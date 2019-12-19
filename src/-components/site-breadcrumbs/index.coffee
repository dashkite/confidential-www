import markdown from "marked"
import {split, isDefined} from "panda-parchment"
import {collect, map, select, go} from "panda-river-esm"
import {wrap, pipe as _pipe, spread} from "panda-garden"
pipe = spread _pipe

import {Gadget, mixin, tag, bebop, shadow,
  render, properties, events, local} from "panda-play"

import {lookup} from "../../-content/indexer"

import {navigate, describe, resource} from "../mixins"
import {smart} from "../combinators"

import template from "./index.pug"

class extends Gadget

  mixin @, [

    tag "site-breadcrumbs"

    bebop, shadow, describe, navigate

    resource ->
      [crumbs..., current] = do pipe [
        wrap @dom.dataset.path[1..]
        split "/"
        map lookup
        select isDefined
        collect
      ]
      {crumbs, current}

    render smart template

  ]
