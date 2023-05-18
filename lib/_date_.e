-- Date Calculations
--
-- Sep 1, 1996
-- written by Junko C. Miura, Rapid Deployment Software
-- Contributed to the Public Domain
--
-- Aug 5, 2010
-- converted by Jean-Marc Duro to a reusable unit

include std/convert.e
include std/sequence.e
include std/text.e
include std/math.e
include _common_.e
include _conv_.e
include _sequence_.e

constant
  YEAR = 1,
  MONTH = 2,
  DAY = 3,
  HOUR = 4,
  MINUTE = 5,
  SECOND = 6

public constant DATE_LANGUAGE="fr"
--<constant>
--<name>DATE_LANGUAGE</name>
--<value>One of "en" or "fr"</value>
--<desc>Language used to format date strings</desc>
--</constant>

public constant STR_WEEK = {"Saturday", "Sunday", "Monday", "Tuesday", "Wednesday",
		 "Thursday", "Friday"}
--<constant>
--<name>STR_WEEK</name>
--<value>{"Saturday", "Sunday", "Monday", "Tuesday", "Wednesday", "Thursday", "Friday"}</value>
--<desc>Names of the days in a week (english)</desc>
--</constant>
public constant STR_SEMAINE = {"Samedi", "Dimanche", "Lundi", "Mardi", "Mercredi",
		 "Jeudi", "Vendredi"}
--<constant>
--<name>STR_SEMAINE</name>
--<value>{"Samedi", "Dimanche", "Lundi", "Mardi", "Mercredi", "Jeudi", "Vendredi"}</value>
--<desc>Names of the days in a week (french)</desc>
--</constant>

public constant STR_MONTH = {"January", "February", "March", "April", "May", "June",
         "July", "August", "September", "October", "November", "December"}
--<constant>
--<name>STR_MONTH</name>
--<value>{"January", "February", "March", "April", "May", "June", "July", "August", "September", "October", "November", "December"}</value>
--<desc>Names of the monthes in a year (english)</desc>
--</constant>
public constant STR_MOIS = {"Janvier", "Février", "Mars", "Avril", "Mai", "Juin",
         "Juillet", "Août", "Septembre", "Octobre", "Novembre", "Décembre"}
--<constant>
--<name>STR_MOIS</name>
--<value>{"Janvier", "Février", "Mars", "Avril", "Mai", "Juin", "Juillet", "Août", "Septembre", "Octobre", "Novembre", "Décembre"}</value>
--<desc>Names of the monthes in a year (french)</desc>
--</constant>

public constant STRING_DATE=1, FILE_DATE=2

------------------------------------------------------------------------------

-- procedures and functions definition
function INT(atom x)
  if x >= 0 then
    return floor(x)
  else
    return -1 * floor(-x)
  end if
end function

------------------------------------------------------------------------------

public function get_factor(integer yyyy, integer mm, integer dd)
--<function>
--<name>get_factor</name>
--<digest></digest>
--<desc>
--</desc>
--<param>
--<type>integer</type>
--<name>yyyy</name>
--<desc>year on 4 digits</desc>
--</param>
--<param>
--<type>integer</type>
--<name>mm</name>
--<desc>month</desc>
--</param>
--<param>
--<type>integer</type>
--<name>dd</name>
--<desc>day</desc>
--</param>
--<return>
--</return>
--<example>
-- lunar_landing = get_factor(1969, 7, 20)
--</example>
--<see_also>
--</see_also>
--</function>
  integer factor

  if yyyy <= 1582 then
	error_message("year must be >1582", 0)
  end if
  if mm < 1 or mm > 12 then
	error_message("month must be >0 and <=12", 0)
  end if
  if mm < 1 or mm > 31 then
	error_message("day must be >0 and <=31", 0)
  end if
  if mm > 2 then
    factor = 365 * yyyy + dd + 31 * (mm - 1) - INT(0.4 * mm + 2.3)
		 + INT(yyyy / 4) - INT(0.75 * (INT(yyyy / 100) + 1))
  else
	factor = 365 * yyyy + dd + 31 * (mm - 1) + INT((yyyy - 1) / 4)
		 - INT(0.75 * (INT(((yyyy - 1) / 100) + 1)))
  end if
  return factor
end function

------------------------------------------------------------------------------

public function day_of_week(integer yyyy, integer mm, integer dd)
--<function>
--<name>day_of_week</name>
--<digest>gets the day of the week of a specified date</digest>
--<desc></desc>
--<param>
--<type>integer</type>
--<name>yyyy</name>
--<desc>year on 4 digits</desc>
--</param>
--<param>
--<type>integer</type>
--<name>mm</name>
--<desc>month</desc>
--</param>
--<param>
--<type>integer</type>
--<name>dd</name>
--<desc>day</desc>
--</param>
--<return>
--</return>
--<example>
-- printf(1, "The lunar module Eagle landed on the moon on %s July 20, 1969\n",
--        {WEEK[day_of_week(1969, 7, 20)]})
-- printf(1, "Le module lunaire Eagle a atterri sur la lune le %s 20 juillet 1969\n",
--        {SEMAINE[day_of_week(1969, 7, 20)]})
--</example>
--<see_also>
--</see_also>
--</function>
  integer factor, day

  factor = get_factor(yyyy, mm, dd)
  day = factor + (INT(-factor / 7) * 7)
  if day > 6 then              -- start of DEBUG
	error_message(sprintf("WARNING-- day_of_week : %d\n", day), 0)
	day = remainder(day, 7)
  end if                             -- end of DEBUG
  return day + 1
