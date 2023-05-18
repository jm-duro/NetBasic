-- HTML parser
-- decodes an HTML/XML document, sequence or file
-- hybrid approach between pure text search and pure HTML decoding
-- parsing indexes HTML/XML document to give quick access to searched
-- element in the original HTML/XML source code

include std/io.e
include std/text.e
include std/sequence.e
include std/search.e
include _search_.e
include _sequence_.e
include _file_.e
include _debug_.e
include _http_.e
include _stack_.e

constant
  SINGLE_HTML_TAGS = {"!doctype", "meta", "link", "img", "br", "hr", "font", "input"}

public constant
  NO_TAG = 0, START_TAG = 1, SINGLE_TAG = 2, END_TAG = 3, START_END_TAG = 4,
  INVALID_TAG = 5, EOF_TAG = 6, TEXT = 7, CDATA = 8, COMMENT = 9,
  ATTR_NAME = 10, ATTR_VALUE = 11
--<constant>
--<name>NO_TAG</name>
--<value>0</value>
--<desc>XML formatted string with no tag (should never occur)</desc>
--</constant>
--<constant>
--<name>START_TAG</name>
--<value>1</value>
--<desc>starting tag (with no closing part)</desc>
--</constant>
--<constant>
--<name>SINGLE_TAG</name>
--<value>2</value>
--<desc>single tag with no mandatory ending part</desc>
--</constant>
--<constant>
--<name>END_TAG</name>
--<value>3</value>
--<desc>ending tag</desc>
--</constant>
--<constant>
--<name>START_END_TAG</name>
--<value>4</value>
--<desc>autonomous tag</desc>
--</constant>
--<constant>
--<name>INVALID_TAG</name>
--<value>5</value>
--<desc>invalid tag</desc>
--</constant>
--<constant>
--<name>EOF_TAG</name>
--<value>6</value>
--<desc>end of file reached without finding next expected tag</desc>
--</constant>
--<constant>
--<name>TEXT</name>
--<value>7</value>
--<desc>text outside of tags</desc>
--</constant>
--<constant>
--<name>CDATA</name>
--<value>8</value>
--<desc>CDATA</desc>
--</constant>
--<constant>
--<name>COMMENT</name>
--<value>9</value>
--<desc>HTML/XML comment</desc>
--</constant>
--<constant>
--<name>ATTR_NAME</name>
--<value>10</value>
--<desc>attribute name within a tag</desc>
--</constant>
--<constant>
--<name>ATTR_VALUE</name>
--<value>11</value>
--<desc>attribute value within a tag</desc>
--</constant>

public constant TAG_TYPES = {
  "START_TAG", "SINGLE_TAG", "END_TAG", "START_END_TAG", "INVALID_TAG",
  "EOF_TAG", "TEXT", "CDATA", "COMMENT", "ATTR_NAME", "ATTR_VALUE"}
--<constant>
--<name>TAG_TYPES</name>
--<value>
-- {"START_TAG", "SINGLE_TAG", "END_TAG", "START_END_TAG", "INVALID_TAG",
--  "EOF_TAG", "TEXT", "CDATA", "COMMENT", "ATTR_NAME", "ATTR_VALUE"}</value>
--<desc></desc>
--</constant>

public constant
  TAG_NAME = 1, TAG_TYPE = 2, TAG_ATTRIBUTES = 3, TAG_PATH = 4, TAG_START = 5,
  TAG_END = 6
--<constant>
--<name>TAG_NAME</name>
--<value>1</value>
--<desc>tag name</desc>
--</constant>
--<constant>
--<name>TAG_TYPE</name>
--<value>2</value>
--<desc>tag type</desc>
--</constant>
--<constant>
--<name>TAG_ATTRIBUTES</name>
--<value>3</value>
--<desc>tag attributes</desc>
--</constant>
--<constant>
--<name>TAG_PATH</name>
--<value>4</value>
--<desc>list of parent tag names</desc>
--</constant>
--<constant>
--<name>TAG_START</name>
--<value>5</value>
--<desc>start position of the tag in the HTML sequence</desc>
--</constant>
--<constant>
--<name>TAG_END</name>
--<value>6</value>
--<desc>end position of the tag in the HTML sequence</desc>
--</constant>

