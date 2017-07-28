# Package

version     = "0.0.1"
author      = "Johannes Beranek"
description = "xx0 in nim"
license     = "MIT"

# Ignore tests dir for installation
skipDirs = @["tests"]

# Deps

requires "nim >= 0.17.0"
requires "frag"
requires "strfmt"

# Binaries
bin = @["xx0"]

# Do not install source
skipExt = @["nim"]

task test, "Runs the test suite":
  exec "nim -c -r tests/tests"
