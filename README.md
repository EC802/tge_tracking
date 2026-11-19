This Bash script is for tracking packages using Team Global Express.
No API required, gathers info from their webpage. But in Terminal :)

Usage:
./tracking.sh tracking_id

It will store the last used tracking number in "latest_id". You can then just run ./tracking.sh without arguments and it will pull the last tracking number from file.

Requires: Curl, jq, bash.

<img width="751" height="351" alt="tracking 1-censored" src="https://github.com/user-attachments/assets/012db028-baf4-417a-8834-530c57e16b8f" />
