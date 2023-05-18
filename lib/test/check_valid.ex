include std/console.e

function check_valid(integer n, sequence s)
  integer lg
  lg = length(s)
  
  for i = 1 to lg by 2 do
    if i = lg then return 0 end if
    if (n >= s[i]) and (n <= s[i+1]) then
      return n
    end if
  end for
  return 0
end function

? check_valid(4, {1, 5, 8, 12, 14})

? check_valid(12, {1, 5, 8, 12, 14})

? check_valid(13, {1, 5, 8, 12, 14})

? check_valid(15, {1, 5, 8, 12, 14})

integer ok

maybe_any_key()

