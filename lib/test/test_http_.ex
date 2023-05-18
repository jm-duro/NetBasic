-- _http_.e

include lib/_debug_.e
include lib/_http_.e
include std/console.e

sequence s, s2, request

f_debug = open("debug.log", "w")

s = ascii_to_html("<tag string=\"élégant\" />")
puts(f_debug, s & "\n")
-- &lt;tag&nbsp;string=&quot;&eacute;l&eacute;gant&quot;&nbsp;/&gt;

s2 = html_to_ascii(s)
puts(f_debug, s2 & "\n")
-- <tag string="élégant" />

s2 = html_to_utf8(s)
puts(f_debug, s2 & "\n")
-- <tag string="Ã©lÃ©gant" /> (ascii)
-- <tag string="élégant" /> (utf-8)

s = utf8_to_html(s2)
puts(f_debug, s & "\n")
-- &lt;tag&nbsp;string=&quot;&eacute;l&eacute;gant&quot;&nbsp;/&gt;

request = "https://www.google.fr/search?q=élégant"

s = encode_url(request)
puts(f_debug, s & "\n")
-- https%3A%2F%2Fwww%2Egoogle%2Efr%2Fsearch%3Fq%3D%E9l%E9gant

s2 = decode_url(s)
puts(f_debug, s2 & "\n")
-- https://www.google.fr/search?q=élégant

s = encode_url(request, 1)
puts(f_debug, s & "\n")
-- https%3A%2F%2Fwww%2Egoogle%2Efr%2Fsearch%3Fq%3D%C3%A9l%C3%A9gant

s2 = decode_url(s, 1)
puts(f_debug, s2 & "\n")
-- https://www.google.fr/search?q=Ã©lÃ©gant (ascii)
-- https://www.google.fr/search?q=élégant (utf-8)

close(f_debug)

integer ok

maybe_any_key()

