#-- Project Variables
PROJECT_NAME := terminal-fps
PROJECT_DESCRIPTION := A simple first-person shooter that runs in your terminal.
PROJECT_VERSION := 0.0.0
SOURCE_FILES := main.odin

#-- Path Variables
SOURCE_DIR := src
BUILD_DIR := build
DIST_DIR := dist
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
	EXE_NAME := $(addsuffix $(EXE_NAME),.exe)
	EXE_NAME_DEBUG := $(addsuffix $(EXE_NAME_DEBUG),.exe)
	EXE_NAME_TESTS := $(addsuffix $(EXE_NAME_TESTS),.exe)
endif

#-- make Configuration
.DEFAULT_GOAL := default

#-- Build Rules

$(BUILD_DIR)/$(EXE_NAME): $(SOURCES) | $(BUILD_DIR)
	@echo "Building \"$@\""
	$(ODIN_COMPILER) build $(SOURCE_DIR) -out:$@ $(ODIN_RELEASE_FLAGS)

$(BUILD_DIR)/$(EXE_NAME_DEBUG): $(SOURCES) | $(BUILD_DIR)
	@echo "Building \"$@\""
	$(ODIN_COMPILER) build $(SOURCE_DIR) -out:$@ $(ODIN_DEBUG_FLAGS)

$(BUILD_DIR):
	@mkdir -p $(BUILD_DIR)

.PHONY: default/pre default env/print all/pre all run run/debug clean rebuild \
	test lint

default/pre:
	@echo "Building default..."

default: default/pre $(BUILD_DIR)/$(EXE_NAME)
	@echo "Built default"

env/print:
	@echo "=== Environment Information ==="
	@echo "Odin: $(shell odin version)"
	@odin report

all/pre:
	@echo "Building all targets..."

all: all/pre $(BUILD_DIR)/$(EXE_NAME) $(BUILD_DIR)/$(EXE_NAME_DEBUG)
	@echo "Built all targets"

run: $(BUILD_DIR)/$(EXE_NAME)
	@$(BUILD_DIR)$(EXE_NAME)

run/debug: $(BUILD_DIR)/$(EXE_NAME_DEBUG)
	@$(BUILD_DIR)$(EXE_NAME_DEBUG)

clean: $(BUILD_DIR)
	@echo "Cleaning..."
	@rm -r $(BUILD_DIR)
	@echo "Done cleaning"

rebuild:
	@$(MAKE) clean
	@$(MAKE) all

test: | $(BUILD_DIR)
	@echo "Running tests..."
	$(ODIN_COMPILER) test $(SOURCE_DIR) -out:$@ $(ODIN_TEST_FLAGS)
	@echo "Cleaning up..."
	@rm "$@"
	@echo "Done running tests"

lint:
	@echo "Linting..."
	$(ODIN_COMPILER) check $(SOURCE_DIR) $(ODIN_CHECK_FLAGS)
	@echo "Done linting"
