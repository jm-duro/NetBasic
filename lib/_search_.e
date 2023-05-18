-- _search_.e

include std/search.e
include std/text.e
include _common_.e
include _types_.e

--------------------------------------------------------------------------------

public function find_matching(integer c, sequence s, integer from=1)
  integer n, e

-- log_puts("find_matching\n")
--analyze_object(s, "s", f_debug)
  if find(c, {'(', '[', '{', '<'}) then
    if c = '(' then
      e = ')'
    elsif c = '[' then
      e = ']'
    elsif c = '{' then
      e = '}'
    elsif c = '<' then
      e = '>'
    end if
    n = 0
    for i = from to length(s) do
      if s[i] = c then n += 1 end if
      if s[i] = e then n -= 1 end if
      if n = -1 then return i end if
    end for
  elsif (c = '\'') or (c = '"') then
    for i = from to length(s) do
      if (s[i] = c) and (s[i-1] != '\\') then return i end if
    end for
  end if
  return 0
end function

-------------------------------------------------------------------------------

public function matching_length(sequence a, sequence b)
--<function>
--<name>matching_length</name>
--<digest>returns length of common portion of 2 sequences</digest>
--<desc>
-- comparison starts on first items of each sequence
--</desc>
--<param>
--<type>sequence</type>
--<name>a</name>
--<desc>first sequence to compare<desc>
--</param>
--<param>
--<type>sequence</type>
--<name>b</name>
--<desc>second sequence to compare</desc>
--</param>
--<return>
-- integer
-- length of the common part
--</return>
--<example>
-- printf(1, "%d\n", matching_length("abracadabroc", "abracadabra"))
-- 10
--</example>
--<see_also>
--</see_also>
--</function>
  integer i

  if not length(a) or not length(b) then return 0 end if
  i = 1
  while (i <= length(a)) and (i <= length(b)) and not compare(a[i], b[i]) do
    i += 1
  end while
  return i-1
end function

-------------------------------------------------------------------------------

public function nb_occurences(sequence item, sequence s)
--<function>
--<name>nb_occurences</name>
--<digest>returns number of occurences of an item in a sequence</digest>
--<desc>
--</desc>
--<param>
--<type>sequence</type>
--<name>item</name>
--<desc>item to search for</desc>
--</param>
--<param>
--<type>sequence</type>
--<name>s</name>
--<desc>sequence to search in</desc>
--</param>
--<return>
-- integer
--</return>
--<example>
-- printf(1, "%d\n", nb_occurences("a", "abracadabra"))
-- 5
--</example>
--<see_also></see_also>
--</function>
  sequence found

  found = match_all(item, s)
  return length(found)
end function

------------------------------------------------------------------------------

public function max_index(sequence lst)
--<function>
--<name>max_index</name>
--<digest>index of the highest value from a sequence</digest>
--<desc>
--</desc>
--<param>
--<type>sequence</type>
--<name>lst</name>
--<desc></desc>
--</param>
--<return>
-- returns index of the highest value from a sequence
-- if unsuccessful, returns 0
--</return>
--<example>
-- printf(1, "max_index({3,1,5,7,2,4}) = %d\n", max_index({3,1,5,7,2,4}))
-- 4
--</example>
--<see_also>
--</see_also>
--</function>
  atom maxi

  for i = 1 to length(lst) do
    if sequence(lst[i]) then
      return 0
    elsif i=1 then
      maxi = i
    elsif lst[i] > lst[maxi] then
      maxi = i
    end if
  end for
  return maxi
end function

------------------------------------------------------------------------------

public function min_index(sequence lst)
--<function>
--<name>min_index</name>
--<digest>index of the lowest value from a sequence</digest>
--<desc>
--</desc>
--<param>
--<type>sequence</type>
--<name>lst</name>
--<desc></desc>
--</param>
--<return>
-- returns index of the lowest value from a sequence
-- if unsuccessful, returns 0
--</return>
--<example>
-- printf(1, "min_index({3,1,5,7,2,4}) = %d\n", min_index({3,1,5,7,2,4}))
-- 2
--</example>
--<see_also>
--</see_also>
--</function>
  atom mini

  for i = 1 to length(lst) do
    if sequence(lst[i]) then
      return 0
    elsif i=1 then
      mini = i
    elsif lst[i] < lst[mini] then
      mini = i
    end if
  end for
  return mini
