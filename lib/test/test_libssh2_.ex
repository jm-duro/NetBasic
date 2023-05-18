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
include lib/_libssh2_.e

constant SOCKET_ERROR = -1

constant NULL = 0

sockets:socket sock

-------------------------------------------------------------------------------

function errorLabel(integer err_num)
  sequence lbl

  switch err_num do
    case OK then
      lbl = "OK"
    case ERR_ACCESS then  -- -1
      lbl = "Permission has been denied"
    case ERR_ADDRINUSE then  -- -2
      lbl = "Address is already in use"
    case ERR_ADDRNOTAVAIL then  -- -3
      lbl = "The specified address is not a valid local IP address on this computer"
    case ERR_AFNOSUPPORT then  -- -4
      lbl = "Address family not supported by the protocol family"
    case ERR_AGAIN then  -- -5
      lbl = "Kernel resources to complete the request are temporarly unavailable"
    case ERR_ALREADY then  -- -6
      lbl = "Operation is already in progress"
    case ERR_CONNABORTED then  -- -7
      lbl = "Software has caused a connection to be aborted"
    case ERR_CONNREFUSED then  -- -8
      lbl = "Connection was refused"
    case ERR_CONNRESET then  -- -9
      lbl = "An incoming connection was supplied however it was terminated by the remote peer"
    case ERR_DESTADDRREQ then  -- -10
      lbl = "Destination address required"
    case ERR_FAULT then  -- -11
      lbl = "Address creation has failed internally"
    case ERR_HOSTUNREACH then  -- -12
      lbl = "No route to the host specified could be found"
    case ERR_INPROGRESS then  -- -13
      lbl = "A blocking call is inprogress"
    case ERR_INTR then  -- -14
      lbl = "A blocking call was cancelled or interrupted"
    case ERR_INVAL then  -- -15
      lbl = "An invalid sequence of command calls were made"
    case ERR_IO then  -- -16
      lbl = "An I/O error occurred while making the directory entry or allocating the inode"
    case ERR_ISCONN then  -- -17
      lbl = "Socket is already connected"
    case ERR_ISDIR then  -- -18
      lbl = "An empty pathname was specified"
    case ERR_LOOP then  -- -19
      lbl = "Too many symbolic links were encountered"
    case ERR_MFILE then  -- -20
      lbl = "The queue is not empty upon routine call"
    case ERR_MSGSIZE then  -- -21
      lbl = "Message is too long for buffer size"
    case ERR_NAMETOOLONG then  -- -22
      lbl = "Component of the path name exceeded 255 characters or the entire path exceeded 1023 characters"
    case ERR_NETDOWN then  -- -23
      lbl = "The network subsystem is down or has failed"
    case ERR_NETRESET then  -- -24
      lbl = "Network has dropped it's connection on reset"
    case ERR_NETUNREACH then  -- -25
      lbl = "Network is unreachable"
    case ERR_NFILE then  -- -26
      lbl = "Not a file"
    case ERR_NOBUFS then  -- -27
      lbl = "No buffer space is available"
    case ERR_NOENT then  -- -28
      lbl = "Named socket does not exist"
    case ERR_NOTCONN then  -- -29
      lbl = "Socket is not connected"
    case ERR_NOTDIR then  -- -30
      lbl = "Component of the path prefix is not a directory"
    case ERR_NOTINITIALISED then  -- -31
      lbl = "Socket system is not initialized"
    case ERR_NOTSOCK then  -- -32
      lbl = "The descriptor is not a socket"
    case ERR_OPNOTSUPP then  -- -33
      lbl = "Operation is not supported on this type of socket"
    case ERR_PROTONOSUPPORT then  -- -34
      lbl = "Protocol not supported"
    case ERR_PROTOTYPE then  -- -35
      lbl = "Protocol is the wrong type for the socket"
    case ERR_ROFS then  -- -36
      lbl = "The name would reside on a read-only file system"
    case ERR_SHUTDOWN then  -- -37
      lbl = "The socket has been shutdown"
    case ERR_SOCKTNOSUPPORT then  -- -38
      lbl = "Socket type is not supported"
    case ERR_TIMEDOUT then  -- -39
      lbl = "Connection has timed out"
    case ERR_WOULDBLOCK then  -- -40
      lbl = "The operation would block on a socket marked as non-blocking"
    case else
      lbl = "Unknown error!"
  end switch
  return lbl
end function

------------------------------------------------------------------------------

procedure handle_error()
  integer err
  sequence msg, title

  err   = error_code()
  title = sprintf("Error %d", err)
  msg   = errorLabel(err)
  log_puts(title & ": " & msg & "\n")
ifdef WINDOWS then
  void  = message_box(msg, title, MB_OK)
