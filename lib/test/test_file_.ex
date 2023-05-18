-- _file_.e

include std/console.e
include std/filesys.e
include lib/_file_.e
include lib/_debug_.e

f_debug = open("debug.log", "w")

puts(1, remove_eol("First Line\nSecond Line\r\nThird Line\rFourth Line") & "\n")
-- First Line Second Line Third Line Fourth Line

sequence s

s = {
  ".",
  "." & SLASH,
  "." & SLASH & ".",
  "." & SLASH & "." & SLASH,
  "." & SLASH & "." & SLASH & "filename",
  "." & SLASH & "." & SLASH & "filename.txt",
  "." & SLASH & ".." & SLASH & "filename",
  "." & SLASH & ".." & SLASH & "filename.txt",
  "." & SLASH & "filename",
  "." & SLASH & "filename.",
  "." & SLASH & "filename.txt",
  "." & SLASH & "subpath" & SLASH & "filename",
  "." & SLASH & "subpath" & SLASH & "filename.txt",
  ".." & SLASH & "." & SLASH & "filename",
  ".." & SLASH & "." & SLASH & "filename",
  ".." & SLASH & "." & SLASH & "filename",
  ".." & SLASH & "." & SLASH & "filename",
  ".." & SLASH & "." & SLASH & "filename.txt",
  ".." & SLASH & ".." & SLASH & "filename",
  ".." & SLASH & ".." & SLASH & "filename.txt",
  ".." & SLASH,
  ".." & SLASH & "filename",
  ".." & SLASH & "filename.",
  ".." & SLASH & "filename.txt",
  ".." & SLASH & "subpath" & SLASH & "filename",
  ".." & SLASH & "subpath" & SLASH & "filename.txt",
  "C:" & SLASH & "." & SLASH & "filename",
  "C:" & SLASH & "." & SLASH & "filename",
  "C:" & SLASH & "." & SLASH & "filename.txt",
  "C:" & SLASH & "." & SLASH & "filename.txt",
  "C:" & SLASH & ".." & SLASH & "filename",
  "C:" & SLASH & ".." & SLASH & "filename",
  "C:" & SLASH & ".." & SLASH & "filename.txt",
  "C:" & SLASH & ".." & SLASH & "filename.txt",
  "C:" & SLASH,
  "C:" & SLASH & "filename",
  "C:" & SLASH & "filename.",
  "C:" & SLASH & "filename.txt",
  "C:" & SLASH & "subpath" & SLASH,
  "C:" & SLASH & "subpath" & SLASH & "filename",
  "C:" & SLASH & "subpath" & SLASH & "filename.",
  "C:" & SLASH & "subpath" & SLASH & "filename.txt",
  "C:." & SLASH & "." & SLASH & "filename",
  "C:." & SLASH & "." & SLASH & "filename.txt",
  "C:." & SLASH & ".." & SLASH & "filename",
  "C:." & SLASH & ".." & SLASH & "filename.txt",
  "C:." & SLASH,
  "C:." & SLASH & "filename",
  "C:." & SLASH & "filename.",
  "C:." & SLASH & "filename.txt",
  "C:." & SLASH & "subpath" & SLASH & "filename",
  "C:." & SLASH & "subpath" & SLASH & "filename.txt",
  "C:.." & SLASH & "." & SLASH & "filename",
  "C:.." & SLASH & "." & SLASH & "filename.txt",
  "C:.." & SLASH & ".." & SLASH & "filename",
  "C:.." & SLASH & ".." & SLASH & "filename.txt",
  "C:.." & SLASH,
  "C:.." & SLASH & "filename",
  "C:.." & SLASH & "filename.",
  "C:.." & SLASH & "filename.txt",
  "C:.." & SLASH & "subpath" & SLASH & "filename",
  "C:.." & SLASH & "subpath" & SLASH & "filename.txt",
  "C:path" & SLASH & "." & SLASH & "filename",
  "C:path" & SLASH & "." & SLASH & "filename.txt",
  "C:path" & SLASH & ".." & SLASH & "filename",
  "C:path" & SLASH & ".." & SLASH & "filename.txt",
  "C:path" & SLASH & "filename",
  "C:path" & SLASH & "filename",
  "C:path" & SLASH & "filename.txt",
  "C:path" & SLASH & "filename.txt",
  "C:path" & SLASH & "subpath" & SLASH & "filename",
  "C:path" & SLASH & "subpath" & SLASH & "filename.txt",
  "path" & SLASH & "." & SLASH & "filename",
  "path" & SLASH & "." & SLASH & "filename.txt",
  "path" & SLASH & ".." & SLASH & "filename",
  "path" & SLASH & ".." & SLASH & "filename.txt",
  "path" & SLASH & "filename",
  "path" & SLASH & "filename",
  "path" & SLASH & "filename.txt",
  "path" & SLASH & "filename.txt",
  "path" & SLASH & "subpath" & SLASH & "filename",
  "path" & SLASH & "subpath" & SLASH & "filename.txt",
  SLASH & "." & SLASH & "filename",
  SLASH & "." & SLASH & "filename",
  SLASH & "." & SLASH & "filename.txt",
  SLASH & "." & SLASH & "filename.txt",
  SLASH & ".." & SLASH & "filename",
  SLASH & ".." & SLASH & "filename",
  SLASH & ".." & SLASH & "filename.txt",
  SLASH & ".." & SLASH & "filename.txt",
  SLASH & "filename",
  SLASH & "filename.",
  SLASH & "filename.txt",
  SLASH & "subpath" & SLASH,
  SLASH & "subpath" & SLASH & "filename",
  SLASH & "subpath" & SLASH & "filename.",
  SLASH & "subpath" & SLASH & "filename.txt",
  {SLASH}
}

