import math
import strutils
import sequtils
import strfmt

func linearInterpolate(before, after, atPoint: float64): float64 =
  before + (after - before) * atPoint

func interpolateArray(data: openArray[float64], fitCount: int): seq[float64] =
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
  
  for i in 0..rows:
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
      plot[rows - y0][x + l_offset] = "─"
    else:
      if y0 > y1:
        plot[rows - y1][x + l_offset] = "╰"
        plot[rows - y0][x + l_offset] = "╮"
      else:
        plot[rows - y1][x + l_offset] = "╭"
        plot[rows - y0][x + l_offset] = "╯"
    
      var start = int(min(y0, y1)) + 1
      var `end` = int(max(y0, y1))
      for y in start..<`end`:
        plot[rows - y][x + l_offset] = "│"

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
  var data = @[3f64, 4, 9, 6, 2, 4, 5, 8, 5, 10, 2, 7, 2, 5, 6]
  echo plot(data, caption="An example graph!")