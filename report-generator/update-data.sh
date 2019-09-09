#!/bin/sh -x

set -euo pipefail

DATA_FILE=namespace-report.json

main() {
  install_software
  run_report
  post_data
}

install_software() {
  # Get the latest version of the namespace-reporter.rb script
  wget https://raw.githubusercontent.com/ministryofjustice/cloud-platform-environments/master/bin/namespace-reporter.rb
  chmod +x namespace-reporter.rb
}

run_report() {
  ./namespace-reporter.rb -n '.*' -o json > ${DATA_FILE}
}

post_data() {
  curl -H "X-API-KEY: ${API_KEY}" -d "$(cat ${DATA_FILE})" ${WEB_APP_URL}
}

main
