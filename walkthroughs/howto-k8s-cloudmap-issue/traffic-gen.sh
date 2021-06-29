#!/bin/bash
eval $(eksops creds -p dev)
count=1
GW_ENDPOINT=$1
limit=$2
while [ $count -lt $limit ]
do
    label=$(kubectl label --list virtualnode/colorapp -n howto-k8s-cloudmap)
    echo $label
	echo "Sending Request"
    out=$(curl --silent ${GW_ENDPOINT}/color)
    echo $out
    if [[ $label == "node=blue" ]]
    then    
        if [[ $out != "blue" ]]; then
            echo "req sent to incorrect backend"
        fi
    else
       if [[ $out != "red" ]]; then
            echo "req sent to incorrect backend"
       fi
    fi    	  
    sleep 1 
    count=$(( $count + 1))
done
