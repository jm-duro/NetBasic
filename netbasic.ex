include std/filesys.e
include std/convert.e
include std/search.e
include std/io.e
include std/text.e
include std/error.e

-- needed for internal routines --
include std/console.e
include std/os.e
----------------------------------

include lib/_debug_.e
include lib/_types_.e
include lib/_search_.e
include lib/_sequence_.e
include lib/_file_.e
include lib/_stack_.e
include lib/_curl_constants_.e
include lib/_curl_.e
include lib/_ssh2_.e
include lib/_telnet2_.e
include webdriver.e
include libraries.e
include process.e

constant
  App = "Net Basic",
  Ver = "0.8.2"

constant
  MAX_STACK_DEPTH = 20

constant
  ASSIGNMENT_OPERATORS   = {"=", "-=", "+=", "*=", "/=", "&="},
  MATHEMATICAL_OPERATORS = {"+","-","*","/","^","%", "mod", "div"},
  BINARY_OPERATORS       = {"&", "|", "~", "#"},
  COMPARISON_OPERATORS   = {"<", ">", "==", "!=", "<=", ">="},
  LOGICAL_OPERATORS      = {"!", "&&", "||", "and", "or", "xor", "not"}

constant SEPARATORS = " +-*/^%&|!~<>()[]{}=,;:'#$?@\"\r\n\t\\"

constant KEYWORDS = {
  {"print",            "print_statement"},
  {"for",              "for_statement"},
  {"end for",          "end_for_statement"},
  {"gosub",            "gosub_statement"},
  {"return",           "return_statement"},
  {"if",               "if_statement"},
  {"elsif",            "elsif_statement"},
  {"else",             "else_statement"},
  {"end if",           "end_if_statement"},
  {"while",            "while_statement"},
  {"end while",        "end_while_statement"},
  {"label",            "label_statement"},
  {"include",          "include_statement"}
}

-- built-in
-- built-in functions included by default
constant BUILT_IN_FUNCS = {
-- Abort execution of the program.
  {PROC, "abort", {INTEGER}},

-- Adds an object at the end of a sequence.
  {FUNC, "append", {SEQUENCE, OBJECT}},

-- Return an angle with tangent equal to argument.
  {FUNC, "arctan", {OBJECT}},

-- Return 1 if argument is an atom else return 0.
  {FUNC, "atom", {OBJECT}},

-- Clear the screen using the current background color.
  {PROC, "clear_screen", {}},

-- Return 0 if objects x1 and x2 are identical, 1 if x1 is greater than x2, -1 if x1 is less than x2.
  {FUNC, "compare", {OBJECT, OBJECT}},

-- Return the cosine of argument (in radians).
  {FUNC, "cos", {OBJECT}},

-- Return a sequence with date and time information.
  {FUNC, "date", {}},

-- Return 1 if Euphoria objects are the same else return 0.
  {FUNC, "equal", {OBJECT, OBJECT}},

-- Find and object as an element of a sequence.
  {FUNC, "find", {OBJECT, SEQUENCE}},

-- Find and object as an element of a sequence starting at defined index.
  {FUNC, "find_from", {OBJECT, SEQUENCE, INTEGER}},

-- Return the greatest integer less than or equal to argument.
  {FUNC, "floor", {OBJECT}},

-- Return the key that was pressed by the user, without waiting.
  {FUNC, "get_key", {}},

-- Get the next character (byte) from stream.
  {FUNC, "getc", {INTEGER}},

-- Return the value of an environment variable.
  {FUNC, "getenv", {SEQUENCE}},

-- Get the next line from stream including end of line.
  {FUNC, "gets", {INTEGER}},

-- Return 1 if argument is an integer else return 0.
  {FUNC, "integer", {OBJECT}},

-- Return the length of a sequence.
  {FUNC, "length", {SEQUENCE}},

-- Return the natural logarithm of argument.
  {FUNC, "log", {OBJECT}},

-- Match a sequence against some slice of another one.
  {FUNC, "match", {SEQUENCE, SEQUENCE}},

-- Match a sequence against some slice of another one starting at defined index.
  {FUNC, "match_from", {SEQUENCE, SEQUENCE, INTEGER}},

-- Opens a stream.
  {FUNC, "open", {SEQUENCE, SEQUENCE}},

-- Indicates the platform that the program is being executed on.
  {FUNC, "platform", {}},

-- Set the cursor to specified line and column.
  {PROC, "position", {INTEGER, INTEGER}},

-- Raise first argument to the power of second one.
  {FUNC, "power", {OBJECT, OBJECT}},

-- Adds an object at the beginning of a sequence.
  {FUNC, "prepend", {SEQUENCE, OBJECT}},

-- Print an object x with braces { , , , } to show the structure.
  {PROC, "print", {INTEGER, OBJECT}},

-- Print an object to a stream using a format string.
  {PROC, "printf", {INTEGER, SEQUENCE, OBJECT}},

-- Output a single byte (atom) or sequence of bytes to a stream.
  {PROC, "puts", {INTEGER, SEQUENCE}},

-- Return a random integer from 1 to argument value.
  {FUNC, "rand", {OBJECT}},

-- Compute the remainder after dividing first argument by second one.
  {FUNC, "remainder", {OBJECT, OBJECT}},

-- Create a sequence of an object repeated specified times.
  {FUNC, "repeat", {OBJECT, INTEGER}},

-- Return 1 if argument is a sequence else return 0.
  {FUNC, "sequence", {OBJECT}},

-- Return the sine of argument (in radians).
  {FUNC, "sin", {OBJECT}},

-- Print an object to a sequence using a format string.
  {FUNC, "sprintf", {SEQUENCE, OBJECT}},

-- Calculate the square root of argument.
  {FUNC, "sqrt", {OBJECT}},

-- Pass a command to the OS command interpreter.
  {PROC, "system", {SEQUENCE, INTEGER}},

-- Run .EXE and .COM programs
  {FUNC, "system_exec", {SEQUENCE, INTEGER}},

-- Return the tangent of argument (in radians).
  {FUNC, "tan", {OBJECT}},

-- Return the number of seconds since some fixed point in the past.
  {FUNC, "time", {}}
}

constant LIBRARIES = {
  {"get",       GET_CONSTS,  GET_FUNCS},
  {"webdriver", {},          WD_FUNCS},
  {"ssh2",      {},          SSH2_FUNCS},
  {"curl",      {},          CURL_FUNCS},
  {"telnet",    {},          TELNET_FUNCS}
}

constant OBJECT_TYPES = {
  "INTEGER", "ATOM", "STRING", "CHAR", "SEQUENCE", "IDENTIFIER", "VARIABLE",
  "ROUTINE", "SEPARATOR", "ASSIGNMENT", "MATHEMATICAL", "BINARY", "COMPARISON",
  "LOGICAL", "CONSTANT"
}

-- last object type
constant
  NULL         = 0,
  INTEGER      = 1,
  ATOM         = 2,
  STRING       = 3,
  CHAR         = 4,
  SEQUENCE     = 5,
  IDENTIFIER   = 6,
  VARIABLE     = 7,
  ROUTINE      = 8,
  SEPARATOR    = 9,
  ASSIGNMENT   = 10,
  MATHEMATICAL = 11,
  BINARY       = 12,
  COMPARISON   = 13,
  LOGICAL      = 14,
  CONSTANT     = 15

constant
  LIB_NAME=1, LIB_CONSTS=2, LIB_FUNCS=3

constant
  VAR_NAME=1, VAR_TYPE=2, VAR_VALUE=3

constant
  CONST_NAME=1, CONST_VALUE=2

constant
  OBJ_TYPE=1, OBJ_VALUE=2

sequence program, line, buffer, op
integer pos, lg

integer  for_stack, gosub_stack, block_stack, scan_stack, lineNum, index
object current_token

sequence variables, constants, sessionId
variables = {}
sessionId = {}
constants = {}

sequence builtin_routines, builtin_list
builtin_routines = {}
builtin_list = {}

sequence jumps
jumps = {}

integer f_out
f_out = 0

--------------------------------------------------------------------------------

integer rtn_id
 function identifyInstruction(sequence path, integer level, integer n, object x)
  -- printf(f_debug, "  path: '%s', level: %d, n: %d, x: %s\n", {path, level, n, object_dump(x)})
  if level = 2 then
    if    n = 1 then return sprintf("TYPE (%s)", {OBJECT_TYPES[x]})
    elsif n = 2 then return "VALUE"
    end if
  end if
  return sprintf("%d",n)
end function
rtn_id = routine_id("identifyInstruction")

--------------------------------------------------------------------------------

