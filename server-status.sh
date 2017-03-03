#!/bin/bash

# ==================================================================
#
#   server-status.sh
#
#   Retrieves current status of the server and sends it to Slack.
#
#   https://github.com/TrueFurby/server-status
#
# ==================================================================

# Slack settings

#SLACK_WEBHOOK="https://hooks.slack.com/services/WEBHOOK_URL"
SLACK_CHANNEL=${SLACK_CHANNEL-"status"}
SLACK_USERNAME=${SLACK_USERNAME-"server-status"}

[ -z $SLACK_WEBHOOK ] && { echo "The SLACK_WEBHOOK is not set!"; exit 1; }

# server status data

HOSTNAME=`hostname`
HOSTIP=`hostname -I | sed -r 's/(\S+) (\S+)/\1, \2/g'`
ROUTES=`ip route list scope global`
UPTIME=`uptime`
DISK=`df -hT /`
MEMORY=`free -h`

# sending the message

statusMessage() {
    echo -e ":black_small_square: *${HOSTNAME}* - ${HOSTIP}\n"
    echo -e "_Uptime:_\n\`\`\`${UPTIME}\`\`\`"
    echo -e "_Memory:_\n\`\`\`${MEMORY}\`\`\`"
    echo -e "_Disk:_\n\`\`\`${DISK}\`\`\`"
    echo -e "_Routes:_\n\`\`\`${ROUTES}\`\`\`"
}

PAYLOAD="{\"channel\": \"#${SLACK_CHANNEL}\", \"username\": \"${SLACK_USERNAME}\", \"text\": \"`statusMessage`\"}"
curl -X POST --data-urlencode "payload=$PAYLOAD" $SLACK_WEBHOOK
