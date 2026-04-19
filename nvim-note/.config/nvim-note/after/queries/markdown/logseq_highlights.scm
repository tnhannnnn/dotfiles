; Logseq task state keywords
; Match the keyword right after a list item marker
((list_item
  (paragraph) @_para
  (#match? @_para "^(TODO|DOING|DONE|LATER|NOW|WAITING|CANCELLED) ")))

; Logseq property lines (key:: value)
; We match inline content that looks like a property
((paragraph) @logseq.property.key
  (#match? @logseq.property.key "^[a-zA-Z][a-zA-Z0-9_-]*::"))

; Block references ((uuid))
((inline) @logseq.block_ref
  (#match? @logseq.block_ref "\\(\\([a-f0-9-]+\\)\\)"))

; Embeds
((inline) @logseq.embed
  (#match? @logseq.embed "\\{\\{embed"))

; Queries
((inline) @logseq.query
  (#match? @logseq.query "\\{\\{query"))

; Tags
((inline) @logseq.tag
  (#match? @logseq.tag "#[a-zA-Z]"))

