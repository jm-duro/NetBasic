-- Manages TCP connections
-- Program then    TNCNX.PAS
-- Object then     Delphi component which implement the TCP/IP telnet protocol
--         including some options negociations.
--         RFC854, RFC885, RFC779, RFC1091
-- Author then     Fran&ccedil;ois PIETTE
-- EMail then    http then//users.swing.be/francois.piette  francois.piette@swing.be
--         http then//www.rtfm.be/fpiette       francois.piette@rtfm.be
--         francois.piette@pophost.eunet.be
-- Creation then   April, 1996
-- Version then    2.09
-- Support then    Use the mailing list twsocket@rtfm.be See website for details.
-- Legal issues then Copyright (C) 1996-2002 by Fran&ccedil;ois PIETTE
--         Rue de Grady 24, 4053 Embourg, Belgium. Fax then +32-4-365.74.56
--         <francois.piette@pophost.eunet.be>
--
--         This software is provided "as-is", without any express or
--         implied warranty.  In no event will the author be held liable
--         for any  damages arising from the use of this software.
--
--         Permission is granted to anyone to use this software for any
--         purpose, including commercial applications, and to alter it
--         and redistribute it freely, subject to the following
--         restrictions then
--
--         1. The origin of this software must not be misrepresented,
--          you must not claim that you wrote the original software.
--          If you use this software in a product, an acknowledgment
--          in the product documentation would be appreciated but is
--          not required.
--
--         2. Altered source versions must be plainly marked as such, and
--          must not be misrepresented as being the original software.
--
--         3. This notice may not be removed or altered from any source
--          distribution.
--
--         4. You must register this software by sending a picture postcard
--          to the author. Use a nice stamp and mention your name, street
--          address, EMail address and any comment you like to say.
--
-- Updates then
-- Jul 22, 1997 Adapted to Delphi 3
-- Sep 5, 1997  Added version information, removed old code, added OnTermType
--        Renamed some indentifier to be more standard.
-- Sep 24, 1997 V2.03 Added procedures to negociate options
-- May 12, 1998 V2.04 Changed NegociateOption to properly handle unwanted
--        option as Jan Tomasek <xtomasej@feld.cvut.cz> suggested.
-- Aug 10, 1998 V2.05 Cleared activeConnections[cnx][SUB_OPTION] after NegociateSubOption as Jan
--        Tomasek <xtomasej@feld.cvut.cz> suggested.
-- Aug 15, 1999 V2.06 Moved Notification procedure to public section for
--        BCB4 compatibility
-- Aug 20, 1999 V2.07 Added compile time options. Revised for BCB4.
-- Jun 18, 2001 V2.08 Use AllocateHWnd and DeallocateHWnd from wsocket.
-- Oct 23, 2002 V2.09 Changed Buffer arg in OnDataAvailable to Pointer instead
--        of PChar to avoid Delphi 7 messing everything with AnsiChar.
-- Oct 23, 2015 V2.09 Ported to OpenEuphoria 4 by Jean-Marc DURO
-- Mar 31, 2016 V2.09 Ported to Euphoria 3.11 by Jean-Marc DURO

include std/win32/msgbox.e
include std/search.e
include std/text.e
include std/dll.e
include Sockets.ew
include WSErrors.ew
include _idle_.e
include _search_.e
include _conv_.e
include _debug_.e
include _sequence_.e
include _file_.e

constant
--  TnCnxVersion     = 209,
--  CopyRight = " TTnCnx (c) 1996-2002 F. Piette V2.09 ",
  FLocation = "TNCNX",
  FTermType = "VT100",

  -- Telnet command characters
  TNCH_EOR        = 239,  -- #EF End Of Record (preceded by IAC)
  TNCH_SE         = 240,  -- #F0 End of subnegociation parameters
--  TNCH_NOP        = 241,  -- #F1 No operation
--  TNCH_DATA_MARK  = 242,  -- #F2 Data stream portion of a Synch
--  TNCH_BREAK      = 243,  -- #F3 NVT charcater break
  TNCH_IP         = 244,  -- #F4 Interrupt process
  TNCH_AO         = 245,  -- #F5 Abort output
  TNCH_AYT        = 246,  -- #F6 Are you there
  TNCH_EC         = 247,  -- #F7 Erase character
  TNCH_EL         = 248,  -- #F8 Erase line
--  TNCH_GA         = 249,  -- #F9 Go ahead
  TNCH_SB         = 250,  -- #FA Subnegociation
  TNCH_WILL       = 251,  -- #FB Will
  TNCH_WONT       = 252,  -- #FC Wont
  TNCH_DO         = 253,  -- #FD Do
  TNCH_DONT       = 254,  -- #FE Dont
  TNCH_IAC        = 255,  -- #FF IAC

  -- Telnet options
  TN_TRANSMIT_BINARY = 0,   -- #00
  TN_ECHO            = 1,   -- #01
--  TN_RECONNECTION    = 2,   -- #02
  TN_SUPPRESS_GA     = 3,   -- #03
--  TN_MSG_SZ_NEGOC    = 4,   -- #04
--  TN_STATUS          = 5,   -- #05
--  TN_TIMING_MARK     = 6,   -- #06
--  TN_NOPTIONS        = 6,   -- #06
--  TN_DET             = 20,  -- #14
  TN_SEND_LOC        = 23,  -- #17
  TN_TERMTYPE        = 24,  -- #18
  TN_EOR             = 25,  -- #19
--  TN_NAWS            = 31,  -- #1F
--  TN_TERMSPEED       = 32,  -- #20
--  TN_TFC             = 33,  -- #21
--  TN_XDISPLOC        = 35,  -- #23
--  TN_EXOPL           = 255, -- #FF

  TN_TTYPE_SEND      = 1,
  TN_TTYPE_IS        = 0

public constant
  TCP_HOST = 1, TCP_PORT = 2, TCP_SOCKET = 3, TCP_STATUS = 4,
  LAST_IO = 5, BUFFER = 6, IAC = 7, VERB = 8, SUB_OPTION = 9,
  SUB_NEGOC = 10
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
--<name>TCP_STATUS</name>
--<value>4</value>
--<desc></desc>
--</constant>
--<constant>
--<name>LAST_IO</name>
--<value>5</value>
--<desc></desc>
--</constant>
--<constant>
--<name>BUFFER</name>
--<value>6</value>
--<desc></desc>
--</constant>
--<constant>
--<name>IAC</name>
--<value>7</value>
--<desc></desc>
--</constant>
--<constant>
--<name>VERB</name>
--<value>8</value>
--<desc></desc>
--</constant>
--<constant>
--<name>SUB_OPTION</name>
--<value>9</value>
--<desc></desc>
--</constant>
--<constant>
--<name>SUB_NEGOC</name>
--<value>10</value>
--<desc></desc>
--</constant>


public constant DISCONNECTED = 0, CONNECTED = 1, LISTENING = 2
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

public sequence activeConnections, activeSockets
--<variable>
--<type>sequence</type>
--<name>activeConnections</name>
--<desc>
-- list of active connections
-- active does not mean connected (see activeSockets for that)
--</desc>
--</variable>
--<variable>
--<type>sequence</type>
--<name>activeSockets</name>
--<desc>list of active sockets</desc>
--</variable>
activeConnections = {}
activeSockets = {}

public integer onTheFlowDisplayRoutine
--<variable>
--<type>integer</type>
--<name>onTheFlowDisplayRoutine</name>
--<desc>
-- if declared, id of the routine that gets data when check connections() is run
-- not really on the flow until you set a timer to check connections periodically
--</desc>
--</variable>
onTheFlowDisplayRoutine = 0

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

constant MAXLEN = 1000

constant max_time = 30

integer
  RemoteBinMode,
  LocalBinMode,
  FLocalEcho,
  spga,
  FTType

sequence linearBuffers
linearBuffers = {}

integer displayBuffer
linearBuffers = append(linearBuffers, {})
displayBuffer = length(linearBuffers)

-------------------------------------------------------------------------------

function identifyConnection(sequence path, integer level, integer n)
--  printf(f_debug, "  path: '%s', level: %d, n: %d\n", {path, level, n})
  if level = 1 then
    if    n =  1 then return "TCP_HOST"
    elsif n =  2 then return "TCP_PORT"
    elsif n =  3 then return "TCP_SOCKET"
    elsif n =  4 then return "TCP_STATUS"
    elsif n =  5 then return "LAST_IO"
    elsif n =  6 then return "BUFFER"
    elsif n =  7 then return "IAC"
    elsif n =  8 then return "VERB"
    elsif n =  9 then return "SUB_OPTION"
    elsif n = 10 then return "SUB_NEGOC"
    end if
  end if
  return sprintf("%d",n)
end function
rtn_ident_cnx = routine_id("identifyConnection")

------------------------------------------------------------------------------

public procedure handle_error()
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

------------------------------------------------------------------------------

public function get_port(atom hsock)
--<function>
--<name>get_port</name>
--<digest>get the port that is bound to the socket</digest>
--<desc>
-- low-level command
--</desc>
--<param>
--<type>atom</type>
--<name>hsock</name>
--<desc>TCP socket</desc>
--</param>
--<return>
-- integer: port number
--</return>
--<example>
-- port_used = get_port(tcpSocket)
-- port_used = get_port(activeConnections[cnx][TCP_SOCKET])
--</example>
--<see_also>
--</see_also>
--</function>
  sequence Address

  Address = getsockname (hsock)
  return Address[4] + Address[3] * 256
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
  atom tcpSocket

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
  if activeConnections[cnx][TCP_STATUS] = DISCONNECTED then
    log_printf("not connected to host %s:%d\n", {host, port})
    return 0
  end if
  tcpSocket = activeConnections[cnx][TCP_SOCKET]
  if tcpSocket = 0 then
    log_printf("no socket to host %s:%d\n", {host, port})
    return 0
  end if
  return 1
end function

------------------------------------------------------------------------------

function sock_listen(integer Port)
  sequence Address
  atom     hSockListen

  -- Create a stream (TCP) socket
  hSockListen = socket (AF_INET, SOCK_STREAM, 0)
  if hSockListen != SOCKET_ERROR then
    -- Setup an IP address/port structure
    -- Use the localhost address and let Windows choose the port
    Address = sockaddr_in (AF_INET, "", Port)
    -- Bind this end of the socket to the local port
    if bind (hSockListen, Address) != SOCKET_ERROR then
      -- Listen for a connection request
      if listen (hSockListen, 1) != SOCKET_ERROR then
        return hSockListen
      end if
    end if
  end if
  handle_error()
  return 0
end function

------------------------------------------------------------------------------

procedure sock_disconnect (atom tcpSocket)
  void = closesocket (tcpSocket)
end procedure

------------------------------------------------------------------------------

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
      else
        void = closesocket (tcpSocket)
      end if
    end if
  end if
  handle_error()
  return 0
end function

--------------------------------------------------------------------------------

public function telnet_send(integer cnx, sequence cmd)
--<function>
--<name>telnet_send</name>
--<digest>send data on a socket</digest>
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
--<desc>command to send (as is)</desc>
--</param>
--<return>
--</return>
--<example>
-- void = telnet_send(cnx, "exit\r\n")
--</example>
--<see_also>telnet_read(), read_all(), read_until()</see_also>
--</function>
  integer  status

  log_printf("telnet_send(%d, '%s')\n", {cnx, cmd})
  if not check_link(cnx) then return 0 end if
  status = send(activeConnections[cnx][TCP_SOCKET],cmd)
  if status != SOCKET_ERROR then
    log_printf("telnet_send: Sent '%s' %s (%d bytes) on connection %d\n", {show_printable(cmd), sprint(cmd), status, cnx})
    activeConnections[cnx][LAST_IO] = time()
  else
    handle_error()
    log_printf("telnet_send: Error while sending '%s' on connection %d\n", {cmd, cnx})
  end if
  return status
end function

--------------------------------------------------------------------------------

procedure Answer(integer cnx, integer chAns, integer chOption)
  sequence Buf

  Buf = {TNCH_IAC, chAns, chOption}
  void = telnet_send(cnx, Buf)
end procedure

--------------------------------------------------------------------------------

procedure NegociateSubOption(integer cnx, sequence strSubOption)
  sequence Buf

  if strSubOption[1] = TN_TERMTYPE then
    if strSubOption[2] = TN_TTYPE_SEND then
      Buf = {TNCH_IAC, TNCH_SB, TN_TERMTYPE, TN_TTYPE_IS} & FTermType & {TNCH_IAC, TNCH_SE}
      void = telnet_send(cnx, Buf)
    end if
  else
--    log_puts("Unknown suboption\n");
  end if
end procedure

--------------------------------------------------------------------------------

procedure NegociateOption(integer cnx, integer chAction, integer chOption)
  sequence Buf

  if chOption = TN_TRANSMIT_BINARY then
    if chAction = TNCH_WILL then
      Answer(cnx, TNCH_DO, chOption)
      RemoteBinMode = 1
      LocalBinMode  = 1
    elsif chAction = TNCH_WONT then
      if RemoteBinMode then
        RemoteBinMode = 0
        LocalBinMode  = 0
      end if
    end if
  elsif chOption = TN_ECHO then
    if chAction = TNCH_WILL then
      Answer(cnx, TNCH_DO, chOption)
      FLocalEcho = 0
    elsif chAction = TNCH_WONT then
      FLocalEcho = 1
    end if
  elsif chOption = TN_SUPPRESS_GA then
    if chAction = TNCH_WILL then
      Answer(cnx, TNCH_DO, chOption)
      spga = 1
    end if
  elsif chOption = TN_TERMTYPE then
    if chAction = TNCH_DO then
      Answer(cnx, TNCH_WILL, chOption)
      FTType = 1
    end if
  elsif chOption = TN_SEND_LOC then
    if chAction = TNCH_DO then
      Answer(cnx, TNCH_WILL, chOption)
      Buf = {TNCH_IAC, TNCH_SB, TN_SEND_LOC, FLocation, TNCH_IAC, TNCH_SE}
      void = telnet_send(cnx, Buf)
    end if
  elsif chOption = TN_EOR then
    if chAction = TNCH_DO then
      Answer(cnx, TNCH_WILL, chOption)
      FTType = 1
    end if
  else
--    Answer(cnx, TNCH_WONT, chOption);
    -- Jan Tomasek <xtomasej@feld.cvut.cz>
    if chAction = TNCH_WILL then
      Answer(cnx, TNCH_DONT, chOption)
    else
      Answer(cnx, TNCH_WONT, chOption)
    end if
  end if
end procedure

--------------------------------------------------------------------------------

procedure AddChar(integer cnx, integer Ch)
  linearBuffers[displayBuffer] &= {Ch}
  linearBuffers[activeConnections[cnx][BUFFER]] &= {Ch}
end procedure

--------------------------------------------------------------------------------

procedure ReceiveChar(integer cnx, integer Ch)

  if activeConnections[cnx][VERB] != #0 then
    NegociateOption(cnx, activeConnections[cnx][VERB], Ch)
    activeConnections[cnx][VERB]     = #0
    activeConnections[cnx][SUB_OPTION] = ""
    return
  end if

  if activeConnections[cnx][SUB_NEGOC] then
    if Ch = TNCH_SE then
      activeConnections[cnx][SUB_NEGOC]  = 0
      NegociateSubOption(cnx, activeConnections[cnx][SUB_OPTION])
      activeConnections[cnx][SUB_OPTION] = ""
    else
      activeConnections[cnx][SUB_OPTION] = activeConnections[cnx][SUB_OPTION] & Ch
    end if
    return
  end if

  if activeConnections[cnx][IAC] then
    if Ch = TNCH_IAC then
      AddChar(cnx, Ch)
      activeConnections[cnx][IAC] = 0
    elsif find(Ch, {TNCH_DO, TNCH_WILL, TNCH_DONT, TNCH_WONT}) then
      activeConnections[cnx][IAC]   = 0
      activeConnections[cnx][VERB] = Ch
    elsif Ch = TNCH_EOR then
      -- log_puts("TNCH_EOR\n")
      activeConnections[cnx][IAC]   = 0
    elsif Ch = TNCH_SB then
--      log_puts("Subnegociation\r\n");
      activeConnections[cnx][SUB_NEGOC] = 1
      activeConnections[cnx][IAC]    = 0
    elsif Ch = TNCH_IP then
      log_puts("Connection about to be broken\n")
      activeConnections[cnx][IAC]   = 0
    else
      log_printf("Unknown telnet IAC option %02x\n", Ch)
      activeConnections[cnx][IAC] = 0
    end if
    return
  end if

  if Ch = TNCH_EL then
    -- log_puts("TNCH_EL\n")
    AddChar(cnx, Ch)
  elsif Ch = TNCH_EC then
    -- log_puts("TNCH_EC\n")
    AddChar(cnx, Ch)
  elsif Ch = TNCH_AYT then
    -- log_puts("TNCH_AYT\n")
    AddChar(cnx, Ch)
  elsif Ch = TNCH_AO then
    -- log_puts("TNCH_AO\n")
    AddChar(cnx, Ch)
  elsif Ch = TNCH_IAC then
    activeConnections[cnx][IAC] = 1
  else
    AddChar(cnx, Ch)
  end if
end procedure

--------------------------------------------------------------------------------

global function get_buffer(integer cnx)
  sequence data
  
  data = linearBuffers[activeConnections[cnx][BUFFER]]
  linearBuffers[activeConnections[cnx][BUFFER]] = ""
  return data
end function

--------------------------------------------------------------------------------

function get_active_sockets()
  sequence s

  s = {}
  for i = 1 to length(activeConnections) do
    if activeConnections[i][TCP_STATUS] = CONNECTED then
      s = append(s, activeConnections[i][TCP_SOCKET])
    end if
  end for
  return s
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

--------------------------------------------------------------------------------

