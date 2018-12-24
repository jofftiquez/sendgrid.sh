#!/bin/sh
SENDGRID_API_KEY=""
TEMPLATE_ID=""
FROM_EMAIL=""
FROM_NAME=""
RECIPIENT_PATH=""

echo ========================
echo =Welcome to sendgrid.sh=
echo ========================

# API Key
echo Sendgrid API Key:
read SENDGRID_API_KEY

# Template id
echo Sendgrid template id:
read TEMPLATE_ID

# From email
echo From email:
read FROM_EMAIL

# From name
echo From name:
read FROM_NAME

# Subject
echo Subject:
read SUBJECT

# Template
echo Template:
read TEMPLATE_PATH

# Emails
echo Recipient path:
read RECIPIENT_PATH

send() {
  EMAIL_TO=$1
  REQUEST_DATA='{
    "personalizations": [
      { 
        "to": [
          { 
            "email": "'"$EMAIL_TO"'" 
          }
        ],
        "dynamic_template_data": {
          "name": "'"$2"'"
        }
      }
    ],
    "from": {
      "email": "'"$FROM_EMAIL"'",
      "name": "'"$FROM_NAME"'" 
    },
    "template_id": "'"$TEMPLATE_ID"'"
  }'
  # SEND
  curl -X "POST" "https://api.sendgrid.com/v3/mail/send" \
    -H "Authorization: Bearer $SENDGRID_API_KEY" \
    -H "Content-Type: application/json" \
    -d "$REQUEST_DATA"
  # DONE
  echo "Sent to $EMAIL_TO!"
}

jq -c '.[]' $RECIPIENT_PATH | while read i; do
  NAME=$(jq --raw-output '.name' <<< ${i})
  EMAIL=$(jq --raw-output '.email' <<< ${i})
  send $EMAIL $NAME
done