import "coffeescript/register"

import FS from "fs"
import Path from "path"
import Crypto from "crypto"

import {define, run, glob, read, write,
  extension, copy, watch} from "panda-9000"

import {pipe} from "panda-garden"
import {exist, rmr} from "panda-quill"
import {go, map, wait, tee} from "panda-river"
import {merge, include, isString, isObject, dashed} from "panda-parchment"
import {yaml} from "panda-serialize"

import h9 from "haiku9"

import {method, has} from "./generics"
import {transform, markdown, template, serve} from "./helpers"
import PugHelpers from "./pug-helpers"

import Site from "./site"

import pug from "jstransformer-pug"
import stylus from "stylus"
import styles from "panda-style"

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
  Site.clean()
  go [
    glob [ "**/*.yaml", "!**/-*/**" ], source
    wait tee read
    tee ({path, source}) ->
      # TODO we end up getting the parent twice
      #      once here and once in set
      #      not sure if there's a way to avoid that
      [ancestors..., _] = Site.keys path
      parent = Site.traverse ancestors
      Site.set path, yaml template source.content, parent
  ]

hash = (string) ->
  Crypto
    .createHash "md5"
    .update string
    .digest "base64"

define "md", ->
  Site.data.content ?= {}
  go [
    glob [ "**/*.md", , "!**/-*/**" ], source
    wait tee read
    tee ({path, source}) ->
      Site.data.content[hash source.content] =
        markdown template source.content, Site.get path
  ]

define "html", ->
  PugHelpers.interface = PugHelpers.typeInterface
  globals = $: include {markdown, template}, Site, PugHelpers, {dashed}
  filters = markdown: (string) -> Site.data.content[hash string] ? ""
  go [
    glob [ "**/*.pug", "!**/-*/**" ], source
    wait tee read
    tee (context) ->
      context.data = merge globals, Site.get context.path
    tee transform pug, {filters}, basedir: source
    tee extension ".html"
    tee write target
  ]

define "css", ->

  render = ({source, target}) ->
    target.content = stylus.render source.content,
      # compress: true
      filename: source.path
      paths: [ styles().path ]

  go [
    glob [ "**/*.styl", "!**/-*/**" ], source
    wait map read
    tee render
    map extension ".css"
    map write target
  ]

# TODO add back CS compilation
define "js", ->

define "h9:publish:staging", -> h9.publish "staging"

define "h9:publish:production", -> h9.publish "production"

define "build", [ "clean", "data", "md", "html&", "css&", "js&", "images&" ]

define "watch", watch source, -> run "build"

define "server",
  serve target,
    files: extensions: [ "html" ]
    logger: "tiny"
    port: 8001

define "default", [ "build", "watch&", "server&" ]

define "link", ->
  link = method "link"

  link.define isObject, (dictionary) ->
    for directory, description of dictionary
      link directory, description

  link.define isString, isObject, (directory, dictionary) ->
    cwd = process.cwd()
    process.chdir directory
    for directory, description of dictionary
      link directory, description
    process.chdir cwd

  link.define isString, isString, (file, target) ->
    # point file to target
    console.log "In [#{process.cwd()}], link [#{file}] to [#{target}]."
    if process.env.force?
      try
        FS.unlinkSync file
    try
      FS.symlinkSync target, file

  go [
    glob "symlinks.yaml", "."
    wait tee read
    tee ({source}) -> link yaml source.content
  ]
