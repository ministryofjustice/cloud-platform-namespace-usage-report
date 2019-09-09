# Report Generator

A docker image and kubernetes cronjob definition to run the namespace resources
report and post the resulting JSON data to the web application.

## Environment variables

 * API_KEY - API key defined in the usage report web application. Posts must use this value, or the web appication will ignore the posted data
 * WEB_APP_URL - The location to which the JSON data should be posted

## Updating the docker image

Pre-requisites: You need push access to the `ministryofjustice` repo on [docker hub]

To update the docker image:

 * make and commit your changes
 * update the tag value of `IMAGE` in the `makefile`
 * run `make`

This will build the docker image and push it to docker hub, using the updated tag value.

### Update the cronjob.yaml

After updating the docker image, you will need to update the tag value in
the [cronjob.yaml] file.

## Deployment

This docker image is referenced in the [cronjob.yaml], in the namespace usage report deployment

[docker hub]: https://hub.docker.com/u/ministryofjustice
[cronjob.yaml]: https://github.com/ministryofjustice/cloud-platform-environments/blob/master/namespaces/live-1.cloud-platform.service.justice.gov.uk/namespace-usage-report/cronjob.yaml
