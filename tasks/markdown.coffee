import MarkdownIt from "markdown-it"

markdown = do (p = undefined) ->
  p = MarkdownIt
    html: true
    linkify: true
    typographer: true
    breaks: true
    quotes: '“”‘’'

  (string) -> p.render string

export default markdown
