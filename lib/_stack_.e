include std/convert.e
include _debug_.e
include _search_.e
include _sequence_.e

constant
--  STACK_NAME = 1,  -- unused as it is a default value in find_in_array()
  STACK_BUFFER = 2

sequence LiFos
LiFos = {}

integer rtn_ident_lifo

-------------------------------------------------------------------------------

function identify_stack(sequence path, integer level, integer n)
  if level = 1 then
    if    n =  1 then return "STACK_NAME"
    elsif n =  2 then return "STACK_BUFFER"
    end if
  end if
  return sprintf("%d",n)
end function
rtn_ident_lifo = routine_id("identify_stack")

------------------------------------------------------------------------------

public function stack_check(integer stack_id)
--<function>
--<name>stack_check</name>
--<digest>check if a stack id is valid</digest>
--<desc></desc>
--<param>
--<type>integer</type>
--<name>stack_id</name>
--<desc>stack id to check</desc>
--</param>
--<return>
-- integer: 1 if valid or 0 if not
--</return>
--<example>
-- if not stack_check(stack_id) then return 0 end if
--</example>
--<see_also></see_also>
--</function>
  integer lg

  lg = length(LiFos)
  if lg = 0 then
    log_puts("no LiFo stack_id available")
    return 0
  end if
  if (stack_id < 1) or (stack_id > lg) then
    log_printf("no stack_id %d available", stack_id)
    return 0
  end if
  return 1
end function

-----------------------------------------------------------------------------

public function stack_push(integer stack_id, object o)
--<function>
--<name>stack_push</name>
--<digest>pushes an object on the LiFo stack</digest>
--<desc></desc>
--<param>
--<type>integer</type>
--<name>stack_id</name>
--<desc>stack id to push on</desc>
--</param>
--<param>
--<type>object</type>
--<name>o</name>
--<desc>object to push on the stack</desc>
--</param>
--<return>
-- integer: 1 if successful, 0 if not
--</return>
--<example>
-- void = stack_push(10, "One")
-- pushes string "One" on stack #10
--</example>
--<see_also>stack_pop(), stack_at(), stack_last()</see_also>
--</function>
  sequence buffer

  if not stack_check(stack_id) then return 0 end if
  buffer = LiFos[stack_id][STACK_BUFFER]
  LiFos[stack_id][STACK_BUFFER] = prepend(buffer, o)
  return 1
end function

------------------------------------------------------------------------------

public function stack_last(integer stack_id, object notFound)
--<function>
--<name>stack_last</name>
--<digest>gets last element of the stack (most recent one)</digest>
--<desc>
-- stack_last does not remove the last item of the stack as stack_pop does
--</desc>
--<param>
--<type>integer</type>
--<name>stack_id</name>
--<desc>stack id to check</desc>
--</param>
--<param>
--<type>object</type>
--<name>notFound</name>
--<desc>object to return if check fails</desc>
--</param>
--<return>
-- last item if successful or object notFound if not
--</return>
--<example>
-- x = stack_last(stack_id, notFound)
-- returns last object if stack is not empty and notFound if not
--</example>
--<see_also>stack_push(), stack_pop(), stack_at()</see_also>
--</function>
  sequence buffer

  buffer = LiFos[stack_id][STACK_BUFFER]
  if length(buffer) then
    return buffer[1]
  else
    return notFound
  end if
end function

-----------------------------------------------------------------------------

procedure remove_last(integer stack_id)
  sequence buffer

  buffer = LiFos[stack_id][STACK_BUFFER]
  if length(buffer) > 1 then
    buffer = buffer[2..$]
  else
    buffer = {}
  end if
  LiFos[stack_id][STACK_BUFFER] = buffer
end procedure

-----------------------------------------------------------------------------

public function stack_pop(integer stack_id, object notFound)
--<function>
--<name>stack_pop</name>
--<digest>gets last element of the stack (most recent one)</digest>
--<desc>
-- stack_pop removes the last item of the stack whereas stack_last does not
--</desc>
--<param>
--<type>integer</type>
--<name>stack_id</name>
--<desc>stack id to pop from</desc>
--</param>
--<param>
--<type>object</type>
--<name>notFound</name>
--<desc>object to return if pop fails</desc>
--</param>
--<return>
-- last item if successful or object notFound if not
--</return>
--<example>
-- x = stack_pop(stack_id, notFound)
-- returns most recent object if stack is not empty and notFound if not
--</example>
--<see_also>stack_push(), stack_last(), stack_at()</see_also>
--</function>
  object x

  if not stack_check(stack_id) then return notFound end if
  x = stack_last(stack_id, notFound)
  remove_last(stack_id)
  return x
end function

------------------------------------------------------------------------------

public function stack_at(integer stack_id, integer i, object notFound)
--<function>
--<name>stack_at</name>
--<digest>checks item at position <b>i</b> in stack</digest>
--<desc>
-- stack_at does change the content of the stack
--</desc>
--<param>
--<type>integer</type>
--<name>stack_id</name>
--<desc>stack id to check</desc>
--</param>
--<param>
--<type>integer</type>
--<name>i</name>
--<desc>position of item to check in the stack</desc>
--</param>
--<param>
--<type>object</type>
--<name>notFound</name>
--<desc>object to return if check fails</desc>
--</param>
--<return>
-- item at given position if successful or object notFound if not
--</return>
--<example>
-- x = stack_at(stack_id, 3, notFound)
-- returns the third most recent object in stack if stack_size is enough
-- and notFound if not
--</example>
--<see_also>stack_push(), stack_pop(), stack_last()</see_also>
--</function>
  sequence buffer

