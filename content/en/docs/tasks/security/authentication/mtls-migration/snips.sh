#!/usr/bin/python

####################################################################################################
# WARNING: THIS IS AN AUTO-GENERATED FILE, DO NOT EDIT. PLEASE MODIFY THE ORIGINAL MARKDOWN FILE:
#          /docs/tasks/security/authentication/mtls-migration/index.md
####################################################################################################

snip_line_40() {
kubectl create ns foo
kubectl apply -f <(istioctl kube-inject -f samples/httpbin/httpbin.yaml) -n foo
kubectl apply -f <(istioctl kube-inject -f samples/sleep/sleep.yaml) -n foo
kubectl create ns bar
kubectl apply -f <(istioctl kube-inject -f samples/httpbin/httpbin.yaml) -n bar
kubectl apply -f <(istioctl kube-inject -f samples/sleep/sleep.yaml) -n bar
}

snip_line_51() {
kubectl create ns legacy
kubectl apply -f samples/sleep/sleep.yaml -n legacy
}

snip_line_58() {
for from in "foo" "bar" "legacy"; do for to in "foo" "bar"; do kubectl exec $(kubectl get pod -l app=sleep -n ${from} -o jsonpath={.items..metadata.name}) -c sleep -n ${from} -- curl http://httpbin.${to}:8000/ip -s -o /dev/null -w "sleep.${from} to httpbin.${to}: %{http_code}\n"; done; done
}

! read -r -d '' snip_line_58_out <<ENDSNIP
sleep.foo to httpbin.foo: 200
sleep.foo to httpbin.bar: 200
sleep.bar to httpbin.foo: 200
sleep.bar to httpbin.bar: 200
sleep.legacy to httpbin.foo: 200
sleep.legacy to httpbin.bar: 200
ENDSNIP

snip_line_70() {
kubectl get peerauthentication --all-namespaces
}

! read -r -d '' snip_line_70_out <<ENDSNIP
No resources found
ENDSNIP

snip_line_75() {
kubectl get destinationrule --all-namespaces
}

! read -r -d '' snip_line_75_out <<ENDSNIP
No resources found
ENDSNIP

snip_line_85() {
kubectl apply -n foo -f - <<EOF
apiVersion: "security.istio.io/v1beta1"
kind: "PeerAuthentication"
metadata:
  name: "default"
spec:
  mtls:
    mode: STRICT
EOF
}

snip_line_99() {
for from in "foo" "bar" "legacy"; do for to in "foo" "bar"; do kubectl exec $(kubectl get pod -l app=sleep -n ${from} -o jsonpath={.items..metadata.name}) -c sleep -n ${from} -- curl http://httpbin.${to}:8000/ip -s -o /dev/null -w "sleep.${from} to httpbin.${to}: %{http_code}\n"; done; done
}

! read -r -d '' snip_line_99_out <<ENDSNIP
sleep.foo to httpbin.foo: 200
sleep.foo to httpbin.bar: 200
sleep.bar to httpbin.foo: 200
sleep.bar to httpbin.bar: 200
sleep.legacy to httpbin.foo: 000
command terminated with exit code 56
sleep.legacy to httpbin.bar: 200
ENDSNIP

snip_line_113() {
kubectl exec -nfoo $(kubectl get pod -nfoo -lapp=httpbin -ojsonpath={.items..metadata.name}) -c istio-proxy -it -- sudo tcpdump dst port 80  -A
}

! read -r -d '' snip_line_113_out <<ENDSNIP
tcpdump: verbose output suppressed, use -v or -vv for full protocol decode
listening on eth0, link-type EN10MB (Ethernet), capture size 262144 bytes
ENDSNIP

snip_line_128() {
kubectl apply -n istio-system -f - <<EOF
apiVersion: "security.istio.io/v1beta1"
kind: "PeerAuthentication"
metadata:
  name: "default"
spec:
  mtls:
    mode: STRICT
EOF
}

snip_line_143() {
for from in "foo" "bar" "legacy"; do for to in "foo" "bar"; do kubectl exec $(kubectl get pod -l app=sleep -n ${from} -o jsonpath={.items..metadata.name}) -c sleep -n ${from} -- curl http://httpbin.${to}:8000/ip -s -o /dev/null -w "sleep.${from} to httpbin.${to}: %{http_code}\n"; done; done
}

snip_line_151() {
kubectl delete peerauthentication --all-namespaces --all
}

snip_line_157() {
kubectl delete ns foo bar legacy
}

! read -r -d '' snip_line_157_out <<ENDSNIP
Namespaces foo bar legacy deleted.
ENDSNIP
