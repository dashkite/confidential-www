import Path from "path"
import {glob, read, write, copy} from "panda-9000"
import {go, map, wait, tee, reject} from "panda-river"
import {loader, fallback, buffer, include, embedded, filters, sandbox, engine} from "biscotti"

import {imagePattern} from "./constants"

Biscotti = (source, intermediate, target) ->
  ->
    _render = engine [
      sandbox: sandbox {require, console}
      loader
        biscotti:
          index: true
          extensions: [ ".biscotti" ]
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
      glob "**/*.biscotti", source
      wait map read
      render
      tee ({source, target}) ->
        {name} = Path.parse source.path
        {ext, name:final} = Path.parse name
        target.name = final
        target.extension = ext
      map write intermediate
    ]

export default Biscotti
