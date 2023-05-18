public constant
  PROC=1, FUNC=2

public constant
  INTEGER=1, ATOM=2, SEQUENCE=3, OBJECT=4

public sequence additional_routines, routine_list
additional_routines = {}
routine_list = {}

--------------------------------------------------------------------------------

-- misc.e

-- misc constants included by default
public constant MISC_CONSTS = {
  {"WIN32", 2},
  {"LINUX", 3},
  {"PI", 3.141592653589793238}
}

-- misc functions included by default
public constant MISC_FUNCS = {
-- Return a handle to the current program.
  {FUNC, "instance", {}},

-- Suspend execution for i seconds.
  {PROC, "sleep", {INTEGER}},

-- Reverse the order of elements in a sequence.
  {FUNC, "reverse", {SEQUENCE}},

-- Returns the representation of x as a string of characters.
  {FUNC, "sprint", {OBJECT}},

-- Print an object x, using braces { , , , }, indentation, and multiple lines
-- to show the structure.
  {PROC, "pretty_print", {INTEGER, OBJECT, SEQUENCE}},

-- Return an angle with cosine equal to argument.
  {FUNC, "arccos", {OBJECT}},

-- Return an angle with sine equal to argument.
  {FUNC, "arcsin", {OBJECT}}
}

--------------------------------------------------------------------------------

-- get.e

public constant GET_CONSTS = {
  {"GET_SUCCESS", 0},
  {"GET_EOF", -1},
  {"GET_FAIL", 1}
}

public constant GET_FUNCS = {
-- Wait until a key is pressed by the user
  {FUNC, "wait_key", {}},

-- Input a human-readable string of characters representing a Euphoria object.
  {FUNC, "get", {INTEGER}},

-- Read and compute the string representation of a Euphoria object.
  {FUNC, "value", {SEQUENCE}},

-- Prompt the user to enter a number.
  {FUNC, "prompt_number", {SEQUENCE, SEQUENCE}},

-- Prompt the user to enter a string of text.
  {FUNC, "prompt_string", {SEQUENCE}},

-- Read the next bytes from file.
  {FUNC, "get_bytes", {INTEGER, INTEGER}}
}

--------------------------------------------------------------------------------

