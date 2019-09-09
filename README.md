# Cloud Platform Namespace Usage Report

Use the JSON output of the [namespace reporter] to create charts (using [Google charts]) showing namespace resource usage.

The application is a sinatra app. running in a container.

## Updating the JSON data

Note: This is handled via a [cron job][cronjob.yaml], so you shouldn't need to do this manually.

To provision data to the app, make an HTTP post, like this:

    curl -d "$(cat namespace-report.json)" http://localhost:4567/update-data

Once data has been posted, visit the app at `http://localhost:4567`

## Security

The app. will only accept posted JSON data when the HTTP POST supplies the correct API key.

'correct' means the value of the 'X-API-KEY' header in the HTTP POST must match the value of the 'API_KEY' environment variable that was in scope when the app. was started.

i.e. the curl example above would be this, to send 'foobar' as the API key.

    curl -H "X-API-KEY: foobar" -d "$(cat namespace-report.json)" http://localhost:4567/update-data

If the supplied API key matches the expected value, the locally stored JSON data file will be overwritten with the request body supplied in the POST.

If the API key doesn't match, the app. will return a 403 error.

## Updating the docker image

Pre-requisites: You need push access to the `ministryofjustice` repo on [docker hub]

To update the docker image:

 * make and commit your changes
 * update the tag value of `IMAGE` in the `makefile`
 * run `make`

This will build the docker image and push it to docker hub, using the updated tag value.

### Update the deployment

After updating the docker image, you will need to update the tag value in
the [deployment.yaml] file.

[namespace reporter]: https://github.com/ministryofjustice/cloud-platform-environments/blob/master/bin/namespace-reporter.rb
[Google charts]: https://developers.google.com/chart/
[cronjob.yaml]: https://github.com/ministryofjustice/cloud-platform-environments/blob/master/namespaces/live-1.cloud-platform.service.justice.gov.uk/namespace-usage-report/cronjob.yaml
[docker hub]: https://hub.docker.com/u/ministryofjustice
[deployment.yaml]: https://github.com/ministryofjustice/cloud-platform-environments/blob/master/namespaces/live-1.cloud-platform.service.justice.gov.uk/namespace-usage-report/deployment.yaml
