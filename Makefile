# Commands
STRIP       := gstrip

# Flags
BUILD_FLAGS := --threads:on -d:release --opt:size \
  --passC:-ffunction-sections --passC:-fdata-sections \
  --passL:-Wl

TEST_BUILD_FLAGS := --debugger:native --passC:--coverage --passL:--coverage

# Dirs
PROJECT_ROOT:= $(dir $(realpath $(firstword $(MAKEFILE_LIST))))

BIN_DIR     := $(PROJECT_ROOT)bin
TESTS_DIR   := $(PROJECT_ROOT)tests
COVERAGE_DIR:= coverage

# Files
MAIN_NIM    := xx0.nim
MAIN_BIN    := $(BIN_DIR)/xx0
MAIN_INFO   := xx0.info
TEST_NIM    := $(TESTS_DIR)/tests.nim
TEST_BIN    := $(BIN_DIR)/tests
TEST_INFO   := $(TESTS_DIR)/tests.info


# ----- Rules

# Default rule
.PHONY: default
default: run

# Binaries
$(BIN_DIR):
	mkdir -p $@

$(MAIN_BIN): $(MAIN_NIM) $(BIN_DIR)
	nim c $(BUILD_FLAGS) --out:$@ $<
	$(STRIP) -S -x $@

$(TEST_BIN): $(TEST_NIM) $(BIN_DIR)
	nim c $(TEST_BUILD_FLAGS) --out:$@ $<


# Coverage
$(TEST_INFO): $(TEST_BIN)
	$(MAKE) clean-test-info
# reset counters
	lcov --base-directory . --directory . --zerocounters -q
	$(MAKE) run-test
# create coverage info
	lcov --base-directory . --directory . -c -o $(TEST_INFO)
# remove Nim system libs from coverage
	lcov --remove $(TEST_INFO) "*/nim/lib/*" -o $(TEST_INFO)

$(COVERAGE_DIR): $(TEST_INFO)
	$(MAKE) clean-coverage
	genhtml -o $(COVERAGE_DIR) $(TEST_INFO)

.PHONY: build
build: $(MAIN_BIN)

.PHONY: cov
cov: $(COVERAGE_DIR)

.PHONY: run
run: $(MAIN_BIN)
	$(MAIN_BIN)

.PHONY: run-test
run-test: $(TEST_BIN)
	$(TEST_BIN)

.PHONY: clean-test-info
clean-test-info:
	rm -f $(TEST_INFO) 

.PHONY: clean-coverage
clean-coverage:
	rm -rf $(COVERAGE_DIR)

.PHONY: install-dev-deps
install-dev-deps:
	nimble install sdl2 strfmt