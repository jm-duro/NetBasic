i = 10
s = "racine"

print "affectation"
print PI
printf(1, "i = %d\n", i)
printf(1, "pi = %f\n", PI)
printf(1, "s = %s\n", {s})

i -= 2
printf(1, "autosoustraction: i -= 2, i = %d\n", i)

i += 2
printf(1, "autoaddition: i += 2, i = %d\n", i)

i *= 2
printf(1, "automultiplication: i *= 2, i = %d\n", i)

i /= 2
printf(1, "autodivision: i /= 2, i = %d\n", i)

s &= ".suffixe"
printf(1, "autoconcatenation: s &= \".suffixe\", s = %s\n", {s})
