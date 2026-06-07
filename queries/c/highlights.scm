; extends
; Custom query on rtp (see also queries/cpp/highlights.scm).
; Split `#pragma` directive from its argument — stock queries color the whole line one color.
(preproc_call
  directive: (preproc_directive) @_dir
  argument: (_) @preproc.arg
  (#lua-match? @_dir "^#[ \t]*pragma$"))
