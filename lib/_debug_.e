-- _debug_.e
-- debug controls

include std/filesys.e
include std/text.e
include std/win32/msgbox.e
include std/os.e
include std/io.e
include _version_.e
include _types_.e

public constant WARNING_MSG = 1, ERROR_MSG = 2
--<constant>
--<name>WARNING_MSG</name>
--<value>1</value>
--<desc>to be used with display_message(): makes a warning appear</desc>
--</constant>
--<constant>
--<name>ERROR_MSG</name>
--<value>2</value>
--<desc>to be used with display_message(): makes an error message appear</desc>
--</constant>

------------------------------------------------------------------------------

public function date_stamp(sequence msg)
--<function>
--<name>date_stamp</name>
--<digest>prefixes the given message by date and time for logging purposes</digest>
--<desc></desc>
--<param>
--<type>sequence</type>
--<name>msg</name>
--<desc>string to prefix</desc>
--</param>
--<return>
-- sequence: given string prefixed by date and time
--</return>
-- puts(1, date_stamp("message") & "\n")
-- 2016-11-14 08:14:14 -> message
--<see_also></see_also>
--</function>
  sequence cur_date

  cur_date = date()
  return sprintf("%d-%02d-%02d %02d:%02d:%02d -> %s\n", {
                             (cur_date[1] + 1900), cur_date[2], cur_date[3],
                              cur_date[4], cur_date[5], cur_date[6], msg
                            })
end function

-----------------------------------------------------------------------------

public procedure display_message(sequence msg, integer msgType)
--<procedure>
--<name>display_message</name>
--<digest>displays a given message as an information, a warning or an error message according to the type provided</digest>
--<desc>
-- if given type is WARNING_MSG, displays a warning
-- if given type is ERROR_MSG, displays an error message
-- if given type is anything else, displays an information message
--
-- On Windows, message is displayed in a message_box.
-- On Linux, message is displayed on stderr
--</desc>
--<param>
--<type>sequence</type>
--<name>msg</name>
--<desc>message to display</desc>
--</param>
--<param>
--<type>integer</type>
--<name>msgType</name>
--<desc>
-- kind of message to display:
-- either WARNING_MSG, ERROR_MSG are whatever else
--</desc>
--</param>
--<example>
-- display_message("Information", 0)
-- display_message("Warning", WARNING_MSG)
-- display_message("Error", ERROR_MSG)
--</example>
--<see_also>error_message()</see_also>
--</procedure>
  log_puts(msg)

ifdef WINDOWS then
  if msgType = WARNING_MSG then
    void = message_box(msg, "Warning", MB_ICONWARNING+MB_OK+MB_APPLMODAL+MB_SETFOREGROUND)
  elsif msgType = ERROR_MSG then
    void = message_box(msg, "Error", MB_ICONERROR+MB_OK+MB_APPLMODAL+MB_SETFOREGROUND)
  else
    void = message_box(msg, "Information", MB_ICONINFORMATION+MB_OK+MB_APPLMODAL+MB_SETFOREGROUND)
  end if
elsifdef LINUX then
  if msgType = WARNING_MSG then
    puts(2, "Warning: " & msg & "\n")
  elsif msgType = ERROR_MSG then
    puts(2, "Error: " & msg & "\n")
  else
    puts(2, "Info: " & msg & "\n")
  end if
end ifdef

end procedure

------------------------------------------------------------------------------

