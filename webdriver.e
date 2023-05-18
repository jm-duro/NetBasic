include std/filesys.e
include std/dll.e
include std/convert.e
include std/search.e
include std/io.e
include std/base64.e
include lib/_debug_.e
include lib/_conv_.e
include lib/_search_.e
include lib/_sequence_.e
include lib/_curl_constants_.e
include lib/_curl_.e
include lib/_http_.e
include lib/_json_.e
include lib/_file_.e

-- Command descriptions are from:
-- https:--code.google.com/p/selenium/wiki/JsonWireProtocol

-- chromedriver --log-path=chromedriver.log [--verbose]

-- java -jar selenium-server-standalone-3.4.0.jar

constant
  -- CHROME_DRIVER = "http://192.168.1.254:32769/wd/hub"
  CHROME_DRIVER = "http://127.0.0.1:4444/wd/hub"
  -- CHROME_DRIVER = "http://127.0.0.1:9515"

-- constant
--   HTTP_GET=1, HTTP_POST=2, HTTP_DELETE=3

public constant WD_ERRORS = {
  { 6, "A session is either terminated or not started"},
  { 7, "An element could not be located on the page using the given search parameters."},
  { 8, "A request to switch to a frame could not be satisfied because the frame could not be found."},
  { 9, "The requested resource could not be found, or a request was received using an HTTP method that is not supported by the mapped resource."},
  {10, "An element command failed because the referenced element is no longer attached to the DOM."},
  {11, "An element command could not be completed because the element is not visible on the page."},
  {12, "An element command could not be completed because the element is in an invalid state (e.g. attempting to click a disabled element)."},
  {13, "An unknown server-side error occurred while processing the command."},
  {15, "An attempt was made to select an element that cannot be selected."},
  {17, "An error occurred while executing user supplied JavaScript."},
  {19, "An error occurred while searching for an element by XPath."},
  {21, "An operation did not complete before its timeout expired."},
  {23, "A request to switch to a different window could not be satisfied because the window could not be found."},
  {24, "An illegal attempt was made to set a cookie under a different domain than the current page."},
  {25, "A request to set a cookie's value could not be satisfied."},
  {26, "A modal dialog was open, blocking this operation."},
  {27, "An attempt was made to operate on a modal dialog when one was not open."},
  {28, "A script did not complete before its timeout expired."},
  {29, "The coordinates provided to an interactions operation are invalid."},
  {30, "IME was not available."},
  {31, "An IME engine could not be started."},
  {32, "Argument was an invalid selector (e.g. XPath/CSS)."},
  {33, "A new session could not be created."},
  {34, "Target provided for a move action is out of bounds"}
}

sequence wd_commands

public integer http_status
http_status = 0

public sequence
  http_url, http_headers, http_body
http_url = ""
http_headers = {}
http_body = ""

--------------------------------------------------------------------------------

type MouseButton(integer n)
  return (n >= 0) and (n <= 2)
end type

-- constant
--   LEFT_BUTTON   = 0,
--   MIDDLE_BUTTON = 1,
--   RIGHT_BUTTON  = 2

-- type Cookie struct {
--   Name   string
--   Value  string
--   Path   string
--   Domain string
--   Secure bool
--   Expiry int
-- }

-- type GeoLocation struct {
--   Latitude  float64 `json:"latitude"`
--   Longitude float64 `json:"longitude"`
--   Altitude  float64 `json:"altitude"`
-- }

-- HTML5CacheStatus

type HTML5CacheStatus(integer n)
  return (n>=0) and (n <= 5)
end type

-- constant
--   CACHE_STATUS_UNCACHED     = 0,
--   CACHE_STATUS_IDLE         = 1,
--   CACHE_STATUS_CHECKING     = 2,
--   CACHE_STATUS_DOWNLOADING  = 3,
--   CACHE_STATUS_UPDATE_READY = 4,
--   CACHE_STATUS_OBSOLETE     = 5

-- LogLevel

type LogLevel(sequence s)
  return find(s, {"ALL", "DEBUG", "INFO", "WARNING", "SEVERE", "OFF"})
end type

-- type LogEntry struct {
--   TimeStamp int --TODO timestamp number type?
--   Level     string
--   Message   string
-- }

-- FindElementStrategy

type FindElementStrategy(sequence s)
  return find(s, {"class name", "css selector", "id", "name", "link text",
                  "partial link text", "tag name", "xpath"})
end type

-- Search for an element on the page, starting from the document root.
-- using:
-- class name         Returns an element whose class name contains the search
--                    value; compound class names are not permitted.
-- css selector       Returns an element matching a CSS selector.
--
-- id                 Returns an element whose ID attribute matches the search
--                    value.
-- name               Returns an element whose NAME attribute matches the search
--                    value.
-- link text          Returns an anchor element whose visible text matches the
--                    search value.
-- partial link text  Returns an anchor element whose visible text partially
--                    matches the search value.
-- tag name           Returns an element whose tag name matches the search
--                    value.
-- xpath              Returns an element matching an XPath expression.

-- type Size struct {
--   width  int
--   height int
-- }

-- type Position struct {
--   X int
--   Y int
-- }

--------------------------------------------------------------------------------

atom curl
curl = NULL

--------------------------------------------------------------------------------

-- Take a screenshot of the current page.
public function wd_take_screenshot(sequence sessionId)
  object res
  sequence img, request

  request = sprintf("/session/%s/screenshot", {sessionId})
  res = curl_get(curl, CHROME_DRIVER & request)
  img = get_json_value("value", json_to_sequence(res[HTTP_BODY]), 0)
  return decode(img)
end function

--------------------------------------------------------------------------------

-- Get the current page source.
public function wd_get_page_source(sequence sessionId)
  object res
  sequence s, request

  request = sprintf("/session/%s/source", {sessionId})
  res = curl_get(curl, CHROME_DRIVER & request)
  s = get_json_value("value", json_to_sequence(res[HTTP_BODY]), 0)
  -- analyze_object(s, "s", f_debug)
  s = replace_all(s, "\\u003C", "<")
  s = replace_all(s, "\\u003E", ">")
  return unescape(s)