for i = 1 to length(s) do
  analyze_object(split_filename(s[i]), s[i], f_debug)
end for

s = {
  ".",
  "." & SLASH,
  "." & SLASH & ".",
  "." & SLASH & "." & SLASH,
  "." & SLASH & "subpath" & SLASH,
  ".." & SLASH,
  ".." & SLASH & "..",
  ".." & SLASH & ".." & SLASH,
  ".." & SLASH & "subpath" & SLASH,
  "C:" & SLASH & ".",
  "C:" & SLASH & "." & SLASH,
  "C:" & SLASH & "..",
  "C:" & SLASH & ".." & SLASH,
  "C:" & SLASH,
  "C:" & SLASH & ".",
  "C:" & SLASH & "..",
  "C:" & SLASH & "path",
  "C:" & SLASH & "path" & SLASH,
  "C:" & SLASH & "path" & SLASH & "subpath",
  "C:" & SLASH & "path" & SLASH & "subpath" & SLASH,
  "C:" & SLASH & "subpath" & SLASH & ".",
  "C:" & SLASH & "subpath" & SLASH & "..",
  "C:." & SLASH & "." & SLASH & ".",
  "C:." & SLASH & ".." & SLASH & ".",
  "C:." & SLASH,
  "C:." & SLASH & ".",
  "C:." & SLASH & "..",
  "C:." & SLASH & "subpath" & SLASH & ".",
  "C:.." & SLASH & "." & SLASH & ".",
  "C:.." & SLASH & ".." & SLASH & ".",
  "C:.." & SLASH,
  "C:.." & SLASH & ".",
  "C:.." & SLASH & "..",
  "C:.." & SLASH & "subpath" & SLASH & ".",
  "C:path" & SLASH & "." & SLASH & ".",
  "C:path" & SLASH & ".." & SLASH & ".",
  "C:path" & SLASH & ".",
  "C:path" & SLASH & ".",
  "C:path" & SLASH & "subpath" & SLASH & ".",
  "path" & SLASH & "." & SLASH & ".",
  "path" & SLASH & ".." & SLASH & ".",
  "path" & SLASH & ".",
  "path" & SLASH & "..",
  "path" & SLASH & "subpath" & SLASH & ".",
  "path" & SLASH & "subpath" & SLASH & "..",
  SLASH & "." & SLASH & ".",
  SLASH & "." & SLASH & "..",
  SLASH & ".." & SLASH & ".",
  SLASH & ".." & SLASH & "..",
  SLASH & ".",
  SLASH & "..",
  SLASH & "subpath" & SLASH,
  {SLASH}
}

for i = 1 to length(s) do
  analyze_object(parent_dir(s[i]), s[i], f_debug)
end for

copy_file("test_file_.exw", "test_file_.bak")
--         1 fichier(s) copié(s).

replace_text("test_file_.bak", "new_file_.bak", "filename", "this")

? file_exists("test_file_.bak")
-- 1
? file_exists("test_file_.old")
-- 0

analyze_object(read_csv("test.csv", 1), "read_csv")
-- read_csv =
-- .  [1]
-- .  .  [1] "Name"
-- .  .  [2] "Bytes"
-- .  .  [3] "Size"
-- .  .  [4] "#Files"
-- .  .  [5] "Most recent"
-- .  [2]
-- .  .  [1] "Z:\"
-- .  .  [2] 56144659864
-- .  .  [3] "52,29 GB"
-- .  .  [4] 23855
-- .  .  [5] 2016
-- .  [3]
-- .  .  [1] "Z:" & SLASH & "BlackBox"
-- .  .  [2] 81699302
-- .  .  [3] "77,91 MB"
-- .  .  [4] 4
-- .  .  [5] 2012
-- .  [4]
-- .  .  [1] "Z:" & SLASH & "Dying_Gasp"
-- .  .  [2] 7757074
-- .  .  [3] "7,40 MB"
-- .  .  [4] 66
-- .  .  [5] 2015
-- .  [5]
-- .  .  [1] "Z:" & SLASH & "Temp"
-- .  .  [2] 812629032
-- .  .  [3] "774,98 MB"
-- .  .  [4] 641
-- .  .  [5] 2016
analyze_object(read_csv("test.csv", 0), "read_csv")
-- read_csv =
-- .  [1]
-- .  .  [1] "Z:\"
-- .  .  [2] 56144659864
-- .  .  [3] "52,29 GB"
-- .  .  [4] 23855
-- .  .  [5] 2016
-- .  [2]
-- .  .  [1] "Z:" & SLASH & "BlackBox"
-- .  .  [2] 81699302
-- .  .  [3] "77,91 MB"
-- .  .  [4] 4
-- .  .  [5] 2012
-- .  [3]
-- .  .  [1] "Z:" & SLASH & "Dying_Gasp"
-- .  .  [2] 7757074
-- .  .  [3] "7,40 MB"
-- .  .  [4] 66
-- .  .  [5] 2015
-- .  [4]
-- .  .  [1] "Z:" & SLASH & "Temp"
-- .  .  [2] 812629032
-- .  .  [3] "774,98 MB"
-- .  .  [4] 641
-- .  .  [5] 2016

