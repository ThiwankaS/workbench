; inherits: c — cpp-only rules (shared rules live in queries/c/highlights.scm).

(call_expression
  function: (qualified_identifier
    name: (identifier) @function.call)
  (#set! priority 100))

(function_declarator
  declarator: (qualified_identifier
    name: (identifier) @function)
  (#set! priority 100))

(call_expression
  function: (field_expression
    field: (field_identifier) @function.method.call)
  (#set! priority 100))

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

(field_expression
  (field_expression
    (field_identifier) @variable.member
    (field_identifier) _)
  (field_identifier) @function.method.call
  (#set! priority 100))
