# TODO export from panda-builder?

# Helpers to run external programs
import {spawn} from "child_process"
import {resolve as resolvePath} from "path"
import {w} from "panda-parchment"

print = (_process) ->
  new Promise (resolve, reject) ->
    _process.stdout.on "data", (data) -> process.stdout.write data.toString()
    _process.stderr.on "data", (data) -> process.stderr.write data.toString()
    _process.on "error", (error) ->
      console.error error
      reject()
    _process.on "close", (status) ->
      if status == 0
        resolve()
      else
        reject new Error "child process exited with non-zero status: #{status}"


shell = (str, path) ->
  [command, args...] = w str
  if path
    await print await spawn command, args, cwd: resolvePath process.cwd(), path
  else
    await print await spawn command, args, cwd: resolvePath process.cwd()

log = (message) -> console.error message


export default shell
