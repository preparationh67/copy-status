# copy-status
Bash based file copy (cp) monitor

Usage:
./copystatus.sh [-h] [-t int]
	-t Refresh time in seconds
	-h Human readable unit conversion
Notes:
Currently fails when source path contains spaces due to space-delimited command parsing.
Also may fail momentarily if the CP process goes to sleep, simply rerun.
It retries six (6) times over 6 seconds to find the PID of cp
