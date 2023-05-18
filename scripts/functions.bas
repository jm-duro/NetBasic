include get
include misc

i = 10
pi = 3.1416
c = 'a'
s = "abcd"
puts(1, s)
--s = {}
--s = {10}

s = sprint("abcd") & "\n"
puts(1, s)

s = sprint(10) & "\n"
puts(1, s)

s = sprint(3.1416) & "\n"
puts(1, s)

s = sprint({"pi", 3.1416}) & "\n"
puts(1, s)
-- {{112,105},3.1416}

s = sprint({1, {"pi", 3.1416}, "as"}) & "\n"
puts(1, s)
-- {1,{{112,105},3.1416},{97,115}}

s = "bcd"
printf(1, "s = %s\n", {s})
s = append(s, 'e')
printf(1, "s = %s\n", {s})
s = prepend(s, 'a')
printf(1, "s = %s\n", {s})

puts(1, "Press a key ...")

ok = wait_key()

end