end function

------------------------------------------------------------------------------

public function days_between_dates(sequence date1, sequence date2)
--<function>
--<name>days_between_dates</name>
--<digest>gets the number of days between two dates</digest>
--<desc>
--</desc>
--<param>
--<type>sequence</type>
--<name>date1</name>
--<desc></desc>
--</param>
--<param>
--<type>sequence</type>
--<name>date2</name>
--<desc></desc>
--</param>
--<return>
--</return>
--<example>
-- printf(1, "The lunar module Eagle landed on the moon %d days ago\n", days_between_dates({1969, 7, 20}, {1900+dt[1], dt[2], dt[3]}))
--</example>
--<see_also>
--</see_also>
--</function>
  integer factor1, factor2, numDays

  factor1 = get_factor(date1[1],date1[2],date1[3])
  factor2 = get_factor(date2[1],date2[2],date2[3])
  if factor2 > factor1 then
    numDays = factor2 - factor1
  else
    numDays = factor1 - factor2
  end if
  return numDays
end function

------------------------------------------------------------------------------

public function datetime_to_iso(sequence dt, integer fmt)
--<function>
--<name>datetime_to_iso</name>
--<digest>returns date and time in ISO format</digest>
--<desc></desc>
--<param>
--<type>sequence</type>
--<name>dt</name>
--<desc>
-- date in datetime format
--</desc>
--</param>
--<param>
--<type>integer</type>
--<name>fmt</name>
--<desc>
-- output format:
-- * STRING_DATE: "YYYY-MM-DD HH:MM:SS"
-- * FILE_DATE  : "YYYY-MM-DD_HH-MM-SS"
--</desc>
--</param>
--<return>
-- sequence: date and time in ISO format
--</return>
--<example>
-- puts(1, datetime_to_iso(date(), STRING_DATE) & " -> message\n")
-- 2016-11-14 08:14:14 -> message
-- puts(1, datetime_to_iso(date(), FILE_DATE) & ".log")
-- 2016-11-14_08-14-14.log
--</example>
--<see_also></see_also>
--</function>
  if fmt=STRING_DATE then
    return sprintf("%d-%02d-%02d %02d:%02d:%02d", {
                             (dt[1] + 1900), dt[2], dt[3],
                              dt[4], dt[5], dt[6]
                            })
  elsif fmt=FILE_DATE then
    return sprintf("%d-%02d-%02d_%02d-%02d-%02d", {
                             (dt[1] + 1900), dt[2], dt[3],
                              dt[4], dt[5], dt[6]
                            })
  end if
end function


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
  return sprintf("%s -> %s\n", {datetime_to_iso(date(), STRING_DATE), msg})
end function

------------------------------------------------------------------------------

public function string_to_datetime(sequence oa)
--<function>
--<name>string_to_datetime</name>
--<digest>converts a string in datetime format</digest>
--<desc>
-- monthes names have to be complete: no abbreviation
-- monthes decoding according to DATE_LANGUAGE constant: "en" or "fr"
-- seconds are optional
--</desc>
--<param>
--<type>sequence</type>
--<name>dt</name>
--<desc>
-- date and time in string format
--</desc>
--</param>
--<return>
-- sequence: datetime
--</return>
--<example>
-- puts(1, "string_to_datetime(\"27 octobre 1996 11:10:00\") = " &
--      object_dump(string_to_datetime("27 octobre 1996 11:10:00")) & "\n")
-- string_to_datetime("27 octobre 1996 11:10:00") = {1996,10,27,11,10,0}
-- puts(1, "string_to_datetime(\"27 octobre 1996 11:10\") = " &
--      object_dump(string_to_datetime("27 octobre 1996 11:10")) & "\n")
-- string_to_datetime("27 octobre 1996 11:10") = {1996,10,27,11,10,0}
--</example>
--<see_also></see_also>
--</function>
  sequence s, month_names
  integer y, m, d

  if equal(DATE_LANGUAGE, "fr") then
    month_names = STR_MOIS
  else
    month_names = STR_MONTH
  end if
  s = split(oa, " ", {})
  m = find(lower(s[2]), lower(month_names))
  if m = 0 then
    return "Invalid Month"
  end if
  y = to_number(s[3])
  d = to_number(s[1])
  s = split(s[4], ":", {})
  if length(s) = 3 then
    return {y, m, d, to_number(s[1]), to_number(s[2]), to_number(s[3])}
  else
    return {y, m, d, to_number(s[1]), to_number(s[2]), 0}
  end if
