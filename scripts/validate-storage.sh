#!/usr/bin/env bash
set -Eeuo pipefail

DEV=stayops-dev
STG=stayops-staging
CLAIM=stayops-data
TESTPOD=storage-check
MARKER="stayops-persistence-$(date +%s)"

pass() { echo "PASS: $*"; }
fail() { echo "FAIL: $*" >&2; exit 1; }

echo "=========================================="
echo " StayOps Persistent Storage Validation"
echo "=========================================="

echo
echo "[1/8] Check Kubernetes and StorageClass"
kubectl cluster-info
kubectl get storageclass
kubectl get nodes

SC=$(kubectl get storageclass -o jsonpath='{.items[0].metadata.name}')
[[ -n "$SC" ]] || fail "No StorageClass found"
echo "Using StorageClass: $SC"

echo
echo "[2/8] Create PVCs in dev and staging"
for NS in "$DEV" "$STG"; do
  kubectl apply -n "$NS" -f - <<EOF
apiVersion: v1
kind: PersistentVolumeClaim
metadata:
  name: $CLAIM
spec:
  accessModes:
    - ReadWriteOnce
  storageClassName: $SC
  resources:
    requests:
      storage: 1Gi
EOF
done

echo
echo "[3/8] Wait for PVC binding"
for NS in "$DEV" "$STG"; do
  kubectl wait -n "$NS" --for=jsonpath='{.status.phase}'=Bound pvc/$CLAIM --timeout=180s
  kubectl get pvc "$CLAIM" -n "$NS"
done
pass "PVCs bound"

echo
echo "[4/8] Create storage test pods"
for NS in "$DEV" "$STG"; do
  kubectl delete pod "$TESTPOD" -n "$NS" --ignore-not-found --wait=true
  kubectl apply -n "$NS" -f - <<EOF
apiVersion: v1
kind: Pod
metadata:
  name: $TESTPOD
spec:
  containers:
    - name: storage-test
      image: busybox:1.36
      command: ["sh", "-c", "sleep 36000"]
      volumeMounts:
        - name: data
          mountPath: /data
  volumes:
    - name: data
      persistentVolumeClaim:
        claimName: $CLAIM
EOF
  kubectl wait -n "$NS" --for=condition=Ready pod/$TESTPOD --timeout=180s
done
pass "Storage test pods ready"

echo
echo "[5/8] Write unique persistence marker"
for NS in "$DEV" "$STG"; do
  kubectl exec -n "$NS" "$TESTPOD" -- sh -c "echo '$MARKER-$NS' > /data/persistence-check.txt"
  kubectl exec -n "$NS" "$TESTPOD" -- cat /data/persistence-check.txt
done

echo
echo "[6/8] Delete and recreate test pods"
for NS in "$DEV" "$STG"; do
  kubectl delete pod "$TESTPOD" -n "$NS" --wait=true
  kubectl apply -n "$NS" -f - <<EOF
apiVersion: v1
kind: Pod
metadata:
  name: $TESTPOD
spec:
  containers:
    - name: storage-test
      image: busybox:1.36
      command: ["sh", "-c", "sleep 36000"]
      volumeMounts:
        - name: data
          mountPath: /data
  volumes:
    - name: data
      persistentVolumeClaim:
        claimName: $CLAIM
EOF
  kubectl wait -n "$NS" --for=condition=Ready pod/$TESTPOD --timeout=180s
done

echo
echo "[7/8] Verify persistence after pod recreation"
for NS in "$DEV" "$STG"; do
  ACTUAL=$(kubectl exec -n "$NS" "$TESTPOD" -- cat /data/persistence-check.txt)
  EXPECTED="$MARKER-$NS"
  [[ "$ACTUAL" == "$EXPECTED" ]] || fail "$NS marker mismatch"
  echo "$NS: $ACTUAL"
done
pass "Data survived pod deletion/recreation"

echo
echo "[8/8] Verify NGINX Services remain healthy"
for NS in "$DEV" "$STG"; do
  kubectl rollout status deployment/nginx -n "$NS" --timeout=180s
  kubectl run "storage-http-$NS" -n "$NS" --rm -i --restart=Never \
    --image=curlimages/curl -- \
    curl -fsS -o /dev/null -w "HTTP %{http_code}\n" \
    http://nginx-service."$NS".svc.cluster.local
done

echo
echo "===== PVC STATUS ====="
kubectl get pvc -A

echo
echo "=========================================="
echo " PASS: Storage provisioning and persistence"
echo "=========================================="
echo "Claims retained for future labs: $CLAIM"
echo "Test pods retained temporarily: $TESTPOD"
