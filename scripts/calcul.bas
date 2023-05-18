i = 20+10
printf(1, "addition: 20 + 10 = %d\n", i)

i = 20 - 10
printf(1, "soustraction: 20 - 10 = %d\n", i)

i = 20 * 10
printf(1, "multiplication: 20 * 10 = %d\n", i)

s = "abc" * 3
printf(1, "multiplication: \"abc\" * 3 = %s\n", {s})

i = 25 / 10
printf(1, "division: 25 / 10 = %.1f\n", i)

i = 2 ^ 3
printf(1, "elevation a la puissance: 2 ^ 3 = %d\n", i)

i = 25 % 10
printf(1, "restant d'une division entiere: 25 %% 10 = %d\n", i)

i = 255 & 7
printf(1, "ET binaire (AND): 255 & 7 = %d\n", i)

s = "abc" & "def"
printf(1, "Concatenation: \"abc\" & \"def\" = %s\n", {s})

i = 8 | 2
printf(1, "OU binaire (OR):  8 | 2 = %d\n", i)

i = ~ 8
printf(1, "NON binaire (NOT):  ~ 8 = %d\n", i)

i = 8 # 2
printf(1, "OU exclusif binaire (XOR):  8 # 2 = %d\n", i)

i = 10
printf(1, "i = 10 = %d\n", i)

i = (i == 10)
printf(1, "egalite: (i == 10) = %d\n", i)

i = (i != 10)
printf(1, "difference: (i != 10) = %d\n", i)

i = (i < 10)
printf(1, "inferieur: (i < 10) = %d\n", i)

i = (i > 10)
printf(1, "superieur: (i > 10) = %d\n", i)

i = (i <= 10)
printf(1, "inferieur ou egal: (i <= 10) = %d\n", i)

i = (i >= 10)
printf(1, "superieur ou egal: (i >= 10) = %d\n", i)

i = (i > 10) && (i < 20)
printf(1, "ET logique: (i > 10) && (i < 20) = %d\n", i)

i = (i < 10) || (i > 20)
printf(1, "OU logique: (i < 10) || (i > 20) = %d\n", i)

i = !(i < 10)
printf(1, "NON logique: !(i < 10) = %d\n", i)

i = 25 div 10
printf(1, "division entiere: 25 div 10 = %d\n", i)

i = 25 mod 10
printf(1, "(modulus) restant d'une division entiere: 25 mod 10 = %d\n", i)

i = (i > 10) and (i < 20)
printf(1, "ET logique: (i > 10) and (i < 20) = %d\n", i)

i = (i < 10) or (i > 20)
printf(1, "OU logique: (i < 10) or (i > 20) = %d\n", i)

i = not (i < 10)
printf(1, "NON logique:  not (i < 10) = %d\n", i)

i = not 1
printf(1, "NON logique:  not 1 = %d\n", i)

i = (1 xor 1)
printf(1, "OU exclusif logique: 1 xor 1 = %d\n", i)

i = (0 xor 1)
printf(1, "OU exclusif logique: 0 xor 1 = %d\n", i)
