#!/bin/bash
eval $(eksops creds -p dev)
count=$1
curr=0
while [ $curr -lt  $count ]
do
    echo "Expect blue"
	echo "Scaling blue to 30"
	kubectl scale --replicas=30 rs/blue -n howto-k8s-cloudmap

    echo "Scaling red to 0"
    kubectl scale --replicas=0 rs/red -n howto-k8s-cloudmap
    sleep 180

    # update vnode label selector
    kubectl apply -f vnode-red.yaml

    echo "Expect red"
    
    echo "Scaling blue to 0"
    kubectl scale --replicas=0 rs/blue -n howto-k8s-cloudmap

    
    echo "Scaling red to 30"
    kubectl scale --replicas=30 rs/red -n howto-k8s-cloudmap
    sleep 180

    # update vnode label to blue
    kubectl apply -f vnode-blue.yaml
    
    curr=$(( $curr + 1))
done
