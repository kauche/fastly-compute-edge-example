OS   := $(shell uname | awk '{print tolower($$0)}')
ARCH := $(shell case $$(uname -m) in (x86_64) echo amd64 ;; (aarch64) echo arm64 ;; (*) echo $$(uname -m) ;; esac)

BIN_DIR := $(shell pwd)/bin

FASTLY_CLI_VERSION := 3.0.0
VICEROY_VERSION    := 0.2.14

FASTLY_CLI := $(abspath $(BIN_DIR)/fastly)-$(FASTLY_CLI_VERSION)
VICEROY    := $(abspath $(BIN_DIR)/viceroy)-$(VICEROY_VERSION)

fastly: $(FASTLY_CLI)
$(FASTLY_CLI):
	@curl -sSL "https://github.com/fastly/cli/releases/download/v$(FASTLY_CLI_VERSION)/fastly_v$(FASTLY_CLI_VERSION)_$(OS)-$(ARCH).tar.gz" | \
		tar -C $(BIN_DIR) -xzv fastly
	@cp $(BIN_DIR)/fastly $(FASTLY_CLI)

viceroy: $(VICEROY)
$(VICEROY):
	@curl -sSL "https://github.com/fastly/Viceroy/releases/download/v$(VICEROY_VERSION)/viceroy_v$(VICEROY_VERSION)_$(OS)-$(ARCH).tar.gz" | \
		tar -C $(BIN_DIR) -xzv viceroy
	@cp $(BIN_DIR)/viceroy $(VICEROY)

.PHONY: build
build: $(FASTLY_CLI)
	@docker compose run --rm fastly ../bin/fastly compute build

.PHONY: test
test: build $(FASTLY_CLI) $(VICEROY)
	@docker compose stop
	@docker compose up --detach
	@docker run --rm --network fastly-compute-edge-example_default jwilder/dockerize:0.6.1 dockerize -timeout=60s -wait=tcp://fastly:3000
	@docker compose run --rm fastly bash -c "cd ../test/e2e && cargo test"