end function

--------------------------------------------------------------------------------

procedure check_status(sequence res, sequence command,
                       sequence params, sequence data)
  integer status
  sequence msg, img, sessionId, html

  log_puts("check_status()\n")
  if (res[HTTP_STATUS] != 200) then
    sessionId = params[1]
    error_message(command & " " & object_dump(data) & ":\n\n" &
                  "bad HTTP status: " & to_string(res[HTTP_STATUS]), 0)
    img = wd_take_screenshot(sessionId)
    write_file(InitialDir & SLASH & "debug" & SLASH & "error.png", img)
    html = wd_get_page_source(sessionId)
    write_file(InitialDir & SLASH & "debug" & SLASH & "error.html", html)
    if length(sessionId) then
      res = curl_delete(curl, CHROME_DRIVER & "/session/" & sessionId)
    end if
    curl_easy_cleanup(curl)
    curl_global_cleanup()
    close(f_debug)
    abort(1)
  end if
  status = get_json_value("status", json_to_sequence(res[HTTP_BODY]), 0)
  if status then
    msg = get_json_value("value", json_to_sequence(res[HTTP_BODY]), 0)
    analyze_object(msg, "msg", f_debug)
    error_message(command & " " & object_dump(data) & ":\n\n" &
                  vlookup(status, WD_ERRORS, 1, 2, {{"default","?"}}) & "\n\n" &
                  msg[1][2], 0)
    if length(params) then
      sessionId = params[1]
      img = wd_take_screenshot(sessionId)
      write_file(InitialDir & SLASH & "debug" & SLASH & "error.png", img)
      html = wd_get_page_source(sessionId)
      write_file(InitialDir & SLASH & "debug" & SLASH & "error.html", html)
      void = curl_delete(curl, CHROME_DRIVER & "/session/" & sessionId)
    end if
    curl_easy_cleanup(curl)
    curl_global_cleanup()
    close(f_debug)
    abort(1)
  end if
end procedure

------------------------------------------------------------------------------

function wd_execute(sequence command, sequence params, sequence data)
  sequence s, request, body
  object res

  log_printf("wd_execute(%s, %s, %s)\n", {command, object_dump(params),
                                          object_dump(data)})
  if not curl then
    error_message("Initialize curl first!\n", 0)
    close(f_debug)
    abort(1)
  end if
  s = find_in_array(command, wd_commands, {{"target_field", -1}})
  if length(s) =0 then return 0 end if
  request = sprintf(s[3], params)
  res = 0
  if equal(s[2], "GET") then
    res = curl_get(curl, CHROME_DRIVER & request)
  elsif equal(s[2], "POST") then
    body = sprintf(s[4], data)
    analyze_object(body, "body", f_debug)
    res = curl_post(curl, CHROME_DRIVER & request, body)
  elsif equal(s[2], "DELETE") then
    res = curl_delete(curl, CHROME_DRIVER & request)
  end if
  check_status(res, command, params, data)
  return res
end function

--------------------------------------------------------------------------------

function string_to_list(sequence s)
  sequence result

  result = "[\"" & s[1] & "\""
  for i = 2 to length(s) do
    result &= ", \"" & s[i] & "\""
  end for
  return result & "]"
end function

--------------------------------------------------------------------------------

-- Initializes CURL and sets proxy
-- set proxy to NULL if unused
public procedure wd_init(object proxy)
  object res

  log_puts("wd_init()\n")
  wd_commands = read_csv(InitialDir & SLASH & "wd_commands.csv", 1)
  analyze_object(wd_commands, "wd_commands", f_debug)
  res = curl_global_init(CURL_GLOBAL_DEFAULT)
  curl = curl_easy_init()
  if not curl then
    curl_easy_cleanup(curl)
    curl_global_cleanup()
    close(f_debug)
    abort(1)
  end if
  if sequence(proxy) then
    curl_easy_setopt(curl, CURLOPT_PROXYTYPE, CURLPROXY_HTTP)
    curl_easy_setopt(curl, CURLOPT_PROXY, proxy)
  end if
  curl_easy_setopt(curl, CURLOPT_COOKIEFILE, InitialDir & SLASH & "cookies.txt")
  curl_easy_setopt(curl, CURLOPT_COOKIEJAR, InitialDir & SLASH & "cookies.txt")
  curl_easy_setopt(curl, CURLOPT_VERBOSE, 1)
  curl_easy_setopt(curl, CURLOPT_FOLLOWLOCATION, 1)
  -- Connection: close for standalone server, keep-alive for chromedriver
  --  curl_easy_setopt(curl, CURLOPT_HTTPHEADER, "Connection: keep-alive")
  curl_easy_setopt(curl, CURLOPT_HTTPHEADER, "Connection: close")
  curl_easy_setopt(curl, CURLOPT_HTTPHEADER, "Accept: application/json")
  curl_easy_setopt(curl, CURLOPT_HTTPHEADER, "Content-Type: application/json; charset=UTF-8")
end procedure

--------------------------------------------------------------------------------

-- Starts a new Chrome session
-- chromedriver has to be run before using wd_new_session()
-- chromedriver --log-path=chromedriver.log [--verbose]
public function wd_new_session(object proxy)
  object res
  sequence capabilities, sessionId

  log_puts("wd_new_session()\n")
  if atom(proxy) then
    capabilities = "{" &
      " \"requiredCapabilities\": {}," &
      " \"desiredCapabilities\": {" &
        " \"platform\": \"ANY\"," &
        " \"browserName\": \"chrome\"," &
--        " \"takesScreenshot\": true," &
--        " \"javascriptEnabled\": true," &
        " \"version\": \"\"" &
      "}" &
    "}"
  else
    capabilities = "{" &
      " \"requiredCapabilities\": {}," &
      " \"desiredCapabilities\": {" &
        " \"platform\": \"ANY\"," &
        " \"browserName\": \"chrome\"," &
