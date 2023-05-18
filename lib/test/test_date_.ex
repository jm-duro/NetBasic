-- Date Calculations
include std/console.e
include lib/_date_.e

atom lunar_landing
sequence dt
integer ok

lunar_landing = getFactor(1969, 7, 20)

? lunar_landing

printf(1, "The lunar module Eagle landed on the moon on %s July 20, 1969\n",
        {WEEK[dayOfWeek(1969, 7, 20)]})
printf(1, "Le module lunaire Eagle a atterri sur la lune le %s 20 juillet 1969\n",
        {SEMAINE[dayOfWeek(1969, 7, 20)]})

dt = date()
printf(1, "This happened %d days ago\n", daysBetweenDates({1969, 7, 20}, {1900+dt[1], dt[2], dt[3]}))

ok= wait_key()

