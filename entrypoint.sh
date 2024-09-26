#!/bin/bash
set -e

INPUT_PREFIX="${INPUT_PREFIX:-backup}"

function main() {
  sanitize "${INPUT_ACCESS_KEY_ID}" "access_key_id"
  sanitize "${INPUT_SECRET_ACCESS_KEY}" "secret_access_key"
  sanitize "${INPUT_REGION}" "region"
  sanitize "${INPUT_CLUSTER_NAME}" "cluster_name"
  sanitize "${INPUT_SLACK_WEBHOOK}" "slack_webhook"

  configure
  take_snapshot
  post_to_slack
}

function sanitize() {
  if [ -z "${1}" ]; then
    echo >&2 "Unable to find the ${2}. Did you set with.${2}?"
    exit 1
  fi
}

function configure() {
  export AWS_ACCESS_KEY_ID=$INPUT_ACCESS_KEY_ID
  export AWS_SECRET_ACCESS_KEY=$INPUT_SECRET_ACCESS_KEY
  export AWS_DEFAULT_REGION=$INPUT_REGION
  export SLACK_WEBHOOK=$INPUT_SLACK_WEBHOOK
}

function take_snapshot() {
  echo "== Taking SNAPSHOT OF ${INPUT_CLUSTER_NAME}"
  if [ "${INPUT_CLUSTER_NAME}" == "" ]; then
    echo "Unable to find the cluster_name. Did you set with cluster_name?"
    exit 1
  fi

  aws rds create-db-cluster-snapshot --db-cluster-identifier ${INPUT_CLUSTER_NAME} --db-cluster-snapshot-identifier ${INPUT_PREFIX}-$(date +%Y%m%d%H%M%S) --region ${INPUT_REGION}

  echo "== FINISHED SNAPSHOT of ${INPUT_CLUSTER_NAME}"
}

function post_to_slak() {
  echo "== Posting to Slack"
  curl -X POST \
       -H 'Content-Type: application/json' \
       -d '{"blocks":[{"type":"rich_text","elements":[{"type":"rich_text_section","elements":[{"type":"emoji","name":"database"},{"type":"text","text":" Database backup done!","style":{"bold":true}}]}]}]}' \
        ${INPUT_SLACK_WEBHOOK}
  echo "== Posted to Slack"
}

main
