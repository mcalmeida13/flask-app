IMAGE_NAME=flask-app
CONTAINER_NAME=flask-app
PORT=5000

.PHONY: build run stop clean logs restart

build:
	docker build -t $(IMAGE_NAME) .

run:
	docker run -d -p $(PORT):$(PORT) --name $(CONTAINER_NAME) $(IMAGE_NAME)

stop:
	docker stop $(CONTAINER_NAME)

logs:
	docker logs -f $(CONTAINER_NAME)

clean: stop
	docker rm $(CONTAINER_NAME)
	docker rmi $(IMAGE_NAME)

restart: stop run
