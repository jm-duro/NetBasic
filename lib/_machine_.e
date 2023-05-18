-- Machine Level Access
include std/dll.e
include std/machine.e
include std/convert.e
include std/os.e
include _version_.e
include _common_.e

--------------------------------------------------------------------------------

public procedure poke8(atom address, object x)
--<procedure>
--<name>poke8</name>
--<digest>put one or more 8-byte signed/unsigned long integers at a memory location</digest>
--<desc></desc>
--<param>
--<type>atom</type>
--<name>address</name>
--<desc>either a long integer or a non empty sequence of long integers</desc>
--</param>
--<param>
--<type>object</type>
--<name>x</name>
--<desc></desc>
--</param>
--<return>
--</return>
--<example>
-- poke8(addr, -1)
--</example>
--<see_also>peek8u(), peek8s()</see_also>
--</procedure>
  if atom(x) then x = {x} end if
  address -= 8
  for i = 1 to length(x) do
    -- put less significant bits.
    poke4(address+i*8,and_bits(#FFFFFFFF,x[i]))
    if x[i] > 0 then
      poke4(address+i*8+4,floor(x[i]/#100000000))
    else
      poke4(address+i*8+4,floor(x[i]/#100000000))
    end if
  end for
end procedure

--------------------------------------------------------------------------------

public function peek8u(object address)
--<function>
--<name>peek8u</name>
--<digest>read one or more 8-byte unsigned long integers from an address in memory</digest>
--<desc></desc>
--<param>
--<type>object</type>
--<name>address</name>
--<desc>
-- either of
-- * an atom addr : to fetch one long integer at addr, or
-- * a pair {addr,len} : to fetch len long integers at addr
--</desc>
--</param>
--<return>
--</return>
--<example>
-- poke8(addr, -1)
-- ? peek8u(addr) --> 1.844674407e+019
--</example>
--<see_also>poke8(), peek8s()</see_also>
--</function>
  integer count, atom_flag
  sequence out

  count = 1
  atom_flag = atom(address)
  if sequence(address) then
    count = address[2]
    address = address[1]
  end if
  out = peek4u({address,count*2})
  for i = 1 to length(out) by 2 do
    out[floor((i+1)/2)] = out[i+1] * #100000000 + out[i]
  end for
  out = out[1..count]
  if atom_flag then return out[1] end if
  return out
end function

--------------------------------------------------------------------------------

public function peek8s(object address)
--<function>
--<name>peek8s</name>
--<digest>read one or more 8-byte signed long integers from an address in memory</digest>
--<desc>
--</desc>
--<param>
--<type>object</type>
--<name>address</name>
--<desc>
-- either of
-- * an atom addr : to fetch one long integer at addr, or
-- * a pair {addr,len} : to fetch len long integers at addr
--</desc>
--</param>
--<return>
--</return>
--<example>
-- poke8(addr, -1)
-- ? peek8s(addr) --> -1
--</example>
--<see_also>poke8(), peek8u()</see_also>
--</function>
  integer count, atom_flag
  sequence sout, uout, out

  count = 1
  atom_flag = atom(address)
  if sequence(address) then
    count = address[2]
    address = address[1]
  end if
  sout = peek4s({address,2*count})
  uout = peek4u({address,2*count})
  out = repeat(0,count)
  for i = 1 to count do
    out[i] = sout[2*i] * #100000000 + uout[2*i-1]
  end for
  if atom_flag then return out[1] end if
  return out
end function

--------------------------------------------------------------------------------

public procedure poke_float(atom p, atom a)
--<procedure>
--<name>poke_float</name>
--<digest>put a 4-byte float at a memory location</digest>
--<desc>
--</desc>
--<param>
--<type>atom</type>
--<name>p</name>
--<desc></desc>
--</param>
--<param>
--<type>atom</type>
--<name>a</name>
--<desc></desc>
--</param>
--<return>
--</return>
--<example>
-- poke_float(addr, 3.1416)
--</example>
--<see_also>peek_float()</see_also>
--</procedure>
  poke(p, atom_to_float32(a))
end procedure

--------------------------------------------------------------------------------

public function peek_float(atom p)
--<function>
--<name>peek_float</name>
--<digest>read a 4-byte float from an address in memory</digest>
--<desc>
--</desc>
--<param>
--<type>atom</type>
--<name>p</name>
--<desc></desc>
--</param>
--<return>
--</return>
--<example>
-- poke_float(addr, 3.1416)
-- ? peek_float(addr) --> 3.141599894 (caused by float storage format)
--</example>
--<see_also>poke_float()</see_also>
--</function>
  return float32_to_atom(peek({p, 4}))
end function

--------------------------------------------------------------------------------

public procedure poke_double(atom p, atom a)
--<procedure>
--<name>poke_double</name>
--<digest>put a 8-byte float at a memory location</digest>
--<desc>
--</desc>
--<param>
--<type>atom</type>
--<name>p</name>
--<desc></desc>
--</param>
--<param>
--<type>atom</type>
--<name>a</name>
--<desc></desc>
--</param>
--<return>
--</return>
--<example>
-- poke_double(addr, 216656332.2)
--</example>
--<see_also>peek_double()</see_also>
--</procedure>
  poke(p, atom_to_float64(a))
end procedure

--------------------------------------------------------------------------------

public function peek_double(atom p)
--<function>
--<name>peek_double</name>
--<digest>read a 8-byte float from an address in memory</digest>
--<desc>
--</desc>
--<param>
--<type>atom</type>
--<name>p</name>
--<desc></desc>
--</param>
--<return>
--</return>
--<example>
-- poke_double(addr, 216656332.2)
-- ? peek_double(addr) --> 216656332.2
--</example>
--<see_also>poke_double()</see_also>
--</function>
  return float64_to_atom(peek({p, 8}))
end function

--------------------------------------------------------------------------------

public procedure poke_pointer(atom addr, object x)
--<procedure>
--<name>poke_pointer</name>
--<digest>put a 4 byte pointer in memory</digest>
--<desc>
--</desc>
--<param>
--<type>atom</type>
--<name>addr</name>
--<desc></desc>
--</param>
--<param>
--<type>object</type>
--<name>x</name>
--<desc></desc>
--</param>
--<return>
--</return>
--<example>
-- poke_pointer(addr, allocate_string("where?"))
--</example>
--<see_also>peek_pointer()</see_also>
--</procedure>
  if addr <= 0 then
    error_message(sprintf("poke_pointer: bad pointer %d\n", addr), 1)
  end if
  poke4(addr, x)
end procedure

--------------------------------------------------------------------------------

public function peek_pointer(object addr)
--<function>
--<name>peek_pointer</name>
--<digest>read a 4 byte pointer in memory</digest>
--<desc>
--</desc>
--<param>
--<type>object</type>
--<name>addr</name>
--<desc></desc>
--</param>
--<return>
--</return>
--<example>
-- addr2 = allocate_string("where?")
-- ? addr2
-- poke_pointer(addr, addr2)
-- ? peek_pointer(addr) --> same as addr2
--</example>
--<see_also>poke_pointer()</see_also>
--</function>
  if atom(addr) and (addr <= 0) then
    error_message(sprintf("peek_pointer: bad pointer %d\n", addr), 1)
  end if
  if sequence(addr) and (addr[1] <= 0) then
    error_message(sprintf("peek_pointer: bad pointer %d\n", addr[1]), 1)
  end if
  return peek4u(addr)
end function

--------------------------------------------------------------------------------

public function allocate_plist(sequence pointers)
--<function>
--<name>allocate_plist</name>
--<digest>allocates a list of pointers in memory</digest>
--<desc>
--</desc>
--<param>
--<type>sequence</type>
--<name>pointers</name>
--<desc></desc>
--</param>
--<return>
--</return>
--<example>
-- addr2 = allocate(4)
-- addr3 = allocate(4)
-- addr = allocate_plist({addr2, addr3})
--</example>
--<see_also>poke_plist(), peek_plist(), free_plist()</see_also>
--</function>
  atom addr
  integer len

  len = length(pointers) * address_length
  addr = allocate(len + address_length)
  if addr then
    poke_pointer(addr, pointers)
    poke_pointer(addr + len, NULL)
  end if
  return addr
end function

--------------------------------------------------------------------------------

public procedure poke_plist(atom addr, sequence pointers)
--<procedure>
--<name>poke_plist</name>
--<digest>puts a list of pointers in memory</digest>
--<desc>
--</desc>
--<param>
--<type>atom</type>
--<name>addr</name>
--<desc></desc>
--</param>
--<param>
--<type>sequence</type>
--<name>pointers</name>
--<desc></desc>
--</param>
--<return>
--</return>
--<example>
-- addr2 = allocate(4)
-- addr3 = allocate(4)
-- addr = allocate_plist({NULL, NULL})
-- poke_plist(addr, {addr3, addr2})
--</example>
--<see_also>allocate_plist(), peek_plist(), free_plist()</see_also>
--</procedure>
  integer len

  if addr <= 0 then return end if
  len = length(pointers) * address_length
  poke_pointer(addr, pointers)
  poke_pointer(addr + len, NULL)
end procedure

--------------------------------------------------------------------------------

public function peek_plist(atom addr)
--<function>
--<name>peek_plist</name>
--<digest>reads a list of pointers in memory</digest>
--<desc>
--</desc>
--<param>
--<type>atom</type>
--<name>addr</name>
--<desc></desc>
--</param>
--<return>
--</return>
--<example>
-- addr2 = allocate(4)
-- ? addr2 --> 4758384
-- addr3 = allocate(4)
-- ? addr3 --> 4832984
-- addr = allocate_plist({addr2, addr3})
-- ? peek_plist(addr) --> {4758384,4832984}
--</example>
--<see_also>allocate_plist(), poke_plist(), free_plist()</see_also>
--</function>
  atom ptr

  ptr = addr
  while peek_pointer(ptr) do ptr += address_length end while
  return peek_pointer({addr, (ptr - addr) / address_length})
end function

--------------------------------------------------------------------------------

public procedure free_plist(atom addr)
--<procedure>
--<name>free_plist</name>
--<digest>free a list of pointers in memory</digest>
--<desc>
--</desc>
--<param>
--<type>atom</type>
--<name>addr</name>
--<desc></desc>
--</param>
--<return>
--</return>
--<example>
-- free_plist(addr)
-- ? peek_plist(addr) --> {}
--</example>
--<see_also>allocate_plist(), poke_plist(), peek_plist()</see_also>
--</procedure>
  atom ptr

  ptr = peek_pointer(addr)
  while ptr do
    free(ptr)
    poke4(addr, 0)
    addr += address_length
    ptr = peek_pointer(addr)
  end while
end procedure

--------------------------------------------------------------------------------

public function allocate_string_list(sequence string_list)
--<function>
--<name>allocate_string_list</name>
--<digest>allocate a list of strings in memory</digest>
--<desc>
-- no need of poke_string_list as allocate_string_list does the job
--</desc>
--<param>
--<type>object</type>
--<name>string_list</name>
--<desc></desc>
--</param>
--<return>
--</return>
--<example>
-- addr = allocate_string_list({"my","taylor","is","rich"})
--</example>
--<see_also>peek_string_list(), free_string_list()</see_also>
--</function>
  for i = 1 to length(string_list) do
    string_list[i] = allocate_string(string_list[i])
  end for
  return allocate_plist(string_list)
end function

--------------------------------------------------------------------------------

public function peek_string_list( atom addr, integer max=-1)
--<function>
--<name>peek_string_list</name>
--<digest>reads a list of strings in memory</digest>
--<desc>
-- opposite of allocate_string_list()
--</desc>
--<param>
--<type>atom</type>
--<name>addr</name>
--<desc></desc>
--</param>
--<param>
--<type>integer</type>
--<name>max</name>
--<desc>
-- fixes maximum number of strings to read
--</desc>
--</param>
--<return>
--</return>
--<example>
-- addr = allocate_string_list({"my","taylor","is","rich"})
-- s = peek_string_list(addr)
-- s is {"my","taylor","is","rich"}
-- s = peek_string_list(addr, 2)
-- s is {"my","taylor"}
--</example>
--<see_also>allocate_string_list(), free_string_list()</see_also>
--</function>
  sequence strings, str
  atom ptr

  strings = {}
  ptr = peek_pointer(addr)
  while ptr do
    str = peek_string( ptr )
    strings = append( strings, str )
    if (max != -1) and (length(strings) = max) then
      exit
    end if
    addr += address_length
    ptr = peek_pointer(addr)
  end while
  return strings
end function

--------------------------------------------------------------------------------

public procedure free_string_list(atom addr)
--<procedure>
--<name>free_string_list</name>
--<digest>frees a list of strings in memory</digest>
--<desc>
--</desc>
--<param>
--<type>atom</type>
--<name>addr</name>
--<desc></desc>
--</param>
--<return>
--</return>
--<example>
-- free_string_list(addr)
-- s = peek_string_list(addr, {})
-- s is {}
--</example>
--<see_also>allocate_string_list(), peek_string_list()</see_also>
--</procedure>
  free_plist(addr)
end procedure

--------------------------------------------------------------------------------

public function cdecl_callback(integer rtn)
--<function>
--<name>cdecl_callback</name>
--<digest>return a CDECL call_back handle for a routine</digest>
--<desc>
--</desc>
--<param>
--<type>integer</type>
--<name>rtn</name>
--<desc></desc>
--</param>
--<return>
--</return>
--<example>
--</example>
--<see_also>
--</see_also>
--</function>
ifdef WINDOWS then
  return call_back({ '+', rtn })
elsifdef LINUX then
  return call_back(rtn)
end ifdef
end function

-------------------------------------------------------------------------------

public function byte_to_word(atom l, atom h)
--<function>
--<name>byte_to_word</name>
--<digest>merges 2 bytes in a word</digest>
--<desc>
--</desc>
--<param>
--<type>atom</type>
--<name>l</name>
--<desc></desc>
--</param>
--<param>
--<type>atom</type>
--<name>h</name>
--<desc></desc>
--</param>
--<return>
--</return>
--<example>
-- ? byte_to_word(#AA, #80)  --> 32938 (#80AA)
--</example>
--<see_also>high_byte(), low_byte()</see_also>
--</function>
  return h*#100+l
end function

-------------------------------------------------------------------------------

public function high_byte(atom x)
--<function>
--<name>high_byte</name>
--<digest>extracts higher byte of a word</digest>
--<desc>
--</desc>
--<param>
--<type>atom</type>
--<name>x</name>
--<desc></desc>
--</param>
--<return>
--</return>
--<example>
-- ? high_byte(#80AA)  --> 128 (#80)
--</example>
--<see_also>byte_to_word(), low_byte()</see_also>
--</function>
  return floor(x / #100)
end function

-------------------------------------------------------------------------------

public function low_byte(atom x)
--<function>
--<name>low_byte</name>
--<digest>extracts lower byte of a word</digest>
--<desc>
--</desc>
--<param>
--<type>atom</type>
--<name>x</name>
--<desc></desc>
--</param>
--<return>
--</return>
--<example>
-- ? low_byte(#80AA)  --> 170 (#AA)
--</example>
--<see_also>byte_to_word(), high_byte()</see_also>
--</function>
  return remainder(x, #100)
end function

-------------------------------------------------------------------------------

public function word_to_dword(atom l, atom h)
--<function>
--<name>word_to_dword</name>
--<digest>merges 2 words in a double word</digest>
--<desc>
--</desc>
--<param>
--<type>atom</type>
--<name>l</name>
--<desc></desc>
--</param>
--<param>
--<type>atom</type>
--<name>h</name>
--<desc></desc>
--</param>
--<return>
--</return>
--<example>
-- ? word_to_dword(#21FA, #8123)  --> 2166563322 (#812321FA)
--</example>
--<see_also>high_word(), low_word()</see_also>
--</function>
  return h*#10000+l
end function

--------------------------------------------------------------------------------

public function high_word(atom pData)
--<function>
--<name>high_word</name>
--<digest>extracts higher word of a double word</digest>
--<desc>
-- from win32lib tk_maths.e
--</desc>
--<param>
--<type>atom</type>
--<name>pData</name>
--<desc></desc>
--</param>
--<return>
--</return>
--<example>
-- ? high_word(#812321FA)  --> 33059 (#8123)
--</example>
--<see_also>word_to_dword(), low_word()</see_also>
--</function>
  return and_bits(and_bits(pData, #FFFF0000) / #10000, #FFFF)
end function

--------------------------------------------------------------------------------

public function low_word(atom pData)
--<function>
--<name>low_word</name>
--<digest>extracts lower word of a double word</digest>
--<desc>
-- from win32lib tk_maths.e
--</desc>
--<param>
--<type>atom</type>
--<name>pData</name>
--<desc></desc>
--</param>
--<return>
--</return>
--<example>
-- ? low_word(#812321FA)  --> 8698 (#21FA)
--</example>
--<see_also>word_to_dword(), high_word()</see_also>
--</function>
  return and_bits(pData, #FFFF)
end function

-------------------------------------------------------------------------------

public function higher_bits(integer x, integer divide)
--<function>
--<name>higher_bits</name>
--<digest>returns the highest bits of an integer</digest>
--<desc>
--</desc>
--<param>
--<type>integer</type>
--<name>x</name>
--<desc></desc>
--</param>
--<param>
--<type>integer</type>
--<name>divide</name>
--<desc>divide is the is the value that fixes the limit between higher bits and lower bits</desc>
--</param>
--<return>
--</return>
--<example>
--  higher_bits(x, #10) gets the higher quartet (4 bits) of byte x (8 bits)
--  higher_bits(x, #100) gets the higher bytes (8 bits) of word x (16 bits)
--  higher_bits(x, #10000) gets the higher word (16 bits) of dword x (32 bits)
--</example>
--<see_also></see_also>
--</function>
  return floor(x / divide)
end function

-------------------------------------------------------------------------------

public function lower_bits(integer x, integer divide)
--<function>
--<name>lower_bits</name>
--<digest>returns the lowest bits of an integer</digest>
--<desc>
--</desc>
--<param>
--<type>integer</type>
--<name>x</name>
--<desc></desc>
--</param>
--<param>
--<type>integer</type>
--<name>divide</name>
--<desc>divide is the is the value that fixes the limit between higher bits and lower bits</desc>
--</param>
--<return>
--</return>
--<example>
--  lower_bits(x, #10) gets the lower quartet (4 bits) of byte x (8 bits)
--  lower_bits(x, #100) gets the lower bytes (8 bits) of word x (16 bits)
--  lower_bits(x, #10000) gets the lower word (16 bits) of dword x (32 bits)
--</example>
--<see_also></see_also>
--</function>
  return remainder(x, divide)
end function

-------------------------------------------------------------------------------

public function join_bits(integer highest, integer lowest, integer divide)
--<function>
--<name>join_bits</name>
--<digest>combine higher and lower item to build one bigger item</digest>
--<desc>
--</desc>
--<param>
--<type>integer</type>
--<name>highest</name>
--<desc></desc>
--</param>
--<param>
--<type>integer</type>
--<name>lowest</name>
--<desc></desc>
--</param>
--<param>
--<type>integer</type>
--<name>divide</name>
--<desc>divide is the resulting value when highest is 1 and lowest is 0</desc>
--</param>
--<return>
--</return>
--<example>
--  join_bits(h, l, #10) joins to quartets (4 bits) to build a byte (8 bits)
--  join_bits(h, l, #100) joins to bytes (8 bits) to build a word (16 bits)
--  join_bits(h, l, #10000) joins to words (16 bits) to build a dword (32 bits)
--</example>
--<see_also></see_also>
--</function>
  return (highest*divide) + lowest
end function

