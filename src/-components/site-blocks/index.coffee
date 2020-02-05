import {Gadget, mixin, tag, bebop, shadow,
  render, properties, events, local} from "panda-play"

import {glob} from "@dashkite/hydrogen"

import {navigate, describe, resource} from "../mixins"
import {smart} from "../combinators"

import template from "./index.pug"

class extends Gadget

  mixin @, [

    tag "site-blocks"

    bebop, shadow, describe, navigate

    resource -> glob @dom.dataset.glob

    render smart template

  ]