end function

------------------------------------------------------------------------------

public function find_text(sequence buffer, sequence st, sequence en,
                          integer with_tags=0, integer with_coords=0)
--<function>
--<name>find_text</name>
--<digest>find a text delimited with tags in a string</digest>
--<desc></desc>
--<param>
--<type>sequence</type>
--<name>buffer</name>
--<desc>string to search in</desc>
--</param>
--<param>
--<type>sequence</type>
--<name>st</name>
--<desc>start tag</desc>
--</param>
--<param>
--<type>sequence</type>
--<name>en</name>
--<desc>end tag</desc>
--</param>
--<param>
--<type>integer</type>
--<name>with_tags</name>
--<desc>
--  if set start tag and end tag will be returned with string in between.
--  Defaults to 0
--</desc>
--</param>
--<param>
--<type>integer</type>
--<name>with_coords</name>
--<desc>
--  if set result will be a sequence with start position, end position and the
--  string. Defaults to 0 (searched string only).
--</desc>
--</param>
--<return>
-- sequence
--</return>
--<example>
-- puts(1, find_text("This is a #value# man!", "#", "#") & "\n")
-- value
-- print(1, find_text("This is a #value# man!", "#", "#", , 1))
-- puts(1, "\n")
-- {11,17,{118,97,108,117,101}}
-- puts(1, find_text("This is a #value# man!", "#", "#", 1) & "\n")
-- #value#
-- print(1, find_text("This is a #value# man!", "#", "#", 1, 1))
-- puts(1, "\n")
-- {11,17,{35,118,97,108,117,101,35}}
--</example>
--<see_also>find_all_text(), get_delimited_text()</see_also>
--</function>
  integer p1, p2
  sequence res

  res = ""
  p1 = match(st, buffer)
  if p1 > 0 then
    p2 = match_from(en, buffer, p1+length(st))
    if p2 > 0 then
      if with_tags then
        res = buffer[p1..p2+length(en)-1]
      else
        res = trim(buffer[p1+length(st)..p2-1])
      end if
      if with_coords then
        return {p1, p2+length(en)-1, res}
      else
        return res
      end if
    end if
  end if
  return 0
end function

-------------------------------------------------------------------------------

public function find_all_text(sequence buffer, sequence st, sequence en,
                              integer with_tags=0)
