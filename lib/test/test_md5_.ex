-- md5.e - The MD5 Message-Digest Algorithm - version 1.11
include std/io.e
include std/console.e
include lib/_md5_.e

sequence whole_file

whole_file = read_file("test_math_.ex")
? md5(whole_file)
puts(1, md5sum("test_math_.ex") & "\n")

integer ok
maybe_any_key()