function is_char(sequence var)
  -- log_puts("is_char(" & object_dump(var) & ")\n")
  if is_string(var) and (length(var) = 3) and
     (var[1] = #27) and  (var[3] = #27) then
    return 1
  else
    return 0
  end if
end function

--------------------------------------------------------------------------------

function is_variable(sequence var)
  -- log_puts("is_variable(" & object_dump(var) & ")\n")
  return find_in_array(var, variables, {})
end function

--------------------------------------------------------------------------------

procedure set_variable(sequence var, object value)
  integer varnum

  -- log_puts("set_variable(" & var & ", " & object_dump(value) & ")\n")
  if length(var) = 0 then
    error_message("set_variable: empty variable name!\n", 1)
  end if
  if not is_identifier(var) then
    error_message("set_variable: '" & var & "' is not a valid identifier!\n", 1)
  end if
  varnum = is_variable(var)
  if varnum then
    variables[varnum][VAR_VALUE] = value
  else
    if integer(value) then
      variables = append(variables, {var, INTEGER, value})
    elsif atom(value) then
      variables = append(variables, {var, ATOM, value})
    elsif is_char(value) then
      variables = append(variables, {var, CHAR, value})
    elsif is_string(value) then
      variables = append(variables, {var, STRING, value})
    elsif is_variable(value) then
      variables = append(variables, {var, VARIABLE, value})
    else
      variables = append(variables, {var, SEQUENCE, value})
    end if
 end if
  op = ""
end procedure

--------------------------------------------------------------------------------

function get_variable(sequence var)
  -- log_puts("get_variable(" & object_dump(var) & ")\n")
  if not is_identifier(var) then
    error_message("get_variable: '" & var & "' is not a valid identifier!\n", 1)
  end if
  if not is_variable(var) then
    error_message("get_variable: '" & var & "' is not a known variable!\n", 1)
  end if
  return vlookup(var, variables, VAR_NAME, VAR_VALUE)
end function

--------------------------------------------------------------------------------

function variable_type(sequence var)
  -- log_puts("variable_type(" & object_dump(var) & ")\n")
  if not is_identifier(var) then
    error_message("variable_type: '" & var & "' is not a valid identifier!\n", 1)
  end if
  if not is_variable(var) then
    error_message("variable_type: '" & var & "' is not a known variable!\n", 1)
  end if
  return vlookup(var, variables, VAR_NAME, VAR_TYPE)
end function

--------------------------------------------------------------------------------

function is_constant(sequence var)
  -- log_puts("is_constant(" & object_dump(var) & ")\n")
  return find_in_array(var, constants, {})
end function

--------------------------------------------------------------------------------

function get_constant(sequence var)
  -- log_puts("get_constant(" & object_dump(var) & ")\n")
  if not is_identifier(var) then
    error_message("get_constant: '" & var & "' is not a valid identifier!\n", 1)
  end if
  if not is_constant(var) then
    error_message("get_constant: '" & var & "' is not a known constant!\n", 1)
  end if
  return vlookup(var, constants, CONST_NAME, CONST_VALUE)
end function

------------------------------------------------------------------------------

function split_params(sequence str)
  sequence splitted, s
  integer i, n

  -- log_puts("split_params(" & object_dump(str) & ")\n")
  splitted = {}
  s = ""
  i = 0
  while i < length(str) do
    i += 1
    if find(str[i], "{\"'") then
      n = find_matching(str[i], str, i+1)
      s &= str[i..n]
      i = n
    elsif str[i] = ',' then
      splitted = append(splitted, trim(s))
      s = ""
    else
      s &= str[i]
    end if
  end while
  if length(s) then
    splitted = append(splitted, trim(s))
  end if
  return splitted
end function

--------------------------------------------------------------------------------

function is_parsed(sequence s)
  -- log_puts("is_parsed(" & object_dump(s) & ")\n")
  if length(s) != 2 then return 0 end if
  if not integer(s[1]) then return 0 end if
  return 1
end function

--------------------------------------------------------------------------------

function is_parsed_sequence(sequence s)
  -- log_puts("is_parsed_sequence(" & object_dump(s) & ")\n")
  for i = 1 to length(s) do
    if atom(s[i]) then return 0 end if
    if not is_parsed(s[i]) then return 0 end if
  end for
  return 1
end function

------------------------------------------------------------------------------

function get_object(object parsed)
  sequence splitted

  -- log_puts("get_object(" & object_dump(parsed) & ")\n")
  if parsed[OBJ_TYPE] = SEQUENCE then
    -- log_puts("get_object: SEQUENCE\n")
    splitted = split_params(parsed[OBJ_VALUE]) -- [2..$-1])
    -- analyze_object(splitted, "get_object: splitted", f_debug)
    if length(splitted) then
      return splitted
    else
      return {}
    end if
  elsif find(parsed[OBJ_TYPE], {INTEGER, ATOM, STRING, CHAR}) then  -- 1,2,3,4
    -- log_puts("get_object: INTEGER, ATOM, STRING or CHAR\n")
    return parsed[OBJ_VALUE]
  elsif parsed[OBJ_TYPE] = VARIABLE then  -- 7
    -- log_puts("get_object: VARIABLE\n")
    return get_variable(parsed[OBJ_VALUE])
  elsif parsed[OBJ_TYPE] = CONSTANT then  -- 7
    -- log_puts("get_object: CONSTANT\n")
    return get_constant(parsed[OBJ_VALUE])
  else
    -- log_puts("get_object: UNKNOWN\n")
    error_message("get_object: Can't manage type for '" & object_dump(parsed) & "'!\n", 1)
  end if
end function

--------------------------------------------------------------------------------

function rebuild_parsed_string(sequence parsed)
  sequence result

  -- log_puts("rebuild_parsed_string(" & object_dump(parsed) & ")\n")
  result = ""
  for i = 1 to length(parsed) do
    if not is_parsed(parsed[i]) then
      error_message(sprintf("rebuild_parsed_string: '%s' is not a parsed object!\n",
                    object_dump(parsed[i])), 1)
    end if
    if parsed[i][OBJ_TYPE] = VARIABLE then  -- 7
      result &= " " & parsed[i][OBJ_VALUE]
    elsif parsed[i][OBJ_TYPE] = CONSTANT then  -- 7
      result &= " " & parsed[i][OBJ_VALUE]
    else
      result &= " " & object_dump(parsed[i][OBJ_VALUE])
    end if
  end for
  if length(result) then result = remove(result, 1, 1) end if
  return result
end function

--------------------------------------------------------------------------------

function search_parsed_by_type(sequence s, sequence parsed)
  -- log_puts("search_parsed_by_type(" & s & ", " & object_dump(parsed) & ")\n")
  for i = 1 to length(parsed) do
    if not is_parsed(parsed[i]) then
      error_message(sprintf("search_parsed_by_type: '%s' is not a parsed object!\n",
                    object_dump(parsed[i])), 1)
    end if
    if equal(s, parsed[i][OBJ_TYPE]) then return i end if
  end for
  return 0
end function

--------------------------------------------------------------------------------

function search_parsed_by_value(sequence s, sequence parsed)
  -- log_puts("search_parsed_by_value(" & s & ", " & object_dump(parsed) & ")\n")
  for i = 1 to length(parsed) do
    if not is_parsed(parsed[i]) then
      error_message(sprintf("search_parsed_by_value: '%s' is not a parsed object!\n",
                    object_dump(parsed[i])), 1)
    end if
    if equal(s, parsed[i][OBJ_VALUE]) then return i end if
  end for
  return 0
end function

--------------------------------------------------------------------------------

function is_routine(sequence s)
  -- log_puts("is_routine(" & object_dump(s) & ")\n")
  if (length(s) < 3) or (length(s) > 4) then return 0 end if
  if not is_parsed_sequence(s) then return 0 end if
  if s[1][OBJ_TYPE] != ROUTINE then return 0 end if
  if not equal(s[2][OBJ_VALUE], "(") then return 0 end if
  if not equal(s[$][OBJ_VALUE], ")") then return 0 end if
  if find(s[1][OBJ_VALUE], builtin_routines) then
    return 1
  elsif find(s[1][OBJ_VALUE], additional_routines) then
    return 1
  else
    return 0
  end if
end function

--------------------------------------------------------------------------------

function evaluate(object ref, sequence op, object n)
  sequence s

  -- log_puts("evaluate(" & object_dump(ref) & ", '" & op & "', " &
  --          object_dump(n) & ")\n")
  if find(op, {"+","-","/","^","%","&&","||","|","~","==","!=","<=",">=",
               "!","#","<",">","and","or","xor","not", "mod", "div"}) then
    if not (atom(ref) and atom(n)) then
      error_message("evaluate: '" & op & "' operates on atoms only!\n", 1)
    end if
  end if
  if equal(op, "+") then
    return (ref + n)
  elsif equal(op, "-") then
    return (ref - n)
  elsif equal(op, "*") then
    if atom(ref) and atom(n) then
      return (ref * n)
    elsif is_string(ref) and atom(n) then
      s = ""
      for i = 1 to n do
        s &= ref
      end for
      return s
    else
      error_message("Cannot evaluate: '*' expression!\n", 1)
    end if
  elsif equal(op, "/") then
    return (ref / n)
  elsif equal(op, "^") then
    return power(ref, n)
  elsif equal(op, "div") then
    return floor(ref/n)
  elsif equal(op, "mod") then
    return remainder(ref, n)
  elsif equal(op, "%") then
    return remainder(ref, n)
  elsif equal(op, "&") then
    if atom(ref) and atom(n) then
      return and_bits(ref, n)
    elsif is_string(ref) and is_string(n) then
      return ref & n
    elsif is_string(ref) and atom(n) then
      return ref & {n}
    else
      error_message("Cannot evaluate: '&' expression!\n", 1)
    end if
  elsif equal(op, "|") then
    return or_bits(ref, n)
  elsif equal(op, "~") then
    return not_bits(n)
  elsif equal(op, "#") then
    return xor_bits(ref, n)
  elsif equal(op, "<") then
    return (ref < n)
  elsif equal(op, ">") then
    return (ref > n)
  elsif equal(op, "&&") then
    return (ref and n)
  elsif equal(op, "||") then
    return (ref or n)
  elsif equal(op, "!") then
    return not n
  elsif equal(op, "and") then
    return (ref and n)
  elsif equal(op, "or") then
    return (ref or n)
  elsif equal(op, "not") then
    return (not n)
  elsif equal(op, "xor") then
    return ((ref and not n) or (not ref and n))
  elsif equal(op, "==") then
    return (ref = n)
  elsif equal(op, "!=") then
    return (ref != n)
  elsif equal(op, "<=") then
    return (ref <= n)
  elsif equal(op, ">=") then
    return (ref >= n)
  else
    error_message("Unknown operator!\n", 1)
  end if
