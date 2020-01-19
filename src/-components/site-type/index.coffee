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

    resource -> lookup "path", @dom.dataset.path

    properties
      view: get: ->
        if @value?
          globs:
            instanceProperties: "#{@value.path}/interface/instance/properties/*"
            classMethods: "#{@value.path}/interface/class/methods/*"
          $: (text) -> links markdown text

    render smart template

  ]
