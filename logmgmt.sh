#!/bin/bash

. ./utils.sh

# info "Starting the script"
gen_logs() {

	filename=$1
	number=$2
	info "Generating the logs"
	while [[ ! $number -eq 0 ]]; do
		echo "The quick brown fox jumps over the lazy dog." >>$filename
		number=$((number - 1))
	done
	info "Log written to $filename "
	return 0
}

rotate_logs() {
	info "Rotate Logs"

	filename=$1
	threshold=$2

	date=$(date -u +%s)
	if [ -f "$filename" ]; then
		if test $(wc -l <$filename) -gt $threshold; then
			# rename the file name
			mv $filename "$filename-$date"
			info "The $filename  has been renamed to $filename-$date"
		fi
	else
		echo "$filename doesn't exit"
	fi
}

clean() {
	directory=$1
	threshold=$2
	info "Clean Logs"
	# count number of files in directory

	if [[ $(ls -1rA -c $directory | wc -l) -gt "$threshold" ]]; then
		info "More than $threshold logs found in directory, cleaning up!"
		n=0

		for file_name in $(ls -1rA -c $directory); do
			if [[ $n -eq $threshold ]]; then
				break
			fi
			n=$((n + 1))
			rm "$directory/$file_name"
		done
	fi

}
logmgmt_() {

	# pre checks
	check_root
	check_log_dir

	if test "$#" -gt 0; then

		subcmd=$1
		shift

		case "$subcmd" in
		#case 1
		"gen") gen_logs $@ ;;
			#case 2
		"rotate") rotate_logs $@ ;;
			#case 3
		"clean") clean $@ ;;
			#case 4
		"--help" | "-h") help ;;
		#case 5
		*) echo "Not a valid command, see --help for available commands" ;;

		esac

	else
		fatal "Needs at least one argument, can be gen, rotate, or clean."
	fi
}

logmgmt_ $@
