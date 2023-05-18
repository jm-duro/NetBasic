-- expressions sur des nombres
i = 9515
print i

i1 = 8
print ( 10 - ( i1 * 2 ) ) / 2
i = ( 10 - ( i1 * 2 ) ) / 2
printf(1, "( 10 - ( %d * 2 ) ) / 2 = %d\n", {i1, i})

print i1^2
i = i1^2
printf(1, "%d^2 = %d\n", {i1, i})

print (i1+2) % 3
i = (i1+2) % 3
printf(1, "(%d+2) %% 3 = %d\n", {i1, i})

print 3.14
printf(1, "%f\n", {3.14})

print 3.14159265359
printf(1, "%f\n", {3.14159265359})

-- expressions sur des chaines
print "racine"
print "prefixe." "racine" ".suffixe"
s = "prefixe." & "racine" & ".suffixe"
print s
s &= "\n"
puts(1, s)
