import FS from "fs"
import Path from "path"
import jsdom from "jsdom"
import "../-pages"
import {dispatch} from "../router"

{JSDOM} = jsdom
html = FS.readFileSync Path.join __dirname, "..", "..", "preview.html"
dom = new JSDOM html
{window} = dom
{document} = window
global.window = window
global.document = document
require "custom-event-polyfill"
global.CustomEvent = window.CustomEvent
do ->
  await dispatch url: "http://localhost:8000/api/functions/convert"
  console.log dom.serialize()
