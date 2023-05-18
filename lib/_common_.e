include std/filesys.e
include std/os.e
include std/error.e
include std/io.e
include std/win32/msgbox.e

global integer address_length
--<variable>
--<type>integer</type>
--<name>address_length</name>
--<desc>
-- address length for pointers detected by _version_.e
-- * 4 on 32-bit OSes
-- * 8 on 64-bit OSes
--</desc>
--</variable>
address_length = 4

global constant
  EU_4_1_LNX_64 = 1, EU_4_1_LNX_32 = 2, EU_4_0_LNX = 3,
  EU_4_1_WIN_64 = 5, EU_4_1_WIN_32 = 6, EU_4_0_WIN = 7
--<constant>
--<name>EU_4_1_LNX_64</name>
--<value>1</value>
--<desc>
-- OpenEuphoria 4.1 running on 64-bit Linux
--</desc>
--</constant>
--<constant>
--<name>EU_4_1_LNX_32</name>
--<value>2</value>
--<desc>
-- OpenEuphoria 4.1 running on 32-bit Linux
--</desc>
--</constant>
--<constant>
--<name>EU_4_0_LNX</name>
--<value>3</value>
--<desc>
-- OpenEuphoria 4.0 running on Linux
-- always considered as 32-bit even on 64-bit OSes
--</desc>
--</constant>
--<constant>
--<name>EU_4_1_WIN_64</name>
--<value>5</value>
--<desc>
-- OpenEuphoria 4.1 running on 64-bit Windows
--</desc>
--</constant>
--<constant>
--<name>EU_4_1_WIN_32</name>
--<value>6</value>
--<desc>
-- OpenEuphoria 4.1 running on 32-bit Windows
--</desc>
--</constant>
--<constant>
--<name>EU_4_0_WIN</name>
--<value>7</value>
--<desc>
-- OpenEuphoria 4.0 running on Windows
-- always considered as 32-bit even on 64-bit OSes
--</desc>
--</constant>

global integer f_debug    -- debug file
--<variable>
--<type>integer</type>
--<name>f_debug</name>
--<desc>
-- default debug file handle: defaults to 0 (no_debug)
-- set f_debug to 1 to debug on standard output
-- open a file in write text mode "w" and set f_debug to its handle
-- to debug to a file
-- <code>
-- ex: f_debug = open("debug.log", "w")
-- </code>
--</desc>
--</variable>
f_debug = 0

global integer with_debug
--<variable>
--<type>integer</type>
--<name>with_debug</name>
--<desc>
-- if set, log_puts and log_printf will write to debug file
-- defaults to 0 (no_debug)
--</desc>
--</variable>
with_debug = 0

global sequence InitialDir
--<variable>
--<type>sequence</type>
--<name>InitialDir</name>
--<desc>directory where the program is located. Defaults to ".".</desc>
--</variable>
InitialDir = init_curdir()

global object void
--<variable>
--<type>object</type>
--<name>void</name>
--<desc>
-- Dummy object used when function return value is unused
-- <code>
-- ex: void = change_directory("..")
-- </code>
--</desc>
--</variable>
void = 0

global constant
  ON = 1,
--<constant>
--<name>ON</name>
--<value>1</value>
--<desc></desc>
--</constant>
  OFF = 0,
--<constant>
--<name>OFF</name>
--<value>0</value>
--<desc></desc>
--</constant>
  SUCCESS = 1,
--<constant>
--<name>SUCCESS</name>
--<value>1</value>
--<desc></desc>
--</constant>
  FAIL = 0,
--<constant>
--<name>FAIL</name>
--<value>0</value>
--<desc></desc>
--</constant>
  TRUE  = 1,
--<constant>
--<name>TRUE</name>
--<value>1</value>
--<desc></desc>
--</constant>
  FALSE = 0
--<constant>
--<name>FALSE</name>
--<value>0</value>
--<desc></desc>
--</constant>

integer f_error    -- error file
f_error = 0

------------------------------------------------------------------------------