public procedure telnet_close(integer cnx)
--<procedure>
--<name>telnet_close</name>
--<digest>close a telnet connection</digest>
--<desc>
-- updates activeConnections and activeSockets
--</desc>
--<param>
--<type>integer</type>
--<name>cnx</name>
--<desc>connection id</desc>
--</param>
--<example>
-- telnet_close(1)
--</example>
--<see_also>
--</see_also>
--</procedure>
  sequence host
  atom tcpSocket

  if cnx= 0 then return end if
  host = activeConnections[cnx][TCP_HOST]
  tcpSocket = activeConnections[cnx][TCP_SOCKET]
  void = closesocket (tcpSocket)
  activeConnections[cnx][TCP_STATUS] = DISCONNECTED
  activeConnections[cnx][TCP_SOCKET] = 0
  activeSockets = get_active_sockets()
end procedure

--------------------------------------------------------------------------------

procedure telnetReceive(integer cnx)
  object data

  -- log_printf("telnetReceive(%d)\n", {cnx})
  if not check_link(cnx) then return end if
  data = recv(activeConnections[cnx][TCP_SOCKET], MAXLEN)
  if data[1] = 0 then -- indicates the connection was closed
    log_printf("telnetReceive: lost connection %d\n", {cnx})
    activeConnections[cnx][TCP_STATUS] = DISCONNECTED
  elsif data[1] > 0 then -- number of bytes received
--    printf(f_debug, "bytes received = %d\n", {data[1]})
    analyze_object(data[2], sprintf("telnetReceive(%d)", {cnx}), f_debug)
    activeConnections[cnx][LAST_IO] = time()
    for i = 1 to length(data[2]) do ReceiveChar(cnx, data[2][i]) end for
    data = linearBuffers[displayBuffer]
    if sequence (data) and onTheFlowDisplayRoutine then  -- process data with routine onTheFlowDisplayRoutine
      call_proc(onTheFlowDisplayRoutine, {data})
    end if
    linearBuffers[displayBuffer] = ""
  else
    handle_error()
    log_printf("telnetReceive: Error while receiving on connection %d\n", {cnx})
    telnet_close(cnx)
  end if
end procedure

--------------------------------------------------------------------------------

public procedure check_connections( integer timeout=0, integer timeout_micro=0 )
--<procedure>
--<name>check_connections</name>
--<digest></digest>
--<desc>
-- used by telnet_read(), read_all(), read_until() and send_receive()
-- can also be launched periodically by a 0.1 s timer to receive data on the flow
-- to display data on the flow onTheFlowDisplayRoutine has to point to a display routine
--</desc>
--<param>
--<type>integer</type>
--<name>timeout</name>
--<desc>
-- time out in seconds to wait for. default to 0
--</desc>
--</param>
--<param>
--<type>integer</type>
--<name>timeout_micro</name>
--<desc>
-- additional time out in microseconds to wait for. default to 0
--</desc>
--</param>
--<example>
-- procedure onTimer(integer self, integer event, sequence params)
-- -- This handler is called every TIMEOUT ms.
--   integer timerID
--
--   timerID = params[1]
--   if timerID = TIMER then
--     killTimer (Form, TIMER) -- Prevent reentry
--     check_connections()
--     setTimer (Form, TIMER, 100) -- Restart the timer
--   end if
-- end procedure  -- onTimer_Form1
--</example>
--<see_also>
--</see_also>
--</procedure>
  -- get socket state
  object sock_data
  integer cnx

  for i = 1 to length(activeConnections) do
--    log_puts(sprintf("activeConnections[%d][TCP_STATUS] = %d\n", {i, activeConnections[i][TCP_STATUS]}))
--    log_printf("elapsed time = %d\n", {time() - activeConnections[i][LAST_IO]})
    if activeConnections[i][TCP_STATUS] = CONNECTED then
      if (time() - activeConnections[i][LAST_IO]) >= max_time then
        void = telnet_send(i, {32,8})  -- SPACE and BACKSPACE
      end if
    end if
  end for
  sock_data = select(activeSockets, {}, activeSockets,
                          {timeout, timeout_micro})
  if sock_data[1] = 0 then
    return -- no data received
  end if
  for i = 1 to length(sock_data[2]) do
    cnx = find_in_array(sock_data[2][i], activeConnections, {{"search_field", TCP_SOCKET}})
    if cnx then
      if sock_data[2][i] then
        --log_printf("check_connections: Data readable on connection %d", {cnx})
        telnetReceive(cnx)
      end if
    end if
  end for
  for i = 1 to length(sock_data[4]) do
    cnx = find_in_array(sock_data[2][i], activeConnections, {{"search_field", TCP_SOCKET}})
    if cnx then
      log_printf("check_connections: Connexion %d is in error state, closed\n", {cnx})
      telnet_close(cnx)
    end if
  end for
end procedure

------------------------------------------------------------------------------

public function telnet_listen(integer port)
--<function>
--<name>telnet_listen</name>
--<digest>create a stream (TCP) socket and listens on it</digest>
--<desc>
--</desc>
--<param>
--<type>integer</type>
--<name>port</name>
--<desc></desc>
--</param>
--<return>
-- integer: connection id
--</return>
--<example>
-- cnx = telnet_listen(23)
--</example>
--<see_also>
--</see_also>
--</function>
  atom tcpSocket
  integer cnx, buffer
  sequence s, address

  tcpSocket = sock_listen(port)
  if tcpSocket = 0 then
    log_printf("telnet_listen: Could not listen on %d\n", {port})
    void = closesocket (tcpSocket)
    return 0
  else
    -- Get the port that is bound to the socket
    address = getsockname(tcpSocket)
    port = address[4] + address[3] * 256
    log_printf("telnet_listen: listen on %d\n", {port})
    s = find_common_fields(activeConnections, {TCP_HOST, TCP_PORT}, {"127.0.0.1", port})
    if length(s) then
      cnx = s[1]
      buffer = activeConnections[cnx][BUFFER]
      activeConnections[cnx] = {"127.0.0.1", port, tcpSocket, LISTENING, time(), buffer, 0, #0, "", 0}
      linearBuffers[buffer] = ""
    else
      linearBuffers = append(linearBuffers, {})
      activeConnections = append(activeConnections, {"127.0.0.1", port, tcpSocket, LISTENING, time(), length(linearBuffers), 0, #0, "", 0})
      cnx = length(activeConnections)
    end if
    activeSockets = get_active_sockets()
  end if
  return cnx
end function

--------------------------------------------------------------------------------

public function telnet_accept(integer listen)
--<function>
--<name>telnet_accept</name>
--<digest>accept a connection form listening socket and creates a stream (TCP) socket</digest>
--<desc>
-- updates activeConnections and activeSockets
--</desc>
--<param>
--<type>integer</type>
--<name>listen</name>
--<desc>listening connection</desc>
--</param>
--<return>
-- integer: connection id
--</return>
--<example>
-- cnx = telnet_accept(listen)
--</example>
--<see_also>
--</see_also>
--</function>
  atom tcpSocket
  integer cnx, buffer, port
  sequence s

  tcpSocket = accept(activeConnections[listen][TCP_SOCKET])
  if tcpSocket = 0 then
    log_printf("telnet_accept: Could not accept connection on %d\n", {activeConnections[listen][TCP_PORT]})
--    void = closesocket (tcpSocket)
    return 0
  else
    port = get_port(tcpSocket)
    log_printf("telnet_accept: Connection on port %d\n", {port})
    s = find_common_fields(activeConnections, {TCP_HOST,TCP_PORT}, {"127.0.0.1", port})
    if length(s) then
      cnx = s[1]
      buffer = activeConnections[cnx][BUFFER]
      activeConnections[cnx] = {"127.0.0.1", port, tcpSocket, CONNECTED, time(), buffer, 0, #0, "", 0}
      linearBuffers[buffer] = ""
    else
      linearBuffers = append(linearBuffers, {})
      activeConnections = append(activeConnections, {"127.0.0.1", port, tcpSocket, CONNECTED, time(), length(linearBuffers), 0, #0, "", 0})
      cnx = length(activeConnections)
    end if
    activeSockets = get_active_sockets()
  end if
  return cnx
end function

--------------------------------------------------------------------------------

public function telnet_connect(sequence host, integer port)
--<function>
--<name>telnet_connect</name>
--<digest>create a stream (TCP) socket and connect it to a remote host</digest>
--<desc>
-- updates activeConnections and activeSockets
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
-- integer: connection id
--</return>
--<example>
-- cnx = telnet_connect("192.168.1.250", 23)
--</example>
--<see_also>
--</see_also>
--</function>
  atom tcpSocket
  integer cnx, buffer
  sequence s

  tcpSocket = sock_connect(host, port)
  if tcpSocket = 0 then
    log_printf("telnet_connect: Could not connect to %s:%d\n", {host, port})
--    void = closesocket (tcpSocket)
    return 0
  else
    log_printf("telnet_connect: Connected to %s:%d\n", {host, port})
    s = find_common_fields(activeConnections, {TCP_HOST,TCP_PORT}, {host, port})
    if length(s) then
      cnx = s[1]
      buffer = activeConnections[cnx][BUFFER]
      activeConnections[cnx] = {host, port, tcpSocket, CONNECTED, time(), buffer, 0, #0, "", 0}
      linearBuffers[buffer] = ""
    else
      linearBuffers = append(linearBuffers, {})
      activeConnections = append(activeConnections, {host, port, tcpSocket, CONNECTED, time(), length(linearBuffers), 0, #0, "", 0})
      cnx = length(activeConnections)
    end if
    activeSockets = get_active_sockets()
  end if
  return cnx
end function

------------------------------------------------------------------------------

public function telnet_read(integer cnx, atom wait_time=0.1)
--<function>
--<name>telnet_read</name>
--<digest>checks connections and reads data</digest>
--<desc>
--</desc>
--<param>
--<type>integer</type>
--<name>cnx</name>
--<desc>connection id</desc>
--</param>
--<param>
--<type>atom</type>
--<name>wait_time</name>
--<desc>
-- time to wait for data in seconds: defaults to 0.1s
--</desc>
--</param>
--<return>
--</return>
--<example>
-- data = telnet_read(cnx)
-- data = telnet_read(cnx, 3)
--</example>
--<see_also>telnet_send()</see_also>
--</function>
  sequence data
  atom t0

--  log_printf("telnet_read(%d, %.3f)", {cnx,wait_time})
  if not check_link(cnx) then return 0 end if
  t0 = time()
  while (time() - t0) <= wait_time do
    check_connections()
    pause(0.01)
  end while
  data = linearBuffers[activeConnections[cnx][BUFFER]]
  linearBuffers[activeConnections[cnx][BUFFER]] = ""
  return data
end function

------------------------------------------------------------------------------

public function read_until(integer cnx, sequence invite, sequence optional)
--<function>
--<name>read_until</name>
--<digest>read until specified invite</digest>
--<desc>
-- first read with telnet_read and a wait_time delay
-- repeat until max_time is reached or invite has been received
-- if login_invite is received, stop reading
--</desc>
--<param>
--<type>integer</type>
--<name>cnx</name>
--<desc>connection id</desc>
--</param>
--<param>
--<type>sequence</type>
--<name>invite</name>
--<desc>current invite that ends all received data</desc>
--</param>
--<param>
--<type>sequence</type>
--<name>optional</name>
--<desc>
-- optional "other" is a list of invites that may happen in timeout or abnormal conditions: defaults to {"login:"}
-- optional "wait_time" is time to wait between two data checks: defaults to 0.1s
-- optional "max_time" is maximal delay to wait for expected data: defaults to 3s
-- optional "debug_mode" defaults to 0. When set won't wait for an invite, waits for a timeout
-- in debug mode most devices send lots of data on the flow and expected invite can be splitted by debug data
--</desc>
--</param>
--<return>
--</return>
--<example>
-- puts(1, read_until(cnx, "password:", {})
--</example>
--<see_also>telnet_send(), read_all()</see_also>
--</function>
  sequence read, s
  atom t0
  object data
  sequence other
  atom wait_time
  integer max_time, debug_mode

  other = get_option("other", optional, "login:")
  wait_time = get_option("wait_time", optional, 0.1)
  max_time = get_option("max_time", optional, 3)
  debug_mode = get_option("debug_mode", optional, 0)
  log_printf("read_until(%d, '%s', '%s', %.3f, %d)\n", {cnx, invite, object_dump(other), wait_time, max_time})
  if length(invite)=0 then
    log_puts("read_until: actual invite missing !\n")
    return 0
  end if
  t0 = time()
  read = ""
  while 1 do
    data = telnet_read(cnx, wait_time)
    if atom(data) then return 0 end if
    if length(data) then
      read &= data
--      analyze_object(read, sprintf("read_until(%d): read", {cnx}), f_debug)
      if match(invite, read) then
        return read
      elsif length(other) then
        if match_any(other, read) then exit end if
      end if
      if debug_mode then	-- en mode debug, pas d'invite sans retour chariot
        if time()-t0 > 20 then -- toutes les 20 secondes
          void = telnet_send(cnx, "\n")
          t0 = time()
        end if
      end if
    end if
    if (max_time != -1) and ( (time()-t0) > max_time ) then
      log_printf("read_until(%d): max_time exceeded\n", {cnx})
      exit
    end if
  end while
  if length(data) then
    analyze_object(data, sprintf("read_until(%d)\n", {cnx}), f_debug)
  end if
  log_printf("read_until: failed to read '%s'\n", {invite})
  return 0
end function

------------------------------------------------------------------------------

public function read_all(integer cnx, atom wait_time=0.1, integer max_time=3)
--<function>
--<name>read_all</name>
--<digest></digest>
--<desc>
-- first read with telnet_read and a wait_time delay
-- if nothing received, try more until max_time is reached if max_time is an
--   integer or max_time[1] (maxWaitTime) if max_time is a sequence
-- if something received, read more until max_time is reached if max_time is an
--   integer or max_time[1] (maxWaitTime) if max_time is a sequence
--   stop immediatly if nothing more received
--</desc>
--<param>
--<type>integer</type>
--<name>cnx</name>
--<desc>connection id</desc>
--</param>
--<param>
--<type>atom</type>
--<name>wait_time</name>
--<desc>
-- time to wait between two data checks: defaults to 0.1s
--</desc>
--</param>
--<param>
--<type>integer</type>
--<name>max_time</name>
--<desc>
-- maximal delay to wait for expected data: defaults to 3s
--</desc>
--</param>
--<return>
--</return>
--<example>
-- puts(1, read_all(cnx))
--</example>
--<see_also>telnet_send(), read_until()</see_also>
--</function>
  sequence read
  atom t0
  object data
  integer flagReceiving

  log_printf("read_all(%d, %.3f, %s)\n", {cnx, wait_time, sprint(max_time)})
  t0 = time()
  read = ""
  flagReceiving = 0
  while 1 do
    data = telnet_read(cnx, wait_time)
    if atom(data) then return 0 end if
    if length(data) then
      read &= data
--      analyze_object(read, sprintf("read_all(%d): read", {cnx}), f_debug)
      if not flagReceiving and sequence(max_time) then
        t0 = time()
      end if
      flagReceiving = 1
      if atom(max_time) then
        if (max_time != -1) and ( (time()-t0) > max_time ) then
          log_printf("read_all(%d): max_time exceeded\n", cnx)
          exit
        end if
      else
        if (time()-t0) > max_time[2] then
          log_printf("read_all(%d): maxReadTime exceeded\n", cnx)
          exit
        end if
      end if
    else
      if not flagReceiving then
        if atom(max_time) then
          if (max_time != -1) and ( (time()-t0) > max_time ) then
            log_printf("read_all(%d): max_time exceeded\n", cnx)
            exit
          end if
        else
          if (time()-t0) > max_time[1] then
            log_printf("read_all(%d): maxWaitTime exceeded\n", cnx)
            exit
          end if
        end if
      else  --  got something previously but nothing more: stop immediatly
        exit
      end if
    end if
  end while
  return read
end function

------------------------------------------------------------------------------

public function send_receive(integer cnx, sequence cmd, sequence invite, sequence optional)
--<function>
--<name>send_receive</name>
--<digest>send a Telnet command and awaits an answer</digest>
--<desc>
--</desc>
--<param>
--<type>integer</type>
--<name>cnx</name>
--<desc></desc>
--</param>
--<param>
--<type>sequence</type>
--<name>cmd</name>
--<desc></desc>
--</param>
--<param>
--<type>sequence</type>
--<name>invite</name>
--<desc></desc>
--</param>
--<param>
--<type>sequence</type>
--<name>optional</name>
--<desc>
-- optional "login_invite" is invite to log in (when connection lost after idle timeout): defaults to "login:"
-- optional "wait_time" is time to wait between two data checks: defaults to 0.1s
-- optional "max_time" is maximal delay to wait for expected data: defaults to 3s
-- optional "debug_mode" defaults to 0. When set won't wait for an invite, waits for a timeout
-- in debug mode most devices send lots of data on the flow and expected invite can be splitted by debug data
--</desc>
--</param>
--<return>
--</return>
--<example>
-- void = sendReceive(cnx, "exit\r\n", "login:", {})
--</example>
--<see_also>
--</see_also>
--</function>
  sequence login_invite
  atom wait_time
  integer max_time, debug_mode

  login_invite = get_option("login_invite", optional, "login:")
  wait_time = get_option("wait_time", optional, 0.1)
  max_time = get_option("max_time", optional, 3)
  debug_mode = get_option("debug_mode", optional, 0)
  -- log_printf("send_receive(%d, '%s', '%s', '%s', %.3f, %d)\n",{cnx, show_printable(cmd), invite, login_invite, wait_time, max_time})
  if not check_link(cnx) then return 0 end if
  if telnet_send(cnx, cmd) < 0 then return 0 end if
  return read_until(cnx, invite, {
    {"login_invite", login_invite},
    {"wait_time", wait_time},
    {"max_time", max_time},
    {"debug_mode", debug_mode}
  })
end function

