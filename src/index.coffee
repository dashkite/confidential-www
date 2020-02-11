import "./-pages"
import "./-components"
import "./content"
import {dispatch} from "@dashkite/oxygen"
import {router} from "./-pages/helpers"
import {navigate} from "./navigate"
import {ready, message} from "./helpers"

ready ->
  navigate document
  dispatch url: window.location.href
