-- Windows error codes
-- source: Microsoft
-- https://msdn.microsoft.com/en-us/library/windows/desktop/ms681381(v=vs.85).aspx
--
-- Pretty exhaustive list of Win32 error codes as of August 2016
-- Jean-Marc Duro
--
-- function FormatSystemError() is a copy of Fabio Ramirez's sys_FormatMessage()
-- v1.1  2016-08-17   added WinHTTP errors
-- v1.0  2016-08-15

include std/dll.e
include std/machine.e
include std/math.e
include _dll_.e

public constant
  -- To format error messages ( used by FormatSystemError() )
  FORMAT_MESSAGE_ALLOCATE_BUFFER = 256,
  FORMAT_MESSAGE_FROM_SYSTEM     = 4096,
  FORMAT_MESSAGE_IGNORE_INSERTS  = 512
--<constant>
--<name>FORMAT_MESSAGE_ALLOCATE_BUFFER</name>
--<value>256</value>
--<desc></desc>
--</constant>
--<constant>
--<name>FORMAT_MESSAGE_FROM_SYSTEM</name>
--<value>4096</value>
--<desc></desc>
--</constant>
--<constant>
--<name>FORMAT_MESSAGE_IGNORE_INSERTS</name>
--<value>512</value>
--<desc></desc>
--</constant>


public integer error_code
--<variable>
--<type>integer</type>
--<name>error_code</name>
--<desc>numerical value of the last Windows error code</desc>
--</variable>
error_code = 0

public sequence error_msg
--<variable>
--<type>sequence</type>
--<name>error_msg</name>
--<desc>description of the last Windows error code</desc>
--</variable>
error_msg = ""

constant KERNEL32_LIBRARY_DEFINITION = {
  {
    "kernel32",     -- L_NAME
    0,              -- L_LNX_64
    0,              -- L_LNX_32
    0,              -- L_WIN_64
    "kernel32.dll"  -- L_WIN_32
  }
}

atom kernel32
kernel32 = register_library("kernel32", KERNEL32_LIBRARY_DEFINITION)

constant KERNEL32_ROUTINE_DEFINITION = {
  {"GetLastError",   {}, long},
  {"FormatMessageA", {pointer, pointer, pointer, pointer, pointer, pointer,
                      pointer}, pointer}
}

integer xGetLastError, xFormatMessage
xGetLastError  = register_routine(kernel32, "GetLastError",
                                  KERNEL32_ROUTINE_DEFINITION)
xFormatMessage = register_routine(kernel32, "FormatMessageA",
                                  KERNEL32_ROUTINE_DEFINITION)

--------------------------------------------------------------------------------

constant
  INTERNET_ERROR_MESSAGES = {
  {#2EE0, "Not an error. Used internally as a reference for Internet errors."},
  {#2EE1, "No more handles could be generated at this time."},
  {#2EE1, "Obsolete; no longer used."},
  {#2EE2, "The request has timed out."},
  {#2EE3, "An extended error was returned from the server. This is typically" &
          " a string\nor buffer containing a verbose error message." &
          " Call\nInternetGetLastResponseInfo to retrieve the error text."},
  {#2EE4, "An internal error has occurred."},
  {#2EE5, "The URL is invalid."},
  {#2EE6, "The URL scheme could not be recognized, or is not supported."},
  {#2EE7, "The server name could not be resolved."},
  {#2EE8, "The requested protocol could not be located."},
  {#2EE9, "A request to InternetQueryOption or InternetSetOption specified an" &
          " invalid\noption value."},
  {#2EEA, "The length of an option supplied to InternetQueryOption or\n" &
          "InternetSetOption is incorrect for the type of option specified."},
  {#2EEB, "The requested option cannot be set, only queried."},
  {#2EEC, "WinINet support is being shut down or unloaded."},
  {#2EED, "The request to connect and log on to an FTP server could not be" &
          " completed\nbecause the supplied user name is incorrect."},
  {#2EEE, "The request to connect and log on to an FTP server could not be" &
          " completed\nbecause the supplied password is incorrect."},
  {#2EEF, "The request to connect and log on to an FTP server failed."},
  {#2EF0, "The requested operation is invalid."},
  {#2EF1, "The operation was canceled, usually because the handle on which" &
          " the request\nwas operating was closed before the operation" &
          " completed."},
  {#2EF2, "The type of handle supplied is incorrect for this operation."},
  {#2EF3, "The requested operation cannot be carried out because the handle" &
          " supplied\nis not in the correct state."},
  {#2EF4, "The request cannot be made via a proxy."},
  {#2EF5, "A required registry value could not be located."},
  {#2EF6, "A required registry value was located but is an incorrect type or" &
          " has an\ninvalid value."},
  {#2EF7, "Direct network access cannot be made at this time."},
  {#2EF8, "An asynchronous request could not be made because a zero context" &
          " value was\nsupplied."},
  {#2EF9, "An asynchronous request could not be made because a callback" &
          " function has\nnot been set."},
  {#2EFA, "The required operation could not be completed because one or" &
          " more requests\nare pending."},
  {#2EFB, "The format of the request is invalid."},
  {#2EFC, "The requested item could not be located."},
  {#2EFD, "The attempt to connect to the server failed."},
  {#2EFE, "The connection with the server has been terminated."},
  {#2EFF, "The connection with the server has been reset."},
  {#2F00, "The function needs to redo the request."},
  {#2F01, "The request to the proxy was invalid."},
  {#2F02, "A user interface or other blocking operation has been requested."},
  {#2F04, "The request failed because the handle already exists."},
  {#2F05, "SSL certificate date that was received from the server is bad." &
          " The\ncertificate is expired."},
  {#2F06, "SSL certificate common name (host name field) is incorrect -" &
          " for example,\nif you entered www.server.com and the common name" &
          " on the certificate says\nwww.different.com."},
  {#2F07, "The application is moving from a non-SSL to an SSL connection" &
          " because of a\nredirect."},
  {#2F08, "The application is moving from an SSL to an non-SSL connection" &
          " because of a\nredirect."},
  {#2F09, "The content is not entirely secure. Some of the content being" &
          " viewed may\nhave come from unsecured servers."},
  {#2F0A, "The application is posting and attempting to change multiple" &
          " lines of text\non a server that is not secure."},
  {#2F0B, "The application is posting data to a server that is not secure."},
  {#2F0C, "The server is requesting client authentication."},
  {#2F0D, "The function is unfamiliar with the Certificate Authority that" &
          " generated\nthe server's certificate."},
  {#2F0E, "Client authorization is not set up on this computer."},
  {#2F0F, "The application could not start an asynchronous thread."},
  {#2F10, "The function could not handle the redirection, because the" &
          " scheme changed\n(for example, HTTP to FTP)."},
  {#2F11, "Another thread has a password dialog box in progress."},
  {#2F12, "The dialog box should be retried."},
  {#2F14, "The data being submitted to an SSL connection is being redirected" &
          " to a\nnon-SSL connection."},
  {#2F15, "The request requires a CD-ROM to be inserted in the CD-ROM drive" &
          " to locate\nthe resource requested."},
  {#2F16, "The requested resource requires Fortezza authentication."},
  {#2F17, "The SSL certificate contains errors."},
  {#2F18, "The SSL certificate was not revoked."},
  {#2F19, "Revocation of the SSL certificate failed."},
  {#2F44, "Returned by the HttpRequest object if a requested operation" &
          " cannot be\nperformed before calling the Open method."},
  {#2F45, "Returned by the HttpRequest object if a requested operation" &
          " cannot be\nperformed before calling the Send method."},
  {#2F46, "Returned by the HttpRequest object if a requested operation" &
          " cannot be\nperformed after calling the Send method."},
  {#2F47, "Returned by the HttpRequest object if a specified option cannot" &
          " be\nrequested after the Open method has been called."},
  {#2F4E, "The requested operation cannot be made on the FTP session handle" &
          " because an\noperation is already in progress."},
  {#2F4F, "The FTP operation was not completed because the session was" &
          " aborted."},
  {#2F50, "Passive mode is not available on the server."},
  {#2F62, "An error was detected while parsing data returned from the Gopher" &
          " server."},
  {#2F63, "The request must be made for a file locator."},
  {#2F64, "An error was detected while receiving data from the Gopher server."},
  {#2F65, "The end of the data has been reached."},
  {#2F66, "The supplied locator is not valid."},
  {#2F67, "The type of the locator is not correct for this operation."},
  {#2F68, "The requested operation can be made only against a Gopher+ server," &
          " or with\na locator that specifies a Gopher+ operation."},
  {#2F69, "The requested attribute could not be located."},
  {#2F6A, "The locator type is unknown."},
  {#2F76, "The requested header could not be located."},
  {#2F77, "The server did not return any headers."},
  {#2F78, "The server response could not be parsed."},
  {#2F79, "The supplied header is invalid."},
  {#2F7A, "The request made to HttpQueryInfo is invalid."},
  {#2F7A, "Obsolete; no longer used."},
  {#2F7B, "The header could not be added because it already exists."},
  {#2F7B, "Obsolete; no longer used."},
  {#2F7C, "The redirection failed because either the scheme changed (for" &
          " example, HTTP\nto FTP) or all attempts made to redirect failed (default is five attempts)."},
  {#2F7D, "The application experienced an internal error loading the SSL" &
          " libraries."},
  {#2F7E, "The function was unable to cache the file."},
  {#2F7F, "The required protocol stack is not loaded and the application" &
          " cannot start\nWinSock."},
  {#2F80, "The HTTP request was not redirected."},
  {#2F81, "The HTTP cookie requires confirmation."},
  {#2F82, "The HTTP cookie was declined by the server."},
  {#2F83, "The Internet connection has been lost."},
  {#2F84, "The Web site or server indicated is unreachable."},
  {#2F85, "The designated proxy server cannot be reached."},
  {#2F86, "There was an error in the automatic proxy configuration script."},
  {#2F87, "The automatic proxy configuration script could not be downloaded." &
          " The\nINTERNET_FLAG_MUST_CACHE_REQUEST flag was set."},
  {#2F88, "The redirection requires user confirmation."},
  {#2F89, "SSL certificate is invalid."},
  {#2F8A, "SSL certificate was revoked."},
  {#2F8B, "The function failed due to a security check."},
  {#2F8C, "Initialization of the WinINet API has not occurred. Indicates" &
          " that a\nhigher-level function, such as InternetOpen, has not" &
          " been called yet."},
  {#2F8C, "Obsolete; no longer used."},
  {#2F8E, "The MS-Logoff digest header has been returned from the Web site." &
          " This\nheader specifically instructs the digest package to purge" &
          " credentials for\nthe associated realm. This error will only be" &
          " returned if\nINTERNET_ERROR_MASK_LOGIN_FAILURE_DISPLAY_ENTITY_BODY" &
          " has been set."},
  {#2F8F, "One or more errors were found in the Secure Sockets Layer (SSL)" &
          " certificate\nsent by the server. To determine what type of error" &
          " was encountered, check\nfor a WINHTTP_CALLBACK_STATUS_SECURE_FAILURE" &
          " notification in a status\ncallback function. For more information," &
          " see WINHTTP_STATUS_CALLBACK."},
  {#2F90, "The script type is not supported."},
  {#2F91, "An error was encountered while executing a script."},
  {#2F92, "Returned by WinHttpGetProxyForUrl when a proxy for the specified" &
          " URL cannot\nbe located."},
  {#2F93, "Indicates that a certificate is not valid for the requested usage\n" &
          "(equivalent to CERT_E_WRONG_USAGE)."},
  {#2F94, "Returned by WinHttpDetectAutoProxyConfigUrl if WinHTTP was unable" &
          " to\ndiscover the URL of the Proxy Auto-Configuration (PAC) file."},
  {#2F95, "Returned by WinHttpReceiveResponse when a larger number of headers" &
          " were\npresent in a response than WinHTTP could receive."},
  {#2F96, "Returned by WinHttpReceiveResponse when the size of headers" &
          " received\nexceeds the limit for the request handle."},
  {#2F97, "Returned by WinHttpReceiveResponse when an overflow condition is\n" &
          "encountered in the course of parsing chunked encoding."},
  {#2F98, "Returned when an incoming response exceeds an internal WinHTTP size" &
          " limit."},
  {#2F99, "The context for the SSL client certificate does not have a private" &
          " key\nassociated with it. The client certificate may have been" &
          " imported to the\ncomputer without the private key.\nWindows Server" &
          " 2003 with SP1 and Windows XP with SP2: This error is not\nsupported."},
  {#2F9A, "The application does not have the required privileges to access the" &
          " private\nkey associated with the client certificate.\nWindows" &
          " Server 2003 with SP1 and Windows XP with SP2: This error is not\n" &
          "supported."}
  }

--------------------------------------------------------------------------------

public function GetLastError()
--<function>
--<name>GetLastError</name>
--<digest>get last Windows error code</digest>
--<desc>
--</desc>
--<return>
--</return>
--<example>
--</example>
--<see_also>
--</see_also>
--</function>
 return c_func(xGetLastError, {})
end function

--------------------------------------------------------------------------------

public function GetInternetError(atom ErrorCode)
--<function>
--<name>GetInternetError</name>
--<digest>return description of Internet error based on its code</digest>
--<desc>
--</desc>
--<param>
--<type>atom</type>
--<name>ErrorCode</name>
--<desc></desc>
--</param>
--<return>
--</return>
--<example>
--</example>
--<see_also>
--</see_also>
--</function>
  for i = 1 to length(INTERNET_ERROR_MESSAGES) do
    if INTERNET_ERROR_MESSAGES[i][1] = ErrorCode then
      return INTERNET_ERROR_MESSAGES[i][2]
    end if
  end for
  return ""
end function

--------------------------------------------------------------------------------

public function FormatSystemError(atom ErrorCode)
--<function>
--<name>FormatSystemError</name>
--<digest>return description of System error based on its code</digest>
--<desc>
--</desc>
--<param>
--<type>atom</type>
--<name>ErrorCode</name>
--<desc></desc>
--</param>
--<return>
--</return>
--<example>
--</example>
--<see_also>
--</see_also>
--</function>
  atom posBuffer, Buffer, BufferLength
  sequence ExtMessage
  
  if (ErrorCode > 12000) and (ErrorCode < 13000) then
    return GetInternetError(ErrorCode)
  end if
  
  ExtMessage = {}
  posBuffer = allocate(4)
  BufferLength =  c_func(xFormatMessage, {
    or_all({
      FORMAT_MESSAGE_ALLOCATE_BUFFER,
      FORMAT_MESSAGE_FROM_SYSTEM,
      FORMAT_MESSAGE_IGNORE_INSERTS
    }),
    NULL, ErrorCode, NULL, posBuffer, NULL, NULL
  })

  if BufferLength > 0 then
    Buffer = peek4u(posBuffer)
    ExtMessage = peek_string(Buffer)
  end if
  free(posBuffer)
  return ExtMessage
end function

--------------------------------------------------------------------------------

public constant
  ERROR_SUCCESS                                             =     0,  -- (#0000)
--<constant>
--<name>ERROR_SUCCESS</name>
--<value>0</value>
--<desc>The operation completed successfully.</desc>
--</constant>

  ERROR_INVALID_FUNCTION                                    =     1,  -- (#0001)
--<constant>
--<name>ERROR_INVALID_FUNCTION</name>
--<value>1</value>
--<desc>Incorrect function.</desc>
--</constant>

  ERROR_FILE_NOT_FOUND                                      =     2,  -- (#0002)
--<constant>
--<name>ERROR_FILE_NOT_FOUND</name>
--<value>2</value>
--<desc>The system cannot find the file specified.</desc>
--</constant>

  ERROR_PATH_NOT_FOUND                                      =     3,  -- (#0003)
--<constant>
--<name>ERROR_PATH_NOT_FOUND</name>
--<value>3</value>
--<desc>The system cannot find the path specified.</desc>
--</constant>

  ERROR_TOO_MANY_OPEN_FILES                                 =     4,  -- (#0004)
--<constant>
--<name>ERROR_TOO_MANY_OPEN_FILES</name>
--<value>4</value>
--<desc>The system cannot open the file.</desc>
--</constant>

  ERROR_ACCESS_DENIED                                       =     5,  -- (#0005)
--<constant>
--<name>ERROR_ACCESS_DENIED</name>
--<value>5</value>
--<desc>Access is denied.</desc>
--</constant>

  ERROR_INVALID_HANDLE                                      =     6,  -- (#0006)
--<constant>
--<name>ERROR_INVALID_HANDLE</name>
--<value>6</value>
--<desc>The handle is invalid.</desc>
--</constant>

  ERROR_ARENA_TRASHED                                       =     7,  -- (#0007)
--<constant>
--<name>ERROR_ARENA_TRASHED</name>
--<value>7</value>
--<desc>The storage control blocks were destroyed.</desc>
--</constant>

  ERROR_NOT_ENOUGH_MEMORY                                   =     8,  -- (#0008)
--<constant>
--<name>ERROR_NOT_ENOUGH_MEMORY</name>
--<value>8</value>
--<desc>Not enough storage is available to process this command.</desc>
--</constant>

  ERROR_INVALID_BLOCK                                       =     9,  -- (#0009)
--<constant>
--<name>ERROR_INVALID_BLOCK</name>
--<value>9</value>
--<desc>The storage control block address is invalid.</desc>
--</constant>

  ERROR_BAD_ENVIRONMENT                                     =    10,  -- (#000A)
--<constant>
--<name>ERROR_BAD_ENVIRONMENT</name>
--<value>10</value>
--<desc>The environment is incorrect.</desc>
--</constant>

  ERROR_BAD_FORMAT                                          =    11,  -- (#000B)
--<constant>
--<name>ERROR_BAD_FORMAT</name>
--<value>11</value>
--<desc>An attempt was made to load a program with an incorrect format.</desc>
--</constant>

  ERROR_INVALID_ACCESS                                      =    12,  -- (#000C)
--<constant>
--<name>ERROR_INVALID_ACCESS</name>
--<value>12</value>
--<desc>The access code is invalid.</desc>
--</constant>

  ERROR_INVALID_DATA                                        =    13,  -- (#000D)
--<constant>
--<name>ERROR_INVALID_DATA</name>
--<value>13</value>
--<desc>The data is invalid.</desc>
--</constant>

  ERROR_OUTOFMEMORY                                         =    14,  -- (#000E)
--<constant>
--<name>ERROR_OUTOFMEMORY</name>
--<value>14</value>
--<desc>Not enough storage is available to complete this operation.</desc>
--</constant>

  ERROR_INVALID_DRIVE                                       =    15,  -- (#000F)
--<constant>
--<name>ERROR_INVALID_DRIVE</name>
--<value>15</value>
--<desc>The system cannot find the drive specified.</desc>
--</constant>

  ERROR_CURRENT_DIRECTORY                                   =    16,  -- (#0010)
--<constant>
--<name>ERROR_CURRENT_DIRECTORY</name>
--<value>16</value>
--<desc>The directory cannot be removed.</desc>
--</constant>

  ERROR_NOT_SAME_DEVICE                                     =    17,  -- (#0011)
--<constant>
--<name>ERROR_NOT_SAME_DEVICE</name>
--<value>17</value>
--<desc>The system cannot move the file to a different disk drive.</desc>
--</constant>

  ERROR_NO_MORE_FILES                                       =    18,  -- (#0012)
--<constant>
--<name>ERROR_NO_MORE_FILES</name>
--<value>18</value>
--<desc>There are no more files.</desc>
--</constant>

  ERROR_WRITE_PROTECT                                       =    19,  -- (#0013)
--<constant>
--<name>ERROR_WRITE_PROTECT</name>
--<value>19</value>
--<desc>The media is write protected.</desc>
--</constant>

  ERROR_BAD_UNIT                                            =    20,  -- (#0014)
--<constant>
--<name>ERROR_BAD_UNIT</name>
--<value>20</value>
--<desc>The system cannot find the device specified.</desc>
--</constant>

  ERROR_NOT_READY                                           =    21,  -- (#0015)
--<constant>
--<name>ERROR_NOT_READY</name>
--<value>21</value>
--<desc>The device is not ready.</desc>
--</constant>

  ERROR_BAD_COMMAND                                         =    22,  -- (#0016)
--<constant>
--<name>ERROR_BAD_COMMAND</name>
--<value>22</value>
--<desc>The device does not recognize the command.</desc>
--</constant>

  ERROR_CRC                                                 =    23,  -- (#0017)
--<constant>
--<name>ERROR_CRC</name>
--<value>23</value>
--<desc>Data error (cyclic redundancy check).</desc>
--</constant>

  ERROR_BAD_LENGTH                                          =    24,  -- (#0018)
--<constant>
--<name>ERROR_BAD_LENGTH</name>
--<value>24</value>
--<desc>The program issued a command but the command length is incorrect.</desc>
--</constant>

  ERROR_SEEK                                                =    25,  -- (#0019)
--<constant>
--<name>ERROR_SEEK</name>
--<value>25</value>
--<desc>The drive cannot locate a specific area or track on the disk.</desc>
--</constant>

  ERROR_NOT_DOS_DISK                                        =    26,  -- (#001A)
--<constant>
--<name>ERROR_NOT_DOS_DISK</name>
--<value>26</value>
--<desc>The specified disk or diskette cannot be accessed.</desc>
--</constant>

  ERROR_SECTOR_NOT_FOUND                                    =    27,  -- (#001B)
--<constant>
--<name>ERROR_SECTOR_NOT_FOUND</name>
--<value>27</value>
--<desc>The drive cannot find the sector requested.</desc>
--</constant>

  ERROR_OUT_OF_PAPER                                        =    28,  -- (#001C)
--<constant>
--<name>ERROR_OUT_OF_PAPER</name>
--<value>28</value>
--<desc>The printer is out of paper.</desc>
--</constant>

  ERROR_WRITE_FAULT                                         =    29,  -- (#001D)
--<constant>
--<name>ERROR_WRITE_FAULT</name>
--<value>29</value>
--<desc>The system cannot write to the specified device.</desc>
--</constant>

  ERROR_READ_FAULT                                          =    30,  -- (#001E)
--<constant>
--<name>ERROR_READ_FAULT</name>
--<value>30</value>
--<desc>The system cannot read from the specified device.</desc>
--</constant>

  ERROR_GEN_FAILURE                                         =    31,  -- (#001F)
  -- A device attached to the system is not functioning.
--<constant>
--<name>ERROR_GEN_FAILURE</name>
--<value>31</value>
--<desc></desc>
--</constant>

  ERROR_SHARING_VIOLATION                                   =    32,  -- (#0020)
--<constant>
--<name>ERROR_SHARING_VIOLATION</name>
--<value>32</value>
--<desc>
-- The process cannot access the file because it is being used by another
-- process.
--</desc>
--</constant>

  ERROR_LOCK_VIOLATION                                      =    33,  -- (#0021)
--<constant>
--<name>ERROR_LOCK_VIOLATION</name>
--<value>33</value>
--<desc>
-- The process cannot access the file because another process has locked a
-- portion of the file.
--</desc>
--</constant>

  ERROR_WRONG_DISK                                          =    34,  -- (#0022)
--<constant>
--<name>ERROR_WRONG_DISK</name>
--<value>34</value>
--<desc>
-- The wrong diskette is in the drive. Insert %2 (Volume Serial Number: %3)
-- into drive %1.
--</desc>
--</constant>

  ERROR_SHARING_BUFFER_EXCEEDED                             =    36,  -- (#0024)
--<constant>
--<name>ERROR_SHARING_BUFFER_EXCEEDED</name>
--<value>36</value>
--<desc>Too many files opened for sharing.</desc>
--</constant>

  ERROR_HANDLE_EOF                                          =    38,  -- (#0026)
--<constant>
--<name>ERROR_HANDLE_EOF</name>
--<value>38</value>
--<desc>Reached the end of the file.</desc>
--</constant>

  ERROR_HANDLE_DISK_FULL                                    =    39,  -- (#0027)
--<constant>
--<name>ERROR_HANDLE_DISK_FULL</name>
--<value>39</value>
--<desc>The disk is full.</desc>
--</constant>

  ERROR_NOT_SUPPORTED                                       =    50,  -- (#0032)
--<constant>
--<name>ERROR_NOT_SUPPORTED</name>
--<value>50</value>
--<desc>The request is not supported.</desc>
--</constant>

  ERROR_REM_NOT_LIST                                        =    51,  -- (#0033)
--<constant>
--<name>ERROR_REM_NOT_LIST</name>
--<value>51</value>
--<desc>The remote computer is not available.</desc>
--</constant>

  ERROR_DUP_NAME                                            =    52,  -- (#0034)
--<constant>
--<name>ERROR_DUP_NAME</name>
--<value>52</value>
--<desc>A duplicate name exists on the network.</desc>
--</constant>

  ERROR_BAD_NETPATH                                         =    53,  -- (#0035)
--<constant>
--<name>ERROR_BAD_NETPATH</name>
--<value>53</value>
--<desc>The network path was not found.</desc>
--</constant>

  ERROR_NETWORK_BUSY                                        =    54,  -- (#0036)
--<constant>
--<name>ERROR_NETWORK_BUSY</name>
--<value>54</value>
--<desc>The network is busy.</desc>
--</constant>

  ERROR_DEV_NOT_EXIST                                       =    55,  -- (#0037)
--<constant>
--<name>ERROR_DEV_NOT_EXIST</name>
--<value>55</value>
--<desc>The specified network resource or device is no longer available.</desc>
--</constant>

  ERROR_TOO_MANY_CMDS                                       =    56,  -- (#0038)
--<constant>
--<name>ERROR_TOO_MANY_CMDS</name>
--<value>56</value>
--<desc>The network BIOS command limit has been reached.</desc>
--</constant>

  ERROR_ADAP_HDW_ERR                                        =    57,  -- (#0039)
--<constant>
--<name>ERROR_ADAP_HDW_ERR</name>
--<value>57</value>
--<desc>A network adapter hardware error occurred.</desc>
--</constant>

  ERROR_BAD_NET_RESP                                        =    58,  -- (#003A)
--<constant>
--<name>ERROR_BAD_NET_RESP</name>
--<value>58</value>
--<desc>The specified server cannot perform the requested operation.</desc>
--</constant>

  ERROR_UNEXP_NET_ERR                                       =    59,  -- (#003B)
--<constant>
--<name>ERROR_UNEXP_NET_ERR</name>
--<value>59</value>
--<desc>An unexpected network error occurred.</desc>
--</constant>

  ERROR_BAD_REM_ADAP                                        =    60,  -- (#003C)
  -- The remote adapter is not compatible.
--<constant>
--<name>ERROR_BAD_REM_ADAP</name>
--<value>60</value>
--<desc></desc>
--</constant>

  ERROR_PRINTQ_FULL                                         =    61,  -- (#003D)
--<constant>
--<name>ERROR_PRINTQ_FULL</name>
--<value>61</value>
--<desc>The printer queue is full.</desc>
--</constant>

  ERROR_NO_SPOOL_SPACE                                      =    62,  -- (#003E)
--<constant>
--<name>ERROR_NO_SPOOL_SPACE</name>
--<value>62</value>
--<desc>
-- Space to store the file waiting to be printed is not available on the
-- server.
--</desc>
--</constant>

  ERROR_PRINT_CANCELLED                                     =    63,  -- (#003F)
--<constant>
--<name>ERROR_PRINT_CANCELLED</name>
--<value>63</value>
--<desc>Your file waiting to be printed was deleted.</desc>
--</constant>

  ERROR_NETNAME_DELETED                                     =    64,  -- (#0040)
--<constant>
--<name>ERROR_NETNAME_DELETED</name>
--<value>64</value>
--<desc>The specified network name is no longer available.</desc>
--</constant>

  ERROR_NETWORK_ACCESS_DENIED                               =    65,  -- (#0041)
--<constant>
--<name>ERROR_NETWORK_ACCESS_DENIED</name>
--<value>65</value>
--<desc>Network access is denied.</desc>
--</constant>

  ERROR_BAD_DEV_TYPE                                        =    66,  -- (#0042)
--<constant>
--<name>ERROR_BAD_DEV_TYPE</name>
--<value>66</value>
--<desc>The network resource type is not correct.</desc>
--</constant>

  ERROR_BAD_NET_NAME                                        =    67,  -- (#0043)
--<constant>
--<name>ERROR_BAD_NET_NAME</name>
--<value>67</value>
--<desc>The network name cannot be found.</desc>
--</constant>

  ERROR_TOO_MANY_NAMES                                      =    68,  -- (#0044)
--<constant>
--<name>ERROR_TOO_MANY_NAMES</name>
--<value>68</value>
--<desc>The name limit for the local computer network adapter card was exceeded.</desc>
--</constant>

  ERROR_TOO_MANY_SESS                                       =    69,  -- (#0045)
--<constant>
--<name>ERROR_TOO_MANY_SESS</name>
--<value>69</value>
--<desc>The network BIOS session limit was exceeded.</desc>
--</constant>

  ERROR_SHARING_PAUSED                                      =    70,  -- (#0046)
--<constant>
--<name>ERROR_SHARING_PAUSED</name>
--<value>70</value>
--<desc>The remote server has been paused or is in the process of being started.</desc>
--</constant>

  ERROR_REQ_NOT_ACCEP                                       =    71,  -- (#0047)
--<constant>
--<name>ERROR_REQ_NOT_ACCEP</name>
--<value>71</value>
--<desc>
-- No more connections can be made to this remote computer at this time
-- because there are already as many connections as the computer can accept.
--</desc>
--</constant>

  ERROR_REDIR_PAUSED                                        =    72,  -- (#0048)
--<constant>
--<name>ERROR_REDIR_PAUSED</name>
--<value>72</value>
--<desc>The specified printer or disk device has been paused.</desc>
--</constant>

  ERROR_FILE_EXISTS                                         =    80,  -- (#0050)
  -- The file exists.
--<constant>
--<name>ERROR_FILE_EXISTS</name>
--<value>80</value>
--<desc></desc>
--</constant>

  ERROR_CANNOT_MAKE                                         =    82,  -- (#0052)
--<constant>
--<name>ERROR_CANNOT_MAKE</name>
--<value>82</value>
--<desc>The directory or file cannot be created.</desc>
--</constant>

  ERROR_FAIL_I24                                            =    83,  -- (#0053)
--<constant>
--<name>ERROR_FAIL_I24</name>
--<value>83</value>
--<desc>Fail on INT 24.</desc>
--</constant>

  ERROR_OUT_OF_STRUCTURES                                   =    84,  -- (#0054)
--<constant>
--<name>ERROR_OUT_OF_STRUCTURES</name>
--<value>84</value>
--<desc>Storage to process this request is not available.</desc>
--</constant>

  ERROR_ALREADY_ASSIGNED                                    =    85,  -- (#0055)
--<constant>
--<name>ERROR_ALREADY_ASSIGNED</name>
--<value>85</value>
--<desc>The local device name is already in use.</desc>
--</constant>

  ERROR_INVALID_PASSWORD                                    =    86,  -- (#0056)
--<constant>
--<name>ERROR_INVALID_PASSWORD</name>
--<value>86</value>
--<desc>The specified network password is not correct.</desc>
--</constant>

  ERROR_INVALID_PARAMETER                                   =    87,  -- (#0057)
--<constant>
--<name>ERROR_INVALID_PARAMETER</name>
--<value>87</value>
--<desc>The parameter is incorrect.</desc>
--</constant>

  ERROR_NET_WRITE_FAULT                                     =    88,  -- (#0058)
--<constant>
--<name>ERROR_NET_WRITE_FAULT</name>
--<value>88</value>
--<desc>A write fault occurred on the network.</desc>
--</constant>

  ERROR_NO_PROC_SLOTS                                       =    89,  -- (#0059)
--<constant>
--<name>ERROR_NO_PROC_SLOTS</name>
--<value>89</value>
--<desc>The system cannot start another process at this time.</desc>
--</constant>

  ERROR_TOO_MANY_SEMAPHORES                                 =   100,  -- (#0064)
--<constant>
--<name>ERROR_TOO_MANY_SEMAPHORES</name>
--<value>100</value>
--<desc>Cannot create another system semaphore.</desc>
--</constant>
--<constant>
--<name>ERROR_EXCL_SEM_ALREADY_OWNED</name>
--<value>101</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_SEM_IS_SET</name>
--<value>102</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_TOO_MANY_SEM_REQUESTS</name>
--<value>103</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_INVALID_AT_INTERRUPT_TIME</name>
--<value>104</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_SEM_OWNER_DIED</name>
--<value>105</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_SEM_USER_LIMIT</name>
--<value>106</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_DISK_CHANGE</name>
--<value>107</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_DRIVE_LOCKED</name>
--<value>108</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_BROKEN_PIPE</name>
--<value>109</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_OPEN_FAILED</name>
--<value>110</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_BUFFER_OVERFLOW</name>
--<value>111</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_DISK_FULL</name>
--<value>112</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_NO_MORE_SEARCH_HANDLES</name>
--<value>113</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_INVALID_TARGET_HANDLE</name>
--<value>114</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_INVALID_CATEGORY</name>
--<value>117</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_INVALID_VERIFY_SWITCH</name>
--<value>118</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_BAD_DRIVER_LEVEL</name>
--<value>119</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_CALL_NOT_IMPLEMENTED</name>
--<value>120</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_SEM_TIMEOUT</name>
--<value>121</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_INSUFFICIENT_BUFFER</name>
--<value>122</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_INVALID_NAME</name>
--<value>123</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_INVALID_LEVEL</name>
--<value>124</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_NO_VOLUME_LABEL</name>
--<value>125</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_MOD_NOT_FOUND</name>
--<value>126</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_PROC_NOT_FOUND</name>
--<value>127</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_WAIT_NO_CHILDREN</name>
--<value>128</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_CHILD_NOT_COMPLETE</name>
--<value>129</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_DIRECT_ACCESS_HANDLE</name>
--<value>130</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_NEGATIVE_SEEK</name>
--<value>131</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_SEEK_ON_DEVICE</name>
--<value>132</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_IS_JOIN_TARGET</name>
--<value>133</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_IS_JOINED</name>
--<value>134</value>
--<desc></desc>
--</constant>

  ERROR_EXCL_SEM_ALREADY_OWNED                              =   101,  -- (#0065)
  -- The exclusive semaphore is owned by another process.

  ERROR_SEM_IS_SET                                          =   102,  -- (#0066)
  -- The semaphore is set and cannot be closed.

  ERROR_TOO_MANY_SEM_REQUESTS                               =   103,  -- (#0067)
  -- The semaphore cannot be set again.

  ERROR_INVALID_AT_INTERRUPT_TIME                           =   104,  -- (#0068)
  -- Cannot request exclusive semaphores at interrupt time.

  ERROR_SEM_OWNER_DIED                                      =   105,  -- (#0069)
  -- The previous ownership of this semaphore has ended.

  ERROR_SEM_USER_LIMIT                                      =   106,  -- (#006A)
  -- Insert the diskette for drive %1.

  ERROR_DISK_CHANGE                                         =   107,  -- (#006B)
  -- The program stopped because an alternate diskette was not inserted.

  ERROR_DRIVE_LOCKED                                        =   108,  -- (#006C)
  -- The disk is in use or locked by another process.

  ERROR_BROKEN_PIPE                                         =   109,  -- (#006D)
  -- The pipe has been ended.

  ERROR_OPEN_FAILED                                         =   110,  -- (#006E)
  -- The system cannot open the device or file specified.

  ERROR_BUFFER_OVERFLOW                                     =   111,  -- (#006F)
  -- The file name is too long.

  ERROR_DISK_FULL                                           =   112,  -- (#0070)
  -- There is not enough space on the disk.

  ERROR_NO_MORE_SEARCH_HANDLES                              =   113,  -- (#0071)
  -- No more internal file identifiers available.

  ERROR_INVALID_TARGET_HANDLE                               =   114,  -- (#0072)
  -- The target internal file identifier is incorrect.

  ERROR_INVALID_CATEGORY                                    =   117,  -- (#0075)
  -- The IOCTL call made by the application program is not correct.

  ERROR_INVALID_VERIFY_SWITCH                               =   118,  -- (#0076)
  -- The verify-on-write switch parameter value is not correct.

  ERROR_BAD_DRIVER_LEVEL                                    =   119,  -- (#0077)
  -- The system does not support the command requested.

  ERROR_CALL_NOT_IMPLEMENTED                                =   120,  -- (#0078)
  -- This function is not supported on this system.

  ERROR_SEM_TIMEOUT                                         =   121,  -- (#0079)
  -- The semaphore timeout period has expired.

  ERROR_INSUFFICIENT_BUFFER                                 =   122,  -- (#007A)
  -- The data area passed to a system call is too small.

  ERROR_INVALID_NAME                                        =   123,  -- (#007B)
  -- The filename, directory name, or volume label syntax is incorrect.

  ERROR_INVALID_LEVEL                                       =   124,  -- (#007C)
  -- The system call level is not correct.

  ERROR_NO_VOLUME_LABEL                                     =   125,  -- (#007D)
  -- The disk has no volume label.

  ERROR_MOD_NOT_FOUND                                       =   126,  -- (#007E)
  -- The specified module could not be found.

  ERROR_PROC_NOT_FOUND                                      =   127,  -- (#007F)
  -- The specified procedure could not be found.

  ERROR_WAIT_NO_CHILDREN                                    =   128,  -- (#0080)
  -- There are no child processes to wait for.

  ERROR_CHILD_NOT_COMPLETE                                  =   129,  -- (#0081)
  -- The %1 application cannot be run in Win32 mode.

  ERROR_DIRECT_ACCESS_HANDLE                                =   130,  -- (#0082)
  -- Attempt to use a file handle to an open disk partition for an operation
  -- other than raw disk I/O.

  ERROR_NEGATIVE_SEEK                                       =   131,  -- (#0083)
  -- An attempt was made to move the file pointer before the beginning of the
  -- file.

  ERROR_SEEK_ON_DEVICE                                      =   132,  -- (#0084)
  -- The file pointer cannot be set on the specified device or file.

  ERROR_IS_JOIN_TARGET                                      =   133,  -- (#0085)
  -- A JOIN or SUBST command cannot be used for a drive that contains previously
  -- joined drives.

  ERROR_IS_JOINED                                           =   134,  -- (#0086)
  -- An attempt was made to use a JOIN or SUBST command on a drive that has
  -- already been joined.

  ERROR_IS_SUBSTED                                          =   135,  -- (#0087)
--<constant>
--<name>ERROR_IS_SUBSTED</name>
--<value>135</value>
--<desc>
-- An attempt was made to use a JOIN or SUBST command on a drive that has
-- already been substituted.
--</desc>
--</constant>

  ERROR_NOT_JOINED                                          =   136,  -- (#0088)
--<constant>
--<name>ERROR_NOT_JOINED</name>
--<value>136</value>
--<desc>The system tried to delete the JOIN of a drive that is not joined.</desc>
--</constant>

  ERROR_NOT_SUBSTED                                         =   137,  -- (#0089)
--<constant>
--<name>ERROR_NOT_SUBSTED</name>
--<value>137</value>
--<desc>
-- The system tried to delete the substitution of a drive that is not
-- substituted.
--</desc>
--</constant>

  ERROR_JOIN_TO_JOIN                                        =   138,  -- (#008A)
--<constant>
--<name>ERROR_JOIN_TO_JOIN</name>
--<value>138</value>
--<desc>The system tried to join a drive to a directory on a joined drive.</desc>
--</constant>

  ERROR_SUBST_TO_SUBST                                      =   139,  -- (#008B)
--<constant>
--<name>ERROR_SUBST_TO_SUBST</name>
--<value>139</value>
--<desc>
  -- The system tried to substitute a drive to a directory on a substituted
  -- drive.
--</desc>
--</constant>

  ERROR_JOIN_TO_SUBST                                       =   140,  -- (#008C)
  -- The system tried to join a drive to a directory on a substituted drive.

  ERROR_SUBST_TO_JOIN                                       =   141,  -- (#008D)
  -- The system tried to SUBST a drive to a directory on a joined drive.

  ERROR_BUSY_DRIVE                                          =   142,  -- (#008E)
  -- The system cannot perform a JOIN or SUBST at this time.

  ERROR_SAME_DRIVE                                          =   143,  -- (#008F)
  -- The system cannot join or substitute a drive to or for a directory on the
  -- same drive.

  ERROR_DIR_NOT_ROOT                                        =   144,  -- (#0090)
  -- The directory is not a subdirectory of the root directory.

  ERROR_DIR_NOT_EMPTY                                       =   145,  -- (#0091)
  -- The directory is not empty.

  ERROR_IS_SUBST_PATH                                       =   146,  -- (#0092)
  -- The path specified is being used in a substitute.

  ERROR_IS_JOIN_PATH                                        =   147,  -- (#0093)
  -- Not enough resources are available to process this command.

  ERROR_PATH_BUSY                                           =   148,  -- (#0094)
  -- The path specified cannot be used at this time.

  ERROR_IS_SUBST_TARGET                                     =   149,  -- (#0095)
  -- An attempt was made to join or substitute a drive for which a directory
  -- on the drive is the target of a previous substitute.

  ERROR_SYSTEM_TRACE                                        =   150,  -- (#0096)
  -- System trace information was not specified in your CONFIG.SYS file, or
  -- tracing is disallowed.

  ERROR_INVALID_EVENT_COUNT                                 =   151,  -- (#0097)
  -- The number of specified semaphore events for DosMuxSemWait is not correct.

  ERROR_TOO_MANY_MUXWAITERS                                 =   152,  -- (#0098)
  -- DosMuxSemWait did not execute; too many semaphores are already set.

  ERROR_INVALID_LIST_FORMAT                                 =   153,  -- (#0099)
  -- The DosMuxSemWait list is not correct.

  ERROR_LABEL_TOO_LONG                                      =   154,  -- (#009A)
  -- The volume label you entered exceeds the label character limit of the
  -- target file system.

  ERROR_TOO_MANY_TCBS                                       =   155,  -- (#009B)
  -- Cannot create another thread.

  ERROR_SIGNAL_REFUSED                                      =   156,  -- (#009C)
  -- The recipient process has refused the signal.

  ERROR_DISCARDED                                           =   157,  -- (#009D)
  -- The segment is already discarded and cannot be locked.

  ERROR_NOT_LOCKED                                          =   158,  -- (#009E)
  -- The segment is already unlocked.

  ERROR_BAD_THREADID_ADDR                                   =   159,  -- (#009F)
  -- The address for the thread ID is not correct.

  ERROR_BAD_ARGUMENTS                                       =   160,  -- (#00A0)
  -- The argument string passed to DosExecPgm is not correct.

  ERROR_BAD_PATHNAME                                        =   161,  -- (#00A1)
  -- The specified path is invalid.

  ERROR_SIGNAL_PENDING                                      =   162,  -- (#00A2)
  -- A signal is already pending.

  ERROR_MAX_THRDS_REACHED                                   =   164,  -- (#00A4)
  -- No more threads can be created in the system.

  ERROR_LOCK_FAILED                                         =   167,  -- (#00A7)
  -- Unable to lock a region of a file.

  ERROR_BUSY                                                =   170,  -- (#00AA)
  -- The requested resource is in use.

  ERROR_CANCEL_VIOLATION                                    =   173,  -- (#00AD)
  -- A lock request was not outstanding for the supplied cancel region.

  ERROR_ATOMIC_LOCKS_NOT_SUPPORTED                          =   174,  -- (#00AE)
  -- The file system does not support atomic changes to the lock type.

  ERROR_INVALID_SEGMENT_NUMBER                              =   180,  -- (#00B4)
  -- The system detected a segment number that was not correct.

  ERROR_INVALID_ORDINAL                                     =   182,  -- (#00B6)
  -- The operating system cannot run %1.

  ERROR_ALREADY_EXISTS                                      =   183,  -- (#00B7)
  -- Cannot create a file when that file already exists.

  ERROR_INVALID_FLAG_NUMBER                                 =   186,  -- (#00BA)
  -- The flag passed is not correct.

  ERROR_SEM_NOT_FOUND                                       =   187,  -- (#00BB)
  -- The specified system semaphore name was not found.

  ERROR_INVALID_STARTING_CODESEG                            =   188,  -- (#00BC)
  -- The operating system cannot run %1.

  ERROR_INVALID_STACKSEG                                    =   189,  -- (#00BD)
  -- The operating system cannot run %1.

  ERROR_INVALID_MODULETYPE                                  =   190,  -- (#00BE)
  -- The operating system cannot run %1.

  ERROR_INVALID_EXE_SIGNATURE                               =   191,  -- (#00BF)
  -- Cannot run %1 in Win32 mode.

  ERROR_EXE_MARKED_INVALID                                  =   192,  -- (#00C0)
  -- The operating system cannot run %1.

  ERROR_BAD_EXE_FORMAT                                      =   193,  -- (#00C1)
  -- %1 is not a valid Win32 application.

  ERROR_ITERATED_DATA_EXCEEDS_64k                           =   194,  -- (#00C2)
  -- The operating system cannot run %1.

  ERROR_INVALID_MINALLOCSIZE                                =   195,  -- (#00C3)
  -- The operating system cannot run %1.

  ERROR_DYNLINK_FROM_INVALID_RING                           =   196,  -- (#00C4)
  -- The operating system cannot run this application program.

  ERROR_IOPL_NOT_ENABLED                                    =   197,  -- (#00C5)
  -- The operating system is not presently configured to run this application.

  ERROR_INVALID_SEGDPL                                      =   198,  -- (#00C6)
  -- The operating system cannot run %1.

  ERROR_AUTODATASEG_EXCEEDS_64k                             =   199,  -- (#00C7)
  -- The operating system cannot run this application program.

  ERROR_RING2SEG_MUST_BE_MOVABLE                              = 200,  -- (#00C8)
  -- The code segment cannot be greater than or equal to 64K.

  ERROR_RELOC_CHAIN_XEEDS_SEGLIM                            =   201,  -- (#00C9)
  -- The operating system cannot run %1.

  ERROR_INFLOOP_IN_RELOC_CHAIN                              =   202,  -- (#00CA)
  -- The operating system cannot run %1.

  ERROR_ENVVAR_NOT_FOUND                                    =   203,  -- (#00CB)
  -- The system could not find the environment option that was entered.

  ERROR_NO_SIGNAL_SENT                                      =   205,  -- (#00CD)
  -- No process in the command subtree has a signal handler.

  ERROR_FILENAME_EXCED_RANGE                                =   206,  -- (#00CE)
  -- The filename or extension is too long.

  ERROR_RING2_STACK_IN_USE                                  =   207,  -- (#00CF)
  -- The ring 2 stack is in use.

  ERROR_META_EXPANSION_TOO_LONG                             =   208,  -- (#00D0)
  -- The public filename characters, * or ?, are entered incorrectly or too many
  -- public filename characters are specified.

  ERROR_INVALID_SIGNAL_NUMBER                               =   209,  -- (#00D1)
  -- The signal being posted is not correct.

  ERROR_THREAD_1_INACTIVE                                   =   210,  -- (#00D2)
  -- The signal handler cannot be set.

  ERROR_LOCKED                                              =   212,  -- (#00D4)
  -- The segment is locked and cannot be reallocated.

  ERROR_TOO_MANY_MODULES                                    =   214,  -- (#00D6)
  -- Too many dynamic-link modules are attached to this program or dynamic-link
  -- module.

  ERROR_NESTING_NOT_ALLOWED                                 =   215,  -- (#00D7)
  -- Cannot nest calls to LoadModule.

  ERROR_EXE_MACHINE_TYPE_MISMATCH                           =   216,  -- (#00D8)
  -- The image file %1 is valid, but is for a machine type other than the
  -- current machine.

  ERROR_EXE_CANNOT_MODIFY_SIGNED_BINARY                     =   217,  -- (#00D9)
  -- The image file %1 is signed, unable to modify.

  ERROR_EXE_CANNOT_MODIFY_STRONG_SIGNED_BINARY              =   218,  -- (#00DA)
  -- The image file %1 is strong signed, unable to modify.

  ERROR_FILE_CHECKED_OUT                                    =   220,  -- (#00DC)
  -- This file is checked out or locked for editing by another user.

  ERROR_CHECKOUT_REQUIRED                                   =   221,  -- (#00DD)
  -- The file must be checked out before saving changes.

  ERROR_BAD_FILE_TYPE                                       =   222,  -- (#00DE)
  -- The file type being saved or retrieved has been blocked.

  ERROR_FILE_TOO_LARGE                                      =   223,  -- (#00DF)
  -- The file size exceeds the limit allowed and cannot be saved.

  ERROR_FORMS_AUTH_REQUIRED                                 =   224,  -- (#00E0)
  -- Access Denied. Before opening files in this location, you must first add
  -- the web site to your trusted sites list, browse to the web site, and select
  -- the option to login automatically.

  ERROR_VIRUS_INFECTED                                      =   225,  -- (#00E1)
  -- Operation did not complete successfully because the file contains a virus.

  ERROR_VIRUS_DELETED                                       =   226,  -- (#00E2)
  -- This file contains a virus and cannot be opened. Due to the nature of this
  -- virus, the file has been removed from this location.

  ERROR_PIPE_LOCAL                                          =   229,  -- (#00E5)
  -- The pipe state is invalid.

  ERROR_BAD_PIPE                                            =   230,  -- (#00E6)
  -- The pipe state is invalid.

  ERROR_PIPE_BUSY                                           =   231,  -- (#00E7)
  -- All pipe instances are busy.

  ERROR_NO_DATA                                             =   232,  -- (#00E8)
  -- The pipe is being closed.

  ERROR_PIPE_NOT_CONNECTED                                  =   233,  -- (#00E9)
  -- No process is on the other end of the pipe.

  ERROR_MORE_DATA                                           =   234,  -- (#00EA)
  -- More data is available.

  ERROR_VC_DISCONNECTED                                     =   240,  -- (#00F0)
  -- The session was canceled.

  ERROR_INVALID_EA_NAME                                     =   254,  -- (#00FE)
  -- The specified extended attribute name was invalid.

  ERROR_EA_LIST_INCONSISTENT                                =   255,  -- (#00FF)
  -- The extended attributes are inconsistent.

  ERROR_WAIT_TIMEOUT                                        =   258,  -- (#0102)
  -- The wait operation timed out.

  ERROR_NO_MORE_ITEMS                                       =   259,  -- (#0103)
  -- No more data is available.

  ERROR_CANNOT_COPY                                         =   266,  -- (#010A)
  -- The copy functions cannot be used.

  ERROR_DIRECTORY                                           =   267,  -- (#010B)
  -- The directory name is invalid.

  ERROR_EAS_DIDNT_FIT                                       =   275,  -- (#0113)
  -- The extended attributes did not fit in the buffer.

  ERROR_EA_FILE_CORRUPT                                     =   276,  -- (#0114)
  -- The extended attribute file on the mounted file system is corrupt.

  ERROR_EA_TABLE_FULL                                       =   277,  -- (#0115)
  -- The extended attribute table file is full.

  ERROR_INVALID_EA_HANDLE                                   =   278,  -- (#0116)
  -- The specified extended attribute handle is invalid.

  ERROR_EAS_NOT_SUPPORTED                                   =   282,  -- (#011A)
  -- The mounted file system does not support extended attributes.

  ERROR_NOT_OWNER                                           =   288,  -- (#0120)
  -- Attempt to release mutex not owned by caller.

  ERROR_TOO_MANY_POSTS                                      =   298,  -- (#012A)
  -- Too many posts were made to a semaphore.

  ERROR_PARTIAL_COPY                                        =   299,  -- (#012B)
  -- Only part of a ReadProcessMemory or WriteProcessMemory request was
  -- completed.

  ERROR_OPLOCK_NOT_GRANTED                                  =   300,  -- (#012C)
  -- The oplock request is denied.

  ERROR_INVALID_OPLOCK_PROTOCOL                             =   301,  -- (#012D)
  -- An invalid oplock acknowledgment was received by the system.

  ERROR_DISK_TOO_FRAGMENTED                                 =   302,  -- (#012E)
  -- The volume is too fragmented to complete this operation.

  ERROR_DELETE_PENDING                                      =   303,  -- (#012F)
  -- The file cannot be opened because it is in the process of being deleted.

  ERROR_INCOMPATIBLE_WITH_GLOBAL_SHORT_NAME_REGISTRY_SETTING=   304,  -- (#0130)
  -- Short name settings may not be changed on this volume due to the public
  -- registry setting.

  ERROR_SHORT_NAMES_NOT_ENABLED_ON_VOLUME                   =   305,  -- (#0131)
  -- Short names are not enabled on this volume.

  ERROR_SECURITY_STREAM_IS_INCONSISTENT                     =   306,  -- (#0132)
  -- The security stream for the given volume is in an inconsistent state.

  ERROR_INVALID_LOCK_RANGE                                  =   307,  -- (#0133)
  -- A requested file lock operation cannot be processed due to an invalid byte
  -- range.

  ERROR_IMAGE_SUBSYSTEM_NOT_PRESENT                         =   308,  -- (#0134)
  -- The subsystem needed to support the image type is not present.

  ERROR_NOTIFICATION_GUID_ALREADY_DEFINED                   =   309,  -- (#0135)
  -- The specified file already has a notification GUID associated with it.

  ERROR_MR_MID_NOT_FOUND                                    =   317,  -- (#013D)
  -- The system cannot find message text for message number 0x%1 in the message
  -- file for %2.

  ERROR_SCOPE_NOT_FOUND                                     =   318,  -- (#013E)
  -- The scope specified was not found.

  ERROR_FAIL_NOACTION_REBOOT                                =   350,  -- (#015E)
  -- No action was taken as a system reboot is required.

  ERROR_FAIL_SHUTDOWN                                       =   351,  -- (#015F)
  -- The shutdown operation failed.

  ERROR_FAIL_RESTART                                        =   352,  -- (#0160)
  -- The restart operation failed.

  ERROR_MAX_SESSIONS_REACHED                                =   353,  -- (#0161)
  -- The maximum number of sessions has been reached.

  ERROR_THREAD_MODE_ALREADY_BACKGROUND                      =   400,  -- (#0190)
  -- The thread is already in background processing mode.

  ERROR_THREAD_MODE_NOT_BACKGROUND                            = 401,  -- (#0191)
  -- The thread is not in background processing mode.

  ERROR_PROCESS_MODE_ALREADY_BACKGROUND                     =   402,  -- (#0192)
  -- The process is already in background processing mode.

  ERROR_PROCESS_MODE_NOT_BACKGROUND                         =   403,  -- (#0193)
  -- The process is not in background processing mode.

  ERROR_INVALID_ADDRESS                                     =   487,  -- (#01E7)
  -- Attempt to access invalid address.

  ERROR_USER_PROFILE_LOAD                                   =   500,  -- (#01F4)
  -- User profile cannot be loaded.

  ERROR_ARITHMETIC_OVERFLOW                                 =   534,  -- (#0216)
  -- Arithmetic result exceeded 32 bits.

  ERROR_PIPE_CONNECTED                                      =   535,  -- (#0217)
  -- There is a process on other end of the pipe.

  ERROR_PIPE_LISTENING                                      =   536,  -- (#0218)
  -- Waiting for a process to open the other end of the pipe.

  ERROR_VERIFIER_STOP                                       =   537,  -- (#0219)
  -- Application verifier has found an error in the current process.

  ERROR_ABIOS_ERROR                                         =   538,  -- (#021A)
  -- An error occurred in the ABIOS subsystem.

  ERROR_WX86_WARNING                                        =   539,  -- (#021B)
  -- A warning occurred in the WX86 subsystem.

  ERROR_WX86_ERROR                                          =   540,  -- (#021C)
  -- An error occurred in the WX86 subsystem.

  ERROR_TIMER_NOT_CANCELED                                  =   541,  -- (#021D)
  -- An attempt was made to cancel or set a timer that has an associated APC and
  -- the subject thread is not the thread that originally set the timer with an
  -- associated APC routine.

  ERROR_UNWIND                                              =   542,  -- (#021E)
  -- Unwind exception code.

  ERROR_BAD_STACK                                           =   543,  -- (#021F)
  -- An invalid or unaligned stack was encountered during an unwind operation.

  ERROR_INVALID_UNWIND_TARGET                               =   544,  -- (#0220)
  -- An invalid unwind target was encountered during an unwind operation.

  ERROR_INVALID_PORT_ATTRIBUTES                             =   545,  -- (#0221)
  -- Invalid Object Attributes specified to NtCreatePort or invalid Port
  -- Attributes specified to NtConnectPort.

  ERROR_PORT_MESSAGE_TOO_LONG                               =   546,  -- (#0222)
  -- Length of message passed to NtRequestPort or NtRequestWaitReplyPort was
  -- longer than the maximum message allowed by the port.

  ERROR_INVALID_QUOTA_LOWER                                 =   547,  -- (#0223)
  -- An attempt was made to lower a quota limit below the current usage.

  ERROR_DEVICE_ALREADY_ATTACHED                             =   548,  -- (#0224)
  -- An attempt was made to attach to a device that was already attached to
  -- another device.

  ERROR_INSTRUCTION_MISALIGNMENT                            =   549,  -- (#0225)
  -- An attempt was made to execute an instruction at an unaligned address and
  -- the host system does not support unaligned instruction references.

  ERROR_PROFILING_NOT_STARTED                               =   550,  -- (#0226)
  -- Profiling not started.

  ERROR_PROFILING_NOT_STOPPED                               =   551,  -- (#0227)
  -- Profiling not stopped.

  ERROR_COULD_NOT_INTERPRET                                 =   552,  -- (#0228)
  -- The passed ACL did not contain the minimum required information.

  ERROR_PROFILING_AT_LIMIT                                  =   553,  -- (#0229)
  -- The number of active profiling objects is at the maximum and no more may be
  -- started.

  ERROR_CANT_WAIT                                           =   554,  -- (#022A)
  -- Used to indicate that an operation cannot continue without blocking for
  -- I/O.

  ERROR_CANT_TERMINATE_SELF                                 =   555,  -- (#022B)
  -- Indicates that a thread attempted to terminate itself by default (called
  -- NtTerminateThread with NULL) and it was the last thread in the current
  -- process.

  ERROR_UNEXPECTED_MM_CREATE_ERR                            =   556,  -- (#022C)
  -- If an MM error is returned which is not defined in the standard FsRtl
  -- filter, it is converted to one of the following errors which is guaranteed
  -- to be in the filter. In this case information is lost, however, the filter
  -- correctly handles the exception.

  ERROR_UNEXPECTED_MM_MAP_ERROR                             =   557,  -- (#022D)
  -- If an MM error is returned which is not defined in the standard FsRtl
  -- filter, it is converted to one of the following errors which is guaranteed
  -- to be in the filter. In this case information is lost, however, the filter
  -- correctly handles the exception.

  ERROR_UNEXPECTED_MM_EXTEND_ERR                            =   558,  -- (#022E)
  -- If an MM error is returned which is not defined in the standard FsRtl
  -- filter, it is converted to one of the following errors which is guaranteed
  -- to be in the filter. In this case information is lost, however, the filter
  -- correctly handles the exception.

  ERROR_BAD_FUNCTION_TABLE                                  =   559,  -- (#022F)
  -- A malformed function table was encountered during an unwind operation.

  ERROR_NO_GUID_TRANSLATION                                 =   560,  -- (#0230)
  -- Indicates that an attempt was made to assign protection to a file system
  -- file or directory and one of the SIDs in the security descriptor could not
  -- be translated into a GUID that could be stored by the file system. This
  -- causes the protection attempt to fail, which may cause a file creation
  -- attempt to fail.

  ERROR_INVALID_LDT_SIZE                                    =   561,  -- (#0231)
  -- Indicates that an attempt was made to grow an LDT by setting its size, or
  -- that the size was not an even number of selectors.

  ERROR_INVALID_LDT_OFFSET                                  =   563,  -- (#0233)
  -- Indicates that the starting value for the LDT information was not an
  -- integral multiple of the selector size.

  ERROR_INVALID_LDT_DESCRIPTOR                              =   564,  -- (#0234)
  -- Indicates that the user supplied an invalid descriptor when trying to set
  -- up Ldt descriptors.

  ERROR_TOO_MANY_THREADS                                    =   565,  -- (#0235)
  -- Indicates a process has too many threads to perform the requested action.
  -- For example, assignment of a primary token may only be performed when a
  -- process has zero or one threads.

  ERROR_THREAD_NOT_IN_PROCESS                               =   566,  -- (#0236)
  -- An attempt was made to operate on a thread within a specific process, but
  -- the thread specified is not in the process specified.

  ERROR_PAGEFILE_QUOTA_EXCEEDED                             =   567,  -- (#0237)
  -- Page file quota was exceeded.

  ERROR_LOGON_SERVER_CONFLICT                               =   568,  -- (#0238)
  -- The Netlogon service cannot start because another Netlogon service running
  -- in the domain conflicts with the specified role.

  ERROR_SYNCHRONIZATION_REQUIRED                            =   569,  -- (#0239)
  -- The SAM database on a Windows Server is significantly out of
  -- synchronization with the copy on the Domain Controller. A complete
  -- synchronization is required.

  ERROR_NET_OPEN_FAILED                                     =   570,  -- (#023A)
  -- The NtCreateFile API failed. This error should never be returned to an
  -- application, it is a place holder for the Windows Lan Manager Redirector
  -- to use in its internal error mapping routines.

  ERROR_IO_PRIVILEGE_FAILED                                 =   571,  -- (#023B)
  -- {Privilege Failed} The I/O permissions for the process could not be
  -- changed.

  ERROR_CONTROL_C_EXIT                                      =   572,  -- (#023C)
  -- {Application Exit by CTRL+C} The application terminated as a result of a
  -- CTRL+C.

  ERROR_MISSING_SYSTEMFILE                                  =   573,  -- (#023D)
  -- {Missing System File} The required system file %hs is bad or missing.

  ERROR_UNHANDLED_EXCEPTION                                 =   574,  -- (#023E)
  -- {Application Error} The exception %s (0x%08lx) occurred in the application
  -- at location 0x%08lx.

  ERROR_APP_INIT_FAILURE                                    =   575,  -- (#023F)
  -- {Application Error} The application failed to initialize properly (0x%lx).
  -- Click OK to terminate the application.

  ERROR_PAGEFILE_CREATE_FAILED                              =   576,  -- (#0240)
  -- {Unable to Create Paging File} The creation of the paging file %hs failed
  -- (%lx). The requested size was %ld.

  ERROR_INVALID_IMAGE_HASH                                  =   577,  -- (#0241)
  -- Windows cannot verify the digital signature for this file. A recent
  -- hardware or software change might have installed a file that is signed
  -- incorrectly or damaged, or that might be malicious software from an
  -- unknown source.

  ERROR_NO_PAGEFILE                                         =   578,  -- (#0242)
  -- {No Paging File Specified} No paging file was specified in the system
  -- configuration.

  ERROR_ILLEGAL_FLOAT_CONTEXT                               =   579,  -- (#0243)
  -- {EXCEPTION} A real-mode application issued a floating-point instructiont
  -- and floating-poin hardware is not present.

  ERROR_NO_EVENT_PAIR                                       =   580,  -- (#0244)
  -- An event pair synchronization operation was performed using the thread
  -- specific client/server event pair object, but no event pair object was
  -- associated with the thread.

  ERROR_DOMAIN_CTRLR_CONFIG_ERROR                           =   581,  -- (#0245)
  -- A Windows Server has an incorrect configuration.

  ERROR_ILLEGAL_CHARACTER                                   =   582,  -- (#0246)
  -- An illegal character was encountered. For a multi-byte character set this
  -- includes a lead byte without a succeeding trail byte. For the Unicode
  -- character set this includes the characters 0xFFFF and 0xFFFE.

  ERROR_UNDEFINED_CHARACTER                                 =   583,  -- (#0247)
  -- The Unicode character is not defined in the Unicode character set installed
  -- on the system.

  ERROR_FLOPPY_VOLUME                                       =   584,  -- (#0248)
  -- The paging file cannot be created on a floppy diskette.

  ERROR_BIOS_FAILED_TO_CONNECT_INTERRUPT                    =   585,  -- (#0249)
  -- The system BIOS failed to connect a system interrupt to the device or bus
  -- for which the device is connected.

  ERROR_BACKUP_CONTROLLER                                   =   586,  -- (#024A)
  -- This operation is only allowed for the Primary Domain Controller of the
  -- domain.

  ERROR_MUTANT_LIMIT_EXCEEDED                               =   587,  -- (#024B)
  -- An attempt was made to acquire a mutant such that its maximum count would
  -- have been exceeded.

  ERROR_FS_DRIVER_REQUIRED                                  =   588,  -- (#024C)
  -- A volume has been accessed for which a file system driver is required that
  -- has not yet been loaded.

  ERROR_CANNOT_LOAD_REGISTRY_FILE                           =   589,  -- (#024D)
  -- {Registry File Failure}   The registry cannot load the hive (file): %hs or
  -- its log or alternate. It is corrupt, absent, or not writable.

  ERROR_DEBUG_ATTACH_FAILED                                 =   590,  -- (#024E)
  -- {Unexpected Failure in DebugActiveProcess} An unexpected failure occurred
  -- while processing a DebugActiveProcess API request. You may choose OK to
  -- terminate the process, or Cancel to ignore the error.

  ERROR_SYSTEM_PROCESS_TERMINATED                           =   591,  -- (#024F)
  -- {Fatal System Error} The %hs system process terminated unexpectedly with a
  -- status of 0x%08x (0x%08x 0x%08x). The system has been shut down.

  ERROR_DATA_NOT_ACCEPTED                                   =   592,  -- (#0250)
  -- {Data Not Accepted} The TDI client could not handle the data received
  -- during an indication.

  ERROR_VDM_HARD_ERROR                                      =   593,  -- (#0251)
  -- NTVDM encountered a hard error.

  ERROR_DRIVER_CANCEL_TIMEOUT                               =   594,  -- (#0252)
  -- {Cancel Timeout} The driver %hs failed to complete a cancelled I/O request
  -- in the allotted time.

  ERROR_REPLY_MESSAGE_MISMATCH                              =   595,  -- (#0253)
  -- {Reply Message Mismatch} An attempt was made to reply to an LPC message,
  -- but the thread specified by the client ID in the message was not waiting on that message.

  ERROR_LOST_WRITEBEHIND_DATA                               =   596,  -- (#0254)
  -- {Delayed Write Failed} Windows was unable to save all the data for the file
  -- %hs. The data has been lost. This error may be caused by a failure of your
  -- computer hardware or network connection. Please try to save this file
  -- elsewhere.

  ERROR_CLIENT_SERVER_PARAMETERS_INVALID                    =   597,  -- (#0255)
  -- The parameter(s) passed to the server in the client/server shared memory
  -- window were invalid. Too much data may have been put in the shared memory
  -- window.

  ERROR_NOT_TINY_STREAM                                     =   598,  -- (#0256)
  -- The stream is not a tiny stream.

  ERROR_STACK_OVERFLOW_READ                                 =   599,  -- (#0257)
  -- The request must be handled by the stack overflow code.

  ERROR_CONVERT_TO_LARGE                                    =   600,  -- (#0258)
  -- Internal OFS status codes indicating how an allocation operation is
  -- handled. Either it is retried after the containing onode is moved or the
  -- extent stream is converted to a large stream.

  ERROR_FOUND_OUT_OF_SCOPE                                  =   601,  -- (#0259)
  -- The attempt to find the object found an object matching by ID on the volume
  -- but it is out of the scope of the handle used for the operation.

  ERROR_ALLOCATE_BUCKET                                     =   602,  -- (#025A)
  -- The bucket array must be grown. Retry transaction after doing so.

  ERROR_MARSHALL_OVERFLOW                                   =   603,  -- (#025B)
  -- The user/kernel marshalling buffer has overflowed.

  ERROR_INVALID_VARIANT                                     =   604,  -- (#025C)
  -- The supplied variant structure contains invalid data.

  ERROR_BAD_COMPRESSION_BUFFER                              =   605,  -- (#025D)
  -- The specified buffer contains ill-formed data.

  ERROR_AUDIT_FAILED                                        =   606,  -- (#025E)
  -- {Audit Failed} An attempt to generate a security audit failed.

  ERROR_TIMER_RESOLUTION_NOT_SET                            =   607,  -- (#025F)
  -- The timer resolution was not previously set by the current process.

  ERROR_INSUFFICIENT_LOGON_INFO                             =   608,  -- (#0260)
  -- There is insufficient account information to log you on.

  ERROR_BAD_DLL_ENTRYPOINT                                  =   609,  -- (#0261)
  -- {Invalid DLL Entrypoint} The dynamic link library %hs is not written
  -- correctly. The stack pointer has been left in an inconsistent state. The
  -- entrypoint should be declared as WINAPI or STDCALL. Select YES to fail the
  -- DLL load. Select NO to continue execution. Selecting NO may cause the
  -- application to operate incorrectly.

  ERROR_BAD_SERVICE_ENTRYPOINT                              =   610,  -- (#0262)
  -- {Invalid Service Callback Entrypoint} The %hs service is not written
  -- correctly. The stack pointer has been left in an inconsistent state. The
  -- callback entrypoint should be declared as WINAPI or STDCALL. Selecting OK
  -- will cause the service to continue operation. However, the service process
  -- may operate incorrectly.

  ERROR_IP_ADDRESS_CONFLICT1                                =   611,  -- (#0263)
  -- There is an IP address conflict with another system on the network

  ERROR_IP_ADDRESS_CONFLICT2                                =   612,  -- (#0264)
  -- There is an IP address conflict with another system on the network

  ERROR_REGISTRY_QUOTA_LIMIT                                =   613,  -- (#0265)
  -- {Low On Registry Space} The system has reached the maximum size allowed for the system part of
  -- the registry. Additional storage requests will be ignored.

  ERROR_NO_CALLBACK_ACTIVE                                  =   614,  -- (#0266)
  -- A callback return system service cannot be executed when no callback is
  -- active.

  ERROR_PWD_TOO_SHORT                                       =   615,  -- (#0267)
  -- The password provided is too short to meet the policy of your user account.
  -- Please choose a longer password.

  ERROR_PWD_TOO_RECENT                                      =   616,  -- (#0268)
  -- The policy of your user account does not allow you to change passwords too
  -- frequently. This is done to prevent users from changing back to a familiar,
  -- but potentially discovered, password. If you feel your password has been
  -- compromised then please contact your administrator immediately to have a
  -- new one assigned.

  ERROR_PWD_HISTORY_CONFLICT                                =   617,  -- (#0269)
  -- You have attempted to change your password to one that you have used in the
  -- past. The policy of your user account does not allow this. Please selecty
  -- a password that you have not previousl used.

  ERROR_UNSUPPORTED_COMPRESSION                             =   618,  -- (#026A)
  -- The specified compression format is unsupported.

  ERROR_INVALID_HW_PROFILE                                  =   619,  -- (#026B)
  -- The specified hardware profile configuration is invalid.

  ERROR_INVALID_PLUGPLAY_DEVICE_PATH                        =   620,  -- (#026C)
  -- The specified Plug and Play registry device path is invalid.

  ERROR_QUOTA_LIST_INCONSISTENT                             =   621,  -- (#026D)
  -- The specified quota list is internally inconsistent with its descriptor.

  ERROR_EVALUATION_EXPIRATION                               =   622,  -- (#026E)
  -- {Windows Evaluation Notification}   The evaluation period for this
  -- installation of Windows has expired. This system will shutdown in 1 hour.
  -- To restore access to this installation of Windows, please upgrade this
  -- installation using a licensed distribution of this product.

  ERROR_ILLEGAL_DLL_RELOCATION                              =   623,  -- (#026F)
  -- {Illegal System DLL Relocation} The system DLL %hs was relocated in memory.
  -- The application will not run properly. The relocation occurred because the
  -- DLL %hs occupied an address range reserved for Windows system DLLs. The
  -- vendor supplying the DLL should be contacted for a new DLL.

  ERROR_DLL_INIT_FAILED_LOGOFF                              =   624,  -- (#0270)
  -- {DLL Initialization Failed} The application failed to initialize because
  -- the window station is shutting down.

  ERROR_VALIDATE_CONTINUE                                   =   625,  -- (#0271)
  -- The validation process needs to continue on to the next step.

  ERROR_NO_MORE_MATCHES                                     =   626,  -- (#0272)
  -- There are no more matches for the current index enumeration.

  ERROR_RANGE_LIST_CONFLICT                                 =   627,  -- (#0273)
  -- The range could not be added to the range list because of a conflict.

  ERROR_SERVER_SID_MISMATCH                                 =   628,  -- (#0274)
  -- The server process is running under a SID different than that required by
  -- client.

  ERROR_CANT_ENABLE_DENY_ONLY                               =   629,  -- (#0275)
  -- A group marked use for deny only cannot be enabled.

  ERROR_FLOAT_MULTIPLE_FAULTS                               =   630,  -- (#0276)
  -- {EXCEPTION} Multiple floating point faults.

  ERROR_FLOAT_MULTIPLE_TRAPS                                =   631,  -- (#0277)
  -- {EXCEPTION} Multiple floating point traps.

  ERROR_NOINTERFACE                                         =   632,  -- (#0278)
  -- The requested interface is not supported.

  ERROR_DRIVER_FAILED_SLEEP                                 =   633,  -- (#0279)
  -- {System Standby Failed} The driver %hs does not support standby mode.
  -- Updating this driver may allow the system to go to standby mode.

  ERROR_CORRUPT_SYSTEM_FILE                                 =   634,  -- (#027A)
  -- The system file %1 has become corrupt and has been replaced.

  ERROR_COMMITMENT_MINIMUM                                  =   635,  -- (#027B)
  -- {Virtual Memory Minimum Too Low} Your system is low on virtual memory.
  -- Windows is increasing the size of your virtual memory paging file.
  -- During this process, memory requests for some applications may be denied.
  -- For more information, see Help.

  ERROR_PNP_RESTART_ENUMERATION                             =   636,  -- (#027C)
  -- A device was removed so enumeration must be restarted.

  ERROR_SYSTEM_IMAGE_BAD_SIGNATURE                          =   637,  -- (#027D)
  -- {Fatal System Error} The system image %s is not properly signed. The file
  -- has been replaced with the signed file. The system has been shut down.

  ERROR_PNP_REBOOT_REQUIRED                                 =   638,  -- (#027E)
  -- Device will not start without a reboot.

  ERROR_INSUFFICIENT_POWER                                  =   639,  -- (#027F)
  -- There is not enough power to complete the requested operation.

  ERROR_MULTIPLE_FAULT_VIOLATION                            =   640,  -- (#0280)
  -- n/a

  ERROR_SYSTEM_SHUTDOWN                                     =   641,  -- (#0281)
  -- The system is in the process of shutting down.

  ERROR_PORT_NOT_SET                                        =   642,  -- (#0282)
  -- An attempt to remove a processes DebugPort was made, but a port was not
  -- already associated with the process.

  ERROR_DS_VERSION_CHECK_FAILURE                            =   643,  -- (#0283)
  -- This version of Windows is not compatible with the behavior version of
  -- directory forest, domain or domain controller.

  ERROR_RANGE_NOT_FOUND                                     =   644,  -- (#0284)
  -- The specified range could not be found in the range list.

  ERROR_NOT_SAFE_MODE_DRIVER                                =   646,  -- (#0286)
  -- The driver was not loaded because the system is booting into safe mode.

  ERROR_FAILED_DRIVER_ENTRY                                 =   647,  -- (#0287)
  -- The driver was not loaded because it failed it's initialization call.

  ERROR_DEVICE_ENUMERATION_ERROR                            =   648,  -- (#0288)
  -- The "%hs" encountered an error while applying power or reading the device
  -- configuration. This may be caused by a failure of your hardware or by a
  -- poor connection.

  ERROR_MOUNT_POINT_NOT_RESOLVED                            =   649,  -- (#0289)
  -- The create operation failed because the name contained at least one mount
  -- point which resolves to a volume to which the specified device object is
  -- not attached.

  ERROR_INVALID_DEVICE_OBJECT_PARAMETER                     =   650,  -- (#028A)
  -- The device object parameter is either not a valid device object or is not
  -- attached to the volume specified by the file name.

  ERROR_MCA_OCCURED                                         =   651,  -- (#028B)
  -- A Machine Check Error has occurred. Please check the system eventlog for
  -- additional information.

  ERROR_DRIVER_DATABASE_ERROR                               =   652,  -- (#028C)
  -- There was error [%2] processing the driver database.

  ERROR_SYSTEM_HIVE_TOO_LARGE                               =   653,  -- (#028D)
  -- System hive size has exceeded its limit.

  ERROR_DRIVER_FAILED_PRIOR_UNLOAD                          =   654,  -- (#028E)
  -- The driver could not be loaded because a previous version of the driver is
  -- still in memory.

  ERROR_VOLSNAP_PREPARE_HIBERNATE                           =   655,  -- (#028F)
  -- {Volume Shadow Copy Service} Please wait while the Volume Shadow Copy
  -- Service prepares volume %hs for hibernation.

  ERROR_HIBERNATION_FAILURE                                 =   656,  -- (#0290)
  -- The system has failed to hibernate (The error code is %hs). Hibernation
  -- will be disabled until the system is restarted.

  ERROR_FILE_SYSTEM_LIMITATION                              =   665,  -- (#0299)
  -- The requested operation could not be completed due to a file system
  -- limitation.

  ERROR_ASSERTION_FAILURE                                   =   668,  -- (#029C)
  -- An assertion failure has occurred.

  ERROR_ACPI_ERROR                                          =   669,  -- (#029D)
  -- An error occurred in the ACPI subsystem.

  ERROR_WOW_ASSERTION                                       =   670,  -- (#029E)
  -- WOW Assertion Error.

  ERROR_PNP_BAD_MPS_TABLE                                   =   671,  -- (#029F)
  -- A device is missing in the system BIOS MPS table. This device will not be
  -- used. Please contact your system vendor for system BIOS update.

  ERROR_PNP_TRANSLATION_FAILED                              =   672,  -- (#02A0)
  -- A translator failed to translate resources.

  ERROR_PNP_IRQ_TRANSLATION_FAILED                          =   673,  -- (#02A1)
  -- A IRQ translator failed to translate resources.

  ERROR_PNP_INVALID_ID                                      =   674,  -- (#02A2)
  -- Driver %2 returned invalid ID for a child device (%3)
  -- .

  ERROR_WAKE_SYSTEM_DEBUGGER                                =   675,  -- (#02A3)
  -- {Kernel Debugger Awakened} the system debugger was awakened by an
  -- interrupt.

  ERROR_HANDLES_CLOSED                                      =   676,  -- (#02A4)
  -- {Handles Closed} Handles to objects have been automatically closed as a
  -- result of the requested operation.

  ERROR_EXTRANEOUS_INFORMATION                              =   677,  -- (#02A5)
  -- {Too Much Information} The specified access control list (ACL) contained
  -- more information than was expected.

  ERROR_RXACT_COMMIT_NECESSARY                              =   678,  -- (#02A6)
  -- This warning level status indicates that the transaction state already
  -- exists for the registry sub-tree, but that a transaction commit was
  -- previously aborted. The commit has NOT been completed, but has not been
  -- rolled back either (so it may still be committed if desired).

  ERROR_MEDIA_CHECK                                         =   679,  -- (#02A7)
  -- {Media Changed} The media may have changed.

  ERROR_GUID_SUBSTITUTION_MADE                              =   680,  -- (#02A8)
  -- {GUID Substitution} During the translation of a public identifier (GUID)
  -- to a Windows security ID (SID), no administratively-defined GUID prefix was
  -- found. A substitute prefix was used, which will not compromise system
  -- security. However, this may provide a more restrictive access than
  -- intended.

  ERROR_STOPPED_ON_SYMLINK                                  =   681,  -- (#02A9)
  -- The create operation stopped after reaching a symbolic link.

  ERROR_LONGJUMP                                            =   682,  -- (#02AA)
  -- A long jump has been executed.

  ERROR_PLUGPLAY_QUERY_VETOED                               =   683,  -- (#02AB)
  -- The Plug and Play query operation was not successful.

  ERROR_UNWIND_CONSOLIDATE                                  =   684,  -- (#02AC)
  -- A frame consolidation has been executed.

  ERROR_REGISTRY_HIVE_RECOVERED                             =   685,  -- (#02AD)
  -- {Registry Hive Recovered} Registry hive (file): %hs was corrupted and it
  -- has been recovered. Some data might have been lost.

  ERROR_DLL_MIGHT_BE_INSECURE                               =   686,  -- (#02AE)
  -- The application is attempting to run executable code from the module %hs.
  -- This may be insecure. An alternative, %hs, is available. Should the
  -- application use the secure module %hs?

  ERROR_DLL_MIGHT_BE_INCOMPATIBLE                           =   687,  -- (#02AF)
  -- The application is loading executable code from the module %hs. This is
  -- secure, but may be incompatible with previous releases of the operating
  -- system. An alternative, %hs, is available. Should the application use the
  -- secure module %hs?

  ERROR_DBG_EXCEPTION_NOT_HANDLED                           =   688,  -- (#02B0)
  -- Debugger did not handle the exception.

  ERROR_DBG_REPLY_LATER                                     =   689,  -- (#02B1)
  -- Debugger will reply later.

  ERROR_DBG_UNABLE_TO_PROVIDE_HANDLE                        =   690,  -- (#02B2)
  -- Debugger cannot provide handle.

  ERROR_DBG_TERMINATE_THREAD                                =   691,  -- (#02B3)
  -- Debugger terminated thread.

  ERROR_DBG_TERMINATE_PROCESS                               =   692,  -- (#02B4)
  -- Debugger terminated process.

  ERROR_DBG_CONTROL_C                                       =   693,  -- (#02B5)
  -- Debugger got control C.

  ERROR_DBG_PRINTEXCEPTION_C                                =   694,  -- (#02B6)
  -- Debugger printed exception on control C.

  ERROR_DBG_RIPEXCEPTION                                    =   695,  -- (#02B7)
  -- Debugger received RIP exception.

  ERROR_DBG_CONTROL_BREAK                                   =   696,  -- (#02B8)
  -- Debugger received control break.

  ERROR_DBG_COMMAND_EXCEPTION                               =   697,  -- (#02B9)
  -- Debugger command communication exception.

  ERROR_OBJECT_NAME_EXISTS                                  =   698,  -- (#02BA)
  -- {Object Exists} An attempt was made to create an object and the object name
  -- already existed.

  ERROR_THREAD_WAS_SUSPENDED                                =   699,  -- (#02BB)
  -- {Thread Suspended} A thread termination occurred while the thread was
  -- suspended. The thread was resumed, and termination proceeded.

  ERROR_IMAGE_NOT_AT_BASE                                   =   700,  -- (#02BC)
  -- {Image Relocated}   An image file could not be mapped at the address
  -- specified in the image file. Local fixups must be performed on this image.

  ERROR_RXACT_STATE_CREATED                                 =   701,  -- (#02BD)
  -- This informational level status indicates that a specified registry
  -- sub-tree transaction state did not yet exist and had to be created.

  ERROR_SEGMENT_NOTIFICATION                                =   702,  -- (#02BE)
  -- {Segment Load} A virtual DOS machine (VDM) is loading, unloading, or moving
  -- an MS-DOS or Win16 program segment image. An exception is raised so a
  -- debugger can load, unload or track symbols and breakpoints within these
  -- 16-bit segments.

  ERROR_BAD_CURRENT_DIRECTORY                               =   703,  -- (#02BF)
  -- {Invalid Current Directory} The process cannot switch to the startup
  -- current directory %hs. Select OK to set current directory to %hs, or select
  -- CANCEL to exit.

  ERROR_FT_READ_RECOVERY_FROM_BACKUP                        =   704,  -- (#02C0)
  -- {Redundant Read} To satisfy a read request, the NT fault-tolerant file
  -- system successfully read the requested data from a redundant copy. This was
  -- done because the file system encountered a failure on a member of the
  -- fault-tolerant volume, but was unable to reassign the failing area of the
  -- device.

  ERROR_FT_WRITE_RECOVERY                                   =   705,  -- (#02C1)
  -- {Redundant Write} To satisfy a write request, the NT fault-tolerant file
  -- system successfully wrote a redundant copy of the information. This was
  -- done because the file system encountered a failure on a member of the
  -- fault-tolerant volume, but was not able to reassign the failing area of the
  -- device.

  ERROR_IMAGE_MACHINE_TYPE_MISMATCH                         =   706,  -- (#02C2)
  -- {Machine Type Mismatch} The image file %hs is valid, but is for a machine
  -- type other than the current machine. Select OK to continue, or CANCEL to
  -- fail the DLL load.

  ERROR_RECEIVE_PARTIAL                                     =   707,  -- (#02C3)
  -- {Partial Data Received} The network transport returned partial data to its
  -- client. The remaining data will be sent later.

  ERROR_RECEIVE_EXPEDITED                                   =   708,  -- (#02C4)
  -- {Expedited Data Received} The network transport returned data to its client
  -- that was marked as expedited by the remote system.

  ERROR_RECEIVE_PARTIAL_EXPEDITED                           =   709,  -- (#02C5)
  -- {Partial Expedited Data Received} The network transport returned partial
  -- data to its client and this data was marked as expedited by the remote
  -- system. The remaining data will be sent later.

  ERROR_EVENT_DONE                                          =   710,  -- (#02C6)
  -- {TDI Event Done} The TDI indication has completed successfully.

  ERROR_EVENT_PENDING                                       =   711,  -- (#02C7)
  -- {TDI Event Pending} The TDI indication has entered the pending state.

  ERROR_CHECKING_FILE_SYSTEM                                =   712,  -- (#02C8)
  -- Checking file system on %wZ.
  
  ERROR_FATAL_APP_EXIT                                      =   713,  -- (#02C9)
  -- {Fatal Application Exit} %hs.

  ERROR_PREDEFINED_HANDLE                                   =   714,  -- (#02CA)
  -- The specified registry key is referenced by a predefined handle.

  ERROR_WAS_UNLOCKED                                        =   715,  -- (#02CB)
  -- {Page Unlocked} The page protection of a locked page was changed to
  -- 'No Access' and the page was unlocked from memory and from the process.

  ERROR_SERVICE_NOTIFICATION                                =   716,  -- (#02CC)
  -- %hs.
  
  ERROR_WAS_LOCKED                                          =   717,  -- (#02CD)
  -- {Page Locked} One of the pages to lock was already locked.

  ERROR_LOG_HARD_ERROR                                      =   718,  -- (#02CE)
  -- Application popup: %1 : %2.
  
  ERROR_ALREADY_WIN32                                       =   719,  -- (#02CF)
  -- ERROR_ALREADY_WIN32.

  ERROR_IMAGE_MACHINE_TYPE_MISMATCH_EXE                     =   720,  -- (#02D0)
  -- {Machine Type Mismatch} The image file %hs is valid, but is for a machine
  -- type other than the current machine.

  ERROR_NO_YIELD_PERFORMED                                  =   721,  -- (#02D1)
  -- A yield execution was performed and no thread was available to run.

  ERROR_TIMER_RESUME_IGNORED                                =   722,  -- (#02D2)
  -- The resumable flag to a timer API was ignored.

  ERROR_ARBITRATION_UNHANDLED                               =   723,  -- (#02D3)
  -- The arbiter has deferred arbitration of these resources to its parent.

  ERROR_CARDBUS_NOT_SUPPORTED                               =   724,  -- (#02D4)
  -- The inserted CardBus device cannot be started because of a configuration
  -- error on "%hs".

  ERROR_MP_PROCESSOR_MISMATCH                               =   725,  -- (#02D5)
  -- The CPUs in this multiprocessor system are not all the same revision level.
  -- To use all processors the operating system restricts itself to the features
  -- of the least capable processor in the system. Should problems occur with
  -- this system, contact the CPU manufacturer to see if this mix of processors
  -- is supported.

  ERROR_HIBERNATED                                          =   726,  -- (#02D6)
  -- The system was put into hibernation.

  ERROR_RESUME_HIBERNATION                                  =   727,  -- (#02D7)
  -- The system was resumed from hibernation.

  ERROR_FIRMWARE_UPDATED                                    =   728,  -- (#02D8)
  -- Windows has detected that the system firmware (BIOS) was updated
  -- [previous firmware date %2, current firmware date %3].

  ERROR_DRIVERS_LEAKING_LOCKED_PAGES                        =   729,  -- (#02D9)
  -- A device driver is leaking locked I/O pages causing system degradation. The
  -- system has automatically enabled tracking code in order to try and catch
  -- the culprit.

  ERROR_WAKE_SYSTEM                                         =   730,  -- (#02DA)
  -- The system has awoken.

  ERROR_WAIT_1                                              =   731,  -- (#02DB)
  -- n/a
  
  ERROR_WAIT_2                                              =   732,  -- (#02DC)
  -- n/a
  
  ERROR_WAIT_3                                              =   733,  -- (#02DD)
  -- n/a
  
  ERROR_WAIT_63                                             =   734,  -- (#02DE)
  -- n/a
  
  ERROR_ABANDONED_WAIT_0                                    =   735,  -- (#02DF)
  -- n/a
  
  ERROR_ABANDONED_WAIT_63                                   =   736,  -- (#02E0)
  -- n/a
  
  ERROR_USER_APC                                            =   737,  -- (#02E1)
  -- n/a
  
  ERROR_KERNEL_APC                                          =   738,  -- (#02E2)
  -- n/a
  
  ERROR_ALERTED                                             =   739,  -- (#02E3)
  -- n/a
  
  ERROR_ELEVATION_REQUIRED                                  =   740,  -- (#02E4)
  -- The requested operation requires elevation.

  ERROR_REPARSE                                             =   741,  -- (#02E5)
  -- A reparse should be performed by the Object Manager since the name of the
  -- file resulted in a symbolic link.

  ERROR_OPLOCK_BREAK_IN_PROGRESS                            =   742,  -- (#02E6)
  -- An open/create operation completed while an oplock break is underway.

  ERROR_VOLUME_MOUNTED                                      =   743,  -- (#02E7)
  -- A new volume has been mounted by a file system.

  ERROR_RXACT_COMMITTED                                     =   744,  -- (#02E8)
  -- This success level status indicates that the transaction state already
  -- exists for the registry sub-tree, but that a transaction commit was
  -- previously aborted. The commit has now been completed.

  ERROR_NOTIFY_CLEANUP                                      =   745,  -- (#02E9)
  -- This indicates that a notify change request has been completed due to
  -- closing the handle which made the notify change request.

  ERROR_PRIMARY_TRANSPORT_CONNECT_FAILED                    =   746,  -- (#02EA)
  -- {Connect Failure on Primary Transport} An attempt was made to connect to
  -- the remote server %hs on the primary transport, but the connection failed.
  -- The computer WAS able to connect on a secondary transport.

  ERROR_PAGE_FAULT_TRANSITION                               =   747,  -- (#02EB)
  -- Page fault was a transition fault.

  ERROR_PAGE_FAULT_DEMAND_ZERO                              =   748,  -- (#02EC)
  -- Page fault was a demand zero fault.

  ERROR_PAGE_FAULT_COPY_ON_WRITE                            =   749,  -- (#02ED)
  -- Page fault was a demand zero fault.

  ERROR_PAGE_FAULT_GUARD_PAGE                               =   750,  -- (#02EE)
  -- Page fault was a demand zero fault.

  ERROR_PAGE_FAULT_PAGING_FILE                              =   751,  -- (#02EF)
  -- Page fault was satisfied by reading from a secondary storage device.

  ERROR_CACHE_PAGE_LOCKED                                   =   752,  -- (#02F0)
  -- Cached page was locked during operation.

  ERROR_CRASH_DUMP                                          =   753,  -- (#02F1)
  -- Crash dump exists in paging file.

  ERROR_BUFFER_ALL_ZEROS                                    =   754,  -- (#02F2)
  -- Specified buffer contains all zeros.

  ERROR_REPARSE_OBJECT                                      =   755,  -- (#02F3)
  -- A reparse should be performed by the Object Manager since the name of the
  -- file resulted in a symbolic link.

  ERROR_RESOURCE_REQUIREMENTS_CHANGED                       =   756,  -- (#02F4)
  -- The device has succeeded a query-stop and its resource requirements have
  -- changed.

  ERROR_TRANSLATION_COMPLETE                                =   757,  -- (#02F5)
  -- The translator has translated these resources into the public space and no
  -- further translations should be performed.

  ERROR_NOTHING_TO_TERMINATE                                =   758,  -- (#02F6)
  -- A process being terminated has no threads to terminate.

  ERROR_PROCESS_NOT_IN_JOB                                  =   759,  -- (#02F7)
  -- The specified process is not part of a job.

  ERROR_PROCESS_IN_JOB                                      =   760,  -- (#02F8)
  -- The specified process is part of a job.

  ERROR_VOLSNAP_HIBERNATE_READY                             =   761,  -- (#02F9)
  -- {Volume Shadow Copy Service} The system is now ready for hibernation.

  ERROR_FSFILTER_OP_COMPLETED_SUCCESSFULLY                  =   762,  -- (#02FA)
  -- A file system or file system filter driver has successfully completed an
  -- FsFilter operation.

  ERROR_INTERRUPT_VECTOR_ALREADY_CONNECTED                  =   763,  -- (#02FB)
  -- The specified interrupt vector was already connected.

  ERROR_INTERRUPT_STILL_CONNECTED                           =   764,  -- (#02FC)
  -- The specified interrupt vector is still connected.

  ERROR_WAIT_FOR_OPLOCK                                     =   765,  -- (#02FD)
  -- An operation is blocked waiting for an oplock.

  ERROR_DBG_EXCEPTION_HANDLED                               =   766,  -- (#02FE)
  -- Debugger handled exception.
  
  ERROR_DBG_CONTINUE                                        =   767,  -- (#02FF)
  -- Debugger continued.
  
  ERROR_CALLBACK_POP_STACK                                  =   768,  -- (#0300)
  -- An exception occurred in a user mode callback and the kernel callback
  -- frame should be removed.

  ERROR_COMPRESSION_DISABLED                                =   769,  -- (#0301)
  -- Compression is disabled for this volume.

  ERROR_CANTFETCHBACKWARDS                                  =   770,  -- (#0302)
  -- The data provider cannot fetch backwards through a result set.

  ERROR_CANTSCROLLBACKWARDS                                 =   771,  -- (#0303)
  -- The data provider cannot scroll backwards through a result set.

  ERROR_ROWSNOTRELEASED                                     =   772,  -- (#0304)
  -- The data provider requires that previously fetched data is released before
  -- asking for more data.

  ERROR_BAD_ACCESSOR_FLAGS                                  =   773,  -- (#0305)
  -- The data provider was not able to interpret the flags set for a column
  -- binding in an accessor.

  ERROR_ERRORS_ENCOUNTERED                                  =   774,  -- (#0306)
  -- One or more errors occurred while processing the request.

  ERROR_NOT_CAPABLE                                         =   775,  -- (#0307)
  -- The implementation is not capable of performing the request.

  ERROR_REQUEST_OUT_OF_SEQUENCE                             =   776,  -- (#0308)
  -- The client of a component requested an operation which is not valid given
  -- the state of the component instance.

  ERROR_VERSION_PARSE_ERROR                                 =   777,  -- (#0309)
  -- A version number could not be parsed.

  ERROR_BADSTARTPOSITION                                    =   778,  -- (#030A)
  -- The iterator's start position is invalid.

  ERROR_MEMORY_HARDWARE                                     =   779,  -- (#030B)
  -- The hardware has reported an uncorrectable memory error.

  ERROR_DISK_REPAIR_DISABLED                                =   780,  -- (#030C)
  -- The attempted operation required self healing to be enabled.

  ERROR_INSUFFICIENT_RESOURCE_FOR_SPECIFIED_SHARED_SECTION_SIZE = 781,  -- (#030D)
  -- The Desktop heap encountered an error while allocating session memory.
  -- There is more information in the system event log.

  ERROR_SYSTEM_POWERSTATE_TRANSITION                        =   782,  -- (#030E)
  -- The system power state is transitioning from %2 to %3.

  ERROR_SYSTEM_POWERSTATE_COMPLEX_TRANSITION                =   783,  -- (#030F)
  -- The system power state is transitioning from %2 to %3 but could enter %4.

  ERROR_MCA_EXCEPTION                                       =   784,  -- (#0310)
  -- A thread is getting dispatched with MCA EXCEPTION because of MCA.

  ERROR_ACCESS_AUDIT_BY_POLICY                              =   785,  -- (#0311)
  -- Access to %1 is monitored by policy rule %2.

  ERROR_ACCESS_DISABLED_NO_SAFER_UI_BY_POLICY               =   786,  -- (#0312)
  -- Access to %1 has been restricted by your Administrator by policy rule %2.

  ERROR_ABANDON_HIBERFILE                                   =   787,  -- (#0313)
  -- A valid hibernation file has been invalidated and should be abandoned.

  ERROR_LOST_WRITEBEHIND_DATA_NETWORK_DISCONNECTED          =   788,  -- (#0314)
  -- {Delayed Write Failed} Windows was unable to save all the data for the file
  -- %hs; the data has been lost. This error may be caused by network
  -- connectivity issues. Please try to save this file elsewhere.

  ERROR_LOST_WRITEBEHIND_DATA_NETWORK_SERVER_ERROR          =   789,  -- (#0315)
  -- {Delayed Write Failed} Windows was unable to save all the data for the file
  -- %hs; the data has been lost. This error was returned by the server on which
  -- the file exists. Please try to save this file elsewhere.

  ERROR_LOST_WRITEBEHIND_DATA_LOCAL_DISK_ERROR              =   790,  -- (#0316)
  -- {Delayed Write Failed} Windows was unable to save all the data for the file
  -- %hs; the data has been lost. This error may be caused if the device has
  -- been removed or the media is write-protected.

  ERROR_BAD_MCFG_TABLE                                      =   791,  -- (#0317)
  -- The resources required for this device conflict with the MCFG table.

  ERROR_OPLOCK_SWITCHED_TO_NEW_HANDLE                       =   800,  -- (#0320)
  -- The oplock that was associated with this handle is now associated with a
  -- different handle.

  ERROR_CANNOT_GRANT_REQUESTED_OPLOCK                       =   801,  -- (#0321)
  -- An oplock of the requested level cannot be granted. An oplock of a lower
  -- level may be available.

  ERROR_CANNOT_BREAK_OPLOCK                                 =   802,  -- (#0322)
  -- The operation did not complete successfully because it would cause an
  -- oplock to be broken. The caller has requested that existing oplocks not be
  -- broken.

  ERROR_OPLOCK_HANDLE_CLOSED                                =   803,  -- (#0323)
  -- The handle with which this oplock was associated has been closed. The
  -- oplock is now broken.

  ERROR_NO_ACE_CONDITION                                    =   804,  -- (#0324)
  -- The specified access control entry (ACE) does not contain a condition.

  ERROR_INVALID_ACE_CONDITION                               =   805,  -- (#0325)
  -- The specified access control entry (ACE) contains an invalid condition.

  ERROR_EA_ACCESS_DENIED                                    =   994,  -- (#03E2)
  -- Access to the extended attribute was denied.

  ERROR_OPERATION_ABORTED                                   =   995,  -- (#03E3)
  -- The I/O operation has been aborted because of either a thread exit or an
  -- application request.

  ERROR_IO_INCOMPLETE                                       =   996,  -- (#03E4)
  -- Overlapped I/O event is not in a signaled state.

  ERROR_IO_PENDING                                          =   997,  -- (#03E5)
  -- Overlapped I/O operation is in progress.

  ERROR_NOACCESS                                            =   998,  -- (#03E6)
  -- Invalid access to memory location.

  ERROR_SWAPERROR                                           =   999,  -- (#03E7)
  -- Error performing inpage operation.

  ERROR_STACK_OVERFLOW                                      =  1001,  -- (#03E9)
  -- Recursion too deep; the stack overflowed.

  ERROR_INVALID_MESSAGE                                     =  1002,  -- (#03EA)
  -- The window cannot act on the sent message.

  ERROR_CAN_NOT_COMPLETE                                    =  1003,  -- (#03EB)
  -- Cannot complete this function.

  ERROR_INVALID_FLAGS                                       =  1004,  -- (#03EC)
  -- Invalid flags.

  ERROR_UNRECOGNIZED_VOLUME                                 =  1005,  -- (#03ED)
  -- The volume does not contain a recognized file system. Please make sure that
  -- all required file system drivers are loaded and that the volume is not
  -- corrupted.

  ERROR_FILE_INVALID                                        =  1006,  -- (#03EE)
  -- The volume for a file has been externally altered so that the opened file
  -- is no longer valid.

  ERROR_FULLSCREEN_MODE                                     =  1007,  -- (#03EF)
  -- The requested operation cannot be performed in full-screen mode.

  ERROR_NO_TOKEN                                            =  1008,  -- (#03F0)
  -- An attempt was made to reference a token that does not exist.

  ERROR_BADDB                                               =  1009,  -- (#03F1)
  -- The configuration registry database is corrupt.

  ERROR_BADKEY                                              =  1010,  -- (#03F2)
  -- The configuration registry key is invalid.

  ERROR_CANTOPEN                                            =  1011,  -- (#03F3)
  -- The configuration registry key could not be opened.

  ERROR_CANTREAD                                            =  1012,  -- (#03F4)
  -- The configuration registry key could not be read.

  ERROR_CANTWRITE                                           =  1013,  -- (#03F5)
  -- The configuration registry key could not be written.

  ERROR_REGISTRY_RECOVERED                                  =  1014,  -- (#03F6)
  -- One of the files in the registry database had to be recovered by use of a
  -- log or alternate copy. The recovery was successful.

  ERROR_REGISTRY_CORRUPT                                    =  1015,  -- (#03F7)
  -- The registry is corrupted. The structure of one of the files containing
  -- registry data is corrupted, or the system's memory image of the file is
  -- corrupted, or the file could not be recovered because the alternate copy or
  -- log was absent or corrupted.

  ERROR_REGISTRY_IO_FAILED                                  =  1016,  -- (#03F8)
  -- An I/O operation initiated by the registry failed unrecoverably. The
  -- registry could not read in, or write out, or flush, one of the files that
  -- contain the system's image of the registry.

  ERROR_NOT_REGISTRY_FILE                                   =  1017,  -- (#03F9)
  -- The system has attempted to load or restore a file into the registry, but
  -- the specified file is not in a registry file format.

  ERROR_KEY_DELETED                                         =  1018,  -- (#03FA)
  -- Illegal operation attempted on a registry key that has been marked for
  -- deletion.

  ERROR_NO_LOG_SPACE                                        =  1019,  -- (#03FB)
  -- System could not allocate the required space in a registry log.

  ERROR_KEY_HAS_CHILDREN                                    =  1020,  -- (#03FC)
  -- Cannot create a symbolic link in a registry key that already has subkeys or
  -- values.

  ERROR_CHILD_MUST_BE_VOLATILE                              =  1021,  -- (#03FD)
  -- Cannot create a stable subkey under a volatile parent key.

  ERROR_NOTIFY_ENUM_DIR                                     =  1022,  -- (#03FE)
  -- A notify change request is being completed and the information is not being
  -- returned in the caller's buffer. The caller now needs to enumerate the
  -- files to find the changes.

  ERROR_DEPENDENT_SERVICES_RUNNING                          =  1051,  -- (#041B)
  -- A stop control has been sent to a service that other running services are
  -- dependent on.

  ERROR_INVALID_SERVICE_CONTROL                             =  1052,  -- (#041C)
  -- The requested control is not valid for this service.

  ERROR_SERVICE_REQUEST_TIMEOUT                             =  1053,  -- (#041D)
  -- The service did not respond to the start or control request in a timely
  -- fashion.

  ERROR_SERVICE_NO_THREAD                                   =  1054,  -- (#041E)
  -- A thread could not be created for the service.

  ERROR_SERVICE_DATABASE_LOCKED                             =  1055,  -- (#041F)
  -- The service database is locked.

  ERROR_SERVICE_ALREADY_RUNNING                             =  1056,  -- (#0420)
  -- An instance of the service is already running.

  ERROR_INVALID_SERVICE_ACCOUNT                             =  1057,  -- (#0421)
  -- The account name is invalid or does not exist, or the password is invalid
  -- for the account name specified.

  ERROR_SERVICE_DISABLED                                    =  1058,  -- (#0422)
  -- The service cannot be started, either because it is disabled or because it
  -- has no enabled devices associated with it.

  ERROR_CIRCULAR_DEPENDENCY                                 =  1059,  -- (#0423)
  -- Circular service dependency was specified.

  ERROR_SERVICE_DOES_NOT_EXIST                              =  1060,  -- (#0424)
  -- The specified service does not exist as an installed service.

  ERROR_SERVICE_CANNOT_ACCEPT_CTRL                          =  1061,  -- (#0425)
  -- The service cannot accept control messages at this time.

  ERROR_SERVICE_NOT_ACTIVE                                  =  1062,  -- (#0426)
  -- The service has not been started.

  ERROR_FAILED_SERVICE_CONTROLLER_CONNECT                   =  1063,  -- (#0427)
  -- The service process could not connect to the service controller.

  ERROR_EXCEPTION_IN_SERVICE                                =  1064,  -- (#0428)
  -- An exception occurred in the service when handling the control request.

  ERROR_DATABASE_DOES_NOT_EXIST                             =  1065,  -- (#0429)
  -- The database specified does not exist.

  ERROR_SERVICE_SPECIFIC_ERROR                              =  1066,  -- (#042A)
  -- The service has returned a service-specific error code.

  ERROR_PROCESS_ABORTED                                     =  1067,  -- (#042B)
  -- The process terminated unexpectedly.

  ERROR_SERVICE_DEPENDENCY_FAIL                             =  1068,  -- (#042C)
  -- The dependency service or group failed to start.

  ERROR_SERVICE_LOGON_FAILED                                =  1069,  -- (#042D)
  -- The service did not start due to a logon failure.

  ERROR_SERVICE_START_HANG                                  =  1070,  -- (#042E)
  -- After starting, the service hung in a start-pending state.

  ERROR_INVALID_SERVICE_LOCK                                =  1071,  -- (#042F)
  -- The specified service database lock is invalid.

  ERROR_SERVICE_MARKED_FOR_DELETE                           =  1072,  -- (#0430)
  -- The specified service has been marked for deletion.

  ERROR_SERVICE_EXISTS                                      =  1073,  -- (#0431)
  -- The specified service already exists.

  ERROR_ALREADY_RUNNING_LKG                                 =  1074,  -- (#0432)
  -- The system is currently running with the last-known-good configuration.

  ERROR_SERVICE_DEPENDENCY_DELETED                          =  1075,  -- (#0433)
  -- The dependency service does not exist or has been marked for deletion.

  ERROR_BOOT_ALREADY_ACCEPTED                               =  1076,  -- (#0434)
  -- The current boot has already been accepted for use as the last-known-good
  -- control set.

  ERROR_SERVICE_NEVER_STARTED                               =  1077,  -- (#0435)
  -- No attempts to start the service have been made since the last boot.

  ERROR_DUPLICATE_SERVICE_NAME                              =  1078,  -- (#0436)
  -- The name is already in use as either a service name or a service display
  -- name.

  ERROR_DIFFERENT_SERVICE_ACCOUNT                           =  1079,  -- (#0437)
  -- The account specified for this service is different from the account
  -- specified for other services running in the same process.

  ERROR_CANNOT_DETECT_DRIVER_FAILURE                        =  1080,  -- (#0438)
  -- Failure actions can only be set for Win32 services, not for drivers.

  ERROR_CANNOT_DETECT_PROCESS_ABORT                         =  1081,  -- (#0439)
  -- This service runs in the same process as the service control manager.
  -- Therefore, the service control manager cannot take action if this service's
  -- process terminates unexpectedly.

  ERROR_NO_RECOVERY_PROGRAM                                 =  1082,  -- (#043A)
  -- No recovery program has been configured for this service.

  ERROR_SERVICE_NOT_IN_EXE                                  =  1083,  -- (#043B)
  -- The executable program that this service is configured to run in does not
  -- implement the service.

  ERROR_NOT_SAFEBOOT_SERVICE                                =  1084,  -- (#043C)
  -- This service cannot be started in Safe Mode.

  ERROR_END_OF_MEDIA                                        =  1100,  -- (#044C)
  -- The physical end of the tape has been reached.

  ERROR_FILEMARK_DETECTED                                   =  1101,  -- (#044D)
  -- A tape access reached a filemark.

  ERROR_BEGINNING_OF_MEDIA                                  =  1102,  -- (#044E)
  -- The beginning of the tape or a partition was encountered.

  ERROR_SETMARK_DETECTED                                    =  1103,  -- (#044F)
  -- A tape access reached the end of a set of files.

  ERROR_NO_DATA_DETECTED                                    =  1104,  -- (#0450)
  -- No more data is on the tape.

  ERROR_PARTITION_FAILURE                                   =  1105,  -- (#0451)
  -- Tape could not be partitioned.

  ERROR_INVALID_BLOCK_LENGTH                                =  1106,  -- (#0452)
  -- When accessing a new tape of a multivolume partition, the current block
  -- size is incorrect.

  ERROR_DEVICE_NOT_PARTITIONED                              =  1107,  -- (#0453)
  -- Tape partition information could not be found when loading a tape.

  ERROR_UNABLE_TO_LOCK_MEDIA                                =  1108,  -- (#0454)
  -- Unable to lock the media eject mechanism.

  ERROR_UNABLE_TO_UNLOAD_MEDIA                              =  1109,  -- (#0455)
  -- Unable to unload the media.

  ERROR_MEDIA_CHANGED                                       =  1110,  -- (#0456)
  -- The media in the drive may have changed.

  ERROR_BUS_RESET                                           =  1111,  -- (#0457)
  -- The I/O bus was reset.

  ERROR_NO_MEDIA_IN_DRIVE                                   =  1112,  -- (#0458)
  -- No media in drive.

  ERROR_NO_UNICODE_TRANSLATION                              =  1113,  -- (#0459)
  -- No mapping for the Unicode character exists in the target multi-byte code
  -- page.

  ERROR_DLL_INIT_FAILED                                     =  1114,  -- (#045A)
  -- A dynamic link library (DLL) initialization routine failed.

  ERROR_SHUTDOWN_IN_PROGRESS                                =  1115,  -- (#045B)
  -- A system shutdown is in progress.

  ERROR_NO_SHUTDOWN_IN_PROGRESS                             =  1116,  -- (#045C)
  -- Unable to abort the system shutdown because no shutdown was in progress.

  ERROR_IO_DEVICE                                           =  1117,  -- (#045D)
  -- The request could not be performed because of an I/O device error.

  ERROR_SERIAL_NO_DEVICE                                    =  1118,  -- (#045E)
  -- No serial device was successfully initialized. The serial driver will
  -- unload.

  ERROR_IRQ_BUSY                                            =  1119,  -- (#045F)
  -- Unable to open a device that was sharing an interrupt request (IRQ)  with
  -- other devices. At least one other device that uses that IRQ was already
  -- opened.

  ERROR_MORE_WRITES                                         =  1120,  -- (#0460)
  -- A serial I/O operation was completed by another write to the serial port.
  -- (The IOCTL_SERIAL_XOFF_COUNTER reached zero.)
  -- 
  ERROR_COUNTER_TIMEOUT                                     =  1121,  -- (#0461)
  -- A serial I/O operation completed because the timeout period expired. (The
  -- IOCTL_SERIAL_XOFF_COUNTER did not reach zero.)
  -- 
  ERROR_FLOPPY_ID_MARK_NOT_FOUND                            =  1122,  -- (#0462)
  -- No ID address mark was found on the floppy disk.

  ERROR_FLOPPY_WRONG_CYLINDER                               =  1123,  -- (#0463)
  -- Mismatch between the floppy disk sector ID field and the floppy disk
  -- controller track address.

  ERROR_FLOPPY_UNKNOWN_ERROR                                =  1124,  -- (#0464)
  -- The floppy disk controller reported an error that is not recognized by the
  -- floppy disk driver.

  ERROR_FLOPPY_BAD_REGISTERS                                =  1125,  -- (#0465)
  -- The floppy disk controller returned inconsistent results in its registers.

  ERROR_DISK_RECALIBRATE_FAILED                             =  1126,  -- (#0466)
  -- While accessing the hard disk, a recalibrate operation failed, even after
  -- retries.

  ERROR_DISK_OPERATION_FAILED                               =  1127,  -- (#0467)
  -- While accessing the hard disk, a disk operation failed even after retries.

  ERROR_DISK_RESET_FAILED                                   =  1128,  -- (#0468)
  -- While accessing the hard disk, a disk controller reset was needed, but even
  -- that failed.

  ERROR_EOM_OVERFLOW                                        =  1129,  -- (#0469)
  -- Physical end of tape encountered.

  ERROR_NOT_ENOUGH_SERVER_MEMORY                            =  1130,  -- (#046A)
  -- Not enough server storage is available to process this command.

  ERROR_POSSIBLE_DEADLOCK                                   =  1131,  -- (#046B)
  -- A potential deadlock condition has been detected.

  ERROR_MAPPED_ALIGNMENT                                    =  1132,  -- (#046C)
  -- The base address or the file offset specified does not have the proper
  -- alignment.

  ERROR_SET_POWER_STATE_VETOED                              =  1140,  -- (#0474)
  -- An attempt to change the system power state was vetoed by another
  -- application or driver.

  ERROR_SET_POWER_STATE_FAILED                              =  1141,  -- (#0475)
  -- The system BIOS failed an attempt to change the system power state.

  ERROR_TOO_MANY_LINKS                                      =  1142,  -- (#0476)
  -- An attempt was made to create more links on a file than the file system
  -- supports.

  ERROR_OLD_WIN_VERSION                                     =  1150,  -- (#047E)
  -- The specified program requires a newer version of Windows.

  ERROR_APP_WRONG_OS                                        =  1151,  -- (#047F)
  -- The specified program is not a Windows or MS-DOS program.

  ERROR_SINGLE_INSTANCE_APP                                 =  1152,  -- (#0480)
  -- Cannot start more than one instance of the specified program.

  ERROR_RMODE_APP                                           =  1153,  -- (#0481)
  -- The specified program was written for an earlier version of Windows.

  ERROR_INVALID_DLL                                         =  1154,  -- (#0482)
  -- One of the library files needed to run this application is damaged.

  ERROR_NO_ASSOCIATION                                      =  1155,  -- (#0483)
  -- No application is associated with the specified file for this operation.

  ERROR_DDE_FAIL                                            =  1156,  -- (#0484)
  -- An error occurred in sending the command to the application.

  ERROR_DLL_NOT_FOUND                                       =  1157,  -- (#0485)
  -- One of the library files needed to run this application cannot be found.

  ERROR_NO_MORE_USER_HANDLES                                =  1158,  -- (#0486)
  -- The current process has used all of its system allowance of handles for
  -- Window Manager objects.

  ERROR_MESSAGE_SYNC_ONLY                                   =  1159,  -- (#0487)
  -- The message can be used only with synchronous operations.

  ERROR_SOURCE_ELEMENT_EMPTY                                =  1160,  -- (#0488)
  -- The indicated source element has no media.

  ERROR_DESTINATION_ELEMENT_FULL                            =  1161,  -- (#0489)
  -- The indicated destination element already contains media.

  ERROR_ILLEGAL_ELEMENT_ADDRESS                             =  1162,  -- (#048A)
  -- The indicated element does not exist.

  ERROR_MAGAZINE_NOT_PRESENT                                =  1163,  -- (#048B)
  -- The indicated element is part of a magazine that is not present.

  ERROR_DEVICE_REINITIALIZATION_NEEDED                      =  1164,  -- (#048C)
  -- The indicated device requires reinitialization due to hardware errors.

  ERROR_DEVICE_REQUIRES_CLEANING                            =  1165,  -- (#048D)
  -- The device has indicated that cleaning is required before further
  -- operations are attempted.

  ERROR_DEVICE_DOOR_OPEN                                    =  1166,  -- (#048E)
  -- The device has indicated that its door is open.

  ERROR_DEVICE_NOT_CONNECTED                                =  1167,  -- (#048F)
  -- The device is not connected.

  ERROR_NOT_FOUND                                           =  1168,  -- (#0490)
  -- Element not found.

  ERROR_NO_MATCH                                            =  1169,  -- (#0491)
  -- There was no match for the specified key in the index.

  ERROR_SET_NOT_FOUND                                       =  1170,  -- (#0492)
  -- The property set specified does not exist on the object.

  ERROR_POINT_NOT_FOUND                                     =  1171,  -- (#0493)
  -- The point passed to GetMouseMovePointsEx is not in the buffer.

  ERROR_NO_TRACKING_SERVICE                                 =  1172,  -- (#0494)
  -- The tracking (workstation) service is not running.

  ERROR_NO_VOLUME_ID                                        =  1173,  -- (#0495)
  -- The Volume ID could not be found.

  ERROR_UNABLE_TO_REMOVE_REPLACED                           =  1175,  -- (#0497)
  -- Unable to remove the file to be replaced.

  ERROR_UNABLE_TO_MOVE_REPLACEMENT                          =  1176,  -- (#0498)
  -- Unable to move the replacement file to the file to be replaced. The file to
  -- be replaced has retained its original name.

  ERROR_UNABLE_TO_MOVE_REPLACEMENT_2                        =  1177,  -- (#0499)
  -- Unable to move the replacement file to the file to be replaced. The file to
  -- be replaced has been renamed using the backup name.

  ERROR_JOURNAL_DELETE_IN_PROGRESS                          =  1178,  -- (#049A)
  -- The volume change journal is being deleted.

  ERROR_JOURNAL_NOT_ACTIVE                                  =  1179,  -- (#049B)
  -- The volume change journal service is not active.

  ERROR_POTENTIAL_FILE_FOUND                                =  1180,  -- (#049C)
  -- A file was found, but it may not be the correct file.

  ERROR_JOURNAL_ENTRY_DELETED                               =  1181,  -- (#049D)
  -- The journal entry has been deleted from the journal.

  ERROR_SHUTDOWN_IS_SCHEDULED                               =  1190,  -- (#04A6)
  -- A system shutdown has already been scheduled.

  ERROR_SHUTDOWN_USERS_LOGGED_ON                            =  1191,  -- (#04A7)
  -- The system shutdown cannot be initiated because there are other users
  -- logged on to the computer.

  ERROR_BAD_DEVICE                                          =  1200,  -- (#04B0)
  -- The specified device name is invalid.

  ERROR_CONNECTION_UNAVAIL                                  =  1201,  -- (#04B1)
  -- The device is not currently connected but it is a remembered connection.

  ERROR_DEVICE_ALREADY_REMEMBERED                           =  1202,  -- (#04B2)
  -- The local device name has a remembered connection to another network
  -- resource.

  ERROR_NO_NET_OR_BAD_PATH                                  =  1203,  -- (#04B3)
  -- No network provider accepted the given network path.

  ERROR_BAD_PROVIDER                                        =  1204,  -- (#04B4)
  -- The specified network provider name is invalid.

  ERROR_CANNOT_OPEN_PROFILE                                 =  1205,  -- (#04B5)
  -- Unable to open the network connection profile.

  ERROR_BAD_PROFILE                                         =  1206,  -- (#04B6)
  -- The network connection profile is corrupted.

  ERROR_NOT_CONTAINER                                       =  1207,  -- (#04B7)
  -- Cannot enumerate a noncontainer.

  ERROR_EXTENDED_ERROR                                      =  1208,  -- (#04B8)
  -- An extended error has occurred.

  ERROR_INVALID_GROUPNAME                                   =  1209,  -- (#04B9)
  -- The format of the specified group name is invalid.

  ERROR_INVALID_COMPUTERNAME                                =  1210,  -- (#04BA)
  -- The format of the specified computer name is invalid.

  ERROR_INVALID_EVENTNAME                                   =  1211,  -- (#04BB)
  -- The format of the specified event name is invalid.

  ERROR_INVALID_DOMAINNAME                                  =  1212,  -- (#04BC)
  -- The format of the specified domain name is invalid.

  ERROR_INVALID_SERVICENAME                                 =  1213,  -- (#04BD)
  -- The format of the specified service name is invalid.

  ERROR_INVALID_NETNAME                                     =  1214,  -- (#04BE)
  -- The format of the specified network name is invalid.

  ERROR_INVALID_SHARENAME                                   =  1215,  -- (#04BF)
  -- The format of the specified share name is invalid.

  ERROR_INVALID_PASSWORDNAME                                =  1216,  -- (#04C0)
  -- The format of the specified password is invalid.

  ERROR_INVALID_MESSAGENAME                                 =  1217,  -- (#04C1)
  -- The format of the specified message name is invalid.

  ERROR_INVALID_MESSAGEDEST                                 =  1218,  -- (#04C2)
  -- The format of the specified message destination is invalid.

  ERROR_SESSION_CREDENTIAL_CONFLICT                         =  1219,  -- (#04C3)
  -- The credentials supplied conflict with an existing set of credentials.

  ERROR_REMOTE_SESSION_LIMIT_EXCEEDED                       =  1220,  -- (#04C4)
  -- An attempt was made to establish a session to a network server, but there
  -- are already too many sessions established to that server.

  ERROR_DUP_DOMAINNAME                                      =  1221,  -- (#04C5)
  -- The workgroup or domain name is already in use by another computer on the
  -- network.

  ERROR_NO_NETWORK                                          =  1222,  -- (#04C6)
  -- The network is not present or not started.

  ERROR_CANCELLED                                           =  1223,  -- (#04C7)
  -- The operation was canceled by the user.

  ERROR_USER_MAPPED_FILE                                    =  1224,  -- (#04C8)
  -- The requested operation cannot be performed on a file with a user-mapped
  -- section open.

  ERROR_CONNECTION_REFUSED                                  =  1225,  -- (#04C9)
  -- The remote system refused the network connection.

  ERROR_GRACEFUL_DISCONNECT                                 =  1226,  -- (#04CA)
  -- The network connection was gracefully closed.

  ERROR_ADDRESS_ALREADY_ASSOCIATED                          =  1227,  -- (#04CB)
  -- The network transport endpoint already has an address associated with it.

  ERROR_ADDRESS_NOT_ASSOCIATED                              =  1228,  -- (#04CC)
  -- An address has not yet been associated with the network endpoint.

  ERROR_CONNECTION_INVALID                                  =  1229,  -- (#04CD)
  -- An operation was attempted on a nonexistent network connection.

  ERROR_CONNECTION_ACTIVE                                   =  1230,  -- (#04CE)
  -- An invalid operation was attempted on an active network connection.

  ERROR_NETWORK_UNREACHABLE                                 =  1231,  -- (#04CF)
  -- The network location cannot be reached. For information about network
  -- troubleshooting, see Windows Help.

  ERROR_HOST_UNREACHABLE                                    =  1232,  -- (#04D0)
  -- The network location cannot be reached. For information about network
  -- troubleshooting, see Windows Help.

  ERROR_PROTOCOL_UNREACHABLE                                =  1233,  -- (#04D1)
  -- The network location cannot be reached. For information about network
  -- troubleshooting, see Windows Help.

  ERROR_PORT_UNREACHABLE                                    =  1234,  -- (#04D2)
  -- No service is operating at the destination network endpoint on the remote
  -- system.

  ERROR_REQUEST_ABORTED                                     =  1235,  -- (#04D3)
  -- The request was aborted.

  ERROR_CONNECTION_ABORTED                                  =  1236,  -- (#04D4)
  -- The network connection was aborted by the local system.

  ERROR_RETRY                                               =  1237,  -- (#04D5)
  -- The operation could not be completed. A retry should be performed.

  ERROR_CONNECTION_COUNT_LIMIT                              =  1238,  -- (#04D6)
  -- A connection to the server could not be made because the limit on the
  -- number of concurrent connections for this account has been reached.

  ERROR_LOGIN_TIME_RESTRICTION                              =  1239,  -- (#04D7)
  -- Attempting to log in during an unauthorized time of day for this account.

  ERROR_LOGIN_WKSTA_RESTRICTION                             =  1240,  -- (#04D8)
  -- The account is not authorized to log in from this station.

  ERROR_INCORRECT_ADDRESS                                   =  1241,  -- (#04D9)
  -- The network address could not be used for the operation requested.

  ERROR_ALREADY_REGISTERED                                  =  1242,  -- (#04DA)
  -- The service is already registered.

  ERROR_SERVICE_NOT_FOUND                                   =  1243,  -- (#04DB)
  -- The specified service does not exist.

  ERROR_NOT_AUTHENTICATED                                   =  1244,  -- (#04DC)
  -- The operation being requested was not performed because the user has not
  -- been authenticated.

  ERROR_NOT_LOGGED_ON                                       =  1245,  -- (#04DD)
  -- The operation being requested was not performed because the user has not
  -- logged on to the network. The specified service does not exist.

  ERROR_CONTINUE                                            =  1246,  -- (#04DE)
  -- Continue with work in progress.

  ERROR_ALREADY_INITIALIZED                                 =  1247,  -- (#04DF)
  -- An attempt was made to perform an initialization operation when
  -- initialization has already been completed.

  ERROR_NO_MORE_DEVICES                                     =  1248,  -- (#04E0)
  -- No more local devices.

  ERROR_NO_SUCH_SITE                                        =  1249,  -- (#04E1)
  -- The specified site does not exist.

  ERROR_DOMAIN_CONTROLLER_EXISTS                            =  1250,  -- (#04E2)
  -- A domain controller with the specified name already exists.

  ERROR_ONLY_IF_CONNECTED                                   =  1251,  -- (#04E3)
  -- This operation is supported only when you are connected to the server.

  ERROR_OVERRIDE_NOCHANGES                                  =  1252,  -- (#04E4)
  -- The group policy framework should call the extension even if there are no
  -- changes.

  ERROR_BAD_USER_PROFILE                                    =  1253,  -- (#04E5)
  -- The specified user does not have a valid profile.

  ERROR_NOT_SUPPORTED_ON_SBS                                =  1254,  -- (#04E6)
  -- This operation is not supported on a Microsoft Small Business Server.

  ERROR_SERVER_SHUTDOWN_IN_PROGRESS                         =  1255,  -- (#04E7)
  -- The server machine is shutting down.

  ERROR_HOST_DOWN                                           =  1256,  -- (#04E8)
  -- The remote system is not available. For information about network
  -- troubleshooting, see Windows Help.

  ERROR_NON_ACCOUNT_SID                                     =  1257,  -- (#04E9)
  -- The security identifier provided is not from an account domain.

  ERROR_NON_DOMAIN_SID                                      =  1258,  -- (#04EA)
  -- The security identifier provided does not have a domain component.

  ERROR_APPHELP_BLOCK                                       =  1259,  -- (#04EB)
  -- AppHelp dialog canceled thus preventing the application from starting.

  ERROR_ACCESS_DISABLED_BY_POLICY                           =  1260,  -- (#04EC)
  -- This program is blocked by group policy. For more information, contact your
  -- system administrator.

  ERROR_REG_NAT_CONSUMPTION                                 =  1261,  -- (#04ED)
  -- A program attempt to use an invalid register value. Normally caused by an
  -- uninitialized register. This error is Itanium specific.

  ERROR_CSCSHARE_OFFLINE                                    =  1262,  -- (#04EE)
  -- The share is currently offline or does not exist.

  ERROR_PKINIT_FAILURE                                      =  1263,  -- (#04EF)
  -- The Kerberos protocol encountered an error while validating the KDC
  -- certificate during smartcard logon. There is more information in the system
  -- event log.

  ERROR_SMARTCARD_SUBSYSTEM_FAILURE                         =  1264,  -- (#04F0)
  -- The Kerberos protocol encountered an error while attempting to utilize the
  -- smartcard subsystem.

  ERROR_DOWNGRADE_DETECTED                                  =  1265,  -- (#04F1)
  -- The system detected a possible attempt to compromise security. Please
  -- ensure that you can contact the server that authenticated you.

  ERROR_MACHINE_LOCKED                                      =  1271,  -- (#04F7)
  -- The machine is locked and cannot be shut down without the force option.

  ERROR_CALLBACK_SUPPLIED_INVALID_DATA                      =  1273,  -- (#04F9)
  -- An application-defined callback gave invalid data when called.

  ERROR_SYNC_FOREGROUND_REFRESH_REQUIRED                    =  1274,  -- (#04FA)
  -- The group policy framework should call the extension in the synchronous
  -- foreground policy refresh.

  ERROR_DRIVER_BLOCKED                                      =  1275,  -- (#04FB)
  -- This driver has been blocked from loading.
  
  ERROR_INVALID_IMPORT_OF_NON_DLL                           =  1276,  -- (#04FC)
  -- A dynamic link library (DLL) referenced a module that was neither a DLL nor
  -- the process's executable image.

  ERROR_ACCESS_DISABLED_WEBBLADE                            =  1277,  -- (#04FD)
  -- Windows cannot open this program since it has been disabled.

  ERROR_ACCESS_DISABLED_WEBBLADE_TAMPER                     =  1278,  -- (#04FE)
  -- Windows cannot open this program because the license enforcement system has
  -- been tampered with or become corrupted.

  ERROR_RECOVERY_FAILURE                                    =  1279,  -- (#04FF)
  -- A transaction recover failed.

  ERROR_ALREADY_FIBER                                       =  1280,  -- (#0500)
  -- The current thread has already been converted to a fiber.

  ERROR_ALREADY_THREAD                                      =  1281,  -- (#0501)
  -- The current thread has already been converted from a fiber.

  ERROR_STACK_BUFFER_OVERRUN                                =  1282,  -- (#0502)
  -- The system detected an overrun of a stack-based buffer in this application.
  -- This overrun could potentially allow a malicious user to gain control of
  -- this application.

  ERROR_PARAMETER_QUOTA_EXCEEDED                            =  1283,  -- (#0503)
  -- Data present in one of the parameters is more than the function can operate
  -- on.

  ERROR_DEBUGGER_INACTIVE                                   =  1284,  -- (#0504)
  -- An attempt to do an operation on a debug object failed because the object
  -- is in the process of being deleted.

  ERROR_DELAY_LOAD_FAILED                                   =  1285,  -- (#0505)
  -- An attempt to delay-load a .dll or get a function address in a delay-loaded
  -- .dll failed.

  ERROR_VDM_DISALLOWED                                      =  1286,  -- (#0506)
  -- %1 is a 16-bit application. You do not have permissions to execute 16-bit
  -- applications. Check your permissions with your system administrator.

  ERROR_UNIDENTIFIED_ERROR                                  =  1287,  -- (#0507)
  -- Insufficient information exists to identify the cause of failure.

  ERROR_INVALID_CRUNTIME_PARAMETER                          =  1288,  -- (#0508)
  -- The parameter passed to a C runtime function is incorrect.

  ERROR_BEYOND_VDL                                          =  1289,  -- (#0509)
  -- The operation occurred beyond the valid data length of the file.

  ERROR_INCOMPATIBLE_SERVICE_SID_TYPE                       =  1290,  -- (#050A)
  -- The service start failed since one or more services in the same process
  -- have an incompatible service SID type setting. A service with restricted
  -- service SID type can only coexist in the same process with other services
  -- with a restricted SID type. If the service SID type for this service was
  -- just configured, the hosting process must be restarted in order to start
  -- this service.

  ERROR_DRIVER_PROCESS_TERMINATED                           =  1291,  -- (#050B)
  -- The process hosting the driver for this device has been terminated.

  ERROR_IMPLEMENTATION_LIMIT                                =  1292,  -- (#050C)
  -- An operation attempted to exceed an implementation-defined limit.

  ERROR_PROCESS_IS_PROTECTED                                =  1293,  -- (#050D)
  -- Either the target process, or the target thread's containing process, is a
  -- protected process.

  ERROR_SERVICE_NOTIFY_CLIENT_LAGGING                       =  1294,  -- (#050E)
  -- The service notification client is lagging too far behind the current state
  -- of services in the machine.

  ERROR_DISK_QUOTA_EXCEEDED                                 =  1295,  -- (#050F)
  -- The requested file operation failed because the storage quota was exceeded.
  -- To free up disk space, move files to a different location or delete
  -- unnecessary files. For more information, contact your system administrator.

  ERROR_CONTENT_BLOCKED                                     =  1296,  -- (#0510)
  -- The requested file operation failed because the storage policy blocks that
  -- type of file. For more information, contact your system administrator.

  ERROR_INCOMPATIBLE_SERVICE_PRIVILEGE                      =  1297,  -- (#0511)
  -- A privilege that the service requires to function properly does not exist
  -- in the service account configuration. You may use the Services Microsoft
  -- Management Console (MMC) snap-in (services.msc) and the Local Security
  -- Settings MMC snap-in (secpol.msc) to view the service configuration and the
  -- account configuration.

  ERROR_INVALID_LABEL                                       =  1299,  -- (#0513)
  -- Indicates a particular Security ID may not be assigned as the label of an
  -- object.

  ERROR_NOT_ALL_ASSIGNED                                    =  1300,  -- (#0514)
  -- Not all privileges referenced are assigned to the caller.

  ERROR_SOME_NOT_MAPPED                                     =  1301,  -- (#0515)
  -- Some mapping between account names and security IDs was not done.

  ERROR_NO_QUOTAS_FOR_ACCOUNT                               =  1302,  -- (#0516)
  -- No system quota limits are specifically set for this account.

  ERROR_LOCAL_USER_SESSION_KEY                              =  1303,  -- (#0517)
  -- No encryption key is available. A well-known encryption key was returned.

  ERROR_NULL_LM_PASSWORD                                    =  1304,  -- (#0518)
  -- The password is too complex to be converted to a LAN Manager password.
  -- The LAN Manager password returned is a NULL string.

  ERROR_UNKNOWN_REVISION                                    =  1305,  -- (#0519)
  -- The revision level is unknown.

  ERROR_REVISION_MISMATCH                                   =  1306,  -- (#051A)
  -- Indicates two revision levels are incompatible.

  ERROR_INVALID_OWNER                                       =  1307,  -- (#051B)
  -- This security ID may not be assigned as the owner of this object.

  ERROR_INVALID_PRIMARY_GROUP                               =  1308,  -- (#051C)
  -- This security ID may not be assigned as the primary group of an object.

  ERROR_NO_IMPERSONATION_TOKEN                              =  1309,  -- (#051D)
  -- An attempt has been made to operate on an impersonation token by a thread
  -- that is not currently impersonating a client.

  ERROR_CANT_DISABLE_MANDATORY                              =  1310,  -- (#051E)
  -- The group may not be disabled.

  ERROR_NO_LOGON_SERVERS                                    =  1311,  -- (#051F)
  -- There are currently no logon servers available to service the logon
  -- request.

  ERROR_NO_SUCH_LOGON_SESSION                               =  1312,  -- (#0520)
  -- A specified logon session does not exist. It may already have been
  -- terminated.

  ERROR_NO_SUCH_PRIVILEGE                                   =  1313,  -- (#0521)
  -- A specified privilege does not exist.

  ERROR_PRIVILEGE_NOT_HELD                                  =  1314,  -- (#0522)
  -- A required privilege is not held by the client.

  ERROR_INVALID_ACCOUNT_NAME                                =  1315,  -- (#0523)
  -- The name provided is not a properly formed account name.

  ERROR_USER_EXISTS                                         =  1316,  -- (#0524)
  -- The specified user already exists.

  ERROR_NO_SUCH_USER                                        =  1317,  -- (#0525)
  -- The specified user does not exist.

  ERROR_GROUP_EXISTS                                        =  1318,  -- (#0526)
  -- The specified group already exists.

  ERROR_NO_SUCH_GROUP                                       =  1319,  -- (#0527)
  -- The specified group does not exist.

  ERROR_MEMBER_IN_GROUP                                     =  1320,  -- (#0528)
  -- Either the specified user account is already a member of the specified
  -- group, or the specified group cannot be deleted because it contains a
  -- member.

  ERROR_MEMBER_NOT_IN_GROUP                                 =  1321,  -- (#0529)
  -- The specified user account is not a member of the specified group account.

  ERROR_LAST_ADMIN                                          =  1322,  -- (#052A)
  -- The last remaining administration account cannot be disabled or deleted.

  ERROR_WRONG_PASSWORD                                      =  1323,  -- (#052B)
  -- Unable to update the password. The value provided as the current password
  -- is incorrect.

  ERROR_ILL_FORMED_PASSWORD                                 =  1324,  -- (#052C)
  -- Unable to update the password. The value provided for the new password
  -- contains values that are not allowed in passwords.

  ERROR_PASSWORD_RESTRICTION                                =  1325,  -- (#052D)
  -- Unable to update the password. The value provided for the new password does
  -- not meet the length, complexity, or history requirement of the domain.

  ERROR_LOGON_FAILURE                                       =  1326,  -- (#052E)
  -- Logon failure: unknown user name or bad password.

  ERROR_ACCOUNT_RESTRICTION                                 =  1327,  -- (#052F)
  -- Logon failure: user account restriction.

  ERROR_INVALID_LOGON_HOURS                                 =  1328,  -- (#0530)
  -- Logon failure: account logon time restriction violation.

  ERROR_INVALID_WORKSTATION                                 =  1329,  -- (#0531)
  -- Logon failure: user not allowed to log on to this computer.

  ERROR_PASSWORD_EXPIRED                                    =  1330,  -- (#0532)
  -- Logon failure: the specified account password has expired.

  ERROR_ACCOUNT_DISABLED                                    =  1331,  -- (#0533)
  -- Logon failure: account currently disabled.

  ERROR_NONE_MAPPED                                         =  1332,  -- (#0534)
  -- No mapping between account names and security IDs was done.

  ERROR_TOO_MANY_LUIDS_REQUESTED                            =  1333,  -- (#0535)
  -- Too many local user identifiers (LUIDs) were requested at one time.

  ERROR_LUIDS_EXHAUSTED                                     =  1334,  -- (#0536)
  -- No more local user identifiers (LUIDs) are available.

  ERROR_INVALID_SUB_AUTHORITY                               =  1335,  -- (#0537)
  -- The subauthority part of a security ID is invalid for this particular use.

  ERROR_INVALID_ACL                                         =  1336,  -- (#0538)
  -- The access control list (ACL) structure is invalid.

  ERROR_INVALID_SID                                         =  1337,  -- (#0539)
  -- The security ID structure is invalid.

  ERROR_INVALID_SECURITY_DESCR                              =  1338,  -- (#053A)
  -- The security descriptor structure is invalid.

  ERROR_BAD_INHERITANCE_ACL                                 =  1340,  -- (#053C)
  -- The inherited access control list (ACL) or access control entry (ACE)
  -- could not be built.

  ERROR_SERVER_DISABLED                                     =  1341,  -- (#053D)
  -- The server is currently disabled.

  ERROR_SERVER_NOT_DISABLED                                 =  1342,  -- (#053E)
  -- The server is currently enabled.

  ERROR_INVALID_ID_AUTHORITY                                =  1343,  -- (#053F)
  -- The value provided was an invalid value for an identifier authority.

  ERROR_ALLOTTED_SPACE_EXCEEDED                             =  1344,  -- (#0540)
  -- No more memory is available for security information updates.

  ERROR_INVALID_GROUP_ATTRIBUTES                            =  1345,  -- (#0541)
  -- The specified attributes are invalid, or incompatible with the attributes
  -- for the group as a whole.

  ERROR_BAD_IMPERSONATION_LEVEL                             =  1346,  -- (#0542)
  -- Either a required impersonation level was not provided, or the provided
  -- impersonation level is invalid.

  ERROR_CANT_OPEN_ANONYMOUS                                 =  1347,  -- (#0543)
  -- Cannot open an anonymous level security token.

  ERROR_BAD_VALIDATION_CLASS                                =  1348,  -- (#0544)
  -- The validation information class requested was invalid.

  ERROR_BAD_TOKEN_TYPE                                      =  1349,  -- (#0545)
  -- The type of the token is inappropriate for its attempted use.

  ERROR_NO_SECURITY_ON_OBJECT                               =  1350,  -- (#0546)
  -- Unable to perform a security operation on an object that has no associated
  -- security.

  ERROR_CANT_ACCESS_DOMAIN_INFO                             =  1351,  -- (#0547)
  -- Configuration information could not be read from the domain controller,
  -- either because the machine is unavailable, or access has been denied.

  ERROR_INVALID_SERVER_STATE                                =  1352,  -- (#0548)
  -- The security account manager (SAM) r local security authority (LSA)
  -- server was in the wrong state to perform the security operation.

  ERROR_INVALID_DOMAIN_STATE                                =  1353,  -- (#0549)
  -- The domain was in the wrong state to perform the security operation.

  ERROR_INVALID_DOMAIN_ROLE                                 =  1354,  -- (#054A)
  -- This operation is only allowed for the Primary Domain Controller of the
  -- domain.

  ERROR_NO_SUCH_DOMAIN                                      =  1355,  -- (#054B)
  -- The specified domain either does not exist or could not be contacted.

  ERROR_DOMAIN_EXISTS                                       =  1356,  -- (#054C)
  -- The specified domain already exists.

  ERROR_DOMAIN_LIMIT_EXCEEDED                               =  1357,  -- (#054D)
  -- An attempt was made to exceed the limit on the number of domains per
  -- server.

  ERROR_INTERNAL_DB_CORRUPTION                              =  1358,  -- (#054E)
  -- Unable to complete the requested operation because of either a catastrophic
  -- media failure or a data structure corruption on the disk.

  ERROR_INTERNAL_ERROR                                      =  1359,  -- (#054F)
  -- An internal error occurred.

  ERROR_GENERIC_NOT_MAPPED                                  =  1360,  -- (#0550)
  -- Generic access types were contained in an access mask which should already
  -- be mapped to nongeneric types.

  ERROR_BAD_DESCRIPTOR_FORMAT                               =  1361,  -- (#0551)
  -- A security descriptor is not in the right format (absolute or
  -- self-relative).

  ERROR_NOT_LOGON_PROCESS                                   =  1362,  -- (#0552)
  -- The requested action is restricted for use by logon processes only. The
  -- calling process has not registered as a logon process.

  ERROR_LOGON_SESSION_EXISTS                                =  1363,  -- (#0553)
  -- Cannot start a new logon session with an ID that is already in use.

  ERROR_NO_SUCH_PACKAGE                                     =  1364,  -- (#0554)
  -- A specified authentication package is unknown.

  ERROR_BAD_LOGON_SESSION_STATE                             =  1365,  -- (#0555)
  -- The logon session is not in a state that is consistent with the requested
  -- operation.

  ERROR_LOGON_SESSION_COLLISION                             =  1366,  -- (#0556)
  -- The logon session ID is already in use.

  ERROR_INVALID_LOGON_TYPE                                  =  1367,  -- (#0557)
  -- A logon request contained an invalid logon type value.

  ERROR_CANNOT_IMPERSONATE                                  =  1368,  -- (#0558)
  -- Unable to impersonate using a named pipe until data has been read from that
  -- pipe.

  ERROR_RXACT_INVALID_STATE                                 =  1369,  -- (#0559)
  -- The transaction state of a registry subtree is incompatible with the
  -- requested operation.

  ERROR_RXACT_COMMIT_FAILURE                                =  1370,  -- (#055A)
  -- An internal security database corruption has been encountered.

  ERROR_SPECIAL_ACCOUNT                                     =  1371,  -- (#055B)
  -- Cannot perform this operation on built-in accounts.

  ERROR_SPECIAL_GROUP                                       =  1372,  -- (#055C)
  -- Cannot perform this operation on this built-in special group.

  ERROR_SPECIAL_USER                                        =  1373,  -- (#055D)
  -- Cannot perform this operation on this built-in special user.

  ERROR_MEMBERS_PRIMARY_GROUP                               =  1374,  -- (#055E)
  -- The user cannot be removed from a group because the group is currently the
  -- user's primary group.

  ERROR_TOKEN_ALREADY_IN_USE                                =  1375,  -- (#055F)
  -- The token is already in use as a primary token.

  ERROR_NO_SUCH_ALIAS                                       =  1376,  -- (#0560)
  -- The specified local group does not exist.

  ERROR_MEMBER_NOT_IN_ALIAS                                 =  1377,  -- (#0561)
  -- The specified account name is not a member of the local group.

  ERROR_MEMBER_IN_ALIAS                                     =  1378,  -- (#0562)
  -- The specified account name is already a member of the local group.

  ERROR_ALIAS_EXISTS                                        =  1379,  -- (#0563)
  -- The specified local group already exists.

  ERROR_LOGON_NOT_GRANTED                                   =  1380,  -- (#0564)
  -- Logon failure: the user has not been granted the requested logon type at
  -- this computer.

  ERROR_TOO_MANY_SECRETS                                    =  1381,  -- (#0565)
  -- The maximum number of secrets that may be stored in a single system has
  -- been exceeded.

  ERROR_SECRET_TOO_LONG                                     =  1382,  -- (#0566)
  -- The length of a secret exceeds the maximum length allowed.

  ERROR_INTERNAL_DB_ERROR                                   =  1383,  -- (#0567)
  -- The local security authority database contains an internal inconsistency.

  ERROR_TOO_MANY_CONTEXT_IDS                                =  1384,  -- (#0568)
  -- During a logon attempt, the user's security context accumulated too many
  -- security IDs.

  ERROR_LOGON_TYPE_NOT_GRANTED                              =  1385,  -- (#0569)
  -- Logon failure: the user has not been granted the requested logon type at
  -- this computer.

  ERROR_NT_CROSS_ENCRYPTION_REQUIRED                        =  1386,  -- (#056A)
  -- A cross-encrypted password is necessary to change a user password.

  ERROR_NO_SUCH_MEMBER                                      =  1387,  -- (#056B)
  -- A new member could not be added to or removed from the local group because
  -- the member does not exist.

  ERROR_INVALID_MEMBER                                      =  1388,  -- (#056C)
  -- A new member could not be added to a local group because the member has the
  -- wrong account type.

  ERROR_TOO_MANY_SIDS                                       =  1389,  -- (#056D)
  -- Too many security IDs have been specified.

  ERROR_LM_CROSS_ENCRYPTION_REQUIRED                        =  1390,  -- (#056E)
  -- A cross-encrypted password is necessary to change this user password.

  ERROR_NO_INHERITANCE                                      =  1391,  -- (#056F)
  -- Indicates an ACL contains no inheritable components.

  ERROR_FILE_CORRUPT                                        =  1392,  -- (#0570)
  -- The file or directory is corrupted and unreadable.

  ERROR_DISK_CORRUPT                                        =  1393,  -- (#0571)
  -- The disk structure is corrupted and unreadable.

  ERROR_NO_USER_SESSION_KEY                                 =  1394,  -- (#0572)
  -- There is no user session key for the specified logon session.

  ERROR_LICENSE_QUOTA_EXCEEDED                              =  1395,  -- (#0573)
  -- The service being accessed is licensed for a particular number of
  -- connections. No more connections can be made to the service at this time
  -- because there are already as many connections as the service can accept.

  ERROR_WRONG_TARGET_NAME                                   =  1396,  -- (#0574)
  -- Logon Failure: The target account name is incorrect.

  ERROR_MUTUAL_AUTH_FAILED                                  =  1397,  -- (#0575)
  -- Mutual Authentication failed. The server's password is out of date at the
  -- domain controller.

  ERROR_TIME_SKEW                                           =  1398,  -- (#0576)
  -- There is a time difference between the client and server.

  ERROR_CURRENT_DOMAIN_NOT_ALLOWED                          =  1399,  -- (#0577)
  -- This operation can not be performed on the current domain.

  ERROR_INVALID_WINDOW_HANDLE                               =  1400,  -- (#0578)
  -- Invalid window handle.

  ERROR_INVALID_MENU_HANDLE                                 =  1401,  -- (#0579)
  -- Invalid menu handle.

  ERROR_INVALID_CURSOR_HANDLE                               =  1402,  -- (#057A)
  -- Invalid cursor handle.

  ERROR_INVALID_ACCEL_HANDLE                                =  1403,  -- (#057B)
  -- Invalid accelerator table handle.

  ERROR_INVALID_HOOK_HANDLE                                 =  1404,  -- (#057C)
  -- Invalid hook handle.

  ERROR_INVALID_DWP_HANDLE                                  =  1405,  -- (#057D)
  -- Invalid handle to a multiple-window position structure.

  ERROR_TLW_WITH_WSCHILD                                    =  1406,  -- (#057E)
  -- Cannot create a top-level child window.

  ERROR_CANNOT_FIND_WND_CLASS                               =  1407,  -- (#057F)
  -- Cannot find window class.

  ERROR_WINDOW_OF_OTHER_THREAD                              =  1408,  -- (#0580)
  -- Invalid window; it belongs to other thread.

  ERROR_HOTKEY_ALREADY_REGISTERED                           =  1409,  -- (#0581)
  -- Hot key is already registered.

  ERROR_CLASS_ALREADY_EXISTS                                =  1410,  -- (#0582)
  -- Class already exists.

  ERROR_CLASS_DOES_NOT_EXIST                                =  1411,  -- (#0583)
  -- Class does not exist.

  ERROR_CLASS_HAS_WINDOWS                                   =  1412,  -- (#0584)
  -- Class still has open windows.

  ERROR_INVALID_INDEX                                       =  1413,  -- (#0585)
  -- Invalid index.

  ERROR_INVALID_ICON_HANDLE                                 =  1414,  -- (#0586)
  -- Invalid icon handle.

  ERROR_PRIVATE_DIALOG_INDEX                                =  1415,  -- (#0587)
  -- Using private DIALOG window words.

  ERROR_LISTBOX_ID_NOT_FOUND                                =  1416,  -- (#0588)
  -- The list box identifier was not found.

  ERROR_NO_WILDCARD_CHARACTERS                              =  1417,  -- (#0589)
  -- No wildcards were found.

  ERROR_CLIPBOARD_NOT_OPEN                                  =  1418,  -- (#058A)
  -- Thread does not have a clipboard open.

  ERROR_HOTKEY_NOT_REGISTERED                               =  1419,  -- (#058B)
  -- Hot key is not registered.

  ERROR_WINDOW_NOT_DIALOG                                   =  1420,  -- (#058C)
  -- The window is not a valid dialog window.

  ERROR_CONTROL_ID_NOT_FOUND                                =  1421,  -- (#058D)
  -- Control ID not found.

  ERROR_INVALID_COMBOBOX_MESSAGE                            =  1422,  -- (#058E)
  -- Invalid message for a combo box because it does not have an edit control.

  ERROR_WINDOW_NOT_COMBOBOX                                 =  1423,  -- (#058F)
  -- The window is not a combo box.

  ERROR_INVALID_EDIT_HEIGHT                                 =  1424,  -- (#0590)
  -- Height must be less than 256.

  ERROR_DC_NOT_FOUND                                        =  1425,  -- (#0591)
  -- Invalid device context (DC) handle.

  ERROR_INVALID_HOOK_FILTER                                 =  1426,  -- (#0592)
  -- Invalid hook procedure type.

  ERROR_INVALID_FILTER_PROC                                 =  1427,  -- (#0593)
  -- Invalid hook procedure.

  ERROR_HOOK_NEEDS_HMOD                                     =  1428,  -- (#0594)
  -- Cannot set nonlocal hook without a module handle.

  ERROR_GLOBAL_ONLY_HOOK                                    =  1429,  -- (#0595)
  -- This hook procedure can only be set globally.

  ERROR_JOURNAL_HOOK_SET                                    =  1430,  -- (#0596)
  -- The journal hook procedure is already installed.

  ERROR_HOOK_NOT_INSTALLED                                  =  1431,  -- (#0597)
  -- The hook procedure is not installed.

  ERROR_INVALID_LB_MESSAGE                                  =  1432,  -- (#0598)
  -- Invalid message for single-selection list box.

  ERROR_SETCOUNT_ON_BAD_LB                                  =  1433,  -- (#0599)
  -- LB_SETCOUNT sent to non-lazy list box.

  ERROR_LB_WITHOUT_TABSTOPS                                 =  1434,  -- (#059A)
  -- This list box does not support tab stops.

  ERROR_DESTROY_OBJECT_OF_OTHER_THREAD                      =  1435,  -- (#059B)
  -- Cannot destroy object created by another thread.

  ERROR_CHILD_WINDOW_MENU                                   =  1436,  -- (#059C)
  -- Child windows cannot have menus.

  ERROR_NO_SYSTEM_MENU                                      =  1437,  -- (#059D)
  -- The window does not have a system menu.

  ERROR_INVALID_MSGBOX_STYLE                                =  1438,  -- (#059E)
  -- Invalid message box style.

  ERROR_INVALID_SPI_VALUE                                   =  1439,  -- (#059F)
  -- Invalid system-wide (SPI_*) parameter.

  ERROR_SCREEN_ALREADY_LOCKED                               =  1440,  -- (#05A0)
  -- Screen already locked.

  ERROR_HWNDS_HAVE_DIFF_PARENT                              =  1441,  -- (#05A1)
  -- All handles to windows in a multiple-window position structure must have
  -- the same parent.

  ERROR_NOT_CHILD_WINDOW                                    =  1442,  -- (#05A2)
  -- The window is not a child window.

  ERROR_INVALID_GW_COMMAND                                  =  1443,  -- (#05A3)
  -- Invalid GW_* command.

  ERROR_INVALID_THREAD_ID                                   =  1444,  -- (#05A4)
  -- Invalid thread identifier.

  ERROR_NON_MDICHILD_WINDOW                                 =  1445,  -- (#05A5)
  -- Cannot process a message from a window that is not a multiple document
  -- interface (MDI) window.

  ERROR_POPUP_ALREADY_ACTIVE                                =  1446,  -- (#05A6)
  -- Popup menu already active.

  ERROR_NO_SCROLLBARS                                       =  1447,  -- (#05A7)
  -- The window does not have scroll bars.

  ERROR_INVALID_SCROLLBAR_RANGE                             =  1448,  -- (#05A8)
  -- Scroll bar range cannot be greater than MAXLONG.

  ERROR_INVALID_SHOWWIN_COMMAND                             =  1449,  -- (#05A9)
  -- Cannot show or remove the window in the way specified.

  ERROR_NO_SYSTEM_RESOURCES                                 =  1450,  -- (#05AA)
  -- Insufficient system resources exist to complete the requested service.

  ERROR_NONPAGED_SYSTEM_RESOURCES                           =  1451,  -- (#05AB)
  -- Insufficient system resources exist to complete the requested service.

  ERROR_PAGED_SYSTEM_RESOURCES                              =  1452,  -- (#05AC)
  -- Insufficient system resources exist to complete the requested service.

  ERROR_WORKING_SET_QUOTA                                   =  1453,  -- (#05AD)
  -- Insufficient quota to complete the requested service.

  ERROR_PAGEFILE_QUOTA                                      =  1454,  -- (#05AE)
  -- Insufficient quota to complete the requested service.

  ERROR_COMMITMENT_LIMIT                                    =  1455,  -- (#05AF)
  -- The paging file is too small for this operation to complete.

  ERROR_MENU_ITEM_NOT_FOUND                                 =  1456,  -- (#05B0)
  -- A menu item was not found.

  ERROR_INVALID_KEYBOARD_HANDLE                             =  1457,  -- (#05B1)
  -- Invalid keyboard layout handle.

  ERROR_HOOK_TYPE_NOT_ALLOWED                               =  1458,  -- (#05B2)
  -- Hook type not allowed.

  ERROR_REQUIRES_INTERACTIVE_WINDOWSTATION                  =  1459,  -- (#05B3)
  -- This operation requires an interactive window station.

  ERROR_TIMEOUT                                             =  1460,  -- (#05B4)
  -- This operation returned because the timeout period expired.

  ERROR_INVALID_MONITOR_HANDLE                              =  1461,  -- (#05B5)
  -- Invalid monitor handle.

  ERROR_INCORRECT_SIZE                                      =  1462,  -- (#05B6)
  -- Incorrect size argument.

  ERROR_SYMLINK_CLASS_DISABLED                              =  1463,  -- (#05B7)
  -- The symbolic link cannot be followed because its type is disabled.

  ERROR_SYMLINK_NOT_SUPPORTED                               =  1464,  -- (#05B8)
  -- This application does not support the current operation on symbolic links.

  ERROR_XML_PARSE_ERROR                                     =  1465,  -- (#05B9)
  -- Windows was unable to parse the requested XML data.

  ERROR_XMLDSIG_ERROR                                       =  1466,  -- (#05BA)
  -- An error was encountered while processing an XML digital signature.

  ERROR_RESTART_APPLICATION                                 =  1467,  -- (#05BB)
  -- This application must be restarted.

  ERROR_WRONG_COMPARTMENT                                   =  1468,  -- (#05BC)
  -- The caller made the connection request in the wrong routing compartment.

  ERROR_AUTHIP_FAILURE                                      =  1469,  -- (#05BD)
  -- There was an AuthIP failure when attempting to connect to the remote host.

  ERROR_NO_NVRAM_RESOURCES                                  =  1470,  -- (#05BE)
  -- Insufficient NVRAM resources exist to complete the requested service. A
  -- reboot might be required.

  ERROR_EVENTLOG_FILE_CORRUPT                               =  1500,  -- (#05DC)
  -- The event log file is corrupted.

  ERROR_EVENTLOG_CANT_START                                 =  1501,  -- (#05DD)
  -- No event log file could be opened, so the event logging service did not
  -- start.

  ERROR_LOG_FILE_FULL                                       =  1502,  -- (#05DE)
  -- The event log file is full.

  ERROR_EVENTLOG_FILE_CHANGED                               =  1503,  -- (#05DF)
  -- The event log file has changed between read operations.

  ERROR_INVALID_TASK_NAME                                   =  1550,  -- (#060E)
  -- The specified task name is invalid.

  ERROR_INVALID_TASK_INDEX                                  =  1551,  -- (#060F)
  -- The specified task index is invalid.

  ERROR_THREAD_ALREADY_IN_TASK                              =  1552,  -- (#0610)
  -- The specified thread is already joining a task.

  ERROR_INSTALL_SERVICE_FAILURE                             =  1601,  -- (#0641)
  -- The Windows Installer service could not be accessed. Contact your support
  -- personnel to verify that the Windows Installer service is properly
  -- registered.

  ERROR_INSTALL_USEREXIT                                    =  1602,  -- (#0642)
  -- User cancelled installation.

  ERROR_INSTALL_FAILURE                                     =  1603,  -- (#0643)
  -- Fatal error during installation.

  ERROR_INSTALL_SUSPEND                                     =  1604,  -- (#0644)
  -- Installation suspended, incomplete.

  ERROR_UNKNOWN_PRODUCT                                     =  1605,  -- (#0645)
  -- This action is only valid for products that are currently installed.

  ERROR_UNKNOWN_FEATURE                                     =  1606,  -- (#0646)
  -- Feature ID not registered.

  ERROR_UNKNOWN_COMPONENT                                   =  1607,  -- (#0647)
  -- Component ID not registered.

  ERROR_UNKNOWN_PROPERTY                                    =  1608,  -- (#0648)
  -- Unknown property.

  ERROR_INVALID_HANDLE_STATE                                =  1609,  -- (#0649)
  -- Handle is in an invalid state.

  ERROR_BAD_CONFIGURATION                                   =  1610,  -- (#064A)
  -- The configuration data for this product is corrupt. Contact your support
  -- personnel.

  ERROR_INDEX_ABSENT                                        =  1611,  -- (#064B)
  -- Component qualifier not present.

  ERROR_INSTALL_SOURCE_ABSENT                               =  1612,  -- (#064C)
  -- The installation source for this product is not available. Verify that the
  -- source exists and that you can access it.

  ERROR_INSTALL_PACKAGE_VERSION                             =  1613,  -- (#064D)
  -- This installation package cannot be installed by the Windows Installer
  -- service. You must install a Windows service pack that contains a newer
  -- version of the Windows Installer service.

  ERROR_PRODUCT_UNINSTALLED                                 =  1614,  -- (#064E)
  -- Product is uninstalled.

  ERROR_BAD_QUERY_SYNTAX                                    =  1615,  -- (#064F)
  -- SQL query syntax invalid or unsupported.

  ERROR_INVALID_FIELD                                       =  1616,  -- (#0650)
  -- Record field does not exist.

  ERROR_DEVICE_REMOVED                                      =  1617,  -- (#0651)
  -- The device has been removed.

  ERROR_INSTALL_ALREADY_RUNNING                             =  1618,  -- (#0652)
  -- Another installation is already in progress. Complete that installation
  -- before proceeding with this install.

  ERROR_INSTALL_PACKAGE_OPEN_FAILED                         =  1619,  -- (#0653)
  -- This installation package could not be opened. Verify that the package
  -- exists and that you can access it, or contact the application vendor to
  -- verify that this is a valid Windows Installer package.

  ERROR_INSTALL_PACKAGE_INVALID                             =  1620,  -- (#0654)
  -- This installation package could not be opened. Contact the application
  -- vendor to verify that this is a valid Windows Installer package.

  ERROR_INSTALL_UI_FAILURE                                  =  1621,  -- (#0655)
  -- There was an error starting the Windows Installer service user interface.
  -- Contact your support personnel.

  ERROR_INSTALL_LOG_FAILURE                                 =  1622,  -- (#0656)
  -- Error opening installation log file. Verify that the specified log file
  -- location exists and that you can write to it.

  ERROR_INSTALL_LANGUAGE_UNSUPPORTED                        =  1623,  -- (#0657)
  -- The language of this installation package is not supported by your system.

  ERROR_INSTALL_TRANSFORM_FAILURE                           =  1624,  -- (#0658)
  -- Error applying transforms. Verify that the specified transform paths are
  -- valid.

  ERROR_INSTALL_PACKAGE_REJECTED                            =  1625,  -- (#0659)
  -- This installation is forbidden by system policy. Contact your system
  -- administrator.

  ERROR_FUNCTION_NOT_CALLED                                 =  1626,  -- (#065A)
  -- Function could not be executed.

  ERROR_FUNCTION_FAILED                                     =  1627,  -- (#065B)
  -- Function failed during execution.

  ERROR_INVALID_TABLE                                       =  1628,  -- (#065C)
  -- Invalid or unknown table specified.

  ERROR_DATATYPE_MISMATCH                                   =  1629,  -- (#065D)
  -- Data supplied is of wrong type.

  ERROR_UNSUPPORTED_TYPE                                    =  1630,  -- (#065E)
  -- Data of this type is not supported.

  ERROR_CREATE_FAILED                                       =  1631,  -- (#065F)
  -- The Windows Installer service failed to start. Contact your support
  -- personnel.

  ERROR_INSTALL_TEMP_UNWRITABLE                             =  1632,  -- (#0660)
  -- The temp folder is either full or inaccessible. Verify that the temp folder
  -- exists and that you can write to it.

  ERROR_INSTALL_PLATFORM_UNSUPPORTED                        =  1633,  -- (#0661)
  -- This installation package is not supported by this processor type. Contact
  -- your product vendor.

  ERROR_INSTALL_NOTUSED                                     =  1634,  -- (#0662)
  -- Component not used on this computer.

  ERROR_PATCH_PACKAGE_OPEN_FAILED                           =  1635,  -- (#0663)
  -- This patch package could not be opened. Verify that the patch package
  -- exists and that you can access it, or contact the application vendor to
  -- verify that this is a valid Windows Installer patch package.

  ERROR_PATCH_PACKAGE_INVALID                               =  1636,  -- (#0664)
  -- This patch package could not be opened. Contact the application vendor to
  -- verify that this is a valid Windows Installer patch package.

  ERROR_PATCH_PACKAGE_UNSUPPORTED                           =  1637,  -- (#0665)
  -- This patch package cannot be processed by the Windows Installer service.
  -- You must install a Windows service pack that contains a newer version of
  -- the Windows Installer service.

  ERROR_PRODUCT_VERSION                                     =  1638,  -- (#0666)
  -- Another version of this product is already installed. Installation of this
  -- version cannot continue. To configure or remove the existing version of
  -- this product, use Add/Remove Programs on the Control Panel.

  ERROR_INVALID_COMMAND_LINE                                =  1639,  -- (#0667)
  -- Invalid command line argument. Consult the Windows Installer SDK for
  -- detailed command line help.

  ERROR_INSTALL_REMOTE_DISALLOWED                           =  1640,  -- (#0668)
  -- Only administrators have permission to add, remove, or configure server
  -- software during a Terminal Services remote session. If you want to install
  -- or configure software on the server, contact your network administrator.

  ERROR_SUCCESS_REBOOT_INITIATED                            =  1641,  -- (#0669)
  -- The requested operation completed successfully. The system will be
  -- restarted so the changes can take effect.

  ERROR_PATCH_TARGET_NOT_FOUND                              =  1642,  -- (#066A)
  -- The upgrade patch cannot be installed by the Windows Installer service
  -- because the program to be upgraded may be missing, or the upgrade patch may
  -- update a different version of the program. Verify that the program to be
  -- upgraded exists on your computer and that you have the correct upgrade
  -- patch.

  ERROR_PATCH_PACKAGE_REJECTED                              =  1643,  -- (#066B)
  -- The patch package is not permitted by system policy. It is not signed with
  -- an appropriate certificate.

  ERROR_INSTALL_TRANSFORM_REJECTED                          =  1644,  -- (#066C)
  -- One or more customizations are not permitted by system policy. They are not
  -- signed with an appropriate certificate.

  ERROR_INSTALL_REMOTE_PROHIBITED                           =  1645,  -- (#066D)
  -- The Windows Installer does not permit installation from a Remote Desktop
  -- Connection.

  ERROR_PATCH_REMOVAL_UNSUPPORTED                           =  1646,  -- (#066E)
  -- Uninstallation of the update package is not supported.

  ERROR_UNKNOWN_PATCH                                       =  1647,  -- (#066F)
  -- The update is not applied to this product.

  ERROR_PATCH_NO_SEQUENCE                                   =  1648,  -- (#0670)
  -- No valid sequence could be found for the set of updates.

  ERROR_PATCH_REMOVAL_DISALLOWED                            =  1649,  -- (#0671)
  -- Update removal was disallowed by policy.

  ERROR_INVALID_PATCH_XML                                   =  1650,  -- (#0672)
  -- The XML update data is invalid.

  ERROR_PATCH_MANAGED_ADVERTISED_PRODUCT                    =  1651,  -- (#0673)
  -- Windows Installer does not permit updating of managed advertised products.
  -- At least one feature of the product must be installed before applying the
  -- update.

  ERROR_INSTALL_SERVICE_SAFEBOOT                            =  1652,  -- (#0674)
  -- The Windows Installer service is not accessible in Safe Mode. Please try
  -- again when your computer is not in Safe Mode or you can use System Restore
  -- to return your machine to a previous good state.

  ERROR_FAIL_FAST_EXCEPTION                                 =  1653,  -- (#0675)
  -- A fail fast exception occurred.  Exception handlers will not be invoked and
  -- the process will be terminated immediately.

  RPC_S_INVALID_STRING_BINDING                              =  1700,  -- (#06A4)
  -- The string binding is invalid.

  RPC_S_WRONG_KIND_OF_BINDING                               =  1701,  -- (#06A5)
  -- The binding handle is not the correct type.

  RPC_S_INVALID_BINDING                                     =  1702,  -- (#06A6)
  -- The binding handle is invalid.

  RPC_S_PROTSEQ_NOT_SUPPORTED                               =  1703,  -- (#06A7)
  -- The RPC protocol sequence is not supported.

  RPC_S_INVALID_RPC_PROTSEQ                                 =  1704,  -- (#06A8)
  -- The RPC protocol sequence is invalid.

  RPC_S_INVALID_STRING_UUID                                 =  1705,  -- (#06A9)
  -- The string universal unique identifier (UUID) is invalid.

  RPC_S_INVALID_ENDPOINT_FORMAT                             =  1706,  -- (#06AA)
  -- The endpoint format is invalid.

  RPC_S_INVALID_NET_ADDR                                    =  1707,  -- (#06AB)
  -- The network address is invalid.

  RPC_S_NO_ENDPOINT_FOUND                                   =  1708,  -- (#06AC)
  -- No endpoint was found.

  RPC_S_INVALID_TIMEOUT                                     =  1709,  -- (#06AD)
  -- The timeout value is invalid.

  RPC_S_OBJECT_NOT_FOUND                                    =  1710,  -- (#06AE)
  -- The object universal unique identifier (UUID) was not found.

  RPC_S_ALREADY_REGISTERED                                  =  1711,  -- (#06AF)
  -- The object universal unique identifier (UUID) has already been registered.

  RPC_S_TYPE_ALREADY_REGISTERED                             =  1712,  -- (#06B0)
  -- The type universal unique identifier (UUID) has already been registered.

  RPC_S_ALREADY_LISTENING                                   =  1713,  -- (#06B1)
  -- The RPC server is already listening.

  RPC_S_NO_PROTSEQS_REGISTERED                              =  1714,  -- (#06B2)
  -- No protocol sequences have been registered.

  RPC_S_NOT_LISTENING                                       =  1715,  -- (#06B3)
  -- The RPC server is not listening.

  RPC_S_UNKNOWN_MGR_TYPE                                    =  1716,  -- (#06B4)
  -- The manager type is unknown.

  RPC_S_UNKNOWN_IF                                          =  1717,  -- (#06B5)
  -- The interface is unknown.

  RPC_S_NO_BINDINGS                                         =  1718,  -- (#06B6)
  -- There are no bindings.

  RPC_S_NO_PROTSEQS                                         =  1719,  -- (#06B7)
  -- There are no protocol sequences.

  RPC_S_CANT_CREATE_ENDPOINT                                =  1720,  -- (#06B8)
  -- The endpoint cannot be created.

  RPC_S_OUT_OF_RESOURCES                                    =  1721,  -- (#06B9)
  -- Not enough resources are available to complete this operation.

  RPC_S_SERVER_UNAVAILABLE                                  =  1722,  -- (#06BA)
  -- The RPC server is unavailable.

  RPC_S_SERVER_TOO_BUSY                                     =  1723,  -- (#06BB)
  -- The RPC server is too busy to complete this operation.

  RPC_S_INVALID_NETWORK_OPTIONS                             =  1724,  -- (#06BC)
  -- The network options are invalid.

  RPC_S_NO_CALL_ACTIVE                                      =  1725,  -- (#06BD)
  -- There are no remote procedure calls active on this thread.

  RPC_S_CALL_FAILED                                         =  1726,  -- (#06BE)
  -- The remote procedure call failed.

  RPC_S_CALL_FAILED_DNE                                     =  1727,  -- (#06BF)
  -- The remote procedure call failed and did not execute.

  RPC_S_PROTOCOL_ERROR                                      =  1728,  -- (#06C0)
  -- A remote procedure call (RPC) protocol error occurred.

  RPC_S_PROXY_ACCESS_DENIED                                 =  1729,  -- (#06C1)
  -- Access to the HTTP proxy is denied.

  RPC_S_UNSUPPORTED_TRANS_SYN                               =  1730,  -- (#06C2)
  -- The transfer syntax is not supported by the RPC server.

  RPC_S_UNSUPPORTED_TYPE                                    =  1732,  -- (#06C4)
  -- The universal unique identifier (UUID) type is not supported.

  RPC_S_INVALID_TAG                                         =  1733,  -- (#06C5)
  -- The tag is invalid.

  RPC_S_INVALID_BOUND                                       =  1734,  -- (#06C6)
  -- The array bounds are invalid.

  RPC_S_NO_ENTRY_NAME                                       =  1735,  -- (#06C7)
  -- The binding does not contain an entry name.

  RPC_S_INVALID_NAME_SYNTAX                                 =  1736,  -- (#06C8)
  -- The name syntax is invalid.

  RPC_S_UNSUPPORTED_NAME_SYNTAX                             =  1737,  -- (#06C9)
  -- The name syntax is not supported.

  RPC_S_UUID_NO_ADDRESS                                     =  1739,  -- (#06CB)
  -- No network address is available to use to construct a universal unique
  -- identifier (UUID).

  RPC_S_DUPLICATE_ENDPOINT                                  =  1740,  -- (#06CC)
  -- The endpoint is a duplicate.

  RPC_S_UNKNOWN_AUTHN_TYPE                                  =  1741,  -- (#06CD)
  -- The authentication type is unknown.

  RPC_S_MAX_CALLS_TOO_SMALL                                 =  1742,  -- (#06CE)
  -- The maximum number of calls is too small.

  RPC_S_STRING_TOO_LONG                                     =  1743,  -- (#06CF)
  -- The string is too long.

  RPC_S_PROTSEQ_NOT_FOUND                                   =  1744,  -- (#06D0)
  -- The RPC protocol sequence was not found.

  RPC_S_PROCNUM_OUT_OF_RANGE                                =  1745,  -- (#06D1)
  -- The procedure number is out of range.

  RPC_S_BINDING_HAS_NO_AUTH                                 =  1746,  -- (#06D2)
  -- The binding does not contain any authentication information.

  RPC_S_UNKNOWN_AUTHN_SERVICE                               =  1747,  -- (#06D3)
  -- The authentication service is unknown.

  RPC_S_UNKNOWN_AUTHN_LEVEL                                 =  1748,  -- (#06D4)
  -- The authentication level is unknown.

  RPC_S_INVALID_AUTH_IDENTITY                               =  1749,  -- (#06D5)
  -- The security context is invalid.

  RPC_S_UNKNOWN_AUTHZ_SERVICE                               =  1750,  -- (#06D6)
  -- The authorization service is unknown.

  EPT_S_INVALID_ENTRY                                       =  1751,  -- (#06D7)
  -- The entry is invalid.

  EPT_S_CANT_PERFORM_OP                                     =  1752,  -- (#06D8)
  -- The server endpoint cannot perform the operation.

  EPT_S_NOT_REGISTERED                                      =  1753,  -- (#06D9)
  -- There are no more endpoints available from the endpoint mapper.

  RPC_S_NOTHING_TO_EXPORT                                   =  1754,  -- (#06DA)
  -- No interfaces have been exported.

  RPC_S_INCOMPLETE_NAME                                     =  1755,  -- (#06DB)
  -- The entry name is incomplete.

  RPC_S_INVALID_VERS_OPTION                                 =  1756,  -- (#06DC)
  -- The version option is invalid.

  RPC_S_NO_MORE_MEMBERS                                     =  1757,  -- (#06DD)
  -- There are no more members.

  RPC_S_NOT_ALL_OBJS_UNEXPORTED                             =  1758,  -- (#06DE)
  -- There is nothing to unexport.

  RPC_S_INTERFACE_NOT_FOUND                                 =  1759,  -- (#06DF)
  -- The interface was not found.

  RPC_S_ENTRY_ALREADY_EXISTS                                =  1760,  -- (#06E0)
  -- The entry already exists.

  RPC_S_ENTRY_NOT_FOUND                                     =  1761,  -- (#06E1)
  -- The entry is not found.

  RPC_S_NAME_SERVICE_UNAVAILABLE                            =  1762,  -- (#06E2)
  -- The name service is unavailable.

  RPC_S_INVALID_NAF_ID                                      =  1763,  -- (#06E3)
  -- The network address family is invalid.

  RPC_S_CANNOT_SUPPORT                                      =  1764,  -- (#06E4)
  -- The requested operation is not supported.

  RPC_S_NO_CONTEXT_AVAILABLE                                =  1765,  -- (#06E5)
  -- No security context is available to allow impersonation.

  RPC_S_INTERNAL_ERROR                                      =  1766,  -- (#06E6)
  -- An internal error occurred in a remote procedure call (RPC).

  RPC_S_ZERO_DIVIDE                                         =  1767,  -- (#06E7)
  -- The RPC server attempted an integer division by zero.

  RPC_S_ADDRESS_ERROR                                       =  1768,  -- (#06E8)
  -- An addressing error occurred in the RPC server.

  RPC_S_FP_DIV_ZERO                                         =  1769,  -- (#06E9)
  -- A floating-point operation at the RPC server caused a division by zero.

  RPC_S_FP_UNDERFLOW                                        =  1770,  -- (#06EA)
  -- A floating-point underflow occurred at the RPC server.

  RPC_S_FP_OVERFLOW                                         =  1771,  -- (#06EB)
  -- A floating-point overflow occurred at the RPC server.

  RPC_X_NO_MORE_ENTRIES                                     =  1772,  -- (#06EC)
  -- The list of RPC servers available for the binding of auto handles has been
  -- exhausted.

  RPC_X_SS_CHAR_TRANS_OPEN_FAIL                             =  1773,  -- (#06ED)
  -- Unable to open the character translation table file.

  RPC_X_SS_CHAR_TRANS_SHORT_FILE                            =  1774,  -- (#06EE)
  -- The file containing the character translation table has fewer than 512
  -- bytes.

  RPC_X_SS_IN_NULL_CONTEXT                                  =  1775,  -- (#06EF)
  -- A null context handle was passed from the client to the host during a
  -- remote procedure call.

  RPC_X_SS_CONTEXT_DAMAGED                                  =  1777,  -- (#06F1)
  -- The context handle changed during a remote procedure call.

  RPC_X_SS_HANDLES_MISMATCH                                 =  1778,  -- (#06F2)
  -- The binding handles passed to a remote procedure call do not match.

  RPC_X_SS_CANNOT_GET_CALL_HANDLE                           =  1779,  -- (#06F3)
  -- The stub is unable to get the remote procedure call handle.

  RPC_X_NULL_REF_POINTER                                    =  1780,  -- (#06F4)
  -- A null reference pointer was passed to the stub.

  RPC_X_ENUM_VALUE_OUT_OF_RANGE                             =  1781,  -- (#06F5)
  -- The enumeration value is out of range.

  RPC_X_BYTE_COUNT_TOO_SMALL                                =  1782,  -- (#06F6)
  -- The byte count is too small.

  RPC_X_BAD_STUB_DATA                                       =  1783,  -- (#06F7)
  -- The stub received bad data.

  ERROR_INVALID_USER_BUFFER                                 =  1784,  -- (#06F8)
  -- The supplied user buffer is not valid for the requested operation.

  ERROR_UNRECOGNIZED_MEDIA                                  =  1785,  -- (#06F9)
  -- The disk media is not recognized. It may not be formatted.

  ERROR_NO_TRUST_LSA_SECRET                                 =  1786,  -- (#06FA)
  -- The workstation does not have a trust secret.

  ERROR_NO_TRUST_SAM_ACCOUNT                                =  1787,  -- (#06FB)
  -- The security database on the server does not have a computer account for
  -- this workstation trust relationship.

  ERROR_TRUSTED_DOMAIN_FAILURE                              =  1788,  -- (#06FC)
  -- The trust relationship between the primary domain and the trusted domain
  -- failed.

  ERROR_TRUSTED_RELATIONSHIP_FAILURE                        =  1789,  -- (#06FD)
  -- The trust relationship between this workstation and the primary domain
  -- failed.

  ERROR_TRUST_FAILURE                                       =  1790,  -- (#06FE)
  -- The network logon failed.

  RPC_S_CALL_IN_PROGRESS                                    =  1791,  -- (#06FF)
  -- A remote procedure call is already in progress for this thread.

  ERROR_NETLOGON_NOT_STARTED                                =  1792,  -- (#0700)
  -- An attempt was made to logon, but the network logon service was not
  -- started.

  ERROR_ACCOUNT_EXPIRED                                     =  1793,  -- (#0701)
  -- The user's account has expired.

  ERROR_REDIRECTOR_HAS_OPEN_HANDLES                         =  1794,  -- (#0702)
  -- The redirector is in use and cannot be unloaded.

  ERROR_PRINTER_DRIVER_ALREADY_INSTALLED                    =  1795,  -- (#0703)
  -- The specified printer driver is already installed.

  ERROR_UNKNOWN_PORT                                        =  1796,  -- (#0704)
  -- The specified port is unknown.

  ERROR_UNKNOWN_PRINTER_DRIVER                              =  1797,  -- (#0705)
  -- The printer driver is unknown.

  ERROR_UNKNOWN_PRINTPROCESSOR                              =  1798,  -- (#0706)
  -- The print processor is unknown.

  ERROR_INVALID_SEPARATOR_FILE                              =  1799,  -- (#0707)
  -- The specified separator file is invalid.

  ERROR_INVALID_PRIORITY                                    =  1800,  -- (#0708)
  -- The specified priority is invalid.

  ERROR_INVALID_PRINTER_NAME                                =  1801,  -- (#0709)
  -- The printer name is invalid.

  ERROR_PRINTER_ALREADY_EXISTS                              =  1802,  -- (#070A)
  -- The printer already exists.

  ERROR_INVALID_PRINTER_COMMAND                             =  1803,  -- (#070B)
  -- The printer command is invalid.

  ERROR_INVALID_DATATYPE                                    =  1804,  -- (#070C)
  -- The specified datatype is invalid.

  ERROR_INVALID_ENVIRONMENT                                 =  1805,  -- (#070D)
  -- The environment specified is invalid.

  RPC_S_NO_MORE_BINDINGS                                    =  1806,  -- (#070E)
  -- There are no more bindings.

  ERROR_NOLOGON_INTERDOMAIN_TRUST_ACCOUNT                   =  1807,  -- (#070F)
  -- The account used is an interdomain trust account. Use your public user
  -- account or local user account to access this server.

  ERROR_NOLOGON_WORKSTATION_TRUST_ACCOUNT                   =  1808,  -- (#0710)
  -- The account used is a computer account. Use your public user account or
  -- local user account to access this server.

  ERROR_NOLOGON_SERVER_TRUST_ACCOUNT                        =  1809,  -- (#0711)
  -- The account used is a server trust account. Use your public user account or
  -- local user account to access this server.

  ERROR_DOMAIN_TRUST_INCONSISTENT                           =  1810,  -- (#0712)
  -- The name or security ID (SID) of the domain specified is inconsistent with
  -- the trust information for that domain.

  ERROR_SERVER_HAS_OPEN_HANDLES                             =  1811,  -- (#0713)
  -- The server is in use and cannot be unloaded.

  ERROR_RESOURCE_DATA_NOT_FOUND                             =  1812,  -- (#0714)
  -- The specified image file did not contain a resource section.

  ERROR_RESOURCE_TYPE_NOT_FOUND                             =  1813,  -- (#0715)
  -- The specified resource type cannot be found in the image file.

  ERROR_RESOURCE_NAME_NOT_FOUND                             =  1814,  -- (#0716)
  -- The specified resource name cannot be found in the image file.

  ERROR_RESOURCE_LANG_NOT_FOUND                             =  1815,  -- (#0717)
  -- The specified resource language ID cannot be found in the image file.

  ERROR_NOT_ENOUGH_QUOTA                                    =  1816,  -- (#0718)
  -- Not enough quota is available to process this command.

  RPC_S_NO_INTERFACES                                       =  1817,  -- (#0719)
  -- No interfaces have been registered.

  RPC_S_CALL_CANCELLED                                      =  1818,  -- (#071A)
  -- The remote procedure call was cancelled.

  RPC_S_BINDING_INCOMPLETE                                  =  1819,  -- (#071B)
  -- The binding handle does not contain all required information.

  RPC_S_COMM_FAILURE                                        =  1820,  -- (#071C)
  -- A communications failure occurred during a remote procedure call.

  RPC_S_UNSUPPORTED_AUTHN_LEVEL                             =  1821,  -- (#071D)
  -- The requested authentication level is not supported.

  RPC_S_NO_PRINC_NAME                                       =  1822,  -- (#071E)
  -- No principal name registered.

  RPC_S_NOT_RPC_ERROR                                       =  1823,  -- (#071F)
  -- The error specified is not a valid Windows RPC error code.

  RPC_S_UUID_LOCAL_ONLY                                     =  1824,  -- (#0720)
  -- A UUID that is valid only on this computer has been allocated.

  RPC_S_SEC_PKG_ERROR                                       =  1825,  -- (#0721)
  -- A security package specific error occurred.

  RPC_S_NOT_CANCELLED                                       =  1826,  -- (#0722)
  -- Thread is not canceled.

  RPC_X_INVALID_ES_ACTION                                   =  1827,  -- (#0723)
  -- Invalid operation on the encoding/decoding handle.

  RPC_X_WRONG_ES_VERSION                                    =  1828,  -- (#0724)
  -- Incompatible version of the serializing package.

  RPC_X_WRONG_STUB_VERSION                                  =  1829,  -- (#0725)
  -- Incompatible version of the RPC stub.

  RPC_X_INVALID_PIPE_OBJECT                                 =  1830,  -- (#0726)
  -- The RPC pipe object is invalid or corrupted.

  RPC_X_WRONG_PIPE_ORDER                                    =  1831,  -- (#0727)
  -- An invalid operation was attempted on an RPC pipe object.

  RPC_X_WRONG_PIPE_VERSION                                  =  1832,  -- (#0728)
  -- Unsupported RPC pipe version.

  RPC_S_COOKIE_AUTH_FAILED                                  =  1833,  -- (#0729)
  -- HTTP proxy server rejected the connection because the cookie authentication
  -- failed.

  RPC_S_GROUP_MEMBER_NOT_FOUND                              =  1898,  -- (#076A)
  -- The group member was not found.

  EPT_S_CANT_CREATE                                         =  1899,  -- (#076B)
  -- The endpoint mapper database entry could not be created.

  RPC_S_INVALID_OBJECT                                      =  1900,  -- (#076C)
  -- The object universal unique identifier (UUID) is the nil UUID.

  ERROR_INVALID_TIME                                        =  1901,  -- (#076D)
  -- The specified time is invalid.

  ERROR_INVALID_FORM_NAME                                   =  1902,  -- (#076E)
  -- The specified form name is invalid.

  ERROR_INVALID_FORM_SIZE                                   =  1903,  -- (#076F)
  -- The specified form size is invalid.

  ERROR_ALREADY_WAITING                                     =  1904,  -- (#0770)
  -- The specified printer handle is already being waited on.
  
  ERROR_PRINTER_DELETED                                     =  1905,  -- (#0771)
  -- The specified printer has been deleted.

  ERROR_INVALID_PRINTER_STATE                               =  1906,  -- (#0772)
  -- The state of the printer is invalid.

  ERROR_PASSWORD_MUST_CHANGE                                =  1907,  -- (#0773)
  -- The user's password must be changed before logging on the first time.

  ERROR_DOMAIN_CONTROLLER_NOT_FOUND                         =  1908,  -- (#0774)
  -- Could not find the domain controller for this domain.

  ERROR_ACCOUNT_LOCKED_OUT                                  =  1909,  -- (#0775)
  -- The referenced account is currently locked out and may not be logged on to.

  OR_INVALID_OXID                                           =  1910,  -- (#0776)
  -- The object exporter specified was not found.

  OR_INVALID_OID                                            =  1911,  -- (#0777)
  -- The object specified was not found.

  OR_INVALID_SET                                            =  1912,  -- (#0778)
  -- The object resolver set specified was not found.

  RPC_S_SEND_INCOMPLETE                                     =  1913,  -- (#0779)
  -- Some data remains to be sent in the request buffer.

  RPC_S_INVALID_ASYNC_HANDLE                                =  1914,  -- (#077A)
  -- Invalid asynchronous remote procedure call handle.

  RPC_S_INVALID_ASYNC_CALL                                  =  1915,  -- (#077B)
  -- Invalid asynchronous RPC call handle for this operation.

  RPC_X_PIPE_CLOSED                                         =  1916,  -- (#077C)
  -- The RPC pipe object has already been closed.

  RPC_X_PIPE_DISCIPLINE_ERROR                               =  1917,  -- (#077D)
  -- The RPC call completed before all pipes were processed.

  RPC_X_PIPE_EMPTY                                          =  1918,  -- (#077E)
  -- No more data is available from the RPC pipe.

  ERROR_NO_SITENAME                                         =  1919,  -- (#077F)
  -- No site name is available for this machine.

  ERROR_CANT_ACCESS_FILE                                    =  1920,  -- (#0780)
  -- The file can not be accessed by the system.

  ERROR_CANT_RESOLVE_FILENAME                               =  1921,  -- (#0781)
  -- The name of the file cannot be resolved by the system.

  RPC_S_ENTRY_TYPE_MISMATCH                                 =  1922,  -- (#0782)
  -- The entry is not of the expected type.

  RPC_S_NOT_ALL_OBJS_EXPORTED                               =  1923,  -- (#0783)
  -- Not all object UUIDs could be exported to the specified entry.

  RPC_S_INTERFACE_NOT_EXPORTED                              =  1924,  -- (#0784)
  -- Interface could not be exported to the specified entry.

  RPC_S_PROFILE_NOT_ADDED                                   =  1925,  -- (#0785)
  -- The specified profile entry could not be added.

  RPC_S_PRF_ELT_NOT_ADDED                                   =  1926,  -- (#0786)
  -- The specified profile element could not be added.

  RPC_S_PRF_ELT_NOT_REMOVED                                 =  1927,  -- (#0787)
  -- The specified profile element could not be removed.

  RPC_S_GRP_ELT_NOT_ADDED                                   =  1928,  -- (#0788)
  -- The group element could not be added.

  RPC_S_GRP_ELT_NOT_REMOVED                                 =  1929,  -- (#0789)
  -- The group element could not be removed.

  ERROR_KM_DRIVER_BLOCKED                                   =  1930,  -- (#078A)
  -- The printer driver is not compatible with a policy enabled on your computer
  -- that blocks NT 4.0 drivers.

  ERROR_CONTEXT_EXPIRED                                     =  1931,  -- (#078B)
  -- The context has expired and can no longer be used.

  ERROR_PER_USER_TRUST_QUOTA_EXCEEDED                       =  1932,  -- (#078C)
  -- The current user's delegated trust creation quota has been exceeded.

  ERROR_ALL_USER_TRUST_QUOTA_EXCEEDED                       =  1933,  -- (#078D)
  -- The total delegated trust creation quota has been exceeded.

  ERROR_USER_DELETE_TRUST_QUOTA_EXCEEDED                    =  1934,  -- (#078E)
  -- The current user's delegated trust deletion quota has been exceeded.

  ERROR_AUTHENTICATION_FIREWALL_FAILED                      =  1935,  -- (#078F)
  -- Logon Failure: The machine you are logging onto is protected by an
  -- authentication firewall. The specified account is not allowed to
  -- authenticate to the machine.

  ERROR_REMOTE_PRINT_CONNECTIONS_BLOCKED                    =  1936,  -- (#0790)
  -- Remote connections to the Print Spooler are blocked by a policy set on your
  -- machine.

  ERROR_NTLM_BLOCKED                                        =  1937,  -- (#0791)
  -- Logon Failure: Authentication failed because NTLM authentication has been
  -- disabled.

  ERROR_INVALID_PIXEL_FORMAT                                =  2000,  -- (#07D0)
  -- The pixel format is invalid.

  ERROR_BAD_DRIVER                                          =  2001,  -- (#07D1)
  -- The specified driver is invalid.

  ERROR_INVALID_WINDOW_STYLE                                =  2002,  -- (#07D2)
  -- The window style or class attribute is invalid for this operation.

  ERROR_METAFILE_NOT_SUPPORTED                              =  2003,  -- (#07D3)
  -- The requested metafile operation is not supported.

  ERROR_TRANSFORM_NOT_SUPPORTED                             =  2004,  -- (#07D4)
  -- The requested transformation operation is not supported.

  ERROR_CLIPPING_NOT_SUPPORTED                              =  2005,  -- (#07D5)
  -- The requested clipping operation is not supported.

  ERROR_INVALID_CMM                                         =  2010,  -- (#07DA)
  -- The specified color management module is invalid.

  ERROR_INVALID_PROFILE                                     =  2011,  -- (#07DB)
  -- The specified color profile is invalid.

  ERROR_TAG_NOT_FOUND                                       =  2012,  -- (#07DC)
  -- The specified tag was not found.

  ERROR_TAG_NOT_PRESENT                                     =  2013,  -- (#07DD)
  -- A required tag is not present.

  ERROR_DUPLICATE_TAG                                       =  2014,  -- (#07DE)
  -- The specified tag is already present.

  ERROR_PROFILE_NOT_ASSOCIATED_WITH_DEVICE                  =  2015,  -- (#07DF)
  -- The specified color profile is not associated with any device.

  ERROR_PROFILE_NOT_FOUND                                   =  2016,  -- (#07E0)
  -- The specified color profile was not found.

  ERROR_INVALID_COLORSPACE                                  =  2017,  -- (#07E1)
  -- The specified color space is invalid.

  ERROR_ICM_NOT_ENABLED                                     =  2018,  -- (#07E2)
  -- Image Color Management is not enabled.

  ERROR_DELETING_ICM_XFORM                                  =  2019,  -- (#07E3)
  -- There was an error while deleting the color transform.

  ERROR_INVALID_TRANSFORM                                   =  2020,  -- (#07E4)
  -- The specified color transform is invalid.

  ERROR_COLORSPACE_MISMATCH                                 =  2021,  -- (#07E5)
  -- The specified transform does not match the bitmap's color space.

  ERROR_INVALID_COLORINDEX                                  =  2022,  -- (#07E6)
  -- The specified named color index is not present in the profile.

  ERROR_PROFILE_DOES_NOT_MATCH_DEVICE                       =  2023,  -- (#07E7)
  -- The specified profile is intended for a device of a different type than the
  -- specified device.

  ERROR_CONNECTED_OTHER_PASSWORD                            =  2108,  -- (#083C)
  -- The network connection was made successfully, but the user had to be
  -- prompted for a password other than the one originally specified.

  ERROR_CONNECTED_OTHER_PASSWORD_DEFAULT                    =  2109,  -- (#083D)
  -- The network connection was made successfully using default credentials.

  ERROR_BAD_USERNAME                                        =  2202,  -- (#089A)
  -- The specified username is invalid.

  ERROR_NOT_CONNECTED                                       =  2250,  -- (#08CA)
  -- This network connection does not exist.

  ERROR_OPEN_FILES                                          =  2401,  -- (#0961)
  -- This network connection has files open or requests pending.

  ERROR_ACTIVE_CONNECTIONS                                  =  2402,  -- (#0962)
  -- Active connections still exist.

  ERROR_DEVICE_IN_USE                                       =  2404,  -- (#0964)
  -- The device is in use by an active process and cannot be disconnected.

  ERROR_UNKNOWN_PRINT_MONITOR                               =  3000,  -- (#0BB8)
  -- The specified print monitor is unknown.

  ERROR_PRINTER_DRIVER_IN_USE                               =  3001,  -- (#0BB9)
  -- The specified printer driver is currently in use.

  ERROR_SPOOL_FILE_NOT_FOUND                                =  3002,  -- (#0BBA)
  -- The spool file was not found.

  ERROR_SPL_NO_STARTDOC                                     =  3003,  -- (#0BBB)
  -- A StartDocPrinter call was not issued.

  ERROR_SPL_NO_ADDJOB                                       =  3004,  -- (#0BBC)
  -- An AddJob call was not issued.

  ERROR_PRINT_PROCESSOR_ALREADY_INSTALLED                   =  3005,  -- (#0BBD)
  -- The specified print processor has already been installed.

  ERROR_PRINT_MONITOR_ALREADY_INSTALLED                     =  3006,  -- (#0BBE)
  -- The specified print monitor has already been installed.

  ERROR_INVALID_PRINT_MONITOR                               =  3007,  -- (#0BBF)
  -- The specified print monitor does not have the required functions.

  ERROR_PRINT_MONITOR_IN_USE                                =  3008,  -- (#0BC0)
  -- The specified print monitor is currently in use.

  ERROR_PRINTER_HAS_JOBS_QUEUED                             =  3009,  -- (#0BC1)
  -- The requested operation is not allowed when there are jobs queued to the
  -- printer.

  ERROR_SUCCESS_REBOOT_REQUIRED                             =  3010,  -- (#0BC2)
  -- The requested operation is successful. Changes will not be effective until
  -- the system is rebooted.

  ERROR_SUCCESS_RESTART_REQUIRED                            =  3011,  -- (#0BC3)
  -- The requested operation is successful. Changes will not be effective until
  -- the service is restarted.

  ERROR_PRINTER_NOT_FOUND                                   =  3012,  -- (#0BC4)
  -- No printers were found.

  ERROR_PRINTER_DRIVER_WARNED                               =  3013,  -- (#0BC5)
  -- The printer driver is known to be unreliable.

  ERROR_PRINTER_DRIVER_BLOCKED                              =  3014,  -- (#0BC6)
  -- The printer driver is known to harm the system.

  ERROR_PRINTER_DRIVER_PACKAGE_IN_USE                       =  3015,  -- (#0BC7)
  -- The specified printer driver package is currently in use.

  ERROR_CORE_DRIVER_PACKAGE_NOT_FOUND                       =  3016,  -- (#0BC8)
  -- Unable to find a core driver package that is required by the printer driver
  -- package.

  ERROR_FAIL_REBOOT_REQUIRED                                =  3017,  -- (#0BC9)
  -- The requested operation failed. A system reboot is required to roll back
  -- changes made.

  ERROR_FAIL_REBOOT_INITIATED                               =  3018,  -- (#0BCA)
  -- The requested operation failed. A system reboot has been initiated to roll
  -- back changes made.

  ERROR_PRINTER_DRIVER_DOWNLOAD_NEEDED                      =  3019,  -- (#0BCB)
  -- The specified printer driver was not found on the system and needs to be
  -- downloaded.

  ERROR_PRINT_JOB_RESTART_REQUIRED                          =  3020,  -- (#0BCC)
  -- The requested print job has failed to print. A print system update requires
  -- the job to be resubmitted.

  ERROR_IO_REISSUE_AS_CACHED                                =  3950,  -- (#0F6E)
  -- Reissue the given operation as a cached IO operation.
  
  ERROR_WINS_INTERNAL                                       =  4000,  -- (#0FA0)
  -- WINS encountered an error while processing the command.

  ERROR_CAN_NOT_DEL_LOCAL_WINS                              =  4001,  -- (#0FA1)
  -- The local WINS can not be deleted.

  ERROR_STATIC_INIT                                         =  4002,  -- (#0FA2)
  -- The importation from the file failed.

  ERROR_INC_BACKUP                                          =  4003,  -- (#0FA3)
  -- The backup failed. Was a full backup done before?
  
  ERROR_FULL_BACKUP                                         =  4004,  -- (#0FA4)
  -- The backup failed. Check the directory to which you are backing the
  -- database.

  ERROR_REC_NON_EXISTENT                                    =  4005,  -- (#0FA5)
  -- The name does not exist in the WINS database.

  ERROR_RPL_NOT_ALLOWED                                     =  4006,  -- (#0FA6)
  -- Replication with a nonconfigured partner is not allowed.

  PEERDIST_ERROR_CONTENTINFO_VERSION_UNSUPPORTED            =  4050,  -- (#0FD2)
  -- The version of the supplied content information is not supported.

  PEERDIST_ERROR_CANNOT_PARSE_CONTENTINFO                   =  4051,  -- (#0FD3)
  -- The supplied content information is malformed.

  PEERDIST_ERROR_MISSING_DATA                               =  4052,  -- (#0FD4)
  -- The requested data cannot be found in local or peer caches.

  PEERDIST_ERROR_NO_MORE                                    =  4053,  -- (#0FD5)
  -- No more data is available or required.

  PEERDIST_ERROR_NOT_INITIALIZED                            =  4054,  -- (#0FD6)
  -- The supplied object has not been initialized.

  PEERDIST_ERROR_ALREADY_INITIALIZED                        =  4055,  -- (#0FD7)
  -- The supplied object has already been initialized.

  PEERDIST_ERROR_SHUTDOWN_IN_PROGRESS                       =  4056,  -- (#0FD8)
  -- A shutdown operation is already in progress.

  PEERDIST_ERROR_INVALIDATED                                =  4057,  -- (#0FD9)
  -- The supplied object has already been invalidated.

  PEERDIST_ERROR_ALREADY_EXISTS                             =  4058,  -- (#0FDA)
  -- An element already exists and was not replaced.

  PEERDIST_ERROR_OPERATION_NOTFOUND                         =  4059,  -- (#0FDB)
  -- Can not cancel the requested operation as it has already been completed.

  PEERDIST_ERROR_ALREADY_COMPLETED                          =  4060,  -- (#0FDC)
  -- Can not perform the reqested operation because it has already been carried
  -- out.

  PEERDIST_ERROR_OUT_OF_BOUNDS                              =  4061,  -- (#0FDD)
  -- An operation accessed data beyond the bounds of valid data.

  PEERDIST_ERROR_VERSION_UNSUPPORTED                        =  4062,  -- (#0FDE)
  -- The requested version is not supported.

  PEERDIST_ERROR_INVALID_CONFIGURATION                      =  4063,  -- (#0FDF)
  -- A configuration value is invalid.

  PEERDIST_ERROR_NOT_LICENSED                               =  4064,  -- (#0FE0)
  -- The SKU is not licensed.

  PEERDIST_ERROR_SERVICE_UNAVAILABLE                        =  4065,  -- (#0FE1)
  -- PeerDist Service is still initializing and will be available shortly.

  ERROR_DHCP_ADDRESS_CONFLICT                               =  4100,  -- (#1004)
  -- The DHCP client has obtained an IP address that is already in use on the
  -- network. The local interface will be disabled until the DHCP client can
  -- obtain a new address.

  ERROR_WMI_GUID_NOT_FOUND                                  =  4200,  -- (#1068)
  -- The GUID passed was not recognized as valid by a WMI data provider.

  ERROR_WMI_INSTANCE_NOT_FOUND                              =  4201,  -- (#1069)
  -- The instance name passed was not recognized as valid by a WMI data
  -- provider.

  ERROR_WMI_ITEMID_NOT_FOUND                                =  4202,  -- (#106A)
  -- The data item ID passed was not recognized as valid by a WMI data provider.

  ERROR_WMI_TRY_AGAIN                                       =  4203,  -- (#106B)
  -- The WMI request could not be completed and should be retried.

  ERROR_WMI_DP_NOT_FOUND                                    =  4204,  -- (#106C)
  -- The WMI data provider could not be located.

  ERROR_WMI_UNRESOLVED_INSTANCE_REF                         =  4205,  -- (#106D)
  -- The WMI data provider references an instance set that has not been
  -- registered.

  ERROR_WMI_ALREADY_ENABLED                                 =  4206,  -- (#106E)
  -- The WMI data block or event notification has already been enabled.

  ERROR_WMI_GUID_DISCONNECTED                               =  4207,  -- (#106F)
  -- The WMI data block is no longer available.

  ERROR_WMI_SERVER_UNAVAILABLE                              =  4208,  -- (#1070)
  -- The WMI data service is not available.

  ERROR_WMI_DP_FAILED                                       =  4209,  -- (#1071)
  -- The WMI data provider failed to carry out the request.

  ERROR_WMI_INVALID_MOF                                     =  4210,  -- (#1072)
  -- The WMI MOF information is not valid.

  ERROR_WMI_INVALID_REGINFO                                 =  4211,  -- (#1073)
  -- The WMI registration information is not valid.

  ERROR_WMI_ALREADY_DISABLED                                =  4212,  -- (#1074)
  -- The WMI data block or event notification has already been disabled.

  ERROR_WMI_READ_ONLY                                       =  4213,  -- (#1075)
  -- The WMI data item or data block is read only.

  ERROR_WMI_SET_FAILURE                                     =  4214,  -- (#1076)
  -- The WMI data item or data block could not be changed.

  ERROR_INVALID_MEDIA                                       =  4300,  -- (#10CC)
  -- The media identifier does not represent a valid medium.

  ERROR_INVALID_LIBRARY                                     =  4301,  -- (#10CD)
  -- The library identifier does not represent a valid library.

  ERROR_INVALID_MEDIA_POOL                                  =  4302,  -- (#10CE)
  -- The media pool identifier does not represent a valid media pool.

  ERROR_DRIVE_MEDIA_MISMATCH                                =  4303,  -- (#10CF)
  -- The drive and medium are not compatible or exist in different libraries.

  ERROR_MEDIA_OFFLINE                                       =  4304,  -- (#10D0)
  -- The medium currently exists in an offline library and must be online to
  -- perform this operation.

  ERROR_LIBRARY_OFFLINE                                     =  4305,  -- (#10D1)
  -- The operation cannot be performed on an offline library.

  ERROR_EMPTY                                               =  4306,  -- (#10D2)
  -- The library, drive, or media pool is empty.

  ERROR_NOT_EMPTY                                           =  4307,  -- (#10D3)
  -- The library, drive, or media pool must be empty to perform this operation.

  ERROR_MEDIA_UNAVAILABLE                                   =  4308,  -- (#10D4)
  -- No media is currently available in this media pool or library.

  ERROR_RESOURCE_DISABLED                                   =  4309,  -- (#10D5)
  -- A resource required for this operation is disabled.

  ERROR_INVALID_CLEANER                                     =  4310,  -- (#10D6)
  -- The media identifier does not represent a valid cleaner.

  ERROR_UNABLE_TO_CLEAN                                     =  4311,  -- (#10D7)
  -- The drive cannot be cleaned or does not support cleaning.

  ERROR_OBJECT_NOT_FOUND                                    =  4312,  -- (#10D8)
  -- The object identifier does not represent a valid object.

  ERROR_DATABASE_FAILURE                                    =  4313,  -- (#10D9)
  -- Unable to read from or write to the database.

  ERROR_DATABASE_FULL                                       =  4314,  -- (#10DA)
  -- The database is full.

  ERROR_MEDIA_INCOMPATIBLE                                  =  4315,  -- (#10DB)
  -- The medium is not compatible with the device or media pool.

  ERROR_RESOURCE_NOT_PRESENT                                =  4316,  -- (#10DC)
  -- The resource required for this operation does not exist.

  ERROR_INVALID_OPERATION                                   =  4317,  -- (#10DD)
  -- The operation identifier is not valid.

  ERROR_MEDIA_NOT_AVAILABLE                                 =  4318,  -- (#10DE)
  -- The media is not mounted or ready for use.

  ERROR_DEVICE_NOT_AVAILABLE                                =  4319,  -- (#10DF)
  -- The device is not ready for use.

  ERROR_REQUEST_REFUSED                                     =  4320,  -- (#10E0)
  -- The operator or administrator has refused the request.

  ERROR_INVALID_DRIVE_OBJECT                                =  4321,  -- (#10E1)
  -- The drive identifier does not represent a valid drive.

  ERROR_LIBRARY_FULL                                        =  4322,  -- (#10E2)
  -- Library is full. No slot is available for use.

  ERROR_MEDIUM_NOT_ACCESSIBLE                               =  4323,  -- (#10E3)
  -- The transport cannot access the medium.

  ERROR_UNABLE_TO_LOAD_MEDIUM                               =  4324,  -- (#10E4)
  -- Unable to load the medium into the drive.

  ERROR_UNABLE_TO_INVENTORY_DRIVE                           =  4325,  -- (#10E5)
  -- Unable to retrieve status about the drive.

  ERROR_UNABLE_TO_INVENTORY_SLOT                            =  4326,  -- (#10E6)
  -- Unable to retrieve status about the slot.

  ERROR_UNABLE_TO_INVENTORY_TRANSPORT                       =  4327,  -- (#10E7)
  -- Unable to retrieve status about the transport.

  ERROR_TRANSPORT_FULL                                      =  4328,  -- (#10E8)
  -- Cannot use the transport because it is already in use.

  ERROR_CONTROLLING_IEPORT                                  =  4329,  -- (#10E9)
  -- Unable to open or close the inject/eject port.

  ERROR_UNABLE_TO_EJECT_MOUNTED_MEDIA                       =  4330,  -- (#10EA)
  -- Unable to eject the media because it is in a drive.

  ERROR_CLEANER_SLOT_SET                                    =  4331,  -- (#10EB)
  -- A cleaner slot is already reserved.

  ERROR_CLEANER_SLOT_NOT_SET                                =  4332,  -- (#10EC)
  -- A cleaner slot is not reserved.

  ERROR_CLEANER_CARTRIDGE_SPENT                             =  4333,  -- (#10ED)
  -- The cleaner cartridge has performed the maximum number of drive cleanings.

  ERROR_UNEXPECTED_OMID                                     =  4334,  -- (#10EE)
  -- Unexpected on-medium identifier.

  ERROR_CANT_DELETE_LAST_ITEM                               =  4335,  -- (#10EF)
  -- The last remaining item in this group or resource cannot be deleted.

  ERROR_MESSAGE_EXCEEDS_MAX_SIZE                            =  4336,  -- (#10F0)
  -- The message provided exceeds the maximum size allowed for this parameter.

  ERROR_VOLUME_CONTAINS_SYS_FILES                           =  4337,  -- (#10F1)
  -- The volume contains system or paging files.

  ERROR_INDIGENOUS_TYPE                                     =  4338,  -- (#10F2)
  -- The media type cannot be removed from this library since at least one drive
  -- in the library reports it can support this media type.

  ERROR_NO_SUPPORTING_DRIVES                                =  4339,  -- (#10F3)
  -- This offline media cannot be mounted on this system since no enabled drives
  -- are present which can be used.

  ERROR_CLEANER_CARTRIDGE_INSTALLED                         =  4340,  -- (#10F4)
  -- A cleaner cartridge is present in the tape library.

  ERROR_IEPORT_FULL                                         =  4341,  -- (#10F5)
  -- Cannot use the inject/eject port because it is not empty.

  ERROR_FILE_OFFLINE                                        =  4350,  -- (#10FE)
  -- The remote storage service was not able to recall the file.

  ERROR_REMOTE_STORAGE_NOT_ACTIVE                           =  4351,  -- (#10FF)
  -- The remote storage service is not operational at this time.

  ERROR_REMOTE_STORAGE_MEDIA_ERROR                          =  4352,  -- (#1100)
  -- The remote storage service encountered a media error.

  ERROR_NOT_A_REPARSE_POINT                                 =  4390,  -- (#1126)
  -- The file or directory is not a reparse point.

  ERROR_REPARSE_ATTRIBUTE_CONFLICT                          =  4391,  -- (#1127)
  -- The reparse point attribute cannot be set because it conflicts with an
  -- existing attribute.

  ERROR_INVALID_REPARSE_DATA                                =  4392,  -- (#1128)
  -- The data present in the reparse point buffer is invalid.

  ERROR_REPARSE_TAG_INVALID                                 =  4393,  -- (#1129)
  -- The tag present in the reparse point buffer is invalid.

  ERROR_REPARSE_TAG_MISMATCH                                =  4394,  -- (#112A)
  -- There is a mismatch between the tag specified in the request and the tag
  -- present in the reparse point.

  ERROR_VOLUME_NOT_SIS_ENABLED                              =  4500,  -- (#1194)
  -- Single Instance Storage is not available on this volume.

  ERROR_DEPENDENT_RESOURCE_EXISTS                           =  5001,  -- (#1389)
  -- The cluster resource cannot be moved to another group because other
  -- resources are dependent on it.

  ERROR_DEPENDENCY_NOT_FOUND                                =  5002,  -- (#138A)
  -- The cluster resource dependency cannot be found.

  ERROR_DEPENDENCY_ALREADY_EXISTS                           =  5003,  -- (#138B)
  -- The cluster resource cannot be made dependent on the specified resource
  -- because it is already dependent.

  ERROR_RESOURCE_NOT_ONLINE                                 =  5004,  -- (#138C)
  -- The cluster resource is not online.

  ERROR_HOST_NODE_NOT_AVAILABLE                             =  5005,  -- (#138D)
  -- A cluster node is not available for this operation.

  ERROR_RESOURCE_NOT_AVAILABLE                              =  5006,  -- (#138E)
  -- The cluster resource is not available.

  ERROR_RESOURCE_NOT_FOUND                                  =  5007,  -- (#138F)
  -- The cluster resource could not be found.

  ERROR_SHUTDOWN_CLUSTER                                    =  5008,  -- (#1390)
  -- The cluster is being shut down.

  ERROR_CANT_EVICT_ACTIVE_NODE                              =  5009,  -- (#1391)
  -- A cluster node cannot be evicted from the cluster unless the node is down.

  ERROR_OBJECT_ALREADY_EXISTS                               =  5010,  -- (#1392)
  -- The object already exists.

  ERROR_OBJECT_IN_LIST                                      =  5011,  -- (#1393)
  -- The object is already in the list.

  ERROR_GROUP_NOT_AVAILABLE                                 =  5012,  -- (#1394)
  -- The cluster group is not available for any new requests.

  ERROR_GROUP_NOT_FOUND                                     =  5013,  -- (#1395)
  -- The cluster group could not be found.

  ERROR_GROUP_NOT_ONLINE                                    =  5014,  -- (#1396)
  -- The operation could not be completed because the cluster group is not
  -- online.

  ERROR_HOST_NODE_NOT_RESOURCE_OWNER                        =  5015,  -- (#1397)
  -- The cluster node is not the owner of the resource.

  ERROR_HOST_NODE_NOT_GROUP_OWNER                           =  5016,  -- (#1398)
  -- The cluster node is not the owner of the group.

  ERROR_RESMON_CREATE_FAILED                                =  5017,  -- (#1399)
  -- The cluster resource could not be created in the specified resource
  -- monitor.

  ERROR_RESMON_ONLINE_FAILED                                =  5018,  -- (#139A)
  -- The cluster resource could not be brought online by the resource monitor.

  ERROR_RESOURCE_ONLINE                                     =  5019,  -- (#139B)
  -- The operation could not be completed because the cluster resource is
  -- online.

  ERROR_QUORUM_RESOURCE                                     =  5020,  -- (#139C)
  -- The cluster resource could not be deleted or brought offline because it is
  -- the quorum resource.

  ERROR_NOT_QUORUM_CAPABLE                                  =  5021,  -- (#139D)
  -- The cluster could not make the specified resource a quorum resource because
  -- it is not capable of being a quorum resource.

  ERROR_CLUSTER_SHUTTING_DOWN                               =  5022,  -- (#139E)
  -- The cluster software is shutting down.

  ERROR_INVALID_STATE                                       =  5023,  -- (#139F)
  -- The group or resource is not in the correct state to perform the requested
  -- operation.

  ERROR_RESOURCE_PROPERTIES_STORED                          =  5024,  -- (#13A0)
  -- The properties were stored but not all changes will take effect until the
  -- next time the resource is brought online.

  ERROR_NOT_QUORUM_CLASS                                    =  5025,  -- (#13A1)
  -- The cluster could not make the specified resource a quorum resource because
  -- it does not belong to a shared storage class.

  ERROR_CORE_RESOURCE                                       =  5026,  -- (#13A2)
  -- The cluster resource could not be deleted since it is a core resource.

  ERROR_QUORUM_RESOURCE_ONLINE_FAILED                       =  5027,  -- (#13A3)
  -- The quorum resource failed to come online.

  ERROR_QUORUMLOG_OPEN_FAILED                               =  5028,  -- (#13A4)
  -- The quorum log could not be created or mounted successfully.

  ERROR_CLUSTERLOG_CORRUPT                                  =  5029,  -- (#13A5)
  -- The cluster log is corrupt.

  ERROR_CLUSTERLOG_RECORD_EXCEEDS_MAXSIZE                   =  5030,  -- (#13A6)
  -- The record could not be written to the cluster log since it exceeds the
  -- maximum size.

  ERROR_CLUSTERLOG_EXCEEDS_MAXSIZE                          =  5031,  -- (#13A7)
  -- The cluster log exceeds its maximum size.

  ERROR_CLUSTERLOG_CHKPOINT_NOT_FOUND                       =  5032,  -- (#13A8)
  -- No checkpoint record was found in the cluster log.

  ERROR_CLUSTERLOG_NOT_ENOUGH_SPACE                         =  5033,  -- (#13A9)
  -- The minimum required disk space needed for logging is not available.

  ERROR_QUORUM_OWNER_ALIVE                                  =  5034,  -- (#13AA)
  -- The cluster node failed to take control of the quorum resource because the
  -- resource is owned by another active node.

  ERROR_NETWORK_NOT_AVAILABLE                               =  5035,  -- (#13AB)
  -- A cluster network is not available for this operation.

  ERROR_NODE_NOT_AVAILABLE                                  =  5036,  -- (#13AC)
  -- A cluster node is not available for this operation.

  ERROR_ALL_NODES_NOT_AVAILABLE                             =  5037,  -- (#13AD)
  -- All cluster nodes must be running to perform this operation.

  ERROR_RESOURCE_FAILED                                     =  5038,  -- (#13AE)
  -- A cluster resource failed.

  ERROR_CLUSTER_INVALID_NODE                                =  5039,  -- (#13AF)
  -- The cluster node is not valid.

  ERROR_CLUSTER_NODE_EXISTS                                 =  5040,  -- (#13B0)
  -- The cluster node already exists.

  ERROR_CLUSTER_JOIN_IN_PROGRESS                            =  5041,  -- (#13B1)
  -- A node is in the process of joining the cluster.

  ERROR_CLUSTER_NODE_NOT_FOUND                              =  5042,  -- (#13B2)
  -- The cluster node was not found.

  ERROR_CLUSTER_LOCAL_NODE_NOT_FOUND                        =  5043,  -- (#13B3)
  -- The cluster local node information was not found.

  ERROR_CLUSTER_NETWORK_EXISTS                             =  5044,  -- (#13B4)
  -- The cluster network already exists.

  ERROR_CLUSTER_NETWORK_NOT_FOUND                           =  5045,  -- (#13B5)
  -- The cluster network was not found.

  ERROR_CLUSTER_NETINTERFACE_EXISTS                         =  5046,  -- (#13B6)
  -- The cluster network interface already exists.

  ERROR_CLUSTER_NETINTERFACE_NOT_FOUND                      =  5047,  -- (#13B7)
  -- The cluster network interface was not found.

  ERROR_CLUSTER_INVALID_REQUEST                             =  5048,  -- (#13B8)
  -- The cluster request is not valid for this object.

  ERROR_CLUSTER_INVALID_NETWORK_PROVIDER                    =  5049,  -- (#13B9)
  -- The cluster network provider is not valid.

  ERROR_CLUSTER_NODE_DOWN                                   =  5050,  -- (#13BA)
  -- The cluster node is down.

  ERROR_CLUSTER_NODE_UNREACHABLE                            =  5051,  -- (#13BB)
  -- The cluster node is not reachable.

  ERROR_CLUSTER_NODE_NOT_MEMBER                             =  5052,  -- (#13BC)
  -- The cluster node is not a member of the cluster.

  ERROR_CLUSTER_JOIN_NOT_IN_PROGRESS                        =  5053,  -- (#13BD)
  -- A cluster join operation is not in progress.

  ERROR_CLUSTER_INVALID_NETWORK                             =  5054,  -- (#13BE)
  -- The cluster network is not valid.

  ERROR_CLUSTER_NODE_UP                                     =  5056,  -- (#13C0)
  -- The cluster node is up.

  ERROR_CLUSTER_IPADDR_IN_USE                               =  5057,  -- (#13C1)
  -- The cluster IP address is already in use.

  ERROR_CLUSTER_NODE_NOT_PAUSED                             =  5058,  -- (#13C2)
  -- The cluster node is not paused.

  ERROR_CLUSTER_NO_SECURITY_CONTEXT                         =  5059,  -- (#13C3)
  -- No cluster security context is available.

  ERROR_CLUSTER_NETWORK_NOT_INTERNAL                        =  5060,  -- (#13C4)
  -- The cluster network is not configured for internal cluster communication.

  ERROR_CLUSTER_NODE_ALREADY_UP                             =  5061,  -- (#13C5)
  -- The cluster node is already up.

  ERROR_CLUSTER_NODE_ALREADY_DOWN                           =  5062,  -- (#13C6)
  -- The cluster node is already down.

  ERROR_CLUSTER_NETWORK_ALREADY_ONLINE                      =  5063,  -- (#13C7)
  -- The cluster network is already online.

  ERROR_CLUSTER_NETWORK_ALREADY_OFFLINE                     =  5064,  -- (#13C8)
  -- The cluster network is already offline.

  ERROR_CLUSTER_NODE_ALREADY_MEMBER                         =  5065,  -- (#13C9)
  -- The cluster node is already a member of the cluster.

  ERROR_CLUSTER_LAST_INTERNAL_NETWORK                       =  5066,  -- (#13CA)
  -- The cluster network is the only one configured for internal cluster
  -- communication between two or more active cluster nodes. The internal
  -- communication capability cannot be removed from the network.

  ERROR_CLUSTER_NETWORK_HAS_DEPENDENTS                      =  5067,  -- (#13CB)
  -- One or more cluster resources depend on the network to provide service to
  -- clients. The client access capability cannot be removed from the network.

  ERROR_INVALID_OPERATION_ON_QUORUM                         =  5068,  -- (#13CC)
  -- This operation cannot be performed on the cluster resource as it the quorum
  -- resource. You may not bring the quorum resource offline or modify its
  -- possible owners list.

  ERROR_DEPENDENCY_NOT_ALLOWED                              =  5069,  -- (#13CD)
  -- The cluster quorum resource is not allowed to have any dependencies.

  ERROR_CLUSTER_NODE_PAUSED                                 =  5070,  -- (#13CE)
  -- The cluster node is paused.

  ERROR_NODE_CANT_HOST_RESOURCE                             =  5071,  -- (#13CF)
  -- The cluster resource cannot be brought online. The owner node cannot run
  -- this resource.

  ERROR_CLUSTER_NODE_NOT_READY                              =  5072,  -- (#13D0)
  -- The cluster node is not ready to perform the requested operation.

  ERROR_CLUSTER_NODE_SHUTTING_DOWN                          =  5073,  -- (#13D1)
  -- The cluster node is shutting down.

  ERROR_CLUSTER_JOIN_ABORTED                                =  5074,  -- (#13D2)
  -- The cluster join operation was aborted.

  ERROR_CLUSTER_INCOMPATIBLE_VERSIONS                       =  5075,  -- (#13D3)
  -- The cluster join operation failed due to incompatible software versions
  -- between the joining node and its sponsor.

  ERROR_CLUSTER_MAXNUM_OF_RESOURCES_EXCEEDED                =  5076,  -- (#13D4)
  -- This resource cannot be created because the cluster has reached the limit
  -- on the number of resources it can monitor.

  ERROR_CLUSTER_SYSTEM_CONFIG_CHANGED                       =  5077,  -- (#13D5)
  -- The system configuration changed during the cluster join or form operation.
  -- The join or form operation was aborted.

  ERROR_CLUSTER_RESOURCE_TYPE_NOT_FOUND                     =  5078,  -- (#13D6)
  -- The specified resource type was not found.

  ERROR_CLUSTER_RESTYPE_NOT_SUPPORTED                       =  5079,  -- (#13D7)
  -- The specified node does not support a resource of this type. This may be
  -- due to version inconsistencies or due to the absence of the resource DLL on
  -- this node.

  ERROR_CLUSTER_RESNAME_NOT_FOUND                           =  5080,  -- (#13D8)
  -- The specified resource name is supported by this resource DLL. This may be
  -- due to a bad (or changed) name supplied to the resource DLL.

  ERROR_CLUSTER_NO_RPC_PACKAGES_REGISTERED                  =  5081,  -- (#13D9)
  -- No authentication package could be registered with the RPC server.

  ERROR_CLUSTER_OWNER_NOT_IN_PREFLIST                       =  5082,  -- (#13DA)
  -- You cannot bring the group online because the owner of the group is not in
  -- the preferred list for the group. To change the owner node for the group,
  -- move the group.

  ERROR_CLUSTER_DATABASE_SEQMISMATCH                        =  5083,  -- (#13DB)
  -- The join operation failed because the cluster database sequence number has
  -- changed or is incompatible with the locker node. This may happen during a
  -- join operation if the cluster database was changing during the join.

  ERROR_RESMON_INVALID_STATE                                =  5084,  -- (#13DC)
  -- The resource monitor will not allow the fail operation to be performed
  -- while the resource is in its current state. This may happen if the resource
  -- is in a pending state.

  ERROR_CLUSTER_GUM_NOT_LOCKER                              =  5085,  -- (#13DD)
  -- A non locker code got a request to reserve the lock for making public
  -- updates.

  ERROR_QUORUM_DISK_NOT_FOUND                               =  5086,  -- (#13DE)
  -- The quorum disk could not be located by the cluster service.

  ERROR_DATABASE_BACKUP_CORRUPT                             =  5087,  -- (#13DF)
  -- The backup up cluster database is possibly corrupt.

  ERROR_CLUSTER_NODE_ALREADY_HAS_DFS_ROOT                   =  5088,  -- (#13E0)
  -- A DFS root already exists in this cluster node.

  ERROR_RESOURCE_PROPERTY_UNCHANGEABLE                      =  5089,  -- (#13E1)
  -- An attempt to modify a resource property failed because it conflicts with
  -- another existing property.

  ERROR_CLUSTER_MEMBERSHIP_INVALID_STATE                    =  5890,  -- (#1702)
  -- An operation was attempted that is incompatible with the current membership
  -- state of the node.

  ERROR_CLUSTER_QUORUMLOG_NOT_FOUND                         =  5891,  -- (#1703)
  -- The quorum resource does not contain the quorum log.

  ERROR_CLUSTER_MEMBERSHIP_HALT                             =  5892,  -- (#1704)
  -- The membership engine requested shutdown of the cluster service on this
  -- node.

  ERROR_CLUSTER_INSTANCE_ID_MISMATCH                        =  5893,  -- (#1705)
  -- The join operation failed because the cluster instance ID of the joining
  -- node does not match the cluster instance ID of the sponsor node.

  ERROR_CLUSTER_NETWORK_NOT_FOUND_FOR_IP                    =  5894,  -- (#1706)
  -- A matching cluster network for the specified IP address could not be found.

  ERROR_CLUSTER_PROPERTY_DATA_TYPE_MISMATCH                 =  5895,  -- (#1707)
  -- The actual data type of the property did not match the expected data type
  -- of the property.

  ERROR_CLUSTER_EVICT_WITHOUT_CLEANUP                       =  5896,  -- (#1708)
  -- The cluster node was evicted from the cluster successfully, but the node
  -- was not cleaned up. To determine what cleanup steps failed and how to
  -- recover, see the Failover Clustering application event log using Event
  -- Viewer.

  ERROR_CLUSTER_PARAMETER_MISMATCH                          =  5897,  -- (#1709)
  -- Two or more parameter values specified for a resource's properties are in
  -- conflict.

  ERROR_NODE_CANNOT_BE_CLUSTERED                            =  5898,  -- (#170A)
  -- This computer cannot be made a member of a cluster.

  ERROR_CLUSTER_WRONG_OS_VERSION                            =  5899,  -- (#170B)
  -- This computer cannot be made a member of a cluster because it does not have
  -- the correct version of Windows installed.

  ERROR_CLUSTER_CANT_CREATE_DUP_CLUSTER_NAME                =  5900,  -- (#170C)
  -- A cluster cannot be created with the specified cluster name because that
  -- cluster name is already in use. Specify a different name for the cluster.

  ERROR_CLUSCFG_ALREADY_COMMITTED                           =  5901,  -- (#170D)
  -- The cluster configuration action has already been committed.

  ERROR_CLUSCFG_ROLLBACK_FAILED                             =  5902,  -- (#170E)
  -- The cluster configuration action could not be rolled back.

  ERROR_CLUSCFG_SYSTEM_DISK_DRIVE_LETTER_CONFLICT           =  5903,  -- (#170F)
  -- The drive letter assigned to a system disk on one node conflicted with the
  -- drive letter assigned to a disk on another node.

  ERROR_CLUSTER_OLD_VERSION                                 =  5904,  -- (#1710)
  -- One or more nodes in the cluster are running a version of Windows that does
  -- not support this operation.

  ERROR_CLUSTER_MISMATCHED_COMPUTER_ACCT_NAME               =  5905,  -- (#1711)
  -- The name of the corresponding computer account doesn't match the Network
  -- Name for this resource.

  ERROR_CLUSTER_NO_NET_ADAPTERS                             =  5906,  -- (#1712)
  -- No network adapters are available.

  ERROR_CLUSTER_POISONED                                    =  5907,  -- (#1713)
  -- The cluster node has been poisoned.

  ERROR_CLUSTER_GROUP_MOVING                                =  5908,  -- (#1714)
  -- The group is unable to accept the request since it is moving to another
  -- node.

  ERROR_CLUSTER_RESOURCE_TYPE_BUSY                          =  5909,  -- (#1715)
  -- The resource type cannot accept the request since is too busy performing
  -- another operation.

  ERROR_RESOURCE_CALL_TIMED_OUT                             =  5910,  -- (#1716)
  -- The call to the cluster resource DLL timed out.

  ERROR_INVALID_CLUSTER_IPV6_ADDRESS                        =  5911,  -- (#1717)
  -- The address is not valid for an IPv6 Address resource. A public IPv6
  -- address is required, and it must match a cluster network. Compatibility
  -- addresses are not permitted.

  ERROR_CLUSTER_INTERNAL_INVALID_FUNCTION                   =  5912,  -- (#1718)
  -- An internal cluster error occurred. A call to an invalid function was
  -- attempted.

  ERROR_CLUSTER_PARAMETER_OUT_OF_BOUNDS                     =  5913,  -- (#1719)
  -- A parameter value is out of acceptable range.

  ERROR_CLUSTER_PARTIAL_SEND                                =  5914,  -- (#171A)
  -- A network error occurred while sending data to another node in the cluster.
  -- The number of bytes transmitted was less than required.

  ERROR_CLUSTER_REGISTRY_INVALID_FUNCTION                   =  5915,  -- (#171B)
  -- An invalid cluster registry operation was attempted.

  ERROR_CLUSTER_INVALID_STRING_TERMINATION                  =  5916,  -- (#171C)
  -- An input string of characters is not properly terminated.

  ERROR_CLUSTER_INVALID_STRING_FORMAT                       =  5917,  -- (#171D)
  -- An input string of characters is not in a valid format for the data it
  -- represents.

  ERROR_CLUSTER_DATABASE_TRANSACTION_IN_PROGRESS            =  5918,  -- (#171E)
  -- An internal cluster error occurred. A cluster database transaction was
  -- attempted while a transaction was already in progress.

  ERROR_CLUSTER_DATABASE_TRANSACTION_NOT_IN_PROGRESS        =  5919,  -- (#171F)
  -- An internal cluster error occurred. There was an attempt to commit a
  -- cluster database transaction while no transaction was in progress.

  ERROR_CLUSTER_NULL_DATA                                   =  5920,  -- (#1720)
  -- An internal cluster error occurred. Data was not properly initialized.

  ERROR_CLUSTER_PARTIAL_READ                                =  5921,  -- (#1721)
  -- An error occurred while reading from a stream of data. An unexpected number
  -- of bytes was returned.

  ERROR_CLUSTER_PARTIAL_WRITE                               =  5922,  -- (#1722)
  -- An error occurred while writing to a stream of data. The required number of
  -- bytes could not be written.

  ERROR_CLUSTER_CANT_DESERIALIZE_DATA                       =  5923,  -- (#1723)
  -- An error occurred while deserializing a stream of cluster data.

  ERROR_DEPENDENT_RESOURCE_PROPERTY_CONFLICT                =  5924,  -- (#1724)
  -- One or more property values for this resource are in conflict with one or
  -- more property values associated with its dependent resource(s).

  ERROR_CLUSTER_NO_QUORUM                                   =  5925,  -- (#1725)
  -- A quorum of cluster nodes was not present to form a cluster.

  ERROR_CLUSTER_INVALID_IPV6_NETWORK                        =  5926,  -- (#1726)
  -- The cluster network is not valid for an IPv6 Address resource, or it does
  -- not match the configured address.

  ERROR_CLUSTER_INVALID_IPV6_TUNNEL_NETWORK                 =  5927,  -- (#1727)
  -- The cluster network is not valid for an IPv6 Tunnel resource. Check the
  -- configuration of the IP Address resource on which the IPv6 Tunnel resource
  -- depends.

  ERROR_QUORUM_NOT_ALLOWED_IN_THIS_GROUP                    =  5928,  -- (#1728)
  -- Quorum resource cannot reside in the Available Storage group.

  ERROR_DEPENDENCY_TREE_TOO_COMPLEX                         =  5929,  -- (#1729)
  -- The dependencies for this resource are nested too deeply.

  ERROR_EXCEPTION_IN_RESOURCE_CALL                          =  5930,  -- (#172A)
  -- The call into the resource DLL raised an unhandled exception.

  ERROR_CLUSTER_RHS_FAILED_INITIALIZATION                   =  5931,  -- (#172B)
  -- The RHS process failed to initialize.

  ERROR_CLUSTER_NOT_INSTALLED                               =  5932,  -- (#172C)
  -- The Failover Clustering feature is not installed on this node.

  ERROR_CLUSTER_RESOURCES_MUST_BE_ONLINE_ON_THE_SAME_NODE   =  5933,  -- (#172D)
  -- The resources must be online on the same node for this operation
  ERROR_CLUSTER_MAX_NODES_IN_CLUSTER                        =  5934,  -- (#172E)
  -- A new node can not be added since this cluster is already at its maximum
  -- number of nodes.

  ERROR_CLUSTER_TOO_MANY_NODES                              =  5935,  -- (#172F)
  -- This cluster can not be created since the specified number of nodes exceeds
  -- the maximum allowed limit.

  ERROR_CLUSTER_OBJECT_ALREADY_USED                         =  5936,  -- (#1730)
  -- An attempt to use the specified cluster name failed because an enabled
  -- computer object with the given name already exists in the domain.

  ERROR_NONCORE_GROUPS_FOUND                                =  5937,  -- (#1731)
  -- This cluster cannot be destroyed. It has non-core application groups which
  -- must be deleted before the cluster can be destroyed.

  ERROR_FILE_SHARE_RESOURCE_CONFLICT                        =  5938,  -- (#1732)
  -- File share associated with file share witness resource cannot be hosted by
  -- this cluster or any of its nodes.

  ERROR_CLUSTER_EVICT_INVALID_REQUEST                       =  5939,  -- (#1733)
  -- Eviction of this node is invalid at this time. Due to quorum requirements
  -- node eviction will result in cluster shutdown. If it is the last node in
  -- the cluster, destroy cluster command should be used.

  ERROR_CLUSTER_SINGLETON_RESOURCE                          =  5940,  -- (#1734)
  -- Only one instance of this resource type is allowed in the cluster.

  ERROR_CLUSTER_GROUP_SINGLETON_RESOURCE                    =  5941,  -- (#1735)
  -- Only one instance of this resource type is allowed per resource group.

  ERROR_CLUSTER_RESOURCE_PROVIDER_FAILED                    =  5942,  -- (#1736)
  -- The resource failed to come online due to the failure of one or more
  -- provider resources.

  ERROR_CLUSTER_RESOURCE_CONFIGURATION_ERROR                =  5943,  -- (#1737)
  -- The resource has indicated that it cannot come online on any node.

  ERROR_CLUSTER_GROUP_BUSY                                  =  5944,  -- (#1738)
  -- The current operation cannot be performed on this group at this time.

  ERROR_CLUSTER_NOT_SHARED_VOLUME                           =  5945,  -- (#1739)
  -- The directory or file is not located on a cluster shared volume.

  ERROR_CLUSTER_INVALID_SECURITY_DESCRIPTOR                 =  5946,  -- (#173A)
  -- The Security Descriptor does not meet the requirements for a cluster.

  ERROR_CLUSTER_SHARED_VOLUMES_IN_USE                       =  5947,  -- (#173B)
  -- There is one or more shared volumes resources configured in the cluster.
  -- Those resources must be moved to available storage in order for operation
  -- to succeed.

  ERROR_CLUSTER_USE_SHARED_VOLUMES_API                      =  5948,  -- (#173C)
  -- This group or resource cannot be directly manipulated. Use shared volume
  -- APIs to perform desired operation.

  ERROR_CLUSTER_BACKUP_IN_PROGRESS                          =  5949,  -- (#173D)
  -- Back up is in progress. Please wait for backup completion before trying
  -- this operation again.

  ERROR_NON_CSV_PATH                                        =  5950,  -- (#173E)
  -- The path does not belong to a cluster shared volume.

  ERROR_CSV_VOLUME_NOT_LOCAL                                =  5951,  -- (#173F)
  -- The cluster shared volume is not locally mounted on this node.

  ERROR_CLUSTER_WATCHDOG_TERMINATING                        =  5952,  -- (#1740)
  -- The cluster watchdog is terminating.

  ERROR_ENCRYPTION_FAILED                                   =  6000,  -- (#1770)
  -- The specified file could not be encrypted.

  ERROR_DECRYPTION_FAILED                                   =  6001,  -- (#1771)
  -- The specified file could not be decrypted.

  ERROR_FILE_ENCRYPTED                                      =  6002,  -- (#1772)
  -- The specified file is encrypted and the user does not have the ability to
  -- decrypt it.

  ERROR_NO_RECOVERY_POLICY                                  =  6003,  -- (#1773)
  -- There is no valid encryption recovery policy configured for this system.

  ERROR_NO_EFS                                              =  6004,  -- (#1774)
  -- The required encryption driver is not loaded for this system.

  ERROR_WRONG_EFS                                           =  6005,  -- (#1775)
  -- The file was encrypted with a different encryption driver than is currently
  -- loaded.

  ERROR_NO_USER_KEYS                                        =  6006,  -- (#1776)
  -- There are no EFS keys defined for the user.

  ERROR_FILE_NOT_ENCRYPTED                                  =  6007,  -- (#1777)
  -- The specified file is not encrypted.

  ERROR_NOT_EXPORT_FORMAT                                   =  6008,  -- (#1778)
  -- The specified file is not in the defined EFS export format.

  ERROR_FILE_READ_ONLY                                      =  6009,  -- (#1779)
  -- The specified file is read only.

  ERROR_DIR_EFS_DISALLOWED                                  =  6010,  -- (#177A)
  -- The directory has been disabled for encryption.

  ERROR_EFS_SERVER_NOT_TRUSTED                              =  6011,  -- (#177B)
  -- The server is not trusted for remote encryption operation.

  ERROR_BAD_RECOVERY_POLICY                                 =  6012,  -- (#177C)
  -- Recovery policy configured for this system contains invalid recovery
  -- certificate.

  ERROR_EFS_ALG_BLOB_TOO_BIG                                =  6013,  -- (#177D)
  -- The encryption algorithm used on the source file needs a bigger key buffer
  -- than the one on the destination file.

  ERROR_VOLUME_NOT_SUPPORT_EFS                              =  6014,  -- (#177E)
  -- The disk partition does not support file encryption.

  ERROR_EFS_DISABLED                                        =  6015,  -- (#177F)
  -- This machine is disabled for file encryption.

  ERROR_EFS_VERSION_NOT_SUPPORT                             =  6016,  -- (#1780)
  -- A newer system is required to decrypt this encrypted file.

  ERROR_CS_ENCRYPTION_INVALID_SERVER_RESPONSE               =  6017,  -- (#1781)
  -- The remote server sent an invalid response for a file being opened with
  -- Client Side Encryption.

  ERROR_CS_ENCRYPTION_UNSUPPORTED_SERVER                    =  6018,  -- (#1782)
  -- Client Side Encryption is not supported by the remote server even though it
  -- claims to support it.

  ERROR_CS_ENCRYPTION_EXISTING_ENCRYPTED_FILE               =  6019,  -- (#1783)
  -- File is encrypted and should be opened in Client Side Encryption mode.

  ERROR_CS_ENCRYPTION_NEW_ENCRYPTED_FILE                    =  6020,  -- (#1784)
  -- A new encrypted file is being created and a $EFS needs to be provided.

  ERROR_CS_ENCRYPTION_FILE_NOT_CSE                          =  6021,  -- (#1785)
  -- The SMB client requested a CSE FSCTL on a non-CSE file.

  ERROR_NO_BROWSER_SERVERS_FOUND                            =  6118,  -- (#17E6)
  -- The list of servers for this workgroup is not currently available.

  SCHED_E_SERVICE_NOT_LOCALSYSTEM                           =  6200,  -- (#1838)
  -- The Task Scheduler service must be configured to run in the System account
  -- to function properly. Individual tasks may be configured to run in other
  -- accounts.

  ERROR_LOG_SECTOR_INVALID                                  =  6600,  -- (#19C8)
  -- Log service encountered an invalid log sector.

  ERROR_LOG_SECTOR_PARITY_INVALID                           =  6601,  -- (#19C9)
  -- Log service encountered a log sector with invalid block parity.

  ERROR_LOG_SECTOR_REMAPPED                                 =  6602,  -- (#19CA)
  -- Log service encountered a remapped log sector.

  ERROR_LOG_BLOCK_INCOMPLETE                                =  6603,  -- (#19CB)
  -- Log service encountered a partial or incomplete log block.

  ERROR_LOG_INVALID_RANGE                                   =  6604,  -- (#19CC)
  -- Log service encountered an attempt access data outside the active log
  -- range.

  ERROR_LOG_BLOCKS_EXHAUSTED                                =  6605,  -- (#19CD)
  -- Log service user marshalling buffers are exhausted.

  ERROR_LOG_READ_CONTEXT_INVALID                            =  6606,  -- (#19CE)
  -- Log service encountered an attempt read from a marshalling area with an
  -- invalid read context.

  ERROR_LOG_RESTART_INVALID                                 =  6607,  -- (#19CF)
  -- Log service encountered an invalid log restart area.

  ERROR_LOG_BLOCK_VERSION                                   =  6608,  -- (#19D0)
  -- Log service encountered an invalid log block version.

  ERROR_LOG_BLOCK_INVALID                                   =  6609,  -- (#19D1)
  -- Log service encountered an invalid log block.

  ERROR_LOG_READ_MODE_INVALID                               =  6610,  -- (#19D2)
  -- Log service encountered an attempt to read the log with an invalid read
  -- mode.

  ERROR_LOG_NO_RESTART                                      =  6611,  -- (#19D3)
  -- Log service encountered a log stream with no restart area.

  ERROR_LOG_METADATA_CORRUPT                                =  6612,  -- (#19D4)
  -- Log service encountered a corrupted metadata file.

  ERROR_LOG_METADATA_INVALID                                =  6613,  -- (#19D5)
  -- Log service encountered a metadata file that could not be created by the
  -- log file system.

  ERROR_LOG_METADATA_INCONSISTENT                           =  6614,  -- (#19D6)
  -- Log service encountered a metadata file with inconsistent data.

  ERROR_LOG_RESERVATION_INVALID                             =  6615,  -- (#19D7)
  -- Log service encountered an attempt to erroneous allocate or dispose
  -- reservation space.

  ERROR_LOG_CANT_DELETE                                     =  6616,  -- (#19D8)
  -- Log service cannot delete log file or file system container.

  ERROR_LOG_CONTAINER_LIMIT_EXCEEDED                        =  6617,  -- (#19D9)
  -- Log service has reached the maximum allowable containers allocated to a log
  -- file.

  ERROR_LOG_START_OF_LOG                                    =  6618,  -- (#19DA)
  -- Log service has attempted to read or write backward past the start of the
  -- log.

  ERROR_LOG_POLICY_ALREADY_INSTALLED                        =  6619,  -- (#19DB)
  -- Log policy could not be installed because a policy of the same type is
  -- already present.

  ERROR_LOG_POLICY_NOT_INSTALLED                            =  6620,  -- (#19DC)
  -- Log policy in question was not installed at the time of the request.

  ERROR_LOG_POLICY_INVALID                                  =  6621,  -- (#19DD)
  -- The installed set of policies on the log is invalid.

  ERROR_LOG_POLICY_CONFLICT                                 =  6622,  -- (#19DE)
  -- A policy on the log in question prevented the operation from completing.

  ERROR_LOG_PINNED_ARCHIVE_TAIL                             =  6623,  -- (#19DF)
  -- Log space cannot be reclaimed because the log is pinned by the archive
  -- tail.

  ERROR_LOG_RECORD_NONEXISTENT                              =  6624,  -- (#19E0)
  -- Log record is not a record in the log file.

  ERROR_LOG_RECORDS_RESERVED_INVALID                        =  6625,  -- (#19E1)
  -- Number of reserved log records or the adjustment of the number of reserved
  -- log records is invalid.

  ERROR_LOG_SPACE_RESERVED_INVALID                          =  6626,  -- (#19E2)
  -- Reserved log space or the adjustment of the log space is invalid.

  ERROR_LOG_TAIL_INVALID                                    =  6627,  -- (#19E3)
  -- An new or existing archive tail or base of the active log is invalid.

  ERROR_LOG_FULL                                            =  6628,  -- (#19E4)
  -- Log space is exhausted.

  ERROR_COULD_NOT_RESIZE_LOG                                =  6629,  -- (#19E5)
  -- The log could not be set to the requested size.

  ERROR_LOG_MULTIPLEXED                                     =  6630,  -- (#19E6)
  -- Log is multiplexed, no direct writes to the physical log is allowed.

  ERROR_LOG_DEDICATED                                       =  6631,  -- (#19E7)
  -- The operation failed because the log is a dedicated log.

  ERROR_LOG_ARCHIVE_NOT_IN_PROGRESS                         =  6632,  -- (#19E8)
  -- The operation requires an archive context.

  ERROR_LOG_ARCHIVE_IN_PROGRESS                             =  6633,  -- (#19E9)
  -- Log archival is in progress.

  ERROR_LOG_EPHEMERAL                                       =  6634,  -- (#19EA)
  -- The operation requires a non-ephemeral log, but the log is ephemeral.

  ERROR_LOG_NOT_ENOUGH_CONTAINERS                           =  6635,  -- (#19EB)
  -- The log must have at least two containers before it can be read from or
  -- written to.

  ERROR_LOG_CLIENT_ALREADY_REGISTERED                       =  6636,  -- (#19EC)
  -- A log client has already registered on the stream.

  ERROR_LOG_CLIENT_NOT_REGISTERED                           =  6637,  -- (#19ED)
  -- A log client has not been registered on the stream.

  ERROR_LOG_FULL_HANDLER_IN_PROGRESS                        =  6638,  -- (#19EE)
  -- A request has already been made to handle the log full condition.

  ERROR_LOG_CONTAINER_READ_FAILED                           =  6639,  -- (#19EF)
  -- Log service encountered an error when attempting to read from a log
  -- container.

  ERROR_LOG_CONTAINER_WRITE_FAILED                          =  6640,  -- (#19F0)
  -- Log service encountered an error when attempting to write to a log
  -- container.

  ERROR_LOG_CONTAINER_OPEN_FAILED                           =  6641,  -- (#19F1)
  -- Log service encountered an error when attempting open a log container.

  ERROR_LOG_CONTAINER_STATE_INVALID                         =  6642,  -- (#19F2)
  -- Log service encountered an invalid container state when attempting a
  -- requested action.

  ERROR_LOG_STATE_INVALID                                   =  6643,  -- (#19F3)
  -- Log service is not in the correct state to perform a requested action.

  ERROR_LOG_PINNED                                          =  6644,  -- (#19F4)
  -- Log space cannot be reclaimed because the log is pinned.

  ERROR_LOG_METADATA_FLUSH_FAILED                           =  6645,  -- (#19F5)
  -- Log metadata flush failed.

  ERROR_LOG_INCONSISTENT_SECURITY                           =  6646,  -- (#19F6)
  -- Security on the log and its containers is inconsistent.

  ERROR_LOG_APPENDED_FLUSH_FAILED                           =  6647,  -- (#19F7)
  -- Records were appended to the log or reservation changes were made, but the
  -- log could not be flushed.

  ERROR_LOG_PINNED_RESERVATION                              =  6648,  -- (#19F8)
  -- The log is pinned due to reservation consuming most of the log space.
  -- Free some reserved records to make space available.

  ERROR_INVALID_TRANSACTION                                 =  6700,  -- (#1A2C)
  -- The transaction handle associated with this operation is not valid.

  ERROR_TRANSACTION_NOT_ACTIVE                             =  6701,  -- (#1A2D)
  -- The requested operation was made in the context of a transaction that is no
  -- longer active.

  ERROR_TRANSACTION_REQUEST_NOT_VALID                       =  6702,  -- (#1A2E)
  -- The requested operation is not valid on the Transaction object in its
  -- current state.

  ERROR_TRANSACTION_NOT_REQUESTED                           =  6703,  -- (#1A2F)
  -- The caller has called a response API, but the response is not expected
  -- because the TM did not issue the corresponding request to the caller.

  ERROR_TRANSACTION_ALREADY_ABORTED                         =  6704,  -- (#1A30)
  -- It is too late to perform the requested operation, since the Transaction
  -- has already been aborted.

  ERROR_TRANSACTION_ALREADY_COMMITTED                       =  6705,  -- (#1A31)
  -- It is too late to perform the requested operation, since the Transaction
  -- has already been committed.

  ERROR_TM_INITIALIZATION_FAILED                            =  6706,  -- (#1A32)
  -- The Transaction Manager was unable to be successfully initialized.
  -- Transacted operations are not supported.

  ERROR_RESOURCEMANAGER_READ_ONLY                           =  6707,  -- (#1A33)
  -- The specified ResourceManager made no changes or updates to the resource
  -- under this transaction.

  ERROR_TRANSACTION_NOT_JOINED                              =  6708,  -- (#1A34)
  -- The resource manager has attempted to prepare a transaction that it has not
  -- successfully joined.

  ERROR_TRANSACTION_SUPERIOR_EXISTS                         =  6709,  -- (#1A35)
  -- The Transaction object already has a superior enlistment, and the caller
  -- attempted an operation that would have created a new superior. Only a
  -- single superior enlistment is allow.

  ERROR_CRM_PROTOCOL_ALREADY_EXISTS                         =  6710,  -- (#1A36)
  -- The RM tried to register a protocol that already exists.

  ERROR_TRANSACTION_PROPAGATION_FAILED                      =  6711,  -- (#1A37)
  -- The attempt to propagate the Transaction failed.

  ERROR_CRM_PROTOCOL_NOT_FOUND                              =  6712,  -- (#1A38)
  -- The requested propagation protocol was not registered as a CRM.

  ERROR_TRANSACTION_INVALID_MARSHALL_BUFFER                 =  6713,  -- (#1A39)
  -- The buffer passed in to PushTransaction or PullTransaction is not in a
  -- valid format.

  ERROR_CURRENT_TRANSACTION_NOT_VALID                       =  6714,  -- (#1A3A)
  -- The current transaction context associated with the thread is not a valid
  -- handle to a transaction object.

  ERROR_TRANSACTION_NOT_FOUND                               =  6715,  -- (#1A3B)
  -- The specified Transaction object could not be opened, because it was not
  -- found.

  ERROR_RESOURCEMANAGER_NOT_FOUND                           =  6716,  -- (#1A3C)
  -- The specified ResourceManager object could not be opened, because it was
  -- not found.

  ERROR_ENLISTMENT_NOT_FOUND                                =  6717,  -- (#1A3D)
  -- The specified Enlistment object could not be opened, because it was not
  -- found.

  ERROR_TRANSACTIONMANAGER_NOT_FOUND                        =  6718,  -- (#1A3E)
  -- The specified TransactionManager object could not be opened, because it was
  -- not found.

  ERROR_TRANSACTIONMANAGER_NOT_ONLINE                       =  6719,  -- (#1A3F)
  -- The object specified could not be created or opened, because its associated 
  -- TransactionManager is not online. The TransactionManager must be brought
  -- fully Online by calling RecoverTransactionManager to recover to the end of
  -- its LogFile before objects in its Transaction or ResourceManager namespaces
  -- can be opened. In addition, errors in writing records to its LogFile can
  -- cause a TransactionManager to go offline.

  ERROR_TRANSACTIONMANAGER_RECOVERY_NAME_COLLISION          =  6720,  -- (#1A40)
  -- The specified TransactionManager was unable to create the objects contained
  -- in its logfile in the Ob namespace. Therefore, the TransactionManager was
  -- unable to recover.

  ERROR_TRANSACTION_NOT_ROOT                                =  6721,  -- (#1A41)
  -- The call to create a superior Enlistment on this Transaction object could
  -- not be completed, because the Transaction object specified for the
  -- enlistment is a subordinate branch of the Transaction. Only the root of the
  -- Transaction can be enlisted on as a superior.

  ERROR_TRANSACTION_OBJECT_EXPIRED                          =  6722,  -- (#1A42)
  -- Because the associated transaction manager or resource manager has been
  -- closed, the handle is no longer valid.

  ERROR_TRANSACTION_RESPONSE_NOT_ENLISTED                   =  6723,  -- (#1A43)
  -- The specified operation could not be performed on this Superior enlistment,
  -- because the enlistment was not created with the corresponding completion
  -- response in the NotificationMask.

  ERROR_TRANSACTION_RECORD_TOO_LONG                         =  6724,  -- (#1A44)
  -- The specified operation could not be performed, because the record that
  -- would be logged was too long. This can occur because of two conditions:
  -- either there are too many Enlistments on this Transaction, or the combined
  -- RecoveryInformation being logged on behalf of those Enlistments is too
  -- long.

  ERROR_IMPLICIT_TRANSACTION_NOT_SUPPORTED                  =  6725,  -- (#1A45)
  -- Implicit transaction are not supported.

  ERROR_TRANSACTION_INTEGRITY_VIOLATED                      =  6726,  -- (#1A46)
  -- The kernel transaction manager had to abort or forget the transaction
  -- because it blocked forward progress.

  ERROR_TRANSACTIONMANAGER_IDENTITY_MISMATCH                =  6727,  -- (#1A47)
  -- The TransactionManager identity that was supplied did not match the one
  -- recorded in the TransactionManager's log file.

  ERROR_RM_CANNOT_BE_FROZEN_FOR_SNAPSHOT                    =  6728,  -- (#1A48)
  -- This snapshot operation cannot continue because a transactional resource
  -- manager cannot be frozen in its current state. Please try again.

  ERROR_TRANSACTION_MUST_WRITETHROUGH                       =  6729,  -- (#1A49)
  -- The transaction cannot be enlisted on with the specified EnlistmentMask,
  -- because the transaction has already completed the PrePrepare phase. In
  -- order to ensure correctness, the ResourceManager must switch to a
  -- write-through mode and cease caching data within this transaction.
  -- Enlisting for only subsequent transaction phases may still succeed.

  ERROR_TRANSACTION_NO_SUPERIOR                             =  6730,  -- (#1A4A)
  -- The transaction does not have a superior enlistment.

  ERROR_HEURISTIC_DAMAGE_POSSIBLE                           =  6731,  -- (#1A4B)
  -- The attempt to commit the Transaction completed, but it is possible that
  -- some portion of the transaction tree did not commit successfully due to
  -- heuristics. Therefore it is possible that some data modified in the
  -- transaction may not have committed, resulting in transactional
  -- inconsistency. If possible, check the consistency of the associated data.

  ERROR_TRANSACTIONAL_CONFLICT                              =  6800,  -- (#1A90)
  -- The function attempted to use a name that is reserved for use by another
  -- transaction.

  ERROR_RM_NOT_ACTIVE                                       =  6801,  -- (#1A91)
  -- Transaction support within the specified file system resource manager is
  -- not started or was shutdown due to an error.

  ERROR_RM_METADATA_CORRUPT                                 =  6802,  -- (#1A92)
  -- The metadata of the RM has been corrupted. The RM will not function.

  ERROR_DIRECTORY_NOT_RM                                    =  6803,  -- (#1A93)
  -- The specified directory does not contain a resource manager.

  ERROR_TRANSACTIONS_UNSUPPORTED_REMOTE                     =  6805,  -- (#1A95)
  -- The remote server or share does not support transacted file operations.

  ERROR_LOG_RESIZE_INVALID_SIZE                             =  6806,  -- (#1A96)
  -- The requested log size is invalid.

  ERROR_OBJECT_NO_LONGER_EXISTS                             =  6807,  -- (#1A97)
  -- The object (file, stream, link) corresponding to the handle has been
  -- deleted by a transaction savepoint rollback.

  ERROR_STREAM_MINIVERSION_NOT_FOUND                        =  6808,  -- (#1A98)
  -- The specified file miniversion was not found for this transacted file open.

  ERROR_STREAM_MINIVERSION_NOT_VALID                        =  6809,  -- (#1A99)
  -- The specified file miniversion was found but has been invalidated. Most
  -- likely cause is a transaction savepoint rollback.

  ERROR_MINIVERSION_INACCESSIBLE_FROM_SPECIFIED_TRANSACTION =  6810,  -- (#1A9A)
  -- A miniversion may only be opened in the context of the transaction that
  -- created it.

  ERROR_CANT_OPEN_MINIVERSION_WITH_MODIFY_INTENT            =  6811,  -- (#1A9B)
  -- It is not possible to open a miniversion with modify access.

  ERROR_CANT_CREATE_MORE_STREAM_MINIVERSIONS                =  6812,  -- (#1A9C)
  -- It is not possible to create any more miniversions for this stream.

  ERROR_REMOTE_FILE_VERSION_MISMATCH                        =  6814,  -- (#1A9E)
  -- The remote server sent mismatching version number or Fid for a file opened
  -- with transactions.

  ERROR_HANDLE_NO_LONGER_VALID                              =  6815,  -- (#1A9F)
  -- The handle has been invalidated by a transaction. The most likely cause is
  -- the presence of memory mapping on a file or an open handle when the
  -- transaction ended or rolled back to savepoint.

  ERROR_NO_TXF_METADATA                                     =  6816,  -- (#1AA0)
  -- There is no transaction metadata on the file.

  ERROR_LOG_CORRUPTION_DETECTED                             =  6817,  -- (#1AA1)
  -- The log data is corrupt.

  ERROR_CANT_RECOVER_WITH_HANDLE_OPEN                       =  6818,  -- (#1AA2)
  -- The file can't be recovered because there is a handle still open on it.

  ERROR_RM_DISCONNECTED                                     =  6819,  -- (#1AA3)
  -- The transaction outcome is unavailable because the resource manager
  -- responsible for it has disconnected.

  ERROR_ENLISTMENT_NOT_SUPERIOR                             =  6820,  -- (#1AA4)
  -- The request was rejected because the enlistment in question is not a
  -- superior enlistment.

  ERROR_RECOVERY_NOT_NEEDED                                 =  6821,  -- (#1AA5)
  -- The transactional resource manager is already consistent. Recovery is not
  -- needed.

  ERROR_RM_ALREADY_STARTED                                  =  6822,  -- (#1AA6)
  -- The transactional resource manager has already been started.

  ERROR_FILE_IDENTITY_NOT_PERSISTENT                        =  6823,  -- (#1AA7)
  -- The file cannot be opened transactionally, because its identity depends on
  -- the outcome of an unresolved transaction.

  ERROR_CANT_BREAK_TRANSACTIONAL_DEPENDENCY                 =  6824,  -- (#1AA8)
  -- The operation cannot be performed because another transaction is depending
  -- on the fact that this property will not change.

  ERROR_CANT_CROSS_RM_BOUNDARY                              =  6825,  -- (#1AA9)
  -- The operation would involve a single file with two transactional resource
  -- managers and is therefore not allowed.

  ERROR_TXF_DIR_NOT_EMPTY                                   =  6826,  -- (#1AAA)
  -- The $Txf directory must be empty for this operation to succeed.

  ERROR_INDOUBT_TRANSACTIONS_EXIST                          =  6827,  -- (#1AAB)
  -- The operation would leave a transactional resource manager in an
  -- inconsistent state and is therefore not allowed.

  ERROR_TM_VOLATILE                                         =  6828,  -- (#1AAC)
  -- The operation could not be completed because the transaction manager does
  -- not have a log.

  ERROR_ROLLBACK_TIMER_EXPIRED                              =  6829,  -- (#1AAD)
  -- A rollback could not be scheduled because a previously scheduled rollback
  -- has already executed or been queued for execution.

  ERROR_TXF_ATTRIBUTE_CORRUPT                               =  6830,  -- (#1AAE)
  -- The transactional metadata attribute on the file or directory is corrupt
  -- and unreadable.

  ERROR_EFS_NOT_ALLOWED_IN_TRANSACTION                      =  6831,  -- (#1AAF)
  -- The encryption operation could not be completed because a transaction is
  -- active.

  ERROR_TRANSACTIONAL_OPEN_NOT_ALLOWED                      =  6832,  -- (#1AB0)
  -- This object is not allowed to be opened in a transaction.

  ERROR_LOG_GROWTH_FAILED                                   =  6833,  -- (#1AB1)
  -- An attempt to create space in the transactional resource manager's log
  -- failed. The failure status has been recorded in the event log.

  ERROR_TRANSACTED_MAPPING_UNSUPPORTED_REMOTE               =  6834,  -- (#1AB2)
  -- Memory mapping (creating a mapped section) a remote file under a
  -- transaction is not supported.

  ERROR_TXF_METADATA_ALREADY_PRESENT                        =  6835,  -- (#1AB3)
  -- Transaction metadata is already present on this file and cannot be
  -- superseded.

  ERROR_TRANSACTION_SCOPE_CALLBACKS_NOT_SET                 =  6836,  -- (#1AB4)
  -- A transaction scope could not be entered because the scope handler has not
  -- been initialized.

  ERROR_TRANSACTION_REQUIRED_PROMOTION                      =  6837,  -- (#1AB5)
  -- Promotion was required in order to allow the resource manager to enlist,
  -- but the transaction was set to disallow it.

  ERROR_CANNOT_EXECUTE_FILE_IN_TRANSACTION                  =  6838,  -- (#1AB6)
  -- This file is open for modification in an unresolved transaction and may be
  -- opened for execute only by a transacted reader.

  ERROR_TRANSACTIONS_NOT_FROZEN                             =  6839,  -- (#1AB7)
  -- The request to thaw frozen transactions was ignored because transactions
  -- had not previously been frozen.

  ERROR_TRANSACTION_FREEZE_IN_PROGRESS                      =  6840,  -- (#1AB8)
  -- Transactions cannot be frozen because a freeze is already in progress.

  ERROR_NOT_SNAPSHOT_VOLUME                                 =  6841,  -- (#1AB9)
  -- The target volume is not a snapshot volume. This operation is only valid on
  -- a volume mounted as a snapshot.

  ERROR_NO_SAVEPOINT_WITH_OPEN_FILES                        =  6842,  -- (#1ABA)
  -- The savepoint operation failed because files are open on the transaction.
  -- This is not permitted.

  ERROR_DATA_LOST_REPAIR                                    =  6843,  -- (#1ABB)
  -- Windows has discovered corruption in a file, and that file has since been
  -- repaired. Data loss may have occurred.

  ERROR_SPARSE_NOT_ALLOWED_IN_TRANSACTION                   =  6844,  -- (#1ABC)
  -- The sparse operation could not be completed because a transaction is active
  -- on the file.

  ERROR_TM_IDENTITY_MISMATCH                                =  6845,  -- (#1ABD)
  -- The call to create a TransactionManager object failed because the Tm
  -- Identity stored in the logfile does not match the Tm Identity that was
  -- passed in as an argument.

  ERROR_FLOATED_SECTION                                     =  6846,  -- (#1ABE)
  -- I/O was attempted on a section object that has been floated as a result of
  -- a transaction ending. There is no valid data.

  ERROR_CANNOT_ACCEPT_TRANSACTED_WORK                       =  6847,  -- (#1ABF)
  -- The transactional resource manager cannot currently accept transacted work
  -- due to a transient condition such as low resources.

  ERROR_CANNOT_ABORT_TRANSACTIONS                           =  6848,  -- (#1AC0)
  -- The transactional resource manager had too many tranactions outstanding
  -- that could not be aborted. The transactional resource manger has been shut
  -- down.

  ERROR_BAD_CLUSTERS                                        =  6849,  -- (#1AC1)
  -- The operation could not be completed due to bad clusters on disk.

  ERROR_COMPRESSION_NOT_ALLOWED_IN_TRANSACTION              =  6850,  -- (#1AC2)
  -- The compression operation could not be completed because a transaction is
  -- active on the file.

  ERROR_VOLUME_DIRTY                                        =  6851,  -- (#1AC3)
  -- The operation could not be completed because the volume is dirty. Please
  -- run chkdsk and try again.

  ERROR_NO_LINK_TRACKING_IN_TRANSACTION                     =  6852,  -- (#1AC4)
  -- The link tracking operation could not be completed because a transaction is
  -- active.

  ERROR_OPERATION_NOT_SUPPORTED_IN_TRANSACTION              =  6853,  -- (#1AC5)
  -- This operation cannot be performed in a transaction.

  ERROR_EXPIRED_HANDLE                                      =  6854,  -- (#1AC6)
  -- The handle is no longer properly associated with its transaction. It may
  -- have been opened in a transactional resource manager that was subsequently
  -- forced to restart. Please close the handle and open a new one.

  ERROR_TRANSACTION_NOT_ENLISTED                            =  6855,  -- (#1AC7)
  -- The specified operation could not be performed because the resource manager
  -- is not enlisted in the transaction.

  ERROR_CTX_WINSTATION_NAME_INVALID                         =  7001,  -- (#1B59)
  -- The specified session name is invalid.

  ERROR_CTX_INVALID_PD                                      =  7002,  -- (#1B5A)
  -- The specified protocol driver is invalid.

  ERROR_CTX_PD_NOT_FOUND                                    =  7003,  -- (#1B5B)
  -- The specified protocol driver was not found in the system path.

  ERROR_CTX_WD_NOT_FOUND                                    =  7004,  -- (#1B5C)
  -- The specified terminal connection driver was not found in the system path.

  ERROR_CTX_CANNOT_MAKE_EVENTLOG_ENTRY                      =  7005,  -- (#1B5D)
  -- A registry key for event logging could not be created for this session.

  ERROR_CTX_SERVICE_NAME_COLLISION                          =  7006,  -- (#1B5E)
  -- A service with the same name already exists on the system.

  ERROR_CTX_CLOSE_PENDING                                   =  7007,  -- (#1B5F)
  -- A close operation is pending on the session.

  ERROR_CTX_NO_OUTBUF                                       =  7008,  -- (#1B60)
  -- There are no free output buffers available.

  ERROR_CTX_MODEM_INF_NOT_FOUND                             =  7009,  -- (#1B61)
  -- The MODEM.INF file was not found.

  ERROR_CTX_INVALID_MODEMNAME                               =  7010,  -- (#1B62)
  -- The modem name was not found in MODEM.INF.

  ERROR_CTX_MODEM_RESPONSE_ERROR                            =  7011,  -- (#1B63)
  -- The modem did not accept the command sent to it. Verify that the configured
  -- modem name matches the attached modem.

  ERROR_CTX_MODEM_RESPONSE_TIMEOUT                          =  7012,  -- (#1B64)
  -- The modem did not respond to the command sent to it. Verify that the modem
  -- is properly cabled and powered on.

  ERROR_CTX_MODEM_RESPONSE_NO_CARRIER                       =  7013,  -- (#1B65)
  -- Carrier detect has failed or carrier has been dropped due to disconnect.

  ERROR_CTX_MODEM_RESPONSE_NO_DIALTONE                      =  7014,  -- (#1B66)
  -- Dial tone not detected within the required time. Verify that the phone
  -- cable is properly attached and functional.

  ERROR_CTX_MODEM_RESPONSE_BUSY                             =  7015,  -- (#1B67)
  -- Busy signal detected at remote site on callback.

  ERROR_CTX_MODEM_RESPONSE_VOICE                            =  7016,  -- (#1B68)
  -- Voice detected at remote site on callback.

  ERROR_CTX_TD_ERROR                                        =  7017,  -- (#1B69)
  -- Transport driver error.
  
  ERROR_CTX_WINSTATION_NOT_FOUND                            =  7022,  -- (#1B6E)
  -- The specified session cannot be found.

  ERROR_CTX_WINSTATION_ALREADY_EXISTS                       =  7023,  -- (#1B6F)
  -- The specified session name is already in use.

  ERROR_CTX_WINSTATION_BUSY                                 =  7024,  -- (#1B70)
  -- The requested operation cannot be completed because the terminal connection
  -- is currently busy processing a connect, disconnect, reset, or delete
  -- operation.

  ERROR_CTX_BAD_VIDEO_MODE                                  =  7025,  -- (#1B71)
  -- An attempt has been made to connect to a session whose video mode is not
  -- supported by the current client.

  ERROR_CTX_GRAPHICS_INVALID                                =  7035,  -- (#1B7B)
  -- The application attempted to enable DOS graphics mode. DOS graphics mode is
  -- not supported.

  ERROR_CTX_LOGON_DISABLED                                  =  7037,  -- (#1B7D)
  -- Your interactive logon privilege has been disabled. Please contact your
  -- administrator.

  ERROR_CTX_NOT_CONSOLE                                     =  7038,  -- (#1B7E)
  -- The requested operation can be performed only on the system console. This
  -- is most often the result of a driver or system DLL requiring direct console
  -- access.

  ERROR_CTX_CLIENT_QUERY_TIMEOUT                            =  7040,  -- (#1B80)
  -- The client failed to respond to the server connect message.

  ERROR_CTX_CONSOLE_DISCONNECT                              =  7041,  -- (#1B81)
  -- Disconnecting the console session is not supported.

  ERROR_CTX_CONSOLE_CONNECT                                 =  7042,  -- (#1B82)
  -- Reconnecting a disconnected session to the console is not supported.

  ERROR_CTX_SHADOW_DENIED                                   =  7044,  -- (#1B84)
  -- The request to control another session remotely was denied.

  ERROR_CTX_WINSTATION_ACCESS_DENIED                        =  7045,  -- (#1B85)
  -- The requested session access is denied.

  ERROR_CTX_INVALID_WD                                      =  7049,  -- (#1B89)
  -- The specified terminal connection driver is invalid.

  ERROR_CTX_SHADOW_INVALID                                  =  7050,  -- (#1B8A)
  -- The requested session cannot be controlled remotely. This may be because
  -- the session is disconnected or does not currently have a user logged on.
  -- Also, you cannot control a session remotely from the system console and you
  -- cannot remote control your own current session.

  ERROR_CTX_SHADOW_DISABLED                                 =  7051,  -- (#1B8B)
  -- The requested session is not configured to allow remote control.

  ERROR_CTX_CLIENT_LICENSE_IN_USE                           =  7052,  -- (#1B8C)
  -- Your request to connect to this Terminal Server has been rejected. Your
  -- Terminal Server client license number is currently being used by another
  -- user. Please call your system administrator to obtain a new copy of the
  -- Terminal Server client with a valid, unique license number.

  ERROR_CTX_CLIENT_LICENSE_NOT_SET                          =  7053,  -- (#1B8D)
  -- Your request to connect to this Terminal Server has been rejected. Your
  -- Terminal Server client license number has not been entered for this copy of
  -- the Terminal Server client. Please call your system administrator for help
  -- in entering a valid, unique license number for this Terminal Server client.

  ERROR_CTX_LICENSE_NOT_AVAILABLE                           =  7054,  -- (#1B8E)
  -- The system has reached its licensed logon limit. Please try again later.

  ERROR_CTX_LICENSE_CLIENT_INVALID                          =  7055,  -- (#1B8F)
  -- The client you are using is not licensed to use this system. Your logon
  -- request is denied.

  ERROR_CTX_LICENSE_EXPIRED                                 =  7056,  -- (#1B90)
  -- The system license has expired. Your logon request is denied.

  ERROR_CTX_SHADOW_NOT_RUNNING                              =  7057,  -- (#1B91)
  -- Remote control could not be terminated because the specified session is not
  -- currently being remotely controlled.

  ERROR_CTX_SHADOW_ENDED_BY_MODE_CHANGE                     =  7058,  -- (#1B92)
  -- The remote control of the console was terminated because the display mode
  -- was changed. Changing the display mode in a remote control session is not
  -- supported.

  ERROR_ACTIVATION_COUNT_EXCEEDED                           =  7059,  -- (#1B93)
  -- Activation has already been reset the maximum number of times for this
  -- installation. Your activation timer will not be cleared.

  ERROR_CTX_WINSTATIONS_DISABLED                            =  7060,  -- (#1B94)
  -- Remote logins are currently disabled.

  ERROR_CTX_ENCRYPTION_LEVEL_REQUIRED                       =  7061,  -- (#1B95)
  -- You do not have the proper encryption level to access this Session.

  ERROR_CTX_SESSION_IN_USE                                  =  7062,  -- (#1B96)
  -- The user %s\\%s is currently logged on to this computer. Only the current
  -- user or an administrator can log on to this computer.

  ERROR_CTX_NO_FORCE_LOGOFF                                 =  7063,  -- (#1B97)
  -- The user %s\\%s is already logged on to the console of this computer. You
  -- do not have permission to log in at this time. To resolve this issue,
  -- contact %s\\%s and have them log off.

  ERROR_CTX_ACCOUNT_RESTRICTION                             =  7064,  -- (#1B98)
  -- Unable to log you on because of an account restriction.

  ERROR_RDP_PROTOCOL_ERROR                                  =  7065,  -- (#1B99)
  -- The RDP protocol component %2 detected an error in the protocol stream and
  -- has disconnected the client.

  ERROR_CTX_CDM_CONNECT                                     =  7066,  -- (#1B9A)
  -- The Client Drive Mapping Service Has Connected on Terminal Connection.

  ERROR_CTX_CDM_DISCONNECT                                  =  7067,  -- (#1B9B)
  -- The Client Drive Mapping Service Has Disconnected on Terminal Connection.

  ERROR_CTX_SECURITY_LAYER_ERROR                            =  7068,  -- (#1B9C)
  -- The Terminal Server security layer detected an error in the protocol stream
  -- and has disconnected the client.

  ERROR_TS_INCOMPATIBLE_SESSIONS                            =  7069,  -- (#1B9D)
  -- The target session is incompatible with the current session.

  ERROR_TS_VIDEO_SUBSYSTEM_ERROR                            =  7070,  -- (#1B9E)
  -- Windows can't connect to your session because a problem occurred in the
  -- Windows video subsystem. Try connecting again later, or contact the server
  -- administrator for assistance.

  FRS_ERR_INVALID_API_SEQUENCE                              =  8001,  -- (#1F41)
  -- The file replication service API was called incorrectly.

  FRS_ERR_STARTING_SERVICE                                  =  8002,  -- (#1F42)
  -- The file replication service cannot be started.

  FRS_ERR_STOPPING_SERVICE                                  =  8003,  -- (#1F43)
  -- The file replication service cannot be stopped.

  FRS_ERR_INTERNAL_API                                      =  8004,  -- (#1F44)
  -- The file replication service API terminated the request. The event log may
  -- have more information.

  FRS_ERR_INTERNAL                                          =  8005,  -- (#1F45)
  -- The file replication service terminated the request. The event log may have
  -- more information.

  FRS_ERR_SERVICE_COMM                                      =  8006,  -- (#1F46)
  -- The file replication service cannot be contacted. The event log may have
  -- more information.

  FRS_ERR_INSUFFICIENT_PRIV                                 =  8007,  -- (#1F47)
  -- The file replication service cannot satisfy the request because the user
  -- has insufficient privileges. The event log may have more information.

  FRS_ERR_AUTHENTICATION                                    =  8008,  -- (#1F48)
  -- The file replication service cannot satisfy the request because
  -- authenticated RPC is not available. The event log may have more
  -- information.

  FRS_ERR_PARENT_INSUFFICIENT_PRIV                          =  8009,  -- (#1F49)
  -- The file replication service cannot satisfy the request because the user
  -- has insufficient privileges on the domain controller. The event log may
  -- have more information.

  FRS_ERR_PARENT_AUTHENTICATION                             =  8010,  -- (#1F4A)
  -- The file replication service cannot satisfy the request because
  -- authenticated RPC is not available on the domain controller. The event log
  -- may have more information.

  FRS_ERR_CHILD_TO_PARENT_COMM                              =  8011,  -- (#1F4B)
  -- The file replication service cannot communicate with the file replication
  -- service on the domain controller. The event log may have more information.

  FRS_ERR_PARENT_TO_CHILD_COMM                              =  8012,  -- (#1F4C)
  -- The file replication service on the domain controller cannot communicate
  -- with the file replication service on this computer. The event log may have
  -- more information.

  FRS_ERR_SYSVOL_POPULATE                                   =  8013,  -- (#1F4D)
  -- The file replication service cannot populate the system volume because of
  -- an internal error. The event log may have more information.

  FRS_ERR_SYSVOL_POPULATE_TIMEOUT                           =  8014,  -- (#1F4E)
  -- The file replication service cannot populate the system volume because of
  -- an internal timeout. The event log may have more information.

  FRS_ERR_SYSVOL_IS_BUSY                                    =  8015,  -- (#1F4F)
  -- The file replication service cannot process the request. The system volume
  -- is busy with a previous request.

  FRS_ERR_SYSVOL_DEMOTE                                     =  8016,  -- (#1F50)
  -- The file replication service cannot stop replicating the system volume
  -- because of an internal error. The event log may have more information.

  FRS_ERR_INVALID_SERVICE_PARAMETER                         =  8017,  -- (#1F51)
  -- The file replication service detected an invalid parameter.

  ERROR_DS_NOT_INSTALLED                                    =  8200,  -- (#2008)
  -- An error occurred while installing the directory service. For more
  -- information, see the event log.

  ERROR_DS_MEMBERSHIP_EVALUATED_LOCALLY                     =  8201,  -- (#2009)
  -- The directory service evaluated group memberships locally.

  ERROR_DS_NO_ATTRIBUTE_OR_VALUE                            =  8202,  -- (#200A)
  -- The specified directory service attribute or value does not exist.

  ERROR_DS_INVALID_ATTRIBUTE_SYNTAX                         =  8203,  -- (#200B)
  -- The attribute syntax specified to the directory service is invalid.

  ERROR_DS_ATTRIBUTE_TYPE_UNDEFINED                         =  8204,  -- (#200C)
  -- The attribute type specified to the directory service is not defined.

  ERROR_DS_ATTRIBUTE_OR_VALUE_EXISTS                        =  8205,  -- (#200D)
  -- The specified directory service attribute or value already exists.

  ERROR_DS_BUSY                                             =  8206,  -- (#200E)
  -- The directory service is busy.

  ERROR_DS_UNAVAILABLE                                      =  8207,  -- (#200F)
  -- The directory service is unavailable.

  ERROR_DS_NO_RIDS_ALLOCATED                                =  8208,  -- (#2010)
  -- The directory service was unable to allocate a relative identifier.

  ERROR_DS_NO_MORE_RIDS                                     =  8209,  -- (#2011)
  -- The directory service has exhausted the pool of relative identifiers.

  ERROR_DS_INCORRECT_ROLE_OWNER                             =  8210,  -- (#2012)
  -- The requested operation could not be performed because the directory
  -- service is not the master for that type of operation.

  ERROR_DS_RIDMGR_INIT_ERROR                                =  8211,  -- (#2013)
  -- The directory service was unable to initialize the subsystem that allocates
  -- relative identifiers.

  ERROR_DS_OBJ_CLASS_VIOLATION                              =  8212,  -- (#2014)
  -- The requested operation did not satisfy one or more constraints associated
  -- with the class of the object.

  ERROR_DS_CANT_ON_NON_LEAF                                 =  8213,  -- (#2015)
  -- The directory service can perform the requested operation only on a leaf
  -- object.

  ERROR_DS_CANT_ON_RDN                                      =  8214,  -- (#2016)
  -- The directory service cannot perform the requested operation on the RDN
  -- attribute of an object.

  ERROR_DS_CANT_MOD_OBJ_CLASS                               =  8215,  -- (#2017)
  -- The directory service detected an attempt to modify the object class of an
  -- object.

  ERROR_DS_CROSS_DOM_MOVE_ERROR                             =  8216,  -- (#2018)
  -- The requested cross-domain move operation could not be performed.

  ERROR_DS_GC_NOT_AVAILABLE                                 =  8217,  -- (#2019)
  -- Unable to contact the public catalog server.

  ERROR_SHARED_POLICY                                       =  8218,  -- (#201A)
  -- The policy object is shared and can only be modified at the root.

  ERROR_POLICY_OBJECT_NOT_FOUND                             =  8219,  -- (#201B)
  -- The policy object does not exist.

  ERROR_POLICY_ONLY_IN_DS                                   =  8220,  -- (#201C)
  -- The requested policy information is only in the directory service.

  ERROR_PROMOTION_ACTIVE                                    =  8221,  -- (#201D)
  -- A domain controller promotion is currently active.

  ERROR_NO_PROMOTION_ACTIVE                                 =  8222,  -- (#201E)
  -- A domain controller promotion is not currently active.
  
  ERROR_DS_OPERATIONS_ERROR                                 =  8224,  -- (#2020)
  -- An operations error occurred.

  ERROR_DS_PROTOCOL_ERROR                                   =  8225,  -- (#2021)
  -- A protocol error occurred.

  ERROR_DS_TIMELIMIT_EXCEEDED                               =  8226,  -- (#2022)
  -- The time limit for this request was exceeded.

  ERROR_DS_SIZELIMIT_EXCEEDED                               =  8227,  -- (#2023)
  -- The size limit for this request was exceeded.

  ERROR_DS_ADMIN_LIMIT_EXCEEDED                             =  8228,  -- (#2024)
  -- The administrative limit for this request was exceeded.

  ERROR_DS_COMPARE_FALSE                                    =  8229,  -- (#2025)
  -- The compare response was false.

  ERROR_DS_COMPARE_TRUE                                     =  8230,  -- (#2026)
  -- The compare response was true.

  ERROR_DS_AUTH_METHOD_NOT_SUPPORTED                        =  8231,  -- (#2027)
  -- The requested authentication method is not supported by the server.

  ERROR_DS_STRONG_AUTH_REQUIRED                             =  8232,  -- (#2028)
  -- A more secure authentication method is required for this server.

  ERROR_DS_INAPPROPRIATE_AUTH                               =  8233,  -- (#2029)
  -- Inappropriate authentication.

  ERROR_DS_AUTH_UNKNOWN                                     =  8234,  -- (#202A)
  -- The authentication mechanism is unknown.

  ERROR_DS_REFERRAL                                         =  8235,  -- (#202B)
  -- A referral was returned from the server.

  ERROR_DS_UNAVAILABLE_CRIT_EXTENSION                       =  8236,  -- (#202C)
  -- The server does not support the requested critical extension.

  ERROR_DS_CONFIDENTIALITY_REQUIRED                         =  8237,  -- (#202D)
  -- This request requires a secure connection.

  ERROR_DS_INAPPROPRIATE_MATCHING                           =  8238,  -- (#202E)
  -- Inappropriate matching.

  ERROR_DS_CONSTRAINT_VIOLATION                             =  8239,  -- (#202F)
  -- A constraint violation occurred.

  ERROR_DS_NO_SUCH_OBJECT                                   =  8240,  -- (#2030)
  -- There is no such object on the server.

  ERROR_DS_ALIAS_PROBLEM                                    =  8241,  -- (#2031)
  -- There is an alias problem.

  ERROR_DS_INVALID_DN_SYNTAX                                =  8242,  -- (#2032)
  -- An invalid dn syntax has been specified.

  ERROR_DS_IS_LEAF                                          =  8243,  -- (#2033)
  -- The object is a leaf object.

  ERROR_DS_ALIAS_DEREF_PROBLEM                             =  8244,  -- (#2034)
  -- There is an alias dereferencing problem.

  ERROR_DS_UNWILLING_TO_PERFORM                             =  8245,  -- (#2035)
  -- The server is unwilling to process the request.

  ERROR_DS_LOOP_DETECT                                      =  8246,  -- (#2036)
  -- A loop has been detected.

  ERROR_DS_NAMING_VIOLATION                                 =  8247,  -- (#2037)
  -- There is a naming violation.

  ERROR_DS_OBJECT_RESULTS_TOO_LARGE                         =  8248,  -- (#2038)
  -- The result set is too large.

  ERROR_DS_AFFECTS_MULTIPLE_DSAS                            =  8249,  -- (#2039)
  -- The operation affects multiple DSAs.
  
  ERROR_DS_SERVER_DOWN                                      =  8250,  -- (#203A)
  -- The server is not operational.

  ERROR_DS_LOCAL_ERROR                                      =  8251,  -- (#203B)
  -- A local error has occurred.

  ERROR_DS_ENCODING_ERROR                                   =  8252,  -- (#203C)
  -- An encoding error has occurred.

  ERROR_DS_DECODING_ERROR                                   =  8253,  -- (#203D)
  -- A decoding error has occurred.

  ERROR_DS_FILTER_UNKNOWN                                   =  8254,  -- (#203E)
  -- The search filter cannot be recognized.

  ERROR_DS_PARAM_ERROR                                      =  8255,  -- (#203F)
  -- One or more parameters are illegal.

  ERROR_DS_NOT_SUPPORTED                                    =  8256,  -- (#2040)
  -- The specified method is not supported.

  ERROR_DS_NO_RESULTS_RETURNED                              =  8257,  -- (#2041)
  -- No results were returned.

  ERROR_DS_CONTROL_NOT_FOUND                                =  8258,  -- (#2042)
  -- The specified control is not supported by the server.

  ERROR_DS_CLIENT_LOOP                                      =  8259,  -- (#2043)
  -- A referral loop was detected by the client.

  ERROR_DS_REFERRAL_LIMIT_EXCEEDED                          =  8260,  -- (#2044)
  -- The preset referral limit was exceeded.

  ERROR_DS_SORT_CONTROL_MISSING                             =  8261,  -- (#2045)
  -- The search requires a SORT control.

  ERROR_DS_OFFSET_RANGE_ERROR                               =  8262,  -- (#2046)
  -- The search results exceed the offset range specified.

  ERROR_DS_ROOT_MUST_BE_NC                                  =  8301,  -- (#206D)
  -- The root object must be the head of a naming context. The root object
  -- cannot have an instantiated parent.

  ERROR_DS_ADD_REPLICA_INHIBITED                            =  8302,  -- (#206E)
  -- The add replica operation cannot be performed. The naming context must be
  -- writable in order to create the replica.

  ERROR_DS_ATT_NOT_DEF_IN_SCHEMA                            =  8303,  -- (#206F)
  -- A reference to an attribute that is not defined in the schema occurred.

  ERROR_DS_MAX_OBJ_SIZE_EXCEEDED                            =  8304,  -- (#2070)
  -- The maximum size of an object has been exceeded.

  ERROR_DS_OBJ_STRING_NAME_EXISTS                           =  8305,  -- (#2071)
  -- An attempt was made to add an object to the directory with a name that is
  -- already in use.

  ERROR_DS_NO_RDN_DEFINED_IN_SCHEMA                         =  8306,  -- (#2072)
  -- An attempt was made to add an object of a class that does not have an RDN
  -- defined in the schema.

  ERROR_DS_RDN_DOESNT_MATCH_SCHEMA                          =  8307,  -- (#2073)
  -- An attempt was made to add an object using an RDN that is not the RDN
  -- defined in the schema.

  ERROR_DS_NO_REQUESTED_ATTS_FOUND                          =  8308,  -- (#2074)
  -- None of the requested attributes were found on the objects.

  ERROR_DS_USER_BUFFER_TO_SMALL                             =  8309,  -- (#2075)
  -- The user buffer is too small.

  ERROR_DS_ATT_IS_NOT_ON_OBJ                                =  8310,  -- (#2076)
  -- The attribute specified in the operation is not present on the object.

  ERROR_DS_ILLEGAL_MOD_OPERATION                            =  8311,  -- (#2077)
  -- Illegal modify operation. Some aspect of the modification is not permitted.

  ERROR_DS_OBJ_TOO_LARGE                                    =  8312,  -- (#2078)
  -- The specified object is too large.

  ERROR_DS_BAD_INSTANCE_TYPE                                =  8313,  -- (#2079)
  -- The specified instance type is not valid.

  ERROR_DS_MASTERDSA_REQUIRED                               =  8314,  -- (#207A)
  -- The operation must be performed at a master DSA.

  ERROR_DS_OBJECT_CLASS_REQUIRED                            =  8315,  -- (#207B)
  -- The object class attribute must be specified.

  ERROR_DS_MISSING_REQUIRED_ATT                             =  8316,  -- (#207C)
  -- A required attribute is missing.

  ERROR_DS_ATT_NOT_DEF_FOR_CLASS                            =  8317,  -- (#207D)
  -- An attempt was made to modify an object to include an attribute that is not
  -- legal for its class.

  ERROR_DS_ATT_ALREADY_EXISTS                               =  8318,  -- (#207E)
  -- The specified attribute is already present on the object.

  ERROR_DS_CANT_ADD_ATT_VALUES                              =  8320,  -- (#2080)
  -- The specified attribute is not present, or has no values.

  ERROR_DS_SINGLE_VALUE_CONSTRAINT                          =  8321,  -- (#2081)
  -- Multiple values were specified for an attribute that can have only one
  -- value.

  ERROR_DS_RANGE_CONSTRAINT                                 =  8322,  -- (#2082)
  -- A value for the attribute was not in the acceptable range of values.

  ERROR_DS_ATT_VAL_ALREADY_EXISTS                           =  8323,  -- (#2083)
  -- The specified value already exists.

  ERROR_DS_CANT_REM_MISSING_ATT                             =  8324,  -- (#2084)
  -- The attribute cannot be removed because it is not present on the object.

  ERROR_DS_CANT_REM_MISSING_ATT_VAL                         =  8325,  -- (#2085)
  -- The attribute value cannot be removed because it is not present on the
  -- object.

  ERROR_DS_ROOT_CANT_BE_SUBREF                              =  8326,  -- (#2086)
  -- The specified root object cannot be a subref.

  ERROR_DS_NO_CHAINING                                      =  8327,  -- (#2087)
  -- Chaining is not permitted.

  ERROR_DS_NO_CHAINED_EVAL                                  =  8328,  -- (#2088)
  -- Chained evaluation is not permitted.

  ERROR_DS_NO_PARENT_OBJECT                                 =  8329,  -- (#2089)
  -- The operation could not be performed because the object's parent is either
  -- uninstantiated or deleted.

  ERROR_DS_PARENT_IS_AN_ALIAS                               =  8330,  -- (#208A)
  -- Having a parent that is an alias is not permitted. Aliases are leaf
  -- objects.

  ERROR_DS_CANT_MIX_MASTER_AND_REPS                         =  8331,  -- (#208B)
  -- The object and parent must be of the same type, either both masters or both
  -- replicas.

  ERROR_DS_CHILDREN_EXIST                                   =  8332,  -- (#208C)
  -- The operation cannot be performed because child objects exist. This
  -- operation can only be performed on a leaf object.

  ERROR_DS_OBJ_NOT_FOUND                                    =  8333,  -- (#208D)
  -- Directory object not found.

  ERROR_DS_ALIASED_OBJ_MISSING                              =  8334,  -- (#208E)
  -- The aliased object is missing.

  ERROR_DS_BAD_NAME_SYNTAX                                  =  8335,  -- (#208F)
  -- The object name has bad syntax.

  ERROR_DS_ALIAS_POINTS_TO_ALIAS                            =  8336,  -- (#2090)
  -- It is not permitted for an alias to refer to another alias.

  ERROR_DS_CANT_DEREF_ALIAS                                 =  8337,  -- (#2091)
  -- The alias cannot be dereferenced.

  ERROR_DS_OUT_OF_SCOPE                                     =  8338,  -- (#2092)
  -- The operation is out of scope.

  ERROR_DS_CANT_DELETE_DSA_OBJ                              =  8340,  -- (#2094)
  -- The DSA object cannot be deleted.

  ERROR_DS_GENERIC_ERROR                                    =  8341,  -- (#2095)
  -- A directory service error has occurred.

  ERROR_DS_DSA_MUST_BE_INT_MASTER                           =  8342,  -- (#2096)
  -- The operation can only be performed on an internal master DSA object.

  ERROR_DS_CLASS_NOT_DSA                                    =  8343,  -- (#2097)
  -- The object must be of class DSA.

  ERROR_DS_INSUFF_ACCESS_RIGHTS                             =  8344,  -- (#2098)
  -- Insufficient access rights to perform the operation.

  ERROR_DS_ILLEGAL_SUPERIOR                                 =  8345,  -- (#2099)
  -- The object cannot be added because the parent is not on the list of
  -- possible superiors.

  ERROR_DS_ATTRIBUTE_OWNED_BY_SAM                           =  8346,  -- (#209A)
  -- Access to the attribute is not permitted because the attribute is owned by
  -- the Security Accounts Manager (SAM).

  ERROR_DS_NAME_TOO_MANY_PARTS                              =  8347,  -- (#209B)
  -- The name has too many parts.

  ERROR_DS_NAME_TOO_LONG                                    =  8348,  -- (#209C)
  -- The name is too long.

  ERROR_DS_NAME_VALUE_TOO_LONG                              =  8349,  -- (#209D)
  -- The name value is too long.

  ERROR_DS_NAME_UNPARSEABLE                                 =  8350,  -- (#209E)
  -- The directory service encountered an error parsing a name.

  ERROR_DS_NAME_TYPE_UNKNOWN                                =  8351,  -- (#209F)
  -- The directory service cannot get the attribute type for a name.

  ERROR_DS_NOT_AN_OBJECT                                    =  8352,  -- (#20A0)
  -- The name does not identify an object; the name identifies a phantom.

  ERROR_DS_SEC_DESC_TOO_SHORT                               =  8353,  -- (#20A1)
  -- The security descriptor is too short.

  ERROR_DS_SEC_DESC_INVALID                                 =  8354,  -- (#20A2)
  -- The security descriptor is invalid.

  ERROR_DS_NO_DELETED_NAME                                  =  8355,  -- (#20A3)
  -- Failed to create name for deleted object.

  ERROR_DS_SUBREF_MUST_HAVE_PARENT                          =  8356,  -- (#20A4)
  -- The parent of a new subref must exist.

  ERROR_DS_NCNAME_MUST_BE_NC                                =  8357,  -- (#20A5)
  -- The object must be a naming context.

  ERROR_DS_CANT_ADD_SYSTEM_ONLY                             =  8358,  -- (#20A6)
  -- It is not permitted to add an attribute which is owned by the system.

  ERROR_DS_CLASS_MUST_BE_CONCRETE                           =  8359,  -- (#20A7)
  -- The class of the object must be structural; you cannot instantiate an
  -- abstract class.

  ERROR_DS_INVALID_DMD                                      =  8360,  -- (#20A8)
  -- The schema object could not be found.

  ERROR_DS_OBJ_GUID_EXISTS                                  =  8361,  -- (#20A9)
  -- A local object with this GUID (dead or alive) already exists.

  ERROR_DS_NOT_ON_BACKLINK                                  =  8362,  -- (#20AA)
  -- The operation cannot be performed on a back link.

  ERROR_DS_NO_CROSSREF_FOR_NC                               =  8363,  -- (#20AB)
  -- The cross reference for the specified naming context could not be found.

  ERROR_DS_SHUTTING_DOWN                                    =  8364,  -- (#20AC)
  -- The operation could not be performed because the directory service is
  -- shutting down.

  ERROR_DS_UNKNOWN_OPERATION                                =  8365,  -- (#20AD)
  -- The directory service request is invalid.

  ERROR_DS_INVALID_ROLE_OWNER                               =  8366,  -- (#20AE)
  -- The role owner attribute could not be read.

  ERROR_DS_COULDNT_CONTACT_FSMO                             =  8367,  -- (#20AF)
  -- The requested FSMO operation failed. The current FSMO holder could not be
  -- reached.

  ERROR_DS_CROSS_NC_DN_RENAME                               =  8368,  -- (#20B0)
  -- Modification of a DN across a naming context is not permitted.

  ERROR_DS_CANT_MOD_SYSTEM_ONLY                             =  8369,  -- (#20B1)
  -- The attribute cannot be modified because it is owned by the system.

  ERROR_DS_REPLICATOR_ONLY                                  =  8370,  -- (#20B2)
  -- Only the replicator can perform this function.

  ERROR_DS_OBJ_CLASS_NOT_DEFINED                            =  8371,  -- (#20B3)
  -- The specified class is not defined.

  ERROR_DS_OBJ_CLASS_NOT_SUBCLASS                           =  8372,  -- (#20B4)
  -- The specified class is not a subclass.

  ERROR_DS_NAME_REFERENCE_INVALID                           =  8373,  -- (#20B5)
  -- The name reference is invalid.

  ERROR_DS_CROSS_REF_EXISTS                                 =  8374,  -- (#20B6)
  -- A cross reference already exists.

  ERROR_DS_CANT_DEL_MASTER_CROSSREF                         =  8375,  -- (#20B7)
  -- It is not permitted to delete a master cross reference.

  ERROR_DS_SUBTREE_NOTIFY_NOT_NC_HEAD                       =  8376,  -- (#20B8)
  -- Subtree notifications are only supported on NC heads.

  ERROR_DS_NOTIFY_FILTER_TOO_COMPLEX                        =  8377,  -- (#20B9)
  -- Notification filter is too complex.

  ERROR_DS_DUP_RDN                                          =  8378,  -- (#20BA)
  -- Schema update failed: duplicate RDN.

  ERROR_DS_DUP_OID                                          =  8379,  -- (#20BB)
  -- Schema update failed: duplicate OID.

  ERROR_DS_DUP_MAPI_ID                                      =  8380,  -- (#20BC)
  -- Schema update failed: duplicate MAPI identifier.

  ERROR_DS_DUP_SCHEMA_ID_GUID                               =  8381,  -- (#20BD)
  -- Schema update failed: duplicate schema-id GUID.

  ERROR_DS_DUP_LDAP_DISPLAY_NAME                            =  8382,  -- (#20BE)
  -- Schema update failed: duplicate LDAP display name.

  ERROR_DS_SEMANTIC_ATT_TEST                                =  8383,  -- (#20BF)
  -- Schema update failed: range-lower less than range upper.
  
  ERROR_DS_SYNTAX_MISMATCH                                  =  8384,  -- (#20C0)
  -- Schema update failed: syntax mismatch.
  
  ERROR_DS_EXISTS_IN_MUST_HAVE                              =  8385,  -- (#20C1)
  -- Schema deletion failed: attribute is used in must-contain.
  
  ERROR_DS_EXISTS_IN_MAY_HAVE                               =  8386,  -- (#20C2)
  -- Schema deletion failed: attribute is used in may-contain.
  
  ERROR_DS_NONEXISTENT_MAY_HAVE                             =  8387,  -- (#20C3)
  -- Schema update failed: attribute in may-contain does not exist.
  
  ERROR_DS_NONEXISTENT_MUST_HAVE                            =  8388,  -- (#20C4)
  -- Schema update failed: attribute in must-contain does not exist.
  
  ERROR_DS_AUX_CLS_TEST_FAIL                                =  8389,  -- (#20C5)
  -- Schema update failed: class in aux-class list does not exist or is not an
  -- auxiliary class.
  
  ERROR_DS_NONEXISTENT_POSS_SUP                             =  8390,  -- (#20C6)
  -- Schema update failed: class in poss-superiors does not exist.
  
  ERROR_DS_SUB_CLS_TEST_FAIL                                =  8391,  -- (#20C7)
  -- Schema update failed: class in subclassof list does not exist or does not
  -- satisfy hierarchy rules.
  
  ERROR_DS_BAD_RDN_ATT_ID_SYNTAX                            =  8392,  -- (#20C8)
  -- Schema update failed: Rdn-Att-Id has wrong syntax.

  ERROR_DS_EXISTS_IN_AUX_CLS                                =  8393,  -- (#20C9)
  -- Schema deletion failed: class is used as auxiliary class.
  
  ERROR_DS_EXISTS_IN_SUB_CLS                                =  8394,  -- (#20CA)
  -- Schema deletion failed: class is used as sub class.
  
  ERROR_DS_EXISTS_IN_POSS_SUP                               =  8395,  -- (#20CB)
  -- Schema deletion failed: class is used as poss superior.
  
  ERROR_DS_RECALCSCHEMA_FAILED                              =  8396,  -- (#20CC)
  -- Schema update failed in recalculating validation cache.

  ERROR_DS_TREE_DELETE_NOT_FINISHED                         =  8397,  -- (#20CD)
  -- The tree deletion is not finished.

  ERROR_DS_CANT_DELETE                                      =  8398,  -- (#20CE)
  -- The requested delete operation could not be performed.

  ERROR_DS_ATT_SCHEMA_REQ_ID                                =  8399,  -- (#20CF)
  -- Cannot read the governs class identifier for the schema record.

  ERROR_DS_BAD_ATT_SCHEMA_SYNTAX                            =  8400,  -- (#20D0)
  -- The attribute schema has bad syntax.

  ERROR_DS_CANT_CACHE_ATT                                   =  8401,  -- (#20D1)
  -- The attribute could not be cached.

  ERROR_DS_CANT_CACHE_CLASS                                 =  8402,  -- (#20D2)
  -- The class could not be cached.

  ERROR_DS_CANT_REMOVE_ATT_CACHE                            =  8403,  -- (#20D3)
  -- The attribute could not be removed from the cache.

  ERROR_DS_CANT_REMOVE_CLASS_CACHE                          =  8404,  -- (#20D4)
  -- The class could not be removed from the cache.

  ERROR_DS_CANT_RETRIEVE_DN                                 =  8405,  -- (#20D5)
  -- The distinguished name attribute could not be read.

  ERROR_DS_MISSING_SUPREF                                   =  8406,  -- (#20D6)
  -- A required subref is missing.

  ERROR_DS_CANT_RETRIEVE_INSTANCE                           =  8407,  -- (#20D7)
  -- The instance type attribute could not be retrieved.

  ERROR_DS_CODE_INCONSISTENCY                               =  8408,  -- (#20D8)
  -- An internal error has occurred.

  ERROR_DS_DATABASE_ERROR                                   =  8409,  -- (#20D9)
  -- A database error has occurred.

  ERROR_DS_GOVERNSID_MISSING                                =  8410,  -- (#20DA)
  -- The attribute GOVERNSID is missing.

  ERROR_DS_MISSING_EXPECTED_ATT                             =  8411,  -- (#20DB)
  -- An expected attribute is missing.

  ERROR_DS_NCNAME_MISSING_CR_REF                            =  8412,  -- (#20DC)
  -- The specified naming context is missing a cross reference.

  ERROR_DS_SECURITY_CHECKING_ERROR                          =  8413,  -- (#20DD)
  -- A security checking error has occurred.

  ERROR_DS_SCHEMA_NOT_LOADED                                =  8414,  -- (#20DE)
  -- The schema is not loaded.

  ERROR_DS_SCHEMA_ALLOC_FAILED                              =  8415,  -- (#20DF)
  -- Schema allocation failed. Please check if the machine is running low on
  -- memory.

  ERROR_DS_ATT_SCHEMA_REQ_SYNTAX                            =  8416,  -- (#20E0)
  -- Failed to obtain the required syntax for the attribute schema.

  ERROR_DS_GCVERIFY_ERROR                                   =  8417,  -- (#20E1)
  -- The public catalog verification failed. The public catalog is not available
  -- or does not support the operation. Some part of the directory is currently
  -- not available.

  ERROR_DS_DRA_SCHEMA_MISMATCH                              =  8418,  -- (#20E2)
  -- The replication operation failed because of a schema mismatch between the
  -- servers involved.

  ERROR_DS_CANT_FIND_DSA_OBJ                                =  8419,  -- (#20E3)
  -- The DSA object could not be found.

  ERROR_DS_CANT_FIND_EXPECTED_NC                            =  8420,  -- (#20E4)
  -- The naming context could not be found.

  ERROR_DS_CANT_FIND_NC_IN_CACHE                            =  8421,  -- (#20E5)
  -- The naming context could not be found in the cache.

  ERROR_DS_CANT_RETRIEVE_CHILD                              =  8422,  -- (#20E6)
  -- The child object could not be retrieved.

  ERROR_DS_SECURITY_ILLEGAL_MODIFY                          =  8423,  -- (#20E7)
  -- The modification was not permitted for security reasons.

  ERROR_DS_CANT_REPLACE_HIDDEN_REC                          =  8424,  -- (#20E8)
  -- The operation cannot replace the hidden record.

  ERROR_DS_BAD_HIERARCHY_FILE                               =  8425,  -- (#20E9)
  -- The hierarchy file is invalid.

  ERROR_DS_BUILD_HIERARCHY_TABLE_FAILED                     =  8426,  -- (#20EA)
  -- The attempt to build the hierarchy table failed.

  ERROR_DS_CONFIG_PARAM_MISSING                             =  8427,  -- (#20EB)
  -- The directory configuration parameter is missing from the registry.

  ERROR_DS_COUNTING_AB_INDICES_FAILED                       =  8428,  -- (#20EC)
  -- The attempt to count the address book indices failed.

  ERROR_DS_HIERARCHY_TABLE_MALLOC_FAILED                    =  8429,  -- (#20ED)
  -- The allocation of the hierarchy table failed.

  ERROR_DS_INTERNAL_FAILURE                                 =  8430,  -- (#20EE)
  -- The directory service encountered an internal failure.

  ERROR_DS_UNKNOWN_ERROR                                    =  8431,  -- (#20EF)
  -- The directory service encountered an unknown failure.

  ERROR_DS_ROOT_REQUIRES_CLASS_TOP                          =  8432,  -- (#20F0)
  -- A root object requires a class of 'top'.

  ERROR_DS_REFUSING_FSMO_ROLES                              =  8433,  -- (#20F1)
  -- This directory server is shutting down, and cannot take ownership of new
  -- floating single-master operation roles.

  ERROR_DS_MISSING_FSMO_SETTINGS                            =  8434,  -- (#20F2)
  -- The directory service is missing mandatory configuration information, and
  -- is unable to determine the ownership of floating single-master operation
  -- roles.

  ERROR_DS_UNABLE_TO_SURRENDER_ROLES                        =  8435,  -- (#20F3)
  -- The directory service was unable to transfer ownership of one or more
  -- floating single-master operation roles to other servers.

  ERROR_DS_DRA_GENERIC                                      =  8436,  -- (#20F4)
  -- The replication operation failed.

  ERROR_DS_DRA_INVALID_PARAMETER                            =  8437,  -- (#20F5)
  -- An invalid parameter was specified for this replication operation.

  ERROR_DS_DRA_BUSY                                         =  8438,  -- (#20F6)
  -- The directory service is too busy to complete the replication operation at
  -- this time.

  ERROR_DS_DRA_BAD_DN                                       =  8439,  -- (#20F7)
  -- The distinguished name specified for this replication operation is invalid.

  ERROR_DS_DRA_BAD_NC                                       =  8440,  -- (#20F8)
  -- The naming context specified for this replication operation is invalid.

  ERROR_DS_DRA_DN_EXISTS                                    =  8441,  -- (#20F9)
  -- The distinguished name specified for this replication operation already
  -- exists.

  ERROR_DS_DRA_INTERNAL_ERROR                               =  8442,  -- (#20FA)
  -- The replication system encountered an internal error.

  ERROR_DS_DRA_INCONSISTENT_DIT                             =  8443,  -- (#20FB)
  -- The replication operation encountered a database inconsistency.

  ERROR_DS_DRA_CONNECTION_FAILED                            =  8444,  -- (#20FC)
  -- The server specified for this replication operation could not be contacted.

  ERROR_DS_DRA_BAD_INSTANCE_TYPE                            =  8445,  -- (#20FD)
  -- The replication operation encountered an object with an invalid instance
  -- type.

  ERROR_DS_DRA_OUT_OF_MEM                                   =  8446,  -- (#20FE)
  -- The replication operation failed to allocate memory.

  ERROR_DS_DRA_MAIL_PROBLEM                                 =  8447,  -- (#20FF)
  -- The replication operation encountered an error with the mail system.

  ERROR_DS_DRA_REF_ALREADY_EXISTS                           =  8448,  -- (#2100)
  -- The replication reference information for the target server already exists.

  ERROR_DS_DRA_REF_NOT_FOUND                                =  8449,  -- (#2101)
  -- The replication reference information for the target server does not exist.

  ERROR_DS_DRA_OBJ_IS_REP_SOURCE                            =  8450,  -- (#2102)
  -- The naming context cannot be removed because it is replicated to another
  -- server.

  ERROR_DS_DRA_DB_ERROR                                     =  8451,  -- (#2103)
  -- The replication operation encountered a database error.

  ERROR_DS_DRA_NO_REPLICA                                   =  8452,  -- (#2104)
  -- The naming context is in the process of being removed or is not replicated
  -- from the specified server.

  ERROR_DS_DRA_ACCESS_DENIED                                =  8453,  -- (#2105)
  -- Replication access was denied.

  ERROR_DS_DRA_NOT_SUPPORTED                                =  8454,  -- (#2106)
  -- The requested operation is not supported by this version of the directory
  -- service.

  ERROR_DS_DRA_RPC_CANCELLED                                =  8455,  -- (#2107)
  -- The replication remote procedure call was cancelled.

  ERROR_DS_DRA_SOURCE_DISABLED                              =  8456,  -- (#2108)
  -- The source server is currently rejecting replication requests.

  ERROR_DS_DRA_SINK_DISABLED                                =  8457,  -- (#2109)
  -- The destination server is currently rejecting replication requests.

  ERROR_DS_DRA_NAME_COLLISION                               =  8458,  -- (#210A)
  -- The replication operation failed due to a collision of object names.

  ERROR_DS_DRA_SOURCE_REINSTALLED                           =  8459,  -- (#210B)
  -- The replication source has been reinstalled.

  ERROR_DS_DRA_MISSING_PARENT                               =  8460,  -- (#210C)
  -- The replication operation failed because a required parent object is
  -- missing.

  ERROR_DS_DRA_PREEMPTED                                    =  8461,  -- (#210D)
  -- The replication operation was preempted.

  ERROR_DS_DRA_ABANDON_SYNC                                 =  8462,  -- (#210E)
  -- The replication synchronization attempt was abandoned because of a lack of
  -- updates.

  ERROR_DS_DRA_SHUTDOWN                                     =  8463,  -- (#210F)
  -- The replication operation was terminated because the system is shutting
  -- down.

  ERROR_DS_DRA_INCOMPATIBLE_PARTIAL_SET                     =  8464,  -- (#2110)
  -- The replication synchronization attempt failed as the destination partial
  -- attribute set is not a subset of source partial attribute set.

  ERROR_DS_DRA_SOURCE_IS_PARTIAL_REPLICA                    =  8465,  -- (#2111)
  -- The replication synchronization attempt failed because a master replica
  -- attempted to sync from a partial replica.

  ERROR_DS_DRA_EXTN_CONNECTION_FAILED                       =  8466,  -- (#2112)
  -- The server specified for this replication operation was contacted, but that
  -- server was unable to contact an additional server needed to complete the
  -- operation.

  ERROR_DS_INSTALL_SCHEMA_MISMATCH                          =  8467,  -- (#2113)
  -- A schema mismatch is detected between the source and the build used during
  -- a replica install. The replica cannot be installed.

  ERROR_DS_DUP_LINK_ID                                      =  8468,  -- (#2114)
  -- Schema update failed: An attribute with the same link identifier already
  -- exists.

  ERROR_DS_NAME_ERROR_RESOLVING                             =  8469,  -- (#2115)
  -- Name translation: Generic processing error.

  ERROR_DS_NAME_ERROR_NOT_FOUND                             =  8470,  -- (#2116)
  -- Name translation: Could not find the name or insufficient right to see
  -- name.

  ERROR_DS_NAME_ERROR_NOT_UNIQUE                            =  8471,  -- (#2117)
  -- Name translation: Input name mapped to more than one output name.

  ERROR_DS_NAME_ERROR_NO_MAPPING                            =  8472,  -- (#2118)
  -- Name translation: Input name found, but not the associated output format.

  ERROR_DS_NAME_ERROR_DOMAIN_ONLY                           =  8473,  -- (#2119)
  -- Name translation: Unable to resolve completely, only the domain was found.

  ERROR_DS_NAME_ERROR_NO_SYNTACTICAL_MAPPING                =  8474,  -- (#211A)
  -- Name translation: Unable to perform purely syntactical mapping at the
  -- client without going out to the wire.

  ERROR_DS_CONSTRUCTED_ATT_MOD                              =  8475,  -- (#211B)
  -- Modification of a constructed att is not allowed.

  ERROR_DS_WRONG_OM_OBJ_CLASS                               =  8476,  -- (#211C)
  -- The OM-Object-Class specified is incorrect for an attribute with the
  -- specified syntax.

  ERROR_DS_DRA_REPL_PENDING                                 =  8477,  -- (#211D)
  -- The replication request has been posted; waiting for reply.

  ERROR_DS_DS_REQUIRED                                      =  8478,  -- (#211E)
  -- The requested operation requires a directory service, and none was
  -- available.

  ERROR_DS_INVALID_LDAP_DISPLAY_NAME                        =  8479,  -- (#211F)
  -- The LDAP display name of the class or attribute contains non-ASCII
  -- characters.

  ERROR_DS_NON_BASE_SEARCH                                  =  8480,  -- (#2120)
  -- The requested search operation is only supported for base searches.

  ERROR_DS_CANT_RETRIEVE_ATTS                               =  8481,  -- (#2121)
  -- The search failed to retrieve attributes from the database.

  ERROR_DS_BACKLINK_WITHOUT_LINK                            =  8482,  -- (#2122)
  -- The schema update operation tried to add a backward link attribute that has
  -- no corresponding forward link.

  ERROR_DS_EPOCH_MISMATCH                                   =  8483,  -- (#2123)
  -- Source and destination of a cross domain move do not agree on the object's
  -- epoch number. Either source or destination does not have the latest version
  -- of the object.

  ERROR_DS_SRC_NAME_MISMATCH                                =  8484,  -- (#2124)
  -- Source and destination of a cross domain move do not agree on the object's
  -- current name. Either source or destination does not have the latest version of the object.

  ERROR_DS_SRC_AND_DST_NC_IDENTICAL                         =  8485,  -- (#2125)
  -- Source and destination of a cross domain move operation are identical.
  -- Caller should use local move operation instead of cross domain move
  -- operation.

  ERROR_DS_DST_NC_MISMATCH                                  =  8486,  -- (#2126)
  -- Source and destination for a cross domain move are not in agreement on the
  -- naming contexts in the forest. Either source or destination does not have
  -- the latest version of the Partitions container.

  ERROR_DS_NOT_AUTHORITIVE_FOR_DST_NC                       =  8487,  -- (#2127)
  -- Destination of a cross domain move is not authoritative for the destination
  -- naming context.

  ERROR_DS_SRC_GUID_MISMATCH                                =  8488,  -- (#2128)
  -- Source and destination of a cross domain move do not agree on the identity
  -- of the source object. Either source or destination does not have the latest
  -- version of the source object.

  ERROR_DS_CANT_MOVE_DELETED_OBJECT                         =  8489,  -- (#2129)
  -- Object being moved across domains is already known to be deleted by the
  -- destination server. The source server does not have the latest version of
  -- the source object.

  ERROR_DS_PDC_OPERATION_IN_PROGRESS                        =  8490,  -- (#212A)
  -- Another operation which requires exclusive access to the PDC PSMO is
  -- already in progress.

  ERROR_DS_CROSS_DOMAIN_CLEANUP_REQD                        =  8491,  -- (#212B)
  -- A cross domain move operation failed such that the two versions of the
  -- moved object exist - one each in the source and destination domains. The
  -- destination object needs to be removed to restore the system to a
  -- consistent state.

  ERROR_DS_ILLEGAL_XDOM_MOVE_OPERATION                      =  8492,  -- (#212C)
  -- This object may not be moved across domain boundaries either because cross
  -- domain moves for this class are disallowed, or the object has some special
  -- characteristics, eg: trust account or restricted RID, which prevent its
  -- move.

  ERROR_DS_CANT_WITH_ACCT_GROUP_MEMBERSHPS                  =  8493,  -- (#212D)
  -- Can't move objects with memberships across domain boundaries as once moved,
  -- this would violate the membership conditions of the account group. Remove
  -- the object from any account group memberships and retry.

  ERROR_DS_NC_MUST_HAVE_NC_PARENT                           =  8494,  -- (#212E)
  -- A naming context head must be the immediate child of another naming context
  -- head, not of an interior node.

  ERROR_DS_CR_IMPOSSIBLE_TO_VALIDATE                        =  8495,  -- (#212F)
  -- The directory cannot validate the proposed naming context name because it
  -- does not hold a replica of the naming context above the proposed naming
  -- context. Please ensure that the domain naming master role is held by a
  -- server that is configured as a public catalog server, and that the server
  -- is up to date with its replication partners.

  ERROR_DS_DST_DOMAIN_NOT_NATIVE                            =  8496,  -- (#2130)
  -- Destination domain must be in native mode.

  ERROR_DS_MISSING_INFRASTRUCTURE_CONTAINER                 =  8497,  -- (#2131)
  -- The operation can not be performed because the server does not have an
  -- infrastructure container in the domain of interest.

  ERROR_DS_CANT_MOVE_ACCOUNT_GROUP                          =  8498,  -- (#2132)
  -- Cross-domain move of non-empty account groups is not allowed.

  ERROR_DS_CANT_MOVE_RESOURCE_GROUP                         =  8499,  -- (#2133)
  -- Cross-domain move of non-empty resource groups is not allowed.

  ERROR_DS_INVALID_SEARCH_FLAG                              =  8500,  -- (#2134)
  -- The search flags for the attribute are invalid. The ANR bit is valid only
  -- on attributes of Unicode or Teletex strings.

  ERROR_DS_NO_TREE_DELETE_ABOVE_NC                          =  8501,  -- (#2135)
  -- Tree deletions starting at an object which has an NC head as a descendant
  -- are not allowed.

  ERROR_DS_COULDNT_LOCK_TREE_FOR_DELETE                     =  8502,  -- (#2136)
  -- The directory service failed to lock a tree in preparation for a tree
  -- deletion because the tree was in use.

  ERROR_DS_COULDNT_IDENTIFY_OBJECTS_FOR_TREE_DELETE         =  8503,  -- (#2137)
  -- The directory service failed to identify the list of objects to delete
  -- while attempting a tree deletion.

  ERROR_DS_SAM_INIT_FAILURE                                 =  8504,  -- (#2138)
  -- Security Accounts Manager initialization failed because of the following
  -- error: %1. Error Status: 0x%2. Click OK to shut down the system and reboot
  -- into Directory Services Restore Mode. Check the event log for detailed
  -- information.

  ERROR_DS_SENSITIVE_GROUP_VIOLATION                        =  8505,  -- (#2139)
  -- Only an administrator can modify the membership list of an administrative
  -- group.

  ERROR_DS_CANT_MOD_PRIMARYGROUPID                          =  8506,  -- (#213A)
  -- Cannot change the primary group ID of a domain controller account.

  ERROR_DS_ILLEGAL_BASE_SCHEMA_MOD                          =  8507,  -- (#213B)
  -- An attempt is made to modify the base schema.

  ERROR_DS_NONSAFE_SCHEMA_CHANGE                            =  8508,  -- (#213C)
  -- Adding a new mandatory attribute to an existing class, deleting a mandatory
  -- attribute from an existing class, or adding an optional attribute to the
  -- special class Top that is not a backlink attribute (directly or through
  -- inheritance, for example, by adding or deleting an auxiliary class) is not
  -- allowed.

  ERROR_DS_SCHEMA_UPDATE_DISALLOWED                         =  8509,  -- (#213D)
  -- Schema update is not allowed on this DC because the DC is not the schema
  -- FSMO Role Owner.

  ERROR_DS_CANT_CREATE_UNDER_SCHEMA                         =  8510,  -- (#213E)
  -- An object of this class cannot be created under the schema container. You
  -- can only create attribute-schema and class-schema objects under the schema
  -- container.

  ERROR_DS_INSTALL_NO_SRC_SCH_VERSION                       =  8511,  -- (#213F)
  -- The replica/child install failed to get the objectVersion attribute on the
  -- schema container on the source DC. Either the attribute is missing on the
  -- schema container or the credentials supplied do not have permission to read
  -- it.

  ERROR_DS_INSTALL_NO_SCH_VERSION_IN_INIFILE                =  8512,  -- (#2140)
  -- The replica/child install failed to read the objectVersion attribute in the
  -- SCHEMA section of the file schema.ini in the system32 directory.

  ERROR_DS_INVALID_GROUP_TYPE                               =  8513,  -- (#2141)
  -- The specified group type is invalid.

  ERROR_DS_NO_NEST_GLOBALGROUP_IN_MIXEDDOMAIN               =  8514,  -- (#2142)
  -- Cannot nest public groups in a mixed domain if the group is security-
  -- enabled.

  ERROR_DS_NO_NEST_LOCALGROUP_IN_MIXEDDOMAIN                =  8515,  -- (#2143)
  -- Cannot nest local groups in a mixed domain if the group is security-
  -- enabled.

  ERROR_DS_GLOBAL_CANT_HAVE_LOCAL_MEMBER                    =  8516,  -- (#2144)
  -- A public group cannot have a local group as a member.

  ERROR_DS_GLOBAL_CANT_HAVE_UNIVERSAL_MEMBER                =  8517,  -- (#2145)
  -- A public group cannot have a universal group as a member.

  ERROR_DS_UNIVERSAL_CANT_HAVE_LOCAL_MEMBER                 =  8518,  -- (#2146)
  -- A universal group cannot have a local group as a member.

  ERROR_DS_GLOBAL_CANT_HAVE_CROSSDOMAIN_MEMBER              =  8519,  -- (#2147)
  -- A public group cannot have a cross-domain member.

  ERROR_DS_LOCAL_CANT_HAVE_CROSSDOMAIN_LOCAL_MEMBER         =  8520,  -- (#2148)
  -- A local group cannot have another cross-domain local group as a member.

  ERROR_DS_HAVE_PRIMARY_MEMBERS                             =  8521,  -- (#2149)
  -- A group with primary members cannot change to a security-disabled group.

  ERROR_DS_STRING_SD_CONVERSION_FAILED                      =  8522,  -- (#214A)
  -- The schema cache load failed to convert the string default SD on a class-
  -- schema object.

  ERROR_DS_NAMING_MASTER_GC                                 =  8523,  -- (#214B)
  -- Only DSAs configured to be Global Catalog servers should be allowed to hold
  -- the Domain Naming Master FSMO role.

  ERROR_DS_LOOKUP_FAILURE                                   =  8524,  -- (#214C)
  -- The DSA operation is unable to proceed because of a DNS lookup failure.

  ERROR_DS_COULDNT_UPDATE_SPNS                              =  8525,  -- (#214D)
  -- While processing a change to the DNS Host Name for an object, the Service
  -- Principal Name values could not be kept in sync.

  ERROR_DS_CANT_RETRIEVE_SD                                 =  8526,  -- (#214E)
  -- The Security Descriptor attribute could not be read.

  ERROR_DS_KEY_NOT_UNIQUE                                   =  8527,  -- (#214F)
  -- The object requested was not found, but an object with that key was found.

  ERROR_DS_WRONG_LINKED_ATT_SYNTAX                          =  8528,  -- (#2150)
  -- The syntax of the linked attributed being added is incorrect. Forward links
  -- can only have syntax 2.

  ERROR_DS_SAM_NEED_BOOTKEY_PASSWORD                        =  8529,  -- (#2151)
  -- Security Account Manager needs to get the boot password.

  ERROR_DS_SAM_NEED_BOOTKEY_FLOPPY                          =  8530,  -- (#2152)
  -- Security Account Manager needs to get the boot key from floppy disk.

  ERROR_DS_CANT_START                                       =  8531,  -- (#2153)
  -- Directory Service cannot start.

  ERROR_DS_INIT_FAILURE                                     =  8532,  -- (#2154)
  -- Directory Services could not start.

  ERROR_DS_NO_PKT_PRIVACY_ON_CONNECTION                     =  8533,  -- (#2155)
  -- The connection between client and server requires packet privacy or better.

  ERROR_DS_SOURCE_DOMAIN_IN_FOREST                          =  8534,  -- (#2156)
  -- The source domain may not be in the same forest as destination.

  ERROR_DS_DESTINATION_DOMAIN_NOT_IN_FOREST                 =  8535,  -- (#2157)
  -- The destination domain must be in the forest.

  ERROR_DS_DESTINATION_AUDITING_NOT_ENABLED                 =  8536,  -- (#2158)
  -- The operation requires that destination domain auditing be enabled.

  ERROR_DS_CANT_FIND_DC_FOR_SRC_DOMAIN                      =  8537,  -- (#2159)
  -- The operation couldn't locate a DC for the source domain.

  ERROR_DS_SRC_OBJ_NOT_GROUP_OR_USER                        =  8538,  -- (#215A)
  -- The source object must be a group or user.

  ERROR_DS_SRC_SID_EXISTS_IN_FOREST                         =  8539,  -- (#215B)
  -- The source object's SID already exists in destination forest.

  ERROR_DS_SRC_AND_DST_OBJECT_CLASS_MISMATCH                =  8540,  -- (#215C)
  -- The source and destination object must be of the same type.

  ERROR_SAM_INIT_FAILURE                                    =  8541,  -- (#215D)
  -- Security Accounts Manager initialization failed because of the following
  -- error: %1. Error Status: 0x%2. Click OK to shut down the system and reboot
  -- into Safe Mode. Check the event log for detailed information.

  ERROR_DS_DRA_SCHEMA_INFO_SHIP                             =  8542,  -- (#215E)
  -- Schema information could not be included in the replication request.

  ERROR_DS_DRA_SCHEMA_CONFLICT                              =  8543,  -- (#215F)
  -- The replication operation could not be completed due to a schema
  -- incompatibility.

  ERROR_DS_DRA_EARLIER_SCHEMA_CONLICT                       =  8544,  -- (#2160)
  -- The replication operation could not be completed due to a previous schema
  -- incompatibility.

  ERROR_DS_DRA_OBJ_NC_MISMATCH                              =  8545,  -- (#2161)
  -- The replication update could not be applied because either the source or
  -- the destination has not yet received information regarding a recent cross-
  -- domain move operation.

  ERROR_DS_NC_STILL_HAS_DSAS                                =  8546,  -- (#2162)
  -- The requested domain could not be deleted because there exist domain
  -- controllers that still host this domain.

  ERROR_DS_GC_REQUIRED                                      =  8547,  -- (#2163)
  -- The requested operation can be performed only on a public catalog server.

  ERROR_DS_LOCAL_MEMBER_OF_LOCAL_ONLY                       =  8548,  -- (#2164)
  -- A local group can only be a member of other local groups in the same domain.

  ERROR_DS_NO_FPO_IN_UNIVERSAL_GROUPS                       =  8549,  -- (#2165)
  -- Foreign security principals cannot be members of universal groups.

  ERROR_DS_CANT_ADD_TO_GC                                   =  8550,  -- (#2166)
  -- The attribute is not allowed to be replicated to the GC because of security
  -- reasons.

  ERROR_DS_NO_CHECKPOINT_WITH_PDC                           =  8551,  -- (#2167)
  -- The checkpoint with the PDC could not be taken because there are too many
  -- modifications being processed currently.

  ERROR_DS_SOURCE_AUDITING_NOT_ENABLED                      =  8552,  -- (#2168)
  -- The operation requires that source domain auditing be enabled.

  ERROR_DS_CANT_CREATE_IN_NONDOMAIN_NC                      =  8553,  -- (#2169)
  -- Security principal objects can only be created inside domain naming
  -- contexts.

  ERROR_DS_INVALID_NAME_FOR_SPN                             =  8554,  -- (#216A)
  -- A Service Principal Name (SPN)
  --  could not be constructed because the provided hostname is not in the
  -- necessary format.

  ERROR_DS_FILTER_USES_CONTRUCTED_ATTRS                     =  8555,  -- (#216B)
  -- A Filter was passed that uses constructed attributes.

  ERROR_DS_UNICODEPWD_NOT_IN_QUOTES                         =  8556,  -- (#216C)
  -- The unicodePwd attribute value must be enclosed in double quotes.

  ERROR_DS_MACHINE_ACCOUNT_QUOTA_EXCEEDED                   =  8557,  -- (#216D)
  -- Your computer could not be joined to the domain. You have exceeded the
  -- maximum number of computer accounts you are allowed to create in this
  -- domain. Contact your system administrator to have this limit reset or
  -- increased.

  ERROR_DS_MUST_BE_RUN_ON_DST_DC                            =  8558,  -- (#216E)
  -- For security reasons, the operation must be run on the destination DC.

  ERROR_DS_SRC_DC_MUST_BE_SP4_OR_GREATER                    =  8559,  -- (#216F)
  -- For security reasons, the source DC must be NT4SP4 or greater.

  ERROR_DS_CANT_TREE_DELETE_CRITICAL_OBJ                    =  8560,  -- (#2170)
  -- Critical Directory Service System objects cannot be deleted during tree
  -- delete operations. The tree delete may have been partially performed.

  ERROR_DS_INIT_FAILURE_CONSOLE                             =  8561,  -- (#2171)
  -- Directory Services could not start because of the following error: %1.

  ERROR_DS_SAM_INIT_FAILURE_CONSOLE                         =  8562,  -- (#2172)
  -- Security Accounts Manager initialization failed because of the following
  -- error: %1.

  ERROR_DS_FOREST_VERSION_TOO_HIGH                          =  8563,  -- (#2173)
  -- This version of Windows is too old to support the current directory forest
  -- behavior. You must upgrade the operating system on this server before it
  -- can become a domain controller in this forest.

  ERROR_DS_DOMAIN_VERSION_TOO_HIGH                          =  8564,  -- (#2174)
  -- This version of Windows is too old to support the current domain behavior.
  -- You must upgrade the operating system on this server before it can become a
  -- domain controller in this domain.

  ERROR_DS_FOREST_VERSION_TOO_LOW                           =  8565,  -- (#2175)
  -- This version of Windows no longer supports the behavior version in use in
  -- this directory forest. You must advance the forest behavior version before
  -- this server can become a domain controller in the forest.

  ERROR_DS_DOMAIN_VERSION_TOO_LOW                           =  8566,  -- (#2176)
  -- This version of Windows no longer supports the behavior version in use in
  -- this domain. You must advance the domain behavior version before this
  -- server can become a domain controller in the domain.

  ERROR_DS_INCOMPATIBLE_VERSION                             =  8567,  -- (#2177)
  -- The version of Windows is incompatible with the behavior version of the
  -- domain or forest.

  ERROR_DS_LOW_DSA_VERSION                                  =  8568,  -- (#2178)
  -- The behavior version cannot be increased to the requested value because
  -- Domain Controllers still exist with versions lower than the requested
  -- value.

  ERROR_DS_NO_BEHAVIOR_VERSION_IN_MIXEDDOMAIN               =  8569,  -- (#2179)
  -- The behavior version value cannot be increased while the domain is still in
  -- mixed domain mode. You must first change the domain to native mode before
  -- increasing the behavior version.

  ERROR_DS_NOT_SUPPORTED_SORT_ORDER                         =  8570,  -- (#217A)
  -- The sort order requested is not supported.

  ERROR_DS_NAME_NOT_UNIQUE                                  =  8571,  -- (#217B)
  -- Found an object with a non unique name.

  ERROR_DS_MACHINE_ACCOUNT_CREATED_PRENT4                   =  8572,  -- (#217C)
  -- The machine account was created pre-NT4. The account needs to be recreated.

  ERROR_DS_OUT_OF_VERSION_STORE                             =  8573,  -- (#217D)
  -- The database is out of version store.

  ERROR_DS_INCOMPATIBLE_CONTROLS_USED                       =  8574,  -- (#217E)
  -- Unable to continue operation because multiple conflicting controls were
  -- used.

  ERROR_DS_NO_REF_DOMAIN                                    =  8575,  -- (#217F)
  -- Unable to find a valid security descriptor reference domain for this
  -- partition.

  ERROR_DS_RESERVED_LINK_ID                                 =  8576,  -- (#2180)
  -- Schema update failed: The link identifier is reserved.

  ERROR_DS_LINK_ID_NOT_AVAILABLE                            =  8577,  -- (#2181)
  -- Schema update failed: There are no link identifiers available.

  ERROR_DS_AG_CANT_HAVE_UNIVERSAL_MEMBER                    =  8578,  -- (#2182)
  -- An account group can not have a universal group as a member.

  ERROR_DS_MODIFYDN_DISALLOWED_BY_INSTANCE_TYPE             =  8579,  -- (#2183)
  -- Rename or move operations on naming context heads or read-only objects are
  -- not allowed.

  ERROR_DS_NO_OBJECT_MOVE_IN_SCHEMA_NC                      =  8580,  -- (#2184)
  -- Move operations on objects in the schema naming context are not allowed.

  ERROR_DS_MODIFYDN_DISALLOWED_BY_FLAG                      =  8581,  -- (#2185)
  -- A system flag has been set on the object and does not allow the object to
  -- be moved or renamed.

  ERROR_DS_MODIFYDN_WRONG_GRANDPARENT                       =  8582,  -- (#2186)
  -- This object is not allowed to change its grandparent container.  Moves are
  -- not forbidden on this object, but are restricted to sibling containers.

  ERROR_DS_NAME_ERROR_TRUST_REFERRAL                        =  8583,  -- (#2187)
  -- Unable to resolve completely, a referral to another forest is generated.

  ERROR_NOT_SUPPORTED_ON_STANDARD_SERVER                    =  8584,  -- (#2188)
  -- The requested action is not supported on standard server.

  ERROR_DS_CANT_ACCESS_REMOTE_PART_OF_AD                    =  8585,  -- (#2189)
  -- Could not access a partition of the directory service located on a remote
  -- server.  Make sure at least one server is running for the partition in
  -- question.

  ERROR_DS_CR_IMPOSSIBLE_TO_VALIDATE_V2                     =  8586,  -- (#218A)
  -- The directory cannot validate the proposed naming context (or partition)
  -- name because it does not hold a replica nor can it contact a replica of the
  -- naming context above the proposed naming context. Please ensure that the
  -- parent naming context is properly registered in DNS, and at least one
  -- replica of this naming context is reachable by the Domain Naming master.

  ERROR_DS_THREAD_LIMIT_EXCEEDED                            =  8587,  -- (#218B)
  -- The thread limit for this request was exceeded.

  ERROR_DS_NOT_CLOSEST                                      =  8588,  -- (#218C)
  -- The Global catalog server is not in the closest site.

  ERROR_DS_CANT_DERIVE_SPN_WITHOUT_SERVER_REF               =  8589,  -- (#218D)
  -- The DS cannot derive a service principal name (SPN) with which to mutually
  -- authenticate the target server because the corresponding server object in
  -- the local DS database has no serverReference attribute.

  ERROR_DS_SINGLE_USER_MODE_FAILED                          =  8590,  -- (#218E)
  -- The Directory Service failed to enter single user mode.

  ERROR_DS_NTDSCRIPT_SYNTAX_ERROR                           =  8591,  -- (#218F)
  -- The Directory Service cannot parse the script because of a syntax error.

  ERROR_DS_NTDSCRIPT_PROCESS_ERROR                          =  8592,  -- (#2190)
  -- The Directory Service cannot process the script because of an error.

  ERROR_DS_DIFFERENT_REPL_EPOCHS                           =  8593,  -- (#2191)
  -- The directory service cannot perform the requested operation because the
  -- servers involved are of different replication epochs (which is usually
  -- related to a domain rename that is in progress).

  ERROR_DS_DRS_EXTENSIONS_CHANGED                           =  8594,  -- (#2192)
  -- The directory service binding must be renegotiated due to a change in the
  -- server extensions information.

  ERROR_DS_REPLICA_SET_CHANGE_NOT_ALLOWED_ON_DISABLED_CR    =  8595,  -- (#2193)
  -- Operation not allowed on a disabled cross ref.

  ERROR_DS_NO_MSDS_INTID                                    =  8596,  -- (#2194)
  -- Schema update failed: No values for msDS-IntId are available.

  ERROR_DS_DUP_MSDS_INTID                                   =  8597,  -- (#2195)
  -- Schema update failed: Duplicate msDS-INtId. Retry the operation.

  ERROR_DS_EXISTS_IN_RDNATTID                               =  8598,  -- (#2196)
  -- Schema deletion failed: attribute is used in rDNAttID.

  ERROR_DS_AUTHORIZATION_FAILED                             =  8599,  -- (#2197)
  -- The directory service failed to authorize the request.

  ERROR_DS_INVALID_SCRIPT                                   =  8600,  -- (#2198)
  -- The Directory Service cannot process the script because it is invalid.

  ERROR_DS_REMOTE_CROSSREF_OP_FAILED                        =  8601,  -- (#2199)
  -- The remote create cross reference operation failed on the Domain Naming
  -- Master FSMO. The operation's error is in the extended data.

  ERROR_DS_CROSS_REF_BUSY                                   =  8602,  -- (#219A)
  -- A cross reference is in use locally with the same name.

  ERROR_DS_CANT_DERIVE_SPN_FOR_DELETED_DOMAIN               =  8603,  -- (#219B)
  -- The DS cannot derive a service principal name (SPN) with which to mutually
  -- authenticate the target server because the server's domain has been
  -- deleted from the forest.

  ERROR_DS_CANT_DEMOTE_WITH_WRITEABLE_NC                    =  8604,  -- (#219C)
  -- Writeable NCs prevent this DC from demoting.

  ERROR_DS_DUPLICATE_ID_FOUND                               =  8605,  -- (#219D)
  -- The requested object has a non-unique identifier and cannot be retrieved.

  ERROR_DS_INSUFFICIENT_ATTR_TO_CREATE_OBJECT               =  8606,  -- (#219E)
  -- Insufficient attributes were given to create an object. This object may not
  -- exist because it may have been deleted and already garbage collected.

  ERROR_DS_GROUP_CONVERSION_ERROR                           =  8607,  -- (#219F)
  -- The group cannot be converted due to attribute restrictions on the
  -- requested group type.

  ERROR_DS_CANT_MOVE_APP_BASIC_GROUP                        =  8608,  -- (#21A0)
  -- Cross-domain move of non-empty basic application groups is not allowed.

  ERROR_DS_CANT_MOVE_APP_QUERY_GROUP                        =  8609,  -- (#21A1)
  -- Cross-domain move of non-empty query based application groups is not
  -- allowed.

  ERROR_DS_ROLE_NOT_VERIFIED                                =  8610,  -- (#21A2)
  -- The FSMO role ownership could not be verified because its directory
  -- partition has not replicated successfully with atleast one replication
  -- partner.

  ERROR_DS_WKO_CONTAINER_CANNOT_BE_SPECIAL                  =  8611,  -- (#21A3)
  -- The target container for a redirection of a well known object container
  -- cannot already be a special container.

  ERROR_DS_DOMAIN_RENAME_IN_PROGRESS                        =  8612,  -- (#21A4)
  -- The Directory Service cannot perform the requested operation because a
  -- domain rename operation is in progress.

  ERROR_DS_EXISTING_AD_CHILD_NC                             =  8613,  -- (#21A5)
  -- The directory service detected a child partition below the requested
  -- partition name. The partition hierarchy must be created in a top down
  -- method.

  ERROR_DS_REPL_LIFETIME_EXCEEDED                           =  8614,  -- (#21A6)
  -- The directory service cannot replicate with this server because the time
  -- since the last replication with this server has exceeded the tombstone
  -- lifetime.

  ERROR_DS_DISALLOWED_IN_SYSTEM_CONTAINER                   =  8615,  -- (#21A7)
  -- The requested operation is not allowed on an object under the system
  -- container.

  ERROR_DS_LDAP_SEND_QUEUE_FULL                             =  8616,  -- (#21A8)
  -- The LDAP servers network send queue has filled up because the client is not
  -- processing the results of it's requests fast enough. No more requests will
  -- be processed until the client catches up. If the client does not catch up
  -- then it will be disconnected.

  ERROR_DS_DRA_OUT_SCHEDULE_WINDOW                          =  8617,  -- (#21A9)
  -- The scheduled replication did not take place because the system was too
  -- busy to execute the request within the schedule window. The replication
  -- queue is overloaded. Consider reducing the number of partners or decreasing
  -- the scheduled replication frequency.

  ERROR_DS_POLICY_NOT_KNOWN                                 =  8618,  -- (#21AA)
  -- At this time, it cannot be determined if the branch replication policy is
  -- available on the hub domain controller. Please retry at a later time to
  -- account for replication latencies.

  ERROR_NO_SITE_SETTINGS_OBJECT                             =  8619,  -- (#21AB)
  -- The site settings object for the specified site does not exist.

  ERROR_NO_SECRETS                                          =  8620,  -- (#21AC)
  -- The local account store does not contain secret material for the specified
  -- account.

  ERROR_NO_WRITABLE_DC_FOUND                                =  8621,  -- (#21AD)
  -- Could not find a writable domain controller in the domain.

  ERROR_DS_NO_SERVER_OBJECT                                 =  8622,  -- (#21AE)
  -- The server object for the domain controller does not exist.

  ERROR_DS_NO_NTDSA_OBJECT                                  =  8623,  -- (#21AF)
  -- The NTDS Settings object for the domain controller does not exist.

  ERROR_DS_NON_ASQ_SEARCH                                   =  8624,  -- (#21B0)
  -- The requested search operation is not supported for ASQ searches.

  ERROR_DS_AUDIT_FAILURE                                    =  8625,  -- (#21B1)
  -- A required audit event could not be generated for the operation.

  ERROR_DS_INVALID_SEARCH_FLAG_SUBTREE                      =  8626,  -- (#21B2)
  -- The search flags for the attribute are invalid. The subtree index bit is
  -- valid only on single valued attributes.

  ERROR_DS_INVALID_SEARCH_FLAG_TUPLE                        =  8627,  -- (#21B3)
  -- The search flags for the attribute are invalid. The tuple index bit is
  -- valid only on attributes of Unicode strings.

  ERROR_DS_HIERARCHY_TABLE_TOO_DEEP                         =  8628,  -- (#21B4)
  -- The address books are nested too deeply. Failed to build the hierarchy
  -- table.

  ERROR_DS_DRA_CORRUPT_UTD_VECTOR                           =  8629,  -- (#21B5)
  -- The specified up-to-date-ness vector is corrupt.

  ERROR_DS_DRA_SECRETS_DENIED                               =  8630,  -- (#21B6)
  -- The request to replicate secrets is denied.

  ERROR_DS_RESERVED_MAPI_ID                                 =  8631,  -- (#21B7)
  -- Schema update failed: The MAPI identifier is reserved.

  ERROR_DS_MAPI_ID_NOT_AVAILABLE                            =  8632,  -- (#21B8)
  -- Schema update failed: There are no MAPI identifiers available.

  ERROR_DS_DRA_MISSING_KRBTGT_SECRET                        =  8633,  -- (#21B9)
  -- The replication operation failed because the required attributes of the
  -- local krbtgt object are missing.

  ERROR_DS_DOMAIN_NAME_EXISTS_IN_FOREST                     =  8634,  -- (#21BA)
  -- The domain name of the trusted domain already exists in the forest.

  ERROR_DS_FLAT_NAME_EXISTS_IN_FOREST                       =  8635,  -- (#21BB)
  -- The flat name of the trusted domain already exists in the forest.

  ERROR_INVALID_USER_PRINCIPAL_NAME                         =  8636,  -- (#21BC)
  -- The User Principal Name (UPN) is invalid.

  ERROR_DS_OID_MAPPED_GROUP_CANT_HAVE_MEMBERS               =  8637,  -- (#21BD)
  -- OID mapped groups cannot have members.

  ERROR_DS_OID_NOT_FOUND                                    =  8638,  -- (#21BE)
  -- The specified OID cannot be found.

  ERROR_DS_DRA_RECYCLED_TARGET                              =  8639,  -- (#21BF)
  -- The replication operation failed because the target object referred by a
  -- link value is recycled.

  DNS_ERROR_RCODE_FORMAT_ERROR                              =  9001,  -- (#2329)
  -- DNS server unable to interpret format.

  DNS_ERROR_RCODE_SERVER_FAILURE                            =  9002,  -- (#232A)
  -- DNS server failure.

  DNS_ERROR_RCODE_NAME_ERROR                                =  9003,  -- (#232B)
  -- DNS name does not exist.

  DNS_ERROR_RCODE_NOT_IMPLEMENTED                           =  9004,  -- (#232C)
  -- DNS request not supported by name server.

  DNS_ERROR_RCODE_REFUSED                                   =  9005,  -- (#232D)
  -- DNS operation refused.

  DNS_ERROR_RCODE_YXDOMAIN                                  =  9006,  -- (#232E)
  -- DNS name that ought not exist, does exist.

  DNS_ERROR_RCODE_YXRRSET                                   =  9007,  -- (#232F)
  -- DNS RR set that ought not exist, does exist.

  DNS_ERROR_RCODE_NXRRSET                                   =  9008,  -- (#2330)
  -- DNS RR set that ought to exist, does not exist.

  DNS_ERROR_RCODE_NOTAUTH                                   =  9009,  -- (#2331)
  -- DNS server not authoritative for zone.

  DNS_ERROR_RCODE_NOTZONE                                   =  9010,  -- (#2332)
  -- DNS name in update or prereq is not in zone.

  DNS_ERROR_RCODE_BADSIG                                    =  9016,  -- (#2338)
  -- DNS signature failed to verify.

  DNS_ERROR_RCODE_BADKEY                                    =  9017,  -- (#2339)
  -- DNS bad key.

  DNS_ERROR_RCODE_BADTIME                                   =  9018,  -- (#233A)
  -- DNS signature validity expired.

  DNS_INFO_NO_RECORDS                                       =  9501,  -- (#251D)
  -- No records found for given DNS query.

  DNS_ERROR_BAD_PACKET                                      =  9502,  -- (#251E)
  -- Bad DNS packet.

  DNS_ERROR_NO_PACKET                                       =  9503,  -- (#251F)
  -- No DNS packet.

  DNS_ERROR_RCODE                                           =  9504,  -- (#2520)
  -- DNS error, check rcode.

  DNS_ERROR_UNSECURE_PACKET                                 =  9505,  -- (#2521)
  -- Unsecured DNS packet.

  DNS_ERROR_INVALID_TYPE                                    =  9551,  -- (#254F)
  -- Invalid DNS type.

  DNS_ERROR_INVALID_IP_ADDRESS                              =  9552,  -- (#2550)
  -- Invalid IP address.

  DNS_ERROR_INVALID_PROPERTY                                =  9553,  -- (#2551)
  -- Invalid property.

  DNS_ERROR_TRY_AGAIN_LATER                                 =  9554,  -- (#2552)
  -- Try DNS operation again later.

  DNS_ERROR_NOT_UNIQUE                                      =  9555,  -- (#2553)
  -- Record for given name and type is not unique.

  DNS_ERROR_NON_RFC_NAME                                    =  9556,  -- (#2554)
  -- DNS name does not comply with RFC specifications.

  DNS_STATUS_FQDN                                           =  9557,  -- (#2555)
  -- DNS name is a fully-qualified DNS name.

  DNS_STATUS_DOTTED_NAME                                    =  9558,  -- (#2556)
  -- DNS name is dotted (multi-label).

  DNS_STATUS_SINGLE_PART_NAME                               =  9559,  -- (#2557)
  -- DNS name is a single-part name.

  DNS_ERROR_INVALID_NAME_CHAR                               =  9560,  -- (#2558)
  -- DSN name contains an invalid character.

  DNS_ERROR_NUMERIC_NAME                                    =  9561,  -- (#2559)
  -- DNS name is entirely numeric.

  DNS_ERROR_NOT_ALLOWED_ON_ROOT_SERVER                      =  9562,  -- (#255A)
  -- The operation requested is not permitted on a DNS root server.

  DNS_ERROR_NOT_ALLOWED_UNDER_DELEGATION                    =  9563,  -- (#255B)
  -- The record could not be created because this part of the DNS namespace has
  -- been delegated to another server.

  DNS_ERROR_CANNOT_FIND_ROOT_HINTS                          =  9564,  -- (#255C)
  -- The DNS server could not find a set of root hints.

  DNS_ERROR_INCONSISTENT_ROOT_HINTS                         =  9565,  -- (#255D)
  -- The DNS server found root hints but they were not consistent across all
  -- adapters.

  DNS_ERROR_DWORD_VALUE_TOO_SMALL                           =  9566,  -- (#255E)
  -- The specified value is too small for this parameter.

  DNS_ERROR_DWORD_VALUE_TOO_LARGE                           =  9567,  -- (#255F)
  -- The specified value is too large for this parameter.

  DNS_ERROR_BACKGROUND_LOADING                              =  9568,  -- (#2560)
  -- This operation is not allowed while the DNS server is loading zones in the
  -- background. Please try again later.

  DNS_ERROR_NOT_ALLOWED_ON_RODC                             =  9569,  -- (#2561)
  -- The operation requested is not permitted on against a DNS server running on
  -- a read-only DC.

  DNS_ERROR_NOT_ALLOWED_UNDER_DNAME                         =  9570,  -- (#2562)
  -- No data is allowed to exist underneath a DNAME record.

  DNS_ERROR_DELEGATION_REQUIRED                             =  9571,  -- (#2563)
  -- This operation requires credentials delegation.

  DNS_ERROR_INVALID_POLICY_TABLE                            =  9572,  -- (#2564)
  -- Name resolution policy table has been corrupted. DNS resolution will fail
  -- until it is fixed. Contact your network administrator.

  DNS_ERROR_ZONE_DOES_NOT_EXIST                             =  9601,  -- (#2581)
  -- DNS zone does not exist.

  DNS_ERROR_NO_ZONE_INFO                                    =  9602,  -- (#2582)
  -- DNS zone information not available.

  DNS_ERROR_INVALID_ZONE_OPERATION                          =  9603,  -- (#2583)
  -- Invalid operation for DNS zone.

  DNS_ERROR_ZONE_CONFIGURATION_ERROR                        =  9604,  -- (#2584)
  -- Invalid DNS zone configuration.

  DNS_ERROR_ZONE_HAS_NO_SOA_RECORD                          =  9605,  -- (#2585)
  -- DNS zone has no start of authority (SOA) record.

  DNS_ERROR_ZONE_HAS_NO_NS_RECORDS                          =  9606,  -- (#2586)
  -- DNS zone has no name server (NS) record.

  DNS_ERROR_ZONE_LOCKED                                     =  9607,  -- (#2587)
  -- DNS zone is locked.

  DNS_ERROR_ZONE_CREATION_FAILED                            =  9608,  -- (#2588)
  -- DNS zone creation failed.

  DNS_ERROR_ZONE_ALREADY_EXISTS                             =  9609,  -- (#2589)
  -- DNS zone already exists.

  DNS_ERROR_AUTOZONE_ALREADY_EXISTS                         =  9610,  -- (#258A)
  -- DNS automatic zone already exists.

  DNS_ERROR_INVALID_ZONE_TYPE                               =  9611,  -- (#258B)
  -- Invalid DNS zone type.

  DNS_ERROR_SECONDARY_REQUIRES_MASTER_IP                    =  9612,  -- (#258C)
  -- Secondary DNS zone requires master IP address.

  DNS_ERROR_ZONE_NOT_SECONDARY                              =  9613,  -- (#258D)
  -- DNS zone not secondary.

  DNS_ERROR_NEED_SECONDARY_ADDRESSES                        =  9614,  -- (#258E)
  -- Need secondary IP address.

  DNS_ERROR_WINS_INIT_FAILED                                =  9615,  -- (#258F)
  -- WINS initialization failed.

  DNS_ERROR_NEED_WINS_SERVERS                               =  9616,  -- (#2590)
  -- Need WINS servers.

  DNS_ERROR_NBSTAT_INIT_FAILED                              =  9617,  -- (#2591)
  -- NBTSTAT initialization call failed.

  DNS_ERROR_SOA_DELETE_INVALID                              =  9618,  -- (#2592)
  -- Invalid delete of start of authority (SOA).

  DNS_ERROR_FORWARDER_ALREADY_EXISTS                        =  9619,  -- (#2593)
  -- A conditional forwarding zone already exists for that name.

  DNS_ERROR_ZONE_REQUIRES_MASTER_IP                         =  9620,  -- (#2594)
  -- This zone must be configured with one or more master DNS server IP
  -- addresses.

  DNS_ERROR_ZONE_IS_SHUTDOWN                                =  9621,  -- (#2595)
  -- The operation cannot be performed because this zone is shutdown.

  DNS_ERROR_PRIMARY_REQUIRES_DATAFILE                       =  9651,  -- (#25B3)
  -- Primary DNS zone requires datafile.

  DNS_ERROR_INVALID_DATAFILE_NAME                           =  9652,  -- (#25B4)
  -- Invalid datafile name for DNS zone.

  DNS_ERROR_DATAFILE_OPEN_FAILURE                           =  9653,  -- (#25B5)
  -- Failed to open datafile for DNS zone.

  DNS_ERROR_FILE_WRITEBACK_FAILED                           =  9654,  -- (#25B6)
  -- Failed to write datafile for DNS zone.

  DNS_ERROR_DATAFILE_PARSING                                =  9655,  -- (#25B7)
  -- Failure while reading datafile for DNS zone.

  DNS_ERROR_RECORD_DOES_NOT_EXIST                           =  9701,  -- (#25E5)
  -- DNS record does not exist.

  DNS_ERROR_RECORD_FORMAT                                   =  9702,  -- (#25E6)
  -- DNS record format error.

  DNS_ERROR_NODE_CREATION_FAILED                            =  9703,  -- (#25E7)
  -- Node creation failure in DNS.

  DNS_ERROR_UNKNOWN_RECORD_TYPE                             =  9704,  -- (#25E8)
  -- Unknown DNS record type.

  DNS_ERROR_RECORD_TIMED_OUT                                =  9705,  -- (#25E9)
  -- DNS record timed out.

  DNS_ERROR_NAME_NOT_IN_ZONE                                =  9706,  -- (#25EA)
  -- Name not in DNS zone.

  DNS_ERROR_CNAME_LOOP                                      =  9707,  -- (#25EB)
  -- CNAME loop detected.

  DNS_ERROR_NODE_IS_CNAME                                   =  9708,  -- (#25EC)
  -- Node is a CNAME DNS record.

  DNS_ERROR_CNAME_COLLISION                                 =  9709,  -- (#25ED)
  -- A CNAME record already exists for given name.

  DNS_ERROR_RECORD_ONLY_AT_ZONE_ROOT                        =  9710,  -- (#25EE)
  -- Record only at DNS zone root.

  DNS_ERROR_RECORD_ALREADY_EXISTS                           =  9711,  -- (#25EF)
  -- DNS record already exists.

  DNS_ERROR_SECONDARY_DATA                                  =  9712,  -- (#25F0)
  -- Secondary DNS zone data error.

  DNS_ERROR_NO_CREATE_CACHE_DATA                            =  9713,  -- (#25F1)
  -- Could not create DNS cache data.

  DNS_ERROR_NAME_DOES_NOT_EXIST                             =  9714,  -- (#25F2)
  -- DNS name does not exist.

  DNS_WARNING_PTR_CREATE_FAILED                             =  9715,  -- (#25F3)
  -- Could not create pointer (PTR) record.

  DNS_WARNING_DOMAIN_UNDELETED                              =  9716,  -- (#25F4)
  -- DNS domain was undeleted.

  DNS_ERROR_DS_UNAVAILABLE                                  =  9717,  -- (#25F5)
  -- The directory service is unavailable.

  DNS_ERROR_DS_ZONE_ALREADY_EXISTS                          =  9718,  -- (#25F6)
  -- DNS zone already exists in the directory service.

  DNS_ERROR_NO_BOOTFILE_IF_DS_ZONE                          =  9719,  -- (#25F7)
  -- DNS server not creating or reading the boot file for the directory service
  -- integrated DNS zone.

  DNS_ERROR_NODE_IS_DNAME                                   =  9720,  -- (#25F8)
  -- Node is a DNAME DNS record.

  DNS_ERROR_DNAME_COLLISION                                 =  9721,  -- (#25F9)
  -- A DNAME record already exists for given name.

  DNS_ERROR_ALIAS_LOOP                                      =  9722,  -- (#25FA)
  -- An alias loop has been detected with either CNAME or DNAME records.

  DNS_INFO_AXFR_COMPLETE                                    =  9751,  -- (#2617)
  -- DNS AXFR (zone transfer) complete.

  DNS_ERROR_AXFR                                            =  9752,  -- (#2618)
  -- DNS zone transfer failed.

  DNS_INFO_ADDED_LOCAL_WINS                                 =  9753,  -- (#2619)
  -- Added local WINS server.

  DNS_STATUS_CONTINUE_NEEDED                                =  9801,  -- (#2649)
  -- Secure update call needs to continue update request.

  DNS_ERROR_NO_TCPIP                                        =  9851,  -- (#267B)
  -- TCP/IP network protocol not installed.

  DNS_ERROR_NO_DNS_SERVERS                                  =  9852,  -- (#267C)
  -- No DNS servers configured for local system.

  DNS_ERROR_DP_DOES_NOT_EXIST                               =  9901,  -- (#26AD)
  -- The specified directory partition does not exist.

  DNS_ERROR_DP_ALREADY_EXISTS                               =  9902,  -- (#26AE)
  -- The specified directory partition already exists.

  DNS_ERROR_DP_NOT_ENLISTED                                 =  9903,  -- (#26AF)
  -- This DNS server is not enlisted in the specified directory partition.

  DNS_ERROR_DP_ALREADY_ENLISTED                             =  9904,  -- (#26B0)
  -- This DNS server is already enlisted in the specified directory partition.

  DNS_ERROR_DP_NOT_AVAILABLE                                =  9905,  -- (#26B1)
  -- The directory partition is not available at this time. Please wait a few
  -- minutes and try again.

  DNS_ERROR_DP_FSMO_ERROR                                   =  9906,  -- (#26B2)
  -- The application directory partition operation failed. The domain controller
  -- holding the domain naming master role is down or unable to service the
  -- request or is not running Windows .NET Server.

  WSAEINTR                                                  = 10004,  -- (#2714)
  -- A blocking operation was interrupted by a call to WSACancelBlockingCall.

  WSAEBADF                                                  = 10009,  -- (#2719)
  -- The file handle supplied is not valid.

  WSAEACCES                                                 = 10013,  -- (#271D)
  -- An attempt was made to access a socket in a way forbidden by its access
  -- permissions.

  WSAEFAULT                                                 = 10014,  -- (#271E)
  -- The system detected an invalid pointer address in attempting to use a
  -- pointer argument in a call.

  WSAEINVAL                                                 = 10022,  -- (#2726)
  -- An invalid argument was supplied.

  WSAEMFILE                                                 = 10024,  -- (#2728)
  -- Too many open sockets.

  WSAEWOULDBLOCK                                            = 10035,  -- (#2733)
  -- A non-blocking socket operation could not be completed immediately.

  WSAEINPROGRESS                                            = 10036,  -- (#2734)
  -- A blocking operation is currently executing.

  WSAEALREADY                                               = 10037,  -- (#2735)
  -- An operation was attempted on a non-blocking socket that already had an
  -- operation in progress.

  WSAENOTSOCK                                               = 10038,  -- (#2736)
  -- An operation was attempted on something that is not a socket.

  WSAEDESTADDRREQ                                           = 10039,  -- (#2737)
  -- A required address was omitted from an operation on a socket.

  WSAEMSGSIZE                                               = 10040,  -- (#2738)
  -- A message sent on a datagram socket was larger than the internal message
  -- buffer or some other network limit, or the buffer used to receive a
  -- datagram into was smaller than the datagram itself.

  WSAEPROTOTYPE                                             = 10041,  -- (#2739)
  -- A protocol was specified in the socket function call that does not support
  -- the semantics of the socket type requested.

  WSAENOPROTOOPT                                            = 10042,  -- (#273A)
  -- An unknown, invalid, or unsupported option or level was specified in a
  -- getsockopt or setsockopt call.

  WSAEPROTONOSUPPORT                                        = 10043,  -- (#273B)
  -- The requested protocol has not been configured into the system, or no
  -- implementation for it exists.

  WSAESOCKTNOSUPPORT                                        = 10044,  -- (#273C)
  -- The support for the specified socket type does not exist in this address
  -- family.

  WSAEOPNOTSUPP                                             = 10045,  -- (#273D)
  -- The attempted operation is not supported for the type of object referenced.

  WSAEPFNOSUPPORT                                           = 10046,  -- (#273E)
  -- The protocol family has not been configured into the system or no
  -- implementation for it exists.

  WSAEAFNOSUPPORT                                           = 10047,  -- (#273F)
  -- An address incompatible with the requested protocol was used.

  WSAEADDRINUSE                                             = 10048,  -- (#2740)
  -- Only one usage of each socket address (protocol/network address/port) is
  -- normally permitted.

  WSAEADDRNOTAVAIL                                          = 10049,  -- (#2741)
  -- The requested address is not valid in its context.

  WSAENETDOWN                                               = 10050,  -- (#2742)
  -- A socket operation encountered a dead network.

  WSAENETUNREACH                                            = 10051,  -- (#2743)
  -- A socket operation was attempted to an unreachable network.

  WSAENETRESET                                              = 10052,  -- (#2744)
  -- The connection has been broken due to keep-alive activity detecting a
  -- failure while the operation was in progress.

  WSAECONNABORTED                                           = 10053,  -- (#2745)
  -- An established connection was aborted by the software in your host machine.

  WSAECONNRESET                                             = 10054,  -- (#2746)
  -- An existing connection was forcibly closed by the remote host.

  WSAENOBUFS                                                = 10055,  -- (#2747)
  -- An operation on a socket could not be performed because the system lacked
  -- sufficient buffer space or because a queue was full.

  WSAEISCONN                                                = 10056,  -- (#2748)
  -- A connect request was made on an already connected socket.

  WSAENOTCONN                                               = 10057,  -- (#2749)
  -- A request to send or receive data was disallowed because the socket is not
  -- connected and (when sending on a datagram socket using a sendto call) no
  -- address was supplied.

  WSAESHUTDOWN                                              = 10058,  -- (#274A)
  -- A request to send or receive data was disallowed because the socket had
  -- already been shut down in that direction with a previous shutdown call.

  WSAETOOMANYREFS                                           = 10059,  -- (#274B)
  -- Too many references to some kernel object.

  WSAETIMEDOUT                                              = 10060,  -- (#274C)
  -- A connection attempt failed because the connected party did not properly
  -- respond after a period of time, or established connection failed because
  -- connected host has failed to respond.

  WSAECONNREFUSED                                           = 10061,  -- (#274D)
  -- No connection could be made because the target machine actively refused it.

  WSAELOOP                                                  = 10062,  -- (#274E)
  -- Cannot translate name.

  WSAENAMETOOLONG                                           = 10063,  -- (#274F)
  -- Name component or name was too long.

  WSAEHOSTDOWN                                              = 10064,  -- (#2750)
  -- A socket operation failed because the destination host was down.

  WSAEHOSTUNREACH                                           = 10065,  -- (#2751)
  -- A socket operation was attempted to an unreachable host.

  WSAENOTEMPTY                                              = 10066,  -- (#2752)
  -- Cannot remove a directory that is not empty.

  WSAEPROCLIM                                               = 10067,  -- (#2753)
  -- A Windows Sockets implementation may have a limit on the number of
  -- applications that may use it simultaneously.

  WSAEUSERS                                                 = 10068,  -- (#2754)
  -- Ran out of quota.

  WSAEDQUOT                                                 = 10069,  -- (#2755)
  -- Ran out of disk quota.

  WSAESTALE                                                 = 10070,  -- (#2756)
  -- File handle reference is no longer available.

  WSAEREMOTE                                                = 10071,  -- (#2757)
  -- Item is not available locally.

  WSASYSNOTREADY                                            = 10091,  -- (#276B)
  -- WSAStartup cannot function at this time because the underlying system it
  -- uses to provide network services is currently unavailable.

  WSAVERNOTSUPPORTED                                        = 10092,  -- (#276C)
  -- The Windows Sockets version requested is not supported.

  WSANOTINITIALISED                                         = 10093,  -- (#276D)
  -- Either the application has not called WSAStartup, or WSAStartup failed.

  WSAEDISCON                                                = 10101,  -- (#2775)
  -- Returned by WSARecv or WSARecvFrom to indicate the remote party has
  -- initiated a graceful shutdown sequence.

  WSAENOMORE                                                = 10102,  -- (#2776)
  -- No more results can be returned by WSALookupServiceNext.

  WSAECANCELLED                                             = 10103,  -- (#2777)
  -- A call to WSALookupServiceEnd was made while this call was still
  -- processing. The call has been canceled.

  WSAEINVALIDPROCTABLE                                      = 10104,  -- (#2778)
  -- The procedure call table is invalid.

  WSAEINVALIDPROVIDER                                       = 10105,  -- (#2779)
  -- The requested service provider is invalid.

  WSAEPROVIDERFAILEDINIT                                    = 10106,  -- (#277A)
  -- The requested service provider could not be loaded or initialized.

  WSASYSCALLFAILURE                                         = 10107,  -- (#277B)
  -- A system call that should never fail has failed.

  WSASERVICE_NOT_FOUND                                      = 10108,  -- (#277C)
  -- No such service is known. The service cannot be found in the specified name
  -- space.

  WSATYPE_NOT_FOUND                                         = 10109,  -- (#277D)
  -- The specified class was not found.

  WSA_E_NO_MORE                                             = 10110,  -- (#277E)
  -- No more results can be returned by WSALookupServiceNext.

  WSA_E_CANCELLED                                           = 10111,  -- (#277F)
  -- A call to WSALookupServiceEnd was made while this call was still
  -- processing. The call has been canceled.

  WSAEREFUSED                                               = 10112,  -- (#2780)
  -- A database query failed because it was actively refused.

  WSAHOST_NOT_FOUND                                         = 11001,  -- (#2AF9)
  -- No such host is known.

  WSATRY_AGAIN                                              = 11002,  -- (#2AFA)
  -- This is usually a temporary error during hostname resolution and means that
  -- the local server did not receive a response from an authoritative server.

  WSANO_RECOVERY                                            = 11003,  -- (#2AFB)
  -- A non-recoverable error occurred during a database lookup.

  WSANO_DATA                                                = 11004,  -- (#2AFC)
  -- The requested name is valid and was found in the database, but it does not
  -- have the correct associated data being resolved for.

  WSA_QOS_RECEIVERS                                         = 11005,  -- (#2AFD)
  -- At least one reserve has arrived.

  WSA_QOS_SENDERS                                           = 11006,  -- (#2AFE)
  -- At least one path has arrived.

  WSA_QOS_NO_SENDERS                                        = 11007,  -- (#2AFF)
  -- There are no senders.

  WSA_QOS_NO_RECEIVERS                                      = 11008,  -- (#2B00)
  -- There are no receivers.

  WSA_QOS_REQUEST_CONFIRMED                                 = 11009,  -- (#2B01)
  -- Reserve has been confirmed.

  WSA_QOS_ADMISSION_FAILURE                                 = 11010,  -- (#2B02)
  -- Error due to lack of resources.

  WSA_QOS_POLICY_FAILURE                                    = 11011,  -- (#2B03)
  -- Rejected for administrative reasons - bad credentials.

  WSA_QOS_BAD_STYLE                                         = 11012,  -- (#2B04)
  -- Unknown or conflicting style.

  WSA_QOS_BAD_OBJECT                                        = 11013,  -- (#2B05)
  -- Problem with some part of the filterspec or providerspecific buffer in
  -- general.

  WSA_QOS_TRAFFIC_CTRL_ERROR                                = 11014,  -- (#2B06)
  -- Problem with some part of the flowspec.

  WSA_QOS_GENERIC_ERROR                                     = 11015,  -- (#2B07)
  -- General QOS error.

  WSA_QOS_ESERVICETYPE                                      = 11016,  -- (#2B08)
  -- An invalid or unrecognized service type was found in the flowspec.

  WSA_QOS_EFLOWSPEC                                         = 11017,  -- (#2B09)
  -- An invalid or inconsistent flowspec was found in the QOS structure.

  WSA_QOS_EPROVSPECBUF                                      = 11018,  -- (#2B0A)
  -- Invalid QOS provider-specific buffer.

  WSA_QOS_EFILTERSTYLE                                      = 11019,  -- (#2B0B)
  -- An invalid QOS filter style was used.

  WSA_QOS_EFILTERTYPE                                       = 11020,  -- (#2B0C)
  -- An invalid QOS filter type was used.

  WSA_QOS_EFILTERCOUNT                                      = 11021,  -- (#2B0D)
  -- An incorrect number of QOS FILTERSPECs were specified in the
  -- FLOWDESCRIPTOR.

  WSA_QOS_EOBJLENGTH                                        = 11022,  -- (#2B0E)
  -- An object with an invalid ObjectLength field was specified in the QOS
  -- provider-specific buffer.

  WSA_QOS_EFLOWCOUNT                                        = 11023,  -- (#2B0F)
  -- An incorrect number of flow descriptors was specified in the QOS structure.

  WSA_QOS_EUNKNOWNPSOBJ                                     = 11024,  -- (#2B10)
  -- An unrecognized object was found in the QOS provider-specific buffer.

  WSA_QOS_EPOLICYOBJ                                        = 11025,  -- (#2B11)
  -- An invalid policy object was found in the QOS provider-specific buffer.

  WSA_QOS_EFLOWDESC                                         = 11026,  -- (#2B12)
  -- An invalid QOS flow descriptor was found in the flow descriptor list.

  WSA_QOS_EPSFLOWSPEC                                       = 11027,  -- (#2B13)
  -- An invalid or inconsistent flowspec was found in the QOS provider-specific
  -- buffer.

  WSA_QOS_EPSFILTERSPEC                                     = 11028,  -- (#2B14)
  -- An invalid FILTERSPEC was found in the QOS provider-specific buffer.

  WSA_QOS_ESDMODEOBJ                                        = 11029,  -- (#2B15)
  -- An invalid shape discard mode object was found in the QOS provider-specific
  -- buffer.

  WSA_QOS_ESHAPERATEOBJ                                     = 11030,  -- (#2B16)
  -- An invalid shaping rate object was found in the QOS provider-specific
  -- buffer.

  WSA_QOS_RESERVED_PETYPE                                   = 11031,  -- (#2B17)
  -- A reserved policy element was found in the QOS provider-specific buffer.

  INTERNET_ERROR_BASE                                       = 12000,  -- (#2EE0)
  WINHTTP_ERROR_BASE                                        = 12000,  -- (#2EE0)
  -- Not an error. Used internally as a reference for Internet errors.

  ERROR_INTERNET_OUT_OF_HANDLES                             = 12001,  -- (#2EE1)
  -- No more handles could be generated at this time.

  ERROR_WINHTTP_OUT_OF_HANDLES                              = 12001,  -- (#2EE1)
  -- Obsolete; no longer used.

  ERROR_INTERNET_TIMEOUT                                    = 12002,  -- (#2EE2)
  ERROR_WINHTTP_TIMEOUT                                     = 12002,  -- (#2EE2)
  -- The request has timed out.

  ERROR_INTERNET_EXTENDED_ERROR                             = 12003,  -- (#2EE3)
  -- An extended error was returned from the server. This is typically a string
  -- or buffer containing a verbose error message. Call
  -- InternetGetLastResponseInfo to retrieve the error text.

  ERROR_INTERNET_INTERNAL_ERROR                             = 12004,  -- (#2EE4)
  ERROR_WINHTTP_INTERNAL_ERROR                              = 12004,  -- (#2EE4)
  -- An internal error has occurred.

  ERROR_INTERNET_INVALID_URL                                = 12005,  -- (#2EE5)
  ERROR_WINHTTP_INVALID_URL                                 = 12005,  -- (#2EE5)
  -- The URL is invalid.

  ERROR_INTERNET_UNRECOGNIZED_SCHEME                        = 12006,  -- (#2EE6)
  ERROR_WINHTTP_UNRECOGNIZED_SCHEME                         = 12006,  -- (#2EE6)
  -- The URL scheme could not be recognized, or is not supported.

  ERROR_INTERNET_NAME_NOT_RESOLVED                          = 12007,  -- (#2EE7)
  ERROR_WINHTTP_NAME_NOT_RESOLVED                           = 12007,  -- (#2EE7)
  -- The server name could not be resolved.

  ERROR_INTERNET_PROTOCOL_NOT_FOUND                         = 12008,  -- (#2EE8)
  -- The requested protocol could not be located.

  ERROR_INTERNET_INVALID_OPTION                             = 12009,  -- (#2EE9)
  ERROR_WINHTTP_INVALID_OPTION                              = 12009,  -- (#2EE9)
  -- A request to InternetQueryOption or InternetSetOption specified an invalid
  -- option value.

  ERROR_INTERNET_BAD_OPTION_LENGTH                          = 12010,  -- (#2EEA)
  -- The length of an option supplied to InternetQueryOption or
  -- InternetSetOption is incorrect for the type of option specified.

  ERROR_INTERNET_OPTION_NOT_SETTABLE                        = 12011,  -- (#2EEB)
  ERROR_WINHTTP_OPTION_NOT_SETTABLE                         = 12011,  -- (#2EEB)
  -- The requested option cannot be set, only queried.

  ERROR_INTERNET_SHUTDOWN                                   = 12012,  -- (#2EEC)
  ERROR_WINHTTP_SHUTDOWN                                    = 12012,  -- (#2EEC)
  -- WinINet support is being shut down or unloaded.

  ERROR_INTERNET_INCORRECT_USER_NAME                        = 12013,  -- (#2EED)
  -- The request to connect and log on to an FTP server could not be completed
  -- because the supplied user name is incorrect.

  ERROR_INTERNET_INCORRECT_PASSWORD                         = 12014,  -- (#2EEE)
  -- The request to connect and log on to an FTP server could not be completed
  -- because the supplied password is incorrect.

  ERROR_INTERNET_LOGIN_FAILURE                              = 12015,  -- (#2EEF)
  ERROR_WINHTTP_LOGIN_FAILURE                               = 12015,  -- (#2EEF)
  -- The request to connect and log on to an FTP server failed.

  ERROR_INTERNET_INVALID_OPERATION                          = 12016,  -- (#2EF0)
  -- The requested operation is invalid.

  ERROR_INTERNET_OPERATION_CANCELLED                        = 12017,  -- (#2EF1)
  ERROR_WINHTTP_OPERATION_CANCELLED                         = 12017,  -- (#2EF1)
  -- The operation was canceled, usually because the handle on which the request
  -- was operating was closed before the operation completed.

  ERROR_INTERNET_INCORRECT_HANDLE_TYPE                      = 12018,  -- (#2EF2)
  ERROR_WINHTTP_INCORRECT_HANDLE_TYPE                       = 12018,  -- (#2EF2)
  -- The type of handle supplied is incorrect for this operation.

  ERROR_INTERNET_INCORRECT_HANDLE_STATE                     = 12019,  -- (#2EF3)
  ERROR_WINHTTP_INCORRECT_HANDLE_STATE                      = 12019,  -- (#2EF3)
  -- The requested operation cannot be carried out because the handle supplied
  -- is not in the correct state.

  ERROR_INTERNET_NOT_PROXY_REQUEST                          = 12020,  -- (#2EF4)
  -- The request cannot be made via a proxy.

  ERROR_INTERNET_REGISTRY_VALUE_NOT_FOUND                   = 12021,  -- (#2EF5)
  -- A required registry value could not be located.

  ERROR_INTERNET_BAD_REGISTRY_PARAMETER                     = 12022,  -- (#2EF6)
  -- A required registry value was located but is an incorrect type or has an
  -- invalid value.

  ERROR_INTERNET_NO_DIRECT_ACCESS                           = 12023,  -- (#2EF7)
  -- Direct network access cannot be made at this time.

  ERROR_INTERNET_NO_CONTEXT                                 = 12024,  -- (#2EF8)
  -- An asynchronous request could not be made because a zero context value was
  -- supplied.

  ERROR_INTERNET_NO_CALLBACK                                = 12025,  -- (#2EF9)
  -- An asynchronous request could not be made because a callback function has
  -- not been set.

  ERROR_INTERNET_REQUEST_PENDING                            = 12026,  -- (#2EFA)
  -- The required operation could not be completed because one or more requests
  -- are pending.

  ERROR_INTERNET_INCORRECT_FORMAT                           = 12027,  -- (#2EFB)
  -- The format of the request is invalid.

  ERROR_INTERNET_ITEM_NOT_FOUND                             = 12028,  -- (#2EFC)
  -- The requested item could not be located.

  ERROR_INTERNET_CANNOT_CONNECT                             = 12029,  -- (#2EFD)
  ERROR_WINHTTP_CANNOT_CONNECT                              = 12029,  -- (#2EFD)
  -- The attempt to connect to the server failed.

  ERROR_INTERNET_CONNECTION_ABORTED                         = 12030,  -- (#2EFE)
  ERROR_WINHTTP_CONNECTION_ERROR                            = 12030,  -- (#2EFE)
  -- The connection with the server has been terminated.

  ERROR_INTERNET_CONNECTION_RESET                           = 12031,  -- (#2EFF)
  -- The connection with the server has been reset.

  ERROR_INTERNET_FORCE_RETRY                                = 12032,  -- (#2F00)
  ERROR_WINHTTP_RESEND_REQUEST                              = 12032,  -- (#2F00)
  -- The function needs to redo the request.

  ERROR_INTERNET_INVALID_PROXY_REQUEST                      = 12033,  -- (#2F01)
  -- The request to the proxy was invalid.

  ERROR_INTERNET_NEED_UI                                    = 12034,  -- (#2F02)
  -- A user interface or other blocking operation has been requested.

  ERROR_INTERNET_HANDLE_EXISTS                              = 12036,  -- (#2F04)
  -- The request failed because the handle already exists.

  ERROR_INTERNET_SEC_CERT_DATE_INVALID                      = 12037,  -- (#2F05)
  ERROR_WINHTTP_SECURE_CERT_DATE_INVALID                    = 12037,  -- (#2F05)
  -- SSL certificate date that was received from the server is bad. The
  -- certificate is expired.

  ERROR_INTERNET_SEC_CERT_CN_INVALID                        = 12038,  -- (#2F06)
  ERROR_WINHTTP_SECURE_CERT_CN_INVALID                      = 12038,  -- (#2F06)
  -- SSL certificate common name (host name field) is incorrect - for example,
  -- if you entered www.server.com and the common name on the certificate says
  -- www.different.com.

  ERROR_INTERNET_HTTP_TO_HTTPS_ON_REDIR                     = 12039,  -- (#2F07)
  -- The application is moving from a non-SSL to an SSL connection because of a
  -- redirect.

  ERROR_INTERNET_HTTPS_TO_HTTP_ON_REDIR                     = 12040,  -- (#2F08)
  -- The application is moving from an SSL to an non-SSL connection because of a
  -- redirect.

  ERROR_INTERNET_MIXED_SECURITY                             = 12041,  -- (#2F09)
  -- The content is not entirely secure. Some of the content being viewed may
  -- have come from unsecured servers.

  ERROR_INTERNET_CHG_POST_IS_NON_SECURE                     = 12042,  -- (#2F0A)
  -- The application is posting and attempting to change multiple lines of text
  -- on a server that is not secure.

  ERROR_INTERNET_POST_IS_NON_SECURE                         = 12043,  -- (#2F0B)
  -- The application is posting data to a server that is not secure.

  ERROR_INTERNET_CLIENT_AUTH_CERT_NEEDED                    = 12044,  -- (#2F0C)
  ERROR_WINHTTP_CLIENT_AUTH_CERT_NEEDED                     = 12044,  -- (#2F0C)
  -- The server is requesting client authentication.

  ERROR_INTERNET_INVALID_CA                                 = 12045,  -- (#2F0D)
  ERROR_WINHTTP_SECURE_INVALID_CA                           = 12045,  -- (#2F0D)
  -- The function is unfamiliar with the Certificate Authority that generated
  -- the server's certificate.

  ERROR_INTERNET_CLIENT_AUTH_NOT_SETUP                      = 12046,  -- (#2F0E)
  -- Client authorization is not set up on this computer.

  ERROR_INTERNET_ASYNC_THREAD_FAILED                        = 12047,  -- (#2F0F)
  -- The application could not start an asynchronous thread.

  ERROR_INTERNET_REDIRECT_SCHEME_CHANGE                     = 12048,  -- (#2F10)
  -- The function could not handle the redirection, because the scheme changed
  -- (for example, HTTP to FTP).

  ERROR_INTERNET_DIALOG_PENDING                             = 12049,  -- (#2F11)
  -- Another thread has a password dialog box in progress.

  ERROR_INTERNET_RETRY_DIALOG                               = 12050,  -- (#2F12)
  -- The dialog box should be retried.

  ERROR_INTERNET_HTTPS_HTTP_SUBMIT_REDIR                    = 12052,  -- (#2F14)
  -- The data being submitted to an SSL connection is being redirected to a
  -- non-SSL connection.

  ERROR_INTERNET_INSERT_CDROM                               = 12053,  -- (#2F15)
  -- The request requires a CD-ROM to be inserted in the CD-ROM drive to locate
  -- the resource requested.

  ERROR_INTERNET_FORTEZZA_LOGIN_NEEDED                      = 12054,  -- (#2F16)
  -- The requested resource requires Fortezza authentication.

  ERROR_INTERNET_SEC_CERT_ERRORS                            = 12055,  -- (#2F17)
  -- The SSL certificate contains errors.

  ERROR_INTERNET_SEC_CERT_NO_REV                            = 12056,  -- (#2F18)
  -- The SSL certificate was not revoked.

  ERROR_INTERNET_SEC_CERT_REV_FAILED                        = 12057,  -- (#2F19)
  ERROR_WINHTTP_SECURE_CERT_REV_FAILED                      = 12057,  -- (#2F19)
  -- Revocation of the SSL certificate failed.

  ERROR_WINHTTP_CANNOT_CALL_BEFORE_OPEN	                    = 12100,  -- (#2F44)
  -- Returned by the HttpRequest object if a requested operation cannot be
  -- performed before calling the Open method.

  ERROR_WINHTTP_CANNOT_CALL_BEFORE_SEND	                    = 12101,  -- (#2F45)
  -- Returned by the HttpRequest object if a requested operation cannot be
  -- performed before calling the Send method.

  ERROR_WINHTTP_CANNOT_CALL_AFTER_SEND	                    = 12102,  -- (#2F46)
  -- Returned by the HttpRequest object if a requested operation cannot be
  -- performed after calling the Send method.

  ERROR_WINHTTP_CANNOT_CALL_AFTER_OPEN	                    = 12103,  -- (#2F47)
  -- Returned by the HttpRequest object if a specified option cannot be
  -- requested after the Open method has been called.
  
  -- FTP API errors

  ERROR_FTP_TRANSFER_IN_PROGRESS                            = 12110,  -- (#2F4E)
  -- The requested operation cannot be made on the FTP session handle because an
  -- operation is already in progress.

  ERROR_FTP_DROPPED                                         = 12111,  -- (#2F4F)
  -- The FTP operation was not completed because the session was aborted.

  ERROR_FTP_NO_PASSIVE_MODE                                 = 12112,  -- (#2F50)
  -- Passive mode is not available on the server.

  -- gopher API errors

  ERROR_GOPHER_PROTOCOL_ERROR                               = 12130,  -- (#2F62)
  -- An error was detected while parsing data returned from the Gopher server.

  ERROR_GOPHER_NOT_FILE                                     = 12131,  -- (#2F63)
  -- The request must be made for a file locator.

  ERROR_GOPHER_DATA_ERROR                                   = 12132,  -- (#2F64)
  -- An error was detected while receiving data from the Gopher server.

  ERROR_GOPHER_END_OF_DATA                                  = 12133,  -- (#2F65)
  -- The end of the data has been reached.

  ERROR_GOPHER_INVALID_LOCATOR                              = 12134,  -- (#2F66)
  -- The supplied locator is not valid.

  ERROR_GOPHER_INCORRECT_LOCATOR_TYPE                       = 12135,  -- (#2F67)
  -- The type of the locator is not correct for this operation.

  ERROR_GOPHER_NOT_GOPHER_PLUS                              = 12136,  -- (#2F68)
  -- The requested operation can be made only against a Gopher+ server, or with
  -- a locator that specifies a Gopher+ operation.

  ERROR_GOPHER_ATTRIBUTE_NOT_FOUND                          = 12137,  -- (#2F69)
  -- The requested attribute could not be located.

  ERROR_GOPHER_UNKNOWN_LOCATOR                              = 12138,  -- (#2F6A)
  -- The locator type is unknown.

  -- HTTP API errors

  ERROR_HTTP_HEADER_NOT_FOUND                               = 12150,  -- (#2F76)
  ERROR_WINHTTP_HEADER_NOT_FOUND                            = 12150,  -- (#2F76)
  -- The requested header could not be located.

  ERROR_HTTP_DOWNLEVEL_SERVER                               = 12151,  -- (#2F77)
  -- The server did not return any headers.

  ERROR_HTTP_INVALID_SERVER_RESPONSE                        = 12152,  -- (#2F78)
  ERROR_WINHTTP_INVALID_SERVER_RESPONSE                     = 12152,  -- (#2F78)
  -- The server response could not be parsed.

  ERROR_HTTP_INVALID_HEADER                                 = 12153,  -- (#2F79)
  ERROR_WINHTTP_INVALID_HEADER                              = 12153,  -- (#2F79)
  -- The supplied header is invalid.

  ERROR_HTTP_INVALID_QUERY_REQUEST                          = 12154,  -- (#2F7A)
  -- The request made to HttpQueryInfo is invalid.

  ERROR_WINHTTP_INVALID_QUERY_REQUEST                       = 12154,  -- (#2F7A)
  -- Obsolete; no longer used.

  ERROR_HTTP_HEADER_ALREADY_EXISTS                          = 12155,  -- (#2F7B)
  -- The header could not be added because it already exists.

  ERROR_WINHTTP_HEADER_ALREADY_EXISTS                       = 12155,  -- (#2F7B)
  -- Obsolete; no longer used.

  ERROR_HTTP_REDIRECT_FAILED                                = 12156,  -- (#2F7C)
  ERROR_WINHTTP_REDIRECT_FAILED                             = 12156,  -- (#2F7C)
  -- The redirection failed because either the scheme changed (for example, HTTP
  -- to FTP) or all attempts made to redirect failed (default is five attempts).

  ERROR_INTERNET_SECURITY_CHANNEL_ERROR                     = 12157,  -- (#2F7D)
  ERROR_WINHTTP_SECURE_CHANNEL_ERROR                        = 12157,  -- (#2F7D)
  -- The application experienced an internal error loading the SSL libraries.

  ERROR_INTERNET_UNABLE_TO_CACHE_FILE                       = 12158,  -- (#2F7E)
  -- The function was unable to cache the file.

  ERROR_INTERNET_TCPIP_NOT_INSTALLED                        = 12159,  -- (#2F7F)
  -- The required protocol stack is not loaded and the application cannot start
  -- WinSock.

  ERROR_HTTP_NOT_REDIRECTED                                 = 12160,  -- (#2F80)
  -- The HTTP request was not redirected.

  ERROR_HTTP_COOKIE_NEEDS_CONFIRMATION                      = 12161,  -- (#2F81)
  -- The HTTP cookie requires confirmation.

  ERROR_HTTP_COOKIE_DECLINED                                = 12162,  -- (#2F82)
  -- The HTTP cookie was declined by the server.

  ERROR_INTERNET_DISCONNECTED                               = 12163,  -- (#2F83)
  -- The Internet connection has been lost.

  ERROR_INTERNET_SERVER_UNREACHABLE                         = 12164,  -- (#2F84)
  -- The Web site or server indicated is unreachable.

  ERROR_INTERNET_PROXY_SERVER_UNREACHABLE                   = 12165,  -- (#2F85)
  -- The designated proxy server cannot be reached.

  ERROR_INTERNET_BAD_AUTO_PROXY_SCRIPT                      = 12166,  -- (#2F86)
  ERROR_WINHTTP_BAD_AUTO_PROXY_SCRIPT                       = 12166,  -- (#2F86)
  -- There was an error in the automatic proxy configuration script.

  ERROR_INTERNET_UNABLE_TO_DOWNLOAD_SCRIPT                  = 12167,  -- (#2F87)
  ERROR_WINHTTP_UNABLE_TO_DOWNLOAD_SCRIPT                   = 12167,  -- (#2F87)
  -- The automatic proxy configuration script could not be downloaded. The
  -- INTERNET_FLAG_MUST_CACHE_REQUEST flag was set.

  ERROR_HTTP_REDIRECT_NEEDS_CONFIRMATION                    = 12168,  -- (#2F88)
  -- The redirection requires user confirmation.

  ERROR_INTERNET_SEC_INVALID_CERT                           = 12169,  -- (#2F89)
  ERROR_WINHTTP_SECURE_INVALID_CERT                         = 12169,  -- (#2F89)
  -- SSL certificate is invalid.

  ERROR_INTERNET_SEC_CERT_REVOKED                           = 12170,  -- (#2F8A)
  ERROR_WINHTTP_SECURE_CERT_REVOKED                         = 12170,  -- (#2F8A)
  -- SSL certificate was revoked.

  -- InternetAutodial specific errors

  ERROR_INTERNET_FAILED_DUETOSECURITYCHECK                  = 12171,  -- (#2F8B)
  -- The function failed due to a security check.

  ERROR_INTERNET_NOT_INITIALIZED                            = 12172,  -- (#2F8C)
  -- Initialization of the WinINet API has not occurred. Indicates that a
  -- higher-level function, such as InternetOpen, has not been called yet.

  ERROR_WINHTTP_NOT_INITIALIZED                             = 12172,  -- (#2F8C)
  -- Obsolete; no longer used.

  ERROR_INTERNET_LOGIN_FAILURE_DISPLAY_ENTITY_BODY          = 12174,  -- (#2F8E)
  -- The MS-Logoff digest header has been returned from the Web site. This
  -- header specifically instructs the digest package to purge credentials for
  -- the associated realm. This error will only be returned if
  -- INTERNET_ERROR_MASK_LOGIN_FAILURE_DISPLAY_ENTITY_BODY has been set.
  
  ERROR_WINHTTP_SECURE_FAILURE                              = 12175,  -- (#2F8F)
  -- One or more errors were found in the Secure Sockets Layer (SSL) certificate
  -- sent by the server. To determine what type of error was encountered, check
  -- for a WINHTTP_CALLBACK_STATUS_SECURE_FAILURE notification in a status
  -- callback function. For more information, see WINHTTP_STATUS_CALLBACK.

  ERROR_WINHTTP_UNHANDLED_SCRIPT_TYPE                       = 12176,  -- (#2F90)
  -- The script type is not supported.
  
  ERROR_WINHTTP_SCRIPT_EXECUTION_ERROR                      = 12177,  -- (#2F91)
  -- An error was encountered while executing a script.
  
  ERROR_WINHTTP_AUTO_PROXY_SERVICE_ERROR                    = 12178,  -- (#2F92)
  -- Returned by WinHttpGetProxyForUrl when a proxy for the specified URL cannot
  -- be located.
  
  ERROR_WINHTTP_SECURE_CERT_WRONG_USAGE                     = 12179,  -- (#2F93)
  -- Indicates that a certificate is not valid for the requested usage
  -- (equivalent to CERT_E_WRONG_USAGE).
  
  ERROR_WINHTTP_AUTODETECTION_FAILED                        = 12180,  -- (#2F94)
  -- Returned by WinHttpDetectAutoProxyConfigUrl if WinHTTP was unable to
  -- discover the URL of the Proxy Auto-Configuration (PAC) file.
  
  ERROR_WINHTTP_HEADER_COUNT_EXCEEDED                       = 12181,  -- (#2F95)
  -- Returned by WinHttpReceiveResponse when a larger number of headers were
  -- present in a response than WinHTTP could receive.
  
  ERROR_WINHTTP_HEADER_SIZE_OVERFLOW                        = 12182,  -- (#2F96)
  -- Returned by WinHttpReceiveResponse when the size of headers received
  -- exceeds the limit for the request handle.
  
  ERROR_WINHTTP_CHUNKED_ENCODING_HEADER_SIZE_OVERFLOW       = 12183,  -- (#2F97)
  -- Returned by WinHttpReceiveResponse when an overflow condition is
  -- encountered in the course of parsing chunked encoding.
  
  ERROR_WINHTTP_RESPONSE_DRAIN_OVERFLOW                     = 12184,  -- (#2F98)
  -- Returned when an incoming response exceeds an internal WinHTTP size limit.
  
  ERROR_WINHTTP_CLIENT_CERT_NO_PRIVATE_KEY                  = 12185,  -- (#2F99)
  -- The context for the SSL client certificate does not have a private key
  -- associated with it. The client certificate may have been imported to the
  -- computer without the private key.
  -- Windows Server 2003 with SP1 and Windows XP with SP2: This error is not
  -- supported.
  
  ERROR_WINHTTP_CLIENT_CERT_NO_ACCESS_PRIVATE_KEY           = 12186,  -- (#2F9A)
  -- The application does not have the required privileges to access the private
  -- key associated with the client certificate.
  -- Windows Server 2003 with SP1 and Windows XP with SP2: This error is not
  -- supported.

  -- IPsec errors

  ERROR_IPSEC_QM_POLICY_EXISTS                              = 13000,  -- (#32C8)
  -- The specified quick mode policy already exists.

  ERROR_IPSEC_QM_POLICY_NOT_FOUND                           = 13001,  -- (#32C9)
  -- The specified quick mode policy was not found.

  ERROR_IPSEC_QM_POLICY_IN_USE                              = 13002,  -- (#32CA)
  -- The specified quick mode policy is being used.

  ERROR_IPSEC_MM_POLICY_EXISTS                              = 13003,  -- (#32CB)
  -- The specified main mode policy already exists.

  ERROR_IPSEC_MM_POLICY_NOT_FOUND                           = 13004,  -- (#32CC)
  -- The specified main mode policy was not found.

  ERROR_IPSEC_MM_POLICY_IN_USE                              = 13005,  -- (#32CD)
  -- The specified main mode policy is being used.

  ERROR_IPSEC_MM_FILTER_EXISTS                              = 13006,  -- (#32CE)
  -- The specified main mode filter already exists.

  ERROR_IPSEC_MM_FILTER_NOT_FOUND                           = 13007,  -- (#32CF)
  -- The specified main mode filter was not found.

  ERROR_IPSEC_TRANSPORT_FILTER_EXISTS                       = 13008,  -- (#32D0)
  -- The specified transport mode filter already exists.

  ERROR_IPSEC_TRANSPORT_FILTER_NOT_FOUND                    = 13009,  -- (#32D1)
  -- The specified transport mode filter does not exist.

  ERROR_IPSEC_MM_AUTH_EXISTS                                = 13010,  -- (#32D2)
  -- The specified main mode authentication list exists.

  ERROR_IPSEC_MM_AUTH_NOT_FOUND                             = 13011,  -- (#32D3)
  -- The specified main mode authentication list was not found.

  ERROR_IPSEC_MM_AUTH_IN_USE                                = 13012,  -- (#32D4)
  -- The specified quick mode policy is being used.

  ERROR_IPSEC_DEFAULT_MM_POLICY_NOT_FOUND                   = 13013,  -- (#32D5)
  -- The specified main mode policy already exists.

  ERROR_IPSEC_DEFAULT_MM_AUTH_NOT_FOUND                     = 13014,  -- (#32D6)
  -- The specified quick mode policy was not found.

  ERROR_IPSEC_DEFAULT_QM_POLICY_NOT_FOUND                   = 13015,  -- (#32D7)
  -- The manifest file contains one or more syntax errors.

  ERROR_IPSEC_TUNNEL_FILTER_EXISTS                          = 13016,  -- (#32D8)
  -- The application attempted to activate a disabled activation context.

  ERROR_IPSEC_TUNNEL_FILTER_NOT_FOUND                       = 13017,  -- (#32D9)
  -- The requested lookup key was not found in any active activation context.

  ERROR_IPSEC_MM_FILTER_PENDING_DELETION                    = 13018,  -- (#32DA)
  -- The Main Mode filter is pending deletion.

  ERROR_IPSEC_TRANSPORT_FILTER_PENDING_DELETION             = 13019,  -- (#32DB)
  -- The transport filter is pending deletion.

  ERROR_IPSEC_TUNNEL_FILTER_PENDING_DELETION                = 13020,  -- (#32DC)
  -- The tunnel filter is pending deletion.

  ERROR_IPSEC_MM_POLICY_PENDING_DELETION                    = 13021,  -- (#32DD)
  -- The Main Mode policy is pending deletion.

  ERROR_IPSEC_MM_AUTH_PENDING_DELETION                      = 13022,  -- (#32DE)
  -- The Main Mode authentication bundle is pending deletion.

  ERROR_IPSEC_QM_POLICY_PENDING_DELETION                    = 13023,  -- (#32DF)
  -- The Quick Mode policy is pending deletion.

  WARNING_IPSEC_MM_POLICY_PRUNED                            = 13024,  -- (#32E0)
  -- The Main Mode policy was successfully added, but some of the requested
  -- offers are not supported.

  WARNING_IPSEC_QM_POLICY_PRUNED                            = 13025,  -- (#32E1)
  -- The Quick Mode policy was successfully added, but some of the requested
  -- offers are not supported.

  ERROR_IPSEC_IKE_AUTH_FAIL                                 = 13801,  -- (#35E9)
  -- IKE authentication credentials are unacceptable.

  ERROR_IPSEC_IKE_ATTRIB_FAIL                               = 13802,  -- (#35EA)
  -- IKE security attributes are unacceptable.

  ERROR_IPSEC_IKE_NEGOTIATION_PENDING                       = 13803,  -- (#35EB)
  -- IKE Negotiation in progress.

  ERROR_IPSEC_IKE_GENERAL_PROCESSING_ERROR                  = 13804,  -- (#35EC)
  -- General processing error.

  ERROR_IPSEC_IKE_TIMED_OUT                                 = 13805,  -- (#35ED)
  -- Negotiation timed out.

  ERROR_IPSEC_IKE_NO_CERT                                   = 13806,  -- (#35EE)
  -- IKE failed to find valid machine certificate.

  ERROR_IPSEC_IKE_SA_DELETED                                = 13807,  -- (#35EF)
  -- IKE SA deleted by peer before establishment completed.

  ERROR_IPSEC_IKE_SA_REAPED                                 = 13808,  -- (#35F0)
  -- IKE SA deleted before establishment completed.

  ERROR_IPSEC_IKE_MM_ACQUIRE_DROP                           = 13809,  -- (#35F1)
  -- Negotiation request sat in Queue too long.

  ERROR_IPSEC_IKE_QM_ACQUIRE_DROP                           = 13810,  -- (#35F2)
  -- Negotiation request sat in Queue too long.

  ERROR_IPSEC_IKE_QUEUE_DROP_MM                             = 13811,  -- (#35F3)
  -- Negotiation request sat in Queue too long.

  ERROR_IPSEC_IKE_QUEUE_DROP_NO_MM                          = 13812,  -- (#35F4)
  -- Negotiation request sat in Queue too long.

  ERROR_IPSEC_IKE_DROP_NO_RESPONSE                          = 13813,  -- (#35F5)
  -- No response from peer.

  ERROR_IPSEC_IKE_MM_DELAY_DROP                             = 13814,  -- (#35F6)
  -- Negotiation took too long.

  ERROR_IPSEC_IKE_QM_DELAY_DROP                             = 13815,  -- (#35F7)
  -- Negotiation took too long.

  ERROR_IPSEC_IKE_ERROR                                     = 13816,  -- (#35F8)
  -- Unknown error occurred.

  ERROR_IPSEC_IKE_CRL_FAILED                                = 13817,  -- (#35F9)
  -- Certificate Revocation Check failed.

  ERROR_IPSEC_IKE_INVALID_KEY_USAGE                         = 13818,  -- (#35FA)
  -- Invalid certificate key usage.

  ERROR_IPSEC_IKE_INVALID_CERT_TYPE                         = 13819,  -- (#35FB)
  -- Invalid certificate type.

  ERROR_IPSEC_IKE_NO_PRIVATE_KEY                            = 13820,  -- (#35FC)
  -- No private key associated with machine certificate.

  ERROR_IPSEC_IKE_DH_FAIL                                   = 13822,  -- (#35FE)
  -- Failure in Diffie-Helman computation.

  ERROR_IPSEC_IKE_CRITICAL_PAYLOAD_NOT_RECOGNIZED           = 13823,  -- (#35FF)
  -- Don't know how to process critical payload.

  ERROR_IPSEC_IKE_INVALID_HEADER                            = 13824,  -- (#3600)
  -- Invalid header.

  ERROR_IPSEC_IKE_NO_POLICY                                 = 13825,  -- (#3601)
  -- No policy configured.

  ERROR_IPSEC_IKE_INVALID_SIGNATURE                         = 13826,  -- (#3602)
  -- Failed to verify signature.

  ERROR_IPSEC_IKE_KERBEROS_ERROR                            = 13827,  -- (#3603)
  -- Failed to authenticate using Kerberos.

  ERROR_IPSEC_IKE_NO_PUBLIC_KEY                             = 13828,  -- (#3604)
  -- Peer's certificate did not have a public key.

  ERROR_IPSEC_IKE_PROCESS_ERR                               = 13829,  -- (#3605)
  -- Error processing error payload.

  ERROR_IPSEC_IKE_PROCESS_ERR_SA                            = 13830,  -- (#3606)
  -- Error processing SA payload.

  ERROR_IPSEC_IKE_PROCESS_ERR_PROP                          = 13831,  -- (#3607)
  -- Error processing Proposal payload.

  ERROR_IPSEC_IKE_PROCESS_ERR_TRANS                         = 13832,  -- (#3608)
  -- Error processing Transform payload.

  ERROR_IPSEC_IKE_PROCESS_ERR_KE                            = 13833,  -- (#3609)
  -- Error processing KE payload.

  ERROR_IPSEC_IKE_PROCESS_ERR_ID                            = 13834,  -- (#360A)
  -- Error processing ID payload.

  ERROR_IPSEC_IKE_PROCESS_ERR_CERT                          = 13835,  -- (#360B)
  -- Error processing Cert payload.

  ERROR_IPSEC_IKE_PROCESS_ERR_CERT_REQ                      = 13836,  -- (#360C)
  -- Error processing Certificate Request payload.

  ERROR_IPSEC_IKE_PROCESS_ERR_HASH                          = 13837,  -- (#360D)
  -- Error processing Hash payload.

  ERROR_IPSEC_IKE_PROCESS_ERR_SIG                           = 13838,  -- (#360E)
  -- Error processing Signature payload.

  ERROR_IPSEC_IKE_PROCESS_ERR_NONCE                         = 13839,  -- (#360F)
  -- Error processing Nonce payload.

  ERROR_IPSEC_IKE_PROCESS_ERR_NOTIFY                        = 13840,  -- (#3610)
  -- Error processing Notify payload.

  ERROR_IPSEC_IKE_PROCESS_ERR_DELETE                        = 13841,  -- (#3611)
  -- Error processing Delete Payload.

  ERROR_IPSEC_IKE_PROCESS_ERR_VENDOR                        = 13842,  -- (#3612)
  -- Error processing VendorId payload.

  ERROR_IPSEC_IKE_INVALID_PAYLOAD                           = 13843,  -- (#3613)
  -- Invalid payload received.

  ERROR_IPSEC_IKE_LOAD_SOFT_SA                              = 13844,  -- (#3614)
  -- Soft SA loaded.

  ERROR_IPSEC_IKE_SOFT_SA_TORN_DOWN                         = 13845,  -- (#3615)
  -- Soft SA torn down.

  ERROR_IPSEC_IKE_INVALID_COOKIE                            = 13846,  -- (#3616)
  -- Invalid cookie received.

  ERROR_IPSEC_IKE_NO_PEER_CERT                              = 13847,  -- (#3617)
  -- Peer failed to send valid machine certificate.

  ERROR_IPSEC_IKE_PEER_CRL_FAILED                           = 13848,  -- (#3618)
  -- Certification Revocation check of peer's certificate failed.

  ERROR_IPSEC_IKE_POLICY_CHANGE                             = 13849,  -- (#3619)
  -- New policy invalidated SAs formed with old policy.

  ERROR_IPSEC_IKE_NO_MM_POLICY                              = 13850,  -- (#361A)
  -- There is no available Main Mode IKE policy.

  ERROR_IPSEC_IKE_NOTCBPRIV                                 = 13851,  -- (#361B)
  -- Failed to enabled TCB privilege.

  ERROR_IPSEC_IKE_SECLOADFAIL                               = 13852,  -- (#361C)
  -- Failed to load SECURITY.DLL.

  ERROR_IPSEC_IKE_FAILSSPINIT                               = 13853,  -- (#361D)
  -- Failed to obtain security function table dispatch address from SSPI.

  ERROR_IPSEC_IKE_FAILQUERYSSP                              = 13854,  -- (#361E)
  -- Failed to query Kerberos package to obtain max token size.

  ERROR_IPSEC_IKE_SRVACQFAIL                                = 13855,  -- (#361F)
  -- Failed to obtain Kerberos server credentials for ISAKMP/ERROR_IPSEC_IKE
  -- service.  Kerberos authentication will not function. The most likely reason
  -- for this is lack of domain membership. This is normal if your computer is a
  -- member of a workgroup.

  ERROR_IPSEC_IKE_SRVQUERYCRED                              = 13856,  -- (#3620)
  -- Failed to determine SSPI principal name for ISAKMP/ERROR_IPSEC_IKE service 
  -- (QueryCredentialsAttributes).

  ERROR_IPSEC_IKE_GETSPIFAIL                                = 13857,  -- (#3621)
  -- Failed to obtain new SPI for the inbound SA from Ipsec driver. The most
  -- common cause for this is that the driver does not have the correct filter.
  -- Check your policy to verify the filters.

  ERROR_IPSEC_IKE_INVALID_FILTER                            = 13858,  -- (#3622)
  -- Given filter is invalid.

  ERROR_IPSEC_IKE_OUT_OF_MEMORY                             = 13859,  -- (#3623)
  -- Memory allocation failed.

  ERROR_IPSEC_IKE_ADD_UPDATE_KEY_FAILED                     = 13860,  -- (#3624)
  -- Failed to add Security Association to IPSec Driver. The most common cause
  -- for this is if the IKE negotiation took too long to complete. If the
  -- problem persists, reduce the load on the faulting machine.

  ERROR_IPSEC_IKE_INVALID_POLICY                            = 13861,  -- (#3625)
  -- Invalid policy.

  ERROR_IPSEC_IKE_UNKNOWN_DOI                               = 13862,  -- (#3626)
  -- Invalid DOI.

  ERROR_IPSEC_IKE_INVALID_SITUATION                         = 13863,  -- (#3627)
  -- Invalid situation.

  ERROR_IPSEC_IKE_DH_FAILURE                                = 13864,  -- (#3628)
  -- Diffie-Hellman failure.

  ERROR_IPSEC_IKE_INVALID_GROUP                             = 13865,  -- (#3629)
  -- Invalid Diffie-Hellman group.

  ERROR_IPSEC_IKE_ENCRYPT                                   = 13866,  -- (#362A)
  -- Error encrypting payload.

  ERROR_IPSEC_IKE_DECRYPT                                   = 13867,  -- (#362B)
  -- Error decrypting payload.

  ERROR_IPSEC_IKE_POLICY_MATCH                              = 13868,  -- (#362C)
  -- Policy match error.

  ERROR_IPSEC_IKE_UNSUPPORTED_ID                            = 13869,  -- (#362D)
  -- Unsupported ID.

  ERROR_IPSEC_IKE_INVALID_HASH                              = 13870,  -- (#362E)
  -- Hash verification failed.

  ERROR_IPSEC_IKE_INVALID_HASH_ALG                          = 13871,  -- (#362F)
  -- Invalid hash algorithm.

  ERROR_IPSEC_IKE_INVALID_HASH_SIZE                         = 13872,  -- (#3630)
  -- Invalid hash size.

  ERROR_IPSEC_IKE_INVALID_ENCRYPT_ALG                       = 13873,  -- (#3631)
  -- Invalid encryption algorithm.

  ERROR_IPSEC_IKE_INVALID_AUTH_ALG                          = 13874,  -- (#3632)
  -- Invalid authentication algorithm.

  ERROR_IPSEC_IKE_INVALID_SIG                               = 13875,  -- (#3633)
  -- Invalid certificate signature.

  ERROR_IPSEC_IKE_LOAD_FAILED                               = 13876,  -- (#3634)
  -- Load failed.

  ERROR_IPSEC_IKE_RPC_DELETE                                = 13877,  -- (#3635)
  -- Deleted via RPC call.

  ERROR_IPSEC_IKE_BENIGN_REINIT                             = 13878,  -- (#3636)
  -- Temporary state created to perform reinit. This is not a real failure.

  ERROR_IPSEC_IKE_INVALID_RESPONDER_LIFETIME_NOTIFY         = 13879,  -- (#3637)
  -- The lifetime value received in the Responder Lifetime Notify is below the
  -- Windows 2000 configured minimum value. Please fix the policy on the peer
  -- machine.

  ERROR_IPSEC_IKE_QM_LIMIT_REAP                             = 13880,  -- (#3638)
  -- SA reaped because QM limit was reached.

  ERROR_IPSEC_IKE_INVALID_CERT_KEYLEN                       = 13881,  -- (#3639)
  -- Key length in certificate is too small for configured security
  -- requirements.

  ERROR_IPSEC_IKE_MM_LIMIT                                  = 13882,  -- (#363A)
  -- Max number of established MM SAs to peer exceeded.

  ERROR_IPSEC_IKE_NEGOTIATION_DISABLED                      = 13883,  -- (#363B)
  -- IKE received a policy that disables negotiation.

  ERROR_IPSEC_IKE_QM_LIMIT                                  = 13884,  -- (#363C)
  -- Reached maximum quick mode limit for the main mode. New main mode will be
  -- started.

  ERROR_IPSEC_IKE_MM_EXPIRED                                = 13885,  -- (#363D)
  -- Main mode SA lifetime expired or peer sent a main mode delete.

  ERROR_IPSEC_IKE_PEER_MM_ASSUMED_INVALID                   = 13886,  -- (#363E)
  -- Main mode SA assumed to be invalid because peer stopped responding.

  ERROR_IPSEC_IKE_CERT_CHAIN_POLICY_MISMATCH                = 13887,  -- (#363F)
  -- Certificate doesn't chain to a trusted root in IPsec policy.

  ERROR_IPSEC_IKE_UNEXPECTED_MESSAGE_ID                     = 13888,  -- (#3640)
  -- Received unexpected message ID.

  ERROR_IPSEC_IKE_INVALID_AUTH_PAYLOAD                      = 13889,  -- (#3641)
  -- Received invalid authentication offers.

  ERROR_IPSEC_IKE_DOS_COOKIE_SENT                           = 13890,  -- (#3642)
  -- Sent DOS cookie notify to initiator.

  ERROR_IPSEC_IKE_SHUTTING_DOWN                             = 13891,  -- (#3643)
  -- IKE service is shutting down.

  ERROR_IPSEC_IKE_CGA_AUTH_FAILED                           = 13892,  -- (#3644)
  -- Could not verify binding between CGA address and certificate.

  ERROR_IPSEC_IKE_PROCESS_ERR_NATOA                         = 13893,  -- (#3645)
  -- Error processing NatOA payload.

  ERROR_IPSEC_IKE_INVALID_MM_FOR_QM                         = 13894,  -- (#3646)
  -- Parameters of the main mode are invalid for this quick mode.

  ERROR_IPSEC_IKE_QM_EXPIRED                                = 13895,  -- (#3647)
  -- Quick mode SA was expired by IPsec driver.

  ERROR_IPSEC_IKE_TOO_MANY_FILTERS                          = 13896,  -- (#3648)
  -- Too many dynamically added IKEEXT filters were detected.

  ERROR_IPSEC_IKE_NEG_STATUS_END                            = 13897,  -- (#3649)
  -- n/a
  ERROR_IPSEC_IKE_KILL_DUMMY_NAP_TUNNEL                     = 13898,  -- (#364A)
  -- NAP reauth succeeded and must delete the dummy NAP IkeV2 tunnel.

  ERROR_IPSEC_IKE_INNER_IP_ASSIGNMENT_FAILURE               = 13899,  -- (#364B)
  -- Error in assigning inner IP address to intiator in tunnel mode.

  ERROR_IPSEC_IKE_REQUIRE_CP_PAYLOAD_MISSING                = 13900,  -- (#364C)
  -- Require configuration payload missing.

  ERROR_IPSEC_KEY_MODULE_IMPERSONATION_NEGOTIATION_PENDING  = 13901,  -- (#364D)
  -- A negotiation running as the security principle who issued the connection
  -- is in progress.
  
  ERROR_IPSEC_IKE_COEXISTENCE_SUPPRESS                      = 13902,  -- (#364E)
  -- SA was deleted due to IKEv1/AuthIP co-existence suppress check.

  ERROR_IPSEC_IKE_RATELIMIT_DROP                            = 13903,  -- (#364F)
  -- Incoming SA request was dropped due to peer IP address rate limiting.

  ERROR_IPSEC_IKE_PEER_DOESNT_SUPPORT_MOBIKE                = 13904,  -- (#3650)
  -- Peer does not support MOBIKE.

  ERROR_IPSEC_IKE_AUTHORIZATION_FAILURE                     = 13905,  -- (#3651)
  -- SA establishment is not authorized.

  ERROR_IPSEC_IKE_STRONG_CRED_AUTHORIZATION_FAILURE         = 13906,  -- (#3652)
  -- SA establishment is not authorized because there is not a sufficiently
  -- strong PKINIT-based credential.

  ERROR_IPSEC_IKE_AUTHORIZATION_FAILURE_WITH_OPTIONAL_RETRY = 13907,  -- (#3653)
  -- SA establishment is not authorized. You may need to enter updated or
  -- different credentials such as a smartcard.

  ERROR_IPSEC_IKE_STRONG_CRED_AUTHORIZATION_AND_CERTMAP_FAILURE = 13908,  -- (#3654)
  -- SA establishment is not authorized because there is not a sufficiently
  -- strong PKINIT-based credential. This might be related to certificate-to-
  -- account mapping failure for the SA.

  ERROR_IPSEC_BAD_SPI                                       = 13910,  -- (#3656)
  -- The SPI in the packet does not match a valid IPsec SA.

  ERROR_IPSEC_SA_LIFETIME_EXPIRED                           = 13911,  -- (#3657)
  -- Packet was received on an IPsec SA whose lifetime has expired.

  ERROR_IPSEC_WRONG_SA                                      = 13912,  -- (#3658)
  -- Packet was received on an IPsec SA that doesn't match the packet
  -- characteristics.

  ERROR_IPSEC_REPLAY_CHECK_FAILED                           = 13913,  -- (#3659)
  -- Packet sequence number replay check failed.

  ERROR_IPSEC_INVALID_PACKET                                = 13914,  -- (#365A)
  -- IPsec header and/or trailer in the packet is invalid.

  ERROR_IPSEC_INTEGRITY_CHECK_FAILED                        = 13915,  -- (#365B)
  -- IPsec integrity check failed.

  ERROR_IPSEC_CLEAR_TEXT_DROP                               = 13916,  -- (#365C)
  -- IPsec dropped a clear text packet.

  ERROR_IPSEC_AUTH_FIREWALL_DROP                            = 13917,  -- (#365D)
  -- IPsec dropped an incoming ESP packet in authenticated firewall mode. This
  -- drop is benign.

  ERROR_IPSEC_THROTTLE_DROP                                 = 13918,  -- (#365E)
  -- IPsec dropped a packet due to DoS throttling.

  ERROR_IPSEC_DOSP_BLOCK                                    = 13925,  -- (#3665)
  -- IPsec DoS Protection matched an explicit block rule.

  ERROR_IPSEC_DOSP_RECEIVED_MULTICAST                       = 13926,  -- (#3666)
  -- IPsec DoS Protection received an IPsec specific multicast packet which is
  -- not allowed.

  ERROR_IPSEC_DOSP_INVALID_PACKET                           = 13927,  -- (#3667)
  -- IPsec DoS Protection received an incorrectly formatted packet.

  ERROR_IPSEC_DOSP_STATE_LOOKUP_FAILED                      = 13928,  -- (#3668)
  -- IPsec DoS Protection failed to look up state.

  ERROR_IPSEC_DOSP_MAX_ENTRIES                              = 13929,  -- (#3669)
  -- IPsec DoS Protection failed to create state because the maximum number of
  -- entries allowed by policy has been reached.

  ERROR_IPSEC_DOSP_KEYMOD_NOT_ALLOWED                       = 13930,  -- (#366A)
  -- IPsec DoS Protection received an IPsec negotiation packet for a keying
  -- module which is not allowed by policy.

  ERROR_IPSEC_DOSP_NOT_INSTALLED                            = 13931,  -- (#366B)
  -- IPsec DoS Protection has not been enabled.

  ERROR_IPSEC_DOSP_MAX_PER_IP_RATELIMIT_QUEUES              = 13932,  -- (#366C)
  -- IPsec DoS Protection failed to create a per internal IP rate limit queue
  -- because the maximum number of queues allowed by policy has been reached.

  ERROR_SXS_SECTION_NOT_FOUND                               = 14000,  -- (#36B0)
  -- The requested section was not present in the activation context.

  ERROR_SXS_CANT_GEN_ACTCTX                                 = 14001,  -- (#36B1)
  -- This application has failed to start because the application configuration
  -- is incorrect.  Reinstalling the application may fix this problem.

  ERROR_SXS_INVALID_ACTCTXDATA_FORMAT                       = 14002,  -- (#36B2)
  -- The application binding data format is invalid.

  ERROR_SXS_ASSEMBLY_NOT_FOUND                              = 14003,  -- (#36B3)
  -- The referenced assembly is not installed on your system.

  ERROR_SXS_MANIFEST_FORMAT_ERROR                           = 14004,  -- (#36B4)
  -- The manifest file does not begin with the required tag and format
  -- information.

  ERROR_SXS_MANIFEST_PARSE_ERROR                            = 14005,  -- (#36B5)
  -- The manifest file contains one or more syntax errors.

  ERROR_SXS_ACTIVATION_CONTEXT_DISABLED                     = 14006,  -- (#36B6)
  -- The application attempted to activate a disabled activation context.

  ERROR_SXS_KEY_NOT_FOUND                                   = 14007,  -- (#36B7)
  -- The requested lookup key was not found in any active activation context.

  ERROR_SXS_VERSION_CONFLICT                                = 14008,  -- (#36B8)
  -- A component version required by the application conflicts with another
  -- component version already active.

  ERROR_SXS_WRONG_SECTION_TYPE                              = 14009,  -- (#36B9)
  -- The type requested activation context section does not match the query API
  -- used.

  ERROR_SXS_THREAD_QUERIES_DISABLED                         = 14010,  -- (#36BA)
  -- Lack of system resources has required isolated activation to be disabled
  -- for the current thread of execution.

  ERROR_SXS_PROCESS_DEFAULT_ALREADY_SET                     = 14011,  -- (#36BB)
  -- An attempt to set the process default activation context failed because the
  -- process default activation context was already set.

  ERROR_SXS_UNKNOWN_ENCODING_GROUP                          = 14012,  -- (#36BC)
  -- The encoding group identifier specified is not recognized.

  ERROR_SXS_UNKNOWN_ENCODING                                = 14013,  -- (#36BD)
  -- The encoding requested is not recognized.

  ERROR_SXS_INVALID_XML_NAMESPACE_URI                       = 14014,  -- (#36BE)
  -- The manifest contains a reference to an invalid URI.

  ERROR_SXS_ROOT_MANIFEST_DEPENDENCY_NOT_INSTALLED          = 14015,  -- (#36BF)
  -- The application manifest contains a reference to a dependent assembly which
  -- is not installed.

  ERROR_SXS_LEAF_MANIFEST_DEPENDENCY_NOT_INSTALLED          = 14016,  -- (#36C0)
  -- The manifest for an assembly used by the application has a reference to a
  -- dependent assembly which is not installed.

  ERROR_SXS_INVALID_ASSEMBLY_IDENTITY_ATTRIBUTE             = 14017,  -- (#36C1)
  -- The manifest contains an attribute for the assembly identity which is not
  -- valid.

  ERROR_SXS_MANIFEST_MISSING_REQUIRED_DEFAULT_NAMESPACE     = 14018,  -- (#36C2)
  -- The manifest is missing the required default namespace specification on the
  -- assembly element.

  ERROR_SXS_MANIFEST_INVALID_REQUIRED_DEFAULT_NAMESPACE     = 14019,  -- (#36C3)
  -- The manifest has a default namespace specified on the assembly element but
  -- its value is not "urn:schemas-microsoft-com:asm.v1".

  ERROR_SXS_PRIVATE_MANIFEST_CROSS_PATH_WITH_REPARSE_POINT  = 14020,  -- (#36C4)
  -- The private manifest probe has crossed the reparse-point-associated path.

  ERROR_SXS_DUPLICATE_DLL_NAME                              = 14021,  -- (#36C5)
  -- Two or more components referenced directly or indirectly by the application
  -- manifest have files by the same name.

  ERROR_SXS_DUPLICATE_WINDOWCLASS_NAME                      = 14022,  -- (#36C6)
  -- Two or more components referenced directly or indirectly by the application
  -- manifest have window classes with the same name.

  ERROR_SXS_DUPLICATE_CLSID                                 = 14023,  -- (#36C7)
  -- Two or more components referenced directly or indirectly by the application
  -- manifest have the same COM server CLSIDs.

  ERROR_SXS_DUPLICATE_IID                                   = 14024,  -- (#36C8)
  -- Two or more components referenced directly or indirectly by the application
  -- manifest have proxies for the same COM interface IIDs.

  ERROR_SXS_DUPLICATE_TLBID                                 = 14025,  -- (#36C9)
  -- Two or more components referenced directly or indirectly by the application
  -- manifest have the same COM type library TLBIDs.

  ERROR_SXS_DUPLICATE_PROGID                                = 14026,  -- (#36CA)
  -- Two or more components referenced directly or indirectly by the application
  -- manifest have the same COM ProgIDs.

  ERROR_SXS_DUPLICATE_ASSEMBLY_NAME                         = 14027,  -- (#36CB)
  -- Two or more components referenced directly or indirectly by the application
  -- manifest are different versions of the same component which is not
  -- permitted.

  ERROR_SXS_FILE_HASH_MISMATCH                              = 14028,  -- (#36CC)
  -- A component's file does not match the verification information present in
  -- the component manifest.

  ERROR_SXS_POLICY_PARSE_ERROR                              = 14029,  -- (#36CD)
  -- The policy manifest contains one or more syntax errors.

  ERROR_SXS_XML_E_MISSINGQUOTE                              = 14030,  -- (#36CE)
  -- Manifest Parse Error : A string literal was expected, but no opening quote
  -- character was found.

  ERROR_SXS_XML_E_COMMENTSYNTAX                             = 14031,  -- (#36CF)
  -- Manifest Parse Error : Incorrect syntax was used in a comment.

  ERROR_SXS_XML_E_BADSTARTNAMECHAR                          = 14032,  -- (#36D0)
  -- Manifest Parse Error : A name was started with an invalid character.

  ERROR_SXS_XML_E_BADNAMECHAR                               = 14033,  -- (#36D1)
  -- Manifest Parse Error : A name contained an invalid character.

  ERROR_SXS_XML_E_BADCHARINSTRING                           = 14034,  -- (#36D2)
  -- Manifest Parse Error : A string literal contained an invalid character.

  ERROR_SXS_XML_E_XMLDECLSYNTAX                             = 14035,  -- (#36D3)
  -- Manifest Parse Error : Invalid syntax for an XML declaration.

  ERROR_SXS_XML_E_BADCHARDATA                               = 14036,  -- (#36D4)
  -- Manifest Parse Error : An invalid character was found in text content.

  ERROR_SXS_XML_E_MISSINGWHITESPACE                         = 14037,  -- (#36D5)
  -- Manifest Parse Error : Required white space was missing.

  ERROR_SXS_XML_E_EXPECTINGTAGEND                           = 14038,  -- (#36D6)
  -- Manifest Parse Error : The character '>' was expected.

  ERROR_SXS_XML_E_MISSINGSEMICOLON                          = 14039,  -- (#36D7)
  -- Manifest Parse Error : A semi colon character was expected.

  ERROR_SXS_XML_E_UNBALANCEDPAREN                           = 14040,  -- (#36D8)
  -- Manifest Parse Error : Unbalanced parentheses.

  ERROR_SXS_XML_E_INTERNALERROR                             = 14041,  -- (#36D9)
  -- Manifest Parse Error : Internal error.

  ERROR_SXS_XML_E_UNEXPECTED_WHITESPACE                     = 14042,  -- (#36DA)
  -- Manifest Parse Error : White space is not allowed at this location.

  ERROR_SXS_XML_E_INCOMPLETE_ENCODING                       = 14043,  -- (#36DB)
  -- Manifest Parse Error : End of file reached in invalid state for current
  -- encoding.

  ERROR_SXS_XML_E_MISSING_PAREN                             = 14044,  -- (#36DC)
  -- Manifest Parse Error : Missing parenthesis.

  ERROR_SXS_XML_E_EXPECTINGCLOSEQUOTE                       = 14045,  -- (#36DD)
  -- Manifest Parse Error : A single or double closing quote character (\' or
  -- \") is missing.

  ERROR_SXS_XML_E_MULTIPLE_COLONS                           = 14046,  -- (#36DE)
  -- Manifest Parse Error : Multiple colons are not allowed in a name.

  ERROR_SXS_XML_E_INVALID_DECIMAL                           = 14047,  -- (#36DF)
  -- Manifest Parse Error : Invalid character for decimal digit.

  ERROR_SXS_XML_E_INVALID_HEXIDECIMAL                       = 14048,  -- (#36E0)
  -- Manifest Parse Error : Invalid character for hexadecimal digit.

  ERROR_SXS_XML_E_INVALID_UNICODE                           = 14049,  -- (#36E1)
  -- Manifest Parse Error : Invalid Unicode character value for this platform.

  ERROR_SXS_XML_E_WHITESPACEORQUESTIONMARK                  = 14050,  -- (#36E2)
  -- Manifest Parse Error : Expecting white space or '?'.

  ERROR_SXS_XML_E_UNEXPECTEDENDTAG                          = 14051,  -- (#36E3)
  -- Manifest Parse Error : End tag was not expected at this location.

  ERROR_SXS_XML_E_UNCLOSEDTAG                               = 14052,  -- (#36E4)
  -- Manifest Parse Error : The following tags were not closed: %1.

  ERROR_SXS_XML_E_DUPLICATEATTRIBUTE                        = 14053,  -- (#36E5)
  -- Manifest Parse Error : Duplicate attribute.

  ERROR_SXS_XML_E_MULTIPLEROOTS                             = 14054,  -- (#36E6)
  -- Manifest Parse Error : Only one top level element is allowed in an XML
  -- document.

  ERROR_SXS_XML_E_INVALIDATROOTLEVEL                        = 14055,  -- (#36E7)
  -- Manifest Parse Error : Invalid at the top level of the document.

  ERROR_SXS_XML_E_BADXMLDECL                                = 14056,  -- (#36E8)
  -- Manifest Parse Error : Invalid XML declaration.

  ERROR_SXS_XML_E_MISSINGROOT                               = 14057,  -- (#36E9)
  -- Manifest Parse Error : XML document must have a top level element.

  ERROR_SXS_XML_E_UNEXPECTEDEOF                             = 14058,  -- (#36EA)
  -- Manifest Parse Error : Unexpected end of file.

  ERROR_SXS_XML_E_BADPEREFINSUBSET                          = 14059,  -- (#36EB)
  -- Manifest Parse Error : Parameter entities cannot be used inside markup
  -- declarations in an internal subset.

  ERROR_SXS_XML_E_UNCLOSEDSTARTTAG                          = 14060,  -- (#36EC)
  -- Manifest Parse Error : Element was not closed.

  ERROR_SXS_XML_E_UNCLOSEDENDTAG                            = 14061,  -- (#36ED)
  -- Manifest Parse Error : End element was missing the character '>'.

  ERROR_SXS_XML_E_UNCLOSEDSTRING                            = 14062,  -- (#36EE)
  -- Manifest Parse Error : A string literal was not closed.

  ERROR_SXS_XML_E_UNCLOSEDCOMMENT                           = 14063,  -- (#36EF)
  -- Manifest Parse Error : A comment was not closed.

  ERROR_SXS_XML_E_UNCLOSEDDECL                              = 14064,  -- (#36F0)
  -- Manifest Parse Error : A declaration was not closed.

  ERROR_SXS_XML_E_UNCLOSEDCDATA                             = 14065,  -- (#36F1)
  -- Manifest Parse Error : A CDATA section was not closed.

  ERROR_SXS_XML_E_RESERVEDNAMESPACE                         = 14066,  -- (#36F2)
  -- Manifest Parse Error : The namespace prefix is not allowed to start with
  -- the reserved string "xml".

  ERROR_SXS_XML_E_INVALIDENCODING                           = 14067,  -- (#36F3)
  -- Manifest Parse Error : System does not support the specified encoding.

  ERROR_SXS_XML_E_INVALIDSWITCH                             = 14068,  -- (#36F4)
  -- Manifest Parse Error : Switch from current encoding to specified encoding
  -- not supported.

  ERROR_SXS_XML_E_BADXMLCASE                                = 14069,  -- (#36F5)
  -- Manifest Parse Error : The name 'xml' is reserved and must be lower case.

  ERROR_SXS_XML_E_INVALID_STANDALONE                        = 14070,  -- (#36F6)
  -- Manifest Parse Error : The standalone attribute must have the value 'yes'
  -- or 'no'.

  ERROR_SXS_XML_E_UNEXPECTED_STANDALONE                     = 14071,  -- (#36F7)
  -- Manifest Parse Error : The standalone attribute cannot be used in external
  -- entities.

  ERROR_SXS_XML_E_INVALID_VERSION                           = 14072,  -- (#36F8)
  -- Manifest Parse Error : Invalid version number.

  ERROR_SXS_XML_E_MISSINGEQUALS                             = 14073,  -- (#36F9)
  -- Manifest Parse Error : Missing equals sign between attribute and attribute
  -- value.

  ERROR_SXS_PROTECTION_RECOVERY_FAILED                      = 14074,  -- (#36FA)
  -- Assembly Protection Error: Unable to recover the specified assembly.

  ERROR_SXS_PROTECTION_PUBLIC_KEY_TOO_SHORT                 = 14075,  -- (#36FB)
  -- Assembly Protection Error: The public key for an assembly was too short to
  -- be allowed.

  ERROR_SXS_PROTECTION_CATALOG_NOT_VALID                    = 14076,  -- (#36FC)
  -- Assembly Protection Error: The catalog for an assembly is not valid, or
  -- does not match the assembly's manifest.

  ERROR_SXS_UNTRANSLATABLE_HRESULT                          = 14077,  -- (#36FD)
  -- An HRESULT could not be translated to a corresponding Win32 error code.

  ERROR_SXS_PROTECTION_CATALOG_FILE_MISSING                 = 14078,  -- (#36FE)
  -- Assembly Protection Error: The catalog for an assembly is missing.

  ERROR_SXS_MISSING_ASSEMBLY_IDENTITY_ATTRIBUTE             = 14079,  -- (#36FF)
  -- The supplied assembly identity is missing one or more attributes which must
  -- be present in this context.

  ERROR_SXS_INVALID_ASSEMBLY_IDENTITY_ATTRIBUTE_NAME        = 14080,  -- (#3700)
  -- The supplied assembly identity has one or more attribute names that contain
  -- characters not permitted in XML names.

  ERROR_SXS_ASSEMBLY_MISSING                                = 14081,  -- (#3701)
  -- The referenced assembly could not be found.

  ERROR_SXS_CORRUPT_ACTIVATION_STACK                        = 14082,  -- (#3702)
  -- The activation context activation stack for the running thread of execution
  -- is corrupt.

  ERROR_SXS_CORRUPTION                                      = 14083,  -- (#3703)
  -- The application isolation metadata for this process or thread has become
  -- corrupt.

  ERROR_SXS_EARLY_DEACTIVATION                              = 14084,  -- (#3704)
  -- The activation context being deactivated is not the most recently activated
  -- one.

  ERROR_SXS_INVALID_DEACTIVATION                            = 14085,  -- (#3705)
  -- The activation context being deactivated is not active for the current
  -- thread of execution.

  ERROR_SXS_MULTIPLE_DEACTIVATION                           = 14086,  -- (#3706)
  -- The activation context being deactivated has already been deactivated.

  ERROR_SXS_PROCESS_TERMINATION_REQUESTED                   = 14087,  -- (#3707)
  -- A component used by the isolation facility has requested to terminate the
  -- process.

  ERROR_SXS_RELEASE_ACTIVATION_CONTEXT                      = 14088,  -- (#3708)
  -- A kernel mode component is releasing a reference on an activation context.

  ERROR_SXS_SYSTEM_DEFAULT_ACTIVATION_CONTEXT_EMPTY         = 14089,  -- (#3709)
  -- The activation context of system default assembly could not be generated.

  ERROR_SXS_INVALID_IDENTITY_ATTRIBUTE_VALUE                = 14090,  -- (#370A)
  -- The value of an attribute in an identity is not within the legal range.

  ERROR_SXS_INVALID_IDENTITY_ATTRIBUTE_NAME                 = 14091,  -- (#370B)
  -- The name of an attribute in an identity is not within the legal range.

  ERROR_SXS_IDENTITY_DUPLICATE_ATTRIBUTE                    = 14092,  -- (#370C)
  -- An identity contains two definitions for the same attribute.

  ERROR_SXS_IDENTITY_PARSE_ERROR                            = 14093,  -- (#370D)
  -- The identity string is malformed. This may be due to a trailing comma, more
  -- than two unnamed attributes, missing attribute name or missing attribute
  -- value.

  ERROR_MALFORMED_SUBSTITUTION_STRING                       = 14094,  -- (#370E)
  -- A string containing localized substitutable content was malformed. Either a
  -- dollar sign ($) was followed by something other than a left parenthesis or
  -- another dollar sign or an substitution's right parenthesis was not found.

  ERROR_SXS_INCORRECT_PUBLIC_KEY_TOKEN                      = 14095,  -- (#370F)
  -- The public key token does not correspond to the public key specified.

  ERROR_UNMAPPED_SUBSTITUTION_STRING                        = 14096,  -- (#3710)
  -- A substitution string had no mapping.

  ERROR_SXS_ASSEMBLY_NOT_LOCKED                             = 14097,  -- (#3711)
  -- The component must be locked before making the request.

  ERROR_SXS_COMPONENT_STORE_CORRUPT                         = 14098,  -- (#3712)
  -- The component store has been corrupted.

  ERROR_ADVANCED_INSTALLER_FAILED                           = 14099,  -- (#3713)
  -- An advanced installer failed during setup or servicing.

  ERROR_XML_ENCODING_MISMATCH                               = 14100,  -- (#3714)
  -- The character encoding in the XML declaration did not match the encoding
  -- used in the document.

  ERROR_SXS_MANIFEST_IDENTITY_SAME_BUT_CONTENTS_DIFFERENT   = 14101,  -- (#3715)
  -- The identities of the manifests are identical but their contents are
  -- different.

  ERROR_SXS_IDENTITIES_DIFFERENT                            = 14102,  -- (#3716)
  -- The component identities are different.

  ERROR_SXS_ASSEMBLY_IS_NOT_A_DEPLOYMENT                    = 14103,  -- (#3717)
  -- The assembly is not a deployment.

  ERROR_SXS_FILE_NOT_PART_OF_ASSEMBLY                       = 14104,  -- (#3718)
  -- The file is not a part of the assembly.

  ERROR_SXS_MANIFEST_TOO_BIG                                = 14105,  -- (#3719)
  -- The size of the manifest exceeds the maximum allowed.

  ERROR_SXS_SETTING_NOT_REGISTERED                          = 14106,  -- (#371A)
  -- The setting is not registered.

  ERROR_SXS_TRANSACTION_CLOSURE_INCOMPLETE                  = 14107,  -- (#371B)
  -- One or more required members of the transaction are not present.

  ERROR_SMI_PRIMITIVE_INSTALLER_FAILED                      = 14108,  -- (#371C)
  -- The SMI primitive installer failed during setup or servicing.

  ERROR_GENERIC_COMMAND_FAILED                              = 14109,  -- (#371D)
  -- A generic command executable returned a result that indicates failure.

  ERROR_SXS_FILE_HASH_MISSING                               = 14110,  -- (#371E)
  -- A component is missing file verification information in its manifest.

  ERROR_EVT_INVALID_CHANNEL_PATH                            = 15000,  -- (#3A98)
  -- The specified channel path is invalid.

  ERROR_EVT_INVALID_QUERY                                   = 15001,  -- (#3A99)
  -- The specified query is invalid.

  ERROR_EVT_PUBLISHER_METADATA_NOT_FOUND                    = 15002,  -- (#3A9A)
  -- The publisher metadata cannot be found in the resource.

  ERROR_EVT_EVENT_TEMPLATE_NOT_FOUND                        = 15003,  -- (#3A9B)
  -- The template for an event definition cannot be found in the resource (error
  -- = %1).

  ERROR_EVT_INVALID_PUBLISHER_NAME                          = 15004,  -- (#3A9C)
  -- The specified publisher name is invalid.

  ERROR_EVT_INVALID_EVENT_DATA                              = 15005,  -- (#3A9D)
  -- The event data raised by the publisher is not compatible with the event
  -- template definition in the publisher's manifest.
  
  ERROR_EVT_CHANNEL_NOT_FOUND                               = 15007,  -- (#3A9F)
  -- The specified channel could not be found. Check channel configuration.

  ERROR_EVT_MALFORMED_XML_TEXT                              = 15008,  -- (#3AA0)
  -- The specified xml text was not well-formed. See Extended Error for more
  -- details.

  ERROR_EVT_SUBSCRIPTION_TO_DIRECT_CHANNEL                  = 15009,  -- (#3AA1)
  -- The caller is trying to subscribe to a direct channel which is not allowed.
  -- The events for a direct channel go directly to a logfile and cannot be
  -- subscribed to.

  ERROR_EVT_CONFIGURATION_ERROR                             = 15010,  -- (#3AA2)
  -- Configuration error.

  ERROR_EVT_QUERY_RESULT_STALE                              = 15011,  -- (#3AA3)
  -- The query result is stale / invalid. This may be due to the log being
  -- cleared or rolling over after the query result was created. Users should
  -- handle this code by releasing the query result object and reissuing the
  -- query.

  ERROR_EVT_QUERY_RESULT_INVALID_POSITION                   = 15012,  -- (#3AA4)
  -- Query result is currently at an invalid position.

  ERROR_EVT_NON_VALIDATING_MSXML                            = 15013,  -- (#3AA5)
  -- Registered MSXML doesn't support validation.

  ERROR_EVT_FILTER_ALREADYSCOPED                            = 15014,  -- (#3AA6)
  -- An expression can only be followed by a change of scope operation if it
  -- itself evaluates to a node set and is not already part of some other change
  -- of scope operation.

  ERROR_EVT_FILTER_NOTELTSET                                = 15015,  -- (#3AA7)
  -- Can't perform a step operation from a term that does not represent an
  -- element set.

  ERROR_EVT_FILTER_INVARG                                   = 15016,  -- (#3AA8)
  -- Left hand side arguments to binary operators must be either attributes,
  -- nodes or variables and right hand side arguments must be constants.

  ERROR_EVT_FILTER_INVTEST                                  = 15017,  -- (#3AA9)
  -- A step operation must involve either a node test or, in the case of a
  -- predicate, an algebraic expression against which to test each node in the
  -- node set identified by the preceeding node set can be evaluated.

  ERROR_EVT_FILTER_INVTYPE                                  = 15018,  -- (#3AAA)
  -- This data type is currently unsupported.

  ERROR_EVT_FILTER_PARSEERR                                 = 15019,  -- (#3AAB)
  -- A syntax error occurred at position %1!d!

  ERROR_EVT_FILTER_UNSUPPORTEDOP                            = 15020,  -- (#3AAC)
  -- This operator is unsupported by this implementation of the filter.

  ERROR_EVT_FILTER_UNEXPECTEDTOKEN                          = 15021,  -- (#3AAD)
  -- The token encountered was unexpected.

  ERROR_EVT_INVALID_OPERATION_OVER_ENABLED_DIRECT_CHANNEL   = 15022,  -- (#3AAE)
  -- The requested operation cannot be performed over an enabled direct channel.
  -- The channel must first be disabled before performing the requested
  -- operation.

  ERROR_EVT_INVALID_CHANNEL_PROPERTY_VALUE                  = 15023,  -- (#3AAF)
  -- Channel property %1!s! contains invalid value. The value has invalid type,
  -- is outside of valid range, can't be updated or is not supported by this
  -- type of channel.

  ERROR_EVT_INVALID_PUBLISHER_PROPERTY_VALUE                = 15024,  -- (#3AB0)
  -- Publisher property %1!s! contains invalid value. The value has invalid
  -- type, is outside of valid range, can't be updated or is not supported by
  -- this type of publisher.

  ERROR_EVT_CHANNEL_CANNOT_ACTIVATE                         = 15025,  -- (#3AB1)
  -- The channel fails to activate.

  ERROR_EVT_FILTER_TOO_COMPLEX                              = 15026,  -- (#3AB2)
  -- The xpath expression exceeded supported complexity. Please symplify it or
  -- split it into two or more simple expressions.

  ERROR_EVT_MESSAGE_NOT_FOUND                               = 15027,  -- (#3AB3)
  -- the message resource is present but the message is not found in the string/
  -- message table.
  
  ERROR_EVT_MESSAGE_ID_NOT_FOUND                            = 15028,  -- (#3AB4)
  -- The message id for the desired message could not be found.

  ERROR_EVT_UNRESOLVED_VALUE_INSERT                         = 15029,  -- (#3AB5)
  -- The substitution string for insert index (%1) could not be found.

  ERROR_EVT_UNRESOLVED_PARAMETER_INSERT                     = 15030,  -- (#3AB6)
  -- The description string for parameter reference (%1) could not be found.

  ERROR_EVT_MAX_INSERTS_REACHED                             = 15031,  -- (#3AB7)
  -- The maximum number of replacements has been reached.

  ERROR_EVT_EVENT_DEFINITION_NOT_FOUND                      = 15032,  -- (#3AB8)
  -- The event definition could not be found for event id (%1).

  ERROR_EVT_MESSAGE_LOCALE_NOT_FOUND                        = 15033,  -- (#3AB9)
  -- The locale specific resource for the desired message is not present.

  ERROR_EVT_VERSION_TOO_OLD                                 = 15034,  -- (#3ABA)
  -- The resource is too old to be compatible.

  ERROR_EVT_VERSION_TOO_NEW                                 = 15035,  -- (#3ABB)
  -- The resource is too new to be compatible.

  ERROR_EVT_CANNOT_OPEN_CHANNEL_OF_QUERY                    = 15036,  -- (#3ABC)
  -- The channel at index %1!d! of the query can't be opened.

  ERROR_EVT_PUBLISHER_DISABLED                              = 15037,  -- (#3ABD)
  -- The publisher has been disabled and its resource is not avaiable. This
  -- usually occurs when the publisher is in the process of being uninstalled or
  -- upgraded.

  ERROR_EVT_FILTER_OUT_OF_RANGE                             = 15038,  -- (#3ABE)
  -- Attempted to create a numeric type that is outside of its valid range.

  ERROR_EC_SUBSCRIPTION_CANNOT_ACTIVATE                     = 15080,  -- (#3AE8)
  -- The subscription fails to activate.

  ERROR_EC_LOG_DISABLED                                     = 15081,  -- (#3AE9)
  -- The log of the subscription is in disabled state, and can not be used to
  -- forward events to. The log must first be enabled before the subscription
  -- can be activated.

  ERROR_EC_CIRCULAR_FORWARDING                              = 15082,  -- (#3AEA)
  -- When forwarding events from local machine to itself, the query of the
  -- subscription can't contain target log of the subscription.

  ERROR_EC_CREDSTORE_FULL                                   = 15083,  -- (#3AEB)
  -- The credential store that is used to save credentials is full.

  ERROR_EC_CRED_NOT_FOUND                                   = 15084,  -- (#3AEC)
  -- The credential used by this subscription can't be found in credential
  -- store.

  ERROR_EC_NO_ACTIVE_CHANNEL                                = 15085,  -- (#3AED)
  -- No active channel is found for the query.

  ERROR_MUI_FILE_NOT_FOUND                                  = 15100,  -- (#3AFC)
  -- The resource loader failed to find MUI file.

  ERROR_MUI_INVALID_FILE                                    = 15101,  -- (#3AFD)
  -- The resource loader failed to load MUI file because the file fail to pass
  -- validation.

  ERROR_MUI_INVALID_RC_CONFIG                               = 15102,  -- (#3AFE)
  -- The RC Manifest is corrupted with garbage data or unsupported version or
  -- missing required item.

  ERROR_MUI_INVALID_LOCALE_NAME                             = 15103,  -- (#3AFF)
  -- The RC Manifest has invalid culture name.

  ERROR_MUI_INVALID_ULTIMATEFALLBACK_NAME                   = 15104,  -- (#3B00)
  -- The RC Manifest has invalid ultimatefallback name.

  ERROR_MUI_FILE_NOT_LOADED                                 = 15105,  -- (#3B01)
  -- The resource loader cache doesn't have loaded MUI entry.

  ERROR_RESOURCE_ENUM_USER_STOP                             = 15106,  -- (#3B02)
  -- User stopped resource enumeration.

  ERROR_MUI_INTLSETTINGS_UILANG_NOT_INSTALLED               = 15107,  -- (#3B03)
  -- UI language installation failed.

  ERROR_MUI_INTLSETTINGS_INVALID_LOCALE_NAME                = 15108,  -- (#3B04)
  -- Locale installation failed.

  ERROR_MCA_INVALID_CAPABILITIES_STRING                     = 15200,  -- (#3B60)
  -- The monitor returned a DDC/CI capabilities string that did not comply with
  -- the ACCESS.bus 3.

  ERROR_MCA_INVALID_VCP_VERSION                             = 15201,  -- (#3B61)
  -- The monitor's VCP Version (0xDF) VCP code returned an invalid version
  -- value.

  ERROR_MCA_MONITOR_VIOLATES_MCCS_SPECIFICATION             = 15202,  -- (#3B62)
  -- The monitor does not comply with the MCCS specification it claims to
  -- support.

  ERROR_MCA_MCCS_VERSION_MISMATCH                           = 15203,  -- (#3B63)
  -- The MCCS version in a monitor's mccs_ver capability does not match the MCCS
  -- version the monitor reports when the VCP Version (0xDF) VCP code is used.

  ERROR_MCA_UNSUPPORTED_MCCS_VERSION                        = 15204,  -- (#3B64)
  -- The Monitor Configuration API only works with monitors that support the
  -- MCCS 1.

  ERROR_MCA_INTERNAL_ERROR                                  = 15205,  -- (#3B65)
  -- An internal Monitor Configuration API error occurred.

  ERROR_MCA_INVALID_TECHNOLOGY_TYPE_RETURNED                = 15206,  -- (#3B66)
  -- The monitor returned an invalid monitor technology type. CRT, Plasma and
  -- LCD (TFT) are examples of monitor technology types. This error implies that
  -- the monitor violated the MCCS 2.

  ERROR_MCA_UNSUPPORTED_COLOR_TEMPERATURE                   = 15207,  -- (#3B67)
  -- The caller of SetMonitorColorTemperature specified a color temperature that
  -- the current monitor did not support. This error implies that the monitor
  -- violated the MCCS 2.

  ERROR_AMBIGUOUS_SYSTEM_DEVICE                             = 15250,  -- (#3B92)
  -- The requested system device cannot be identified due to multiple
  -- indistinguishable devices potentially matching the identification criteria.

  ERROR_SYSTEM_DEVICE_NOT_FOUND                             = 15299,  -- (#3BC3)
  -- The requested system device cannot be found.

  ERROR_HASH_NOT_SUPPORTED                                  = 15300,  -- (#3BC4)
  -- Hash generation for the specified hash version and hash type is not enabled
  -- on the server.

  ERROR_HASH_NOT_PRESENT                                    = 15301,  -- (#3BC5)
  -- The hash requested from the server is not available or no longer valid.

  ERROR_SECONDARY_IC_PROVIDER_NOT_REGISTERED                = 15321,  -- (#3BD9)
  -- The secondary interrupt controller instance that manages the specified
  -- interrupt is not registered.

  ERROR_GPIO_CLIENT_INFORMATION_INVALID                     = 15322,  -- (#3BDA)
  -- The information supplied by the GPIO client driver is invalid.

  ERROR_GPIO_VERSION_NOT_SUPPORTED                          = 15323,  -- (#3BDB)
  -- The version specified by the GPIO client driver is not supported.

  ERROR_GPIO_INVALID_REGISTRATION_PACKET                    = 15324,  -- (#3BDC)
  -- The registration packet supplied by the GPIO client driver is not valid.

  ERROR_GPIO_OPERATION_DENIED                               = 15325,  -- (#3BDD)
  -- The requested operation is not suppported for the specified handle.

  ERROR_GPIO_INCOMPATIBLE_CONNECT_MODE                      = 15326,  -- (#3BDE)
  -- The requested connect mode conflicts with an existing mode on one or more
  -- of the specified pins.

  ERROR_GPIO_INTERRUPT_ALREADY_UNMASKED                     = 15327,  -- (#3BDF)
  -- The interrupt requested to be unmasked is not masked.

  ERROR_CANNOT_SWITCH_RUNLEVEL                              = 15400,  -- (#3C28)
  -- The requested run level switch cannot be completed successfully.

  ERROR_INVALID_RUNLEVEL_SETTING                            = 15401,  -- (#3C29)
  -- The service has an invalid run level setting. The run level for a service
  -- must not be higher than the run level of its dependent services.

  ERROR_RUNLEVEL_SWITCH_TIMEOUT                             = 15402,  -- (#3C2A)
  -- The requested run level switch cannot be completed successfully since one
  -- or more services will not stop or restart within the specified timeout.

  ERROR_RUNLEVEL_SWITCH_AGENT_TIMEOUT                       = 15403,  -- (#3C2B)
  -- A run level switch agent did not respond within the specified timeout.

  ERROR_RUNLEVEL_SWITCH_IN_PROGRESS                         = 15404,  -- (#3C2C)
  -- A run level switch is currently in progress.

  ERROR_SERVICES_FAILED_AUTOSTART                           = 15405,  -- (#3C2D)
  -- One or more services failed to start during the service startup phase of a
  -- run level switch.

  ERROR_COM_TASK_STOP_PENDING                               = 15501,  -- (#3C8D)
  -- The task stop request cannot be completed immediately since task needs more
  -- time to shutdown.

  ERROR_INSTALL_OPEN_PACKAGE_FAILED                         = 15600,  -- (#3CF0)
  -- Package could not be opened.

  ERROR_INSTALL_PACKAGE_NOT_FOUND                           = 15601,  -- (#3CF1)
  -- Package was not found.

  ERROR_INSTALL_INVALID_PACKAGE                             = 15602,  -- (#3CF2)
  -- Package data is invalid.

  ERROR_INSTALL_RESOLVE_DEPENDENCY_FAILED                   = 15603,  -- (#3CF3)
  -- Package failed updates, dependency or conflict validation.

  ERROR_INSTALL_OUT_OF_DISK_SPACE                           = 15604,  -- (#3CF4)
  -- There is not enough disk space on your computer. Please free up some space
  -- and try again.

  ERROR_INSTALL_NETWORK_FAILURE                             = 15605,  -- (#3CF5)
  -- There was a problem downloading your product.

  ERROR_INSTALL_REGISTRATION_FAILURE                        = 15606,  -- (#3CF6)
  -- Package could not be registered.

  ERROR_INSTALL_DEREGISTRATION_FAILURE                      = 15607,  -- (#3CF7)
  -- Package could not be unregistered.

  ERROR_INSTALL_CANCEL                                      = 15608,  -- (#3CF8)
  -- User cancelled the install request.

  ERROR_INSTALL_FAILED                                      = 15609,  -- (#3CF9)
  -- Install failed. Please contact your software vendor.

  ERROR_REMOVE_FAILED                                       = 15610,  -- (#3CFA)
  -- Removal failed. Please contact your software vendor.

  ERROR_PACKAGE_ALREADY_EXISTS                              = 15611,  -- (#3CFB)
  -- The provided package is already installed, and reinstallation of the
  -- package was blocked. Check the AppXDeployment-Server event log for details.

  ERROR_NEEDS_REMEDIATION                                   = 15612,  -- (#3CFC)
  -- The application cannot be started. Try reinstalling the application to fix
  -- the problem.

  ERROR_INSTALL_PREREQUISITE_FAILED                         = 15613,  -- (#3CFD)
  -- A Prerequisite for an install could not be satisfied.

  ERROR_PACKAGE_REPOSITORY_CORRUPTED                        = 15614,  -- (#3CFE)
  -- The package repository is corrupted.

  ERROR_INSTALL_POLICY_FAILURE                              = 15615,  -- (#3CFF)
  -- To install this application you need either a Windows developer license or
  -- a sideloading-enabled system.

  ERROR_PACKAGE_UPDATING                                    = 15616,  -- (#3D00)
  -- The application cannot be started because it is currently updating.

  ERROR_DEPLOYMENT_BLOCKED_BY_POLICY                        = 15617,  -- (#3D01)
  -- The package deployment operation is blocked by policy. Please contact your
  -- system administrator.

  ERROR_PACKAGES_IN_USE                                     = 15618,  -- (#3D02)
  -- The package could not be installed because resources it modifies are
  -- currently in use.

  ERROR_RECOVERY_FILE_CORRUPT                               = 15619,  -- (#3D03)
  -- The package could not be recovered because necessary data for recovery have
  -- been corrupted.
--<constant>
--<name>ERROR_JOIN_TO_SUBST</name>
--<value>140</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_SUBST_TO_JOIN</name>
--<value>141</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_BUSY_DRIVE</name>
--<value>142</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_SAME_DRIVE</name>
--<value>143</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_DIR_NOT_ROOT</name>
--<value>144</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_DIR_NOT_EMPTY</name>
--<value>145</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_IS_SUBST_PATH</name>
--<value>146</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_IS_JOIN_PATH</name>
--<value>147</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_PATH_BUSY</name>
--<value>148</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_IS_SUBST_TARGET</name>
--<value>149</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_SYSTEM_TRACE</name>
--<value>150</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_INVALID_EVENT_COUNT</name>
--<value>151</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_TOO_MANY_MUXWAITERS</name>
--<value>152</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_INVALID_LIST_FORMAT</name>
--<value>153</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_LABEL_TOO_LONG</name>
--<value>154</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_TOO_MANY_TCBS</name>
--<value>155</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_SIGNAL_REFUSED</name>
--<value>156</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_DISCARDED</name>
--<value>157</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_NOT_LOCKED</name>
--<value>158</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_BAD_THREADID_ADDR</name>
--<value>159</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_BAD_ARGUMENTS</name>
--<value>160</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_BAD_PATHNAME</name>
--<value>161</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_SIGNAL_PENDING</name>
--<value>162</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_MAX_THRDS_REACHED</name>
--<value>164</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_LOCK_FAILED</name>
--<value>167</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_BUSY</name>
--<value>170</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_CANCEL_VIOLATION</name>
--<value>173</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_ATOMIC_LOCKS_NOT_SUPPORTED</name>
--<value>174</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_INVALID_SEGMENT_NUMBER</name>
--<value>180</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_INVALID_ORDINAL</name>
--<value>182</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_ALREADY_EXISTS</name>
--<value>183</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_INVALID_FLAG_NUMBER</name>
--<value>186</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_SEM_NOT_FOUND</name>
--<value>187</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_INVALID_STARTING_CODESEG</name>
--<value>188</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_INVALID_STACKSEG</name>
--<value>189</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_INVALID_MODULETYPE</name>
--<value>190</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_INVALID_EXE_SIGNATURE</name>
--<value>191</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_EXE_MARKED_INVALID</name>
--<value>192</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_BAD_EXE_FORMAT</name>
--<value>193</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_ITERATED_DATA_EXCEEDS_64k</name>
--<value>194</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_INVALID_MINALLOCSIZE</name>
--<value>195</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_DYNLINK_FROM_INVALID_RING</name>
--<value>196</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_IOPL_NOT_ENABLED</name>
--<value>197</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_INVALID_SEGDPL</name>
--<value>198</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_AUTODATASEG_EXCEEDS_64k</name>
--<value>199</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_RING2SEG_MUST_BE_MOVABLE</name>
--<value>200</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_RELOC_CHAIN_XEEDS_SEGLIM</name>
--<value>201</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_INFLOOP_IN_RELOC_CHAIN</name>
--<value>202</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_ENVVAR_NOT_FOUND</name>
--<value>203</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_NO_SIGNAL_SENT</name>
--<value>205</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_FILENAME_EXCED_RANGE</name>
--<value>206</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_RING2_STACK_IN_USE</name>
--<value>207</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_META_EXPANSION_TOO_LONG</name>
--<value>208</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_INVALID_SIGNAL_NUMBER</name>
--<value>209</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_THREAD_1_INACTIVE</name>
--<value>210</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_LOCKED</name>
--<value>212</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_TOO_MANY_MODULES</name>
--<value>214</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_NESTING_NOT_ALLOWED</name>
--<value>215</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_EXE_MACHINE_TYPE_MISMATCH</name>
--<value>216</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_EXE_CANNOT_MODIFY_SIGNED_BINARY</name>
--<value>217</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_EXE_CANNOT_MODIFY_STRONG_SIGNED_BINARY</name>
--<value>218</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_FILE_CHECKED_OUT</name>
--<value>220</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_CHECKOUT_REQUIRED</name>
--<value>221</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_BAD_FILE_TYPE</name>
--<value>222</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_FILE_TOO_LARGE</name>
--<value>223</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_FORMS_AUTH_REQUIRED</name>
--<value>224</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_VIRUS_INFECTED</name>
--<value>225</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_VIRUS_DELETED</name>
--<value>226</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_PIPE_LOCAL</name>
--<value>229</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_BAD_PIPE</name>
--<value>230</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_PIPE_BUSY</name>
--<value>231</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_NO_DATA</name>
--<value>232</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_PIPE_NOT_CONNECTED</name>
--<value>233</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_MORE_DATA</name>
--<value>234</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_VC_DISCONNECTED</name>
--<value>240</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_INVALID_EA_NAME</name>
--<value>254</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_EA_LIST_INCONSISTENT</name>
--<value>255</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_WAIT_TIMEOUT</name>
--<value>258</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_NO_MORE_ITEMS</name>
--<value>259</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_CANNOT_COPY</name>
--<value>266</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_DIRECTORY</name>
--<value>267</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_EAS_DIDNT_FIT</name>
--<value>275</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_EA_FILE_CORRUPT</name>
--<value>276</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_EA_TABLE_FULL</name>
--<value>277</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_INVALID_EA_HANDLE</name>
--<value>278</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_EAS_NOT_SUPPORTED</name>
--<value>282</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_NOT_OWNER</name>
--<value>288</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_TOO_MANY_POSTS</name>
--<value>298</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_PARTIAL_COPY</name>
--<value>299</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_OPLOCK_NOT_GRANTED</name>
--<value>300</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_INVALID_OPLOCK_PROTOCOL</name>
--<value>301</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_DISK_TOO_FRAGMENTED</name>
--<value>302</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_DELETE_PENDING</name>
--<value>303</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_INCOMPATIBLE_WITH_GLOBAL_SHORT_NAME_REGISTRY_SETTING</name>
--<value>304</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_SHORT_NAMES_NOT_ENABLED_ON_VOLUME</name>
--<value>305</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_SECURITY_STREAM_IS_INCONSISTENT</name>
--<value>306</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_INVALID_LOCK_RANGE</name>
--<value>307</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_IMAGE_SUBSYSTEM_NOT_PRESENT</name>
--<value>308</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_NOTIFICATION_GUID_ALREADY_DEFINED</name>
--<value>309</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_MR_MID_NOT_FOUND</name>
--<value>317</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_SCOPE_NOT_FOUND</name>
--<value>318</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_FAIL_NOACTION_REBOOT</name>
--<value>350</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_FAIL_SHUTDOWN</name>
--<value>351</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_FAIL_RESTART</name>
--<value>352</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_MAX_SESSIONS_REACHED</name>
--<value>353</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_THREAD_MODE_ALREADY_BACKGROUND</name>
--<value>400</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_THREAD_MODE_NOT_BACKGROUND</name>
--<value>401</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_PROCESS_MODE_ALREADY_BACKGROUND</name>
--<value>402</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_PROCESS_MODE_NOT_BACKGROUND</name>
--<value>403</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_INVALID_ADDRESS</name>
--<value>487</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_USER_PROFILE_LOAD</name>
--<value>500</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_ARITHMETIC_OVERFLOW</name>
--<value>534</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_PIPE_CONNECTED</name>
--<value>535</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_PIPE_LISTENING</name>
--<value>536</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_VERIFIER_STOP</name>
--<value>537</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_ABIOS_ERROR</name>
--<value>538</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_WX86_WARNING</name>
--<value>539</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_WX86_ERROR</name>
--<value>540</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_TIMER_NOT_CANCELED</name>
--<value>541</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_UNWIND</name>
--<value>542</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_BAD_STACK</name>
--<value>543</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_INVALID_UNWIND_TARGET</name>
--<value>544</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_INVALID_PORT_ATTRIBUTES</name>
--<value>545</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_PORT_MESSAGE_TOO_LONG</name>
--<value>546</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_INVALID_QUOTA_LOWER</name>
--<value>547</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_DEVICE_ALREADY_ATTACHED</name>
--<value>548</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_INSTRUCTION_MISALIGNMENT</name>
--<value>549</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_PROFILING_NOT_STARTED</name>
--<value>550</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_PROFILING_NOT_STOPPED</name>
--<value>551</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_COULD_NOT_INTERPRET</name>
--<value>552</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_PROFILING_AT_LIMIT</name>
--<value>553</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_CANT_WAIT</name>
--<value>554</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_CANT_TERMINATE_SELF</name>
--<value>555</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_UNEXPECTED_MM_CREATE_ERR</name>
--<value>556</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_UNEXPECTED_MM_MAP_ERROR</name>
--<value>557</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_UNEXPECTED_MM_EXTEND_ERR</name>
--<value>558</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_BAD_FUNCTION_TABLE</name>
--<value>559</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_NO_GUID_TRANSLATION</name>
--<value>560</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_INVALID_LDT_SIZE</name>
--<value>561</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_INVALID_LDT_OFFSET</name>
--<value>563</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_INVALID_LDT_DESCRIPTOR</name>
--<value>564</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_TOO_MANY_THREADS</name>
--<value>565</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_THREAD_NOT_IN_PROCESS</name>
--<value>566</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_PAGEFILE_QUOTA_EXCEEDED</name>
--<value>567</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_LOGON_SERVER_CONFLICT</name>
--<value>568</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_SYNCHRONIZATION_REQUIRED</name>
--<value>569</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_NET_OPEN_FAILED</name>
--<value>570</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_IO_PRIVILEGE_FAILED</name>
--<value>571</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_CONTROL_C_EXIT</name>
--<value>572</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_MISSING_SYSTEMFILE</name>
--<value>573</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_UNHANDLED_EXCEPTION</name>
--<value>574</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_APP_INIT_FAILURE</name>
--<value>575</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_PAGEFILE_CREATE_FAILED</name>
--<value>576</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_INVALID_IMAGE_HASH</name>
--<value>577</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_NO_PAGEFILE</name>
--<value>578</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_ILLEGAL_FLOAT_CONTEXT</name>
--<value>579</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_NO_EVENT_PAIR</name>
--<value>580</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_DOMAIN_CTRLR_CONFIG_ERROR</name>
--<value>581</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_ILLEGAL_CHARACTER</name>
--<value>582</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_UNDEFINED_CHARACTER</name>
--<value>583</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_FLOPPY_VOLUME</name>
--<value>584</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_BIOS_FAILED_TO_CONNECT_INTERRUPT</name>
--<value>585</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_BACKUP_CONTROLLER</name>
--<value>586</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_MUTANT_LIMIT_EXCEEDED</name>
--<value>587</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_FS_DRIVER_REQUIRED</name>
--<value>588</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_CANNOT_LOAD_REGISTRY_FILE</name>
--<value>589</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_DEBUG_ATTACH_FAILED</name>
--<value>590</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_SYSTEM_PROCESS_TERMINATED</name>
--<value>591</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_DATA_NOT_ACCEPTED</name>
--<value>592</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_VDM_HARD_ERROR</name>
--<value>593</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_DRIVER_CANCEL_TIMEOUT</name>
--<value>594</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_REPLY_MESSAGE_MISMATCH</name>
--<value>595</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_LOST_WRITEBEHIND_DATA</name>
--<value>596</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_CLIENT_SERVER_PARAMETERS_INVALID</name>
--<value>597</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_NOT_TINY_STREAM</name>
--<value>598</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_STACK_OVERFLOW_READ</name>
--<value>599</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_CONVERT_TO_LARGE</name>
--<value>600</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_FOUND_OUT_OF_SCOPE</name>
--<value>601</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_ALLOCATE_BUCKET</name>
--<value>602</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_MARSHALL_OVERFLOW</name>
--<value>603</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_INVALID_VARIANT</name>
--<value>604</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_BAD_COMPRESSION_BUFFER</name>
--<value>605</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_AUDIT_FAILED</name>
--<value>606</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_TIMER_RESOLUTION_NOT_SET</name>
--<value>607</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_INSUFFICIENT_LOGON_INFO</name>
--<value>608</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_BAD_DLL_ENTRYPOINT</name>
--<value>609</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_BAD_SERVICE_ENTRYPOINT</name>
--<value>610</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_IP_ADDRESS_CONFLICT1</name>
--<value>611</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_IP_ADDRESS_CONFLICT2</name>
--<value>612</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_REGISTRY_QUOTA_LIMIT</name>
--<value>613</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_NO_CALLBACK_ACTIVE</name>
--<value>614</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_PWD_TOO_SHORT</name>
--<value>615</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_PWD_TOO_RECENT</name>
--<value>616</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_PWD_HISTORY_CONFLICT</name>
--<value>617</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_UNSUPPORTED_COMPRESSION</name>
--<value>618</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_INVALID_HW_PROFILE</name>
--<value>619</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_INVALID_PLUGPLAY_DEVICE_PATH</name>
--<value>620</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_QUOTA_LIST_INCONSISTENT</name>
--<value>621</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_EVALUATION_EXPIRATION</name>
--<value>622</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_ILLEGAL_DLL_RELOCATION</name>
--<value>623</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_DLL_INIT_FAILED_LOGOFF</name>
--<value>624</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_VALIDATE_CONTINUE</name>
--<value>625</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_NO_MORE_MATCHES</name>
--<value>626</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_RANGE_LIST_CONFLICT</name>
--<value>627</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_SERVER_SID_MISMATCH</name>
--<value>628</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_CANT_ENABLE_DENY_ONLY</name>
--<value>629</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_FLOAT_MULTIPLE_FAULTS</name>
--<value>630</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_FLOAT_MULTIPLE_TRAPS</name>
--<value>631</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_NOINTERFACE</name>
--<value>632</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_DRIVER_FAILED_SLEEP</name>
--<value>633</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_CORRUPT_SYSTEM_FILE</name>
--<value>634</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_COMMITMENT_MINIMUM</name>
--<value>635</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_PNP_RESTART_ENUMERATION</name>
--<value>636</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_SYSTEM_IMAGE_BAD_SIGNATURE</name>
--<value>637</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_PNP_REBOOT_REQUIRED</name>
--<value>638</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_INSUFFICIENT_POWER</name>
--<value>639</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_MULTIPLE_FAULT_VIOLATION</name>
--<value>640</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_SYSTEM_SHUTDOWN</name>
--<value>641</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_PORT_NOT_SET</name>
--<value>642</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_DS_VERSION_CHECK_FAILURE</name>
--<value>643</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_RANGE_NOT_FOUND</name>
--<value>644</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_NOT_SAFE_MODE_DRIVER</name>
--<value>646</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_FAILED_DRIVER_ENTRY</name>
--<value>647</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_DEVICE_ENUMERATION_ERROR</name>
--<value>648</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_MOUNT_POINT_NOT_RESOLVED</name>
--<value>649</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_INVALID_DEVICE_OBJECT_PARAMETER</name>
--<value>650</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_MCA_OCCURED</name>
--<value>651</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_DRIVER_DATABASE_ERROR</name>
--<value>652</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_SYSTEM_HIVE_TOO_LARGE</name>
--<value>653</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_DRIVER_FAILED_PRIOR_UNLOAD</name>
--<value>654</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_VOLSNAP_PREPARE_HIBERNATE</name>
--<value>655</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_HIBERNATION_FAILURE</name>
--<value>656</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_FILE_SYSTEM_LIMITATION</name>
--<value>665</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_ASSERTION_FAILURE</name>
--<value>668</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_ACPI_ERROR</name>
--<value>669</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_WOW_ASSERTION</name>
--<value>670</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_PNP_BAD_MPS_TABLE</name>
--<value>671</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_PNP_TRANSLATION_FAILED</name>
--<value>672</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_PNP_IRQ_TRANSLATION_FAILED</name>
--<value>673</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_PNP_INVALID_ID</name>
--<value>674</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_WAKE_SYSTEM_DEBUGGER</name>
--<value>675</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_HANDLES_CLOSED</name>
--<value>676</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_EXTRANEOUS_INFORMATION</name>
--<value>677</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_RXACT_COMMIT_NECESSARY</name>
--<value>678</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_MEDIA_CHECK</name>
--<value>679</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_GUID_SUBSTITUTION_MADE</name>
--<value>680</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_STOPPED_ON_SYMLINK</name>
--<value>681</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_LONGJUMP</name>
--<value>682</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_PLUGPLAY_QUERY_VETOED</name>
--<value>683</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_UNWIND_CONSOLIDATE</name>
--<value>684</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_REGISTRY_HIVE_RECOVERED</name>
--<value>685</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_DLL_MIGHT_BE_INSECURE</name>
--<value>686</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_DLL_MIGHT_BE_INCOMPATIBLE</name>
--<value>687</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_DBG_EXCEPTION_NOT_HANDLED</name>
--<value>688</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_DBG_REPLY_LATER</name>
--<value>689</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_DBG_UNABLE_TO_PROVIDE_HANDLE</name>
--<value>690</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_DBG_TERMINATE_THREAD</name>
--<value>691</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_DBG_TERMINATE_PROCESS</name>
--<value>692</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_DBG_CONTROL_C</name>
--<value>693</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_DBG_PRINTEXCEPTION_C</name>
--<value>694</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_DBG_RIPEXCEPTION</name>
--<value>695</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_DBG_CONTROL_BREAK</name>
--<value>696</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_DBG_COMMAND_EXCEPTION</name>
--<value>697</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_OBJECT_NAME_EXISTS</name>
--<value>698</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_THREAD_WAS_SUSPENDED</name>
--<value>699</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_IMAGE_NOT_AT_BASE</name>
--<value>700</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_RXACT_STATE_CREATED</name>
--<value>701</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_SEGMENT_NOTIFICATION</name>
--<value>702</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_BAD_CURRENT_DIRECTORY</name>
--<value>703</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_FT_READ_RECOVERY_FROM_BACKUP</name>
--<value>704</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_FT_WRITE_RECOVERY</name>
--<value>705</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_IMAGE_MACHINE_TYPE_MISMATCH</name>
--<value>706</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_RECEIVE_PARTIAL</name>
--<value>707</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_RECEIVE_EXPEDITED</name>
--<value>708</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_RECEIVE_PARTIAL_EXPEDITED</name>
--<value>709</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_EVENT_DONE</name>
--<value>710</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_EVENT_PENDING</name>
--<value>711</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_CHECKING_FILE_SYSTEM</name>
--<value>712</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_FATAL_APP_EXIT</name>
--<value>713</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_PREDEFINED_HANDLE</name>
--<value>714</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_WAS_UNLOCKED</name>
--<value>715</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_SERVICE_NOTIFICATION</name>
--<value>716</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_WAS_LOCKED</name>
--<value>717</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_LOG_HARD_ERROR</name>
--<value>718</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_ALREADY_WIN32</name>
--<value>719</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_IMAGE_MACHINE_TYPE_MISMATCH_EXE</name>
--<value>720</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_NO_YIELD_PERFORMED</name>
--<value>721</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_TIMER_RESUME_IGNORED</name>
--<value>722</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_ARBITRATION_UNHANDLED</name>
--<value>723</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_CARDBUS_NOT_SUPPORTED</name>
--<value>724</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_MP_PROCESSOR_MISMATCH</name>
--<value>725</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_HIBERNATED</name>
--<value>726</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_RESUME_HIBERNATION</name>
--<value>727</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_FIRMWARE_UPDATED</name>
--<value>728</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_DRIVERS_LEAKING_LOCKED_PAGES</name>
--<value>729</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_WAKE_SYSTEM</name>
--<value>730</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_WAIT_1</name>
--<value>731</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_WAIT_2</name>
--<value>732</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_WAIT_3</name>
--<value>733</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_WAIT_63</name>
--<value>734</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_ABANDONED_WAIT_0</name>
--<value>735</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_ABANDONED_WAIT_63</name>
--<value>736</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_USER_APC</name>
--<value>737</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_KERNEL_APC</name>
--<value>738</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_ALERTED</name>
--<value>739</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_ELEVATION_REQUIRED</name>
--<value>740</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_REPARSE</name>
--<value>741</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_OPLOCK_BREAK_IN_PROGRESS</name>
--<value>742</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_VOLUME_MOUNTED</name>
--<value>743</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_RXACT_COMMITTED</name>
--<value>744</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_NOTIFY_CLEANUP</name>
--<value>745</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_PRIMARY_TRANSPORT_CONNECT_FAILED</name>
--<value>746</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_PAGE_FAULT_TRANSITION</name>
--<value>747</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_PAGE_FAULT_DEMAND_ZERO</name>
--<value>748</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_PAGE_FAULT_COPY_ON_WRITE</name>
--<value>749</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_PAGE_FAULT_GUARD_PAGE</name>
--<value>750</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_PAGE_FAULT_PAGING_FILE</name>
--<value>751</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_CACHE_PAGE_LOCKED</name>
--<value>752</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_CRASH_DUMP</name>
--<value>753</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_BUFFER_ALL_ZEROS</name>
--<value>754</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_REPARSE_OBJECT</name>
--<value>755</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_RESOURCE_REQUIREMENTS_CHANGED</name>
--<value>756</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_TRANSLATION_COMPLETE</name>
--<value>757</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_NOTHING_TO_TERMINATE</name>
--<value>758</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_PROCESS_NOT_IN_JOB</name>
--<value>759</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_PROCESS_IN_JOB</name>
--<value>760</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_VOLSNAP_HIBERNATE_READY</name>
--<value>761</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_FSFILTER_OP_COMPLETED_SUCCESSFULLY</name>
--<value>762</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_INTERRUPT_VECTOR_ALREADY_CONNECTED</name>
--<value>763</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_INTERRUPT_STILL_CONNECTED</name>
--<value>764</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_WAIT_FOR_OPLOCK</name>
--<value>765</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_DBG_EXCEPTION_HANDLED</name>
--<value>766</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_DBG_CONTINUE</name>
--<value>767</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_CALLBACK_POP_STACK</name>
--<value>768</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_COMPRESSION_DISABLED</name>
--<value>769</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_CANTFETCHBACKWARDS</name>
--<value>770</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_CANTSCROLLBACKWARDS</name>
--<value>771</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_ROWSNOTRELEASED</name>
--<value>772</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_BAD_ACCESSOR_FLAGS</name>
--<value>773</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_ERRORS_ENCOUNTERED</name>
--<value>774</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_NOT_CAPABLE</name>
--<value>775</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_REQUEST_OUT_OF_SEQUENCE</name>
--<value>776</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_VERSION_PARSE_ERROR</name>
--<value>777</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_BADSTARTPOSITION</name>
--<value>778</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_MEMORY_HARDWARE</name>
--<value>779</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_DISK_REPAIR_DISABLED</name>
--<value>780</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_INSUFFICIENT_RESOURCE_FOR_SPECIFIED_SHARED_SECTION_SIZE</name>
--<value>781</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_SYSTEM_POWERSTATE_TRANSITION</name>
--<value>782</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_SYSTEM_POWERSTATE_COMPLEX_TRANSITION</name>
--<value>783</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_MCA_EXCEPTION</name>
--<value>784</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_ACCESS_AUDIT_BY_POLICY</name>
--<value>785</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_ACCESS_DISABLED_NO_SAFER_UI_BY_POLICY</name>
--<value>786</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_ABANDON_HIBERFILE</name>
--<value>787</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_LOST_WRITEBEHIND_DATA_NETWORK_DISCONNECTED</name>
--<value>788</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_LOST_WRITEBEHIND_DATA_NETWORK_SERVER_ERROR</name>
--<value>789</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_LOST_WRITEBEHIND_DATA_LOCAL_DISK_ERROR</name>
--<value>790</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_BAD_MCFG_TABLE</name>
--<value>791</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_OPLOCK_SWITCHED_TO_NEW_HANDLE</name>
--<value>800</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_CANNOT_GRANT_REQUESTED_OPLOCK</name>
--<value>801</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_CANNOT_BREAK_OPLOCK</name>
--<value>802</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_OPLOCK_HANDLE_CLOSED</name>
--<value>803</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_NO_ACE_CONDITION</name>
--<value>804</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_INVALID_ACE_CONDITION</name>
--<value>805</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_EA_ACCESS_DENIED</name>
--<value>994</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_OPERATION_ABORTED</name>
--<value>995</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_IO_INCOMPLETE</name>
--<value>996</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_IO_PENDING</name>
--<value>997</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_NOACCESS</name>
--<value>998</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_SWAPERROR</name>
--<value>999</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_STACK_OVERFLOW</name>
--<value>1001</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_INVALID_MESSAGE</name>
--<value>1002</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_CAN_NOT_COMPLETE</name>
--<value>1003</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_INVALID_FLAGS</name>
--<value>1004</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_UNRECOGNIZED_VOLUME</name>
--<value>1005</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_FILE_INVALID</name>
--<value>1006</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_FULLSCREEN_MODE</name>
--<value>1007</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_NO_TOKEN</name>
--<value>1008</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_BADDB</name>
--<value>1009</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_BADKEY</name>
--<value>1010</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_CANTOPEN</name>
--<value>1011</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_CANTREAD</name>
--<value>1012</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_CANTWRITE</name>
--<value>1013</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_REGISTRY_RECOVERED</name>
--<value>1014</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_REGISTRY_CORRUPT</name>
--<value>1015</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_REGISTRY_IO_FAILED</name>
--<value>1016</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_NOT_REGISTRY_FILE</name>
--<value>1017</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_KEY_DELETED</name>
--<value>1018</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_NO_LOG_SPACE</name>
--<value>1019</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_KEY_HAS_CHILDREN</name>
--<value>1020</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_CHILD_MUST_BE_VOLATILE</name>
--<value>1021</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_NOTIFY_ENUM_DIR</name>
--<value>1022</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_DEPENDENT_SERVICES_RUNNING</name>
--<value>1051</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_INVALID_SERVICE_CONTROL</name>
--<value>1052</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_SERVICE_REQUEST_TIMEOUT</name>
--<value>1053</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_SERVICE_NO_THREAD</name>
--<value>1054</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_SERVICE_DATABASE_LOCKED</name>
--<value>1055</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_SERVICE_ALREADY_RUNNING</name>
--<value>1056</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_INVALID_SERVICE_ACCOUNT</name>
--<value>1057</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_SERVICE_DISABLED</name>
--<value>1058</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_CIRCULAR_DEPENDENCY</name>
--<value>1059</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_SERVICE_DOES_NOT_EXIST</name>
--<value>1060</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_SERVICE_CANNOT_ACCEPT_CTRL</name>
--<value>1061</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_SERVICE_NOT_ACTIVE</name>
--<value>1062</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_FAILED_SERVICE_CONTROLLER_CONNECT</name>
--<value>1063</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_EXCEPTION_IN_SERVICE</name>
--<value>1064</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_DATABASE_DOES_NOT_EXIST</name>
--<value>1065</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_SERVICE_SPECIFIC_ERROR</name>
--<value>1066</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_PROCESS_ABORTED</name>
--<value>1067</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_SERVICE_DEPENDENCY_FAIL</name>
--<value>1068</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_SERVICE_LOGON_FAILED</name>
--<value>1069</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_SERVICE_START_HANG</name>
--<value>1070</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_INVALID_SERVICE_LOCK</name>
--<value>1071</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_SERVICE_MARKED_FOR_DELETE</name>
--<value>1072</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_SERVICE_EXISTS</name>
--<value>1073</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_ALREADY_RUNNING_LKG</name>
--<value>1074</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_SERVICE_DEPENDENCY_DELETED</name>
--<value>1075</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_BOOT_ALREADY_ACCEPTED</name>
--<value>1076</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_SERVICE_NEVER_STARTED</name>
--<value>1077</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_DUPLICATE_SERVICE_NAME</name>
--<value>1078</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_DIFFERENT_SERVICE_ACCOUNT</name>
--<value>1079</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_CANNOT_DETECT_DRIVER_FAILURE</name>
--<value>1080</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_CANNOT_DETECT_PROCESS_ABORT</name>
--<value>1081</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_NO_RECOVERY_PROGRAM</name>
--<value>1082</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_SERVICE_NOT_IN_EXE</name>
--<value>1083</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_NOT_SAFEBOOT_SERVICE</name>
--<value>1084</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_END_OF_MEDIA</name>
--<value>1100</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_FILEMARK_DETECTED</name>
--<value>1101</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_BEGINNING_OF_MEDIA</name>
--<value>1102</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_SETMARK_DETECTED</name>
--<value>1103</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_NO_DATA_DETECTED</name>
--<value>1104</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_PARTITION_FAILURE</name>
--<value>1105</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_INVALID_BLOCK_LENGTH</name>
--<value>1106</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_DEVICE_NOT_PARTITIONED</name>
--<value>1107</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_UNABLE_TO_LOCK_MEDIA</name>
--<value>1108</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_UNABLE_TO_UNLOAD_MEDIA</name>
--<value>1109</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_MEDIA_CHANGED</name>
--<value>1110</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_BUS_RESET</name>
--<value>1111</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_NO_MEDIA_IN_DRIVE</name>
--<value>1112</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_NO_UNICODE_TRANSLATION</name>
--<value>1113</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_DLL_INIT_FAILED</name>
--<value>1114</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_SHUTDOWN_IN_PROGRESS</name>
--<value>1115</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_NO_SHUTDOWN_IN_PROGRESS</name>
--<value>1116</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_IO_DEVICE</name>
--<value>1117</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_SERIAL_NO_DEVICE</name>
--<value>1118</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_IRQ_BUSY</name>
--<value>1119</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_MORE_WRITES</name>
--<value>1120</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_COUNTER_TIMEOUT</name>
--<value>1121</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_FLOPPY_ID_MARK_NOT_FOUND</name>
--<value>1122</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_FLOPPY_WRONG_CYLINDER</name>
--<value>1123</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_FLOPPY_UNKNOWN_ERROR</name>
--<value>1124</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_FLOPPY_BAD_REGISTERS</name>
--<value>1125</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_DISK_RECALIBRATE_FAILED</name>
--<value>1126</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_DISK_OPERATION_FAILED</name>
--<value>1127</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_DISK_RESET_FAILED</name>
--<value>1128</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_EOM_OVERFLOW</name>
--<value>1129</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_NOT_ENOUGH_SERVER_MEMORY</name>
--<value>1130</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_POSSIBLE_DEADLOCK</name>
--<value>1131</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_MAPPED_ALIGNMENT</name>
--<value>1132</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_SET_POWER_STATE_VETOED</name>
--<value>1140</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_SET_POWER_STATE_FAILED</name>
--<value>1141</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_TOO_MANY_LINKS</name>
--<value>1142</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_OLD_WIN_VERSION</name>
--<value>1150</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_APP_WRONG_OS</name>
--<value>1151</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_SINGLE_INSTANCE_APP</name>
--<value>1152</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_RMODE_APP</name>
--<value>1153</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_INVALID_DLL</name>
--<value>1154</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_NO_ASSOCIATION</name>
--<value>1155</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_DDE_FAIL</name>
--<value>1156</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_DLL_NOT_FOUND</name>
--<value>1157</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_NO_MORE_USER_HANDLES</name>
--<value>1158</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_MESSAGE_SYNC_ONLY</name>
--<value>1159</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_SOURCE_ELEMENT_EMPTY</name>
--<value>1160</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_DESTINATION_ELEMENT_FULL</name>
--<value>1161</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_ILLEGAL_ELEMENT_ADDRESS</name>
--<value>1162</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_MAGAZINE_NOT_PRESENT</name>
--<value>1163</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_DEVICE_REINITIALIZATION_NEEDED</name>
--<value>1164</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_DEVICE_REQUIRES_CLEANING</name>
--<value>1165</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_DEVICE_DOOR_OPEN</name>
--<value>1166</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_DEVICE_NOT_CONNECTED</name>
--<value>1167</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_NOT_FOUND</name>
--<value>1168</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_NO_MATCH</name>
--<value>1169</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_SET_NOT_FOUND</name>
--<value>1170</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_POINT_NOT_FOUND</name>
--<value>1171</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_NO_TRACKING_SERVICE</name>
--<value>1172</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_NO_VOLUME_ID</name>
--<value>1173</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_UNABLE_TO_REMOVE_REPLACED</name>
--<value>1175</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_UNABLE_TO_MOVE_REPLACEMENT</name>
--<value>1176</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_UNABLE_TO_MOVE_REPLACEMENT_2</name>
--<value>1177</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_JOURNAL_DELETE_IN_PROGRESS</name>
--<value>1178</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_JOURNAL_NOT_ACTIVE</name>
--<value>1179</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_POTENTIAL_FILE_FOUND</name>
--<value>1180</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_JOURNAL_ENTRY_DELETED</name>
--<value>1181</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_SHUTDOWN_IS_SCHEDULED</name>
--<value>1190</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_SHUTDOWN_USERS_LOGGED_ON</name>
--<value>1191</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_BAD_DEVICE</name>
--<value>1200</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_CONNECTION_UNAVAIL</name>
--<value>1201</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_DEVICE_ALREADY_REMEMBERED</name>
--<value>1202</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_NO_NET_OR_BAD_PATH</name>
--<value>1203</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_BAD_PROVIDER</name>
--<value>1204</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_CANNOT_OPEN_PROFILE</name>
--<value>1205</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_BAD_PROFILE</name>
--<value>1206</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_NOT_CONTAINER</name>
--<value>1207</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_EXTENDED_ERROR</name>
--<value>1208</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_INVALID_GROUPNAME</name>
--<value>1209</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_INVALID_COMPUTERNAME</name>
--<value>1210</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_INVALID_EVENTNAME</name>
--<value>1211</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_INVALID_DOMAINNAME</name>
--<value>1212</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_INVALID_SERVICENAME</name>
--<value>1213</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_INVALID_NETNAME</name>
--<value>1214</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_INVALID_SHARENAME</name>
--<value>1215</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_INVALID_PASSWORDNAME</name>
--<value>1216</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_INVALID_MESSAGENAME</name>
--<value>1217</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_INVALID_MESSAGEDEST</name>
--<value>1218</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_SESSION_CREDENTIAL_CONFLICT</name>
--<value>1219</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_REMOTE_SESSION_LIMIT_EXCEEDED</name>
--<value>1220</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_DUP_DOMAINNAME</name>
--<value>1221</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_NO_NETWORK</name>
--<value>1222</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_CANCELLED</name>
--<value>1223</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_USER_MAPPED_FILE</name>
--<value>1224</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_CONNECTION_REFUSED</name>
--<value>1225</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_GRACEFUL_DISCONNECT</name>
--<value>1226</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_ADDRESS_ALREADY_ASSOCIATED</name>
--<value>1227</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_ADDRESS_NOT_ASSOCIATED</name>
--<value>1228</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_CONNECTION_INVALID</name>
--<value>1229</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_CONNECTION_ACTIVE</name>
--<value>1230</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_NETWORK_UNREACHABLE</name>
--<value>1231</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_HOST_UNREACHABLE</name>
--<value>1232</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_PROTOCOL_UNREACHABLE</name>
--<value>1233</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_PORT_UNREACHABLE</name>
--<value>1234</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_REQUEST_ABORTED</name>
--<value>1235</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_CONNECTION_ABORTED</name>
--<value>1236</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_RETRY</name>
--<value>1237</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_CONNECTION_COUNT_LIMIT</name>
--<value>1238</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_LOGIN_TIME_RESTRICTION</name>
--<value>1239</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_LOGIN_WKSTA_RESTRICTION</name>
--<value>1240</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_INCORRECT_ADDRESS</name>
--<value>1241</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_ALREADY_REGISTERED</name>
--<value>1242</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_SERVICE_NOT_FOUND</name>
--<value>1243</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_NOT_AUTHENTICATED</name>
--<value>1244</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_NOT_LOGGED_ON</name>
--<value>1245</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_CONTINUE</name>
--<value>1246</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_ALREADY_INITIALIZED</name>
--<value>1247</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_NO_MORE_DEVICES</name>
--<value>1248</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_NO_SUCH_SITE</name>
--<value>1249</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_DOMAIN_CONTROLLER_EXISTS</name>
--<value>1250</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_ONLY_IF_CONNECTED</name>
--<value>1251</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_OVERRIDE_NOCHANGES</name>
--<value>1252</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_BAD_USER_PROFILE</name>
--<value>1253</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_NOT_SUPPORTED_ON_SBS</name>
--<value>1254</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_SERVER_SHUTDOWN_IN_PROGRESS</name>
--<value>1255</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_HOST_DOWN</name>
--<value>1256</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_NON_ACCOUNT_SID</name>
--<value>1257</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_NON_DOMAIN_SID</name>
--<value>1258</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_APPHELP_BLOCK</name>
--<value>1259</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_ACCESS_DISABLED_BY_POLICY</name>
--<value>1260</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_REG_NAT_CONSUMPTION</name>
--<value>1261</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_CSCSHARE_OFFLINE</name>
--<value>1262</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_PKINIT_FAILURE</name>
--<value>1263</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_SMARTCARD_SUBSYSTEM_FAILURE</name>
--<value>1264</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_DOWNGRADE_DETECTED</name>
--<value>1265</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_MACHINE_LOCKED</name>
--<value>1271</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_CALLBACK_SUPPLIED_INVALID_DATA</name>
--<value>1273</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_SYNC_FOREGROUND_REFRESH_REQUIRED</name>
--<value>1274</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_DRIVER_BLOCKED</name>
--<value>1275</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_INVALID_IMPORT_OF_NON_DLL</name>
--<value>1276</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_ACCESS_DISABLED_WEBBLADE</name>
--<value>1277</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_ACCESS_DISABLED_WEBBLADE_TAMPER</name>
--<value>1278</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_RECOVERY_FAILURE</name>
--<value>1279</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_ALREADY_FIBER</name>
--<value>1280</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_ALREADY_THREAD</name>
--<value>1281</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_STACK_BUFFER_OVERRUN</name>
--<value>1282</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_PARAMETER_QUOTA_EXCEEDED</name>
--<value>1283</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_DEBUGGER_INACTIVE</name>
--<value>1284</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_DELAY_LOAD_FAILED</name>
--<value>1285</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_VDM_DISALLOWED</name>
--<value>1286</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_UNIDENTIFIED_ERROR</name>
--<value>1287</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_INVALID_CRUNTIME_PARAMETER</name>
--<value>1288</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_BEYOND_VDL</name>
--<value>1289</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_INCOMPATIBLE_SERVICE_SID_TYPE</name>
--<value>1290</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_DRIVER_PROCESS_TERMINATED</name>
--<value>1291</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_IMPLEMENTATION_LIMIT</name>
--<value>1292</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_PROCESS_IS_PROTECTED</name>
--<value>1293</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_SERVICE_NOTIFY_CLIENT_LAGGING</name>
--<value>1294</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_DISK_QUOTA_EXCEEDED</name>
--<value>1295</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_CONTENT_BLOCKED</name>
--<value>1296</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_INCOMPATIBLE_SERVICE_PRIVILEGE</name>
--<value>1297</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_INVALID_LABEL</name>
--<value>1299</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_NOT_ALL_ASSIGNED</name>
--<value>1300</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_SOME_NOT_MAPPED</name>
--<value>1301</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_NO_QUOTAS_FOR_ACCOUNT</name>
--<value>1302</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_LOCAL_USER_SESSION_KEY</name>
--<value>1303</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_NULL_LM_PASSWORD</name>
--<value>1304</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_UNKNOWN_REVISION</name>
--<value>1305</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_REVISION_MISMATCH</name>
--<value>1306</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_INVALID_OWNER</name>
--<value>1307</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_INVALID_PRIMARY_GROUP</name>
--<value>1308</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_NO_IMPERSONATION_TOKEN</name>
--<value>1309</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_CANT_DISABLE_MANDATORY</name>
--<value>1310</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_NO_LOGON_SERVERS</name>
--<value>1311</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_NO_SUCH_LOGON_SESSION</name>
--<value>1312</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_NO_SUCH_PRIVILEGE</name>
--<value>1313</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_PRIVILEGE_NOT_HELD</name>
--<value>1314</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_INVALID_ACCOUNT_NAME</name>
--<value>1315</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_USER_EXISTS</name>
--<value>1316</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_NO_SUCH_USER</name>
--<value>1317</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_GROUP_EXISTS</name>
--<value>1318</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_NO_SUCH_GROUP</name>
--<value>1319</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_MEMBER_IN_GROUP</name>
--<value>1320</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_MEMBER_NOT_IN_GROUP</name>
--<value>1321</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_LAST_ADMIN</name>
--<value>1322</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_WRONG_PASSWORD</name>
--<value>1323</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_ILL_FORMED_PASSWORD</name>
--<value>1324</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_PASSWORD_RESTRICTION</name>
--<value>1325</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_LOGON_FAILURE</name>
--<value>1326</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_ACCOUNT_RESTRICTION</name>
--<value>1327</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_INVALID_LOGON_HOURS</name>
--<value>1328</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_INVALID_WORKSTATION</name>
--<value>1329</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_PASSWORD_EXPIRED</name>
--<value>1330</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_ACCOUNT_DISABLED</name>
--<value>1331</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_NONE_MAPPED</name>
--<value>1332</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_TOO_MANY_LUIDS_REQUESTED</name>
--<value>1333</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_LUIDS_EXHAUSTED</name>
--<value>1334</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_INVALID_SUB_AUTHORITY</name>
--<value>1335</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_INVALID_ACL</name>
--<value>1336</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_INVALID_SID</name>
--<value>1337</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_INVALID_SECURITY_DESCR</name>
--<value>1338</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_BAD_INHERITANCE_ACL</name>
--<value>1340</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_SERVER_DISABLED</name>
--<value>1341</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_SERVER_NOT_DISABLED</name>
--<value>1342</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_INVALID_ID_AUTHORITY</name>
--<value>1343</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_ALLOTTED_SPACE_EXCEEDED</name>
--<value>1344</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_INVALID_GROUP_ATTRIBUTES</name>
--<value>1345</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_BAD_IMPERSONATION_LEVEL</name>
--<value>1346</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_CANT_OPEN_ANONYMOUS</name>
--<value>1347</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_BAD_VALIDATION_CLASS</name>
--<value>1348</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_BAD_TOKEN_TYPE</name>
--<value>1349</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_NO_SECURITY_ON_OBJECT</name>
--<value>1350</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_CANT_ACCESS_DOMAIN_INFO</name>
--<value>1351</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_INVALID_SERVER_STATE</name>
--<value>1352</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_INVALID_DOMAIN_STATE</name>
--<value>1353</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_INVALID_DOMAIN_ROLE</name>
--<value>1354</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_NO_SUCH_DOMAIN</name>
--<value>1355</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_DOMAIN_EXISTS</name>
--<value>1356</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_DOMAIN_LIMIT_EXCEEDED</name>
--<value>1357</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_INTERNAL_DB_CORRUPTION</name>
--<value>1358</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_INTERNAL_ERROR</name>
--<value>1359</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_GENERIC_NOT_MAPPED</name>
--<value>1360</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_BAD_DESCRIPTOR_FORMAT</name>
--<value>1361</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_NOT_LOGON_PROCESS</name>
--<value>1362</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_LOGON_SESSION_EXISTS</name>
--<value>1363</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_NO_SUCH_PACKAGE</name>
--<value>1364</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_BAD_LOGON_SESSION_STATE</name>
--<value>1365</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_LOGON_SESSION_COLLISION</name>
--<value>1366</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_INVALID_LOGON_TYPE</name>
--<value>1367</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_CANNOT_IMPERSONATE</name>
--<value>1368</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_RXACT_INVALID_STATE</name>
--<value>1369</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_RXACT_COMMIT_FAILURE</name>
--<value>1370</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_SPECIAL_ACCOUNT</name>
--<value>1371</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_SPECIAL_GROUP</name>
--<value>1372</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_SPECIAL_USER</name>
--<value>1373</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_MEMBERS_PRIMARY_GROUP</name>
--<value>1374</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_TOKEN_ALREADY_IN_USE</name>
--<value>1375</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_NO_SUCH_ALIAS</name>
--<value>1376</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_MEMBER_NOT_IN_ALIAS</name>
--<value>1377</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_MEMBER_IN_ALIAS</name>
--<value>1378</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_ALIAS_EXISTS</name>
--<value>1379</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_LOGON_NOT_GRANTED</name>
--<value>1380</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_TOO_MANY_SECRETS</name>
--<value>1381</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_SECRET_TOO_LONG</name>
--<value>1382</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_INTERNAL_DB_ERROR</name>
--<value>1383</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_TOO_MANY_CONTEXT_IDS</name>
--<value>1384</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_LOGON_TYPE_NOT_GRANTED</name>
--<value>1385</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_NT_CROSS_ENCRYPTION_REQUIRED</name>
--<value>1386</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_NO_SUCH_MEMBER</name>
--<value>1387</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_INVALID_MEMBER</name>
--<value>1388</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_TOO_MANY_SIDS</name>
--<value>1389</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_LM_CROSS_ENCRYPTION_REQUIRED</name>
--<value>1390</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_NO_INHERITANCE</name>
--<value>1391</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_FILE_CORRUPT</name>
--<value>1392</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_DISK_CORRUPT</name>
--<value>1393</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_NO_USER_SESSION_KEY</name>
--<value>1394</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_LICENSE_QUOTA_EXCEEDED</name>
--<value>1395</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_WRONG_TARGET_NAME</name>
--<value>1396</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_MUTUAL_AUTH_FAILED</name>
--<value>1397</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_TIME_SKEW</name>
--<value>1398</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_CURRENT_DOMAIN_NOT_ALLOWED</name>
--<value>1399</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_INVALID_WINDOW_HANDLE</name>
--<value>1400</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_INVALID_MENU_HANDLE</name>
--<value>1401</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_INVALID_CURSOR_HANDLE</name>
--<value>1402</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_INVALID_ACCEL_HANDLE</name>
--<value>1403</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_INVALID_HOOK_HANDLE</name>
--<value>1404</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_INVALID_DWP_HANDLE</name>
--<value>1405</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_TLW_WITH_WSCHILD</name>
--<value>1406</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_CANNOT_FIND_WND_CLASS</name>
--<value>1407</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_WINDOW_OF_OTHER_THREAD</name>
--<value>1408</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_HOTKEY_ALREADY_REGISTERED</name>
--<value>1409</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_CLASS_ALREADY_EXISTS</name>
--<value>1410</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_CLASS_DOES_NOT_EXIST</name>
--<value>1411</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_CLASS_HAS_WINDOWS</name>
--<value>1412</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_INVALID_INDEX</name>
--<value>1413</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_INVALID_ICON_HANDLE</name>
--<value>1414</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_PRIVATE_DIALOG_INDEX</name>
--<value>1415</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_LISTBOX_ID_NOT_FOUND</name>
--<value>1416</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_NO_WILDCARD_CHARACTERS</name>
--<value>1417</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_CLIPBOARD_NOT_OPEN</name>
--<value>1418</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_HOTKEY_NOT_REGISTERED</name>
--<value>1419</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_WINDOW_NOT_DIALOG</name>
--<value>1420</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_CONTROL_ID_NOT_FOUND</name>
--<value>1421</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_INVALID_COMBOBOX_MESSAGE</name>
--<value>1422</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_WINDOW_NOT_COMBOBOX</name>
--<value>1423</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_INVALID_EDIT_HEIGHT</name>
--<value>1424</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_DC_NOT_FOUND</name>
--<value>1425</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_INVALID_HOOK_FILTER</name>
--<value>1426</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_INVALID_FILTER_PROC</name>
--<value>1427</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_HOOK_NEEDS_HMOD</name>
--<value>1428</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_GLOBAL_ONLY_HOOK</name>
--<value>1429</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_JOURNAL_HOOK_SET</name>
--<value>1430</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_HOOK_NOT_INSTALLED</name>
--<value>1431</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_INVALID_LB_MESSAGE</name>
--<value>1432</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_SETCOUNT_ON_BAD_LB</name>
--<value>1433</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_LB_WITHOUT_TABSTOPS</name>
--<value>1434</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_DESTROY_OBJECT_OF_OTHER_THREAD</name>
--<value>1435</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_CHILD_WINDOW_MENU</name>
--<value>1436</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_NO_SYSTEM_MENU</name>
--<value>1437</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_INVALID_MSGBOX_STYLE</name>
--<value>1438</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_INVALID_SPI_VALUE</name>
--<value>1439</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_SCREEN_ALREADY_LOCKED</name>
--<value>1440</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_HWNDS_HAVE_DIFF_PARENT</name>
--<value>1441</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_NOT_CHILD_WINDOW</name>
--<value>1442</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_INVALID_GW_COMMAND</name>
--<value>1443</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_INVALID_THREAD_ID</name>
--<value>1444</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_NON_MDICHILD_WINDOW</name>
--<value>1445</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_POPUP_ALREADY_ACTIVE</name>
--<value>1446</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_NO_SCROLLBARS</name>
--<value>1447</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_INVALID_SCROLLBAR_RANGE</name>
--<value>1448</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_INVALID_SHOWWIN_COMMAND</name>
--<value>1449</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_NO_SYSTEM_RESOURCES</name>
--<value>1450</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_NONPAGED_SYSTEM_RESOURCES</name>
--<value>1451</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_PAGED_SYSTEM_RESOURCES</name>
--<value>1452</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_WORKING_SET_QUOTA</name>
--<value>1453</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_PAGEFILE_QUOTA</name>
--<value>1454</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_COMMITMENT_LIMIT</name>
--<value>1455</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_MENU_ITEM_NOT_FOUND</name>
--<value>1456</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_INVALID_KEYBOARD_HANDLE</name>
--<value>1457</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_HOOK_TYPE_NOT_ALLOWED</name>
--<value>1458</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_REQUIRES_INTERACTIVE_WINDOWSTATION</name>
--<value>1459</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_TIMEOUT</name>
--<value>1460</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_INVALID_MONITOR_HANDLE</name>
--<value>1461</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_INCORRECT_SIZE</name>
--<value>1462</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_SYMLINK_CLASS_DISABLED</name>
--<value>1463</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_SYMLINK_NOT_SUPPORTED</name>
--<value>1464</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_XML_PARSE_ERROR</name>
--<value>1465</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_XMLDSIG_ERROR</name>
--<value>1466</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_RESTART_APPLICATION</name>
--<value>1467</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_WRONG_COMPARTMENT</name>
--<value>1468</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_AUTHIP_FAILURE</name>
--<value>1469</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_NO_NVRAM_RESOURCES</name>
--<value>1470</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_EVENTLOG_FILE_CORRUPT</name>
--<value>1500</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_EVENTLOG_CANT_START</name>
--<value>1501</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_LOG_FILE_FULL</name>
--<value>1502</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_EVENTLOG_FILE_CHANGED</name>
--<value>1503</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_INVALID_TASK_NAME</name>
--<value>1550</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_INVALID_TASK_INDEX</name>
--<value>1551</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_THREAD_ALREADY_IN_TASK</name>
--<value>1552</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_INSTALL_SERVICE_FAILURE</name>
--<value>1601</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_INSTALL_USEREXIT</name>
--<value>1602</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_INSTALL_FAILURE</name>
--<value>1603</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_INSTALL_SUSPEND</name>
--<value>1604</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_UNKNOWN_PRODUCT</name>
--<value>1605</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_UNKNOWN_FEATURE</name>
--<value>1606</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_UNKNOWN_COMPONENT</name>
--<value>1607</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_UNKNOWN_PROPERTY</name>
--<value>1608</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_INVALID_HANDLE_STATE</name>
--<value>1609</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_BAD_CONFIGURATION</name>
--<value>1610</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_INDEX_ABSENT</name>
--<value>1611</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_INSTALL_SOURCE_ABSENT</name>
--<value>1612</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_INSTALL_PACKAGE_VERSION</name>
--<value>1613</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_PRODUCT_UNINSTALLED</name>
--<value>1614</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_BAD_QUERY_SYNTAX</name>
--<value>1615</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_INVALID_FIELD</name>
--<value>1616</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_DEVICE_REMOVED</name>
--<value>1617</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_INSTALL_ALREADY_RUNNING</name>
--<value>1618</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_INSTALL_PACKAGE_OPEN_FAILED</name>
--<value>1619</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_INSTALL_PACKAGE_INVALID</name>
--<value>1620</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_INSTALL_UI_FAILURE</name>
--<value>1621</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_INSTALL_LOG_FAILURE</name>
--<value>1622</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_INSTALL_LANGUAGE_UNSUPPORTED</name>
--<value>1623</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_INSTALL_TRANSFORM_FAILURE</name>
--<value>1624</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_INSTALL_PACKAGE_REJECTED</name>
--<value>1625</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_FUNCTION_NOT_CALLED</name>
--<value>1626</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_FUNCTION_FAILED</name>
--<value>1627</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_INVALID_TABLE</name>
--<value>1628</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_DATATYPE_MISMATCH</name>
--<value>1629</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_UNSUPPORTED_TYPE</name>
--<value>1630</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_CREATE_FAILED</name>
--<value>1631</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_INSTALL_TEMP_UNWRITABLE</name>
--<value>1632</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_INSTALL_PLATFORM_UNSUPPORTED</name>
--<value>1633</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_INSTALL_NOTUSED</name>
--<value>1634</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_PATCH_PACKAGE_OPEN_FAILED</name>
--<value>1635</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_PATCH_PACKAGE_INVALID</name>
--<value>1636</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_PATCH_PACKAGE_UNSUPPORTED</name>
--<value>1637</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_PRODUCT_VERSION</name>
--<value>1638</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_INVALID_COMMAND_LINE</name>
--<value>1639</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_INSTALL_REMOTE_DISALLOWED</name>
--<value>1640</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_SUCCESS_REBOOT_INITIATED</name>
--<value>1641</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_PATCH_TARGET_NOT_FOUND</name>
--<value>1642</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_PATCH_PACKAGE_REJECTED</name>
--<value>1643</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_INSTALL_TRANSFORM_REJECTED</name>
--<value>1644</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_INSTALL_REMOTE_PROHIBITED</name>
--<value>1645</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_PATCH_REMOVAL_UNSUPPORTED</name>
--<value>1646</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_UNKNOWN_PATCH</name>
--<value>1647</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_PATCH_NO_SEQUENCE</name>
--<value>1648</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_PATCH_REMOVAL_DISALLOWED</name>
--<value>1649</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_INVALID_PATCH_XML</name>
--<value>1650</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_PATCH_MANAGED_ADVERTISED_PRODUCT</name>
--<value>1651</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_INSTALL_SERVICE_SAFEBOOT</name>
--<value>1652</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_FAIL_FAST_EXCEPTION</name>
--<value>1653</value>
--<desc></desc>
--</constant>
--<constant>
--<name>RPC_S_INVALID_STRING_BINDING</name>
--<value>1700</value>
--<desc></desc>
--</constant>
--<constant>
--<name>RPC_S_WRONG_KIND_OF_BINDING</name>
--<value>1701</value>
--<desc></desc>
--</constant>
--<constant>
--<name>RPC_S_INVALID_BINDING</name>
--<value>1702</value>
--<desc></desc>
--</constant>
--<constant>
--<name>RPC_S_PROTSEQ_NOT_SUPPORTED</name>
--<value>1703</value>
--<desc></desc>
--</constant>
--<constant>
--<name>RPC_S_INVALID_RPC_PROTSEQ</name>
--<value>1704</value>
--<desc></desc>
--</constant>
--<constant>
--<name>RPC_S_INVALID_STRING_UUID</name>
--<value>1705</value>
--<desc></desc>
--</constant>
--<constant>
--<name>RPC_S_INVALID_ENDPOINT_FORMAT</name>
--<value>1706</value>
--<desc></desc>
--</constant>
--<constant>
--<name>RPC_S_INVALID_NET_ADDR</name>
--<value>1707</value>
--<desc></desc>
--</constant>
--<constant>
--<name>RPC_S_NO_ENDPOINT_FOUND</name>
--<value>1708</value>
--<desc></desc>
--</constant>
--<constant>
--<name>RPC_S_INVALID_TIMEOUT</name>
--<value>1709</value>
--<desc></desc>
--</constant>
--<constant>
--<name>RPC_S_OBJECT_NOT_FOUND</name>
--<value>1710</value>
--<desc></desc>
--</constant>
--<constant>
--<name>RPC_S_ALREADY_REGISTERED</name>
--<value>1711</value>
--<desc></desc>
--</constant>
--<constant>
--<name>RPC_S_TYPE_ALREADY_REGISTERED</name>
--<value>1712</value>
--<desc></desc>
--</constant>
--<constant>
--<name>RPC_S_ALREADY_LISTENING</name>
--<value>1713</value>
--<desc></desc>
--</constant>
--<constant>
--<name>RPC_S_NO_PROTSEQS_REGISTERED</name>
--<value>1714</value>
--<desc></desc>
--</constant>
--<constant>
--<name>RPC_S_NOT_LISTENING</name>
--<value>1715</value>
--<desc></desc>
--</constant>
--<constant>
--<name>RPC_S_UNKNOWN_MGR_TYPE</name>
--<value>1716</value>
--<desc></desc>
--</constant>
--<constant>
--<name>RPC_S_UNKNOWN_IF</name>
--<value>1717</value>
--<desc></desc>
--</constant>
--<constant>
--<name>RPC_S_NO_BINDINGS</name>
--<value>1718</value>
--<desc></desc>
--</constant>
--<constant>
--<name>RPC_S_NO_PROTSEQS</name>
--<value>1719</value>
--<desc></desc>
--</constant>
--<constant>
--<name>RPC_S_CANT_CREATE_ENDPOINT</name>
--<value>1720</value>
--<desc></desc>
--</constant>
--<constant>
--<name>RPC_S_OUT_OF_RESOURCES</name>
--<value>1721</value>
--<desc></desc>
--</constant>
--<constant>
--<name>RPC_S_SERVER_UNAVAILABLE</name>
--<value>1722</value>
--<desc></desc>
--</constant>
--<constant>
--<name>RPC_S_SERVER_TOO_BUSY</name>
--<value>1723</value>
--<desc></desc>
--</constant>
--<constant>
--<name>RPC_S_INVALID_NETWORK_OPTIONS</name>
--<value>1724</value>
--<desc></desc>
--</constant>
--<constant>
--<name>RPC_S_NO_CALL_ACTIVE</name>
--<value>1725</value>
--<desc></desc>
--</constant>
--<constant>
--<name>RPC_S_CALL_FAILED</name>
--<value>1726</value>
--<desc></desc>
--</constant>
--<constant>
--<name>RPC_S_CALL_FAILED_DNE</name>
--<value>1727</value>
--<desc></desc>
--</constant>
--<constant>
--<name>RPC_S_PROTOCOL_ERROR</name>
--<value>1728</value>
--<desc></desc>
--</constant>
--<constant>
--<name>RPC_S_PROXY_ACCESS_DENIED</name>
--<value>1729</value>
--<desc></desc>
--</constant>
--<constant>
--<name>RPC_S_UNSUPPORTED_TRANS_SYN</name>
--<value>1730</value>
--<desc></desc>
--</constant>
--<constant>
--<name>RPC_S_UNSUPPORTED_TYPE</name>
--<value>1732</value>
--<desc></desc>
--</constant>
--<constant>
--<name>RPC_S_INVALID_TAG</name>
--<value>1733</value>
--<desc></desc>
--</constant>
--<constant>
--<name>RPC_S_INVALID_BOUND</name>
--<value>1734</value>
--<desc></desc>
--</constant>
--<constant>
--<name>RPC_S_NO_ENTRY_NAME</name>
--<value>1735</value>
--<desc></desc>
--</constant>
--<constant>
--<name>RPC_S_INVALID_NAME_SYNTAX</name>
--<value>1736</value>
--<desc></desc>
--</constant>
--<constant>
--<name>RPC_S_UNSUPPORTED_NAME_SYNTAX</name>
--<value>1737</value>
--<desc></desc>
--</constant>
--<constant>
--<name>RPC_S_UUID_NO_ADDRESS</name>
--<value>1739</value>
--<desc></desc>
--</constant>
--<constant>
--<name>RPC_S_DUPLICATE_ENDPOINT</name>
--<value>1740</value>
--<desc></desc>
--</constant>
--<constant>
--<name>RPC_S_UNKNOWN_AUTHN_TYPE</name>
--<value>1741</value>
--<desc></desc>
--</constant>
--<constant>
--<name>RPC_S_MAX_CALLS_TOO_SMALL</name>
--<value>1742</value>
--<desc></desc>
--</constant>
--<constant>
--<name>RPC_S_STRING_TOO_LONG</name>
--<value>1743</value>
--<desc></desc>
--</constant>
--<constant>
--<name>RPC_S_PROTSEQ_NOT_FOUND</name>
--<value>1744</value>
--<desc></desc>
--</constant>
--<constant>
--<name>RPC_S_PROCNUM_OUT_OF_RANGE</name>
--<value>1745</value>
--<desc></desc>
--</constant>
--<constant>
--<name>RPC_S_BINDING_HAS_NO_AUTH</name>
--<value>1746</value>
--<desc></desc>
--</constant>
--<constant>
--<name>RPC_S_UNKNOWN_AUTHN_SERVICE</name>
--<value>1747</value>
--<desc></desc>
--</constant>
--<constant>
--<name>RPC_S_UNKNOWN_AUTHN_LEVEL</name>
--<value>1748</value>
--<desc></desc>
--</constant>
--<constant>
--<name>RPC_S_INVALID_AUTH_IDENTITY</name>
--<value>1749</value>
--<desc></desc>
--</constant>
--<constant>
--<name>RPC_S_UNKNOWN_AUTHZ_SERVICE</name>
--<value>1750</value>
--<desc></desc>
--</constant>
--<constant>
--<name>EPT_S_INVALID_ENTRY</name>
--<value>1751</value>
--<desc></desc>
--</constant>
--<constant>
--<name>EPT_S_CANT_PERFORM_OP</name>
--<value>1752</value>
--<desc></desc>
--</constant>
--<constant>
--<name>EPT_S_NOT_REGISTERED</name>
--<value>1753</value>
--<desc></desc>
--</constant>
--<constant>
--<name>RPC_S_NOTHING_TO_EXPORT</name>
--<value>1754</value>
--<desc></desc>
--</constant>
--<constant>
--<name>RPC_S_INCOMPLETE_NAME</name>
--<value>1755</value>
--<desc></desc>
--</constant>
--<constant>
--<name>RPC_S_INVALID_VERS_OPTION</name>
--<value>1756</value>
--<desc></desc>
--</constant>
--<constant>
--<name>RPC_S_NO_MORE_MEMBERS</name>
--<value>1757</value>
--<desc></desc>
--</constant>
--<constant>
--<name>RPC_S_NOT_ALL_OBJS_UNEXPORTED</name>
--<value>1758</value>
--<desc></desc>
--</constant>
--<constant>
--<name>RPC_S_INTERFACE_NOT_FOUND</name>
--<value>1759</value>
--<desc></desc>
--</constant>
--<constant>
--<name>RPC_S_ENTRY_ALREADY_EXISTS</name>
--<value>1760</value>
--<desc></desc>
--</constant>
--<constant>
--<name>RPC_S_ENTRY_NOT_FOUND</name>
--<value>1761</value>
--<desc></desc>
--</constant>
--<constant>
--<name>RPC_S_NAME_SERVICE_UNAVAILABLE</name>
--<value>1762</value>
--<desc></desc>
--</constant>
--<constant>
--<name>RPC_S_INVALID_NAF_ID</name>
--<value>1763</value>
--<desc></desc>
--</constant>
--<constant>
--<name>RPC_S_CANNOT_SUPPORT</name>
--<value>1764</value>
--<desc></desc>
--</constant>
--<constant>
--<name>RPC_S_NO_CONTEXT_AVAILABLE</name>
--<value>1765</value>
--<desc></desc>
--</constant>
--<constant>
--<name>RPC_S_INTERNAL_ERROR</name>
--<value>1766</value>
--<desc></desc>
--</constant>
--<constant>
--<name>RPC_S_ZERO_DIVIDE</name>
--<value>1767</value>
--<desc></desc>
--</constant>
--<constant>
--<name>RPC_S_ADDRESS_ERROR</name>
--<value>1768</value>
--<desc></desc>
--</constant>
--<constant>
--<name>RPC_S_FP_DIV_ZERO</name>
--<value>1769</value>
--<desc></desc>
--</constant>
--<constant>
--<name>RPC_S_FP_UNDERFLOW</name>
--<value>1770</value>
--<desc></desc>
--</constant>
--<constant>
--<name>RPC_S_FP_OVERFLOW</name>
--<value>1771</value>
--<desc></desc>
--</constant>
--<constant>
--<name>RPC_X_NO_MORE_ENTRIES</name>
--<value>1772</value>
--<desc></desc>
--</constant>
--<constant>
--<name>RPC_X_SS_CHAR_TRANS_OPEN_FAIL</name>
--<value>1773</value>
--<desc></desc>
--</constant>
--<constant>
--<name>RPC_X_SS_CHAR_TRANS_SHORT_FILE</name>
--<value>1774</value>
--<desc></desc>
--</constant>
--<constant>
--<name>RPC_X_SS_IN_NULL_CONTEXT</name>
--<value>1775</value>
--<desc></desc>
--</constant>
--<constant>
--<name>RPC_X_SS_CONTEXT_DAMAGED</name>
--<value>1777</value>
--<desc></desc>
--</constant>
--<constant>
--<name>RPC_X_SS_HANDLES_MISMATCH</name>
--<value>1778</value>
--<desc></desc>
--</constant>
--<constant>
--<name>RPC_X_SS_CANNOT_GET_CALL_HANDLE</name>
--<value>1779</value>
--<desc></desc>
--</constant>
--<constant>
--<name>RPC_X_NULL_REF_POINTER</name>
--<value>1780</value>
--<desc></desc>
--</constant>
--<constant>
--<name>RPC_X_ENUM_VALUE_OUT_OF_RANGE</name>
--<value>1781</value>
--<desc></desc>
--</constant>
--<constant>
--<name>RPC_X_BYTE_COUNT_TOO_SMALL</name>
--<value>1782</value>
--<desc></desc>
--</constant>
--<constant>
--<name>RPC_X_BAD_STUB_DATA</name>
--<value>1783</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_INVALID_USER_BUFFER</name>
--<value>1784</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_UNRECOGNIZED_MEDIA</name>
--<value>1785</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_NO_TRUST_LSA_SECRET</name>
--<value>1786</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_NO_TRUST_SAM_ACCOUNT</name>
--<value>1787</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_TRUSTED_DOMAIN_FAILURE</name>
--<value>1788</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_TRUSTED_RELATIONSHIP_FAILURE</name>
--<value>1789</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_TRUST_FAILURE</name>
--<value>1790</value>
--<desc></desc>
--</constant>
--<constant>
--<name>RPC_S_CALL_IN_PROGRESS</name>
--<value>1791</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_NETLOGON_NOT_STARTED</name>
--<value>1792</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_ACCOUNT_EXPIRED</name>
--<value>1793</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_REDIRECTOR_HAS_OPEN_HANDLES</name>
--<value>1794</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_PRINTER_DRIVER_ALREADY_INSTALLED</name>
--<value>1795</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_UNKNOWN_PORT</name>
--<value>1796</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_UNKNOWN_PRINTER_DRIVER</name>
--<value>1797</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_UNKNOWN_PRINTPROCESSOR</name>
--<value>1798</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_INVALID_SEPARATOR_FILE</name>
--<value>1799</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_INVALID_PRIORITY</name>
--<value>1800</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_INVALID_PRINTER_NAME</name>
--<value>1801</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_PRINTER_ALREADY_EXISTS</name>
--<value>1802</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_INVALID_PRINTER_COMMAND</name>
--<value>1803</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_INVALID_DATATYPE</name>
--<value>1804</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_INVALID_ENVIRONMENT</name>
--<value>1805</value>
--<desc></desc>
--</constant>
--<constant>
--<name>RPC_S_NO_MORE_BINDINGS</name>
--<value>1806</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_NOLOGON_INTERDOMAIN_TRUST_ACCOUNT</name>
--<value>1807</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_NOLOGON_WORKSTATION_TRUST_ACCOUNT</name>
--<value>1808</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_NOLOGON_SERVER_TRUST_ACCOUNT</name>
--<value>1809</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_DOMAIN_TRUST_INCONSISTENT</name>
--<value>1810</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_SERVER_HAS_OPEN_HANDLES</name>
--<value>1811</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_RESOURCE_DATA_NOT_FOUND</name>
--<value>1812</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_RESOURCE_TYPE_NOT_FOUND</name>
--<value>1813</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_RESOURCE_NAME_NOT_FOUND</name>
--<value>1814</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_RESOURCE_LANG_NOT_FOUND</name>
--<value>1815</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_NOT_ENOUGH_QUOTA</name>
--<value>1816</value>
--<desc></desc>
--</constant>
--<constant>
--<name>RPC_S_NO_INTERFACES</name>
--<value>1817</value>
--<desc></desc>
--</constant>
--<constant>
--<name>RPC_S_CALL_CANCELLED</name>
--<value>1818</value>
--<desc></desc>
--</constant>
--<constant>
--<name>RPC_S_BINDING_INCOMPLETE</name>
--<value>1819</value>
--<desc></desc>
--</constant>
--<constant>
--<name>RPC_S_COMM_FAILURE</name>
--<value>1820</value>
--<desc></desc>
--</constant>
--<constant>
--<name>RPC_S_UNSUPPORTED_AUTHN_LEVEL</name>
--<value>1821</value>
--<desc></desc>
--</constant>
--<constant>
--<name>RPC_S_NO_PRINC_NAME</name>
--<value>1822</value>
--<desc></desc>
--</constant>
--<constant>
--<name>RPC_S_NOT_RPC_ERROR</name>
--<value>1823</value>
--<desc></desc>
--</constant>
--<constant>
--<name>RPC_S_UUID_LOCAL_ONLY</name>
--<value>1824</value>
--<desc></desc>
--</constant>
--<constant>
--<name>RPC_S_SEC_PKG_ERROR</name>
--<value>1825</value>
--<desc></desc>
--</constant>
--<constant>
--<name>RPC_S_NOT_CANCELLED</name>
--<value>1826</value>
--<desc></desc>
--</constant>
--<constant>
--<name>RPC_X_INVALID_ES_ACTION</name>
--<value>1827</value>
--<desc></desc>
--</constant>
--<constant>
--<name>RPC_X_WRONG_ES_VERSION</name>
--<value>1828</value>
--<desc></desc>
--</constant>
--<constant>
--<name>RPC_X_WRONG_STUB_VERSION</name>
--<value>1829</value>
--<desc></desc>
--</constant>
--<constant>
--<name>RPC_X_INVALID_PIPE_OBJECT</name>
--<value>1830</value>
--<desc></desc>
--</constant>
--<constant>
--<name>RPC_X_WRONG_PIPE_ORDER</name>
--<value>1831</value>
--<desc></desc>
--</constant>
--<constant>
--<name>RPC_X_WRONG_PIPE_VERSION</name>
--<value>1832</value>
--<desc></desc>
--</constant>
--<constant>
--<name>RPC_S_COOKIE_AUTH_FAILED</name>
--<value>1833</value>
--<desc></desc>
--</constant>
--<constant>
--<name>RPC_S_GROUP_MEMBER_NOT_FOUND</name>
--<value>1898</value>
--<desc></desc>
--</constant>
--<constant>
--<name>EPT_S_CANT_CREATE</name>
--<value>1899</value>
--<desc></desc>
--</constant>
--<constant>
--<name>RPC_S_INVALID_OBJECT</name>
--<value>1900</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_INVALID_TIME</name>
--<value>1901</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_INVALID_FORM_NAME</name>
--<value>1902</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_INVALID_FORM_SIZE</name>
--<value>1903</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_ALREADY_WAITING</name>
--<value>1904</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_PRINTER_DELETED</name>
--<value>1905</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_INVALID_PRINTER_STATE</name>
--<value>1906</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_PASSWORD_MUST_CHANGE</name>
--<value>1907</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_DOMAIN_CONTROLLER_NOT_FOUND</name>
--<value>1908</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_ACCOUNT_LOCKED_OUT</name>
--<value>1909</value>
--<desc></desc>
--</constant>
--<constant>
--<name>OR_INVALID_OXID</name>
--<value>1910</value>
--<desc></desc>
--</constant>
--<constant>
--<name>OR_INVALID_OID</name>
--<value>1911</value>
--<desc></desc>
--</constant>
--<constant>
--<name>OR_INVALID_SET</name>
--<value>1912</value>
--<desc></desc>
--</constant>
--<constant>
--<name>RPC_S_SEND_INCOMPLETE</name>
--<value>1913</value>
--<desc></desc>
--</constant>
--<constant>
--<name>RPC_S_INVALID_ASYNC_HANDLE</name>
--<value>1914</value>
--<desc></desc>
--</constant>
--<constant>
--<name>RPC_S_INVALID_ASYNC_CALL</name>
--<value>1915</value>
--<desc></desc>
--</constant>
--<constant>
--<name>RPC_X_PIPE_CLOSED</name>
--<value>1916</value>
--<desc></desc>
--</constant>
--<constant>
--<name>RPC_X_PIPE_DISCIPLINE_ERROR</name>
--<value>1917</value>
--<desc></desc>
--</constant>
--<constant>
--<name>RPC_X_PIPE_EMPTY</name>
--<value>1918</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_NO_SITENAME</name>
--<value>1919</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_CANT_ACCESS_FILE</name>
--<value>1920</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_CANT_RESOLVE_FILENAME</name>
--<value>1921</value>
--<desc></desc>
--</constant>
--<constant>
--<name>RPC_S_ENTRY_TYPE_MISMATCH</name>
--<value>1922</value>
--<desc></desc>
--</constant>
--<constant>
--<name>RPC_S_NOT_ALL_OBJS_EXPORTED</name>
--<value>1923</value>
--<desc></desc>
--</constant>
--<constant>
--<name>RPC_S_INTERFACE_NOT_EXPORTED</name>
--<value>1924</value>
--<desc></desc>
--</constant>
--<constant>
--<name>RPC_S_PROFILE_NOT_ADDED</name>
--<value>1925</value>
--<desc></desc>
--</constant>
--<constant>
--<name>RPC_S_PRF_ELT_NOT_ADDED</name>
--<value>1926</value>
--<desc></desc>
--</constant>
--<constant>
--<name>RPC_S_PRF_ELT_NOT_REMOVED</name>
--<value>1927</value>
--<desc></desc>
--</constant>
--<constant>
--<name>RPC_S_GRP_ELT_NOT_ADDED</name>
--<value>1928</value>
--<desc></desc>
--</constant>
--<constant>
--<name>RPC_S_GRP_ELT_NOT_REMOVED</name>
--<value>1929</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_KM_DRIVER_BLOCKED</name>
--<value>1930</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_CONTEXT_EXPIRED</name>
--<value>1931</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_PER_USER_TRUST_QUOTA_EXCEEDED</name>
--<value>1932</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_ALL_USER_TRUST_QUOTA_EXCEEDED</name>
--<value>1933</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_USER_DELETE_TRUST_QUOTA_EXCEEDED</name>
--<value>1934</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_AUTHENTICATION_FIREWALL_FAILED</name>
--<value>1935</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_REMOTE_PRINT_CONNECTIONS_BLOCKED</name>
--<value>1936</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_NTLM_BLOCKED</name>
--<value>1937</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_INVALID_PIXEL_FORMAT</name>
--<value>2000</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_BAD_DRIVER</name>
--<value>2001</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_INVALID_WINDOW_STYLE</name>
--<value>2002</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_METAFILE_NOT_SUPPORTED</name>
--<value>2003</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_TRANSFORM_NOT_SUPPORTED</name>
--<value>2004</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_CLIPPING_NOT_SUPPORTED</name>
--<value>2005</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_INVALID_CMM</name>
--<value>2010</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_INVALID_PROFILE</name>
--<value>2011</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_TAG_NOT_FOUND</name>
--<value>2012</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_TAG_NOT_PRESENT</name>
--<value>2013</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_DUPLICATE_TAG</name>
--<value>2014</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_PROFILE_NOT_ASSOCIATED_WITH_DEVICE</name>
--<value>2015</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_PROFILE_NOT_FOUND</name>
--<value>2016</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_INVALID_COLORSPACE</name>
--<value>2017</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_ICM_NOT_ENABLED</name>
--<value>2018</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_DELETING_ICM_XFORM</name>
--<value>2019</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_INVALID_TRANSFORM</name>
--<value>2020</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_COLORSPACE_MISMATCH</name>
--<value>2021</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_INVALID_COLORINDEX</name>
--<value>2022</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_PROFILE_DOES_NOT_MATCH_DEVICE</name>
--<value>2023</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_CONNECTED_OTHER_PASSWORD</name>
--<value>2108</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_CONNECTED_OTHER_PASSWORD_DEFAULT</name>
--<value>2109</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_BAD_USERNAME</name>
--<value>2202</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_NOT_CONNECTED</name>
--<value>2250</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_OPEN_FILES</name>
--<value>2401</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_ACTIVE_CONNECTIONS</name>
--<value>2402</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_DEVICE_IN_USE</name>
--<value>2404</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_UNKNOWN_PRINT_MONITOR</name>
--<value>3000</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_PRINTER_DRIVER_IN_USE</name>
--<value>3001</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_SPOOL_FILE_NOT_FOUND</name>
--<value>3002</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_SPL_NO_STARTDOC</name>
--<value>3003</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_SPL_NO_ADDJOB</name>
--<value>3004</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_PRINT_PROCESSOR_ALREADY_INSTALLED</name>
--<value>3005</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_PRINT_MONITOR_ALREADY_INSTALLED</name>
--<value>3006</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_INVALID_PRINT_MONITOR</name>
--<value>3007</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_PRINT_MONITOR_IN_USE</name>
--<value>3008</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_PRINTER_HAS_JOBS_QUEUED</name>
--<value>3009</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_SUCCESS_REBOOT_REQUIRED</name>
--<value>3010</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_SUCCESS_RESTART_REQUIRED</name>
--<value>3011</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_PRINTER_NOT_FOUND</name>
--<value>3012</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_PRINTER_DRIVER_WARNED</name>
--<value>3013</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_PRINTER_DRIVER_BLOCKED</name>
--<value>3014</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_PRINTER_DRIVER_PACKAGE_IN_USE</name>
--<value>3015</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_CORE_DRIVER_PACKAGE_NOT_FOUND</name>
--<value>3016</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_FAIL_REBOOT_REQUIRED</name>
--<value>3017</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_FAIL_REBOOT_INITIATED</name>
--<value>3018</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_PRINTER_DRIVER_DOWNLOAD_NEEDED</name>
--<value>3019</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_PRINT_JOB_RESTART_REQUIRED</name>
--<value>3020</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_IO_REISSUE_AS_CACHED</name>
--<value>3950</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_WINS_INTERNAL</name>
--<value>4000</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_CAN_NOT_DEL_LOCAL_WINS</name>
--<value>4001</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_STATIC_INIT</name>
--<value>4002</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_INC_BACKUP</name>
--<value>4003</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_FULL_BACKUP</name>
--<value>4004</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_REC_NON_EXISTENT</name>
--<value>4005</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_RPL_NOT_ALLOWED</name>
--<value>4006</value>
--<desc></desc>
--</constant>
--<constant>
--<name>PEERDIST_ERROR_CONTENTINFO_VERSION_UNSUPPORTED</name>
--<value>4050</value>
--<desc></desc>
--</constant>
--<constant>
--<name>PEERDIST_ERROR_CANNOT_PARSE_CONTENTINFO</name>
--<value>4051</value>
--<desc></desc>
--</constant>
--<constant>
--<name>PEERDIST_ERROR_MISSING_DATA</name>
--<value>4052</value>
--<desc></desc>
--</constant>
--<constant>
--<name>PEERDIST_ERROR_NO_MORE</name>
--<value>4053</value>
--<desc></desc>
--</constant>
--<constant>
--<name>PEERDIST_ERROR_NOT_INITIALIZED</name>
--<value>4054</value>
--<desc></desc>
--</constant>
--<constant>
--<name>PEERDIST_ERROR_ALREADY_INITIALIZED</name>
--<value>4055</value>
--<desc></desc>
--</constant>
--<constant>
--<name>PEERDIST_ERROR_SHUTDOWN_IN_PROGRESS</name>
--<value>4056</value>
--<desc></desc>
--</constant>
--<constant>
--<name>PEERDIST_ERROR_INVALIDATED</name>
--<value>4057</value>
--<desc></desc>
--</constant>
--<constant>
--<name>PEERDIST_ERROR_ALREADY_EXISTS</name>
--<value>4058</value>
--<desc></desc>
--</constant>
--<constant>
--<name>PEERDIST_ERROR_OPERATION_NOTFOUND</name>
--<value>4059</value>
--<desc></desc>
--</constant>
--<constant>
--<name>PEERDIST_ERROR_ALREADY_COMPLETED</name>
--<value>4060</value>
--<desc></desc>
--</constant>
--<constant>
--<name>PEERDIST_ERROR_OUT_OF_BOUNDS</name>
--<value>4061</value>
--<desc></desc>
--</constant>
--<constant>
--<name>PEERDIST_ERROR_VERSION_UNSUPPORTED</name>
--<value>4062</value>
--<desc></desc>
--</constant>
--<constant>
--<name>PEERDIST_ERROR_INVALID_CONFIGURATION</name>
--<value>4063</value>
--<desc></desc>
--</constant>
--<constant>
--<name>PEERDIST_ERROR_NOT_LICENSED</name>
--<value>4064</value>
--<desc></desc>
--</constant>
--<constant>
--<name>PEERDIST_ERROR_SERVICE_UNAVAILABLE</name>
--<value>4065</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_DHCP_ADDRESS_CONFLICT</name>
--<value>4100</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_WMI_GUID_NOT_FOUND</name>
--<value>4200</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_WMI_INSTANCE_NOT_FOUND</name>
--<value>4201</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_WMI_ITEMID_NOT_FOUND</name>
--<value>4202</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_WMI_TRY_AGAIN</name>
--<value>4203</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_WMI_DP_NOT_FOUND</name>
--<value>4204</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_WMI_UNRESOLVED_INSTANCE_REF</name>
--<value>4205</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_WMI_ALREADY_ENABLED</name>
--<value>4206</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_WMI_GUID_DISCONNECTED</name>
--<value>4207</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_WMI_SERVER_UNAVAILABLE</name>
--<value>4208</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_WMI_DP_FAILED</name>
--<value>4209</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_WMI_INVALID_MOF</name>
--<value>4210</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_WMI_INVALID_REGINFO</name>
--<value>4211</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_WMI_ALREADY_DISABLED</name>
--<value>4212</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_WMI_READ_ONLY</name>
--<value>4213</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_WMI_SET_FAILURE</name>
--<value>4214</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_INVALID_MEDIA</name>
--<value>4300</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_INVALID_LIBRARY</name>
--<value>4301</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_INVALID_MEDIA_POOL</name>
--<value>4302</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_DRIVE_MEDIA_MISMATCH</name>
--<value>4303</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_MEDIA_OFFLINE</name>
--<value>4304</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_LIBRARY_OFFLINE</name>
--<value>4305</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_EMPTY</name>
--<value>4306</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_NOT_EMPTY</name>
--<value>4307</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_MEDIA_UNAVAILABLE</name>
--<value>4308</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_RESOURCE_DISABLED</name>
--<value>4309</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_INVALID_CLEANER</name>
--<value>4310</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_UNABLE_TO_CLEAN</name>
--<value>4311</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_OBJECT_NOT_FOUND</name>
--<value>4312</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_DATABASE_FAILURE</name>
--<value>4313</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_DATABASE_FULL</name>
--<value>4314</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_MEDIA_INCOMPATIBLE</name>
--<value>4315</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_RESOURCE_NOT_PRESENT</name>
--<value>4316</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_INVALID_OPERATION</name>
--<value>4317</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_MEDIA_NOT_AVAILABLE</name>
--<value>4318</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_DEVICE_NOT_AVAILABLE</name>
--<value>4319</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_REQUEST_REFUSED</name>
--<value>4320</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_INVALID_DRIVE_OBJECT</name>
--<value>4321</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_LIBRARY_FULL</name>
--<value>4322</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_MEDIUM_NOT_ACCESSIBLE</name>
--<value>4323</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_UNABLE_TO_LOAD_MEDIUM</name>
--<value>4324</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_UNABLE_TO_INVENTORY_DRIVE</name>
--<value>4325</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_UNABLE_TO_INVENTORY_SLOT</name>
--<value>4326</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_UNABLE_TO_INVENTORY_TRANSPORT</name>
--<value>4327</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_TRANSPORT_FULL</name>
--<value>4328</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_CONTROLLING_IEPORT</name>
--<value>4329</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_UNABLE_TO_EJECT_MOUNTED_MEDIA</name>
--<value>4330</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_CLEANER_SLOT_SET</name>
--<value>4331</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_CLEANER_SLOT_NOT_SET</name>
--<value>4332</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_CLEANER_CARTRIDGE_SPENT</name>
--<value>4333</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_UNEXPECTED_OMID</name>
--<value>4334</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_CANT_DELETE_LAST_ITEM</name>
--<value>4335</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_MESSAGE_EXCEEDS_MAX_SIZE</name>
--<value>4336</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_VOLUME_CONTAINS_SYS_FILES</name>
--<value>4337</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_INDIGENOUS_TYPE</name>
--<value>4338</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_NO_SUPPORTING_DRIVES</name>
--<value>4339</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_CLEANER_CARTRIDGE_INSTALLED</name>
--<value>4340</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_IEPORT_FULL</name>
--<value>4341</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_FILE_OFFLINE</name>
--<value>4350</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_REMOTE_STORAGE_NOT_ACTIVE</name>
--<value>4351</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_REMOTE_STORAGE_MEDIA_ERROR</name>
--<value>4352</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_NOT_A_REPARSE_POINT</name>
--<value>4390</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_REPARSE_ATTRIBUTE_CONFLICT</name>
--<value>4391</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_INVALID_REPARSE_DATA</name>
--<value>4392</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_REPARSE_TAG_INVALID</name>
--<value>4393</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_REPARSE_TAG_MISMATCH</name>
--<value>4394</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_VOLUME_NOT_SIS_ENABLED</name>
--<value>4500</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_DEPENDENT_RESOURCE_EXISTS</name>
--<value>5001</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_DEPENDENCY_NOT_FOUND</name>
--<value>5002</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_DEPENDENCY_ALREADY_EXISTS</name>
--<value>5003</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_RESOURCE_NOT_ONLINE</name>
--<value>5004</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_HOST_NODE_NOT_AVAILABLE</name>
--<value>5005</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_RESOURCE_NOT_AVAILABLE</name>
--<value>5006</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_RESOURCE_NOT_FOUND</name>
--<value>5007</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_SHUTDOWN_CLUSTER</name>
--<value>5008</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_CANT_EVICT_ACTIVE_NODE</name>
--<value>5009</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_OBJECT_ALREADY_EXISTS</name>
--<value>5010</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_OBJECT_IN_LIST</name>
--<value>5011</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_GROUP_NOT_AVAILABLE</name>
--<value>5012</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_GROUP_NOT_FOUND</name>
--<value>5013</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_GROUP_NOT_ONLINE</name>
--<value>5014</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_HOST_NODE_NOT_RESOURCE_OWNER</name>
--<value>5015</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_HOST_NODE_NOT_GROUP_OWNER</name>
--<value>5016</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_RESMON_CREATE_FAILED</name>
--<value>5017</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_RESMON_ONLINE_FAILED</name>
--<value>5018</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_RESOURCE_ONLINE</name>
--<value>5019</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_QUORUM_RESOURCE</name>
--<value>5020</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_NOT_QUORUM_CAPABLE</name>
--<value>5021</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_CLUSTER_SHUTTING_DOWN</name>
--<value>5022</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_INVALID_STATE</name>
--<value>5023</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_RESOURCE_PROPERTIES_STORED</name>
--<value>5024</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_NOT_QUORUM_CLASS</name>
--<value>5025</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_CORE_RESOURCE</name>
--<value>5026</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_QUORUM_RESOURCE_ONLINE_FAILED</name>
--<value>5027</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_QUORUMLOG_OPEN_FAILED</name>
--<value>5028</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_CLUSTERLOG_CORRUPT</name>
--<value>5029</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_CLUSTERLOG_RECORD_EXCEEDS_MAXSIZE</name>
--<value>5030</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_CLUSTERLOG_EXCEEDS_MAXSIZE</name>
--<value>5031</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_CLUSTERLOG_CHKPOINT_NOT_FOUND</name>
--<value>5032</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_CLUSTERLOG_NOT_ENOUGH_SPACE</name>
--<value>5033</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_QUORUM_OWNER_ALIVE</name>
--<value>5034</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_NETWORK_NOT_AVAILABLE</name>
--<value>5035</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_NODE_NOT_AVAILABLE</name>
--<value>5036</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_ALL_NODES_NOT_AVAILABLE</name>
--<value>5037</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_RESOURCE_FAILED</name>
--<value>5038</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_CLUSTER_INVALID_NODE</name>
--<value>5039</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_CLUSTER_NODE_EXISTS</name>
--<value>5040</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_CLUSTER_JOIN_IN_PROGRESS</name>
--<value>5041</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_CLUSTER_NODE_NOT_FOUND</name>
--<value>5042</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_CLUSTER_LOCAL_NODE_NOT_FOUND</name>
--<value>5043</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_CLUSTER_NETWORK_EXISTS</name>
--<value>5044</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_CLUSTER_NETWORK_NOT_FOUND</name>
--<value>5045</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_CLUSTER_NETINTERFACE_EXISTS</name>
--<value>5046</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_CLUSTER_NETINTERFACE_NOT_FOUND</name>
--<value>5047</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_CLUSTER_INVALID_REQUEST</name>
--<value>5048</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_CLUSTER_INVALID_NETWORK_PROVIDER</name>
--<value>5049</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_CLUSTER_NODE_DOWN</name>
--<value>5050</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_CLUSTER_NODE_UNREACHABLE</name>
--<value>5051</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_CLUSTER_NODE_NOT_MEMBER</name>
--<value>5052</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_CLUSTER_JOIN_NOT_IN_PROGRESS</name>
--<value>5053</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_CLUSTER_INVALID_NETWORK</name>
--<value>5054</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_CLUSTER_NODE_UP</name>
--<value>5056</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_CLUSTER_IPADDR_IN_USE</name>
--<value>5057</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_CLUSTER_NODE_NOT_PAUSED</name>
--<value>5058</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_CLUSTER_NO_SECURITY_CONTEXT</name>
--<value>5059</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_CLUSTER_NETWORK_NOT_INTERNAL</name>
--<value>5060</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_CLUSTER_NODE_ALREADY_UP</name>
--<value>5061</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_CLUSTER_NODE_ALREADY_DOWN</name>
--<value>5062</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_CLUSTER_NETWORK_ALREADY_ONLINE</name>
--<value>5063</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_CLUSTER_NETWORK_ALREADY_OFFLINE</name>
--<value>5064</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_CLUSTER_NODE_ALREADY_MEMBER</name>
--<value>5065</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_CLUSTER_LAST_INTERNAL_NETWORK</name>
--<value>5066</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_CLUSTER_NETWORK_HAS_DEPENDENTS</name>
--<value>5067</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_INVALID_OPERATION_ON_QUORUM</name>
--<value>5068</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_DEPENDENCY_NOT_ALLOWED</name>
--<value>5069</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_CLUSTER_NODE_PAUSED</name>
--<value>5070</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_NODE_CANT_HOST_RESOURCE</name>
--<value>5071</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_CLUSTER_NODE_NOT_READY</name>
--<value>5072</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_CLUSTER_NODE_SHUTTING_DOWN</name>
--<value>5073</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_CLUSTER_JOIN_ABORTED</name>
--<value>5074</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_CLUSTER_INCOMPATIBLE_VERSIONS</name>
--<value>5075</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_CLUSTER_MAXNUM_OF_RESOURCES_EXCEEDED</name>
--<value>5076</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_CLUSTER_SYSTEM_CONFIG_CHANGED</name>
--<value>5077</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_CLUSTER_RESOURCE_TYPE_NOT_FOUND</name>
--<value>5078</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_CLUSTER_RESTYPE_NOT_SUPPORTED</name>
--<value>5079</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_CLUSTER_RESNAME_NOT_FOUND</name>
--<value>5080</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_CLUSTER_NO_RPC_PACKAGES_REGISTERED</name>
--<value>5081</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_CLUSTER_OWNER_NOT_IN_PREFLIST</name>
--<value>5082</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_CLUSTER_DATABASE_SEQMISMATCH</name>
--<value>5083</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_RESMON_INVALID_STATE</name>
--<value>5084</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_CLUSTER_GUM_NOT_LOCKER</name>
--<value>5085</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_QUORUM_DISK_NOT_FOUND</name>
--<value>5086</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_DATABASE_BACKUP_CORRUPT</name>
--<value>5087</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_CLUSTER_NODE_ALREADY_HAS_DFS_ROOT</name>
--<value>5088</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_RESOURCE_PROPERTY_UNCHANGEABLE</name>
--<value>5089</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_CLUSTER_MEMBERSHIP_INVALID_STATE</name>
--<value>5890</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_CLUSTER_QUORUMLOG_NOT_FOUND</name>
--<value>5891</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_CLUSTER_MEMBERSHIP_HALT</name>
--<value>5892</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_CLUSTER_INSTANCE_ID_MISMATCH</name>
--<value>5893</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_CLUSTER_NETWORK_NOT_FOUND_FOR_IP</name>
--<value>5894</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_CLUSTER_PROPERTY_DATA_TYPE_MISMATCH</name>
--<value>5895</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_CLUSTER_EVICT_WITHOUT_CLEANUP</name>
--<value>5896</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_CLUSTER_PARAMETER_MISMATCH</name>
--<value>5897</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_NODE_CANNOT_BE_CLUSTERED</name>
--<value>5898</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_CLUSTER_WRONG_OS_VERSION</name>
--<value>5899</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_CLUSTER_CANT_CREATE_DUP_CLUSTER_NAME</name>
--<value>5900</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_CLUSCFG_ALREADY_COMMITTED</name>
--<value>5901</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_CLUSCFG_ROLLBACK_FAILED</name>
--<value>5902</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_CLUSCFG_SYSTEM_DISK_DRIVE_LETTER_CONFLICT</name>
--<value>5903</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_CLUSTER_OLD_VERSION</name>
--<value>5904</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_CLUSTER_MISMATCHED_COMPUTER_ACCT_NAME</name>
--<value>5905</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_CLUSTER_NO_NET_ADAPTERS</name>
--<value>5906</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_CLUSTER_POISONED</name>
--<value>5907</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_CLUSTER_GROUP_MOVING</name>
--<value>5908</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_CLUSTER_RESOURCE_TYPE_BUSY</name>
--<value>5909</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_RESOURCE_CALL_TIMED_OUT</name>
--<value>5910</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_INVALID_CLUSTER_IPV6_ADDRESS</name>
--<value>5911</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_CLUSTER_INTERNAL_INVALID_FUNCTION</name>
--<value>5912</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_CLUSTER_PARAMETER_OUT_OF_BOUNDS</name>
--<value>5913</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_CLUSTER_PARTIAL_SEND</name>
--<value>5914</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_CLUSTER_REGISTRY_INVALID_FUNCTION</name>
--<value>5915</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_CLUSTER_INVALID_STRING_TERMINATION</name>
--<value>5916</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_CLUSTER_INVALID_STRING_FORMAT</name>
--<value>5917</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_CLUSTER_DATABASE_TRANSACTION_IN_PROGRESS</name>
--<value>5918</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_CLUSTER_DATABASE_TRANSACTION_NOT_IN_PROGRESS</name>
--<value>5919</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_CLUSTER_NULL_DATA</name>
--<value>5920</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_CLUSTER_PARTIAL_READ</name>
--<value>5921</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_CLUSTER_PARTIAL_WRITE</name>
--<value>5922</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_CLUSTER_CANT_DESERIALIZE_DATA</name>
--<value>5923</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_DEPENDENT_RESOURCE_PROPERTY_CONFLICT</name>
--<value>5924</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_CLUSTER_NO_QUORUM</name>
--<value>5925</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_CLUSTER_INVALID_IPV6_NETWORK</name>
--<value>5926</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_CLUSTER_INVALID_IPV6_TUNNEL_NETWORK</name>
--<value>5927</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_QUORUM_NOT_ALLOWED_IN_THIS_GROUP</name>
--<value>5928</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_DEPENDENCY_TREE_TOO_COMPLEX</name>
--<value>5929</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_EXCEPTION_IN_RESOURCE_CALL</name>
--<value>5930</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_CLUSTER_RHS_FAILED_INITIALIZATION</name>
--<value>5931</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_CLUSTER_NOT_INSTALLED</name>
--<value>5932</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_CLUSTER_RESOURCES_MUST_BE_ONLINE_ON_THE_SAME_NODE</name>
--<value>5933</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_CLUSTER_MAX_NODES_IN_CLUSTER</name>
--<value>5934</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_CLUSTER_TOO_MANY_NODES</name>
--<value>5935</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_CLUSTER_OBJECT_ALREADY_USED</name>
--<value>5936</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_NONCORE_GROUPS_FOUND</name>
--<value>5937</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_FILE_SHARE_RESOURCE_CONFLICT</name>
--<value>5938</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_CLUSTER_EVICT_INVALID_REQUEST</name>
--<value>5939</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_CLUSTER_SINGLETON_RESOURCE</name>
--<value>5940</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_CLUSTER_GROUP_SINGLETON_RESOURCE</name>
--<value>5941</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_CLUSTER_RESOURCE_PROVIDER_FAILED</name>
--<value>5942</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_CLUSTER_RESOURCE_CONFIGURATION_ERROR</name>
--<value>5943</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_CLUSTER_GROUP_BUSY</name>
--<value>5944</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_CLUSTER_NOT_SHARED_VOLUME</name>
--<value>5945</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_CLUSTER_INVALID_SECURITY_DESCRIPTOR</name>
--<value>5946</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_CLUSTER_SHARED_VOLUMES_IN_USE</name>
--<value>5947</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_CLUSTER_USE_SHARED_VOLUMES_API</name>
--<value>5948</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_CLUSTER_BACKUP_IN_PROGRESS</name>
--<value>5949</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_NON_CSV_PATH</name>
--<value>5950</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_CSV_VOLUME_NOT_LOCAL</name>
--<value>5951</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_CLUSTER_WATCHDOG_TERMINATING</name>
--<value>5952</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_ENCRYPTION_FAILED</name>
--<value>6000</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_DECRYPTION_FAILED</name>
--<value>6001</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_FILE_ENCRYPTED</name>
--<value>6002</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_NO_RECOVERY_POLICY</name>
--<value>6003</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_NO_EFS</name>
--<value>6004</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_WRONG_EFS</name>
--<value>6005</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_NO_USER_KEYS</name>
--<value>6006</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_FILE_NOT_ENCRYPTED</name>
--<value>6007</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_NOT_EXPORT_FORMAT</name>
--<value>6008</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_FILE_READ_ONLY</name>
--<value>6009</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_DIR_EFS_DISALLOWED</name>
--<value>6010</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_EFS_SERVER_NOT_TRUSTED</name>
--<value>6011</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_BAD_RECOVERY_POLICY</name>
--<value>6012</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_EFS_ALG_BLOB_TOO_BIG</name>
--<value>6013</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_VOLUME_NOT_SUPPORT_EFS</name>
--<value>6014</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_EFS_DISABLED</name>
--<value>6015</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_EFS_VERSION_NOT_SUPPORT</name>
--<value>6016</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_CS_ENCRYPTION_INVALID_SERVER_RESPONSE</name>
--<value>6017</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_CS_ENCRYPTION_UNSUPPORTED_SERVER</name>
--<value>6018</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_CS_ENCRYPTION_EXISTING_ENCRYPTED_FILE</name>
--<value>6019</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_CS_ENCRYPTION_NEW_ENCRYPTED_FILE</name>
--<value>6020</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_CS_ENCRYPTION_FILE_NOT_CSE</name>
--<value>6021</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_NO_BROWSER_SERVERS_FOUND</name>
--<value>6118</value>
--<desc></desc>
--</constant>
--<constant>
--<name>SCHED_E_SERVICE_NOT_LOCALSYSTEM</name>
--<value>6200</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_LOG_SECTOR_INVALID</name>
--<value>6600</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_LOG_SECTOR_PARITY_INVALID</name>
--<value>6601</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_LOG_SECTOR_REMAPPED</name>
--<value>6602</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_LOG_BLOCK_INCOMPLETE</name>
--<value>6603</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_LOG_INVALID_RANGE</name>
--<value>6604</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_LOG_BLOCKS_EXHAUSTED</name>
--<value>6605</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_LOG_READ_CONTEXT_INVALID</name>
--<value>6606</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_LOG_RESTART_INVALID</name>
--<value>6607</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_LOG_BLOCK_VERSION</name>
--<value>6608</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_LOG_BLOCK_INVALID</name>
--<value>6609</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_LOG_READ_MODE_INVALID</name>
--<value>6610</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_LOG_NO_RESTART</name>
--<value>6611</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_LOG_METADATA_CORRUPT</name>
--<value>6612</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_LOG_METADATA_INVALID</name>
--<value>6613</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_LOG_METADATA_INCONSISTENT</name>
--<value>6614</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_LOG_RESERVATION_INVALID</name>
--<value>6615</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_LOG_CANT_DELETE</name>
--<value>6616</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_LOG_CONTAINER_LIMIT_EXCEEDED</name>
--<value>6617</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_LOG_START_OF_LOG</name>
--<value>6618</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_LOG_POLICY_ALREADY_INSTALLED</name>
--<value>6619</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_LOG_POLICY_NOT_INSTALLED</name>
--<value>6620</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_LOG_POLICY_INVALID</name>
--<value>6621</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_LOG_POLICY_CONFLICT</name>
--<value>6622</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_LOG_PINNED_ARCHIVE_TAIL</name>
--<value>6623</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_LOG_RECORD_NONEXISTENT</name>
--<value>6624</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_LOG_RECORDS_RESERVED_INVALID</name>
--<value>6625</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_LOG_SPACE_RESERVED_INVALID</name>
--<value>6626</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_LOG_TAIL_INVALID</name>
--<value>6627</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_LOG_FULL</name>
--<value>6628</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_COULD_NOT_RESIZE_LOG</name>
--<value>6629</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_LOG_MULTIPLEXED</name>
--<value>6630</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_LOG_DEDICATED</name>
--<value>6631</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_LOG_ARCHIVE_NOT_IN_PROGRESS</name>
--<value>6632</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_LOG_ARCHIVE_IN_PROGRESS</name>
--<value>6633</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_LOG_EPHEMERAL</name>
--<value>6634</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_LOG_NOT_ENOUGH_CONTAINERS</name>
--<value>6635</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_LOG_CLIENT_ALREADY_REGISTERED</name>
--<value>6636</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_LOG_CLIENT_NOT_REGISTERED</name>
--<value>6637</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_LOG_FULL_HANDLER_IN_PROGRESS</name>
--<value>6638</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_LOG_CONTAINER_READ_FAILED</name>
--<value>6639</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_LOG_CONTAINER_WRITE_FAILED</name>
--<value>6640</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_LOG_CONTAINER_OPEN_FAILED</name>
--<value>6641</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_LOG_CONTAINER_STATE_INVALID</name>
--<value>6642</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_LOG_STATE_INVALID</name>
--<value>6643</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_LOG_PINNED</name>
--<value>6644</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_LOG_METADATA_FLUSH_FAILED</name>
--<value>6645</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_LOG_INCONSISTENT_SECURITY</name>
--<value>6646</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_LOG_APPENDED_FLUSH_FAILED</name>
--<value>6647</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_LOG_PINNED_RESERVATION</name>
--<value>6648</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_INVALID_TRANSACTION</name>
--<value>6700</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_TRANSACTION_NOT_ACTIVE</name>
--<value>6701</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_TRANSACTION_REQUEST_NOT_VALID</name>
--<value>6702</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_TRANSACTION_NOT_REQUESTED</name>
--<value>6703</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_TRANSACTION_ALREADY_ABORTED</name>
--<value>6704</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_TRANSACTION_ALREADY_COMMITTED</name>
--<value>6705</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_TM_INITIALIZATION_FAILED</name>
--<value>6706</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_RESOURCEMANAGER_READ_ONLY</name>
--<value>6707</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_TRANSACTION_NOT_JOINED</name>
--<value>6708</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_TRANSACTION_SUPERIOR_EXISTS</name>
--<value>6709</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_CRM_PROTOCOL_ALREADY_EXISTS</name>
--<value>6710</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_TRANSACTION_PROPAGATION_FAILED</name>
--<value>6711</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_CRM_PROTOCOL_NOT_FOUND</name>
--<value>6712</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_TRANSACTION_INVALID_MARSHALL_BUFFER</name>
--<value>6713</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_CURRENT_TRANSACTION_NOT_VALID</name>
--<value>6714</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_TRANSACTION_NOT_FOUND</name>
--<value>6715</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_RESOURCEMANAGER_NOT_FOUND</name>
--<value>6716</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_ENLISTMENT_NOT_FOUND</name>
--<value>6717</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_TRANSACTIONMANAGER_NOT_FOUND</name>
--<value>6718</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_TRANSACTIONMANAGER_NOT_ONLINE</name>
--<value>6719</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_TRANSACTIONMANAGER_RECOVERY_NAME_COLLISION</name>
--<value>6720</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_TRANSACTION_NOT_ROOT</name>
--<value>6721</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_TRANSACTION_OBJECT_EXPIRED</name>
--<value>6722</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_TRANSACTION_RESPONSE_NOT_ENLISTED</name>
--<value>6723</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_TRANSACTION_RECORD_TOO_LONG</name>
--<value>6724</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_IMPLICIT_TRANSACTION_NOT_SUPPORTED</name>
--<value>6725</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_TRANSACTION_INTEGRITY_VIOLATED</name>
--<value>6726</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_TRANSACTIONMANAGER_IDENTITY_MISMATCH</name>
--<value>6727</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_RM_CANNOT_BE_FROZEN_FOR_SNAPSHOT</name>
--<value>6728</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_TRANSACTION_MUST_WRITETHROUGH</name>
--<value>6729</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_TRANSACTION_NO_SUPERIOR</name>
--<value>6730</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_HEURISTIC_DAMAGE_POSSIBLE</name>
--<value>6731</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_TRANSACTIONAL_CONFLICT</name>
--<value>6800</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_RM_NOT_ACTIVE</name>
--<value>6801</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_RM_METADATA_CORRUPT</name>
--<value>6802</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_DIRECTORY_NOT_RM</name>
--<value>6803</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_TRANSACTIONS_UNSUPPORTED_REMOTE</name>
--<value>6805</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_LOG_RESIZE_INVALID_SIZE</name>
--<value>6806</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_OBJECT_NO_LONGER_EXISTS</name>
--<value>6807</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_STREAM_MINIVERSION_NOT_FOUND</name>
--<value>6808</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_STREAM_MINIVERSION_NOT_VALID</name>
--<value>6809</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_MINIVERSION_INACCESSIBLE_FROM_SPECIFIED_TRANSACTION</name>
--<value>6810</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_CANT_OPEN_MINIVERSION_WITH_MODIFY_INTENT</name>
--<value>6811</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_CANT_CREATE_MORE_STREAM_MINIVERSIONS</name>
--<value>6812</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_REMOTE_FILE_VERSION_MISMATCH</name>
--<value>6814</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_HANDLE_NO_LONGER_VALID</name>
--<value>6815</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_NO_TXF_METADATA</name>
--<value>6816</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_LOG_CORRUPTION_DETECTED</name>
--<value>6817</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_CANT_RECOVER_WITH_HANDLE_OPEN</name>
--<value>6818</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_RM_DISCONNECTED</name>
--<value>6819</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_ENLISTMENT_NOT_SUPERIOR</name>
--<value>6820</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_RECOVERY_NOT_NEEDED</name>
--<value>6821</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_RM_ALREADY_STARTED</name>
--<value>6822</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_FILE_IDENTITY_NOT_PERSISTENT</name>
--<value>6823</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_CANT_BREAK_TRANSACTIONAL_DEPENDENCY</name>
--<value>6824</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_CANT_CROSS_RM_BOUNDARY</name>
--<value>6825</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_TXF_DIR_NOT_EMPTY</name>
--<value>6826</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_INDOUBT_TRANSACTIONS_EXIST</name>
--<value>6827</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_TM_VOLATILE</name>
--<value>6828</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_ROLLBACK_TIMER_EXPIRED</name>
--<value>6829</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_TXF_ATTRIBUTE_CORRUPT</name>
--<value>6830</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_EFS_NOT_ALLOWED_IN_TRANSACTION</name>
--<value>6831</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_TRANSACTIONAL_OPEN_NOT_ALLOWED</name>
--<value>6832</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_LOG_GROWTH_FAILED</name>
--<value>6833</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_TRANSACTED_MAPPING_UNSUPPORTED_REMOTE</name>
--<value>6834</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_TXF_METADATA_ALREADY_PRESENT</name>
--<value>6835</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_TRANSACTION_SCOPE_CALLBACKS_NOT_SET</name>
--<value>6836</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_TRANSACTION_REQUIRED_PROMOTION</name>
--<value>6837</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_CANNOT_EXECUTE_FILE_IN_TRANSACTION</name>
--<value>6838</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_TRANSACTIONS_NOT_FROZEN</name>
--<value>6839</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_TRANSACTION_FREEZE_IN_PROGRESS</name>
--<value>6840</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_NOT_SNAPSHOT_VOLUME</name>
--<value>6841</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_NO_SAVEPOINT_WITH_OPEN_FILES</name>
--<value>6842</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_DATA_LOST_REPAIR</name>
--<value>6843</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_SPARSE_NOT_ALLOWED_IN_TRANSACTION</name>
--<value>6844</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_TM_IDENTITY_MISMATCH</name>
--<value>6845</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_FLOATED_SECTION</name>
--<value>6846</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_CANNOT_ACCEPT_TRANSACTED_WORK</name>
--<value>6847</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_CANNOT_ABORT_TRANSACTIONS</name>
--<value>6848</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_BAD_CLUSTERS</name>
--<value>6849</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_COMPRESSION_NOT_ALLOWED_IN_TRANSACTION</name>
--<value>6850</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_VOLUME_DIRTY</name>
--<value>6851</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_NO_LINK_TRACKING_IN_TRANSACTION</name>
--<value>6852</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_OPERATION_NOT_SUPPORTED_IN_TRANSACTION</name>
--<value>6853</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_EXPIRED_HANDLE</name>
--<value>6854</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_TRANSACTION_NOT_ENLISTED</name>
--<value>6855</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_CTX_WINSTATION_NAME_INVALID</name>
--<value>7001</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_CTX_INVALID_PD</name>
--<value>7002</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_CTX_PD_NOT_FOUND</name>
--<value>7003</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_CTX_WD_NOT_FOUND</name>
--<value>7004</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_CTX_CANNOT_MAKE_EVENTLOG_ENTRY</name>
--<value>7005</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_CTX_SERVICE_NAME_COLLISION</name>
--<value>7006</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_CTX_CLOSE_PENDING</name>
--<value>7007</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_CTX_NO_OUTBUF</name>
--<value>7008</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_CTX_MODEM_INF_NOT_FOUND</name>
--<value>7009</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_CTX_INVALID_MODEMNAME</name>
--<value>7010</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_CTX_MODEM_RESPONSE_ERROR</name>
--<value>7011</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_CTX_MODEM_RESPONSE_TIMEOUT</name>
--<value>7012</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_CTX_MODEM_RESPONSE_NO_CARRIER</name>
--<value>7013</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_CTX_MODEM_RESPONSE_NO_DIALTONE</name>
--<value>7014</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_CTX_MODEM_RESPONSE_BUSY</name>
--<value>7015</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_CTX_MODEM_RESPONSE_VOICE</name>
--<value>7016</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_CTX_TD_ERROR</name>
--<value>7017</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_CTX_WINSTATION_NOT_FOUND</name>
--<value>7022</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_CTX_WINSTATION_ALREADY_EXISTS</name>
--<value>7023</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_CTX_WINSTATION_BUSY</name>
--<value>7024</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_CTX_BAD_VIDEO_MODE</name>
--<value>7025</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_CTX_GRAPHICS_INVALID</name>
--<value>7035</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_CTX_LOGON_DISABLED</name>
--<value>7037</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_CTX_NOT_CONSOLE</name>
--<value>7038</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_CTX_CLIENT_QUERY_TIMEOUT</name>
--<value>7040</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_CTX_CONSOLE_DISCONNECT</name>
--<value>7041</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_CTX_CONSOLE_CONNECT</name>
--<value>7042</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_CTX_SHADOW_DENIED</name>
--<value>7044</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_CTX_WINSTATION_ACCESS_DENIED</name>
--<value>7045</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_CTX_INVALID_WD</name>
--<value>7049</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_CTX_SHADOW_INVALID</name>
--<value>7050</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_CTX_SHADOW_DISABLED</name>
--<value>7051</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_CTX_CLIENT_LICENSE_IN_USE</name>
--<value>7052</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_CTX_CLIENT_LICENSE_NOT_SET</name>
--<value>7053</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_CTX_LICENSE_NOT_AVAILABLE</name>
--<value>7054</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_CTX_LICENSE_CLIENT_INVALID</name>
--<value>7055</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_CTX_LICENSE_EXPIRED</name>
--<value>7056</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_CTX_SHADOW_NOT_RUNNING</name>
--<value>7057</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_CTX_SHADOW_ENDED_BY_MODE_CHANGE</name>
--<value>7058</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_ACTIVATION_COUNT_EXCEEDED</name>
--<value>7059</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_CTX_WINSTATIONS_DISABLED</name>
--<value>7060</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_CTX_ENCRYPTION_LEVEL_REQUIRED</name>
--<value>7061</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_CTX_SESSION_IN_USE</name>
--<value>7062</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_CTX_NO_FORCE_LOGOFF</name>
--<value>7063</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_CTX_ACCOUNT_RESTRICTION</name>
--<value>7064</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_RDP_PROTOCOL_ERROR</name>
--<value>7065</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_CTX_CDM_CONNECT</name>
--<value>7066</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_CTX_CDM_DISCONNECT</name>
--<value>7067</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_CTX_SECURITY_LAYER_ERROR</name>
--<value>7068</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_TS_INCOMPATIBLE_SESSIONS</name>
--<value>7069</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_TS_VIDEO_SUBSYSTEM_ERROR</name>
--<value>7070</value>
--<desc></desc>
--</constant>
--<constant>
--<name>FRS_ERR_INVALID_API_SEQUENCE</name>
--<value>8001</value>
--<desc></desc>
--</constant>
--<constant>
--<name>FRS_ERR_STARTING_SERVICE</name>
--<value>8002</value>
--<desc></desc>
--</constant>
--<constant>
--<name>FRS_ERR_STOPPING_SERVICE</name>
--<value>8003</value>
--<desc></desc>
--</constant>
--<constant>
--<name>FRS_ERR_INTERNAL_API</name>
--<value>8004</value>
--<desc></desc>
--</constant>
--<constant>
--<name>FRS_ERR_INTERNAL</name>
--<value>8005</value>
--<desc></desc>
--</constant>
--<constant>
--<name>FRS_ERR_SERVICE_COMM</name>
--<value>8006</value>
--<desc></desc>
--</constant>
--<constant>
--<name>FRS_ERR_INSUFFICIENT_PRIV</name>
--<value>8007</value>
--<desc></desc>
--</constant>
--<constant>
--<name>FRS_ERR_AUTHENTICATION</name>
--<value>8008</value>
--<desc></desc>
--</constant>
--<constant>
--<name>FRS_ERR_PARENT_INSUFFICIENT_PRIV</name>
--<value>8009</value>
--<desc></desc>
--</constant>
--<constant>
--<name>FRS_ERR_PARENT_AUTHENTICATION</name>
--<value>8010</value>
--<desc></desc>
--</constant>
--<constant>
--<name>FRS_ERR_CHILD_TO_PARENT_COMM</name>
--<value>8011</value>
--<desc></desc>
--</constant>
--<constant>
--<name>FRS_ERR_PARENT_TO_CHILD_COMM</name>
--<value>8012</value>
--<desc></desc>
--</constant>
--<constant>
--<name>FRS_ERR_SYSVOL_POPULATE</name>
--<value>8013</value>
--<desc></desc>
--</constant>
--<constant>
--<name>FRS_ERR_SYSVOL_POPULATE_TIMEOUT</name>
--<value>8014</value>
--<desc></desc>
--</constant>
--<constant>
--<name>FRS_ERR_SYSVOL_IS_BUSY</name>
--<value>8015</value>
--<desc></desc>
--</constant>
--<constant>
--<name>FRS_ERR_SYSVOL_DEMOTE</name>
--<value>8016</value>
--<desc></desc>
--</constant>
--<constant>
--<name>FRS_ERR_INVALID_SERVICE_PARAMETER</name>
--<value>8017</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_DS_NOT_INSTALLED</name>
--<value>8200</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_DS_MEMBERSHIP_EVALUATED_LOCALLY</name>
--<value>8201</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_DS_NO_ATTRIBUTE_OR_VALUE</name>
--<value>8202</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_DS_INVALID_ATTRIBUTE_SYNTAX</name>
--<value>8203</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_DS_ATTRIBUTE_TYPE_UNDEFINED</name>
--<value>8204</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_DS_ATTRIBUTE_OR_VALUE_EXISTS</name>
--<value>8205</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_DS_BUSY</name>
--<value>8206</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_DS_UNAVAILABLE</name>
--<value>8207</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_DS_NO_RIDS_ALLOCATED</name>
--<value>8208</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_DS_NO_MORE_RIDS</name>
--<value>8209</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_DS_INCORRECT_ROLE_OWNER</name>
--<value>8210</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_DS_RIDMGR_INIT_ERROR</name>
--<value>8211</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_DS_OBJ_CLASS_VIOLATION</name>
--<value>8212</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_DS_CANT_ON_NON_LEAF</name>
--<value>8213</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_DS_CANT_ON_RDN</name>
--<value>8214</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_DS_CANT_MOD_OBJ_CLASS</name>
--<value>8215</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_DS_CROSS_DOM_MOVE_ERROR</name>
--<value>8216</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_DS_GC_NOT_AVAILABLE</name>
--<value>8217</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_SHARED_POLICY</name>
--<value>8218</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_POLICY_OBJECT_NOT_FOUND</name>
--<value>8219</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_POLICY_ONLY_IN_DS</name>
--<value>8220</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_PROMOTION_ACTIVE</name>
--<value>8221</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_NO_PROMOTION_ACTIVE</name>
--<value>8222</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_DS_OPERATIONS_ERROR</name>
--<value>8224</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_DS_PROTOCOL_ERROR</name>
--<value>8225</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_DS_TIMELIMIT_EXCEEDED</name>
--<value>8226</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_DS_SIZELIMIT_EXCEEDED</name>
--<value>8227</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_DS_ADMIN_LIMIT_EXCEEDED</name>
--<value>8228</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_DS_COMPARE_FALSE</name>
--<value>8229</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_DS_COMPARE_TRUE</name>
--<value>8230</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_DS_AUTH_METHOD_NOT_SUPPORTED</name>
--<value>8231</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_DS_STRONG_AUTH_REQUIRED</name>
--<value>8232</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_DS_INAPPROPRIATE_AUTH</name>
--<value>8233</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_DS_AUTH_UNKNOWN</name>
--<value>8234</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_DS_REFERRAL</name>
--<value>8235</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_DS_UNAVAILABLE_CRIT_EXTENSION</name>
--<value>8236</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_DS_CONFIDENTIALITY_REQUIRED</name>
--<value>8237</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_DS_INAPPROPRIATE_MATCHING</name>
--<value>8238</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_DS_CONSTRAINT_VIOLATION</name>
--<value>8239</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_DS_NO_SUCH_OBJECT</name>
--<value>8240</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_DS_ALIAS_PROBLEM</name>
--<value>8241</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_DS_INVALID_DN_SYNTAX</name>
--<value>8242</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_DS_IS_LEAF</name>
--<value>8243</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_DS_ALIAS_DEREF_PROBLEM</name>
--<value>8244</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_DS_UNWILLING_TO_PERFORM</name>
--<value>8245</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_DS_LOOP_DETECT</name>
--<value>8246</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_DS_NAMING_VIOLATION</name>
--<value>8247</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_DS_OBJECT_RESULTS_TOO_LARGE</name>
--<value>8248</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_DS_AFFECTS_MULTIPLE_DSAS</name>
--<value>8249</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_DS_SERVER_DOWN</name>
--<value>8250</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_DS_LOCAL_ERROR</name>
--<value>8251</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_DS_ENCODING_ERROR</name>
--<value>8252</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_DS_DECODING_ERROR</name>
--<value>8253</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_DS_FILTER_UNKNOWN</name>
--<value>8254</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_DS_PARAM_ERROR</name>
--<value>8255</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_DS_NOT_SUPPORTED</name>
--<value>8256</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_DS_NO_RESULTS_RETURNED</name>
--<value>8257</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_DS_CONTROL_NOT_FOUND</name>
--<value>8258</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_DS_CLIENT_LOOP</name>
--<value>8259</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_DS_REFERRAL_LIMIT_EXCEEDED</name>
--<value>8260</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_DS_SORT_CONTROL_MISSING</name>
--<value>8261</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_DS_OFFSET_RANGE_ERROR</name>
--<value>8262</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_DS_ROOT_MUST_BE_NC</name>
--<value>8301</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_DS_ADD_REPLICA_INHIBITED</name>
--<value>8302</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_DS_ATT_NOT_DEF_IN_SCHEMA</name>
--<value>8303</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_DS_MAX_OBJ_SIZE_EXCEEDED</name>
--<value>8304</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_DS_OBJ_STRING_NAME_EXISTS</name>
--<value>8305</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_DS_NO_RDN_DEFINED_IN_SCHEMA</name>
--<value>8306</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_DS_RDN_DOESNT_MATCH_SCHEMA</name>
--<value>8307</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_DS_NO_REQUESTED_ATTS_FOUND</name>
--<value>8308</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_DS_USER_BUFFER_TO_SMALL</name>
--<value>8309</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_DS_ATT_IS_NOT_ON_OBJ</name>
--<value>8310</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_DS_ILLEGAL_MOD_OPERATION</name>
--<value>8311</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_DS_OBJ_TOO_LARGE</name>
--<value>8312</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_DS_BAD_INSTANCE_TYPE</name>
--<value>8313</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_DS_MASTERDSA_REQUIRED</name>
--<value>8314</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_DS_OBJECT_CLASS_REQUIRED</name>
--<value>8315</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_DS_MISSING_REQUIRED_ATT</name>
--<value>8316</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_DS_ATT_NOT_DEF_FOR_CLASS</name>
--<value>8317</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_DS_ATT_ALREADY_EXISTS</name>
--<value>8318</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_DS_CANT_ADD_ATT_VALUES</name>
--<value>8320</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_DS_SINGLE_VALUE_CONSTRAINT</name>
--<value>8321</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_DS_RANGE_CONSTRAINT</name>
--<value>8322</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_DS_ATT_VAL_ALREADY_EXISTS</name>
--<value>8323</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_DS_CANT_REM_MISSING_ATT</name>
--<value>8324</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_DS_CANT_REM_MISSING_ATT_VAL</name>
--<value>8325</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_DS_ROOT_CANT_BE_SUBREF</name>
--<value>8326</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_DS_NO_CHAINING</name>
--<value>8327</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_DS_NO_CHAINED_EVAL</name>
--<value>8328</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_DS_NO_PARENT_OBJECT</name>
--<value>8329</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_DS_PARENT_IS_AN_ALIAS</name>
--<value>8330</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_DS_CANT_MIX_MASTER_AND_REPS</name>
--<value>8331</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_DS_CHILDREN_EXIST</name>
--<value>8332</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_DS_OBJ_NOT_FOUND</name>
--<value>8333</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_DS_ALIASED_OBJ_MISSING</name>
--<value>8334</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_DS_BAD_NAME_SYNTAX</name>
--<value>8335</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_DS_ALIAS_POINTS_TO_ALIAS</name>
--<value>8336</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_DS_CANT_DEREF_ALIAS</name>
--<value>8337</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_DS_OUT_OF_SCOPE</name>
--<value>8338</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_DS_CANT_DELETE_DSA_OBJ</name>
--<value>8340</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_DS_GENERIC_ERROR</name>
--<value>8341</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_DS_DSA_MUST_BE_INT_MASTER</name>
--<value>8342</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_DS_CLASS_NOT_DSA</name>
--<value>8343</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_DS_INSUFF_ACCESS_RIGHTS</name>
--<value>8344</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_DS_ILLEGAL_SUPERIOR</name>
--<value>8345</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_DS_ATTRIBUTE_OWNED_BY_SAM</name>
--<value>8346</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_DS_NAME_TOO_MANY_PARTS</name>
--<value>8347</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_DS_NAME_TOO_LONG</name>
--<value>8348</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_DS_NAME_VALUE_TOO_LONG</name>
--<value>8349</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_DS_NAME_UNPARSEABLE</name>
--<value>8350</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_DS_NAME_TYPE_UNKNOWN</name>
--<value>8351</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_DS_NOT_AN_OBJECT</name>
--<value>8352</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_DS_SEC_DESC_TOO_SHORT</name>
--<value>8353</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_DS_SEC_DESC_INVALID</name>
--<value>8354</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_DS_NO_DELETED_NAME</name>
--<value>8355</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_DS_SUBREF_MUST_HAVE_PARENT</name>
--<value>8356</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_DS_NCNAME_MUST_BE_NC</name>
--<value>8357</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_DS_CANT_ADD_SYSTEM_ONLY</name>
--<value>8358</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_DS_CLASS_MUST_BE_CONCRETE</name>
--<value>8359</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_DS_INVALID_DMD</name>
--<value>8360</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_DS_OBJ_GUID_EXISTS</name>
--<value>8361</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_DS_NOT_ON_BACKLINK</name>
--<value>8362</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_DS_NO_CROSSREF_FOR_NC</name>
--<value>8363</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_DS_SHUTTING_DOWN</name>
--<value>8364</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_DS_UNKNOWN_OPERATION</name>
--<value>8365</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_DS_INVALID_ROLE_OWNER</name>
--<value>8366</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_DS_COULDNT_CONTACT_FSMO</name>
--<value>8367</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_DS_CROSS_NC_DN_RENAME</name>
--<value>8368</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_DS_CANT_MOD_SYSTEM_ONLY</name>
--<value>8369</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_DS_REPLICATOR_ONLY</name>
--<value>8370</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_DS_OBJ_CLASS_NOT_DEFINED</name>
--<value>8371</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_DS_OBJ_CLASS_NOT_SUBCLASS</name>
--<value>8372</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_DS_NAME_REFERENCE_INVALID</name>
--<value>8373</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_DS_CROSS_REF_EXISTS</name>
--<value>8374</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_DS_CANT_DEL_MASTER_CROSSREF</name>
--<value>8375</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_DS_SUBTREE_NOTIFY_NOT_NC_HEAD</name>
--<value>8376</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_DS_NOTIFY_FILTER_TOO_COMPLEX</name>
--<value>8377</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_DS_DUP_RDN</name>
--<value>8378</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_DS_DUP_OID</name>
--<value>8379</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_DS_DUP_MAPI_ID</name>
--<value>8380</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_DS_DUP_SCHEMA_ID_GUID</name>
--<value>8381</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_DS_DUP_LDAP_DISPLAY_NAME</name>
--<value>8382</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_DS_SEMANTIC_ATT_TEST</name>
--<value>8383</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_DS_SYNTAX_MISMATCH</name>
--<value>8384</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_DS_EXISTS_IN_MUST_HAVE</name>
--<value>8385</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_DS_EXISTS_IN_MAY_HAVE</name>
--<value>8386</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_DS_NONEXISTENT_MAY_HAVE</name>
--<value>8387</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_DS_NONEXISTENT_MUST_HAVE</name>
--<value>8388</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_DS_AUX_CLS_TEST_FAIL</name>
--<value>8389</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_DS_NONEXISTENT_POSS_SUP</name>
--<value>8390</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_DS_SUB_CLS_TEST_FAIL</name>
--<value>8391</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_DS_BAD_RDN_ATT_ID_SYNTAX</name>
--<value>8392</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_DS_EXISTS_IN_AUX_CLS</name>
--<value>8393</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_DS_EXISTS_IN_SUB_CLS</name>
--<value>8394</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_DS_EXISTS_IN_POSS_SUP</name>
--<value>8395</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_DS_RECALCSCHEMA_FAILED</name>
--<value>8396</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_DS_TREE_DELETE_NOT_FINISHED</name>
--<value>8397</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_DS_CANT_DELETE</name>
--<value>8398</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_DS_ATT_SCHEMA_REQ_ID</name>
--<value>8399</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_DS_BAD_ATT_SCHEMA_SYNTAX</name>
--<value>8400</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_DS_CANT_CACHE_ATT</name>
--<value>8401</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_DS_CANT_CACHE_CLASS</name>
--<value>8402</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_DS_CANT_REMOVE_ATT_CACHE</name>
--<value>8403</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_DS_CANT_REMOVE_CLASS_CACHE</name>
--<value>8404</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_DS_CANT_RETRIEVE_DN</name>
--<value>8405</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_DS_MISSING_SUPREF</name>
--<value>8406</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_DS_CANT_RETRIEVE_INSTANCE</name>
--<value>8407</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_DS_CODE_INCONSISTENCY</name>
--<value>8408</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_DS_DATABASE_ERROR</name>
--<value>8409</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_DS_GOVERNSID_MISSING</name>
--<value>8410</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_DS_MISSING_EXPECTED_ATT</name>
--<value>8411</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_DS_NCNAME_MISSING_CR_REF</name>
--<value>8412</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_DS_SECURITY_CHECKING_ERROR</name>
--<value>8413</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_DS_SCHEMA_NOT_LOADED</name>
--<value>8414</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_DS_SCHEMA_ALLOC_FAILED</name>
--<value>8415</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_DS_ATT_SCHEMA_REQ_SYNTAX</name>
--<value>8416</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_DS_GCVERIFY_ERROR</name>
--<value>8417</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_DS_DRA_SCHEMA_MISMATCH</name>
--<value>8418</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_DS_CANT_FIND_DSA_OBJ</name>
--<value>8419</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_DS_CANT_FIND_EXPECTED_NC</name>
--<value>8420</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_DS_CANT_FIND_NC_IN_CACHE</name>
--<value>8421</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_DS_CANT_RETRIEVE_CHILD</name>
--<value>8422</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_DS_SECURITY_ILLEGAL_MODIFY</name>
--<value>8423</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_DS_CANT_REPLACE_HIDDEN_REC</name>
--<value>8424</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_DS_BAD_HIERARCHY_FILE</name>
--<value>8425</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_DS_BUILD_HIERARCHY_TABLE_FAILED</name>
--<value>8426</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_DS_CONFIG_PARAM_MISSING</name>
--<value>8427</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_DS_COUNTING_AB_INDICES_FAILED</name>
--<value>8428</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_DS_HIERARCHY_TABLE_MALLOC_FAILED</name>
--<value>8429</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_DS_INTERNAL_FAILURE</name>
--<value>8430</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_DS_UNKNOWN_ERROR</name>
--<value>8431</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_DS_ROOT_REQUIRES_CLASS_TOP</name>
--<value>8432</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_DS_REFUSING_FSMO_ROLES</name>
--<value>8433</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_DS_MISSING_FSMO_SETTINGS</name>
--<value>8434</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_DS_UNABLE_TO_SURRENDER_ROLES</name>
--<value>8435</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_DS_DRA_GENERIC</name>
--<value>8436</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_DS_DRA_INVALID_PARAMETER</name>
--<value>8437</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_DS_DRA_BUSY</name>
--<value>8438</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_DS_DRA_BAD_DN</name>
--<value>8439</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_DS_DRA_BAD_NC</name>
--<value>8440</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_DS_DRA_DN_EXISTS</name>
--<value>8441</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_DS_DRA_INTERNAL_ERROR</name>
--<value>8442</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_DS_DRA_INCONSISTENT_DIT</name>
--<value>8443</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_DS_DRA_CONNECTION_FAILED</name>
--<value>8444</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_DS_DRA_BAD_INSTANCE_TYPE</name>
--<value>8445</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_DS_DRA_OUT_OF_MEM</name>
--<value>8446</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_DS_DRA_MAIL_PROBLEM</name>
--<value>8447</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_DS_DRA_REF_ALREADY_EXISTS</name>
--<value>8448</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_DS_DRA_REF_NOT_FOUND</name>
--<value>8449</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_DS_DRA_OBJ_IS_REP_SOURCE</name>
--<value>8450</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_DS_DRA_DB_ERROR</name>
--<value>8451</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_DS_DRA_NO_REPLICA</name>
--<value>8452</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_DS_DRA_ACCESS_DENIED</name>
--<value>8453</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_DS_DRA_NOT_SUPPORTED</name>
--<value>8454</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_DS_DRA_RPC_CANCELLED</name>
--<value>8455</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_DS_DRA_SOURCE_DISABLED</name>
--<value>8456</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_DS_DRA_SINK_DISABLED</name>
--<value>8457</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_DS_DRA_NAME_COLLISION</name>
--<value>8458</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_DS_DRA_SOURCE_REINSTALLED</name>
--<value>8459</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_DS_DRA_MISSING_PARENT</name>
--<value>8460</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_DS_DRA_PREEMPTED</name>
--<value>8461</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_DS_DRA_ABANDON_SYNC</name>
--<value>8462</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_DS_DRA_SHUTDOWN</name>
--<value>8463</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_DS_DRA_INCOMPATIBLE_PARTIAL_SET</name>
--<value>8464</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_DS_DRA_SOURCE_IS_PARTIAL_REPLICA</name>
--<value>8465</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_DS_DRA_EXTN_CONNECTION_FAILED</name>
--<value>8466</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_DS_INSTALL_SCHEMA_MISMATCH</name>
--<value>8467</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_DS_DUP_LINK_ID</name>
--<value>8468</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_DS_NAME_ERROR_RESOLVING</name>
--<value>8469</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_DS_NAME_ERROR_NOT_FOUND</name>
--<value>8470</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_DS_NAME_ERROR_NOT_UNIQUE</name>
--<value>8471</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_DS_NAME_ERROR_NO_MAPPING</name>
--<value>8472</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_DS_NAME_ERROR_DOMAIN_ONLY</name>
--<value>8473</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_DS_NAME_ERROR_NO_SYNTACTICAL_MAPPING</name>
--<value>8474</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_DS_CONSTRUCTED_ATT_MOD</name>
--<value>8475</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_DS_WRONG_OM_OBJ_CLASS</name>
--<value>8476</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_DS_DRA_REPL_PENDING</name>
--<value>8477</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_DS_DS_REQUIRED</name>
--<value>8478</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_DS_INVALID_LDAP_DISPLAY_NAME</name>
--<value>8479</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_DS_NON_BASE_SEARCH</name>
--<value>8480</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_DS_CANT_RETRIEVE_ATTS</name>
--<value>8481</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_DS_BACKLINK_WITHOUT_LINK</name>
--<value>8482</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_DS_EPOCH_MISMATCH</name>
--<value>8483</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_DS_SRC_NAME_MISMATCH</name>
--<value>8484</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_DS_SRC_AND_DST_NC_IDENTICAL</name>
--<value>8485</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_DS_DST_NC_MISMATCH</name>
--<value>8486</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_DS_NOT_AUTHORITIVE_FOR_DST_NC</name>
--<value>8487</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_DS_SRC_GUID_MISMATCH</name>
--<value>8488</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_DS_CANT_MOVE_DELETED_OBJECT</name>
--<value>8489</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_DS_PDC_OPERATION_IN_PROGRESS</name>
--<value>8490</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_DS_CROSS_DOMAIN_CLEANUP_REQD</name>
--<value>8491</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_DS_ILLEGAL_XDOM_MOVE_OPERATION</name>
--<value>8492</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_DS_CANT_WITH_ACCT_GROUP_MEMBERSHPS</name>
--<value>8493</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_DS_NC_MUST_HAVE_NC_PARENT</name>
--<value>8494</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_DS_CR_IMPOSSIBLE_TO_VALIDATE</name>
--<value>8495</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_DS_DST_DOMAIN_NOT_NATIVE</name>
--<value>8496</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_DS_MISSING_INFRASTRUCTURE_CONTAINER</name>
--<value>8497</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_DS_CANT_MOVE_ACCOUNT_GROUP</name>
--<value>8498</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_DS_CANT_MOVE_RESOURCE_GROUP</name>
--<value>8499</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_DS_INVALID_SEARCH_FLAG</name>
--<value>8500</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_DS_NO_TREE_DELETE_ABOVE_NC</name>
--<value>8501</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_DS_COULDNT_LOCK_TREE_FOR_DELETE</name>
--<value>8502</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_DS_COULDNT_IDENTIFY_OBJECTS_FOR_TREE_DELETE</name>
--<value>8503</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_DS_SAM_INIT_FAILURE</name>
--<value>8504</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_DS_SENSITIVE_GROUP_VIOLATION</name>
--<value>8505</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_DS_CANT_MOD_PRIMARYGROUPID</name>
--<value>8506</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_DS_ILLEGAL_BASE_SCHEMA_MOD</name>
--<value>8507</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_DS_NONSAFE_SCHEMA_CHANGE</name>
--<value>8508</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_DS_SCHEMA_UPDATE_DISALLOWED</name>
--<value>8509</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_DS_CANT_CREATE_UNDER_SCHEMA</name>
--<value>8510</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_DS_INSTALL_NO_SRC_SCH_VERSION</name>
--<value>8511</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_DS_INSTALL_NO_SCH_VERSION_IN_INIFILE</name>
--<value>8512</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_DS_INVALID_GROUP_TYPE</name>
--<value>8513</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_DS_NO_NEST_GLOBALGROUP_IN_MIXEDDOMAIN</name>
--<value>8514</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_DS_NO_NEST_LOCALGROUP_IN_MIXEDDOMAIN</name>
--<value>8515</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_DS_GLOBAL_CANT_HAVE_LOCAL_MEMBER</name>
--<value>8516</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_DS_GLOBAL_CANT_HAVE_UNIVERSAL_MEMBER</name>
--<value>8517</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_DS_UNIVERSAL_CANT_HAVE_LOCAL_MEMBER</name>
--<value>8518</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_DS_GLOBAL_CANT_HAVE_CROSSDOMAIN_MEMBER</name>
--<value>8519</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_DS_LOCAL_CANT_HAVE_CROSSDOMAIN_LOCAL_MEMBER</name>
--<value>8520</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_DS_HAVE_PRIMARY_MEMBERS</name>
--<value>8521</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_DS_STRING_SD_CONVERSION_FAILED</name>
--<value>8522</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_DS_NAMING_MASTER_GC</name>
--<value>8523</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_DS_LOOKUP_FAILURE</name>
--<value>8524</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_DS_COULDNT_UPDATE_SPNS</name>
--<value>8525</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_DS_CANT_RETRIEVE_SD</name>
--<value>8526</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_DS_KEY_NOT_UNIQUE</name>
--<value>8527</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_DS_WRONG_LINKED_ATT_SYNTAX</name>
--<value>8528</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_DS_SAM_NEED_BOOTKEY_PASSWORD</name>
--<value>8529</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_DS_SAM_NEED_BOOTKEY_FLOPPY</name>
--<value>8530</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_DS_CANT_START</name>
--<value>8531</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_DS_INIT_FAILURE</name>
--<value>8532</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_DS_NO_PKT_PRIVACY_ON_CONNECTION</name>
--<value>8533</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_DS_SOURCE_DOMAIN_IN_FOREST</name>
--<value>8534</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_DS_DESTINATION_DOMAIN_NOT_IN_FOREST</name>
--<value>8535</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_DS_DESTINATION_AUDITING_NOT_ENABLED</name>
--<value>8536</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_DS_CANT_FIND_DC_FOR_SRC_DOMAIN</name>
--<value>8537</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_DS_SRC_OBJ_NOT_GROUP_OR_USER</name>
--<value>8538</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_DS_SRC_SID_EXISTS_IN_FOREST</name>
--<value>8539</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_DS_SRC_AND_DST_OBJECT_CLASS_MISMATCH</name>
--<value>8540</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_SAM_INIT_FAILURE</name>
--<value>8541</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_DS_DRA_SCHEMA_INFO_SHIP</name>
--<value>8542</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_DS_DRA_SCHEMA_CONFLICT</name>
--<value>8543</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_DS_DRA_EARLIER_SCHEMA_CONLICT</name>
--<value>8544</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_DS_DRA_OBJ_NC_MISMATCH</name>
--<value>8545</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_DS_NC_STILL_HAS_DSAS</name>
--<value>8546</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_DS_GC_REQUIRED</name>
--<value>8547</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_DS_LOCAL_MEMBER_OF_LOCAL_ONLY</name>
--<value>8548</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_DS_NO_FPO_IN_UNIVERSAL_GROUPS</name>
--<value>8549</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_DS_CANT_ADD_TO_GC</name>
--<value>8550</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_DS_NO_CHECKPOINT_WITH_PDC</name>
--<value>8551</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_DS_SOURCE_AUDITING_NOT_ENABLED</name>
--<value>8552</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_DS_CANT_CREATE_IN_NONDOMAIN_NC</name>
--<value>8553</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_DS_INVALID_NAME_FOR_SPN</name>
--<value>8554</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_DS_FILTER_USES_CONTRUCTED_ATTRS</name>
--<value>8555</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_DS_UNICODEPWD_NOT_IN_QUOTES</name>
--<value>8556</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_DS_MACHINE_ACCOUNT_QUOTA_EXCEEDED</name>
--<value>8557</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_DS_MUST_BE_RUN_ON_DST_DC</name>
--<value>8558</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_DS_SRC_DC_MUST_BE_SP4_OR_GREATER</name>
--<value>8559</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_DS_CANT_TREE_DELETE_CRITICAL_OBJ</name>
--<value>8560</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_DS_INIT_FAILURE_CONSOLE</name>
--<value>8561</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_DS_SAM_INIT_FAILURE_CONSOLE</name>
--<value>8562</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_DS_FOREST_VERSION_TOO_HIGH</name>
--<value>8563</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_DS_DOMAIN_VERSION_TOO_HIGH</name>
--<value>8564</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_DS_FOREST_VERSION_TOO_LOW</name>
--<value>8565</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_DS_DOMAIN_VERSION_TOO_LOW</name>
--<value>8566</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_DS_INCOMPATIBLE_VERSION</name>
--<value>8567</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_DS_LOW_DSA_VERSION</name>
--<value>8568</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_DS_NO_BEHAVIOR_VERSION_IN_MIXEDDOMAIN</name>
--<value>8569</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_DS_NOT_SUPPORTED_SORT_ORDER</name>
--<value>8570</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_DS_NAME_NOT_UNIQUE</name>
--<value>8571</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_DS_MACHINE_ACCOUNT_CREATED_PRENT4</name>
--<value>8572</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_DS_OUT_OF_VERSION_STORE</name>
--<value>8573</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_DS_INCOMPATIBLE_CONTROLS_USED</name>
--<value>8574</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_DS_NO_REF_DOMAIN</name>
--<value>8575</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_DS_RESERVED_LINK_ID</name>
--<value>8576</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_DS_LINK_ID_NOT_AVAILABLE</name>
--<value>8577</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_DS_AG_CANT_HAVE_UNIVERSAL_MEMBER</name>
--<value>8578</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_DS_MODIFYDN_DISALLOWED_BY_INSTANCE_TYPE</name>
--<value>8579</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_DS_NO_OBJECT_MOVE_IN_SCHEMA_NC</name>
--<value>8580</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_DS_MODIFYDN_DISALLOWED_BY_FLAG</name>
--<value>8581</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_DS_MODIFYDN_WRONG_GRANDPARENT</name>
--<value>8582</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_DS_NAME_ERROR_TRUST_REFERRAL</name>
--<value>8583</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_NOT_SUPPORTED_ON_STANDARD_SERVER</name>
--<value>8584</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_DS_CANT_ACCESS_REMOTE_PART_OF_AD</name>
--<value>8585</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_DS_CR_IMPOSSIBLE_TO_VALIDATE_V2</name>
--<value>8586</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_DS_THREAD_LIMIT_EXCEEDED</name>
--<value>8587</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_DS_NOT_CLOSEST</name>
--<value>8588</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_DS_CANT_DERIVE_SPN_WITHOUT_SERVER_REF</name>
--<value>8589</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_DS_SINGLE_USER_MODE_FAILED</name>
--<value>8590</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_DS_NTDSCRIPT_SYNTAX_ERROR</name>
--<value>8591</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_DS_NTDSCRIPT_PROCESS_ERROR</name>
--<value>8592</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_DS_DIFFERENT_REPL_EPOCHS</name>
--<value>8593</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_DS_DRS_EXTENSIONS_CHANGED</name>
--<value>8594</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_DS_REPLICA_SET_CHANGE_NOT_ALLOWED_ON_DISABLED_CR</name>
--<value>8595</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_DS_NO_MSDS_INTID</name>
--<value>8596</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_DS_DUP_MSDS_INTID</name>
--<value>8597</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_DS_EXISTS_IN_RDNATTID</name>
--<value>8598</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_DS_AUTHORIZATION_FAILED</name>
--<value>8599</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_DS_INVALID_SCRIPT</name>
--<value>8600</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_DS_REMOTE_CROSSREF_OP_FAILED</name>
--<value>8601</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_DS_CROSS_REF_BUSY</name>
--<value>8602</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_DS_CANT_DERIVE_SPN_FOR_DELETED_DOMAIN</name>
--<value>8603</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_DS_CANT_DEMOTE_WITH_WRITEABLE_NC</name>
--<value>8604</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_DS_DUPLICATE_ID_FOUND</name>
--<value>8605</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_DS_INSUFFICIENT_ATTR_TO_CREATE_OBJECT</name>
--<value>8606</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_DS_GROUP_CONVERSION_ERROR</name>
--<value>8607</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_DS_CANT_MOVE_APP_BASIC_GROUP</name>
--<value>8608</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_DS_CANT_MOVE_APP_QUERY_GROUP</name>
--<value>8609</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_DS_ROLE_NOT_VERIFIED</name>
--<value>8610</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_DS_WKO_CONTAINER_CANNOT_BE_SPECIAL</name>
--<value>8611</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_DS_DOMAIN_RENAME_IN_PROGRESS</name>
--<value>8612</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_DS_EXISTING_AD_CHILD_NC</name>
--<value>8613</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_DS_REPL_LIFETIME_EXCEEDED</name>
--<value>8614</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_DS_DISALLOWED_IN_SYSTEM_CONTAINER</name>
--<value>8615</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_DS_LDAP_SEND_QUEUE_FULL</name>
--<value>8616</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_DS_DRA_OUT_SCHEDULE_WINDOW</name>
--<value>8617</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_DS_POLICY_NOT_KNOWN</name>
--<value>8618</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_NO_SITE_SETTINGS_OBJECT</name>
--<value>8619</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_NO_SECRETS</name>
--<value>8620</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_NO_WRITABLE_DC_FOUND</name>
--<value>8621</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_DS_NO_SERVER_OBJECT</name>
--<value>8622</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_DS_NO_NTDSA_OBJECT</name>
--<value>8623</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_DS_NON_ASQ_SEARCH</name>
--<value>8624</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_DS_AUDIT_FAILURE</name>
--<value>8625</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_DS_INVALID_SEARCH_FLAG_SUBTREE</name>
--<value>8626</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_DS_INVALID_SEARCH_FLAG_TUPLE</name>
--<value>8627</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_DS_HIERARCHY_TABLE_TOO_DEEP</name>
--<value>8628</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_DS_DRA_CORRUPT_UTD_VECTOR</name>
--<value>8629</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_DS_DRA_SECRETS_DENIED</name>
--<value>8630</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_DS_RESERVED_MAPI_ID</name>
--<value>8631</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_DS_MAPI_ID_NOT_AVAILABLE</name>
--<value>8632</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_DS_DRA_MISSING_KRBTGT_SECRET</name>
--<value>8633</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_DS_DOMAIN_NAME_EXISTS_IN_FOREST</name>
--<value>8634</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_DS_FLAT_NAME_EXISTS_IN_FOREST</name>
--<value>8635</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_INVALID_USER_PRINCIPAL_NAME</name>
--<value>8636</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_DS_OID_MAPPED_GROUP_CANT_HAVE_MEMBERS</name>
--<value>8637</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_DS_OID_NOT_FOUND</name>
--<value>8638</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_DS_DRA_RECYCLED_TARGET</name>
--<value>8639</value>
--<desc></desc>
--</constant>
--<constant>
--<name>DNS_ERROR_RCODE_FORMAT_ERROR</name>
--<value>9001</value>
--<desc></desc>
--</constant>
--<constant>
--<name>DNS_ERROR_RCODE_SERVER_FAILURE</name>
--<value>9002</value>
--<desc></desc>
--</constant>
--<constant>
--<name>DNS_ERROR_RCODE_NAME_ERROR</name>
--<value>9003</value>
--<desc></desc>
--</constant>
--<constant>
--<name>DNS_ERROR_RCODE_NOT_IMPLEMENTED</name>
--<value>9004</value>
--<desc></desc>
--</constant>
--<constant>
--<name>DNS_ERROR_RCODE_REFUSED</name>
--<value>9005</value>
--<desc></desc>
--</constant>
--<constant>
--<name>DNS_ERROR_RCODE_YXDOMAIN</name>
--<value>9006</value>
--<desc></desc>
--</constant>
--<constant>
--<name>DNS_ERROR_RCODE_YXRRSET</name>
--<value>9007</value>
--<desc></desc>
--</constant>
--<constant>
--<name>DNS_ERROR_RCODE_NXRRSET</name>
--<value>9008</value>
--<desc></desc>
--</constant>
--<constant>
--<name>DNS_ERROR_RCODE_NOTAUTH</name>
--<value>9009</value>
--<desc></desc>
--</constant>
--<constant>
--<name>DNS_ERROR_RCODE_NOTZONE</name>
--<value>9010</value>
--<desc></desc>
--</constant>
--<constant>
--<name>DNS_ERROR_RCODE_BADSIG</name>
--<value>9016</value>
--<desc></desc>
--</constant>
--<constant>
--<name>DNS_ERROR_RCODE_BADKEY</name>
--<value>9017</value>
--<desc></desc>
--</constant>
--<constant>
--<name>DNS_ERROR_RCODE_BADTIME</name>
--<value>9018</value>
--<desc></desc>
--</constant>
--<constant>
--<name>DNS_INFO_NO_RECORDS</name>
--<value>9501</value>
--<desc></desc>
--</constant>
--<constant>
--<name>DNS_ERROR_BAD_PACKET</name>
--<value>9502</value>
--<desc></desc>
--</constant>
--<constant>
--<name>DNS_ERROR_NO_PACKET</name>
--<value>9503</value>
--<desc></desc>
--</constant>
--<constant>
--<name>DNS_ERROR_RCODE</name>
--<value>9504</value>
--<desc></desc>
--</constant>
--<constant>
--<name>DNS_ERROR_UNSECURE_PACKET</name>
--<value>9505</value>
--<desc></desc>
--</constant>
--<constant>
--<name>DNS_ERROR_INVALID_TYPE</name>
--<value>9551</value>
--<desc></desc>
--</constant>
--<constant>
--<name>DNS_ERROR_INVALID_IP_ADDRESS</name>
--<value>9552</value>
--<desc></desc>
--</constant>
--<constant>
--<name>DNS_ERROR_INVALID_PROPERTY</name>
--<value>9553</value>
--<desc></desc>
--</constant>
--<constant>
--<name>DNS_ERROR_TRY_AGAIN_LATER</name>
--<value>9554</value>
--<desc></desc>
--</constant>
--<constant>
--<name>DNS_ERROR_NOT_UNIQUE</name>
--<value>9555</value>
--<desc></desc>
--</constant>
--<constant>
--<name>DNS_ERROR_NON_RFC_NAME</name>
--<value>9556</value>
--<desc></desc>
--</constant>
--<constant>
--<name>DNS_STATUS_FQDN</name>
--<value>9557</value>
--<desc></desc>
--</constant>
--<constant>
--<name>DNS_STATUS_DOTTED_NAME</name>
--<value>9558</value>
--<desc></desc>
--</constant>
--<constant>
--<name>DNS_STATUS_SINGLE_PART_NAME</name>
--<value>9559</value>
--<desc></desc>
--</constant>
--<constant>
--<name>DNS_ERROR_INVALID_NAME_CHAR</name>
--<value>9560</value>
--<desc></desc>
--</constant>
--<constant>
--<name>DNS_ERROR_NUMERIC_NAME</name>
--<value>9561</value>
--<desc></desc>
--</constant>
--<constant>
--<name>DNS_ERROR_NOT_ALLOWED_ON_ROOT_SERVER</name>
--<value>9562</value>
--<desc></desc>
--</constant>
--<constant>
--<name>DNS_ERROR_NOT_ALLOWED_UNDER_DELEGATION</name>
--<value>9563</value>
--<desc></desc>
--</constant>
--<constant>
--<name>DNS_ERROR_CANNOT_FIND_ROOT_HINTS</name>
--<value>9564</value>
--<desc></desc>
--</constant>
--<constant>
--<name>DNS_ERROR_INCONSISTENT_ROOT_HINTS</name>
--<value>9565</value>
--<desc></desc>
--</constant>
--<constant>
--<name>DNS_ERROR_DWORD_VALUE_TOO_SMALL</name>
--<value>9566</value>
--<desc></desc>
--</constant>
--<constant>
--<name>DNS_ERROR_DWORD_VALUE_TOO_LARGE</name>
--<value>9567</value>
--<desc></desc>
--</constant>
--<constant>
--<name>DNS_ERROR_BACKGROUND_LOADING</name>
--<value>9568</value>
--<desc></desc>
--</constant>
--<constant>
--<name>DNS_ERROR_NOT_ALLOWED_ON_RODC</name>
--<value>9569</value>
--<desc></desc>
--</constant>
--<constant>
--<name>DNS_ERROR_NOT_ALLOWED_UNDER_DNAME</name>
--<value>9570</value>
--<desc></desc>
--</constant>
--<constant>
--<name>DNS_ERROR_DELEGATION_REQUIRED</name>
--<value>9571</value>
--<desc></desc>
--</constant>
--<constant>
--<name>DNS_ERROR_INVALID_POLICY_TABLE</name>
--<value>9572</value>
--<desc></desc>
--</constant>
--<constant>
--<name>DNS_ERROR_ZONE_DOES_NOT_EXIST</name>
--<value>9601</value>
--<desc></desc>
--</constant>
--<constant>
--<name>DNS_ERROR_NO_ZONE_INFO</name>
--<value>9602</value>
--<desc></desc>
--</constant>
--<constant>
--<name>DNS_ERROR_INVALID_ZONE_OPERATION</name>
--<value>9603</value>
--<desc></desc>
--</constant>
--<constant>
--<name>DNS_ERROR_ZONE_CONFIGURATION_ERROR</name>
--<value>9604</value>
--<desc></desc>
--</constant>
--<constant>
--<name>DNS_ERROR_ZONE_HAS_NO_SOA_RECORD</name>
--<value>9605</value>
--<desc></desc>
--</constant>
--<constant>
--<name>DNS_ERROR_ZONE_HAS_NO_NS_RECORDS</name>
--<value>9606</value>
--<desc></desc>
--</constant>
--<constant>
--<name>DNS_ERROR_ZONE_LOCKED</name>
--<value>9607</value>
--<desc></desc>
--</constant>
--<constant>
--<name>DNS_ERROR_ZONE_CREATION_FAILED</name>
--<value>9608</value>
--<desc></desc>
--</constant>
--<constant>
--<name>DNS_ERROR_ZONE_ALREADY_EXISTS</name>
--<value>9609</value>
--<desc></desc>
--</constant>
--<constant>
--<name>DNS_ERROR_AUTOZONE_ALREADY_EXISTS</name>
--<value>9610</value>
--<desc></desc>
--</constant>
--<constant>
--<name>DNS_ERROR_INVALID_ZONE_TYPE</name>
--<value>9611</value>
--<desc></desc>
--</constant>
--<constant>
--<name>DNS_ERROR_SECONDARY_REQUIRES_MASTER_IP</name>
--<value>9612</value>
--<desc></desc>
--</constant>
--<constant>
--<name>DNS_ERROR_ZONE_NOT_SECONDARY</name>
--<value>9613</value>
--<desc></desc>
--</constant>
--<constant>
--<name>DNS_ERROR_NEED_SECONDARY_ADDRESSES</name>
--<value>9614</value>
--<desc></desc>
--</constant>
--<constant>
--<name>DNS_ERROR_WINS_INIT_FAILED</name>
--<value>9615</value>
--<desc></desc>
--</constant>
--<constant>
--<name>DNS_ERROR_NEED_WINS_SERVERS</name>
--<value>9616</value>
--<desc></desc>
--</constant>
--<constant>
--<name>DNS_ERROR_NBSTAT_INIT_FAILED</name>
--<value>9617</value>
--<desc></desc>
--</constant>
--<constant>
--<name>DNS_ERROR_SOA_DELETE_INVALID</name>
--<value>9618</value>
--<desc></desc>
--</constant>
--<constant>
--<name>DNS_ERROR_FORWARDER_ALREADY_EXISTS</name>
--<value>9619</value>
--<desc></desc>
--</constant>
--<constant>
--<name>DNS_ERROR_ZONE_REQUIRES_MASTER_IP</name>
--<value>9620</value>
--<desc></desc>
--</constant>
--<constant>
--<name>DNS_ERROR_ZONE_IS_SHUTDOWN</name>
--<value>9621</value>
--<desc></desc>
--</constant>
--<constant>
--<name>DNS_ERROR_PRIMARY_REQUIRES_DATAFILE</name>
--<value>9651</value>
--<desc></desc>
--</constant>
--<constant>
--<name>DNS_ERROR_INVALID_DATAFILE_NAME</name>
--<value>9652</value>
--<desc></desc>
--</constant>
--<constant>
--<name>DNS_ERROR_DATAFILE_OPEN_FAILURE</name>
--<value>9653</value>
--<desc></desc>
--</constant>
--<constant>
--<name>DNS_ERROR_FILE_WRITEBACK_FAILED</name>
--<value>9654</value>
--<desc></desc>
--</constant>
--<constant>
--<name>DNS_ERROR_DATAFILE_PARSING</name>
--<value>9655</value>
--<desc></desc>
--</constant>
--<constant>
--<name>DNS_ERROR_RECORD_DOES_NOT_EXIST</name>
--<value>9701</value>
--<desc></desc>
--</constant>
--<constant>
--<name>DNS_ERROR_RECORD_FORMAT</name>
--<value>9702</value>
--<desc></desc>
--</constant>
--<constant>
--<name>DNS_ERROR_NODE_CREATION_FAILED</name>
--<value>9703</value>
--<desc></desc>
--</constant>
--<constant>
--<name>DNS_ERROR_UNKNOWN_RECORD_TYPE</name>
--<value>9704</value>
--<desc></desc>
--</constant>
--<constant>
--<name>DNS_ERROR_RECORD_TIMED_OUT</name>
--<value>9705</value>
--<desc></desc>
--</constant>
--<constant>
--<name>DNS_ERROR_NAME_NOT_IN_ZONE</name>
--<value>9706</value>
--<desc></desc>
--</constant>
--<constant>
--<name>DNS_ERROR_CNAME_LOOP</name>
--<value>9707</value>
--<desc></desc>
--</constant>
--<constant>
--<name>DNS_ERROR_NODE_IS_CNAME</name>
--<value>9708</value>
--<desc></desc>
--</constant>
--<constant>
--<name>DNS_ERROR_CNAME_COLLISION</name>
--<value>9709</value>
--<desc></desc>
--</constant>
--<constant>
--<name>DNS_ERROR_RECORD_ONLY_AT_ZONE_ROOT</name>
--<value>9710</value>
--<desc></desc>
--</constant>
--<constant>
--<name>DNS_ERROR_RECORD_ALREADY_EXISTS</name>
--<value>9711</value>
--<desc></desc>
--</constant>
--<constant>
--<name>DNS_ERROR_SECONDARY_DATA</name>
--<value>9712</value>
--<desc></desc>
--</constant>
--<constant>
--<name>DNS_ERROR_NO_CREATE_CACHE_DATA</name>
--<value>9713</value>
--<desc></desc>
--</constant>
--<constant>
--<name>DNS_ERROR_NAME_DOES_NOT_EXIST</name>
--<value>9714</value>
--<desc></desc>
--</constant>
--<constant>
--<name>DNS_WARNING_PTR_CREATE_FAILED</name>
--<value>9715</value>
--<desc></desc>
--</constant>
--<constant>
--<name>DNS_WARNING_DOMAIN_UNDELETED</name>
--<value>9716</value>
--<desc></desc>
--</constant>
--<constant>
--<name>DNS_ERROR_DS_UNAVAILABLE</name>
--<value>9717</value>
--<desc></desc>
--</constant>
--<constant>
--<name>DNS_ERROR_DS_ZONE_ALREADY_EXISTS</name>
--<value>9718</value>
--<desc></desc>
--</constant>
--<constant>
--<name>DNS_ERROR_NO_BOOTFILE_IF_DS_ZONE</name>
--<value>9719</value>
--<desc></desc>
--</constant>
--<constant>
--<name>DNS_ERROR_NODE_IS_DNAME</name>
--<value>9720</value>
--<desc></desc>
--</constant>
--<constant>
--<name>DNS_ERROR_DNAME_COLLISION</name>
--<value>9721</value>
--<desc></desc>
--</constant>
--<constant>
--<name>DNS_ERROR_ALIAS_LOOP</name>
--<value>9722</value>
--<desc></desc>
--</constant>
--<constant>
--<name>DNS_INFO_AXFR_COMPLETE</name>
--<value>9751</value>
--<desc></desc>
--</constant>
--<constant>
--<name>DNS_ERROR_AXFR</name>
--<value>9752</value>
--<desc></desc>
--</constant>
--<constant>
--<name>DNS_INFO_ADDED_LOCAL_WINS</name>
--<value>9753</value>
--<desc></desc>
--</constant>
--<constant>
--<name>DNS_STATUS_CONTINUE_NEEDED</name>
--<value>9801</value>
--<desc></desc>
--</constant>
--<constant>
--<name>DNS_ERROR_NO_TCPIP</name>
--<value>9851</value>
--<desc></desc>
--</constant>
--<constant>
--<name>DNS_ERROR_NO_DNS_SERVERS</name>
--<value>9852</value>
--<desc></desc>
--</constant>
--<constant>
--<name>DNS_ERROR_DP_DOES_NOT_EXIST</name>
--<value>9901</value>
--<desc></desc>
--</constant>
--<constant>
--<name>DNS_ERROR_DP_ALREADY_EXISTS</name>
--<value>9902</value>
--<desc></desc>
--</constant>
--<constant>
--<name>DNS_ERROR_DP_NOT_ENLISTED</name>
--<value>9903</value>
--<desc></desc>
--</constant>
--<constant>
--<name>DNS_ERROR_DP_ALREADY_ENLISTED</name>
--<value>9904</value>
--<desc></desc>
--</constant>
--<constant>
--<name>DNS_ERROR_DP_NOT_AVAILABLE</name>
--<value>9905</value>
--<desc></desc>
--</constant>
--<constant>
--<name>DNS_ERROR_DP_FSMO_ERROR</name>
--<value>9906</value>
--<desc></desc>
--</constant>
--<constant>
--<name>WSAEINTR</name>
--<value>10004</value>
--<desc></desc>
--</constant>
--<constant>
--<name>WSAEBADF</name>
--<value>10009</value>
--<desc></desc>
--</constant>
--<constant>
--<name>WSAEACCES</name>
--<value>10013</value>
--<desc></desc>
--</constant>
--<constant>
--<name>WSAEFAULT</name>
--<value>10014</value>
--<desc></desc>
--</constant>
--<constant>
--<name>WSAEINVAL</name>
--<value>10022</value>
--<desc></desc>
--</constant>
--<constant>
--<name>WSAEMFILE</name>
--<value>10024</value>
--<desc></desc>
--</constant>
--<constant>
--<name>WSAEWOULDBLOCK</name>
--<value>10035</value>
--<desc></desc>
--</constant>
--<constant>
--<name>WSAEINPROGRESS</name>
--<value>10036</value>
--<desc></desc>
--</constant>
--<constant>
--<name>WSAEALREADY</name>
--<value>10037</value>
--<desc></desc>
--</constant>
--<constant>
--<name>WSAENOTSOCK</name>
--<value>10038</value>
--<desc></desc>
--</constant>
--<constant>
--<name>WSAEDESTADDRREQ</name>
--<value>10039</value>
--<desc></desc>
--</constant>
--<constant>
--<name>WSAEMSGSIZE</name>
--<value>10040</value>
--<desc></desc>
--</constant>
--<constant>
--<name>WSAEPROTOTYPE</name>
--<value>10041</value>
--<desc></desc>
--</constant>
--<constant>
--<name>WSAENOPROTOOPT</name>
--<value>10042</value>
--<desc></desc>
--</constant>
--<constant>
--<name>WSAEPROTONOSUPPORT</name>
--<value>10043</value>
--<desc></desc>
--</constant>
--<constant>
--<name>WSAESOCKTNOSUPPORT</name>
--<value>10044</value>
--<desc></desc>
--</constant>
--<constant>
--<name>WSAEOPNOTSUPP</name>
--<value>10045</value>
--<desc></desc>
--</constant>
--<constant>
--<name>WSAEPFNOSUPPORT</name>
--<value>10046</value>
--<desc></desc>
--</constant>
--<constant>
--<name>WSAEAFNOSUPPORT</name>
--<value>10047</value>
--<desc></desc>
--</constant>
--<constant>
--<name>WSAEADDRINUSE</name>
--<value>10048</value>
--<desc></desc>
--</constant>
--<constant>
--<name>WSAEADDRNOTAVAIL</name>
--<value>10049</value>
--<desc></desc>
--</constant>
--<constant>
--<name>WSAENETDOWN</name>
--<value>10050</value>
--<desc></desc>
--</constant>
--<constant>
--<name>WSAENETUNREACH</name>
--<value>10051</value>
--<desc></desc>
--</constant>
--<constant>
--<name>WSAENETRESET</name>
--<value>10052</value>
--<desc></desc>
--</constant>
--<constant>
--<name>WSAECONNABORTED</name>
--<value>10053</value>
--<desc></desc>
--</constant>
--<constant>
--<name>WSAECONNRESET</name>
--<value>10054</value>
--<desc></desc>
--</constant>
--<constant>
--<name>WSAENOBUFS</name>
--<value>10055</value>
--<desc></desc>
--</constant>
--<constant>
--<name>WSAEISCONN</name>
--<value>10056</value>
--<desc></desc>
--</constant>
--<constant>
--<name>WSAENOTCONN</name>
--<value>10057</value>
--<desc></desc>
--</constant>
--<constant>
--<name>WSAESHUTDOWN</name>
--<value>10058</value>
--<desc></desc>
--</constant>
--<constant>
--<name>WSAETOOMANYREFS</name>
--<value>10059</value>
--<desc></desc>
--</constant>
--<constant>
--<name>WSAETIMEDOUT</name>
--<value>10060</value>
--<desc></desc>
--</constant>
--<constant>
--<name>WSAECONNREFUSED</name>
--<value>10061</value>
--<desc></desc>
--</constant>
--<constant>
--<name>WSAELOOP</name>
--<value>10062</value>
--<desc></desc>
--</constant>
--<constant>
--<name>WSAENAMETOOLONG</name>
--<value>10063</value>
--<desc></desc>
--</constant>
--<constant>
--<name>WSAEHOSTDOWN</name>
--<value>10064</value>
--<desc></desc>
--</constant>
--<constant>
--<name>WSAEHOSTUNREACH</name>
--<value>10065</value>
--<desc></desc>
--</constant>
--<constant>
--<name>WSAENOTEMPTY</name>
--<value>10066</value>
--<desc></desc>
--</constant>
--<constant>
--<name>WSAEPROCLIM</name>
--<value>10067</value>
--<desc></desc>
--</constant>
--<constant>
--<name>WSAEUSERS</name>
--<value>10068</value>
--<desc></desc>
--</constant>
--<constant>
--<name>WSAEDQUOT</name>
--<value>10069</value>
--<desc></desc>
--</constant>
--<constant>
--<name>WSAESTALE</name>
--<value>10070</value>
--<desc></desc>
--</constant>
--<constant>
--<name>WSAEREMOTE</name>
--<value>10071</value>
--<desc></desc>
--</constant>
--<constant>
--<name>WSASYSNOTREADY</name>
--<value>10091</value>
--<desc></desc>
--</constant>
--<constant>
--<name>WSAVERNOTSUPPORTED</name>
--<value>10092</value>
--<desc></desc>
--</constant>
--<constant>
--<name>WSANOTINITIALISED</name>
--<value>10093</value>
--<desc></desc>
--</constant>
--<constant>
--<name>WSAEDISCON</name>
--<value>10101</value>
--<desc></desc>
--</constant>
--<constant>
--<name>WSAENOMORE</name>
--<value>10102</value>
--<desc></desc>
--</constant>
--<constant>
--<name>WSAECANCELLED</name>
--<value>10103</value>
--<desc></desc>
--</constant>
--<constant>
--<name>WSAEINVALIDPROCTABLE</name>
--<value>10104</value>
--<desc></desc>
--</constant>
--<constant>
--<name>WSAEINVALIDPROVIDER</name>
--<value>10105</value>
--<desc></desc>
--</constant>
--<constant>
--<name>WSAEPROVIDERFAILEDINIT</name>
--<value>10106</value>
--<desc></desc>
--</constant>
--<constant>
--<name>WSASYSCALLFAILURE</name>
--<value>10107</value>
--<desc></desc>
--</constant>
--<constant>
--<name>WSASERVICE_NOT_FOUND</name>
--<value>10108</value>
--<desc></desc>
--</constant>
--<constant>
--<name>WSATYPE_NOT_FOUND</name>
--<value>10109</value>
--<desc></desc>
--</constant>
--<constant>
--<name>WSA_E_NO_MORE</name>
--<value>10110</value>
--<desc></desc>
--</constant>
--<constant>
--<name>WSA_E_CANCELLED</name>
--<value>10111</value>
--<desc></desc>
--</constant>
--<constant>
--<name>WSAEREFUSED</name>
--<value>10112</value>
--<desc></desc>
--</constant>
--<constant>
--<name>WSAHOST_NOT_FOUND</name>
--<value>11001</value>
--<desc></desc>
--</constant>
--<constant>
--<name>WSATRY_AGAIN</name>
--<value>11002</value>
--<desc></desc>
--</constant>
--<constant>
--<name>WSANO_RECOVERY</name>
--<value>11003</value>
--<desc></desc>
--</constant>
--<constant>
--<name>WSANO_DATA</name>
--<value>11004</value>
--<desc></desc>
--</constant>
--<constant>
--<name>WSA_QOS_RECEIVERS</name>
--<value>11005</value>
--<desc></desc>
--</constant>
--<constant>
--<name>WSA_QOS_SENDERS</name>
--<value>11006</value>
--<desc></desc>
--</constant>
--<constant>
--<name>WSA_QOS_NO_SENDERS</name>
--<value>11007</value>
--<desc></desc>
--</constant>
--<constant>
--<name>WSA_QOS_NO_RECEIVERS</name>
--<value>11008</value>
--<desc></desc>
--</constant>
--<constant>
--<name>WSA_QOS_REQUEST_CONFIRMED</name>
--<value>11009</value>
--<desc></desc>
--</constant>
--<constant>
--<name>WSA_QOS_ADMISSION_FAILURE</name>
--<value>11010</value>
--<desc></desc>
--</constant>
--<constant>
--<name>WSA_QOS_POLICY_FAILURE</name>
--<value>11011</value>
--<desc></desc>
--</constant>
--<constant>
--<name>WSA_QOS_BAD_STYLE</name>
--<value>11012</value>
--<desc></desc>
--</constant>
--<constant>
--<name>WSA_QOS_BAD_OBJECT</name>
--<value>11013</value>
--<desc></desc>
--</constant>
--<constant>
--<name>WSA_QOS_TRAFFIC_CTRL_ERROR</name>
--<value>11014</value>
--<desc></desc>
--</constant>
--<constant>
--<name>WSA_QOS_GENERIC_ERROR</name>
--<value>11015</value>
--<desc></desc>
--</constant>
--<constant>
--<name>WSA_QOS_ESERVICETYPE</name>
--<value>11016</value>
--<desc></desc>
--</constant>
--<constant>
--<name>WSA_QOS_EFLOWSPEC</name>
--<value>11017</value>
--<desc></desc>
--</constant>
--<constant>
--<name>WSA_QOS_EPROVSPECBUF</name>
--<value>11018</value>
--<desc></desc>
--</constant>
--<constant>
--<name>WSA_QOS_EFILTERSTYLE</name>
--<value>11019</value>
--<desc></desc>
--</constant>
--<constant>
--<name>WSA_QOS_EFILTERTYPE</name>
--<value>11020</value>
--<desc></desc>
--</constant>
--<constant>
--<name>WSA_QOS_EFILTERCOUNT</name>
--<value>11021</value>
--<desc></desc>
--</constant>
--<constant>
--<name>WSA_QOS_EOBJLENGTH</name>
--<value>11022</value>
--<desc></desc>
--</constant>
--<constant>
--<name>WSA_QOS_EFLOWCOUNT</name>
--<value>11023</value>
--<desc></desc>
--</constant>
--<constant>
--<name>WSA_QOS_EUNKNOWNPSOBJ</name>
--<value>11024</value>
--<desc></desc>
--</constant>
--<constant>
--<name>WSA_QOS_EPOLICYOBJ</name>
--<value>11025</value>
--<desc></desc>
--</constant>
--<constant>
--<name>WSA_QOS_EFLOWDESC</name>
--<value>11026</value>
--<desc></desc>
--</constant>
--<constant>
--<name>WSA_QOS_EPSFLOWSPEC</name>
--<value>11027</value>
--<desc></desc>
--</constant>
--<constant>
--<name>WSA_QOS_EPSFILTERSPEC</name>
--<value>11028</value>
--<desc></desc>
--</constant>
--<constant>
--<name>WSA_QOS_ESDMODEOBJ</name>
--<value>11029</value>
--<desc></desc>
--</constant>
--<constant>
--<name>WSA_QOS_ESHAPERATEOBJ</name>
--<value>11030</value>
--<desc></desc>
--</constant>
--<constant>
--<name>WSA_QOS_RESERVED_PETYPE</name>
--<value>11031</value>
--<desc></desc>
--</constant>
--<constant>
--<name>INTERNET_ERROR_BASE</name>
--<value>12000</value>
--<desc></desc>
--</constant>
--<constant>
--<name>WINHTTP_ERROR_BASE</name>
--<value>12000</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_INTERNET_OUT_OF_HANDLES</name>
--<value>12001</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_WINHTTP_OUT_OF_HANDLES</name>
--<value>12001</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_INTERNET_TIMEOUT</name>
--<value>12002</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_WINHTTP_TIMEOUT</name>
--<value>12002</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_INTERNET_EXTENDED_ERROR</name>
--<value>12003</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_INTERNET_INTERNAL_ERROR</name>
--<value>12004</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_WINHTTP_INTERNAL_ERROR</name>
--<value>12004</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_INTERNET_INVALID_URL</name>
--<value>12005</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_WINHTTP_INVALID_URL</name>
--<value>12005</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_INTERNET_UNRECOGNIZED_SCHEME</name>
--<value>12006</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_WINHTTP_UNRECOGNIZED_SCHEME</name>
--<value>12006</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_INTERNET_NAME_NOT_RESOLVED</name>
--<value>12007</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_WINHTTP_NAME_NOT_RESOLVED</name>
--<value>12007</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_INTERNET_PROTOCOL_NOT_FOUND</name>
--<value>12008</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_INTERNET_INVALID_OPTION</name>
--<value>12009</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_WINHTTP_INVALID_OPTION</name>
--<value>12009</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_INTERNET_BAD_OPTION_LENGTH</name>
--<value>12010</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_INTERNET_OPTION_NOT_SETTABLE</name>
--<value>12011</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_WINHTTP_OPTION_NOT_SETTABLE</name>
--<value>12011</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_INTERNET_SHUTDOWN</name>
--<value>12012</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_WINHTTP_SHUTDOWN</name>
--<value>12012</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_INTERNET_INCORRECT_USER_NAME</name>
--<value>12013</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_INTERNET_INCORRECT_PASSWORD</name>
--<value>12014</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_INTERNET_LOGIN_FAILURE</name>
--<value>12015</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_WINHTTP_LOGIN_FAILURE</name>
--<value>12015</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_INTERNET_INVALID_OPERATION</name>
--<value>12016</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_INTERNET_OPERATION_CANCELLED</name>
--<value>12017</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_WINHTTP_OPERATION_CANCELLED</name>
--<value>12017</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_INTERNET_INCORRECT_HANDLE_TYPE</name>
--<value>12018</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_WINHTTP_INCORRECT_HANDLE_TYPE</name>
--<value>12018</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_INTERNET_INCORRECT_HANDLE_STATE</name>
--<value>12019</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_WINHTTP_INCORRECT_HANDLE_STATE</name>
--<value>12019</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_INTERNET_NOT_PROXY_REQUEST</name>
--<value>12020</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_INTERNET_REGISTRY_VALUE_NOT_FOUND</name>
--<value>12021</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_INTERNET_BAD_REGISTRY_PARAMETER</name>
--<value>12022</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_INTERNET_NO_DIRECT_ACCESS</name>
--<value>12023</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_INTERNET_NO_CONTEXT</name>
--<value>12024</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_INTERNET_NO_CALLBACK</name>
--<value>12025</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_INTERNET_REQUEST_PENDING</name>
--<value>12026</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_INTERNET_INCORRECT_FORMAT</name>
--<value>12027</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_INTERNET_ITEM_NOT_FOUND</name>
--<value>12028</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_INTERNET_CANNOT_CONNECT</name>
--<value>12029</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_WINHTTP_CANNOT_CONNECT</name>
--<value>12029</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_INTERNET_CONNECTION_ABORTED</name>
--<value>12030</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_WINHTTP_CONNECTION_ERROR</name>
--<value>12030</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_INTERNET_CONNECTION_RESET</name>
--<value>12031</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_INTERNET_FORCE_RETRY</name>
--<value>12032</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_WINHTTP_RESEND_REQUEST</name>
--<value>12032</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_INTERNET_INVALID_PROXY_REQUEST</name>
--<value>12033</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_INTERNET_NEED_UI</name>
--<value>12034</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_INTERNET_HANDLE_EXISTS</name>
--<value>12036</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_INTERNET_SEC_CERT_DATE_INVALID</name>
--<value>12037</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_WINHTTP_SECURE_CERT_DATE_INVALID</name>
--<value>12037</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_INTERNET_SEC_CERT_CN_INVALID</name>
--<value>12038</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_WINHTTP_SECURE_CERT_CN_INVALID</name>
--<value>12038</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_INTERNET_HTTP_TO_HTTPS_ON_REDIR</name>
--<value>12039</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_INTERNET_HTTPS_TO_HTTP_ON_REDIR</name>
--<value>12040</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_INTERNET_MIXED_SECURITY</name>
--<value>12041</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_INTERNET_CHG_POST_IS_NON_SECURE</name>
--<value>12042</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_INTERNET_POST_IS_NON_SECURE</name>
--<value>12043</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_INTERNET_CLIENT_AUTH_CERT_NEEDED</name>
--<value>12044</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_WINHTTP_CLIENT_AUTH_CERT_NEEDED</name>
--<value>12044</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_INTERNET_INVALID_CA</name>
--<value>12045</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_WINHTTP_SECURE_INVALID_CA</name>
--<value>12045</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_INTERNET_CLIENT_AUTH_NOT_SETUP</name>
--<value>12046</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_INTERNET_ASYNC_THREAD_FAILED</name>
--<value>12047</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_INTERNET_REDIRECT_SCHEME_CHANGE</name>
--<value>12048</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_INTERNET_DIALOG_PENDING</name>
--<value>12049</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_INTERNET_RETRY_DIALOG</name>
--<value>12050</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_INTERNET_HTTPS_HTTP_SUBMIT_REDIR</name>
--<value>12052</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_INTERNET_INSERT_CDROM</name>
--<value>12053</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_INTERNET_FORTEZZA_LOGIN_NEEDED</name>
--<value>12054</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_INTERNET_SEC_CERT_ERRORS</name>
--<value>12055</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_INTERNET_SEC_CERT_NO_REV</name>
--<value>12056</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_INTERNET_SEC_CERT_REV_FAILED</name>
--<value>12057</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_WINHTTP_SECURE_CERT_REV_FAILED</name>
--<value>12057</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_WINHTTP_CANNOT_CALL_BEFORE_OPEN</name>
--<value>12100</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_WINHTTP_CANNOT_CALL_BEFORE_SEND</name>
--<value>12101</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_WINHTTP_CANNOT_CALL_AFTER_SEND</name>
--<value>12102</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_WINHTTP_CANNOT_CALL_AFTER_OPEN</name>
--<value>12103</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_FTP_TRANSFER_IN_PROGRESS</name>
--<value>12110</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_FTP_DROPPED</name>
--<value>12111</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_FTP_NO_PASSIVE_MODE</name>
--<value>12112</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_GOPHER_PROTOCOL_ERROR</name>
--<value>12130</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_GOPHER_NOT_FILE</name>
--<value>12131</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_GOPHER_DATA_ERROR</name>
--<value>12132</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_GOPHER_END_OF_DATA</name>
--<value>12133</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_GOPHER_INVALID_LOCATOR</name>
--<value>12134</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_GOPHER_INCORRECT_LOCATOR_TYPE</name>
--<value>12135</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_GOPHER_NOT_GOPHER_PLUS</name>
--<value>12136</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_GOPHER_ATTRIBUTE_NOT_FOUND</name>
--<value>12137</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_GOPHER_UNKNOWN_LOCATOR</name>
--<value>12138</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_HTTP_HEADER_NOT_FOUND</name>
--<value>12150</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_WINHTTP_HEADER_NOT_FOUND</name>
--<value>12150</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_HTTP_DOWNLEVEL_SERVER</name>
--<value>12151</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_HTTP_INVALID_SERVER_RESPONSE</name>
--<value>12152</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_WINHTTP_INVALID_SERVER_RESPONSE</name>
--<value>12152</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_HTTP_INVALID_HEADER</name>
--<value>12153</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_WINHTTP_INVALID_HEADER</name>
--<value>12153</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_HTTP_INVALID_QUERY_REQUEST</name>
--<value>12154</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_WINHTTP_INVALID_QUERY_REQUEST</name>
--<value>12154</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_HTTP_HEADER_ALREADY_EXISTS</name>
--<value>12155</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_WINHTTP_HEADER_ALREADY_EXISTS</name>
--<value>12155</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_HTTP_REDIRECT_FAILED</name>
--<value>12156</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_WINHTTP_REDIRECT_FAILED</name>
--<value>12156</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_INTERNET_SECURITY_CHANNEL_ERROR</name>
--<value>12157</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_WINHTTP_SECURE_CHANNEL_ERROR</name>
--<value>12157</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_INTERNET_UNABLE_TO_CACHE_FILE</name>
--<value>12158</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_INTERNET_TCPIP_NOT_INSTALLED</name>
--<value>12159</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_HTTP_NOT_REDIRECTED</name>
--<value>12160</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_HTTP_COOKIE_NEEDS_CONFIRMATION</name>
--<value>12161</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_HTTP_COOKIE_DECLINED</name>
--<value>12162</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_INTERNET_DISCONNECTED</name>
--<value>12163</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_INTERNET_SERVER_UNREACHABLE</name>
--<value>12164</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_INTERNET_PROXY_SERVER_UNREACHABLE</name>
--<value>12165</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_INTERNET_BAD_AUTO_PROXY_SCRIPT</name>
--<value>12166</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_WINHTTP_BAD_AUTO_PROXY_SCRIPT</name>
--<value>12166</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_INTERNET_UNABLE_TO_DOWNLOAD_SCRIPT</name>
--<value>12167</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_WINHTTP_UNABLE_TO_DOWNLOAD_SCRIPT</name>
--<value>12167</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_HTTP_REDIRECT_NEEDS_CONFIRMATION</name>
--<value>12168</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_INTERNET_SEC_INVALID_CERT</name>
--<value>12169</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_WINHTTP_SECURE_INVALID_CERT</name>
--<value>12169</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_INTERNET_SEC_CERT_REVOKED</name>
--<value>12170</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_WINHTTP_SECURE_CERT_REVOKED</name>
--<value>12170</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_INTERNET_FAILED_DUETOSECURITYCHECK</name>
--<value>12171</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_INTERNET_NOT_INITIALIZED</name>
--<value>12172</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_WINHTTP_NOT_INITIALIZED</name>
--<value>12172</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_INTERNET_LOGIN_FAILURE_DISPLAY_ENTITY_BODY</name>
--<value>12174</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_WINHTTP_SECURE_FAILURE</name>
--<value>12175</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_WINHTTP_UNHANDLED_SCRIPT_TYPE</name>
--<value>12176</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_WINHTTP_SCRIPT_EXECUTION_ERROR</name>
--<value>12177</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_WINHTTP_AUTO_PROXY_SERVICE_ERROR</name>
--<value>12178</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_WINHTTP_SECURE_CERT_WRONG_USAGE</name>
--<value>12179</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_WINHTTP_AUTODETECTION_FAILED</name>
--<value>12180</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_WINHTTP_HEADER_COUNT_EXCEEDED</name>
--<value>12181</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_WINHTTP_HEADER_SIZE_OVERFLOW</name>
--<value>12182</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_WINHTTP_CHUNKED_ENCODING_HEADER_SIZE_OVERFLOW</name>
--<value>12183</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_WINHTTP_RESPONSE_DRAIN_OVERFLOW</name>
--<value>12184</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_WINHTTP_CLIENT_CERT_NO_PRIVATE_KEY</name>
--<value>12185</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_WINHTTP_CLIENT_CERT_NO_ACCESS_PRIVATE_KEY</name>
--<value>12186</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_IPSEC_QM_POLICY_EXISTS</name>
--<value>13000</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_IPSEC_QM_POLICY_NOT_FOUND</name>
--<value>13001</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_IPSEC_QM_POLICY_IN_USE</name>
--<value>13002</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_IPSEC_MM_POLICY_EXISTS</name>
--<value>13003</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_IPSEC_MM_POLICY_NOT_FOUND</name>
--<value>13004</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_IPSEC_MM_POLICY_IN_USE</name>
--<value>13005</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_IPSEC_MM_FILTER_EXISTS</name>
--<value>13006</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_IPSEC_MM_FILTER_NOT_FOUND</name>
--<value>13007</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_IPSEC_TRANSPORT_FILTER_EXISTS</name>
--<value>13008</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_IPSEC_TRANSPORT_FILTER_NOT_FOUND</name>
--<value>13009</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_IPSEC_MM_AUTH_EXISTS</name>
--<value>13010</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_IPSEC_MM_AUTH_NOT_FOUND</name>
--<value>13011</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_IPSEC_MM_AUTH_IN_USE</name>
--<value>13012</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_IPSEC_DEFAULT_MM_POLICY_NOT_FOUND</name>
--<value>13013</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_IPSEC_DEFAULT_MM_AUTH_NOT_FOUND</name>
--<value>13014</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_IPSEC_DEFAULT_QM_POLICY_NOT_FOUND</name>
--<value>13015</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_IPSEC_TUNNEL_FILTER_EXISTS</name>
--<value>13016</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_IPSEC_TUNNEL_FILTER_NOT_FOUND</name>
--<value>13017</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_IPSEC_MM_FILTER_PENDING_DELETION</name>
--<value>13018</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_IPSEC_TRANSPORT_FILTER_PENDING_DELETION</name>
--<value>13019</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_IPSEC_TUNNEL_FILTER_PENDING_DELETION</name>
--<value>13020</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_IPSEC_MM_POLICY_PENDING_DELETION</name>
--<value>13021</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_IPSEC_MM_AUTH_PENDING_DELETION</name>
--<value>13022</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_IPSEC_QM_POLICY_PENDING_DELETION</name>
--<value>13023</value>
--<desc></desc>
--</constant>
--<constant>
--<name>WARNING_IPSEC_MM_POLICY_PRUNED</name>
--<value>13024</value>
--<desc></desc>
--</constant>
--<constant>
--<name>WARNING_IPSEC_QM_POLICY_PRUNED</name>
--<value>13025</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_IPSEC_IKE_AUTH_FAIL</name>
--<value>13801</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_IPSEC_IKE_ATTRIB_FAIL</name>
--<value>13802</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_IPSEC_IKE_NEGOTIATION_PENDING</name>
--<value>13803</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_IPSEC_IKE_GENERAL_PROCESSING_ERROR</name>
--<value>13804</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_IPSEC_IKE_TIMED_OUT</name>
--<value>13805</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_IPSEC_IKE_NO_CERT</name>
--<value>13806</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_IPSEC_IKE_SA_DELETED</name>
--<value>13807</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_IPSEC_IKE_SA_REAPED</name>
--<value>13808</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_IPSEC_IKE_MM_ACQUIRE_DROP</name>
--<value>13809</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_IPSEC_IKE_QM_ACQUIRE_DROP</name>
--<value>13810</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_IPSEC_IKE_QUEUE_DROP_MM</name>
--<value>13811</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_IPSEC_IKE_QUEUE_DROP_NO_MM</name>
--<value>13812</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_IPSEC_IKE_DROP_NO_RESPONSE</name>
--<value>13813</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_IPSEC_IKE_MM_DELAY_DROP</name>
--<value>13814</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_IPSEC_IKE_QM_DELAY_DROP</name>
--<value>13815</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_IPSEC_IKE_ERROR</name>
--<value>13816</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_IPSEC_IKE_CRL_FAILED</name>
--<value>13817</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_IPSEC_IKE_INVALID_KEY_USAGE</name>
--<value>13818</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_IPSEC_IKE_INVALID_CERT_TYPE</name>
--<value>13819</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_IPSEC_IKE_NO_PRIVATE_KEY</name>
--<value>13820</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_IPSEC_IKE_DH_FAIL</name>
--<value>13822</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_IPSEC_IKE_CRITICAL_PAYLOAD_NOT_RECOGNIZED</name>
--<value>13823</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_IPSEC_IKE_INVALID_HEADER</name>
--<value>13824</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_IPSEC_IKE_NO_POLICY</name>
--<value>13825</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_IPSEC_IKE_INVALID_SIGNATURE</name>
--<value>13826</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_IPSEC_IKE_KERBEROS_ERROR</name>
--<value>13827</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_IPSEC_IKE_NO_PUBLIC_KEY</name>
--<value>13828</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_IPSEC_IKE_PROCESS_ERR</name>
--<value>13829</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_IPSEC_IKE_PROCESS_ERR_SA</name>
--<value>13830</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_IPSEC_IKE_PROCESS_ERR_PROP</name>
--<value>13831</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_IPSEC_IKE_PROCESS_ERR_TRANS</name>
--<value>13832</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_IPSEC_IKE_PROCESS_ERR_KE</name>
--<value>13833</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_IPSEC_IKE_PROCESS_ERR_ID</name>
--<value>13834</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_IPSEC_IKE_PROCESS_ERR_CERT</name>
--<value>13835</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_IPSEC_IKE_PROCESS_ERR_CERT_REQ</name>
--<value>13836</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_IPSEC_IKE_PROCESS_ERR_HASH</name>
--<value>13837</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_IPSEC_IKE_PROCESS_ERR_SIG</name>
--<value>13838</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_IPSEC_IKE_PROCESS_ERR_NONCE</name>
--<value>13839</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_IPSEC_IKE_PROCESS_ERR_NOTIFY</name>
--<value>13840</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_IPSEC_IKE_PROCESS_ERR_DELETE</name>
--<value>13841</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_IPSEC_IKE_PROCESS_ERR_VENDOR</name>
--<value>13842</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_IPSEC_IKE_INVALID_PAYLOAD</name>
--<value>13843</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_IPSEC_IKE_LOAD_SOFT_SA</name>
--<value>13844</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_IPSEC_IKE_SOFT_SA_TORN_DOWN</name>
--<value>13845</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_IPSEC_IKE_INVALID_COOKIE</name>
--<value>13846</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_IPSEC_IKE_NO_PEER_CERT</name>
--<value>13847</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_IPSEC_IKE_PEER_CRL_FAILED</name>
--<value>13848</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_IPSEC_IKE_POLICY_CHANGE</name>
--<value>13849</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_IPSEC_IKE_NO_MM_POLICY</name>
--<value>13850</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_IPSEC_IKE_NOTCBPRIV</name>
--<value>13851</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_IPSEC_IKE_SECLOADFAIL</name>
--<value>13852</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_IPSEC_IKE_FAILSSPINIT</name>
--<value>13853</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_IPSEC_IKE_FAILQUERYSSP</name>
--<value>13854</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_IPSEC_IKE_SRVACQFAIL</name>
--<value>13855</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_IPSEC_IKE_SRVQUERYCRED</name>
--<value>13856</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_IPSEC_IKE_GETSPIFAIL</name>
--<value>13857</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_IPSEC_IKE_INVALID_FILTER</name>
--<value>13858</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_IPSEC_IKE_OUT_OF_MEMORY</name>
--<value>13859</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_IPSEC_IKE_ADD_UPDATE_KEY_FAILED</name>
--<value>13860</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_IPSEC_IKE_INVALID_POLICY</name>
--<value>13861</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_IPSEC_IKE_UNKNOWN_DOI</name>
--<value>13862</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_IPSEC_IKE_INVALID_SITUATION</name>
--<value>13863</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_IPSEC_IKE_DH_FAILURE</name>
--<value>13864</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_IPSEC_IKE_INVALID_GROUP</name>
--<value>13865</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_IPSEC_IKE_ENCRYPT</name>
--<value>13866</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_IPSEC_IKE_DECRYPT</name>
--<value>13867</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_IPSEC_IKE_POLICY_MATCH</name>
--<value>13868</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_IPSEC_IKE_UNSUPPORTED_ID</name>
--<value>13869</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_IPSEC_IKE_INVALID_HASH</name>
--<value>13870</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_IPSEC_IKE_INVALID_HASH_ALG</name>
--<value>13871</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_IPSEC_IKE_INVALID_HASH_SIZE</name>
--<value>13872</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_IPSEC_IKE_INVALID_ENCRYPT_ALG</name>
--<value>13873</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_IPSEC_IKE_INVALID_AUTH_ALG</name>
--<value>13874</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_IPSEC_IKE_INVALID_SIG</name>
--<value>13875</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_IPSEC_IKE_LOAD_FAILED</name>
--<value>13876</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_IPSEC_IKE_RPC_DELETE</name>
--<value>13877</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_IPSEC_IKE_BENIGN_REINIT</name>
--<value>13878</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_IPSEC_IKE_INVALID_RESPONDER_LIFETIME_NOTIFY</name>
--<value>13879</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_IPSEC_IKE_QM_LIMIT_REAP</name>
--<value>13880</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_IPSEC_IKE_INVALID_CERT_KEYLEN</name>
--<value>13881</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_IPSEC_IKE_MM_LIMIT</name>
--<value>13882</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_IPSEC_IKE_NEGOTIATION_DISABLED</name>
--<value>13883</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_IPSEC_IKE_QM_LIMIT</name>
--<value>13884</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_IPSEC_IKE_MM_EXPIRED</name>
--<value>13885</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_IPSEC_IKE_PEER_MM_ASSUMED_INVALID</name>
--<value>13886</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_IPSEC_IKE_CERT_CHAIN_POLICY_MISMATCH</name>
--<value>13887</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_IPSEC_IKE_UNEXPECTED_MESSAGE_ID</name>
--<value>13888</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_IPSEC_IKE_INVALID_AUTH_PAYLOAD</name>
--<value>13889</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_IPSEC_IKE_DOS_COOKIE_SENT</name>
--<value>13890</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_IPSEC_IKE_SHUTTING_DOWN</name>
--<value>13891</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_IPSEC_IKE_CGA_AUTH_FAILED</name>
--<value>13892</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_IPSEC_IKE_PROCESS_ERR_NATOA</name>
--<value>13893</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_IPSEC_IKE_INVALID_MM_FOR_QM</name>
--<value>13894</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_IPSEC_IKE_QM_EXPIRED</name>
--<value>13895</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_IPSEC_IKE_TOO_MANY_FILTERS</name>
--<value>13896</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_IPSEC_IKE_NEG_STATUS_END</name>
--<value>13897</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_IPSEC_IKE_KILL_DUMMY_NAP_TUNNEL</name>
--<value>13898</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_IPSEC_IKE_INNER_IP_ASSIGNMENT_FAILURE</name>
--<value>13899</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_IPSEC_IKE_REQUIRE_CP_PAYLOAD_MISSING</name>
--<value>13900</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_IPSEC_KEY_MODULE_IMPERSONATION_NEGOTIATION_PENDING</name>
--<value>13901</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_IPSEC_IKE_COEXISTENCE_SUPPRESS</name>
--<value>13902</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_IPSEC_IKE_RATELIMIT_DROP</name>
--<value>13903</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_IPSEC_IKE_PEER_DOESNT_SUPPORT_MOBIKE</name>
--<value>13904</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_IPSEC_IKE_AUTHORIZATION_FAILURE</name>
--<value>13905</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_IPSEC_IKE_STRONG_CRED_AUTHORIZATION_FAILURE</name>
--<value>13906</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_IPSEC_IKE_AUTHORIZATION_FAILURE_WITH_OPTIONAL_RETRY</name>
--<value>13907</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_IPSEC_IKE_STRONG_CRED_AUTHORIZATION_AND_CERTMAP_FAILURE</name>
--<value>13908</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_IPSEC_BAD_SPI</name>
--<value>13910</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_IPSEC_SA_LIFETIME_EXPIRED</name>
--<value>13911</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_IPSEC_WRONG_SA</name>
--<value>13912</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_IPSEC_REPLAY_CHECK_FAILED</name>
--<value>13913</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_IPSEC_INVALID_PACKET</name>
--<value>13914</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_IPSEC_INTEGRITY_CHECK_FAILED</name>
--<value>13915</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_IPSEC_CLEAR_TEXT_DROP</name>
--<value>13916</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_IPSEC_AUTH_FIREWALL_DROP</name>
--<value>13917</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_IPSEC_THROTTLE_DROP</name>
--<value>13918</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_IPSEC_DOSP_BLOCK</name>
--<value>13925</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_IPSEC_DOSP_RECEIVED_MULTICAST</name>
--<value>13926</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_IPSEC_DOSP_INVALID_PACKET</name>
--<value>13927</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_IPSEC_DOSP_STATE_LOOKUP_FAILED</name>
--<value>13928</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_IPSEC_DOSP_MAX_ENTRIES</name>
--<value>13929</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_IPSEC_DOSP_KEYMOD_NOT_ALLOWED</name>
--<value>13930</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_IPSEC_DOSP_NOT_INSTALLED</name>
--<value>13931</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_IPSEC_DOSP_MAX_PER_IP_RATELIMIT_QUEUES</name>
--<value>13932</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_SXS_SECTION_NOT_FOUND</name>
--<value>14000</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_SXS_CANT_GEN_ACTCTX</name>
--<value>14001</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_SXS_INVALID_ACTCTXDATA_FORMAT</name>
--<value>14002</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_SXS_ASSEMBLY_NOT_FOUND</name>
--<value>14003</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_SXS_MANIFEST_FORMAT_ERROR</name>
--<value>14004</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_SXS_MANIFEST_PARSE_ERROR</name>
--<value>14005</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_SXS_ACTIVATION_CONTEXT_DISABLED</name>
--<value>14006</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_SXS_KEY_NOT_FOUND</name>
--<value>14007</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_SXS_VERSION_CONFLICT</name>
--<value>14008</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_SXS_WRONG_SECTION_TYPE</name>
--<value>14009</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_SXS_THREAD_QUERIES_DISABLED</name>
--<value>14010</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_SXS_PROCESS_DEFAULT_ALREADY_SET</name>
--<value>14011</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_SXS_UNKNOWN_ENCODING_GROUP</name>
--<value>14012</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_SXS_UNKNOWN_ENCODING</name>
--<value>14013</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_SXS_INVALID_XML_NAMESPACE_URI</name>
--<value>14014</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_SXS_ROOT_MANIFEST_DEPENDENCY_NOT_INSTALLED</name>
--<value>14015</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_SXS_LEAF_MANIFEST_DEPENDENCY_NOT_INSTALLED</name>
--<value>14016</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_SXS_INVALID_ASSEMBLY_IDENTITY_ATTRIBUTE</name>
--<value>14017</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_SXS_MANIFEST_MISSING_REQUIRED_DEFAULT_NAMESPACE</name>
--<value>14018</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_SXS_MANIFEST_INVALID_REQUIRED_DEFAULT_NAMESPACE</name>
--<value>14019</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_SXS_PRIVATE_MANIFEST_CROSS_PATH_WITH_REPARSE_POINT</name>
--<value>14020</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_SXS_DUPLICATE_DLL_NAME</name>
--<value>14021</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_SXS_DUPLICATE_WINDOWCLASS_NAME</name>
--<value>14022</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_SXS_DUPLICATE_CLSID</name>
--<value>14023</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_SXS_DUPLICATE_IID</name>
--<value>14024</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_SXS_DUPLICATE_TLBID</name>
--<value>14025</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_SXS_DUPLICATE_PROGID</name>
--<value>14026</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_SXS_DUPLICATE_ASSEMBLY_NAME</name>
--<value>14027</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_SXS_FILE_HASH_MISMATCH</name>
--<value>14028</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_SXS_POLICY_PARSE_ERROR</name>
--<value>14029</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_SXS_XML_E_MISSINGQUOTE</name>
--<value>14030</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_SXS_XML_E_COMMENTSYNTAX</name>
--<value>14031</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_SXS_XML_E_BADSTARTNAMECHAR</name>
--<value>14032</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_SXS_XML_E_BADNAMECHAR</name>
--<value>14033</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_SXS_XML_E_BADCHARINSTRING</name>
--<value>14034</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_SXS_XML_E_XMLDECLSYNTAX</name>
--<value>14035</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_SXS_XML_E_BADCHARDATA</name>
--<value>14036</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_SXS_XML_E_MISSINGWHITESPACE</name>
--<value>14037</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_SXS_XML_E_EXPECTINGTAGEND</name>
--<value>14038</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_SXS_XML_E_MISSINGSEMICOLON</name>
--<value>14039</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_SXS_XML_E_UNBALANCEDPAREN</name>
--<value>14040</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_SXS_XML_E_INTERNALERROR</name>
--<value>14041</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_SXS_XML_E_UNEXPECTED_WHITESPACE</name>
--<value>14042</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_SXS_XML_E_INCOMPLETE_ENCODING</name>
--<value>14043</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_SXS_XML_E_MISSING_PAREN</name>
--<value>14044</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_SXS_XML_E_EXPECTINGCLOSEQUOTE</name>
--<value>14045</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_SXS_XML_E_MULTIPLE_COLONS</name>
--<value>14046</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_SXS_XML_E_INVALID_DECIMAL</name>
--<value>14047</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_SXS_XML_E_INVALID_HEXIDECIMAL</name>
--<value>14048</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_SXS_XML_E_INVALID_UNICODE</name>
--<value>14049</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_SXS_XML_E_WHITESPACEORQUESTIONMARK</name>
--<value>14050</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_SXS_XML_E_UNEXPECTEDENDTAG</name>
--<value>14051</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_SXS_XML_E_UNCLOSEDTAG</name>
--<value>14052</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_SXS_XML_E_DUPLICATEATTRIBUTE</name>
--<value>14053</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_SXS_XML_E_MULTIPLEROOTS</name>
--<value>14054</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_SXS_XML_E_INVALIDATROOTLEVEL</name>
--<value>14055</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_SXS_XML_E_BADXMLDECL</name>
--<value>14056</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_SXS_XML_E_MISSINGROOT</name>
--<value>14057</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_SXS_XML_E_UNEXPECTEDEOF</name>
--<value>14058</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_SXS_XML_E_BADPEREFINSUBSET</name>
--<value>14059</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_SXS_XML_E_UNCLOSEDSTARTTAG</name>
--<value>14060</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_SXS_XML_E_UNCLOSEDENDTAG</name>
--<value>14061</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_SXS_XML_E_UNCLOSEDSTRING</name>
--<value>14062</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_SXS_XML_E_UNCLOSEDCOMMENT</name>
--<value>14063</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_SXS_XML_E_UNCLOSEDDECL</name>
--<value>14064</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_SXS_XML_E_UNCLOSEDCDATA</name>
--<value>14065</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_SXS_XML_E_RESERVEDNAMESPACE</name>
--<value>14066</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_SXS_XML_E_INVALIDENCODING</name>
--<value>14067</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_SXS_XML_E_INVALIDSWITCH</name>
--<value>14068</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_SXS_XML_E_BADXMLCASE</name>
--<value>14069</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_SXS_XML_E_INVALID_STANDALONE</name>
--<value>14070</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_SXS_XML_E_UNEXPECTED_STANDALONE</name>
--<value>14071</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_SXS_XML_E_INVALID_VERSION</name>
--<value>14072</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_SXS_XML_E_MISSINGEQUALS</name>
--<value>14073</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_SXS_PROTECTION_RECOVERY_FAILED</name>
--<value>14074</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_SXS_PROTECTION_PUBLIC_KEY_TOO_SHORT</name>
--<value>14075</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_SXS_PROTECTION_CATALOG_NOT_VALID</name>
--<value>14076</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_SXS_UNTRANSLATABLE_HRESULT</name>
--<value>14077</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_SXS_PROTECTION_CATALOG_FILE_MISSING</name>
--<value>14078</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_SXS_MISSING_ASSEMBLY_IDENTITY_ATTRIBUTE</name>
--<value>14079</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_SXS_INVALID_ASSEMBLY_IDENTITY_ATTRIBUTE_NAME</name>
--<value>14080</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_SXS_ASSEMBLY_MISSING</name>
--<value>14081</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_SXS_CORRUPT_ACTIVATION_STACK</name>
--<value>14082</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_SXS_CORRUPTION</name>
--<value>14083</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_SXS_EARLY_DEACTIVATION</name>
--<value>14084</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_SXS_INVALID_DEACTIVATION</name>
--<value>14085</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_SXS_MULTIPLE_DEACTIVATION</name>
--<value>14086</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_SXS_PROCESS_TERMINATION_REQUESTED</name>
--<value>14087</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_SXS_RELEASE_ACTIVATION_CONTEXT</name>
--<value>14088</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_SXS_SYSTEM_DEFAULT_ACTIVATION_CONTEXT_EMPTY</name>
--<value>14089</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_SXS_INVALID_IDENTITY_ATTRIBUTE_VALUE</name>
--<value>14090</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_SXS_INVALID_IDENTITY_ATTRIBUTE_NAME</name>
--<value>14091</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_SXS_IDENTITY_DUPLICATE_ATTRIBUTE</name>
--<value>14092</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_SXS_IDENTITY_PARSE_ERROR</name>
--<value>14093</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_MALFORMED_SUBSTITUTION_STRING</name>
--<value>14094</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_SXS_INCORRECT_PUBLIC_KEY_TOKEN</name>
--<value>14095</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_UNMAPPED_SUBSTITUTION_STRING</name>
--<value>14096</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_SXS_ASSEMBLY_NOT_LOCKED</name>
--<value>14097</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_SXS_COMPONENT_STORE_CORRUPT</name>
--<value>14098</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_ADVANCED_INSTALLER_FAILED</name>
--<value>14099</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_XML_ENCODING_MISMATCH</name>
--<value>14100</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_SXS_MANIFEST_IDENTITY_SAME_BUT_CONTENTS_DIFFERENT</name>
--<value>14101</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_SXS_IDENTITIES_DIFFERENT</name>
--<value>14102</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_SXS_ASSEMBLY_IS_NOT_A_DEPLOYMENT</name>
--<value>14103</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_SXS_FILE_NOT_PART_OF_ASSEMBLY</name>
--<value>14104</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_SXS_MANIFEST_TOO_BIG</name>
--<value>14105</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_SXS_SETTING_NOT_REGISTERED</name>
--<value>14106</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_SXS_TRANSACTION_CLOSURE_INCOMPLETE</name>
--<value>14107</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_SMI_PRIMITIVE_INSTALLER_FAILED</name>
--<value>14108</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_GENERIC_COMMAND_FAILED</name>
--<value>14109</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_SXS_FILE_HASH_MISSING</name>
--<value>14110</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_EVT_INVALID_CHANNEL_PATH</name>
--<value>15000</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_EVT_INVALID_QUERY</name>
--<value>15001</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_EVT_PUBLISHER_METADATA_NOT_FOUND</name>
--<value>15002</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_EVT_EVENT_TEMPLATE_NOT_FOUND</name>
--<value>15003</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_EVT_INVALID_PUBLISHER_NAME</name>
--<value>15004</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_EVT_INVALID_EVENT_DATA</name>
--<value>15005</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_EVT_CHANNEL_NOT_FOUND</name>
--<value>15007</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_EVT_MALFORMED_XML_TEXT</name>
--<value>15008</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_EVT_SUBSCRIPTION_TO_DIRECT_CHANNEL</name>
--<value>15009</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_EVT_CONFIGURATION_ERROR</name>
--<value>15010</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_EVT_QUERY_RESULT_STALE</name>
--<value>15011</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_EVT_QUERY_RESULT_INVALID_POSITION</name>
--<value>15012</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_EVT_NON_VALIDATING_MSXML</name>
--<value>15013</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_EVT_FILTER_ALREADYSCOPED</name>
--<value>15014</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_EVT_FILTER_NOTELTSET</name>
--<value>15015</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_EVT_FILTER_INVARG</name>
--<value>15016</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_EVT_FILTER_INVTEST</name>
--<value>15017</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_EVT_FILTER_INVTYPE</name>
--<value>15018</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_EVT_FILTER_PARSEERR</name>
--<value>15019</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_EVT_FILTER_UNSUPPORTEDOP</name>
--<value>15020</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_EVT_FILTER_UNEXPECTEDTOKEN</name>
--<value>15021</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_EVT_INVALID_OPERATION_OVER_ENABLED_DIRECT_CHANNEL</name>
--<value>15022</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_EVT_INVALID_CHANNEL_PROPERTY_VALUE</name>
--<value>15023</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_EVT_INVALID_PUBLISHER_PROPERTY_VALUE</name>
--<value>15024</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_EVT_CHANNEL_CANNOT_ACTIVATE</name>
--<value>15025</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_EVT_FILTER_TOO_COMPLEX</name>
--<value>15026</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_EVT_MESSAGE_NOT_FOUND</name>
--<value>15027</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_EVT_MESSAGE_ID_NOT_FOUND</name>
--<value>15028</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_EVT_UNRESOLVED_VALUE_INSERT</name>
--<value>15029</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_EVT_UNRESOLVED_PARAMETER_INSERT</name>
--<value>15030</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_EVT_MAX_INSERTS_REACHED</name>
--<value>15031</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_EVT_EVENT_DEFINITION_NOT_FOUND</name>
--<value>15032</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_EVT_MESSAGE_LOCALE_NOT_FOUND</name>
--<value>15033</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_EVT_VERSION_TOO_OLD</name>
--<value>15034</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_EVT_VERSION_TOO_NEW</name>
--<value>15035</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_EVT_CANNOT_OPEN_CHANNEL_OF_QUERY</name>
--<value>15036</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_EVT_PUBLISHER_DISABLED</name>
--<value>15037</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_EVT_FILTER_OUT_OF_RANGE</name>
--<value>15038</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_EC_SUBSCRIPTION_CANNOT_ACTIVATE</name>
--<value>15080</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_EC_LOG_DISABLED</name>
--<value>15081</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_EC_CIRCULAR_FORWARDING</name>
--<value>15082</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_EC_CREDSTORE_FULL</name>
--<value>15083</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_EC_CRED_NOT_FOUND</name>
--<value>15084</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_EC_NO_ACTIVE_CHANNEL</name>
--<value>15085</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_MUI_FILE_NOT_FOUND</name>
--<value>15100</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_MUI_INVALID_FILE</name>
--<value>15101</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_MUI_INVALID_RC_CONFIG</name>
--<value>15102</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_MUI_INVALID_LOCALE_NAME</name>
--<value>15103</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_MUI_INVALID_ULTIMATEFALLBACK_NAME</name>
--<value>15104</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_MUI_FILE_NOT_LOADED</name>
--<value>15105</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_RESOURCE_ENUM_USER_STOP</name>
--<value>15106</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_MUI_INTLSETTINGS_UILANG_NOT_INSTALLED</name>
--<value>15107</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_MUI_INTLSETTINGS_INVALID_LOCALE_NAME</name>
--<value>15108</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_MCA_INVALID_CAPABILITIES_STRING</name>
--<value>15200</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_MCA_INVALID_VCP_VERSION</name>
--<value>15201</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_MCA_MONITOR_VIOLATES_MCCS_SPECIFICATION</name>
--<value>15202</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_MCA_MCCS_VERSION_MISMATCH</name>
--<value>15203</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_MCA_UNSUPPORTED_MCCS_VERSION</name>
--<value>15204</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_MCA_INTERNAL_ERROR</name>
--<value>15205</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_MCA_INVALID_TECHNOLOGY_TYPE_RETURNED</name>
--<value>15206</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_MCA_UNSUPPORTED_COLOR_TEMPERATURE</name>
--<value>15207</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_AMBIGUOUS_SYSTEM_DEVICE</name>
--<value>15250</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_SYSTEM_DEVICE_NOT_FOUND</name>
--<value>15299</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_HASH_NOT_SUPPORTED</name>
--<value>15300</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_HASH_NOT_PRESENT</name>
--<value>15301</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_SECONDARY_IC_PROVIDER_NOT_REGISTERED</name>
--<value>15321</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_GPIO_CLIENT_INFORMATION_INVALID</name>
--<value>15322</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_GPIO_VERSION_NOT_SUPPORTED</name>
--<value>15323</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_GPIO_INVALID_REGISTRATION_PACKET</name>
--<value>15324</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_GPIO_OPERATION_DENIED</name>
--<value>15325</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_GPIO_INCOMPATIBLE_CONNECT_MODE</name>
--<value>15326</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_GPIO_INTERRUPT_ALREADY_UNMASKED</name>
--<value>15327</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_CANNOT_SWITCH_RUNLEVEL</name>
--<value>15400</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_INVALID_RUNLEVEL_SETTING</name>
--<value>15401</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_RUNLEVEL_SWITCH_TIMEOUT</name>
--<value>15402</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_RUNLEVEL_SWITCH_AGENT_TIMEOUT</name>
--<value>15403</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_RUNLEVEL_SWITCH_IN_PROGRESS</name>
--<value>15404</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_SERVICES_FAILED_AUTOSTART</name>
--<value>15405</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_COM_TASK_STOP_PENDING</name>
--<value>15501</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_INSTALL_OPEN_PACKAGE_FAILED</name>
--<value>15600</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_INSTALL_PACKAGE_NOT_FOUND</name>
--<value>15601</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_INSTALL_INVALID_PACKAGE</name>
--<value>15602</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_INSTALL_RESOLVE_DEPENDENCY_FAILED</name>
--<value>15603</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_INSTALL_OUT_OF_DISK_SPACE</name>
--<value>15604</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_INSTALL_NETWORK_FAILURE</name>
--<value>15605</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_INSTALL_REGISTRATION_FAILURE</name>
--<value>15606</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_INSTALL_DEREGISTRATION_FAILURE</name>
--<value>15607</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_INSTALL_CANCEL</name>
--<value>15608</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_INSTALL_FAILED</name>
--<value>15609</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_REMOVE_FAILED</name>
--<value>15610</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_PACKAGE_ALREADY_EXISTS</name>
--<value>15611</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_NEEDS_REMEDIATION</name>
--<value>15612</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_INSTALL_PREREQUISITE_FAILED</name>
--<value>15613</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_PACKAGE_REPOSITORY_CORRUPTED</name>
--<value>15614</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_INSTALL_POLICY_FAILURE</name>
--<value>15615</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_PACKAGE_UPDATING</name>
--<value>15616</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_DEPLOYMENT_BLOCKED_BY_POLICY</name>
--<value>15617</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_PACKAGES_IN_USE</name>
--<value>15618</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ERROR_RECOVERY_FILE_CORRUPT</name>
--<value>15619</value>
--<desc></desc>
--</constant>

  ERROR_INVALID_STAGED_SIGNATURE                            = 15620,  -- (#3D04)
--<constant>
--<name>ERROR_INVALID_STAGED_SIGNATURE</name>
--<value>15620</value>
--<desc>
-- The signature is invalid. To register in developer mode, AppxSignature.p7x
-- and AppxBlockMap.xml must be valid or should not be present.
--</desc>
--</constant>

  ERROR_DELETING_EXISTING_APPLICATIONDATA_STORE_FAILED      = 15621,  -- (#3D05)
--<constant>
--<name>ERROR_DELETING_EXISTING_APPLICATIONDATA_STORE_FAILED</name>
--<value>15621</value>
--<desc>
-- An error occurred while deleting the package's previously existing
-- application data.
--</desc>
--</constant>

  ERROR_INSTALL_PACKAGE_DOWNGRADE                           = 15622,  -- (#3D06)
--<constant>
--<name>ERROR_INSTALL_PACKAGE_DOWNGRADE</name>
--<value>15622</value>
--<desc>
-- The package could not be installed because a higher version of this package
-- is already installed.
--</desc>
--</constant>

  ERROR_SYSTEM_NEEDS_REMEDIATION                            = 15623,  -- (#3D07)
--<constant>
--<name>ERROR_SYSTEM_NEEDS_REMEDIATION</name>
--<value>15623</value>
--<desc>
-- An error in a system binary was detected. Try refreshing the PC to fix the
-- problem.
--</desc>
--</constant>

  ERROR_APPX_INTEGRITY_FAILURE_CLR_NGEN                     = 15624,  -- (#3D08)
--<constant>
--<name>ERROR_APPX_INTEGRITY_FAILURE_CLR_NGEN</name>
--<value>15624</value>
--<desc>A corrupted CLR NGEN binary was detected on the system.</desc>
--</constant>

  ERROR_RESILIENCY_FILE_CORRUPT                             = 15625,  -- (#3D09)
--<constant>
--<name>ERROR_RESILIENCY_FILE_CORRUPT</name>
--<value>15625</value>
--<desc>
-- The operation could not be resumed because necessary data for recovery have
-- been corrupted.
--</desc>
--</constant>

  ERROR_INSTALL_FIREWALL_SERVICE_NOT_RUNNING                = 15626,  -- (#3D0A)
--<constant>
--<name>ERROR_INSTALL_FIREWALL_SERVICE_NOT_RUNNING</name>
--<value>15626</value>
--<desc>
-- The package could not be installed because the Windows Firewall service is
-- not running. Enable the Windows Firewall service and try again.
--</desc>
--</constant>

  ERROR_NO_PACKAGE                                          = 15700,  -- (#3D54)
--<constant>
--<name>ERROR_NO_PACKAGE</name>
--<value>15700</value>
--<desc>The process has no package identity.</desc>
--</constant>

  ERROR_PACKAGE_RUNTIME_CORRUPT                             = 15701,  -- (#3D55)
--<constant>
--<name>ERROR_PACKAGE_RUNTIME_CORRUPT</name>
--<value>15701</value>
--<desc>The package runtime information is corrupted.</desc>
--</constant>

  ERROR_PACKAGE_IDENTITY_CORRUPT                            = 15702,  -- (#3D56)
--<constant>
--<name>ERROR_PACKAGE_IDENTITY_CORRUPT</name>
--<value>15702</value>
--<desc>The package identity is corrupted.</desc>
--</constant>

  ERROR_NO_APPLICATION                                      = 15703,  -- (#3D57)
--<constant>
--<name>ERROR_NO_APPLICATION</name>
--<value>15703</value>
--<desc>The process has no application identity.</desc>
--</constant>

  ERROR_STATE_LOAD_STORE_FAILED                             = 15800,  -- (#3DB8)
--<constant>
--<name>ERROR_STATE_LOAD_STORE_FAILED</name>
--<value>15800</value>
--<desc>Loading the state store failed.</desc>
--</constant>

  ERROR_STATE_GET_VERSION_FAILED                            = 15801,  -- (#3DB9)
--<constant>
--<name>ERROR_STATE_GET_VERSION_FAILED</name>
--<value>15801</value>
--<desc>Retrieving the state version for the application failed.</desc>
--</constant>

  ERROR_STATE_SET_VERSION_FAILED                            = 15802,  -- (#3DBA)
--<constant>
--<name>ERROR_STATE_SET_VERSION_FAILED</name>
--<value>15802</value>
--<desc>Setting the state version for the application failed.</desc>
--</constant>

  ERROR_STATE_STRUCTURED_RESET_FAILED                       = 15803,  -- (#3DBB)
--<constant>
--<name>ERROR_STATE_STRUCTURED_RESET_FAILED</name>
--<value>15803</value>
--<desc>Resetting the structured state of the application failed.</desc>
--</constant>

  ERROR_STATE_OPEN_CONTAINER_FAILED                         = 15804,  -- (#3DBC)
--<constant>
--<name>ERROR_STATE_OPEN_CONTAINER_FAILED</name>
--<value>15804</value>
--<desc>State Manager failed to open the container.</desc>
--</constant>

  ERROR_STATE_CREATE_CONTAINER_FAILED                       = 15805,  -- (#3DBD)
--<constant>
--<name>ERROR_STATE_CREATE_CONTAINER_FAILED</name>
--<value>15805</value>
--<desc>State Manager failed to create the container.</desc>
--</constant>

  ERROR_STATE_DELETE_CONTAINER_FAILED                       = 15806,  -- (#3DBE)
--<constant>
--<name>ERROR_STATE_DELETE_CONTAINER_FAILED</name>
--<value>15806</value>
--<desc>State Manager failed to delete the container.</desc>
--</constant>

  ERROR_STATE_READ_SETTING_FAILED                           = 15807,  -- (#3DBF)
--<constant>
--<name>ERROR_STATE_READ_SETTING_FAILED</name>
--<value>15807</value>
--<desc>State Manager failed to read the setting.</desc>
--</constant>

  ERROR_STATE_WRITE_SETTING_FAILED                          = 15808,  -- (#3DC0)
--<constant>
--<name>ERROR_STATE_WRITE_SETTING_FAILED</name>
--<value>15808</value>
--<desc>State Manager failed to write the setting.</desc>
--</constant>

  ERROR_STATE_DELETE_SETTING_FAILED                         = 15809,  -- (#3DC1)
--<constant>
--<name>ERROR_STATE_DELETE_SETTING_FAILED</name>
--<value>15809</value>
--<desc>State Manager failed to delete the setting.</desc>
--</constant>

  ERROR_STATE_QUERY_SETTING_FAILED                          = 15810,  -- (#3DC2)
--<constant>
--<name>ERROR_STATE_QUERY_SETTING_FAILED</name>
--<value>15810</value>
--<desc>State Manager failed to query the setting.</desc>
--</constant>

  ERROR_STATE_READ_COMPOSITE_SETTING_FAILED                 = 15811,  -- (#3DC3)
--<constant>
--<name>ERROR_STATE_READ_COMPOSITE_SETTING_FAILED</name>
--<value>15811</value>
--<desc>State Manager failed to read the composite setting.</desc>
--</constant>

  ERROR_STATE_WRITE_COMPOSITE_SETTING_FAILED                = 15812,  -- (#3DC4)
--<constant>
--<name>ERROR_STATE_WRITE_COMPOSITE_SETTING_FAILED</name>
--<value>15812</value>
--<desc>State Manager failed to write the composite setting.</desc>
--</constant>

  ERROR_STATE_ENUMERATE_CONTAINER_FAILED                    = 15813,  -- (#3DC5)
--<constant>
--<name>ERROR_STATE_ENUMERATE_CONTAINER_FAILED</name>
--<value>15813</value>
--<desc>State Manager failed to enumerate the containers.</desc>
--</constant>

  ERROR_STATE_ENUMERATE_SETTINGS_FAILED                     = 15814,  -- (#3DC6)
--<constant>
--<name>ERROR_STATE_ENUMERATE_SETTINGS_FAILED</name>
--<value>15814</value>
--<desc>State Manager failed to enumerate the settings.</desc>
--</constant>

  ERROR_STATE_COMPOSITE_SETTING_VALUE_SIZE_LIMIT_EXCEEDED   = 15815,  -- (#3DC7)
--<constant>
--<name>ERROR_STATE_COMPOSITE_SETTING_VALUE_SIZE_LIMIT_EXCEEDED</name>
--<value>15815</value>
--<desc>The size of the state manager composite setting value has exceeded the limit.</desc>
--</constant>

  ERROR_STATE_SETTING_VALUE_SIZE_LIMIT_EXCEEDED             = 15816,  -- (#3DC8)
--<constant>
--<name>ERROR_STATE_SETTING_VALUE_SIZE_LIMIT_EXCEEDED</name>
--<value>15816</value>
--<desc>The size of the state manager setting value has exceeded the limit.</desc>
--</constant>

  ERROR_STATE_SETTING_NAME_SIZE_LIMIT_EXCEEDED              = 15817,  -- (#3DC9)
--<constant>
--<name>ERROR_STATE_SETTING_NAME_SIZE_LIMIT_EXCEEDED</name>
--<value>15817</value>
--<desc>The length of the state manager setting name has exceeded the limit.</desc>
--</constant>

  ERROR_STATE_CONTAINER_NAME_SIZE_LIMIT_EXCEEDED            = 15818   -- (#3DCA)
--<constant>
--<name>ERROR_STATE_CONTAINER_NAME_SIZE_LIMIT_EXCEEDED</name>
--<value>15818</value>
--<desc>The length of the state manager container name has exceeded the limit.</desc>
--</constant>


