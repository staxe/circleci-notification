#!/bin/bash

SLACK_API_URL=

checkfail_env_var() {
  if [ -z "$1" ]; then
    echo "one of the environment variables is missing"
    exit 1
  fi
}

printUsage() {
    echo -e "\nUsage: ./script.sh --slack-url https://some-url-with-key \n"
}

#---- Retrieve and process all arguments ----

while [ $# -gt 0 ]
do
  case $1 in
          --slack-url)
                  shift
                  SLACK_API_URL=$1;;
          *)
                 echo "Unknown parameter: " $1
                 printUsage
                 exit 1;;
  esac
  shift
done

# these envs are injected by default from CircleCI biulds
checkfail_env_var $CIRCLE_PROJECT_REPONAME
checkfail_env_var $CIRCLE_BUILD_NUM
checkfail_env_var $CIRCLE_USERNAME
checkfail_env_var $CIRCLE_BRANCH
checkfail_env_var $CIRCLE_SHA1

# env comes from CircleCI Contexts
checkfail_env_var $SLACK_API_URL

curl -X POST -H 'Content-type: application/json' \
  --data "{ \"text\": \"*Build $CIRCLE_PROJECT_REPONAME:* #$CIRCLE_BUILD_NUM branch: \`$CIRCLE_BRANCH\` commit: ${CIRCLE_SHA1:0:7} user: \`$CIRCLE_USERNAME\`: _Deployed_ correctly.\", \"username\": \"Yambo\", \"mrkdwn\": true }" $SLACK_API_URL