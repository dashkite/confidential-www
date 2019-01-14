import MarkdownIt from "markdown-it"
import MarkdownItAnchor from "markdown-it-anchor"

markdown = do (p = undefined) ->
  p = MarkdownIt
    html: true
    linkify: true
    typographer: true
    breaks: true
    quotes: '“”‘’'
  .use MarkdownItAnchor

  (string) -> p.render string

export default markdown
