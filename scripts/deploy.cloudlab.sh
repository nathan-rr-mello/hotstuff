#!/bin/bash

join() {
	local IFS="$1"
	shift
	echo "$*"
}

num_hosts=9

declare -A hosts

for ((i = 1; i <= num_hosts; i++)); do
	hosts[$i]="node$i"
done

compose_args="--project-name=hotstuff"

docker compose $compose_args -f docker-compose.cloudlab.yml up -d --build controller
docker compose $compose_args exec -T controller /bin/sh -c "ssh-keyscan -H $(join ' ' "${hosts[@]}") >> ~/.ssh/known_hosts" &>/dev/null
docker compose $compose_args exec -T controller /bin/sh -c "hotstuff run --config=./example_config.yml --ssh-config=.ssh/config --exe=/usr/local/hotstuff/hotstuff --cue=./host_config.cue"
exit_code="$?"


exit $exit_code
