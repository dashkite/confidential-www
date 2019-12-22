import markdown from "marked"
import {Gadget, mixin, tag, bebop, shadow,
  render, properties, events, local} from "panda-play"

import {lookup, links, glob} from "../../-content/indexer"

import {navigate, describe, resource} from "../mixins"
import {smart} from "../combinators"

import template from "./index.pug"

class extends Gadget

  mixin @, [

    tag "site-type"

    bebop, shadow, describe, navigate

    resource -> lookup @dom.dataset.path

    properties
      view: get: ->
        if @value?
          paths:
            instanceProperties: glob "#{@value.path}/interface/instance/properties/*"
          globs:
            classMethods: "#{@value.path}/interface/class/methods/*"
          $: (text) -> links markdown text

    render smart template

  ]
