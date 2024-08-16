# Project Definitions
## General Settings
PROJECT_NAME := Terminal FPS
PROJECT_VERSION := 0.0.0
PROJECT_DESCRIPTION := A simple first-person shooter game that runs in your terminal.

## Project Directories
SOURCE_DIR := src
LIB_DIR := lib
ASSETS_DIR := assets
TEST_DIR := tests
BUILD_DIR := build
DIST_DIR := dist

## Target Settings
TARGET_NAME_BASE := terminal-fps
TARGET_NAME_DEBUG := $(TARGET_NAME_BASE)-debug
TARGET_NAME_RELEASE := $(TARGET_NAME_BASE)
TARGET_NAME_TESTS := $(TARGET_NAME_BASE)-tests
TARGET_NAME_ARCHIVE_BASE := $(TARGET_NAME_BASE)-$(PROJECT_VERSION)
TARGET_NAME_ARCHIVE_DEBUG := $(TARGET_NAME_ARCHIVE_BASE)-debug.zip
TARGET_NAME_ARCHIVE_RELEASE := $(TARGET_NAME_ARCHIVE_BASE)-release.zip

## Compiler Settings
ODIN_COMPILER ?= odin
ARCHIVER ?= 7zz
ODIN_BUILD_FLAGS ?= -build-mode:exe
ODIN_BUILD_FLAGS_DEBUG ?= -o:none -debug
ODIN_BUILD_FLAGS_RELEASE ?= -o:minimal
ODIN_TEST_FLAGS ?= -o:none -debug
ODIN_CHECK_FLAGS_SOURCE ?= -strict-style -vet-unused -vet-shadowing				\
						   -vet-using-stmt -vet-using-param -vet-style 			\
						   -vet-semicolon -disallow-do -thread-count:4
ODIN_CHECK_FLAGS_TESTS ?= -strict-style -vet-unused -vet-shadowing				\
						  -vet-using-stmt -vet-using-param -vet-style			\
						  -vet-semicolon -disallow-do -thread-count:4			\
						  -no-entry-point
ODIN_BUILD_COLLECTIONS ?=
ODIN_TEST_COLLECTIONS ?= src=$(SOURCE_DIR)										\
						 test_utils=$(TEST_DIR)/utils
ODIN_DEFINES ?= -define:PROJECT_NAME="$(PROJECT_NAME)"							\
				-define:PROJECT_VERSION="$(PROJECT_VERSION)"					\
				-define:PROJECT_DESCRIPTION="$(PROJECT_DESCRIPTION)"

#!! Do not edit below this line unless you know what you're doing !!

# Windows-specific adjustments

ifeq ($(OS),Windows_NT)
	#-- Add `.exe` to various file names
	ODIN_COMPILER := $(addsuffix .exe, $(ODIN_COMPILER))
	TARGET_NAME_DEBUG := $(addsuffix .exe, $(TARGET_NAME_DEBUG))
	TARGET_NAME_RELEASE := $(addsuffix .exe, $(TARGET_NAME_RELEASE))
	TARGET_NAME_TESTS := $(addsuffix .exe, $(TARGET_NAME_TESTS))
	#-- 7-zip is just called 7z on Windows where as it's 7zz on other systems
	ARCHIVER := 7z.exe
endif

#-- Sanitize all directories so they don't interfere with alias targets
SOURCE_DIR := $(abspath $(SOURCE_DIR))
LIB_DIR := $(abspath $(LIB_DIR))
ASSETS_DIR := $(abspath $(ASSETS_DIR))
TEST_DIR := $(abspath $(TEST_DIR))
BUILD_DIR := $(abspath $(BUILD_DIR))
DIST_DIR := $(abspath $(DIST_DIR))

#-- Determine Odin source files
SOURCE_FILES := $(wildcard $(SOURCE_DIR)/*.odin)								\
				$(wildcard $(SOURCE_DIR)/**/*.odin)

#-- Determine assets files
ASSETS_FILES := $(wildcard $(ASSETS_DIR)/*)									\
				$(wildcard $(ASSETS_DIR)/**/*)

#-- Main build goals

$(BUILD_DIR)/$(TARGET_NAME_DEBUG): $(SOURCE_FILES) | $(BUILD_DIR)
	@echo "Building $(TARGET_NAME_DEBUG)..."
	$(ODIN_COMPILER) build $(SOURCE_DIR) -out:$(BUILD_DIR)/$(TARGET_NAME_DEBUG)	\
		$(ODIN_BUILD_FLAGS) $(ODIN_BUILD_FLAGS_DEBUG) $(ODIN_BUILD_COLLECTIONS) \
		$(ODIN_DEFINES)
	@echo "Built $(TARGET_NAME_DEBUG)"

