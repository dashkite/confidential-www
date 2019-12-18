import markdown from "marked"
import {split, isDefined} from "panda-parchment"
import {collect, map, select} from "panda-river-esm"
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
      [crumbs..., current] = collect select isDefined,
        map lookup, split "/", @dom.dataset.path
      {crumbs, current}

    render smart template

  ]
