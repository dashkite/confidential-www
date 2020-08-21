import marked from "marked"
import dayjs from "dayjs"
import rtime from "dayjs/plugin/relativeTime"
import {$} from "@dashkite/carbon"
import {create as createRouter} from "@dashkite/oxygen"

ready = (f) ->
  document.addEventListener "DOMContentLoaded", f

dayjs.extend rtime

time = (t) ->
  if t
    dayjs (if isNaN(ms = Number t) then t else ms)
    .fromNow()

isoTime = (t) -> (dayjs t).toISOString()

message = do ({messages} = {}) ->
  (description) ->
    messages ?= await $ "raven-messages"
    messages.enqueue description

markdown = (content) ->
  marked content,
    smartypants: true
    gfm: true
    # TODO figure out how to make permalinks work within components
    # headerIds: true

router = createRouter()

export {ready, time, isoTime, message, markdown, router}
