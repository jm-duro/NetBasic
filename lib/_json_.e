include std/convert.e
include std/search.e
include std/text.e
include std/sequence.e
include _types_.e
include _conv_.e
include _sequence_.e
include _search_.e
include _debug_.e
include _file_.e

constant
  JSON_NULL   = 0,
  JSON_TRUE   = 1,
  JSON_FALSE  = 2 --,
--  JSON_NUMBER = 3,
--  JSON_STRING = 4,
--  JSON_OBJECT = 5,
--  JSON_ARRAY  = 6

--constant
--  JSON_TYPE = {
--    "JSON_NULL", "JSON_TRUE", "JSON_FALSE", "JSON_NUMBER", "JSON_STRING",
--    "JSON_OBJECT", "JSON_ARRAY"
--  }

--------------------------------------------------------------------------------

function split_list(sequence json, integer sep)
  sequence result
  integer c, e, previous
  integer tmpStr      -- if 1, index is within double quotes

  tmpStr = 0
  c = 1
  result = {}
  previous = 1
  while c < length(json) do
    if (json[c] = '{') or (json[c] = '[') then
      e = find_matching(json[c], json, c+1)
      -- log_printf("\nc = %d, e = %d, s = %s\n", {c, e, json[c..e]})
      if e then c = e end if
    elsif json[c] = '"' then
      if (c = 1) or (json[c-1] != '\\') then
        e = find_matching(json[c], json, c+1)
        -- log_printf("\nc = %d, e = %d, s = %s\n", {c, e, json[c..e]})
        if e then c = e end if
      end if
    elsif json[c] = sep then
      result = append(result, trim(json[previous..c-1]))
      previous = c + 1
    end if
    c += 1
  end while
  result = append(result, trim(json[previous..$]))
  return result
end function

--------------------------------------------------------------------------------

function get_json_type(sequence s)
  sequence comma_split, colon_split

  if equal(lower(s), "null") then
    return JSON_NULL
  elsif equal(lower(s), "true") then
    return JSON_TRUE
  elsif equal(lower(s), "false") then
    return JSON_FALSE
  else
    comma_split = split_list(s, ',')
    if length(comma_split) > 1 then return {',', comma_split} end if
    colon_split = split_list(s, ':')
    if length(colon_split) = 2 then return {':', colon_split} end if
    if (s[1] = '{') and (s[$] = '}') then return {'{', split_list(s[2..$-1], ',')} end if
    if (s[1] = '[') and (s[$] = ']') then return {'[', split_list(s[2..$-1], ',')} end if
    if (s[1] = '"') and (s[$] = '"') then return {'"', s[2..$-1]} end if
    return {'0', to_number(s)}
  end if
end function

--------------------------------------------------------------------------------

public function json_to_sequence(sequence json)
--<function>
--<name>json_to_sequence</name>
--<digest>Converts JSON string to an Euphoria sequence</digest>
--<desc>
--</desc>
--<param>
--<type>sequence</type>
--<name>json</name>
--<desc>JSON sequence to parse</desc>
--</param>
--<return>
-- hierarchical sequence of all JSON elements
--</return>
--<example>
-- s = "{\"key1\" : {\"key1.1\" : 2}, \"key2\" : 2}"
-- elements = json_to_sequence(s)
-- elements =
-- .  [1]
-- .  .  [1] "key1"
-- .  .  [2]
-- .  .  .  [1]
-- .  .  .  .  [1] "key1.1"
-- .  .  .  .  [2] 2
-- .  [2]
-- .  .  [1] "key2"
-- .  .  [2] 2
--</example>
--<see_also>
--</see_also>
--</function>
  integer json_type
  object result, x

--  log_puts("\njson_to_sequence(" & object_dump(json) & ")\n")
  result = {}
  if length(json) = 0 then return result end if
  x = get_json_type(json)
  if atom(x) then
--    log_puts(" " & JSON_TYPE[x+1] & "\n")
    json_type = x
  else
--    log_puts(" " & x[1] & "\n")
    json_type = x[1]
      end if
  if json_type = JSON_NULL then
    result = -1
  elsif json_type = JSON_TRUE then
    result = 1
  elsif json_type = JSON_FALSE then
    result = 0
  elsif json_type = ',' then
    for i = 1 to length(x[2]) do
      result = append(result, json_to_sequence(x[2][i]))
    end for
  elsif json_type = ':' then
    result &= {dequote(x[2][1], {}), json_to_sequence(x[2][2])}
  elsif json_type = '{' then
    for i = 1 to length(x[2]) do
      result = append(result, json_to_sequence(x[2][i]))
    end for
  elsif json_type = '[' then
    for i = 1 to length(x[2]) do
      result = append(result, json_to_sequence(x[2][i]))
    end for
  elsif json_type = '"' then
    result = x[2]
  elsif json_type = '0' then
    result = x[2]
  else
    error_message("Unknown JSON type", 1)
  end if
  return result
end function

--------------------------------------------------------------------------------

public function get_json_value(sequence name, sequence elements, object default)
--<function>
--<name>get_json_value</name>
--<digest>Returns the value of a JSON item</digest>
--<desc>
--</desc>
--<param>
--<type>sequence</type>
--<name>name</name>
--<desc>JSON item name to search for</desc>
--</param>
--<param>
--<type>sequence</type>
--<name>elements</name>
--<desc>JSON sequence converted to an Euphoria sequence by json_to_sequence()</desc>
--</param>
--<param>
--<type>object</type>
--<name>default</name>
--<desc>value to return when search fails</desc>
--</param>
--<return>
-- an object: value of found JSON element
--</return>
--<example>
-- s = "{\"key1\" : {\"key1.1\" : 2}, \"key2\" : 2}"
-- get_json_value("key1.1", s  0) is 2
--</example>
--<see_also>
--</see_also>
--</function>
  sequence found, s

  found = find_nested(name, elements)
--  analyze_object(found, "found", f_debug)
  if length(found) then
    s = fetch(elements, found[1..$-1])
    return s[2]
  else
    return default
  end if
end function

