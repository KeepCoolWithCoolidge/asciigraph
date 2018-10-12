# Package

version = "0.1.0"
author = "KeepCoolWithCoolidge"
description = "Console ascii line charts in pure nim"
license = "MIT"
srcDir = "src"

# Dependencies

requires "nim >= 0.19.0"
requires "strfmt"

proc configForTests() =
  --hints: off
  --linedir: on
  --stacktrace: on
  --linetrace: on
  --debuginfo
  --path: "."
  --run

task test, "run tests":
  configForTests()
  setCommand "c", "tests/test.nim"
