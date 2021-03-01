# asciigraph ![BuildAndTest](https://github.com/Yardanico/asciigraph/actions/workflows/test.yml/badge.svg)

Console ascii line graphs in pure Nim ╭┈╯.

## Installation

```sh
nimble install asciigraph
```

## Usage
### Basic graph

```nim
import asciigraph

var data = @[3f64, 4, 9, 6, 2, 4, 5, 8, 5, 10, 2, 7, 2, 5, 6]
echo plot(data, caption="An example graph!")
```

Running this example renders the following graph:

```
 10.00 ┤        ╭╮     
  9.00 ┤ ╭╮     ││     
  8.00 ┤ ││   ╭╮││     
  7.00 ┤ ││   ││││╭╮   
  6.00 ┤ │╰╮  ││││││ ╭ 
  5.00 ┤ │ │ ╭╯╰╯│││╭╯ 
  4.00 ┤╭╯ │╭╯   ││││  
  3.00 ┼╯  ││    ││││  
  2.00 ┤   ╰╯    ╰╯╰╯  
          An example graph!
```

## Acknowledgements

This package is a Nim port of the [asciichart](https://github.com/kroitor/asciichart) library written by [@kroitor](https://github.com/kroitor).

Forked from https://github.com/KeepCoolWithCoolidge/asciigraph to update for latest Nim versions (and some other improvements).

## Contributing

Feel free to make a pull request! :octocat:
