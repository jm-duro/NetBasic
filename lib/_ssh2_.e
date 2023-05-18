include std/search.e
include std/text.e
include std/dll.e
include std/machine.e
include std/socket.e
include std/types.e
ifdef WINDOWS then
include std/win32/msgbox.e
include win32lib.ew
end ifdef
include _common_.e as com
include _idle_.e
include _search_.e
include _conv_.e
include _debug_.e
include _sequence_.e
include _file_.e
include _libssh2_.e

public constant
  TCP_HOST = 1, TCP_PORT = 2, TCP_SOCKET = 3, SSH_SESSION = 4, SSH_STATE = 5,
  BUFFER = 6
--<constant>
--<name>TCP_HOST</name>
--<value>1</value>
--<desc></desc>
--</constant>
--<constant>
--<name>TCP_PORT</name>
--<value>2</value>
--<desc></desc>
--</constant>
--<constant>
--<name>TCP_SOCKET</name>
--<value>3</value>
--<desc></desc>
--</constant>
--<constant>
--<name>SSH_SESSION</name>
--<value>4</value>
--<desc></desc>
--</constant>
--<constant>
--<name>SSH_STATE</name>
--<value>5</value>
--<desc></desc>
--</constant>
--<constant>
--<name>BUFFER</name>
--<value>6</value>
--<desc></desc>
--</constant>

public constant DISCONNECTED=0, CONNECTED=1
--<constant>
--<name>DISCONNECTED</name>
--<value>0</value>
--<desc></desc>
--</constant>
--<constant>
--<name>CONNECTED</name>
--<value>1</value>
--<desc></desc>
--</constant>

constant SOCKET_ERROR = -1

constant NULL = 0

public sequence activeConnections
--<variable>
--<type>sequence</type>
--<name>activeConnections</name>
--<desc>
-- list of active connections
-- active does not mean connected (see activeSockets for that)
--</desc>
--</variable>
activeConnections = {}

public integer rtn_ident_cnx
--<variable>
--<type>integer</type>
--<name>rtn_ident_cnx</name>
--<desc>
-- id of the routine that identifies items in activeConnections
-- to be used for debug with analyze_object
-- example:
--   analyzeObject(activeConnections, "activeConnections", f_debug, rtn_ident_cnx)
--</desc>
--</variable>

object void
void = 0

sequence linearBuffers
linearBuffers = {}

integer displayBuffer
linearBuffers = append(linearBuffers, {})
displayBuffer = length(linearBuffers)

-------------------------------------------------------------------------------

function identifyConnection(sequence path, integer level, integer n, object x)
--  printf(f_debug, "  path: '%s', level: %d, n: %d\n", {path, level, n})
  if level = 1 then
    if    n =  1 then return "TCP_HOST"
    elsif n =  2 then return "TCP_PORT"
    elsif n =  3 then return "TCP_SOCKET"
    elsif n =  4 then return "SSH_SESSION"
    elsif n =  5 then return "SSH_STATE"
    elsif n =  6 then return "BUFFER"
    end if
  end if
  return sprintf("%d",n)
end function
rtn_ident_cnx = routine_id("identifyConnection")

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
  error_message(title & ": " & msg & "\n", 0)
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

public function check_link(integer cnx)
--<function>
--<name>check_link</name>
--<digest>check if a connection is valid</digest>
--<desc>
--</desc>
--<param>
--<type>integer</type>
--<name>cnx</name>
--<desc></desc>
--</param>
--<return>
--</return>
--<example>
-- if not check_link(1) then puts(2, "Connection 1 failed!") end if
--</example>
--<see_also>
--</see_also>
--</function>
  sequence host
  integer port, lg
  atom session
  sockets:socket tcpSocket

  lg = length(activeConnections)
  if lg = 0 then
    log_puts("no active connection available\n")
    return 0
  end if
  if (cnx < 1) or (cnx > lg) then
    log_printf("no connection %d available\n", cnx)
    return 0
  end if
  host = activeConnections[cnx][TCP_HOST]
  port = activeConnections[cnx][TCP_PORT]
  if activeConnections[cnx][SSH_STATE] = DISCONNECTED then
    log_printf("not connected to host %s:%d\n", {host, port})
    return 0
  end if
  session = activeConnections[cnx][SSH_SESSION]
  if session=NULL then
    log_printf("no SSH session to host %s:%d\n", {host, port})
    return 0
  end if
  tcpSocket = activeConnections[cnx][TCP_SOCKET]
  if atom(tcpSocket) then
    log_printf("no socket to host %s:%d\n", {host, port})
    return 0
  end if
  return 1
end function

------------------------------------------------------------------------------

public function get_buffer(integer cnx)
--<function>
--<name>get_buffer</name>
--<digest>reads connection buffer</digest>
--<desc>
--</desc>
--<param>
--<type>integer</type>
--<name>cnx</name>
--<desc>connection id</desc>
--</param>
--<return>
-- sequence: buffer content
--</return>
--<example>
-- data = get_buffer(cnx)
--</example>
--<see_also></see_also>
--</function>
  sequence data

--  log_printf("get_buffer(%d)", {cnx})
  if not check_link(cnx) then return 0 end if
  data = linearBuffers[activeConnections[cnx][BUFFER]]
  return data
end function

------------------------------------------------------------------------------

public function set_buffer(integer cnx, sequence data)
--<function>
--<name>set_buffer</name>
--<digest>sets connection buffer</digest>
--<desc>
--</desc>
--<param>
--<type>integer</type>
--<name>cnx</name>
--<desc>connection id</desc>
--</param>
--<param>
--<type>sequence</type>
--<name>data</name>
--<desc>new buffer content</desc>
--</param>
--<return>
-- integer: 1 on success, 0 on failure
--</return>
--<example>
-- data = get_buffer(cnx)
-- ok = set_buffer(cnx, remove(data, 1, 7))
--</example>
--<see_also></see_also>
--</function>
--  log_printf("set_buffer(%d, %s)", {cnx, data})
  if not check_link(cnx) then return 0 end if
  linearBuffers[activeConnections[cnx][BUFFER]] = data
  return 1
end function

------------------------------------------------------------------------------

public function clean_buffer(integer cnx)
--<function>
--<name>clean_buffer</name>
--<digest>cleans connection buffer</digest>
--<desc>
--</desc>
--<param>
--<type>integer</type>
--<name>cnx</name>
--<desc>connection id</desc>
--</param>
--<return>
-- integer: 1 on success, 0 on failure
--</return>
--<example>
-- ok = clean_buffer(cnx)
--</example>
--<see_also></see_also>
--</function>
--  log_printf("clean_buffer(%d)", {cnx})
  if not check_link(cnx) then return 0 end if
  linearBuffers[activeConnections[cnx][BUFFER]] = ""
  return 1
end function

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

function wait_socket(integer cnx)
  integer direction, lg
  sequence read, write, s
  atom t0, session
  sockets:socket tcpSocket

  if cnx= 0 then return 0 end if
  log_printf("wait_socket(%d)\n", {cnx})
  session = activeConnections[cnx][SSH_SESSION]
  tcpSocket = activeConnections[cnx][TCP_SOCKET]
  read = {}
  write = {}
  -- now make sure we wait in the correct direction
  direction = libssh2_session_block_directions(session)

  if and_bits(direction, LIBSSH2_SESSION_BLOCK_INBOUND) then
    read = {tcpSocket}
  end if
  if and_bits(direction, LIBSSH2_SESSION_BLOCK_OUTBOUND) then
    write = {tcpSocket}
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

--------------------------------------------------------------------------------

