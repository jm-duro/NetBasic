include lib/_common_.e
include lib/_version_.e  -- to test arch and address length
include lib/_debug_.e
include std/console.e
include std/filesys.e

printf(1, "arch = %s\n", {arch})
-- * "x86" or "AMD64" on Windows
-- * "i686" or "x86_64" on Linux
-- * "unknown" on others OSes

printf(1, "address_length = %d\n", {address_length})
-- * 4 on 32-bit OSes
-- * 8 on 64-bit OSes

printf(1, "InitialDir = %s\n", {InitialDir})
--<desc>directory where the program is located. Defaults to ".".</desc>

printf(1, "SLASH = %s\n", {SLASH})
-- defaults to '\\' on Windows and '/' on Linux

f_debug = 0
log_puts("Nothing should appear\n")
log_printf("%s", {"Nothing should appear\n"})
error_message("Nothing should appear in the console\n", 0)

f_debug = 1
log_puts("This should appear\n")
log_printf("%s", {"This should appear\n"})
error_message("This should appear in the console\n", 0)

constant options = {
  {"first", "One"},
  {"second", 2}
}

analyze_object(get_option("first", options, 0), "get_option(\"first\", options, 0)")
analyze_object(get_option("first", {}, 0), "get_option(\"first\", {}, 0)")
analyze_object(get_option("second", options, ""), "get_option(\"first\", options, \"\")")
analyze_object(get_option("second", {}, ""), "get_option(\"first\", {}, \"\")")

integer ok

maybe_any_key()

