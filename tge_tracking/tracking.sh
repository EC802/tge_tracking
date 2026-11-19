
#!/bin/bash

# Team Global Express tracking script


# First run check if latest_id file exists.
if [ ! -f "latest_id" ]; then
	touch latest_id
fi




# Get stored tracking number
LAST_ID=$(cat latest_id)

if [ -z "$1" ]; then
		if [ -z "${LAST_ID}" ]; then
			echo "No stored tracking ID found."
			echo "Provide one with ./tracking.sh <tracking_number>"
			exit 1
		fi
    echo "Using stored tracking ID: ${LAST_ID}"
    TRACKING=${LAST_ID}
else
	TRACKING="${1}"
	# update stored tracking number
	echo "${1}" > latest_id
fi

URL="https://teamglobalexp.com/myparcel?shipmentID=$TRACKING"


# Download tracking page
echo -n "Getting info"

curl -sSL "$URL" -o /tmp/tge_response.html &
CURL_PID=$!

while kill -0 "$CURL_PID" 2>/dev/null; do
	echo -n "."
	sleep 0.4
done

wait "$CURL_PID"
HTML=$(cat /tmp/tge_response.html)

echo " Done!"



# Extract tracking JSON
JSON=$(echo "$HTML" | sed -n "s/^[[:space:]]*var parsedJsonData = '\(.*\)';$/\1/p" | head -n 1)

if [ -z "$JSON" ]; then
	echo "Unable to retrieve tracking information."
	exit 1
fi


# Display tracking information
echo
echo "Team Global Express"
echo "-------------------"

echo "Consignment: $TRACKING"
echo "Status:      $(echo "$JSON" | jq -r '.notification.finalMessage')"

ETA=$(echo "$JSON" | jq -r '.trackingDetails[-1].estimatedDeliveryDate // empty')

if [ -n "$ETA" ]; then
	ETA=$(date -d "$ETA" '+%d/%m/%Y %H:%M' 2>/dev/null)
	echo "ETA:         $ETA"
fi

echo
echo "Tracking History"
echo "----------------"

echo "$JSON" | jq -r '
.trackingDetails[] |
[
  .status,
  (.location.physicalAddress.suburb // "Unknown"),
  (.location.physicalAddress.stateName // ""),
  (.estimatedDeliveryDate // "")
] |
"\(.[0]) - \(.[1]), \(.[2]) (\(.[3] | if . == "" then "No date available" else sub("\\.[0-9]+"; "") | sub("\\+.*"; "") | sub("T"; " ") end))"
'
echo



