#-- Project Variables
PROJECT_NAME := terminal-fps
PROJECT_DESCRIPTION := A simple first-person shooter that runs in your terminal.
PROJECT_VERSION := 0.0.0
SOURCE_FILES := main.odin

#-- Path Variables
SOURCE_DIR := src
OUT_DIR ?= dist
DOC_DIR := docs

#-- Tool Variables
ODIN_COMPILER ?= odin
FLAGS ?= -build-mode:exe
DEBUG_FLAGS ?= -debug -o:none
RELEASE_FLAGS ?= -o:minimal -obfuscate-source-code-locations
TEST_FLAGS ?=
CHECK_FLAGS ?= -strict-style -vet-unused -vet-shadowing -vet-using-stmt \
				-vet-using-param -vet-style -vet-semicolon
DEFINES ?= -define:PROJECT_NAME="$(PROJECT_NAME)"				 \
			-define:PROJECT_DESCRIPTION="$(PROJECT_DESCRIPTION)" \
			-define:PROJECT_VERSION="$(PROJECT_VERSION)"

#-- Generated Variables
SOURCES := $(SOURCE_FILES:%=$(SOURCE_DIR)/%)

ODIN_BASE_FLAGS ?= $(CHECK_FLAGS) $(ODIN_DEFINES)
ODIN_DEBUG_FLAGS ?= $(ODIN_BASE_FLAGS) $(DEBUG_FLAGS)
ODIN_RELEASE_FLAGS ?= $(ODIN_BASE_FLAGS) $(RELEASE_FLAGS)
ODIN_TEST_FLAGS ?= $(ODIN_BASE_FLAGS) $(TEST_FLAGS)
ODIN_CHECK_FLAGS ?= $(ODIN_BASE_FLAGS)

EXE_NAME ?= $(PROJECT_NAME)
EXE_NAME_DEBUG ?= $(PROJECT_NAME)-debug
EXE_NAME_TESTS ?= $(PROJECT_NAME)-tests

ifeq ($(OS),Windows_NT)
	EXE_NAME := $(addsuffix .exe,$(EXE_NAME))
	EXE_NAME_DEBUG := $(addsuffix .exe,$(EXE_NAME_DEBUG))
	EXE_NAME_TESTS := $(addsuffix .exe,$(EXE_NAME_TESTS))
endif

#-- GNU make Configuration
.DEFAULT_GOAL := default

#-- Build Rules

$(OUT_DIR)/$(EXE_NAME): $(SOURCES) | $(OUT_DIR)
	@echo "Building \"$@\""
	$(ODIN_COMPILER) build $(SOURCE_DIR) -out:$@ $(ODIN_RELEASE_FLAGS)

$(OUT_DIR)/$(EXE_NAME_DEBUG): $(SOURCES) | $(OUT_DIR)
	@echo "Building \"$@\""
	$(ODIN_COMPILER) build $(SOURCE_DIR) -out:$@ $(ODIN_DEBUG_FLAGS)

$(OUT_DIR):
	@mkdir -p $(OUT_DIR)

#-- Rule Aliases

.PHONY: default print-env pre-all all pre-build build build-release \
	build-debug run run-debug clean rebuild test lint

default: build

print-env:
	@echo "=== Environment Information ==="
	@echo "Odin: $(shell odin version)"
	@odin report

pre-all:
	@echo "Building all targets..."

all: pre-all build-release build-debug
	@echo "Built all targets"

pre-build:
	@echo "Building default target..."

build: pre-build build-release
	@echo "Built default target"

pre-build-release:
	@echo "Building release target..."

build-release: pre-build-release $(OUT_DIR)/$(EXE_NAME)
	@echo "Built release target"

pre-build-debug:
	@echo "Building debug target..."

build-debug: pre-build-debug $(OUT_DIR)/$(EXE_NAME_DEBUG)
	@echo "Built debug target"

run: build-release
	@echo "Running $(OUT_DIR)/$(EXE_NAME)..."
	@$(OUT_DIR)/$(EXE_NAME) $(RUN_ARGS)

run-debug: build-debug
	@echo "Running $(OUT_DIR)/$(EXE_NAME_DEBUG)..."
	@$(OUT_DIR)/$(EXE_NAME_DEBUG) $(RUN_DEBUG_ARGS)

clean: $(OUT_DIR)
	@echo "Cleaning..."
	@rm -r $(OUT_DIR)
	@echo "Done cleaning"

rebuild:
	@$(MAKE) clean
	@$(MAKE) all

test: | $(OUT_DIR)
	@echo "Running tests..."
	$(ODIN_COMPILER) test $(SOURCE_DIR) -out:$@ $(ODIN_TEST_FLAGS)
	@echo "Cleaning up..."
	@rm "$@"
	@echo "Done running tests"

lint:
	@echo "Linting..."
	$(ODIN_COMPILER) check $(SOURCE_DIR) $(ODIN_CHECK_FLAGS)
	@echo "Done linting"
