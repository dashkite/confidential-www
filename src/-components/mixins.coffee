import {prepare, ready, property, events, local} from "panda-play"
import {pipe as _pipe, spread} from "panda-garden"
import {navigate as _navigate} from "../navigate"

navigate = ready -> _navigate @root

pipe = spread _pipe

describe = ->

  # convert a dataset into an ordinary object
  get = (dataset) ->
    r = {}
    r[k] = v for k, v of object when v?
    r

  pipe [

    # define a getter that returns an ordinary object
    property description: get: -> get(@dom.dataset)

    # dispatch 'describe' event when we change an attribute
    ready ->
      new MutationObserver (=> @dispatch "describe")
      .observe @dom, attributes: true

  ]

resource = (_get) ->

  get = -> @value = await _get.apply @

  pipe [

    ready get

    events
      activate: local get
      describe: local get

  ]

queryable = prepare ->

  @query =

    element: new Proxy @,
      get: (target, selector) ->
        target.root.querySelector selector

    elements: new Proxy @,
      get: (target, selector) ->
        target.root.querySelectorAll selector

    form: new Proxy @,
      get: (target, name) ->
        target.query.element["[name='#{name}']"]?.value

export {navigate, describe, resource, queryable}
