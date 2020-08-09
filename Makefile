
IMAGE="follyengine/redfolly:latest"

# persist data with -v node_red_user_data:/data
# 		-v /tmp/data:/data/ \


run: build
	docker rm -f mynodered | true
	docker run -it \
		-p 1880:1880 \
		-e PORT=1880 \
		--name mynodered \
		-v $(CWD):/data/ \
		-e FLOWS=/data/flow.json \
		-e NODE_RED_ENABLE_PROJECTS=true \
		--net=host \
		$(IMAGE)

build:
	docker build -t $(IMAGE) .

exec:
	docker exec -it mynodered bash