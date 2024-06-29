import std/htmlgen
import std/strformat

const
  HalfBig = "half-big"
  RightAlign = "right-align"

const
  Author = gorge("whoami")

let CopyRight = p(class=RightAlign,
  "by " & Author
)

let Body = body(
  p center p big(class=HalfBig,
      "Happy New Year"
  ),
  CopyRight
)


#let Style = slurp "static.css"

let bgImgUrl = 
  r"static/bg.jpg"

template Tem(s): string = fmt(s,'<','>')

let inStyle = Tem"""
body{
	background-image: url('<bgImgUrl>');
	background-size: 100%;
	height: 100%;
}

.half-big{
	font-size: 25em;
}
.right-align{
	text-align: right;
}
"""

let Html = html(
  head(
    meta(charset="utf-8"),
    title("lit-srv"),
    link(rel="icon", type="image/x-icon", href="/static/favicon.ico"),
    style(inStyle)
  ),
  Body
)

echo Html
    
