# Define variables
FLUTTER := flutter
DART := $(FLUTTER) pub run dart

BUILD_NUMBER=$(date +%s)

# Define build args
BUILD_MODE := $(if $(DEBUG),--debug)$(if $(RELEASE),--release)$(if $(PROFILE),--profile)
FLAVOR := $(if $(SIGNED),signed,unsigned)$(if $(STORE),store,foss) 
BUILD_ARGS := $(BUILD_MODE)

ifneq ($(WEEKLY_EPOCH),)
	BUILD_NAME := $(shell date -d "@$(WEEKLY_EPOCH)" +%Y-%U)
	BUILD_SEMVER := $(shell date -d "@$(WEEKLY_EPOCH)" +%Y.%U.0)
	BUILD_ARGS += "--build-name=$(BUILD_SEMVER)" \
		"--dart-define=VERSION_NAME=Weekly $(BUILD_NAME)" \
		"--build-number=$(WEEKLY_EPOCH)" \
		"--dart-define=VERSION_CODE=$(WEEKLY_EPOCH)"
endif

# Define targets and their dependencies
all: analyze

build-android-apk:
	@$(FLUTTER) build apk $(BUILD_ARGS) $(if $(FLAVOR),--flavor $(FLAVOR),)

build-web:
	@$(FLUTTER) build web $(BUILD_ARGS) --source-maps $(if $(SPLIT_PER_ABI),--split-per-abi,)

build-windows:
	@$(FLUTTER) build windows $(BUILD_ARGS)

build-linux:
	$(FLUTTER) build linux $(BUILD_ARGS)

analyze:
	@$(FLUTTER) analyze --no-pub --no-fatal-infos --no-congratulate --no-preamble

pubspec.lock: pubspec.yaml
	@$(DART) pub get

clean:
	@$(FLUTTER) clean
	@rm -rf pubspec.lock

run: analyze
	@$(FLUTTER) run

test:
	@$(FLUTTER) test

# Define phony targets
.PHONY: all analyze clean run test build-android-apk build-web build-windows build-linux
