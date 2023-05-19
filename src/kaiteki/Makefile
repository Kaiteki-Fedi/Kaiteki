# Define variables
FLUTTER := flutter
DART := $(FLUTTER) pub run dart

BUILD_NUMBER := $(shell date +%s)

# Define build args
BUILD_MODE := $(if $(DEBUG),--debug)$(if $(RELEASE),--release)$(if $(PROFILE),--profile)
FLAVOR := $(if $(SIGNED),signed,unsigned)$(if $(STORE),store,foss) 

ifneq ($(WEEKLY_EPOCH),)
	BUILD_NAME := $(shell date -d "@$(WEEKLY_EPOCH)" +%Y-%U)
	BUILD_SEMVER := $(shell date -d "@$(WEEKLY_EPOCH)" +%Y.%U.0)
endif

BUILD_ARGS := $(BUILD_MODE) \
	$(if $(BUILD_SEMVER),--build-name=$(BUILD_SEMVER)) \
	$(if $(BUILD_NUMBER),--build-number=$(BUILD_NUMBER) --dart-define=VERSION_CODE=$(BUILD_NUMBER)) \

ifneq ($(WEEKLY_EPOCH),)
	BUILD_ARGS += "--dart-define=VERSION_NAME=Weekly $(BUILD_NAME)"
endif

$(info build number: $(BUILD_NUMBER))

# Define targets and their dependencies
all: analyze

build-android:
ifdef $(STORE)
	@$(FLUTTER) build appbundle $(BUILD_ARGS) $(if $(FLAVOR),--flavor $(FLAVOR),) $(if $(SPLIT_PER_ABI),--split-per-abi,)
else
	@$(FLUTTER) build apk $(BUILD_ARGS) $(if $(FLAVOR),--flavor $(FLAVOR),) $(if $(SPLIT_PER_ABI),--split-per-abi,)
endif

build-web:
	@$(FLUTTER) build web $(BUILD_ARGS) --source-maps

build-windows:
	@$(FLUTTER) build windows $(BUILD_ARGS)

build-linux:
	@$(FLUTTER) build linux $(BUILD_ARGS)

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
.PHONY: all analyze clean run test build-android build-web build-windows build-linux