--  log_printf("stack_at(%d, %d)", {stack_id, i})
  if not stack_check(stack_id) then return notFound end if
  buffer = LiFos[stack_id][STACK_BUFFER]
  if length(buffer) < i then
    return notFound
  else
    return buffer[i]
  end if
end function

-----------------------------------------------------------------------------

public function stack_dump(integer stack_id)
--<function>
--<name>stack_dump</name>
--<digest>returns the stack content as a sequence</digest>
--<desc></desc>
--<param>
--<type>integer</type>
--<name>stack_id</name>
--<desc>stack id to compute the path</desc>
--</param>
--<return>
-- sequence
--</return>
--<example>
-- void = stack_push(10, "One")
-- void = stack_push(10, "Two")
-- void = stack_push(10, "Three")
-- puts(1, stack_dump(10)) shows
-- .  [1] "Three"
-- .  [2] "Two"
-- .  [3] "One"
--</example>
--<see_also></see_also>
--</function>
  return LiFos[stack_id][STACK_BUFFER]
end function

-----------------------------------------------------------------------------

public function stack_path(integer stack_id)
--<function>
--<name>stack_path</name>
--<digest>returns the stack content as a string</digest>
--<desc>
-- result is formatted as a POSIX file path
--</desc>
--<param>
--<type>integer</type>
--<name>stack_id</name>
--<desc>stack id to compute the path</desc>
--</param>
--<return>
-- sequence: a string formatted as a POSIX file path
--</return>
--<example>
-- void = stack_push(10, "One")
-- void = stack_push(10, "Two")
-- void = stack_push(10, "Three")
-- puts(1, stack_path(10)) shows "Three/Two/One"
--</example>
--<see_also></see_also>
--</function>
  sequence s
  sequence buffer

--  log_printf("stack_path(%d)", {stack_id})
  buffer = LiFos[stack_id][STACK_BUFFER]
  s = ""
  for i = 1 to length(buffer) do
    s &= "/" & to_string(buffer[i])
  end for
  return s
end function

--------------------------------------------------------------------------------

public function stack_find(sequence stack_name)
--<function>
--<name>stack_find</name>
--<digest>returns stack id corresponding to given stack name</digest>
--<desc></desc>
--<param>
--<type>sequence</type>
--<name>stack_name</name>
--<desc>stack name to find</desc>
--</param>
--<return>
-- integer: corresponding stack id
--</return>
--<example></example>
--<see_also></see_also>
--</function>
  return find_in_array(stack_name, LiFos, {})
end function

--------------------------------------------------------------------------------

public function stack_size(integer stack_id)
--<function>
--<name>stack_size</name>
--<digest>return stack size</digest>
--<desc></desc>
--<param>
--<type>integer</type>
--<name>stack_id</name>
--<desc>stack id to check</desc>
--</param>
--<return>
-- integer: stack size
--</return>
--<example></example>
--<see_also></see_also>
--</function>
  return length(LiFos[stack_id][STACK_BUFFER])
end function

--------------------------------------------------------------------------------

public procedure stack_clear(integer stack_id)
--<procedure>
--<name>stack_clear</name>
--<digest>empties a stack</digest>
--<desc></desc>
--<param>
--<type>integer</type>
--<name>stack_id</name>
--<desc>stack id to clear</desc>
--</param>
--<example></example>
--<see_also></see_also>
--</procedure>
--  log_printf("stack_clear(%d)", {stack_id})
  if length(LiFos)=0 then
    log_puts("stack_clear: no stack_id available")
    return
  end if
  LiFos[stack_id][STACK_BUFFER] = {}
end procedure

--------------------------------------------------------------------------------

public function stack_new(sequence stack_name)
--<function>
--<name>stack_new</name>
--<digest>creates a new LiFo stack</digest>
--<desc></desc>
--<param>
--<type>sequence</type>
--<name>stack_name</name>
--<desc>stack name to associate with new stack id</desc>
--</param>
--<return>
-- integer: the new stack id
--</return>
--<example>
-- id = stack_new("tags")
--</example>
--<see_also>stack_remove()</see_also>
--</function>
  integer stack_id

--  log_printf("stack_new(%s)", {stack_name})
  stack_id = stack_find(stack_name)
  if stack_id then
    stack_clear(stack_id)
  else
    LiFos = append(LiFos, {stack_name, {}})
    stack_id = length(LiFos)
  end if
  return stack_id
end function

--------------------------------------------------------------------------------

public procedure stack_remove(sequence stack_name)
--<procedure>
--<name>stack_remove</name>
--<digest>removes a stack by its name</digest>
--<desc></desc>
--<param>
--<type>sequence</type>
--<name>stack_name</name>
--<desc>name of the stack to remove</desc>
--</param>
--<example>
-- stack_remove("tags")
--</example>
--<see_also>stack_new()</see_also>
--</procedure>
  integer found
  
  found = stack_find(stack_name)
  LiFos = remove(LiFos, found, found)
end procedure
