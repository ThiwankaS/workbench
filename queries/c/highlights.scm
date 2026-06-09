; extends
; Custom highlights (rtp overrides). See lua/config/theme.lua for colors.

(preproc_call
  directive: (preproc_directive) @_dir
  argument: (_) @preproc.arg
  (#lua-match? @_dir "^#[ \t]*pragma$"))

((identifier) @constant
  (#lua-match? @constant "^[A-Z][A-Z0-9_]+$")
  (#set! priority 110))

(call_expression
  function: (identifier) @function.call
  (#set! priority 100))

(function_declarator
  declarator: (identifier) @function
  (#set! priority 100))

; Member access (see queries/cpp/highlights.scm)
(field_expression
  (identifier) @variable
  (field_identifier) @variable.member
  (#set! priority 108))

(field_expression
  (field_expression
    (identifier) @variable
    (field_identifier) _)
  (field_identifier) @variable.member
  (#set! priority 108))

(field_expression
  (field_expression
    (field_expression
      (identifier) @variable
      (field_identifier) _)
    (field_identifier) _)
  (field_identifier) @variable.member
  (#set! priority 108))