integer tags
tags = stack_new("tags")

------------------------------------------------------------------------------

function stack_path()
  return reverse(stack_dump(tags))
end function

------------------------------------------------------------------------------

public function xml_path(integer id, sequence elements)
--<function>
--<name>xml_path</name>
--<digest>returns numerical path to a tag</digest>
--<desc></desc>
--<param>
--<type>integer</type>
--<name>id</name>
--<desc>number of an item of structure <i</desc>
--</param>
--<param>
--<type>sequence</type>
--<name>elements</name>
--<desc>detailed HTML/XML parser result</desc>
--</param>
--<return>
-- numerical path to a tag (ex: {1,3,2})
--</return>
--<example>
-- s = tag_path(, elements)
--</example>
--<see_also></see_also>
--</function>
  return elements[id][TAG_PATH]
end function

------------------------------------------------------------------------------

public function tag_path(sequence path, sequence elements)
--<function>
--<name>tag_path</name>
--<digest>converts a numerical path to a named tag path</digest>
--<desc></desc>
--<param>
--<type>sequence</type>
--<name>path</name>
--<desc>numerical path to a tag</desc>
--</param>
--<param>
--<type>sequence</type>
--<name>elements</name>
--<desc>detailed HTML/XML parser result</desc>
--</param>
--<return>
-- string formatted as a POSIX file path (ex: "/html/body/div")
--</return>
--<example>
-- s = tag_path({1,3,2}, elements)
--</example>
--<see_also></see_also>
--</function>
  sequence result

  if length(path)=0 then return "/" end if
  result = elements[path[1]][1]
  for i = 2 to length(path) do
    result &= "/" & elements[path[i]][1]
  end for
  return result
end function

------------------------------------------------------------------------------

function analyze_tag(sequence xml)
  integer lg, tagType
  sequence tagName, tagAttributes, s
  
  tagType = NO_TAG
  tagAttributes = {}
  s = split_string(xml[2..$-1], " ")
  tagName = lower(s[1])
  lg = length(s)
--  analyze_object(s, "analyze_tag: s", f_debug)
  if lg = 1 then
--  log_puts("a\n")
    if s[1][$] = '/' then  -- autonomous tag
      tagType = START_END_TAG
    elsif s[1][1] = '/' then  -- end tag
      tagType = END_TAG
    elsif find(tagName, SINGLE_HTML_TAGS) then  -- autonomous tag
      tagType = SINGLE_TAG
    else                   -- start tag
      tagType = START_TAG
    end if
  elsif find(tagName, SINGLE_HTML_TAGS) then  -- autonomous tag
--  log_puts("b\n")
    tagType = SINGLE_TAG
    if equal(s[$], "/") then s = s[1..$-1] end if
    for i = 2 to length(s) do
      if length(trim_head(s[i])) then
        tagAttributes = append(tagAttributes, split_string(s[i],'='))
      end if
    end for
  elsif equal(s[$], "/") then  -- autonomous tag
--  log_puts("c\n")
    tagType = START_END_TAG
    for i = 2 to length(s)-1 do
      if length(trim_head(s[i])) then
        tagAttributes = append(tagAttributes, split_string(s[i],'='))
      end if
    end for
  else
--  log_puts("d\n")
    tagType = START_TAG
    for i = 2 to length(s) do
      if length(trim_head(s[i])) then
        tagAttributes = append(tagAttributes, split_string(s[i],'='))
      end if
    end for
  end if
--  log_puts(TAG_TYPES[tagType] & " " & tagName & "\n")
  return {tagName, tagType, tagAttributes}
end function

------------------------------------------------------------------------------

