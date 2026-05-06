; extends

; Split `#pragma` (directive) from its argument (e.g. `once`) — stock queries color the whole line as @keyword.directive.
(preproc_call
  directive: (preproc_directive) @_dir
  argument: (_) @preproc.arg
  (#lua-match? @_dir "^#[ \t]*pragma$"))
