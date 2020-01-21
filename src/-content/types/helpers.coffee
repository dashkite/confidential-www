import {curry} from "panda-garden"

load = curry (extension, path) -> require "../#{path[1..]}.#{extension}"

export {load}
