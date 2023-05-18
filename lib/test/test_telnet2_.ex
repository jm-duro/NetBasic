--****
-- === telnet_server.ex
--
-- socket example that shows off using non-blocking sockets and a multi-user server
-- w/no threads needed.

include std/filesys.e
include std/socket.e
include std/text.e
include lib/_debug_.e
include lib/_telnet2_.e

integer fsm_state
fsm_state = DISCONNECTED

--------------------------------------------------------------------------------

function fsm_change_state(integer n, object event)
  if activeConnections[n][TELNET_STATE] = DISCONNECTED then
  elsif activeConnections[n][TELNET_STATE] = CONNECTED then
  elsif activeConnections[n][TELNET_STATE] = IDENTIFIED then
  elsif activeConnections[n][TELNET_STATE] = AUTHENTICATED then
  end if
  return 0
end function

--------------------------------------------------------------------------------

procedure manage_connection(integer n)
  object data
  integer p
  sequence s
  
  log_printf("manage_connection(%d)\n", {n})
  log_printf("TELNET_STATE = %d\n", {activeConnections[n][TELNET_STATE]})
  data = get_buffer(n)
  if atom(data) then return end if
  printf(1, "Client %d sent '%s' (%s)\n", { n, trim(data), sprint(data) })
  p = match("\r\n", data)
  log_printf("p = %d\n", {p})
  if p = 0 then return end if
  if activeConnections[n][TELNET_STATE] = DISCONNECTED then
    return
  elsif activeConnections[n][TELNET_STATE] = CONNECTED then
    if p > 1 then
      activeConnections[n][TELNET_LOGIN] = data[1..p-1]
      activeConnections[n][TELNET_STATE] = IDENTIFIED
      void = telnet_send(n, "Password:")
      log_puts("Identified as '" & activeConnections[n][TELNET_LOGIN] & "'\r\n")
    end if
  elsif activeConnections[n][TELNET_STATE] = IDENTIFIED then
    if p > 1 then
      s = data[1..p-1]
    else 
      s = ""
    end if
    if equal(activeConnections[n][TELNET_LOGIN], "admin") and
       equal(s, "admin") then
      activeConnections[n][TELNET_STATE] = AUTHENTICATED
      void = telnet_send(n, "Fake_LBB>")
    else
      activeConnections[n][TELNET_STATE] = CONNECTED
    end if  
  elsif activeConnections[n][TELNET_STATE] = AUTHENTICATED then
    if p > 1 then
      s = data[1..p-1]  -- command
      if equal(s, "exit") then
        telnet_close(n)
      else  -- manage command
        -- TODO
        void = telnet_send(n, "Fake_LBB>")
      end if
    end if
  end if
  data = remove(data, 1, p+1)
  void = set_buffer(n, data)
end procedure

--------------------------------------------------------------------------------

  integer listen_port, cnx
  sequence remove_sockets, active_sockets
  object sock_data
  sockets:socket server

  listen_port = 23
  cnx = 0
  remove_sockets = {}
  active_sockets = {}
  f_debug = open(InitialDir & SLASH & "debug.log", "w")
  with_debug = 1
  
  server = sock_bind(listen_port)
  if atom(server) then abort(1) end if

  printf(1, "Waiting for connections on port %d\n", { listen_port })
  while sockets:listen(server, 10) = 0 do    -- 10 connections max
    -- get socket states
    sock_data = sockets:select({ server }, {}, {}, 0, 0)
    if length(sock_data) then
      -- check for new incoming connects on server socket
      if sock_data[1][SELECT_IS_READABLE] then
        cnx = telnet_accept(server)
        void = telnet_send(cnx, "Username:")
        printf(1, "Connection from %d (client count now %d)\n",  { activeConnections[cnx][TCP_SOCKET], length(activeConnections) })
      end if
    end if

    -- check for any activity on the client sockets
    active_sockets = check_all_connections()
    for n = 1 to length(active_sockets) do
      manage_connection(n)
    end for
  end while

  void = sockets:close(server)
  puts(1, "Server closed\n")
  close(f_debug)
