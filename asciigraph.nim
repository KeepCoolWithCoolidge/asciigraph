import math
import strutils
import sequtils
import strfmt

func linearInterpolate*(before, after, atPoint: float64): float64 =
  before + (after - before) * atPoint

func interpolateArray*(data: openArray[float64], fitCount: int): seq[float64] =
  var
    spring: float64
    before: float64
    after: float64
    atPoint: float64
    interpolateData: seq[float64] = newSeq[float64](0)
    springFactor = float64(len(data) - 1) / float64(fitCount - 1)
  
  interpolateData.add(data[0])

  for i in 1..<fitCount - 1:
    spring = float64(i) * springFactor
    before = floor(spring)
    after = ceil(spring)
    atPoint = spring - before
    interpolateData.add(linearInterpolate(data[int(before)], data[int(after)], atPoint))
  
  interpolateData.add(data[data.high])
  interpolateData

func plot*(series: openArray[float64], width: int = 0, height: int = 0, offset: int = 3, caption: string = ""): string =
  var l_height, l_offset: int
  var interpolatedSeries: seq[float64]
  if width > 0:
    interpolatedSeries = interpolateArray(series, width)
  else:
    interpolatedSeries = interpolateArray(series, len(series))

  var 
    minimum = min(interpolatedSeries)
    maximum = max(interpolatedSeries)
    interval = abs(maximum - minimum)

  if height <= 0:
    if int(interval) <= 0:
      l_height = int(interval * pow(10,ceil(-log10(interval))))
    else:
      l_height = int(interval)
  else:
    l_height = height
  
  l_offset = if offset <= 0: 3 else: offset
  
  var 
    ratio = if interval != 0: float64(l_height) / interval else: 1
    min2 = round(minimum * ratio)
    max2 = round(maximum * ratio)

    intmin2 = int(min2)
    intmax2 = int(max2)

    rows = abs(intmax2 - intmin2)
    width = len(interpolatedSeries) + l_offset
    plot = newSeqWith(rows + 1, newSeq[string](width))
  
  for i in 0..<rows + 1:
    for j in 0..<width:
      plot[i][j] = " "
  
  var 
    precision = 2
    logMaximum = log10(max(abs(maximum), abs(minimum)))
  
  if logMaximum < 0:
    if logMaximum mod 1 != 0:
      inc precision, int(abs(logMaximum))
    else:
      inc precision, int(abs(logMaximum) - 1.0)
  elif logMaximum > 2:
    precision = 0

  var 
    maxNumLength = len(maximum.format("0.$1f" % $precision))
    minNumLength = len(minimum.format("0.$1f" % $precision))
    maxWidth = max(maxNumLength, minNumLength)

  for y in intmin2..intmax2:
    var magnitude: float64
    if rows > 0:
      magnitude = maximum - (float64(y - intmin2) * interval / float64(rows))
    else:
      magnitude = float64(y)
  
    var
      label = magnitude.format("$1.$2f" % [$(maxWidth + 1), $precision])
      w = y - intmin2
      h = max(l_offset - len(label), 0)
    
    plot[w][h] = label
    if y == 0:
      plot[w][l_offset - 1] = "┼"
    else:
      plot[w][l_offset - 1] = "┤"
  
  var y0 = int(round(interpolatedSeries[0] * ratio) - min2)
  var y1: int
  
  plot[rows - y0][l_offset - 1] = "┼"

  for x in 0..<interpolatedSeries.high:
    y0 = int(round(interpolatedSeries[x + 0] * ratio) - float64(intmin2))
    y1 = int(round(interpolatedSeries[x + 1] * ratio) - float64(intmin2))
    if y0 == y1:
      plot[rows-y0][x + l_offset] = "─"
    else:
      if y0 > y1:
        plot[rows-y1][x + l_offset] = "╰"
        plot[rows-y0][x + l_offset] = "╮"
      else:
        plot[rows-y1][x + l_offset] = "╭"
        plot[rows-y0][x + l_offset] = "╯"
    
      var start = int(min(y0, y1)) + 1
      var `end` = int(max(y0, y1))
      for y in start..<`end`:
        plot[rows-y][x + l_offset] = "│"

  var lines: string
  for h, horizontal in plot:
    if h != 0:
      lines.add("\n")
    for _, v in horizontal:
      lines.add(v)
  
  if caption != "":
    lines.add("\n")
    lines.add(repeat(" ", l_offset + maxWidth + 2))
    lines.add(caption)
  lines