public function parse_sequence(sequence buffer)
--<function>
--<name>parse_sequence</name>
--<digest></digest>
--<desc>
--</desc>
--<param>
--<type>sequence</type>
--<name>buffer</name>
--<desc>HTML sequence to parse</desc>
--</param>
--<return>
-- hierarchical sequence of all HTML/XML elements
-- with value, type, attributes, path, starting and ending position
--</return>
--<example>
-- s = "<head><title>Example Domain</title><meta charset="utf-8" /></head>"
-- elements = parse_sequence(s)
--</example>
--<see_also>
--</see_also>
--</function>
  sequence elements, text, s, tagName, tagAttributes, tag_string
  integer lg, tagType, st, n, pos

  pos = 0
  st=pos
  text = ""
  s = ""
  tagName = ""
  tagAttributes = {}
  lg = length(buffer)
  elements = {}
  while pos < lg do
    pos += 1
    if (pos < lg-3) and equal(buffer[pos..pos+3], "<!--") then   -- begin of Comment zone
      text = trim(text)
      if length(text) then
        elements = append(elements, {html_to_ascii(text), TEXT, "", stack_path() & length(elements), st, pos-1})
        text = ""
      end if
      s = get_delimited_text(buffer, pos, "-->")
      if s[3] then pos = s[3] else error_message("s[3] = 0 !", 1) end if
      elements = append(elements, {html_to_ascii(s[1]), COMMENT, "", stack_path() & length(elements), s[2], s[3]})
      st = pos+1
    elsif (pos < lg-4) and equal(buffer[pos..pos+4], "<?xml") then   -- begin of Comment zone
      s = get_delimited_text(buffer, pos, "?>")
      if s[3] then pos = s[3] else error_message("s[3] = 0 !", 1) end if
      elements = append(elements, {html_to_ascii(s[1]), COMMENT, "", stack_path() & length(elements), s[2], s[3]})
      st = pos+1
    elsif (pos < lg-10) and equal(buffer[pos..pos+10], "//<![CDATA[") then   -- begin of CDATA Javascript zone
      text = trim(text)
      if length(text) then
        elements = append(elements, {html_to_ascii(text), TEXT, "", st, pos-1})
        text = ""
      end if
      s = get_delimited_text(buffer, pos, "//]]>")
      if s[3] then pos = s[3] else error_message("s[3] = 0 !", 1) end if
      elements = append(elements, {html_to_ascii(s[1]), CDATA, "", stack_path() & length(elements), s[2], s[3]})
      st = pos+1
    elsif (pos < lg-12) and equal(buffer[pos..pos+12], "/*<![CDATA[*/") then   -- begin of CDATA CSS zone
      text = trim(text)
      if length(text) then
        elements = append(elements, {html_to_ascii(text), TEXT, "", stack_path() & length(elements), st, pos-1})
        text = ""
      end if
      s = get_delimited_text(buffer, pos, "/*]]>*/")
      if s[3] then pos = s[3] else error_message("s[3] = 0 !", 1) end if
      elements = append(elements, {html_to_ascii(s[1]), CDATA, "", stack_path() & length(elements), s[2], s[3]})
      st = pos+1
    elsif buffer[pos] = '<' then
      text = trim(text)
      if length(text) then
        elements = append(elements, {html_to_ascii(text), TEXT, "", stack_path() & length(elements), st, pos-1})
        text = ""
      end if
      tag_string = get_delimited_text(buffer, pos, ">")
      if tag_string[3] then pos = tag_string[3] else error_message("tag_string[3] = 0 !", 1) end if
--      analyze_object(tag_string, "tag_string", f_debug)
      s = analyze_tag(tag_string[1])
--      analyze_object(s, "analyze_tag", f_debug)
      tagName = s[1]
      tagType = s[2]
      tagAttributes = s[3]
      if tagType = START_TAG then
        elements = append(elements, {tagName, tagType, tagAttributes, stack_path() & length(elements), tag_string[2], tag_string[3]})
        void = stack_push(tags, length(elements))
      elsif (tagType = SINGLE_TAG) or (tagType = START_END_TAG) then
        elements = append(elements, {tagName, tagType, tagAttributes, stack_path() & length(elements), tag_string[2], tag_string[3]})
      elsif tagType = END_TAG then
        n = stack_at(tags, 1, 0)
        if (stack_size(tags)>0) and equal(elements[n][1], tagName[2..$]) then
          void = stack_pop(tags, 0)
        else
          error_message(sprintf("End tagName (%s) differs from start tagName (%s)!\n", {tagName, elements[n][1]}), 1)
        end if
        elements = append(elements, {tagName, tagType, tagAttributes, stack_path() & length(elements), tag_string[2], tag_string[3]})
      end if
      text = ""
      st = pos+1
    else
      if (buffer[pos] != '\r') and (buffer[pos] != '\n') then text &= buffer[pos] end if
    end if
  end while
  return elements
