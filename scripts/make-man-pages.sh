#!/bin/bash
SOURCE_PATH=$1
PROGRAMS=$2

if [[ -z "$1" ]]; then
  echo "You must supply a relative path to the ION open source code."
  exit
fi

POD2MAN=pod2man
POD_DIR="${SOURCE_PATH}/man"
mkdir -p "$POD_DIR"

# Split PROGRAMS into an array
IFS=' ' read -r -a prog_array <<< "$PROGRAMS"

for prog in "${prog_array[@]}"; do
	full_path="${POD_DIR}/$prog.pod"
	if [[ -f "$full_path" ]]; then
		if $POD2MAN "$full_path" | gzip -c > "./man/${prog}.1.gz"; then
		echo "Generated man page for $prog"
		else
		echo "ERROR: Failed to generate man page for $prog"
		fi
	else
		echo "Documentation source for $prog not found at $full_path"
	fi
done