end function

--------------------------------------------------------------------------------

function find_closing(sequence c, sequence s, integer from)
  integer n
  sequence e

  -- log_printf("find_closing(%s, %s, %d)\n", {c, object_dump(s), from})
  e = " "
  if equal(c, "(") then
    e = ")"
  elsif equal(c, "[") then
    e = "]"
  elsif equal(c, "{") then
    e = "}"
  elsif equal(c, "<") then
    e = ">"
  elsif equal(c, "\"") then
    e = "\""
  end if

  n = 0
  for i = from to length(s) do
--log_printf("  i = %d\n", {i})
    if equal(s[i][OBJ_VALUE], c) then n += 1 end if
    if equal(s[i][OBJ_VALUE], e) then n -= 1 end if
    if n = 0 then return i end if
  end for
  return 0
end function

--------------------------------------------------------------------------------

function expression(sequence s)
  integer i, n
  sequence op
  object exp, result
  integer objectType
  object objectValue

  -- log_puts("expression(" & object_dump(s) & ")\n")
  -- analyze_object({s}, "expression: s", f_debug, rtn_id)
  result = 0
  if is_parsed(s) then
    -- log_puts("expression: parsed_item\n")
    objectType  = s[OBJ_TYPE]
    objectValue = s[OBJ_VALUE]
    if (objectType = INTEGER) or (objectType = ATOM) then  -- 1, 2
      -- log_puts("expression: number\n")
      return objectValue
    elsif objectType = STRING then  -- 3
      -- log_puts("expression: string\n")
      return objectValue
    elsif objectType = CHAR then  -- 4
      -- log_puts("expression: char\n")
      return objectValue
    elsif objectType = VARIABLE then  -- 7
      -- log_puts("expression: variable\n")
      return get_variable(objectValue)
    elsif objectType = CONSTANT then  -- 7
      -- log_puts("expression: constant\n")
      return get_constant(objectValue)
    elsif objectType = SEQUENCE then  -- 5
      -- log_puts("expression: sequence\n")
      return { expression(s[1]) }
    else
      error_message("Unexpected type " & OBJECT_TYPES[objectType] & "!\n", 1)
    end if
  end if
  i = 1
  op = ""
  if not is_parsed_sequence(s) then
    error_message("expression: sequence expected!\n", 1)
  end if
  -- log_puts("expression: parsed_sequence\n")
  while i <= length(s) do
    -- log_printf("expression: i = %d\n", i)
    objectType  = s[i][OBJ_TYPE]
    objectValue = s[i][OBJ_VALUE]
    if equal(objectValue, "(") then
      n = find_closing("(", s, i)
      if n then
        exp = expression(s[i+1..n-1])
        -- log_printf("expression: exp = %g\n", {exp})
        if length(op) then
          result = evaluate(result, op, exp)
        else
          result = exp
        end if
        i = n
      else
        error_message("missing closing parenthesis!\n", 1)
      end if
    else
      -- log_printf("expression: objectValue = '%s'\n", {object_dump(objectValue)})
      if find(objectType, {MATHEMATICAL, BINARY, COMPARISON, LOGICAL}) then  -- 11,12,13,14
        -- log_puts("expression: operator\n")
        op = objectValue
      elsif find(objectType, {INTEGER, ATOM, STRING, CHAR}) then  -- 1,2,3,4
        -- log_puts("expression: number, string or char\n")
        if length(op) then
          result = evaluate(result, op, objectValue)
        else
          result = objectValue
        end if
      elsif objectType = VARIABLE then  -- 7
        -- log_puts("expression: variable\n")
        if length(op) then
          result = evaluate(result, op, get_variable(objectValue))
        else
          result = get_variable(objectValue)
        end if
      elsif objectType = CONSTANT then  -- 15
        -- log_puts("expression: constant\n")
        if length(op) then
          result = evaluate(result, op, get_constant(objectValue))
        else
          result = get_constant(objectValue)
        end if
      elsif objectType = ROUTINE then  -- 8
        log_puts("expression: routine => not managed\n")
      elsif objectType = IDENTIFIER then  -- 6
        log_puts("identifier => not managed\n")
      else
        if length(op) then
          result = evaluate(result, op, expression(s[i]))
        else
          result = expression(s[i])
        end if
--        error_message("Illegal expression "
--                      & rebuild_parsed_string(s) & "!\n", 1)
      end if
    end if
    i += 1
  end while
  -- analyze_object(result, "expression", f_debug)
  return result
end function

--------------------------------------------------------------------------------

function jump_line_index(integer l, integer idx)
  sequence msg

  -- log_printf("jump_line_index(%d, %d)\n", { l, idx})
  if (l < 1) or (l > length(program)) then
    msg = sprintf("jump_line_index: lineNum %d not found!\n", l)
    error_message(msg, 1)
  end if
  lineNum = l
  if (idx < 1) or (idx > length(program[l])) then
    msg = sprintf("jump_line_index: idx %d not found!\n", idx)
    error_message(msg, 1)
  end if
  index = idx
  return program[lineNum][index]
end function

-----------------------------------------------------------------------------

-- compares program code to a template
-- returns differences
function compare_elements(sequence template, sequence code)
  sequence result, exact
  integer lgc, lgt, c, t, delta1, delta2, templateInCode, codeInTemplate
  sequence s1, s2

  -- log_puts("compare_elements(" & object_dump(template) & ", " &
  --           object_dump(code) & ")\n")
  lgc = length(template)
  lgt = length(code)
  result = {}

  c = 1
  t = 1
  exact = {0, 0}
  while (c <= lgc) and (t <= lgt) do
--log_printf("c = %d '%s' - t = %d '%s'\n",
--       {c, template[c], t, code[t]})
    if exact[1] then
      codeInTemplate = find_from(code[t], template, exact[1])
    else
      codeInTemplate = find(code[t], template)
    end if
    if exact[2] then
      templateInCode = find_from(template[c], code, exact[2])
    else
      templateInCode = find(template[c], code)
    end if
    if codeInTemplate then
      s1 = template[codeInTemplate]
    else
      s1 = ""
    end if
    if templateInCode then
      s2 = code[templateInCode]
    else
      s2 = ""
    end if
--log_printf("codeInTemplate = %d '%s' - templateInCode = %d '%s'\n", {codeInTemplate,s1,templateInCode,s2})
    if (templateInCode * codeInTemplate) = 0 then
      if templateInCode then
--        log_puts("a\n")
        for i = t to templateInCode-1 do
          result = append(result, {'+', 0, i})
          t += 1
        end for
        exact = {c, templateInCode}
        result = append(result, {'=', c, templateInCode})
      elsif codeInTemplate then
--        log_puts("b\n")
        for i = c to codeInTemplate-1 do
          result = append(result, {'-', i, 0})
          c += 1
        end for
        exact = {codeInTemplate, t}
        result = append(result, {'=', codeInTemplate, t})
      else
--        log_puts("c\n")
        result = append(result, {'#', c, t})
      end if
    else
      delta1 = codeInTemplate - exact[1]
      delta2 = templateInCode - exact[2]
      if delta2 > delta1 then
--        log_puts("d\n")
        for i = c to codeInTemplate-1 do
          result = append(result, {'#', c, t})
          c += 1
        end for
        exact = {codeInTemplate, t}
        result = append(result, {'=', codeInTemplate, t})
      elsif delta1 > delta2 then
--        log_puts("e\n")
        for i = t to templateInCode-1 do
          result = append(result, {'#', c, t})
          t += 1
        end for
        exact = {c, templateInCode}
        result = append(result, {'=', c, templateInCode})
      else
--        log_puts("f\n")
        exact = {c, t}
        result = append(result, {'=', c, t})
      end if
    end if
    c += 1
    t += 1