end function

------------------------------------------------------------------------------

public function parse_file(sequence filename)
--<function>
--<name>parse_file</name>
--<digest></digest>
--<desc>
--</desc>
--<param>
--<type>sequence</type>
--<name>filename</name>
--<desc>HTML file to parse</desc>
--</param>
--<return>
-- sequence
-- [1] HTML/XML code of the file
-- [2] hierarchical sequence of all HTML/XML elements
--     with value, type, attributes, path, starting and ending position
--</return>
--<example>
-- elements = parse_file("page.html")
--</example>
--<see_also>
--</see_also>
--</function>
  sequence html
  
  html = read_file(filename)
  return {html, parse_sequence(html)}
end function

------------------------------------------------------------------------------

sequence elements, buffer
integer pos

function scan_tag()
  sequence section, text, s, tag, attributes, tag_string
  integer lg

  s = ""
  tag = ""
  text = ""
  attributes = {}
  lg = length(buffer)
  section = {}
  while pos < lg do
    pos += 1
    if (pos < lg-3) and equal(buffer[pos..pos+3], "<!--") then   -- begin of Comment zone
      s = get_delimited_text(buffer, pos, "-->")
      pos = s[3]
    elsif (pos < lg-4) and equal(buffer[pos..pos+4], "<?xml") then   -- begin of Comment zone
      s = get_delimited_text(buffer, pos, "?>")
      pos = s[3]
    elsif buffer[pos] = '<' then
      tag_string = get_delimited_text(buffer, pos, ">")
      pos = tag_string[3]
--      analyze_object(tag_string, "scan_tag: tag_string", f_debug)
      s = analyze_tag(tag_string[1])
--      analyze_object(s, "scan_tag: s", f_debug)
      tag = s[TAG_NAME]
--      log_printf("Tag type: %s\n", {TAG_TYPES[s[2]]})
      if (s[TAG_TYPE] = START_TAG) or (s[TAG_TYPE] = START_END_TAG) then
        attributes = s[TAG_ATTRIBUTES]
        section = append(section, {tag})
        if length(attributes) then
          section[$] = append(section[$], attributes)
        end if
        if (s[TAG_TYPE] = START_TAG) then
          void = stack_push(tags, tag)
          s = scan_tag()
        end if
        section[$] &= s
      elsif s[TAG_TYPE] = END_TAG then
        text = trim(text)
        if length(text) then
          section = append(section, html_to_ascii(text))
        end if
        if (stack_size(tags)>0) and equal(stack_at(tags, 1, 0), tag[2..$]) then
          void = stack_pop(tags, 0)
          exit
        else
          error_message(sprintf("End tag (%s) differs from start tag (%s)!\n", {tag, stack_at(tags, 1, 0)}), 1)
        end if
      end if
    else
      if buffer[pos] != '\n' then text &= buffer[pos] end if
    end if
  end while
  return section
end function

------------------------------------------------------------------------------

public function xml_to_sequence(sequence s)
--<function>
--<name>xml_to_sequence</name>
--<digest>converts an XML string into an Euphoria sequence</digest>
--<desc></desc>
--<param>
--<type>sequence</type>
--<name>s</name>
--<desc>XML string to convert</desc>
--</param>
--<return>
-- sequence
--</return>
--<example>
-- s = xml_to_sequence(
--   "&lt;?xml version=\"1.0\" standalone=\"yes\" ?&gt;" &
--   "&lt;list&gt;" &
--   "  &lt;node id=\"proxmox\" claimed=\"true\" class=\"system\" handle=\"DMI:0002\"&gt;" &
--   "    &lt;description&gt;Low Profile Desktop Computer&lt;/description&gt;" &
--   "    &lt;product&gt;()&lt;/product&gt;" &
--   "    &lt;vendor&gt;Hewlett-Packard&lt;/vendor&gt;" &
--   "  &lt;/node&gt;" &
--   "&lt;/list&gt;"
-- )
--</example>
--<see_also>get_tag(), get_attributes(), get_attribute_value()</see_also>
--</function>
  elements = {}
  pos = 0
  buffer = s
  elements = scan_tag()
