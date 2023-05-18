-- _search_.e
include std/os.e
include std/console.e
include lib/_search_.e
include lib/_debug_.e

sequence s
integer n

printf(1, "%d\n", matching_length("abracadabroc", "abracadabra"))
-- 10

printf(1, "%d\n", nb_occurences("a", "abracadabra"))
-- 5

printf(1, "max_index({3,1,5,7,2,4}) = %d\n", max_index({3,1,5,7,2,4}))
-- 4
printf(1, "min_index({3,1,5,7,2,4}) = %d\n", min_index({3,1,5,7,2,4}))
-- 2

puts(1, find_text("This is a #value# man!", "#", "#") & "\n")
-- value
print(1, find_text("This is a #value# man!", "#", "#", ,1))
puts(1, "\n")
-- {11,17,{118,97,108,117,101}}
puts(1, find_text("This is a #value# man!", "#", "#", 1) & "\n")
-- #value#
print(1, find_text("This is a #value# man!", "#", "#", 1, 1))
puts(1, "\n")
-- {11,17,{35,118,97,108,117,101,35}}

analyze_object(find_all_text("a #name# and a #value#", "#", "#"), "find_all_text")
-- find_all_text =
-- .  [1] "name"
-- .  [2] "value"
analyze_object(find_all_text("a #name# and a #value#", "#", "#", 1), "find_all_text with tags")
-- find_all_text with tags =
-- .  [1] "#name#"
-- .  [2] "#value#"

s = "a sentence containing this <-- comment -->"
n = find('<', s)
analyze_object(get_delimited_text(s, n, "-->"), "get_delimited_text")

sleep(3)

analyze_object(find_in_array("first", {{"first",1},{"second",2}}, {}), "first")
-- first =  1
analyze_object(find_in_array(2, {{"first",1},{"second",2}}, {{"search_field",2}}), "2")
-- 2 =  2
analyze_object(find_in_array("first", {{"first",1},{"second",2}}, {{"target_field",2}}), "first + target_field")
-- first + target_field =  {1}
analyze_object(find_in_array("first", {{"first",1},{"first",10},{"second",2}}, {{"start_line",2}}), "first + start_line")
-- first + start_line =  2
analyze_object(find_in_array("first", {{"first",1},{"first",10},{"second",2}}, {{"all_occurences",1}}), "first + all_occurences")
-- first + all_occurences =  {1,2}

analyze_object(find_common_fields({{"first",1},{"first",10},{"second",2}}, {1,2}, {"first",10}), "find_common_fields")
-- find_common_fields =  {2}
analyze_object(find_common_fields({{"first",1},{"first",10},{"second",2}}, {1,2}, {"first",10}, 3), "find_common_fields + start")
-- find_common_fields + start =  ""

analyze_object(find_all_nested(13, {13, {12, {13, "b"}}}), "find_all_nested")
-- find_all_nested =  {{1}, {2,2,1}}

analyze_object(match_nested("13", {"a", {"12", {"13", "b"}}}), "match_nested")
-- match_nested =  {2,2,1}

analyze_object(match_all_nested("13", {"13", {"12", {"130", "b"}}}), "match_all_nested")
-- match_all_nested = {{1}, {2,2,1}}

integer ok

maybe_any_key()

