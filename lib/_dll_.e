include std/dll.e
include std/os.e
include std/machine.e
include std/search.e
include _version_.e
include _search_.e
include _machine_.e
include _sequence_.e
include _debug_.e

public constant
  -- basic C types
  int8  = #01000001, int16  = #01000002, int32  = #01000004, int64  = #01000008,
  uint8 = #02000001, uint16 = #02000002, uint32 = #02000004, uint64 = #02000008,
  pointer = #03000001, long_pointer = #03000002, float = #03000004, double = #03000008,
  bool = int32,
  -- extended C types
  Bool = bool, byte = uint8, char = uint8, char16 = uint16, char16_t = uint16,
  char32 = uint32, char32_t = uint32, double_t = double, dword = uint32,
  dwordlong = uint64, float_t = float, int = int32, int8_t = int8,
  int16_t = int16, int32_t = int32, int64_t = int64, intptr = pointer,
  intptr_t = pointer, long = int32, long_double = pointer, long_int = int32,
  long_long = int64, long_long_int = int64, longlong = int64,
  ptrdiff_t = pointer, short = int16, short_int = int16, signed = int32,
  signed_char = int8, signed_int = int32, signed_long = int32,
  signed_long_int = int32, signed_long_long = int64,
  signed_long_long_int = int64, signed_short = int16, signed_short_int = int16,
  size_t = pointer, ssize_t = pointer, uint8_t = uint8, uint16_t = uint16,
  uint32_t = uint32, uint64_t = uint64, uintptr = pointer, uintptr_t = pointer,
  ulonglong = uint64, unsigned = uint32, unsigned_char = uint8,
  unsigned_int = uint32, unsigned_long = uint32, unsigned_long_int = uint32,
  unsigned_long_long = uint64, unsigned_long_long_int = uint64,
  unsigned_short = uint16, unsigned_short_int = uint16,
  wchar = uint16, wchar_t = uint16, word = uint16, time_t = pointer,
  uint = uint32, ulong = uint32, ushort = uint16
