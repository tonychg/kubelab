DOCKER_IMAGE = localhost:5000/dummy-app:latest

deploy: build
	kubectl apply -f deploy
	kubectl rollout restart -n default deploy/dummy-app

build:
	docker build -t $(DOCKER_IMAGE) .
	docker push $(DOCKER_IMAGE)
