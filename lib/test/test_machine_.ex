-- Machine Level Access
include std/machine.e
include lib/_machine_.e
include lib/_conv_.e
include lib/_debug_.e
include std/console.e

atom addr, addr2, addr3

addr = allocate(8)

puts(1, "peek8u(), peek8s()\n")
poke8(addr, -1)
? peek8u(addr) --> 1.844674407e+019
? peek8s(addr) --> -1

puts(1, "peek_float()\n")
poke_float(addr, 3.1416)
? peek_float(addr) --> 3.141599894

puts(1, "peek_double()\n")
poke_double(addr, 216656332.2)
? peek_double(addr) --> 216656332.2

puts(1, "peek_pointer()\n")
addr2 = allocate_string("where?")
? addr2
poke_pointer(addr, addr2)
? peek_pointer(addr) --> same as addr2

puts(1, "peek_plist()\n")
addr2 = allocate(4)
? addr2
-- 4758384
addr3 = allocate(4)
? addr3
-- 4832984
addr = allocate_plist({addr2, addr3})
? peek_plist(addr)
-- {4758384,4832984}
poke_plist(addr, {addr3, addr2})
? peek_plist(addr)
-- {4832984,4758384}
free_plist(addr)
? peek_plist(addr)
-- {}
free(addr)

puts(1, "peek_string_list()\n")
addr = allocate_string_list({"my","taylor","is","rich"})
analyze_object(peek_string_list(addr), "peek_string_list")
-- peek_string_list =
-- .  [1] "my"
-- .  [2] "taylor"
-- .  [3] "is"
-- .  [4] "rich"
analyze_object(peek_string_list(addr, 2), "peek_string_list")
-- peek_string_list =
-- .  [1] "my"
-- .  [2] "taylor"
free_string_list(addr)
analyze_object(peek_string_list(addr), "peek_string_list")
-- peek_string_list = ""

puts(1, "byte_to_word()\n")
? byte_to_word(#AA, #80)  --> 32938 (#80AA)

puts(1, "high_byte()\n")
? high_byte(#80AA)  --> 128 (#80)

puts(1, "low_byte()\n")
? low_byte(#80AA)  --> 170 (#AA)

puts(1, "word_to_dword()\n")
? word_to_dword(#21FA, #8123)  --> 2166563322 (#812321FA)

puts(1, "high_word()\n")
? high_word(#812321FA)  --> 33059 (#8123)

puts(1, "low_word()\n")
? low_word(#812321FA)  --> 8698 (#21FA)

integer ok
maybe_any_key()

