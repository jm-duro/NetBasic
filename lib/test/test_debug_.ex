include std/search.e
include std/console.e
include lib/_debug_.e
include lib/_sequence_.e

puts(1, date_stamp("message") & "\n")
-- 2016-11-14 08:14:14 -> message

display_message("Information", 0)
display_message("Warning", WARNING_MSG)
display_message("Error", ERROR_MSG)

puts(1, show_printable("message"&10&"and"&8&2&233) & "\n")
-- message[lf]and[bksp].Ú

puts(1, object_dump({{1}}&"message"&10&"and"&{{8,2},4}&233) & "\n")
-- {{1},109,101,115,115,97,103,101,10,97,110,100,{8,2},4,233}      '{}message[lf]and{}.Ú'

integer rtn_id
function identifyInstruction(sequence path, integer level, integer n)
--  printf(1, "  path: '%s', level: %d, n: %d\n", {path, level, n})
  if level = 1 then
    if n = 1 then return "TARGET_DEVICE"
    elsif n = 2 then return "OPERATION"
    elsif n = 3 then return "INSTRUCTIONS"
    elsif n = 4 then return "FILTER"
    end if
  elsif (level = 2) and ends("[4]", path) then
    if n = 1 then return "FROM"
    elsif n = 2 then return "TO"
    end if
  end if
  return sprintf("%d",n)
end function
rtn_id = routine_id("identifyInstruction")

sequence endCommands

endCommands = {{1, "", "term len 0", 0}, {1, "", "debug cwmp", {"interface 0", "exit"}}}

analyze_object(endCommands, "endCommands", 1, rtn_id)
-- endCommands =
-- .  [1]
-- .  .  [TARGET_DEVICE] 1
-- .  .  [OPERATION] ""
-- .  .  [INSTRUCTIONS] "term len 0"
-- .  .  [FILTER] 0
-- .  [2]
-- .  .  [TARGET_DEVICE] 1
-- .  .  [OPERATION] ""
-- .  .  [INSTRUCTIONS] "debug cwmp"
-- .  .  [FILTER]
-- .  .  .  [FROM] "interface 0"
-- .  .  .  [TO] "exit"

analyze_object(endCommands, "endCommands")
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

hex_dump("0123456789ABCDEF"&0&1&2&3&4, 1)

-- Addr  0  1  2  3  4  5  6  7  8  9  A  B  C  D  E  F
-- 0000  30 31 32 33 34 35 36 37 38 39 41 42 43 44 45 46
-- 0001  00 01 02 03 04

integer ok
maybe_any_key()

