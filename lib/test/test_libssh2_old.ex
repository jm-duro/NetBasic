--
-- $Id: ssh2.c,v 1.19 2009/04/28 10:35:30 bagder Exp $
--
-- Sample showing how to do SSH2 connect.
--
-- The sample code has default values for host name, user name, password
-- and path to copy, but you can specify them on the command line like:
--
-- "ssh2 host user password [-p|-i|-k]"
--

include std/search.e
include std/dll.e
include std/machine.e
include std/filesys.e
include std/convert.e
include std/win32/msgbox.e
include std/console.e
include std/text.e
include std/os.e
include lib/Sockets.ew
include lib/WSErrors.ew
include lib/_conv_.e
include lib/_machine_.e
include lib/_libssh2_constants_.e
include lib/_libssh2_.e

constant LETTERS = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ"

atom session, channel, sock

------------------------------------------------------------------------------

function nextLetter(integer from, sequence o)
  for i = from to length(o) do
    if find(o[i], LETTERS) then return i end if
  end for
  return 0
end function

------------------------------------------------------------------------------

procedure displayData(sequence data)
  sequence s
  integer p, e, n, lg, line, column

  s = {}
  p = 0
  e = 0
  n = 0
--  data = utf8_to_ascii(data)
  lg = length(data)
  while p < lg do
    p += 1
    if (p+2 <= lg) and equal(data[p..p+1], {27,91}) then  -- <ESC>[
      e = nextLetter(p+2, data)
      if e then
        if data[e] = 'A' then  -- <ESC>[{COUNT}A              Cursor Up
          n = to_number(data[p+2..e-1])
          printf(1, "[UP %d]", n)
        elsif data[e] = 'B' then  -- <ESC>[{COUNT}B              Cursor Down
          n = to_number(data[p+2..e-1])
          printf(1, "[DOWN %d]", n)
        elsif data[e] = 'C' then  -- <ESC>[{COUNT}C              Cursor Forward
          n = to_number(data[p+2..e-1])
          printf(1, "[RIGHT %d]", n)
        elsif data[e] = 'D' then  -- <ESC>[{COUNT}D              Cursor Backward
          n = to_number(data[p+2..e-1])
          printf(1, "[LEFT %d]", n)
        elsif data[e] = 'H' then  -- <ESC>[{line};{col}H         Position
          if e = p+2 then
            puts(1, "[HOME]")
          else
            n = find_from(';', data, p+2)
            line = to_number(data[p+2..n-1])
            column = to_number(data[n+1..e-1])
            printf(1, "[POSITION %d %d]", {line,column})
          end if
        elsif data[e] = 'J' then  -- <ESC>[J         Erase to end of screen
          puts(1, "[CLRSCR]")
        elsif data[e] = 'K' then  -- <ESC>[K         Erase to end of line
          puts(1, "[CLREOL]")
        end if
        p = e
      end if
    elsif data[p] = 8 then  -- Backspace
      puts(1, "[BKSP]")
    elsif data[p] = 7 then  -- Bell
      puts(1, "[BELL]")
    elsif find(data[p], {9,10,13}) or (data[p] > 31) then
      puts(1, {data[p]})
    end if
  end while
end procedure

function kbd_callback(atom name, integer name_len,
                       atom instruction, integer instruction_len,
                       integer num_prompts, atom prompts,
                       atom responses, atom abstract)
  name = name
  name_len = name_len
  instruction = instruction
  instruction_len = instruction_len
  if num_prompts = 1 then
--    responses[0].text = strdup(password)
--    responses[0].length = strlen(password)
  end if
  prompts = prompts
  abstract = abstract
  return 0
end function -- kbd_callback

procedure handle_error()
--<procedure>
--<name>handle_error</name>
--<digest>displays details on last WinSock error</digest>
--<desc>
--</desc>
--<example>
--</example>
--<see_also>
--</see_also>
--</procedure>
  integer err
  sequence msg, title, id, short

  err   = WSAGetLastError()
  id    = WSGetErrorString(err)
  short = WSGetShortDescription(err)
  title = sprintf("Winsock Error %d", err)
  msg   = sprintf("%s: %s", {id, short})
  void  = message_box(msg, title, MB_OK)
end procedure

function sock_connect(sequence Host, integer Port)
  object Address
  atom tcpSocket

  -- Create a stream (TCP) socket
  tcpSocket = socket (AF_INET, SOCK_STREAM, 0)
  if tcpSocket != SOCKET_ERROR then
    -- Setup an IP address/port structure
    -- Use the remote address and port specified in the edit boxes
    Address = sockaddr_in (AF_INET, Host, Port)
    if sequence (Address) then
      -- Connect the new socket to the remote host
      if connect (tcpSocket, Address) != SOCKET_ERROR then
        return tcpSocket
      end if
    end if
  end if

  handle_error()
  void = closesocket (tcpSocket)
  return 0
end function

procedure skip_shell()
  if (channel) then
    void = libssh2_channel_free(channel)
    channel = NULL
  end if
end procedure

procedure shutdown()
  void = libssh2_session_disconnect(session, "Normal Shutdown")
  void = libssh2_session_free(session)
  void = closesocket(sock)
  void = WSACleanup()
  puts(1, "all done!\n")
  libssh2_exit()
  close(f_debug)
  maybe_any_key()
end procedure

function wait_socket()
  integer direction
  sequence read, write

  read = {}
  write = {}
  -- now make sure we wait in the correct direction
  direction = libssh2_session_block_directions(session)

  if and_bits(direction, LIBSSH2_SESSION_BLOCK_INBOUND) then
    read = {sock}
  end if
  if and_bits(direction, LIBSSH2_SESSION_BLOCK_OUTBOUND) then
    write = {sock}
  end if
  return select(read, {}, write, {0, 500000})
end function

sequence keyfile1, keyfile2, username, password, ip
integer rc, auth_pw, lg
atom fingerprint, kbd_cb, buf
sequence s, userauthlist

f_debug = open(InitialDir & SLASH & "debug.log", "w")
with_debug = 1

keyfile1="~/.ssh/id_rsa.pub"
keyfile2="~/.ssh/id_rsa"
username="admin"
password="admin"
ip="192.168.1.251"

if WSAStartup() = SOCKET_ERROR then -- must be called before using Winsock API
  error_message("Failed WSAStartup()", 1)
end if

kbd_cb = cdecl_callback(routine_id("kbd_callback"))

rc = libssh2_init(0)
if rc then
  error_message(sprintf("libssh2 initialization failed (%d)\n", rc), 1)
end if

-- Ultra basic "connect to port 22 on localhost".  Your code is
-- responsible for creating the socket establishing the connection

sock = sock_connect(ip, 22)
if not sock then
  void = WSACleanup()
  libssh2_exit()
  close(f_debug)
end if

-- Create a session instance and start it up. This will trade welcome
-- banners, exchange keys, and setup crypto, compression, and MAC layers

session = libssh2_session_init()
if libssh2_session_startup(session, sock) then
  error_message("Failure establishing SSH session\n", 1)
end if

-- libssh2_session_set_blocking(session, 0)

-- At this point we havn't authenticated. The first thing to do is check
-- the hostkey's fingerprint against our known hosts Your app may have it
-- hard coded, may go to a file, may present it to the user, that's your
-- call

fingerprint = allocate(SHA_DIGEST_LENGTH)
fingerprint = libssh2_hostkey_hash(session, LIBSSH2_HOSTKEY_HASH_SHA1)
s = peek({fingerprint, SHA_DIGEST_LENGTH})
-- puts(1, "Fingerprint: ")
for i = 1 to 20 do
  printf(1, "%02x ", s[i])
end for
puts(1, "\n")

-- check what authentication methods are available--
auth_pw = 0

userauthlist = libssh2_userauth_list(session, username)
printf(1, "Authentication methods: %s\n", {userauthlist})
if match("password", userauthlist) then
  auth_pw = or_bits(auth_pw, 1)
end if
if match("keyboard-interactive", userauthlist) then
  auth_pw = or_bits(auth_pw, 2)
end if
if match("publickey", userauthlist) then
  auth_pw = or_bits(auth_pw, 4)
end if

if and_bits(auth_pw, 1) then
  -- We could authenticate via password--
  if (libssh2_userauth_password(session, username, password, 0)) then
    puts(1, "\tAuthentication by password failed!\n")
    shutdown()
  else
    puts(1, "\tAuthentication by password succeeded.\n")
  end if
elsif and_bits(auth_pw, 2) then
  -- Or via keyboard-interactive--
  if (libssh2_userauth_keyboard_interactive(session, username, kbd_cb) ) then
    puts(1, "\tAuthentication by keyboard-interactive failed!\n")
    shutdown()
  else
    puts(1, "\tAuthentication by keyboard-interactive succeeded.\n")
  end if
elsif and_bits(auth_pw, 4) then
  -- Or by public key--
  if (libssh2_userauth_publickey_fromfile(session, username, keyfile1,
                                          keyfile2, password)) then
    puts(1, "\tAuthentication by public key failed!\n")
    shutdown()
  else
    puts(1, "\tAuthentication by public key succeeded.\n")
  end if
else
  puts(1, "No supported authentication methods found!\n")
  shutdown()
end if

-- Request a shell--
-- puts(1, "Request a shell\n")
channel = libssh2_channel_open_session(session)
if not (channel) then
  puts(2, "Unable to open a session\n")
  shutdown()
end if

-- Some environment variables may be set,
-- It's up to the server which ones it'll allow though

-- puts(1, "Set environment variables\n")
void = libssh2_channel_setenv(channel, "FOO", "bar")

-- Request a terminal with 'vanilla' terminal emulation
-- See /etc/termcap for more options

-- puts(1, "Request a terminal\n")
if libssh2_channel_request_pty(channel, "vanilla") then
  puts(2, "Failed requesting pty\n")
  skip_shell()
  shutdown()
end if

-- Open a SHELL on that pty--
-- puts(1, "Open a SHELL on that pty\n")
if libssh2_channel_shell(channel) then
  puts(2, "Unable to request shell on allocated pty\n")
  shutdown()
end if

-- At this point the shell can be interacted with using
-- libssh2_channel_read()
-- libssh2_channel_read_stderr()
-- libssh2_channel_write()
-- libssh2_channel_write_stderr()

  buf = allocate(#4000)
  void = libssh2_channel_write(channel, allocate_string("ls -l\r\n"), length("ls -l\r\n")+1)
  
  lg = 1
  while lg do
    lg = libssh2_channel_read(channel, buf, #4000)
    displayData(peek({buf, lg}))
    s = wait_socket()
    log_printf("  s = %s\n", {sprint(s)})
    log_printf("  lg = %d\n", {s[1]})
    lg = s[1]
  end while

sleep(2)

-- Blocking mode may be (en|dis)abled with: libssh2_channel_set_blocking()
-- If the server send EOF, libssh2_channel_eof() will return non-0
-- To send EOF to the server use: libssh2_channel_send_eof()
-- A channel can be closed with: libssh2_channel_close()
-- A channel can be freed with: libssh2_channel_free()

-- Other channel types are supported via:
-- libssh2_scp_send()
-- libssh2_scp_recv()
-- libssh2_channel_direct_tcpip()

shutdown()
