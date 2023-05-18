include lib/_eumem_.e
include std/console.e

atom my_spot, my_spot2

my_spot = memAlloc("")
my_spot2 = memAlloc(4)

ram_space[my_spot] = "to be or not to be"
puts(1, ram_space[my_spot] & "\n")
-- to be or not to be

ram_space[my_spot2] = 1024
? ram_space[my_spot2]
-- 1024

puts(1, ram_space[my_spot] & "\n")
-- to be or not to be
? ram_space[my_spot2]
-- 1024

memFree(my_spot2)
memFree(my_spot)
integer ok
maybe_any_key()

