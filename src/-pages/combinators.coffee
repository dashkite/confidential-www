import {tee} from "panda-garden"

parent = tee (context) ->
  context.bindings.parent =
    context.path
    .split "/"
    .slice(0,-1)
    .join "/"

export {parent}
