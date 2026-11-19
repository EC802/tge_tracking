This Bash script is for tracking packages using Team Global Express.
No API required, gathers info from their webpage. But in Terminal :)

Usage:
./tracking.sh tracking_id

It will store the last used tracking number in "latest_id". You can then just run ./tracking.sh without arguments and it will pull the last tracking number from file.

Requires: Curl, jq, bash.

