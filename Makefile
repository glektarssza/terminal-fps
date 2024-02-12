#-- Project Variables
PROJECT_NAME := terminal-fps
PROJECT_DESCRIPTION := A simple first-person shooter that runs in your terminal.
PROJECT_VERSION := 0.0.0
SOURCE_FILES := main.odin

#-- Path Variables
SOURCE_DIR := ./src/
BUILD_DIR := ./build/
DIST_DIR := ./dist/
DOC_DIR := ./docs/

#-- Tool Variables
ODIN_COMPILER ?= odin
ODIN_FLAGS ?= -strict-style -vet-unused -vet-shadowing -vet-using-stmt \
			  -vet-using-param -vet-style -vet-semicolon -build-mode:exe
ODIN_DEBUG_FLAGS ?= -debug -o:none
ODIN_RELEASE_FLAGS ?= -o:minimal -obfuscate-source-code-locations
ODIN_DEFINES ?= -define:PROJECT_NAME="$(PROJECT_NAME)"				 \
				-define:PROJECT_DESCRIPTION="$(PROJECT_DESCRIPTION)" \
				-define:PROJECT_VERSION="$(PROJECT_VERSION)"

#-- Generated Variables
SOURCES := $(SOURCE_FILES:%=$(SOURCE_DIR)%)
EXE_NAME ?= $(PROJECT_NAME)
EXE_NAME_DEBUG ?= $(PROJECT_NAME)-debug

ifeq ($(OS),Windows_NT)
	EXE_NAME := $(addsuffix $(EXE_NAME),.exe)
	EXE_NAME := $(addsuffix $(EXE_NAME_DEBUG),.exe)
endif

#-- Build Rules

$(BUILD_DIR)$(EXE_NAME): $(SOURCES) | $(BUILD_DIR)
	@echo "Building \"$@\""
	$(ODIN_COMPILER) build $(SOURCE_DIR) -out:$@ $(ODIN_DEFINES) $(ODIN_FLAGS) \
		$(ODIN_RELEASE_FLAGS)

$(BUILD_DIR)$(EXE_NAME_DEBUG): $(SOURCES) | $(BUILD_DIR)
	@echo "Building \"$@\""
	$(ODIN_COMPILER) build $(SOURCE_DIR) -out:$@ $(ODIN_DEFINES) $(ODIN_FLAGS) \
		$(ODIN_DEUBG_FLAGS)

$(BUILD_DIR):
	@mkdir -p $(BUILD_DIR)

.PHONY: print-env pre-all all clean run debug rebuild

print-env:
	@echo "=== Environment Information ==="
	@echo "Odin: $(shell odin version)"
	@odin report

pre-all:
	@echo "Building all targets..."

all: pre-all $(BUILD_DIR)$(EXE_NAME) $(BUILD_DIR)$(EXE_NAME_DEBUG)
	@echo "Built all targets"

run: $(BUILD_DIR)$(EXE_NAME)
	@$(BUILD_DIR)$(EXE_NAME)

debug: $(BUILD_DIR)$(EXE_NAME_DEBUG)
	@$(BUILD_DIR)$(EXE_NAME_DEBUG)

clean: $(BUILD_DIR)
	@echo "Cleaning..."
	@rm -r $(BUILD_DIR)
	@echo "Done cleaning"

rebuild:
	@$(MAKE) clean
	@$(MAKE) all
