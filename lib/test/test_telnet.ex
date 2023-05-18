-------------------------------------------------------------------------------
-- SockDemo.exw
--
-- Author:  Brett A. Pantalone
--          pantalone2001@yahoo.com
--
-- Description:
--     The obligatory "chat" demo to illustrate the Euphoria Sockets library.
--
-- How to use:
--     The purpose of this program is to demonstrate the use of sockets in
--     Euphoria. Start at least two separate instances of this program, either
--     on different networked computers or all on the same localhost. In one
--     of the instances, enter the address and port of another instance (the
--     listening port is shown on its title bar) and click the "Connect" button.
--     You can experiment to determine the Windows socket behavior under 
--     different circumstances.
--
-- License: Copyright (C) 2005 Brett A. Pantalone
--
--     This software is released into the public domain.  You are free to use 
--     it in any way you like, except that you may not sell this source code.
--
--     This program is distributed in the hope that it will be useful,
--     but WITHOUT ANY WARRANTY; without even the implied warranty of
--     MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
--     GNU General Public License for more details.
--
-------------------------------------------------------------------------------

include std/text.e
include lib/_debug_.e
include lib/_telnet_.e
include lib/Sockets.ew
include lib/WSErrors.ew
include win32lib.ew
without warning

constant 
  Win1  = create (Window, "SockDemo", 0, Default, Default, 350, 300, 0)
, Text1 = create (LText, "Host Address", Win1, 16, 16, 120, 20, 0)
, Text2 = create (LText, "Port", Win1, 176, 16, 48, 20, 0)
, Edit1 = create (EditText, "127.0.0.1", Win1, 16, 36, 152, 24, 0)
, Edit2 = create (EditText, "", Win1, 176, 36, 48, 24, 0)
, Edit3 = create (EditText, "", Win1, 16, 236, 216, 24, 0)
, Btn1  = create (PushButton, "Connect", Win1, 244, 36, 80, 24, 0)
, Btn2  = create (PushButton, "Send", Win1, 244, 236, 80, 24, 0)
, Console = create (RichEdit, "", Win1, 16, 80, 308, 148, ES_NOHIDESEL)
    setReadOnly (Console, w32True)

constant TIMER = 1, MAXLEN = 1000
constant DISCONNECTED = 0, LISTEN = 1, CONNECTED = 2
atom hSockListen, hSockConnect, State

-------------------------------------------------------------------------------
procedure gotoStateListen ()
    sequence Address
    integer Port
  log_puts("gotoStateListen\n")
    -- Get the port that is bound to the socket
    Address = getsockname (activeConnections[hSockListen][TCP_SOCKET])
    Port = Address[4] + Address[3] * 256
    setText (Win1, "Listen:" & sprint (Port))
    setFont (Console, {Black,"Arial"}, 10, Bold)
    appendText (Console, "Listening on Port " & sprint (Port) & "\r\n")
    if getNumber (Edit2) = 0 then setText (Edit2, Port+1) end if
    State = LISTEN
end procedure

-------------------------------------------------------------------------------
procedure gotoStateConnect (sequence Message)
    sequence Address
    integer Port
  log_puts("gotoStateConnect\n")
    Address = getsockname (activeConnections[hSockConnect][TCP_SOCKET])
    Port = Address[4] + Address[3] * 256
    setText (Win1, "Connected:" & sprint (Port))
    setFont (Console, {Black,"Arial"}, 10, Bold)
    appendText (Console, Message)
    setText (Btn1, "Disconnect")
    setEnable (Edit1, w32False)
    setEnable (Edit2, w32False)
    setEnable (Edit3, w32True)
    setEnable (Btn2, w32True)
    setFocus (Edit3)
    State = CONNECTED
end procedure

-------------------------------------------------------------------------------
procedure gotoStateDisconnect (sequence Message)
  log_puts("gotoStateDisconnect\n")
    setText (Win1, "Disconnected")
    setFont (Console, {Black,"Arial"}, 10, Bold)
    appendText (Console, Message)
    setText (Btn1, "Connect")
    setEnable (Edit1, w32True)
    setEnable (Edit2, w32True)
    setEnable (Edit3, w32False)
    setEnable (Btn2, w32False)
    State = DISCONNECTED
end procedure

-------------------------------------------------------------------------------
procedure createListeningSocket()
    sequence Address

  log_puts("createListeningSocket\n")
    if hSockListen > 0 then
        -- Already listening; reuse the existing socket
        gotoStateListen()
        return 
    end if

    hSockListen = telnet_listen(0) -- let windows choose the port
    if hSockListen then
      gotoStateListen()
      return
    end if

    handle_error()
    closeWindow (Win1)
end procedure

-------------------------------------------------------------------------------
procedure checkPendingConnections()
    sequence result

