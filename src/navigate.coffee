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
  if (el = e.closest "[href]")? && (url = el.href)?
    {url}

isCurrentLocation = ({url}) -> window.location.href == url

origin = (url) -> (new URL url).origin
isCrossOrigin = ({url}) ->
  if window.location.origin != origin url
    # For non-local URLs, open the link in a new tab.
    window.open url
    true
  else
    false

getAlias = ({url}) ->
  if (match = getAliasKey url)? && (alias = aliases[match.key])?
    url: alias
  else
    {url}

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
    reject isCrossOrigin
    tee browse
  ]

  if root = document
    go [
      events "popstate", window
      tee -> dispatch url: window.location.href
    ]

export {navigate}
