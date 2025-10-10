#!/bin/bash

# Usage: ./deploy.cloudlab.sh <config_file> <cue_file>
if [ "$#" -ne 2 ]; then
    echo "Usage: $0 <config_file> <cue_file>"
    exit 1
fi

CONFIG_FILE="$1"
CUE_FILE="$2"

join() {
	local IFS="$1"
	shift
	echo "$*"
}

num_hosts=13

declare -A hosts

for ((i = 1; i <= num_hosts; i++)); do
	hosts[$i]="node$i"
done

compose_args="--project-name=hotstuff"

docker compose $compose_args -f docker-compose.cloudlab.yml up -d --build controller
docker compose $compose_args exec -T controller /bin/sh -c "ssh-keyscan -H $(join ' ' "${hosts[@]}") >> ~/.ssh/known_hosts" &>/dev/null
docker compose $compose_args exec -T controller /bin/sh -c "hotstuff run --config=$CONFIG_FILE --ssh-config=.ssh/config --exe=/usr/local/hotstuff/hotstuff --cue=$CUE_FILE"
exit_code="$?"


exit $exit_code
