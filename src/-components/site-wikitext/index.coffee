import markdown from "marked"

import {Gadget, mixin, tag, bebop, shadow, render, properties} from "panda-play"
import {dashed} from "panda-parchment"

import {lookup, links} from "../../-content/indexer"

import {navigate, describe, resource, queryable} from "../mixins"
import {smart} from "../combinators"

import template from "./index.pug"

markup = do ({filters, apply, key} = {}) ->
  apply = do (filters = {dashed}) ->
    (value, name) -> filters[name] value
  (string, context = {}) ->
    string.replace /\{\{([\s\S]+)\}\}/g, (_, directive) ->
      [key, filters...] = directive.split("|").map (s) -> s.trim()
      filters.reduce apply, context[key]

class extends Gadget

  mixin @, [

    tag "site-wikitext"

    bebop, describe, shadow, queryable, navigate

    resource ->
      links markdown markup @text, await @data

    properties
      data:
        get: ->
          lookup "path", @description.path ? {}
      text:
        get: ->
          @dom
          .querySelector "script"
          .text

    render smart template

  ]
