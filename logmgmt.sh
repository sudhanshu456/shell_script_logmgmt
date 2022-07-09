#!/bin/bash

. ./utils.sh

# info "Starting the script"
gen_logs() {
	info "Generating the logs"
	for (( i=1; i<=$2; i++ ));do
		echo "The quick brown fox jumps over the lazy dog." >>$1
	done
	info "Log written to $1 "
}

rotate_logs() {

	info "Rotate Logs"

	if [ -f "$1" ]; then
		if test $(wc -l <$1) -gt $2; then

			mv $1 "$1-$(date -u +%s)"

			info "The $1  has been renamed to $1-$(date -u +%s)"
		fi
	else
		echo "$1 doesn't exit"
	fi
}

clean() {
	
	directory=$1
	threshold=$2
	
	info "Checking Logs for cleanup"

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
