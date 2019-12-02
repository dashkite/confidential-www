import coffee from "coffeescript"
import {define, watch, glob, read, write, extension} from "panda-9000"
import {rmr} from "panda-quill"
import {go, map, wait, tee, reject} from "panda-river"

import shell from "./shell"
import {bundle} from "./helpers"

define "test:clean", ->
  await rmr "test/build"
  await rmr "test/screenshots"

define "test:build", "test:clean", ->

  await go [
    glob [ "**/*.coffee" ], "test/src"
    wait map read
    tee ({source, target}) ->
      target.content = coffee.compile source.content,
        filename: source.path
        bare: true
        inlineMap: true
        transpile:
          presets: [[
            require.resolve "@babel/preset-env",
              paths: [ process.cwd() ]
            targets: node: "10.12"
          ]]
    map extension ".js"
    map write "test/build"
  ]

  await go [
    glob [ "**/*.yaml" ], "test/src"
    wait map read
    tee ({source, target}) -> target.content = source.content
    map write "test/build"
  ]

define "test", "test:build", ->
  await shell "node test/build/index.js"
