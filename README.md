# copy-status
Bash based file copy (cp) monitor

Usage:
./copystatus.sh [-h]
	-h Human readable unit conversion
Notes:
Currently fails when source path contains spaces due to space-delimited command parsing.
Also may fail momentarily if the CP process goes to sleep, simply rerun
