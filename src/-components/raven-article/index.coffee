import {Gadget, mixin, tag, bebop, shadow,
  render, properties, events, local} from "panda-play"

import {get} from "../../content"

import {navigate, describe, resource} from "../mixins"
import {smart} from "../combinators"

import template from "./index.pug"

class extends Gadget

  mixin @, [

    tag "raven-article"

    bebop, shadow, describe, navigate

    resource -> data = get(@dom.dataset.path)

    render smart template

  ]
