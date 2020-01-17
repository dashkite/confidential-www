import markdown from "marked"
import {Gadget, mixin, tag, bebop, shadow,
  render, properties, events, local} from "panda-play"

import {glob, links} from "../../-content/indexer"

import {navigate, describe, resource} from "../mixins"
import {smart} from "../combinators"

import template from "./index.pug"

class extends Gadget

  mixin @, [

    tag "site-properties"

    bebop, shadow, describe, navigate

    resource -> glob @dom.dataset.glob

    properties
      view: get: ->
        results: wiki @value
        $: (text) -> links markdown text
    render smart template

  ]