--        " \"takesScreenshot\": true," &
--        " \"javascriptEnabled\": true," &
        " \"version\": \"\"," &
        " \"proxy\": {" &
          " \"proxyType\": \"MANUAL\"," &
          " \"noProxy\": null," &
          " \"autodetect\": false," &
          " \"sslProxy\": \"" & proxy & "\"," &
          " \"httpProxy\": \"" & proxy & "\"," &
          " \"class\": \"org.openqa.selenium.Proxy\"," &
          " \"ftpProxy\": \"" & proxy & "\"" &
        "}" &
      "}" &
    "}"
  end if

  res = curl_post(curl, CHROME_DRIVER & "/session", capabilities)
  check_status(res, "wd_new_session", "", "")

  sessionId = get_json_value("sessionId", json_to_sequence(res[HTTP_BODY]), 0)
  log_printf("Session ID: %s\n", {sessionId})
  return sessionId
end function

--------------------------------------------------------------------------------

-- Final cleanup
public procedure wd_cleanup()
  curl_easy_cleanup(curl)
  curl_global_cleanup()
end procedure

--------------------------------------------------------------------------------

-- Accepts the currently displayed alert dialog.
public procedure wd_accept_alert(sequence sessionId)
  void = wd_execute("accept_alert", {sessionId}, {})
end procedure

--------------------------------------------------------------------------------

-- Set a cookie.
public procedure wd_add_cookie(sequence sessionId, sequence cookie)
  void = wd_execute("add_cookie", {sessionId}, {cookie})
end procedure

--------------------------------------------------------------------------------

-- Click and hold the left mouse button (set by moveto).
public procedure wd_button_down(sequence sessionId, MouseButton button)
  void = wd_execute("button_down", {sessionId}, {button})
end procedure

--------------------------------------------------------------------------------

-- Releases the mouse button previously held (set by moveto).
public procedure wd_button_up(sequence sessionId, MouseButton button)
  void = wd_execute("button_up", {sessionId}, {button})
end procedure

--------------------------------------------------------------------------------

-- Navigate to a new URL.
public function wd_change_url(sequence sessionId, sequence url)
  sequence res

  res = wd_execute("change_url", {sessionId}, {url})
  http_status  = res[1]
  http_url     =  res[2]
  http_headers = res[3]
  http_body    = res[4]
  return (http_status = 200)  -- HTTP OK
end function

--------------------------------------------------------------------------------

-- Clear a TEXTAREA or text INPUT element's value.
public procedure wd_clear_element(sequence sessionId, sequence id)
  void = wd_execute("clear_element", {sessionId, id}, {})
end procedure

--------------------------------------------------------------------------------

-- Click any mouse button (at the coordinates set by the last moveto command).
--
-- Note that calling this command after calling wd_button_down() and before
-- calling wd_button_up() (or any out-of-order interactions sequence) will
-- yield undefined behaviour).
public procedure wd_click(sequence sessionId, MouseButton button)
  void = wd_execute("click", {sessionId}, {button})
end procedure

--------------------------------------------------------------------------------

-- Click on an element.
public procedure wd_click_element(sequence sessionId, sequence id)
  void = wd_execute("click_element", {sessionId, id}, {})
end procedure

--------------------------------------------------------------------------------

-- Close the current window.
public procedure wd_close_current_window(sequence sessionId)
  void = wd_execute("close_current_window", {sessionId}, {})
end procedure

--------------------------------------------------------------------------------

-- Delete all cookies visible to the current page.
public procedure wd_delete_all_cookies(sequence sessionId)
  void = wd_execute("delete_all_cookies", {sessionId}, {})
end procedure

--------------------------------------------------------------------------------

-- Delete the cookie with the given name.
public procedure wd_delete_cookie_by_name(sequence sessionId, sequence name)
  void = wd_execute("delete_cookie_by_name", {sessionId, name}, {})
end procedure

--------------------------------------------------------------------------------

-- Delete the session.
public procedure wd_delete_session(sequence sessionId)
  if length(sessionId) then
    void = wd_execute("delete_session", {sessionId}, {})
  end if
end procedure

--------------------------------------------------------------------------------

-- Dismisses the currently displayed alert dialog.
public procedure wd_dismiss_alert(sequence sessionId)
  void = wd_execute("dismiss_alert", {sessionId}, {})
end procedure

--------------------------------------------------------------------------------

-- Double-clicks at the current mouse coordinates (set by moveto).
public procedure wd_double_click(sequence sessionId)
  void = wd_execute("double_click", {sessionId}, {})
end procedure

--------------------------------------------------------------------------------

-- Test if two element IDs refer to the same DOM element.
public function wd_element_equals(sequence sessionId, sequence id,
                                  sequence element)
  object res

  res = wd_execute("element_equals", {sessionId, id, element}, {})
  return get_json_value("value", json_to_sequence(res[HTTP_BODY]), 0)
end function

--------------------------------------------------------------------------------

-- Inject a snippet of JavaScript into the page for execution in the context of
-- the currently selected frame. The executed script is assumed to be
-- asynchronous and must signal that is done by invoking the provided callback,
-- which is always provided as the final argument to the function. The value to
-- this callback will be returned to the client.
-- Asynchronous script commands may not span page loads. If an unload event is
-- fired while waiting for a script result, an error should be returned to the
-- client.
-- The script argument defines the script to execute in teh form of a function
-- body. The function will be invoked with the provided args array and the
-- values may be accessed via the arguments object in the order specified. The
-- final argument will always be a callback function that must be invoked to
-- signal that the script has finished.
-- Arguments may be any JSON-primitive, array, or JSON object. JSON objects that
-- define a WebElement reference will be converted to the corresponding DOM
-- element. Likewise, any WebElements in the script result will be returned to
-- the client as WebElement JSON objects.
public function wd_execute_async_script(sequence sessionId,
                                        sequence script, sequence args)
  object res

  res = wd_execute("execute_async_script", {sessionId}, {script, args})
  return res
