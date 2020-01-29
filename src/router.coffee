import {Router} from "panda-router"
import TemplateParser from "url-template"

router = new Router()
handlers = {}

route = (template, data, handler) ->
  router.add {template, data}
  handlers[data.name] = handler
  router

match = (url) -> router.match url

# TODO we have this redundantly in the navigation too
relative = (url) ->
  if /^[^\/]/.test url
    {pathname, search} = new URL url
    pathname + search
  else
    url

# TODO handle URL description?
dispatch = ({url, name, parameters}) ->
  url ?= link {name, parameters}
  path = relative url
  try
    {data, bindings} = match relative url
  catch error
    console.warn "Failed to match '#{url}'"
    throw error
  try
    handlers[data.name] {path, data, bindings}
  catch error
    console.warn "No handler defined for '#{data.name}'"
    throw error

link = ({name, parameters}) ->
  for route in router.routes
    if route.data.name == name
      return TemplateParser
        .parse route.template
        .expand parameters ? {}

  console.warn "link: no page matching '#{name}'"

push = ({url, name, parameters, state}) ->
  url ?= link {name, parameters}
  window.history.pushState state, "", url

replace = ({url, name, parameters, state}) ->
  url ?= link {name, parameters}
  window.history.replaceState state, "", url

browse = ({url, name, parameters, state}) ->
  url ?= link {name, parameters}
  # pushState will throw if undefined
  try
    push {url, state}
    dispatch {url}
  catch error
    console.warn error
    # For non-local URLs, open the link in a new tab.
    window.open url

export {router, route, match, dispatch, link, push, replace, browse}
