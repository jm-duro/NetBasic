include std/os.e
include euphoria/info.e
include _common_.e

public integer eu_version
--<variable>
--<type>integer</type>
--<name>eu_version</name>
--<desc>
-- One of following constants:
-- EU_4_1_LNX_64, EU_4_1_LNX_32, EU_4_0_LNX,
-- EU_4_1_WIN_64, EU_4_1_WIN_32, EU_4_0_WIN
--</desc>
--</variable>
eu_version = 0

------------------------------------------------------------------------------

public function eu_version_name()
--<function>
--<name>eu_version_name</name>
--<digest>returns eu_version as a string</digest>
--<desc></desc>
--<return>
-- One of following strings:
-- "EU_4_1_LNX_64", "EU_4_1_LNX_32", "EU_4_0_LNX",
-- "EU_4_1_WIN_64", "EU_4_1_WIN_32", "EU_4_0_WIN"
--</return>
--<example>
-- printf(1, "eu_version_name() = %s\n", {eu_version_name()})
-- eu_version_name() = EU_4_1_WIN_32
--</example>
--<see_also>
--</see_also>
--</function>
  if eu_version = EU_4_1_LNX_64 then
    return "EU_4_1_LNX_64"
  elsif eu_version = EU_4_1_LNX_32 then
    return "EU_4_1_LNX_32"
  elsif eu_version = EU_4_0_LNX then
    return "EU_4_0_LNX"
  elsif eu_version = EU_4_1_WIN_64 then
    return "EU_4_1_WIN_64"
  elsif eu_version = EU_4_1_WIN_32 then
    return "EU_4_1_WIN_32"
  elsif eu_version = EU_4_0_WIN then
    return "EU_4_0_WIN"
  end if
  return ""
end function

------------------------------------------------------------------------------

integer major = version_major()
integer minor = version_minor()
sequence arch = arch_bits()

ifdef WINDOWS then
  if (major=4) and (minor=0) then
    eu_version = EU_4_0_WIN
    address_length = 4
  else
    if compare(arch, "32-bit") = 0 then
      eu_version = EU_4_1_WIN_32
      address_length = 4
    elsif compare(arch, "64-bit") = 0 then
      eu_version = EU_4_1_WIN_64
      address_length = 8
    end if
  end if
elsifdef LINUX then
  if (major=4) and (minor=0) then
    eu_version = EU_4_0_LNX
    address_length = 4
  else
    if compare(arch, "32-bit") = 0 then
      eu_version = EU_4_1_LNX_32
      address_length = 4
    elsif compare(arch, "64-bit") = 0 then
      eu_version = EU_4_1_LNX_64
      address_length = 8
    end if
  end if
end ifdef
