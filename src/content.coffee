load = (path) ->
  data = require "./-content/#{path}/index.yaml"
  data.html = require "./-content/#{path}/index.md"
  data

# TODO just POC, not doing much with this yet
# This is the basis for querying the CMS for, say, a list of blog posts
list = ->
  context = require.context "./-content", true, /\.yaml/
  context.keys()

export {load}
