extends ../shared/-html/default

block append head
  +google-font("Patua One")
  link(rel="stylesheet" href="./index.css")

block header
  a(href = "/"): h1 Panda Confidential

block main
  h2 API Reference

  ::
  include "./-functions/index.pug.b"
  ::
