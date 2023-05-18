include std/console.e
include lib/_version_.e

? eu_version
-- One of following constants:
-- EU_4_1_LNX_64 = 1, EU_4_1_LNX_32 = 2, EU_4_0_LNX = 3, EU_3_1_LNX = 4,
-- EU_4_1_WIN_64 = 5, EU_4_1_WIN_32 = 6, EU_4_0_WIN = 7, EU_3_1_WIN = 8
-- eu_version = 8
printf(1, "eu_version_name() = %s\n", {eu_version_name()})
-- eu_version_name() = EU_3_1_WIN
integer ok
maybe_any_key()

