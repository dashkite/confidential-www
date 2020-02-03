import marked from "marked"
import dayjs from "dayjs"
import rtime from "dayjs/plugin/relativeTime"
import {$} from "panda-play"

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
    # headerIds: true

export {ready, time, isoTime, message, markdown}
