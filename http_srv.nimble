# Package

version       = "0.1.0"
author        = "litlighilit"
description   = "A python's http.server like Nim binary"
license       = "MIT"
srcDir        = "src"
bin           = @["http_srv"]


# Dependencies

requires "nim >= 1.6.14"


task genHtml, "gen html":
  # dest="${1-src/newYear.nims}"
  for i in commandLineParams:
    if i[0] != '-':
      let dest = i
      exec "nim --hints:off $dest > html/index.html"
      break


