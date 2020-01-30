import "coffeescript/register"

import Path from "path"

import coffee from "coffeescript"
import pug from "jstransformer-pug"
import stylus from "jstransformer-stylus"

import {define, run, glob, read, write,
  extension, copy, transform, watch} from "panda-9000"

import {rmr} from "panda-quill"
import {go, map, wait, tee, reject} from "panda-river"

import {markdown, bundle, serve} from "./helpers"

import "./server"
import "./test"

source = "./src"
target = "./build"

define "default", [ "build", "watch&", "serve&" ]

# TODO allow watch to take multiple paths
define "watch-source",
  watch (Path.resolve source), -> run "build"

define "watch-npm",
  watch (Path.resolve "package-lock.json"), -> run "build"

define "watch", [ "watch-source", "watch-npm" ]

define "build", [ "clean", "html&", "css&", "js&", "images&" ]

define "clean", -> rmr "build"

define "html", ->
  go [
    glob [ "**/*.pug",  "!**/-*/**", "!**/-*" ], source
    wait map read
    map transform pug, filters: {markdown}
    map extension ".html"
    map write target
  ]

define "css", ->

  go [
    glob [ "**/*.styl",  "!**/-*/**", "!**/-*" ], source
    wait map read
    map transform stylus, {}
    map extension ".css"
    map write target
  ]

define "js", -> bundle "./src/index.coffee", "./build"

define "images", ->
  go [
    glob "**/*.{jpg,png,webp,svg,ico,mp4,webm,js}", source
    map copy target
  ]

define "serve",
  serve target,
    files: extensions: [ "html" ]
    logger: "tiny"
    rewrite: verbose: true
    port: 8000