end function

--------------------------------------------------------------------------------

-- Inject a snippet of JavaScript into the page for execution in the context of
-- the currently selected frame. The executed script is assumed to be
-- synchronous and the result of evaluating the script is returned to the
-- client.
-- The script argument defines the script to execute in the form of a function
-- body. The value returned by that function will be returned to the client. The
-- function will be invoked with the provided args array and the values may be
-- accessed via the arguments object in the order specified.
-- Arguments may be any JSON-primitive, array, or JSON object. JSON objects that
-- define a WebElement reference will be converted to the corresponding DOM
-- element. Likewise, any WebElements in the script result will be returned to
-- the client as WebElement JSON objects.
public function wd_execute_script(sequence sessionId, sequence script,
                                  sequence args)
  object res

  res = wd_execute("execute_script", {sessionId}, {script, args})
  return res
end function

--------------------------------------------------------------------------------

-- Get the element on the page that currently has focus.
public function wd_get_active_element(sequence sessionId)
  object res

  res = wd_execute("get_active_element", {sessionId}, {})
  return get_json_value("ELEMENT", json_to_sequence(res[HTTP_BODY]), 0)
end function

--------------------------------------------------------------------------------

-- Gets the text of the currently displayed JavaScript alert(), confirm(),
-- or prompt() dialog.
public function wd_get_alert_text(sequence sessionId)
  object res

  res = wd_execute("get_alert_text", {sessionId}, {})
  return get_json_value("value", json_to_sequence(res[HTTP_BODY]), 0)
end function

--------------------------------------------------------------------------------

-- Retrieve all cookies visible to the current page.
public function wd_get_cookies(sequence sessionId)
  object res

  res = wd_execute("get_cookies", {sessionId}, {})
  return get_json_value("value", json_to_sequence(res[HTTP_BODY]), 0)
end function

--------------------------------------------------------------------------------

-- Query the value of an element's computed CSS property.
public function wd_get_css_property(sequence sessionId,  sequence id,
                                    sequence name)
  object res

  res = wd_execute("get_css_property", {sessionId, id, name}, {})
  return get_json_value("value", json_to_sequence(res[HTTP_BODY]), 0)
end function

--------------------------------------------------------------------------------

-- Describe the identified element. This command is reserved for future use;
-- its return type is currently undefined.
public function wd_get_element(sequence sessionId, sequence id)
  object res

  res = wd_execute("get_element", {sessionId, id}, {})
  return get_json_value("value", json_to_sequence(res[HTTP_BODY]), 0)
end function

--------------------------------------------------------------------------------

-- Get the value of an element's attribute.
public function wd_get_element_attribute(sequence sessionId, sequence id,
                                         sequence name)
  object res

  res = wd_execute("get_element_attribute", {sessionId, id, name}, {})
  return get_json_value("value", json_to_sequence(res[HTTP_BODY]), 0)
end function

--------------------------------------------------------------------------------

-- Determine an element's location on the page.
--The point (0, 0) refers to the upper-left corner of the page. The element's
-- coordinates are returned as a JSON object with x and y properties.
public function wd_get_element_location(sequence sessionId,      sequence id)
  object res

  res = wd_execute("get_element_location", {sessionId, id}, {})
  return get_json_value("value", json_to_sequence(res[HTTP_BODY]), 0)
end function

--------------------------------------------------------------------------------

-- Determine an element's location on the screen once it has been scrolled into
-- view.
-- Note: This is considered an internal command and should only be used to
-- determine an element's location for correctly generating native events.
public function wd_get_element_location_in_view(sequence sessionId, sequence id)
  object res

  res = wd_execute("get_element_location_in_view", {sessionId, id}, {})
  return get_json_value("value", json_to_sequence(res[HTTP_BODY]), 0)
end function

--------------------------------------------------------------------------------

-- Query for an element's tag name.
public function wd_get_element_name(sequence sessionId, sequence id)
  object res

  res = wd_execute("get_element_name", {sessionId, id}, {})
  return get_json_value("value", json_to_sequence(res[HTTP_BODY]), 0)
end function

--------------------------------------------------------------------------------

-- Determine an element's size in pixels.
public function wd_get_element_size(sequence sessionId, sequence id)
  object res

  res = wd_execute("get_element_size", {sessionId, id}, {})
  return get_json_value("value", json_to_sequence(res[HTTP_BODY]), 0)
end function

--------------------------------------------------------------------------------

-- Returns the visible text for the element.
public function wd_get_element_text(sequence sessionId,  sequence id)
  object res

  res = wd_execute("get_element_text", {sessionId, id}, {})
  return get_json_value("value", json_to_sequence(res[HTTP_BODY]), 0)
end function

--------------------------------------------------------------------------------

-- Get the current geo location.
public function wd_get_geo_location(sequence sessionId)
  object res

  res = wd_execute("get_geo_location", {sessionId}, {})
  return get_json_value("value", json_to_sequence(res[HTTP_BODY]), 0)
end function

--------------------------------------------------------------------------------

-- Get the status of the html5 application cache.
public function wd_get_html5_cache_status(sequence sessionId)
  object res

  res = wd_execute("get_html5_cache_status", {sessionId}, {})
  return get_json_value("value", json_to_sequence(res[HTTP_BODY]), 0)
end function

--------------------------------------------------------------------------------

-- Get the log for a given log type.
public function wd_get_log(sequence sessionId, sequence logType)
  object res

  res = wd_execute("get_log", {sessionId}, {logType})
  return get_json_value("value", json_to_sequence(res[HTTP_BODY]), 0)
end function

--------------------------------------------------------------------------------

-- Get available log types.
public function wd_list_available_log_types(sequence sessionId)
  object res

  res = wd_execute("list_available_log_types", {sessionId}, {})
  return get_json_value("value", json_to_sequence(res[HTTP_BODY]), 0)
end function

--------------------------------------------------------------------------------

