
IMAGE_NAME = mickuehl/s2i-oasp

build:
	docker build -t $(IMAGE_NAME) .

.PHONY: build