--log_printf("exact = %s\n", {sprint(exact)})
  end while
  while c <= lgc do
    result = append(result, {'-', c, 0})
    c += 1
  end while
  while t <= lgt do
    result = append(result, {'+', 0, t})
    t += 1
  end while
  return result
end function

------------------------------------------------------------------------------

function get_result_item(sequence id, sequence res, object default)
  integer objectType
  object  objectValue, result

  -- log_puts("get_result_item(" & id & ", " & object_dump(res) & ", " &
  --           object_dump(default) & ")\n")
  result = default
  for i = 1 to length(res) do
    if equal(res[i][1], id) then
      -- analyze_object(res[i][2], sprintf("get_result_item: res[%d][2]", i), f_debug)
      if length(res[i][2]) = 1 then
        if is_parsed(res[i][2][1]) then
          objectValue  = res[i][2][1][OBJ_VALUE]
          objectType  = res[i][2][1][OBJ_TYPE]
          objectValue = res[i][2][1][OBJ_VALUE]
        else
          error_message(sprintf("get_result_item: '%s' is not a parsed object!\n",
                                object_dump(res[i][2][1])), 1)
        end if
        if find(objectType, {MATHEMATICAL, BINARY, COMPARISON, LOGICAL}) then
          -- log_puts("get_result_item: operator\n")
          op = objectValue
        elsif find(objectType, {INTEGER, ATOM, STRING, CHAR}) then
          -- log_puts("get_result_item: number, string or char\n")
          if length(op) then
            result = evaluate("", op, objectValue)
          else
            result = objectValue
          end if
        elsif objectType = VARIABLE then
          -- log_puts("get_result_item: variable\n")
          if length(op) then
            result = evaluate("", op, get_variable(objectValue))
          else
            result = get_variable(objectValue)
          end if
        elsif objectType = CONSTANT then  -- 15
          -- log_puts("get_result_item: constant\n")
          if length(op) then
            result = evaluate("", op, get_constant(objectValue))
          else
            result = get_constant(objectValue)
          end if
        elsif objectType = ROUTINE then
          log_puts("get_result_item: routine => not managed\n")
        elsif objectType = IDENTIFIER then
          -- log_puts("get_result_item: identifier\n")
          result = objectValue
        else
          error_message("get_result_item: Don't know what to do with "
                        & rebuild_parsed_string(res[i][2]) & "!\n", 1)
        end if
      else                                   -- expression
        -- log_puts("get_result_item: expression\n")
        result = expression(res[i][2])
      end if
    end if
  end for
  -- analyze_object(result, "get_result_item", f_debug)
  return result
end function

------------------------------------------------------------------------------

-- analyzes current lineNum according to template
-- returns variable elements
function analyze_syntax(sequence tmpl)
  sequence code, analysis, result, msg, template, filter, var, s
  integer start, stop, c, t, skip, optional

  -- log_puts("analyze_syntax(" & object_dump(tmpl) & ")\n")
  -- manage optional parameters

  template = {}
  filter = {}
  optional = 0
  for i = 1 to length(tmpl) do
    if atom(tmpl[i]) then
      if tmpl[i] = ']' then
        optional = 0
      elsif tmpl[i] = '[' then
        optional = 1
      else
        error_message(sprintf("analyze_syntax: Unknown character %s!\n", tmpl[i]), 1)
      end if
    else
      template = append(template, tmpl[i])
      filter = append(filter, optional)
    end if
  end for
  -- analyze_object(template, "analyze_syntax: template", f_debug)
--  analyze_object(filter, "filter", f_debug)
 -- analysis starts at current lineNum and index
  start = lineNum
  -- if last element of template is variable
  -- last element cannot be optional
  if template[$][1] = '<' then
    -- code ends at the end of current lineNum
    code = program[lineNum][index..$]
    stop = length(program[lineNum])
  else
    -- search last element of the template
    stop = search_parsed_by_value(template[$], program[lineNum][index..$])
    -- if last element of the template found
    if stop then
      -- code ends at last element of the template
      code = program[lineNum][index..stop]
    else
      code = program[lineNum][index..$]
      -- add next lineNum to analyzed code
      lineNum += 1
      index = 1
      while not stop do
        -- if end of program reached
        if lineNum > length(program) then
          -- raise an error
          error_message(sprintf("analyze_syntax: Error on line %d!\n" &
                            "  End of program reached without finding '%s'.\n",
                            {start, template[$]}),
                    1)
        end if
        stop = search_parsed_by_value(template[$], program[lineNum][index..$])
        if not stop then
          code &= program[lineNum]
          lineNum += 1
          index = 1
        end if
      end while
    end if
  end if
  result = {}
  s = {}
  for i = 1 to length(code) do
    s = append(s, code[i][OBJ_VALUE])
  end for
  -- analyze_object(s, "analyze_syntax: s", f_debug)
  if not equal(s[1], template[1]) then
    msg = sprintf("analyze_syntax: template (%s) does not correspond to s (%s)!\n",
                  {template[1], s[1]})
    error_message(msg, 1)
  end if
  analysis = compare_elements(template, s)
  -- analyze_object(analysis, "analysis", f_debug)
  result = {}
  c = 2  -- code index
  t = 2  -- template index
  skip = 0
  for i = 1 to length(analysis) do
    if analysis[i][2] then t = analysis[i][2] end if
    if analysis[i][3] then c = analysis[i][3] end if
    if analysis[i][1] = '=' then
      skip = 0
    elsif analysis[i][1] = '#' then
      if not skip and (template[t][1] = '<') then
        result = append(result, {template[t], {code[c]}})
      else
        skip = 1
        result[$][2] = append(result[$][2], code[c])
      end if
    elsif analysis[i][1] = '+' then
      result[$][2] = append(result[$][2], code[c])
    else
      t = analysis[i][2]
      if not filter[i] then
        msg = sprintf("analyze_syntax: element '%s' not present",
                      {template[t]})
        log_puts(msg & "\n")
      end if
    end if
  end for
  -- analyze_object(result, "analyze_syntax: result", f_debug)
  index = stop
  -- check result
  for i =1 to length(template) do
    -- if variable found
    if sequence(template[i][1]) and (template[i][1][1] = '<') then
      -- if variable is not optional
      if not filter[i] then
        -- check if variable returned
        var = get_result_item(template[i][1], result, "bad")
        if equal(var, "bad") then
          msg = sprintf("analyze_syntax: no %s variable in %s statement!\n",
                        {template[i][1], template[1]})
          error_message(msg, 1)
        end if
        -- check if variable is an identifier
        if equal(template[i][1], "<identifier>") and not is_identifier(var) then
          msg = sprintf("analyze_syntax: identifier expected, got '%s'!\n",
                        {var})
          error_message(msg, 1)
        end if
      end if
    end if
  end for
  -- analyze_object(result, "analyze_syntax", f_debug)
  return result
end function

------------------------------------------------------------------------------

function find_jump(sequence name, sequence id)
  -- log_puts("find_jump()\n")
  for i = 1 to length(jumps) do
    if equal(jumps[i][1], name) and equal(jumps[i][2], id) then
      return i
    end if
  end for
  return 0
end function

------------------------------------------------------------------------------

-- returns next token (sequence) or 0 (atom) if end of program reached
-- updates lineNum and index
function next_token()
  -- log_puts("next_token()\n")
  if index < length(program[lineNum]) then
    index += 1
  else
    lineNum += 1
    index = 1
  end if
  if lineNum <= length(program) then
    return program[lineNum][index]
  else
    return 0
  end if
end function

------------------------------------------------------------------------------

-- returns previous token
-- updates lineNum and index
function previous_token()
  -- log_puts("previous_token()\n")
  if index > 1 then
    index -= 1
  else
    if lineNum > 1 then
      lineNum -= 1
      index = length(program[lineNum])
    else
      return 0
    end if
  end if
  return program[lineNum][index]
end function

------------------------------------------------------------------------------

procedure print_statement()
  sequence result
  object params

  -- log_puts("print_statement()\n")
  result = analyze_syntax({"print", '[', "<parameters>", ']'})
  params = get_result_item("<parameters>", result, "")
  -- analyze_object(params, "params", f_debug)
  if atom(params) then
    printf(1, "%g", {params})
    if f_out then printf(f_out, "%g", {params}) end if
  else
    params = replace_all(params, "\\\"", "\"")
    printf(1, "%s", {params})
    if f_out then printf(f_out, "%s", {dequote(params, {})}) end if
  end if
  puts(1, "\n")
  if f_out then puts(f_out, "\n") end if
end procedure

------------------------------------------------------------------------------

procedure for_statement()
  sequence result, var
  integer from, upto, n
  sequence localVars
  object step

  -- log_puts("for_statement()\n")
  result = analyze_syntax({"for", "<var>", "=", "<from>", "to", "<upto>",
                          '[', "by", "<by>", ']', "do"})
  var = result[1][2][1][OBJ_VALUE]
  -- analyze_object(var, "var", f_debug)
  from = get_result_item("<from>", result, 0)
  set_variable(var, from)
  upto = get_result_item("<upto>", result, 0)
  step = get_result_item("<by>", result, 1)

  n = stack_size(for_stack)
  if (n < MAX_STACK_DEPTH) then
    localVars = sprintf("for-%d", {n+1})
    void = stack_push(for_stack, {"for", {var, from, upto, step}, {lineNum, index}, localVars})
  else
    error_message("for_statement: for stack size exceeded!\n", 1)
  end if
