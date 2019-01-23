import Path from "path"
import {glob, read, write, copy, extension, transform} from "panda-9000"
import {go, map, wait, tee, reject} from "panda-river"
import {loader, fallback, buffer, include, embedded, filters, sandbox, engine} from "biscotti"

import {imagePattern} from "./constants"

import pug from "jstransformer-pug"
import markdown from "./markdown"

Biscotti = (source, intermediate, target) ->
  ->
    _render = engine [
      sandbox: sandbox {require, console, process},
        (globals, unit) ->
          globals.__filename = unit.path
          globals.__dirname = Path.dirname unit.path
      loader
        biscotti:
          index: true
          extensions: [ ".biscotti", ".b" ]
      fallback language: "biscotti"
      do include
      buffer
      embedded "::", "::"
      filters.string
    ]

    render = tee ({source, target}) ->
      target.content = await _render path: source.path

    # Pass through any non-Biscotti, non-image file to the intermediate stage.
    await go [
      glob ["!**/*.{#{imagePattern},biscotti}", "**/*"], source
      map copy intermediate
    ]

    # Render Biscotti templates to the intermediate stage.
    await go [
      glob ["**/*.pug.b", "!**/-*/**"], source
      wait map read
      render
      tee ({source, target}) ->
        {name} = Path.parse source.path
        {ext, name:final} = Path.parse name
        target.name = final
        target.extension = ext
      tee ({source, target}) ->
        source.content = target.content
      map transform pug, filters: {markdown}, basedir: source
      map extension ".html"
      map write target
    ]

export default Biscotti