--  analyze_object(elements, "elements", f_debug)
  return elements
end function

------------------------------------------------------------------------------

public function get_tag_name(sequence s)
--<function>
--<name>get_tag_name</name>
--<digest>gets the first tag of an XML string</digest>
--<desc></desc>
--<param>
--<type>sequence</type>
--<name>s</name>
--<desc>XML string to convert</desc>
--</param>
--<return>
-- sequence
--</return>
--<example>
-- s = get_tag_name("&lt;setting id=\"driver\" value=\"MOSCHIP usb-ethernet driver\" /&gt;")
-- s will get value "setting"
--</example>
--<see_also>xml_to_sequence(), get_attributes(), get_attribute_value()</see_also>
--</function>
  sequence xml_content

  xml_content = analyze_tag(s)
  return xml_content[TAG_NAME]
end function

------------------------------------------------------------------------------

public function get_attributes(sequence s)
--<function>
--<name>get_attributes</name>
--<digest>gets the list of attributes of a single tag XML string</digest>
--<desc>
-- the list is returned as a sequence of pairs {name, value}
--</desc>
--<param>
--<type>sequence</type>
--<name>s</name>
--<desc>XML string to convert</desc>
--</param>
--<return>
-- sequence
--</return>
--<example>
-- s = get_attributes("&lt;setting id=\"driver\" value=\"MOSCHIP usb-ethernet driver\" /&gt;")
-- s will get value {{"id", "driver"}, {"value", "MOSCHIP usb-ethernet driver"}}
--</example>
--<see_also>xml_to_sequence(), get_tag_name(), get_attribute_value()</see_also>
--</function>
  sequence xml_content

  xml_content = analyze_tag(s)
  return xml_content[TAG_ATTRIBUTES]
end function

------------------------------------------------------------------------------

public function get_attribute_value(sequence name, sequence s)
--<function>
--<name>get_attribute_value</name>
--<digest>returns the value associated with an attribute name</digest>
--<desc>
--</desc>
--<param>
--<type>sequence</type>
--<name>name</name>
--<desc>attribute name</desc>
--</param>
--<param>
--<type>sequence</type>
--<name>s</name>
--<desc>XML string</desc>
--</param>
--<return>
-- sequence
--</return>
--<example>
-- s = get_attribute_value("id", "&lt;setting id=\"driver\" value=\"MOSCHIP usb-ethernet driver\" /&gt;")
-- s will get value "driver"
--</example>
--<see_also>xml_to_sequence(), get_tag_name(), get_attributes()()</see_also>
--</function>
  sequence attributes

  attributes = get_attributes(s)
  return vlookup(name, attributes, 1, 2, {})
end function

------------------------------------------------------------------------------

constant TAG_TYPE_FILTER = {TEXT, ATTR_VALUE}
  
