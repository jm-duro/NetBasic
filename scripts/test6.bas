gosub sub
for i = 1 to 10 do
  puts(1, "\n")
  if i == 2 then
    res = i^4
    printf(1, "%d^4 = %d\n", {i, res})
  elsif i == 4 then
    res = i%2
    printf(1, "%d%%2 = %d\n", {i, res})
  elsif i >= 6 then
    res = i*2
    printf(1, "%d*2 = %d\n", {i, res})
  else
    printf(1, "%d\n", {i})
  end if
end for
while i > 1 do
  printf(1, "%d\n", {i})
  i -= 1
  i = i - 1
end while
puts(1, "end\n")
end
label sub
  puts(1, "subroutine\n")
  s = "subroutine" & " " & "sub\n"
  puts(1, s)
  s = ("sub " * 3) & "\n"
  puts(1, s)
return
