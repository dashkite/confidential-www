import {mix, basic, data, title, content, route} from "./mixins"

class Block
  mix @, [
    basic, data, title, content
    route "{/path*}"
  ]