--<constant>
--<name>int8</name>
--<value>#01000001</value>
--<desc></desc>
--</constant>
--<constant>
--<name>int16</name>
--<value>#01000002</value>
--<desc></desc>
--</constant>
--<constant>
--<name>int32</name>
--<value>#01000004</value>
--<desc></desc>
--</constant>
--<constant>
--<name>int64</name>
--<value>#01000008</value>
--<desc></desc>
--</constant>
--<constant>
--<name>uint8</name>
--<value>#02000001</value>
--<desc></desc>
--</constant>
--<constant>
--<name>uint16</name>
--<value>#02000002</value>
--<desc></desc>
--</constant>
--<constant>
--<name>uint32</name>
--<value>#02000004</value>
--<desc></desc>
--</constant>
--<constant>
--<name>uint64</name>
--<value>#02000008</value>
--<desc></desc>
--</constant>
--<constant>
--<name>pointer</name>
--<value>#03000001</value>
--<desc></desc>
--</constant>
--<constant>
--<name>long_pointer</name>
--<value>#03000002</value>
--<desc></desc>
--</constant>
--<constant>
--<name>float</name>
--<value>#03000004</value>
--<desc></desc>
--</constant>
--<constant>
--<name>double</name>
--<value>#03000008</value>
--<desc></desc>
--</constant>
--<constant>
--<name>bool</name>
--<value>int32</value>
--<desc></desc>
--</constant>
--<constant>
--<name>Bool</name>
--<value>bool</value>
--<desc></desc>
--</constant>
--<constant>
--<name>byte</name>
--<value>uint8</value>
--<desc></desc>
--</constant>
--<constant>
--<name>char</name>
--<value>uint8</value>
--<desc></desc>
--</constant>
--<constant>
--<name>char16</name>
--<value>uint16</value>
--<desc></desc>
--</constant>
--<constant>
--<name>char16_t</name>
--<value>uint16</value>
--<desc></desc>
--</constant>
--<constant>
--<name>char32</name>
--<value>uint32</value>
--<desc></desc>
--</constant>
--<constant>
--<name>char32_t</name>
--<value>uint32</value>
--<desc></desc>
--</constant>
--<constant>
--<name>double_t</name>
--<value>double</value>
--<desc></desc>
--</constant>
--<constant>
--<name>dword</name>
--<value>uint32</value>
--<desc></desc>
--</constant>
--<constant>
--<name>dwordlong</name>
--<value>uint64</value>
--<desc></desc>
--</constant>
--<constant>
--<name>float_t</name>
--<value>float</value>
--<desc></desc>
--</constant>
--<constant>
--<name>int</name>
--<value>int32</value>
--<desc></desc>
--</constant>
--<constant>
--<name>int8_t</name>
--<value>int8</value>
--<desc></desc>
--</constant>
--<constant>
--<name>int16_t</name>
--<value>int16</value>
--<desc></desc>
--</constant>
--<constant>
--<name>int32_t</name>
--<value>int32</value>
--<desc></desc>
--</constant>
--<constant>
--<name>int64_t</name>
--<value>int64</value>
--<desc></desc>
--</constant>
--<constant>
--<name>intptr</name>
--<value>pointer</value>
--<desc></desc>
--</constant>
--<constant>
--<name>intptr_t</name>
--<value>pointer</value>
--<desc></desc>
--</constant>
--<constant>
--<name>long</name>
--<value>int32</value>
--<desc></desc>
--</constant>
--<constant>
--<name>long_double</name>
--<value>pointer</value>
--<desc></desc>
--</constant>
--<constant>
--<name>long_int</name>
--<value>int32</value>
--<desc></desc>
--</constant>
--<constant>
--<name>long_long</name>
--<value>int64</value>
--<desc></desc>
--</constant>
--<constant>
--<name>long_long_int</name>
--<value>int64</value>
--<desc></desc>
--</constant>
--<constant>
--<name>longlong</name>
--<value>int64</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ptrdiff_t</name>
--<value>pointer</value>
--<desc></desc>
--</constant>
--<constant>
--<name>short</name>
--<value>int16</value>
--<desc></desc>
--</constant>
--<constant>
--<name>short_int</name>
--<value>int16</value>
--<desc></desc>
--</constant>
--<constant>
--<name>signed</name>
--<value>int32</value>
--<desc></desc>
--</constant>
--<constant>
--<name>signed_char</name>
--<value>int8</value>
--<desc></desc>
--</constant>
--<constant>
--<name>signed_int</name>
--<value>int32</value>
--<desc></desc>
--</constant>
--<constant>
--<name>signed_long</name>
--<value>int32</value>
--<desc></desc>
--</constant>
--<constant>
--<name>signed_long_int</name>
--<value>int32</value>
--<desc></desc>
--</constant>
--<constant>
--<name>signed_long_long</name>
--<value>int64</value>
--<desc></desc>
--</constant>
--<constant>
--<name>signed_long_long_int</name>
--<value>int64</value>
--<desc></desc>
--</constant>
--<constant>
--<name>signed_short</name>
--<value>int16</value>
--<desc></desc>
--</constant>
--<constant>
--<name>signed_short_int</name>
--<value>int16</value>
--<desc></desc>
--</constant>
--<constant>
--<name>size_t</name>
--<value>pointer</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ssize_t</name>
--<value>pointer</value>
--<desc></desc>
--</constant>
--<constant>
--<name>uint8_t</name>
--<value>uint8</value>
--<desc></desc>
--</constant>
--<constant>
--<name>uint16_t</name>
--<value>uint16</value>
--<desc></desc>
--</constant>
--<constant>
--<name>uint32_t</name>
--<value>uint32</value>
--<desc></desc>
--</constant>
--<constant>
--<name>uint64_t</name>
--<value>uint64</value>
--<desc></desc>
--</constant>
--<constant>
--<name>uintptr</name>
--<value>pointer</value>
--<desc></desc>
--</constant>
--<constant>
--<name>uintptr_t</name>
--<value>pointer</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ulonglong</name>
--<value>uint64</value>
--<desc></desc>
--</constant>
--<constant>
--<name>unsigned</name>
--<value>uint32</value>
--<desc></desc>
--</constant>
--<constant>
--<name>unsigned_char</name>
--<value>uint8</value>
--<desc></desc>
--</constant>
--<constant>
--<name>unsigned_int</name>
--<value>uint32</value>
--<desc></desc>
--</constant>
--<constant>
--<name>unsigned_long</name>
--<value>uint32</value>
--<desc></desc>
--</constant>
--<constant>
--<name>unsigned_long_int</name>
--<value>uint32</value>
--<desc></desc>
--</constant>
--<constant>
--<name>unsigned_long_long</name>
--<value>uint64</value>
--<desc></desc>
--</constant>
--<constant>
--<name>unsigned_long_long_int</name>
--<value>uint64</value>
--<desc></desc>
--</constant>
--<constant>
--<name>unsigned_short</name>
--<value>uint16</value>
--<desc></desc>
--</constant>
--<constant>
--<name>unsigned_short_int</name>
--<value>uint16</value>
--<desc></desc>
--</constant>
--<constant>
--<name>wchar</name>
--<value>uint16</value>
--<desc></desc>
--</constant>
--<constant>
--<name>wchar_t</name>
--<value>uint16</value>
--<desc></desc>
--</constant>
--<constant>
--<name>word</name>
--<value>uint16</value>
--<desc></desc>
--</constant>
--<constant>
--<name>time_t</name>
--<value>pointer</value>
--<desc></desc>
--</constant>
--<constant>
--<name>uint</name>
--<value>uint32</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ulong</name>
--<value>uint32</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ushort</name>
--<value>uint16</value>
--<desc></desc>
--</constant>