-- webdriver.e
public constant WD_FUNCS = {
-- Take a screenshot of the current page.
  {FUNC, "wd_take_screenshot", {}},

-- Get the current page source.
  {FUNC, "wd_get_page_source", {}},

-- Initializes CURL and sets proxy
  {PROC, "wd_init", {OBJECT}},

-- Starts a new Chrome session
  {FUNC, "wd_new_session", {OBJECT}},

-- Final cleanup
  {PROC, "wd_cleanup", {}},

-- Accepts the currently displayed alert dialog.
  {PROC, "wd_accept_alert", {}},

-- Set a cookie.
  {PROC, "wd_add_cookie", {SEQUENCE}},

-- Click and hold the left mouse button (set by moveto).
  {PROC, "wd_button_down", {INTEGER}},

-- Releases the mouse button previously held (set by moveto).
  {PROC, "wd_button_up", {INTEGER}},

-- Navigate to a new URL.
  {FUNC, "wd_change_url", {SEQUENCE}},

-- Clear a TEXTAREA or text INPUT element's value.
  {PROC, "wd_clear_element", {SEQUENCE}},

-- Click any mouse button (at the coordinates set by the last moveto command).
  {PROC, "wd_click", {INTEGER}},

-- Click on an element.
  {PROC, "wd_click_element", {SEQUENCE}},

-- Close the current window.
  {PROC, "wd_close_current_window", {}},

-- Delete all cookies visible to the current page.
  {PROC, "wd_delete_all_cookies", {}},

-- Delete the cookie with the given name.
  {PROC, "wd_delete_cookie_by_name", {SEQUENCE}},

-- Delete the session.
  {PROC, "wd_delete_session", {}},

-- Dismisses the currently displayed alert dialog.
  {PROC, "wd_dismiss_alert", {}},

-- Double-clicks at the current mouse coordinates (set by moveto).
  {PROC, "wd_double_click", {}},

-- Test if two element IDs refer to the same DOM element.
  {FUNC, "wd_element_equals", {SEQUENCE, SEQUENCE}},

-- Inject a snippet of asynchronous JavaScript into the page for execution.
  {FUNC, "wd_execute_async_script", {SEQUENCE, SEQUENCE}},

-- Inject a snippet of synchronous JavaScript into the page for execution.
  {FUNC, "wd_execute_script", {SEQUENCE, SEQUENCE}},

-- Get the element on the page that currently has focus.
  {FUNC, "wd_get_active_element", {}},

-- Gets the text of the currently displayed JavaScript dialog.
  {FUNC, "wd_get_alert_text", {}},

-- Retrieve all cookies visible to the current page.
  {FUNC, "wd_get_cookies", {}},

-- Query the value of an element's computed CSS property.
  {FUNC, "wd_get_css_property", {SEQUENCE, SEQUENCE}},

-- Describe the identified element.
  {FUNC, "wd_get_element", {SEQUENCE}},

-- Get the value of an element's attribute.
  {FUNC, "wd_get_element_attribute", {SEQUENCE, SEQUENCE}},

-- Determine an element's location on the page.
  {FUNC, "wd_get_element_location", {SEQUENCE}},

-- Determine an element's location on the screen once scrolled into view.
  {FUNC, "wd_get_element_location_in_view", {SEQUENCE}},

-- Query for an element's tag name.
  {FUNC, "wd_get_element_name", {SEQUENCE}},

-- Determine an element's size in pixels.
  {FUNC, "wd_get_element_size", {SEQUENCE}},

-- Returns the visible text for the element.
  {FUNC, "wd_get_element_text", { SEQUENCE}},

-- Get the current geo location.
  {FUNC, "wd_get_geo_location", {}},

-- Get the status of the html5 application cache.
  {FUNC, "wd_get_html5_cache_status", {}},

-- Get the log for a given log type.
  {FUNC, "wd_get_log", {SEQUENCE}},

-- Get available log types.
  {FUNC, "wd_list_available_log_types", {}},

-- Get the current browser orientation.
  {FUNC, "wd_get_orientation", {}},

-- Retrieve the capabilities of the specified session.
  {FUNC, "wd_get_session_capabilities", {}},

-- Get the current page title.
  {FUNC, "wd_get_title", {}},

-- Retrieve the URL of the current page.
  {FUNC, "wd_get_current_url", {}},

-- Retrieve the current window handle.
  {FUNC, "wd_get_current_window_handle", {}},

-- Retrieve the list of all window handles available to the session.
  {FUNC, "wd_get_all_window_handles", {}},

-- Get the position of the specified window.
  {FUNC, "wd_get_window_position", {SEQUENCE}},

-- Get the size of the specified window.
  {FUNC, "wd_get_window_size", {SEQUENCE}},

-- Make an engines that is available active.
  {PROC, "wd_activate_ime", {SEQUENCE}},

-- Get the name of the active IME engine.
  {FUNC, "wd_get_ime_active_engine", {}},

-- List all available engines on the machine.
  {FUNC, "wd_list_ime_available_engines", {}},

-- De-activates the currently-active IME engine.
  {PROC, "wd_deactivate_ime", {}},

-- Indicates whether IME input is active at the moment (not if it's available).
  {FUNC, "wd_is_ime_activated", {}},

-- Determine if an element is currently displayed.
  {FUNC, "wd_is_element_displayed", {SEQUENCE}},

-- Determine if an element is currently enabled.
  {FUNC, "wd_is_element_enabled", {SEQUENCE}},

-- Determine if an OPTION element, or an INPUT element is currently selected.
  {FUNC, "wd_is_element_selected", {SEQUENCE}},

-- Maximize the specified window if not already maximized.
  {PROC, "wd_maximize_window", {SEQUENCE}},

-- Move the mouse by an offset of the specificed element.
  {PROC, "wd_move_mouse_to", {SEQUENCE, INTEGER, INTEGER}},

-- Navigate backwards in the browser history, if possible.
  {PROC, "wd_go_back", {}},

-- Navigate forwards in the browser history, if possible.
  {PROC, "wd_go_forward", {}},

-- Refresh the current page.
  {PROC, "wd_refresh", {}},

-- Search for an element on the page, starting from document root.
  {FUNC, "wd_search_element", {SEQUENCE, SEQUENCE}},

-- Search for an element by ID, starting from document root.
  {FUNC, "wd_select_element_by_id", {SEQUENCE}},

-- Search for an element by NAME, starting from document root.
  {FUNC, "wd_select_element_by_name", {SEQUENCE}},

-- Search for an element on the page, starting from the identified element.
  {FUNC, "wd_search_element_from", {SEQUENCE, SEQUENCE, SEQUENCE}},

-- Search for multiple elements on the page, starting from the document root.
  {FUNC, "wd_search_elements", {SEQUENCE, SEQUENCE}},

-- Search for multiple elements on the page, starting from the identified element.
  {FUNC, "wd_search_elements_from", {SEQUENCE, SEQUENCE, SEQUENCE}},

-- Send a SEQUENCE of key strokes to an element.
  {PROC, "wd_send_keys_to_element", {SEQUENCE, SEQUENCE}},

-- Send a sequence of key strokes to an element.
  {PROC, "wd_set_element", {SEQUENCE, SEQUENCE}},

-- Send a SEQUENCE of key strokes to the active element.
  {PROC, "wd_send_keys_to_active_element", {SEQUENCE}},

-- Sends keystrokes to a JavaScript dialog.
  {PROC, "wd_send_keys_to_alert", {SEQUENCE}},

-- Set the current geo location.
  {PROC, "wd_set_geo_location", {SEQUENCE}}, -- location GeoLocation

-- Set the amount of time the driver should wait when searching for elements.
  {PROC, "wd_set_implicit_wait", {INTEGER}},

-- Set the browser orientation.
  {PROC, "wd_set_orientation", {SEQUENCE}},

-- Change the size of the specified window.
  {PROC, "wd_set_window_size", {SEQUENCE, INTEGER, INTEGER}},

-- Set the amount of time an operation can execute before timeout.
  {PROC, "wd_set_timeout", {SEQUENCE, INTEGER}},

-- Set the amount of timeasynchronous scripts can run before timeout.
  {PROC, "wd_set_script_timeout", {INTEGER}},

-- Change the position of the specified window.
  {PROC, "wd_set_window_position", {SEQUENCE, INTEGER, INTEGER}},

-- Clear the storage.
  {PROC, "wd_clear_local_storage", {}},

-- Get all keys of the storage.
  {FUNC, "wd_get_local_storage_keys", {}},

-- Set the storage item for the given key.
  {PROC, "wd_set_local_storage_item", {SEQUENCE, SEQUENCE}},

-- Get the storage item for the given key.
  {FUNC, "wd_get_local_storage_item", {SEQUENCE}},

-- Remove the storage item for the given key.
  {PROC, "wd_remove_local_storage_item", {SEQUENCE}},

-- Get the number of items in the storage.
  {FUNC, "wd_get_local_storage_size", {}},

-- Clear the storage.
  {PROC, "wd_clear_session_storage", {}},

-- Get all keys of the storage.
  {FUNC, "wd_get_session_storage_key", {}},

-- Set the storage item for the given key.
  {PROC, "wd_set_session_storage_item", {SEQUENCE, SEQUENCE}},

-- Get the storage item for the given key.
  {FUNC, "wd_get_session_storage_item", {SEQUENCE}},

-- Remove the storage item for the given key.
  {PROC, "wd_remove_session_storage_item", {SEQUENCE}},

-- Get the number of items in the storage.
  {FUNC, "wd_get_session_storage_size", {}},

-- Submit a FORM element.
  {PROC, "wd_submit_form", {SEQUENCE}},

-- Change focus to another frame on the page.
  {PROC, "wd_switch_to_frame", {SEQUENCE}},

-- Change focus to another window.
  {PROC, "wd_switch_to_window", {SEQUENCE}},

-- Change focus back to parent frame
  {PROC, "wd_switch_to_parent_frame", {}},

-- Single tap on the touch enabled device.
  {PROC, "wd_touch_single_tap", {SEQUENCE}},

-- Finger down on the screen.
  {PROC, "wd_touch_down", {INTEGER, INTEGER}},

-- Finger up on the screen.
  {PROC, "wd_touch_up", {INTEGER, INTEGER}},

-- Finger move on the screen.
  {PROC, "wd_touch_move", {INTEGER, INTEGER}},

-- Scroll on the touch screen using finger based motion events.
  {PROC, "wd_touch_scroll", {SEQUENCE, INTEGER, INTEGER}},

-- Double tap on the touch screen using finger motion events.
  {PROC, "wd_touch_double_tap", {SEQUENCE}},

-- Long press on the touch screen using finger motion events.
  {PROC, "wd_touch_long_press", {SEQUENCE}},

-- Flick on the touch screen at a particular screen location.
  {PROC, "wd_touch_flick", {SEQUENCE, INTEGER, INTEGER, INTEGER}},

-- Flick on the touch screen anywhere on the screen.
  {PROC, "wd_touch_flick_anywhere", {INTEGER, INTEGER}}
}

--------------------------------------------------------------------------------

-- _libssh2_.e

public constant LIBSSH2_FUNCS = {
--------------------------------------------------------------------------------
-- Global API
--------------------------------------------------------------------------------

-- Initialize the libssh2 functions.
  {FUNC, "libssh2_init", {INTEGER} },

-- Exit the libssh2 functions and free's all memory used internally.
  {PROC, "libssh2_exit", {} },

--------------------------------------------------------------------------------
-- Session API
--------------------------------------------------------------------------------

-- Set the banner that will be sent to the remote host when the SSH session is
-- started with libssh2_session_handshake()
  {PROC, "libssh2_banner_set", {ATOM, SEQUENCE} },

-- Initialize an SSH session object.
  {FUNC, "libssh2_session_init", {} },

-- Sets a custom callback handler for a previously initialized session object.
  {FUNC, "libssh2_session_callback_set", {ATOM, INTEGER, ATOM} },

-- Perform the SSH handshake
  {FUNC, "libssh2_session_handshake", {ATOM, ATOM} },

-- begin transport layer
  {FUNC, "libssh2_session_startup", {ATOM, INTEGER} },

-- Free resources associated with a session instance
  {FUNC, "libssh2_session_free", {ATOM} },

-- Terminate transport layer
  {FUNC, "libssh2_session_disconnect", {ATOM, SEQUENCE} },

-- Return the actual method negotiated for a particular transport parameter.
  {FUNC, "libssh2_session_methods", {ATOM, INTEGER} },

-- Return a pointer to where the abstract pointer provided to
-- <b>libssh2_session_init_ex()</b> is stored.
  {FUNC, "libssh2_session_abstract", {ATOM} },

-- Determine the most recent error condition and its cause.
--  {FUNC, "libssh2_session_last_error", {ATOM, ATOM, ATOM, INTEGER} },
  {FUNC, "libssh2_session_last_error", {ATOM} },

-- Determine the most recent error condition.
  {FUNC, "libssh2_session_last_errno", {ATOM} },

-- Set options for the created session.
  {FUNC, "libssh2_session_flag", {ATOM, INTEGER, INTEGER} },

-- Set or clear blocking mode on session
  {PROC, "libssh2_session_set_blocking", {ATOM, INTEGER} },

-- Get blocking mode on session
  {FUNC, "libssh2_session_get_blocking", {ATOM} },

-- Set timeout in milliseconds for blocking functions
  {PROC, "libssh2_session_set_timeout", {ATOM, ATOM} },

-- Get the timeout in milliseconds for blocking functions
  {FUNC, "libssh2_session_get_timeout", {ATOM} },

-- Poll for activity on a socket, channel or listener (deprecated: do not use)
  {FUNC, "libssh2_poll", {ATOM, INTEGER, ATOM} },

-- Check if data is available (deprecated: do not use)
  {FUNC, "libssh2_poll_channel_read", {ATOM, INTEGER} },

-- Get directions to wait for
  {FUNC, "libssh2_session_block_directions", {ATOM} },

-- Return hash signature
  {FUNC, "libssh2_hostkey_hash", {ATOM, INTEGER} },

-- Get the remote key
  {FUNC, "libssh2_session_hostkey", {ATOM, INTEGER, INTEGER} },

-- Set preferred key exchange method
  {FUNC, "libssh2_session_method_pref", {ATOM, INTEGER, ATOM} },

--------------------------------------------------------------------------------
-- Userauth API
--------------------------------------------------------------------------------
-- List supported authentication methods
  {FUNC, "libssh2_userauth_list", {ATOM, SEQUENCE} },

-- Return authentication status
  {FUNC, "libssh2_userauth_authenticated", {ATOM} },

-- Authenticate a session with username and password
  {FUNC, "libssh2_userauth_password", {ATOM, SEQUENCE, SEQUENCE, ATOM} },

-- Authenticate using a callback function
  {FUNC, "libssh2_userauth_publickey", {ATOM, ATOM, SEQUENCE, ATOM, ATOM} },

-- Authenticate a session with a public key, read from a file
  {FUNC, "libssh2_userauth_publickey_fromfile", {ATOM, SEQUENCE, ATOM, ATOM, ATOM} },

-- No description yet
  {FUNC, "libssh2_userauth_hostbased_fromfile", {ATOM, SEQUENCE, ATOM, ATOM, ATOM, SEQUENCE} },

-- Authenticate a session using keyboard-interactive authentication
  {FUNC, "libssh2_userauth_keyboard_interactive", {ATOM, SEQUENCE, ATOM} },

--------------------------------------------------------------------------------
-- Channel API
--------------------------------------------------------------------------------

-- Cancel a forwarded TCP port 
  {FUNC, "libssh2_channel_forward_cancel", {ATOM} },

-- Accept a queued connection 
  {FUNC, "libssh2_channel_forward_accept", {ATOM} },

-- Request a shell on a channel 
  {FUNC, "libssh2_channel_process_startup", {ATOM, ATOM, INTEGER, ATOM, INTEGER} },

-- Adjust the channel window (deprecated: do not use)
  {FUNC, "libssh2_channel_receive_window_adjust", {ATOM, ATOM, INTEGER} },

-- Adjust the channel window
  {FUNC, "libssh2_channel_receive_window_adjust2", {ATOM, ATOM, INTEGER, ATOM} },

-- Set or clear blocking mode on channel 
  {PROC, "libssh2_channel_set_blocking", {ATOM, INTEGER} },

-- Set extended data handling mode 
  {PROC, "libssh2_channel_handle_extended_data", {ATOM, INTEGER} },

-- Set extended data handling mode
  {FUNC, "libssh2_channel_handle_extended_data2", {ATOM, INTEGER} },

-- Get the remote exit code 
  {FUNC, "libssh2_channel_get_exit_status", {ATOM} },

-- Send EOF to remote server 
  {FUNC, "libssh2_channel_send_eof", {ATOM} },

-- Check a channel's EOF status 
  {FUNC, "libssh2_channel_eof", {ATOM} },

-- Wait for the remote to reply to an EOF request 
  {FUNC, "libssh2_channel_wait_eof", {ATOM} },

--  Close a channel
  {FUNC, "libssh2_channel_close", {ATOM} },

-- Wait for the remote to close the channel 
  {FUNC, "libssh2_channel_wait_closed", {ATOM} },

-- Free all resources associated with a channel 
  {FUNC, "libssh2_channel_free", {ATOM} },

-- No description yet
  {FUNC, "libssh2_base64_decode", {ATOM, ATOM, ATOM, ATOM, INTEGER} },

-- Return the libssh2 version number
  {FUNC, "libssh2_version", {INTEGER} },

-- Init a collection of known hosts.
  {FUNC, "libssh2_knownhost_init", {ATOM} },

-- Add a host and its associated key to the collection of known hosts.
  {FUNC, "libssh2_knownhost_add", {ATOM, ATOM, ATOM, ATOM, ATOM, INTEGER, ATOM} },

-- Add a host and its associated key to the collection of known hosts.
  {FUNC, "libssh2_knownhost_addc", {ATOM, ATOM, ATOM, ATOM, ATOM, ATOM, ATOM, INTEGER, ATOM} },

-- Check a host and its associated key against the collection of known hosts.
  {FUNC, "libssh2_knownhost_check", {ATOM, ATOM, ATOM, ATOM, INTEGER, ATOM} },

-- Check a host and its associated key against the collection of known hosts.
  {FUNC, "libssh2_knownhost_checkp", {ATOM, ATOM, INTEGER, ATOM, ATOM, INTEGER, ATOM} },

-- Remove a host from the collection of known hosts.
  {FUNC, "libssh2_knownhost_del", {ATOM, ATOM} },

-- Free an entire collection of known hosts.
  {PROC, "libssh2_knownhost_free", {ATOM} },

-- Pass in a line of a file of 'type'. It makes libssh2 read this line.
  {FUNC, "libssh2_knownhost_readline", {ATOM, ATOM, ATOM, INTEGER} },

-- Add hosts+key pairs from a given file.
  {FUNC, "libssh2_knownhost_readfile", {ATOM, ATOM, INTEGER} },

-- Ask libssh2 to convert a known host to an output line for storage.
  {FUNC, "libssh2_knownhost_writeline", {ATOM, ATOM, ATOM, ATOM, ATOM, INTEGER} },

-- Write hosts+key pairs to a given file.
  {FUNC, "libssh2_knownhost_writefile", {ATOM, ATOM, INTEGER} },

-- Traverse the internal list of known hosts.
  {FUNC, "libssh2_knownhost_get", {ATOM, ATOM, ATOM} },

-- Init an ssh-agent handle.
  {FUNC, "libssh2_agent_init", {ATOM} },

-- Connect to an ssh-agent.
  {FUNC, "libssh2_agent_connect", {ATOM} },

-- Request an ssh-agent to list identities.
  {FUNC, "libssh2_agent_list_identities", {ATOM} },

-- Traverse the internal list of public keys.
  {FUNC, "libssh2_agent_get_identity", {ATOM, ATOM, ATOM} },

-- Do publickey user authentication with the help of ssh-agent.
  {FUNC, "libssh2_agent_userauth", {ATOM, ATOM, ATOM} },

-- Close a connection to an ssh-agent.
  {FUNC, "libssh2_agent_disconnect", {ATOM} },

-- Free an ssh-agent handle.
  {PROC, "libssh2_agent_free", {ATOM} },

-- Set how often keepalive messages should be sent.
  {PROC, "libssh2_keepalive_config", {ATOM, INTEGER, INTEGER} },

-- Send a keepalive message if needed.
  {FUNC, "libssh2_keepalive_send", {ATOM} },

-- Enable debug info from inside libssh2
  {FUNC, "libssh2_trace", {ATOM, INTEGER} },

-- Set a trace output handler 
  {FUNC, "libssh2_trace_sethandler", {ATOM, ATOM, ATOM} },

-- Establish a generic session channel 
  {FUNC, "libssh2_channel_open_session", {ATOM} },

-- Tunnel a TCP connection through an SSH session
  {FUNC, "libssh2_channel_direct_tcpip", {ATOM, ATOM, INTEGER} },

-- Listen to inbound connections 
  {FUNC, "libssh2_channel_forward_listen", {ATOM, INTEGER} },

-- Set an environment variable on the channel 
  {FUNC, "libssh2_channel_setenv", {ATOM, SEQUENCE, SEQUENCE} },

-- Short function description 
  {FUNC, "libssh2_channel_request_pty", {ATOM, SEQUENCE} },

-- No description yet
  {FUNC, "libssh2_channel_request_pty_size", {ATOM, INTEGER, INTEGER} },

-- Request an X11 forwarding channel 
  {FUNC, "libssh2_channel_x11_req", {ATOM, INTEGER} },

-- Request a shell on a channel
  {FUNC, "libssh2_channel_shell", {ATOM} },

-- Request a shell on a channel 
  {FUNC, "libssh2_channel_exec", {ATOM, SEQUENCE} },

-- Request a shell on a channel
  {FUNC, "libssh2_channel_subsystem", {ATOM, SEQUENCE} },

-- Read data from channel 0 stream 
--  {FUNC, "libssh2_channel_read", {ATOM} },
  {FUNC, "libssh2_channel_read", {ATOM, ATOM, INTEGER} },

-- Read data from channel STDERR stream 
--  {FUNC, "libssh2_channel_read_stderr", {ATOM} },
  {FUNC, "libssh2_channel_read_stderr", {ATOM, ATOM, INTEGER} },

-- Check the status of the read window 
  {FUNC, "libssh2_channel_window_read", {ATOM} },

-- Check the status of the write window on channel 0
  {FUNC, "libssh2_channel_write", {ATOM, ATOM, INTEGER} },

-- Check the status of the write window on channel STDERR
  {FUNC, "libssh2_channel_write_stderr", {ATOM, ATOM, INTEGER} },

-- Check the status of the write window
  {FUNC, "libssh2_channel_window_write", {ATOM} },

-- Set extended data handling mode
  {PROC, "libssh2_channel_ignore_extended_data", {ATOM, INTEGER} },

-- flush channel 0
  {FUNC, "libssh2_channel_flush", {ATOM} },

-- flush channel STDERR
  {FUNC, "libssh2_channel_flush_stderr", {ATOM} },

-- Send a file via SCP 
  {FUNC, "libssh2_scp_send", {ATOM, ATOM, INTEGER, INTEGER} },

-- Send a file via SCP 
  {FUNC, "libssh2_scp_send64", {ATOM, ATOM, INTEGER, ATOM, ATOM, ATOM} },

-- Request a remote file via SCP 
  {FUNC, "libssh2_scp_recv", {ATOM, ATOM, ATOM} }
}

--------------------------------------------------------------------------------

-- _ssh2_.e

public constant SSH2_FUNCS = {
-- Check if a connection is valid
  {FUNC, "check_link", {INTEGER} },

-- Reads connection buffer
  {FUNC, "get_buffer", {INTEGER} },

-- Sets connection buffer
  {FUNC, "set_buffer", {INTEGER, SEQUENCE} },

-- Cleans connection buffer
  {FUNC, "clean_buffer", {INTEGER} },

-- Find a connection id from host and port
  {FUNC, "find_connection", {SEQUENCE, INTEGER} },

-- Initialize the libssh2 functions
  {FUNC, "ssh_init", {} },

-- Exit the libssh2 functions and free's all memory used internally
  {PROC, "ssh_exit", {} },

-- Close a SSH connection
  {PROC, "ssh_close", {INTEGER} },

-- Run a command on the SSH session
  {PROC, "ssh_exec", {INTEGER, SEQUENCE, INTEGER} },

-- Open a SSH connection to a remote host
  {FUNC, "ssh_connect", {SEQUENCE, INTEGER, SEQUENCE, SEQUENCE} }
}

--------------------------------------------------------------------------------

-- _curl_.e

public constant CURL_CONSTS = {
  {"HTTP_STATUS",  1},
  {"HTTP_URL",     2},
  {"HTTP_HEADERS", 3},
  {"HTTP_BODY",    4}
}

public constant CURL_FUNCS = {
-- 
  {FUNC, "curl_write_callback", {ATOM, ATOM, ATOM, ATOM}},

-- 
  {FUNC, "curl_read_callback", {ATOM, ATOM, ATOM, ATOM}},

-- checks whether two strings are equal.
-- subject for removal in a future libcurl
  {FUNC, "curl_strequal", {SEQUENCE, SEQUENCE}},

-- checks whether the first n chars of two strings are equal.
-- subject for removal in a future libcurl
  {FUNC, "curl_strnequal", {SEQUENCE, SEQUENCE, ATOM}},

-- Pretty advanced function for building multi-part formposts. Each
-- invoke adds one part that together construct a full post.
-- Then use CURLOPT_HTTPPOST to send it off to libcurl.
  {FUNC, "curl_formadd", {ATOM, ATOM, ATOM}},

-- Serialize a curl_httppost struct built with curl_formadd", {).
-- Accepts a void pointer as second argument which will be passed to
-- the curl_formget_callback public function.
  {FUNC, "curl_formget", {ATOM, ATOM, ATOM}},

-- Free a multipart formpost previously built with curl_formadd", {).
  {PROC, "curl_formfree", {ATOM}},

-- DEPRECATED
  {FUNC, "curl_getenv", {SEQUENCE}},

-- Returns a static ascii string of the libcurl version.
  {FUNC, "curl_version", {}},

-- Escapes URL strings
-- Converts all letters consider illegal in URLs to their %XX versions
  {FUNC, "curl_easy_escape", {ATOM, SEQUENCE}},

-- the previous version
  {FUNC, "curl_escape", {SEQUENCE}},

-- Unescapes URL encoding in strings
-- 
-- Converts all %XX codes to their 8bit versions.
-- Conversion Note: On non-ASCII platforms the ASCII %XX codes are
-- converted into the host encoding.
  {FUNC, "curl_easy_unescape", {ATOM, SEQUENCE}},

-- the previous version
  {FUNC, "curl_unescape", {SEQUENCE}},

-- Provided for de-allocation in the same translation unit that did the
-- allocation.
  {PROC, "curl_free", {ATOM}},

-- curl_global_init", {) should be invoked exactly once for each application that
-- uses libcurl and before any call of other libcurl functions.
-- This function is not thread-safe!
  {FUNC, "curl_global_init", {ATOM}},

-- Appends a string to a linked list.
-- If no list exists, it will be created first.
  {FUNC, "curl_slist_append", {ATOM, SEQUENCE}},

-- free a previously built curl_slist.
  {PROC, "curl_slist_free_all", {ATOM}},

-- return the content of a slist as a SEQUENCE
  {FUNC, "peek_curl_slist", { ATOM, INTEGER}},

-- curl_global_cleanup", {) should be invoked exactly once for each application
-- that uses libcurl
  {PROC, "curl_global_cleanup", {}},

-- Returns the time, in seconds since 1 Jan 1970 of the time string given in
-- the first argument. The time argument in the second parameter is unused
-- and should be set to NULL.
  {FUNC, "curl_getdate", {SEQUENCE}},

-- returns a pointer to a static copy of the version info struct.
  {FUNC, "curl_version_info", {}},

-- turns a CURLcode value into the equivalent human readable error string.
-- This is useful for printing meaningful error messages.
  {FUNC, "curl_easy_strerror", {INTEGER}},

-- pauses or unpauses transfers.
-- Select the new state by setting the bitmask, use the convenience defines.
  {FUNC, "curl_easy_pause", {ATOM, INTEGER}},

-- 
  {FUNC, "curl_easy_init", {}},

-- 
  {PROC, "curl_easy_setopt", {ATOM, INTEGER, OBJECT}},

-- 
  {FUNC, "curl_easy_perform", {ATOM}},

-- 
  {PROC, "curl_easy_cleanup", {ATOM}},

-- request internal information from the curl session
-- Intended to get used *AFTER* a performed transfer.
-- All results from this   {FUNC, "are undefined until the
-- transfer is completed.
  {FUNC, "curl_easy_getinfo", {ATOM, INTEGER}},

-- Creates a new curl session handle with the same options set for the handle
-- passed in. Duplicating a handle could only be a matter of cloning data and
-- options, internal state info and things like persistent connections cannot
-- be transferred. It is useful in multithreaded applications when you can run
-- curl_easy_duphandle", {) for each new thread to avoid a series of identical
-- curl_easy_setopt", {) invokes in every thread.
  {FUNC, "curl_easy_duphandle", {ATOM}},

-- Re-initializes a CURL handle to the default values. This puts back the
-- handle to the same state as it was in when it was just created.
-- It does keep: live connections, the Session ID cache, the DNS cache and the
-- cookies.
  {PROC, "curl_easy_reset", {ATOM}},

-- Receives data from the connected socket. Use after successful
-- curl_easy_perform", {) with CURLOPT_CONNECT_ONLY option.
  {FUNC, "curl_easy_recv", {ATOM, ATOM, INTEGER}},

-- Sends data over the connected socket. Use after successful
-- curl_easy_perform", {) with CURLOPT_CONNECT_ONLY option.
  {FUNC, "curl_easy_send", {ATOM, ATOM, INTEGER}},

-- extract cookies from SEQUENCE of headers
  {FUNC, "curl_extract_cookies", {SEQUENCE, INTEGER}},

-- extract CSRF token from HTML content
  {FUNC, "curl_extract_csrf_token", {SEQUENCE}},

-- gets a page
  {FUNC, "curl_easy_perform_ex", {ATOM}},

-- sends a GET request to an URL and gets the page
  {FUNC, "curl_get", {ATOM, SEQUENCE}},

-- sends a POST request to an URL and gets the page
  {FUNC, "curl_post", {ATOM, SEQUENCE, OBJECT}},

-- sends a DELETE request to an URL and gets the page
  {FUNC, "curl_delete", {ATOM, SEQUENCE}}
}

--------------------------------------------------------------------------------

-- _telnet2_.e

public constant TELNET_CONSTS = {
  {"TCP_HOST",      1},
  {"TCP_PORT",      2},
  {"TCP_SOCKET",    3},
  {"TELNET_STATE",  4},
  {"BUFFER",        5},
  {"IAC",           6},
  {"VERB",          7},
  {"SUB_OPTION",    8},
  {"SUB_NEGOC",     9},
  {"TELNET_LOGIN",  10},
  {"LAST_SEND",     11},
  {"LAST_RECV",     12},

  {"DISCONNECTED",   0},
  {"CONNECTED",      1},
  {"IDENTIFIED",     2},
  {"AUTHENTICATED",  3},
  {"LISTENING",      4}
}

public constant TELNET_FUNCS = {
  {FUNC, "errorLabel", {INTEGER}},

-- displays details on last WinSock error</digest>
  {PROC, "handle_error", {}},

-- Retrieves the local name ", {family, address, and port) for a socket.
-- This is the only way to determine the local association of socket/name
-- when a connect", {) call has been made without doing a bind", {) first.
  {FUNC, "getsockname", {INTEGER}},

-- Retrieves the name of the peer to which a socket is connected.
-- This does not work for unconnected datagram sockets.
  {FUNC, "getpeername", {INTEGER}},

-- get the port that is bound to the socket</digest>
  {FUNC, "get_port", {ATOM}},

-- check if a connection is valid</digest>
  {FUNC, "check_link", {INTEGER}},

-- reads connection buffer</digest>
  {FUNC, "get_buffer", {INTEGER}},

-- sets connection buffer</digest>
  {FUNC, "set_buffer", {INTEGER, SEQUENCE}},

-- cleans connection buffer</digest>
  {FUNC, "clean_buffer", {INTEGER}},

-- open a socket and binds it to a local port</digest>
  {FUNC, "sock_bind", {INTEGER}},

-- listens on specified socket</digest>
  {FUNC, "sock_listen", {SEQUENCE}},

-- close a socket</digest>
  {PROC, "sock_disconnect ", {SEQUENCE}},

-- connect to a server</digest>
  {FUNC, "sock_connect", {SEQUENCE, INTEGER}},

-- send data on a socket</digest>
  {FUNC, "telnet_send", {INTEGER, SEQUENCE}},

-- find a connection id from host and port used</digest>
  {FUNC, "find_connection", {SEQUENCE, INTEGER}},

-- close a telnet connection</digest>
  {PROC, "telnet_close", {INTEGER}},

-- used by telnet_read", {), read_all", {), read_until", {) and send_receive", {)
-- can also be launched periodically by a 0.1 s timer to receive data on the flow
-- to display data on the flow onTheFlowDisplayRoutine has to point to a display routine
  {FUNC, "check_connection", {INTEGER, INTEGER, INTEGER}},

-- checks all connections
-- can also be launched periodically by a 0.1 s timer to receive data on the flow
-- to display data on the flow onTheFlowDisplayRoutine has to point to a display routine
  {FUNC, "check_all_connections", {INTEGER, INTEGER}},

-- create a stream ", {TCP) socket and listens on it</digest>
  {FUNC, "telnet_listen", {INTEGER}},

-- accept a connection from listening socket and creates a stream ", {TCP) socket</digest>
  {FUNC, "telnet_accept", {SEQUENCE}},

-- create a stream ", {TCP) socket and connect it to a remote host</digest>
  {FUNC, "telnet_connect", {SEQUENCE, INTEGER}},

-- checks connections and reads data</digest>
  {FUNC, "telnet_read", {INTEGER, ATOM}},

-- read until specified invite</digest>
  {FUNC, "read_until", {INTEGER, SEQUENCE, SEQUENCE}},

-- first read with telnet_read and a wait_time delay
-- if nothing received, try more until max_time is reached if max_time is an
--   INTEGER or max_time[1] ", {maxWaitTime) if max_time is a SEQUENCE
-- if something received, read more until max_time is reached if max_time is an
--   INTEGER or max_time[1] ", {maxWaitTime) if max_time is a SEQUENCE
--   stop immediatly if nothing more received
  {FUNC, "read_all", {INTEGER, ATOM, INTEGER}},

-- send a Telnet command and awaits an answer</digest>
  {FUNC, "send_receive", {INTEGER, SEQUENCE, SEQUENCE, SEQUENCE}}
}

