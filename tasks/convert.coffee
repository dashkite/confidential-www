import Path from "path"
import {define, glob, read} from "panda-9000"

import {dashed} from "panda-parchment"
import {mkdirp, write} from "panda-quill"
import {go, wait, tee} from "panda-river"
import {yaml} from "panda-serialize"

define "convert", ->

  # go [
  #   glob [ "functions/**/*.yaml", "!functions/{en,de}crypt/**" ], "src/api"
  #   wait tee read
  #   tee (context) ->
  #     {path, source} = context
  #     {directory} = source
  #     {title, signatures, variables, prose, examples} = yaml source.content
  #     data =
  #       name: title
  #       fragment: dashed title
  #       signatures: signatures
  #       variables: variables
  #     await write source.path, yaml data
  #     await write (Path.join directory, "description.md"), prose
  #
  #     if examples?
  #       await mkdirp 0o777, Path.join directory, "examples"
  #       for example in examples
  #         {title, content} = example
  #         name = dashed title
  #         await write (Path.join directory, "examples", "#{name}.md"), content
  # ]

  go [
    glob [ "types/**/*.yaml" ], "src/api"
    wait tee read
    tee (context) ->
      {path, source} = context
      {directory} = source
      {title, prototype, prose, properties, staticMethods, instanceMethods} = yaml source.content

      data =
        name: title
        fragment: dashed title
      directory = Path.join directory, data.fragment
      await mkdirp 0o777, directory
      if prose?
        await write (Path.join directory, "description.md"), prose
      if prototype != false
        data.extends = prototype
      await write (Path.join directory, "index.yaml"), yaml data

      if properties != false
        await do (directory) ->
          directory = Path.join directory, "instance", "properties"
          for name, property of properties
            await mkdirp 0o777, Path.join directory, name
            await write (Path.join directory, name, "index.yaml"), yaml property

      if staticMethods != false
        await do (directory) ->
          directory = Path.join directory, "static", "methods"
          for name, method of staticMethods
            await mkdirp 0o777, Path.join directory, name
            {signatures, variables, prose} = method
            await write (Path.join directory, name, "index.yaml"),
              yaml {signatures, variables}
            if prose?
              await write (Path.join directory, name, "description.md"), prose

      if instanceMethods != false
        await do (directory) ->
          directory = Path.join directory, "instance", "methods"
          for name, method of instanceMethods
            await mkdirp 0o777, Path.join directory, name
            {signatures, variables, prose} = method
            await write (Path.join directory, name, "index.yaml"),
              yaml {signatures, variables}
            if prose?
              await write (Path.join directory, name, "description.md"), prose
  ]
