import MarkdownIt from "markdown-it"
import MarkdownItAnchor from "markdown-it-anchor"

import {tee} from "panda-garden"
import {read} from "panda-quill"

import _transform from "jstransformer"

markdown = do (p = undefined) ->
  p = MarkdownIt
    html: true
    linkify: true
    typographer: true
    breaks: true
    quotes: '“”‘’'
  .use MarkdownItAnchor

  (string) -> p.render string

# TODO backport into P9K
# (the change is passing the data into the transformer)
transform = (transformer, options) ->
  adapter = _transform transformer
  tee ({source, data, target}) ->
    source.content ?= await read source.path
    options.filename = source.path
    result = await adapter.renderAsync source.content, options, data
    target.content = result.body ? ""

export {transform, markdown}