--  log_puts("checkPendingConnections\n")
    -- Check for pending connections on the listening socket
    result = select ({activeConnections[hSockListen][TCP_SOCKET]},{},{},{0,0})
    if result[1] = 0 then return -- nothing waiting
    elsif result[1] > 0 and find (activeConnections[hSockListen][TCP_SOCKET], result[2]) then
    -- The find() is redundant, since there was only one socket requested
    -- in the call to select(). Even if there is activity on other sockets,
    -- only information about hSockListen will be returned.

        -- Accept the waiting connection.
        -- This returns a new socket, already connected to the remote peer.
        hSockConnect = telnet_accept (hSockListen)
        if hSockConnect then
            gotoStateConnect ("Connected as Host\r\n")
            return
        end if
    end if 

    handle_error()
    closeWindow (Win1)
end procedure

-------------------------------------------------------------------------------
procedure checkReceiveBuffer()
    sequence result

--  log_puts("checkReceiveBuffer\n")
    -- Check for data waiting in the receive buffer
    result = select ({activeConnections[hSockConnect][TCP_SOCKET]},{},{},{0,0})
    if result[1] = 0 then return -- no data received
    elsif result[1] > 0 and find (activeConnections[hSockConnect][TCP_SOCKET], result[2]) then

        -- Fetch the received data
        result = telnet_read(hSockConnect)
        if activeConnections[hSockConnect][TCP_STATUS] = DISCONNECTED then -- indicates the connection was closed
            telnet_close(hSockConnect)
            gotoStateDisconnect ("Connection Closed by Peer\r\n")
            return
        elsif length(result) then -- number of bytes received
            setFont (Console, {Red,"Arial"}, 10, Normal)
            appendText (Console, result & "\r\n")
            return
        end if

    end if

    handle_error()
    telnet_close(hSockConnect)
    gotoStateDisconnect ("Receive Error; Connection Closed\r\n")
end procedure

-------------------------------------------------------------------------------
procedure onConnect (integer self, integer event, sequence params)
-- User has clicked the '(Dis)Connect' button. Attempt an outgoing connection 
-- to a remote server, or close the connection if one already exists.
    object Address
    sequence Host
    integer Port

  log_puts("onConnect\n")
    if State = CONNECTED then
        -- Disconnect the existing socket
        telnet_close(hSockConnect)
        gotoStateDisconnect ("Connection Terminated by User\r\n")
        return
    end if

        Host = getText (Edit1)
        Port = getNumber (Edit2)
    -- Create a stream (TCP) socket
    hSockConnect = telnet_connect(Host, Port)
    if hSockConnect then
      gotoStateConnect ("Connected as Client\r\n")
      return
    end if

    handle_error()
    telnet_close(hSockConnect)
    gotoStateDisconnect ("Connect Error; Connection Aborted\r\n")
end procedure
setHandler (Btn1, w32HClick, routine_id("onConnect"))

-------------------------------------------------------------------------------
procedure onSend (integer self, integer event, sequence params)
-- User has clicked the 'Send' button. Send edit box text to the remote peer.
    sequence Text
  log_puts("onSend\n")
    Text = getText (Edit3)
    if not equal (Text,"") then
        if telnet_send (hSockConnect, Text) then
            setText (Edit3,"")
            setFont (Console, {Blue,"Arial"}, 10, Normal)
            appendText (Console, Text & "\r\n")
            setFocus (Edit3)
            return
        end if
    end if
    handle_error()
end procedure
setHandler (Btn2, w32HClick, routine_id ("onSend"))

-------------------------------------------------------------------------------
procedure onReturnKey (integer self, integer event, sequence params)
-- If user types 'return' click the send button and keep focus
--  log_puts("onReturnKey\n")
    if getFocus() = Edit3 and params[1] = VK_RETURN and params[2] = 0 then
        VOID = invokeHandler (Btn2, w32HClick, {})
        returnValue (-1)
    end if
end procedure
setHandler (Edit3, w32HKeyPress, routine_id ("onReturnKey"))

-------------------------------------------------------------------------------
procedure onClose (integer self, integer event, sequence params)
  log_puts("onClose\n")
-- Do some last-minute cleanup when the program is terminated
    killTimer (Win1, TIMER)
    telnet_close(hSockListen)
    telnet_close(hSockConnect)
    VOID = WSACleanup()
end procedure
setHandler (Win1, w32HClose, routine_id("onClose"))

-------------------------------------------------------------------------------
procedure onTimeout (integer self, integer event, sequence params)
-- This handler is called every 100 ms. This allows us to use non-blocking
-- send & receive calls, while avoiding a CPU-intensive while(1) control loop.
--  log_puts("onTimeout\n")
    if params[1] = TIMER then
        killTimer (Win1, TIMER) -- Prevent reentry
        if State = LISTEN then
            checkPendingConnections()
        elsif State = CONNECTED then
            checkReceiveBuffer()
        end if
        setTimer (Win1, TIMER, 100) -- Restart the timer
    end if
end procedure
setHandler (Win1, w32HTimer, routine_id ("onTimeout"))

-------------------------------------------------------------------------------
if WSAStartup() = SOCKET_ERROR then -- must be called before using Winsock API
    VOID = message_box ("Failed WSAStartup()", "Winsock Error", MB_OK)
    abort (1)
end if

f_debug = open("debug.log", "w")
hSockListen = 0
hSockConnect = 0
gotoStateDisconnect ("")
createListeningSocket()
setTimer (Win1, TIMER, 100)
WinMain (Win1, Normal)
close(f_debug)