elsifdef LINUX then
  puts(2, title & ": " & msg & "\n")
end ifdef
end procedure

------------------------------------------------------------------------------

function sock_connect(sequence host, integer port)
  object Address
  sockets:socket tcpSocket

  -- Create a stream (TCP) socket
  tcpSocket = sockets:create(AF_INET, SOCK_STREAM, 0)
  if not equal(tcpSocket, SOCKET_ERROR) then
    -- Setup an IP address/port structure
    -- Use the remote address and port specified in the edit boxes
    Address = sprintf("%s:%d", {host, port})
    if sequence (Address) then
      -- Connect the new socket to the remote host
      if sockets:connect(tcpSocket, Address) != SOCKET_ERROR then
        return tcpSocket
      end if
    end if
  end if

  handle_error()
  void = sockets:shutdown(tcpSocket)
  return 0
end function

------------------------------------------------------------------------------

procedure shutdown(atom session)
  void = libssh2_session_disconnect(session, "Normal Shutdown")
  void = libssh2_session_free(session)
  void = sockets:shutdown(sock)
  -- puts(1, "all done!\n")
  libssh2_exit()
  close(f_debug)
  maybe_any_key()
end procedure

------------------------------------------------------------------------------

function remove_vt_controls(sequence data)
  sequence s
  integer p, from, lg

  log_printf("remove_vt_controls(%s)\n", {sprint(data)})
  s = {}
  p = 0
--  data = utf8_to_ascii(data)
  lg = length(data)
  while p < lg do
    p += 1
    if (p+2 <= lg) and equal(data[p..p+1], {27,91}) then  -- <ESC>[
      from = p+2
      for i = from to length(data) do
        if t_alpha(data[i]) then
          p = i
          exit
        end if
      end for
    elsif find(data[p], {9,10,13}) or (data[p] > 31) then
      s &= {data[p]}
    end if
  end while
  return s
end function

------------------------------------------------------------------------------

function wait_socket(atom session)
  integer direction
  sequence read, write, s
  atom t0

  log_printf("wait_socket(%d)\n", {session})
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
  t0 = time()
  lg = 0
  while (lg = 0) and ((time()-t0) < 0.5) do
    s = select(read, {}, write, 0, 100000)
    lg = s[1][SELECT_IS_READABLE]
    log_printf("s = %s, lg = %d\n", {sprint(s), lg})
  end while
  return lg
end function

------------------------------------------------------------------------------

procedure exec_cmd(atom session, sequence commandline, integer terminal=0)
  integer rc, lg
  atom buf, channel
  sequence s

  log_printf("exec_cmd(%s)\n", {commandline})

  -- puts(1, "Establish a generic session channel\n")
  channel = libssh2_channel_open_session(session)
  if not (channel) then
    puts(2, "Unable to open a session\n")
    shutdown(session)
  end if

  if terminal then
    -- puts(1, "Request a terminal\n")
    if libssh2_channel_request_pty(channel, "vanilla") then
      puts(2, "Failed requesting pty\n")
      if (channel) then
        void = libssh2_channel_free(channel)
        channel = NULL
      end if
      shutdown(session)
    end if
  
    -- puts(1, "Open a SHELL on that terminal\n")
    if libssh2_channel_shell(channel) then
      puts(2, "Unable to request shell on allocated pty\n")
      shutdown(session)
    end if
  
    sleep(2)
  
    rc = libssh2_channel_write(channel, allocate_string(commandline & "\n"), length(commandline)+2)
    while rc = LIBSSH2_ERROR_EAGAIN do
      void = wait_socket(session)
      rc = libssh2_channel_write(channel, allocate_string(commandline & "\n"), length(commandline)+2)
    end while
    if rc=0 then
      s = libssh2_session_last_error(session)
      error_message(sprintf("Failure executing command %s: %d\n", {commandline, s}), 0)
      shutdown(session)
    end if
  else
    rc = libssh2_channel_exec(channel, allocate_string(commandline & "\n"), length(commandline)+2)
    while rc = LIBSSH2_ERROR_EAGAIN do
      void = wait_socket(session)
      rc = libssh2_channel_exec(channel, allocate_string(commandline & "\n"), length(commandline)+2)
    end while
  end if

  buf = allocate(#4000)
  lg = 1
  while lg do
    lg = libssh2_channel_read(channel, buf, #4000)
    s = remove_vt_controls(peek({buf, lg}))
    if length(s) then
      puts(f_debug, s)
      puts(1, s)
    end if
    lg = wait_socket(session)
  end while
  free(buf)

  void = libssh2_channel_send_eof(channel)
  void = libssh2_channel_close(channel)
  void = libssh2_channel_free(channel)
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
