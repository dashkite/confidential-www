import Path from "path"
import MarkdownIt from "markdown-it"
import MarkdownItAnchor from "markdown-it-anchor"

import {tee} from "panda-garden"
import {read} from "panda-quill"
import {yaml} from "panda-serialize"

import _transform from "jstransformer"

import http from "http"
import connect from "connect"
import logger from "morgan"
import finish from "finalhandler"
import files from "serve-static"

import {green, red} from "colors/safe"
import Site from "./site"

autolink = (dictionary) ->
  (string) ->
    string.replace /\[([^\]]+)\]\[([^\]]*)\]/g, (match, text, key) ->
      key = text if key == ""
      if (url = dictionary[key])?
        "[#{text}](#{url})"
      else
        "[#{text}](#broken)"

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

# TODO backport into P9K
serve = (path, options) ->
  ->
    {port} = options
    handler = connect()
    if options.logger?
      handler.use logger options.logger
    handler.use files "./build", options.files
    handler.use finish
    http.createServer handler
    .listen port, ->
      console.log green "p9k: server listening on port #{port}"

getInterface = (key, _scope, _category) ->
  result = {}
  if (type = Site.data.api.types[key])?
    for _key, value of type
      {category, scope} = value
      scope ?= "instance"
      if category == _category && scope == _scope
        result[_key] = value
  result

getProperties = (key, scope) -> getInterface key, scope, "property"
getMethods = (key, scope) -> getInterface key, scope, "method"

export {autolink, transform, markdown, serve, getProperties, getMethods}
