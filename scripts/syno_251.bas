include get
include misc
include webdriver

sessionId = wd_new_session(0)
wd_set_implicit_wait(sessionId, 5)
ok = wd_change_url(sessionId, "http://192.168.1.251/phpMyAdmin/")
if not ok then
  end
end if

element = wd_search_element(sessionId, "id", "sel-lang")
wd_set_element(sessionId, element, "Fran")  -- "Français - French"

element = wd_search_element(sessionId, "id", "input_username")
wd_clear_element(sessionId, element)
wd_set_element(sessionId, element, "root")

element = wd_search_element(sessionId, "id", "input_password")
wd_clear_element(sessionId, element)
wd_set_element(sessionId, element, "Zero1:sde1")

element = wd_search_element(sessionId, "id", "input_go")
wd_click_element(sessionId, element)

sleep(2)
-- print HTTP_STATUS
-- print HTTP_URL
-- print HTTP_HEADERS
-- print HTTP_BODY
-- take_screenshot "clients.png"

element = wd_search_element(sessionId, "link text", "Modifier le mot de passe")
wd_click_element(sessionId, element)

sleep(2)

wd_delete_session(sessionId)

print "Press a key ..."
ok = wait_key()

end
