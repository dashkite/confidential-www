import {isDefined} from "panda-parchment"
import {go, events, map, tee, select, reject} from "panda-river-esm"
import {browse, dispatch} from "@dashkite/oxygen"
import {router} from "./helpers"

# event helpers, adapted from:
# https://github.com/vuejs/vue-router/blob/dev/src/components/link.js

# ensure there's an enclosing link

hasLink = (e) -> (e.path[0]?.closest? "[href]")?

hasKeyModifier = ({altKey, ctrlKey, metaKey, shiftKey}) ->
  metaKey || altKey || ctrlKey || shiftKey

isRightClick = (e) -> e.button? && e.button != 0

isAlreadyHandled = (e) -> e.defaultPrevented

intercept = (event) ->
  event.preventDefault()
  event.stopPropagation()

# extract the element href if it has one
description = (e) ->
  if (el = e.path[0]?.closest? "[href]")? && (url = el.href)?
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
    tee intercept
    map description
    select isDefined
    reject isCurrentLocation
    reject isCrossOrigin
    tee browse router
  ]

  if root = document
    go [
      events "popstate", window
      tee -> dispatch router, url: window.location.href
    ]

export {navigate}
