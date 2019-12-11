import {Router} from "panda-router"
import TemplateParser from "url-template"

router = new Router()

route = (template, handler) ->
  router.add template
  router

match = (path) -> router.match path

export {router, route, match}