-- Get the current browser orientation.
public function wd_get_orientation(sequence sessionId)
  object res

  res = wd_execute("get_orientation", {sessionId}, {})
  return get_json_value("value", json_to_sequence(res[HTTP_BODY]), 0)
end function

--------------------------------------------------------------------------------

-- Retrieve the capabilities of the specified session.
public function wd_get_session_capabilities(sequence sessionId)
  object res

  res = wd_execute("get_session_capabilities", {sessionId}, {})
  return get_json_value("value", json_to_sequence(res[HTTP_BODY]), 0)
end function

--------------------------------------------------------------------------------

-- Get the current page title.
public function wd_get_title(sequence sessionId)
  object res

  res = wd_execute("get_title", {sessionId}, {})
  return get_json_value("value", json_to_sequence(res[HTTP_BODY]), 0)
end function

--------------------------------------------------------------------------------

-- Retrieve the URL of the current page.
public function wd_get_current_url(sequence sessionId)
  object res

  res = wd_execute("get_current_url", {sessionId}, {})
  return get_json_value("value", json_to_sequence(res[HTTP_BODY]), 0)
end function

--------------------------------------------------------------------------------

-- Retrieve the current window handle.
public function wd_get_current_window_handle(sequence sessionId)
  object res

  res = wd_execute("get_current_window_handle", {sessionId}, {})
  return get_json_value("value", json_to_sequence(res[HTTP_BODY]), 0)
end function

--------------------------------------------------------------------------------

-- Retrieve the list of all window handles available to the session.
public function wd_get_all_window_handles(sequence sessionId)
  object res

  res = wd_execute("get_all_window_handles", {sessionId}, {})
  return get_json_value("value", json_to_sequence(res[HTTP_BODY]), 0)
end function

--------------------------------------------------------------------------------

-- Get the position of the specified window.
public function wd_get_window_position(sequence sessionId, sequence id)
  object res

  res = wd_execute("get_window_position", {sessionId, id}, {})
  return get_json_value("value", json_to_sequence(res[HTTP_BODY]), 0)
end function

--------------------------------------------------------------------------------

-- Get the size of the specified window.
public function wd_get_window_size(sequence sessionId, sequence id)
  object res

  res = wd_execute("get_window_size", {sessionId, id}, {})
  return get_json_value("value", json_to_sequence(res[HTTP_BODY]), 0)
end function

--------------------------------------------------------------------------------

-- Make an engines that is available (appears on the list returned by
-- wd_list_available_engines) active.
public procedure wd_activate_ime(sequence sessionId, sequence engine)
  void = wd_execute("activate_ime", {sessionId}, {engine})
end procedure

--------------------------------------------------------------------------------

-- Get the name of the active IME engine.
public function wd_get_ime_active_engine(sequence sessionId)
  object res

  res = wd_execute("get_ime_active_engine", {sessionId}, {})
  return get_json_value("value", json_to_sequence(res[HTTP_BODY]), 0)
end function

--------------------------------------------------------------------------------

-- List all available engines on the machine.
public function wd_list_ime_available_engines(sequence sessionId)
  object res

  res = wd_execute("list_ime_available_engines", {sessionId}, {})
  return get_json_value("value", json_to_sequence(res[HTTP_BODY]), 0)
end function

--------------------------------------------------------------------------------

-- De-activates the currently-active IME engine.
public procedure wd_deactivate_ime(sequence sessionId)
  void = wd_execute("deactivate_ime", {sessionId}, {})
end procedure

--------------------------------------------------------------------------------

-- Indicates whether IME input is active at the moment (not if it's available).
public function wd_is_ime_activated(sequence sessionId)
  object res

  res = wd_execute("is_ime_activated", {sessionId}, {})
  return get_json_value("value", json_to_sequence(res[HTTP_BODY]), 0)
end function

--------------------------------------------------------------------------------

-- Determine if an element is currently displayed.
public function wd_is_element_displayed(sequence sessionId, sequence id)
  object res

  res = wd_execute("is_element_displayed", {sessionId, id}, {})
  return get_json_value("value", json_to_sequence(res[HTTP_BODY]), 0)
end function

--------------------------------------------------------------------------------

-- Determine if an element is currently enabled.
public function wd_is_element_enabled(sequence sessionId, sequence id)
  object res

  res = wd_execute("is_element_enabled", {sessionId, id}, {})
  return get_json_value("value", json_to_sequence(res[HTTP_BODY]), 0)
end function

--------------------------------------------------------------------------------

-- Determine if an OPTION element, or an INPUT element of type checkbox or
-- radiobutton is currently selected.
public function wd_is_element_selected(sequence sessionId, sequence id)
  object res

  res = wd_execute("is_element_selected", {sessionId, id}, {})
  return get_json_value("value", json_to_sequence(res[HTTP_BODY]), 0)
end function

--------------------------------------------------------------------------------

-- Maximize the specified window if not already maximized.
public procedure wd_maximize_window(sequence sessionId, sequence id)
  void = wd_execute("maximize_window", {sessionId, id}, {})
end procedure

--------------------------------------------------------------------------------

-- Move the mouse by an offset of the specificed element.
-- If no element is specified, the move is relative to the current mouse cursor.
-- If an element is provided but no offset, the mouse will be moved to the
-- center of the element. If the element is not visible, it will be scrolled
-- into view.
public procedure wd_move_mouse_to(sequence sessionId, sequence element,
                                  integer xoffset, integer yoffset)
  void = wd_execute("move_mouse_to", {sessionId}, {element, xoffset, yoffset})
end procedure

--------------------------------------------------------------------------------

-- Navigate backwards in the browser history, if possible.
public procedure wd_go_back(sequence sessionId)
  void = wd_execute("go_back", {sessionId}, {})
end procedure

--------------------------------------------------------------------------------

-- Navigate forwards in the browser history, if possible.
public procedure wd_go_forward(sequence sessionId)
  void = wd_execute("go_forward", {sessionId}, {})
end procedure

--------------------------------------------------------------------------------

-- Refresh the current page.
public procedure wd_refresh(sequence sessionId)
  void = wd_execute("refresh", {sessionId}, {})
end procedure

--------------------------------------------------------------------------------

-- Search for an element on the page, starting from document root.
public function wd_search_element(sequence sessionId,
                                  -- FindElementStrategy using, sequence value)
                                  sequence using, sequence value)
  object res

  res = wd_execute("search_element", {sessionId}, {using, value})
  return get_json_value("ELEMENT", json_to_sequence(res[HTTP_BODY]), 0)