public constant CTYPE_NAMES = {
--<constant>
--<name>CTYPE_NAMES</name>
--<value>{</value>
--<desc></desc>
--</constant>
  {Bool                  , "_Bool"},
  {bool                  , "bool"},
  {byte                  , "byte"},
  {char                  , "char"},
  {char16                , "char16"},
  {char16_t              , "char16_t"},
  {char32                , "char32"},
  {char32_t              , "char32_t"},
  {double                , "double"},
  {double_t              , "double_t"},
  {dword                 , "dword"},
  {dwordlong             , "dwordlong"},
  {float                 , "float"},
  {float_t               , "float_t"},
  {int                   , "int"},
  {int8                  , "int8"},
  {int8_t                , "int8_t"},
  {int16                 , "int16"},
  {int16_t               , "int16_t"},
  {int32                 , "int32"},
  {int32_t               , "int32_t"},
  {int64                 , "int64"},
  {int64_t               , "int64_t"},
  {intptr                , "intptr"},
  {intptr_t              , "intptr_t"},
  {long                  , "long"},
  {long_double           , "long double"},
  {long_int              , "long int"},
  {long_long             , "long long"},
  {long_long_int         , "long long int"},
  {longlong              , "longlong"},
  {pointer               , "pointer"},
  {ptrdiff_t             , "ptrdiff_t"},
  {short                 , "short"},
  {short_int             , "short int"},
  {signed                , "signed"},
  {signed_char           , "signed char"},
  {signed_int            , "signed int"},
  {signed_long           , "signed long"},
  {signed_long_int       , "signed long int"},
  {signed_long_long      , "signed long long"},
  {signed_long_long_int  , "signed long long int"},
  {signed_short          , "signed short"},
  {signed_short_int      , "signed short int"},
  {size_t                , "size_t"},
  {ssize_t               , "ssize_t"},
  {time_t                , "time_t"},
  {uint8                 , "uint8"},
  {uint8_t               , "uint8_t"},
  {uint16                , "uint16"},
  {uint16_t              , "uint16_t"},
  {uint32                , "uint32"},
  {uint32_t              , "uint32_t"},
  {uint64                , "uint64"},
  {uint64_t              , "uint64_t"},
  {uintptr               , "uintptr"},
  {uintptr_t             , "uintptr_t"},
  {ulonglong             , "ulonglong"},
  {unsigned              , "unsigned"},
  {unsigned_char         , "unsigned char"},
  {unsigned_int          , "unsigned int"},
  {unsigned_long         , "unsigned long"},
  {unsigned_long_int     , "unsigned long int"},
  {unsigned_long_long    , "unsigned long long"},
  {unsigned_long_long_int, "unsigned long long int"},
  {unsigned_short        , "unsigned short"},
  {unsigned_short_int    , "unsigned short int"},
  {wchar                 , "wchar"},
  {wchar_t               , "wchar_t"},
  {word                  , "word"}
}

public constant
  L_NAME = 1, L_LNX_64 = 2, L_LNX_32 = 3, L_WIN_64 = 4, L_WIN_32 = 5
--<constant>
--<name>L_NAME</name>
--<value>1</value>
--<desc></desc>
--</constant>
--<constant>
--<name>L_LNX_64</name>
--<value>2</value>
--<desc></desc>
--</constant>
--<constant>
--<name>L_LNX_32</name>
--<value>3</value>
--<desc></desc>
--</constant>
--<constant>
--<name>L_WIN_64</name>
--<value>4</value>
--<desc></desc>
--</constant>
--<constant>
--<name>L_WIN_32</name>
--<value>5</value>
--<desc></desc>
--</constant>

public constant
  F_NAME = 1, F_INPUT = 2, F_OUTPUT = 3
--<constant>
--<name>F_NAME</name>
--<value>1</value>
--<desc></desc>
--</constant>
--<constant>
--<name>F_INPUT</name>
--<value>2</value>
--<desc></desc>
--</constant>
--<constant>
--<name>F_OUTPUT</name>
--<value>3</value>
--<desc></desc>
--</constant>

--------------------------------------------------------------------------------

public function size_of( atom ctype )
--<function>
--<name>size_of</name>
--<digest></digest>
--<desc>
--</desc>
--<param>
--<type>atom</type>
--<name>ctype</name>
--<desc></desc>
--</param>
--<return>
--</return>
--<example>
-- ? size_of(pointer)
--</example>
--<see_also>
--</see_also>
--</function>
  if ctype = #03000001 then
    return address_length
  elsif ctype = #03000002 then  -- T_LONGLONG
    return 8
  else
    return and_bits( ctype, #FF )
  end if
end function

--------------------------------------------------------------------------------

function link_c_func(atom dll, sequence name, sequence args, atom result)
  atom handle

ifdef WINDOWS then
  handle = define_c_func(dll, name, args, result)
elsifdef LINUX then
  handle = define_c_func(dll, name, args, result)
end ifdef
  if handle = -1 then
    error_message("function " & name & " not found", 1)
  end if
  return handle
end function

--------------------------------------------------------------------------------

function link_c_proc(atom dll, sequence name, sequence args)
  atom handle

ifdef WINDOWS then
  handle = define_c_proc(dll, name, args)
elsifdef LINUX then
  handle = define_c_proc(dll, name, args)
end ifdef
  if handle = -1 then
    error_message("procedure " & name & " not found", 1)
  end if
  return handle
end function

--------------------------------------------------------------------------------

function link_c_var(atom dll, sequence name)
  atom address

ifdef WINDOWS then
  address = define_c_var(dll, name)
elsifdef LINUX then
  address = define_c_var(dll, name)
end ifdef
  if address = -1 then
    error_message("variable " & name & " not found", 1)
  end if
  return address
end function

-----------------------------------------------------------------------------

function convert_c_type(atom ctype)
  if find(eu_version, {EU_4_0_LNX, EU_4_0_WIN}) then
    if ctype = int64 then
--      log_puts("type int64 converted to int32\n")
      return int32
    elsif (ctype = uint64) or (ctype = pointer) then
--      log_puts("type uint64 converted to uint32\n")
      return uint32
    end if
  end if
  if ctype = long_pointer then
    if find(eu_version, {EU_4_0_LNX, EU_4_0_WIN}) then
--      log_puts("type long_pointer converted to double\n")
      return double
    end if
  end if
  return ctype
end function

-----------------------------------------------------------------------------

function convert_c_sequence(sequence input)
  sequence result
  
  result = input
  for i = 1 to length(input) do
    result[i] = convert_c_type(input[i])
  end for
  return result
end function

--------------------------------------------------------------------------------

public function allocate_structure(atom p, sequence def)
--<function>
--<name>allocate_structure</name>
--<digest></digest>
--<desc>
-- allocates memory according to a structure definition
-- automatically sizes structure to EU version and OS Architecture
--</desc>
--<param>
--<type>atom</type>
--<name>p</name>
--<desc></desc>
--</param>
--<param>
--<type>sequence</type>
--<name>def</name>
--<desc></desc>
--</param>
--<return>
--</return>
--<example>
-- atom p = NULL
-- p = allocateStructure(p, {pointer, int, int} )
--</example>
--<see_also>
--</see_also>
--</function>
  integer lg
  atom ctype

--  log_printf("allocate_structure(#%x, %s)\n", {p, hex_sequence(def)})
  lg = 0
  for i = 1 to length(def) do
    ctype = convert_c_type(def[i])
    lg += size_of(ctype)
--    log_printf("allocate_structure: lg = %d\n", {lg})
  end for
  if lg then p = allocate(lg) end if
--    log_printf("allocate_structure: p = #%x, lg = %d\n", {p, lg})
  return p
end function

-----------------------------------------------------------------------------

public procedure write_structure(atom p, sequence def, sequence values)
--<procedure>
--<name>write_structure</name>
--<digest></digest>
--<desc>
-- writes data in memory according to a structure definition
-- automatically sizes structure to EU version and OS Architecture
--</desc>
--<param>
--<type>atom</type>
--<name>p</name>
--<desc></desc>
--</param>
--<param>
--<type>sequence</type>
--<name>def</name>
--<desc></desc>
--</param>
--<param>
--<type>sequence</type>
--<name>values</name>
--<desc></desc>
--</param>
--<return>
--</return>
--<example>
-- writeStructure(p, {pointer, int, int}, {hwnd, 12, 25} )
--</example>
--<see_also>
--</see_also>
--</procedure>
  atom ctype --, ptr

--  ptr = p
--  log_printf("write_structure(#%x, %s, %s)\n", {p, hex_sequence(def), sprint(values)})
  for i = 1 to length(def) do
    ctype = convert_c_type(def[i])
    if (ctype = int8) or (ctype = uint8) then  -- 8-bit signed, unsigned
      poke(p, values[i])
    elsif (ctype = int16) or (ctype = uint16) then  -- 16-bit signed, unsigned
      poke2(p, values[i])
    elsif (ctype = int32) or (ctype = uint32) then  -- 32-bit signed, unsigned
      poke4(p, values[i])
    elsif (ctype = int64) or (ctype = uint64) then  -- 64-bit signed, unsigned
      poke8(p, values[i])
    elsif ctype = pointer then       -- pointer
      if address_length=4 then     -- 32-bit
        poke4(p, values[i])
      elsif address_length=8 then  -- 64-bit
        poke8(p, values[i])
      end if
    elsif ctype = long_pointer then       -- 64-bit integer
      poke8(p, values[i])
    elsif ctype = float then       -- 32-bit float
      poke_float(p, values[i])
    elsif ctype = double then       -- 64-bit float
      poke_double(p, values[i])
    end if
    p += size_of(ctype)
  end for
--  log_printf("write_structure: p = #%x, code = %s\n", {ptr, hex_sequence(peek({ptr, 12}))})
end procedure

-----------------------------------------------------------------------------

public function read_structure(atom p, sequence def)
--<function>
--<name>read_structure</name>
--<digest></digest>
--<desc>
-- reads data in memory according to a structure definition
-- automatically sizes structure to EU version and OS Architecture
--</desc>
--<param>
--<type>atom</type>
--<name>p</name>
--<desc></desc>
--</param>
--<param>
--<type>sequence</type>
--<name>def</name>
--<desc></desc>
--</param>
--<return>
--</return>
--<example>
-- sequence s = readStructure(p, {pointer, int, int} )
--</example>
--<see_also>
--</see_also>
--</function>
  atom ctype
  sequence result

--  log_printf("read_structure(#%x, %s)\n", {p, hex_sequence(def)})
--  log_printf("read_structure: p = #%x, code = %s\n", {p, hex_sequence(peek({p, 12}))})
  result = {}
  for i = 1 to length(def) do
    ctype = convert_c_type(def[i])
    if ctype = int8 then       -- 8-bit signed
      result = append( result, peeks(p) )
    elsif ctype = int16 then       -- 16-bit signed
      result = append( result, peek2s(p) )
    elsif ctype = int32 then       -- 32-bit signed
      result = append( result, peek4s(p) )
    elsif ctype = int64 then       -- 64-bit signed
      result = append( result, peek8s(p) )
    elsif ctype = uint8 then       -- 8-bit unsigned
      result = append( result, peek(p) )
    elsif ctype = uint16 then       -- 16-bit unsigned
      result = append( result, peek2u(p) )
    elsif ctype = uint32 then       -- 32-bit unsigned
      result = append( result, peek4u(p) )
    elsif ctype = uint64 then       -- 64-bit unsigned
      result = append( result, peek8u(p) )
    elsif ctype = pointer then       -- pointer
      if address_length=4 then     -- 32-bit
        result = append( result, peek4s(p) )
      elsif address_length=8 then  -- 64-bit
        result = append( result, peek8s(p) )
      end if
    elsif ctype = long_pointer then       -- 64-bit integer
      result = append( result, peek8u(p) )
    elsif ctype = float then       -- 32-bit float
      result = append( result, peek_float(p) )
    elsif ctype = double then       -- 64-bit float
      result = append( result, peek_double(p) )
    end if
    p += size_of(ctype)
  end for
  return result
end function

-----------------------------------------------------------------------------

public procedure free_structure(atom p, sequence def, sequence values)
--<procedure>
--<name>free_structure</name>
--<digest></digest>
--<desc>
-- frees memory according to a structure definition
-- automatically frees pointers included in the structure
-- according to EU version and OS Architecture
--</desc>
--<param>
--<type>atom</type>
--<name>p</name>
--<desc></desc>
--</param>
--<param>
--<type>sequence</type>
--<name>def</name>
--<desc></desc>
--</param>
--<param>
--<type>sequence</type>
--<name>values</name>
--<desc></desc>
--</param>
--<return>
--</return>
--<example>
-- freeStructure(p, {pointer, int, int}, {hwnd, 12, 25} )
--</example>
--<see_also>
--</see_also>
--</procedure>
--  log_printf("free_structure(#%x, %s)\n", {p, hex_sequence(def)})
  for i = 1 to length(def) do
    if find(def[i], {pointer, long_pointer}) then
      free(values[i])
    end if
  end for
  free(p)
end procedure

-----------------------------------------------------------------------------

function identify_library(sequence path, integer level, integer n)
--  log_printf("  path: '%s', level: %d, n: %d\n", {path, level, n})
  if level = 0 then
    if n = 1 then return "L_NAME"
    elsif n = 2 then return "L_LNX_64"
    elsif n = 3 then return "L_LNX_32"
    elsif n = 4 then return "L_WIN_64"
    elsif n = 5 then return "L_WIN_32"
    end if
  end if
  return sprintf("%d",n)
end function

-----------------------------------------------------------------------------

public function register_library(sequence name, sequence library_definition)
--<function>
--<name>register_library</name>
--<digest></digest>
--<desc>
--</desc>
--<param>
--<type>sequence</type>
--<name>name</name>
--<desc></desc>
--</param>
--<param>
--<type>sequence</type>
--<name>library_definition</name>
--<desc></desc>
--</param>
--<return>
--</return>
--<example>
-- constant CURL_LIBRARY_DEFINITION = {
--   {
--     "libcurl",                                -- L_NAME
--     "/usr/lib/x86_64-linux-gnu/libcurl.so.4", -- L_LNX_64
--     "/usr/lib/i386-linux-gnu/libcurl.so.4",   -- L_LNX_32
--     0,                                        -- L_WIN_64
--     InitialDir & "\\libcurl.dll"              -- L_WIN_32
--   }
-- }
--
-- libcurl = register_library("libcurl", CURL_LIBRARY_DEFINITION)
--</example>
--<see_also>
--</see_also>
--</function>
  integer l
  atom handle
  sequence lib
  object filename

--  log_printf("register_library(%s)\n", {name})
  l = find_in_array(name, library_definition, { {"search_field", L_NAME} })
  if l = 0 then
    error_message(sprintf("There is no library named %s!", {name}), 1)
  end if
  lib = library_definition[l]
--  analyze_object( lib,
--                  sprintf("library_definition[%d]", l),
--                  f_debug,
--                  routine_id("identify_library")
--                )
  if eu_version = EU_4_1_LNX_64 then
    filename = lib[L_LNX_64]
  elsif find(eu_version, {EU_4_1_LNX_32, EU_4_0_LNX}) then
    filename = lib[L_LNX_32]
  elsif eu_version = EU_4_1_WIN_64 then
    filename = lib[L_WIN_64]
  elsif find(eu_version, {EU_4_1_WIN_32, EU_4_0_WIN}) then
    filename = lib[L_WIN_32]
  end if
  if atom(filename) then
    error_message(sprintf("No %s library defined for %s!\n", {name, eu_version_name()}), 1)
  end if
  handle = open_dll(filename)
  if handle = -1 then
    error_message(sprintf("The library %s could not be opened!\n", {filename}), 1)
  end if
--  log_printf("Library file = %s\n", {filename})
--  log_printf("Library handle = #%08x\n", {handle})
  return handle
end function

-----------------------------------------------------------------------------

function identify_routine(sequence path, integer level, integer n)
--  log_printf("  path: '%s', level: %d, n: %d\n", {path, level, n})
  if level = 0 then
    if n = 1 then return "F_NAME"
    elsif n = 2 then return "F_LIB"
    elsif n = 3 then return "F_INPUT"
    elsif n = 4 then return "F_OUTPUT"
    end if
  end if
  return sprintf("%d",n)
end function

-----------------------------------------------------------------------------

public function register_routine(atom lib, sequence name, sequence function_definition)
--<function>
--<name>register_routine</name>
--<digest></digest>
--<desc>
--</desc>
--<param>
--<type>atom</type>
--<name>lib</name>
--<desc></desc>
--</param>
--<param>
--<type>sequence</type>
--<name>name</name>
--<desc></desc>
--</param>
--<param>
--<type>sequence</type>
--<name>function_definition</name>
--<desc></desc>
--</param>
--<return>
--</return>
--<example>
-- constant CURL_ROUTINE_DEFINITION = {
--   {"+curl_getenv",       {pointer}, pointer},
--   {"+curl_version_info", {pointer}, pointer}
-- }
--
-- xcurl_version_info = register_routine(libcurl, "+curl_version_info",
--                                  CURL_ROUTINE_DEFINITION)
--
-- p = c_func(xcurl_version_info, {3})
-- ? peek_string(p)  --> {3}
--</example>
--<see_also>
--</see_also>
--</function>
  sequence s, errmsg, rtn
  integer r
  atom handle

--  log_printf("register_function(%s)\n", {name})
  r = find_in_array(name, function_definition, { {"search_field", F_NAME} })
  if r = 0 then
    error_message(sprintf("There is no function named %s!", {name}), 1)
  end if
  rtn = function_definition[r]
--  analyze_object(rtn,
--                 sprintf("function_definition[%d]", r),
--                 f_debug, routine_id("identify_routine")
--                )
  errmsg = {}
  s = {}
  if equal(rtn[F_INPUT],{{}}) then
    rtn[F_INPUT] = {}
  end if
--  log_printf("lib = %d\n", lib)
  if length(rtn) < F_OUTPUT then
--    log_printf("link_c_proc(%d, \"%s\", %s)\n", {lib, name, hex_sequence(convert_c_sequence(rtn[F_INPUT]))})
    handle = link_c_proc(lib, name, convert_c_sequence(rtn[F_INPUT]))
  else
--    log_printf("link_c_func(%d, \"%s\", %s, #%x)\n", {lib, name, hex_sequence(convert_c_sequence(rtn[F_INPUT])), convert_c_type(rtn[F_OUTPUT])})
    handle = link_c_func(lib, name, convert_c_sequence(rtn[F_INPUT]), convert_c_type(rtn[F_OUTPUT]))
  end if
  if handle = -1 then
    errmsg &= sprintf("\nThe routine %s using %s failed !"&
          "\n\nIf you have recently added this routine to the"&
          " definition list then verify that"&
          "\nthe parameters, definition format, and DLL name are"&
          " all correct."&
          "\n\nCheck if the correct DLL is available on this system."&
          "\n\nCheck if the name requires any Ex, A, or W modifier.",
          {rtn[F_NAME],lib})
    errmsg &= "\n\n-- This routine definition is expecting the following"&
          " parameters :\n\n"
    if length(rtn[F_INPUT]) then
      s = vlookup(rtn[F_INPUT][1], CTYPE_NAMES, 1, 2, "?")
      errmsg &= s
      for i = 2 to length(rtn[F_INPUT]) do
        s = vlookup(rtn[F_INPUT][i], CTYPE_NAMES, 1, 2, "?")
        errmsg &= ", " & s
      end for
    else
      errmsg &= "    -- No Parameters --"
    end if
    if length(rtn < F_OUTPUT) then
      errmsg &= "\n\n-- This function definition's return value is : "
      s = vlookup(rtn[F_OUTPUT], CTYPE_NAMES, 1, 2, "?")
      errmsg &= s
    else
      errmsg &= " No Return Value"
    end if
    errmsg &= "\n\n"
    error_message(errmsg, 1)
  end if
--  log_printf("Function handle = #%08x\n", {handle})
  return handle
end function