$(BUILD_DIR)/$(TARGET_NAME_RELEASE): $(SOURCE_FILES) | $(BUILD_DIR)
	@echo "Building $(TARGET_NAME_RELEASE)..."
	$(ODIN_COMPILER) build $(SOURCE_DIR)										\
		-out:$(BUILD_DIR)/$(TARGET_NAME_RELEASE)								\
		$(ODIN_BUILD_FLAGS) $(ODIN_BUILD_FLAGS_RELEASE)							\
		$(ODIN_BUILD_COLLECTIONS) $(ODIN_DEFINES)
	@echo "Built $(TARGET_NAME_RELEASE)"

#-- Distribution goals

$(DIST_DIR)/debug/$(TARGET_NAME_DEBUG): $(BUILD_DIR)/$(TARGET_NAME_DEBUG) $(ASSETS_FILES) | $(DIST_DIR)/debug/
	@echo "Generating debug distribution..."
	@cp $(BUILD_DIR)/$(TARGET_NAME_DEBUG) $(DIST_DIR)/debug/
	# NOTE: Commented out until we have assets to copy
	# @cp -r $(ASSETS_DIR) $(DIST_DIR)/debug/
	@echo "Generated debug distribution"

$(DIST_DIR)/release/$(TARGET_NAME_RELEASE): $(BUILD_DIR)/$(TARGET_NAME_RELEASE) $(ASSETS_FILES) | $(DIST_DIR)/release/
	@echo "Generating release distribution..."
	@cp $(BUILD_DIR)/$(TARGET_NAME_RELEASE) $(DIST_DIR)/release/
	# NOTE: Commented out until we have assets to copy
	# @cp -r $(ASSETS_DIR) $(DIST_DIR)/release/
	@echo "Generated release distribution"

#-- Archive goals

$(TARGET_NAME_ARCHIVE_DEBUG): $(DIST_DIR)/debug/$(TARGET_NAME_DEBUG) | $(DIST_DIR)/debug/
	@echo "Creating $(TARGET_NAME_ARCHIVE_DEBUG)..."
	$(ARCHIVER) a -mx=9 $(TARGET_NAME_ARCHIVE_DEBUG) "$(DIST_DIR)/debug/*"
	@echo "Created $(TARGET_NAME_ARCHIVE_DEBUG)"

$(TARGET_NAME_ARCHIVE_RELEASE): $(DIST_DIR)/release/$(TARGET_NAME_RELEASE) | $(DIST_DIR)/release/
	@echo "Creating $(TARGET_NAME_ARCHIVE_RELEASE)..."
	$(ARCHIVER) a -mx=9 $(TARGET_NAME_ARCHIVE_RELEASE) "$(DIST_DIR)/release/*"
	@echo "Created $(TARGET_NAME_ARCHIVE_RELEASE)"

#-- Directory creation goals

$(BUILD_DIR):
	@echo "Creating '$(BUILD_DIR)' directory..."
	@mkdir -p $(BUILD_DIR)

$(DIST_DIR)/debug/:
	@echo "Creating '$(DIST_DIR)/debug/' directory..."
	@mkdir -p $(DIST_DIR)/debug/

$(DIST_DIR)/release/:
	@echo "Creating '$(DIST_DIR)/release/' directory..."
	@mkdir -p $(DIST_DIR)/release/

#-- Build goals

.PHONY: pre-build-release
pre-build-release:
	@echo "Building release goal..."

.PHONY: build-release
build-release: pre-build-release $(BUILD_DIR)/$(TARGET_NAME_RELEASE)
	@echo "Built release goal"

.PHONY: pre-build-debug
pre-build-debug:
	@echo "Building debug goal..."

.PHONY: build-debug
build-debug: pre-build-debug $(BUILD_DIR)/$(TARGET_NAME_DEBUG)
	@echo "Built debug goal"

.PHONY: pre-build
pre-build:
	@echo "Building default goal..."

.PHONY: build
build: pre-build build-release
	@echo "Built default goal"

.PHONY: pre-build-all
pre-build-all:
	@echo "Building all goals..."

.PHONY: build-all
build-all: pre-build-all build-debug build-release
	@echo "Built all goals"

#-- Clean goals

