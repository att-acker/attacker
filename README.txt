attacker

this repository contains a script with launches
a docker container on random *still working*
russian website. To run it:

	sudo ./attacker.sh

You can add new websites by editing the targets.txt file.
The following parameters can be tuned in the attacker.sh script.

	PING_COUNT	- number of ping to check for site availability.
	PING_TIMEOUT	- the maximum timeout time to check if site is available.
	ATTACK_CONNECTIONS	- how many connections to make when attacking
	ATTACK_DURATION		- a durration of an individual attack
