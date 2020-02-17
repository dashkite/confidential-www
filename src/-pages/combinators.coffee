import {tee, flow} from "panda-garden"
import Store from "@dashkite/hydrogen"
import Registry from "@dashkite/helium"
import {resource, properties} from "@dashkite/neon"

parent = tee (context) ->
  context.bindings.parent =
    context.path
    .split "/"
    .slice(0,-1)
    .join "/"

metadata = tee flow [
  resource (context) ->
    cms = Registry.get "cms"
    Store.get cms, index: "path", key: context.path
  properties
    # name: ({data}) -> data.name
    path: ({path}) -> path
    title: ({resource}) -> "Confidential: #{resource.title}"
    url: ({path}) -> window?.location.origin + path
    description: ({resource}) -> resource.summary
    image: -> window?.location.origin + "/logo.png"
]

export {parent, metadata}
