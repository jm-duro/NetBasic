include std/search.e
include std/dll.e
include std/machine.e
include std/filesys.e
include std/convert.e
ifdef WINDOWS then
include std/win32/msgbox.e
end ifdef
include std/console.e
include std/text.e
include std/os.e
include std/types.e
include std/socket.e
include lib/_conv_.e
include lib/_machine_.e
-- include lib/_libssh2_constants_.e
include lib/_ssh2_.e

------------------------------------------------------------------------------

procedure shutdown(integer cnx)
  ssh_close(cnx)
  puts(1, "all done!\n")
  libssh2_exit()
  close(f_debug)
  maybe_any_key()
end procedure

------------------------------------------------------------------------------

constant COMMANDS = {
  "ls -l",
  "df -h",
  "exit"
}

sequence username, password, ip, s
integer rc, lg
atom session, buf

f_debug = open(InitialDir & SLASH & "debug.log", "w")
with_debug = 1

username="admin"
password="admin"
ip="192.168.1.251"

rc = libssh2_init(0)
if rc then
  error_message(sprintf("libssh2 initialization failed (%d)\n", rc), 1)
end if

-- Ultra basic "connect to port 22 on localhost".  Your code is
-- responsible for creating the socket establishing the connection

sock = sock_connect(ip, 22)
if atom(sock) then
  libssh2_exit()
  close(f_debug)
end if

-- Create a session instance and start it up. This will trade welcome
-- banners, exchange keys, and setup crypto, compression, and MAC layers

session = libssh2_session_init()
if libssh2_session_startup(session, sock[SOCKET_SOCKET]) then
  error_message("Failure establishing SSH session\n", 1)
end if

-- libssh2_session_set_blocking(session, 0)

if (libssh2_userauth_password(session, username, password, 0)) then
  puts(1, "\tAuthentication by password failed!\n")
  shutdown(session)
--else
--  puts(1, "\tAuthentication by password succeeded.\n")
end if

for i = 1 to length(COMMANDS) do
  puts(f_debug, COMMANDS[i] & "\n")
  puts(1, COMMANDS[i] & "\n")
  exec_cmd(session, COMMANDS[i])
end for

shutdown(session)
