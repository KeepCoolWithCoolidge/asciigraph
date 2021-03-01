import std/[unittest, os]

import asciigraph

let prefix = "tests" / "graphs"

suite "asciigraph tests":
  test "Graph 1":
    let
      data = @[1f64, 1, 1, 1, 1]
      graph = readFile(prefix / "t1.txt")
    check plot(data) == graph

  test "Graph 2":
    let
      data = @[2f64, 1, 1, 2, -2, 5, 7, 11, 3, 7, 1]
      graph = readFile(prefix / "t2.txt")
    check plot(data) == graph

  test "Graph 3":
    let
      data = @[2f64, 1, 1, 2, -2, 5, 7, 11, 3, 7, 4, 5, 6, 9, 4, 0,
                  6, 1, 5, 3, 6, 2]
      graph = readFile(prefix / "t3.txt")
    check plot(data, caption = "Plot using asciigraph.") == graph

  test "Graph 4":
    let
      data = @[0.2f64, 0.1, 0.2, 2, -0.9, 0.7, 0.91, 0.3, 0.7, 0.4, 0.5]
      graph = readFile(prefix / "t4.txt")
    check plot(data, caption = "Plot using asciigraph.") == graph

  test "Graph 5":
    let
      data = @[2f64, 1, 1, 2, -2, 5, 7, 11, 3, 7, 1]
      graph = readFile(prefix / "t5.txt")
    check plot(data, height = 4, offset = 3) == graph

  test "Graph 6":
    let
      data = @[0.453f64, 0.141, 0.951, 0.251, 0.223, 0.581, 0.771, 0.191,
              0.393, 0.617, 0.478]
      graph = readFile(prefix / "t6.txt")
    check plot(data) == graph

  test "Graph 7":
    let
      data = @[0.01f64, 0.004, 0.003, 0.0042, 0.0083, 0.0033, 0.0079]
      graph = readFile(prefix / "t7.txt")
    check plot(data) == graph

  test "Graph 8":
    let
      data = @[192f64, 431, 112, 449, -122, 375, 782, 123, 911, 1711, 172]
      graph = readFile(prefix / "t8.txt")
    check plot(data, height = 10) == graph

  test "Graph 9":
    let
      data = @[0.3189989805f64, 0.149949026, 0.30142492354,
              0.195129182935, 0.3142492354, 0.1674974513,
              0.3142492354, 0.1474974513, 0.3047974513]
      graph = readFile(prefix / "t9.txt")
    check plot(data, width = 30, height = 5,
        caption = "Plot with custom height & width.") == graph

  test "Graph 10":
    let
      data = @[0f64, 0, 0, 0, 1.5, 0, 0, -0.5, 9, -3, 0, 0, 1, 2, 1,
              0, 0, 0, 0, 0, 0, 0, 0, 1.5, 0, 0, -0.5, 8, -3, 0, 0,
              1, 2, 1, 0, 0, 0, 0, 0, 0, 0, 0, 1.5, 0, 0, -0.5, 10,
              -3, 0, 0, 1, 2, 1, 0, 0, 0, 0]
      graph0 = readFile(prefix / "t10.txt")
    check plot(data, offset = 10, height = 10,
        caption = "I'm a doctor, not an engineer.") == graph0

  test "Graph 11":
    let
      data = @[-5f64, -2, -3, -4, 0, -5, -6, -7, -8, 0, -9, -3, -5,
              -2, -9, -3, -1]
      graph1 = readFile(prefix / "t11.txt")
    check plot(data) == graph1

  test "Graph 12":
    let
      data = @[-0.000018527f64, -0.021, -0.00123,
                0.00000021312, -0.0434321234, -0.032413241234,
                0.0000234234]
      graph2 = readFile(prefix / "t12.txt")
    check plot(data, height = 5, width = 45) == graph2

  test "Graph 13":
    let
      data = @[57.76f64, 54.04, 56.31, 57.02, 59.5, 52.63, 52.97,
                56.44, 56.75, 52.96, 55.54, 55.09, 58.22, 56.85,
                60.61, 59.62, 59.73, 59.93, 56.3, 54.69, 55.32,
                54.03, 50.98, 50.48, 54.55, 47.49, 55.3, 46.74,
                46, 45.8, 49.6, 48.83, 47.64, 46.61, 54.72,
                42.77, 50.3, 42.79, 41.84, 44.19, 43.36, 45.62,
                45.09, 44.95, 50.36, 47.21, 47.77, 52.04, 47.46,
                44.19, 47.22, 45.55, 40.65, 39.64, 37.26, 40.71,
                42.15, 36.45, 39.14, 36.62]
      graph3 = readFile(prefix / "t13.txt")

    check plot(data, width = -10, height = -10, offset = -1) == graph3
