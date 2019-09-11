IMAGE := ministryofjustice/cloud-platform-namespace-usage-report:1.2

build: .built-image

.built-image: app.rb Gemfile* makefile views/*
	docker build -t $(IMAGE) .
	docker push $(IMAGE)
	touch .built-image

run: build
	docker run --rm \
		-p 4567:4567 \
		-e API_KEY=soopersekrit \
		-it $(IMAGE)