end procedure

------------------------------------------------------------------------------

procedure end_for_statement()
  sequence s
  object var

  -- log_puts("end_for_statement()\n")
  if stack_size(for_stack) > 0 then
    s = stack_last(for_stack, 0)
    var = s[2][1]
    -- analyze_object(get_variable(var), "get_variable(var)", f_debug)
    if get_variable(var)+1 <= s[2][3] then
      set_variable(var, get_variable(var) + 1)
      current_token = jump_line_index(s[3][1], s[3][2])
    else
      void = stack_pop(for_stack, 0)
    end if
  end if
end procedure

------------------------------------------------------------------------------

procedure gosub_statement()
  sequence result
  integer linenum, n
  object lbl

  -- log_puts("gosub_statement()\n")
  result = analyze_syntax({"gosub", "<label>"})
  lbl = get_result_item("<label>", result, 0)
  -- analyze_object(lbl, "label", f_debug)
  n = find_jump("label", lbl)
  if not n then
    error_message("label " & lbl & " not found!\n", 1)
  end if
  linenum = jumps[n][3]
  -- log_printf("gosub_statement: linenum = %d\n", linenum)
  if stack_size(gosub_stack) < MAX_STACK_DEPTH then
    void = stack_push(gosub_stack, {lineNum, index})
    current_token = jump_line_index(linenum, length(program[linenum]))
  else
    log_puts("gosub_statement: gosub stack size exceeded\n")
  end if
end procedure

------------------------------------------------------------------------------

procedure return_statement()
  sequence s

  -- log_puts("return_statement()\n")
  if stack_size(gosub_stack) > 0 then
    s = stack_pop(gosub_stack, 0)
    --analyze_object(s, "s", f_debug)
    current_token = jump_line_index(s[1], s[2])
  else
    log_puts("return_statement: non-matching return\n")
  end if
end procedure

------------------------------------------------------------------------------

procedure if_statement()
  sequence result
  integer n
  object condition

  -- log_puts("if_statement()\n")
  result = analyze_syntax({"if", "<condition>", "then"})
  condition = get_result_item("<condition>", result, 0)
  -- analyze_object(condition, "condition", f_debug)

  n = stack_size(block_stack)
  if (n < MAX_STACK_DEPTH) then
    void = stack_push(block_stack, {"if", condition, {lineNum, index}})
  else
    error_message("if_statement: block stack size exceeded!\n", 1)
  end if

  if not condition then  -- condition not met, skip if zone
    -- log_puts("if_statement: actual if condition not met\n")
    current_token = next_token()
    -- check end of program reached
    if atom(current_token) then return end if
    while not find(current_token[OBJ_VALUE], {"elsif", "else", "end if"}) do
      -- log_puts("if_statement: " & object_dump(current_token[OBJ_VALUE]) & " skipped\n")
      -- get next token
      current_token = next_token()

      -- check end of program reached
      if atom(current_token) then
        error_message("if_statement: end of program reached without end if!\n", 1)
        return
      end if
    end while
    current_token = previous_token()
  else
    -- log_puts("if_statement: actual if condition met\n")
  end if
end procedure

------------------------------------------------------------------------------

procedure elsif_statement()
  sequence result, s
  integer n
  object condition

  -- log_puts("elsif_statement()\n")

  result = analyze_syntax({"elsif", "<condition>", "then"})
  condition = get_result_item("<condition>", result, 0)
  -- analyze_object(condition, "condition", f_debug)

  if stack_size(block_stack) > 0 then
    s = stack_last(block_stack, 0)
    if not find(s[1], {"if", "elsif"}) then
      error_message("elsif_statement: non-matching if/elsif!\n", 1)
    end if
    s = stack_pop(block_stack, 0)
--analyze_object(s, "s", f_debug)
    if s[2] then  -- previous condition met, skip until end if
      -- log_puts("elsif_statement: previous if/elsif condition met\n")
      current_token = next_token()
      -- check end of program reached
      if atom(current_token) then return end if
      while not equal(current_token[OBJ_VALUE], "end if") do
        -- log_puts("elsif_statement: " & object_dump(current_token[OBJ_VALUE]) & " skipped\n")
        -- get next token
        current_token = next_token()
        -- check end of program reached
        if atom(current_token) then
          error_message("elsif_statement: end of program reached without end if!\n", 1)
          return
        end if
      end while
      current_token = previous_token()
    else
      -- log_puts("elsif_statement: previous if/elsif condition not met\n")
    end if
  else
    error_message("elsif_statement: non-matching if/elsif!\n", 1)
  end if

  n = stack_size(block_stack)
  if (n < MAX_STACK_DEPTH) then
    void = stack_push(block_stack, {"elsif", condition, {lineNum, index}})
  else
    error_message("elsif_statement: block stack size exceeded!\n", 1)
  end if

  if not condition then  -- condition not met, skip if zone
    -- log_puts("elsif_statement: actual elsif condition not met\n")
    current_token = next_token()
    -- check end of program reached
    if atom(current_token) then return end if
    while not find(current_token[OBJ_VALUE], {"elsif", "else", "end if"}) do
      -- log_puts("elsif_statement: " & object_dump(current_token[OBJ_VALUE]) & " skipped\n")
      -- get next token
      current_token = next_token()

      -- check end of program reached
      if atom(current_token) then
        error_message("elsif_statement: end of program reached without end if!\n", 1)
        return
      end if
    end while
    current_token = previous_token()
  else
    -- log_puts("elsif_statement: actual elsif condition met\n")
  end if
end procedure

------------------------------------------------------------------------------

procedure else_statement()
  sequence s
  integer n

  -- log_puts("else_statement()\n")
  if stack_size(block_stack) > 0 then
    s = stack_last(block_stack, 0)
    if not find(s[1], {"if", "elsif"}) then
      error_message("else_statement: non-matching if/elsif!\n", 1)
    end if
    s = stack_pop(block_stack, 0)
--analyze_object(s, "s", f_debug)
    if s[2] then  -- condition met, skip else zone
      log_puts("else_statement: previous if/elsif condition met\n")
      current_token = next_token()
      -- check end of program reached
      if atom(current_token) then return end if
      while not equal(current_token[OBJ_VALUE], "end if") do
        -- log_puts(object_dump(current_token[OBJ_VALUE]) & " skipped\n")
        -- get next token
        current_token = next_token()
        -- check end of program reached
        if atom(current_token) then
          error_message("else_statement: end of program reached without end if!\n", 1)
          return
        end if
      end while
      current_token = previous_token()
    else
      -- log_puts("else_statement: previous if/elsif condition not met\n")
    end if
  else
    error_message("else_statement: non-matching if/elsif!\n", 1)
  end if
  n = stack_size(block_stack)
  if (n < MAX_STACK_DEPTH) then
    void = stack_push(block_stack, {"else", {lineNum, index}})
  else
    error_message("else_statement: block stack size exceeded!\n", 1)
  end if
end procedure

------------------------------------------------------------------------------

procedure end_if_statement()
  sequence s

  -- log_puts("end_if_statement()\n")
  if stack_size(block_stack) > 0 then
    s = stack_last(block_stack, 0)
    if not find(s[1], {"if", "elsif", "else"}) then
      error_message("end_if_statement: non-matching if/elsif/else!\n", 1)
    end if
    s = stack_pop(block_stack, 0)
--analyze_object(s, "s", f_debug)
  else
    error_message("end_if_statement: non-matching if/elsif/else!\n", 1)
  end if
end procedure

------------------------------------------------------------------------------

procedure while_statement()
  sequence result
  integer n
  object condition

  -- log_puts("while_statement()\n")
  result = analyze_syntax({"while", "<condition>", "do"})
  condition = get_result_item("<condition>", result, 0)
  -- analyze_object(condition, "condition", f_debug)

  n = stack_size(block_stack)
  if (n < MAX_STACK_DEPTH) then
    void = stack_push(block_stack, {"while", condition, {lineNum-1, length(program[lineNum-1])}})
  else
    error_message("while_statement: block stack size exceeded!\n", 1)
  end if

  if not condition then  -- condition not met, skip while zone
    -- log_puts("while_statement: actual while condition not met\n")
    current_token = next_token()
    -- check end of program reached
    if atom(current_token) then return end if
    while not equal(current_token[OBJ_VALUE], "end while") do
      -- log_puts("while_statement: " & object_dump(current_token[OBJ_VALUE]) & " skipped\n")
      -- get next token
      current_token = next_token()

      -- check end of program reached
      if atom(current_token) then
        error_message("while_statement: end of program reached without end while!\n", 1)
        return
      end if
    end while
    current_token = previous_token()
  else
    -- log_puts("while_statement: actual while condition met\n")
  end if
end procedure

------------------------------------------------------------------------------

