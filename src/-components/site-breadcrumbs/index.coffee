import markdown from "marked"
import {split, isDefined} from "panda-parchment"
import {collect, map, select} from "panda-river-esm"
import {wrap, flow, spread} from "panda-garden"

import {Gadget, mixin, tag, bebop, shadow,
  render, properties, events, local} from "panda-play"

import {find} from "../../-content/indexer"

import {navigate, describe, resource} from "../mixins"
import {smart} from "../combinators"

import template from "./index.pug"

class extends Gadget

  mixin @, [

    tag "site-breadcrumbs"

    bebop, shadow, describe, navigate

    resource ->
      [crumbs..., current] = do flow [
        wrap @dom.dataset.path[1..]
        split "/"
        map find
        select isDefined
        collect
      ]
      {crumbs, current}

    render smart template

  ]
