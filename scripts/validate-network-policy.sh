#!/usr/bin/env bash
set -euo pipefail

CTX="kind-stayops-netsec"
NS="netpol-lab"

kubectl --context "$CTX" wait --for=condition=Ready pod/client \
  -n "$NS" --timeout=120s
kubectl --context "$CTX" wait --for=condition=Ready pod/unauthorized \
  -n "$NS" --timeout=120s

echo "=== 0. Remove previous selective allow ==="
kubectl --context "$CTX" delete networkpolicy allow-client-to-web \
  -n "$NS" --ignore-not-found

echo "=== 1. Apply default-deny ingress ==="
kubectl --context "$CTX" apply -f - <<'POLICY'
apiVersion: networking.k8s.io/v1
kind: NetworkPolicy
metadata:
  name: default-deny-web
  namespace: netpol-lab
spec:
  podSelector:
    matchLabels:
      app: web
  policyTypes:
  - Ingress
POLICY

echo "=== 2. Verify default-deny blocks authorized client ==="
if kubectl --context "$CTX" exec -n "$NS" client -- \
  curl -sS --connect-timeout 3 --max-time 5 http://web >/dev/null 2>&1; then
  echo "FAIL: client reached web under default-deny"
  exit 1
else
  echo "PASS: default-deny blocks client"
fi

echo "=== 3. Apply selective allow ==="
kubectl --context "$CTX" apply \
  -f deploy/kubernetes/security/networkpolicy-lab.yaml

echo "=== 4. Verify authorized client is allowed ==="
kubectl --context "$CTX" exec -n "$NS" client -- \
  curl -fsS --connect-timeout 3 --max-time 5 http://web >/dev/null
echo "PASS: authorized client reached web"

echo "=== 5. Verify unauthorized client is blocked ==="
if kubectl --context "$CTX" exec -n "$NS" unauthorized -- \
  curl -sS --connect-timeout 3 --max-time 5 http://web >/dev/null 2>&1; then
  echo "FAIL: unauthorized client reached web"
  exit 1
else
  echo "PASS: unauthorized client blocked"
fi

echo "=== 6. Final policy state ==="
kubectl --context "$CTX" get networkpolicy -n "$NS"

echo "PASS: NetworkPolicy selective ingress validation"