end function

------------------------------------------------------------------------------

public function seconds_to_time_string(atom t)
--<function>
--<name>seconds_to_time_string</name>
--<digest>
-- converts a number of seconds in a string formatted with days, hours,
-- minutes and seconds
--</digest>
--<desc>
-- day abbreviation according to DATE_LANGUAGE constant
--</desc>
--<param>
--<type>atom</type>
--<name>t</name>
--<desc>
-- number of seconds to convert
--</desc>
--</param>
--<return>
-- string
--</return>
--<example>
-- puts(1, "seconds_to_time_string(99999) = " &
--      object_dump(seconds_to_time_string(99999)) & "\n")
-- seconds_to_time_string(99999) = '01j 03h 46mn 39s'
--</example>
--<see_also></see_also>
--</function>
  integer d, h, m, s

  d = floor(t/86400)
  t -= d*86400
  h = floor(t/3600)
  t -= h*3600
  m = floor(t/60)
  t -= m*60
  s = floor(t)
  if equal(DATE_LANGUAGE, "fr") then
    return sprintf("%02dj %02dh %02dmn %02ds", {d, h, m, s})
  else  -- english
    return sprintf("%02dd %02dh %02dmn %02ds", {d, h, m, s})
  end if
end function

------------------------------------------------------------------------------


public function excel_time_to_datetime(atom a)
--<function>
--<name>excel_time_to_datetime</name>
--<digest>converts an Excel datetime atom in a datetime sequence</digest>
--<desc></desc>
--<param>
--<type>atom</type>
--<name>a</name>
--<desc>
-- Excel datetime atom to convert
--</desc>
--</param>
--<return>
-- sequence: datetime
--</return>
--<example>
-- birth = datetime_to_excel_time({1996, 10, 27, 11, 10, 0})
-- printf(1, "excel_time_to_datetime(%f) = %s\n", {birth,
--      object_dump(excel_time_to_datetime(birth))})
-- excel_time_to_datetime(35365.465278) = {1996,10,27,11,10,0}
--</example>
--<see_also></see_also>
--</function>
  atom t
  integer ly, d
  sequence dt

  -- return date
  dt = {1900,1,1,0,0,0}
  a = a - 1  -- 1/1/1900 begins as #1
  while a > 1 do
    if remainder(dt[YEAR],4)=0 then
      -- and (remainder(dt[YEAR],100)>0 or remainder(dt[YEAR],400)=0) Microsoft Excel includes years divisible
      -- by 100 but not by 400 as leap years.
      ly = 1
    else
      ly = 0
    end if
    if a >= 366 and ly = 1 then
      dt[YEAR] = dt[YEAR] + 1
      a -= 366
    elsif a >= 365 and ly = 0 then
      dt[YEAR] = dt[YEAR] + 1
      a -= 365
    elsif find(dt[MONTH],{1,3,5,7,8,10,12}) and a >= 31 then
      dt[MONTH] = dt[MONTH] + 1
      a -= 31
    elsif find(dt[MONTH],{4,6,9,11}) and a >= 30 then
      dt[MONTH] = dt[MONTH] + 1
      a -= 30
    elsif dt[MONTH]=2 and ly=1 and a >= 29 then
      dt[MONTH] = dt[MONTH] + 1
      a -= 29
    elsif dt[MONTH]=2 and ly=0 and a >= 28 then
      dt[MONTH] = dt[MONTH] + 1
      a -= 28
    else
      d = trunc(a)
      dt[DAY] = dt[DAY] + d
      a -= d
    end if
  end while
  t = frac(a) * 24
  dt[HOUR] = trunc(t)
  t = (t-dt[HOUR]) * 60
  dt[MINUTE] = trunc(t)
  t = (t-dt[MINUTE]) * 60
  dt[SECOND] = trunc(t)
  return dt
end function

------------------------------------------------------------------------------

public function datetime_to_excel_time(sequence dt)
--<function>
--<name>datetime_to_excel_time</name>
--<digest>converts a datetime sequence in an Excel datetime atom</digest>
--<desc></desc>
--<param>
--<type>sequence</type>
--<name>dt</name>
--<desc>
-- datetime sequence to convert
--</desc>
--</param>
--<return>
-- Excel datetime atom
--</return>
--<example>
-- birth = datetime_to_excel_time({1996, 10, 27, 11, 10, 0})
-- printf(1, "datetime_to_excel_time(%s) = %f\n", {
--        object_dump({1996, 10, 27, 11, 10, 0}), birth})
-- datetime_to_excel_time({1996,10,27,11,10,0}) = 35365.465278
--</example>
--<see_also></see_also>
--</function>
  atom nb

  nb = days_between_dates({1899,12,30}, {dt[YEAR],dt[MONTH],dt[DAY]})
  nb += (dt[SECOND]+dt[MINUTE]*60+dt[HOUR]*3600)/86400
  return nb
end function

