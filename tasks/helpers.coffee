import fs from "fs"
import Path from "path"
import {promise} from "panda-parchment"
import {read} from "panda-quill"
import webpack from "webpack"
import markdown from "marked"
import http from "http"
import connect from "connect"
import logger from "morgan"
import finish from "finalhandler"
import rewrite from "connect-history-api-fallback"
import files from "serve-static"
import {green, red} from "colors/safe"

bundle = ({entry, target, mode}) ->

  mode ?= process.env.mode ? "development"

  promise (resolve, reject) ->

    callback = (error, result) ->
      console.error result.toString colors: true
      if error? || result.hasErrors()
        reject error ? result.errors
      else
        fs.writeFileSync "webpack-stats.json", JSON.stringify result.toJson()
        resolve result

    config =
      entry: entry
      stats:
        maxModules: 100
      devtool: if mode == "development" then "inline-source-map"
      mode: mode
      output:
        path: Path.resolve target
        filename: "index.js"
        devtoolModuleFilenameTemplate: (info, args...) ->
          {namespace, resourcePath} = info
          "webpack://#{namespace}/#{resourcePath}"
      module:
        rules: [

          test: /\.pug$/
          use: [
            loader: "pug-loader"
            options: filters: {markdown}

          ]
        ,
          test: /\.coffee$/
          use: [ "coffee-loader" ]
        ,
          test: /\.js$/
          use: [
              "source-map-loader"
            # TODO should we use babel here?
            # ,
            #   loader: "babel-loader"
            #   options:
            #     presets: [ "@babel/preset-env"]

          ]
          enforce: "pre"
        ,
          test: /\.yaml$/
          use: [ "json-loader", "yaml-loader" ]
        ,
          test: /\.md$/
          use: [
              "html-loader"
            ,
              loader: "markdown-loader"
              options:
                smartypants: true
                gfm: true
                # TODO figure out how to make permalinks work within components
                # headerIds: true
          ]
          # use: [ "raw-loader" ]
        ]

      resolve:
        modules: [
          Path.resolve "node_modules"
          # local dev
          # TODO seems like webpack should be able to infer this?
          Path.resolve "..", "page-graph", "node_modules"
          Path.resolve "..", "panda-play", "node_modules"
        ]
        extensions: [ ".js", ".json", ".coffee" ]

      plugins: []

    webpack config, callback

# TODO backport into p9k
serve = (path, options) ->

  ->
    {port} = options
    handler = connect()

    if options.logger?
      handler.use logger options.logger

    # 1. try to find the file based on the URL
    handler.use files path, options.files

    # 2. rewrite the URL and try again
    if options.rewrite?
      handler.use rewrite options.rewrite
    handler.use files path, options.files

    # 3. give up and error out
    handler.use finish

    http.createServer handler
    .listen port, ->
      console.log green "p9k: server listening on port #{port}"

export {markdown, bundle, serve}
