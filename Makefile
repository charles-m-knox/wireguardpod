IMAGE_TAG=ghcr.io/charles-m-knox/wireguardpod:latest

build-image:
	podman build -t $(IMAGE_TAG) -f containerfile .

push-image:
	podman push $(IMAGE_TAG)