procedure end_while_statement()
  sequence s

  -- log_puts("end_while_statement()\n")
  if stack_size(block_stack) > 0 then
    s = stack_last(block_stack, 0)
    if not equal(s[1], "while") then
      error_message("end_while_statement: non-matching while!\n", 1)
    end if
-- analyze_object(s, "s", f_debug)
    if s[2] then  -- condition met, jump to beginning of while zone
      -- log_puts("end_while_statement: previous while condition met\n")
      current_token = jump_line_index(s[3][1], s[3][2])
    else
      -- log_puts("end_while_statement: previous while condition not met\n")
      void = stack_pop(block_stack, 0)
    end if
  else  -- condition not met, continue next lineNum
    error_message("end_while_statement: non-matching while!\n", 1)
  end if
end procedure

------------------------------------------------------------------------------

procedure label_statement()
  -- log_puts("label_statement()\n")
  lineNum += 1
  index = 1
end procedure

------------------------------------------------------------------------------

procedure include_statement()
  sequence result, routines, consts
  object library

  -- log_puts("include_statement()\n")
  result = analyze_syntax({"include", "<library>"})
  -- analyze_object(result, "result", f_debug)
  library = get_result_item("<library>", result, 0)
  -- analyze_object(library, "library", f_debug)
  if atom(library) then
    error_message("no library specified to include!\n", 1)
  end if
  if equal(library, "webdriver") then
ifdef WINDOWS then
    if not is_running("chromedriver.exe") and
       not is_running("java.exe") then
      error_message("no driver is running\n" &
                    "NetBasic networking functions will not work\n", 0)
    else
      wd_init(0)
    end if
elsifdef LINUX then
    if not is_running("chromedriver") and
       not is_running("java") then
      error_message("no driver is running\n" &
                    "NetBasic networking functions will not work\n", 0)
    else
      wd_init(0)
    end if
end ifdef
  end if
  if equal(library, "ssh2") then
    ssh_init()
  end if
  consts = vlookup(library, LIBRARIES, LIB_NAME, LIB_CONSTS, {{"default",{}}})
  for i = 1 to length(consts) do
    constants = append(constants, consts[i])
  end for
  routines = vlookup(library, LIBRARIES, LIB_NAME, LIB_FUNCS, {{"default",{}}})
  for i = 1 to length(routines) do
    routine_list = append(routine_list, routines[i])
    additional_routines = append(additional_routines, routines[i][2])
  end for
  for i = 1 to length(program) do
    for j = 1 to length(program[i]) do
      for k = 1 to length(routines) do
        if equal(program[i][j][OBJ_VALUE], routines[k][2]) and
           not equal(program[i][1][OBJ_VALUE], "include") then
          -- log_puts("found " & routines[k][2] & "\n")
          program[i][j][OBJ_TYPE] = ROUTINE
          -- analyze_object(program[i], "program[i]", f_debug)
        end if
      end for
    end for
  end for
end procedure

--------------------------------------------------------------------------------

procedure run_builtins_proc(sequence fname, object fparams)
  -- log_puts("run_builtins_proc(" & fname & ", " & object_dump(fparams) & ")\n")
  if equal(fname, "abort") then
    abort(fparams)
  elsif equal(fname, "clear_screen") then
    clear_screen()
  elsif equal(fname, "position") then
    position(fparams[1], fparams[2])
  elsif equal(fname, "print") then
    print(fparams[1], fparams[2])
    print(f_out, fparams[2])
  elsif equal(fname, "printf") then
    printf(fparams[1], fparams[2], fparams[3])
    printf(f_out, fparams[2], fparams[3])
  elsif equal(fname, "puts") then
    puts(fparams[1], fparams[2])
    puts(f_out, fparams[2])
  elsif equal(fname, "system") then
    system(fparams[1], fparams[2])
  end if
end procedure

--------------------------------------------------------------------------------

function run_builtins_func(sequence fname, object fparams)
  -- log_puts("run_builtins_func(" & fname & ", " & object_dump(fparams) & ")\n")
  if equal(fname, "append") then
    return append(fparams[1], fparams[2])
  elsif equal(fname, "arctan") then
    return arctan(fparams)
  elsif equal(fname, "atom") then
    return atom(fparams)
  elsif equal(fname, "compare") then
    return compare(fparams[1], fparams[2])
  elsif equal(fname, "cos") then
    return cos(fparams)
  elsif equal(fname, "date") then
    return date()
  elsif equal(fname, "equal") then
    return equal(fparams[1], fparams[2])
  elsif equal(fname, "find") then
    return find(fparams[1], fparams[2])
  elsif equal(fname, "find_from") then
    return find_from(fparams[1], fparams[2], fparams[3])
  elsif equal(fname, "floor") then
    return floor(fparams)
  elsif equal(fname, "get_key") then
    return get_key()
  elsif equal(fname, "getc") then
    return getc(fparams)
  elsif equal(fname, "getenv") then
    return getenv(fparams)
  elsif equal(fname, "gets") then
    return gets(fparams)
  elsif equal(fname, "integer") then
    return integer(fparams)
  elsif equal(fname, "length") then
    return length(fparams)
  elsif equal(fname, "log") then
    return log(fparams)
  elsif equal(fname, "match") then
    return match(fparams[1], fparams[2])
  elsif equal(fname, "match_from") then
    return match_from(fparams[1], fparams[2], fparams[3])
  elsif equal(fname, "open") then
    return open(fparams[1], fparams[2])
  elsif equal(fname, "platform") then
    return platform()
  elsif equal(fname, "power") then
    return power(fparams[1], fparams[2])
  elsif equal(fname, "prepend") then
    return prepend(fparams[1], fparams[2])
  elsif equal(fname, "rand") then
    return rand(fparams)
  elsif equal(fname, "remainder") then
    return remainder(fparams[1], fparams[2])
  elsif equal(fname, "repeat") then
    return repeat(fparams[1], fparams[2])
  elsif equal(fname, "sequence") then
    return sequence(fparams)
  elsif equal(fname, "sin") then
    return sin(fparams)
  elsif equal(fname, "sprintf") then
    return sprintf(fparams[1], fparams[2])
  elsif equal(fname, "sqrt") then
    return sqrt(fparams)
  elsif equal(fname, "system_exec") then
    return system_exec(fparams[1], fparams[2])
  elsif equal(fname, "tan") then
    return tan(fparams)
  elsif equal(fname, "time") then
    return time()
  end if
  return 0
end function

--------------------------------------------------------------------------------

function get_params(sequence s)
  sequence params, sub

  -- log_puts("get_params(" & object_dump(s) & ")\n")
  params = {}
  if length(s) > 3 then
    for i = 3 to length(s)-1 do
      -- analyze_object(s[i], sprintf("s[%d]", i), f_debug)
      if s[i][OBJ_TYPE] = VARIABLE then     -- 7
        params = append(params, get_variable(s[i][OBJ_VALUE]))
      elsif s[i][OBJ_TYPE] = CONSTANT then  -- 15
        params = append(params, get_constant(s[i][OBJ_VALUE]))
      elsif s[i][OBJ_TYPE] = SEQUENCE then  -- 5
        params = append(params, {})
        sub = s[i][OBJ_VALUE]
        for j = 1 to length(sub) do
          if not equal(sub[j][OBJ_VALUE], ",") then
            params[$] = append(params[$], get_object(sub[j]))
          end if
        end for
      elsif not equal(s[i][OBJ_VALUE], ",") then
        params = append(params, s[i][OBJ_VALUE])
      end if
    end for
  end if
  return params
end function

--------------------------------------------------------------------------------

function check_routine(sequence s)
  sequence found, params
  integer rtn
  object result, exp

  -- log_puts("check_routine(" & object_dump(s) & ")\n")
  result = 0
  if find(s[1][OBJ_VALUE], builtin_routines) then
    -- log_puts("check_routine: built-in routine\n")
    found = find_in_array(s[1][OBJ_VALUE], builtin_list,
                          {{"search_field", 2}, {"target_field", -1}})
    -- analyze_object(found, "check_routine: found", f_debug)
    if found[1] = PROC then
      -- log_puts(found[2] & " is a procedure\n")
    else
      -- log_puts(found[2] & " is a function\n")
    end if
    params = get_params(s)
    -- analyze_object(params, "check_routine: params", f_debug)
    if found[1] = PROC then
      run_builtins_proc(found[2], params)
    else
      exp = run_builtins_func(found[2], params)
      -- analyze_object(exp, "check_routine: exp", f_debug)
    end if
    if found[1] = FUNC then
      result = exp
    else
      result = 0
    end if
  elsif find(s[1][OBJ_VALUE], additional_routines) then
    -- log_puts("check_routine: additional routine\n")
    found = find_in_array(s[1][OBJ_VALUE], routine_list,
                          {{"search_field", 2}, {"target_field", -1}})
    -- analyze_object(found, "check_routine: found", f_debug)
    if found[1] = PROC then
      -- log_puts(found[2] & " is a procedure\n")
    else
      -- log_puts(found[2] & " is a function\n")
    end if
    params = get_params(s)
    -- analyze_object(params, "check_routine: params", f_debug)
    rtn = routine_id(found[2])
    if found[1] = PROC then
      call_proc(rtn, params)
    else
      exp = call_func(rtn, params)
      -- analyze_object(exp, "check_routine: exp", f_debug)
    end if
    set_variable("HTTP_STATUS",  http_status)
    set_variable("HTTP_URL",     http_url)
    set_variable("HTTP_HEADERS", http_headers)
    set_variable("HTTP_BODY", http_body)
    -- analyze_object(variables, "variables", f_debug)
    if found[1] = FUNC then
      result = exp
    else
      result = 0
    end if
  end if
  -- analyze_object(result, "check_routine", f_debug)
  return result
