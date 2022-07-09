
# utils modules
info() {
	echo "[INFO] $@"
}

fatal() {
	echo "[FATAL] $@"
	exit 1
}

help(){
   	# Display Help
	echo ""
   	echo "Log Management shell script"
	echo "Usage: $0 {gen|rotate|clean}"
	echo "	gen  : generate log into the file"
    echo "  ex: gen [filename] [lines]"
	echo "	rotate : rename file name if number of lines are over the threshold"
    echo "  ex: rotate [file-name] [threshold]"	
	echo "	clean  : remove the logs"
    echo "  ex: clean [directory] [threshold]"
	echo ""
}

check_root() {
	if [ ! "$EUID" -ne 0 ]; then
		fatal "This script must be run as a non-root user"
		exit 1
	fi
}

check_log_dir() {
	if [ ! -d "$PWD/logs" ]; then
		fatal "The 'logs' directory is not present."
		exit 1
	fi
}