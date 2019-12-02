import {isDefined} from "panda-parchment"
import {go, events, map, tee, select, reject} from "panda-river-esm"
import {browse, dispatch} from "./router"

# event helpers, adapted from:
# https://github.com/vuejs/vue-router/blob/dev/src/components/link.js

# ensure there's an enclosing link

hasLink = (e) -> (e.target?.closest "[href]")?

hasKeyModifier = ({altKey, ctrlKey, metaKey, shiftKey}) ->
  metaKey || altKey || ctrlKey || shiftKey

isRightClick = (e) -> e.button? && e.button != 0

isAlreadyHandled = (e) -> e.defaultPrevented

hasTarget = (e) -> (e.target?.getAttribute "target")?

intercept = (event) ->
  event.preventDefault()
  event.stopPropagation()

# extract the event target
target = (e) -> e.target

# extract the element href if it has one
description = (e) ->
  if (el = e.closest "[href]")?
    if (url = el.href)?
      _url = new URL url
      # TODO: what do we want to call this?
      if _url.host == "resource.dashkite.com"
        name: _pathname[1..] # strip leading /
        parameters: _url.searchParams
      else
        {url}

isCurrentLocation = ({url}) -> window.location.href == url

navigate = (root) ->

  go [
    events "click", root
    select hasLink
    reject hasKeyModifier
    reject isRightClick
    reject isAlreadyHandled
    reject hasTarget
    tee intercept
    map target
    map description
    select isDefined
    reject isCurrentLocation
    tee browse
  ]

  if root = document
    go [
      events "popstate", window
      tee -> dispatch url: window.location.href
    ]

export {navigate}
