import markdown from "marked"
import {Gadget, mixin, tag, bebop, shadow,
  render, properties, events, local} from "panda-play"

import {lookup, links} from "../../-content/indexer"

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
        $: (text) -> links markdown text

    render smart template

  ]