end function

------------------------------------------------------------------------------

procedure parse()
  object keyword_routine, exp, last_assigned
  sequence id, code, op
  integer n

  -- log_puts("parse()\n")
  lineNum = 1
  index = 0
  current_token = 0
  id = ""
  while lineNum <= length(program) do
    log_puts("--------------------------------------------\n")
    -- get next token
    current_token = next_token()
    if lineNum > length(program) then return end if
    
    log_printf("lineNum: %d, index: %d, current_token: '%s'\n",
               {lineNum, index, object_dump(current_token)})
    analyze_object({program[lineNum]}, sprintf("program[%d]", lineNum),
                   f_debug, rtn_id)

    -- check end of program reached
    if atom(current_token) then exit end if

    keyword_routine = vlookup(current_token[OBJ_VALUE], KEYWORDS, 1, 2)

    if equal(current_token[OBJ_VALUE], "end") then
      exit

    elsif sequence(keyword_routine) and length(keyword_routine) then
      log_puts("call internal routine " & keyword_routine & "\n")
      call_proc(routine_id(keyword_routine), {})

    elsif find(current_token[OBJ_VALUE], builtin_routines) or
          find(current_token[OBJ_VALUE], additional_routines) then
      -- check if procedure in additional_routines
      log_puts("call external procedure " & current_token[OBJ_VALUE] & "\n")
      void = check_routine(program[lineNum][index..$])
      index = length(program[lineNum])

    else
      code = program[lineNum][index..$]
      if code[1][OBJ_TYPE] = VARIABLE then  -- 7
        log_puts("parse: assignment\n")
        -- analysis starts at current lineNum and index
        -- code ends at the end of current lineNum
        if length(code[1][OBJ_VALUE]) = 0 then
          error_message("No identifier in " & object_dump(code) & "!\n", 1)
        end if
        id = code[1][OBJ_VALUE]
        analyze_object(id, "id", f_debug)
        if length(code) < 3 then
          error_message("Incorrect syntax in " & object_dump(code) & "!\n", 1)
        end if
        if code[2][OBJ_TYPE] != ASSIGNMENT then
          error_message(object_dump(code) & " is not an assignment statement!\n", 1)
        end if
        op = code[2][OBJ_VALUE]
        analyze_object(op, "op", f_debug)
        if code[3][OBJ_TYPE] = ROUTINE then  -- 8
          log_puts("parse: routine\n")
          n = search_parsed_by_value(")", code)
          if n = 0 then
            error_message("parse: Missing parameters for routine " &
                           code[3][OBJ_VALUE] & "!\n", 1)
          end if
          exp = check_routine(code[3..n])
          index = n
        else
          log_puts("parse: expression\n")
          exp = expression(code[3..$])
          index = length(program[lineNum])
        end if
        analyze_object(exp, "exp", f_debug)
        if equal(op, "=") then
          set_variable(id, exp)
        elsif equal(op, "-=") then
          set_variable(id, get_variable(id) - exp)
        elsif equal(op, "+=") then
          set_variable(id, get_variable(id) + exp)
        elsif equal(op, "*=") then
          set_variable(id, get_variable(id) * exp)
        elsif equal(op, "/=") then
          set_variable(id, get_variable(id) / exp)
        elsif equal(op, "&=") then
          set_variable(id, get_variable(id) & exp)
        end if
      elsif find(code[1][OBJ_TYPE], {MATHEMATICAL, BINARY, COMPARISON, LOGICAL}) then
        log_puts("parse: operation\n")
        id = last_assigned
        analyze_object(id, "id", f_debug)
        op = code[1][OBJ_VALUE]
        analyze_object(op, "op", f_debug)
        if code[2][OBJ_TYPE] = ROUTINE then  -- 8
          log_puts("parse: routine\n")
          n = search_parsed_by_value(")", code)
          if n = 0 then
            error_message("parse: Missing parameters for routine " &
                          code[2][OBJ_VALUE] & "!\n", 1)
          end if
          exp = check_routine(code[2..n])
          index = n
        else
          log_puts("parse: expression\n")
          exp = expression(code[2..$])
          index = length(program[lineNum])
        end if
        analyze_object(exp, "exp", f_debug)
        set_variable(id, evaluate(get_variable(id), op, exp))
      end if
      last_assigned = id
    end if
  end while
end procedure

------------------------------------------------------------------------------

procedure check_jumps()
  log_puts("check_jumps()\n")
  for i = 1 to length(program) do
    if equal(program[i][1][OBJ_VALUE], "label") then
      jumps = append(jumps, {"label", program[i][2][OBJ_VALUE], i})
    end if
  end for
  analyze_object(jumps, "jumps", f_debug)
end procedure

--------------------------------------------------------------------------------

procedure show_remaining_line()
  integer n

  -- log_puts("show_remaining_line()\n")
  n = find_from('\n', buffer, pos+1)
  if n then
    log_puts("remaining line: '" & show_printable(buffer[pos..n]) & "'\n")
  else
    log_puts("remaining line: '" & show_printable(buffer[pos..$]) & "'\n")
  end if
end procedure

--------------------------------------------------------------------------------

function get_next_word()
  sequence s

  -- log_puts("get_next_word()\n")
  s = {}
  while not find(buffer[pos], SEPARATORS) do
    s = s & buffer[pos]
    pos += 1
    if pos > length(buffer) then exit end if
  end while
  if (pos <= length(buffer)) and
     find(buffer[pos], SEPARATORS) then
    pos -= 1
  end if
  s = trim(s)
  -- analyze_object(s, "s", f_debug)
  return s
end function

--------------------------------------------------------------------------------