public function show_printable(object s)
--<function>
--<name>show_printable</name>
--<digest>replaces non-printable characters in a string</digest>
--<desc>
-- special characters are displayed within square brackets: [lf], [cr], [tab], ...
-- other non-printable characters are replaced by a dot.
--</desc>
--<param>
--<type>object</type>
--<name>s</name>
--<desc>object to display, either an atom, an integer or a string</desc>
--</param>
--<return>
-- sequence: a readable string
--</return>
--<example>
-- puts(1, show_printable("One\tTwo\r\n" & 253 & "abc") would display
-- "One[tab]Two[cr][lf].abc"
--</example>
--<see_also></see_also>
--</function>
  sequence res

  res = ""
  for i = 1 to length(s) do
    if sequence(s[i]) then
        res &= "{}"
    elsif integer(s[i]) then
      if (s[i] > 31) and (s[i] < 255) then
        res &= s[i]
      elsif s[i] = 8 then
        res &= "[bksp]"
      elsif s[i] = 9 then
        res &= "[tab]"
      elsif s[i] = 10 then
        res &= "[lf]"
      elsif s[i] = 11 then
        res &= "[vtab]"
      elsif s[i] = 12 then
        res &= "[ff]"
      elsif s[i] = 13 then
        res &= "[cr]"
      else
        res &= "."
      end if
    else
      res &= "."
    end if
  end for
  return res
end function

------------------------------------------------------------------------------

public function object_dump(object x)
--<function>
--<name>object_dump</name>
--<digest>prints an object structure in a human readable way as one string</digest>
--<desc></desc>
--<param>
--<type>object</type>
--<name>x</name>
--<desc>object to dump</desc>
--</param>
--<return>
--</return>
--<example>
-- s = object_dump({12, "error", 36.8})
-- s takes value {12, 'error', 36.8}
-- s = object_dump({{1}}&"message"&10&"and"&{{8,2},4}&233)
-- s takes value {{1},109,101,115,115,97,103,101,10,97,110,100,{8,2},4,233}      '{}message[lf]and{}.Ú'
--</example>
--<see_also></see_also>
--</function>
  integer subSequence
  sequence s

--  analyze_object(x, "x", f_debug)
  s = ""
  if integer(x) then
    s = sprintf("%d", {x})
  elsif atom(x) then
    if (x >= 0) and (x = floor(x)) then
      s = sprintf("%.0f", {x})
    elsif (x < 0) and (x = floor(x+1)) then
      s = sprintf("%.0f", {x})
    else
      s = sprintf("%f", {x})
    end if
  elsif is_string(x) then
    if length(x) = 0 then
      s = "''"
    else
      s = sprintf("'%s'", {show_printable(x)})
    end if
  else
    subSequence = 0
    for i=1 to length(x) do
      if sequence(x[i]) then
        subSequence = 1
        exit
      end if
    end for
    if subSequence = 0 then
      if is_string(x) then
        s = sprintf("'%s'", {show_printable(x)})
      else
        s = sprintf("%s", {sprint(x)})
      end if
    elsif length(x) then
      s = "{" & object_dump(x[1])
      if length(x) > 1 then
        for i=2 to length(x) do
          s &= ", " & object_dump(x[i])
        end for
      end if
      s &= "}"
    end if
  end if
  return s
end function

------------------------------------------------------------------------------

public procedure hex_dump(sequence s, integer output)
--<procedure>
--<name>hex_dump</name>
--<digest>dumps a sequence in hex form to the specified output</digest>
--<desc>
-- global integer <b>with_debug</b> has to be set to get a result
--</desc>
--<param>
--<type>sequence</type>
--<name>s</name>
--<desc>sequence to dump in hex form</desc>
--</param>
--<param>
--<type>integer</type>
--<name>output</name>
--<desc>output stream</desc>
--</param>
--<example>
-- hex_dump("0123456789ABCDEF"&0&1&2&3&4, 1)
-- Addr   0  1  2  3  4  5  6  7  8  9  A  B  C  D  E  F  0123456789ABCDEF
-- 0000  30 31 32 33 34 35 36 37 38 39 41 42 43 44 45 46  0123456789ABCDEF
-- 0001  00 01 02 03 04                                   .....
--</example>
--<see_also></see_also>
--</procedure>
  sequence address, binary, ascii
  integer lg

  if with_debug = 0 then return end if
  puts(output, "\nAddr   0  1  2  3  4  5  6  7  8  9  A  B  C  D  E  F  0123456789ABCDEF\n")
  address = "0000 "
  binary = ""
  ascii  = "  "
  lg = length(s)
  for i = 1 to lg do
    binary &= sprintf(" %02x", s[i])
    if (s[i] > 31) and (s[i] < 127) then
      ascii &= s[i]
    elsif s[i] = 9 then
      ascii &= "\\t"
    elsif s[i] = 13 then
      ascii &= "\\r"
    elsif s[i] = 10 then
      ascii &= "\\n"
    else
      ascii &= "."
    end if
    if (remainder(i-1, 16) = 15) then
      puts(output, address&binary&ascii&"\n")
      address = sprintf("%04x ", i)
      binary = ""
      ascii  = "  "
    end if
  end for
  lg = length(binary)
  if lg then
    puts(output, address&sprintf("%-48s", {binary})&ascii&"\n")
  end if
  puts(output, "\n")
end procedure

------------------------------------------------------------------------------

procedure scan_object(object x, sequence name, integer output,
                      integer translator, integer detailed, sequence path,
                      integer level, sequence prefix)
-- prints a sequence structure in a human readable way
  integer subSequence
  sequence s, offset

  offset = ""
  for i = 1 to level do offset &= ".  " end for
  s = ""
  if integer(x) then
    s = sprintf(" %d", {x})
    puts(output, offset&prefix&s&"\n")
  elsif atom(x) then
    if (x >= 0) and (x = floor(x)) then
      s = sprintf(" %.0f", {x})
    elsif (x < 0) and (x = floor(x+1)) then
      s = sprintf(" %.0f", {x})
    else
      s = sprintf(" %f", {x})
    end if
    puts(output, offset&prefix&s&"\n")
  elsif is_string(x) then
    if length(x) = 0 then
      s = " ''"
    else
      s = sprintf(" '%s'", {show_printable(x)})
      if detailed then s &= sprintf(" (%s)", {sprint(x)}) end if
    end if
    puts(output, offset&prefix&s&"\n")
  else
    subSequence = 0
    for i=1 to length(x) do
      if sequence(x[i]) then
        subSequence = 1
        exit
      end if
    end for
    if subSequence = 0 then
      if is_string(x) then
        s = sprintf(" '%s'", {show_printable(x)})
        if detailed then s &= sprintf(" (%s)", {sprint(x)}) end if
      else
        s = sprintf(" %s", {sprint(x)})
      end if
      puts(output, offset&prefix&s&"\n")
    else
      if length(s) = 0 then
        puts(output, offset&prefix&"\n")
      end if
      for i=1 to length(x) do
        if translator != -1 then
          prefix = sprintf("[%s]", { call_func(translator, {path, level, i, x[i]}) })
        else
          prefix = sprintf("[%d]", i)
        end if
        scan_object(x[i], name, output, translator, detailed, path&sprintf("[%d]", i), level+1, prefix)
      end for
    end if
  end if
  if output=f_debug then flush(f_debug) end if
end procedure

public procedure analyze_object(object x, sequence name, integer output=1,
                                integer translator=-1, integer detailed=0)
--<procedure>
--<name>analyze_object</name>
--<digest>dumps an object in a hierarchical structure</digest>
--<desc>
-- elements of the sequence are displayed in a tree view with numbered items
-- item numbers can be replaced by strings if a conversion routine is provided
-- global integer <b>with_debug</b> has to be set to get a result
--</desc>
--<param>
--<type>object</type>
--<name>x</name>
--<desc>object to dump in a tree view. Nested sequences are allowed.</desc>
--</param>
--<param>
--<type>sequence</type>
--<name>name</name>
--<desc>name to display at the root of the tree view</desc>
--</param>
--<param>
--<type>integer</type>
--<name>output</name>
--<desc>
-- output stream
-- 1 displays on the screen (default)
-- f_debug prints in the debug file if open
--</desc>
--</param>
--<param>
--<type>integer</type>
--<name>translator</name>
--<desc>
-- routine id that translates indexes in understandable names
-- defaults to -1 (no routine provided)
--</desc>
--</param>
--<param>
--<type>integer</type>
--<name>detailed</name>
--<desc>
-- shows strings as sequences of bytes
-- defaults to 0 (no details shown)
--</desc>
--</param>
--<example>
-- example of a conversion routine:
-- function identifyInstruction(sequence path, integer level, integer n, object x)
--   printf(f_debug, "  path: '%s', level: %d, n: %d\n", {path, level, n, object_dump(x)})
--   if level = 1 then
--     if n = 1 then return "TARGET_DEVICE"
--     elsif n = 2 then return "OPERATION"
--     elsif n = 3 then return "INSTRUCTIONS"
--     elsif n = 4 then return "FILTER"
--     end if
--   elsif (level = 2) and ends("[4]", path) then
--     if n = 1 then return "FROM"
--     elsif n = 2 then return "TO"
--     end if
--   end if
--   return sprintf("%d",n)
-- end function
-- integer rtn_ident_instr
-- rtn_ident_instr = routine_id("identifyInstruction")
--
-- analyze_object(endCommands, "endCommands", 1, rtn_ident_instr)
-- would display
-- endCommands = 
-- .  [1]
-- .  .  [TARGET_DEVICE] 1
-- .  .  [OPERATION] ""
-- .  .  [INSTRUCTIONS] "term len 0"
-- .  .  [FILTER] 0
-- .  [2]
-- .  .  [TARGET_DEVICE] 1
-- .  .  [OPERATION] ""
-- .  .  [INSTRUCTIONS] "sh run"
-- .  .  [FILTER]
-- .  .  .  [FROM] "interface 0"
-- .  .  .  [TO] "exit"
--
-- whereas 
-- analyze_object(endCommands, "endCommands")
-- would display
-- endCommands = 
-- .  [1]
-- .  .  [1] 1
-- .  .  [2] ""
-- .  .  [3] "term len 0"
-- .  .  [4] 0
-- .  [2]
-- .  .  [1] 1
-- .  .  [2] ""
-- .  .  [3] "debug cwmp"
-- .  .  [4]
-- .  .  .  [1] "interface 0"
-- .  .  .  [2] "exit"
--</example>
--<see_also></see_also>
--</procedure>
  
  printf(output, "%s = ", {name})
  scan_object(x, name, output, translator, detailed, {}, 0, "")
end procedure

------------------------------------------------------------------------------
