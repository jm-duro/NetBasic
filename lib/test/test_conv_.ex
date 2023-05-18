include std/console.e
include std/convert.e
include std/io.e
include lib/_conv_.e
include lib/_debug_.e

puts(1, num_to_str(10,  2, 4) & "\n") -- "1010"
puts(1, num_to_str(10,  8, 2) & "\n") -- "12"
puts(1, num_to_str(10, 10, 2) & "\n") -- "10"
puts(1, num_to_str(10, 16, 2) & "\n") -- "0A"

printf(1, "%d\n", str_to_num("1010",  2)) -- 10
printf(1, "%d\n", str_to_num("12",  8)) -- 10
printf(1, "%d\n", str_to_num("10", 10)) -- 10
printf(1, "%d\n", str_to_num("0A", 16)) -- 10

printf(1, "%d\n", to_number("10")) -- 10
printf(1, "%d\n", to_number("#0A")) -- 10
printf(1, "%d\n", to_number("0A")) -- 0

puts(1, to_string({{1}}&"message"&10&"and"&{{8,2},4}&233) & "\n")
-- {{1},109,101,115,115,97,103,101,10,97,110,100,{8,2},4,233}

puts(1, hex_string({1,2,3,4,5,6}) & "\n")
-- 010203040506

puts(1, hex_sequence({1,2,3,4,5,6}) & "\n")
-- {#1, #2, #3, #4, #5, #6}

f_debug = open("ascii.log", "w")
puts(f_debug, hex_sequence("âœ“") & "\n")
-- {#E2, #9C, #93}
printf(f_debug, "utf8_to_chr(#C398) = %04x '%s'\n", {utf8_to_chr(#C398), utf8_to_chr(#C398)})
-- Ø
printf(f_debug, "utf8_to_chr(#C2A3) = %04x '%s'\n", {utf8_to_chr(#C2A3), utf8_to_chr(#C2A3)})
-- £

puts(f_debug, utf8_to_ascii({#C3, #98, #C2, #A3, #C3, #A8,#C3, #A9, #C3, #AA}) & "\n")
-- Ø£èéê
close(f_debug)

f_debug = open("utf8.log", "w")
puts(f_debug, {#EF, #BB , #BF})   --BOM UTF-8

puts(f_debug, unicode('Ø') & "\n")
-- 
puts(f_debug, unicode('£') & "\n")

puts(f_debug, unicode(#06D1) & "\n")
-- 
puts(f_debug, ascii_to_utf8("Ø£èéê"&{#06D1}) & "\n")
close(f_debug)

sequence s
s = dos_to_unix("message\r\n")
puts(1, show_printable(s) & "\n")
--puts(1, show_printable(dos_to_unix("message\r\n")) & "\n")
-- message[lf]

puts(1, show_printable(unix_to_dos("message\n")) & "\n")

integer ok
maybe_any_key()