when isMainModule:
  var 
    dataSet1 = @[1f64, 1, 1, 1, 1]
    dataSet2 = @[2f64, 1, 1, 2, -2, 5, 7, 11, 3, 7, 1]
    dataSet3 = @[2f64, 1, 1, 2, -2, 5, 7, 11, 3, 7, 4, 5, 6, 9, 4, 0, 6, 1, 5, 3, 6, 2]
    dataSet4 = @[0.2f64, 0.1, 0.2, 2, -0.9, 0.7, 0.91, 0.3, 0.7, 0.4, 0.5]
    dataSet5 = @[2f64, 1, 1, 2, -2, 5, 7, 11, 3, 7, 1]
    dataSet6 = @[0.453f64, 0.141, 0.951, 0.251, 0.223, 0.581, 0.771, 0.191, 0.393, 0.617, 0.478]
    dataSet7 = @[0.01f64, 0.004, 0.003, 0.0042, 0.0083, 0.0033, 0.0079]
    dataSet8 = @[192f64, 431, 112, 449, -122, 375, 782, 123, 911, 1711, 172]
    dataSet9 = @[0.3189989805f64, 0.149949026, 0.30142492354, 0.195129182935, 0.3142492354, 0.1674974513, 0.3142492354, 0.1474974513, 0.3047974513]
    dataSet10 = @[0f64, 0, 0, 0, 1.5, 0, 0, -0.5, 9, -3, 0, 0, 1, 2, 1, 0, 0, 0, 0, 0, 0, 0, 0, 1.5, 0, 0, -0.5, 8, -3, 0, 0, 1, 2, 1, 0, 0, 0, 0, 0, 0, 0, 0, 1.5, 0, 0, -0.5, 10, -3, 0, 0, 1, 2, 1, 0, 0, 0, 0]
    dataSet11 = @[-5f64, -2, -3, -4, 0, -5, -6, -7, -8, 0, -9, -3, -5, -2, -9, -3, -1]
    dataSet12 = @[-0.000018527f64, -0.021, -0.00123, 0.00000021312, -0.0434321234, -0.032413241234, 0.0000234234]
    dataSet13 = @[ 57.76f64, 54.04, 56.31, 57.02, 59.5, 52.63, 52.97, 56.44, 56.75, 52.96, 55.54, 55.09, 58.22, 56.85, 60.61, 59.62, 59.73, 59.93, 56.3, 54.69, 55.32, 54.03, 50.98, 50.48, 54.55, 47.49, 55.3, 46.74, 46, 45.8, 49.6, 48.83, 47.64, 46.61, 54.72, 42.77, 50.3, 42.79, 41.84, 44.19, 43.36, 45.62, 45.09, 44.95, 50.36, 47.21, 47.77, 52.04, 47.46, 44.19, 47.22, 45.55, 40.65, 39.64, 37.26, 40.71, 42.15, 36.45, 39.14, 36.62]
  echo plot(dataSet1), "\n"
  echo plot(dataSet2), "\n"
  echo plot(dataSet3, caption="Plot using asciigraph."), "\n"
  echo plot(dataSet4, caption="Plot using asciigraph."), "\n"
  echo plot(dataSet5, height=4, offset=3), "\n"
  echo plot(dataSet6), "\n"
  echo plot(dataSet7), "\n"
  echo plot(dataSet8, height=10), "\n"
  echo plot(dataSet9, width=30, height=5, caption="Plot with custom height & width."), "\n"
  echo plot(dataSet10, offset=10, height=10, caption="I'm a doctor, not an engineer."), "\n"
  echo plot(dataSet11), "\n"
  echo plot(dataSet12, height=5, width=45), "\n"
  echo plot(dataSet13)