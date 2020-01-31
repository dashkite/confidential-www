import FS from "fs"
import Path from "path"
import jsdom from "jsdom"
import "./-pages"
# TODO build play for node
# import "./-components"
import {dispatch} from "./router"
import html from "./preview.pug"

{JSDOM} = jsdom
dom = new JSDOM html()
{window} = dom
{document} = window
global.window = window
global.document = document
require "custom-event-polyfill"
global.CustomEvent = window.CustomEvent
preview = (url) ->
  await dispatch {url}
  dom.serialize()

do ->
  # TODO we should get the URL from an lambda event
  console.log await preview "/api/functions/convert"
