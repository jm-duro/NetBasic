-- _sequence_.e

include lib/_search_.e  -- find_nested
include lib/_debug_.e
include lib/_sequence_.e
include std/console.e

puts(1, "'" & trim_spaces("\t first  second\t third \t fourth\t\tfifth\t \t ") & "'\n")
-- 'first second third fourth fifth'

puts(1, left("message", 4) & "\n")
-- mess

puts(1, right("message", 4) & "\n")
-- sage

analyze_object(split_string("my name is Bond", ' '), "split")
-- split =
-- .  [1] "my"
-- .  [2] "name"
-- .  [3] "is"
-- .  [4] "Bond"
analyze_object(split_string("my name is Bond", ' ', , 1), "split")
-- split =
-- .  [1] "my"
-- .  [2] " "
-- .  [3] "name"
-- .  [4] " "
-- .  [5] "is"
-- .  [6] " "
-- .  [7] "Bond"
analyze_object(split_string("my name is: Bond", ": "), "split")
-- split =
-- .  [1] "my"
-- .  [2] "name"
-- .  [3] "is"
-- .  [4] "Bond"
analyze_object(split_string("my name is: Bond", ": ", , 1), "split")
-- split =
-- .  [1] "my"
-- .  [2] "name"
-- .  [3] "is"
-- .  [4] ""
-- .  [5] "Bond"
analyze_object(split_string("my name is: Bond", ": ", 1), "split")
-- split =
-- .  [1] "my name is"
-- .  [2] "Bond"

analyze_object(split_n_convert("my,code,is,7", ","), "split_n_convert")
-- split_n_convert =
-- .  [1] "my"
-- .  [2] "code"
-- .  [3] "is"
-- .  [4] 7

puts(1, convert_n_join({"my","code","is", 7}, ",") & "\n")
-- "my","code","is",7

puts(1, replace_all("atoms, integers and objects", "s", "") & "\n")
-- atom, integer and object

puts(1, append_if_new("abcdefghij", 'a') & "\n")
-- abcdefghij
puts(1, append_if_new("abcdefghij", 'k') & "\n")
-- abcdefghijk

puts(1, extract_column({"Start","Tank","Own","Patent"}, 1) & "\n")
-- STOP

sequence result
result = parse_sequence("http://www.google.com:80/search?q=euphoria", "http://<url>:<port>/search?q=<query>")
puts(1, object_dump(result) & "\n")
-- {{"<url>", "www.google.com"}, {"<port>", "80"}, {"<query>", "euphoria"}}

integer ok

maybe_any_key()

