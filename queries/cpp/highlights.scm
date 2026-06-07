; inherits: c
; Same #pragma argument split as queries/c/highlights.scm (cpp query path is separate on rtp).

(preproc_call
  directive: (preproc_directive) @_dir
  argument: (_) @preproc.arg
  (#lua-match? @_dir "^#[ \t]*pragma$"))
