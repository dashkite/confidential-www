import {Gadget, mixin, tag, bebop, shadow,
  render, properties, ready, events, local} from "panda-play"

import {navigate} from "../mixins"
import {determined} from "../combinators"

import template from "./index.pug"

class extends Gadget

  mixin @, [

    tag "site-banner"

    bebop, shadow, navigate

    render determined template

  ]
