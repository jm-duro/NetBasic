include std/console.e
include lib/_idle_.e

integer count, ok

atom t
t = time()

? t
while (time() - t) < 3 do
  nanosleep(0.01)
  -- yield to other tasks, if any is ready
  task_yield()
end while

? (time() - t)

pause(500)

? (time() - t)

atom task_idle

task_idle = task_create(routine_id("idletask"), {0.001})
task_schedule(task_idle, 1)

count = 0

while 1 do
  puts(1, ".")
  count += 1
  pause(500)
  if count = 10 then exit end if
end while

maybe_any_key()

