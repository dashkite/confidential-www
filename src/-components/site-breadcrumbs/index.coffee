import markdown from "marked"
import {split} from "panda-parchment"

import {Gadget, mixin, tag, bebop, shadow,
  render, properties, events, local} from "panda-play"

import {find, lookup} from "../../-content/indexer"

import {navigate, describe, resource} from "../mixins"
import {smart} from "../combinators"

import template from "./index.pug"

join = (string, array) -> array.join string
parent = (path) ->
  components = split "/", path
  components.pop()
  if components.length > 1
    join "/", components

class extends Gadget

  mixin @, [

    tag "site-breadcrumbs"

    bebop, shadow, describe, navigate

    resource ->
      path = @dom.dataset.path
      crumbs = []
      current = @dom.dataset.current ? (await lookup "path", path).title
      while (path = parent path)?
        if (target = await lookup "path", path)?
          crumbs.push target
      {crumbs, current}

    render smart template

  ]
