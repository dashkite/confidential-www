import {Gadget, mixin, tag, bebop, shadow,
  render, properties, events, local} from "panda-play"

import {find} from "../../-content/indexer"

import {navigate, describe, resource} from "../mixins"
import {smart} from "../combinators"

import template from "./index.pug"

class extends Gadget

  mixin @, [

    tag "raven-article"

    bebop, shadow, describe, navigate

    resource -> find @dom.dataset.key

    render smart template

  ]
