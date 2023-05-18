--Written by Ryan Johnson
--Date: 2008-05-13
--http://fluidae.com/
--
--You make use this code freely.
--Currently runs only on linux and windows.
--
--Euphoria 3.0.0 or higher required for the idletask() procedure.
--If you have an older version, you can still use nanosleep() if you comment out idletask()

include std/machine.e
include std/text.e
include std/dll.e
include std/os.e

atom syslib, func_nanosleep

ifdef WINDOWS then
  syslib = open_dll("Kernel32.dll")
  func_nanosleep = define_c_proc(syslib, "Sleep", {C_UINT}) --NOTE: resolution is only to 1 millisecond on Windows
elsifdef LINUX then
  syslib = open_dll("")
  func_nanosleep = define_c_func(syslib, "nanosleep", {C_POINTER, C_POINTER}, C_INT)
end ifdef


public procedure nanosleep(atom s)
--<procedure>
--<name>nanosleep</name>
--<digest>Sleeps for s seconds. 0.000000001 s = 1 nanosecond.</digest>
--<desc>
--This is compatible with the sleep() function. However, you can use non-integers as well.
--Note: It is normal for the program to sleep for slightly more than the specified time, due
--to multitasking scheduling.
--Also, on windows, the resolution seems to be only milliseconds, not nanoseconds.
--</desc>
--<param>
--<type>atom</type>
--<name>s</name>
--<desc>sleep duration in seconds</desc>
--</param>
--<example>
--  nanosleep(0.001) --sleeps for 1 millisecond
--  nanosleep(0.000000001) --this is the smallest amount of time possible (linux)
--  nanosleep(0) --sleeps for the smallest amount of time possible
--  nanosleep(1.5)
--  nanosleep(17.0003) 
--  nanosleep(0.5)
--</example>
--<see_also>pause(), sleep()</see_also>
--</procedure>
  atom void, p_s

ifdef WINDOWS then
  c_proc(func_nanosleep, {s * 1000})

elsifdef LINUX then
  p_s = allocate(8)
  poke4(p_s + 0, floor(s))
  poke4(p_s + 4, (s - floor(s)) * 1000000000)
  void = c_func(func_nanosleep, {p_s, 0})
end ifdef
end procedure

public procedure pause(atom delaytime)
--<procedure>
--<name>pause</name>
--<digest>non-blocking sleep</digest>
--<desc>causes a delay while allowing other tasks to run</desc>
--<param>
--<type>atom</type>
--<name>delaytime</name>
--<desc>delay time in milliseconds</desc>
--</param>
--<example>
-- pause(500) pauses program for half a second
--</example>
--<see_also>nanosleep(), sleep(), idletask()</see_also>
--</procedure>
  atom t
  t = time()

  while (time() - t) < (delaytime/1000) do
    nanosleep(0.01)
    -- yield to other tasks, if any is ready
    task_yield()
  end while
end procedure


public procedure idletask(atom idletime)
--<procedure>
--<name>idletask</name>
--<digest></digest>
--<desc>
--allows the new Euphoria task manager to idle the cpu when other tasks are not scheduled to run.
--without this, a Euphoria program will use 100% cpu when there is less than 1 second between
--scheduled tasks!
--</desc>
--<param>
--<type>atom</type>
--<name>idletime</name>
--<desc></desc>
--</param>
--<example>
--To use this properly, insert the following code into your program:
--
--   atom task_idle
--   task_idle = task_create(routine_id("idletask"), {0.001})
--   task_schedule(task_idle, 1)
--
--The task will be scheduled to run whenever real-time tasks are not running. It should not
--affect the performance of the application.
--If you want to, you can experiment with different values for idletime.If you try 0 seconds
--on windows, you program may still use 100% CPU.  I would recomment trying 0.001 seconds first.
--</example>
--<see_also>pause()</see_also>
--</procedure>

  while 1 do
    nanosleep(idletime)
    task_yield()
  end while
end procedure