public function find_connection(sequence host, integer port)
--<function>
--<name>find_connection</name>
--<digest>find a connection id from host and port used</digest>
--<desc>
--</desc>
--<param>
--<type>sequence</type>
--<name>host</name>
--<desc></desc>
--</param>
--<param>
--<type>integer</type>
--<name>port</name>
--<desc></desc>
--</param>
--<return>
--</return>
--<example>
-- i = find_connection("192.168.1.250", 23)
--</example>
--<see_also>
--</see_also>
--</function>
  sequence s

  s = find_common_fields(activeConnections, {TCP_HOST,TCP_PORT}, {host,port})
  if length(s) then return s[1] else return 0 end if
end function

------------------------------------------------------------------------------

public function ssh_init()
--<function>
--<name>ssh_init</name>
--<digest>Initialize the libssh2 functions</digest>
--<desc></desc>
--<return>
-- Returns 1 if successful else returns 0
--</return>
--<example>
-- if not ssh_init() then abort(1) end if
--</example>
--<see_also>ssh_exit()</see_also>
--</function>
  integer rc

  rc = libssh2_init(0)
  if rc then
    error_message(sprintf("libssh2 initialization failed (%d)\n", rc), 0)
    return 0
  end if
  return 1
end function

------------------------------------------------------------------------------

public procedure ssh_exit()
--<procedure>
--<name>ssh_exit</name>
--<digest>Exit the libssh2 functions and free's all memory used internally.</digest>
--<desc></desc>
--<example>
-- ssh_exit()
--</example>
--<see_also>ssh_init()</see_also>
--</procedure>
  libssh2_exit()
end procedure

------------------------------------------------------------------------------

public procedure ssh_close(integer cnx)
--<procedure>
--<name>ssh_close</name>
--<digest>close a SSH connection</digest>
--<desc>
-- updates activeConnections
--</desc>
--<param>
--<type>integer</type>
--<name>cnx</name>
--<desc>connection id</desc>
--</param>
--<example>
-- ssh_close(1)
--</example>
--<see_also>ssh_connect()</see_also>
--</procedure>
  atom session
  sockets:socket tcpSocket

  if cnx= 0 then return end if
  session = activeConnections[cnx][SSH_SESSION]
  tcpSocket = activeConnections[cnx][TCP_SOCKET]
  void = libssh2_session_disconnect(session, "Normal Shutdown")
  void = libssh2_session_free(session)
  void = sockets:shutdown(tcpSocket)
  activeConnections = remove(activeConnections, cnx)
end procedure

------------------------------------------------------------------------------

