-- WinHTTP wrapper
-- WinHTTP is Unicode only
include std/dll.e
include std/machine.e
include std/filesys.e
include std/io.e
include std/math.e
include std/search.e
include std/sequence.e
include std/text.e
include _dll_.e
include _machine_.e
include _search_.e
include _sequence_.e
include _html_.e
include _winhttp_constants_.e
include _w32errors_.e

constant
--  HRESULT       = int,
--  LPARAM        = int,
--  WPARAM        = int,
--  HANDLE        = unsigned_long,

  LPWSTR        = pointer,
  LPCWSTR       = pointer,
  DWORD_PTR     = pointer,
  LPVOID        = pointer,
  LPCVOID       = pointer,
--  PVOID         = pointer,
  LPDWORD       = pointer,
  HINTERNET     = LPVOID,
--  LPHINTERNET   = pointer,

  INTERNET_PORT             = word,
--  LPINTERNET_PORT           = pointer,
  LPURL_COMPONENTS          = pointer,
--  LPWINHTTP_PROXY_INFO      = pointer,
  WINHTTP_STATUS_CALLBACK   = pointer  --,
--  LPWINHTTP_STATUS_CALLBACK = pointer,
--  LPURL_COMPONENTSW         = LPURL_COMPONENTS,
--  LPWINHTTP_PROXY_INFOW     = LPWINHTTP_PROXY_INFO

public constant
  HTTP_STATUS=1, HTTP_URL=2, HTTP_HEADERS=3, HTTP_CONTENT=4

--------------------------------------------------------------------------------

constant WINHTTP_LIBRARY_DEFINITION = {
  {
    "winhttp",     -- L_NAME
    0,             -- L_LNX_64
    0,             -- L_LNX_32
    0,             -- L_WIN_64
    "winhttp.dll"  -- L_WIN_32
  }
}

atom winhttp
winhttp = register_library("winhttp", WINHTTP_LIBRARY_DEFINITION)

--------------------------------------------------------------------------------

