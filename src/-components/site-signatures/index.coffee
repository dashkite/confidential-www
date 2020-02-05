import {Gadget, mixin, tag, bebop, shadow,
  render, properties, events, local} from "panda-play"
import {dashed} from "panda-parchment"
import {lookup} from "@dashkite/hydrogen"

import {navigate, describe, resource} from "../mixins"
import {smart} from "../combinators"

import template from "./index.pug"

class extends Gadget

  mixin @, [

    tag "site-signatures"

    bebop, shadow, describe, navigate

    resource -> lookup "path", @dom.dataset.path

    render smart template

    properties
      view:
        get: ->
          if @value?
            {parent, category, scope, name} = @value
            if category == "method"
              type = await lookup "path", parent
              scoped:
                switch scope
                  when "class" then type.name
                  when "instance" then dashed type.name


  ]
