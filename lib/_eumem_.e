-- OpenEuphoria's std/eumem.e

public sequence ram_space
--<variable>
--<type>sequence</type>
--<name>ram_space</name>
--<desc>
-- The (pseudo) RAM heap space. Use <b>memAlloc</b> to gain ownership to a heap
-- location and <b>memFree</b> to release it back to the system.
--</desc>
--</variable>
ram_space = {}

integer ram_free_list
ram_free_list = 0

public integer free_rid
--<variable>
--<type>integer</type>
--<name>free_rid</name>
--<desc>handle of routine memFree()</desc>
--</variable>

public function memAlloc(object mem_struct_p)
--<function>
--<name>memAlloc</name>
--<digest>Allocate a block of (pseudo) memory</digest>
--<desc>
--</desc>
--<param>
--<type>object</type>
--<name>mem_struct_p</name>
--<desc>
-- The initial structure (sequence) to occupy the allocated block.
-- If this is an integer, a sequence of zero this long is used. The default
-- is the number 1, meaning that the default initial structure is {0}
--</desc>
--</param>
--<return>
-- A <i>handle</i>, to the acquired block. Once you acquire this, you can use it
-- as you need to.
--</return>
--<example>
-- atom my_spot, my_spot2
--
-- my_spot = memAlloc("")
-- my_spot2 = memAlloc(4)
--
-- ram_space[my_spot] = "to be or not to be"
-- puts(1, ram_space[my_spot] & "\n")
-- -- to be or not to be
--
-- ram_space[my_spot2] = 1024
-- ? ram_space[my_spot2]
-- -- 1024
--
-- puts(1, ram_space[my_spot] & "\n")
-- -- to be or not to be
-- ? ram_space[my_spot2]
-- -- 1024
--
-- memFree(my_spot2)
-- memFree(my_spot)
--</example>
--<see_also>memFree</see_also>
--</function>
  integer temp_

  if atom(mem_struct_p) then
    mem_struct_p = repeat(0, mem_struct_p)
  end if
  if ram_free_list = 0 then
    ram_space = append(ram_space, mem_struct_p)
    return length(ram_space)
  end if

  temp_ = ram_free_list
  ram_free_list = ram_space[temp_]
  ram_space[temp_] = mem_struct_p

  return temp_
end function

public procedure memFree(atom mem_p)
--<procedure>
--<name>memFree</name>
--<digest>Deallocate a block of (pseudo) memory</digest>
--<desc>
-- This allows the location to be used by other parts of your application. You 
-- should no longer access this location again because it could be acquired by
-- some other process in your application.
--</desc>
--<param>
--<type>atom</type>
--<name>mem_p</name>
--<desc>The handle to a previously acquired <i>ram_space</i> location.</desc>
--</param>
--<example>
-- atom my_spot, my_spot2
--
-- my_spot = memAlloc("")
-- my_spot2 = memAlloc(4)
--
-- do some stuff ...
--
-- memFree(my_spot2)
-- memFree(my_spot)
--</example>
--<see_also>memAlloc</see_also>
--</procedure>
  if mem_p < 1 then return end if
  if mem_p > length(ram_space) then return end if

  ram_space[mem_p] = ram_free_list
  ram_free_list = floor(mem_p)
end procedure
free_rid = routine_id("memFree")