.PHONY: pre-clean-debug
pre-clean-debug:
	@echo "Running debug clean goal..."

.PHONY: clean-debug
clean-debug: pre-clean-debug
	@echo "Cleaning '$(BUILD_DIR)/$(TARGET_NAME_DEBUG)'..."
	@rm -rf $(BUILD_DIR)/$(TARGET_NAME_DEBUG)
ifeq ($(OS),Windows_NT)
	@rm -rf $(BUILD_DIR)/$(subst .exe,.pdb,$(TARGET_NAME_DEBUG))
endif
	@echo "Ran debug clean goal"

.PHONY: pre-clean-release
pre-clean-release:
	@echo "Running release clean goal..."

.PHONY: clean-release
clean-release: pre-clean-release
	@echo "Cleaning '$(BUILD_DIR)/$(TARGET_NAME_RELEASE)'..."
	@rm -rf $(BUILD_DIR)/$(TARGET_NAME_RELEASE)
	@echo "Ran release clean goal"

.PHONY: pre-clean-build
pre-clean-build:
	@echo "Running build clean goal..."

.PHONY: clean-build
clean-build: pre-clean-build clean-debug clean-release
	@echo "Ran build clean goal"

.PHONY: pre-clean-dist-debug
pre-clean-dist-debug:
	@echo "Running debug distribution clean goal..."

.PHONY: clean-dist-debug
clean-dist-debug: pre-clean-dist-debug
	@echo "Cleaning '$(DIST_DIR)/debug/'..."
	@rm -rf $(DIST_DIR)/debug/
	@echo "Ran debug distribution clean goal"

.PHONY: pre-clean-dist-release
pre-clean-dist-release:
	@echo "Running release distribution clean goal..."

.PHONY: clean-dist-release
clean-dist-release: pre-clean-dist-release
	@echo "Cleaning '$(DIST_DIR)/release/'..."
	@rm -rf $(DIST_DIR)/release/
	@echo "Ran release distribution clean goal"

.PHONY: pre-clean-dist
pre-clean-dist:
	@echo "Running distribution clean goal..."

.PHONY: clean-dist
clean-dist: pre-clean-dist clean-dist-debug clean-dist-release
	@echo "Ran distribution clean goal"

.PHONY: pre-clean-dist-all
pre-clean-dist-all:
	@echo "Running all distribution clean goal..."

.PHONY: clean-dist-all
clean-dist-all: pre-clean-dist-all clean-dist
	@echo "Ran all distribution clean goal"

.PHONY: pre-clean-archive-debug
pre-clean-archive-debug:
	@echo "Running debug archive clean goal..."

.PHONY: clean-archive-debug
clean-archive-debug: pre-clean-archive-debug
	@echo "Cleaning '$(TARGET_NAME_ARCHIVE_DEBUG)'..."
	@rm -rf $(TARGET_NAME_ARCHIVE_DEBUG)
	@echo "Ran debug archive clean goal"

.PHONY: pre-clean-archive-release
pre-clean-archive-release:
	@echo "Running release archive clean goal..."

.PHONY: clean-archive-release
clean-archive-release: pre-clean-archive-release
	@echo "Cleaning '$(TARGET_NAME_ARCHIVE_RELEASE)'..."
	@rm -rf $(TARGET_NAME_ARCHIVE_RELEASE)
	@echo "Ran release archive clean goal"

.PHONY: pre-clean-archive
pre-clean-archive:
	@echo "Running archive clean goal..."

.PHONY: clean-archive
clean-archive: pre-clean-archive clean-archive-debug clean-archive-release
	@echo "Ran archive clean goal"

.PHONY: pre-clean-tests
pre-clean-tests:
	@echo "Running tests clean goal..."

.PHONY: clean-tests
clean-tests: pre-clean-tests
	@echo "Cleaning '$(BUILD_DIR)/$(TARGET_NAME_TESTS)'..."
	@rm -rf $(BUILD_DIR)/$(TARGET_NAME_TESTS)
ifeq ($(OS),Windows_NT)
	@echo "Cleaning '$(BUILD_DIR)/$(subst .exe,.pdb,$(TARGET_NAME_TESTS))'..."
	@rm -rf $(BUILD_DIR)/$(subst .exe,.pdb,$(TARGET_NAME_TESTS))
endif
	@echo "Ran tests clean goal"

.PHONY: pre-clean
pre-clean:
	@echo "Running default clean goal..."

