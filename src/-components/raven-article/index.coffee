import {Gadget, mixin, tag, bebop, shadow,
  render, properties, events, local} from "panda-play"

import {get, links} from "../../content"

import {navigate, describe, resource} from "../mixins"
import {smart} from "../combinators"

import template from "./index.pug"

class extends Gadget

  mixin @, [

    tag "raven-article"

    bebop, shadow, describe, navigate

    resource ->
      data = get(@dom.dataset.path)
      data.html ?= links data.render? @
      data
      
    render smart template

  ]
