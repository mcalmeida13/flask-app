IMAGE_NAME=flask-app
CONTAINER_NAME=flask-app
PORT=5000
VERSION=$(shell cat VERSION)

.PHONY: build release run run-version stop clean logs restart images

build:
	docker build -t $(IMAGE_NAME):$(VERSION) .

release: build
	docker tag $(IMAGE_NAME):$(VERSION) $(IMAGE_NAME):latest

run:
	docker run -d -p $(PORT):$(PORT) --name $(CONTAINER_NAME) $(IMAGE_NAME):latest

run-version:
	docker run -d -p $(PORT):$(PORT) --name $(CONTAINER_NAME) $(IMAGE_NAME):$(VERSION)

stop:
	docker stop $(CONTAINER_NAME)

logs:
	docker logs -f $(CONTAINER_NAME)

clean: stop
	docker rm $(CONTAINER_NAME)
	docker rmi $(IMAGE_NAME):latest $(IMAGE_NAME):$(VERSION)

restart: stop run

images:
	docker images $(IMAGE_NAME)
