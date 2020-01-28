import markdown from "marked"
import {Gadget, mixin, tag, bebop, shadow,
  render, properties, events, local} from "panda-play"
import {dashed} from "panda-parchment"

import {lookup, links} from "../../-content/indexer"

import {navigate, describe, resource} from "../mixins"
import {smart} from "../combinators"

import template from "./index.pug"

class extends Gadget

  mixin @, [

    tag "site-variables"

    bebop, shadow, describe, navigate

    resource -> lookup "path", @dom.dataset.path

    properties
      view: get: ->
        if @value?
          {parent, category, scope, variables} = @value
          if category == "method" && scope == "instance"
            type = await lookup "path", parent
            variables: [
                name: dashed type.name
                type: "[`#{type.name}`][]"
                description: "An instance of [`#{type.name}`][]."
              ,
                variables...
              ]

    render smart template

  ]
