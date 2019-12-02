import "./-components"
import {dispatch} from "./router"
import {navigate} from "./navigate"
import {ready, message} from "./helpers"

ready ->
  navigate document
  dispatch url: window.location.href
