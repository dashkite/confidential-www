import markdown from "marked"
import {Gadget, mixin, tag, bebop, shadow,
  render, properties, events, local} from "panda-play"

import {lookup, links} from "../../-content/indexer"

import {navigate, describe, resource} from "../mixins"
import {smart} from "../combinators"

import template from "./index.pug"

class extends Gadget

  mixin @, [

    tag "site-function"

    bebop, shadow, describe, navigate

    resource -> lookup "path", @dom.dataset.path

    render smart template

    properties
      view:
        get: ->
          if @value?
            {parent, scope, name} = @value
            type = await lookup "path", parent
            qname:
              switch scope
                when "class" then "#{type.name}.#{name}"
                when "instance" then "#{type.name}::#{name}"
                else name

  ]
