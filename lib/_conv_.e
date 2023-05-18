-- _conv_.e

include std/convert.e
include std/get.e
include std/math.e
include std/search.e
include std/sequence.e
include _common_.e
include _types_.e
include _debug_.e
include _search_.e

public constant
  NORMAL = 1, REVERSE = 2

constant CP850_UNICODE = {
  {#00, #0000, "NULL"},
  {#01, #0001, "START OF HEADING"},
  {#02, #0002, "START OF TEXT"},
  {#03, #0003, "END OF TEXT"},
  {#04, #0004, "END OF TRANSMISSION"},
  {#05, #0005, "ENQUIRY"},
  {#06, #0006, "ACKNOWLEDGE"},
  {#07, #0007, "BELL"},
  {#08, #0008, "BACKSPACE"},
  {#09, #0009, "HORIZONTAL TABULATION"},
  {#0A, #000A, "LINE FEED"},
  {#0B, #000B, "VERTICAL TABULATION"},
  {#0C, #000C, "FORM FEED"},
  {#0D, #000D, "CARRIAGE RETURN"},
  {#0E, #000E, "SHIFT OUT"},
  {#0F, #000F, "SHIFT IN"},
  {#10, #0010, "DATA LINK ESCAPE"},
  {#11, #0011, "DEVICE CONTROL ONE"},
  {#12, #0012, "DEVICE CONTROL TWO"},
  {#13, #0013, "DEVICE CONTROL THREE"},
  {#14, #0014, "DEVICE CONTROL FOUR"},
  {#15, #0015, "NEGATIVE ACKNOWLEDGE"},
  {#16, #0016, "SYNCHRONOUS IDLE"},
  {#17, #0017, "END OF TRANSMISSION BLOCK"},
  {#18, #0018, "CANCEL"},
  {#19, #0019, "END OF MEDIUM"},
  {#1A, #001A, "SUBSTITUTE"},
  {#1B, #001B, "ESCAPE"},
  {#1C, #001C, "FILE SEPARATOR"},
  {#1D, #001D, "GROUP SEPARATOR"},
  {#1E, #001E, "RECORD SEPARATOR"},
  {#1F, #001F, "UNIT SEPARATOR"},
  {#20, #0020, "SPACE"},
  {#21, #0021, "EXCLAMATION MARK"},
  {#22, #0022, "QUOTATION MARK"},
  {#23, #0023, "NUMBER SIGN"},
  {#24, #0024, "DOLLAR SIGN"},
  {#25, #0025, "PERCENT SIGN"},
  {#26, #0026, "AMPERSAND"},
  {#27, #0027, "APOSTROPHE"},
  {#28, #0028, "LEFT PARENTHESIS"},
  {#29, #0029, "RIGHT PARENTHESIS"},
  {#2A, #002A, "ASTERISK"},
  {#2B, #002B, "PLUS SIGN"},
  {#2C, #002C, "COMMA"},
  {#2D, #002D, "HYPHEN-MINUS"},
  {#2E, #002E, "FULL STOP"},
  {#2F, #002F, "SOLIDUS"},
  {#30, #0030, "DIGIT ZERO"},
  {#31, #0031, "DIGIT ONE"},
  {#32, #0032, "DIGIT TWO"},
  {#33, #0033, "DIGIT THREE"},
  {#34, #0034, "DIGIT FOUR"},
  {#35, #0035, "DIGIT FIVE"},
  {#36, #0036, "DIGIT SIX"},
  {#37, #0037, "DIGIT SEVEN"},
  {#38, #0038, "DIGIT EIGHT"},
  {#39, #0039, "DIGIT NINE"},
  {#3A, #003A, "COLON"},
  {#3B, #003B, "SEMICOLON"},
  {#3C, #003C, "LESS-THAN SIGN"},
  {#3D, #003D, "EQUALS SIGN"},
  {#3E, #003E, "GREATER-THAN SIGN"},
  {#3F, #003F, "QUESTION MARK"},
  {#40, #0040, "COMMERCIAL AT"},
  {#41, #0041, "LATIN CAPITAL LETTER A"},
  {#42, #0042, "LATIN CAPITAL LETTER B"},
  {#43, #0043, "LATIN CAPITAL LETTER C"},
  {#44, #0044, "LATIN CAPITAL LETTER D"},
  {#45, #0045, "LATIN CAPITAL LETTER E"},
  {#46, #0046, "LATIN CAPITAL LETTER F"},
  {#47, #0047, "LATIN CAPITAL LETTER G"},
  {#48, #0048, "LATIN CAPITAL LETTER H"},
  {#49, #0049, "LATIN CAPITAL LETTER I"},
  {#4A, #004A, "LATIN CAPITAL LETTER J"},
  {#4B, #004B, "LATIN CAPITAL LETTER K"},
  {#4C, #004C, "LATIN CAPITAL LETTER L"},
  {#4D, #004D, "LATIN CAPITAL LETTER M"},
  {#4E, #004E, "LATIN CAPITAL LETTER N"},
  {#4F, #004F, "LATIN CAPITAL LETTER O"},
  {#50, #0050, "LATIN CAPITAL LETTER P"},
  {#51, #0051, "LATIN CAPITAL LETTER Q"},
  {#52, #0052, "LATIN CAPITAL LETTER R"},
  {#53, #0053, "LATIN CAPITAL LETTER S"},
  {#54, #0054, "LATIN CAPITAL LETTER T"},
  {#55, #0055, "LATIN CAPITAL LETTER U"},
  {#56, #0056, "LATIN CAPITAL LETTER V"},
  {#57, #0057, "LATIN CAPITAL LETTER W"},
  {#58, #0058, "LATIN CAPITAL LETTER X"},
  {#59, #0059, "LATIN CAPITAL LETTER Y"},
  {#5A, #005A, "LATIN CAPITAL LETTER Z"},
  {#5B, #005B, "LEFT SQUARE BRACKET"},
  {#5C, #005C, "REVERSE SOLIDUS"},
  {#5D, #005D, "RIGHT SQUARE BRACKET"},
  {#5E, #005E, "CIRCUMFLEX ACCENT"},
  {#5F, #005F, "LOW LINE"},
  {#60, #0060, "GRAVE ACCENT"},
  {#61, #0061, "LATIN SMALL LETTER A"},
  {#62, #0062, "LATIN SMALL LETTER B"},
  {#63, #0063, "LATIN SMALL LETTER C"},
  {#64, #0064, "LATIN SMALL LETTER D"},
  {#65, #0065, "LATIN SMALL LETTER E"},
  {#66, #0066, "LATIN SMALL LETTER F"},
  {#67, #0067, "LATIN SMALL LETTER G"},
  {#68, #0068, "LATIN SMALL LETTER H"},
  {#69, #0069, "LATIN SMALL LETTER I"},
  {#6A, #006A, "LATIN SMALL LETTER J"},
  {#6B, #006B, "LATIN SMALL LETTER K"},
  {#6C, #006C, "LATIN SMALL LETTER L"},
  {#6D, #006D, "LATIN SMALL LETTER M"},
  {#6E, #006E, "LATIN SMALL LETTER N"},
  {#6F, #006F, "LATIN SMALL LETTER O"},
  {#70, #0070, "LATIN SMALL LETTER P"},
  {#71, #0071, "LATIN SMALL LETTER Q"},
  {#72, #0072, "LATIN SMALL LETTER R"},
  {#73, #0073, "LATIN SMALL LETTER S"},
  {#74, #0074, "LATIN SMALL LETTER T"},
  {#75, #0075, "LATIN SMALL LETTER U"},
  {#76, #0076, "LATIN SMALL LETTER V"},
  {#77, #0077, "LATIN SMALL LETTER W"},
  {#78, #0078, "LATIN SMALL LETTER X"},
  {#79, #0079, "LATIN SMALL LETTER Y"},
  {#7A, #007A, "LATIN SMALL LETTER Z"},
  {#7B, #007B, "LEFT CURLY BRACKET"},
  {#7C, #007C, "VERTICAL LINE"},
  {#7D, #007D, "RIGHT CURLY BRACKET"},
  {#7E, #007E, "TILDE"},
  {#7F, #007F, "DELETE"},
  {#80, #00C7, "LATIN CAPITAL LETTER C WITH CEDILLA"},
  {#81, #00FC, "LATIN SMALL LETTER U WITH DIAERESIS"},
  {#82, #00E9, "LATIN SMALL LETTER E WITH ACUTE"},
  {#83, #00E2, "LATIN SMALL LETTER A WITH CIRCUMFLEX"},
  {#84, #00E4, "LATIN SMALL LETTER A WITH DIAERESIS"},
  {#85, #00E0, "LATIN SMALL LETTER A WITH GRAVE"},
  {#86, #00E5, "LATIN SMALL LETTER A WITH RING ABOVE"},
  {#87, #00E7, "LATIN SMALL LETTER C WITH CEDILLA"},
  {#88, #00EA, "LATIN SMALL LETTER E WITH CIRCUMFLEX"},
  {#89, #00EB, "LATIN SMALL LETTER E WITH DIAERESIS"},
  {#8A, #00E8, "LATIN SMALL LETTER E WITH GRAVE"},
  {#8B, #00EF, "LATIN SMALL LETTER I WITH DIAERESIS"},
  {#8C, #00EE, "LATIN SMALL LETTER I WITH CIRCUMFLEX"},
  {#8D, #00EC, "LATIN SMALL LETTER I WITH GRAVE"},
  {#8E, #00C4, "LATIN CAPITAL LETTER A WITH DIAERESIS"},
  {#8F, #00C5, "LATIN CAPITAL LETTER A WITH RING ABOVE"},
  {#90, #00C9, "LATIN CAPITAL LETTER E WITH ACUTE"},
  {#91, #00E6, "LATIN SMALL LETTER AE"},
  {#92, #00C6, "LATIN CAPITAL LETTER AE"},
  {#93, #00F4, "LATIN SMALL LETTER O WITH CIRCUMFLEX"},
  {#94, #00F6, "LATIN SMALL LETTER O WITH DIAERESIS"},
  {#95, #00F2, "LATIN SMALL LETTER O WITH GRAVE"},
  {#96, #00FB, "LATIN SMALL LETTER U WITH CIRCUMFLEX"},
  {#97, #00F9, "LATIN SMALL LETTER U WITH GRAVE"},
  {#98, #00FF, "LATIN SMALL LETTER Y WITH DIAERESIS"},
  {#99, #00D6, "LATIN CAPITAL LETTER O WITH DIAERESIS"},
  {#9A, #00DC, "LATIN CAPITAL LETTER U WITH DIAERESIS"},
  {#9B, #00F8, "LATIN SMALL LETTER O WITH STROKE"},
  {#9C, #00A3, "POUND SIGN"},
  {#9D, #00D8, "LATIN CAPITAL LETTER O WITH STROKE"},
  {#9E, #00D7, "MULTIPLICATION SIGN"},
  {#9F, #0192, "LATIN SMALL LETTER F WITH HOOK"},
  {#A0, #00E1, "LATIN SMALL LETTER A WITH ACUTE"},
  {#A1, #00ED, "LATIN SMALL LETTER I WITH ACUTE"},
  {#A2, #00F3, "LATIN SMALL LETTER O WITH ACUTE"},
  {#A3, #00FA, "LATIN SMALL LETTER U WITH ACUTE"},
  {#A4, #00F1, "LATIN SMALL LETTER N WITH TILDE"},
  {#A5, #00D1, "LATIN CAPITAL LETTER N WITH TILDE"},
  {#A6, #00AA, "FEMININE ORDINAL INDICATOR"},
  {#A7, #00BA, "MASCULINE ORDINAL INDICATOR"},
  {#A8, #00BF, "INVERTED QUESTION MARK"},
  {#A9, #00AE, "REGISTERED SIGN"},
  {#AA, #00AC, "NOT SIGN"},
  {#AB, #00BD, "VULGAR FRACTION ONE HALF"},
  {#AC, #00BC, "VULGAR FRACTION ONE QUARTER"},
  {#AD, #00A1, "INVERTED EXCLAMATION MARK"},
  {#AE, #00AB, "LEFT-POINTING DOUBLE ANGLE QUOTATION MARK"},
  {#AF, #00BB, "RIGHT-POINTING DOUBLE ANGLE QUOTATION MARK"},
  {#B0, #2591, "LIGHT SHADE"},
  {#B1, #2592, "MEDIUM SHADE"},
  {#B2, #2593, "DARK SHADE"},
  {#B3, #2502, "BOX DRAWINGS LIGHT VERTICAL"},
  {#B4, #2524, "BOX DRAWINGS LIGHT VERTICAL AND LEFT"},
  {#B5, #00C1, "LATIN CAPITAL LETTER A WITH ACUTE"},
  {#B6, #00C2, "LATIN CAPITAL LETTER A WITH CIRCUMFLEX"},
  {#B7, #00C0, "LATIN CAPITAL LETTER A WITH GRAVE"},
  {#B8, #00A9, "COPYRIGHT SIGN"},
  {#B9, #2563, "BOX DRAWINGS DOUBLE VERTICAL AND LEFT"},
  {#BA, #2551, "BOX DRAWINGS DOUBLE VERTICAL"},
  {#BB, #2557, "BOX DRAWINGS DOUBLE DOWN AND LEFT"},
  {#BC, #255D, "BOX DRAWINGS DOUBLE UP AND LEFT"},
  {#BD, #00A2, "CENT SIGN"},
  {#BE, #00A5, "YEN SIGN"},
  {#BF, #2510, "BOX DRAWINGS LIGHT DOWN AND LEFT"},
  {#C0, #2514, "BOX DRAWINGS LIGHT UP AND RIGHT"},
  {#C1, #2534, "BOX DRAWINGS LIGHT UP AND HORIZONTAL"},
  {#C2, #252C, "BOX DRAWINGS LIGHT DOWN AND HORIZONTAL"},
  {#C3, #251C, "BOX DRAWINGS LIGHT VERTICAL AND RIGHT"},
  {#C4, #2500, "BOX DRAWINGS LIGHT HORIZONTAL"},
  {#C5, #253C, "BOX DRAWINGS LIGHT VERTICAL AND HORIZONTAL"},
  {#C6, #00E3, "LATIN SMALL LETTER A WITH TILDE"},
  {#C7, #00C3, "LATIN CAPITAL LETTER A WITH TILDE"},
  {#C8, #255A, "BOX DRAWINGS DOUBLE UP AND RIGHT"},
  {#C9, #2554, "BOX DRAWINGS DOUBLE DOWN AND RIGHT"},
  {#CA, #2569, "BOX DRAWINGS DOUBLE UP AND HORIZONTAL"},
  {#CB, #2566, "BOX DRAWINGS DOUBLE DOWN AND HORIZONTAL"},
  {#CC, #2560, "BOX DRAWINGS DOUBLE VERTICAL AND RIGHT"},
  {#CD, #2550, "BOX DRAWINGS DOUBLE HORIZONTAL"},
  {#CE, #256C, "BOX DRAWINGS DOUBLE VERTICAL AND HORIZONTAL"},
  {#CF, #00A4, "CURRENCY SIGN"},
  {#D0, #00F0, "LATIN SMALL LETTER ETH"},
  {#D1, #00D0, "LATIN CAPITAL LETTER ETH"},
  {#D2, #00CA, "LATIN CAPITAL LETTER E WITH CIRCUMFLEX"},
  {#D3, #00CB, "LATIN CAPITAL LETTER E WITH DIAERESIS"},
  {#D4, #00C8, "LATIN CAPITAL LETTER E WITH GRAVE"},
  {#D5, #0131, "LATIN SMALL LETTER DOTLESS I"},
  {#D6, #00CD, "LATIN CAPITAL LETTER I WITH ACUTE"},
  {#D7, #00CE, "LATIN CAPITAL LETTER I WITH CIRCUMFLEX"},
  {#D8, #00CF, "LATIN CAPITAL LETTER I WITH DIAERESIS"},
  {#D9, #2518, "BOX DRAWINGS LIGHT UP AND LEFT"},
  {#DA, #250C, "BOX DRAWINGS LIGHT DOWN AND RIGHT"},
  {#DB, #2588, "FULL BLOCK"},
  {#DC, #2584, "LOWER HALF BLOCK"},
  {#DD, #00A6, "BROKEN BAR"},
  {#DE, #00CC, "LATIN CAPITAL LETTER I WITH GRAVE"},
  {#DF, #2580, "UPPER HALF BLOCK"},
  {#E0, #00D3, "LATIN CAPITAL LETTER O WITH ACUTE"},
  {#E1, #00DF, "LATIN SMALL LETTER SHARP S"},
  {#E2, #00D4, "LATIN CAPITAL LETTER O WITH CIRCUMFLEX"},
  {#E3, #00D2, "LATIN CAPITAL LETTER O WITH GRAVE"},
  {#E4, #00F5, "LATIN SMALL LETTER O WITH TILDE"},
  {#E5, #00D5, "LATIN CAPITAL LETTER O WITH TILDE"},
  {#E6, #00B5, "MICRO SIGN"},
  {#E7, #00FE, "LATIN SMALL LETTER THORN"},
  {#E8, #00DE, "LATIN CAPITAL LETTER THORN"},
  {#E9, #00DA, "LATIN CAPITAL LETTER U WITH ACUTE"},
  {#EA, #00DB, "LATIN CAPITAL LETTER U WITH CIRCUMFLEX"},
  {#EB, #00D9, "LATIN CAPITAL LETTER U WITH GRAVE"},
  {#EC, #00FD, "LATIN SMALL LETTER Y WITH ACUTE"},
  {#ED, #00DD, "LATIN CAPITAL LETTER Y WITH ACUTE"},
  {#EE, #00AF, "MACRON"},
  {#EF, #00B4, "ACUTE ACCENT"},
  {#F0, #00AD, "SOFT HYPHEN"},
  {#F1, #00B1, "PLUS-MINUS SIGN"},
  {#F2, #2017, "DOUBLE LOW LINE"},
  {#F3, #00BE, "VULGAR FRACTION THREE QUARTERS"},
  {#F4, #00B6, "PILCROW SIGN"},
  {#F5, #00A7, "SECTION SIGN"},
  {#F6, #00F7, "DIVISION SIGN"},
  {#F7, #00B8, "CEDILLA"},
  {#F8, #00B0, "DEGREE SIGN"},
  {#F9, #00A8, "DIAERESIS"},
  {#FA, #00B7, "MIDDLE DOT"},
  {#FB, #00B9, "SUPERSCRIPT ONE"},
  {#FC, #00B3, "SUPERSCRIPT THREE"},
  {#FD, #00B2, "SUPERSCRIPT TWO"},
  {#FE, #25A0, "BLACK SQUARE"},
  {#FF, #00A0, "NO-BREAK SPACE"}
}

-------------------------------------------------------------------------------

function dec_to_str(atom n, atom d)
  sequence result

  result = repeat(32, d)
  for i = d to 1 by -1 do
    result[i] = remainder(n, 10) + 48
    n = floor(n / 10)
  end for
  return result
end function

-------------------------------------------------------------------------------

function base_to_str(atom n, atom b, atom d)
  atom c
  sequence result

  result = repeat(32, d)
  c = floor((log(b)/log(2))+0.5)
  for i = d to 1 by -1 do
    result[i] = DIGITS[and_bits(n / power(2, (d-i)*c), b-1)+1]
  end for
  return result
end function

-------------------------------------------------------------------------------

public function num_to_str(atom n, atom b, atom d)
--<function>
--<name>num_to_str</name>
--<digest>converts an atom to a string according to a numerical base</digest>
--<desc>
-- base can be 2, 8, 10 or 16
-- resulting string length has to be specified
--</desc>
--<param>
--<type>atom</type>
--<name>n</name>
--<desc>atom to convert</desc>
--</param>
--<param>
--<type>atom</type>
--<name>b</name>
--<desc>base: 2, 8, 10 or 16</desc>
--</param>
--<param>
--<type>atom</type>
--<name>d</name>
--<desc>length of the resulting string</desc>
--</param>
--<return>
-- sequence: a formatted string
--</return>
--<example>
-- puts(1, num_to_str(10,  2, 4)) would display n in binary form: "1010"
-- puts(1, num_to_str(10,  8, 2)) would display n in octal form: "12"
-- puts(1, num_to_str(10, 10, 2)) would display n in decimal form: "10"
-- puts(1, num_to_str(10, 16, 2)) would display n in hexadecimal form: "0A"
--</example>
--<see_also>str_to_num()</see_also>
--</function>

  if b = 2 then
    if d>32 then d = 32 end if
    return base_to_str(n, 2, d)
  elsif b = 8 then
    if d>11 then d = 11 end if
    return base_to_str(n, 8, d)
  elsif b = 10 then
    return dec_to_str(n, d)
  elsif b = 16 then
    if d>8 then d = 8 end if
    return base_to_str(n, 16, d)
  else
    return {}
  end if
end function

-------------------------------------------------------------------------------

public function str_to_num(sequence s, atom b)
--<function>
--<name>str_to_num</name>
--<digest>converts a string to an atom according to a scecified base</digest>
--<desc></desc>
--<param>
--<type>sequence</type>
--<name>s</name>
--<desc>string to convert</desc>
--</param>
--<param>
--<type>atom</type>
--<name>b</name>
--<desc>base: 2, 8, 10 or 16</desc>
--</param>
--<return>
-- atom
--</return>
--<example>
-- printf(1, "%d", str_to_num("1010",  2)) would display 10 
-- printf(1, "%d", str_to_num("12",  8)) would display 10 
-- printf(1, "%d", str_to_num("10", 10)) would display 10 
-- printf(1, "%d", str_to_num("0A", 16)) would display 10 
--</example>
--<see_also>num_to_str(), to_number()</see_also>
--</function>
  atom l

  l = 0
  for i = 1 to length(s) do
    l = l + (match({s[i]}, DIGITS)-1) * floor(power(b, length(s)-i))
  end for
  return l
end function

------------------------------------------------------------------------------

public function hex_string(sequence s)
--<function>
--<name>hex_string</name>
--<digest>returns hexadecimal representation of a string</digest>
--<desc>
--</desc>
--<param>
--<type>sequence</type>
--<name>s</name>
--<desc>string to convert</desc>
--</param>
--<return>
-- sequence
--</return>
--<example>
-- puts(1, hex_string({1,2,3,4,5,6}) & "\n")
-- 010203040506
--</example>
--<see_also>hex_sequence(), num_to_str()</see_also>
--</function>
  sequence result

  result = ""
  for i = 1 to length(s) do
    result &= sprintf("%02x", s[i])
  end for
  return result
end function

------------------------------------------------------------------------------

public function hex_sequence(sequence s)
--<function>
--<name>hex_sequence</name>
--<digest>returns hexadecimal representation of a sequence</digest>
--<desc>
--</desc>
--<param>
--<type>sequence</type>
--<name>s</name>
--<desc>sequence to convert</desc>
--</param>
--<return>
-- sequence
--</return>
--<example>
-- puts(1, hex_sequence({1,2,3,4,5,6}) & "\n")
-- {#1, #2, #3, #4, #5, #6}
--</example>
--<see_also>hex_string()</see_also>
--</function>
  sequence result

  result = ""
  for i = 1 to length(s) do
    if length(result) then
      result &= sprintf(", #%x", s[i])
    else  
      result &= sprintf("#%x", s[i])
    end if
  end for
  result = "{" & result & "}"
  return result
end function

-------------------------------------------------------------------------------

--<function>
--<name>bytes_to_uint</name>
--<digest>converts sequence of bytes peeked in memory to a numerical value</digest>
--<desc></desc>
--<param>
--<type>sequence</type>
--<name>s</name>
--<desc>sequence to convert</desc>
--</param>
--<param>
--<type>integer</type>
--<name>direction</name>
--<desc>
-- direction is NORMAL or REVERSE (default).
-- when direction is REVERSE (usual), lowest byte is first
-- when direction is NORMAL (telecom frames), highest byte is first
--</desc>
--</param>
--<return>
-- integer
--</return>
--<example>
--   bytes_to_uint({#1C,#0A,#00,#00}, NORMAL) = #1C0A0000
--   bytes_to_uint({#1C,#0A,#00,#00}) = #A1C
--</example>
--<see_also>uint_to_bytes()</see_also>
--</function>
public function bytes_to_uint(sequence s, integer direction=REVERSE)
  atom l, mult

  l = 0
  mult = 1
  if direction = NORMAL then
    for i = length(s) to 1 by -1 do
      l += s[i]*mult
      mult *= #100
    end for
  elsif direction = REVERSE then
    for i = 1 to length(s) do
      l += s[i]*mult
      mult *= #100
    end for
  end if
  return l
end function

-------------------------------------------------------------------------------

--<function>
--<name>uint_to_bytes</name>
--<digest>converts an atom to a sequence of bytes</digest>
--<desc></desc>
--<param>
--<type>atom</type>
--<name>n</name>
--<desc>atom to convert</desc>
--</param>
--<param>
--<type>integer</type>
--<name>digits</name>
--<desc>length of the resulting sequence</desc>
--</param>
--<param>
--<type>integer</type>
--<name>direction</name>
--<desc>
-- direction is NORMAL or REVERSE (default).
-- when direction is REVERSE (usual), lowest byte is first
-- when direction is NORMAL (telecom frames), highest byte is first
--</desc>
--</param>
--<return>
-- sequence
--</return>
--<example>
-- uint_to_bytes(#1C0A0000, 4, NORMAL) = {#1C, #0A, #00, #00}
-- uint_to_bytes(#1C0A0000, 4, REVERSE) = {#00, #00, #0A, #1C}
--</example>
--<see_also>bytes_to_uint()</see_also>
--</function>
public function uint_to_bytes(atom n, integer digits, integer direction=REVERSE)
  sequence s

  s = repeat(0, digits)
  if direction = NORMAL then
    for i = digits to 1 by -1 do
      s[i] = remainder(n, #100)
      n = floor(n / #100)
    end for
  elsif direction = REVERSE then
    for i = 1 to digits do
      s[i] = remainder(n, #100)
      n = floor(n / #100)
    end for
  end if
  return s
end function

------------------------------------------------------------------------------

public function utf8_to_chr(atom n)
--<function>
--<name>utf8_to_chr</name>
--<digest>converts an UTF-8 char to an ASCII char</digest>
--<desc></desc>
--<param>
--<type>integer</type>
--<name>c</name>
--<desc>UTF-8 char to convert</desc>
--</param>
--<return>
-- sequence
--</return>
--<example>
--</example>
--<see_also>ascii_to_utf8()</see_also>
--</function>
  atom res, a

  if n <= #7F then
--  xxxxxxx
--  0xxxxxxx
--  n & 7F
    return n
  elsif and_bits(n, #E000) = #C000 then
--       xxx   xx  xxxxxx
--  110xxxxx     10xxxxxx
--  ( (n & 1F00) >> 2 ) + (n & 003F)
    res =  shift_bits(and_bits(n, #1F00), 2)
    res +=            and_bits(n, #003F)
  elsif and_bits(n, #F00000) = #E00000 then
--           xxxx    xxxx   xx  xxxxxx
--  1110xxxx     10xxxxxx     10xxxxxx
--  ( (n & 0F0000) >> 4 ) + ( (n & 003F00) >> 2 ) + (n & 00003F)
    res =  shift_bits(and_bits(n, #0F0000), 4)
    res += shift_bits(and_bits(n, #003F00), 2)
    res +=            and_bits(n, #00003F)
  elsif and_bits(n, #F8000000) = #F0000000 then
--            xxx      xx xxxx    xxxx   xx  xxxxxx
--  11110xxx     10xxxxxx     10xxxxxx     10xxxxxx
--  ( (n & 07000000) >> 6 ) + ( (n & 003F0000) >> 4 ) +
--  ( (n & 00003F00) >> 2 ) + (n & 0000003F)
    res =  shift_bits(and_bits(n, #07000000), 6)
    res += shift_bits(and_bits(n, #003F0000), 4)
    res += shift_bits(and_bits(n, #00003F00), 2)
    res +=            and_bits(n, #0000003F)
  elsif and_bits(n, #FC00000000) = #F800000000 then
--  ( (n & 0300000000) >> 8 ) + ( (n & 003F000000) >> 6 ) +
--  ( (n & 00003F0000) >> 4 ) + ( (n & 0000003F00) >> 2 ) + (n & 000000003F)
    res =  shift_bits(and_bits(n, #0300000000), 8)
    res += shift_bits(and_bits(n, #003F000000), 6)
    res += shift_bits(and_bits(n, #00003F0000), 4)
    res += shift_bits(and_bits(n, #0000003F00), 2)
    res +=            and_bits(n, #000000003F)
  else
--  ( (n & 010000000000) >> 10 ) + ( (n & 003F00000000) >> 8 ) +
--  ( (n & 00003F000000) >> 6 ) + ( (n & 0000003F0000) >> 4 ) +
--  ( (n & 000000003F00) >> 2 ) + (n & 00000000003F)
    res =  shift_bits(and_bits(n, #010000000000), 10)
    res += shift_bits(and_bits(n, #003F00000000), 8)
    res += shift_bits(and_bits(n, #00003F000000), 6)
    res += shift_bits(and_bits(n, #0000003F0000), 4)
    res += shift_bits(and_bits(n, #000000003F00), 2)
    res +=            and_bits(n, #00000000003F)
  end if
  return res
end function

------------------------------------------------------------------------------

public function utf8_to_ascii(sequence s)
--<function>
--<name>utf8_to_ascii</name>
--<digest>converts an UTF-8 string to an ASCII string</digest>
--<desc></desc>
--<param>
--<type>sequence</type>
--<name>s</name>
--<desc>string to convert</desc>
--</param>
--<return>
-- sequence
--</return>
--<example>
--</example>
--<see_also>ascii_to_utf8()</see_also>
--</function>
  sequence res
  integer i, lg
  atom char

  i = 1
  res = ""
  lg = length(s)
  if lg < 2 then return s end if
  while i <= lg do
    if and_bits(s[i],#80) = #00 then
      res &= s[i]
      i += 1
    elsif and_bits(s[i], #E0) = #C0 then
 printf(f_debug, "s[i]   = %02x\n", s[i])
 printf(f_debug, "s[i+1] = %02x\n", s[i+1])
      char =  shift_bits(and_bits(s[i]  , #1F), -6)
      char +=            and_bits(s[i+1], #3F)
 printf(f_debug, "char = %04x\n", char)
      res = append(res, char)
      i += 2
    elsif and_bits(s[i], #F0) = #E0 then
      char =  shift_bits(and_bits(s[i]  , #0F0000), 4)
      char += shift_bits(and_bits(s[i+1], #003F00), 2)
      char +=            and_bits(s[i+2], #00003F)
      res &= uint_to_bytes(char, 2, NORMAL)
      i += 3
    elsif and_bits(s[i], #F8) = #F0 then
      char =  shift_bits(and_bits(s[i]  , #07000000), 6)
      char += shift_bits(and_bits(s[i+1], #003F0000), 4)
      char += shift_bits(and_bits(s[i+2], #00003F00), 2)
      char +=            and_bits(s[i+3], #0000003F)
      res &= uint_to_bytes(char, 2, NORMAL)
      i += 4
    else
      res &= s[i]
      i += 1
    end if
  end while
  return res
end function

------------------------------------------------------------------------------

public function unicode(integer c)
--<function>
--<name>unicode</name>
--<digest>converts an ASCII character to its unicode equivalent</digest>
--<desc></desc>
--<param>
--<type>integer</type>
--<name>c</name>
--<desc>integer to convert</desc>
--</param>
--<return>
-- sequence
--</return>
--<example>
-- puts(f_debug, unicode('A') & "\n")    --> A
-- puts(f_debug, unicode(#0152) & "\n")  --> &#x0152;
-- puts(f_debug, unicode(#0153) & "\n")  --> &#x0153;
-- puts(f_debug, unicode(#03C0) & "\n")  --> &#x03C0;
--</example>
--<see_also>utf8_to_ascii()</see_also>
--</function>
  sequence bits, u8

    if c >= 65536 then     -- 11110xxx 10xxxxxx 10xxxxxx 10xxxxxx
      bits = reverse(int_to_bits(c,21))
      u8 = {{1,1,1,1,0}&bits[1..3],{1,0}&bits[4..9],{1,0}&bits[10..15],{1,0}&bits[16..21]}
      return bits_to_int(reverse(u8[1]))&bits_to_int(reverse(u8[2]))&bits_to_int(reverse(u8[3]))&bits_to_int(reverse(u8[4]))
   elsif c >= 2048 then  -- 1110xxxx 10xxxxxx 10xxxxxx
      bits = reverse(int_to_bits(c,16))
      u8 = {{1,1,1,0}&bits[1..4],{1,0}&bits[5..10],{1,0}&bits[11..16]}
      return bits_to_int(reverse(u8[1]))&bits_to_int(reverse(u8[2]))&bits_to_int(reverse(u8[3]))
    elsif c >= 128 then   -- 110xxxxx 10xxxxxx
      bits = reverse(int_to_bits(c,11))
      u8 = {{1,1,0}&bits[1..5],{1,0}&bits[6..11]}
      return bits_to_int(reverse(u8[1]))&bits_to_int(reverse(u8[2]))
    else                -- 0xxxxxxx
      return {c}
    end if
end function

------------------------------------------------------------------------------

public function ascii_to_utf8(sequence s)
--<function>
--<name>ascii_to_utf8</name>
--<digest>converts an ASCII string to an UTF-8 string</digest>
--<desc></desc>
--<param>
--<type>sequence</type>
--<name>s</name>
--<desc>string to convert</desc>
--</param>
--<return>
-- sequence
--</return>
--<example>
-- puts(f_debug, ascii_to_utf8({#0152, #0153, #03C0}) & "\n")
--   --> &#x0152;&#x0153;&#x03C0;
--</example>
--<see_also>utf8_to_ascii()</see_also>
--</function>
  sequence res

  res = ""
  for i = 1 to length(s) do
    res &= unicode(s[i])
  end for
  return res
end function

------------------------------------------------------------------------------

public function cp850_to_unicode(integer c)
--<function>
--<name>cp850_to_unicode</name>
--<digest>converts a DOS character (codepage 850) to its unicode equivalent</digest>
--<desc></desc>
--<param>
--<type>integer</type>
--<name>c</name>
--<desc>integer to convert</desc>
--</param>
--<return>
-- sequence
--</return>
--<example>
-- puts(1, cp850_to_unicode(#82) & "\n")  --> #00E9 (&eacute;)
--</example>
--<see_also>unicode_to_cp850()</see_also>
--</function>
  return vlookup(c, CP850_UNICODE, 1, 2, '?')
end function

------------------------------------------------------------------------------

public function unicode_to_cp850(integer c)
--<function>
--<name>unicode</name>
--<digest>converts an unicode character to its DOS equivalent (codepage 850)</digest>
--<desc></desc>
--<param>
--<type>integer</type>
--<name>c</name>
--<desc>integer to convert</desc>
--</param>
--<return>
-- sequence
--</return>
--<example>
-- puts(f_debug, unicode_to_cp850(#00E9) & "\n")  --> #82 (&eacute;)
--</example>
--<see_also>cp850_to_unicode()</see_also>
--</function>
  return vlookup(c, CP850_UNICODE, 2, 1, '?')
end function

------------------------------------------------------------------------------

public function dos_to_unix(sequence s)
--<function>
--<name>dos_to_unix</name>
--<digest>converts DOS end of lines to Unix ones</digest>
--<desc></desc>
--<param>
--<type>sequence</type>
--<name>s</name>
--<desc>string to convert</desc>
--</param>
--<return>
-- sequence
--</return>
--<example>
-- dos_to_unix("message\r\n") --> "message\n"
--</example>
--<see_also>unix_to_dos()</see_also>
--</function>
  integer index
  sequence res

  res = ""
  index = match({13,10}, s)
  while index != 0 do
    if index > 1 then
      res &= s[1..index-1]&{10}
    elsif index = 1 then
      res &= {10}
    end if
    if (index+2) > length(s) then
      s = ""
      exit
    end if
    s = s[index+2..$]
    index = match({13,10}, s)
  end while
  if length(s) then res &= s end if
  return res
end function

------------------------------------------------------------------------------

public function unix_to_dos(sequence s)
--<function>
--<name>unix_to_dos</name>
--<digest>converts Unix end of lines to DOS ones</digest>
--<desc></desc>
--<param>
--<type>sequence</type>
--<name>s</name>
--<desc>string to convert</desc>
--</param>
--<return>
-- sequence
--</return>
--<example>
--</example>
--<see_also>dos_to_unix()</see_also>
--</function>
  integer index
  sequence res

  res = ""
  index = find(10, s)
  while index != 0 do
    if index > 1 then
      res &= s[1..index-1]&{13,10}
    elsif index = 1 then
      res &= {13,10}
    end if
    if (index+1) > length(s) then
      s = ""
      exit
    end if
    s = s[index+1..$]
    index = find(10, s)
  end while
  if length(s) then res &= s end if
  return res
end function

