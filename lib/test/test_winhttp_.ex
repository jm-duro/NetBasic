include std/dll.e
include std/machine.e
include std/math.e
include std/console.e
include lib/_conv_.e
include lib/_debug_.e
include lib/_w32errors_.e
include lib/_winhttp_constants_.e
include lib/_winhttp_.e

-- Explanation of the Handle Hierarchy
-- 
-- First, a session handle is created with WinHttpOpen.
-- 
-- WinHttpConnect requires the session handle as its first parameter and
-- returns a connection handle for a specified server.
-- 
-- A request handle is created by WinHttpOpenRequest, which uses the
-- connection handle created by WinHttpConnect.
-- 
-- If the application chooses to add additional headers to the request, or
-- if is it necessary for the application to set credentials for
-- authentication, WinHttpAddRequestHeaders and WinHttpSetCredentials can
-- be called using this request handle.
-- 
-- The request is sent by WinHttpSendRequest, which uses the request
-- handle.
-- 
-- After sending the request, additional data can be sent to the server
-- using WinHttpWriteData, or the application can skip directly to
-- WinHttpReceiveResponse to specify that no more information is sent to
-- the server.
-- 
-- At this point, depending on the purpose of the application, the request
-- handle can be used to call WinHttpQueryHeaders, WinHttpQueryAuthSchemes,
-- or retrieve a resource with WinHttpQueryDataAvailable and
-- WinHttpReadData.

atom hSession, hConnect, hRequest
hSession = NULL
hConnect = NULL
hRequest = NULL

procedure free_pointers()
  integer bResults

  if hRequest != NULL then bResults = WinHttpCloseHandle(hRequest) end if
  if hConnect != NULL then bResults = WinHttpCloseHandle(hConnect) end if
  if hSession != NULL then bResults = WinHttpCloseHandle(hSession) end if
end procedure

object Buffer
integer bResults, dwSize
sequence UserAgent, cookies
atom addr

f_debug = open("debug.log", "w")
with_debug = 1

Buffer = ""
bResults = FALSE
UserAgent = "Mozilla/5.0 (Windows NT 10.0; WOW64; rv:47.0) Gecko/20100101 Firefox/47.0"

-- Use WinHttpOpen to obtain a session handle.
hSession = WinHttpOpen( UserAgent,
                        WINHTTP_ACCESS_TYPE_DEFAULT_PROXY,
                        WINHTTP_NO_PROXY_NAME,
                        WINHTTP_NO_PROXY_BYPASS, 0)
if hSession = NULL then
  printf(1, "Error %d: %s\n", {error_code, error_msg})
  abort(1)
end if
printf(1, "hSession = %d\n", {hSession})

-- Specify an HTTP server.
-- WinHTTP is Unicode only
hConnect = WinHttpConnect( hSession, "192.168.1.1", INTERNET_DEFAULT_HTTPS_PORT)
if hConnect = NULL then
  printf(1, "Error %d: %s\n", {error_code, error_msg})
  abort(1)
end if
printf(1, "hConnect = %d\n", {hConnect})

-- Create an HTTP request handle.
--  hRequest = WinHttpOpenRequest( hConnect, "GET", "/",
  hRequest = WinHttpOpenRequest( hConnect, NULL, NULL,
                                 NULL, WINHTTP_NO_REFERER,
                                 {WINHTTP_DEFAULT_ACCEPT_TYPES},
                                 WINHTTP_FLAG_SECURE)
if hRequest = NULL then
  printf(1, "Error %d: %s\n", {error_code, error_msg})
  abort(1)
end if
printf(1, "hRequest = %d\n", {hRequest})

-- Ignore certificate errors
addr = allocate(4)
poke4(addr, or_all({SECURITY_FLAG_IGNORE_UNKNOWN_CA,
                    SECURITY_FLAG_IGNORE_CERT_CN_INVALID,
                    SECURITY_FLAG_IGNORE_CERT_DATE_INVALID}))

bResults = WinHttpSetOption(hRequest, WINHTTP_OPTION_SECURITY_FLAGS,
                            addr, 4)
free(addr)
if bResults = NULL then
  printf(1, "Error %d: %s\n", {error_code, error_msg})
  abort(1)
end if

-- Send a request.
bResults = WinHttpSendRequest( hRequest,
                               WINHTTP_NO_ADDITIONAL_HEADERS,
                               WINHTTP_NO_REQUEST_DATA,
                               0)
if bResults = NULL then
  printf(1, "Error %d: %s\n", {error_code, error_msg})
  abort(1)
end if
printf(1, "bResults = %d\n", {bResults})

-- End the request.
bResults = WinHttpReceiveResponse( hRequest, NULL)
if bResults = NULL then
  printf(1, "Error %d: %s\n", {error_code, error_msg})
  abort(1)
end if
printf(1, "bResults = %d\n", {bResults})

-- Retrieve the header.
Buffer = WinHttpQueryHeaders( hRequest )
-- Print the header contents.
if sequence(Buffer) then
  printf(1, "Header contents: \n%s", {Buffer})
  cookies = WinHttpExtractCookies(Buffer, 1)
  analyze_object(cookies, "cookies")
  cookies = WinHttpExtractCookies(Buffer)
  analyze_object(cookies, "cookies")
end if

-- Retrieve page content.
Buffer = ""
dwSize = WinHttpQueryDataAvailable(hRequest)
while dwSize do
  Buffer &= WinHttpReadData(hRequest, dwSize)
  dwSize = WinHttpQueryDataAvailable(hRequest)
end while
puts(1, Buffer & "\n")
puts(1, "CSRF-Token = " & WinHttpExtractCsrfToken(Buffer) & "\n")

-- Close any open handles.
free_pointers()

maybe_any_key()
