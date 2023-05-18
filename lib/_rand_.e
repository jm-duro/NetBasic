include std/dll.e
include std/machine.e
include std/os.e
include std/rand.e
include _debug_.e

constant P2_32=power(2,32)

atom timeFactor, TimeFactor, k32, pc, pq, rcp
sequence perf, times, started

--*------------------------------------------------------*
-- reference high resolution timer libraries
--*------------------------------------------------------*
ifdef not WINDOWS then
  error_message("This library will function correctly under Windows only.", 1)
end ifdef
k32=open_dll("kernel32")
if k32=-1 then
  error_message("kernel32.dll can\'t be opened.", 1)
end if
pq=define_c_func(k32,"QueryPerformanceFrequency",{C_UINT},C_UINT)
pc=define_c_proc(k32,"QueryPerformanceCounter",{C_UINT})
if (pc=-1) or (pq=-1) then
  error_message("The current Windows version does not support hi-res timers.", 1)
end if

public procedure initialize()
--<procedure>
--<name>initialize</name>
--<digest>initializes hi-res timers</digest>
--<desc></desc>
--<example>
-- initialize()
--</example>
--<see_also>
-- randomize()
--</see_also>
--</procedure>
  perf=repeat(0,400)
  times=perf
  started=perf
  for i=1 to 400 do perf[i]=allocate(16) end for
  TimeFactor = allocate(8)
  rcp=c_func(pq,{TimeFactor})-1
  if rcp=-1 then error_message("Your hardware does not support hi-res timers.", 1) end if
  timeFactor=0
  if rcp>-1 then timeFactor=peek4u(TimeFactor)+P2_32*peek4u(TimeFactor+4) end if
  free(TimeFactor)
end procedure

public procedure randomize()
--<procedure>
--<name>randomize</name>
--<digest>reset the random number generator</digest>
--<desc>
-- The seed provided to the random number generator is an atom
-- calculated from a high-resolution time factor so it is very unlikely
-- to be the same at next launch
--</desc>
--<example>
-- randomize()
--</example>
--<see_also>
-- initialize()
--</see_also>
--</procedure>
  integer n
  atom a

  c_proc(pc,{TimeFactor})
  a=P2_32*peek4u(TimeFactor+4)+peek4u(TimeFactor)
  n = floor(remainder(a, 134217728))
  set_rand(n)
end procedure