puts(1, sequence_to_csv({1,"Two",3,"Four"}) & "\n")
-- 1;"Two";3;"Four"

write_csv("test2.csv", {{1,"Two",3,"Four"},{1,"Two",3,"Four"}})
analyze_object(read_csv("test2.csv", 1), "read_csv")
-- read_csv =
-- .  [1]
-- .  .  [1] 1
-- .  .  [2] "Two"
-- .  .  [3] 3
-- .  .  [4] "Four"

append_csv("test2.csv", {{1,"Two",3,"Four"},{1,"Two",3,"Four"}})
analyze_object(read_csv("test2.csv", 1), "read_csv")
-- read_csv =
-- .  [1]
-- .  .  [1] 1
-- .  .  [2] "Two"
-- .  .  [3] 3
-- .  .  [4] "Four"
-- .  [2]
-- .  .  [1] 1
-- .  .  [2] "Two"
-- .  .  [3] 3
-- .  .  [4] "Four"
-- .  [3]
-- .  .  [1] 1
-- .  .  [2] "Two"
-- .  .  [3] 3
-- .  .  [4] "Four"

analyze_object(read_ini_file("test.ini"), "read_ini")
-- read_ini =
-- .  [1]
-- .  .  [1] "Telnet"
-- .  .  [2]
-- .  .  .  [1] "host=127.0.0.1"
-- .  .  .  [2] "port=23"
-- .  [2]
-- .  .  [1] "SSH"
-- .  .  [2]
-- .  .  .  [1] "host=127.0.0.1"
-- .  .  .  [2] "port=22"
-- .  [3]
-- .  .  [1] "FTP"
-- .  .  [2]
-- .  .  .  [1] "host=127.0.0.1"
-- .  .  .  [2] "port=21"

write_ini_file("test2.ini", {{"Section",{"name=value"}}})
-- [Section]
-- name=value

sequence params
params = {"first=1","second=2","third=three"}

? find_param_name(params, "third")
-- 3

puts(1,get_param_value(params, "second") & "\n")
-- 2

analyze_object(set_param_value(params, "third", "3"), "set_param_value")
-- set_param_value =
-- .  [1] "first=1"
-- .  [2] "second=2"
-- .  [3] "third=3"
analyze_object(set_param_value(params, "fourth", "4", 0), "set_param_value")
-- set_param_value =
-- .  [1] "first=1"
-- .  [2] "second=2"
-- .  [3] "third=three"
analyze_object(set_param_value(params, "fourth", "4"), "set_param_value")
-- set_param_value =
-- .  [1] "first=1"
-- .  [2] "second=2"
-- .  [3] "third=three"
-- .  [4] "fourth=4"

sequence ini

ini = read_ini_file("test.ini")
analyze_object(ini, "ini")
-- ini =
-- .  [1]
-- .  .  [1] "Telnet"
-- .  .  [2]
-- .  .  .  [1] "host=127.0.0.1"
-- .  .  .  [2] "port=23"
-- .  [2]
-- .  .  [1] "SSH"
-- .  .  [2]
-- .  .  .  [1] "host=127.0.0.1"
-- .  .  .  [2] "port=22"
-- .  [3]
-- .  .  [1] "FTP"
-- .  .  [2]
-- .  .  .  [1] "host=127.0.0.1"
-- .  .  .  [2] "port=21"

analyze_object(get_ini_section(ini, "SSH"), "get_ini_section")
-- get_ini_section =
-- .  [1] "host=127.0.0.1"
-- .  [2] "port=22"

puts(1, search_ini(ini, "FTP", "port") & "\n")
-- 21

puts(1, read_ini("test.ini", "Telnet", "port", -1) & "\n")
-- 23

write_ini("test.ini", "Telnet", "port", "223")
-- [Telnet]
-- host=127.0.0.1
-- port=223

write_ini("test.ini", "HTTP", "host", "127.0.0.1")
-- [HTTP]
-- host=127.0.0.1

write_ini("test.ini", "HTTP", "port", "80")
-- [HTTP]
-- host=127.0.0.1
-- port=80

close(f_debug)

integer ok

maybe_any_key()

