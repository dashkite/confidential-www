::

import {yaml} from "panda-serialize"
import {readFileSync} from "fs"

import transformer from "jstransformer"
import pugTransformer from "jstransformer-pug"
pug = transformer pugTransformer

# can't import local modules for some reason
import MarkdownIt from "markdown-it"
import MarkdownItAnchor from "markdown-it-anchor"

markdown = do (p = undefined) ->
  p = MarkdownIt
    html: true
    linkify: true
    typographer: true
    breaks: true
    quotes: '“”‘’'
  .use MarkdownItAnchor

  (string) -> p.render string


read = (path) -> readFileSync path, encoding: "utf8"
data = yaml read "./src/api/-functions/encrypt/index.yaml"
options = filters: markdown
html = pug.renderFile "./src/api/-functions/encrypt/index.pug", options, data

::
.
  ::
  $$ html.body
  ::