end function

--------------------------------------------------------------------------------

-- Search for an element by ID, starting from document root.
public function wd_select_element_by_id(sequence sessionId, sequence name)
  return wd_search_element(sessionId, "id", name)
end function

--------------------------------------------------------------------------------

-- Search for an element by NAME, starting from document root.
public function wd_select_element_by_name(sequence sessionId, sequence name)
  return wd_search_element(sessionId, "name", name)
end function

--------------------------------------------------------------------------------

-- Search for an element on the page, starting from the identified element.
public function wd_search_element_from(sequence sessionId, sequence id,
                                       sequence using, sequence value)
  object res

  res = wd_execute("search_element_from", {sessionId, id}, {using, value})
  return get_json_value("ELEMENT", json_to_sequence(res[HTTP_BODY]), 0)
end function

--------------------------------------------------------------------------------

-- Search for multiple elements on the page, starting from the document root.
public function wd_search_elements(sequence sessionId,
                                   sequence using, sequence value)
  object res

  res = wd_execute("search_elements", {sessionId}, {using, value})
  return get_json_value("ELEMENT", json_to_sequence(res[HTTP_BODY]), 0)
end function

--------------------------------------------------------------------------------

-- Search for multiple elements on the page, starting from the identified
-- element.
public function wd_search_elements_from(sequence sessionId, sequence id,
                                        sequence using, sequence value)
  object res

  res = wd_execute("search_elements_from", {sessionId, id}, {using, value})
  return get_json_value("ELEMENT", json_to_sequence(res[HTTP_BODY]), 0)
end function

--------------------------------------------------------------------------------

-- Send a sequence of key strokes to an element.
public procedure wd_send_keys_to_element(sequence sessionId, sequence id,
                                         sequence text)
  void = wd_execute("send_keys_to_element", {sessionId, id},
                    {string_to_list(text)})
end procedure

--------------------------------------------------------------------------------

-- Send a sequence of key strokes to an element.
public procedure wd_set_element(sequence sessionId, sequence id, sequence text)
  wd_send_keys_to_element(sessionId, id, text)
end procedure

--------------------------------------------------------------------------------

-- Send a sequence of key strokes to the active element.
public procedure wd_send_keys_to_active_element(sequence sessionId,
                                                sequence text)
  void = wd_execute("send_keys_to_active_element", {sessionId},
                    {string_to_list(text)})
end procedure

--------------------------------------------------------------------------------

-- Sends keystrokes to a JavaScript prompt() dialog.
public procedure wd_send_keys_to_alert(sequence sessionId, sequence text)
  void = wd_execute("send_keys_to_alert", {sessionId}, {string_to_list(text)})
end procedure

--------------------------------------------------------------------------------

-- Set the current geo location.
public procedure wd_set_geo_location(sequence sessionId, sequence location) -- location GeoLocation
  void = wd_execute("set_geo_location", {sessionId}, {location})
end procedure

--------------------------------------------------------------------------------

-- Set the amount of time the driver should wait when searching for elements.
-- When searching for a single element, the driver should poll the page until an
-- element is found or the timeout expires, whichever occurs first.
-- When searching for multiple elements, the driver should poll the page until
-- at least one element is found or the timeout expires, at which point it
-- should return an empty list.
-- If this command is never sent, the driver should default to an implicit wait
-- of 0ms.
public procedure wd_set_implicit_wait(sequence sessionId, integer secs)
  void = wd_execute("set_implicit_wait", {sessionId}, {secs*1000})
end procedure

--------------------------------------------------------------------------------

-- Set the browser orientation.
public procedure wd_set_orientation(sequence sessionId, sequence orientation)
  void = wd_execute("set_orientation", {sessionId}, {orientation})
end procedure

--------------------------------------------------------------------------------

-- Change the size of the specified window.
public procedure wd_set_window_size(sequence sessionId, sequence id,
                                    integer width, integer height)
  void = wd_execute("set_window_size", {sessionId, id}, {width, height})
end procedure

--------------------------------------------------------------------------------

-- Configure the amount of time that a particular type of operation can execute
-- for before they are aborted and a |Timeout| error is returned to the client.
-- Valid values are: "script" for script timeouts, "implicit" for modifying the
-- implicit wait timeout and "page load" for setting a page load timeout.
public procedure wd_set_timeout(sequence sessionId, sequence typ, integer secs)
  void = wd_execute("set_timeout", {sessionId}, {typ, secs*1000})
end procedure

--------------------------------------------------------------------------------

-- Set the amount of time, in milliseconds, that asynchronous scripts executed
-- by ExecuteScriptAsync() are permitted to run before they are aborted and a
-- |Timeout| error is returned to the client.
public procedure wd_set_script_timeout(sequence sessionId, integer secs)
  void = wd_execute("set_script_timeout", {sessionId}, {secs*1000})
end procedure

--------------------------------------------------------------------------------

-- Change the position of the specified window.
public procedure wd_set_window_position(sequence sessionId, sequence id,
                                        integer x, integer y)
  void = wd_execute("set_window_position", {sessionId, id}, {x, y})
end procedure

--------------------------------------------------------------------------------

-- Clear the storage.
public procedure wd_clear_local_storage(sequence sessionId)
  void = wd_execute("clear_local_storage", {sessionId}, {})
end procedure

--------------------------------------------------------------------------------

-- Get all keys of the storage.
public function wd_get_local_storage_keys(sequence sessionId)
  object res

  res = wd_execute("get_local_storage_keys", {sessionId}, {})
  return get_json_value("value", json_to_sequence(res[HTTP_BODY]), 0)
