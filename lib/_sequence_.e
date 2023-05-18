-- _sequence_.e

include std/convert.e
include std/search.e
include std/sequence.e
include std/text.e
include _common_.e
include _types_.e
include _conv_.e

-------------------------------------------------------------------------------

public function trim_spaces(sequence s)
--<function>
--<name>trim_spaces</name>
--<digest></digest>
--<desc>
-- remove space chars from both ends of a string
-- and removes exceeding space chars between words
-- tab spaces are converted to normal spaces before removal
--</desc>
--<param>
--<type>sequence</type>
--<name>s</name>
--<desc>string to modify</desc>
--</param>
--<return>
-- modified string
--</return>
--<example>
--</example>
--<see_also>trim_head(), trim_tail(), trim()</see_also>
--</function>
  sequence result
  integer lg

  result = ""
  s = trim(s)
  lg = length(s)
  if lg = 0 then return "" end if
  if s[1] = '\t' then s[1] = " " end if
  if s[1] != ' ' then result &= {s[1]} end if
  if lg > 1 then
    for i = 2 to lg do
      if s[i] = '\t' then s[i] = ' ' end if
      if s[i] != ' ' then
        result &= {s[i]}
      else
        if s[i-1] != ' ' then result &= {s[i]} end if
      end if
    end for
  end if
  return result
end function

------------------------------------------------------------------------------

-- returns the n characters at the right of string s
public function left(sequence s, integer n)
--<function>
--<name>left</name>
--<digest>returns the given number of characters at the left of a string</digest>
--<desc>
--</desc>
--<param>
--<type>sequence</type>
--<name>s</name>
--<desc>string to look at</desc>
--</param>
--<param>
--<type>integer</type>
--<name>n</name>
--<desc></desc>
--</param>
--<return>
-- sequence: extracted sub-string
--</return>
--<example>
--</example>
--<see_also>mid(), right()</see_also>
--</function>
  return head(s, n)
end function

------------------------------------------------------------------------------

--
public function right(sequence s, integer n)
--<function>
--<name>right</name>
--<digest>returns the given number of characters at the right of a string</digest>
--<desc>
--</desc>
--<param>
--<type>sequence</type>
--<name>s</name>
--<desc>string to look at</desc>
--</param>
--<param>
--<type>integer</type>
--<name>n</name>
--<desc></desc>
--</param>
--<return>
-- sequence: extracted sub-string
--</return>
--<example>
--</example>
--<see_also>left(), mid()</see_also>
--</function>
  return tail(s, n)
end function

------------------------------------------------------------------------------

public function split_string(sequence str, object sep, integer as_is=0,
                             integer keep=0)
--<function>
--<name>split_string</name>
--<digest>splits a string according to a separator</digest>
--<desc>
--</desc>
--<param>
--<type>sequence</type>
--<name>str</name>
--<desc>string to split</desc>
--</param>
--<param>
--<type>object</type>
--<name>sep</name>
--<desc>
-- separator
-- either an object or a sequence
-- if separator is a sequence then:
-- * if as_is is set then the whole string is the separator
-- * is as_is is not set then each character of the string is considered
--</desc>
--</param>
--<param>
--<type>integer</type>
--<name>as_is</name>
--<desc>
-- indicates that separator is the whole string instead of each character
-- separately. Defaults to 0 (each character separately).
--</desc>
--</param>
--<param>
--<type>integer</type>
--<name>keep</name>
--<desc>
-- indicates that separator is kept in result. Defaults to 0 (no).
--</desc>
--</param>
--<return>
-- splitted sequence
--</return>
--<example>
-- analyze_object(split_string("my name is Bond", ' '), "split_string")
-- split_string =
-- .  [1] "my"
-- .  [2] "name"
-- .  [3] "is"
-- .  [4] "Bond"
-- analyze_object(split_string("my name is Bond", ' ', , 1), "split_string")
-- split_string =
-- .  [1] "my"
-- .  [2] " "
-- .  [3] "name"
-- .  [4] " "
-- .  [5] "is"
-- .  [6] " "
-- .  [7] "Bond"
-- analyze_object(split_string("my name is: Bond", ": "), "split_string")
-- split_string =
-- .  [1] "my"
-- .  [2] "name"
-- .  [3] "is"
-- .  [4] "Bond"
-- analyze_object(split_string("my name is: Bond", ": ", 1), "split_string")
-- split_string =
-- .  [1] "my name is"
-- .  [2] "Bond"
--</example>
--<see_also>
--</see_also>
--</function>
  integer i, slen, lg
  sequence result, s, t
  integer tmpStr

  result = {}
  slen = length(str)
  if slen = 0 then return result end if
  if atom(sep) then sep = {sep} end if

  s = {}
  tmpStr = 0      -- if 1, index is within double quotes
  lg = length(sep)
  i = 1
  while i <= slen do
    if (str[i] = '"') and not find('"', sep) then
      s = s & str[i]
      if (i = 1) or (str[i-1] != '\\') then
        if tmpStr = 0 then
          tmpStr = 1
        else
          tmpStr = 0
        end if
      end if
    elsif as_is = 0 then
      if tmpStr = 0 and find(str[i], sep) then
        t = trim(s)
        if length(t) then result = append(result, t) end if
        if keep then result = append(result, str[i]) end if
        s = {}
      else
        s = s & str[i]
      end if
    elsif as_is = 1 then
      if (tmpStr = 0) and (i < slen-lg) and (match(sep, str[i..$])=1) then
        t = trim(s)
        if length(t) then result = append(result, t) end if
        i += lg-1
        if keep then result = append(result, sep) end if
        s = {}
      else
        s = s & str[i]
      end if
    end if
    i += 1
  end while
  t = trim(s)
  if length(t) then result = append(result, t) end if
  return result
