TARGET = node_manager
VERSION = v1
DOCKER_NAME = dsrv/api_builder

.PHONY: help
.PHONY: all python json
.PHONY: clean
define banner
	@echo "========================================================================"
	@echo " $(1)"
	@echo "========================================================================"
endef

define set_build_env
	git submodule init
	git submodule update
	docker build -t ${DOCKER_NAME} .
endef

define build
	$(call set_build_env)
	$(call banner, "Start the build protobuf")
	@for t in $(TARGET); do \
		docker run -i --rm -v ${PWD}:/opt ${DOCKER_NAME} python3 build.py $$t -c$(1) ; \
	done
endef

help:
	@echo "Make Options:"
	@echo " go                  - Generate all : ${TARGET}"
	@echo " clean               - Clean up dist directory"

go:
	mkdir dist
	protoc -I=. \
	    --go_out dist/ --go_opt paths=source_relative \
	    --go-grpc_out dist/ --go-grpc_opt paths=source_relative \
		proto/**/**/**/*.proto

clean:
	$(call banner, "Clean up dist directory")
	sudo rm -rf dist
	sudo rm -rf artifact
