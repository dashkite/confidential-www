import "./pages"
import "./components"
import "./content"
import {dispatch} from "@dashkite/oxygen"
import {router} from "./helpers"
import {navigate} from "./navigate"
import {ready, message} from "./helpers"

ready ->
  navigate document
  dispatch router, url: window.location.href
