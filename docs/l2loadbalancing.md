kubelab $ kubectl get no -owide
NAME                       STATUS   ROLES           AGE   VERSION   INTERNAL-IP   EXTERNAL-IP   OS-IMAGE                         KERNEL-VERSION   CONTAINER-RUNTIME
kind-local-control-plane   Ready    control-plane   13m   v1.34.0   172.19.0.2    <none>        Debian GNU/Linux 12 (bookworm)   6.12.42          containerd://2.1.3
kind-local-worker          Ready    <none>          13m   v1.34.0   172.19.0.3    <none>        Debian GNU/Linux 12 (bookworm)   6.12.42          containerd://2.1.3
kind-local-worker2         Ready    <none>          13m   v1.34.0   172.19.0.4    <none>        Debian GNU/Linux 12 (bookworm)   6.12.42          containerd://2.1.3
kind-local-worker3         Ready    <none>          13m   v1.34.0   172.19.0.5    <none>        Debian GNU/Linux 12 (bookworm)   6.12.42          containerd://2.1.3

kubelab $ kubectl get po -n default -owide
NAME                      READY   STATUS    RESTARTS   AGE     IP             NODE                 NOMINATED NODE   READINESS GATES
backend-77d4d5968-5wxlh   1/1     Running   0          8m13s   10.244.3.121   kind-local-worker3   <none>           <none>

kubelab $ kubectl get po -n envoy-gateway-system -owide
NAME                                         READY   STATUS    RESTARTS   AGE     IP             NODE                 NOMINATED NODE   READINESS GATES
envoy-default-eg-e41e7b31-5685844fff-9rpgb   2/2     Running   0          8m23s   10.244.1.209   kind-local-worker2   <none>           <none>
envoy-gateway-665bbf7c49-zkfb4               1/1     Running   0          11m     10.244.1.42    kind-local-worker2   <none>           <none>

kubelab $ kubectl get svc -n envoy-gateway-system
NAME                        TYPE           CLUSTER-IP     EXTERNAL-IP    PORT(S)                                            AGE
envoy-default-eg-e41e7b31   LoadBalancer   10.96.193.72   172.19.255.1   80:30292/TCP                                       8m44s
envoy-gateway               ClusterIP      10.96.51.102   <none>         18000/TCP,18001/TCP,18002/TCP,19001/TCP,9443/TCP   12m


kubelab $ watch -n .1 'curl --silent --header "Host: www.example.com"  http://172.19.255.1'

kubelab $ traceroute 172.19.255.1
traceroute to 172.19.255.1 (172.19.255.1), 30 hops max, 60 byte packets
 1  172.19.0.4 (172.19.0.4)  0.071 ms  0.027 ms  0.024 ms
 2  172.19.0.4 (172.19.0.4)  3076.646 ms !H  3076.573 ms !H  3076.541 ms !H

kubelab $ kubectl drain kind-local-worker2 --ignore-daemonsets --delete-emptydir-data

kubelab $ kubectl get no
NAME                       STATUS                     ROLES           AGE   VERSION
kind-local-control-plane   Ready                      control-plane   17m   v1.34.0
kind-local-worker          Ready                      <none>          17m   v1.34.0
kind-local-worker2         Ready,SchedulingDisabled   <none>          17m   v1.34.0
kind-local-worker3         Ready                      <none>          17m   v1.34.0

kubelab $ traceroute 172.19.255.1
traceroute to 172.19.255.1 (172.19.255.1), 30 hops max, 60 byte packets
 1  172.19.0.5 (172.19.0.5)  0.070 ms  0.019 ms  0.016 ms
 2  172.19.0.5 (172.19.0.5)  3080.823 ms !H  3080.760 ms !H  3080.746 ms !H