public procedure ssh_exec(integer cnx, sequence cmd, integer terminal=0)
--<procedure>
--<name>ssh_exec</name>
--<digest>run a command on the SSH session</digest>
--<desc>
--</desc>
--<param>
--<type>integer</type>
--<name>cnx</name>
--<desc>connection id</desc>
--</param>
--<param>
--<type>sequence</type>
--<name>cmd</name>
--<desc>command to run</desc>
--</param>
--<param>
--<type>integer</type>
--<name>terminal</name>
--<desc>opens a terminal if 1 (true) (defaults to 0)</desc>
--</param>
--<example>
-- ssh_exec(1, "ls -l", 1)
--</example>
--<see_also>
--</see_also>
--</procedure>
  integer rc, lg
  atom buf, session, channel
  sequence s

  log_printf("ssh_exec(%d, %s, %d)\n", {cnx, cmd, terminal})

  if cnx= 0 then return end if
  session = activeConnections[cnx][SSH_SESSION]
  -- puts(1, "Establish a generic session channel\n")
  channel = libssh2_channel_open_session(session)
  if not (channel) then
    puts(2, "Unable to open a session\n")
    ssh_close(cnx)
  end if

  if terminal then
    -- puts(1, "Request a terminal\n")
    if libssh2_channel_request_pty(channel, "vanilla") then
      puts(2, "Failed requesting pty\n")
      if (channel) then
        void = libssh2_channel_free(channel)
        channel = NULL
      end if
      ssh_close(cnx)
    end if
  
    -- puts(1, "Open a SHELL on that terminal\n")
    if libssh2_channel_shell(channel) then
      puts(2, "Unable to request shell on allocated pty\n")
      ssh_close(cnx)
    end if
  
    rc = libssh2_channel_write(channel, allocate_string(cmd & "\n"), length(cmd)+2)
    while rc = LIBSSH2_ERROR_EAGAIN do
      void = wait_socket(cnx)
      rc = libssh2_channel_write(channel, allocate_string(cmd & "\n"), length(cmd)+2)
    end while
    if rc=0 then
      s = libssh2_session_last_error(session)
      error_message(sprintf("Failure executing command %s: %d\n", {cmd, s}), 0)
      ssh_close(cnx)
    end if
  else
    rc = libssh2_channel_exec(channel, allocate_string(cmd & "\n"), length(cmd)+2)
    while rc = LIBSSH2_ERROR_EAGAIN do
      void = wait_socket(cnx)
      rc = libssh2_channel_exec(channel, allocate_string(cmd & "\n"), length(cmd)+2)
    end while
  end if

  buf = allocate(#4000)
  lg = 1
  while lg do
    lg = libssh2_channel_read(channel, buf, #4000)
    s = remove_vt_controls(peek({buf, lg}))
    if length(s) then
      puts(f_debug, s)
      linearBuffers[displayBuffer] &= s
      linearBuffers[activeConnections[cnx][BUFFER]] &= s
    end if
    lg = wait_socket(cnx)
  end while
  free(buf)

  void = libssh2_channel_send_eof(channel)
  void = libssh2_channel_close(channel)
  void = libssh2_channel_free(channel)
end procedure

------------------------------------------------------------------------------

public function ssh_connect(sequence host, integer port,
                            sequence username, sequence password) 
--<function>
--<name>ssh_connect</name>
--<digest>open a SSH connection to a remote host</digest>
--<desc>
-- updates activeConnections
--</desc>
--<param>
--<type>sequence</type>
--<name>host</name>
--<desc></desc>
--</param>
--<param>
--<type>integer</type>
--<name>port</name>
--<desc></desc>
--</param>
--<param>
--<type>sequence</type>
--<name>username</name>
--<desc></desc>
--</param>
--<param>
--<type>sequence</type>
--<name>password</name>
--<desc></desc>
--</param>
--<return>
-- integer: connection id
--</return>
--<example>
-- cnx = ssh_connect("192.168.1.250", 22, "admin", "admin")
--</example>
--<see_also>ssh_close()</see_also>
--</function>
  sequence s
  integer cnx, buffer
  atom session
  sockets:socket tcpSocket
  
  -- Create the socket establishing the connection
  
  tcpSocket = sock_connect(host, port)
  if atom(tcpSocket) then
    error_message(sprintf("Could not connect to %s:%d\n", {host, port}), 0)
    libssh2_exit()
    return 0
  end if
  
  -- Create a session instance and start it up. This will trade welcome
  -- banners, exchange keys, and setup crypto, compression, and MAC layers
  
  session = libssh2_session_init()
  if libssh2_session_startup(session, tcpSocket[SOCKET_SOCKET]) then
    error_message("Failure establishing SSH session\n", 0)
    ssh_close(session)
    return 0
  end if
  
  -- libssh2_session_set_blocking(session, 0)
  
  if (libssh2_userauth_password(session, username, password, 0)) then
    error_message("Authentication by password failed!\n", 0)
    ssh_close(session)
    return 0
  end if
  log_printf("ssh_connect: Connected to %s:%d\n", {host, port})
  s = find_common_fields(activeConnections, {TCP_HOST,TCP_PORT}, {host, port})
  if length(s) then
    cnx = s[1]
    buffer = activeConnections[cnx][BUFFER]
    activeConnections[cnx] = {host, port, tcpSocket, session, CONNECTED, buffer}
    linearBuffers[buffer] = ""
  else
    linearBuffers = append(linearBuffers, {})
    activeConnections = append(activeConnections, {host, port, tcpSocket, session, CONNECTED, length(linearBuffers)})
    cnx = length(activeConnections)
  end if
  return cnx
end function
