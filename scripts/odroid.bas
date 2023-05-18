include get
include misc
include webdriver
include ssh2

sessionId = wd_new_session(0)
wd_set_implicit_wait(sessionId, 5)
ok = wd_change_url(sessionId, "http://192.168.1.40:5000/login")
if not ok then
  end
end if

element = wd_search_element(sessionId, "id", "inputUsername")
wd_set_element(sessionId, element, "admin")

element = wd_search_element(sessionId, "id", "inputPassword")
wd_set_element(sessionId, element, "admin")

element = wd_search_element(sessionId, "class name", "form-signin")
wd_submit_form(sessionId, element)

sleep(5)

span = wd_search_element(sessionId, "class name", "span9")
element = wd_search_element_from(sessionId, span, "link text", "ubuntu1")
wd_click_element(sessionId, element)

sleep(10)

element = wd_search_element(sessionId, "link text", "Start")
wd_click_element(sessionId, element)

sleep(15)

element = wd_search_element(sessionId, "link text", "Freeze")
wd_click_element(sessionId, element)

sleep(5)

element = wd_search_element(sessionId, "link text", "Start")
wd_click_element(sessionId, element)

sleep(5)

cnx = ssh_connect("192.168.1.41", 22, "ubuntu", "ubuntu")

ssh_exec(cnx, "uname -a", 1)
s = get_buffer(cnx)
print s
clean_buffer(cnx)

ssh_exec(cnx, "ls -l", 1)
s = get_buffer(cnx)
print s
clean_buffer(cnx)

sleep(5)

ssh_close(cnx)
ssh_exit()

element = wd_search_element(sessionId, "link text", "Stop")
wd_click_element(sessionId, element)

sleep(5)

element = wd_search_element(sessionId, "link text", "Logout (admin)")
wd_click_element(sessionId, element)

sleep(2)

wd_delete_session(sessionId)

print "Press a key ..."
ok = wait_key()

end
