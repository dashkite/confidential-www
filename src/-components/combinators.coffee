import {curry} from "panda-garden"
import {isArray} from "panda-parchment"

# Adapt a template so that it can merge together component facets
smart = curry (template, object) ->

  # facets
  {description, value, view} = object

  # if we don't have a value, do nothing
  # TODO add a loader here?
  if value?

    # build up composite from facets
    r = {}

    # lowest precedence is description
    r[k] = v for k, v of description if description?

    # next is value
    if value?
      # adapt arrays by convention
      if isArray value
        r.results = value
      else
        # don't overwrite with null properties
        r[k] = v for k, v of value when v?

    # view has the highest precedence
    # view may be async
    _view = await view
    # don't overwrite with null properties
    r[k] = v for k, v of _view when v? if _view?

    # invoke template using composite
    template r


# Adapt a template so that it can merge together component facets
determined = curry (template, object) ->

  # facets
  {description, value, view} = object

  # build up composite from facets
  r = {}

  # lowest precedence is description
  r[k] = v for k, v of description if description?

  # next is value
  if value?
    # adapt arrays by convention
    if isArray value
      r.results = value
    else
      # don't overwrite with null properties
      r[k] = v for k, v of value when v?

  # view has the highest precedence
  # view may be async
  _view = await view
  # don't overwrite with null properties
  r[k] = v for k, v of _view when v? if _view?

  # invoke template using composite
  template r

export {smart, determined}
