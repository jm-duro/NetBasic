-- OpenEuphoria std/mathcons.e and std/math.e
-- without following functions:
-- * larger_of  (see max_index in _search_.e)
-- * smaller_of (see min_index in _search_.e)
-- * ensure_in_range (see is_in_range)
-- * ensure_in_list (see find or find_in_array in _search_.e)
-- * binary functions (see _machine_.e)
-- * Eu 3.11 built-in functions

include std/math.e

-------------------------------------------------------------------------------

public function is_in_range(atom item, atom from, atom upto)
--<function>
--<name>is_in_range</name>
--<digest>checks if item fills in a range</digest>
--<desc>
--</desc>
--<param>
--<type>atom</type>
--<name>item</name>
--<desc>item to check</desc>
--</param>
--<param>
--<type>atom</type>
--<name>from</name>
--<desc>minimal value</desc>
--</param>
--<param>
--<type>atom</type>
--<name>upto</name>
--<desc>maximal value</desc>
--</param>
--<return>
-- 1 if within range, 0 if not
--</return>
--<example>
-- i = is_in_range(3.14, 3, 4)
-- i is 1
-- i = is_in_range(3.14, 2, 3)
-- i is 0
--</example>
--<see_also></see_also>
--</function>
  if compare(item, from) < 0 then return 0 end if
  if compare(item, upto) > 0 then return 0 end if
  return 1
end function

-------------------------------------------------------------------------------

public function is_powerof2(object p)
--<function>
--<name>is_powerof2</name>
--<digest>checks if object is power of 2</digest>
--<desc>may be applied to an atom or to a sequence</desc>
--<param>
--<type>object</type>
--<name>p</name>
--<desc></desc>
--</param>
--<return>
--</return>
--<example>
--for i = 1 to 5 do
--  ? {i, powof2(i)}
--end for
-- output ...
-- {1,1}
-- {2,1}
-- {3,0}
-- {4,1}
-- {5,0}
--</example>
--<see_also>
--</see_also>
--</function>
  return powof2(p)
end function

