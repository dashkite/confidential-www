load = (extension) ->
  -> require "../#{@source.path[1..]}.#{extension}"

export {load}
