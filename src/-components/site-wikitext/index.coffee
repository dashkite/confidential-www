import markdown from "marked"

import {Gadget, mixin, tag, bebop, shadow, render, properties} from "panda-play"

import {links} from "../../-content/indexer"

import {navigate, describe, resource, queryable} from "../mixins"
import {smart} from "../combinators"

import template from "./index.pug"

class extends Gadget

  mixin @, [

    tag "site-wikitext"

    bebop, describe, shadow, queryable, navigate

    resource -> links markdown @text

    properties
      text: get: ->
        @dom
        .querySelector "script"
        .text

    render smart template

  ]
