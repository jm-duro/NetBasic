-- _types_.e

------------------------------------------------------------------------------

public constant
  DIGITS = "0123456789ABCDEF"
--<constant>
--<name>DIGITS</name>
--<value>"0123456789ABCDEF"</value>
--<desc></desc>
--</constant>

------------------------------------------------------------------------------

public type positive(object x)
--<eu_type>
--<name>positive</name>
--<desc>checks if <b>x</b> >=0</desc>
--<param>
--<type>object</type>
--<name>x</name>
--<desc>object to check</desc>
--</param>
--</eu_type>
  if not atom(x) then return 0 end if
  return x>=0
end type

--------------------------------------------------------------------------------

public type is_space(object n)
--<eu_type>
--<name>is_space</name>
--<desc>checks if <b>n</b> is a space, tab, vtab, cr, lf of ff</desc>
--<param>
--<type>object</type>
--<name>n</name>
--<desc>object to check</desc>
--</param>
--</eu_type>
  if not integer(n) then return 0 end if
  return find(n, {32, 10, 9, 11, 12, 13})
end type

--------------------------------------------------------------------------------

public type is_alpha(object n)
--<eu_type>
--<name>is_alpha</name>
--<desc>checks if <b>n</b> is within [a-z] or [A-Z]</desc>
--<param>
--<type>object</type>
--<name>n</name>
--<desc>object to check</desc>
--</param>
--</eu_type>
  if not integer(n) then return 0 end if
  return ((n >= 'A') and (n <= 'Z')) or
         ((n >= 'a') and (n <= 'z'))
end type

--------------------------------------------------------------------------------

public type is_digit(object n)
--<eu_type>
--<name>is_digit</name>
--<desc>test if <b>n</b> is within [0-9]</desc>
--<param>
--<type>object</type>
--<name>n</name>
--<desc>object to check</desc>
--</param>
--</eu_type>
  if not integer(n) then return 0 end if
  return (n >= '0') and (n <= '9')
end type

------------------------------------------------------------------------------

public type is_string(object x)
--<eu_type>
--<name>is_string</name>
--<desc>checks if <b>x</b> is a string</desc>
--<param>
--<type>object</type>
--<name>x</name>
--<desc>object to check</desc>
--</param>
--</eu_type>
  if atom(x) then return 0 end if
  for i = 1 to length(x) do
    if not integer(x[i]) then return 0 end if
    if (x[i] < ' ') and (x[i] != 9) and (x[i] != 13) and (x[i] != 10) then return 0 end if
    if x[i]> 254 then return 0 end if
  end for
  return 1
end type

------------------------------------------------------------------------------

public type is_integer(object s)
--<eu_type>
--<name>is_integer</name>
--<desc>checks if <b>s</b> represents an integer</desc>
--<param>
--<type>object</type>
--<name>s</name>
--<desc>object to check</desc>
--</param>
--</eu_type>
  integer lg, nb_digits

  if atom(s) then return 0 end if
  lg = length(s)
  nb_digits = 0
  if lg = 0 then return 0 end if
  for i = 1 to lg do
    if sequence(s[i]) then
      return 0
    else
      if is_digit(s[i]) then
        nb_digits += 1
      elsif not find(s[i], "-+") then
        return 0
      end if
    end if
  end for
  if nb_digits = 0 then return 0 else return 1 end if
end type

------------------------------------------------------------------------------

public type is_number(object s)
--<eu_type>
--<name>is_number</name>
--<desc>checks if <b>s</b> represents a number</desc>
--<param>
--<type>object</type>
--<name>s</name>
--<desc>object to check</desc>
--</param>
--</eu_type>
  integer lg, nb_digits

  if atom(s) then return 0 end if
  lg = length(s)
  nb_digits = 0
  if lg = 0 then return 0 end if
  for i = 1 to lg do
    if sequence(s[i]) then
      return 0
    else
      if is_digit(s[i]) then
        nb_digits += 1
      elsif not find(s[i], ",.-+") then
        return 0
      end if
    end if
  end for
  if nb_digits = 0 then return 0 else return 1 end if
end type

------------------------------------------------------------------------------

public type is_date(object s)
--<eu_type>
--<name>is_date</name>
--<desc>
-- checks if <b>s</b> represents a date
-- "[.]./[.]./[..].."
--</desc>
--<param>
--<type>object</type>
--<name>s</name>
--<desc>object to check</desc>
--</param>
--</eu_type>
  integer n, n2

  if atom(s) then return 0 end if
  n = length(s) if (n < 6) or (n > 10) then return 0 end if
  for i = 1 to length(s) do
    if sequence(s[i]) then return 0 end if
    if not is_digit(s[i]) and (s[i] != '/') then return 0 end if
    n = find('/', s) if (n != 2) and (n != 3) then return 0 end if
    n2 = find('/', s[n+1..$]) if (n2 != 2) and (n2 != 3) then return 0 end if
  end for
  return 1
end type

------------------------------------------------------------------------------

public type is_hex(object s)
--<eu_type>
--<name>is_hex</name>
--<desc>checks if <b>s</b> represents a hexadecimal number</desc>
--<param>
--<type>object</type>
--<name>s</name>
--<desc>object to check</desc>
--</param>
--</eu_type>
  integer lg

  if atom(s) then return 0 end if
  lg = length(s)
  if lg < 2 then return 0 end if         -- min 2 cars (#n)
  if s[1] != '#' then return 0 end if
  for i = 2 to lg do
    if sequence(s[i]) then
      return 0
    else
      if not find(s[i], DIGITS) then return 0 end if
    end if
  end for
  return 1
end type

--------------------------------------------------------------------------------

public type is_identifier(object s)
--<eu_type>
--<name>is_identifier</name>
--<desc>
-- checks if <b>s</b> represents an identifier
-- begins with '_' or  [a-z] or [A-Z]
-- contains '_' or  [a-z] or [A-Z] or [0-9]
--</desc>
--<param>
--<type>object</type>
--<name>s</name>
--<desc>object to check</desc>
--</param>
--</eu_type>
  integer lg

  if not is_string(s) then return 0 end if
  lg = length(s)
  if lg = 0 then return 0 end if
  if not is_alpha(s[1]) and (s[1] != '_') then
    return 0
  end if
  for i = 2 to lg do
    if sequence(s[i]) then
      return 0
    else
      if not is_alpha(s[i]) and (s[i] != '_') and not is_digit(s[i]) then
        return 0
      end if
    end if
  end for
  return 1
end type
