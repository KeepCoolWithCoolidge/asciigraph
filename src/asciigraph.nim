import std/[math, strutils, sequtils, strformat]

func linearInterpolate(before, after, atPoint: SomeFloat): SomeFloat =
  before + (after - before) * atPoint

func interpolateArray[T: SomeFloat](data: openArray[T], fitCount: int): seq[T] =
  result.newSeq(fitCount)
  var
    spring, before, after, atPoint: T
    springFactor = T(len(data) - 1) / T(fitCount - 1)

  result[0] = data[0]

  for i in 1..<fitCount - 1:
    spring = T(i) * springFactor
    before = floor(spring)
    after = ceil(spring)
    atPoint = spring - before
    result[i] = linearInterpolate(data[int(before)], data[int(after)], atPoint)

  result[fitCount - 1] = data[^1]

func plot*[T: SomeFloat](series: openArray[T], width = 0, height = 0,
    offset = 3, caption = ""): string =
  var l_height, l_offset: int
  var interpolatedSeries: seq[T]
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
      l_height = int(interval * pow(10, ceil(-log10(interval))))
    else:
      l_height = int(interval)
  else:
    l_height = height

  l_offset = if offset <= 0: 3 else: offset

  var
    ratio = if interval != 0: T(l_height) / interval else: 1
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
    specifier = "0.$1f" % $precision
    maxString, minString: string

  maxString.formatValue(maximum, specifier)
  minString.formatValue(minimum, specifier)

  let
    maxNumLength = len(maxString)
    minNumLength = len(minString)
    maxWidth = max(maxNumLength, minNumLength)

  for y in intmin2..intmax2:
    var magnitude: T
    if rows > 0:
      magnitude = maximum - (T(y - intmin2) * interval / T(rows))
    else:
      magnitude = T(y)

    specifier = "$1.$2f" % [$(maxWidth + 1), $precision]
    var label: string
    label.formatValue(magnitude, specifier)
    var w = y - intmin2
    var h = max(l_offset - len(label), 0)

    plot[w][h] = label
    if y == 0:
      plot[w][l_offset - 1] = "┼"
    else:
      plot[w][l_offset - 1] = "┤"

  var y0 = int(round(interpolatedSeries[0] * ratio) - min2)
  var y1: int

  plot[rows - y0][l_offset - 1] = "┼"

  for x in 0..<interpolatedSeries.high:
    y0 = int(round(interpolatedSeries[x + 0] * ratio) - T(intmin2))
    y1 = int(round(interpolatedSeries[x + 1] * ratio) - T(intmin2))
    if y0 == y1:
      plot[rows - y0][x + l_offset] = "─"
    else:
      plot[rows - y1][x + l_offset] = if y0 > y1: "╰" else: "╭"
      plot[rows - y0][x + l_offset] = if y0 > y1: "╮" else: "╯"

      var frm = int(min(y0, y1)) + 1
      var to = int(max(y0, y1))
      for y in frm..<to:
        plot[rows - y][x + l_offset] = "│"

  for h, horizontal in plot:
    if h != 0:
      result.add("\n")
    for _, v in horizontal:
      result.add(v)

  if caption != "":
    result.add("\n")
    result.add(repeat(" ", l_offset + maxWidth + 2))
    result.add(caption)

when isMainModule:
  var data = @[3f32, 4, 9, 6, 2, 4, 5, 8, 5, 10, 2, 7, 2, 5, 6]
  echo plot(data, caption = "An example graph!")
