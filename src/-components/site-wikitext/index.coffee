import markdown from "marked"

import {Gadget, mixin, tag, bebop, shadow, render, properties} from "panda-play"

import {links} from "../../-content/indexer"

import {navigate, describe, resource, queryable} from "../mixins"
import {smart} from "../combinators"

class extends Gadget

  mixin @, [

    tag "site-wikitext"

    bebop, describe, queryable, navigate

    resource -> links markdown @markdown

    properties
      markdown: get: ->
        @dom
        .querySelector "script"
        .text

    render smart ({value}) -> value

  ]