.PHONY: clean
clean: pre-clean clean-build clean-archive clean-tests clean-dist
	@echo "Ran default clean goal"

.PHONY: pre-clean-all
pre-clean-all:
	@echo "Running all clean goal..."

.PHONY: clean-all
clean-all: pre-clean-all clean-build clean-archive clean-tests clean-dist
	@echo "Ran all clean goal"

#-- Archive goals

.PHONY: pre-archive
pre-archive:
	@echo "Running default archive goal..."

.PHONY: archive
archive: pre-archive archive-release
	@echo "Ran default archive goal"

.PHONY: pre-archive-release
pre-archive-release:
	@echo "Running release archive goal..."

.PHONY: archive-release
archive-release: pre-archive-release $(TARGET_NAME_ARCHIVE_RELEASE)
	@echo "Ran release archive goal"

.PHONY: pre-archive-debug
pre-archive-debug:
	@echo "Running debug archive goal..."

.PHONY: archive-debug
archive-debug: pre-archive-debug $(TARGET_NAME_ARCHIVE_DEBUG)
	@echo "Ran debug archive goal"

#-- Test goals

.PHONY: pre-test
pre-test:
	@echo "Running default test goal..."

.PHONY: test
test: pre-test | $(BUILD_DIR)
	$(ODIN_COMPILER) test $(TEST_DIR) -out:$(BUILD_DIR)/$(TARGET_NAME_TESTS)	\
		$(ODIN_TEST_FLAGS) $(ODIN_TEST_COLLECTIONS) $(ODIN_DEFINES)
	@echo "Ran default test goal"

#-- Lint goals

.PHONY: pre-lint-source
pre-lint-source:
	@echo "Running source lint goal..."

.PHONY: lint-source
lint-source: pre-lint-source
	$(ODIN_COMPILER) check $(SOURCE_DIR) $(ODIN_CHECK_FLAGS_SOURCE)				\
		$(ODIN_DEFINES)
	@echo "Ran source lint goal"

.PHONY: pre-lint-tests
pre-lint-tests:
	@echo "Running tests lint goal..."

.PHONY: lint-tests
lint-tests: pre-lint-tests
	$(ODIN_COMPILER) check $(TEST_DIR) $(ODIN_CHECK_FLAGS_TESTS)				\
		$(ODIN_DEFINES)
	@echo "Ran tests lint goal"

.PHONY: pre-lint
pre-lint:
	@echo "Running default lint goal..."

.PHONY: lint
lint: pre-lint lint-source lint-tests
	@echo "Ran default lint goal"

.PHONY: pre-lint-all
pre-lint-all:
	@echo "Running all lint goal..."

.PHONY: lint-all
lint-all: pre-lint-all lint
	@echo "Ran all lint goal"

#-- Run goals

.PHONY: pre-run-debug
pre-run-debug:
	@echo "Running debug run goal..."

.PHONY: run-debug
run-debug: pre-run-debug $(BUILD_DIR)/$(TARGET_NAME_DEBUG)
	@echo "Running $(TARGET_NAME_DEBUG)..."
	@echo "=== START OUTPUT ==="
	@echo ""
	@$(BUILD_DIR)/$(TARGET_NAME_DEBUG)
	@echo ""
	@echo "=== END OUTPUT ==="
	@echo "Ran $(TARGET_NAME_DEBUG)"

.PHONY: pre-run-release
pre-run-release:
	@echo "Running release run goal..."

.PHONY: run-release
run-release: pre-run-release $(BUILD_DIR)/$(TARGET_NAME_RELEASE)
	@echo "Running $(TARGET_NAME_RELEASE)..."
	@echo "=== START OUTPUT ==="
	@echo ""
	@$(BUILD_DIR)/$(TARGET_NAME_RELEASE)
	@echo ""
	@echo "=== END OUTPUT ==="
	@echo "Ran $(TARGET_NAME_RELEASE)"

.PHONY: pre-run
pre-run:
	@echo "Running default run goal..."

.PHONY: run
run: pre-run run-release
	@echo "Ran default run goal"

#-- General goals

.DEFAULT_GOAL := default

.PHONY: default
default: build

.PHONY: all
all: build-all

.PHONY: dist-debug
dist-debug: $(DIST_DIR)/debug/$(TARGET_NAME_DEBUG)

.PHONY: dist-release
dist-release: $(DIST_DIR)/release/$(TARGET_NAME_RELEASE)

.PHONY: dist
dist: dist-release

.PHONY: dist-all
dist-all: dist-debug dist-release
