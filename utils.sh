
# utils modules
info() {
	echo "[INFO] $1"
}

fatal() {
	echo "[FATAL] $1"
	exit 1
}

help(){
   	# Display Help
	echo ""
   	echo "Log Management shell script"
	echo "Usage: $0 {gen|rotate|clean}"
	echo "	gen  : generate log into the file"
	echo "	rotate : rename file name if number of lines are over the threshold "	
	echo "	clean  : remove the logs"
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