include lib/_debug_.e
include lib/_telnet_.e
include lib/Sockets.ew
include std/os.e
include std/console.e

integer cnx
cnx = 0

  f_debug = open(InitialDir&"\\debug.log", "w")

  if WSAStartup() = SOCKET_ERROR then -- must be called before using Winsock API
    error_message("Failed WSAStartup()", 1)
  end if

  cnx = telnet_connect("192.168.1.250", 23)
  if not cnx then
    void = WSACleanup()
    error_message("Could not connect to 192.168.1.250:23", 1)
  end if
  puts(1, read_all(cnx))

  void = telnet_send(cnx, "admin\r\n")
  puts(1, read_until(cnx, "Password:", "login as:"))

  void = telnet_send(cnx, "admin\r\n")
  sleep(2)
  puts(1, read_all(cnx))

  void = telnet_send(cnx, "exit\r\n")
  puts(1, read_all(cnx))

  telnet_close(cnx)
  void = WSACleanup()
  close(f_debug)