end function

--------------------------------------------------------------------------------

-- Set the storage item for the given key.
public procedure wd_set_local_storage_item(sequence sessionId,
                                           sequence key, sequence value)
  void = wd_execute("set_local_storage_item", {sessionId}, {key, value})
end procedure

--------------------------------------------------------------------------------

-- Get the storage item for the given key.
public function wd_get_local_storage_item(sequence sessionId, sequence key)
  object res

  res = wd_execute("get_local_storage_item", {sessionId, key}, {})
  return get_json_value("value", json_to_sequence(res[HTTP_BODY]), 0)
end function

--------------------------------------------------------------------------------

-- Remove the storage item for the given key.
public procedure wd_remove_local_storage_item(sequence sessionId, sequence key)
  void = wd_execute("remove_local_storage_item", {sessionId, key}, {})
end procedure

--------------------------------------------------------------------------------

-- Get the number of items in the storage.
public function wd_get_local_storage_size(sequence sessionId)
  object res

  res = wd_execute("get_local_storage_size", {sessionId}, {})
  return get_json_value("value", json_to_sequence(res[HTTP_BODY]), 0)
end function

--------------------------------------------------------------------------------

-- Clear the storage.
public procedure wd_clear_session_storage(sequence sessionId)
  void = wd_execute("clear_session_storage", {sessionId}, {})
end procedure

--------------------------------------------------------------------------------

-- Get all keys of the storage.
public function wd_get_session_storage_key(sequence sessionId)
  object res

  res = wd_execute("get_session_storage_key", {sessionId}, {})
  return get_json_value("value", json_to_sequence(res[HTTP_BODY]), 0)
end function

--------------------------------------------------------------------------------

-- Set the storage item for the given key.
public procedure wd_set_session_storage_item(sequence sessionId,
                                             sequence key, sequence value)
  void = wd_execute("set_session_storage_item", {sessionId}, {key, value})
end procedure

--------------------------------------------------------------------------------

-- Get the storage item for the given key.
public function wd_get_session_storage_item(sequence sessionId, sequence key)
  object res

  res = wd_execute("get_session_storage_item", {sessionId, key}, {})
  return get_json_value("value", json_to_sequence(res[HTTP_BODY]), 0)
end function

--------------------------------------------------------------------------------

-- Remove the storage item for the given key.
public procedure wd_remove_session_storage_item(sequence sessionId,
                                                sequence key)
  void = wd_execute("remove_session_storage_item", {sessionId, key}, {})
end procedure

--------------------------------------------------------------------------------

-- Get the number of items in the storage.
public function wd_get_session_storage_size(sequence sessionId)
  object res

  res = wd_execute("get_session_storage_size", {sessionId}, {})
  return get_json_value("value", json_to_sequence(res[HTTP_BODY]), 0)
end function

--------------------------------------------------------------------------------

-- Submit a FORM element.
public procedure wd_submit_form(sequence sessionId, sequence id)
  void = wd_execute("submit_form", {sessionId, id}, {})
end procedure

--------------------------------------------------------------------------------

-- Change focus to another frame on the page.
-- frameId must be string (int|NULL|WebElement are not accepted here)
public procedure wd_switch_to_frame(sequence sessionId, sequence frameId)
  void = wd_execute("switch_to_frame", {sessionId}, {frameId})
end procedure

--------------------------------------------------------------------------------

-- Change focus to another window. The window to change focus to may be
-- specified by its server assigned window handle, or by the value of its name
-- attribute.
public procedure wd_switch_to_window(sequence sessionId,  sequence name)
  void = wd_execute("switch_to_window", {sessionId}, {name})
end procedure

--------------------------------------------------------------------------------

-- Change focus back to parent frame
public procedure wd_switch_to_parent_frame(sequence sessionId)
  void = wd_execute("switch_to_parent_frame", {sessionId}, {})
end procedure

--------------------------------------------------------------------------------

-- Single tap on the touch enabled device.
public procedure wd_touch_single_tap(sequence sessionId, sequence id)
  void = wd_execute("touch_single_tap", {sessionId}, {id})
end procedure

--------------------------------------------------------------------------------

-- Finger down on the screen.
public procedure wd_touch_down(sequence sessionId, integer x, integer y)
  void = wd_execute("touch_down", {sessionId}, {x, y})
end procedure

--------------------------------------------------------------------------------

-- Finger up on the screen.
public procedure wd_touch_up(sequence sessionId, integer x, integer y)
  void = wd_execute("touch_up", {sessionId}, {x, y})
end procedure

--------------------------------------------------------------------------------

-- Finger move on the screen.
public procedure wd_touch_move(sequence sessionId, integer x, integer y)
  void = wd_execute("touch_move", {sessionId}, {x, y})
end procedure

--------------------------------------------------------------------------------

-- Scroll on the touch screen using finger based motion events.
public procedure wd_touch_scroll(sequence sessionId, sequence element,
                                 integer xoffset, integer yoffset)
  void = wd_execute("touch_scroll", {sessionId}, {element, xoffset, yoffset})
end procedure

--------------------------------------------------------------------------------

-- Double tap on the touch screen using finger motion events.
public procedure wd_touch_double_tap(sequence sessionId, sequence id)
  void = wd_execute("touch_double_tap", {sessionId}, {id})
end procedure

--------------------------------------------------------------------------------

-- Long press on the touch screen using finger motion events.
public procedure wd_touch_long_press(sequence sessionId, sequence id)
  void = wd_execute("touch_long_press", {sessionId}, {id})
end procedure

--------------------------------------------------------------------------------

-- Flick on the touch screen using finger motion events.
-- This flick command starts at a particular screen location.
public procedure wd_touch_flick(sequence sessionId, sequence element,
                                integer xoffset, integer yoffset, integer speed)
  void = wd_execute("touch_flick", {sessionId},
                    {element, xoffset, yoffset, speed})
end procedure

--------------------------------------------------------------------------------

