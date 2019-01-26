import "coffeescript/register"

import {define, run, glob, read, write,
  extension, copy, watch, serve} from "panda-9000"

import {rmr} from "panda-quill"
import {go, map, wait, tee} from "panda-river"
import {merge} from "panda-parchment"
import {yaml} from "panda-serialize"

import h9 from "haiku9"

import {transform, markdown} from "./helpers"
import Site from "./site"

import pug from "jstransformer-pug"
import stylus from "jstransformer-stylus"

process.on 'unhandledRejection', (reason, p) ->
  console.error "Unhandled Rejection:", reason

source = "src"
target = "build"

define "clean", -> rmr target

define "images", ->
  go [
    glob "**/*.{jpg,png,svg,ico,gif}", source
    map copy target
  ]

define "data", ->
  go [
    glob [ "**/*.yaml" ], source
    wait tee read
    tee ({path, source}) ->
      Site.set path,
        yaml source.content
  ]

define "html", ->

  globals =
    $site: Site.data
    $helpers: {markdown}

  go [
    glob [ "**/*.pug", "!**/-*/**" ], source
    wait tee read
    tee (context) ->
      context.data = merge globals, Site.get context.path
    tee transform pug, filters: {markdown}, basedir: source
    tee extension ".html"
    tee write target
  ]

define "css", ->
  go [
    glob [ "**/*.styl", "!**/-*/**" ], source
    wait map read
    map transform stylus, compress: true
    map extension ".css"
    map write target
  ]

# TODO add back CS compilation
define "js", ->

define "h9:publish:staging", -> h9.publish "staging"

define "h9:publish:production", -> h9.publish "production"

define "build", [ "clean", "data", "html&", "css&", "js&", "images&" ]

define "watch", watch source, -> run "build"

define "server",
  serve target,
    files: extensions: [ "html" ]
    logger: "tiny"
    rewrite: true
    port: 8001

define "default", [ "build", "watch&", "server&" ]