--<function>
--<name>find_all_text</name>
--<digest>returns a list of all text delimited by given tags</digest>
--<desc></desc>
--<param>
--<type>sequence</type>
--<name>buffer</name>
--<desc>string to search in</desc>
--</param>
--<param>
--<type>sequence</type>
--<name>st</name>
--<desc>start tag</desc>
--</param>
--<param>
--<type>sequence</type>
--<name>en</name>
--<desc>end tag</desc>
--</param>
--<param>
--<type>integer</type>
--<name>with_tags</name>
--<desc>
--  if set start tag and end tag will be returned with string in between.
--  Defaults to 0 (don't keep start tag and end tag)
--</desc>
--</param>
--<return>
-- sequence
--</return>
--<example>
-- find_all_text("a #name# and a #value#", "#", "#")
-- {"name", "value"}
-- find_all_text("a #name# and a #value#", "#", "#", 1)
-- {"#name#", "#value#"}
--</example>
--<see_also>find_text()</see_also>
--</function>
  sequence res
  object o

  res = {}
  while 1 do
    o = find_text(buffer, st, en, with_tags, 1)
    if atom(o) then return res end if
    res = append(res, o[3])
    buffer = buffer[o[2]+1..$]
  end while
  return res
end function

------------------------------------------------------------------------------

--
public function get_delimited_text(sequence buffer, integer pos,
                                   sequence delimiter)
--<function>
--<name>get_delimited_text</name>
--<digest>get text in buffer from specified position upto specified delimiter</digest>
--<desc></desc>
--<param>
--<type>sequence</type>
--<name>buffer</name>
--<desc>string to search in</desc>
--</param>
--<param>
--<type>integer</type>
--<name>pos</name>
--<desc>position in buffer to search from</desc>
--</param>
--<param>
--<type>sequence</type>
--<name>delimiter</name>
--<desc>sequence to match that ends search</desc>
--</param>
--<return>
-- sequence
-- [1] part of buffer from specified position to delimiter included
-- [2] start position ( = <b>pos</b> )
-- [3] end position   (including ending delimiter)
--</return>
--<example>
-- s = "a sentence containing this <-- comment -->"
-- n = find('<', s)
-- analyze_object(get_delimited_text(s, n, "-->"), "get_delimited_text")
-- .  [1] "<-- comment -->"
-- .  [2] 28
-- .  [3] 42
--</example>
--<see_also>find_text()</see_also>
--</function>
  integer l, st, en

  l = length(delimiter)-1
  st = pos
  en = 0
  while pos <= length(buffer)-l do
    if buffer[pos] = '"' then
      while pos <= length(buffer)-l do
        pos += 1
        if buffer[pos] = '"' then exit end if
      end while
    elsif equal(buffer[pos..pos+l], delimiter) then
      en = pos + l
      exit
    end if
    pos += 1
  end while
  if en > 0 then
    pos = en
    return {buffer[st..en], st, en}
  else
    error_message(sprintf("End delimiter (%s) not found!", {delimiter}), 1)
  end if
end function

------------------------------------------------------------------------------

public function find_in_array(object val, sequence array, sequence optional)
--<function>
--<name>find_in_array</name>
--<digest>search an object in an array</digest>
--<desc>
-- by default searches in first field (column) and returns position of item
-- found (0 if not found)
--</desc>
--<param>
--<type>object</type>
--<name>val</name>
--<desc></desc>
--</param>
--<param>
--<type>sequence</type>
--<name>array</name>
--<desc></desc>
--</param>
--<param>
--<type>sequence</type>
--<name>optional</name>
--<desc>
-- optional parameters:
--  search_field   = the field/column in which to search for val:
--                   defaults to 1
--  target_field   = field or sequence of fields to return values from:
--                   0: return line number only, no content
--                   -1: return all fields (whole record)
--                   defaults to 0 (line number only)
--  start_line = start search at specified position in array
--                   defaults to 1
--  all_occurences = return all occurences of items found
--                   defaults to 0 (return only first occurence)
--</desc>
--</param>
--<return>
--</return>
--<example>
-- find_in_array("first", {{"first",1},{"second",2}}, {})
-- 1
-- find_in_array(2, {{"first",1},{"second",2}}, {{"search_field",2}})
-- 2
-- find_in_array("first", {{"first",1},{"second",2}}, {{"target_field",2}})
-- {1}
-- find_in_array("first", {{"first",1},{"first",10},{"second",2}}, {{"start_line",2}})
-- 2
-- find_in_array("first", {{"first",1},{"first",10},{"second",2}}, {{"all_occurences",1}})
-- {1,2}
--</example>
--<see_also>vlookup(), find_common_fields()</see_also>
--</function>
  integer search_field, target_field, start_line, all_occurences
  object target_occurence
  sequence res

  search_field   = get_option("search_field",   optional, 1)
  target_field   = get_option("target_field",   optional, 0)
  start_line     = get_option("start_line"  ,   optional, 1)
  all_occurences = get_option("all_occurences", optional, 0)
  if search_field = 0 then return {} end if
  res = {}
  for occ = start_line to length(array) do
    if compare(val, array[occ][search_field]) = 0 then
      if sequence(target_field) then
        target_occurence = {}
        for fld = 1 to length(target_field) do
          target_occurence = append(target_occurence, array[occ][target_field[fld]])
        end for
      elsif target_field > 0 then
        target_occurence = {array[occ][target_field]}
      elsif target_field = 0 then
        target_occurence = occ
      else
        target_occurence = array[occ]
      end if
      if all_occurences then
        res = append(res, target_occurence)
      else
        return target_occurence
      end if
    end if
  end for
  if all_occurences then
    return res
  else
    return 0
  end if
end function

------------------------------------------------------------------------------

public function find_common_fields(sequence array, sequence fields, sequence vals, integer start=1)
--<function>
--<name>find_common_fields</name>
--<digest>list records from sheet array with selected values in selected fields</digest>
--<desc>
-- find_common_fields(tab, {1,3}, {5,"John"}) will list items having
-- 5 in first column and "John" in third
--</desc>
--<param>
--<type>sequence</type>
--<name>array</name>
--<desc>array to search in</desc>
--</param>
--<param>
--<type>sequence</type>
--<name>fields</name>
--<desc>fields to compare</desc>
--</param>
--<param>
--<type>sequence</type>
--<name>vals</name>
--<desc>values to compare</desc>
--</param>
--<param>
--<type>integer</type>
--<name>start</name>
--<desc>indicates line to search from: defaults to 1</desc>
--</param>
--<return>
--</return>
--<example>
-- find_common_fields({{"first",1},{"first",10},{"second",2}}, {1,2}, {"first",10})
-- {2}
-- find_common_fields({{"first",1},{"first",10},{"second",2}}, {1,2}, {"first",10}, 3)
-- ""
--</example>
--<see_also>find_in_array(), vlookup()</see_also>
--</function>
--
  sequence res
  integer found

  if (length(fields) = 0) or (length(vals) = 0) or (length(fields) != length(vals)) then return {} end if
  res = {}
  for i = start to length(array) do
    found = 1
    for j = 1 to length(fields) do
      if compare(array[i][fields[j]], vals[j]) != 0 then
        found = 0
      end if
    end for
    if found = 1 then
      res = append(res, i)
    end if
  end for
  return res
end function

------------------------------------------------------------------------------

public function find_all_nested(object x, sequence s)
--<function>
--<name>find_all_nested</name>
--<digest>ind the path to all occurences of an element in a sequence</digest>
--<desc></desc>
--<param>
--<type>object</type>
--<name>x</name>
--<desc>object to search for</desc>
--</param>
--<param>
--<type>sequence</type>
--<name>s</name>
--<desc>sequence to search in</desc>
--</param>
--<return>
-- sequence
--</return>
--<example>
-- find_all_nested(13, {13, {12, {13, "b"}}})
-- {{1}, {2,2,1}}
--</example>
--<see_also>find_nested()</see_also>
--</function>
  return find_nested(x, s, NESTED_ALL)
end function

------------------------------------------------------------------------------

function match_element(object x, sequence path, sequence s)
  sequence res

  res = {}
  if match(x, s) then
    return path
  else
    for i=1 to length(s) do
      if sequence(s[i]) then
        res = match_element(x, append(path, i), s[i])
        if length(res) then return res end if
      end if
    end for
  end if
  return {}
end function

------------------------------------------------------------------------------

sequence matchResults

procedure match_all_elements(object x, sequence path, sequence s)
  sequence res

  res = {}
  if match(x, s) then
    matchResults = append(matchResults, path)
  else
    for i=1 to length(s) do
      if sequence(s[i]) then
        match_all_elements(x, append(path, i), s[i])
      end if
    end for
  end if
end procedure

------------------------------------------------------------------------------

public function match_nested(object x, sequence s)
--<function>
--<name>match_nested</name>
--<digest>find the path to a matching element in a sequence</digest>
--<desc></desc>
--<param>
--<type>object</type>
--<name>x</name>
--<desc>object to search for</desc>
--</param>
--<param>
--<type>sequence</type>
--<name>s</name>
--<desc>sequence to search in</desc>
--</param>
--<return>
-- sequence
--</return>
--<example>
-- match_nested("13", {"a", {"12", {"130", "b"}}})
-- {2,2,1}
--</example>
--<see_also>match_all_nested()</see_also>
--</function>
  return match_element(x, {}, s)
end function

------------------------------------------------------------------------------

public function match_all_nested(object x, sequence s)
--<function>
--<name>match_all_nested</name>
--<digest>ind the path to all matching occurences of an element in a sequence</digest>
--<desc></desc>
--<param>
--<type>object</type>
--<name>x</name>
--<desc>object to search for</desc>
--</param>
--<param>
--<type>sequence</type>
--<name>s</name>
--<desc>sequence to search in</desc>
--</param>
--<return>
-- sequence
--</return>
--<example>
-- match_all_nested("13", {"13", {"12", {"130", "b"}}})
-- {{1}, {2,2,1}}
--</example>
--<see_also>match_nested()</see_also>
--</function>
  matchResults = {}
  match_all_elements(x, {}, s)
  return matchResults
end function

