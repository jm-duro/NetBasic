include lib/_debug_.e
include lib/_stack_.e
include std/console.e

integer tags

tags = stack_new("tags")

? stack_check(tags)
-- 1
? stack_size(tags)
-- 0

? stack_check(99)
-- 0

void = stack_push(tags, "One")
void = stack_push(tags, "Two")
void = stack_push(tags, "Three")
analyze_object(stack_dump(tags), "tags")
-- "Three", "Two", "One"

stack_clear(tags)
? stack_size(tags)
-- 0

void = stack_push(tags, "One")
void = stack_push(tags, "Two")
void = stack_push(tags, "Three")
puts(1, stack_path(tags) & "\n")
-- /Three/Two/One
? stack_size(tags)
--3

puts(1, stack_at(tags, 2, 0) & "\n")
-- Two

puts(1, stack_last(tags, 0) & "\n")
-- Three

puts(1, stack_pop(tags, 0) & "\n")
-- Three
puts(1, stack_last(tags, 0) & "\n")
-- Two
puts(1, stack_path(tags) & "\n")
-- /Two/One
? stack_size(tags)
-- 2

? stack_find("tags")
-- 1

stack_remove("tags")

? stack_find("tags")
-- 0


integer ok

maybe_any_key()


