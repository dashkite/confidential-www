import markdown from "marked"
import {first} from "panda-parchment"
import {Gadget, mixin, tag, bebop, shadow,
  render, properties, events, local} from "panda-play"

import {glob} from "@dashkite/hydrogen"

import {navigate, describe, resource} from "../mixins"
import {smart} from "../combinators"

import template from "./index.pug"

class extends Gadget

  mixin @, [

    tag "site-toc"

    bebop, shadow, describe, navigate

    resource -> glob @description.glob

    render smart template

  ]