-- Flick on the touch screen using finger motion events.
-- Use this flick command if you don't care where the flick starts on the
-- screen.
public procedure wd_touch_flick_anywhere(sequence sessionId,
                                         integer xspeed, integer yspeed)
  void = wd_execute("touch_flick_anywhere", {sessionId}, {xspeed, yspeed})
end procedure

--------------------------------------------------------------------------------
-- Following functions may be out-of-date or for standalone Selenium server
-- (remote web driver). They are untested and may be missing parameters.
--------------------------------------------------------------------------------

-- Get all sessions logs.
public function wd_get_session_logs()
  object res

  res = wd_execute("get_session_logs", {}, {})
  return get_json_value("value", json_to_sequence(res[HTTP_BODY]), 0)
end function

--------------------------------------------------------------------------------

-- Get alert.
public function wd_get_alert(sequence sessionId)
  object res

  res = wd_execute("get_alert", {sessionId}, {})
  return get_json_value("value", json_to_sequence(res[HTTP_BODY]), 0)
end function

--------------------------------------------------------------------------------

-- 
public function wd_is_auto_reporting(sequence sessionId)
  object res

  res = wd_execute("is_auto_reporting", {sessionId}, {})
  return get_json_value("value", json_to_sequence(res[HTTP_BODY]), 0)
end function

--------------------------------------------------------------------------------

-- 
public procedure wd_set_auto_reporting(sequence sessionId)
  void = wd_execute("set_auto_reporting", {sessionId}, {})
end procedure

--------------------------------------------------------------------------------

-- 
public function wd_is_browser_online(sequence sessionId)
  object res

  res = wd_execute("is_browser_online", {sessionId}, {})
  return get_json_value("value", json_to_sequence(res[HTTP_BODY]), 0)
end function

--------------------------------------------------------------------------------

-- 
public procedure wd_set_browser_online(sequence sessionId)
  void = wd_execute("set_browser_online", {sessionId}, {})
end procedure

--------------------------------------------------------------------------------

-- 
public procedure wd_launch_app(sequence sessionId)
  void = wd_execute("launch_app", {sessionId}, {})
end procedure

--------------------------------------------------------------------------------

-- 
public procedure wd_delete_network_conditions(sequence sessionId)
  void = wd_execute("delete_network_conditions", {sessionId}, {})
end procedure

--------------------------------------------------------------------------------

-- 
public function wd_get_network_conditions(sequence sessionId)
  object res

  res = wd_execute("get_network_conditions", {sessionId}, {})
  return get_json_value("value", json_to_sequence(res[HTTP_BODY]), 0)
end function

--------------------------------------------------------------------------------

-- 
public procedure wd_set_network_conditions(sequence sessionId)
  void = wd_execute("set_network_conditions", {sessionId}, {})
end procedure

--------------------------------------------------------------------------------

-- 
public procedure wd_drag_element(sequence sessionId)
  void = wd_execute("drag_element", {sessionId}, {})
end procedure

--------------------------------------------------------------------------------

-- 
public procedure wd_hover_over_element(sequence sessionId, sequence id)
  void = wd_execute("hover_over_element", {sessionId, id}, {})
end procedure

--------------------------------------------------------------------------------

-- 
public function wd_get_element_value(sequence sessionId, sequence id)
  object res

  res = wd_execute("get_element_value", {sessionId, id}, {})
  return get_json_value("ELEMENT", json_to_sequence(res[HTTP_BODY]), 0)
end function

--------------------------------------------------------------------------------

-- 
public function wd_execute_sql(sequence sessionId, sequence sql)
  object res

  res = wd_execute("execute_sql", {sessionId}, {sql})
  return get_json_value("value", json_to_sequence(res[HTTP_BODY]), 0)
end function

--------------------------------------------------------------------------------

-- 
public function wd_upload_file(sequence sessionId, sequence file)
  object res

  res = wd_execute("upload_file", {sessionId}, {file})
  return get_json_value("value", json_to_sequence(res[HTTP_BODY]), 0)
end function

--------------------------------------------------------------------------------

-- 
public function wd_is_loading(sequence sessionId)
  object res

  res = wd_execute("is_loading", {sessionId}, {})
  return get_json_value("value", json_to_sequence(res[HTTP_BODY]), 0)
end function

--------------------------------------------------------------------------------

-- 
public function wd_get_network_connection(sequence sessionId)
  object res

  res = wd_execute("get_network_connection", {sessionId}, {})
  return get_json_value("value", json_to_sequence(res[HTTP_BODY]), 0)
end function

--------------------------------------------------------------------------------

-- 
public function wd_set_network_connection(sequence sessionId)
  object res

  res = wd_execute("set_network_connection", {sessionId}, {})
  return get_json_value("value", json_to_sequence(res[HTTP_BODY]), 0)
end function

--------------------------------------------------------------------------------

-- 
public function wd_delete_orientation(sequence sessionId)
  object res

  res = wd_execute("delete_orientation", {sessionId}, {})
  return get_json_value("value", json_to_sequence(res[HTTP_BODY]), 0)
end function

--------------------------------------------------------------------------------

-- 
public procedure wd_touch_pinch(sequence sessionId)
  void = wd_execute("touch_pinch", {sessionId}, {})
end procedure

--------------------------------------------------------------------------------

-- 
public function wd_is_browser_visible(sequence sessionId)
  object res

  res = wd_execute("is_browser_visible", {sessionId}, {})
  return get_json_value("value", json_to_sequence(res[HTTP_BODY]), 0)
end function

--------------------------------------------------------------------------------

-- 
public procedure wd_set_browser_visible(sequence sessionId)
  void = wd_execute("set_browser_visible", {sessionId}, {})
end procedure

--------------------------------------------------------------------------------

-- 
public function wd_get_sessions(sequence sessionId)
  object res

  res = wd_execute("get_sessions", {sessionId}, {})
  return get_json_value("value", json_to_sequence(res[HTTP_BODY]), 0)
end function

--------------------------------------------------------------------------------