public function search_target(sequence name, sequence elements)
--<function>
--<name>search_target</name>
--<digest>returns the path to the item containing <i>name</i> in structure <i>elements</i></digest>
--<desc>
-- searches the best target in this order
-- * exact match if unique (when find_all_nested returns one unique path)
-- * if no exact match is found then partial match if unique (match)
-- * if many exact matches found then filter on tag type TEXT, return filtered matches if not null
-- * if many partial matches found then filter on tag type TEXT, return filtered matches if not null
-- * if many exact matches found then filter on tag type ATTR_VALUE, return filtered matches if not null
-- * if many partial matches found then filter on tag type ATTR_VALUE, return filtered matches if not null
-- * if exact matches found then return matches
-- * return partial matches
--</desc>
--<param>
--<type>sequence</type>
--<name>name</name>
--<desc>value to search for</desc>
--</param>
--<param>
--<type>sequence</type>
--<name>elements</name>
--<desc>detailed HTML/XML parser result</desc>
--</param>
--<return>
-- sequence: list of pathes that match <i>name</i>
--</return>
--<example>
-- s = search_target("0001AAAA", elements, html)
--</example>
--<see_also>xml_to_sequence(), get_closest_link()</see_also>
--</function>
  sequence found_exact, found_matching, filtered
  integer ok, n

  found_exact = find_all_nested(name, elements)
  analyze_object(found_exact, "found_exact", f_debug)
  if length(found_exact) = 1 then  -- unique selector
    return found_exact
  elsif length(found_exact) = 0 then     -- not found
    found_matching = match_all_nested(name, elements)
    analyze_object(found_matching, "found_matching", f_debug)
    if length(found_matching) = 1 then  -- unique selector
      return found_matching
    elsif length(found_matching) = 0 then     -- not found
      return {}
    end if
  else                                -- many items corresponding to the description
    for f = 1 to length(TAG_TYPE_FILTER) do
      filtered = {}
      for i = 1 to length(found_exact) do
        if elements[found_exact[i][1]][TAG_TYPE] = TAG_TYPE_FILTER[f] then
          filtered = append(filtered, found_exact[i])
        end if
      end for
      analyze_object(filtered, "filtered", f_debug)
      if length(filtered) then return filtered end if
      filtered = {}
      for i = 1 to length(found_matching) do
        if elements[found_matching[i][1]][TAG_TYPE] = TAG_TYPE_FILTER[f] then
          filtered = append(filtered, found_exact[i])
        end if
      end for
      analyze_object(filtered, "filtered", f_debug)
      if length(filtered) then return filtered end if
    end for
  end if
  if length(found_exact) then
    return found_exact
  else
    return found_matching
  end if
end function

------------------------------------------------------------------------------

public function get_parent_containing(sequence path, sequence id,
                                      sequence elements, sequence buffer)
--<function>
--<name>get_parent_containing</name>
--<digest>returns the position of parent tag in structure <i>elements</i></digest>
--<desc></desc>
--<param>
--<type>sequence</type>
--<name>path</name>
--<desc>numerical path to a tag</desc>
--</param>
--<param>
--<type>sequence</type>
--<name>id</name>
--<desc>value to search for</desc>
--</param>
--<param>
--<type>sequence</type>
--<name>elements</name>
--<desc>detailed HTML/XML parser result</desc>
--</param>
--<param>
--<type>sequence</type>
--<name>buffer</name>
--<desc>HTML/XML string</desc>
--</param>
--<return>
-- sequence
--</return>
--<example>
-- parent = get_parent_containing({504,3,5,2}, "0001AAAA", elements, html)
--</example>
--<see_also>xml_to_sequence(), get_closest_link()</see_also>
--</function>
  sequence parent
  integer ok, n

  ok = 0
  n = path[1]
  parent = elements[n]
  while (n > 1) and not match(id, buffer[parent[TAG_START]..parent[TAG_END]]) do
    n -= 1
    parent = elements[n]
--    analyze_object(parent, "parent", f_debug)
  end while
  return n
end function

------------------------------------------------------------------------------

public function get_closest_link(sequence path, sequence elements, sequence html)
--<function>
--<name>get_closest_link</name>
--<digest>returns link closest to the tag position in structure <i>elements</i></digest>
--<desc></desc>
--<param>
--<type>sequence</type>
--<name>path</name>
--<desc>numerical path to a tag</desc>
--</param>
--<type>sequence</type>
--<name>elements</name>
--<desc>detailed HTML/XML parser result</desc>
--</param>
--<param>
--<type>sequence</type>
--<name>buffer</name>
--<desc>HTML/XML string</desc>
--</param>
--<return>
-- sequence
--</return>
--<example>
-- parent = get_closest_link({504,3,5,2}, elements, html)
--</example>
--<see_also>xml_to_sequence(), get_parent_containing()</see_also>
--</function>
  integer parent, st, en

  parent = get_parent_containing(path, "href", elements, html)
  analyze_object(parent, "parent", f_debug)
  st = elements[parent][TAG_START]
  en = elements[parent][TAG_END]
  return get_attribute_value("href", html[st..en])
end function


