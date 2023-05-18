include std/filesys.e
include std/console.e
include lib/_ssh2_.e

constant COMMANDS = {
  "ls -l",
  "df -h",
  "exit"
}

sequence s
integer cnx

f_debug = open(InitialDir & SLASH & "debug.log", "w")
with_debug = 1

if not ssh_init() then abort(1) end if
cnx = ssh_connect("192.168.1.251", 22, "admin", "admin")

for i = 1 to length(COMMANDS) do
  puts(f_debug, COMMANDS[i] & "\n")
  puts(1, COMMANDS[i] & "\n")
  ssh_exec(cnx, COMMANDS[i])
  puts(f_debug, get_buffer(cnx) & "\n")
  puts(1, get_buffer(cnx) & "\n")
  clean_buffer(cnx)
end for

ssh_close(cnx)
puts(1, "all done!\n")
ssh_exit()
close(f_debug)
maybe_any_key()
