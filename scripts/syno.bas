include get
include misc
include telnet

cnx = telnet_connect("192.168.1.250", 23)
s = read_all(cnx, 0.1, 3)
print s
s = send_receive(cnx, "admin\n", ":", {})
print s
s = send_receive(cnx, "admin\n", "$", {})
print s
s = send_receive(cnx, "ls -l\n", "$", {})
print s

sleep(2)

void = telnet_send(cnx, "exit")
end