function get_next_item()
  sequence s, t
  integer n

  -- log_puts("get_next_item()\n")
  pos += 1
  if pos > lg then return 0 end if

  -- analyze_object(line, "line", f_debug)
  -- show_remaining_line()

  if (pos <= lg-1) and equal(buffer[pos..pos+1], "\r\n") then   -- next line
    if length(line) then
      program = append(program, line)
      line = {}
    end if
    pos += 1
    return 1
  end if

  -- pos is at first char of remaining text

  -- skip spaces and tabs
  if find(buffer[pos], " \t") then
    return 1
  end if

  -- pos is at first valid char of remaining text

  -- skip comments
  if (pos <= lg-1) and equal(buffer[pos..pos+1], "/*") then   -- begin of Comment zone
    s = get_delimited_text(buffer, pos, "*/")
    pos = s[3]
    return 1
  elsif (pos <= lg-1) and equal(buffer[pos..pos+1], "--") then   -- begin of Comment zone
    s = get_delimited_text(buffer, pos, "\n")
    pos = s[3]
    return 1
  end if

  -- pos is at first non-commented char of remaining text
  -- show_remaining_line()

  -- manage strings
  if buffer[pos] = '"' then  --string
    n = find_matching(buffer[pos], buffer, pos+1)
    if n = 0 then
      -- log_puts({buffer[pos]} & " does not start a string\n")
    else
      -- log_puts("STRING\n")
      s = unescape(dequote(buffer[pos..n], {}))
      line = append(line, {STRING, s})
      pos = n
    end if
    return 1
  end if
  if pos > lg then return 0 end if

  -- manage chars
  if buffer[pos] = '\'' then  -- char
    n = find_matching(buffer[pos], buffer, pos+1)
    if n = 0 then
      -- log_puts({buffer[pos]} & " does not start a char\n")
    else
      -- log_puts("CHAR\n")
      s = unescape(dequote(buffer[pos..n], {{"delims",'\''}}))
      -- analyze_object(s, "s", f_debug)
      -- log_puts(sprint(s) & "\n")
      line = append(line, {CHAR, s[1]})
      pos = n
    end if
    return 1
  end if
  if pos > lg then return 0 end if

  -- manage sequences
  if buffer[pos] = '{' then  -- char
    n = find_matching(buffer[pos], buffer, pos+1)
    if n = 0 then
      -- log_puts({buffer[pos]} & " does not start a sequence\n")
    else
      -- log_puts("SEQUENCE\n")
      s = unescape(dequote(buffer[pos..n], {{"delims","{}"}}))
      line = append(line, {SEQUENCE, s})
      pos = n
    end if
    return 1
  end if
  if pos > lg then return 0 end if

  -- pos is at first valid char of non-string and non-char type of remaining text

  -- show_remaining_line()
  if (pos <= lg-1) and find(buffer[pos..pos+1], COMPARISON_OPERATORS) then
    -- log_puts("COMPARISON\n")
    line = append(line, {COMPARISON, buffer[pos..pos+1]})
    pos += 1
    return 1
  end if
  if find({buffer[pos]}, COMPARISON_OPERATORS) then
    -- log_puts("COMPARISON\n")
    line = append(line, {COMPARISON, {buffer[pos]}})
    return 1
  end if

  if (pos <= lg-1) and find(buffer[pos..pos+1], ASSIGNMENT_OPERATORS) then
    -- log_puts("ASSIGNMENT\n")
    -- analyze_object(line[$], "line[$]", f_debug)
    line[$][OBJ_TYPE] = VARIABLE
    set_variable(line[$][OBJ_VALUE], -1)
    line = append(line, {ASSIGNMENT, buffer[pos..pos+1]})
    pos += 1
    return 1
  end if
  if find({buffer[pos]}, ASSIGNMENT_OPERATORS) then
    -- log_puts("ASSIGNMENT\n")
    -- analyze_object(line[$], "line[$]", f_debug)
    line[$][OBJ_TYPE] = VARIABLE
    set_variable(line[$][OBJ_VALUE], -1)
    line = append(line, {ASSIGNMENT, {buffer[pos]}})
    return 1
  end if

  if (pos <= lg-1) and find(buffer[pos..pos+1], MATHEMATICAL_OPERATORS) then
    -- log_puts("MATHEMATICAL\n")
    line = append(line, {MATHEMATICAL, buffer[pos..pos+1]})
    pos += 1
    return 1
  end if
  if find({buffer[pos]}, MATHEMATICAL_OPERATORS) then
    -- log_puts("MATHEMATICAL\n")
    line = append(line, {MATHEMATICAL, {buffer[pos]}})
    return 1
  end if

  if (pos <= lg-1) and find(buffer[pos..pos+1], BINARY_OPERATORS) then
    -- log_puts("BINARY\n")
    line = append(line, {BINARY, buffer[pos..pos+1]})
    pos += 1
    return 1
  end if
  if find({buffer[pos]}, BINARY_OPERATORS) then
    -- log_puts("BINARY\n")
    line = append(line, {BINARY, {buffer[pos]}})
    return 1
  end if

  if (pos <= lg-1) and find(buffer[pos..pos+1], LOGICAL_OPERATORS) then
    -- log_puts("LOGICAL\n")
    line = append(line, {LOGICAL, buffer[pos..pos+1]})
    pos += 1
    return 1
  end if
  if find({buffer[pos]}, LOGICAL_OPERATORS) then
    -- log_puts("LOGICAL\n")
    line = append(line, {LOGICAL, {buffer[pos]}})
    return 1
  end if

  if find(buffer[pos], SEPARATORS) then
    -- log_puts("SEPARATOR\n")
    line = append(line, {SEPARATOR, {buffer[pos]}})
    return 1
  end if

  s = get_next_word()

  -- show_remaining_line()
  if is_integer(s) then
    -- log_puts("INTEGER\n")
    line = append(line, {INTEGER, to_number(s)})
  elsif is_number(s) then
    -- log_puts("ATOM\n")
    line = append(line, {ATOM, to_number(s)})
  elsif find(s, MATHEMATICAL_OPERATORS) then  -- {"mod", "div"}
    -- log_puts("MATHEMATICAL\n")
    line = append(line, {MATHEMATICAL, s})
  elsif find(s, LOGICAL_OPERATORS) then  -- {"and", "or", "xor", "not"}
    -- log_puts("LOGICAL\n")
    line = append(line, {LOGICAL, s})
  elsif is_identifier(s) then
    if is_constant(s) then
      -- log_puts("CONSTANT\n")
      line = append(line, {CONSTANT, s})
    elsif is_variable(s) then
      -- log_puts("VARIABLE\n")
      line = append(line, {VARIABLE, s})
    elsif find(s, builtin_routines) then
      -- log_puts("ROUTINE\n")
      line = append(line, {ROUTINE, s})
    elsif find(s, additional_routines) then
      -- log_puts("ROUTINE\n")
      line = append(line, {ROUTINE, s})
    else
      if equal(s, "end") then
        pos += 2
        t = get_next_word()
        if length(t) then
          s &= " " & t
        else
          pos -= 2
        end if
        -- analyze_object(s, "s", f_debug)
      end if
      -- log_puts("IDENTIFIER\n")
      line = append(line, {IDENTIFIER, s})
    end if
  else
    -- log_puts("UNKNOWN\n")
    error_message("Unknown type for '" & s & "'!\n", 1)
  end if
  if pos > lg then return 0 end if
  return 1
end function

------------------------------------------------------------------------------

procedure scan_buffer()
  integer old_pos, n
  sequence sub, s

  -- log_puts("scan_buffer()\n")
  program = {}
  line = {}
  pos = 0
  while pos < lg do
    -- log_puts("UNKNOWN\n")
    old_pos = pos
    if not get_next_item() then exit end if
    -- log_printf("scan_buffer: pos = %d\n", pos)
    if length(line) then
      -- analyze_object(line[$], "scan_buffer: line[$]", f_debug)
      if (line[$][OBJ_TYPE] = SEQUENCE) and length(line[$][OBJ_VALUE]) then
        n = stack_size(scan_stack)
        if (n < MAX_STACK_DEPTH) then
          void = stack_push(scan_stack, {buffer, line, pos})
        else
          error_message("scan_buffer: scan stack size exceeded!\n", 1)
        end if
        --next_pos = pos
        --old_buffer = buffer
        buffer = line[$][OBJ_VALUE]
        lg = length(buffer)
        n = length(line)
        --old_line = line
        pos = 0
        line = {}
        while pos < lg do
          if not get_next_item() then exit end if
          -- analyze_object(line, "scan_buffer: line", f_debug)
          -- show_remaining_line()
        end while
        sub = line
        if stack_size(scan_stack) > 0 then
          s = stack_pop(scan_stack, 0)
          buffer = s[1]
          line   = s[2]
          pos    = s[3]
        else
          error_message("scan_buffer: empty stack!\n", 1)
        end if
        --pos = next_pos
        --buffer = old_buffer
        lg = length(buffer)
        --line = old_line
        line[n][OBJ_VALUE] = sub
        -- show_remaining_line()
      end if
    else
      -- log_puts("scan_buffer: line = ''\n")
    end if
    if pos = old_pos then
      show_remaining_line()
      puts(1, "scan_buffer: blocage detecte\n")
      exit
    end if
    -- log_printf("pos = %d, lg = %d\n", {pos, lg})
  end while
  if length(line) then
    program = append(program, line)
  end if
end procedure

------------------------------------------------------------------------------

  sequence cmd, program_name, s

  crash_file(InitialDir & SLASH & "debug" & SLASH & "ex.err")
  cmd = command_line()
  if length(cmd) < 3 then
    error_message("Syntax: netbasic file\n", 1)
  end if
  program_name = cmd[3]
  f_debug = open(InitialDir & SLASH & "debug" & SLASH & file_base(program_name) & ".log", "w")
  with_debug = 1
  if not file_exists(InitialDir & SLASH & "scripts" & SLASH & program_name) then
    error_message("File " & program_name & " not found!\n", 1)
  end if

  void = delete_file(InitialDir & SLASH & "debug" & SLASH & "ex.err")
  void = delete_file(InitialDir & SLASH & "error.log")

  log_puts(App & " - " & Ver & "\n")
  s = date()
  f_out = open(InitialDir & SLASH & "results" & SLASH & file_base(program_name) &
               sprintf("_%d-%02d-%02d_%02d-%02d-%02d",
                       {s[1]+1900,s[2],s[3],s[4],s[5],s[6]})&".log", "w")

  -- built-in and misc functions included by default
  for i = 1 to length(BUILT_IN_FUNCS) do
    builtin_list = append(builtin_list, BUILT_IN_FUNCS[i])
    builtin_routines = append(builtin_routines, BUILT_IN_FUNCS[i][2])
  end for
  for i = 1 to length(MISC_CONSTS) do
    constants = append(constants, MISC_CONSTS[i])
  end for
  for i = 1 to length(MISC_FUNCS) do
    routine_list = append(routine_list, MISC_FUNCS[i])
    additional_routines = append(additional_routines, MISC_FUNCS[i][2])
  end for

  for_stack = stack_new("for")
  gosub_stack = stack_new("gosub")
  block_stack = stack_new("block")
  scan_stack = stack_new("scan")

  buffer = read_file(InitialDir & SLASH & "scripts" & SLASH & program_name)
  -- analyze_object(buffer, "buffer", f_debug)
  lg = length(buffer)

  scan_buffer()
  analyze_object(program, "program", f_debug, rtn_id)

  check_jumps()

  set_variable("HTTP_STATUS",  0)
  set_variable("HTTP_URL",     "")
  set_variable("HTTP_HEADERS", "")
  set_variable("HTTP_BODY", "")
  set_variable("CURRENT", "")

  parse()

  wd_cleanup()
  ssh_exit()

  close(f_out)
  close(f_debug)
--  void = wait_key()

