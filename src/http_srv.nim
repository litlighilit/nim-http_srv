

import std/asynchttpserver
# This will create an HTTP server on an port specified by `bPort`.
# It will respond to GET requests with a `200 OK` response code and a `python -m http.server` like
# response body.
import std/asyncdispatch

import std/times
from std/uri import Uri
import std/os
from std/strutils import parseInt

template readIfExist(fn, elseVal): string =
  if fileExists fn: readFile fn
  else: elseVal

const html404 = "404.html"
const i404Content = readIfExist html404: "<h1>The Page you are seeking for is not found. </h1>"
template getIndexContent: string = readIfExist"index.html": "<h1>The Index Page</h1>"
proc getContentByString(p: string): string =
  if p=="": return getIndexContent()
  var hp = p
  if fileExists hp: return readFile hp
  hp.add ".html"
  if fileExists hp: return readFile hp
  i404Content
  
proc getContent(url: Uri): string =
  if url.path.len == 1: return getContentByString ""
  
  var path  = url.path[1..^1] # remove leading '/'
  let lidx = path.len-1
  if path[lidx] == '/': path.setlen lidx

  return getContentByString path


proc main(port: Port) {.async.} =
  var server = newAsyncHttpServer()
  proc cb(req: Request) {.async.} =
    # echo (req.reqMethod, req.url, req.headers)
    if HttpGet != req.reqMethod: return
    let dtS = now().format"yy-MM-dd HH:mm:ss"
    echo '[',dtS,"] ",req.hostname," requires ",req.url.path

    let headers = {"Content-type": "text/html; charset=utf-8"}
    await req.respond(Http200, getContent req.url, headers.newHttpHeaders())

  server.listen(port)
  #let port = server.getPort
  echo "listen at ",port.uint16
  while true:
    if server.shouldAcceptRequest():
      await server.acceptRequest(cb)
    else:
      # too many concurrent connections, `maxFDs` exceeded
      # wait 500ms for FDs to be closed
      await sleepAsync(500)

var bPort = Port(
  if paramCount() > 0: paramStr(1).parseInt
  else: 8000
)

waitFor main bPort

