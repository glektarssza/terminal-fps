#-- Project Variables
PROJECT_NAME := terminal-fps
PROJECT_DESCRIPTION := A simple first-person shooter that runs in your terminal.
PROJECT_VERSION := 0.0.0
SOURCE_FILES := main.odin

#-- Path Variables
SOURCE_DIR := ./src/
BUILD_DIR := ./build/
DIST_DIR := ./dist/
INSTALL_DIR ?= $(DIST_DIR)
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

#-- Build Rules

$(DIST_DIR)$(EXE_NAME): $(SOURCES) | $(BUILD_DIR) $(DIST_DIR)
	$(ODIN_COMPILER) build $(SOURCE_DIR) -out:$@ $(ODIN_DEFINES) $(ODIN_FLAGS) \
		$(ODIN_RELEASE_FLAGS)

$(DIST_DIR)$(EXE_NAME_DEBUG): $(SOURCES) | $(BUILD_DIR) $(DIST_DIR)
	$(ODIN_COMPILER) build $(SOURCE_DIR) -out:$@ $(ODIN_DEFINES) $(ODIN_FLAGS) \
		$(ODIN_DEUBG_FLAGS)

#-- Windows Build Rules

$(DIST_DIR)$(EXE_NAME).exe: $(SOURCES) | $(BUILD_DIR) $(DIST_DIR)
	$(ODIN_COMPILER) build $(SOURCE_DIR) -out:$@ $(ODIN_DEFINES) $(ODIN_FLAGS) \
		$(ODIN_RELEASE_FLAGS)

$(DIST_DIR)$(EXE_NAME_DEBUG).exe: $(SOURCES) | $(BUILD_DIR) $(DIST_DIR)
	$(ODIN_COMPILER) build $(SOURCE_DIR) -out:$@ $(ODIN_DEFINES) $(ODIN_FLAGS) \
		$(ODIN_DEUBG_FLAGS)

#-- Directory Creation Rules
$(DIST_DIR) $(BUILD_DIR):
	@mkdir -p "$@"

.PHONY: print-env
print-env:
	@echo "=== Environment Information ==="
	@echo "Odin: $(shell odin version)"
	@odin report

ifeq ($(OS),Windows_NT)
.PHONY: all
all: $(DIST_DIR)$(EXE_NAME).exe $(DIST_DIR)$(EXE_NAME_DEBUG).exe
	@echo "Building all targets..."

.PHONY: run
run: $(DIST_DIR)$(EXE_NAME)
	@$(DIST_DIR)$(EXE_NAME).exe

.PHONY: debug
debug: $(DIST_DIR)$(EXE_NAME_DEBUG)
	@$(DIST_DIR)$(EXE_NAME_DEBUG).exe
else
.PHONY: all
all: $(DIST_DIR)$(EXE_NAME) $(DIST_DIR)$(EXE_NAME_DEBUG)
	@echo "Building all targets..."

.PHONY: run
run: $(DIST_DIR)$(EXE_NAME)
	@$(DIST_DIR)$(EXE_NAME)

.PHONY: debug
debug: $(DIST_DIR)$(EXE_NAME_DEBUG)
	@$(DIST_DIR)$(EXE_NAME_DEBUG)
endif
