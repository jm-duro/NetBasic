gosub sub
for i = 1 to 10 do
  print
  if i == 2 then
    print i^4
  elsif i == 4 then
    print i%2
  elsif i >= 6 then
    print i*2
  else
    print i
  end if
end for
while i > 1 do
  print i
  i -= 1
  i = i - 1
end while
print "end"
end
label sub
print "subroutine"
print "subroutine" & " " & "sub"
print "sub " * 3
return