-- Exported functions (Windows 7 Enterprise)
constant WINHTTP_ROUTINE_DEFINITION = {
  {"WinHttpAddRequestHeaders", {HINTERNET, LPCWSTR, dword, dword}, bool},
  {"WinHttpCheckPlatform", {}, bool},
  {"WinHttpCloseHandle", {HINTERNET}, bool},
  {"WinHttpConnect", {HINTERNET, LPCWSTR, INTERNET_PORT, dword}, HINTERNET},
  {"WinHttpCrackUrl", {LPCWSTR, dword, dword, LPURL_COMPONENTS}, bool},
  {"WinHttpCreateUrl", {LPURL_COMPONENTS, dword, LPWSTR, LPDWORD}, bool},
  {"WinHttpDetectAutoProxyConfigUrl", {dword, pointer}, bool},
  {"WinHttpGetDefaultProxyConfiguration", {pointer}, bool},
  {"WinHttpGetIEProxyConfigForCurrentUser", {pointer}, bool},
  {"WinHttpGetProxyForUrl", {HINTERNET, LPCWSTR, pointer, pointer}, bool},
  {"WinHttpOpen", {LPCWSTR, dword, LPCWSTR, LPCWSTR, dword}, HINTERNET},
  {"WinHttpOpenRequest", {HINTERNET, LPCWSTR, LPCWSTR, LPCWSTR, LPCWSTR, pointer, dword}, HINTERNET},
  {"WinHttpQueryAuthSchemes", {HINTERNET, LPDWORD, LPDWORD, LPDWORD}, bool},
  {"WinHttpQueryDataAvailable", {HINTERNET, LPDWORD}, bool},
  {"WinHttpQueryHeaders", {HINTERNET, dword, LPCWSTR, LPVOID, LPDWORD, LPDWORD}, bool},
  {"WinHttpQueryOption", {HINTERNET, dword, LPVOID, LPDWORD}, bool},
  {"WinHttpReadData", {HINTERNET, LPVOID, dword, LPDWORD}, bool},
  {"WinHttpReceiveResponse", {HINTERNET, LPVOID}, bool},
  {"WinHttpSendRequest", {HINTERNET, LPCWSTR, dword, LPVOID, dword, dword, DWORD_PTR}, bool},
  {"WinHttpSetCredentials", {HINTERNET, dword, dword, LPCWSTR, LPCWSTR, LPVOID}, bool},
  {"WinHttpSetDefaultProxyConfiguration", {pointer}, bool},
  {"WinHttpSetOption", {HINTERNET, dword, LPVOID, dword}, bool},
  {"WinHttpSetStatusCallback", {HINTERNET, WINHTTP_STATUS_CALLBACK, dword, DWORD_PTR}, WINHTTP_STATUS_CALLBACK},
  {"WinHttpSetTimeouts", {HINTERNET, int, int, int, int}, bool},
  {"WinHttpTimeFromSystemTime", {pointer, LPWSTR}, bool},
  {"WinHttpTimeToSystemTime", {LPCWSTR, pointer}, bool},
  {"WinHttpWriteData", {HINTERNET, LPCVOID, dword, LPDWORD}, bool}

-- Following functions are not exported in Windows 7 Enterprise
-- Present only in latest Windows versions (8, 8.1 and 10)
--  {'WinHttpIsHostInProxyBypassList", {pointer, PCWSTR, INTERNET_SCHEME, INTERNET_PORT, bool}, dword},
--  {"WinHttpQueryAuthParams", {HINTERNET, dword, pointer}, bool},
--  {"WinHttpCreateProxyResolver", {HINTERNET, pointer}, dword},
--  {"WinHttpGetProxyForUrlEx", {HINTERNET, PCWSTR, pointer, DWORD_PTR}, dword},
--  {"WinHttpGetProxyResult", {HINTERNET, pointer}, dword},
--  {"WinHttpFreeProxyResult", {pointer}},
--  {"WinHttpResetAutoProxy", {HINTERNET, dword}, dword},
--  {"WinHttpWebSocketCompleteUpgrade", {HINTERNET, DWORD_PTR}, HINTERNET},
--  {"WinHttpWebSocketSend", {HINTERNET, WINHTTP_WEB_SOCKET_BUFFER_TYPE, PVOID, dword}, dword},
--  {"WinHttpWebSocketReceive", {HINTERNET, PVOID, dword, pointer, pointer}, dword},
--  {"WinHttpWebSocketShutdown", {HINTERNET, USHORT, PVOID, dword}, dword},
--  {"WinHttpWebSocketClose", {HINTERNET, USHORT, PVOID, dword}, dword},
--  {"WinHttpWebSocketQueryCloseStatus", {HINTERNET, pointer, PVOID, dword, pointer}, dword}
}

integer
  xWinHttpAddRequestHeaders, xWinHttpCheckPlatform, xWinHttpCloseHandle,
  xWinHttpConnect, xWinHttpCrackUrl, xWinHttpCreateUrl,
  xWinHttpDetectAutoProxyConfigUrl, xWinHttpGetDefaultProxyConfiguration,
  xWinHttpGetIEProxyConfigForCurrentUser, xWinHttpGetProxyForUrl, xWinHttpOpen,
  xWinHttpOpenRequest, xWinHttpQueryAuthSchemes, xWinHttpQueryDataAvailable,
  xWinHttpQueryHeaders, xWinHttpQueryOption, xWinHttpReadData,
  xWinHttpReceiveResponse, xWinHttpSendRequest, xWinHttpSetCredentials,
  xWinHttpSetDefaultProxyConfiguration, xWinHttpSetOption,
  xWinHttpSetStatusCallback, xWinHttpSetTimeouts , xWinHttpTimeFromSystemTime,
  xWinHttpTimeToSystemTime, xWinHttpWriteData

-- Present only in latest Windows versions (8, 8.1 and 10)
--  xWinHttpIsHostInProxyBypassList, xWinHttpQueryAuthParams,
--  xWinHttpCreateProxyResolver, xWinHttpGetProxyForUrlEx,
--  xWinHttpGetProxyResult, xWinHttpFreeProxyResult, xWinHttpResetAutoProxy,
--  xWinHttpWebSocketCompleteUpgrade, xWinHttpWebSocketSend,
--  xWinHttpWebSocketReceive, xWinHttpWebSocketShutdown,
--  xWinHttpWebSocketClose, xWinHttpWebSocketQueryCloseStatus

xWinHttpAddRequestHeaders = 0
xWinHttpCheckPlatform = 0
xWinHttpCloseHandle = 0
xWinHttpConnect = 0
xWinHttpCrackUrl = 0
xWinHttpCreateUrl = 0
xWinHttpDetectAutoProxyConfigUrl = 0
xWinHttpGetDefaultProxyConfiguration = 0
xWinHttpGetIEProxyConfigForCurrentUser = 0
xWinHttpGetProxyForUrl = 0
xWinHttpOpen = 0
xWinHttpOpenRequest = 0
xWinHttpQueryAuthSchemes = 0
xWinHttpQueryDataAvailable = 0
xWinHttpQueryHeaders = 0
xWinHttpQueryOption = 0
xWinHttpReadData = 0
xWinHttpReceiveResponse = 0
xWinHttpSendRequest = 0
xWinHttpSetCredentials = 0
xWinHttpSetDefaultProxyConfiguration = 0
xWinHttpSetOption = 0
xWinHttpSetStatusCallback = 0
xWinHttpSetTimeouts  = 0
xWinHttpTimeFromSystemTime = 0
xWinHttpTimeToSystemTime = 0
xWinHttpWriteData = 0

--------------------------------------------------------------------------------

-- The WinHttpAddRequestHeaders function adds one or more HTTP request headers
-- to the HTTP request handle.
-- 
-- Syntax
-- bool WINAPI WinHttpAddRequestHeaders(
--   _In_ HINTERNET hRequest,
--   _In_ LPCWSTR   pwszHeaders,
--   _In_ dword     dwHeadersLength,
--   _In_ dword     dwModifiers
-- );
-- 
-- Parameters
-- 
--   hRequest [in]
--     A HINTERNET handle returned by a call to the WinHttpOpenRequest function.
-- 
--   pwszHeaders [in]
--     A pointer to a string variable that contains the headers to append to
--     the request. Each header except the last must be terminated by a
--     carriage return/line feed (CR/LF).
-- 
--   dwHeadersLength [in]
--     An unsigned long integer value that contains the length, in characters,
--     of pwszHeaders. If this parameter is -1L, the function assumes that
--     pwszHeaders is zero-terminated (ASCIIZ), and the length is computed.
-- 
--   dwModifiers [in]
--     An unsigned long integer value that contains the flags used to modify
--     the semantics of this function. Can be one or more of the following
--     flags.
-- 
--     Value                            Meaning
--     WINHTTP_ADDREQ_FLAG_ADD          Adds the header if it does not exist.
--                                      Used with WINHTTP_ADDREQ_FLAG_REPLACE.
--     WINHTTP_ADDREQ_FLAG_ADD_IF_NEW   Adds the header only if it does not
--                                      already exist; otherwise, an error is
--                                      returned.
--     WINHTTP_ADDREQ_FLAG_COALESCE     Merges headers of the same name.
--     WINHTTP_ADDREQ_FLAG_COALESCE_WITH_COMMA   Merges headers of the same
--                                      name using a comma. For example, adding
--                                      "Accept: text/*" followed by "Accept:
--                                      audio/*" with this flag results in a
--                                      single header "Accept: text/*, audio/
--                                      *". This causes the first header found
--                                      to be merged. The calling application
--                                      must to ensure a cohesive scheme with
--                                      respect to merged and separate headers.
--     WINHTTP_ADDREQ_FLAG_COALESCE_WITH_SEMICOLON   Merges headers of the same
--                                      name using a semicolon.
--     WINHTTP_ADDREQ_FLAG_REPLACE      Replaces or removes a header. If the
--                                      header value is empty and the header is
--                                      found, it is removed. If the value is
--                                      not empty, it is replaced.
--      
-- Return value
--   Returns TRUE if successful, or FALSE otherwise. For extended error
--   information, call GetLastError. Among the error codes returned are the
--   following.
-- 
--   Error Code                             Description
--   ERROR_WINHTTP_INCORRECT_HANDLE_STATE   The requested operation cannot be
--                                          performed because the handle
--                                          supplied is not in the correct
--                                          state.
--   ERROR_WINHTTP_INCORRECT_HANDLE_TYPE    The type of handle supplied is
--                                          incorrect for this operation.
--   ERROR_WINHTTP_INTERNAL_ERROR           An internal error has occurred.
--   ERROR_NOT_ENOUGH_MEMORY                Not enough memory was available to
--                                          complete the requested operation.
--  
-- Remarks
--   Headers are transferred across redirects. This can be a security issue.
--   To avoid having headers transferred when a redirect occurs, use the
--   WINHTTP_STATUS_CALLBACK callback to correct the specific headers when a
--   redirect occurs. 
--   
--   Even when WinHTTP is used in asynchronous mode (that is, when
--   WINHTTP_FLAG_ASYNC has been set in WinHttpOpen), this function operates
--   synchronously. The return value indicates success or failure. To get
--   extended error information, call GetLastError. 
--   
--   The WinHttpAddRequestHeaders function appends additional free-format
--   headers to the HTTP request handle and is intended for use by
--   sophisticated clients that require detailed control over the exact
--   request sent to the HTTP server. 
--   
--   The name and value of request headers added with this function are
--   validated. Headers must be well formed. For more information about valid
--   HTTP headers, see RFC 2616. If an invalid header is used, this function
--   fails and GetLastError returns ERROR_INVALID_PARAMETER. The invalid
--   header is not added. 
--   
--   If you are sending a Date: request header, you can use the
--   WinHttpTimeFromSystemTime function to create structure for the header. 
--   
--   For basic WinHttpAddRequestHeaders, the application can pass in multiple
--   headers in a single buffer. 
--   
--   An application can also use WinHttpSendRequest to add additional headers
--   to the HTTP request handle before sending a request.
--<function>
--<name>WinHttpAddRequestHeaders</name>
--<digest>adds one or more HTTP request headers to the HTTP request handle.</digest>
--<desc>
--</desc>
--<param>
--<type>atom</type>
--<name>hRequest</name>
--<desc></desc>
--</param>
--<param>
--<type>object</type>
--<name>Headers</name>
--<desc></desc>
--</param>
--<param>
--<type>atom</type>
--<name>dwModifiers</name>
--<desc></desc>
--</param>
--<return>
--</return>
--<example>
--</example>
--<see_also>
--</see_also>
--</function>

public function WinHttpAddRequestHeaders(atom hRequest, object Headers,
                                         atom dwModifiers)
  atom lpszHeaders, dwHeadersLength
  integer result

  if sequence(Headers) then
    lpszHeaders = allocate_wstring(Headers)
    dwHeadersLength = (2*length(Headers))
  else
    error_msg = "WinHttpAddRequestHeaders: Headers should be a sequence"
    return FALSE
  end if

  error_code = 0
  error_msg = ""

  if not xWinHttpAddRequestHeaders then
    xWinHttpAddRequestHeaders = register_routine(winhttp,
            "WinHttpAddRequestHeaders", WINHTTP_ROUTINE_DEFINITION)
  end if
  result = c_func(xWinHttpAddRequestHeaders, {hRequest, lpszHeaders,
                                              dwHeadersLength+2, dwModifiers})

  if lpszHeaders != NULL then free(lpszHeaders) end if
  if result = FALSE then
    error_code = GetLastError()
    error_msg = "WinHttpAddRequestHeaders failed:\n  " &
                  FormatSystemError(error_code)
    if f_debug then
      log_printf("Error %d: %s\n", {error_code, error_msg})
      flush(f_debug)
    end if
  end if
  return result
end function

--------------------------------------------------------------------------------

-- The WinHttpCheckPlatform function determines whether the current
-- platform is supported by this version of Microsoft Windows HTTP Services
-- (WinHTTP).
-- 
-- Syntax
--   bool WinHttpCheckPlatform(void);
-- 
-- Parameters
--   This function has no parameters.
-- 
-- Return value
--   The return value is TRUE if the platform is supported by Microsoft
--   Windows HTTP Services (WinHTTP), or FALSE otherwise.
-- 
-- Remarks
--   This function is useful if your application uses Microsoft Windows HTTP
--   Services (WinHTTP), but also supports platforms that WinHTTP does not. 
-- 
--   Even when WinHTTP is used in asynchronous mode (that is, when
--   WINHTTP_FLAG_ASYNC has been set in WinHttpOpen), this function operates
--   synchronously. The return value indicates success or failure. To get
--   extended error information, call GetLastError. 
-- 
--   WinHTTP version 5.1 is an operating-system component of Windows 2000
--   with Service Pack 3 (SP3) and later (except Datacenter Server), Windows
--   XP with Service Pack 1 (SP1) and later, and Windows Server 2003. In
--   Windows Server 2003, WinHTTP is a system side-by-side assembly.
--<function>
--<name>WinHttpCheckPlatform</name>
--<digest>determines whether the current platform is supported</digest>
--<desc>
--</desc>
--<return>
--</return>
--<example>
--</example>
--<see_also>
--</see_also>
--</function>

public function WinHttpCheckPlatform()
  integer result

  error_code = 0
  error_msg = ""

  if not xWinHttpCheckPlatform then
    xWinHttpCheckPlatform = register_routine(winhttp, "WinHttpCheckPlatform",
                                          WINHTTP_ROUTINE_DEFINITION)
  end if
  result = c_func(xWinHttpCheckPlatform, {})
  if result = FALSE then
    error_code = result
    error_msg = "WinHTTP does not support this platform!"
    if f_debug then
      log_printf("Error: %s\n", {error_msg})
      flush(f_debug)
    end if
  end if
  return result
end function

--------------------------------------------------------------------------------

-- The WinHttpCloseHandle function closes a single HINTERNET handle.
-- 
-- Syntax
--   bool WINAPI WinHttpCloseHandle(
--     _In_ HINTERNET hInternet
--   );
-- 
-- Parameters
-- 
--   hInternet [in]
--     Valid HINTERNET handle to be closed.
-- 
-- Return value
-- 
--   Returns TRUE if the handle is successfully closed, or FALSE otherwise.
--   To get extended error information, call GetLastError. Among the error
--   codes returned are the following.
-- 
--   Error Codes      Description
--   ERROR_WINHTTP_SHUTDOWN         The WinHTTP function support is being shut
--                                  down or unloaded.
--   ERROR_WINHTTP_INTERNAL_ERROR   An internal error has occurred.
--   ERROR_NOT_ENOUGH_MEMORY        Not enough memory was available to complete
--                                  the requested operation. (Windows error
--                                  code)
--  
-- Remarks
--   Even when WinHTTP is used in asynchronous mode (that is, when
--   WINHTTP_FLAG_ASYNC has been set in WinHttpOpen), this function operates
--   synchronously. The return value indicates success or failure. To get
--   extended error information, call GetLastError.
-- 
--   If there is a status callback registered for the handle being closed and
--   the handle was created with a non-NULL context value, a
--   WINHTTP_CALLBACK_STATUS_HANDLE_CLOSING callback is made. This is the
--   last callback made from the handle and indicates that the handle is
--   being destroyed.
-- 
--   An application can terminate an in-progress synchronous or asynchronous
--   request by closing the HINTERNET request handle using
--   WinHttpCloseHandle. For asynchronous requests, keep the following points
--   in mind:
-- 
--   - After an application calls WinHttpCloseHandle on a WinHTTP handle, it
--     cannot call any other WinHTTP API functions using that handle from any
--     thread.
-- 
--   - Even after a call to WinHttpCloseHandle returns, the application must
--     still be prepared to receive callbacks for the closed handle, because
--     WinHTTP can tear down the handle asynchronously. If the asynchronous
--     request was not able to complete successfully, the callback receives a
--     WINHTTP_CALLBACK_STATUS_REQUEST_ERROR notification.
-- 
--   - If an application associates a context data structure or object with
--     the handle, it should maintain that binding until the callback function
--     receives a WINHTTP_CALLBACK_STATUS_HANDLE_CLOSING notification. This is
--     the last callback notification WinHTTP sends prior to deleting a handle
--     object from memory. In order to receive the
--     WINHTTP_CALLBACK_STATUS_HANDLE_CLOSING callback notification, the
--     application must enable the WINHTTP_CALLBACK_FLAG_HANDLES flag in the
--     WinHttpSetStatusCallback call.
-- 
--   - Before calling WinHttpCloseHandle, an application can call
--     WinHttpSetStatusCallback to indicate that no more callbacks should be
--     made:
-- 
--     WinHttpSetStatusCallback( hRequest, NULL, 0, 0 );
-- 
--     It might seem that the context data structure could then be freed
--     immediately rather than having to wait for a
--     WINHTTP_CALLBACK_STATUS_HANDLE_CLOSING notification, but this is not the
--     case: WinHTTP does not synchronize WinHttpSetStatusCallback with
--     callbacks originating in worker threads. As a result, a callback could
--     already be in progress from another thread, and the application could
--     receive a callback notification even after having NULLed-out the
--     callback function pointer and deleted the handle's context data
--     structure. Because of this potential race condition, be conservative in
--     freeing the context structure until after having received the
--     WINHTTP_CALLBACK_STATUS_HANDLE_CLOSING notification.
-- 
--   An application should never call WinHttpCloseHandle on a synchronous
--   request. This can create a race condition. See HINTERNET Handles in
--   WinHTTP for more information.
--<function>
--<name>WinHttpCloseHandle</name>
--<digest>closes a single HINTERNET handle.</digest>
--<desc>
--</desc>
--<param>
--<type>atom</type>
--<name>hInternet</name>
--<desc>Valid HINTERNET handle to be closed.</desc>
--</param>
--<return>
--</return>
--<example>
--</example>
--<see_also>
--</see_also>
--</function>

public function WinHttpCloseHandle(atom hInternet)
  integer result

  error_code = 0
  error_msg = ""

  if not xWinHttpCloseHandle then
    xWinHttpCloseHandle = register_routine(winhttp, "WinHttpCloseHandle",
                                           WINHTTP_ROUTINE_DEFINITION)
  end if
  result = c_func(xWinHttpCloseHandle, {hInternet})
  if result = FALSE then
    error_code = GetLastError()
    error_msg = "WinHttpCloseHandle failed:\n  " &
                  FormatSystemError(error_code)
    if f_debug then
      log_printf("Error %d: %s\n", {error_code, error_msg})
      flush(f_debug)
    end if
  end if
  return result
end function

--------------------------------------------------------------------------------

-- The WinHttpConnect function specifies the initial target server of an
-- HTTP request and returns an HINTERNET connection handle to an HTTP
-- session for that initial target.
-- 
-- Syntax
--   HINTERNET WINAPI WinHttpConnect(
--     _In_       HINTERNET     hSession,
--     _In_       LPCWSTR       pswzServerName,
--     _In_       INTERNET_PORT nServerPort,
--     _Reserved_ dword         dwReserved
--   );
-- 
-- Parameters
-- 
--   hSession [in]
--     Valid HINTERNET WinHTTP session handle returned by a previous call to
--     WinHttpOpen.
-- 
--   pswzServerName [in]
--     Pointer to a null-terminated string that contains the host name of an
--     HTTP server. Alternately, the string can contain the IP address of the
--     site in ASCII, for example, 10.0.1.45. Note that WinHttp does not accept
--     international host names without converting them first to Punycode. For
--     more information, see Handling Internationalized Domain Names (IDNs).
-- 
--   nServerPort [in]
--     Unsigned integer that specifies the TCP/IP port on the server to which a
--     connection is made. This parameter can be any valid TCP/IP port number,
--     or one of the following values.
-- 
--     Value                       Meaning
--     INTERNET_DEFAULT_HTTP_PORT    Uses the default port for HTTP servers
--                                   (port 80).
--     INTERNET_DEFAULT_HTTPS_PORT   Uses the default port for HTTPS servers
--                                   (port 443). Selecting this port does not
--                                   automatically establish a secure
--                                   connection. You must still specify the
--                                   use of secure transaction semantics by
--                                   using the WINHTTP_FLAG_SECURE flag with
--                                   WinHttpOpenRequest.
--     INTERNET_DEFAULT_PORT         Uses port 80 for HTTP and port 443 for
--                                   Secure Hypertext Transfer Protocol
--                                   (HTTPS).
--
--   dwReserved [in]
--     This parameter is reserved and must be 0.
-- 
-- Return value
--   Returns a valid connection handle to the HTTP session if the connection
--   is successful, or NULL otherwise. To retrieve extended error
--   information, call GetLastError. Among the error codes returned are the
--   following.
-- 
--   Error Codes                           Description
--   ERROR_WINHTTP_INCORRECT_HANDLE_TYPE   The type of handle supplied is
--                                         incorrect for this operation.
--   ERROR_WINHTTP_INTERNAL_ERROR          An internal error has occurred.
--   ERROR_WINHTTP_INVALID_URL             The URL is invalid.
--   ERROR_WINHTTP_OPERATION_CANCELLED     The operation was canceled, usually
--                                         because the handle on which the
--                                         request was operating was closed
--                                         before the operation completed.
--   ERROR_WINHTTP_UNRECOGNIZED_SCHEME     The URL scheme could not be
--                                         recognized, or is not supported.
--   ERROR_WINHTTP_SHUTDOWN                The WinHTTP function support is being
--                                         shut down or unloaded.
--   ERROR_NOT_ENOUGH_MEMORY               Not enough memory was available to
--                                         complete the requested operation.
--                                         (Windows error code)
--  
-- Remarks
--   Even when WinHTTP is used in asynchronous mode (that is, when
--   WINHTTP_FLAG_ASYNC has been set in WinHttpOpen), this function operates
--   synchronously. The return value indicates success or failure. To get
--   extended error information, call GetLastError. 
--   
--   After the calling application has finished using the HINTERNET handle
--   returned by WinHttpConnect, it must be closed using the
--   WinHttpCloseHandle function. 
--   
--   WinHttpConnect specifies the target HTTP server, however a response can
--   come from another server if the request was redirected. You can
--   determine the URL of the server sending the response by calling
--   WinHttpQueryOption with the WINHTTP_OPTION_URL flag.
--   
--<function>
--<name>WinHttpConnect</name>
--<digest>
-- specifies the initial target server of an HTTP request and returns an
-- HINTERNET connection handle to an HTTP session for that initial target.
--</digest>
--<desc>
--</desc>
--<param>
--<type>atom</type>
--<name>hSession</name>
--<desc></desc>
--</param>
--<param>
--<type>sequence</type>
--<name>ServerName</name>
--<desc></desc>
--</param>
--<param>
--<type>integer</type>
--<name>nServerPort</name>
--<desc></desc>
--</param>
--<return>
--</return>
--<example>
--</example>
--<see_also>
--</see_also>
--</function>

public function WinHttpConnect(atom hSession, sequence ServerName,
                               integer nServerPort)
  atom pswzServerName
  atom result

  if not xWinHttpConnect then
    xWinHttpConnect = register_routine(winhttp, "WinHttpConnect",
                                       WINHTTP_ROUTINE_DEFINITION)
  end if
  if sequence(ServerName) then
--    pswzServerName = allocate_string(ascii_to_utf16(ServerName))
    pswzServerName = allocate_wstring(ServerName)
  else
    error_msg = "WinHttpConnect: ServerName should be a sequence"
    return NULL
  end if
  
  error_code = 0
  error_msg = ""

  result = c_func(xWinHttpConnect, {hSession, pswzServerName, nServerPort, 0})

  free(pswzServerName)
  if result = NULL then
    error_code = GetLastError()
    error_msg = "WinHttpConnect failed:\n  " &
                  FormatSystemError(error_code)
    if f_debug then
      log_printf("Error %d: %s\n", {error_code, error_msg})
      flush(f_debug)
    end if
  end if
  return result
end function

--------------------------------------------------------------------------------

-- The WinHttpCrackUrl function separates a URL into its component parts such as host name and path.
--
-- Syntax
--   bool WINAPI WinHttpCrackUrl(
--     _In_    LPCWSTR          pwszUrl,
--     _In_    dword            dwUrlLength,
--     _In_    dword            dwFlags,
--     _Inout_ LPURL_COMPONENTS lpUrlComponents
--   );
--
-- Parameters
--
--   pwszUrl [in]
--
--       Pointer to a string that contains the canonical URL to separate. WinHttpCrackUrl does not check this URL for validity or correct format before attempting to crack it.
--   dwUrlLength [in]
--
--       The length of the pwszUrl string, in characters. If dwUrlLength is set to zero, WinHttpCrackUrl assumes that the pwszUrl string is null terminated and determines the length of the pwszUrl string based on that assumption.
--   dwFlags [in]
--
--       The flags that control the operation. This parameter can be one of the following values.
--       Value  Meaning
--
--       ICU_DECODE    Converts characters that are "escape encoded" (%xx) to their non-escaped form. This does not decode other encodings, such as UTF-8. This feature can be used only if the user provides buffers in the URL_COMPONENTS structure to copy the components into.
--
--       ICU_ESCAPE    Escapes certain characters to their escape sequences (%xx). Characters to be escaped are non-ASCII characters or those ASCII characters that must be escaped to be represented in an HTTP request. This feature can be used only if the user provides buffers in the URL_COMPONENTS structure to copy the components into.
--
--       ICU_REJECT_USERPWD    Rejects URLs as input that contains either a username, or a password, or both. If the function fails because of an invalid URL, subsequent calls to GetLastError will return ERROR_WINHTTP_INVALID_URL.
--
--
--   lpUrlComponents [in, out]
--
--       Pointer to a URL_COMPONENTS structure that receives the URL components.
--
-- Return value
--
--   Returns TRUE if the function succeeds, or FALSE otherwise. To get extended error information, call GetLastError. Among the error codes returned are the following.
--   Error Codes  Description
--
--   ERROR_WINHTTP_INTERNAL_ERROR    An internal error has occurred.
--
--   ERROR_WINHTTP_INVALID_URL    The URL is invalid.
--
--   ERROR_WINHTTP_UNRECOGNIZED_SCHEME    The URL scheme could not be recognized, or is not supported.
--
--   ERROR_NOT_ENOUGH_MEMORY    Not enough memory was available to complete the requested operation. (Windows error code)
--
--
-- Remarks
--
--   Even when WinHTTP is used in asynchronous mode (that is, when WINHTTP_FLAG_ASYNC has been set in WinHttpOpen), this function operates synchronously. The return value indicates success or failure. To get extended error information, call GetLastError.
--
--   The required components are indicated by members of the URL_COMPONENTS structure. Each component has a pointer to the value and has a member that stores the length of the stored value. If both the value and the length for a component are equal to zero, that component is not returned. If the pointer to the value of the component is not NULL and the value of its corresponding length member is nonzero, the address of the first character of the corresponding component in the pwszUrl string is stored in the pointer, and the length of the component is stored in the length member.
--
--   If the pointer contains the address of the user-supplied buffer, the length member must contain the size of the buffer. The WinHttpCrackUrl function copies the component into the buffer, and the length member is set to the length of the copied component, minus 1 for the trailing string terminator. If a user-supplied buffer is not large enough, WinHttpCrackUrl returns FALSE, and GetLastError returns ERROR_INSUFFICIENT_BUFFER.
--
--   For WinHttpCrackUrl to work properly, the size of the URL_COMPONENTS structure must be stored in the dwStructSize member of that structure.
--
--   If the Internet protocol of the URL passed in for pwszUrl is not HTTP or HTTPS, then WinHttpCrackUrl returns FALSE and GetLastError indicates ERROR_WINHTTP_UNRECOGNIZED_SCHEME.
--
--   WinHttpCrackUrl does not check the validity or format of a URL before attempting to crack it. As a result, if a string such as ""http://server?Bad=URL"" is passed in, the function returns incorrect results.
--<function>
--<name>WinHttpCrackUrl</name>
--<digest>separates a URL into its component parts such as host name and path.</digest>
--<desc>
--</desc>
--<param>
--<type>atom</type>
--<name>pwszUrl</name>
--<desc></desc>
--</param>
--<param>
--<type>integer</type>
--<name>dwUrlLength</name>
--<desc></desc>
--</param>
--<param>
--<type>integer</type>
--<name>dwFlags</name>
--<desc></desc>
--</param>
--<param>
--<type>atom</type>
--<name>lpUrlComponents</name>
--<desc></desc>
--</param>
--<return>
--</return>
--<example>
--</example>
--<see_also>
--</see_also>
--</function>

public function WinHttpCrackUrl(atom pwszUrl, integer dwUrlLength,
                                integer dwFlags, atom lpUrlComponents)
  integer result

  if not xWinHttpCrackUrl then
    xWinHttpCrackUrl = register_routine(winhttp, "WinHttpCrackUrl",
                                        WINHTTP_ROUTINE_DEFINITION)
  end if
  error_code = 0
  error_msg = ""

  result = c_func(xWinHttpCrackUrl, {pwszUrl, dwUrlLength, dwFlags,
                                     lpUrlComponents})
  if result = FALSE then
    error_msg = "WinHttpCrackUrl failed"
    if f_debug then
      log_printf("Error %d: %s\n", {error_code, error_msg})
      flush(f_debug)
    end if
  end if
  return result
end function

--------------------------------------------------------------------------------

-- The WinHttpCreateUrl function creates a URL from component parts such as the
-- host name and path.
-- 
-- Syntax
--   bool WINAPI WinHttpCreateUrl(
--     _In_    LPURL_COMPONENTS lpUrlComponents,
--     _In_    dword            dwFlags,
--     _Out_   LPWSTR           pwszUrl,
--     _Inout_ LPDWORD          lpdwUrlLength
--   );
-- 
-- Parameters
-- 
--   lpUrlComponents [in]
--     Pointer to a URL_COMPONENTS structure that contains the components from
--     which to create the URL.
-- 
--   dwFlags [in]
--     Flags that control the operation of this function. This parameter can be
--     one of the following values.
--     Value              Meaning
--     ICU_ESCAPE           Converts all unsafe characters to their
--                          corresponding escape sequences in the path string
--                          pointed to by the lpszUrlPath member and in
--                          lpszExtraInfo the extra-information string pointed
--                          to by the member of the URL_COMPONENTS structure
--                          pointed to by the lpUrlComponents parameter.
--     ICU_REJECT_USERPWD   Rejects URLs as input that contains either a
--                          username, or a password, or both. If the function
--                          fails because of an invalid URL, subsequent calls to
--                          GetLastError will return ERROR_WINHTTP_INVALID_URL.
--        
--   pwszUrl [out]
--     Pointer to a character buffer that receives the URL as a wide character
--     (Unicode) string.
-- 
--   lpdwUrlLength [in, out]
--     Pointer to a variable of type unsigned long integer that receives the
--     length of the pwszUrl buffer in wide (Unicode) characters. When the
--     function returns, this parameter receives the length of the URL string
--     wide in characters, minus 1 for the terminating character. If
--     GetLastError returns ERROR_INSUFFICIENT_BUFFER, this parameter receives
--     the number of wide characters required to hold the created URL.
-- 
-- Return value
--   Returns TRUE if the function succeeds, or FALSE otherwise. To get extended 
--   error data, call GetLastError. Among the error codes returned are the
--   following. 
--   Error Code                     Description
--   ERROR_WINHTTP_INTERNAL_ERROR   An internal error occurred.
--   ERROR_NOT_ENOUGH_MEMORY        Insufficient memory available to complete the
--                                  requested operation. (Windows error code)
--  
-- Remarks
--   Even when WinHTTP is used in asynchronous mode, that is, when
--   WINHTTP_FLAG_ASYNC has been set in WinHttpOpen, this function operates
--   synchronously. The return value indicates success or failure. To get
--   extended error data, call GetLastError.
--<function>
--<name>WinHttpCreateUrl</name>
--<digest>creates a URL from component parts such as the host name and path.</digest>
--<desc>
--</desc>
--<param>
--<type>atom</type>
--<name>lpUrlComponents</name>
--<desc></desc>
--</param>
--<param>
--<type>integer</type>
--<name>dwFlags</name>
--<desc></desc>
--</param>
--<param>
--<type>atom</type>
--<name>pwszUrl</name>
--<desc></desc>
--</param>
--<param>
--<type>atom</type>
--<name>pdwUrlLength</name>
--<desc></desc>
--</param>
--<return>
--</return>
--<example>
--</example>
--<see_also>
--</see_also>
--</function>

public function WinHttpCreateUrl(atom lpUrlComponents, integer dwFlags,
                                 atom pwszUrl, atom pdwUrlLength)
  integer result

  if not xWinHttpCreateUrl then
    xWinHttpCreateUrl = register_routine(winhttp, "WinHttpCreateUrl",
                                         WINHTTP_ROUTINE_DEFINITION)
  end if
  error_code = 0
  error_msg = ""

  result = c_func(xWinHttpCreateUrl, {lpUrlComponents, dwFlags, pwszUrl,
                                      pdwUrlLength})
  if result = FALSE then
    error_code = GetLastError()
    error_msg = "WinHttpCreateUrl failed:\n  " &
                  FormatSystemError(error_code)
    if f_debug then
      log_printf("Error %d: %s\n", {error_code, error_msg})
      flush(f_debug)
    end if
  end if
  return result
end function

--------------------------------------------------------------------------------

-- The WinHttpDetectAutoProxyConfigUrl function finds the URL for the Proxy
-- Auto-Configuration (PAC) file. This function reports the URL of the PAC file, but it does not download the file.
--
-- Syntax
--   bool WINAPI WinHttpDetectAutoProxyConfigUrl(
--     _In_  dword  dwAutoDetectFlags,
--     _Out_ LPWSTR *ppwszAutoConfigUrl
--   );
--
-- Parameters
--
--   dwAutoDetectFlags [in]
--
--       A data type that specifies what protocols to use to locate the PAC file. If both the DHCP and DNS auto detect flags are set, DHCP is used first; if no PAC URL is discovered using DHCP, then DNS is used.
--       Value  Meaning
--
--       WINHTTP_AUTO_DETECT_TYPE_DHCP    Use DHCP to locate the proxy auto-configuration file.
--
--       WINHTTP_AUTO_DETECT_TYPE_DNS_A    Use DNS to attempt to locate the proxy auto-configuration file at a well-known location on the domain of the local computer.
--
--
--   ppwszAutoConfigUrl [out]
--
--       A data type that returns a pointer to a null-terminated Unicode string that contains the configuration URL that receives the proxy data. You must free the string pointed to by ppwszAutoConfigUrl using the GlobalFree function.
--
-- Return value
--
--   Returns TRUE if successful, or FALSE otherwise. For extended error information, call GetLastError. Among the error codes returned are the following.
--   Error Code  Description
--
--   ERROR_WINHTTP_AUTODETECTION_FAILED    Returned if WinHTTP was unable to discover the URL of the Proxy Auto-Configuration (PAC) file.
--
--   ERROR_WINHTTP_INTERNAL_ERROR    An internal error has occurred.
--
--   ERROR_NOT_ENOUGH_MEMORY    Not enough memory was available to complete the requested operation. (Windows error code)
--
--
-- Remarks
--
--   WinHTTP implements the Web Proxy Auto-Discovery (WPAD) protocol, often referred to as autoproxy. For more information about well-known locations, see the Discovery Process section of the WPAD protocol document.
--
--   Note that because the WinHttpDetectAutoProxyConfigUrl function takes time to complete its operation, it should not be called from a UI thread.
--<function>
--<name>WinHttpDetectAutoProxyConfigUrl</name>
--<digest>finds the URL for the Proxy Auto-Configuration (PAC) file.</digest>
--<desc>
-- This function reports the URL of the PAC file, but it does not download the file.
--</desc>
--<param>
--<type></type>
--<name></name>
--<desc></desc>
--</param>
--<return>
--</return>
--<example>
--</example>
--<see_also>
--</see_also>
--</function>

public function WinHttpDetectAutoProxyConfigUrl(integer dwAutoDetectFlags,
                                                atom ppwstrAutoConfigUrl)
  integer result

  if not xWinHttpDetectAutoProxyConfigUrl then
    xWinHttpDetectAutoProxyConfigUrl = register_routine(winhttp,
            "WinHttpDetectAutoProxyConfigUrl", WINHTTP_ROUTINE_DEFINITION)
  end if
  error_code = 0
  error_msg = ""

  result = c_func(xWinHttpDetectAutoProxyConfigUrl, {dwAutoDetectFlags,
                                                     ppwstrAutoConfigUrl})
  if result = FALSE then
    error_msg = "WinHttpDetectAutoProxyConfigUrl failed"
    if f_debug then
      log_printf("Error %d: %s\n", {error_code, error_msg})
      flush(f_debug)
    end if
  end if
  return result
end function

--------------------------------------------------------------------------------

-- The WinHttpGetDefaultProxyConfiguration function retrieves the default WinHTTP proxy configuration from the registry.
--
-- Syntax
--   bool WINAPI WinHttpGetDefaultProxyConfiguration(
--     _Inout_ WINHTTP_PROXY_INFO *pProxyInfo
--   );
--
-- Parameters
--
--   pProxyInfo [in, out]
--
--       A pointer to a variable of type WINHTTP_PROXY_INFO that receives the default proxy configuration.
--
-- Return value
--
--   Returns TRUE if successful or FALSE otherwise. To retrieve a specific error message, call GetLastError. Error codes returned include the following.
--   Error Code  Description
--
--   ERROR_WINHTTP_INTERNAL_ERROR    An internal error has occurred.
--
--   ERROR_NOT_ENOUGH_MEMORY    Not enough memory was available to complete the requested operation. (Windows error code)
--
--
-- Remarks
--
--   WinHttpGetDefaultProxyConfiguration retrieves the proxy configuration set by WinHttpSetDefaultProxyConfiguration or ProxyCfg.exe.
--
--   The default proxy configuration can be overridden for a WinHTTP session by calling WinHttpSetOption and specifying the WINHTTP_OPTION_PROXY flag. WinHttpGetDefaultProxyConfiguration does not retrieve the configuration for the current session. It retrieves the configuration specified in the registry.
--
--   If the registry contains a list of proxy servers, the dwAccessType member of pProxyInfo is set to WINHTTP_ACCESS_TYPE_NAMED_PROXY. Otherwise, it is set to WINHTTP_ACCESS_TYPE_NO_PROXY.
--
--   WinHttpGetDefaultProxyConfiguration allocates memory for the string members of pProxyInfo. To free this memory, call GlobalFree.
--
--   Even when WinHTTP is used in asynchronous mode (that is, when WINHTTP_FLAG_ASYNC has been set in WinHttpOpen), this function operates synchronously. The return value indicates success or failure. To get extended error information, call GetLastError.
--<function>
--<name>WinHttpGetDefaultProxyConfiguration</name>
--<digest>retrieves the default WinHTTP proxy configuration from the registry.</digest>
--<desc>
--</desc>
--<param>
--<type></type>
--<name></name>
--<desc></desc>
--</param>
--<return>
--</return>
--<example>
--</example>
--<see_also>
--</see_also>
--</function>

public function WinHttpGetDefaultProxyConfiguration(atom pProxyInfo)
  integer result

  if not xWinHttpGetDefaultProxyConfiguration then
    xWinHttpGetDefaultProxyConfiguration = register_routine(winhttp,
            "WinHttpGetDefaultProxyConfiguration", WINHTTP_ROUTINE_DEFINITION)
  end if
  error_code = 0
  error_msg = ""

  result = c_func(xWinHttpGetDefaultProxyConfiguration, {pProxyInfo})
  if result = FALSE then
    error_msg = "WinHttpGetDefaultProxyConfiguration failed"
    if f_debug then
      log_printf("Error %d: %s\n", {error_code, error_msg})
      flush(f_debug)
    end if
  end if
  return result
end function

--------------------------------------------------------------------------------

-- The WinHttpGetIEProxyConfigForCurrentUser function retrieves the Internet Explorer proxy configuration for the current user.
--
-- Syntax
--   bool WINAPI WinHttpGetIEProxyConfigForCurrentUser(
--     _Inout_ WINHTTP_CURRENT_USER_IE_PROXY_CONFIG *pProxyConfig
--   );
--
-- Parameters
--
--   pProxyConfig [in, out]
--
--       A pointer, on input, to a WINHTTP_CURRENT_USER_IE_PROXY_CONFIG structure. On output, the structure contains the Internet Explorer proxy settings for the current active network connection (for example, LAN, dial-up, or VPN connection).
--
-- Return value
--
--   Returns TRUE if successful, or FALSE otherwise. For extended error information, call GetLastError. Among the error codes returned are the following.
--   Error Code  Description
--
--   ERROR_FILE_NOT_FOUND    No Internet Explorer proxy settings can be found.
--
--   ERROR_WINHTTP_INTERNAL_ERROR    An internal error has occurred.
--
--   ERROR_NOT_ENOUGH_MEMORY    Not enough memory was available to complete the requested operation. (Windows error code)
--
--
-- Remarks
--
--   In Internet Explorer, the proxy settings are found on the Connections tab of the Tools / Internet Options menu option. Proxy settings are configured on a per-connection basis; that is, the proxy settings for a LAN connection are separate from those for a dial-up or VPN connection. WinHttpGetIEProxyConfigForCurrentUser returns the proxy settings for the current active connection.
--
--   This function is useful in client applications running in network environments in which the Web Proxy Auto-Discovery (WPAD) protocol is not implemented (meaning that no Proxy Auto-Configuration file is available). If a PAC file is not available, then the WinHttpGetProxyForUrl function fails. The WinHttpGetIEProxyConfigForCurrentUser function can be used as a fall-back mechanism to discover a workable proxy configuration by retrieving the user's proxy configuration in Internet Explorer.
--
--   This function should not be used in a service process that does not impersonate a logged-on user.If the caller does not impersonate a logged on user, WinHTTP attempts to retrieve the Internet Explorer settings for the current service process: for example, the local service or the network service. If the Internet Explorer settings are not configured for these system accounts, the call to WinHttpGetIEProxyConfigForCurrentUser will fail.
--
--   The caller must free the lpszProxy, lpszProxyBypass and lpszAutoConfigUrl strings in the WINHTTP_CURRENT_USER_IE_PROXY_CONFIG structure if they are non-NULL. Use GlobalFree to free the strings.
--<function>
--<name>WinHttpGetIEProxyConfigForCurrentUser</name>
--<digest>retrieves the Internet Explorer proxy configuration for the current user.</digest>
--<desc>
--</desc>
--<param>
--<type></type>
--<name></name>
--<desc></desc>
--</param>
--<return>
--</return>
--<example>
--</example>
--<see_also>
--</see_also>
--</function>

public function WinHttpGetIEProxyConfigForCurrentUser(atom pProxyConfig)
  integer result

  if not xWinHttpGetIEProxyConfigForCurrentUser then
    xWinHttpGetIEProxyConfigForCurrentUser = register_routine(winhttp,
            "WinHttpGetIEProxyConfigForCurrentUser", WINHTTP_ROUTINE_DEFINITION)
  end if
  error_code = 0
  error_msg = ""

  result = c_func(xWinHttpGetIEProxyConfigForCurrentUser, {pProxyConfig})
  if result = FALSE then
    error_msg = "WinHttpGetIEProxyConfigForCurrentUser failed"
    if f_debug then
      log_printf("Error %d: %s\n", {error_code, error_msg})
      flush(f_debug)
    end if
  end if
  return result
end function

--------------------------------------------------------------------------------

-- The WinHttpGetProxyForUrl function retrieves the proxy data for the specified URL.
--
-- Syntax
--   bool WINAPI WinHttpGetProxyForUrl(
--     _In_  HINTERNET                 hSession,
--     _In_  LPCWSTR                   lpcwszUrl,
--     _In_  WINHTTP_AUTOPROXY_OPTIONS *pAutoProxyOptions,
--     _Out_ WINHTTP_PROXY_INFO        *pProxyInfo
--   );
--
-- Parameters
--
--   hSession [in]
--
--       The WinHTTP session handle returned by the WinHttpOpen function.
--   lpcwszUrl [in]
--
--       A pointer to a null-terminated Unicode string that contains the URL of the HTTP request that the application is preparing to send.
--   pAutoProxyOptions [in]
--
--       A pointer to a WINHTTP_AUTOPROXY_OPTIONS structure that specifies the auto-proxy options to use.
--   pProxyInfo [out]
--
--       A pointer to a WINHTTP_PROXY_INFO structure that receives the proxy setting. This structure is then applied to the request handle using the WINHTTP_OPTION_PROXY option. Free the lpszProxy and lpszProxyBypass strings contained in this structure (if they are non-NULL) using the GlobalFree function.
--
-- Return value
--
--   If the function succeeds, the function returns TRUE.
--
--   If the function fails, it returns FALSE. For extended error data, call GetLastError.
--
--   Possible error codes include the folllowing.
--   Error Code  Description
--
--   ERROR_WINHTTP_AUTO_PROXY_SERVICE_ERROR    Returned by WinHttpGetProxyForUrl when a proxy for the specified URL cannot be located.
--
--   ERROR_WINHTTP_BAD_AUTO_PROXY_SCRIPT    An error occurred executing the script code in the Proxy Auto-Configuration (PAC) file.
--
--   ERROR_WINHTTP_INCORRECT_HANDLE_TYPE    The type of handle supplied is incorrect for this operation.
--
--   ERROR_WINHTTP_INTERNAL_ERROR    An internal error has occurred.
--
--   ERROR_WINHTTP_INVALID_URL    The URL is invalid.
--
--   ERROR_WINHTTP_LOGIN_FAILURE    The login attempt failed. When this error is encountered, close the request handle with WinHttpCloseHandle. A new request handle must be created before retrying the function that originally produced this error.
--
--   ERROR_WINHTTP_OPERATION_CANCELLED    The operation was canceled, usually because the handle on which the request was operating was closed before the operation completed.
--
--   ERROR_WINHTTP_UNABLE_TO_DOWNLOAD_SCRIPT    The PAC file could not be downloaded. For example, the server referenced by the PAC URL may not have been reachable, or the server returned a 404 NOT FOUND response.
--
--   ERROR_WINHTTP_UNRECOGNIZED_SCHEME    The URL of the PAC file specified a scheme other than "http:" or "https:".
--
--   ERROR_NOT_ENOUGH_MEMORY    Not enough memory was available to complete the requested operation. (Windows error code)
--
--
-- Remarks
--
--   This function implements the Web Proxy Auto-Discovery (WPAD) protocol for automatically configuring the proxy settings for an HTTP request. The WPAD protocol downloads a Proxy Auto-Configuration (PAC) file, which is a script that identifies the proxy server to use for a given target URL. PAC files are typically deployed by the IT department within a corporate network environment. The URL of the PAC file can either be specified explicitly or WinHttpGetProxyForUrl can be instructed to automatically discover the location of the PAC file on the local network.
--
--   WinHttpGetProxyForUrl supports only ECMAScript-based PAC files.
--
--   WinHttpGetProxyForUrl must be called on a per-URL basis, because the PAC file can return a different proxy server for different URLs. This is useful because the PAC file enables an IT department to implement proxy server load balancing by mapping (hashing) the target URL (specified by the lpcwszUrl parameter) to a certain proxy in a proxy server array.
--
--   WinHttpGetProxyForUrl caches the autoproxy URL and the autoproxy script when auto-discovery is specified in the dwFlags member of the pAutoProxyOptions structure. For more information, see Autoproxy Cache.
--<function>
--<name>WinHttpGetProxyForUrl</name>
--<digest>retrieves the proxy data for the specified URL.</digest>
--<desc>
--</desc>
--<param>
--<type></type>
--<name></name>
--<desc></desc>
--</param>
--<return>
--</return>
--<example>
--</example>
--<see_also>
--</see_also>
--</function>

public function WinHttpGetProxyForUrl(atom hSession, atom lpcwszUrl,
                                      atom pAutoProxyOptions, atom pProxyInfo
)
  integer result

  if not xWinHttpGetProxyForUrl then
    xWinHttpGetProxyForUrl = register_routine(winhttp, "WinHttpGetProxyForUrl",
                                              WINHTTP_ROUTINE_DEFINITION)
  end if
  error_code = 0
  error_msg = ""

  result = c_func(xWinHttpGetProxyForUrl, {hSession, lpcwszUrl,
                                           pAutoProxyOptions, pProxyInfo})
  if result = FALSE then
    error_msg = "WinHttpGetProxyForUrl failed"
    if f_debug then
      log_printf("Error %d: %s\n", {error_code, error_msg})
      flush(f_debug)
    end if
  end if
  return result
end function

--------------------------------------------------------------------------------

-- The WinHttpOpen function initializes, for an application, the use of WinHTTP functions and returns a WinHTTP-session handle.
--
-- Syntax
--   HINTERNET WINAPI WinHttpOpen(
--     _In_opt_ LPCWSTR pwszUserAgent,
--     _In_     dword   dwAccessType,
--     _In_     LPCWSTR pwszProxyName,
--     _In_     LPCWSTR pwszProxyBypass,
--     _In_     dword   dwFlags
--   );
--
-- Parameters
--
--   pwszUserAgent [in, optional]
--       A pointer to a string variable that contains the name of the application or entity calling the WinHTTP functions. This name is used as the user agent in the HTTP protocol.
--
--   dwAccessType [in]
--     Type of access required. This can be one of the following values.
--
--     Value                               Meaning
--     WINHTTP_ACCESS_TYPE_NO_PROXY        Resolves all host names directly without a proxy.
--     WINHTTP_ACCESS_TYPE_DEFAULT_PROXY   Retrieves the static proxy or direct configuration from the registry. WINHTTP_ACCESS_TYPE_DEFAULT_PROXY does not inherit browser proxy settings. WinHTTP does not share any proxy settings with Internet Explorer.
--           The WinHTTP proxy configuration is set by one of these mechanisms.
--           The proxycfg.exe utility on Windows XP and Windows Server 2003 or earlier.
--           The netsh.exe utility on Windows Vista and Windows Server 2008 or later.
--           WinHttpSetDefaultProxyConfiguration on all platforms.
--     WINHTTP_ACCESS_TYPE_NAMED_PROXY     Passes requests to the proxy unless a proxy bypass list is supplied and the name to be resolved bypasses the proxy. In this case, this function uses WINHTTP_ACCESS_TYPE_NAMED_PROXY.
--
--   pwszProxyName [in]
--     A pointer to a string variable that contains the name of the proxy server
--     to use when proxy access is specified by setting dwAccessType to
--     WINHTTP_ACCESS_TYPE_NAMED_PROXY.
--     The WinHTTP functions recognize only CERN type proxies for HTTP. If
--     dwAccessType is not set to WINHTTP_ACCESS_TYPE_NAMED_PROXY, this
--     parameter must be set to WINHTTP_NO_PROXY_NAME.
--
--   pwszProxyBypass [in]
--       A pointer to a string variable that contains an optional semicolon delimited list of host names or IP addresses, or both, that should not be routed through the proxy when dwAccessType is set to WINHTTP_ACCESS_TYPE_NAMED_PROXY. The list can contain wildcard characters. Do not use an empty string, because the WinHttpOpen function uses it as the proxy bypass list. If this parameter specifies the "<local>" macro in the list as the only entry, this function bypasses any host name that does not contain a period. If dwAccessType is not set to WINHTTP_ACCESS_TYPE_NAMED_PROXY, this parameter must be set to WINHTTP_NO_PROXY_BYPASS.
--
--   dwFlags [in]
--       Unsigned long integer value that contains the flags that indicate various options affecting the behavior of this function. This parameter can have the following value.
--       Value  Meaning
--
--       WINHTTP_FLAG_ASYNC    Use the WinHTTP functions asynchronously. By default, all WinHTTP functions that use the returned HINTERNET handle are performed synchronously. When this flag is set, the caller needs to specify a callback function through WinHttpSetStatusCallback.
--
-- Return value
--
--   Returns a valid session handle if successful, or NULL otherwise. To retrieve extended error information, call GetLastError. Among the error codes returned are the following.
--   Error Code  Description
--
--   ERROR_WINHTTP_INTERNAL_ERROR    An internal error has occurred.
--
--   ERROR_NOT_ENOUGH_MEMORY    Not enough memory was available to complete the requested operation. (Windows error code)
--
--
-- Remarks
--
--   Even when WinHTTP is used in asynchronous mode (that is, when WINHTTP_FLAG_ASYNC has been set in WinHttpOpen), this function operates synchronously. The return value indicates success or failure. To retrieve extended error information, call GetLastError.
--
--   The WinHttpOpen function is the first of the WinHTTP functions called by an application. It initializes internal WinHTTP data structures and prepares for future calls from the application. When the application finishes using the WinHTTP functions, it must call WinHttpCloseHandle to free the session handle and any associated resources.
--
--   The application can make any number of calls to WinHttpOpen, though a single call is normally sufficient. Each call to WinHttpOpen opens a new session context. Because user data is not shared between multiple session contexts, an application that makes requests on behalf of multiple users should create a separate session for each user, so as not to share user-specific cookies and authentication state. The application should define separate behaviors for each WinHttpOpen instance, such as different proxy servers configured for each.
--
--   After the calling application has finished using the HINTERNET handle returned by WinHttpOpen, it must be closed using the WinHttpCloseHandle function.
--<function>
--<name>WinHttpOpen</name>
--<digest>initializes, for an application, the use of WinHTTP functions and returns a WinHTTP-session handle.</digest>
--<desc>
--</desc>
--<param>
--<type></type>
--<name></name>
--<desc></desc>
--</param>
--<return>
--</return>
--<example>
--</example>
--<see_also>
--</see_also>
--</function>

public function WinHttpOpen(sequence Agent, integer dwAccessType,
                            object ProxyName, object ProxyBypass,
                            integer dwFlags)
  atom pszAgentW, pszProxyW, pszProxyBypassW
  atom result

  if not xWinHttpOpen then
    xWinHttpOpen = register_routine(winhttp, "WinHttpOpen",
                                    WINHTTP_ROUTINE_DEFINITION)
  end if
  if sequence(Agent) then
    pszAgentW = allocate_wstring(Agent)
  else
    error_msg = "WinHttpOpen: Agent should be a sequence"
    return NULL
  end if
  if sequence(ProxyName) then
    pszProxyW = allocate_wstring(ProxyName)
  elsif ProxyName = NULL then
    pszProxyW = NULL
  else
    error_msg = "WinHttpOpen: ProxyName should be a sequence or NULL"
    return NULL
  end if
  if sequence(ProxyBypass) then
    pszProxyBypassW = allocate_wstring(ProxyBypass)
  elsif ProxyBypass = NULL then
    pszProxyBypassW = NULL
  else
    error_msg = "WinHttpOpen: ProxyBypass should be a sequence or NULL"
    return NULL
  end if

  error_code = 0
  error_msg = ""

  result = c_func(xWinHttpOpen, {pszAgentW, dwAccessType, pszProxyW, pszProxyBypassW, dwFlags})

  free(pszAgentW)
  if pszProxyW != NULL then free(pszProxyW) end if
  if pszProxyBypassW != NULL then free(pszProxyBypassW) end if
  if result = NULL then
    error_code = GetLastError()
    error_msg = "WinHttpAddRequestHeaders failed:\n  " &
                  FormatSystemError(error_code)
    if f_debug then
      log_printf("Error %d: %s\n", {error_code, error_msg})
      flush(f_debug)
    end if
  end if
  return result
end function

--------------------------------------------------------------------------------

-- The WinHttpOpenRequest function creates an HTTP request handle.
-- 
-- Syntax
-- HINTERNET WINAPI WinHttpOpenRequest(
--   _In_ HINTERNET hConnect,
--   _In_ LPCWSTR   pwszVerb,
--   _In_ LPCWSTR   pwszObjectName,
--   _In_ LPCWSTR   pwszVersion,
--   _In_ LPCWSTR   pwszReferrer,
--   _In_ LPCWSTR   *ppwszAcceptTypes,
--   _In_ dword     dwFlags
-- );
-- 
-- Parameters
-- 
--   hConnect [in]
--     HINTERNET connection handle to an HTTP session returned by WinHttpConnect.
-- 
--   pwszVerb [in]
--     Pointer to a string that contains the HTTP verb to use in the request.
--     If this parameter is NULL, the function uses GET as the HTTP verb. 
--     
--     Note This string should be all uppercase. Many servers treat HTTP verbs
--     as case-sensitive, and the Internet Engineering Task Force (IETF)
--     Requests for Comments (RFCs) spell these verbs using uppercase
--     characters only.
-- 
--   pwszObjectName [in]
--     Pointer to a string that contains the name of the target resource of the
--     specified HTTP verb. This is generally a file name, an executable
--     module, or a search specifier.
-- 
--   pwszVersion [in]
--     Pointer to a string that contains the HTTP version. If this parameter is
--     NULL, the function uses HTTP/1.1.
-- 
--   pwszReferrer [in]
--     Pointer to a string that specifies the URL of the document from which
--     the URL in the request pwszObjectName was obtained. If this parameter is
--     set to WINHTTP_NO_REFERER, no referring document is specified.
-- 
--   ppwszAcceptTypes [in]
--     Pointer to a null-terminated array of string pointers that specifies
--     media types accepted by the client. If this parameter is set to
--     WINHTTP_DEFAULT_ACCEPT_TYPES, no types are accepted by the client.
--     Typically, servers handle a lack of accepted types as indication that
--     the client accepts only documents of type "text/*"; that is, only text
--     documents--no pictures or other binary files. For a list of valid media
--     types, see Media Types defined by IANA at
--     http://www.iana.org/assignments/media-types/.
--     
--     Because there is no parameter to WinHttpOpenRequest
--     that specifies the number of elements in the AcceptTypes array, the API
--     expects a NULL element to indicate the end of the array.  Therefore, your
--     AcceptTypes array should look like:
--     
--     const wchar_t *att[] = { L"text/plain", L"multipart/signed", NULL };  //
--     array must have NULL terminator
-- 
--   dwFlags [in]
--     Unsigned long integer value that contains the Internet flag values. This
--     can be one or more of the following values:
--
--     Value                              Meaning
--     WINHTTP_FLAG_BYPASS_PROXY_CACHE    This flag provides the same behavior
--                                        as WINHTTP_FLAG_REFRESH.
--     WINHTTP_FLAG_ESCAPE_DISABLE        Unsafe characters in the URL passed
--                                        in for pwszObjectName are not
--                                        converted to escape sequences.
--     WINHTTP_FLAG_ESCAPE_DISABLE_QUERY  Unsafe characters in the query
--                                        component of the URL passed in for
--                                        pwszObjectName are not converted to
--                                        escape sequences.
--     WINHTTP_FLAG_ESCAPE_PERCENT        The string passed in for
--                                        pwszObjectName is converted from an
--                                        LPCWSTR to an LPSTR. All unsafe
--                                        characters are converted to an escape
--                                        sequence including the percent symbol.
--                                        By default, all unsafe characters
--                                        except the percent symbol are
--                                        converted to an escape sequence.
--     WINHTTP_FLAG_NULL_CODEPAGE         The string passed in for
--                                        pwszObjectName is assumed to consist
--                                        of valid ANSI characters represented
--                                        by WCHAR. No check are done for
--                                        unsafe characters.
--                                        Windows 7:  This option is obsolete.
--     WINHTTP_FLAG_REFRESH               Indicates that the request should be
--                                        forwarded to the originating server
--                                        rather than sending a cached version
--                                        of a resource from a proxy server.
--                                        When this flag is used, a "Pragma:
--                                        no-cache" header is added to the
--                                        request handle. When creating an HTTP/
--                                        1.1 request header, a "Cache-Control:
--                                        no-cache" is also added.
--     WINHTTP_FLAG_SECURE                Uses secure transaction semantics.
--                                        This translates to using Secure
--                                        Sockets Layer (SSL)/Transport Layer
--                                        Security (TLS).
-- 
-- Return value
-- 
--   Returns a valid HTTP request handle if successful, or NULL if not. For
--   extended error information, call GetLastError. Among the error codes
--   returned are the following.
--   
--   Error Code                            Description
--   ERROR_WINHTTP_INCORRECT_HANDLE_TYPE   The type of handle supplied is
--                                         incorrect for this operation.
--   ERROR_WINHTTP_INTERNAL_ERROR          An internal error has occurred.
--   ERROR_WINHTTP_INVALID_URL             The URL is invalid.
--   ERROR_WINHTTP_OPERATION_CANCELLED     The operation was canceled, usually
--                                         because the handle on which the
--                                         request was operating was closed
--                                         before the operation completed.
--   ERROR_WINHTTP_UNRECOGNIZED_SCHEME     The URL specified a scheme other than
--                                         "http:" or "https:".
--   ERROR_NOT_ENOUGH_MEMORY               Not enough memory was available to
--                                         complete the requested operation.
--                                         (Windows error code)
--  
-- Remarks
-- 
--   Even when WinHTTP is used in asynchronous mode (that is, when
--   WINHTTP_FLAG_ASYNC has been set in WinHttpOpen), this function operates
--   synchronously. The return value indicates success or failure. To get
--   extended error information, call GetLastError. 
--   
--   The WinHttpOpenRequest function creates a new HTTP request handle and
--   stores the specified parameters in that handle. An HTTP request handle
--   holds a request to send to an HTTP server and contains all
--   RFC822/MIME/HTTP headers to be sent as part of the request. 
--   
--   If pwszVerb is set to "HEAD", the Content-Length header is ignored. 
--   
--   If a status callback function has been installed with
--   WinHttpSetStatusCallback, then a WINHTTP_CALLBACK_STATUS_HANDLE_CREATED
--   notification indicates that WinHttpOpenRequest has created a request
--   handle. 
--   
--   After the calling application finishes using the HINTERNET handle
--   returned by WinHttpOpenRequest, it must be closed using the
--   WinHttpCloseHandle function.
--<function>
--<name>WinHttpOpenRequest</name>
--<digest>creates an HTTP request handle.</digest>
--<desc>
--</desc>
--<param>
--<type></type>
--<name></name>
--<desc></desc>
--</param>
--<return>
--</return>
--<example>
--</example>
--<see_also>
--</see_also>
--</function>

public function WinHttpOpenRequest(atom hConnect, object Verb,
                                   object ObjectName, object Version,
                                   object Referrer, object AcceptTypes,
                                   integer dwFlags)
  atom pwszVerb, pwszObjectName, pwszVersion, pwszReferrer, ppwszAcceptTypes
  atom result
  sequence plist

  if not xWinHttpOpenRequest then
    xWinHttpOpenRequest = register_routine(winhttp, "WinHttpOpenRequest",
                                           WINHTTP_ROUTINE_DEFINITION)
  end if
  if sequence(Verb) then
    pwszVerb = allocate_wstring(Verb)
  elsif Verb = NULL then
    pwszVerb = NULL
  else
    error_msg = "WinHttpOpenRequest: Verb should be a sequence"
    return NULL
  end if
  if sequence(ObjectName) then
    pwszObjectName = allocate_wstring(ObjectName)
  elsif ObjectName = NULL then
    pwszObjectName = NULL
  else
    error_msg = "WinHttpOpenRequest: ObjectName should be a sequence or NULL"
    return NULL
  end if
  if sequence(Version) then
    pwszVersion = allocate_wstring(Version)
  elsif Version = NULL then
    pwszVersion = NULL
  else
    error_msg = "WinHttpOpenRequest: Version should be a sequence or NULL"
    return NULL
  end if
  if sequence(Referrer) then
    pwszReferrer = allocate_wstring(Referrer)
  elsif Referrer = NULL then
    pwszReferrer = NULL
  else
    error_msg = "WinHttpOpenRequest: Referrer should be a sequence or NULL"
    return NULL
  end if
  plist = {}
  ppwszAcceptTypes = allocate(4 * (length(AcceptTypes)+1))
--  for i = 1 to length(AcceptTypes) do
--    plist = append(plist, allocate_string(ascii_to_utf16(AcceptTypes[i])))
--  end for
--  plist = append(plist, NULL)
--  poke4(ppwszAcceptTypes, plist)
  poke4(ppwszAcceptTypes, AcceptTypes & {0})
  
  error_code = 0
  error_msg = ""

  result = c_func(xWinHttpOpenRequest, {hConnect, pwszVerb, pwszObjectName,
                                        pwszVersion, pwszReferrer,
                                        ppwszAcceptTypes, dwFlags})
  if pwszVerb != NULL then free(pwszVerb) end if
  if pwszObjectName != NULL then free(pwszObjectName) end if
  if pwszVersion != NULL then free(pwszVersion) end if
  if pwszReferrer != NULL then free(pwszReferrer) end if
  for i = 1 to length(plist) do
    if plist[i] != NULL then free(plist[i]) end if
  end for
  free(ppwszAcceptTypes)
  if result = NULL then
    error_code = GetLastError()
    error_msg = "WinHttpOpenRequest failed:\n  " &
                  FormatSystemError(error_code)
    if f_debug then
      log_printf("Error %d: %s\n", {error_code, error_msg})
      flush(f_debug)
    end if
  end if
  return result
end function

--------------------------------------------------------------------------------

-- The WinHttpQueryAuthSchemes function returns the authorization schemes that are supported by the server.
--
-- Syntax
--   bool WINAPI WinHttpQueryAuthSchemes(
--     _In_  HINTERNET hRequest,
--     _Out_ LPDWORD   lpdwSupportedSchemes,
--     _Out_ LPDWORD   lpdwFirstScheme,
--     _Out_ LPDWORD   pdwAuthTarget
--   );
--
-- Parameters
--
--   hRequest [in]
--
--       Valid HINTERNET handle returned by WinHttpOpenRequest
--   lpdwSupportedSchemes [out]
--
--       An unsigned integer that specifies a flag that contains the supported authentication schemes. This parameter can return one or more flags that are identified in the following table.
--       Value  Meaning
--
--       WINHTTP_AUTH_SCHEME_BASIC    Indicates basic authentication is available.
--
--       WINHTTP_AUTH_SCHEME_NTLM    Indicates NTLM authentication is available.
--
--       WINHTTP_AUTH_SCHEME_PASSPORT    Indicates passport authentication is available.
--
--       WINHTTP_AUTH_SCHEME_DIGEST    Indicates digest authentication is available.
--
--       WINHTTP_AUTH_SCHEME_NEGOTIATE    Selects between NTLM and Kerberos authentication.
--
--
--   lpdwFirstScheme [out]
--
--       An unsigned integer that specifies a flag that contains the first authentication scheme listed by the server. This parameter can return one or more flags that are identified in the following table.
--       Value  Meaning
--
--       WINHTTP_AUTH_SCHEME_BASIC    Indicates basic authentication is first.
--
--       WINHTTP_AUTH_SCHEME_NTLM    Indicates NTLM authentication is first.
--
--       WINHTTP_AUTH_SCHEME_PASSPORT    Indicates passport authentication is first.
--
--       WINHTTP_AUTH_SCHEME_DIGEST    Indicates digest authentication is first.
--
--       WINHTTP_AUTH_SCHEME_NEGOTIATE    Selects between NTLM and Kerberos authentication.
--
--
--   pdwAuthTarget [out]
--
--       An unsigned integer that specifies a flag that contains the authentication target. This parameter can return one or more flags that are identified in the following table.
--       Value  Meaning
--
--       WINHTTP_AUTH_TARGET_SERVER    Authentication target is a server. Indicates that a 401 status code has been received.
--
--       WINHTTP_AUTH_TARGET_PROXY    Authentication target is a proxy. Indicates that a 407 status code has been received.
--
--
--
-- Return value
--
--   Returns TRUE if successful, or FALSE if unsuccessful. To get extended error information, call GetLastError. The following table identifies the error codes that are returned.
--   Error Code  Description
--
--   ERROR_WINHTTP_INCORRECT_HANDLE_TYPE    The type of handle supplied is incorrect for this operation.
--
--   ERROR_WINHTTP_INTERNAL_ERROR    An internal error has occurred.
--
--   ERROR_NOT_ENOUGH_MEMORY    Not enough memory was available to complete the requested operation. (Windows error code)
--
--
-- Remarks
--
--   Even when WinHTTP is used in asynchronous mode (that is, when WINHTTP_FLAG_ASYNC is set in WinHttpOpen), this function operates synchronously. The return value indicates success or failure. To get extended error information, call GetLastError.
--
--   WinHttpQueryAuthSchemes cannot be used before calling WinHttpQueryHeaders.
--<function>
--<name>WinHttpQueryAuthSchemes</name>
--<digest>returns the authorization schemes that are supported by the server.</digest>
--<desc>
--</desc>
--<param>
--<type></type>
--<name></name>
--<desc></desc>
--</param>
--<return>
--</return>
--<example>
--</example>
--<see_also>
--</see_also>
--</function>

public function WinHttpQueryAuthSchemes(atom hRequest,
                                        atom lpdwSupportedSchemes,
                                        atom lpdwFirstScheme,
                                        atom pdwAuthTarget)
  integer result

  if not xWinHttpQueryAuthSchemes then
    xWinHttpQueryAuthSchemes = register_routine(winhttp,
            "WinHttpQueryAuthSchemes", WINHTTP_ROUTINE_DEFINITION)
  end if
  error_code = 0
  error_msg = ""

  result = c_func(xWinHttpQueryAuthSchemes, {hRequest, lpdwSupportedSchemes,
                                             lpdwFirstScheme, pdwAuthTarget})
  if result = FALSE then
    error_msg = "WinHttpQueryAuthSchemes failed"
    if f_debug then
      log_printf("Error %d: %s\n", {error_code, error_msg})
      flush(f_debug)
    end if
  end if
  return result
end function

--------------------------------------------------------------------------------

-- Remarks
--
--   Even when WinHTTP is used in asynchronous mode (that is, when
--   WINHTTP_FLAG_ASYNC has been set in WinHttpOpen), this function can operate
--   either synchronously or asynchronously.
--
--   If it returns FALSE, it failed and you can call GetLastError to get
--   extended error information.
--
--   If it returns TRUE, use the WINHTTP_CALLBACK_STATUS_DATA_AVAILABLE
--   completion to determine whether this function was successful and the value
--   of the parameters. The WINHTTP_CALLBACK_STATUS_REQUEST_ERROR completion
--   indicates that the operation completed asynchronously, but failed.
--
--   Warning  When WinHTTP is used in asynchronous mode, always set the
--            lpdwNumberOfBytesAvailable parameter to NULL and retrieve the
--            bytes available in the callback function; otherwise, a memory
--            fault can occur.
--
--   The amount of data that remains is not recalculated until all available
--   data indicated by the call to WinHttpQueryDataAvailable is read.
--
--   Use the return value of WinHttpReadData to determine when a response has
--   been completely read.
--   Important  Do not use the return value of WinHttpQueryDataAvailable to
--   determine whether the end of a response has been reached, because not all
--   servers terminate responses properly, and an improperly terminated response
--   causes WinHttpQueryDataAvailable to anticipate more data.
--
--   For HINTERNET handles created by the WinHttpOpenRequest function and sent
--   by WinHttpSendRequest, a call to WinHttpReceiveResponse must be made on the
--   handle before WinHttpQueryDataAvailable can be used.
--
--   If a status callback function has been installed with
--   WinHttpSetStatusCallback, then those of the following notifications that
--   have been set in the dwNotificationFlags parameter of
--   WinHttpSetStatusCallback indicate progress in checking for available data:
--       WINHTTP_CALLBACK_STATUS_RECEIVING_RESPONSE
--       WINHTTP_CALLBACK_STATUS_RESPONSE_RECEIVED
--       WINHTTP_CALLBACK_STATUS_DATA_AVAILABLE
--
--<function>
--<name>WinHttpQueryDataAvailable</name>
--<digest>returns the amount of data, in bytes, available to be read with WinHttpReadData.</digest>
--<desc>
--</desc>
--<param>
--<type>atom</type>
--<name>hRequest</name>
--<desc>A valid HINTERNET handle returned by WinHttpOpenRequest.</desc>
--</param>
--<return>
-- number of bytes of data that are available to read immediately by a
-- subsequent call to WinHttpReadData.
--
-- If no data is available and the end of the file has not been reached, one of
-- two things happens:
-- * If the session is synchronous, the request waits until data becomes
--   available.
-- * If the session is asynchronous, the function returns TRUE, and when data
--   becomes available, calls the callback function with
--   WINHTTP_STATUS_CALLBACK_DATA_AVAILABLE and indicates the number of bytes
--   immediately available to read by calling WinHttpReadData.
--</return>
--<example>
--</example>
--<see_also>
--</see_also>
--</function>

public function WinHttpQueryDataAvailable(atom hRequest)
  atom lpdwNumberOfBytesAvailable
  integer result, BytesAvailable

  if not xWinHttpQueryDataAvailable then
    xWinHttpQueryDataAvailable = register_routine(winhttp,
            "WinHttpQueryDataAvailable", WINHTTP_ROUTINE_DEFINITION)
  end if
  lpdwNumberOfBytesAvailable = allocate(4)

  error_code = 0
  error_msg = ""

  result = c_func(xWinHttpQueryDataAvailable, {hRequest,
                                               lpdwNumberOfBytesAvailable})
  if result = TRUE then
    BytesAvailable = peek4u(lpdwNumberOfBytesAvailable)
  end if
  free(lpdwNumberOfBytesAvailable)
  if result = TRUE then
    return BytesAvailable
  else
    error_msg = "WinHttpQueryDataAvailable failed"
    if f_debug then
      log_printf("Error %d: %s\n", {error_code, error_msg})
      flush(f_debug)
    end if
    return 0
  end if
end function

--------------------------------------------------------------------------------

-- The WinHttpQueryHeaders function retrieves header information associated with
-- an HTTP request.
--
-- Syntax
--   bool WINAPI WinHttpQueryHeaders(
--     _In_     HINTERNET hRequest,
--     _In_     dword     dwInfoLevel,
--     _In_opt_ LPCWSTR   pwszName,
--     _Out_    LPVOID    lpBuffer,
--     _Inout_  LPDWORD   lpdwBufferLength,
--     _Inout_  LPDWORD   lpdwIndex
--   );
--
-- Parameters
--
--   hRequest [in]
--     HINTERNET request handle returned by WinHttpOpenRequest.
--     WinHttpReceiveResponse must have been called for this handle and have
--     completed before WinHttpQueryHeaders is called.
--
--   dwInfoLevel [in]
--     Value of type dword that specifies a combination of attribute and
--     modifier flags listed on the Query Info Flags page. These attribute and
--     modifier flags indicate that the information is being requested and how
--     it is to be formatted.
--
--   pwszName [in, optional]
--     Pointer to a string that contains the header name. If the flag in
--     dwInfoLevel is not WINHTTP_QUERY_CUSTOM, set this parameter to
--     WINHTTP_HEADER_NAME_BY_INDEX.
--
--   lpBuffer [out]
--     Pointer to the buffer that receives the information. Setting this
--     parameter to WINHTTP_NO_OUTPUT_BUFFER causes this function to return
--     FALSE. Calling GetLastError then returns ERROR_INSUFFICIENT_BUFFER and
--     lpdwBufferLength contains the number of bytes required to hold the
--     requested information.
--
--   lpdwBufferLength [in, out]
--     Pointer to a value of type dword that specifies the length of the data
--     buffer, in bytes. When the function returns, this parameter contains the
--     pointer to a value that specifies the length of the information written
--     to the buffer. When the function returns strings, the following rules
--     apply.
--
--     If the function succeeds, lpdwBufferLength specifies the length of the
--     string, in bytes, minus 2 for the terminating null.
--     If the function fails and ERROR_INSUFFICIENT_BUFFER is returned,
--     lpdwBufferLength specifies the number of bytes that the application must
--     allocate to receive the string.
--
--   lpdwIndex [in, out]
--     Pointer to a zero-based header index used to enumerate multiple headers
--     with the same name. When calling the function, this parameter is the
--     index of the specified header to return. When the function returns, this
--     parameter is the index of the next header. If the next index cannot be
--     found, ERROR_WINHTTP_HEADER_NOT_FOUND is returned. Set this parameter to
--     WINHTTP_NO_HEADER_INDEX to specify that only the first occurrence of a
--     header should be returned.
--
-- Return value
--   Returns TRUE if successful, or FALSE otherwise. To get extended error
--   information, call GetLastError. Among the error codes returned are the
--   following.
--   Error Code                       Description
--   ERROR_WINHTTP_HEADER_NOT_FOUND   The requested header could not be located.
--   ERROR_WINHTTP_INCORRECT_HANDLE_STATE  The requested operation cannot be
--                                    carried out because the handle supplied is
--                                    not in the correct state.
--   ERROR_WINHTTP_INCORRECT_HANDLE_TYPE   The type of handle supplied is
--                                    incorrect for this operation.
--   ERROR_WINHTTP_INTERNAL_ERROR     An internal error has occurred.
--   ERROR_NOT_ENOUGH_MEMORY          Not enough memory was available to
--                                    complete the requested operation. (Windows
--                                    error code)
--
-- Remarks
--   Even when WinHTTP is used in asynchronous mode (that is, when
--   WINHTTP_FLAG_ASYNC has been set in WinHttpOpen), this function operates
--   synchronously. The return value indicates success or failure. To get
--   extended error information, call GetLastError.
--
--   By default WinHttpQueryHeaders returns a string. However, you can request
--   data in the form of a SYSTEMTIME structure or dword by including the
--   appropriate modifier flag in dwInfoLevel. The following table shows the
--   possible data types that WinHttpQueryHeaders can return along with the
--   modifier flag that you use to select that data type.
--   Data type    Modifier flag
--   LPCWSTR      Default. No modifier flag required.
--   SYSTEMTIME   WINHTTP_QUERY_FLAG_SYSTEMTIME
--   dword        WINHTTP_QUERY_FLAG_NUMBER
--<function>
--<name>WinHttpQueryHeaders</name>
--<digest>retrieve HTTP headers</digest>
--<desc>
--</desc>
--<param>
--<type>atom</type>
--<name>hRequest</name>
--<desc>
-- Valid HINTERNET handle returned by WinHttpOpenRequest. Wait until
-- WinHttpSendRequest has completed before calling this function.
--</desc>
--</param>
--<return>
--</return>
--<example>
--</example>
--<see_also>
--</see_also>
--</function>

public function WinHttpQueryHeaders(atom hRequest)
  integer dwSize
  sequence Buffer
  atom lpOutBuffer, lpdwSize
  integer bResults
  
  if not xWinHttpQueryHeaders then
    xWinHttpQueryHeaders = register_routine(winhttp, "WinHttpQueryHeaders",
                                            WINHTTP_ROUTINE_DEFINITION)
  end if
  lpdwSize = allocate(4)
  Buffer = ""
  bResults = FALSE
  
  -- First, use WinHttpQueryHeaders to obtain the size of the buffer.
  lpOutBuffer = NULL
  dwSize = 0
  poke4(lpdwSize, dwSize)

  bResults = c_func(xWinHttpQueryHeaders, {
                      hRequest, WINHTTP_QUERY_RAW_HEADERS_CRLF,
                      WINHTTP_HEADER_NAME_BY_INDEX, lpOutBuffer,
                      lpdwSize, WINHTTP_NO_HEADER_INDEX})
  
  -- if there is a header, an error ERROR_INSUFFICIENT_BUFFER should appear
  if GetLastError() = ERROR_INSUFFICIENT_BUFFER then
    -- Allocate memory for the buffer.
    dwSize      = peek4u(lpdwSize)
    lpOutBuffer = allocate(dwSize)
  
    -- Now, use WinHttpQueryHeaders to retrieve the header.
    bResults = c_func(xWinHttpQueryHeaders, {
                        hRequest, WINHTTP_QUERY_RAW_HEADERS_CRLF,
                        WINHTTP_HEADER_NAME_BY_INDEX, lpOutBuffer,
                        lpdwSize, WINHTTP_NO_HEADER_INDEX})
    dwSize = peek4u(lpdwSize)
    Buffer = peek_wstring(lpOutBuffer)

    -- Free the allocated memory.
    free(lpOutBuffer)
  end if

  free(lpdwSize)
  
  if bResults = TRUE then
    return Buffer
  else
    error_code = GetLastError()
    error_msg = "WinHttpQueryHeaders failed:\n  " &
                  FormatSystemError(error_code)
    if f_debug then
      log_printf("Error %d: %s\n", {error_code, error_msg})
      flush(f_debug)
    end if
    return 0
  end if
end function

--------------------------------------------------------------------------------

--<function>
--<name>WinHttpQueryStatusCode</name>
--<digest>returns HTTP Status code</digest>
--<desc>
--</desc>
--<param>
--<type>atom</type>
--<name>hRequest</name>
--<desc>
-- Valid HINTERNET handle returned by WinHttpOpenRequest. Wait until
-- WinHttpSendRequest has completed before calling this function.
--</desc>
--</param>
--<return>
--</return>
--<example>
--</example>
--<see_also>
--</see_also>
--</function>

public function WinHttpQueryStatusCode(atom hRequest)
  atom lpdwStatusCode, lpdwSize, code
  integer bResults

  if not xWinHttpQueryHeaders then
    xWinHttpQueryHeaders = register_routine(winhttp, "WinHttpQueryHeaders",
                                            WINHTTP_ROUTINE_DEFINITION)
  end if
  lpdwSize = allocate(4)
  code = 0
  bResults = FALSE

  lpdwStatusCode = allocate(4)
  poke4(lpdwSize, 4)

  bResults = c_func(xWinHttpQueryHeaders, {hRequest,
                      or_all({WINHTTP_QUERY_STATUS_CODE,WINHTTP_QUERY_FLAG_NUMBER}),
                      WINHTTP_HEADER_NAME_BY_INDEX, lpdwStatusCode,
                      lpdwSize, WINHTTP_NO_HEADER_INDEX})

  code = peek4u(lpdwStatusCode)
  free(lpdwStatusCode)
  free(lpdwSize)

  if bResults = TRUE then
    return code
  else
    error_code = GetLastError()
    error_msg = "WinHttpQueryStatusCode failed:\n  " &
                  FormatSystemError(error_code)
    if f_debug then
      log_printf("Error %d: %s\n", {error_code, error_msg})
      flush(f_debug)
    end if
    return 0
  end if
end function

--------------------------------------------------------------------------------

-- The WinHttpQueryOption function queries an Internet option on the specified handle.
--
-- Syntax
--   bool WINAPI WinHttpQueryOption(
--     _In_    HINTERNET hInternet,
--     _In_    dword     dwOption,
--     _Out_   LPVOID    lpBuffer,
--     _Inout_ LPDWORD   lpdwBufferLength
--   );
--
-- Parameters
--
--   hInternet [in]
--
--       An HINTERNET handle on which to query information. Note that this can be either a Session handle or a Request handle, depending on what option is being queried; see the Option Flags topic to determine which handle is appropriate to use in querying a particular option.
--   dwOption [in]
--
--       An unsigned long integer value that contains the Internet option to query. This can be one of the Option Flags values.
--   lpBuffer [out]
--
--       A pointer to a buffer that receives the option setting. Strings returned by the WinHttpQueryOption function are globally allocated, so the calling application must globally free the string when it finishes using it. Setting this parameter to NULL causes this function to return FALSE. Calling GetLastError then returns ERROR_INSUFFICIENT_BUFFER and lpdwBufferLength contains the number of bytes required to hold the requested information.
--   lpdwBufferLength [in, out]
--
--       A pointer to an unsigned long integer variable that contains the length of lpBuffer, in bytes. When the function returns, the variable receives the length of the data placed into lpBuffer. If GetLastError returns ERROR_INSUFFICIENT_BUFFER, this parameter receives the number of bytes required to hold the requested information.
--
-- Return value
--
--   Returns TRUE if successful, or FALSE otherwise. To get a specific error message, call GetLastError. Among the error codes returned are the following.
--   Error Code  Description
--
--   ERROR_WINHTTP_INCORRECT_HANDLE_STATE    The requested operation cannot be carried out because the handle supplied is not in the correct state.
--
--   ERROR_WINHTTP_INCORRECT_HANDLE_TYPE    The type of handle supplied is incorrect for this operation.
--
--   ERROR_WINHTTP_INTERNAL_ERROR    An internal error has occurred.
--
--   ERROR_WINHTTP_INVALID_OPTION    An invalid option value was specified.
--
--   ERROR_NOT_ENOUGH_MEMORY    Not enough memory was available to complete the requested operation. (Windows error code)
--
--
-- Remarks
--
--   Even when WinHTTP is used in asynchronous mode (that is, when WINHTTP_FLAG_ASYNC has been set in WinHttpOpen), this function operates synchronously. The return value indicates success or failure. To get extended error information, call GetLastError.
--
--   GetLastError returns the ERROR_INVALID_PARAMETER if an option flag that is invalid for the specified handle type is passed to the dwOption parameter.
--
--<function>
--<name>WinHttpQueryOption</name>
--<digest>queries an Internet option on the specified handle.</digest>
--<desc>
--</desc>
--<param>
--<type></type>
--<name></name>
--<desc></desc>
--</param>
--<return>
--</return>
--<example>
--</example>
--<see_also>
--</see_also>
--</function>

public function WinHttpQueryOption(atom hInternet, integer dwOption)
  atom lpBuffer, lpdwBufferLength
  object result

  if not xWinHttpQueryOption then
    xWinHttpQueryOption = register_routine(winhttp, "WinHttpQueryOption",
                                           WINHTTP_ROUTINE_DEFINITION)
  end if
  lpBuffer = allocate(128 + 1)  -- 128 Chars initially
  lpdwBufferLength = allocate(4)
  poke4(lpdwBufferLength, 128)    -- set size of message

  error_code = 0
  error_msg = ""

  result = c_func(xWinHttpQueryOption, {hInternet, dwOption, lpBuffer,
                                        lpdwBufferLength})
  if result = FALSE then
    if GetLastError() = ERROR_INSUFFICIENT_BUFFER  then
     -- the buffer was smaller than needed
      free(lpBuffer)
      lpBuffer = allocate(peek4u(lpdwBufferLength))

      error_code = 0
      error_msg = ""

      result = c_func(xWinHttpQueryOption, {hInternet, dwOption, lpBuffer,
                                          lpdwBufferLength})
    end if
  end if
  if result = TRUE then
    result = peek_wstring(lpBuffer)
  else
    error_code = GetLastError()
    error_msg = "WinHttpQueryOption failed:\n  " &
                  FormatSystemError(error_code)
    if f_debug then
      log_printf("Error %d: %s\n", {error_code, error_msg})
      flush(f_debug)
    end if
  end if
  free(lpBuffer)
  free(lpdwBufferLength)
  return result
end function

--------------------------------------------------------------------------------

-- The WinHttpReadData function reads data from a handle opened by the WinHttpOpenRequest function.
--
-- Syntax
--   bool WINAPI WinHttpReadData(
--     _In_  HINTERNET hRequest,
--     _Out_ LPVOID    lpBuffer,
--     _In_  dword     dwNumberOfBytesToRead,
--     _Out_ LPDWORD   lpdwNumberOfBytesRead
--   );
--
-- Parameters
--
--   hRequest [in]
--
--       Valid HINTERNET handle returned from a previous call to WinHttpOpenRequest. WinHttpReceiveResponse or WinHttpQueryDataAvailable must have been called for this handle and must have completed before WinHttpReadData is called. Although calling WinHttpReadData immediately after completion of WinHttpReceiveResponse avoids the expense of a buffer copy, doing so requires that the application use a fixed-length buffer for reading.
--   lpBuffer [out]
--
--       Pointer to a buffer that receives the data read. Make sure that this buffer remains valid until WinHttpReadData has completed.
--   dwNumberOfBytesToRead [in]
--
--       Unsigned long integer value that contains the number of bytes to read.
--   lpdwNumberOfBytesRead [out]
--
--       Pointer to an unsigned long integer variable that receives the number of bytes read. WinHttpReadData sets this value to zero before doing any work or error checking. When using WinHTTP asynchronously, always set this parameter to NULL and retrieve the information in the callback function; not doing so can cause a memory fault.
--
-- Return value
--
--   Returns TRUE if successful, or FALSE otherwise. For extended error information, call GetLastError. The following table identifies the error codes that are returned.
--   Error Code  Description
--
--   ERROR_WINHTTP_CONNECTION_ERROR    The connection with the server has been reset or terminated, or an incompatible SSL protocol was encountered. For example, WinHTTP 5.1 does not support SSL2 unless the client specifically enables it.
--
--   ERROR_WINHTTP_INCORRECT_HANDLE_STATE    The requested operation cannot be carried out because the handle supplied is not in the correct state.
--
--   ERROR_WINHTTP_INCORRECT_HANDLE_TYPE    The type of handle supplied is incorrect for this operation.
--
--   ERROR_WINHTTP_INTERNAL_ERROR    An internal error has occurred.
--
--   ERROR_WINHTTP_OPERATION_CANCELLED    The operation was canceled, usually because the handle on which the request was operating was closed before the operation completed.
--
--   ERROR_WINHTTP_RESPONSE_DRAIN_OVERFLOW    Returned when an incoming response exceeds an internal WinHTTP size limit.
--
--   ERROR_WINHTTP_TIMEOUT    The request has timed out.
--
--   ERROR_NOT_ENOUGH_MEMORY    Not enough memory was available to complete the requested operation. (Windows error code)
--
--
-- Remarks
--
--   Starting in Windows Vista and Windows Server 2008, WinHttp enables applications to perform chunked transfer encoding on data sent to the server. When the Transfer-Encoding header is present on the WinHttp response, WinHttpReadData strips the chunking information before giving the data to the application.
--
--   Even when WinHTTP is used in asynchronous mode (that is, when WINHTTP_FLAG_ASYNC has been set in WinHttpOpen), this function can operate either synchronously or asynchronously. If this function returns FALSE, this function failed and you can call GetLastError to get extended error information. If this function returns TRUE, use the WINHTTP_CALLBACK_STATUS_READ_COMPLETE completion to determine whether this function was successful and the value of the parameters. The WINHTTP_CALLBACK_STATUS_REQUEST_ERROR completion indicates that the operation completed asynchronously, but failed.
--   Warning  When WinHTTP is used in asynchronous mode, always set the lpdwNumberOfBytesRead parameter to NULL and retrieve the bytes read in the callback function; otherwise, a memory fault can occur.
--
--
--   When the read buffer is very small, WinHttpReadData might complete synchronously. If the WINHTTP_CALLBACK_STATUS_READ_COMPLETE completion triggers another call to WinHttpReadData, the situation can result in a stack overflow. In general, it is best to use a read buffer that is comparable in size, or larger than the internal read buffer used by WinHTTP, which is 8 KB.
--
--   If you are using WinHttpReadData synchronously, and the return value is TRUE and the number of bytes read is zero, the transfer has been completed and there are no more bytes to read on the handle. This is analogous to reaching end-of-file in a local file. If you are using the function asynchronously, the WINHTTP_CALLBACK_STATUS_READ_COMPLETE callback is called with the dwStatusInformationLength parameter set to zero when the end of a response is found.
--
--   WinHttpReadData tries to fill the buffer pointed to by lpBuffer until there is no more data available from the response. If sufficient data has not arrived from the server, the buffer is not filled.
--
--   For HINTERNET handles created by the WinHttpOpenRequest function and sent by WinHttpSendRequest, a call to WinHttpReceiveResponse must be made on the handle before WinHttpReadData can be used.
--
--   Single byte characters retrieved with WinHttpReadData are not converted to multi-byte characters.
--
--   When the read buffer is very small, WinHttpReadData may complete synchronously, and if the WINHTTP_CALLBACK_STATUS_READ_COMPLETE completion then triggers another call to WinHttpReadData, a stack overflow can result. It is best to use a read buffer that is 8 Kilobytes or larger in size.
--
--   If sufficient data has not arrived from the server, WinHttpReadData does not entirely fill the buffer pointed to by lpBuffer. The buffer must be large enough at least to hold the HTTP headers on the first read, and when reading HTML encoded directory entries, it must be large enough to hold at least one complete entry.
--
--   If a status callback function has been installed by using WinHttpSetStatusCallback, then those of the following notifications that have been set in the dwNotificationFlags parameter of WinHttpSetStatusCallback indicate progress in checking for available data:
--
--       WINHTTP_CALLBACK_STATUS_RECEIVING_RESPONSE
--       WINHTTP_CALLBACK_STATUS_RESPONSE_RECEIVED
--       WINHTTP_CALLBACK_STATUS_CONNECTION_CLOSED
--       WINHTTP_CALLBACK_STATUS_READ_COMPLETE
--
--<function>
--<name>WinHttpReadData</name>
--<digest>reads data from a handle opened by the WinHttpOpenRequest function.</digest>
--<desc>
--</desc>
--<param>
--<type></type>
--<name></name>
--<desc></desc>
--</param>
--<return>
--</return>
--<example>
--</example>
--<see_also>
--</see_also>
--</function>

public function WinHttpReadData(atom hRequest, integer dwNumberOfBytesToRead)
  atom lpBuffer, lpdwNumberOfBytesRead
  sequence Buffer
  integer result, NumberOfBytesRead

  if not xWinHttpReadData then
    xWinHttpReadData = register_routine(winhttp, "WinHttpReadData",
                                        WINHTTP_ROUTINE_DEFINITION)
  end if
  Buffer = {}
  lpdwNumberOfBytesRead = allocate(4)
  lpBuffer = allocate(dwNumberOfBytesToRead)

  error_code = 0
  error_msg = ""

  result = c_func(xWinHttpReadData, {hRequest, lpBuffer, dwNumberOfBytesToRead,
                                     lpdwNumberOfBytesRead})
  if result = TRUE then
    NumberOfBytesRead = peek4u(lpdwNumberOfBytesRead)
    if NumberOfBytesRead > 0 then
      Buffer = peek({lpBuffer, NumberOfBytesRead})
    end if
  else
    error_code = GetLastError()
    error_msg = "WinHttpReadData failed:\n  " &
                  FormatSystemError(error_code)
    if f_debug then
      log_printf("Error %d: %s\n", {error_code, error_msg})
      flush(f_debug)
    end if
    free(lpdwNumberOfBytesRead)
    free(lpBuffer)
    return 0
  end if
  free(lpdwNumberOfBytesRead)
  free(lpBuffer)
  return Buffer -- Empty is ok. Validate comparing size
end function

--------------------------------------------------------------------------------

-- The WinHttpReceiveResponse function waits to receive the response to an HTTP request initiated by WinHttpSendRequest. When WinHttpReceiveResponse completes successfully, the status code and response headers have been received and are available for the application to inspect using WinHttpQueryHeaders. An application must call WinHttpReceiveResponse before it can use WinHttpQueryDataAvailable and WinHttpReadData to access the response entity body (if any).
--
-- Syntax
--   bool WINAPI WinHttpReceiveResponse(
--     _In_       HINTERNET hRequest,
--     _Reserved_ LPVOID    lpReserved
--   );
--
-- Parameters
--
--   hRequest [in]
--
--       HINTERNET handle returned by WinHttpOpenRequest and sent by WinHttpSendRequest. Wait until WinHttpSendRequest has completed for this handle before calling WinHttpReceiveResponse.
--   lpReserved [in]
--
--       This parameter is reserved and must be NULL.
--
-- Return value
--
--   Returns TRUE if successful, or FALSE otherwise. For extended error information, call GetLastError. Among the error codes returned are the following.
--   Error Code  Description
--
--   ERROR_WINHTTP_CANNOT_CONNECT    Returned if connection to the server failed.
--
--   ERROR_WINHTTP_CHUNKED_ENCODING_HEADER_SIZE_OVERFLOW    Returned when an overflow condition is encountered in the course of parsing chunked encoding.
--
--   ERROR_WINHTTP_CLIENT_AUTH_CERT_NEEDED    Returned when the server requests client authentication.
--
--   ERROR_WINHTTP_CONNECTION_ERROR    The connection with the server has been reset or terminated, or an incompatible SSL protocol was encountered. For example, WinHTTP version 5.1 does not support SSL2 unless the client specifically enables it.
--
--   ERROR_WINHTTP_HEADER_COUNT_EXCEEDED    Returned when a larger number of headers were present in a response than WinHTTP could receive.
--
--   ERROR_WINHTTP_HEADER_SIZE_OVERFLOW    Returned by WinHttpReceiveResponse when the size of headers received exceeds the limit for the request handle.
--
--   ERROR_WINHTTP_INCORRECT_HANDLE_STATE    The requested operation cannot be carried out because the handle supplied is not in the correct state.
--
--   ERROR_WINHTTP_INCORRECT_HANDLE_TYPE    The type of handle supplied is incorrect for this operation.
--
--   ERROR_WINHTTP_INTERNAL_ERROR    An internal error has occurred.
--
--   ERROR_WINHTTP_INVALID_SERVER_RESPONSE    The server response could not be parsed.
--
--   ERROR_WINHTTP_INVALID_URL    The URL is invalid.
--
--   ERROR_WINHTTP_LOGIN_FAILURE    The login attempt failed. When this error is encountered, the request handle should be closed with WinHttpCloseHandle. A new request handle must be created before retrying the function that originally produced this error.
--
--   ERROR_WINHTTP_NAME_NOT_RESOLVED    The server name could not be resolved.
--
--   ERROR_WINHTTP_OPERATION_CANCELLED    The operation was canceled, usually because the handle on which the request was operating was closed before the operation completed.
--
--   ERROR_WINHTTP_REDIRECT_FAILED    The redirection failed because either the scheme changed or all attempts made to redirect failed (default is five attempts).
--
--   ERROR_WINHTTP_RESEND_REQUEST    The WinHTTP function failed. The desired function can be retried on the same request handle.
--
--   ERROR_WINHTTP_RESPONSE_DRAIN_OVERFLOW    Returned when an incoming response exceeds an internal WinHTTP size limit.
--
--   ERROR_WINHTTP_SECURE_FAILURE    One or more errors were found in the Secure Sockets Layer (SSL) certificate sent by the server. To determine what type of error was encountered, check for a WINHTTP_CALLBACK_STATUS_SECURE_FAILURE notification in a status callback function. For more information, see WINHTTP_STATUS_CALLBACK.
--
--   ERROR_WINHTTP_TIMEOUT    The request has timed out.
--
--   ERROR_WINHTTP_UNRECOGNIZED_SCHEME    The URL specified a scheme other than "http:" or "https:".
--
--   ERROR_NOT_ENOUGH_MEMORY    Not enough memory was available to complete the requested operation. (Windows error code)
--
--
-- Remarks
--
--   Even when WinHTTP is used in asynchronous mode (that is, when WINHTTP_FLAG_ASYNC has been set in WinHttpOpen), this function can operate either synchronously or asynchronously. If this function returns FALSE, this function failed and you can call GetLastError to get extended error information. If this function returns TRUE, the application should expect either the WINHTTP_CALLBACK_STATUS_HEADERS_AVAILABLE completion callback, indicating success, or the WINHTTP_CALLBACK_STATUS_REQUEST_ERROR completion callback, indicating that the operation completed asynchronously, but failed.
--
--   If a status callback function has been installed with WinHttpSetStatusCallback, then those of the following notifications that have been set in the dwNotificationFlags parameter of WinHttpSetStatusCallback indicate progress in receiving the response:
--
--       WINHTTP_CALLBACK_STATUS_RECEIVING_RESPONSE
--       WINHTTP_CALLBACK_STATUS_RESPONSE_RECEIVED
--       WINHTTP_CALLBACK_STATUS_HEADERS_AVAILABLE
--       WINHTTP_CALLBACK_STATUS_INTERMEDIATE_RESPONSE
--       WINHTTP_CALLBACK_STATUS_REDIRECT
--
--   If the server closes the connection, the following notifications will also be reported, provided that they have been set in the dwNotificationFlags parameter of WinHttpSetStatusCallback:
--
--       WINHTTP_CALLBACK_STATUS_CLOSING_CONNECTION
--       WINHTTP_CALLBACK_STATUS_CONNECTION_CLOSED
--<function>
--<name>WinHttpReceiveResponse</name>
--<digest>waits to receive the response to an HTTP request initiated by WinHttpSendRequest.</digest>
--<desc>
--</desc>
--<param>
--<type></type>
--<name></name>
--<desc></desc>
--</param>
--<return>
--</return>
--<example>
--</example>
--<see_also>
--</see_also>
--</function>

public function WinHttpReceiveResponse(atom hRequest, atom lpReserved)
  integer result

  if not xWinHttpCheckPlatform then
    xWinHttpReceiveResponse = register_routine(winhttp,
            "WinHttpReceiveResponse", WINHTTP_ROUTINE_DEFINITION)
  end if
  error_code = 0
  error_msg = ""

  result = c_func(xWinHttpReceiveResponse, {hRequest, lpReserved})
  if result = FALSE then
    error_code = GetLastError()
    error_msg = "WinHttpReceiveResponse failed:\n  " &
                  FormatSystemError(error_code)
    if f_debug then
      log_printf("Error %d: %s\n", {error_code, error_msg})
      flush(f_debug)
    end if
  end if
  return result
end function

--------------------------------------------------------------------------------

-- The WinHttpSendRequest function sends the specified request to the HTTP
-- server.

-- Syntax
--   bool WINAPI WinHttpSendRequest(
--     _In_     HINTERNET hRequest,
--     _In_opt_ LPCWSTR   pwszHeaders,
--     _In_     dword     dwHeadersLength,
--     _In_opt_ LPVOID    lpOptional,
--     _In_     dword     dwOptionalLength,
--     _In_     dword     dwTotalLength,
--     _In_     DWORD_PTR dwContext
--   );
--
-- Parameters
--   hRequest [in]
--     An HINTERNET handle returned by WinHttpOpenRequest.
--
--   pwszHeaders [in, optional]
--     A pointer to a string that contains the additional headers to append to
--     the request. This parameter can be WINHTTP_NO_ADDITIONAL_HEADERS if
--     there are no additional headers to append.
--
--   dwHeadersLength [in]
--     An unsigned long integer value that contains the length, in characters,
--     of the additional headers. If this parameter is -1L and pwszHeaders is
--     not NULL, this function assumes that pwszHeaders is null-terminated,
--     and the length is calculated.
--
--   lpOptional [in, optional]
--     A pointer to a buffer that contains any optional data to send
--     immediately after the request headers. This parameter is generally used
--     for POST and PUT operations. The optional data can be the resource or
--     data posted to the server. This parameter can be WINHTTP_NO_REQUEST_DATA
--     if there is no optional data to send.
--     If the dwOptionalLength parameter is 0, this parameter is ignored and set
--     to NULL.
--     This buffer must remain available until the request handle is closed or
--     the call to WinHttpReceiveResponse has completed.
--
--   dwOptionalLength [in]
--     An unsigned long integer value that contains the length, in bytes, of the
--     optional data. This parameter can be zero if there is no optional data to
--     send.
--     This parameter must contain a valid length when the lpOptional parameter
--     is not NULL. Otherwise, lpOptional is ignored and set to NULL.
--
--   dwTotalLength [in]
--     An unsigned long integer value that contains the length, in bytes, of the
--     total data sent. This parameter specifies the Content-Length header of
--     the request. If the value of this parameter is greater than the length
--     specified by dwOptionalLength, then WinHttpWriteData can be used to send
--     additional data.
--     dwTotalLength must not change between calls to WinHttpSendRequest for the
--     same request. If dwTotalLength needs to be changed, the caller should
--     create a new request.
--
--   dwContext [in]
--     A pointer to a pointer-sized variable that contains an application-
--     defined value that is passed, with the request handle, to any callback
--     functions.
--
-- Return value
--   Returns TRUE if successful, or FALSE otherwise. For extended error
--   information, call GetLastError. Error codes are listed in the following
--   table.
--
--   Error Code
--         Description
--   ERROR_WINHTTP_CANNOT_CONNECT
--         Returned if connection to the server failed.
--   ERROR_WINHTTP_CLIENT_AUTH_CERT_NEEDED
--         The secure HTTP server requires a client certificate. The
--         application retrieves the list of certificate issuers by calling
--         WinHttpQueryOption with the WINHTTP_OPTION_CLIENT_CERT_ISSUER_LIST
--         option.
--         If the server requests the client certificate, but does not require
--         it, the application can alternately call WinHttpSetOption with the
--         WINHTTP_OPTION_CLIENT_CERT_CONTEXT option. In this case, the
--         application specifies the WINHTTP_NO_CLIENT_CERT_CONTEXT macro in the
--         lpBuffer parameter of WinHttpSetOption. For more information, see the
--         WINHTTP_OPTION_CLIENT_CERT_CONTEXT option.
--         Windows Server 2003 with SP1, Windows XP with SP2, and Windows 2000:
--         This error is not supported.
--   ERROR_WINHTTP_CONNECTION_ERROR
--         The connection with the server has been reset or terminated, or an
--         incompatible SSL protocol was encountered. For example, WinHTTP
--         version 5.1 does not support SSL2 unless the client specifically
--         enables it.
--   ERROR_WINHTTP_INCORRECT_HANDLE_STATE
--         The requested operation cannot be carried out because the handle
--         supplied is not in the correct state.
--   ERROR_WINHTTP_INCORRECT_HANDLE_TYPE
--         The type of handle supplied is incorrect for this operation.
--   ERROR_WINHTTP_INTERNAL_ERROR
--         An internal error has occurred.
--   ERROR_WINHTTP_INVALID_URL
--         The URL is invalid.
--   ERROR_WINHTTP_LOGIN_FAILURE
--         The login attempt failed. When this error is encountered, the request
--         handle should be closed with WinHttpCloseHandle. A new request
--         handle must be created before retrying the function that originally
--         produced this error.
--   ERROR_WINHTTP_NAME_NOT_RESOLVED
--         The server name cannot be resolved.
--   ERROR_WINHTTP_OPERATION_CANCELLED
--         The operation was cancelled, usually because the handle on which the
--         request was operating was closed before the operation completed.
--   ERROR_WINHTTP_RESPONSE_DRAIN_OVERFLOW
--         Returned when an incoming response exceeds an internal WinHTTP size
--         limit.
--   ERROR_WINHTTP_SECURE_FAILURE
--         One or more errors were found in the Secure Sockets Layer (SSL)
--         certificate sent by the server.
--         To determine what type of error was encountered, verify through a
--         WINHTTP_CALLBACK_STATUS_SECURE_FAILURE notification in a status
--         callback function. For more information, see WINHTTP_STATUS_CALLBACK.
--   ERROR_WINHTTP_SHUTDOWN
--         The WinHTTP function support is shut down or unloaded.
--   ERROR_WINHTTP_TIMEOUT
--         The request timed out.
--   ERROR_WINHTTP_UNRECOGNIZED_SCHEME
--         The URL specified a scheme other than "http:" or "https:".
--   ERROR_NOT_ENOUGH_MEMORY
--         Not enough memory was available to complete the requested operation.
--         (Windows error code) Windows Server 2003, Windows XP, and Windows
--         2000:  The TCP reservation range set with the
--         WINHTTP_OPTION_PORT_RESERVATION option is not large enough to send
--         this request.
--   ERROR_INVALID_PARAMETER
--         The content length specified in the dwTotalLength parameter does not
--         match the length specified in the Content-Length header.
--         The lpOptional parameter must be NULL and the dwOptionalLength
--         parameter must be zero when the Transfer-Encoding header is present.
--         The Content-Length header cannot be present when the Transfer-
--         Encoding header is present.
--   ERROR_WINHTTP_RESEND_REQUEST
--         The application must call WinHttpSendRequest again due to a redirect
--         or authentication challenge.
--         Windows Server 2003 with SP1, Windows XP with SP2, and Windows 2000:
--         This error is not supported.
--
-- Remarks
--   Even when WinHTTP is used in asynchronous mode, that is, when
--   WINHTTP_FLAG_ASYNC has been set in WinHttpOpen, this function can operate
--   either synchronously or asynchronously. In either case, if the request is
--   sent successfully, the application is called back with the completion
--   status set to WINHTTP_CALLBACK_STATUS_SENDREQUEST_COMPLETE. The
--   WINHTTP_CALLBACK_STATUS_REQUEST_ERROR completion indicates that the
--   operation completed asynchronously, but failed. Upon receiving the
--   WINHTTP_CALLBACK_STATUS_SENDREQUEST_COMPLETE status callback, the
--   application can start to receive a response from the server with
--   WinHttpReceiveResponse. Before then, no other asynchronous functions can be
--   called, otherwise, ERROR_WINHTTP_INCORRECT_HANDLE_STATE is returned.
--
--   An application must not delete or alter the buffer pointed to by lpOptional
--   until the request handle is closed or the call to WinHttpReceiveResponse
--   has completed, because an authentication challenge or redirect that
--   required the optional data could be encountered in the course of receiving
--   the response. If the operation must be aborted with WinHttpCloseHandle, the
--   application must keep the buffer valid until it receives the callback
--   WINHTTP_CALLBACK_STATUS_REQUEST_ERROR with an
--   ERROR_WINHTTP_OPERATION_CANCELLED error code.
--
--   If WinHTTP is used synchronously, that is, when WINHTP_FLAG_ASYNC was not
--   set in WinHttpOpen, an application is not called with a completion status
--   even if a callback function is registered. While in this mode, the
--   application can call WinHttpReceiveResponse when WinHttpSendRequest
--   returns.
--
--   The WinHttpSendRequest function sends the specified request to the HTTP
--   server and allows the client to specify additional headers to send along
--   with the request.
--
--   This function also lets the client specify optional data to send to the
--   HTTP server immediately following the request headers. This feature is
--   generally used for write operations such as PUT and POST.
--
--   An application can use the same HTTP request handle in multiple calls to
--   WinHttpSendRequest to re-send the same request, but the application must
--   read all data returned from the previous call before calling this function
--   again.
--
--   The name and value of request headers added with this function are
--   validated. Headers must be well formed. For more information about valid
--   HTTP headers, see RFC 2616. If an invalid header is used, this function
--   fails and GetLastError returns ERROR_INVALID_PARAMETER. The invalid header
--   is not added.
--
--   Windows 2000:  When sending requests from multiple threads, there may be a
--   significant decrease in network and CPU performance. For more information,
--   see Q282865 - Winsock Shutdown Can Increase CPU Usage to 100 Percent.
--
--   Windows XP and Windows 2000:  See Run-Time Requirements.
--
-- WinHttpSetStatusCallback
--   If a status callback function has been installed with
--   WinHttpSetStatusCallback, then those of the following notifications that
--   have been set in the dwNotificationFlags parameter of
--   WinHttpSetStatusCallback indicate the progress in sending the request:
--
--     WINHTTP_CALLBACK_STATUS_DETECTING_PROXY (not implemented)
--     WINHTTP_CALLBACK_STATUS_SENDREQUEST_COMPLETE (only in asynchronous mode)
--     WINHTTP_CALLBACK_STATUS_REDIRECT
--     WINHTTP_CALLBACK_STATUS_SECURE_FAILURE
--     WINHTTP_CALLBACK_STATUS_INTERMEDIATE_RESPONSE
--
--   Note  On Windows 7 and Windows Server 2008 R2, all of the following
--         notifications are deprecated.
--
--     WINHTTP_CALLBACK_STATUS_RESOLVING_NAME
--     WINHTTP_CALLBACK_STATUS_NAME_RESOLVED
--     WINHTTP_CALLBACK_STATUS_CONNECTING_TO_SERVER
--     WINHTTP_CALLBACK_STATUS_CONNECTED_TO_SERVER
--     WINHTTP_CALLBACK_STATUS_SENDING_REQUEST
--     WINHTTP_CALLBACK_STATUS_REQUEST_SENT
--     WINHTTP_CALLBACK_STATUS_RECEIVING_RESPONSE
--     WINHTTP_CALLBACK_STATUS_RESPONSE_RECEIVED
--
--   If the server closes the connection, the following notifications are also
--   sent, provided that they have been set in the dwNotificationFlags parameter
--   of WinHttpSetStatusCallback:
--
--     WINHTTP_CALLBACK_STATUS_CLOSING_CONNECTION
--     WINHTTP_CALLBACK_STATUS_CONNECTION_CLOSED
--
-- Support for Greater Than 4-GB Upload
--
--   Starting in Windows Vista and Windows Server 2008, WinHttp supports
--   uploading files up to the size of a LARGE_INTEGER (2^64 bytes) using the
--   Content-Length header. Payload lengths specified in the call to
--   WinHttpSendRequest are limited to the size of a dword (2^32 bytes). To
--   upload data to a URL larger than a dword, the application must provide the
--   length in the Content-Length header of the request. In this case, the
--   WinHttp client application calls WinHttpSendRequest with the dwTotalLength
--   parameter set to WINHTTP_IGNORE_REQUEST_TOTAL_LENGTH.
--
--   If the Content-Length header specifies a length less than a 2^32, the
--   application must also specify the content length in the call to
--   WinHttpSendRequest. If the dwTotalLength parameter does not match the
--   length specified in the Content-Length header, the call fails and returns
--   ERROR_INVALID_PARAMETER.
--
--   The Content-Length header can be added in the call to
--   WinHttpAddRequestHeaders, or it can be specified in the lpszHeader
--   parameter of WinHttpSendRequest as shown in the following code example.
--
--   bool fRet = WinHttpSendRequest(
--                                  hReq,
--                                  L"Content-Length: 68719476735\r\n",
--                                  -1L,
--                                  WINHTTP_NO_REQUEST_DATA,
--                                  0,
--                                  WINHTTP_IGNORE_REQUEST_TOTAL_LENGTH,
--                                  pMyContent);
--
-- Transfer-Encoding Header
--
--   Starting in Windows Vista and Windows Server 2008, WinHttp enables
--   applications to perform chunked transfer encoding on data sent to the
--   server. When the Transfer-Encoding header is present on the WinHttp
--   request, the dwTotalLength parameter in the call to WinHttpSendRequest is
--   set to WINHTTP_IGNORE_REQUEST_TOTAL_LENGTH and the application sends the
--   entity body in one or more calls to WinHttpWriteData. The lpOptional
--   parameter of WinHttpSendRequest must be NULL and the dwOptionLength
--   parameter must be zero, otherwise an ERROR_WINHTTP_INVALID_PARAMETER error
--   is returned. To terminate the chunked data transfer, the application
--   generates a zero length chunk and sends it in the last call to
--   WinHttpWriteData.
--<function>
--<name>WinHttpSendRequest</name>
--<digest>sends the specified request to the HTTP server.</digest>
--<desc>
--</desc>
--<param>
--<type>atom</type>
--<name>hRequest</name>
--<desc>
-- Valid HINTERNET handle returned by WinHttpOpenRequest. Wait until
-- WinHttpSendRequest has completed before calling this function.
--</desc>
--</param>
--<param>
--<type>object</type>
--<name>additional_headers</name>
--<desc>either a sequence or WINHTTP_NO_ADDITIONAL_HEADERS</desc>
--</param>
--<param>
--<type>object</type>
--<name>request_data</name>
--<desc>either a sequence or WINHTTP_NO_REQUEST_DATA</desc>
--</param>
--<param>
--<type>atom</type>
--<name>dwContext</name>
--<desc></desc>
--</param>
--<return>
--</return>
--<example>
-- bResults = WinHttpSendRequest(hRequest,
--                               WINHTTP_NO_ADDITIONAL_HEADERS,
--                               WINHTTP_NO_REQUEST_DATA,
--                               0)
-- bResults = WinHttpSendRequest(hRequest,
--                               "content-type:application/x-www-form-urlencoded",
--                               credentials,
--                               0)
--</example>
--<see_also>
--</see_also>
--</function>

public function WinHttpSendRequest(atom hRequest,
                                   object additional_headers,
                                   object request_data,
                                   atom dwContext)
  integer result
  atom lpszHeaders, lpOptional
  integer dwHeadersLength, dwOptionalLength, dwTotalLength

  if sequence(additional_headers) then
    lpszHeaders = allocate_wstring(additional_headers)
    dwHeadersLength = -1
  elsif additional_headers = WINHTTP_NO_ADDITIONAL_HEADERS then
    lpszHeaders = additional_headers
    dwHeadersLength = 0
  else
    error_message("WinHttpSendRequest: additional_headers should be a " &
                  "sequence or WINHTTP_NO_ADDITIONAL_HEADERS", 1)
  end if
  if sequence(request_data) then
    lpOptional = allocate_string(request_data)
    dwOptionalLength = length(request_data) + 1
  elsif request_data = WINHTTP_NO_REQUEST_DATA then
    lpOptional = request_data
    dwOptionalLength = 0
  else
    error_message("WinHttpSendRequest: request_data should be a " &
                  "sequence or WINHTTP_NO_REQUEST_DATA", 1)
  end if
  dwTotalLength = dwOptionalLength
  if not xWinHttpSendRequest then
    xWinHttpSendRequest = register_routine(winhttp, "WinHttpSendRequest",
                                           WINHTTP_ROUTINE_DEFINITION)
  end if
  error_code = 0
  error_msg = ""

  result = c_func(xWinHttpSendRequest, {hRequest, lpszHeaders, dwHeadersLength,
                                        lpOptional, dwOptionalLength,
                                        dwTotalLength, dwContext})
  if lpszHeaders != NULL then free(lpszHeaders) end if
  if lpOptional != NULL then free(lpOptional) end if
  if result = FALSE then
    error_code = GetLastError()
    error_msg = "WinHttpSendRequest failed:\n  " &
                  FormatSystemError(error_code)
    if f_debug then
      log_printf("Error %d: %s\n", {error_code, error_msg})
      flush(f_debug)
    end if
  end if
  return result
end function

--------------------------------------------------------------------------------


-- The WinHttpSetCredentials function passes the required authorization
-- credentials to the server.
--
-- Syntax
--
-- bool WINAPI WinHttpSetCredentials(
--   _In_       HINTERNET hRequest,
--   _In_       dword     AuthTargets,
--   _In_       dword     AuthScheme,
--   _In_       LPCWSTR   pwszUserName,
--   _In_       LPCWSTR   pwszPassword,
--   _Reserved_ LPVOID    pAuthParams
-- );
--
-- Parameters
--
--   hRequest [in]
--     Valid HINTERNET handle returned by WinHttpOpenRequest.
--
--   AuthTargets [in]
--     An unsigned integer that specifies a flag that contains the
--     authentication target. Can be one of the values in the following table.
--     Value                        Meaning
--     WINHTTP_AUTH_TARGET_SERVER   Credentials are passed to a server.
--     WINHTTP_AUTH_TARGET_PROXY    Credentials are passed to a proxy.
--
--   AuthScheme [in]
--     An unsigned integer that specifies a flag that contains the
--     authentication scheme. Must be one of the supported authentication
--     schemes returned from WinHttpQueryAuthSchemes. The following table
--     identifies the possible values.
--     Value                           Meaning
--     WINHTTP_AUTH_SCHEME_BASIC       Use basic authentication.
--     WINHTTP_AUTH_SCHEME_NTLM        Use NTLM authentication.
--     WINHTTP_AUTH_SCHEME_PASSPORT    Use passport authentication.
--     WINHTTP_AUTH_SCHEME_DIGEST      Use digest authentication.
--     WINHTTP_AUTH_SCHEME_NEGOTIATE   Selects between NTLM and Kerberos
--                                     authentication.
--
--   pwszUserName [in]
--     Pointer to a string that contains a valid user name. NULL if default
--     creds are to be used, in which case pszPassword will be ignored
--
--   pwszPassword [in]
--     Pointer to a string that contains a valid password. The password can be
--     blank.
--      1) "" = Blank Password
--      2) Parameter ignored if pszUserName is NULL
--      3) Cannot be NULL if pszUserName is not NULL
--
--   pAuthParams [in]
--     This parameter is reserved and must be NULL.
--
-- Return value
--
--   Returns TRUE if successful, or FALSE otherwise. For extended error
--   information, call GetLastError. The following table identifies the error
--   codes returned.
--   Error Code  Description
--   ERROR_WINHTTP_INCORRECT_HANDLE_STATE  The requested operation cannot be
--                                         carried out because the handle
--                                         supplied is not in the correct state.
--   ERROR_WINHTTP_INCORRECT_HANDLE_TYPE   The type of handle supplied is
--                                         incorrect for this operation.
--   ERROR_WINHTTP_INTERNAL_ERROR          An internal error has occurred.
--   ERROR_NOT_ENOUGH_MEMORY               Not enough memory was available to
--                                         complete the requested operation
--                                         (Windows error code).
--
-- Remarks
--   Even when WinHTTP is used in asynchronous mode (that is, when
--   WINHTTP_FLAG_ASYNC has been set in WinHttpOpen), this function operates
--   synchronously. The return value indicates success or failure. To get
--   extended error information, call GetLastError.
--
--   The credentials set by WinHttpSetCredentials are only used for a single
--   request; WinHTTP does not cache these credentials for use in subsequent
--   requests. As a result, applications must be written so that they can
--   respond to multiple challenges. If an authenticated connection is re-used,
--   subsequent requests cannot be challenged, but your code should be able to
--   respond to a challenge at any point.
--
--   For sample code that illustrates the use of WinHttpSetCredentials, see
--   Authentication in WinHTTP.
--   Note  When using Passport authentication and responding to a 407 status
--   code, a WinHTTP application must use WinHttpSetOption to provide proxy
--   credentials rather than WinHttpSetCredentials. This is only true when using
--   Passport authentication; in all other circumstances, use
--   WinHttpSetCredentials, because WinHttpSetOption is less secure.
--<function>
--<name>WinHttpSetCredentials</name>
--<digest>passes the required authorization credentials to the server.</digest>
--<desc>
--</desc>
--<param>
--<type></type>
--<name></name>
--<desc></desc>
--</param>
--<return>
--</return>
--<example>
--</example>
--<see_also>
--</see_also>
--</function>

public function WinHttpSetCredentials(atom hRequest, integer AuthTargets,
                                      integer AuthScheme, object UserName,
                                      object Password)
  atom pwszUserName, pwszPassword
  integer result

  if not xWinHttpSetCredentials then
    xWinHttpSetCredentials = register_routine(winhttp, "WinHttpSetCredentials",
                                              WINHTTP_ROUTINE_DEFINITION)
  end if
  if sequence(UserName) then
    pwszUserName = allocate_wstring(UserName)
  elsif UserName = NULL then
    pwszUserName = NULL
  else
    error_msg = "WinHttpSetCredentials: UserName should be a sequence or NULL"
    return NULL
  end if
  if sequence(Password) then
    pwszPassword = allocate_wstring(Password)
  elsif Password = NULL then
    if pwszUserName != NULL then
      error_msg = "WinHttpSetCredentials: Password cannot be NULL"
      free(pwszUserName)
      return NULL
    else
      pwszPassword = NULL
    end if
  else
    error_msg = "WinHttpSetCredentials: Password should be a sequence or NULL"
    return NULL
  end if

  error_code = 0
  error_msg = ""

  result = c_func(xWinHttpSetCredentials, {hRequest, AuthTargets, AuthScheme,
                                           pwszUserName, pwszPassword, NULL})

  if pwszUserName != NULL then free(pwszUserName) end if
  if pwszPassword != NULL then free(pwszPassword) end if
  if result = FALSE then
    error_code = GetLastError()
    error_msg = "WinHttpSetCredentials failed:\n  " &
                  FormatSystemError(error_code)
    if f_debug then
      log_printf("Error %d: %s\n", {error_code, error_msg})
      flush(f_debug)
    end if
  end if
  return result
end function

--------------------------------------------------------------------------------

-- The WinHttpSetDefaultProxyConfiguration function sets the default WinHTTP proxy configuration in the registry.
--
-- Syntax
--   bool WINAPI WinHttpSetDefaultProxyConfiguration(
--     _In_ WINHTTP_PROXY_INFO *pProxyInfo
--   );
--
-- Parameters
--
--   pProxyInfo [in]
--
--       A pointer to a variable of type WINHTTP_PROXY_INFO that specifies the default proxy configuration.
--
-- Return value
--
--   Returns TRUE if successful, or FALSE otherwise. For extended error information, call GetLastError. Among the error codes returned are the following.
--   Error Code  Description
--
--   ERROR_WINHTTP_INTERNAL_ERROR    An internal error has occurred.
--
--   ERROR_NOT_ENOUGH_MEMORY    Not enough memory was available to complete the requested operation. (Windows error code)
--
--
-- Remarks
--
--   WinHttpSetDefaultProxyConfiguration changes the proxy configuration set by ProxyCfg.exe.
--
--   The default proxy configuration set by this function can be overridden for an existing WinHTTP session by calling WinHttpSetOption and specifying the WINHTTP_OPTION_PROXY flag. The default proxy configuration can be overridden for a new session by specifying the configuration with the WinHttpOpen function.
--
--   The dwAccessType member of the WINHTTP_PROXY_INFO structure pointed to by pProxyInfo should be set to WINHTTP_ACCESS_TYPE_NAMED_PROXY if a proxy is specified. Otherwise, it should be set to WINHTTP_ACCESS_TYPE_DEFAULT_PROXY.
--
--   Any new sessions created after calling this function use the new default proxy configuration.
--
--   Even when WinHTTP is used in asynchronous mode (that is, when WINHTTP_FLAG_ASYNC has been set in WinHttpOpen), this function operates synchronously. The return value indicates success or failure. To get extended error information, call GetLastError.
--<function>
--<name>WinHttpSetDefaultProxyConfiguration</name>
--<digest>sets the default WinHTTP proxy configuration in the registry.</digest>
--<desc>
--</desc>
--<param>
--<type></type>
--<name></name>
--<desc></desc>
--</param>
--<return>
--</return>
--<example>
--</example>
--<see_also>
--</see_also>
--</function>

public function WinHttpSetDefaultProxyConfiguration(atom pProxyInfo)
  integer result

  if not xWinHttpSetDefaultProxyConfiguration then
    xWinHttpSetDefaultProxyConfiguration = register_routine(winhttp,
            "WinHttpSetDefaultProxyConfiguration", WINHTTP_ROUTINE_DEFINITION)
  end if
  error_code = 0
  error_msg = ""

  result = c_func(xWinHttpSetDefaultProxyConfiguration, {pProxyInfo})
  if result = FALSE then
    error_msg = "WinHttpSetDefaultProxyConfiguration failed"
    if f_debug then
      log_printf("Error %d: %s\n", {error_code, error_msg})
      flush(f_debug)
    end if
  end if
  return result
end function

--------------------------------------------------------------------------------

-- The WinHttpSetOption function sets an Internet option.
--
-- Syntax
--   bool WINAPI WinHttpSetOption(
--     _In_ HINTERNET hInternet,
--     _In_ dword     dwOption,
--     _In_ LPVOID    lpBuffer,
--     _In_ dword     dwBufferLength
--   );
--
-- Parameters
--   hInternet [in]
--     The HINTERNET handle on which to set data. Be aware that this can be
--     either a Session handle or a Request handle, depending on what option is
--     being set. For more information about how to determine which handle is
--     appropriate to use in setting a particular option, see the Option Flags.
--
--   dwOption [in]
--     An unsigned long integer value that contains the Internet option to set.
--     This can be one of the Option Flags values.
--
--   lpBuffer [in]
--     A pointer to a buffer that contains the option setting.
--
--   dwBufferLength [in]
--     Unsigned long integer value that contains the length of the lpBuffer
--     buffer. The length of the buffer is specified in characters for the
--     following options; for all other options, the length is specified in
--     bytes.
--
-- Return value
--
--   Returns TRUE if successful, or FALSE otherwise. For extended error
--   information, call GetLastError. Among the error codes returned are the
--   following
--   Error Code  Description
--   ERROR_WINHTTP_INCORRECT_HANDLE_STATE  The requested operation cannot be
--                                         carried out because the handle
--                                         supplied is not in the correct state.
--   ERROR_WINHTTP_INCORRECT_HANDLE_TYPE   The type of handle supplied is
--                                         incorrect for this operation.
--   ERROR_WINHTTP_INTERNAL_ERROR          An internal error has occurred.
--   ERROR_WINHTTP_INVALID_OPTION          A request to WinHttpQueryOption or
--                                         WinHttpSetOption specified an invalid
--                                         option value.
--   ERROR_INVALID_PARAMETER               A parameter is not valid.
--                                         This value will be returned if
--                                         WINHTTP_OPTION_WEB_SOCKET_KEEPALIVE_INTERVAL
--                                         is set to a value lower than 15000.
--   ERROR_WINHTTP_OPTION_NOT_SETTABLE     The requested option cannot be set,
--                                         only queried.
--   ERROR_INVALID_PARAMETER               A parameter is not valid.
--                                         This value will be returned if
--                                         WINHTTP_OPTION_WEB_SOCKET_KEEPALIVE_INTERVAL
--                                         is set to a value lower than 15000.
--   ERROR_NOT_ENOUGH_MEMORY               Not enough memory was available to
--                                         complete the requested operation.
--                                         (Windows error code)
--
--
-- Remarks
--   Credentials passed to WinHttpSetOption could be unexpectedly sent in
--   plaintext. It is strongly recommended that you use WinHttpQueryAuthSchemes
--   and WinHttpSetCredentials instead of WinHttpSetOption for setting
--   credentials.
--
--   Note  When using Passport authentication, however, a WinHTTP application
--         responding to a 407 status code must use WinHttpSetOption to provide
--         proxy credentials rather than WinHttpSetCredentials.
--         This is only true when using Passport authentication; in all other
--         circumstances, use WinHttpSetCredentials.
--
--   Even when WinHTTP is used in asynchronous mode (that is, when
--   WINHTTP_FLAG_ASYNC has been set in WinHttpOpen), this function operates
--   synchronously. The return value indicates success or failure.
--   To get extended error information, call GetLastError.
--
--   GetLastError returns the error ERROR_INVALID_PARAMETER if an option flag is
--   specified that cannot be set.
--
--   For more information and code examples that show the use of
--   WinHttpSetOption, see Authentication in WinHTTP.
--<function>
--<name>WinHttpSetOption</name>
--<digest>sets an Internet option.</digest>
--<desc>
--</desc>
--<param>
--<type></type>
--<name></name>
--<desc></desc>
--</param>
--<return>
--</return>
--<example>
--</example>
--<see_also>
--</see_also>
--</function>

public function WinHttpSetOption(atom hInternet, integer dwOption,
                                 atom lpBuffer, integer dwBufferLength)
  integer result

  if not xWinHttpSetOption then
    xWinHttpSetOption = register_routine(winhttp, "WinHttpSetOption",
                                         WINHTTP_ROUTINE_DEFINITION)
  end if
  error_code = 0
  error_msg = ""

  result = c_func(xWinHttpSetOption, {hInternet, dwOption, lpBuffer,
                                      dwBufferLength})
  if result = FALSE then
    error_msg = "WinHttpSetOption failed"
    if f_debug then
      log_printf("Error %d: %s\n", {error_code, error_msg})
      flush(f_debug)
    end if
  end if
  return result
end function

--------------------------------------------------------------------------------

-- The WinHttpSetStatusCallback function sets up a callback function that WinHTTP can call as progress is made during an operation.
--
-- Syntax
--   WINHTTP_STATUS_CALLBACK WINAPI WinHttpSetStatusCallback(
--     _In_       HINTERNET               hInternet,
--     _In_       WINHTTP_STATUS_CALLBACK lpfnInternetCallback,
--     _In_       dword                   dwNotificationFlags,
--     _Reserved_ DWORD_PTR               dwReserved
--   );
--
-- Parameters
--
--   hInternet [in]
--     HINTERNET handle for which the callback is to be set.
--
--   lpfnInternetCallback [in]
--     Pointer to the callback function to call when progress is made. Set this to NULL to remove the existing callback function. For more information about the callback function, see WINHTTP_STATUS_CALLBACK.
--
--   dwNotificationFlags [in]
--     Unsigned long integer value that specifies flags to indicate which events activate the callback function.
--
--     The possible values are as follows.
--     Value  Meaning
--     WINHTTP_CALLBACK_FLAG_ALL_COMPLETIONS        Activates upon any completion notification. This flag specifies that all notifications required for read or write operations are used. See WINHTTP_STATUS_CALLBACK for a list of completions.
--     WINHTTP_CALLBACK_FLAG_ALL_NOTIFICATIONS      Activates upon any status change notification including completions. See WINHTTP_STATUS_CALLBACK for a list of notifications.
--     WINHTTP_CALLBACK_FLAG_RESOLVE_NAME           Activates upon beginning and completing name resolution.
--     WINHTTP_CALLBACK_FLAG_CONNECT_TO_SERVER      Activates upon beginning and completing connection to the server.
--     WINHTTP_CALLBACK_FLAG_DETECTING_PROXY        Activates when detecting the proxy server.
--     WINHTTP_CALLBACK_FLAG_DATA_AVAILABLE         Activates when completing a query for data.
--     WINHTTP_CALLBACK_FLAG_HEADERS_AVAILABLE      Activates when the response headers are available for retrieval.
--     WINHTTP_CALLBACK_FLAG_READ_COMPLETE          Activates upon completion of a data-read operation.
--     WINHTTP_CALLBACK_FLAG_REQUEST_ERROR          Activates when an asynchronous error occurs.
--     WINHTTP_CALLBACK_FLAG_SEND_REQUEST           Activates upon beginning and completing the sending of a request header with WinHttpSendRequest.
--     WINHTTP_CALLBACK_FLAG_SENDREQUEST_COMPLETE   Activates when a request header has been sent with WinHttpSendRequest.
--     WINHTTP_CALLBACK_FLAG_WRITE_COMPLETE         Activates upon completion of a data-post operation.
--     WINHTTP_CALLBACK_FLAG_RECEIVE_RESPONSE       Activates upon beginning and completing the receipt of a resource from the HTTP server.
--     WINHTTP_CALLBACK_FLAG_CLOSE_CONNECTION       Activates when beginning and completing the closing of an HTTP connection.
--     WINHTTP_CALLBACK_FLAG_HANDLES                Activates when an HINTERNET handle is created or closed.
--     WINHTTP_CALLBACK_FLAG_REDIRECT               Activates when the request is redirected.
--     WINHTTP_CALLBACK_FLAG_INTERMEDIATE_RESPONSE  Activates when receiving an intermediate (100 level) status code message from the server.
--     WINHTTP_CALLBACK_FLAG_SECURE_FAILURE         Activates upon a secure connection failure.
--
--   dwReserved [in]
--       This parameter is reserved and must be NULL.
--
-- Return value
--
--   If successful, returns a pointer to the previously defined status callback function or NULL if there was no previously defined status callback function. Returns WINHTTP_INVALID_STATUS_CALLBACK if the callback function could not be installed. For extended error information, call GetLastError. Among the error codes returned are the following.
--   Error Code  Description
--
--   ERROR_WINHTTP_INCORRECT_HANDLE_TYPE    The type of handle supplied is incorrect for this operation.
--
--   ERROR_WINHTTP_INTERNAL_ERROR    An internal error has occurred.
--
--   ERROR_NOT_ENOUGH_MEMORY    Not enough memory was available to complete the requested operation. (Windows error code)
--
--
-- Remarks
--
--   If you set the callback on the session handle before creating the request handle, the request handle inherits the callback function pointer from its parent session.
--
--   Even when WinHTTP is used in asynchronous mode (that is, when WINHTTP_FLAG_ASYNC has been set in WinHttpOpen), this function operates synchronously. The return value indicates success or failure. To get extended error information, call GetLastError.
--
--   Both synchronous and asynchronous functions use the callback function to indicate the progress of the request, such as resolving a name, connecting to a server, and so on. The callback function is required for an asynchronous operation.
--
--   A callback function can be set on any handle and is inherited by derived handles. A callback function can be changed using WinHttpSetStatusCallback, provided there are no pending requests that need to use the previous callback value. However, changing the callback function on a handle does not change the callbacks on derived handles, such as that returned by WinHttpConnect. You must change the callback function at each level.
--
--   Many WinHTTP functions perform several operations on the network. Each operation can take time to complete and each can fail.
--
--   After initiating the WinHttpSetStatusCallback function, the callback function can be accessed from within WinHTTP for monitoring time-intensive network operations.
--
--   At the end of asynchronous processing, the application may set the callback function to NULL. This prevents the client application from receiving additional notifications.
--
--   The following code snippet shows the recommended method for setting the callback function to NULL.
--
--   WinHttpSetStatusCallback( hOpen,
--                             NULL,
--                             WINHTTP_CALLBACK_FLAG_ALL_NOTIFICATIONS,
--                             NULL );
--
--   Note, however, that WinHTTP does not synchronize WinHttpSetStatusCallback with worker threads. If a callback originating in another thread is in progress when an application calls WinHttpSetStatusCallback, the application still receives a callback notification even after WinHttpSetStatusCallback successfully sets the callback function to NULL and returns.
--<function>
--<name>WinHttpSetStatusCallback</name>
--<digest>sets up a callback function that WinHTTP can call as progress is made during an operation.</digest>
--<desc>
--</desc>
--<param>
--<type></type>
--<name></name>
--<desc></desc>
--</param>
--<return>
--</return>
--<example>
--</example>
--<see_also>
--</see_also>
--</function>

public function WinHttpSetStatusCallback(atom hInternet, atom lpfnInternetCallback,
                                         integer dwNotificationFlags, atom dwReserved)
  atom result

  if not xWinHttpSetStatusCallback then
    xWinHttpSetStatusCallback = register_routine(winhttp,
                                                 "WinHttpSetStatusCallback",
                                                 WINHTTP_ROUTINE_DEFINITION)
  end if
  error_code = 0
  error_msg = ""

  result = c_func(xWinHttpSetStatusCallback, {hInternet, lpfnInternetCallback,
                                              dwNotificationFlags, dwReserved})
  if result = NULL then
    error_msg = "WinHttpSetStatusCallback failed"
    if f_debug then
      log_printf("Error %d: %s\n", {error_code, error_msg})
      flush(f_debug)
    end if
  end if
  return result
end function

--------------------------------------------------------------------------------

-- The WinHttpSetTimeouts function sets time-outs involved with HTTP transactions.
--
-- Syntax
--   bool WINAPI WinHttpSetTimeouts(
--     _In_ HINTERNET hInternet,
--     _In_ int       dwResolveTimeout,
--     _In_ int       dwConnectTimeout,
--     _In_ int       dwSendTimeout,
--     _In_ int       dwReceiveTimeout
--   );
--
-- Parameters
--
--   hInternet [in]
--     The HINTERNET handle returned by WinHttpOpen or WinHttpOpenRequest.
--
--   dwResolveTimeout [in]
--     A value of type integer that specifies the time-out value, in
--     milliseconds, to use for name resolution. If resolution takes longer
--     than this time-out value, the action is canceled.
--     The initial value is zero, meaning no time-out (infinite).
--
--     Windows Vista and Windows XP:  If DNS timeout is specified using
--     NAME_RESOLUTION_TIMEOUT, there is an overhead of one thread per request.
--
--   dwConnectTimeout [in]
--     A value of type integer that specifies the time-out value, in
--     milliseconds, to use for server connection requests. If a connection
--     request takes longer than this time-out value, the request is canceled.
--     The initial value is 60,000 (60 seconds).
--
--   dwSendTimeout [in]
--     A value of type integer that specifies the time-out value, in
--     milliseconds, to use for sending requests. If sending a request takes
--     longer than this time-out value, the send is canceled.
--     The initial value is 30,000 (30 seconds).
--
--   dwReceiveTimeout [in]
--     A value of type integer that specifies the time-out value, in
--     milliseconds, to receive a response to a request. If a response takes
--     longer than this time-out value, the request is canceled.
--     The initial value is 30,000 (30 seconds).
--
-- Return value
--   Returns TRUE if successful, or FALSE otherwise. For extended error
--   information, call GetLastError. Among the error codes returned are the
--   following.
--
--   Error Code  Description
--   ERROR_WINHTTP_INCORRECT_HANDLE_STATE The requested operation cannot be
--                                        carried out because the handle
--                                        supplied is not in the correct state.
--   ERROR_WINHTTP_INCORRECT_HANDLE_TYPE  The type of handle supplied is
--                                        incorrect for this operation.
--   ERROR_WINHTTP_INTERNAL_ERROR         An internal error has occurred.
--   ERROR_NOT_ENOUGH_MEMORY              Not enough memory was available to
--                                        complete the requested operation.
--                                        (Windows error code)
--   ERROR_INVALID_PARAMETER              One or more of the timeout parameters
--                                        has a negative value other than -1.
--
--
-- Remarks
--
--   Even when WinHTTP is used in asynchronous mode (that is, when
--   WINHTTP_FLAG_ASYNC has been set in WinHttpOpen), this function operates
--   synchronously. The return value indicates success or failure.
--   To get extended error information, call GetLastError.
--
--   A value of 0 or -1 sets a time-out to wait infinitely. A value greater than
--   0 sets the time-out value in milliseconds. For example, 30,000 would set
--   the time-out to 30 seconds. All negative values other than -1 cause the
--   function to fail with ERROR_INVALID_PARAMETER.
--
--   Important  If a small timeout is set using WinHttpSetOption and
--              WINHTTP_OPTION_RECEIVE_TIMEOUT, it can override the value set
--              with the dwReceiveTimeout parameter, causing a response to
--              terminate earlier than expected. To avoid this, do not set a
--              timeout with the WINHTTP_OPTION_RECEIVE_TIMEOUT option that is
--              smaller than the value set using dwReceiveTimeout.
--<function>
--<name>WinHttpSetTimeouts</name>
--<digest>sets time-outs involved with HTTP transactions.</digest>
--<desc>
--</desc>
--<param>
--<type></type>
--<name></name>
--<desc></desc>
--</param>
--<return>
--</return>
--<example>
--</example>
--<see_also>
--</see_also>
--</function>

public function WinHttpSetTimeouts(atom hInternet, integer nResolveTimeout,
                                   integer nConnectTimeout,
                                   integer nSendTimeout,
                                   integer nReceiveTimeout)
  integer result

  if not xWinHttpSetTimeouts then
    xWinHttpSetTimeouts = register_routine(winhttp, "WinHttpSetTimeouts",
                                           WINHTTP_ROUTINE_DEFINITION)
  end if
  error_code = 0
  error_msg = ""

  result = c_func(xWinHttpSetTimeouts, {hInternet, nResolveTimeout,
                  nConnectTimeout, nSendTimeout, nReceiveTimeout})
  if result = FALSE then
    error_msg = "WinHttpSetTimeouts failed"
    if f_debug then
      log_printf("Error %d: %s\n", {error_code, error_msg})
      flush(f_debug)
    end if
  end if
  return result
end function

--------------------------------------------------------------------------------

-- The WinHttpTimeFromSystemTime function formats a date and time according to the HTTP version 1.0 specification.
--
-- Syntax
--   bool WINAPI WinHttpTimeFromSystemTime(
--     _In_  const SYSTEMTIME *pst,
--     _Out_       LPWSTR     pwszTime
--   );
--
-- Parameters
--
--   pst [in]
--
--       A pointer to a SYSTEMTIME structure that contains the date and time to format.
--   pwszTime [out]
--
--       A pointer to a string buffer that receives the formatted date and time. The buffer should equal to the size, in bytes, of WINHTTP_TIME_FORMAT_BUFSIZE.
--
-- Return value
--
--   Returns TRUE if successful, or FALSE otherwise. To get extended error information, call GetLastError. Error codes include the following.
--   Error Code  Description
--
--   ERROR_WINHTTP_INTERNAL_ERROR    An internal error has occurred.
--
--
-- Remarks
--
--   Even when WinHTTP is used in asynchronous mode (that is, when WINHTTP_FLAG_ASYNC has been set in WinHttpOpen), this function operates synchronously. The return value indicates success or failure. To get extended error information, call GetLastError.
--<function>
--<name>WinHttpTimeFromSystemTime</name>
--<digest>formats a date and time according to the HTTP version 1.0 specification.</digest>
--<desc>
--</desc>
--<param>
--<type></type>
--<name></name>
--<desc></desc>
--</param>
--<return>
--</return>
--<example>
--</example>
--<see_also>
--</see_also>
--</function>

public function WinHttpTimeFromSystemTime(atom pst, atom pwszTime)
  integer result

  if not xWinHttpTimeFromSystemTime then
    xWinHttpTimeFromSystemTime = register_routine(winhttp,
                                                  "WinHttpTimeFromSystemTime",
                                                  WINHTTP_ROUTINE_DEFINITION)
  end if
  error_code = 0
  error_msg = ""

  result = c_func(xWinHttpTimeFromSystemTime, {pst, pwszTime})
  if result = FALSE then
    error_msg = "WinHttpTimeFromSystemTime failed"
    if f_debug then
      log_printf("Error %d: %s\n", {error_code, error_msg})
      flush(f_debug)
    end if
  end if
  return result
end function

--------------------------------------------------------------------------------

-- The WinHttpTimeToSystemTime function takes an HTTP time/date string and converts it to a SYSTEMTIME structure.
-- Parameters
--   pwszTime [in]
--     Pointer to a null-terminated date/time string to convert. This value must use the format defined in section 3.3 of the RFC2616.
--
--   pst [out]
--     Pointer to the SYSTEMTIME structure that receives the converted time.
--
--
-- Return value
--
--   Returns TRUE if successful, or FALSE otherwise. For extended error information, call GetLastError. Among the error codes returned is:
--   Error Code  Description
--
--   ERROR_WINHTTP_INTERNAL_ERROR    An internal error has occurred.
--
--
-- Remarks
--
--   Even when WinHTTP is used in asynchronous mode (that is, when WINHTTP_FLAG_ASYNC has been set in WinHttpOpen), this function operates synchronously. The return value indicates success or failure. To get extended error information, call GetLastError.
--<function>
--<name>WinHttpTimeToSystemTime</name>
--<digest>takes an HTTP time/date string and converts it to a SYSTEMTIME sequence.</digest>
--<desc>
--</desc>
--<param>
--<type>sequence</type>
--<name>http_time</name>
--<desc>HTTP time/date string</desc>
--</param>
--<return>
-- sequence of integers
-- {wYear, wMonth, wDayOfWeek, wDay, wHour, wMinute, wSecond, wMilliseconds}
--
-- wYear
--   The year. The valid values for this member are 1601 through 30827.
-- wMonth
--   The month. The valid values for this member are 1 through 12.
-- wDayOfWeek
--   The day of the week. This member can be one of the following values.
--   Value   Meaning
--   0       Sunday
--   1       Monday
--   2       Tuesday
--   3       Wednesday
--   4       Thursday
--   5       Friday
--   6       Saturday
-- wDay
--   The day of the month. The valid values for this member are 1 through 31.
-- wHour
--   The hour. The valid values for this member are 0 through 23.
-- wMinute
--   The minute. The valid values for this member are 0 through 59.
-- wSecond
--   The second. The valid values for this member are 0 through 59.
-- wMilliseconds
--   The millisecond. The valid values for this member are 0 through 999.
--</return>
--<example>
--</example>
--<see_also>
--</see_also>
--</function>

public function WinHttpTimeToSystemTime(sequence http_time)
  integer result
  atom pst, pwszTime
  sequence date_time
  
  if not xWinHttpTimeToSystemTime then
    xWinHttpTimeToSystemTime = register_routine(winhttp,
            "WinHttpTimeToSystemTime", WINHTTP_ROUTINE_DEFINITION)
  end if
  error_code = 0
  error_msg = ""
  pwszTime = allocate_wstring(http_time)
  pst = allocate(16)
  
  result = c_func(xWinHttpTimeToSystemTime, {pwszTime, pst})
  if result = FALSE then
    error_msg = "WinHttpTimeToSystemTime failed"
    if f_debug then
      error_message(sprintf("Error %d: %s\n", {error_code, error_msg}), 1)
    end if
  end if
  date_time = peek2u({pst, 8})
  free(pst)
  free(pwszTime)
  return date_time
end function

--------------------------------------------------------------------------------

-- The WinHttpWriteData function writes request data to an HTTP server.
--
-- Syntax
--   bool WINAPI WinHttpWriteData(
--     _In_  HINTERNET hRequest,
--     _In_  LPCVOID   lpBuffer,
--     _In_  dword     dwNumberOfBytesToWrite,
--     _Out_ LPDWORD   lpdwNumberOfBytesWritten
--   );
--
-- Parameters
--   hRequest [in]
--     Valid HINTERNET handle returned by WinHttpOpenRequest. Wait until WinHttpSendRequest has completed before calling this function.
--
--   lpBuffer [in]
--     Pointer to a buffer that contains the data to be sent to the server. Be sure that this buffer remains valid until after WinHttpWriteData completes.
--
--   dwNumberOfBytesToWrite [in]
--     Unsigned long integer value that contains the number of bytes to be written to the file.
--
--   lpdwNumberOfBytesWritten [out]
--     Pointer to an unsigned long integer variable that receives the number of bytes written to the buffer. The WinHttpWriteData function sets this value to zero before doing any work or error checking. When using WinHTTP asynchronously, this parameter must be set to NULL and retrieve the information in the callback function. Not doing so can cause a memory fault.
--
-- Return value
--
--   Returns TRUE if successful, or FALSE otherwise. For extended error information, call GetLastError. Among the error codes returned are:
--   Error Code  Description
--
--   ERROR_WINHTTP_CONNECTION_ERROR    The connection with the server has been reset or terminated, or an incompatible SSL protocol was encountered. For example, WinHTTP version 5.1 does not support SSL2 unless the client specifically enables it.
--
--   ERROR_WINHTTP_INCORRECT_HANDLE_STATE    The requested operation cannot be carried out because the handle supplied is not in the correct state.
--
--   ERROR_WINHTTP_INCORRECT_HANDLE_TYPE    The type of handle supplied is incorrect for this operation.
--
--   ERROR_WINHTTP_INTERNAL_ERROR    An internal error has occurred.
--
--   ERROR_WINHTTP_OPERATION_CANCELLED    The operation was canceled, usually because the handle on which the request was operating was closed before the operation completed.
--
--   ERROR_WINHTTP_TIMEOUT    The request has timed out.
--
--   ERROR_NOT_ENOUGH_MEMORY    Not enough memory was available to complete the requested operation. (Windows error code)
--
--
-- Remarks
--
--   Even when WinHTTP is used in asynchronous mode (that is, when WINHTTP_FLAG_ASYNC has been set in WinHttpOpen), this function can operate either synchronously or asynchronously. If this function returns FALSE, you can call GetLastError to get extended error information. If this function returns TRUE, use the WINHTTP_CALLBACK_STATUS_WRITE_COMPLETE completion to determine whether this function was successful and the value of the parameters. The WINHTTP_CALLBACK_STATUS_REQUEST_ERROR completion indicates that the operation completed asynchronously, but failed.
--   Warning  When using WinHTTP asynchronously, always set the lpdwNumberOfBytesWritten parameter to NULL and retrieve the bytes written in the callback function; otherwise, a memory fault can occur.
--
--
--   When the application is sending data, it can call WinHttpReceiveResponse to end the data transfer. If WinHttpCloseHandle is called, then the data transfer is aborted.
--
--   If a status callback function has been installed with WinHttpSetStatusCallback, then those of the following notifications that have been set in the dwNotificationFlags parameter of WinHttpSetStatusCallback indicate progress in sending data to the server:
--
--       WINHTTP_CALLBACK_STATUS_RECEIVING_RESPONSE
--       WINHTTP_CALLBACK_STATUS_RESPONSE_RECEIVED
--       WINHTTP_CALLBACK_STATUS_DATA_WRITTEN
--       WINHTTP_CALLBACK_STATUS_SENDING_REQUEST
--       WINHTTP_CALLBACK_STATUS_REQUEST_SENT
--       WINHTTP_CALLBACK_STATUS_WRITE_COMPLETE
--
--   Two issues can arise when attempting to POST (or PUT) data to proxies or servers that challenge using NTLM or Negotiate authentication. First, these proxies or servers may send 401/407 challenges and close the connection before all the data can be POST'ed, in which case not only does WinHttpWriteData fail, but also WinHTTP cannot handle the authentication challenges. NTLM and Negotiate require that all authentication handshakes be exchanged on the same socket connection, so authentication fails if the connection is broken prematurely.
--
--   Secondly, NTLM and Negotiate may require multiple handshakes to complete authentication, which requires data to be re-POST'ed for each authentication legs. This can be very inefficient for large data uploads.
--
--   To work around these two issues, one solution is to send an idempotent warm-up request such as HEAD to the authenticating v-dir first, handle the authentication challenges associated with this request, and only then POST data. As long as the same socket is re-used to handle the POST'ing, no further authentication challenges should be encountered and all data can be uploaded at once. Since an authenticated socket can only be reused for subsequent requests within the same session, the POST should go out in the same socket as long as the socket is not pooled with concurrent requests competing for it.
--<function>
--<name>WinHttpWriteData</name>
--<digest>writes request data to an HTTP server</digest>
--<desc>
--</desc>
--<param>
--<type>atom</type>
--<name>hRequest</name>
--<desc>
-- Valid HINTERNET handle returned by WinHttpOpenRequest. Wait until
-- WinHttpSendRequest has completed before calling this function.
--</desc>
--</param>
--<param>
--<type>sequence</type>
--<name>Data</name>
--<desc>data to be sent to the server</desc>
--</param>
--<return>Returns TRUE if successful, or FALSE otherwise.</return>
--<example>
--</example>
--<see_also>
--</see_also>
--</function>

public function WinHttpWriteData( atom hRequest, sequence Data )
  atom lpBuffer, dwNumberOfBytesToWrite, lpdwNumberOfBytesWritten
  integer result

  if not xWinHttpWriteData then
    xWinHttpWriteData = register_routine(winhttp, "WinHttpWriteData",
                                         WINHTTP_ROUTINE_DEFINITION)
  end if
  dwNumberOfBytesToWrite = (2*length(Data))

  -- it can be zero if reading in a loop and an exact divisor is used
  if dwNumberOfBytesToWrite > 0 then

    lpdwNumberOfBytesWritten = allocate(4)
    lpBuffer = allocate_wstring(Data)

    error_code = 0
    error_msg = ""

    result = c_func(xWinHttpWriteData, {hRequest, lpBuffer,
                                        dwNumberOfBytesToWrite+2,
                                        lpdwNumberOfBytesWritten})

    free(lpBuffer)
    free(lpdwNumberOfBytesWritten)
    if result = FALSE then
      error_msg = "WinHttpWriteData failed"
      if f_debug then
        log_printf("Error %d: %s\n", {error_code, error_msg})
      end if
    end if
    return result
  end if

  return TRUE -- if an empty sequence is passed
end function

--------------------------------------------------------------------------------

public function WinHttpExtractCookies( sequence headers, integer raw=0 )
--<function>
--<name>WinHttpExtractCookies</name>
--<digest>extract cookies from sequence of headers</digest>
--<desc>
-- option raw defaults to no (only cookie name and value returned)
-- only last header is considered in case of redirection
--</desc>
--<param>
--<type>sequence</type>
--<name>headers</name>
--<desc>sequence of headers</desc>
--</param>
--<param>
--<type>integer</type>
--<name>raw</name>
--<desc>
-- extracts raw cookie line from header if 1 (true), only cookie name and
-- value if 0 (false). defaults to 0.
--</desc>
--</param>
--<return>
-- sequence
-- list of cookies found in last header
--</return>
--<example>
-- Headers = WinHttpQueryHeaders( hRequest )
-- if sequence(Buffer) then
--   cookies = WinHttpExtractCookies(Headers, 1)
--   analyze_object(cookies, "cookies")
--
--   cookies = WinHttpExtractCookies(Headers)
--   analyze_object(cookies, "cookies", f_debug)
-- end if
--</example>
--<see_also></see_also>
--</function>
  sequence result, s, cookie
  integer p

  result = {}
  if length(headers) = 0 then return {} end if
  headers = split_string(headers, "\r\n")

  for i = 1 to length(headers) do
    if begins("Set-Cookie:", headers[i]) then
      if raw then
        result = append(result, headers[i])
      else
        s = headers[i][13..$]
        p = find(';', s)
        if p then s = s[1..p-1] end if
        cookie = split_string(s, '=')
        result = append(result, cookie)
      end if
    end if
  end for
  return result
end function

--------------------------------------------------------------------------------

public function WinHttpExtractCsrfToken( sequence content )
--<function>
--<name>WinHttpExtractCsrfToken</name>
--<digest>extract CSRF token from HTML content</digest>
--<desc>
--</desc>
--<param>
--<type>sequence</type>
--<name>content</name>
--<desc>HTML content</desc>
--</param>
--<return>
-- sequence
-- * CRSF token
--</return>
--<example>
-- Buffer = ""
-- dwSize = WinHttpQueryDataAvailable(hRequest)
-- while dwSize do
--   Buffer &= WinHttpReadData(hRequest, dwSize)
--   dwSize = WinHttpQueryDataAvailable(hRequest)
-- end while
-- token = WinHttpExtractCsrfToken(Buffer)
--</example>
--<see_also></see_also>
--</function>
  object o
  sequence token

  if length(content) = 0 then return "" end if
  o = find_all_text(content, "<meta", "/>", 1)
  if atom(o) then return "" end if
--  analyze_object(o, "WinHttpExtractCsrfToken: o", f_debug)
  for i = 1 to length(o) do
    if match("name=\"csrf-token\"", o[i]) then
      token = get_attribute_value("content", o[i])
      return dequote(token, {})
    end if
  end for
  return ""
end function

--------------------------------------------------------------------------------

function SendRequest(atom hConnect, sequence verb, sequence path,
                     object additional_headers, object request_data,
                     integer ignore_cert)
  atom hRequest, addr
  integer bResults, dwSize, status
  sequence content, headers, url

  -- Create an HTTP request handle.
  hRequest = WinHttpOpenRequest(hConnect, verb, path,
                                NULL, WINHTTP_NO_REFERER,
                                {WINHTTP_DEFAULT_ACCEPT_TYPES},
                                WINHTTP_FLAG_SECURE)
  if hRequest = NULL then return 0 end if
  log_printf("hRequest = %d\n", {hRequest})

  if ignore_cert then
    -- Ignore certificate errors
    addr = allocate(4)
    poke4(addr, or_all({SECURITY_FLAG_IGNORE_UNKNOWN_CA,
                        SECURITY_FLAG_IGNORE_CERT_CN_INVALID,
                        SECURITY_FLAG_IGNORE_CERT_DATE_INVALID}))

    bResults = WinHttpSetOption(hRequest, WINHTTP_OPTION_SECURITY_FLAGS, addr, 4)
    free(addr)
    if bResults = NULL then
      bResults = WinHttpCloseHandle(hRequest)
      return 0
    end if
  end if

  -- Send a request.
  bResults = WinHttpSendRequest(hRequest, additional_headers, request_data, 0)
  if bResults = NULL then
    bResults = WinHttpCloseHandle(hRequest)
    return 0
  end if
  log_printf("bResults = %d\n", {bResults})

  -- End the request.
  bResults = WinHttpReceiveResponse( hRequest, NULL)
  if bResults = NULL then
    bResults = WinHttpCloseHandle(hRequest)
    return 0
  end if
  log_printf("bResults = %d\n", {bResults})

  -- Retrieve the header.
  headers = WinHttpQueryHeaders( hRequest )
  -- Print the header contents.
  if sequence(headers) then
    log_puts("Header contents: \n" & headers & "\n")
  end if

  -- Retrieve page content.
  content = ""
  dwSize = WinHttpQueryDataAvailable(hRequest)
  while dwSize do
    content &= WinHttpReadData(hRequest, dwSize)
    dwSize = WinHttpQueryDataAvailable(hRequest)
  end while
  if length(content) then
    log_puts("Page contents: \n" & content & "\n")
  end if

  url = WinHttpQueryOption(hRequest, WINHTTP_OPTION_URL)
  log_puts("Effective URL = " & url & "\n")

  status = WinHttpQueryStatusCode(hRequest)
  log_printf("HTTP Status = %d\n", status)
  bResults = WinHttpCloseHandle(hRequest)
  return {status, url, headers, content}
end function

--------------------------------------------------------------------------------

public function WinHttpGet(atom hConnect, sequence path, sequence optional)
--<function>
--<name></name>
--<digest></digest>
--<desc>
--</desc>
--<param>
--<type></type>
--<name></name>
--<desc></desc>
--</param>
--<param>
--<type></type>
--<name></name>
--<desc></desc>
--</param>
--<param>
--<type></type>
--<name></name>
--<desc></desc>
--</param>
--<return>
--</return>
--<example>
--</example>
--<see_also></see_also>
--</function>
  object additional_headers, request_data
  integer ignore_cert

  additional_headers = get_option("additional_headers", optional,
                                  WINHTTP_NO_ADDITIONAL_HEADERS)
  request_data       = get_option("request_data", optional,
                                  WINHTTP_NO_REQUEST_DATA)
  ignore_cert        = get_option("ignore_cert", optional, 0)
  return SendRequest(hConnect, "GET", path, additional_headers, request_data,
                     ignore_cert)
end function

--------------------------------------------------------------------------------

public function WinHttpPost(atom hConnect, sequence path,
                            object additional_headers, object request_data,
                            sequence optional)
--<function>
--<name></name>
--<digest></digest>
--<desc>
--</desc>
--<param>
--<type></type>
--<name></name>
--<desc></desc>
--</param>
--<param>
--<type></type>
--<name></name>
--<desc></desc>
--</param>
--<param>
--<type></type>
--<name></name>
--<desc></desc>
--</param>
--<param>
--<type></type>
--<name></name>
--<desc></desc>
--</param>
--<return>
--</return>
--<example>
--</example>
--<see_also></see_also>
--</function>
  integer ignore_cert

  ignore_cert = get_option("ignore_cert", optional, 0)
  return SendRequest(hConnect, "POST", path, additional_headers, request_data,
                     ignore_cert)
end function


