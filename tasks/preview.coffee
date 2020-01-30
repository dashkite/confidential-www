
import coffee from "coffeescript"
import pug from "pug"

import {define, run, glob, read, write,
  extension, copy, transform, watch} from "panda-9000"

import {go, map, wait, tee, reject} from "panda-river"

import {markdown} from "./helpers"

source = "./src"
target = "./build/server"

define "server:build", [ "server:js&", "server:html&" ]

define "server:html", ->
  go [
    glob [ "**/*.pug" ], source
    wait map read
    tee ({source, target}) ->
      target.content = do ->
        code = pug.compileClient source.content,
          filename: source.path
          name: "f"
          filters: {markdown}
        "#{code}\n\nmodule.exports = f"
    # map extension ".js"
    map write target
  ]

define "server:js", ->
  resolve = (path) ->
    require.resolve path, paths: [ process.cwd() ]

  go [
    glob [ "**/*.coffee" ], source
    wait map read
    tee ({source, target}) ->
      target.content = coffee.compile source.content,
        bare: true
        inlineMap: true
        filename: source.path
        transpile:
          presets: [[
            resolve "@babel/preset-env"
            targets: node: "13.6"
          ]]
    map extension ".js"
    map write target



  ]