global procedure log_puts(sequence msg)
--<procedure>
--<name>log_puts</name>
--<digest>puts a sequence in the debug file if open</digest>
--<desc></desc>
--<param>
--<type>sequence</type>
--<name>msg</name>
--<desc>the message to put in the debug file</desc>
--</param>
--<example>
--</example>
--<see_also>log_printf</see_also>
--</procedure>
  sequence dt

  dt = date()
  if f_debug and with_debug then
    printf(f_debug, "%d-%02d-%02d %02d:%02d:%02d --> '%s'\n", {
                             (dt[1] + 1900), dt[2], dt[3],
                              dt[4], dt[5], dt[6], msg
                            })
    -- puts(f_debug, msg)
    flush(f_debug)
  end if
end procedure

------------------------------------------------------------------------------

global procedure log_printf(sequence format, object value)
--<procedure>
--<name>log_printf</name>
--<digest>prints a formatted sequence in the debug file if open</digest>
--<desc>
--</desc>
--<param>
--<type>sequence</type>
--<name>format</name>
--<desc>the format of the value to put in the debug file</desc>
--</param>
--<param>
--<type>object</type>
--<name>value</name>
--<desc>the value to put in the debug file</desc>
--</param>
--<example>
--</example>
--<see_also>log_puts</see_also>
--</procedure>
  sequence dt

  dt = date()
  if f_debug and with_debug then
    printf(f_debug, "%d-%02d-%02d %02d:%02d:%02d --> " & format & "\n", {
                             (dt[1] + 1900), dt[2], dt[3],
                              dt[4], dt[5], dt[6]} & value
                            )
    -- printf(f_debug, format, value)
    flush(f_debug)
  end if
end procedure

------------------------------------------------------------------------------

global procedure error_message(sequence msg, atom quit)
--<procedure>
--<name>error_message</name>
--<digest>logs an error</digest>
--<desc>
-- logs an error and displays a warning
-- then abort if quit is set
--</desc>
--<param>
--<type>sequence</type>
--<name>msg</name>
--<desc>error message to log/display</desc>
--</param>
--<param>
--<type>atom</type>
--<name>quit</name>
--<desc>abort (1) or not (0)</desc>
--</param>
--<example>
-- if atom(o) then
--   error_message(sprintf("Unknown option '%d'", {option}), 1)
-- end if
--</example>
--<see_also>
--</see_also>
--</procedure>
  if f_debug then  -- even if with_debug is not set
    puts(f_debug, msg)
    flush(f_debug)
  end if
  if not f_error then
    f_error = open(InitialDir & SLASH & "error.log", "w")
  end if
  puts(f_error, msg)
  flush(f_error)
ifdef WINDOWS then
  void = message_box(msg, "Error", MB_ICONERROR+MB_OK+MB_APPLMODAL+MB_SETFOREGROUND)
elsifdef LINUX then
  puts(2, "Error: " & msg & "\n")
end ifdef
  if quit then
    close(f_error)
    if f_debug then close(f_debug) end if
    abort(1)
  end if
end procedure

------------------------------------------------------------------------------

global function get_option(sequence name, sequence options, object default)
--<function>
--<name>get_option</name>
--<digest>extracts an option value form a list of options</digest>
--<desc>
--</desc>
--<param>
--<type>sequence</type>
--<name>name</name>
--<desc>name associated to a value</desc>
--</param>
--<param>
--<type>sequence</type>
--<name>options</name>
--<desc>list of pairs {name, value}</desc>
--</param>
--<param>
--<type>object</type>
--<name>default</name>
--<desc></desc>
--</param>
--<return>
-- object: value associated with specified mane
--</return>
--<example>
-- search_field = get_option("search_field", optional, 1)
-- returns optional value associated with "search_field" in sequence optional
-- defaults to 1 if not found
-- example of a call to the parent function:
-- find_in_array(2, {{"first",1},{"second",2}}, {{"search_field",2}})
--</example>
--<see_also>
--</see_also>
--</function>
  for i = 1 to length(options) do
    if compare(name, options[i][1]) = 0 then
      return options[i][2]
    end if
  end for
  return default
end function

------------------------------------------------------------------------------

crash_file(InitialDir & SLASH & "ex.err")