end function

------------------------------------------------------------------------------

public function unescape(sequence str)
--<function>
--<name>unescape</name>
--<digest>unescape chars from a string</digest>
--<desc></desc>
--<param>
--<type>sequence</type>
--<name>str</name>
--<desc>string to convert escaped chars from</desc>
--</param>
--<return>
-- unescaped sequence
--</return>
--<example>
-- unescape(\"string1\\string2\") => "string1\string2"
-- unescape(\'char\') => 'char'
-- unescape(col1\tcol2) => col1[tab]col2
-- unescape(line1\rline2) => line1[cr]line2
-- unescape(line1\nline2) => line1[lf]line2
-- unescape(line\n) => line[lf]
--</example>
--<see_also></see_also>
--</function>
  sequence result
  integer i

  result = ""
  if length(str) = 0 then
    return result
  end if
  i = 1
  while i < length(str) do
    if equal(str[i..i+1], "\\n") then
      result &= "\n"
      i += 1
    elsif equal(str[i..i+1], "\\r") then
      result &= "\r"
      i += 1
    elsif equal(str[i..i+1], "\\t") then
      result &= "\t"
      i += 1
    elsif not find(str[i..i+1], {"\\\"", "\\'", "\\\\"}) then
      result &= str[i]
    end if
    i += 1
  end while
  if i <= length(str) then result &= str[i] end if
  return result
end function

------------------------------------------------------------------------------

public function split_n_convert(sequence str, object sep)
--<function>
--<name>split_n_convert</name>
--<digest>splits a string in objects according to given separator</digest>
--<desc>
-- splitted elements are converted to atoms when possible
--</desc>
--<param>
--<type>sequence</type>
--<name>str</name>
--<desc>string to split</desc>
--</param>
--<param>
--<type>object</type>
--<name>sep</name>
--<desc>separator</desc>
--</param>
--<return>
-- splitted sequence
--</return>
--<example>
-- analyze_object(split_n_convert("my,code,is,7", ","), "split_n_convert")
-- split_n_convert =
-- .  [1] "my"
-- .  [2] "code"
-- .  [3] "is"
-- .  [4] 7
--</example>
--<see_also>convert_n_join()</see_also>
--</function>
  sequence s

  s = split_string(str, sep)
  for i = 1 to length(s) do
    if is_number(s[i]) or is_hex(s[i]) then
      s[i] = to_number(s[i])
    elsif is_string(s[i]) then
      s[i] = unescape(dequote(s[i]))
    end if
  end for
  return s
end function

------------------------------------------------------------------------------

public function convert_n_join(sequence s, sequence sep)
--<function>
--<name>convert_n_join</name>
--<digest>merge converted objects in a string with given separator</digest>
--<desc>
-- objects are converted to strings before being joined
--</desc>
--<param>
--<type>sequence</type>
--<name>s</name>
--<desc>sequence of objects</desc>
--</param>
--<param>
--<type>sequence</type>
--<name>sep</name>
--<desc>separator</desc>
--</param>
--<return>
-- merged string
--</return>
--<example>
-- puts(1, convert_n_join({"my","code","is", 7}, ",") & "\n")
-- "my","code","is",7
--</example>
--<see_also>split_n_merge()</see_also>
--</function>
  for i = 1 to length(s) do
    if atom(s[i]) then
      s[i] = to_string(s[i])
    elsif is_string(s[i]) then
      s[i] = quote(s[i], {})
    end if
  end for
  return join(s, sep)
end function

------------------------------------------------------------------------------

public function replace_all(sequence s, sequence old, sequence new)
--<function>
--<name>replace_all</name>
--<digest>replaces all occurences of sub-sequence old by new in sequence target</digest>
--<desc>
--</desc>
--<param>
--<type>sequence</type>
--<name>target</name>
--<desc>sequence to replace in</desc>
--</param>
--<param>
--<type>sequence</type>
--<name>old</name>
--<desc>sub-sequence to be replaced</desc>
--</param>
--<param>
--<type>sequence</type>
--<name>new</name>
--<desc>new sub-sequence</desc>
--</param>
--<return>
-- modified sequence
--</return>
--<example>
-- puts(1, replace_all("atoms, integers and objects", "s", "") & "\n")
-- atom, integer and object
--</example>
--<see_also>
--</see_also>
--</function>
  integer index, lg
  sequence res

  lg = length(old)
  res = ""
  index = match(old, s)
  while index != 0 do
    if index > 1 then
      res &= s[1..index-1]&new
    elsif index = 1 then
      res &= new
    end if
    if (index+lg) > length(s) then
      s = ""
      exit
    end if
    s = s[index+lg..$]
    index = match(old, s)
  end while
  if length(s) then res &= s end if
  return res
end function

------------------------------------------------------------------------------

public function append_if_new(sequence s, object o)
--<function>
--<name>append_if_new</name>
--<digest>append an object to a sequence only if not already present</digest>
--<desc></desc>
--<param>
--<type>sequence</type>
--<name>s</name>
--<desc>sequence to append to</desc>
--</param>
--<param>
--<type>object</type>
--<name>o</name>
--<desc>object to append</desc>
--</param>
--<return>
-- modified sequence
--</return>
--<example>
-- puts(1, append_if_new("abcdefghij", 'a') & "\n")
-- abcdefghij
-- puts(1, append_if_new("abcdefghij", 'k') & "\n")
-- abcdefghijk
--</example>
--<see_also>append()</see_also>
--</function>
  if find(o, s) then
    return s
  else
    return append(s, o)
  end if
end function

------------------------------------------------------------------------------

public function extract_column(sequence array, integer column)
--<function>
--<name>extract_column</name>
--<digest>extract a column of an array</digest>
--<desc>
-- this is fetch function from OpenEuphoria 4
--</desc>
--<param>
--<type>sequence</type>
--<name>array</name>
--<desc>array to extract column from</desc>
--</param>
--<param>
--<type>integer</type>
--<name>column</name>
--<desc>column to be extracted from array</desc>
--</param>
--<return>
-- sequence: selected column of array
--</return>
--<example>
-- puts(1, extract_column({"Start","Tank","Own","Patent"}, 1) & "\n")
-- STOP
--</example>
--<see_also>store()</see_also>
--</function>
  sequence result

  result = {}
  if length(array) = 0 then return {} end if
  for i = 1 to length(array) do
    if column <= length(array[i]) then
      result = append(result, array[i][column])
    else
      result = append(result, {})
    end if
  end for
  return result
end function

------------------------------------------------------------------------------

function split_template(sequence s)
  sequence result, variable, fixed
  integer inside_variable
  
  result = {}
  inside_variable = 0
  fixed = ""
  variable = ""
  for i = 1 to length(s) do
    if s[i] = '<' then
      inside_variable = 1
      variable = "<"
      if length(fixed) then result = append(result, fixed) end if
    elsif s[i] = '>' then
      inside_variable = 0
      result = append(result, variable & ">")
      fixed = ""
    else
      if inside_variable then
        variable &= s[i]
      else
        fixed &= s[i]
      end if
    end if
  end for
  if length(fixed) then result = append(result, fixed) end if
  return result
end function

public function parse_sequence(sequence s, sequence template)
--<function>
--<name>parse_sequence</name>
--<digest>extract variables from a string according to a template</digest>
--<desc>
-- Variables are encoded as XML tags in the template
-- Example: "http://<url>:<port>/search?q=<query>"
--</desc>
--<param>
--<type>sequence</type>
--<name>s</name>
--<desc>sequence to be parsed</desc>
--</param>
--<param>
--<type>sequence</type>
--<name>template</name>
--<desc>reference template</desc>
--</param>
--<return>
-- sequence: list of pairs {name, value} of all encountered variables in string
--</return>
--<example>
-- parse_sequence("http://www.google.com:80/search?q=euphoria",
--                "http://<url>:<port>/search?q=<query>")
-- will return
-- {{"<url>", "www.google.com"}, {"<port>", "80"}, {"<query>", "euphoria"}}
--</example>
--<see_also></see_also>
--</function>
  integer start, n
  sequence result, tmpl
  
  tmpl = split_template(template)
  result = {}
  start = 1
  for i = 1 to length(tmpl) do
    if begins("<", tmpl[i]) then
      if i < length(tmpl) then
        n = match(tmpl[i+1], s, start)
        if n then
          result = append(result, {tmpl[i], s[start..n-1]})
          start = n
        else
          return 0
        end if
      else
        result = append(result, {tmpl[i], s[start..$]})
      end if
    else
      n = match(tmpl[i], s, start)
      if n then
        start = n + length(tmpl[i])
      else
        return 0
      end if
    end if
  end for
  return result
end function
