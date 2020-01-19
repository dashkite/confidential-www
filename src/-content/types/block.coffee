import {mix, basic, data, title, content, route} from "./mixins"
import {load} from "./helpers"

class Block
  mix @, [
    basic, title
    route "{/path*}"
    data load "yaml"
    content load "pug"
  ]
