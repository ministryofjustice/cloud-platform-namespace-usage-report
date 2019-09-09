IMAGE := ministryofjustice/namespace-report-generator:1.0

build: .built-image

.built-image: Dockerfile makefile update-data.sh
	docker build -t $(IMAGE) .
	docker push $(IMAGE)
	touch .built-image
