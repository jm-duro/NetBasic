-- _curl_constants_.e

include std/math.e

--------------------------------------------------------------------------------

public constant
  CURL_HTTPPOST_FILENAME    =   1,
--<constant>
--<name>CURL_HTTPPOST_FILENAME</name>
--<value>1</value>
--<desc>specified content is a file name</desc>
--</constant>
  CURL_HTTPPOST_READFILE    =   2,
--<constant>
--<name>CURL_HTTPPOST_READFILE</name>
--<value>2</value>
--<desc>specified content is a file name</desc>
--</constant>
  CURL_HTTPPOST_PTRNAME     =   4,
--<constant>
--<name>CURL_HTTPPOST_PTRNAME</name>
--<value>4</value>
--<desc>name is only stored pointer do not free in formfree</desc>
--</constant>
  CURL_HTTPPOST_PTRCONTENTS =   8,
--<constant>
--<name>CURL_HTTPPOST_PTRCONTENTS</name>
--<value>8</value>
--<desc>contents is only stored pointer do not free in formfree</desc>
--</constant>
  CURL_HTTPPOST_BUFFER      =  16,  --
--<constant>
--<name>CURL_HTTPPOST_BUFFER</name>
--<value>16</value>
--<desc>upload file from buffer</desc>
--</constant>
  CURL_HTTPPOST_PTRBUFFER   =  32,  --
--<constant>
--<name>CURL_HTTPPOST_PTRBUFFER</name>
--<value>32</value>
--<desc>upload file from pointer contents</desc>
--</constant>
  CURL_HTTPPOST_CALLBACK    =  64,
--<constant>
--<name>CURL_HTTPPOST_CALLBACK</name>
--<value>64</value>
--<desc>
-- upload file contents by using the regular read callback to get the data and
-- pass the given pointer as custom pointer
--</desc>
--</constant>
  CURL_HTTPPOST_LARGE       = 128
--<constant>
--<name>CURL_HTTPPOST_LARGE</name>
--<value>128</value>
--<desc>use size in 'contentlen'</desc>
--</constant>

--------------------------------------------------------------------------------

public constant CURL_MAX_WRITE_SIZE = 16384
--<constant>
--<name>CURL_MAX_WRITE_SIZE</name>
--<value>16384</value>
--<desc>
--   Tests have proven that 20K is a very bad buffer size for uploads on
--      Windows, while 16K for some odd reason performed a lot better.
--      We do the ifndef check to allow this value to easier be changed at build
--      time for those who feel adventurous. The practical minimum is about
--      400 bytes since libcurl uses a buffer of this size as a scratch area
--      (unrelated to network send operations).
--</desc>
--</constant>

public constant CURL_MAX_HTTP_HEADER = (100*1024)
--<constant>
--<name>CURL_MAX_HTTP_HEADER</name>
--<value>(100*1024)</value>
--<desc>
-- The only reason to have a max limit for this is to avoid the risk of a bad
--    server feeding libcurl with a never-ending header that will cause reallocs
--    infinitely
--</desc>
--</constant>

public constant CURL_WRITEFUNC_PAUSE = #10000001
--<constant>
--<name>CURL_WRITEFUNC_PAUSE</name>
--<value>#10000001</value>
--<desc>
-- This is a magic return code for the write callback that, when returned,
--    will signal libcurl to pause receiving on the current transfer.
--</desc>
--</constant>

--------------------------------------------------------------------------------

-- enumeration of file types
public constant
  CURLFILETYPE_FILE         = 0,
--<constant>
--<name>CURLFILETYPE_FILE</name>
--<value>0</value>
--<desc></desc>
--</constant>
  CURLFILETYPE_DIRECTORY    = 1,
--<constant>
--<name>CURLFILETYPE_DIRECTORY</name>
--<value>1</value>
--<desc></desc>
--</constant>
  CURLFILETYPE_SYMLINK      = 2,
--<constant>
--<name>CURLFILETYPE_SYMLINK</name>
--<value>2</value>
--<desc></desc>
--</constant>
  CURLFILETYPE_DEVICE_BLOCK = 3,
--<constant>
--<name>CURLFILETYPE_DEVICE_BLOCK</name>
--<value>3</value>
--<desc></desc>
--</constant>
  CURLFILETYPE_DEVICE_CHAR  = 4,
--<constant>
--<name>CURLFILETYPE_DEVICE_CHAR</name>
--<value>4</value>
--<desc></desc>
--</constant>
  CURLFILETYPE_NAMEDPIPE    = 5,
--<constant>
--<name>CURLFILETYPE_NAMEDPIPE</name>
--<value>5</value>
--<desc></desc>
--</constant>
  CURLFILETYPE_SOCKET       = 6,
--<constant>
--<name>CURLFILETYPE_SOCKET</name>
--<value>6</value>
--<desc></desc>
--</constant>
  CURLFILETYPE_DOOR         = 7,
--<constant>
--<name>CURLFILETYPE_DOOR</name>
--<value>7</value>
--<desc>is possible only on Sun Solaris now</desc>
--</constant>
  CURLFILETYPE_UNKNOWN      = 8
--<constant>
--<name>CURLFILETYPE_UNKNOWN</name>
--<value>8</value>
--<desc>should never occur</desc>
--</constant>

public type curlfiletype(integer n)
--<type>
--<name>curlfiletype</name>
--<desc></desc>
--</type>
  return ((n >= CURLFILETYPE_FILE) and (n <= CURLFILETYPE_UNKNOWN))
end type

--------------------------------------------------------------------------------

public constant
  CURLFINFOFLAG_KNOWN_FILENAME   =   1,
--<constant>
--<name>CURLFINFOFLAG_KNOWN_FILENAME</name>
--<value>1</value>
--<desc></desc>
--</constant>
  CURLFINFOFLAG_KNOWN_FILETYPE   =   2,
--<constant>
--<name>CURLFINFOFLAG_KNOWN_FILETYPE</name>
--<value>2</value>
--<desc></desc>
--</constant>
  CURLFINFOFLAG_KNOWN_TIME       =   4,
--<constant>
--<name>CURLFINFOFLAG_KNOWN_TIME</name>
--<value>4</value>
--<desc></desc>
--</constant>
  CURLFINFOFLAG_KNOWN_PERM       =   8,
--<constant>
--<name>CURLFINFOFLAG_KNOWN_PERM</name>
--<value>8</value>
--<desc></desc>
--</constant>
  CURLFINFOFLAG_KNOWN_UID        =  16,
--<constant>
--<name>CURLFINFOFLAG_KNOWN_UID</name>
--<value>16</value>
--<desc></desc>
--</constant>
  CURLFINFOFLAG_KNOWN_GID        =  32,
--<constant>
--<name>CURLFINFOFLAG_KNOWN_GID</name>
--<value>32</value>
--<desc></desc>
--</constant>
  CURLFINFOFLAG_KNOWN_SIZE       =  64,
--<constant>
--<name>CURLFINFOFLAG_KNOWN_SIZE</name>
--<value>64</value>
--<desc></desc>
--</constant>
  CURLFINFOFLAG_KNOWN_HLINKCOUNT = 128
--<constant>
--<name>CURLFINFOFLAG_KNOWN_HLINKCOUNT</name>
--<value>128</value>
--<desc></desc>
--</constant>

--------------------------------------------------------------------------------

-- return codes for CURLOPT_CHUNK_BGN_FUNCTION
public constant
  CURL_CHUNK_BGN_FUNC_OK   = 0,
--<constant>
--<name>CURL_CHUNK_BGN_FUNC_OK</name>
--<value>0</value>
--<desc></desc>
--</constant>
  CURL_CHUNK_BGN_FUNC_FAIL = 1,
--<constant>
--<name>CURL_CHUNK_BGN_FUNC_FAIL</name>
--<value>1</value>
--<desc>tell the lib to end the task</desc>
--</constant>
  CURL_CHUNK_BGN_FUNC_SKIP = 2
--<constant>
--<name>CURL_CHUNK_BGN_FUNC_SKIP</name>
--<value>2</value>
--<desc>skip this chunk over</desc>
--</constant>

--------------------------------------------------------------------------------

-- return codes for CURLOPT_CHUNK_END_FUNCTION
public constant
  CURL_CHUNK_END_FUNC_OK   = 0,
--<constant>
--<name>CURL_CHUNK_END_FUNC_OK</name>
--<value>0</value>
--<desc></desc>
--</constant>
  CURL_CHUNK_END_FUNC_FAIL = 1
--<constant>
--<name>CURL_CHUNK_END_FUNC_FAIL</name>
--<value>1</value>
--<desc>tell the lib to end the task</desc>
--</constant>

--------------------------------------------------------------------------------

-- return codes for FNMATCHFUNCTION
public constant
  CURL_FNMATCHFUNC_MATCH   = 0,
--<constant>
--<name>CURL_FNMATCHFUNC_MATCH</name>
--<value>0</value>
--<desc>string corresponds to the pattern</desc>
--</constant>
  CURL_FNMATCHFUNC_NOMATCH = 1,
--<constant>
--<name>CURL_FNMATCHFUNC_NOMATCH</name>
--<value>1</value>
--<desc>pattern doesn't match the string</desc>
--</constant>
  CURL_FNMATCHFUNC_FAIL    = 2
--<constant>
--<name>CURL_FNMATCHFUNC_FAIL</name>
--<value>2</value>
--<desc>an error occurred</desc>
--</constant>

--------------------------------------------------------------------------------

-- These are the return codes for the seek callbacks
public constant
  CURL_SEEKFUNC_OK       = 0,
--<constant>
--<name>CURL_SEEKFUNC_OK</name>
--<value>0</value>
--<desc></desc>
--</constant>
  CURL_SEEKFUNC_FAIL     = 1,
--<constant>
--<name>CURL_SEEKFUNC_FAIL</name>
--<value>1</value>
--<desc>fail the entire transfer</desc>
--</constant>
  CURL_SEEKFUNC_CANTSEEK = 2
--<constant>
--<name>CURL_SEEKFUNC_CANTSEEK</name>
--<value>2</value>
--<desc>
--tell libcurl seeking can't be done, so libcurl might try other means instead
--</desc>
--</constant>

--------------------------------------------------------------------------------

public constant CURL_READFUNC_ABORT = #10000000
--<constant>
--<name>CURL_READFUNC_ABORT</name>
--<value>#10000000</value>
--<desc>
-- This is a return code for the read callback that, when returned, will
--    signal libcurl to immediately abort the current transfer.
--</desc>
--</constant>

public constant CURL_READFUNC_PAUSE = #10000001
--<constant>
--<name>CURL_READFUNC_PAUSE</name>
--<value>#10000001</value>
--<desc>
-- This is a return code for the read callback that, when returned, will
--    signal libcurl to pause sending data on the current transfer.
--</desc>
--</constant>

--------------------------------------------------------------------------------

public constant
  CURLSOCKTYPE_IPCXN  = 0,
--<constant>
--<name>CURLSOCKTYPE_IPCXN</name>
--<value>0</value>
--<desc>socket created for a specific IP connection</desc>
--</constant>
  CURLSOCKTYPE_ACCEPT = 1,
--<constant>
--<name>CURLSOCKTYPE_ACCEPT</name>
--<value>1</value>
--<desc>socket created by accept() call</desc>
--</constant>
  CURLSOCKTYPE_LAST   = 2
--<constant>
--<name>CURLSOCKTYPE_LAST</name>
--<value>2</value>
--<desc>never use</desc>
--</constant>

public type curlsocktype(integer n)
--<type>
--<name>curlsocktype</name>
--<desc></desc>
--</type>
  return ((n >= CURLSOCKTYPE_IPCXN) and (n <= CURLSOCKTYPE_LAST))
end type

--------------------------------------------------------------------------------

-- The return code from the sockopt_callback can signal information back
--    to libcurl:
public constant
  CURL_SOCKOPT_OK                = 0,
--<constant>
--<name>CURL_SOCKOPT_OK</name>
--<value>0</value>
--<desc></desc>
--</constant>
  CURL_SOCKOPT_ERROR             = 1,
--<constant>
--<name>CURL_SOCKOPT_ERROR</name>
--<value>1</value>
--<desc>causes libcurl to abort and return CURLE_ABORTED_BY_CALLBACK</desc>
--</constant>
  CURL_SOCKOPT_ALREADY_CONNECTED = 2
--<constant>
--<name>CURL_SOCKOPT_ALREADY_CONNECTED</name>
--<value>2</value>
--<desc></desc>
--</constant>

--------------------------------------------------------------------------------

public constant
  CURLIOE_OK          = 0,
--<constant>
--<name>CURLIOE_OK</name>
--<value>0</value>
--<desc>I/O operation successful</desc>
--</constant>
  CURLIOE_UNKNOWNCMD  = 1,
--<constant>
--<name>CURLIOE_UNKNOWNCMD</name>
--<value>1</value>
--<desc>command was unknown to callback</desc>
--</constant>
  CURLIOE_FAILRESTART = 2,
--<constant>
--<name>CURLIOE_FAILRESTART</name>
--<value>2</value>
--<desc>failed to restart the read</desc>
--</constant>
  CURLIOE_LAST        = 3
--<constant>
--<name>CURLIOE_LAST</name>
--<value>3</value>
--<desc>never use</desc>
--</constant>

public type curlioerr(integer n)
--<type>
--<name>curlioerr</name>
--<desc></desc>
--</type>
  return ((n >= CURLIOE_OK) and (n <= CURLIOE_LAST))
end type

--------------------------------------------------------------------------------

public constant
  CURLIOCMD_NOP         = 0,
--<constant>
--<name>CURLIOCMD_NOP</name>
--<value>0</value>
--<desc>no operation</desc>
--</constant>
  CURLIOCMD_RESTARTREAD = 1,
--<constant>
--<name>CURLIOCMD_RESTARTREAD</name>
--<value>1</value>
--<desc>restart the read stream from start</desc>
--</constant>
  CURLIOCMD_LAST        = 2
--<constant>
--<name>CURLIOCMD_LAST</name>
--<value>2</value>
--<desc>never use</desc>
--</constant>

public type curliocmd(integer n)
--<type>
--<name>curliocmd</name>
--<desc></desc>
--</type>
  return ((n >= CURLIOCMD_NOP) and (n <= CURLIOCMD_LAST))
end type

--------------------------------------------------------------------------------

-- the kind of data that is passed to information_callback*/
public constant
  CURLINFO_TEXT         = 0,
--<constant>
--<name>CURLINFO_TEXT</name>
--<value>0</value>
--<desc></desc>
--</constant>
  CURLINFO_HEADER_IN    = 1,
--<constant>
--<name>CURLINFO_HEADER_IN</name>
--<value>1</value>
--<desc></desc>
--</constant>
  CURLINFO_HEADER_OUT   = 2,
--<constant>
--<name>CURLINFO_HEADER_OUT</name>
--<value>2</value>
--<desc></desc>
--</constant>
  CURLINFO_DATA_IN      = 3,
--<constant>
--<name>CURLINFO_DATA_IN</name>
--<value>3</value>
--<desc></desc>
--</constant>
  CURLINFO_DATA_OUT     = 4,
--<constant>
--<name>CURLINFO_DATA_OUT</name>
--<value>4</value>
--<desc></desc>
--</constant>
  CURLINFO_SSL_DATA_IN  = 5,
--<constant>
--<name>CURLINFO_SSL_DATA_IN</name>
--<value>5</value>
--<desc></desc>
--</constant>
  CURLINFO_SSL_DATA_OUT = 6,
--<constant>
--<name>CURLINFO_SSL_DATA_OUT</name>
--<value>6</value>
--<desc></desc>
--</constant>
  CURLINFO_END          = 7
--<constant>
--<name>CURLINFO_END</name>
--<value>7</value>
--<desc></desc>
--</constant>

public type curl_infotype(integer n)
--<type>
--<name>curl_infotype</name>
--<desc></desc>
--</type>
  return ((n >= CURLINFO_TEXT) and (n <= CURLINFO_END))
end type

--------------------------------------------------------------------------------

-- All possible error codes from all sorts of curl functions. Future versions
--    may return other values, stay prepared.

--    Always add new return codes last. Never *EVER* remove any. The return
--    codes must remain the same!

public constant
  CURLE_OK                       =  0,
--<constant>
--<name>CURLE_OK</name>
--<value>0</value>
--<desc></desc>
--</constant>
  CURLE_UNSUPPORTED_PROTOCOL     =  1,
--<constant>
--<name>CURLE_UNSUPPORTED_PROTOCOL</name>
--<value>1</value>
--<desc></desc>
--</constant>
  CURLE_FAILED_INIT              =  2,
--<constant>
--<name>CURLE_FAILED_INIT</name>
--<value>2</value>
--<desc></desc>
--</constant>
  CURLE_URL_MALFORMAT            =  3,
--<constant>
--<name>CURLE_URL_MALFORMAT</name>
--<value>3</value>
--<desc></desc>
--</constant>
  CURLE_NOT_BUILT_IN             =  4,
--<constant>
--<name>CURLE_NOT_BUILT_IN</name>
--<value>4</value>
--<desc></desc>
--</constant>
  CURLE_COULDNT_RESOLVE_PROXY    =  5,
--<constant>
--<name>CURLE_COULDNT_RESOLVE_PROXY</name>
--<value>5</value>
--<desc></desc>
--</constant>
  CURLE_COULDNT_RESOLVE_HOST     =  6,
--<constant>
--<name>CURLE_COULDNT_RESOLVE_HOST</name>
--<value>6</value>
--<desc></desc>
--</constant>
  CURLE_COULDNT_CONNECT          =  7,
--<constant>
--<name>CURLE_COULDNT_CONNECT</name>
--<value>7</value>
--<desc></desc>
--</constant>
  CURLE_FTP_WEIRD_SERVER_REPLY   =  8,
--<constant>
--<name>CURLE_FTP_WEIRD_SERVER_REPLY</name>
--<value>8</value>
--<desc></desc>
--</constant>
  CURLE_REMOTE_ACCESS_DENIED     =  9,
--<constant>
--<name>CURLE_REMOTE_ACCESS_DENIED</name>
--<value>9</value>
--<desc>
-- a service was denied by the server due to lack of access - when login fails
--   this is not returned.
--</desc>
--</constant>
  CURLE_FTP_ACCEPT_FAILED        = 10,
--<constant>
--<name>CURLE_FTP_ACCEPT_FAILED</name>
--<value>10</value>
--<desc></desc>
--</constant>
  CURLE_FTP_WEIRD_PASS_REPLY     = 11,
--<constant>
--<name>CURLE_FTP_WEIRD_PASS_REPLY</name>
--<value>11</value>
--<desc></desc>
--</constant>
  CURLE_FTP_ACCEPT_TIMEOUT       = 12,
--<constant>
--<name>CURLE_FTP_ACCEPT_TIMEOUT</name>
--<value>12</value>
--<desc>timeout occurred accepting server</desc>
--</constant>
  CURLE_FTP_WEIRD_PASV_REPLY     = 13,
--<constant>
--<name>CURLE_FTP_WEIRD_PASV_REPLY</name>
--<value>13</value>
--<desc></desc>
--</constant>
  CURLE_FTP_WEIRD_227_FORMAT     = 14,
--<constant>
--<name>CURLE_FTP_WEIRD_227_FORMAT</name>
--<value>14</value>
--<desc></desc>
--</constant>
  CURLE_FTP_CANT_GET_HOST        = 15,
--<constant>
--<name>CURLE_FTP_CANT_GET_HOST</name>
--<value>15</value>
--<desc></desc>
--</constant>
  CURLE_HTTP2                    = 16,
--<constant>
--<name>CURLE_HTTP2</name>
--<value>16</value>
--<desc>A problem in the http2 framing layer.</desc>
--</constant>
  CURLE_FTP_COULDNT_SET_TYPE     = 17,
--<constant>
--<name>CURLE_FTP_COULDNT_SET_TYPE</name>
--<value>17</value>
--<desc></desc>
--</constant>
  CURLE_PARTIAL_FILE             = 18,
--<constant>
--<name>CURLE_PARTIAL_FILE</name>
--<value>18</value>
--<desc></desc>
--</constant>
  CURLE_FTP_COULDNT_RETR_FILE    = 19,
--<constant>
--<name>CURLE_FTP_COULDNT_RETR_FILE</name>
--<value>19</value>
--<desc></desc>
--</constant>
  CURLE_OBSOLETE20               = 20,
--<constant>
--<name>CURLE_OBSOLETE20</name>
--<value>20</value>
--<desc>NOT USED</desc>
--</constant>
  CURLE_QUOTE_ERROR              = 21,
--<constant>
--<name>CURLE_QUOTE_ERROR</name>
--<value>21</value>
--<desc>quote command failure</desc>
--</constant>
  CURLE_HTTP_RETURNED_ERROR      = 22,
--<constant>
--<name>CURLE_HTTP_RETURNED_ERROR</name>
--<value>22</value>
--<desc></desc>
--</constant>
  CURLE_WRITE_ERROR              = 23,
--<constant>
--<name>CURLE_WRITE_ERROR</name>
--<value>23</value>
--<desc></desc>
--</constant>
  CURLE_OBSOLETE24               = 24,
--<constant>
--<name>CURLE_OBSOLETE24</name>
--<value>24</value>
--<desc>NOT USED</desc>
--</constant>
  CURLE_UPLOAD_FAILED            = 25,
--<constant>
--<name>CURLE_UPLOAD_FAILED</name>
--<value>25</value>
--<desc>failed upload "command"</desc>
--</constant>
  CURLE_READ_ERROR               = 26,
--<constant>
--<name>CURLE_READ_ERROR</name>
--<value>26</value>
--<desc>couldn't open/read from file</desc>
--</constant>
  CURLE_OUT_OF_MEMORY            = 27,
--<constant>
--<name>CURLE_OUT_OF_MEMORY</name>
--<value>27</value>
--<desc>
  -- Note: CURLE_OUT_OF_MEMORY may sometimes indicate a conversion error
  --         instead of a memory allocation error if CURL_DOES_CONVERSIONS
  --         is defined
--</desc>
--</constant>
  CURLE_OPERATION_TIMEDOUT       = 28,
--<constant>
--<name>CURLE_OPERATION_TIMEDOUT</name>
--<value>28</value>
--<desc>the timeout time was reached</desc>
--</constant>
  CURLE_OBSOLETE29               = 29,
--<constant>
--<name>CURLE_OBSOLETE29</name>
--<value>29</value>
--<desc>NOT USED</desc>
--</constant>
  CURLE_FTP_PORT_FAILED          = 30,
--<constant>
--<name>CURLE_FTP_PORT_FAILED</name>
--<value>30</value>
--<desc>FTP PORT operation failed</desc>
--</constant>
  CURLE_FTP_COULDNT_USE_REST     = 31,
--<constant>
--<name>CURLE_FTP_COULDNT_USE_REST</name>
--<value>31</value>
--<desc>the REST command failed</desc>
--</constant>
  CURLE_OBSOLETE32               = 32,
--<constant>
--<name>CURLE_OBSOLETE32</name>
--<value>32</value>
--<desc>NOT USED</desc>
--</constant>
  CURLE_RANGE_ERROR              = 33,
--<constant>
--<name>CURLE_RANGE_ERROR</name>
--<value>33</value>
--<desc>RANGE "command" didn't work</desc>
--</constant>
  CURLE_HTTP_POST_ERROR          = 34,
--<constant>
--<name>CURLE_HTTP_POST_ERROR</name>
--<value>34</value>
--<desc></desc>
--</constant>
  CURLE_SSL_CONNECT_ERROR        = 35,
--<constant>
--<name>CURLE_SSL_CONNECT_ERROR</name>
--<value>35</value>
--<desc>wrong when connecting with SSL</desc>
--</constant>
  CURLE_BAD_DOWNLOAD_RESUME      = 36,
--<constant>
--<name>CURLE_BAD_DOWNLOAD_RESUME</name>
--<value>36</value>
--<desc>couldn't resume download</desc>
--</constant>
  CURLE_FILE_COULDNT_READ_FILE   = 37,
--<constant>
--<name>CURLE_FILE_COULDNT_READ_FILE</name>
--<value>37</value>
--<desc></desc>
--</constant>
  CURLE_LDAP_CANNOT_BIND         = 38,
--<constant>
--<name>CURLE_LDAP_CANNOT_BIND</name>
--<value>38</value>
--<desc></desc>
--</constant>
  CURLE_LDAP_SEARCH_FAILED       = 39,
--<constant>
--<name>CURLE_LDAP_SEARCH_FAILED</name>
--<value>39</value>
--<desc></desc>
--</constant>
  CURLE_OBSOLETE40               = 40,
--<constant>
--<name>CURLE_OBSOLETE40</name>
--<value>40</value>
--<desc>NOT USED</desc>
--</constant>
  CURLE_FUNCTION_NOT_FOUND       = 41,
--<constant>
--<name>CURLE_FUNCTION_NOT_FOUND</name>
--<value>41</value>
--<desc></desc>
--</constant>
  CURLE_ABORTED_BY_CALLBACK      = 42,
--<constant>
--<name>CURLE_ABORTED_BY_CALLBACK</name>
--<value>42</value>
--<desc></desc>
--</constant>
  CURLE_BAD_FUNCTION_ARGUMENT    = 43,
--<constant>
--<name>CURLE_BAD_FUNCTION_ARGUMENT</name>
--<value>43</value>
--<desc></desc>
--</constant>
  CURLE_OBSOLETE44               = 44,
--<constant>
--<name>CURLE_OBSOLETE44</name>
--<value>44</value>
--<desc>NOT USED</desc>
--</constant>
  CURLE_INTERFACE_FAILED         = 45,
--<constant>
--<name>CURLE_INTERFACE_FAILED</name>
--<value>45</value>
--<desc>CURLOPT_INTERFACE failed</desc>
--</constant>
  CURLE_OBSOLETE46               = 46,
--<constant>
--<name>CURLE_OBSOLETE46</name>
--<value>46</value>
--<desc>NOT USED</desc>
--</constant>
  CURLE_TOO_MANY_REDIRECTS       = 47,
--<constant>
--<name>CURLE_TOO_MANY_REDIRECTS</name>
--<value>47</value>
--<desc>catch endless re-direct loops</desc>
--</constant>
  CURLE_UNKNOWN_OPTION           = 48,
--<constant>
--<name>CURLE_UNKNOWN_OPTION</name>
--<value>48</value>
--<desc>User specified an unknown option</desc>
--</constant>
  CURLE_TELNET_OPTION_SYNTAX     = 49,
--<constant>
--<name>CURLE_TELNET_OPTION_SYNTAX</name>
--<value>49</value>
--<desc>Malformed telnet option</desc>
--</constant>
  CURLE_OBSOLETE50               = 50,
--<constant>
--<name>CURLE_OBSOLETE50</name>
--<value>50</value>
--<desc>NOT USED</desc>
--</constant>
  CURLE_PEER_FAILED_VERIFICATION = 51,
--<constant>
--<name>CURLE_PEER_FAILED_VERIFICATION</name>
--<value>51</value>
--<desc>peer's certificate or fingerprint wasn't verified fine</desc>
--</constant>
  CURLE_GOT_NOTHING              = 52,
--<constant>
--<name>CURLE_GOT_NOTHING</name>
--<value>52</value>
--<desc>when this is a specific error</desc>
--</constant>
  CURLE_SSL_ENGINE_NOTFOUND      = 53,
--<constant>
--<name>CURLE_SSL_ENGINE_NOTFOUND</name>
--<value>53</value>
--<desc>SSL crypto engine not found</desc>
--</constant>
  CURLE_SSL_ENGINE_SETFAILED     = 54,
--<constant>
--<name>CURLE_SSL_ENGINE_SETFAILED</name>
--<value>54</value>
--<desc>cannot set SSL crypto engine as default</desc>
--</constant>
  CURLE_SEND_ERROR               = 55,
--<constant>
--<name>CURLE_SEND_ERROR</name>
--<value>55</value>
--<desc>failed sending network data</desc>
--</constant>
  CURLE_RECV_ERROR               = 56,
--<constant>
--<name>CURLE_RECV_ERROR</name>
--<value>56</value>
--<desc>failure in receiving network data</desc>
--</constant>
  CURLE_OBSOLETE57               = 57,
--<constant>
--<name>CURLE_OBSOLETE57</name>
--<value>57</value>
--<desc>NOT IN USE</desc>
--</constant>
  CURLE_SSL_CERTPROBLEM          = 58,
--<constant>
--<name>CURLE_SSL_CERTPROBLEM</name>
--<value>58</value>
--<desc>problem with the local certificate</desc>
--</constant>
  CURLE_SSL_CIPHER               = 59,
--<constant>
--<name>CURLE_SSL_CIPHER</name>
--<value>59</value>
--<desc>couldn't use specified cipher</desc>
--</constant>
  CURLE_SSL_CACERT               = 60,
--<constant>
--<name>CURLE_SSL_CACERT</name>
--<value>60</value>
--<desc>problem with the CA cert (path?)</desc>
--</constant>
  CURLE_BAD_CONTENT_ENCODING     = 61,
--<constant>
--<name>CURLE_BAD_CONTENT_ENCODING</name>
--<value>61</value>
--<desc>Unrecognized/bad encoding</desc>
--</constant>
  CURLE_LDAP_INVALID_URL         = 62,
--<constant>
--<name>CURLE_LDAP_INVALID_URL</name>
--<value>62</value>
--<desc>Invalid LDAP URL</desc>
--</constant>
  CURLE_FILESIZE_EXCEEDED        = 63,
--<constant>
--<name>CURLE_FILESIZE_EXCEEDED</name>
--<value>63</value>
--<desc>Maximum file size exceeded</desc>
--</constant>
  CURLE_USE_SSL_FAILED           = 64,
--<constant>
--<name>CURLE_USE_SSL_FAILED</name>
--<value>64</value>
--<desc>Requested FTP SSL level failed</desc>
--</constant>
  CURLE_SEND_FAIL_REWIND         = 65,
--<constant>
--<name>CURLE_SEND_FAIL_REWIND</name>
--<value>65</value>
--<desc>Sending the data requires a rewind that failed</desc>
--</constant>
  CURLE_SSL_ENGINE_INITFAILED    = 66,
--<constant>
--<name>CURLE_SSL_ENGINE_INITFAILED</name>
--<value>66</value>
--<desc>failed to initialise ENGINE</desc>
--</constant>
  CURLE_LOGIN_DENIED             = 67,
--<constant>
--<name>CURLE_LOGIN_DENIED</name>
--<value>67</value>
--<desc>user, password or similar was not accepted and we failed to login</desc>
--</constant>
  CURLE_TFTP_NOTFOUND            = 68,
--<constant>
--<name>CURLE_TFTP_NOTFOUND</name>
--<value>68</value>
--<desc>file not found on server</desc>
--</constant>
  CURLE_TFTP_PERM                = 69,
--<constant>
--<name>CURLE_TFTP_PERM</name>
--<value>69</value>
--<desc>permission problem on server</desc>
--</constant>
  CURLE_REMOTE_DISK_FULL         = 70,
--<constant>
--<name>CURLE_REMOTE_DISK_FULL</name>
--<value>70</value>
--<desc>out of disk space on server</desc>
--</constant>
  CURLE_TFTP_ILLEGAL             = 71,
--<constant>
--<name>CURLE_TFTP_ILLEGAL</name>
--<value>71</value>
--<desc>Illegal TFTP operation</desc>
--</constant>
  CURLE_TFTP_UNKNOWNID           = 72,
--<constant>
--<name>CURLE_TFTP_UNKNOWNID</name>
--<value>72</value>
--<desc>Unknown transfer ID</desc>
--</constant>
  CURLE_REMOTE_FILE_EXISTS       = 73,
--<constant>
--<name>CURLE_REMOTE_FILE_EXISTS</name>
--<value>73</value>
--<desc>File already exists</desc>
--</constant>
  CURLE_TFTP_NOSUCHUSER          = 74,
--<constant>
--<name>CURLE_TFTP_NOSUCHUSER</name>
--<value>74</value>
--<desc>No such user</desc>
--</constant>
  CURLE_CONV_FAILED              = 75,
--<constant>
--<name>CURLE_CONV_FAILED</name>
--<value>75</value>
--<desc>conversion failed</desc>
--</constant>
  CURLE_CONV_REQD                = 76,
--<constant>
--<name>CURLE_CONV_REQD</name>
--<value>76</value>
--<desc>
-- caller must register conversion callbacks using curl_easy_setopt options
--     * CURLOPT_CONV_FROM_NETWORK_FUNCTION,
--     * CURLOPT_CONV_TO_NETWORK_FUNCTION, and
--     * CURLOPT_CONV_FROM_UTF8_FUNCTION
--</desc>
--</constant>
  CURLE_SSL_CACERT_BADFILE       = 77,
--<constant>
--<name>CURLE_SSL_CACERT_BADFILE</name>
--<value>77</value>
--<desc>could not load CACERT file, missing or wrong format</desc>
--</constant>
  CURLE_REMOTE_FILE_NOT_FOUND    = 78,
--<constant>
--<name>CURLE_REMOTE_FILE_NOT_FOUND</name>
--<value>78</value>
--<desc>remote file not found</desc>
--</constant>
  CURLE_SSH                      = 79,
--<constant>
--<name>CURLE_SSH</name>
--<value>79</value>
--<desc>
-- error from the SSH layer, somewhat
-- generic so the error message will be of
-- interest when this has happened
--</desc>
--</constant>
  CURLE_SSL_SHUTDOWN_FAILED      = 80,
--<constant>
--<name>CURLE_SSL_SHUTDOWN_FAILED</name>
--<value>80</value>
--<desc>Failed to shut down the SSL connection</desc>
--</constant>
  CURLE_AGAIN                    = 81,
--<constant>
--<name>CURLE_AGAIN</name>
--<value>81</value>
--<desc>socket is not ready for send/recv, wait till it's ready and try again</desc>
--</constant>
  CURLE_SSL_CRL_BADFILE          = 82,
--<constant>
--<name>CURLE_SSL_CRL_BADFILE</name>
--<value>82</value>
--<desc>could not load CRL file, missing or wrong format</desc>
--</constant>
  CURLE_SSL_ISSUER_ERROR         = 83,
--<constant>
--<name>CURLE_SSL_ISSUER_ERROR</name>
--<value>83</value>
--<desc>Issuer check failed.</desc>
--</constant>
  CURLE_FTP_PRET_FAILED          = 84,
--<constant>
--<name>CURLE_FTP_PRET_FAILED</name>
--<value>84</value>
--<desc>a PRET command failed</desc>
--</constant>
  CURLE_RTSP_CSEQ_ERROR          = 85,
--<constant>
--<name>CURLE_RTSP_CSEQ_ERROR</name>
--<value>85</value>
--<desc>mismatch of RTSP CSeq numbers</desc>
--</constant>
  CURLE_RTSP_SESSION_ERROR       = 86,
--<constant>
--<name>CURLE_RTSP_SESSION_ERROR</name>
--<value>86</value>
--<desc>mismatch of RTSP Session Ids</desc>
--</constant>
  CURLE_FTP_BAD_FILE_LIST        = 87,
--<constant>
--<name>CURLE_FTP_BAD_FILE_LIST</name>
--<value>87</value>
--<desc>unable to parse FTP file list</desc>
--</constant>
  CURLE_CHUNK_FAILED             = 88,
--<constant>
--<name>CURLE_CHUNK_FAILED</name>
--<value>88</value>
--<desc>chunk callback reported error</desc>
--</constant>
  CURLE_NO_CONNECTION_AVAILABLE  = 89,
--<constant>
--<name>CURLE_NO_CONNECTION_AVAILABLE</name>
--<value>89</value>
--<desc>No connection available, the session will be queued</desc>
--</constant>
  CURLE_SSL_PINNEDPUBKEYNOTMATCH = 90,
--<constant>
--<name>CURLE_SSL_PINNEDPUBKEYNOTMATCH</name>
--<value>90</value>
--<desc>specified pinned public key did not match</desc>
--</constant>
  CURLE_SSL_INVALIDCERTSTATUS    = 91,
--<constant>
--<name>CURLE_SSL_INVALIDCERTSTATUS</name>
--<value>91</value>
--<desc>invalid certificate status</desc>
--</constant>
  CURLE_HTTP2_STREAM             = 92,
--<constant>
--<name>CURLE_HTTP2_STREAM</name>
--<value>92</value>
--<desc>stream error in HTTP/2 framing layer</desc>
--</constant>
  CURL_LAST                      = 93
--<constant>
--<name>CURL_LAST</name>
--<value>93</value>
--<desc>never use!</desc>
--</constant>

public type CURLcode(integer n)
--<type>
--<name>CURLcode</name>
--<desc></desc>
--</type>
  return ((n >= CURLE_OK) and (n <= CURL_LAST))
end type

--------------------------------------------------------------------------------

public constant
  -- Previously obsolete error code re-used in 7.38.0
  CURLE_OBSOLETE16 = CURLE_HTTP2,
--<constant>
--<name>CURLE_OBSOLETE16</name>
--<value>CURLE_HTTP2</value>
--<desc></desc>
--</constant>

  -- Previously obsolete error codes re-used in 7.24.0
  CURLE_OBSOLETE10 = CURLE_FTP_ACCEPT_FAILED,
--<constant>
--<name>CURLE_OBSOLETE10</name>
--<value>CURLE_FTP_ACCEPT_FAILED</value>
--<desc></desc>
--</constant>
  CURLE_OBSOLETE12 = CURLE_FTP_ACCEPT_TIMEOUT,
--<constant>
--<name>CURLE_OBSOLETE12</name>
--<value>CURLE_FTP_ACCEPT_TIMEOUT</value>
--<desc></desc>
--</constant>

  --  compatibility with older names
--  CURLOPT_ENCODING = CURLOPT_ACCEPT_ENCODING,

  -- The following were added in 7.21.5, April 2011
  CURLE_UNKNOWN_TELNET_OPTION = CURLE_UNKNOWN_OPTION,
--<constant>
--<name>CURLE_UNKNOWN_TELNET_OPTION</name>
--<value>CURLE_UNKNOWN_OPTION</value>
--<desc></desc>
--</constant>

  -- The following were added in 7.17.1
  -- These are scheduled to disappear by 2009
  CURLE_SSL_PEER_CERTIFICATE = CURLE_PEER_FAILED_VERIFICATION,
--<constant>
--<name>CURLE_SSL_PEER_CERTIFICATE</name>
--<value>CURLE_PEER_FAILED_VERIFICATION</value>
--<desc></desc>
--</constant>

  -- The following were added in 7.17.0
  -- These are scheduled to disappear by 2009
  CURLE_OBSOLETE                    = CURLE_OBSOLETE50,  -- no one should be using this!
--<constant>
--<name>CURLE_OBSOLETE</name>
--<value>CURLE_OBSOLETE50</value>
--<desc></desc>
--</constant>
  CURLE_BAD_PASSWORD_ENTERED        = CURLE_OBSOLETE46,
--<constant>
--<name>CURLE_BAD_PASSWORD_ENTERED</name>
--<value>CURLE_OBSOLETE46</value>
--<desc></desc>
--</constant>
  CURLE_BAD_CALLING_ORDER           = CURLE_OBSOLETE44,
--<constant>
--<name>CURLE_BAD_CALLING_ORDER</name>
--<value>CURLE_OBSOLETE44</value>
--<desc></desc>
--</constant>
  CURLE_FTP_USER_PASSWORD_INCORRECT = CURLE_OBSOLETE10,
--<constant>
--<name>CURLE_FTP_USER_PASSWORD_INCORRECT</name>
--<value>CURLE_OBSOLETE10</value>
--<desc></desc>
--</constant>
  CURLE_FTP_CANT_RECONNECT          = CURLE_OBSOLETE16,
--<constant>
--<name>CURLE_FTP_CANT_RECONNECT</name>
--<value>CURLE_OBSOLETE16</value>
--<desc></desc>
--</constant>
  CURLE_FTP_COULDNT_GET_SIZE        = CURLE_OBSOLETE32,
--<constant>
--<name>CURLE_FTP_COULDNT_GET_SIZE</name>
--<value>CURLE_OBSOLETE32</value>
--<desc></desc>
--</constant>
  CURLE_FTP_COULDNT_SET_ASCII       = CURLE_OBSOLETE29,
--<constant>
--<name>CURLE_FTP_COULDNT_SET_ASCII</name>
--<value>CURLE_OBSOLETE29</value>
--<desc></desc>
--</constant>
  CURLE_FTP_WEIRD_USER_REPLY        = CURLE_OBSOLETE12,
--<constant>
--<name>CURLE_FTP_WEIRD_USER_REPLY</name>
--<value>CURLE_OBSOLETE12</value>
--<desc></desc>
--</constant>
  CURLE_FTP_WRITE_ERROR             = CURLE_OBSOLETE20,
--<constant>
--<name>CURLE_FTP_WRITE_ERROR</name>
--<value>CURLE_OBSOLETE20</value>
--<desc></desc>
--</constant>
  CURLE_LIBRARY_NOT_FOUND           = CURLE_OBSOLETE40,
--<constant>
--<name>CURLE_LIBRARY_NOT_FOUND</name>
--<value>CURLE_OBSOLETE40</value>
--<desc></desc>
--</constant>
  CURLE_MALFORMAT_USER              = CURLE_OBSOLETE24,
--<constant>
--<name>CURLE_MALFORMAT_USER</name>
--<value>CURLE_OBSOLETE24</value>
--<desc></desc>
--</constant>
  CURLE_SHARE_IN_USE                = CURLE_OBSOLETE57,
--<constant>
--<name>CURLE_SHARE_IN_USE</name>
--<value>CURLE_OBSOLETE57</value>
--<desc></desc>
--</constant>
  CURLE_URL_MALFORMAT_USER          = CURLE_NOT_BUILT_IN,
--<constant>
--<name>CURLE_URL_MALFORMAT_USER</name>
--<value>CURLE_NOT_BUILT_IN</value>
--<desc></desc>
--</constant>

  CURLE_FTP_ACCESS_DENIED      = CURLE_REMOTE_ACCESS_DENIED,
--<constant>
--<name>CURLE_FTP_ACCESS_DENIED</name>
--<value>CURLE_REMOTE_ACCESS_DENIED</value>
--<desc></desc>
--</constant>
  CURLE_FTP_COULDNT_SET_BINARY = CURLE_FTP_COULDNT_SET_TYPE,
--<constant>
--<name>CURLE_FTP_COULDNT_SET_BINARY</name>
--<value>CURLE_FTP_COULDNT_SET_TYPE</value>
--<desc></desc>
--</constant>
  CURLE_FTP_QUOTE_ERROR        = CURLE_QUOTE_ERROR,
--<constant>
--<name>CURLE_FTP_QUOTE_ERROR</name>
--<value>CURLE_QUOTE_ERROR</value>
--<desc></desc>
--</constant>
  CURLE_TFTP_DISKFULL          = CURLE_REMOTE_DISK_FULL,
--<constant>
--<name>CURLE_TFTP_DISKFULL</name>
--<value>CURLE_REMOTE_DISK_FULL</value>
--<desc></desc>
--</constant>
  CURLE_TFTP_EXISTS            = CURLE_REMOTE_FILE_EXISTS,
--<constant>
--<name>CURLE_TFTP_EXISTS</name>
--<value>CURLE_REMOTE_FILE_EXISTS</value>
--<desc></desc>
--</constant>
  CURLE_HTTP_RANGE_ERROR       = CURLE_RANGE_ERROR,
--<constant>
--<name>CURLE_HTTP_RANGE_ERROR</name>
--<value>CURLE_RANGE_ERROR</value>
--<desc></desc>
--</constant>
  CURLE_FTP_SSL_FAILED         = CURLE_USE_SSL_FAILED,
--<constant>
--<name>CURLE_FTP_SSL_FAILED</name>
--<value>CURLE_USE_SSL_FAILED</value>
--<desc></desc>
--</constant>

--------------------------------------------------------------------------------

  -- The following were added earlier

  CURLE_OPERATION_TIMEOUTED     = CURLE_OPERATION_TIMEDOUT,
--<constant>
--<name>CURLE_OPERATION_TIMEOUTED</name>
--<value>CURLE_OPERATION_TIMEDOUT</value>
--<desc></desc>
--</constant>

  CURLE_HTTP_NOT_FOUND          = CURLE_HTTP_RETURNED_ERROR,
--<constant>
--<name>CURLE_HTTP_NOT_FOUND</name>
--<value>CURLE_HTTP_RETURNED_ERROR</value>
--<desc></desc>
--</constant>
  CURLE_HTTP_PORT_FAILED        = CURLE_INTERFACE_FAILED,
--<constant>
--<name>CURLE_HTTP_PORT_FAILED</name>
--<value>CURLE_INTERFACE_FAILED</value>
--<desc></desc>
--</constant>
  CURLE_FTP_COULDNT_STOR_FILE   = CURLE_UPLOAD_FAILED,
--<constant>
--<name>CURLE_FTP_COULDNT_STOR_FILE</name>
--<value>CURLE_UPLOAD_FAILED</value>
--<desc></desc>
--</constant>

  CURLE_FTP_PARTIAL_FILE        = CURLE_PARTIAL_FILE,
--<constant>
--<name>CURLE_FTP_PARTIAL_FILE</name>
--<value>CURLE_PARTIAL_FILE</value>
--<desc></desc>
--</constant>
  CURLE_FTP_BAD_DOWNLOAD_RESUME = CURLE_BAD_DOWNLOAD_RESUME,
--<constant>
--<name>CURLE_FTP_BAD_DOWNLOAD_RESUME</name>
--<value>CURLE_BAD_DOWNLOAD_RESUME</value>
--<desc></desc>
--</constant>

  -- This was the error code 50 in 7.7.3 and a few earlier versions, this
  --   is no longer used by libcurl but is instead constantd here only to not
  --   make programs break
  CURLE_ALREADY_COMPLETE = 99999,
--<constant>
--<name>CURLE_ALREADY_COMPLETE</name>
--<value>99999</value>
--<desc>no longer used by libcurl</desc>
--</constant>

--------------------------------------------------------------------------------

  -- Provide defines for really old option names
  CURLOPT_FILE        = 10001,  -- name changed in 7.9.7
--<constant>
--<name>CURLOPT_FILE</name>
--<value>10001</value>
--<desc></desc>
--</constant>
  CURLOPT_INFILE      = 10009,  -- name changed in 7.9.7
--<constant>
--<name>CURLOPT_INFILE</name>
--<value>10009</value>
--<desc></desc>
--</constant>
  CURLOPT_WRITEHEADER = 10029,
--<constant>
--<name>CURLOPT_WRITEHEADER</name>
--<value>10029</value>
--<desc></desc>
--</constant>

  -- Since long deprecated options with no code in the lib that does anything
  -- with them.
  CURLOPT_WRITEINFO   = 10040,
--<constant>
--<name>CURLOPT_WRITEINFO</name>
--<value>10040</value>
--<desc>deprecated option</desc>
--</constant>
  CURLOPT_CLOSEPOLICY = 72
--<constant>
--<name>CURLOPT_CLOSEPOLICY</name>
--<value>72</value>
--<desc>deprecated option</desc>
--</constant>

--------------------------------------------------------------------------------

public constant  -- this public enum was added in 7.10
  CURLPROXY_HTTP            = 0,
--<constant>
--<name>CURLPROXY_HTTP</name>
--<value>0</value>
--<desc>default is to use CONNECT HTTP/1.1</desc>
--</constant>
  CURLPROXY_HTTP_1_0        = 1,
--<constant>
--<name>CURLPROXY_HTTP_1_0</name>
--<value>1</value>
--<desc>force to use CONNECT HTTP/1.0</desc>
--</constant>
  CURLPROXY_SOCKS4          = 4,
--<constant>
--<name>CURLPROXY_SOCKS4</name>
--<value>4</value>
--<desc></desc>
--</constant>
  CURLPROXY_SOCKS5          = 5,
--<constant>
--<name>CURLPROXY_SOCKS5</name>
--<value>5</value>
--<desc></desc>
--</constant>
  CURLPROXY_SOCKS4A         = 6,
--<constant>
--<name>CURLPROXY_SOCKS4A</name>
--<value>6</value>
--<desc></desc>
--</constant>
  CURLPROXY_SOCKS5_HOSTNAME = 7
--<constant>
--<name>CURLPROXY_SOCKS5_HOSTNAME</name>
--<value>7</value>
--<desc>Use the SOCKS5 protocol but pass along the hostname rather than the IP address.</desc>
--</constant>

public type curl_proxytype(integer n)
--<type>
--<name>curl_proxytype</name>
--<desc></desc>
--</type>
  return find(n, {CURLPROXY_HTTP, CURLPROXY_HTTP_1_0, CURLPROXY_SOCKS4,
                   CURLPROXY_SOCKS5, CURLPROXY_SOCKS4A, CURLPROXY_SOCKS5_HOSTNAME})
end type

--------------------------------------------------------------------------------

-- Bitmasks for CURLOPT_HTTPAUTH and CURLOPT_PROXYAUTH options:

public constant CURLAUTH_NONE         = #00000000
--<constant>
--<name>CURLAUTH_NONE</name>
--<value>#00000000</value>
--<desc>No HTTP authentication</desc>
--</constant>
public constant CURLAUTH_BASIC        = #00000001
--<constant>
--<name>CURLAUTH_BASIC</name>
--<value>#00000001</value>
--<desc>HTTP Basic authentication (default)</desc>
--</constant>
public constant CURLAUTH_DIGEST       = #00000002
--<constant>
--<name>CURLAUTH_DIGEST</name>
--<value>#00000002</value>
--<desc>HTTP Digest authentication</desc>
--</constant>
public constant CURLAUTH_NEGOTIATE    = #00000004
--<constant>
--<name>CURLAUTH_NEGOTIATE</name>
--<value>#00000004</value>
--<desc>HTTP Negotiate (SPNEGO) authentication</desc>
--</constant>
-- Deprecated since the advent of CURLAUTH_NEGOTIATE
public constant CURLAUTH_GSSNEGOTIATE = CURLAUTH_NEGOTIATE
--<constant>
--<name>CURLAUTH_GSSNEGOTIATE</name>
--<value>CURLAUTH_NEGOTIATE</value>
--<desc>Alias for CURLAUTH_NEGOTIATE (deprecated)</desc>
--</constant>
public constant CURLAUTH_NTLM         = #00000008
--<constant>
--<name>CURLAUTH_NTLM</name>
--<value>#00000008</value>
--<desc>HTTP NTLM authentication</desc>
--</constant>
public constant CURLAUTH_DIGEST_IE    = #00000010
--<constant>
--<name>CURLAUTH_DIGEST_IE</name>
--<value>#00000010</value>
--<desc>HTTP Digest authentication with IE flavour</desc>
--</constant>
public constant CURLAUTH_NTLM_WB      = #00000020
--<constant>
--<name>CURLAUTH_NTLM_WB</name>
--<value>#00000020</value>
--<desc>HTTP NTLM authentication delegated to winbind helper</desc>
--</constant>
public constant CURLAUTH_ONLY         = #80000000
--<constant>
--<name>CURLAUTH_ONLY</name>
--<value>#80000000</value>
--<desc>
-- Use together with a single other type to force no authentication or just
-- that single type
--</desc>
--</constant>
public constant CURLAUTH_ANY          = not CURLAUTH_DIGEST_IE
--<constant>
--<name>CURLAUTH_ANY</name>
--<value>not CURLAUTH_DIGEST_IE</value>
--<desc>All fine types set</desc>
--</constant>
public constant CURLAUTH_ANYSAFE      = not or_bits(CURLAUTH_BASIC, CURLAUTH_DIGEST_IE)
--<constant>
--<name>CURLAUTH_ANYSAFE</name>
--<value>not or_bits(CURLAUTH_BASIC</value>
--<desc>All fine types except Basic</desc>
--</constant>

--------------------------------------------------------------------------------

public constant CURLSSH_AUTH_ANY       = not 0
--<constant>
--<name>CURLSSH_AUTH_ANY</name>
--<value>not 0</value>
--<desc>all types supported by the server</desc>
--</constant>
public constant CURLSSH_AUTH_NONE      = 0
--<constant>
--<name>CURLSSH_AUTH_NONE</name>
--<value>0</value>
--<desc>none allowed, silly but complete</desc>
--</constant>
public constant CURLSSH_AUTH_PUBLICKEY = 1
--<constant>
--<name>CURLSSH_AUTH_PUBLICKEY</name>
--<value>1</value>
--<desc>public/private key files</desc>
--</constant>
public constant CURLSSH_AUTH_PASSWORD  = 2
--<constant>
--<name>CURLSSH_AUTH_PASSWORD</name>
--<value>2</value>
--<desc>password</desc>
--</constant>
public constant CURLSSH_AUTH_HOST      = 4
--<constant>
--<name>CURLSSH_AUTH_HOST</name>
--<value>4</value>
--<desc>host key files</desc>
--</constant>
public constant CURLSSH_AUTH_KEYBOARD  = 8
--<constant>
--<name>CURLSSH_AUTH_KEYBOARD</name>
--<value>8</value>
--<desc>keyboard interactive</desc>
--</constant>
public constant CURLSSH_AUTH_AGENT     = 16
--<constant>
--<name>CURLSSH_AUTH_AGENT</name>
--<value>16</value>
--<desc>agent (ssh-agent, pageant...)</desc>
--</constant>
public constant CURLSSH_AUTH_DEFAULT   = CURLSSH_AUTH_ANY
--<constant>
--<name>CURLSSH_AUTH_DEFAULT</name>
--<value>CURLSSH_AUTH_ANY</value>
--<desc></desc>
--</constant>

--------------------------------------------------------------------------------

public constant CURLGSSAPI_DELEGATION_NONE        = 0
--<constant>
--<name>CURLGSSAPI_DELEGATION_NONE</name>
--<value>0</value>
--<desc>no delegation (default)</desc>
--</constant>
public constant CURLGSSAPI_DELEGATION_POLICY_FLAG = 1
--<constant>
--<name>CURLGSSAPI_DELEGATION_POLICY_FLAG</name>
--<value>1</value>
--<desc>if permitted by policy</desc>
--</constant>
public constant CURLGSSAPI_DELEGATION_FLAG        = 2
--<constant>
--<name>CURLGSSAPI_DELEGATION_FLAG</name>
--<value>2</value>
--<desc>delegate always</desc>
--</constant>

--------------------------------------------------------------------------------

public constant CURL_ERROR_SIZE = 256
--<constant>
--<name>CURL_ERROR_SIZE</name>
--<value>256</value>
--<desc></desc>
--</constant>

--------------------------------------------------------------------------------

public constant
  CURLKHTYPE_UNKNOWN = 0,
--<constant>
--<name>CURLKHTYPE_UNKNOWN</name>
--<value>0</value>
--<desc></desc>
--</constant>
  CURLKHTYPE_RSA1    = 1,
--<constant>
--<name>CURLKHTYPE_RSA1</name>
--<value>1</value>
--<desc></desc>
--</constant>
  CURLKHTYPE_RSA     = 2,
--<constant>
--<name>CURLKHTYPE_RSA</name>
--<value>2</value>
--<desc></desc>
--</constant>
  CURLKHTYPE_DSS     = 3
--<constant>
--<name>CURLKHTYPE_DSS</name>
--<value>3</value>
--<desc></desc>
--</constant>

type curl_khtype(integer x)
  return (x >= CURLKHTYPE_UNKNOWN) and (x <= CURLKHTYPE_DSS)
end type

--------------------------------------------------------------------------------

-- this is the set of return values expected from the curl_sshkeycallback
--    callback
public constant
  CURLKHSTAT_FINE_ADD_TO_FILE = 0,
--<constant>
--<name>CURLKHSTAT_FINE_ADD_TO_FILE</name>
--<value>0</value>
--<desc></desc>
--</constant>
  CURLKHSTAT_FINE   = 1,
--<constant>
--<name>CURLKHSTAT_FINE</name>
--<value>1</value>
--<desc></desc>
--</constant>
  CURLKHSTAT_REJECT = 2,
--<constant>
--<name>CURLKHSTAT_REJECT</name>
--<value>2</value>
--<desc>reject the connection, return an error</desc>
--</constant>
  CURLKHSTAT_DEFER  = 3,
--<constant>
--<name>CURLKHSTAT_DEFER</name>
--<value>3</value>
--<desc>
-- do not accept it, but we can't answer right now so this causes a CURLE_DEFER
-- error but otherwise the connection will be left intact etc
--</desc>
  CURLKHSTAT_LAST   = 4
--</constant>
--<constant>
--<name>CURLKHSTAT_LAST</name>
--<value>4</value>
--<desc>not for use, only a marker for last-in-list</desc>
--</constant>

type curl_khstat(integer x)
  return (x >= CURLKHSTAT_FINE_ADD_TO_FILE) and (x <= CURLKHSTAT_LAST)
end type

--------------------------------------------------------------------------------

-- this is the set of status codes pass in to the callback
public constant
  CURLKHMATCH_OK       = 0,
--<constant>
--<name>CURLKHMATCH_OK</name>
--<value>0</value>
--<desc>match</desc>
--</constant>
  CURLKHMATCH_MISMATCH = 1,
--<constant>
--<name>CURLKHMATCH_MISMATCH</name>
--<value>1</value>
--<desc>host found, key mismatch!</desc>
--</constant>
  CURLKHMATCH_MISSING  = 2,
--<constant>
--<name>CURLKHMATCH_MISSING</name>
--<value>2</value>
--<desc>no matching host/key found</desc>
--</constant>
  CURLKHMATCH_LAST     = 3
--<constant>
--<name>CURLKHMATCH_LAST</name>
--<value>3</value>
--<desc>not for use, only a marker for last-in-list</desc>
--</constant>

type curl_khmatch(integer x)
  return (x >= CURLKHMATCH_OK) and (x <= CURLKHMATCH_LAST)
end type

--------------------------------------------------------------------------------

-- parameter for the CURLOPT_USE_SSL option
public constant
  CURLUSESSL_NONE    = 0,
--<constant>
--<name>CURLUSESSL_NONE</name>
--<value>0</value>
--<desc>do not attempt to use SSL</desc>
--</constant>
  CURLUSESSL_TRY     = 1,
--<constant>
--<name>CURLUSESSL_TRY</name>
--<value>1</value>
--<desc>try using SSL, proceed anyway otherwise</desc>
--</constant>
  CURLUSESSL_CONTROL = 2,
--<constant>
--<name>CURLUSESSL_CONTROL</name>
--<value>2</value>
--<desc>SSL for the control connection or fail</desc>
--</constant>
  CURLUSESSL_ALL     = 3,
--<constant>
--<name>CURLUSESSL_ALL</name>
--<value>3</value>
--<desc>SSL for all communication or fail</desc>
--</constant>
  CURLUSESSL_LAST    = 4
--<constant>
--<name>CURLUSESSL_LAST</name>
--<value>4</value>
--<desc>not an option, never use</desc>
--</constant>

public type curl_usessl(integer x)
--<type>
--<name>curl_usessl</name>
--<desc>parameter for the CURLOPT_USE_SSL option</desc>
--</type>
  return (x >= CURLUSESSL_NONE) and (x <= CURLUSESSL_LAST)
end type

--------------------------------------------------------------------------------

-- Definition of bits for the CURLOPT_SSL_OPTIONS argument:

-- - ALLOW_BEAST tells libcurl to allow the BEAST SSL vulnerability in the
--    name of improving interoperability with older servers. Some SSL libraries
--    have introduced work-arounds for this flaw but those work-arounds sometimes
--    make the SSL communication fail. To regain functionality with those broken
--    servers, a user can this way allow the vulnerability back.
public constant CURLSSLOPT_ALLOW_BEAST = 1
--<constant>
--<name>CURLSSLOPT_ALLOW_BEAST</name>
--<value>1</value>
--<desc></desc>
--</constant>

-- - NO_REVOKE tells libcurl to disable certificate revocation checks for those
--    SSL backends where such behavior is present.
public constant CURLSSLOPT_NO_REVOKE   = 2
--<constant>
--<name>CURLSSLOPT_NO_REVOKE</name>
--<value>2</value>
--<desc></desc>
--</constant>

--------------------------------------------------------------------------------

-- Backwards compatibility with older names
-- These are scheduled to disappear by 2009

public constant CURLFTPSSL_NONE    = CURLUSESSL_NONE
--<constant>
--<name>CURLFTPSSL_NONE</name>
--<value>CURLUSESSL_NONE</value>
--<desc></desc>
--</constant>
public constant CURLFTPSSL_TRY     = CURLUSESSL_TRY
--<constant>
--<name>CURLFTPSSL_TRY</name>
--<value>CURLUSESSL_TRY</value>
--<desc></desc>
--</constant>
public constant CURLFTPSSL_CONTROL = CURLUSESSL_CONTROL
--<constant>
--<name>CURLFTPSSL_CONTROL</name>
--<value>CURLUSESSL_CONTROL</value>
--<desc></desc>
--</constant>
public constant CURLFTPSSL_ALL     = CURLUSESSL_ALL
--<constant>
--<name>CURLFTPSSL_ALL</name>
--<value>CURLUSESSL_ALL</value>
--<desc></desc>
--</constant>
public constant CURLFTPSSL_LAST    = CURLUSESSL_LAST
--<constant>
--<name>CURLFTPSSL_LAST</name>
--<value>CURLUSESSL_LAST</value>
--<desc></desc>
--</constant>
-- curl_ftpssl = curl_usessl

--------------------------------------------------------------------------------

-- parameter for the CURLOPT_FTP_SSL_CCC option
public constant
  CURLFTPSSL_CCC_NONE    = 0,
--<constant>
--<name>CURLFTPSSL_CCC_NONE</name>
--<value>0</value>
--<desc>do not send CCC</desc>
--</constant>
  CURLFTPSSL_CCC_PASSIVE = 1,
--<constant>
--<name>CURLFTPSSL_CCC_PASSIVE</name>
--<value>1</value>
--<desc>Let the server initiate the shutdown</desc>
--</constant>
  CURLFTPSSL_CCC_ACTIVE  = 2,
--<constant>
--<name>CURLFTPSSL_CCC_ACTIVE</name>
--<value>2</value>
--<desc>Initiate the shutdown</desc>
--</constant>
  CURLFTPSSL_CCC_LAST    = 3
--<constant>
--<name>CURLFTPSSL_CCC_LAST</name>
--<value>3</value>
--<desc>not an option, never use</desc>
--</constant>

public type curl_ftpccc(integer x)
--<type>
--<name>curl_ftpccc</name>
--<desc>parameter for the CURLOPT_FTP_SSL_CCC option</desc>
--</type>
  return (x >= CURLFTPSSL_CCC_NONE) and (x <= CURLFTPSSL_CCC_LAST)
end type

--------------------------------------------------------------------------------

-- parameter for the CURLOPT_FTPSSLAUTH option
public constant
  CURLFTPAUTH_DEFAULT = 0,
--<constant>
--<name>CURLFTPAUTH_DEFAULT</name>
--<value>0</value>
--<desc>let libcurl decide</desc>
--</constant>
  CURLFTPAUTH_SSL     = 1,
--<constant>
--<name>CURLFTPAUTH_SSL</name>
--<value>1</value>
--<desc>use "AUTH SSL"</desc>
--</constant>
  CURLFTPAUTH_TLS     = 2,
--<constant>
--<name>CURLFTPAUTH_TLS</name>
--<value>2</value>
--<desc>use "AUTH TLS"</desc>
--</constant>
  CURLFTPAUTH_LAST    = 3
--<constant>
--<name>CURLFTPAUTH_LAST</name>
--<value>3</value>
--<desc>not an option, never use</desc>
--</constant>

public type curl_ftpauth(integer x)
--<type>
--<name>curl_ftpauth</name>
--<desc>parameter for the CURLOPT_FTPSSLAUTH option</desc>
--</type>
  return (x >= CURLFTPAUTH_DEFAULT) and (x <= CURLFTPAUTH_LAST)
end type

--------------------------------------------------------------------------------

-- parameter for the CURLOPT_FTP_CREATE_MISSING_DIRS option
public constant
  CURLFTP_CREATE_DIR_NONE  = 0,
--<constant>
--<name>CURLFTP_CREATE_DIR_NONE</name>
--<value>0</value>
--<desc>do NOT create missing dirs!</desc>
--</constant>
  CURLFTP_CREATE_DIR       = 1,
--<constant>
--<name>CURLFTP_CREATE_DIR</name>
--<value>1</value>
--<desc>
-- (FTP/SFTP) if CWD fails, try MKD and then CWD
-- again if MKD succeeded, for SFTP this does
-- similar magic
--</desc>
--</constant>
  CURLFTP_CREATE_DIR_RETRY = 2,
--<constant>
--<name>CURLFTP_CREATE_DIR_RETRY</name>
--<value>2</value>
--<desc>(FTP only) if CWD fails, try MKD and then CWD again even if MKD failed!</desc>
--</constant>
  CURLFTP_CREATE_DIR_LAST  = 3
--<constant>
--<name>CURLFTP_CREATE_DIR_LAST</name>
--<value>3</value>
--<desc>not an option, never use</desc>
--</constant>

public type curl_ftpcreatedir(integer x)
--<type>
--<name>curl_ftpcreatedir</name>
--<desc>parameter for the CURLOPT_FTP_CREATE_MISSING_DIRS option</desc>
--</type>
  return (x >= CURLFTP_CREATE_DIR_NONE) and (x <= CURLFTP_CREATE_DIR_LAST)
end type

--------------------------------------------------------------------------------

-- parameter for the CURLOPT_FTP_FILEMETHOD option
public constant
  CURLFTPMETHOD_DEFAULT   = 0,
--<constant>
--<name>CURLFTPMETHOD_DEFAULT</name>
--<value>0</value>
--<desc>let libcurl pick</desc>
--</constant>
  CURLFTPMETHOD_MULTICWD  = 1,
--<constant>
--<name>CURLFTPMETHOD_MULTICWD</name>
--<value>1</value>
--<desc>single CWD operation for each path part</desc>
--</constant>
  CURLFTPMETHOD_NOCWD     = 2,
--<constant>
--<name>CURLFTPMETHOD_NOCWD</name>
--<value>2</value>
--<desc>no CWD at all</desc>
--</constant>
  CURLFTPMETHOD_SINGLECWD = 3,
--<constant>
--<name>CURLFTPMETHOD_SINGLECWD</name>
--<value>3</value>
--<desc>one CWD to full dir, then work on file</desc>
--</constant>
  CURLFTPMETHOD_LAST      = 4
--<constant>
--<name>CURLFTPMETHOD_LAST</name>
--<value>4</value>
--<desc>not an option, never use</desc>
--</constant>

public type curl_ftpmethod(integer x)
--<type>
--<name>curl_ftpmethod</name>
--<desc>parameter for the CURLOPT_FTP_FILEMETHOD option</desc>
--</type>
  return (x >= CURLFTPMETHOD_DEFAULT) and (x <= CURLFTPMETHOD_LAST)
end type

--------------------------------------------------------------------------------

-- bitmask defines for CURLOPT_HEADEROPT
public constant CURLHEADER_UNIFIED  = 0
--<constant>
--<name>CURLHEADER_UNIFIED</name>
--<value>0</value>
--<desc>bitmask for CURLOPT_HEADEROPT</desc>
--</constant>
public constant CURLHEADER_SEPARATE = 1
--<constant>
--<name>CURLHEADER_SEPARATE</name>
--<value>1</value>
--<desc>bitmask for CURLOPT_HEADEROPT</desc>
--</constant>

--------------------------------------------------------------------------------

-- CURLPROTO_ defines are for the CURLOPT_*PROTOCOLS options
public constant
  CURLPROTO_HTTP   = #0000001,
--<constant>
--<name>CURLPROTO_HTTP</name>
--<value>#0000001</value>
--<desc></desc>
--</constant>
  CURLPROTO_HTTPS  = #0000002,
--<constant>
--<name>CURLPROTO_HTTPS</name>
--<value>#0000002</value>
--<desc></desc>
--</constant>
  CURLPROTO_FTP    = #0000004,
--<constant>
--<name>CURLPROTO_FTP</name>
--<value>#0000004</value>
--<desc></desc>
--</constant>
  CURLPROTO_FTPS   = #0000008,
--<constant>
--<name>CURLPROTO_FTPS</name>
--<value>#0000008</value>
--<desc></desc>
--</constant>
  CURLPROTO_SCP    = #0000010,
--<constant>
--<name>CURLPROTO_SCP</name>
--<value>#0000010</value>
--<desc></desc>
--</constant>
  CURLPROTO_SFTP   = #0000020,
--<constant>
--<name>CURLPROTO_SFTP</name>
--<value>#0000020</value>
--<desc></desc>
--</constant>
  CURLPROTO_TELNET = #0000040,
--<constant>
--<name>CURLPROTO_TELNET</name>
--<value>#0000040</value>
--<desc></desc>
--</constant>
  CURLPROTO_LDAP   = #0000080,
--<constant>
--<name>CURLPROTO_LDAP</name>
--<value>#0000080</value>
--<desc></desc>
--</constant>
  CURLPROTO_LDAPS  = #0000100,
--<constant>
--<name>CURLPROTO_LDAPS</name>
--<value>#0000100</value>
--<desc></desc>
--</constant>
  CURLPROTO_DICT   = #0000200,
--<constant>
--<name>CURLPROTO_DICT</name>
--<value>#0000200</value>
--<desc></desc>
--</constant>
  CURLPROTO_FILE   = #0000400,
--<constant>
--<name>CURLPROTO_FILE</name>
--<value>#0000400</value>
--<desc></desc>
--</constant>
  CURLPROTO_TFTP   = #0000800,
--<constant>
--<name>CURLPROTO_TFTP</name>
--<value>#0000800</value>
--<desc></desc>
--</constant>
  CURLPROTO_IMAP   = #0001000,
--<constant>
--<name>CURLPROTO_IMAP</name>
--<value>#0001000</value>
--<desc></desc>
--</constant>
  CURLPROTO_IMAPS  = #0002000,
--<constant>
--<name>CURLPROTO_IMAPS</name>
--<value>#0002000</value>
--<desc></desc>
--</constant>
  CURLPROTO_POP3   = #0004000,
--<constant>
--<name>CURLPROTO_POP3</name>
--<value>#0004000</value>
--<desc></desc>
--</constant>
  CURLPROTO_POP3S  = #0008000,
--<constant>
--<name>CURLPROTO_POP3S</name>
--<value>#0008000</value>
--<desc></desc>
--</constant>
  CURLPROTO_SMTP   = #0010000,
--<constant>
--<name>CURLPROTO_SMTP</name>
--<value>#0010000</value>
--<desc></desc>
--</constant>
  CURLPROTO_SMTPS  = #0020000,
--<constant>
--<name>CURLPROTO_SMTPS</name>
--<value>#0020000</value>
--<desc></desc>
--</constant>
  CURLPROTO_RTSP   = #0040000,
--<constant>
--<name>CURLPROTO_RTSP</name>
--<value>#0040000</value>
--<desc></desc>
--</constant>
  CURLPROTO_RTMP   = #0080000,
--<constant>
--<name>CURLPROTO_RTMP</name>
--<value>#0080000</value>
--<desc></desc>
--</constant>
  CURLPROTO_RTMPT  = #0100000,
--<constant>
--<name>CURLPROTO_RTMPT</name>
--<value>#0100000</value>
--<desc></desc>
--</constant>
  CURLPROTO_RTMPE  = #0200000,
--<constant>
--<name>CURLPROTO_RTMPE</name>
--<value>#0200000</value>
--<desc></desc>
--</constant>
  CURLPROTO_RTMPTE = #0400000,
--<constant>
--<name>CURLPROTO_RTMPTE</name>
--<value>#0400000</value>
--<desc></desc>
--</constant>
  CURLPROTO_RTMPS  = #0800000,
--<constant>
--<name>CURLPROTO_RTMPS</name>
--<value>#0800000</value>
--<desc></desc>
--</constant>
  CURLPROTO_RTMPTS = #1000000,
--<constant>
--<name>CURLPROTO_RTMPTS</name>
--<value>#1000000</value>
--<desc></desc>
--</constant>
  CURLPROTO_GOPHER = #2000000,
--<constant>
--<name>CURLPROTO_GOPHER</name>
--<value>#2000000</value>
--<desc></desc>
--</constant>
  CURLPROTO_SMB    = #4000000,
--<constant>
--<name>CURLPROTO_SMB</name>
--<value>#4000000</value>
--<desc></desc>
--</constant>
  CURLPROTO_SMBS   = #8000000,
--<constant>
--<name>CURLPROTO_SMBS</name>
--<value>#8000000</value>
--<desc></desc>
--</constant>
  CURLPROTO_ALL    = not 0
--<constant>
--<name>CURLPROTO_ALL</name>
--<value>not 0</value>
--<desc>enable everything</desc>
--</constant>

--------------------------------------------------------------------------------

-- options to be used with curl_easy_setopt().

public constant
  CURLOPT_WRITEDATA       = 10001,
--<constant>
--<name>CURLOPT_WRITEDATA</name>
--<value>10001</value>
--<desc>This is the FILE * or void * the regular output should be written to.</desc>
--</constant>
  CURLOPT_URL             = 10002,
--<constant>
--<name>CURLOPT_URL</name>
--<value>10002</value>
--<desc>The full URL to get/put</desc>
--</constant>
  CURLOPT_PORT            =     3,
--<constant>
--<name>CURLOPT_PORT</name>
--<value>3</value>
--<desc>Port number to connect to, if other than default.</desc>
--</constant>
  CURLOPT_PROXY           = 10004,
--<constant>
--<name>CURLOPT_PROXY</name>
--<value>10004</value>
--<desc>Name of proxy to use.</desc>
--</constant>
  CURLOPT_USERPWD         = 10005,
--<constant>
--<name>CURLOPT_USERPWD</name>
--<value>10005</value>
--<desc>"user:password;options" to use when fetching.</desc>
--</constant>
  CURLOPT_PROXYUSERPWD    = 10006,
--<constant>
--<name>CURLOPT_PROXYUSERPWD</name>
--<value>10006</value>
--<desc>"user:password" to use with proxy.</desc>
--</constant>
  CURLOPT_RANGE           = 10007,
--<constant>
--<name>CURLOPT_RANGE</name>
--<value>10007</value>
--<desc>Range to get, specified as an ASCII string. not used</desc>
--</constant>
  CURLOPT_READDATA        = 10009,
--<constant>
--<name>CURLOPT_READDATA</name>
--<value>10009</value>
--<desc>Specified file stream to upload from (use as input):</desc>
--</constant>
  CURLOPT_ERRORBUFFER     = 10010,
--<constant>
--<name>CURLOPT_ERRORBUFFER</name>
--<value>10010</value>
--<desc>
-- Buffer to receive error messages in, must be at least CURL_ERROR_SIZE
-- bytes big. If this is not used, error messages go to stderr instead:
--</desc>
--</constant>
  CURLOPT_WRITEFUNCTION   = 20011,
--<constant>
--<name>CURLOPT_WRITEFUNCTION</name>
--<value>20011</value>
--<desc>
-- Function that will be called to store the output (instead of fwrite). The
-- parameters will use fwrite() syntax, make sure to follow them.
--</desc>
--</constant>
  CURLOPT_READFUNCTION    = 20012,
--<constant>
--<name>CURLOPT_READFUNCTION</name>
--<value>20012</value>
--<desc>
-- Function that will be called to read the input (instead of fread). The
-- parameters will use fread() syntax, make sure to follow them.
--</desc>
--</constant>
  CURLOPT_TIMEOUT         =    13,
--<constant>
--<name>CURLOPT_TIMEOUT</name>
--<value>13</value>
--<desc>Time-out the read operation after this amount of seconds</desc>
--</constant>
  CURLOPT_INFILESIZE      =    14,
--<constant>
--<name>CURLOPT_INFILESIZE</name>
--<value>14</value>
--<desc>
-- If the CURLOPT_INFILE is used, this can be used to inform libcurl about
-- how large the file being sent really is. That allows better error
-- checking and better verifies that the upload was successful. -1 means
-- unknown size.
--
-- For large file support, there is also a _LARGE version of the key
-- which takes an off_t type, allowing platforms with larger off_t
-- sizes to handle larger files.  See below for INFILESIZE_LARGE.
--</desc>
--</constant>
  CURLOPT_POSTFIELDS      = 10015,
--<constant>
--<name>CURLOPT_POSTFIELDS</name>
--<value>10015</value>
--<desc>POST static input fields.</desc>
--</constant>
  CURLOPT_REFERER         = 10016,
--<constant>
--<name>CURLOPT_REFERER</name>
--<value>10016</value>
--<desc>Set the referrer page (needed by some CGIs)</desc>
--</constant>
  CURLOPT_FTPPORT         = 10017,
--<constant>
--<name>CURLOPT_FTPPORT</name>
--<value>10017</value>
--<desc>
-- Set the FTP PORT string (interface name, named or numerical IP address)
-- Use i.e '-' to use default address.
--</desc>
--</constant>
  CURLOPT_USERAGENT       = 10018,
--<constant>
--<name>CURLOPT_USERAGENT</name>
--<value>10018</value>
--<desc>
-- Set the User-Agent string (examined by some CGIs)
-- If the download receives less than "low speed limit" bytes/second
-- during "low speed time" seconds, the operations is aborted.
-- You could i.e if you have a pretty high speed connection, abort if
-- it is less than 2000 bytes/sec during 20 seconds.
--</desc>
--</constant>
  CURLOPT_LOW_SPEED_LIMIT =    19,
--<constant>
--<name>CURLOPT_LOW_SPEED_LIMIT</name>
--<value>19</value>
--<desc>Set the "low speed limit"</desc>
--</constant>
  CURLOPT_LOW_SPEED_TIME  =    20,
--<constant>
--<name>CURLOPT_LOW_SPEED_TIME</name>
--<value>20</value>
--<desc>Set the "low speed time"</desc>
--</constant>
  CURLOPT_RESUME_FROM     =    21,
--<constant>
--<name>CURLOPT_RESUME_FROM</name>
--<value>21</value>
--<desc>
-- Set the continuation offset.
--
-- Note there is also a _LARGE version of this key which uses
-- off_t types, allowing for large file offsets on platforms which
-- use larger-than-32-bit off_t's.  Look below for RESUME_FROM_LARGE.
--</desc>
--</constant>
  CURLOPT_COOKIE          = 10022,
--<constant>
--<name>CURLOPT_COOKIE</name>
--<value>10022</value>
--<desc>Set cookie in request:</desc>
--</constant>
  CURLOPT_HTTPHEADER      = 10023,
--<constant>
--<name>CURLOPT_HTTPHEADER</name>
--<value>10023</value>
--<desc>
-- This points to a linked list of headers, struct curl_slist kind. This
-- list is also used for RTSP (in spite of its name)
--</desc>
--</constant>
  CURLOPT_HTTPPOST        = 10024,
--<constant>
--<name>CURLOPT_HTTPPOST</name>
--<value>10024</value>
--<desc>This points to a linked list of post entries, struct curl_httppost</desc>
--</constant>
  CURLOPT_SSLCERT         = 10025,
--<constant>
--<name>CURLOPT_SSLCERT</name>
--<value>10025</value>
--<desc>name of the file keeping your private SSL-certificate</desc>
--</constant>
  CURLOPT_KEYPASSWD       = 10026,
--<constant>
--<name>CURLOPT_KEYPASSWD</name>
--<value>10026</value>
--<desc>password for the SSL or SSH private key</desc>
--</constant>
  CURLOPT_CRLF            =    27,
--<constant>
--<name>CURLOPT_CRLF</name>
--<value>27</value>
--<desc>send TYPE parameter?</desc>
--</constant>
  CURLOPT_QUOTE           = 10028,
--<constant>
--<name>CURLOPT_QUOTE</name>
--<value>10028</value>
--<desc>send linked-list of QUOTE commands</desc>
--</constant>
  CURLOPT_HEADERDATA      = 10029,
--<constant>
--<name>CURLOPT_HEADERDATA</name>
--<value>10029</value>
--<desc>
-- send FILE * or void * to store headers to, if you use a callback it
-- is simply passed to the callback unmodified
--</desc>
--</constant>
  CURLOPT_COOKIEFILE      = 10031,
--<constant>
--<name>CURLOPT_COOKIEFILE</name>
--<value>10031</value>
--<desc>point to a file to read the initial cookies from, also enables "cookie awareness"</desc>
--</constant>
  CURLOPT_SSLVERSION      =    32,
--<constant>
--<name>CURLOPT_SSLVERSION</name>
--<value>32</value>
--<desc>What version to specifically try to use. See CURL_SSLVERSION defines below.</desc>
--</constant>
  CURLOPT_TIMECONDITION   =    33,
--<constant>
--<name>CURLOPT_TIMECONDITION</name>
--<value>33</value>
--<desc>What kind of HTTP time condition to use, see defines</desc>
--</constant>
  CURLOPT_TIMEVALUE       =    34,
--<constant>
--<name>CURLOPT_TIMEVALUE</name>
--<value>34</value>
--<desc>
-- Time to use with the above condition. Specified in number of seconds
-- since 1 Jan 1970
--</desc>
--</constant>
  -- 35 = OBSOLETE
  CURLOPT_CUSTOMREQUEST   = 10036,
--<constant>
--<name>CURLOPT_CUSTOMREQUEST</name>
--<value>10036</value>
--<desc>
-- Custom request, for customizing the get command like
-- HTTP: DELETE, TRACE and others
-- FTP: to use a different list command
--</desc>
--</constant>
  CURLOPT_STDERR          = 10037,
--<constant>
--<name>CURLOPT_STDERR</name>
--<value>10037</value>
--<desc>FILE handle to use instead of stderr</desc>
--</constant>
  -- 38 is not used
  CURLOPT_POSTQUOTE       = 10039,
--<constant>
--<name>CURLOPT_POSTQUOTE</name>
--<value>10039</value>
--<desc>send linked-list of post-transfer QUOTE commands</desc>
--</constant>
  CURLOPT_OBSOLETE40      = 10040,
--<constant>
--<name>CURLOPT_OBSOLETE40</name>
--<value>10040</value>
--<desc>OBSOLETE, do not use!</desc>
--</constant>
  CURLOPT_VERBOSE         =    41,
--<constant>
--<name>CURLOPT_VERBOSE</name>
--<value>41</value>
--<desc>talk a lot</desc>
--</constant>
  CURLOPT_HEADER          =    42,
--<constant>
--<name>CURLOPT_HEADER</name>
--<value>42</value>
--<desc>throw the header out too</desc>
--</constant>
  CURLOPT_NOPROGRESS      =    43,
--<constant>
--<name>CURLOPT_NOPROGRESS</name>
--<value>43</value>
--<desc>shut off the progress meter</desc>
--</constant>
  CURLOPT_NOBODY          =    44,
--<constant>
--<name>CURLOPT_NOBODY</name>
--<value>44</value>
--<desc>use HEAD to get http document</desc>
--</constant>
  CURLOPT_FAILONERROR     =    45,
--<constant>
--<name>CURLOPT_FAILONERROR</name>
--<value>45</value>
--<desc>no output on http error codes >= 400</desc>
--</constant>
  CURLOPT_UPLOAD          =    46,
--<constant>
--<name>CURLOPT_UPLOAD</name>
--<value>46</value>
--<desc>this is an upload</desc>
--</constant>
  CURLOPT_POST            =    47,
--<constant>
--<name>CURLOPT_POST</name>
--<value>47</value>
--<desc>HTTP POST method</desc>
--</constant>
  CURLOPT_DIRLISTONLY     =    48,
--<constant>
--<name>CURLOPT_DIRLISTONLY</name>
--<value>48</value>
--<desc>bare names when listing directories</desc>
--</constant>
  CURLOPT_APPEND          =    50,
--<constant>
--<name>CURLOPT_APPEND</name>
--<value>50</value>
--<desc>Append instead of overwrite on upload!</desc>
--</constant>
  CURLOPT_NETRC           =    51,
--<constant>
--<name>CURLOPT_NETRC</name>
--<value>51</value>
--<desc>
-- Specify whether to read the user+password from the .netrc or the URL.
-- This must be one of the CURL_NETRC_* enums below.
--</desc>
--</constant>
  CURLOPT_FOLLOWLOCATION  =    52,
--<constant>
--<name>CURLOPT_FOLLOWLOCATION</name>
--<value>52</value>
--<desc>use Location: Luke!</desc>
--</constant>
  CURLOPT_TRANSFERTEXT    =    53,
--<constant>
--<name>CURLOPT_TRANSFERTEXT</name>
--<value>53</value>
--<desc>transfer data in text/ASCII format</desc>
--</constant>
  CURLOPT_PUT             =    54,
--<constant>
--<name>CURLOPT_PUT</name>
--<value>54</value>
--<desc>HTTP PUT</desc>
--</constant>
  -- 55 = OBSOLETE
  CURLOPT_PROGRESSFUNCTION = 20056,
--<constant>
--<name>CURLOPT_PROGRESSFUNCTION</name>
--<value>20056</value>
--<desc>
-- DEPRECATED
-- Function that will be called instead of the internal progress display public
-- function. This public function should be defined as the curl_progress_callback
-- prototype defines.
--</desc>
--</constant>
  CURLOPT_PROGRESSDATA    = 10057,
--<constant>
--<name>CURLOPT_PROGRESSDATA</name>
--<value>10057</value>
--<desc>
-- Data passed to the CURLOPT_PROGRESSFUNCTION and CURLOPT_XFERINFOFUNCTION
-- callbacks
--</desc>
--</constant>
  CURLOPT_AUTOREFERER     =    58,
--<constant>
--<name>CURLOPT_AUTOREFERER</name>
--<value>58</value>
--<desc>We want the referrer field set automatically when following locations</desc>
--</constant>
  CURLOPT_PROXYPORT       =    59,
--<constant>
--<name>CURLOPT_PROXYPORT</name>
--<value>59</value>
--<desc>
-- Port of the proxy, can be set in the proxy string as well with:
-- "[host]:[port]"
--</desc>
--</constant>
  CURLOPT_POSTFIELDSIZE   =    60,
--<constant>
--<name>CURLOPT_POSTFIELDSIZE</name>
--<value>60</value>
--<desc>size of the POST input data, if strlen() is not good to use</desc>
--</constant>
  CURLOPT_HTTPPROXYTUNNEL =    61,
--<constant>
--<name>CURLOPT_HTTPPROXYTUNNEL</name>
--<value>61</value>
--<desc>tunnel non-http operations through a HTTP proxy</desc>
--</constant>
  CURLOPT_INTERFACE       = 10062,
--<constant>
--<name>CURLOPT_INTERFACE</name>
--<value>10062</value>
--<desc>Set the interface string to use as outgoing network interface</desc>
--</constant>
  CURLOPT_KRBLEVEL        = 10063,
--<constant>
--<name>CURLOPT_KRBLEVEL</name>
--<value>10063</value>
--<desc>
-- Set the krb4/5 security level, this also enables krb4/5 awareness.  This
-- is a string, 'clear', 'safe', 'confidential' or 'private'.  If the string
-- is set but doesn't match one of these, 'private' will be used.
--</desc>
--</constant>
  CURLOPT_SSL_VERIFYPEER  =    64,
--<constant>
--<name>CURLOPT_SSL_VERIFYPEER</name>
--<value>64</value>
--<desc>Set if we should verify the peer in ssl handshake, set 1 to verify.</desc>
--</constant>
  CURLOPT_CAINFO          = 10065,
--<constant>
--<name>CURLOPT_CAINFO</name>
--<value>10065</value>
--<desc>
-- The CApath or CAfile used to validate the peer certificate
-- this option is used only if SSL_VERIFYPEER is true
--</desc>
--</constant>
  -- 66 = OBSOLETE
  -- 67 = OBSOLETE
  CURLOPT_MAXREDIRS       =    68,
--<constant>
--<name>CURLOPT_MAXREDIRS</name>
--<value>68</value>
--<desc>Maximum number of http redirects to follow</desc>
--</constant>
  CURLOPT_FILETIME        =    69,
--<constant>
--<name>CURLOPT_FILETIME</name>
--<value>69</value>
--<desc>
-- Pass a long set to 1 to get the date of the requested document (if
-- possible)! Pass a zero to shut it off.
--</desc>
--</constant>
  CURLOPT_TELNETOPTIONS   = 10070,
--<constant>
--<name>CURLOPT_TELNETOPTIONS</name>
--<value>10070</value>
--<desc>This points to a linked list of telnet options</desc>
--</constant>
  CURLOPT_MAXCONNECTS     =    71,
--<constant>
--<name>CURLOPT_MAXCONNECTS</name>
--<value>71</value>
--<desc>Max amount of cached alive connections</desc>
--</constant>
  CURLOPT_OBSOLETE72      =    72,
--<constant>
--<name>CURLOPT_OBSOLETE72</name>
--<value>72</value>
--<desc>OBSOLETE, do not use!</desc>
--</constant>
  -- 73 = OBSOLETE
  CURLOPT_FRESH_CONNECT   =    74,
--<constant>
--<name>CURLOPT_FRESH_CONNECT</name>
--<value>74</value>
--<desc>
-- Set to explicitly use a new connection for the upcoming transfer.
-- Do not use this unless you're absolutely sure of this, as it makes the
-- operation slower and is less friendly for the network.
--</desc>
--</constant>
  CURLOPT_FORBID_REUSE    =    75,
--<constant>
--<name>CURLOPT_FORBID_REUSE</name>
--<value>75</value>
--<desc>
-- Set to explicitly forbid the upcoming transfer's connection to be re-used
-- when done. Do not use this unless you're absolutely sure of this, as it
-- makes the operation slower and is less friendly for the network.
--</desc>
--</constant>
  CURLOPT_RANDOM_FILE     = 10076,
--<constant>
--<name>CURLOPT_RANDOM_FILE</name>
--<value>10076</value>
--<desc>
-- Set to a file name that contains random data for libcurl to use to
-- seed the random engine when doing SSL connects.
--</desc>
--</constant>
  CURLOPT_EGDSOCKET       = 10077,
--<constant>
--<name>CURLOPT_EGDSOCKET</name>
--<value>10077</value>
--<desc>Set to the Entropy Gathering Daemon socket pathname</desc>
--</constant>
  CURLOPT_CONNECTTIMEOUT  =    78,
--<constant>
--<name>CURLOPT_CONNECTTIMEOUT</name>
--<value>78</value>
--<desc>
-- Time-out connect operations after this amount of seconds, if connects are
-- OK within this time, then fine... This only aborts the connect phase.
--</desc>
--</constant>
  CURLOPT_HEADERFUNCTION  = 20079,
--<constant>
--<name>CURLOPT_HEADERFUNCTION</name>
--<value>20079</value>
--<desc>
-- Function that will be called to store headers (instead of fwrite). The
-- parameters will use fwrite() syntax, make sure to follow them.
--</desc>
--</constant>
  CURLOPT_HTTPGET         =    80,
--<constant>
--<name>CURLOPT_HTTPGET</name>
--<value>80</value>
--<desc>
-- Set this to force the HTTP request to get back to GET. Only really usable
-- if POST, PUT or a custom request have been used first.
--</desc>
--</constant>
  CURLOPT_SSL_VERIFYHOST  =    81,
--<constant>
--<name>CURLOPT_SSL_VERIFYHOST</name>
--<value>81</value>
--<desc>
-- Set if we should verify the Common name from the peer certificate in ssl
-- handshake, set 1 to check existence, 2 to ensure that it matches the
-- provided hostname.
--</desc>
--</constant>
  CURLOPT_COOKIEJAR       = 10082,
--<constant>
--<name>CURLOPT_COOKIEJAR</name>
--<value>10082</value>
--<desc>
-- Specify which file name to write all known cookies in after completed
-- operation. Set file name to "-" (dash) to make it go to stdout.
--</desc>
--</constant>
  CURLOPT_SSL_CIPHER_LIST = 10083,  --
--<constant>
--<name>CURLOPT_SSL_CIPHER_LIST</name>
--<value>10083</value>
--<desc>Specify which SSL ciphers to use</desc>
--</constant>
  CURLOPT_HTTP_VERSION    =    84,
--<constant>
--<name>CURLOPT_HTTP_VERSION</name>
--<value>84</value>
--<desc>
-- Specify which HTTP version to use! This must be set to one of the
-- CURL_HTTP_VERSION* enums set below.
--</desc>
--</constant>
  CURLOPT_FTP_USE_EPSV    =    85,
--<constant>
--<name>CURLOPT_FTP_USE_EPSV</name>
--<value>85</value>
--<desc>
-- Specifically switch on or off the FTP engine's use of the EPSV command. By
-- default, that one will always be attempted before the more traditional
-- PASV command.
--</desc>
--</constant>
  CURLOPT_SSLCERTTYPE     = 10086,
--<constant>
--<name>CURLOPT_SSLCERTTYPE</name>
--<value>10086</value>
--<desc>type of the file keeping your SSL-certificate ("DER", "PEM", "ENG")</desc>
--</constant>
  CURLOPT_SSLKEY          = 10087,
--<constant>
--<name>CURLOPT_SSLKEY</name>
--<value>10087</value>
--<desc>name of the file keeping your private SSL-key</desc>
--</constant>
  CURLOPT_SSLKEYTYPE      = 10088,
--<constant>
--<name>CURLOPT_SSLKEYTYPE</name>
--<value>10088</value>
--<desc>type of the file keeping your private SSL-key ("DER", "PEM", "ENG")</desc>
--</constant>
  CURLOPT_SSLENGINE       = 10089,
--<constant>
--<name>CURLOPT_SSLENGINE</name>
--<value>10089</value>
--<desc>crypto engine for the SSL-sub system</desc>
--</constant>
  CURLOPT_SSLENGINE_DEFAULT =  90,
--<constant>
--<name>CURLOPT_SSLENGINE_DEFAULT</name>
--<value>90</value>
--<desc>
-- set the crypto engine for the SSL-sub system as default
-- the param has no meaning...
--</desc>
--</constant>
  CURLOPT_DNS_USE_GLOBAL_CACHE = 91,
--<constant>
--<name>CURLOPT_DNS_USE_GLOBAL_CACHE</name>
--<value>91</value>
--<desc>
-- Non-zero value means to use the public dns cache
-- DEPRECATED, do not use!
--</desc>
--</constant>
  CURLOPT_DNS_CACHE_TIMEOUT =  92,
--<constant>
--<name>CURLOPT_DNS_CACHE_TIMEOUT</name>
--<value>92</value>
--<desc>DNS cache timeout</desc>
--</constant>
  CURLOPT_PREQUOTE        = 10093,
--<constant>
--<name>CURLOPT_PREQUOTE</name>
--<value>10093</value>
--<desc>send linked-list of pre-transfer QUOTE commands</desc>
--</constant>
  CURLOPT_DEBUGFUNCTION   = 20094,
--<constant>
--<name>CURLOPT_DEBUGFUNCTION</name>
--<value>20094</value>
--<desc>set the debug public function</desc>
--</constant>
  CURLOPT_DEBUGDATA       = 10095,
--<constant>
--<name>CURLOPT_DEBUGDATA</name>
--<value>10095</value>
--<desc>set the data for the debug public function</desc>
--</constant>
  CURLOPT_COOKIESESSION   =    96,
--<constant>
--<name>CURLOPT_COOKIESESSION</name>
--<value>96</value>
--<desc>mark this as start of a cookie session</desc>
--</constant>
  CURLOPT_CAPATH          = 10097,
--<constant>
--<name>CURLOPT_CAPATH</name>
--<value>10097</value>
--<desc>
-- The CApath directory used to validate the peer certificate
-- this option is used only if SSL_VERIFYPEER is true
--</desc>
--</constant>
  CURLOPT_BUFFERSIZE      =    98,
--<constant>
--<name>CURLOPT_BUFFERSIZE</name>
--<value>98</value>
--<desc>Instruct libcurl to use a smaller receive buffer</desc>
--</constant>
  CURLOPT_NOSIGNAL        =    99,
--<constant>
--<name>CURLOPT_NOSIGNAL</name>
--<value>99</value>
--<desc>
-- Instruct libcurl to not use any signal/alarm handlers, even when using
-- timeouts. This option is useful for multi-threaded applications.
-- See libcurl-the-guide for more background information.
--</desc>
--</constant>
  CURLOPT_SHARE           = 10100,
--<constant>
--<name>CURLOPT_SHARE</name>
--<value>10100</value>
--<desc>Provide a CURLShare for mutexing non-ts data</desc>
--</constant>
  CURLOPT_PROXYTYPE       =   101,
--<constant>
--<name>CURLOPT_PROXYTYPE</name>
--<value>101</value>
--<desc>
-- indicates type of proxy. accepted values are CURLPROXY_HTTP (default,
-- CURLPROXY_SOCKS4, CURLPROXY_SOCKS4A and CURLPROXY_SOCKS5.
--</desc>
--</constant>
  CURLOPT_ACCEPT_ENCODING = 10102,
--<constant>
--<name>CURLOPT_ACCEPT_ENCODING</name>
--<value>10102</value>
--<desc>
-- Set the Accept-Encoding string. Use this to tell a server you would like
-- the response to be compressed. Before 7.21.6, this was known as
-- CURLOPT_ENCODING
--</desc>
--</constant>
  CURLOPT_PRIVATE         = 10103,
--<constant>
--<name>CURLOPT_PRIVATE</name>
--<value>10103</value>
--<desc>Set pointer to private data</desc>
--</constant>
  CURLOPT_HTTP200ALIASES  = 10104,
--<constant>
--<name>CURLOPT_HTTP200ALIASES</name>
--<value>10104</value>
--<desc>Set aliases for HTTP 200 in the HTTP Response header</desc>
--</constant>
  CURLOPT_UNRESTRICTED_AUTH = 105,
--<constant>
--<name>CURLOPT_UNRESTRICTED_AUTH</name>
--<value>105</value>
--<desc>
-- Continue to send authentication (user+password) when following locations,
-- even when hostname changed. This can potentially send off the name
-- and password to whatever host the server decides.
--</desc>
--</constant>
  CURLOPT_FTP_USE_EPRT    =   106,
--<constant>
--<name>CURLOPT_FTP_USE_EPRT</name>
--<value>106</value>
--<desc>
-- Specifically switch on or off the FTP engine's use of the EPRT command (
-- it also disables the LPRT attempt). By default, those ones will always be
-- attempted before the good old traditional PORT command.
--</desc>
--</constant>
  CURLOPT_HTTPAUTH        =   107,
--<constant>
--<name>CURLOPT_HTTPAUTH</name>
--<value>107</value>
--<desc>
-- Set this to a bitmask value to enable the particular authentications
-- methods you like. Use this in combination with CURLOPT_USERPWD.
-- Note that setting multiple bits may cause extra network round-trips.
--</desc>
--</constant>
  CURLOPT_SSL_CTX_FUNCTION = 20108,
--<constant>
--<name>CURLOPT_SSL_CTX_FUNCTION</name>
--<value>20108</value>
--<desc>
-- Set the ssl context callback public function, currently only for OpenSSL ssl_ctx
-- in second argument. The public function must be matching the
-- curl_ssl_ctx_callback proto.
--</desc>
--</constant>
  CURLOPT_SSL_CTX_DATA    = 10109,
--<constant>
--<name>CURLOPT_SSL_CTX_DATA</name>
--<value>10109</value>
--<desc>
-- Set the userdata for the ssl context callback public function's third
-- argument
--</desc>
--</constant>
  CURLOPT_FTP_CREATE_MISSING_DIRS = 110,
--<constant>
--<name>CURLOPT_FTP_CREATE_MISSING_DIRS</name>
--<value>110</value>
--<desc>
-- FTP Option that causes missing dirs to be created on the remote server.
-- In 7.19.4 we introduced the convenience enums for this option using the
-- CURLFTP_CREATE_DIR prefix.
--</desc>
--</constant>
  CURLOPT_PROXYAUTH       =   111,
--<constant>
--<name>CURLOPT_PROXYAUTH</name>
--<value>111</value>
--<desc>
-- Set this to a bitmask value to enable the particular authentications
-- methods you like. Use this in combination with CURLOPT_PROXYUSERPWD.
-- Note that setting multiple bits may cause extra network round-trips.
--</desc>
--</constant>
  CURLOPT_FTP_RESPONSE_TIMEOUT = 112,
--<constant>
--<name>CURLOPT_FTP_RESPONSE_TIMEOUT</name>
--<value>112</value>
--<desc>
-- FTP option that changes the timeout, in seconds, associated with
-- getting a response.  This is different from transfer timeout time and
-- essentially places a demand on the FTP server to acknowledge commands
-- in a timely manner.
--</desc>
--</constant>
  CURLOPT_IPRESOLVE       =   113,
--<constant>
--<name>CURLOPT_IPRESOLVE</name>
--<value>113</value>
--<desc>
-- Set this option to one of the CURL_IPRESOLVE_* defines (see below) to
-- tell libcurl to resolve names to those IP versions only. This only has
-- affect on systems with support for more than one, i.e IPv4 _and_ IPv6.
--</desc>
--</constant>
  CURLOPT_MAXFILESIZE     =   114,
--<constant>
--<name>CURLOPT_MAXFILESIZE</name>
--<value>114</value>
--<desc>
-- Set this option to limit the size of a file that will be downloaded from
-- an HTTP or FTP server.
-- Note there is also _LARGE version which adds large file support for
-- platforms which have larger off_t sizes.  See MAXFILESIZE_LARGE below.
--</desc>
--</constant>
  CURLOPT_INFILESIZE_LARGE = 30115,
--<constant>
--<name>CURLOPT_INFILESIZE_LARGE</name>
--<value>30115</value>
--<desc>
-- See the comment for INFILESIZE above, but in short, specifies
-- the size of the file being uploaded.  -1 means unknown.
--</desc>
--</constant>
  CURLOPT_RESUME_FROM_LARGE = 30116,
--<constant>
--<name>CURLOPT_RESUME_FROM_LARGE</name>
--<value>30116</value>
--<desc>
-- Sets the continuation offset.  There is also a LONG version of this;
-- look above for RESUME_FROM.
--</desc>
--</constant>
  CURLOPT_MAXFILESIZE_LARGE = 30117,
--<constant>
--<name>CURLOPT_MAXFILESIZE_LARGE</name>
--<value>30117</value>
--<desc>
-- Sets the maximum size of data that will be downloaded from
-- an HTTP or FTP server.  See MAXFILESIZE above for the LONG version.
--</desc>
--</constant>
  CURLOPT_NETRC_FILE      = 10118,
--<constant>
--<name>CURLOPT_NETRC_FILE</name>
--<value>10118</value>
--<desc>
-- Set this option to the file name of your .netrc file you want libcurl
-- to parse (using the CURLOPT_NETRC option). If not set, libcurl will do
-- a poor attempt to find the user's home directory and check for a .netrc
-- file in there.
--</desc>
--</constant>
  CURLOPT_USE_SSL         =   119,
--<constant>
--<name>CURLOPT_USE_SSL</name>
--<value>119</value>
--<desc>
-- Enable SSL/TLS for FTP, pick one of:
-- CURLUSESSL_TRY     - try using SSL, proceed anyway otherwise
-- CURLUSESSL_CONTROL - SSL for the control connection or fail
-- CURLUSESSL_ALL     - SSL for all communication or fail
--</desc>
--</constant>
  CURLOPT_POSTFIELDSIZE_LARGE = 30120,
--<constant>
--<name>CURLOPT_POSTFIELDSIZE_LARGE</name>
--<value>30120</value>
--<desc>The _LARGE version of the standard POSTFIELDSIZE option</desc>
--</constant>
  CURLOPT_TCP_NODELAY     =   121,
--<constant>
--<name>CURLOPT_TCP_NODELAY</name>
--<value>121</value>
--<desc>Enable/disable the TCP Nagle algorithm</desc>
--</constant>
  -- 122 OBSOLETE, used in 7.12.3. Gone in 7.13.0
  -- 123 OBSOLETE. Gone in 7.16.0
  -- 124 OBSOLETE, used in 7.12.3. Gone in 7.13.0
  -- 125 OBSOLETE, used in 7.12.3. Gone in 7.13.0
  -- 126 OBSOLETE, used in 7.12.3. Gone in 7.13.0
  -- 127 OBSOLETE. Gone in 7.16.0
  -- 128 OBSOLETE. Gone in 7.16.0
  CURLOPT_FTPSSLAUTH      =   129,
--<constant>
--<name>CURLOPT_FTPSSLAUTH</name>
--<value>129</value>
--<desc>
-- When FTP over SSL/TLS is selected (with CURLOPT_USE_SSL, this option
-- can be used to change libcurl's default action which is to first try
-- "AUTH SSL" and then "AUTH TLS" in this order, and proceed when a OK
-- response has been received.
--
-- Available parameters are:
-- CURLFTPAUTH_DEFAULT - let libcurl decide
-- CURLFTPAUTH_SSL     - try "AUTH SSL" first, then TLS
-- CURLFTPAUTH_TLS     - try "AUTH TLS" first, then SSL
--</desc>
--</constant>
  CURLOPT_IOCTLFUNCTION   = 20130,
--<constant>
--<name>CURLOPT_IOCTLFUNCTION</name>
--<value>20130</value>
--<desc></desc>
--</constant>
  CURLOPT_IOCTLDATA       = 10131,
--<constant>
--<name>CURLOPT_IOCTLDATA</name>
--<value>10131</value>
--<desc></desc>
--</constant>
  -- 132 OBSOLETE. Gone in 7.16.0
  -- 133 OBSOLETE. Gone in 7.16.0
  CURLOPT_FTP_ACCOUNT     = 10134,
--<constant>
--<name>CURLOPT_FTP_ACCOUNT</name>
--<value>10134</value>
--<desc>
-- zero terminated string for pass on to the FTP server when asked for
-- "account" info
--</desc>
--</constant>
  CURLOPT_COOKIELIST      = 10135,
--<constant>
--<name>CURLOPT_COOKIELIST</name>
--<value>10135</value>
--<desc>feed cookie into cookie engine</desc>
--</constant>
  CURLOPT_IGNORE_CONTENT_LENGTH = 136,
--<constant>
--<name>CURLOPT_IGNORE_CONTENT_LENGTH</name>
--<value>136</value>
--<desc>ignore Content-Length</desc>
--</constant>
  CURLOPT_FTP_SKIP_PASV_IP =  137,
--<constant>
--<name>CURLOPT_FTP_SKIP_PASV_IP</name>
--<value>137</value>
--<desc>
-- Set to non-zero to skip the IP address received in a 227 PASV FTP server
-- response. Typically used for FTP-SSL purposes but is not restricted to
-- that. libcurl will then instead use the same IP address it used for the
-- control connection.
--</desc>
--</constant>
  CURLOPT_FTP_FILEMETHOD  =   138,
--<constant>
--<name>CURLOPT_FTP_FILEMETHOD</name>
--<value>138</value>
--<desc>Select "file method" to use when doing FTP, see the curl_ftpmethod above.</desc>
--</constant>
  CURLOPT_LOCALPORT       =   139,
--<constant>
--<name>CURLOPT_LOCALPORT</name>
--<value>139</value>
--<desc>Local port number to bind the socket to</desc>
--</constant>
  CURLOPT_LOCALPORTRANGE  =   140,
--<constant>
--<name>CURLOPT_LOCALPORTRANGE</name>
--<value>140</value>
--<desc>
-- Number of ports to try, including the first one set with LOCALPORT.
-- Thus, setting it to 1 will make no additional attempts but the first.
--</desc>
--</constant>
  CURLOPT_CONNECT_ONLY    =   141,
--<constant>
--<name>CURLOPT_CONNECT_ONLY</name>
--<value>141</value>
--<desc>
-- no transfer, set up connection and let application use the socket by
-- extracting it with CURLINFO_LASTSOCKET
--</desc>
--</constant>
  CURLOPT_CONV_FROM_NETWORK_FUNCTION = 20142,
--<constant>
--<name>CURLOPT_CONV_FROM_NETWORK_FUNCTION</name>
--<value>20142</value>
--<desc>
-- Function that will be called to convert from the
-- network encoding (instead of using the iconv calls in libcurl)
--</desc>
--</constant>
  CURLOPT_CONV_TO_NETWORK_FUNCTION = 20143,
--<constant>
--<name>CURLOPT_CONV_TO_NETWORK_FUNCTION</name>
--<value>20143</value>
--<desc>
-- Function that will be called to convert to the
-- network encoding (instead of using the iconv calls in libcurl)
--</desc>
--</constant>
  CURLOPT_CONV_FROM_UTF8_FUNCTION = 20144,
--<constant>
--<name>CURLOPT_CONV_FROM_UTF8_FUNCTION</name>
--<value>20144</value>
--<desc>
-- Function that will be called to convert from UTF8
-- (instead of using the iconv calls in libcurl)
-- Note that this is used only for SSL certificate processing
-- if the connection proceeds too quickly then need to slow it down
-- limit-rate: maximum number of bytes per second to send or receive
--</desc>
--</constant>
  CURLOPT_MAX_SEND_SPEED_LARGE = 30145,
--<constant>
--<name>CURLOPT_MAX_SEND_SPEED_LARGE</name>
--<value>30145</value>
--<desc></desc>
--</constant>
  CURLOPT_MAX_RECV_SPEED_LARGE = 30146,
--<constant>
--<name>CURLOPT_MAX_RECV_SPEED_LARGE</name>
--<value>30146</value>
--<desc></desc>
--</constant>
  CURLOPT_FTP_ALTERNATIVE_TO_USER = 10147,
--<constant>
--<name>CURLOPT_FTP_ALTERNATIVE_TO_USER</name>
--<value>10147</value>
--<desc>Pointer to command string to send if USER/PASS fails.</desc>
--</constant>
  CURLOPT_SOCKOPTFUNCTION = 20148,
--<constant>
--<name>CURLOPT_SOCKOPTFUNCTION</name>
--<value>20148</value>
--<desc>callback public function for setting socket options</desc>
--</constant>
  CURLOPT_SOCKOPTDATA     = 10149,
--<constant>
--<name>CURLOPT_SOCKOPTDATA</name>
--<value>10149</value>
--<desc></desc>
--</constant>
  CURLOPT_SSL_SESSIONID_CACHE = 150,
--<constant>
--<name>CURLOPT_SSL_SESSIONID_CACHE</name>
--<value>150</value>
--<desc>
-- set to 0 to disable session ID re-use for this transfer, default is
-- enabled (== 1)
--</desc>
--</constant>
  CURLOPT_SSH_AUTH_TYPES  =   151,
--<constant>
--<name>CURLOPT_SSH_AUTH_TYPES</name>
--<value>151</value>
--<desc>allowed SSH authentication methods</desc>
--</constant>
  CURLOPT_SSH_PUBLIC_KEYFILE = 10152,
--<constant>
--<name>CURLOPT_SSH_PUBLIC_KEYFILE</name>
--<value>10152</value>
--<desc>Used by scp/sftp to do public/private key authentication</desc>
--</constant>
  CURLOPT_SSH_PRIVATE_KEYFILE = 10153,
--<constant>
--<name>CURLOPT_SSH_PRIVATE_KEYFILE</name>
--<value>10153</value>
--<desc></desc>
--</constant>
  CURLOPT_FTP_SSL_CCC     =   154,
--<constant>
--<name>CURLOPT_FTP_SSL_CCC</name>
--<value>154</value>
--<desc>Send CCC (Clear Command Channel) after authentication</desc>
--</constant>
  CURLOPT_TIMEOUT_MS      =   155,
--<constant>
--<name>CURLOPT_TIMEOUT_MS</name>
--<value>155</value>
--<desc>Same as TIMEOUT and CONNECTTIMEOUT, but with ms resolution</desc>
--</constant>
  CURLOPT_CONNECTTIMEOUT_MS = 156,
--<constant>
--<name>CURLOPT_CONNECTTIMEOUT_MS</name>
--<value>156</value>
--<desc></desc>
--</constant>
  CURLOPT_HTTP_TRANSFER_DECODING = 157,
--<constant>
--<name>CURLOPT_HTTP_TRANSFER_DECODING</name>
--<value>157</value>
--<desc>
-- set to zero to disable the libcurl's decoding and thus pass the raw body
-- data to the application even when it is encoded/compressed
--</desc>
--</constant>
  CURLOPT_HTTP_CONTENT_DECODING = 158,
--<constant>
--<name>CURLOPT_HTTP_CONTENT_DECODING</name>
--<value>158</value>
--<desc></desc>
--</constant>
  CURLOPT_NEW_FILE_PERMS  =   159,
--<constant>
--<name>CURLOPT_NEW_FILE_PERMS</name>
--<value>159</value>
--<desc>
-- Permission used when creating new files and directories on the remote
-- server for protocols that support it, SFTP/SCP/FILE
--</desc>
--</constant>
  CURLOPT_NEW_DIRECTORY_PERMS = 160,
--<constant>
--<name>CURLOPT_NEW_DIRECTORY_PERMS</name>
--<value>160</value>
--<desc></desc>
--</constant>
  CURLOPT_POSTREDIR       =   161,
--<constant>
--<name>CURLOPT_POSTREDIR</name>
--<value>161</value>
--<desc>
-- Set the behaviour of POST when redirecting. Values must be set to one
-- of CURL_REDIR* defines below. This used to be called CURLOPT_POST301
--</desc>
--</constant>
  CURLOPT_SSH_HOST_PUBLIC_KEY_MD5 = 10162,
--<constant>
--<name>CURLOPT_SSH_HOST_PUBLIC_KEY_MD5</name>
--<value>10162</value>
--<desc>used by scp/sftp to verify the host's public key</desc>
--</constant>
  CURLOPT_OPENSOCKETFUNCTION = 20163,
--<constant>
--<name>CURLOPT_OPENSOCKETFUNCTION</name>
--<value>20163</value>
--<desc>
-- Callback public function for opening socket (instead of socket(2)). Optionally,
-- callback is able change the address or refuse to connect returning
-- CURL_SOCKET_BAD.  The callback should have type curl_opensocket_callback
--</desc>
--</constant>
  CURLOPT_OPENSOCKETDATA  = 10164,
--<constant>
--<name>CURLOPT_OPENSOCKETDATA</name>
--<value>10164</value>
--<desc></desc>
--</constant>
  CURLOPT_COPYPOSTFIELDS  = 10165,
--<constant>
--<name>CURLOPT_COPYPOSTFIELDS</name>
--<value>10165</value>
--<desc>POST volatile input fields.</desc>
--</constant>
  CURLOPT_PROXY_TRANSFER_MODE = 166,
--<constant>
--<name>CURLOPT_PROXY_TRANSFER_MODE</name>
--<value>166</value>
--<desc>set transfer mode (;type=<a|i>) when doing FTP via an HTTP proxy</desc>
--</constant>
  CURLOPT_SEEKFUNCTION    = 20167,
--<constant>
--<name>CURLOPT_SEEKFUNCTION</name>
--<value>20167</value>
--<desc>Callback public function for seeking in the input stream</desc>
--</constant>
  CURLOPT_SEEKDATA        = 10168,
--<constant>
--<name>CURLOPT_SEEKDATA</name>
--<value>10168</value>
--<desc></desc>
--</constant>
  CURLOPT_CRLFILE         = 10169,
--<constant>
--<name>CURLOPT_CRLFILE</name>
--<value>10169</value>
--<desc>CRL file</desc>
--</constant>
  CURLOPT_ISSUERCERT      = 10170,
--<constant>
--<name>CURLOPT_ISSUERCERT</name>
--<value>10170</value>
--<desc>Issuer certificate</desc>
--</constant>
  CURLOPT_ADDRESS_SCOPE   =   171,
--<constant>
--<name>CURLOPT_ADDRESS_SCOPE</name>
--<value>171</value>
--<desc>(IPv6) Address scope</desc>
--</constant>
  CURLOPT_CERTINFO        =   172,
--<constant>
--<name>CURLOPT_CERTINFO</name>
--<value>172</value>
--<desc>
-- Collect certificate chain info and allow it to get retrievable with
-- CURLINFO_CERTINFO after the transfer is complete.
--</desc>
--</constant>
  CURLOPT_USERNAME        = 10173,
--<constant>
--<name>CURLOPT_USERNAME</name>
--<value>10173</value>
--<desc>"name" and "pwd" to use when fetching.</desc>
--</constant>
  CURLOPT_PASSWORD        = 10174,
--<constant>
--<name>CURLOPT_PASSWORD</name>
--<value>10174</value>
--<desc></desc>
--</constant>
--<constant>
  CURLOPT_PROXYUSERNAME   = 10175,
--<name>CURLOPT_PROXYUSERNAME</name>
--<value>10175</value>
--<desc>"name" and "pwd" to use with Proxy when fetching.</desc>
--</constant>
  CURLOPT_PROXYPASSWORD   = 10176,
--<constant>
--<name>CURLOPT_PROXYPASSWORD</name>
--<value>10176</value>
--<desc></desc>
--</constant>
  CURLOPT_NOPROXY         = 10177,
--<constant>
--<name>CURLOPT_NOPROXY</name>
--<value>10177</value>
--<desc>
-- Comma separated list of hostnames defining no-proxy zones. These should
-- match both hostnames directly, and hostnames within a domain. For
-- example, local.com will match local.com and www.local.com, but NOT
-- notlocal.com or www.notlocal.com. For compatibility with other
-- implementations of this, .local.com will be considered to be the same as
-- local.com. A single * is the only valid wildcard, and effectively
-- disables the use of proxy.
--</desc>
--</constant>
  CURLOPT_TFTP_BLKSIZE    =   178,
--<constant>
--<name>CURLOPT_TFTP_BLKSIZE</name>
--<value>178</value>
--<desc>block size for TFTP transfers</desc>
--</constant>
  CURLOPT_SOCKS5_GSSAPI_SERVICE = 10179,
--<constant>
--<name>CURLOPT_SOCKS5_GSSAPI_SERVICE</name>
--<value>10179</value>
--<desc>Socks Service. DEPRECATED, do not use!</desc>
--</constant>
  CURLOPT_SOCKS5_GSSAPI_NEC =   180,
--<constant>
--<name>CURLOPT_SOCKS5_GSSAPI_NEC</name>
--<value>180</value>
--<desc>Socks Service</desc>
--</constant>
  CURLOPT_PROTOCOLS       =   181,
--<constant>
--<name>CURLOPT_PROTOCOLS</name>
--<value>181</value>
--<desc>
-- set the bitmask for the protocols that are allowed to be used for the
-- transfer, which thus helps the app which takes URLs from users or other
-- external inputs and want to restrict what protocol(s) to deal
-- with. Defaults to CURLPROTO_ALL.
--</desc>
--</constant>
  CURLOPT_REDIR_PROTOCOLS =   182,
--<constant>
--<name>CURLOPT_REDIR_PROTOCOLS</name>
--<value>182</value>
--<desc>
-- set the bitmask for the protocols that libcurl is allowed to follow to,
-- as a subset of the CURLOPT_PROTOCOLS ones. That means the protocol needs
-- to be set in both bitmasks to be allowed to get redirected to. Defaults
-- to all protocols except FILE and SCP.
--</desc>
--</constant>
  CURLOPT_SSH_KNOWNHOSTS  = 10183,
--<constant>
--<name>CURLOPT_SSH_KNOWNHOSTS</name>
--<value>10183</value>
--<desc>set the SSH knownhost file name to use</desc>
--</constant>
  CURLOPT_SSH_KEYFUNCTION = 20184,
--<constant>
--<name>CURLOPT_SSH_KEYFUNCTION</name>
--<value>20184</value>
--<desc>
-- set the SSH host key callback, must point to a curl_sshkeycallback
-- public function
--</desc>
--</constant>
  CURLOPT_SSH_KEYDATA     = 10185,
--<constant>
--<name>CURLOPT_SSH_KEYDATA</name>
--<value>10185</value>
--<desc>set the SSH host key callback custom pointer</desc>
--</constant>
  CURLOPT_MAIL_FROM       = 10186,
--<constant>
--<name>CURLOPT_MAIL_FROM</name>
--<value>10186</value>
--<desc>set the SMTP mail originator</desc>
--</constant>
  CURLOPT_MAIL_RCPT       = 10187,
--<constant>
--<name>CURLOPT_MAIL_RCPT</name>
--<value>10187</value>
--<desc>set the list of SMTP mail receiver(s)</desc>
--</constant>
  CURLOPT_FTP_USE_PRET    =   188,
--<constant>
--<name>CURLOPT_FTP_USE_PRET</name>
--<value>188</value>
--<desc>FTP: send PRET before PASV</desc>
--</constant>
  CURLOPT_RTSP_REQUEST    =   189,
--<constant>
--<name>CURLOPT_RTSP_REQUEST</name>
--<value>189</value>
--<desc>RTSP request method (OPTIONS, SETUP, PLAY, etc...)</desc>
--</constant>
  CURLOPT_RTSP_SESSION_ID = 10190,
--<constant>
--<name>CURLOPT_RTSP_SESSION_ID</name>
--<value>10190</value>
--<desc>The RTSP session identifier</desc>
--</constant>
  CURLOPT_RTSP_STREAM_URI = 10191,
--<constant>
--<name>CURLOPT_RTSP_STREAM_URI</name>
--<value>10191</value>
--<desc>The RTSP stream URI</desc>
--</constant>
  CURLOPT_RTSP_TRANSPORT  = 10192,
--<constant>
--<name>CURLOPT_RTSP_TRANSPORT</name>
--<value>10192</value>
--<desc>The Transport: header to use in RTSP requests</desc>
--</constant>
  CURLOPT_RTSP_CLIENT_CSEQ =  193,
--<constant>
--<name>CURLOPT_RTSP_CLIENT_CSEQ</name>
--<value>193</value>
--<desc>Manually initialize the client RTSP CSeq for this handle</desc>
--</constant>
  CURLOPT_RTSP_SERVER_CSEQ =  194,
--<constant>
--<name>CURLOPT_RTSP_SERVER_CSEQ</name>
--<value>194</value>
--<desc>Manually initialize the server RTSP CSeq for this handle</desc>
--</constant>
  CURLOPT_INTERLEAVEDATA  = 10195,
--<constant>
--<name>CURLOPT_INTERLEAVEDATA</name>
--<value>10195</value>
--<desc>The stream to pass to INTERLEAVEFUNCTION.</desc>
--</constant>
  CURLOPT_INTERLEAVEFUNCTION = 20196,
--<constant>
--<name>CURLOPT_INTERLEAVEFUNCTION</name>
--<value>20196</value>
--<desc>Let the application define a custom write method for RTP data</desc>
--</constant>
  CURLOPT_WILDCARDMATCH      = 197,
--<constant>
--<name>CURLOPT_WILDCARDMATCH</name>
--<value>197</value>
--<desc>Turn on wildcard matching</desc>
--</constant>
  CURLOPT_CHUNK_BGN_FUNCTION = 20198,
--<constant>
--<name>CURLOPT_CHUNK_BGN_FUNCTION</name>
--<value>20198</value>
--<desc>
-- Directory matching callback called before downloading of an
-- individual file (chunk) started
--</desc>
--</constant>
  CURLOPT_CHUNK_END_FUNCTION = 20199,
--<constant>
--<name>CURLOPT_CHUNK_END_FUNCTION</name>
--<value>20199</value>
--<desc>
-- Directory matching callback called after the file (chunk)
-- was downloaded, or skipped
--</desc>
--</constant>
  CURLOPT_FNMATCH_FUNCTION = 20200,
--<constant>
--<name>CURLOPT_FNMATCH_FUNCTION</name>
--<value>20200</value>
--<desc>Change match (fnmatch-like) callback for wildcard matching</desc>
--</constant>
  CURLOPT_CHUNK_DATA      = 10201,
--<constant>
--<name>CURLOPT_CHUNK_DATA</name>
--<value>10201</value>
--<desc>Let the application define custom chunk data pointer</desc>
--</constant>
  CURLOPT_FNMATCH_DATA    = 10202,
--<constant>
--<name>CURLOPT_FNMATCH_DATA</name>
--<value>10202</value>
--<desc>FNMATCH_FUNCTION user pointer</desc>
--</constant>
  CURLOPT_RESOLVE         = 10203,
--<constant>
--<name>CURLOPT_RESOLVE</name>
--<value>10203</value>
--<desc>send linked-list of name:port:address sets</desc>
--</constant>
  CURLOPT_TLSAUTH_USERNAME = 10204,
--<constant>
--<name>CURLOPT_TLSAUTH_USERNAME</name>
--<value>10204</value>
--<desc>Set a username for authenticated TLS</desc>
--</constant>
  CURLOPT_TLSAUTH_PASSWORD = 10205,
--<constant>
--<name>CURLOPT_TLSAUTH_PASSWORD</name>
--<value>10205</value>
--<desc>Set a password for authenticated TLS</desc>
--</constant>
  CURLOPT_TLSAUTH_TYPE    = 10206,
--<constant>
--<name>CURLOPT_TLSAUTH_TYPE</name>
--<value>10206</value>
--<desc>Set authentication type for authenticated TLS</desc>
--</constant>
  CURLOPT_TRANSFER_ENCODING = 207,
--<constant>
--<name>CURLOPT_TRANSFER_ENCODING</name>
--<value>207</value>
--<desc>
-- Set to 1 to enable the "TE:" header in HTTP requests to ask for
-- compressed transfer-encoded responses. Set to 0 to disable the use of TE:
-- in outgoing requests. The current default is 0, but it might change in a
-- future libcurl release.
--
-- libcurl will ask for the compressed methods it knows of, and if that
-- isn't any, it will not ask for transfer-encoding at all even if this
-- option is set to 1.
--</desc>
--</constant>
  CURLOPT_CLOSESOCKETFUNCTION = 20208,
--<constant>
--<name>CURLOPT_CLOSESOCKETFUNCTION</name>
--<value>20208</value>
--<desc>
-- Callback public function for closing socket (instead of close(2)). The callback
-- should have type curl_closesocket_callback
--</desc>
--</constant>
  CURLOPT_CLOSESOCKETDATA = 10209,
--<constant>
--<name>CURLOPT_CLOSESOCKETDATA</name>
--<value>10209</value>
--<desc></desc>
--</constant>
  CURLOPT_GSSAPI_DELEGATION = 210,
--<constant>
--<name>CURLOPT_GSSAPI_DELEGATION</name>
--<value>210</value>
--<desc>allow GSSAPI credential delegation</desc>
--</constant>
  CURLOPT_DNS_SERVERS     = 10211,
--<constant>
--<name>CURLOPT_DNS_SERVERS</name>
--<value>10211</value>
--<desc>Set the name servers to use for DNS resolution</desc>
--</constant>
  CURLOPT_ACCEPTTIMEOUT_MS =  212,
--<constant>
--<name>CURLOPT_ACCEPTTIMEOUT_MS</name>
--<value>212</value>
--<desc>
-- Time-out accept operations (currently for FTP only) after this amount
-- of miliseconds.
--</desc>
--</constant>
  CURLOPT_TCP_KEEPALIVE   =   213,
--<constant>
--<name>CURLOPT_TCP_KEEPALIVE</name>
--<value>213</value>
--<desc>Set TCP keepalive</desc>
--</constant>
  CURLOPT_TCP_KEEPIDLE    =   214,
--<constant>
--<name>CURLOPT_TCP_KEEPIDLE</name>
--<value>214</value>
--<desc>non-universal keepalive knobs (Linux, AIX, HP-UX, more)</desc>
--</constant>
  CURLOPT_TCP_KEEPINTVL   =   215,
--<constant>
--<name>CURLOPT_TCP_KEEPINTVL</name>
--<value>215</value>
--<desc></desc>
--</constant>
  CURLOPT_SSL_OPTIONS     =   216,
--<constant>
--<name>CURLOPT_SSL_OPTIONS</name>
--<value>216</value>
--<desc>Enable/disable specific SSL features with a bitmask, see CURLSSLOPT_*</desc>
--</constant>
  CURLOPT_MAIL_AUTH       = 10217,
--<constant>
--<name>CURLOPT_MAIL_AUTH</name>
--<value>10217</value>
--<desc>Set the SMTP auth originator</desc>
--</constant>
  CURLOPT_SASL_IR         =   218,
--<constant>
--<name>CURLOPT_SASL_IR</name>
--<value>218</value>
--<desc>Enable/disable SASL initial response</desc>
--</constant>
  CURLOPT_XFERINFOFUNCTION = 20219,
--<constant>
--<name>CURLOPT_XFERINFOFUNCTION</name>
--<value>20219</value>
--<desc>
-- Function that will be called instead of the internal progress display
-- public function. This public function should be defined as the
-- curl_xferinfo_callback prototype defines. (Deprecates CURLOPT_PROGRESSFUNCTION)
--</desc>
--</constant>
  CURLOPT_XOAUTH2_BEARER  = 10220,
--<constant>
--<name>CURLOPT_XOAUTH2_BEARER</name>
--<value>10220</value>
--<desc>The XOAUTH2 bearer token</desc>
--</constant>
  CURLOPT_DNS_INTERFACE   = 10221,
--<constant>
--<name>CURLOPT_DNS_INTERFACE</name>
--<value>10221</value>
--<desc>
-- Set the interface string to use as outgoing network interface for DNS
-- requests. Only supported by the c-ares DNS backend
--</desc>
--</constant>
  CURLOPT_DNS_LOCAL_IP4   = 10222,
--<constant>
--<name>CURLOPT_DNS_LOCAL_IP4</name>
--<value>10222</value>
--<desc>
-- Set the local IPv4 address to use for outgoing DNS requests.
-- Only supported by the c-ares DNS backend
--</desc>
--</constant>
  CURLOPT_DNS_LOCAL_IP6   = 10223,
--<constant>
--<name>CURLOPT_DNS_LOCAL_IP6</name>
--<value>10223</value>
--<desc>
-- Set the local IPv4 address to use for outgoing DNS requests.
-- Only supported by the c-ares DNS backend
--</desc>
--</constant>
  CURLOPT_LOGIN_OPTIONS   = 10224,
--<constant>
--<name>CURLOPT_LOGIN_OPTIONS</name>
--<value>10224</value>
--<desc>Set authentication options directly</desc>
--</constant>
  CURLOPT_SSL_ENABLE_NPN  =   225,
--<constant>
--<name>CURLOPT_SSL_ENABLE_NPN</name>
--<value>225</value>
--<desc>Enable/disable TLS NPN extension (http2 over ssl might fail without)</desc>
--</constant>
  CURLOPT_SSL_ENABLE_ALPN =   226,
--<constant>
--<name>CURLOPT_SSL_ENABLE_ALPN</name>
--<value>226</value>
--<desc>Enable/disable TLS ALPN extension (http2 over ssl might fail without)</desc>
--</constant>
  CURLOPT_EXPECT_100_TIMEOUT_MS = 227,
--<constant>
--<name>CURLOPT_EXPECT_100_TIMEOUT_MS</name>
--<value>227</value>
--<desc>
-- Time to wait for a response to a HTTP request containing an
-- Expect: 100-continue header before sending the data anyway.
--</desc>
--</constant>
  CURLOPT_PROXYHEADER     = 10228,
--<constant>
--<name>CURLOPT_PROXYHEADER</name>
--<value>10228</value>
--<desc>
-- This points to a linked list of headers used for proxy requests only,
-- struct curl_slist kind
--</desc>
--</constant>
  CURLOPT_HEADEROPT       =   229,
--<constant>
--<name>CURLOPT_HEADEROPT</name>
--<value>229</value>
--<desc>Pass in a bitmask of "header options"</desc>
--</constant>
  CURLOPT_PINNEDPUBLICKEY = 10230,
--<constant>
--<name>CURLOPT_PINNEDPUBLICKEY</name>
--<value>10230</value>
--<desc>
-- The public key in DER form used to validate the peer public key
-- this option is used only if SSL_VERIFYPEER is true
--</desc>
--</constant>
  CURLOPT_UNIX_SOCKET_PATH = 10231,
--<constant>
--<name>CURLOPT_UNIX_SOCKET_PATH</name>
--<value>10231</value>
--<desc>Path to Unix domain socket</desc>
--</constant>
  CURLOPT_SSL_VERIFYSTATUS =  232,
--<constant>
--<name>CURLOPT_SSL_VERIFYSTATUS</name>
--<value>232</value>
--<desc>Set if we should verify the certificate status.</desc>
--</constant>
  CURLOPT_SSL_FALSESTART  =   233,
--<constant>
--<name>CURLOPT_SSL_FALSESTART</name>
--<value>233</value>
--<desc>Set if we should enable TLS false start.</desc>
--</constant>
  CURLOPT_PATH_AS_IS      =   234,
--<constant>
--<name>CURLOPT_PATH_AS_IS</name>
--<value>234</value>
--<desc>Do not squash dot-dot sequences</desc>
--</constant>
  CURLOPT_PROXY_SERVICE_NAME = 10235,
--<constant>
--<name>CURLOPT_PROXY_SERVICE_NAME</name>
--<value>10235</value>
--<desc>Proxy Service Name</desc>
--</constant>
  CURLOPT_SERVICE_NAME    = 10236,
--<constant>
--<name>CURLOPT_SERVICE_NAME</name>
--<value>10236</value>
--<desc>Service Name</desc>
--</constant>
  CURLOPT_PIPEWAIT        =    237,
--<constant>
--<name>CURLOPT_PIPEWAIT</name>
--<value>237</value>
--<desc>Wait/don't wait for pipe/mutex to clarify</desc>
--</constant>
  CURLOPT_DEFAULT_PROTOCOL = 10238,
--<constant>
--<name>CURLOPT_DEFAULT_PROTOCOL</name>
--<value>10238</value>
--<desc>Set the protocol used when curl is given a URL without a protocol</desc>
--</constant>
  CURLOPT_STREAM_WEIGHT   =   239,
--<constant>
--<name>CURLOPT_STREAM_WEIGHT</name>
--<value>239</value>
--<desc>Set stream weight, 1 - 256 (default is 16)</desc>
--</constant>
  CURLOPT_STREAM_DEPENDS  = 10240,
--<constant>
--<name>CURLOPT_STREAM_DEPENDS</name>
--<value>10240</value>
--<desc>Set stream dependency on another CURL handle</desc>
--</constant>
  CURLOPT_STREAM_DEPENDS_E = 10241,
--<constant>
--<name>CURLOPT_STREAM_DEPENDS_E</name>
--<value>10241</value>
--<desc>Set E-xclusive stream dependency on another CURL handle</desc>
--</constant>
  CURLOPT_TFTP_NO_OPTIONS =   242,
--<constant>
--<name>CURLOPT_TFTP_NO_OPTIONS</name>
--<value>242</value>
--<desc>Do not send any tftp option requests to the server</desc>
--</constant>
  CURLOPT_CONNECT_TO      = 10243,
--<constant>
--<name>CURLOPT_CONNECT_TO</name>
--<value>10243</value>
--<desc>
-- Linked-list of host:port:connect-to-host:connect-to-port,
-- overrides the URL's host:port (only for the network layer)
--</desc>
--</constant>
  CURLOPT_TCP_FASTOPEN    =   244,
--<constant>
--<name>CURLOPT_TCP_FASTOPEN</name>
--<value>244</value>
--<desc>Set TCP Fast Open</desc>
--</constant>
  CURLOPT_LASTENTRY       =   245
--<constant>
--<name>CURLOPT_LASTENTRY</name>
--<value>245</value>
--<desc>the last unused</desc>
--</constant>

public type CURLoption(integer n)
--<type>
--<name>CURLoption</name>
--<desc>options to be used with curl_easy_setopt().</desc>
--</type>
  integer rem

  rem = remainder(n, 1000)
  return ((rem >= 1) and (rem <= 245))
end type

--------------------------------------------------------------------------------

public constant CURLOPT_XFERINFODATA            = CURLOPT_PROGRESSDATA
--<constant>
--<name>CURLOPT_XFERINFODATA</name>
--<value>CURLOPT_PROGRESSDATA</value>
--<desc></desc>
--</constant>
public constant CURLOPT_SERVER_RESPONSE_TIMEOUT = CURLOPT_FTP_RESPONSE_TIMEOUT
--<constant>
--<name>CURLOPT_SERVER_RESPONSE_TIMEOUT</name>
--<value>CURLOPT_FTP_RESPONSE_TIMEOUT</value>
--<desc></desc>
--</constant>

--------------------------------------------------------------------------------

-- Backwards compatibility with older names
-- These are scheduled to disappear by 2011

-- This was added in version 7.19.1
public constant CURLOPT_POST301 = CURLOPT_POSTREDIR
--<constant>
--<name>CURLOPT_POST301</name>
--<value>CURLOPT_POSTREDIR</value>
--<desc></desc>
--</constant>

-- These are scheduled to disappear by 2009

-- The following were added in 7.17.0
public constant CURLOPT_SSLKEYPASSWD = CURLOPT_KEYPASSWD
--<constant>
--<name>CURLOPT_SSLKEYPASSWD</name>
--<value>CURLOPT_KEYPASSWD</value>
--<desc></desc>
--</constant>
public constant CURLOPT_FTPAPPEND = CURLOPT_APPEND
--<constant>
--<name>CURLOPT_FTPAPPEND</name>
--<value>CURLOPT_APPEND</value>
--<desc></desc>
--</constant>
public constant CURLOPT_FTPLISTONLY = CURLOPT_DIRLISTONLY
--<constant>
--<name>CURLOPT_FTPLISTONLY</name>
--<value>CURLOPT_DIRLISTONLY</value>
--<desc></desc>
--</constant>
public constant CURLOPT_FTP_SSL = CURLOPT_USE_SSL
--<constant>
--<name>CURLOPT_FTP_SSL</name>
--<value>CURLOPT_USE_SSL</value>
--<desc></desc>
--</constant>

-- The following were added earlier

public constant CURLOPT_SSLCERTPASSWD = CURLOPT_KEYPASSWD
--<constant>
--<name>CURLOPT_SSLCERTPASSWD</name>
--<value>CURLOPT_KEYPASSWD</value>
--<desc></desc>
--</constant>
public constant CURLOPT_KRB4LEVEL = CURLOPT_KRBLEVEL
--<constant>
--<name>CURLOPT_KRB4LEVEL</name>
--<value>CURLOPT_KRBLEVEL</value>
--<desc></desc>
--</constant>


--------------------------------------------------------------------------------

  -- Below here follows defines for the CURLOPT_IPRESOLVE option. If a host
  --   name resolves addresses using more than one IP protocol version, this
  --   option might be handy to force libcurl to use a specific IP version.
public constant CURL_IPRESOLVE_WHATEVER = 0
--<constant>
--<name>CURL_IPRESOLVE_WHATEVER</name>
--<value>0</value>
--<desc>default, resolves addresses to all IP versions that your system allows</desc>
--</constant>
public constant CURL_IPRESOLVE_V4       = 1
--<constant>
--<name>CURL_IPRESOLVE_V4</name>
--<value>1</value>
--<desc>resolve to IPv4 addresses</desc>
--</constant>
public constant CURL_IPRESOLVE_V6       = 2
--<constant>
--<name>CURL_IPRESOLVE_V6</name>
--<value>2</value>
--<desc>resolve to IPv6 addresses</desc>
--</constant>

--------------------------------------------------------------------------------

  -- convenient "aliases" that follow the name scheme better
public constant CURLOPT_RTSPHEADER = CURLOPT_HTTPHEADER
--<constant>
--<name>CURLOPT_RTSPHEADER</name>
--<value>CURLOPT_HTTPHEADER</value>
--<desc></desc>
--</constant>

--------------------------------------------------------------------------------

  -- These enums are for use with the CURLOPT_HTTP_VERSION option.
public constant
  CURL_HTTP_VERSION_NONE = 0,
--<constant>
--<name>CURL_HTTP_VERSION_NONE</name>
--<value>0</value>
--<desc>
-- setting this means we don't care, and that we'd like the library to
-- choose the best possible for us!
--</desc>
--</constant>
  CURL_HTTP_VERSION_1_0  = 1,
--<constant>
--<name>CURL_HTTP_VERSION_1_0</name>
--<value>1</value>
--<desc>please use HTTP 1.0 in the request</desc>
--</constant>
  CURL_HTTP_VERSION_1_1  = 2,
--<constant>
--<name>CURL_HTTP_VERSION_1_1</name>
--<value>2</value>
--<desc>please use HTTP 1.1 in the request</desc>
--</constant>
  CURL_HTTP_VERSION_2_0  = 3,
--<constant>
--<name>CURL_HTTP_VERSION_2_0</name>
--<value>3</value>
--<desc>please use HTTP 2 in the request</desc>
--</constant>
  CURL_HTTP_VERSION_2TLS = 4,
--<constant>
--<name>CURL_HTTP_VERSION_2TLS</name>
--<value>4</value>
--<desc>use version 2 for HTTPS, version 1.1 for HTTP</desc>
--</constant>
  CURL_HTTP_VERSION_2_PRIOR_KNOWLEDGE = 5,
--<constant>
--<name>CURL_HTTP_VERSION_2_PRIOR_KNOWLEDGE</name>
--<value>5</value>
--<desc>please use HTTP 2 without HTTP/1.1 Upgrade</desc>
--</constant>
  CURL_HTTP_VERSION_LAST = 6
--<constant>
--<name>CURL_HTTP_VERSION_LAST</name>
--<value>6</value>
--<desc>*ILLEGAL* http version</desc>
--</constant>

-- Convenience definition simple because the name of the version is HTTP/2 and
--   not 2.0. The 2_0 version of the public enum name was set while the version was
--   still planned to be 2.0 and we stick to it for compatibility.
public constant CURL_HTTP_VERSION_2 = CURL_HTTP_VERSION_2_0
--<constant>
--<name>CURL_HTTP_VERSION_2</name>
--<value>CURL_HTTP_VERSION_2_0</value>
--<desc></desc>
--</constant>

--------------------------------------------------------------------------------

-- Public API enums for RTSP requests

public constant
  CURL_RTSPREQ_NONE          =  0,
--<constant>
--<name>CURL_RTSPREQ_NONE</name>
--<value>0</value>
--<desc></desc>
--</constant>
  CURL_RTSPREQ_OPTIONS       =  1,
--<constant>
--<name>CURL_RTSPREQ_OPTIONS</name>
--<value>1</value>
--<desc></desc>
--</constant>
  CURL_RTSPREQ_DESCRIBE      =  2,
--<constant>
--<name>CURL_RTSPREQ_DESCRIBE</name>
--<value>2</value>
--<desc></desc>
--</constant>
  CURL_RTSPREQ_ANNOUNCE      =  3,
--<constant>
--<name>CURL_RTSPREQ_ANNOUNCE</name>
--<value>3</value>
--<desc></desc>
--</constant>
  CURL_RTSPREQ_SETUP         =  4,
--<constant>
--<name>CURL_RTSPREQ_SETUP</name>
--<value>4</value>
--<desc></desc>
--</constant>
  CURL_RTSPREQ_PLAY          =  5,
--<constant>
--<name>CURL_RTSPREQ_PLAY</name>
--<value>5</value>
--<desc></desc>
--</constant>
  CURL_RTSPREQ_PAUSE         =  6,
--<constant>
--<name>CURL_RTSPREQ_PAUSE</name>
--<value>6</value>
--<desc></desc>
--</constant>
  CURL_RTSPREQ_TEARDOWN      =  7,
--<constant>
--<name>CURL_RTSPREQ_TEARDOWN</name>
--<value>7</value>
--<desc></desc>
--</constant>
  CURL_RTSPREQ_GET_PARAMETER =  8,
--<constant>
--<name>CURL_RTSPREQ_GET_PARAMETER</name>
--<value>8</value>
--<desc></desc>
--</constant>
  CURL_RTSPREQ_SET_PARAMETER =  9,
--<constant>
--<name>CURL_RTSPREQ_SET_PARAMETER</name>
--<value>9</value>
--<desc></desc>
--</constant>
  CURL_RTSPREQ_RECORD        = 10,
--<constant>
--<name>CURL_RTSPREQ_RECORD</name>
--<value>10</value>
--<desc></desc>
--</constant>
  CURL_RTSPREQ_RECEIVE       = 11,
--<constant>
--<name>CURL_RTSPREQ_RECEIVE</name>
--<value>11</value>
--<desc></desc>
--</constant>
  CURL_RTSPREQ_LAST          = 12
--<constant>
--<name>CURL_RTSPREQ_LAST</name>
--<value>12</value>
--<desc></desc>
--</constant>

--------------------------------------------------------------------------------

  -- These enums are for use with the CURLOPT_NETRC option.
public constant
  CURL_NETRC_IGNORED  = 0,
--<constant>
--<name>CURL_NETRC_IGNORED</name>
--<value>0</value>
--<desc>The .netrc will never be read. This is the default.</desc>
--</constant>
  CURL_NETRC_OPTIONAL = 1,
--<constant>
--<name>CURL_NETRC_OPTIONAL</name>
--<value>1</value>
--<desc>
-- A user:password in the URL will be preferred to one in the .netrc.
--</desc>
--</constant>
  CURL_NETRC_REQUIRED = 2,
--<constant>
--<name>CURL_NETRC_REQUIRED</name>
--<value>2</value>
--<desc>
-- A user:password in the URL will be ignored.
-- Unless one is set programmatically, the .netrc will be queried.
--</desc>
--</constant>
  CURL_NETRC_LAST     = 3
--<constant>
--<name>CURL_NETRC_LAST</name>
--<value>3</value>
--<desc></desc>
--</constant>

public type CURL_NETRC_OPTION(integer n)
--<type>
--<name>CURL_NETRC_OPTION</name>
--<desc>for use with the CURLOPT_NETRC option</desc>
--</type>
  return ((n >= CURL_NETRC_IGNORED) and (n <= CURL_NETRC_LAST))
end type

--------------------------------------------------------------------------------

public constant
  CURL_SSLVERSION_DEFAULT = 0,
--<constant>
--<name>CURL_SSLVERSION_DEFAULT</name>
--<value>0</value>
--<desc></desc>
--</constant>
  CURL_SSLVERSION_TLSv1   = 1,
--<constant>
--<name>CURL_SSLVERSION_TLSv1</name>
--<value>1</value>
--<desc>TLS 1.x</desc>
--</constant>
  CURL_SSLVERSION_SSLv2   = 2,
--<constant>
--<name>CURL_SSLVERSION_SSLv2</name>
--<value>2</value>
--<desc></desc>
--</constant>
  CURL_SSLVERSION_SSLv3   = 3,
--<constant>
--<name>CURL_SSLVERSION_SSLv3</name>
--<value>3</value>
--<desc></desc>
--</constant>
  CURL_SSLVERSION_TLSv1_0 = 4,
--<constant>
--<name>CURL_SSLVERSION_TLSv1_0</name>
--<value>4</value>
--<desc></desc>
--</constant>
  CURL_SSLVERSION_TLSv1_1 = 5,
--<constant>
--<name>CURL_SSLVERSION_TLSv1_1</name>
--<value>5</value>
--<desc></desc>
--</constant>
  CURL_SSLVERSION_TLSv1_2 = 6,
--<constant>
--<name>CURL_SSLVERSION_TLSv1_2</name>
--<value>6</value>
--<desc></desc>
--</constant>
  CURL_SSLVERSION_LAST    = 7
--<constant>
--<name>CURL_SSLVERSION_LAST</name>
--<value>7</value>
--<desc>never use, keep last</desc>
--</constant>

--------------------------------------------------------------------------------

public constant
  CURL_TLSAUTH_NONE = 0,
--<constant>
--<name>CURL_TLSAUTH_NONE</name>
--<value>0</value>
--<desc></desc>
--</constant>
  CURL_TLSAUTH_SRP  = 1,
--<constant>
--<name>CURL_TLSAUTH_SRP</name>
--<value>1</value>
--<desc></desc>
--</constant>
  CURL_TLSAUTH_LAST = 2
--<constant>
--<name>CURL_TLSAUTH_LAST</name>
--<value>2</value>
--<desc>never use, keep last</desc>
--</constant>

public type CURL_TLSAUTH(integer n)
--<type>
--<name>CURL_TLSAUTH</name>
--<desc></desc>
--</type>
  return ((n >= CURL_TLSAUTH_NONE) and (n <= CURL_TLSAUTH_LAST))
end type

--------------------------------------------------------------------------------

-- symbols to use with CURLOPT_POSTREDIR.
--   CURL_REDIR_POST_301, CURL_REDIR_POST_302 and CURL_REDIR_POST_303
--   can be bitwise ORed so that CURL_REDIR_POST_301 | CURL_REDIR_POST_302
--   | CURL_REDIR_POST_303 == CURL_REDIR_POST_ALL

public constant
  CURL_REDIR_GET_ALL  = 0,
--<constant>
--<name>CURL_REDIR_GET_ALL</name>
--<value>0</value>
--<desc></desc>
--</constant>
  CURL_REDIR_POST_301 = 1,
--<constant>
--<name>CURL_REDIR_POST_301</name>
--<value>1</value>
--<desc></desc>
--</constant>
  CURL_REDIR_POST_302 = 2,
--<constant>
--<name>CURL_REDIR_POST_302</name>
--<value>2</value>
--<desc></desc>
--</constant>
  CURL_REDIR_POST_303 = 4,
--<constant>
--<name>CURL_REDIR_POST_303</name>
--<value>4</value>
--<desc></desc>
--</constant>
  CURL_REDIR_POST_ALL = or_all({CURL_REDIR_POST_301, CURL_REDIR_POST_302, CURL_REDIR_POST_303})
--<constant>
--<name>CURL_REDIR_POST_ALL</name>
--<value>or_all({CURL_REDIR_POST_301, CURL_REDIR_POST_302, CURL_REDIR_POST_303})</value>
--<desc></desc>
--</constant>

--------------------------------------------------------------------------------

public constant
  CURL_TIMECOND_NONE         = 0,
--<constant>
--<name>CURL_TIMECOND_NONE</name>
--<value>0</value>
--<desc></desc>
--</constant>
  CURL_TIMECOND_IFMODSINCE   = 1,
--<constant>
--<name>CURL_TIMECOND_IFMODSINCE</name>
--<value>1</value>
--<desc></desc>
--</constant>
  CURL_TIMECOND_IFUNMODSINCE = 2,
--<constant>
--<name>CURL_TIMECOND_IFUNMODSINCE</name>
--<value>2</value>
--<desc></desc>
--</constant>
  CURL_TIMECOND_LASTMOD      = 3,
--<constant>
--<name>CURL_TIMECOND_LASTMOD</name>
--<value>3</value>
--<desc></desc>
--</constant>
  CURL_TIMECOND_LAST         = 4
--<constant>
--<name>CURL_TIMECOND_LAST</name>
--<value>4</value>
--<desc></desc>
--</constant>

public type curl_TimeCond(integer n)
--<type>
--<name>curl_TimeCond</name>
--<desc></desc>
--</type>
  return ((n >= CURL_TIMECOND_NONE) and (n <= CURL_TIMECOND_LAST))
end type

--------------------------------------------------------------------------------

public constant
  CURLFORM_NOTHING        =  0,
--<constant>
--<name>CURLFORM_NOTHING</name>
--<value>0</value>
--<desc>unused</desc>
--</constant>
  CURLFORM_COPYNAME       =  1,
--<constant>
--<name>CURLFORM_COPYNAME</name>
--<value>1</value>
--<desc></desc>
--</constant>
  CURLFORM_PTRNAME        =  2,
--<constant>
--<name>CURLFORM_PTRNAME</name>
--<value>2</value>
--<desc></desc>
--</constant>
  CURLFORM_NAMELENGTH     =  3,
--<constant>
--<name>CURLFORM_NAMELENGTH</name>
--<value>3</value>
--<desc></desc>
--</constant>
  CURLFORM_COPYCONTENTS   =  4,
--<constant>
--<name>CURLFORM_COPYCONTENTS</name>
--<value>4</value>
--<desc></desc>
--</constant>
  CURLFORM_PTRCONTENTS    =  5,
--<constant>
--<name>CURLFORM_PTRCONTENTS</name>
--<value>5</value>
--<desc></desc>
--</constant>
  CURLFORM_CONTENTSLENGTH =  6,
--<constant>
--<name>CURLFORM_CONTENTSLENGTH</name>
--<value>6</value>
--<desc></desc>
--</constant>
  CURLFORM_FILECONTENT    =  7,
--<constant>
--<name>CURLFORM_FILECONTENT</name>
--<value>7</value>
--<desc></desc>
--</constant>
  CURLFORM_ARRAY          =  8,
--<constant>
--<name>CURLFORM_ARRAY</name>
--<value>8</value>
--<desc></desc>
--</constant>
  CURLFORM_OBSOLETE       =  9,
--<constant>
--<name>CURLFORM_OBSOLETE</name>
--<value>9</value>
--<desc></desc>
--</constant>
  CURLFORM_FILE           = 10,
--<constant>
--<name>CURLFORM_FILE</name>
--<value>10</value>
--<desc></desc>
--</constant>
  CURLFORM_BUFFER         = 11,
--<constant>
--<name>CURLFORM_BUFFER</name>
--<value>11</value>
--<desc></desc>
--</constant>
  CURLFORM_BUFFERPTR      = 12,
--<constant>
--<name>CURLFORM_BUFFERPTR</name>
--<value>12</value>
--<desc></desc>
--</constant>
  CURLFORM_BUFFERLENGTH   = 13,
--<constant>
--<name>CURLFORM_BUFFERLENGTH</name>
--<value>13</value>
--<desc></desc>
--</constant>
  CURLFORM_CONTENTTYPE    = 14,
--<constant>
--<name>CURLFORM_CONTENTTYPE</name>
--<value>14</value>
--<desc></desc>
--</constant>
  CURLFORM_CONTENTHEADER  = 15,
--<constant>
--<name>CURLFORM_CONTENTHEADER</name>
--<value>15</value>
--<desc></desc>
--</constant>
  CURLFORM_FILENAME       = 16,
--<constant>
--<name>CURLFORM_FILENAME</name>
--<value>16</value>
--<desc></desc>
--</constant>
  CURLFORM_END            = 17,
--<constant>
--<name>CURLFORM_END</name>
--<value>17</value>
--<desc></desc>
--</constant>
  CURLFORM_OBSOLETE2      = 18,
--<constant>
--<name>CURLFORM_OBSOLETE2</name>
--<value>18</value>
--<desc></desc>
--</constant>
  CURLFORM_STREAM         = 19,
--<constant>
--<name>CURLFORM_STREAM</name>
--<value>19</value>
--<desc></desc>
--</constant>
  CURLFORM_CONTENTLEN     = 20,
--<constant>
--<name>CURLFORM_CONTENTLEN</name>
--<value>20</value>
--<desc>provide a curl_off_t length</desc>
--</constant>
  CURLFORM_LASTENTRY      = 21
--<constant>
--<name>CURLFORM_LASTENTRY</name>
--<value>21</value>
--<desc>unused</desc>
--</constant>

public type CURLformoption(integer n)
--<type>
--<name>CURLformoption</name>
--<desc></desc>
--</type>
  return ((n >= CURLFORM_NOTHING) and (n <= CURLFORM_LASTENTRY))
end type

--------------------------------------------------------------------------------

public constant
  CURL_FORMADD_OK             = 0,
--<constant>
--<name>CURL_FORMADD_OK</name>
--<value>0</value>
--<desc>no error</desc>
--</constant>
  CURL_FORMADD_MEMORY         = 1,
--<constant>
--<name>CURL_FORMADD_MEMORY</name>
--<value>1</value>
--<desc></desc>
--</constant>
  CURL_FORMADD_OPTION_TWICE   = 2,
--<constant>
--<name>CURL_FORMADD_OPTION_TWICE</name>
--<value>2</value>
--<desc></desc>
--</constant>
  CURL_FORMADD_NULL           = 3,
--<constant>
--<name>CURL_FORMADD_NULL</name>
--<value>3</value>
--<desc></desc>
--</constant>
  CURL_FORMADD_UNKNOWN_OPTION = 4,
--<constant>
--<name>CURL_FORMADD_UNKNOWN_OPTION</name>
--<value>4</value>
--<desc></desc>
--</constant>
  CURL_FORMADD_INCOMPLETE     = 5,
--<constant>
--<name>CURL_FORMADD_INCOMPLETE</name>
--<value>5</value>
--<desc></desc>
--</constant>
  CURL_FORMADD_ILLEGAL_ARRAY  = 6,
--<constant>
--<name>CURL_FORMADD_ILLEGAL_ARRAY</name>
--<value>6</value>
--<desc></desc>
--</constant>
  CURL_FORMADD_DISABLED       = 7,
--<constant>
--<name>CURL_FORMADD_DISABLED</name>
--<value>7</value>
--<desc>libcurl was built with this disabled</desc>
--</constant>
  CURL_FORMADD_LAST           = 8
--<constant>
--<name>CURL_FORMADD_LAST</name>
--<value>8</value>
--<desc></desc>
--</constant>

public type CURLFORMcode(integer n)
--<type>
--<name>CURLFORMcode</name>
--<desc></desc>
--</type>
  return ((n >= CURL_FORMADD_OK) and (n <= CURL_FORMADD_LAST))
end type

--------------------------------------------------------------------------------

-- use this for multipart formpost building
-- Returns code for curl_formadd()
--
-- Returns:
-- CURL_FORMADD_OK             on success
-- CURL_FORMADD_MEMORY         if the FormInfo allocation fails
-- CURL_FORMADD_OPTION_TWICE   if one option is given twice for one Form
-- CURL_FORMADD_NULL           if a null pointer was given for a char
-- CURL_FORMADD_MEMORY         if the allocation of a FormInfo struct failed
-- CURL_FORMADD_UNKNOWN_OPTION if an unknown option was used
-- CURL_FORMADD_INCOMPLETE     if the some FormInfo is not complete (or error)
-- CURL_FORMADD_MEMORY         if a curl_httppost struct cannot be allocated
-- CURL_FORMADD_MEMORY         if some allocation for string copying failed.
-- CURL_FORMADD_ILLEGAL_ARRAY  if an illegal option is used in an array
--

--------------------------------------------------------------------------------

-- public enum for the different supported SSL backends
public constant
  CURLSSLBACKEND_NONE      =  0,
--<constant>
--<name>CURLSSLBACKEND_NONE</name>
--<value>0</value>
--<desc></desc>
--</constant>
  CURLSSLBACKEND_OPENSSL   =  1,
--<constant>
--<name>CURLSSLBACKEND_OPENSSL</name>
--<value>1</value>
--<desc></desc>
--</constant>
  CURLSSLBACKEND_GNUTLS    =  2,
--<constant>
--<name>CURLSSLBACKEND_GNUTLS</name>
--<value>2</value>
--<desc></desc>
--</constant>
  CURLSSLBACKEND_NSS       =  3,
--<constant>
--<name>CURLSSLBACKEND_NSS</name>
--<value>3</value>
--<desc></desc>
--</constant>
  CURLSSLBACKEND_OBSOLETE4 =  4,
--<constant>
--<name>CURLSSLBACKEND_OBSOLETE4</name>
--<value>4</value>
--<desc>Was QSOSSL.</desc>
--</constant>
  CURLSSLBACKEND_GSKIT     =  5,
--<constant>
--<name>CURLSSLBACKEND_GSKIT</name>
--<value>5</value>
--<desc></desc>
--</constant>
  CURLSSLBACKEND_POLARSSL  =  6,
--<constant>
--<name>CURLSSLBACKEND_POLARSSL</name>
--<value>6</value>
--<desc></desc>
--</constant>
  CURLSSLBACKEND_CYASSL    =  7,
--<constant>
--<name>CURLSSLBACKEND_CYASSL</name>
--<value>7</value>
--<desc></desc>
--</constant>
  CURLSSLBACKEND_SCHANNEL  =  8,
--<constant>
--<name>CURLSSLBACKEND_SCHANNEL</name>
--<value>8</value>
--<desc></desc>
--</constant>
  CURLSSLBACKEND_DARWINSSL =  9,
--<constant>
--<name>CURLSSLBACKEND_DARWINSSL</name>
--<value>9</value>
--<desc></desc>
--</constant>
  CURLSSLBACKEND_AXTLS     = 10,
--<constant>
--<name>CURLSSLBACKEND_AXTLS</name>
--<value>10</value>
--<desc></desc>
--</constant>
  CURLSSLBACKEND_MBEDTLS   = 11
--<constant>
--<name>CURLSSLBACKEND_MBEDTLS</name>
--<value>11</value>
--<desc></desc>
--</constant>

public type curl_sslbackend(integer n)
--<type>
--<name>curl_sslbackend</name>
--<desc>for the different supported SSL backends</desc>
--</type>
  return ((n >= CURLSSLBACKEND_NONE) and (n <= CURLSSLBACKEND_MBEDTLS))
end type

-- aliases for library clones and renames
public constant
  CURLSSLBACKEND_LIBRESSL  = 1,
--<constant>
--<name>CURLSSLBACKEND_LIBRESSL</name>
--<value>1</value>
--<desc></desc>
--</constant>
  CURLSSLBACKEND_BORINGSSL = 1,
--<constant>
--<name>CURLSSLBACKEND_BORINGSSL</name>
--<value>1</value>
--<desc></desc>
--</constant>
  CURLSSLBACKEND_WOLFSSL   = 6
--<constant>
--<name>CURLSSLBACKEND_WOLFSSL</name>
--<value>6</value>
--<desc></desc>
--</constant>

--------------------------------------------------------------------------------

public constant
  CURLINFO_STRING   = #100000,
--<constant>
--<name>CURLINFO_STRING</name>
--<value>#100000</value>
--<desc></desc>
--</constant>
  CURLINFO_LONG     = #200000,
--<constant>
--<name>CURLINFO_LONG</name>
--<value>#200000</value>
--<desc></desc>
--</constant>
  CURLINFO_DOUBLE   = #300000,
--<constant>
--<name>CURLINFO_DOUBLE</name>
--<value>#300000</value>
--<desc></desc>
--</constant>
  CURLINFO_SLIST    = #400000,
--<constant>
--<name>CURLINFO_SLIST</name>
--<value>#400000</value>
--<desc></desc>
--</constant>
  CURLINFO_SOCKET   = #500000,
--<constant>
--<name>CURLINFO_SOCKET</name>
--<value>#500000</value>
--<desc></desc>
--</constant>
  CURLINFO_MASK     = #0FFFFF,
--<constant>
--<name>CURLINFO_MASK</name>
--<value>#0FFFFF</value>
--<desc></desc>
--</constant>
  CURLINFO_TYPEMASK = #F00000
--<constant>
--<name>CURLINFO_TYPEMASK</name>
--<value>#F00000</value>
--<desc></desc>
--</constant>

public constant
  CURLINFO_NONE             = 0,
--<constant>
--<name>CURLINFO_NONE</name>
--<value>0</value>
--<desc>never use this</desc>
--</constant>
  CURLINFO_EFFECTIVE_URL    = CURLINFO_STRING + 1,
--<constant>
--<name>CURLINFO_EFFECTIVE_URL</name>
--<value>CURLINFO_STRING + 1</value>
--<desc></desc>
--</constant>
  CURLINFO_RESPONSE_CODE    = CURLINFO_LONG   + 2,
--<constant>
--<name>CURLINFO_RESPONSE_CODE</name>
--<value>CURLINFO_LONG   + 2</value>
--<desc></desc>
--</constant>
  CURLINFO_TOTAL_TIME       = CURLINFO_DOUBLE + 3,
--<constant>
--<name>CURLINFO_TOTAL_TIME</name>
--<value>CURLINFO_DOUBLE + 3</value>
--<desc></desc>
--</constant>
  CURLINFO_NAMELOOKUP_TIME  = CURLINFO_DOUBLE + 4,
--<constant>
--<name>CURLINFO_NAMELOOKUP_TIME</name>
--<value>CURLINFO_DOUBLE + 4</value>
--<desc></desc>
--</constant>
  CURLINFO_CONNECT_TIME     = CURLINFO_DOUBLE + 5,
--<constant>
--<name>CURLINFO_CONNECT_TIME</name>
--<value>CURLINFO_DOUBLE + 5</value>
--<desc></desc>
--</constant>
  CURLINFO_PRETRANSFER_TIME = CURLINFO_DOUBLE + 6,
--<constant>
--<name>CURLINFO_PRETRANSFER_TIME</name>
--<value>CURLINFO_DOUBLE + 6</value>
--<desc></desc>
--</constant>
  CURLINFO_SIZE_UPLOAD      = CURLINFO_DOUBLE + 7,
--<constant>
--<name>CURLINFO_SIZE_UPLOAD</name>
--<value>CURLINFO_DOUBLE + 7</value>
--<desc></desc>
--</constant>
  CURLINFO_SIZE_DOWNLOAD    = CURLINFO_DOUBLE + 8,
--<constant>
--<name>CURLINFO_SIZE_DOWNLOAD</name>
--<value>CURLINFO_DOUBLE + 8</value>
--<desc></desc>
--</constant>
  CURLINFO_SPEED_DOWNLOAD   = CURLINFO_DOUBLE + 9,
--<constant>
--<name>CURLINFO_SPEED_DOWNLOAD</name>
--<value>CURLINFO_DOUBLE + 9</value>
--<desc></desc>
--</constant>
  CURLINFO_SPEED_UPLOAD     = CURLINFO_DOUBLE + 10,
--<constant>
--<name>CURLINFO_SPEED_UPLOAD</name>
--<value>CURLINFO_DOUBLE + 10</value>
--<desc></desc>
--</constant>
  CURLINFO_HEADER_SIZE      = CURLINFO_LONG   + 11,
--<constant>
--<name>CURLINFO_HEADER_SIZE</name>
--<value>CURLINFO_LONG   + 11</value>
--<desc></desc>
--</constant>
  CURLINFO_REQUEST_SIZE     = CURLINFO_LONG   + 12,
--<constant>
--<name>CURLINFO_REQUEST_SIZE</name>
--<value>CURLINFO_LONG   + 12</value>
--<desc></desc>
--</constant>
  CURLINFO_SSL_VERIFYRESULT = CURLINFO_LONG   + 13,
--<constant>
--<name>CURLINFO_SSL_VERIFYRESULT</name>
--<value>CURLINFO_LONG   + 13</value>
--<desc></desc>
--</constant>
  CURLINFO_FILETIME         = CURLINFO_LONG   + 14,
--<constant>
--<name>CURLINFO_FILETIME</name>
--<value>CURLINFO_LONG   + 14</value>
--<desc></desc>
--</constant>
  CURLINFO_CONTENT_LENGTH_DOWNLOAD   = CURLINFO_DOUBLE + 15,
--<constant>
--<name>CURLINFO_CONTENT_LENGTH_DOWNLOAD</name>
--<value>CURLINFO_DOUBLE + 15</value>
--<desc></desc>
--</constant>
  CURLINFO_CONTENT_LENGTH_UPLOAD     = CURLINFO_DOUBLE + 16,
--<constant>
--<name>CURLINFO_CONTENT_LENGTH_UPLOAD</name>
--<value>CURLINFO_DOUBLE + 16</value>
--<desc></desc>
--</constant>
  CURLINFO_STARTTRANSFER_TIME = CURLINFO_DOUBLE + 17,
--<constant>
--<name>CURLINFO_STARTTRANSFER_TIME</name>
--<value>CURLINFO_DOUBLE + 17</value>
--<desc></desc>
--</constant>
  CURLINFO_CONTENT_TYPE     = CURLINFO_STRING + 18,
--<constant>
--<name>CURLINFO_CONTENT_TYPE</name>
--<value>CURLINFO_STRING + 18</value>
--<desc></desc>
--</constant>
  CURLINFO_REDIRECT_TIME    = CURLINFO_DOUBLE + 19,
--<constant>
--<name>CURLINFO_REDIRECT_TIME</name>
--<value>CURLINFO_DOUBLE + 19</value>
--<desc></desc>
--</constant>
  CURLINFO_REDIRECT_COUNT   = CURLINFO_LONG   + 20,
--<constant>
--<name>CURLINFO_REDIRECT_COUNT</name>
--<value>CURLINFO_LONG   + 20</value>
--<desc></desc>
--</constant>
  CURLINFO_PRIVATE          = CURLINFO_STRING + 21,
--<constant>
--<name>CURLINFO_PRIVATE</name>
--<value>CURLINFO_STRING + 21</value>
--<desc></desc>
--</constant>
  CURLINFO_HTTP_CONNECTCODE = CURLINFO_LONG   + 22,
--<constant>
--<name>CURLINFO_HTTP_CONNECTCODE</name>
--<value>CURLINFO_LONG   + 22</value>
--<desc></desc>
--</constant>
  CURLINFO_HTTPAUTH_AVAIL   = CURLINFO_LONG   + 23,
--<constant>
--<name>CURLINFO_HTTPAUTH_AVAIL</name>
--<value>CURLINFO_LONG   + 23</value>
--<desc></desc>
--</constant>
  CURLINFO_PROXYAUTH_AVAIL  = CURLINFO_LONG   + 24,
--<constant>
--<name>CURLINFO_PROXYAUTH_AVAIL</name>
--<value>CURLINFO_LONG   + 24</value>
--<desc></desc>
--</constant>
  CURLINFO_OS_ERRNO         = CURLINFO_LONG   + 25,
--<constant>
--<name>CURLINFO_OS_ERRNO</name>
--<value>CURLINFO_LONG   + 25</value>
--<desc></desc>
--</constant>
  CURLINFO_NUM_CONNECTS     = CURLINFO_LONG   + 26,
--<constant>
--<name>CURLINFO_NUM_CONNECTS</name>
--<value>CURLINFO_LONG   + 26</value>
--<desc></desc>
--</constant>
  CURLINFO_SSL_ENGINES      = CURLINFO_SLIST  + 27,
--<constant>
--<name>CURLINFO_SSL_ENGINES</name>
--<value>CURLINFO_SLIST  + 27</value>
--<desc></desc>
--</constant>
  CURLINFO_COOKIELIST       = CURLINFO_SLIST  + 28,
--<constant>
--<name>CURLINFO_COOKIELIST</name>
--<value>CURLINFO_SLIST  + 28</value>
--<desc></desc>
--</constant>
  CURLINFO_LASTSOCKET       = CURLINFO_LONG   + 29,
--<constant>
--<name>CURLINFO_LASTSOCKET</name>
--<value>CURLINFO_LONG   + 29</value>
--<desc></desc>
--</constant>
  CURLINFO_FTP_ENTRY_PATH   = CURLINFO_STRING + 30,
--<constant>
--<name>CURLINFO_FTP_ENTRY_PATH</name>
--<value>CURLINFO_STRING + 30</value>
--<desc></desc>
--</constant>
  CURLINFO_REDIRECT_URL     = CURLINFO_STRING + 31,
--<constant>
--<name>CURLINFO_REDIRECT_URL</name>
--<value>CURLINFO_STRING + 31</value>
--<desc></desc>
--</constant>
  CURLINFO_PRIMARY_IP       = CURLINFO_STRING + 32,
--<constant>
--<name>CURLINFO_PRIMARY_IP</name>
--<value>CURLINFO_STRING + 32</value>
--<desc></desc>
--</constant>
  CURLINFO_APPCONNECT_TIME  = CURLINFO_DOUBLE + 33,
--<constant>
--<name>CURLINFO_APPCONNECT_TIME</name>
--<value>CURLINFO_DOUBLE + 33</value>
--<desc></desc>
--</constant>
  CURLINFO_CERTINFO         = CURLINFO_SLIST  + 34,
--<constant>
--<name>CURLINFO_CERTINFO</name>
--<value>CURLINFO_SLIST  + 34</value>
--<desc></desc>
--</constant>
  CURLINFO_CONDITION_UNMET  = CURLINFO_LONG   + 35,
--<constant>
--<name>CURLINFO_CONDITION_UNMET</name>
--<value>CURLINFO_LONG   + 35</value>
--<desc></desc>
--</constant>
  CURLINFO_RTSP_SESSION_ID  = CURLINFO_STRING + 36,
--<constant>
--<name>CURLINFO_RTSP_SESSION_ID</name>
--<value>CURLINFO_STRING + 36</value>
--<desc></desc>
--</constant>
  CURLINFO_RTSP_CLIENT_CSEQ = CURLINFO_LONG   + 37,
--<constant>
--<name>CURLINFO_RTSP_CLIENT_CSEQ</name>
--<value>CURLINFO_LONG   + 37</value>
--<desc></desc>
--</constant>
  CURLINFO_RTSP_SERVER_CSEQ = CURLINFO_LONG   + 38,
--<constant>
--<name>CURLINFO_RTSP_SERVER_CSEQ</name>
--<value>CURLINFO_LONG   + 38</value>
--<desc></desc>
--</constant>
  CURLINFO_RTSP_CSEQ_RECV   = CURLINFO_LONG   + 39,
--<constant>
--<name>CURLINFO_RTSP_CSEQ_RECV</name>
--<value>CURLINFO_LONG   + 39</value>
--<desc></desc>
--</constant>
  CURLINFO_PRIMARY_PORT     = CURLINFO_LONG   + 40,
--<constant>
--<name>CURLINFO_PRIMARY_PORT</name>
--<value>CURLINFO_LONG   + 40</value>
--<desc></desc>
--</constant>
  CURLINFO_LOCAL_IP         = CURLINFO_STRING + 41,
--<constant>
--<name>CURLINFO_LOCAL_IP</name>
--<value>CURLINFO_STRING + 41</value>
--<desc></desc>
--</constant>
  CURLINFO_LOCAL_PORT       = CURLINFO_LONG   + 42,
--<constant>
--<name>CURLINFO_LOCAL_PORT</name>
--<value>CURLINFO_LONG   + 42</value>
--<desc></desc>
--</constant>
  CURLINFO_TLS_SESSION      = CURLINFO_SLIST  + 43,
--<constant>
--<name>CURLINFO_TLS_SESSION</name>
--<value>CURLINFO_SLIST  + 43</value>
--<desc></desc>
--</constant>
  CURLINFO_ACTIVESOCKET     = CURLINFO_SOCKET + 44,
--<constant>
--<name>CURLINFO_ACTIVESOCKET</name>
--<value>CURLINFO_SOCKET + 44</value>
--<desc></desc>
--</constant>
  CURLINFO_TLS_SSL_PTR      = CURLINFO_SLIST  + 45,
--<constant>
--<name>CURLINFO_TLS_SSL_PTR</name>
--<value>CURLINFO_SLIST  + 45</value>
--<desc></desc>
--</constant>
  CURLINFO_HTTP_VERSION     = CURLINFO_LONG   + 46,
--<constant>
--<name>CURLINFO_HTTP_VERSION</name>
--<value>CURLINFO_LONG   + 46</value>
--<desc></desc>
--</constant>
  -- Fill in new entries below here!

  CURLINFO_LASTONE          = 46
--<constant>
--<name>CURLINFO_LASTONE</name>
--<value>46</value>
--<desc></desc>
--</constant>

public type CURLINFO(integer n)
--<type>
--<name>CURLINFO</name>
--<desc>options for curl_easy_getinfo()</desc>
--</type>
  integer rem

  rem = and_bits(n, #0000FF)
  return ((rem >= #0) and (rem <= #2F))
end type

-- CURLINFO_RESPONSE_CODE is the new name for the option previously known as
--   CURLINFO_HTTP_CODE
public constant CURLINFO_HTTP_CODE = CURLINFO_RESPONSE_CODE
--<constant>
--<name>CURLINFO_HTTP_CODE</name>
--<value>CURLINFO_RESPONSE_CODE</value>
--<desc></desc>
--</constant>

--------------------------------------------------------------------------------

public constant
  CURLCLOSEPOLICY_NONE                = 0,
--<constant>
--<name>CURLCLOSEPOLICY_NONE</name>
--<value>0</value>
--<desc>never use this</desc>
--</constant>
  CURLCLOSEPOLICY_OLDEST              = 1,
--<constant>
--<name>CURLCLOSEPOLICY_OLDEST</name>
--<value>1</value>
--<desc></desc>
--</constant>
  CURLCLOSEPOLICY_LEAST_RECENTLY_USED = 2,
--<constant>
--<name>CURLCLOSEPOLICY_LEAST_RECENTLY_USED</name>
--<value>2</value>
--<desc></desc>
--</constant>
  CURLCLOSEPOLICY_LEAST_TRAFFIC       = 3,
--<constant>
--<name>CURLCLOSEPOLICY_LEAST_TRAFFIC</name>
--<value>3</value>
--<desc></desc>
--</constant>
  CURLCLOSEPOLICY_SLOWEST             = 4,
--<constant>
--<name>CURLCLOSEPOLICY_SLOWEST</name>
--<value>4</value>
--<desc></desc>
--</constant>
  CURLCLOSEPOLICY_CALLBACK            = 5,
--<constant>
--<name>CURLCLOSEPOLICY_CALLBACK</name>
--<value>5</value>
--<desc></desc>
--</constant>
  CURLCLOSEPOLICY_LAST                = 6
--<constant>
--<name>CURLCLOSEPOLICY_LAST</name>
--<value>6</value>
--<desc>never use this</desc>
--</constant>

public type curl_closepolicy(integer n)
--<type>
--<name>curl_closepolicy</name>
--<desc></desc>
--</type>
  return ((n >= CURLCLOSEPOLICY_NONE) and (n <= CURLCLOSEPOLICY_LAST))
end type

--------------------------------------------------------------------------------

public constant CURL_GLOBAL_SSL       = 1
--<constant>
--<name>CURL_GLOBAL_SSL</name>
--<value>1</value>
--<desc></desc>
--</constant>
public constant CURL_GLOBAL_WIN32     = 2
--<constant>
--<name>CURL_GLOBAL_WIN32</name>
--<value>2</value>
--<desc></desc>
--</constant>
public constant CURL_GLOBAL_ALL       = or_bits(CURL_GLOBAL_SSL, CURL_GLOBAL_WIN32)
--<constant>
--<name>CURL_GLOBAL_ALL</name>
--<value>or_bits(CURL_GLOBAL_SSL, CURL_GLOBAL_WIN32)</value>
--<desc></desc>
--</constant>
public constant CURL_GLOBAL_NOTHING   = 0
--<constant>
--<name>CURL_GLOBAL_NOTHING</name>
--<value>0</value>
--<desc></desc>
--</constant>
public constant CURL_GLOBAL_DEFAULT   = CURL_GLOBAL_ALL
--<constant>
--<name>CURL_GLOBAL_DEFAULT</name>
--<value>CURL_GLOBAL_ALL</value>
--<desc></desc>
--</constant>
public constant CURL_GLOBAL_ACK_EINTR = 4
--<constant>
--<name>CURL_GLOBAL_ACK_EINTR</name>
--<value>4</value>
--<desc></desc>
--</constant>

--------------------------------------------------------------------------------
-- Setup defines, protos etc for the sharing stuff.
--------------------------------------------------------------------------------

--------------------------------------------------------------------------------

-- Different data locks for a single share
public constant
  CURL_LOCK_DATA_NONE        = 0,
--<constant>
--<name>CURL_LOCK_DATA_NONE</name>
--<value>0</value>
--<desc>
--  CURL_LOCK_DATA_SHARE is used internally to say that the locking is just
--  made to change the internal state of the share itself.
--</desc>
--</constant>
  CURL_LOCK_DATA_SHARE       = 1,
--<constant>
--<name>CURL_LOCK_DATA_SHARE</name>
--<value>1</value>
--<desc></desc>
--</constant>
  CURL_LOCK_DATA_COOKIE      = 2,
--<constant>
--<name>CURL_LOCK_DATA_COOKIE</name>
--<value>2</value>
--<desc></desc>
--</constant>
  CURL_LOCK_DATA_DNS         = 3,
--<constant>
--<name>CURL_LOCK_DATA_DNS</name>
--<value>3</value>
--<desc></desc>
--</constant>
  CURL_LOCK_DATA_SSL_SESSION = 4,
--<constant>
--<name>CURL_LOCK_DATA_SSL_SESSION</name>
--<value>4</value>
--<desc></desc>
--</constant>
  CURL_LOCK_DATA_CONNECT     = 5,
--<constant>
--<name>CURL_LOCK_DATA_CONNECT</name>
--<value>5</value>
--<desc></desc>
--</constant>
  CURL_LOCK_DATA_LAST        = 6
--<constant>
--<name>CURL_LOCK_DATA_LAST</name>
--<value>6</value>
--<desc></desc>
--</constant>

public type curl_lock_data(integer n)
--<type>
--<name>curl_lock_data</name>
--<desc>Different data locks for a single share</desc>
--</type>
  return ((n >= CURL_LOCK_DATA_NONE) and (n <= CURL_LOCK_DATA_LAST))
end type

--------------------------------------------------------------------------------

-- Different lock access types
public constant
  CURL_LOCK_ACCESS_NONE   = 0,
--<constant>
--<name>CURL_LOCK_ACCESS_NONE</name>
--<value>0</value>
--<desc>unspecified action</desc>
--</constant>
  CURL_LOCK_ACCESS_SHARED = 1,
--<constant>
--<name>CURL_LOCK_ACCESS_SHARED</name>
--<value>1</value>
--<desc>for read perhaps</desc>
--</constant>
  CURL_LOCK_ACCESS_SINGLE = 2,
--<constant>
--<name>CURL_LOCK_ACCESS_SINGLE</name>
--<value>2</value>
--<desc>for write perhaps</desc>
--</constant>
  CURL_LOCK_ACCESS_LAST   = 4
--<constant>
--<name>CURL_LOCK_ACCESS_LAST</name>
--<value>4</value>
--<desc>never use</desc>
--</constant>

public type curl_lock_access(integer n)
--<type>
--<name>curl_lock_access</name>
--<desc>Different lock access types</desc>
--</type>
  return ((n >= CURL_LOCK_ACCESS_NONE) and (n <= CURL_LOCK_ACCESS_LAST))
end type

--------------------------------------------------------------------------------

public constant
  CURLVERSION_FIRST  = 0,
--<constant>
--<name>CURLVERSION_FIRST</name>
--<value>0</value>
--<desc></desc>
--</constant>
  CURLVERSION_SECOND = 1,
--<constant>
--<name>CURLVERSION_SECOND</name>
--<value>1</value>
--<desc></desc>
--</constant>
  CURLVERSION_THIRD  = 2,
--<constant>
--<name>CURLVERSION_THIRD</name>
--<value>2</value>
--<desc></desc>
--</constant>
  CURLVERSION_FOURTH = 3,
--<constant>
--<name>CURLVERSION_FOURTH</name>
--<value>3</value>
--<desc></desc>
--</constant>
  CURLVERSION_LAST   = 4
--<constant>
--<name>CURLVERSION_LAST</name>
--<value>4</value>
--<desc>never actually use this</desc>
--</constant>

public type CURLversion(integer n)
--<type>
--<name>CURLversion</name>
--<desc></desc>
--</type>
  return ((n >= CURLVERSION_FIRST) and (n <= CURLVERSION_LAST))
end type

public constant CURLVERSION_NOW = CURLVERSION_FOURTH
--<constant>
--<name>CURLVERSION_NOW</name>
--<value>CURLVERSION_FOURTH</value>
--<desc>
-- The 'CURLVERSION_NOW' is the symbolic name meant to be used by
--    basically all programs ever that want to get version information. It is
--    meant to be a built-in version number for what kind of struct the caller
--    expects. If the struct ever changes, we redefine the NOW to another public enum
--    from above.
--</desc>
--</constant>

public constant
  CURL_VERSION_IPV6         =       1,
--<constant>
--<name>CURL_VERSION_IPV6</name>
--<value>1</value>
--<desc>IPv6-enabled</desc>
--</constant>
  CURL_VERSION_KERBEROS4    =       2,
--<constant>
--<name>CURL_VERSION_KERBEROS4</name>
--<value>2</value>
--<desc>Kerberos V4 auth is supported (deprecated)</desc>
--</constant>
  CURL_VERSION_SSL          =       4,
--<constant>
--<name>CURL_VERSION_SSL</name>
--<value>4</value>
--<desc>SSL options are present</desc>
--</constant>
  CURL_VERSION_LIBZ         =       8,
--<constant>
--<name>CURL_VERSION_LIBZ</name>
--<value>8</value>
--<desc>libz features are present</desc>
--</constant>
  CURL_VERSION_NTLM         =      16,
--<constant>
--<name>CURL_VERSION_NTLM</name>
--<value>16</value>
--<desc>NTLM auth is supported</desc>
--</constant>
  CURL_VERSION_GSSNEGOTIATE =      32,
--<constant>
--<name>CURL_VERSION_GSSNEGOTIATE</name>
--<value>32</value>
--<desc>Negotiate auth is supported (deprecated)</desc>
--</constant>
  CURL_VERSION_DEBUG        =      64,
--<constant>
--<name>CURL_VERSION_DEBUG</name>
--<value>64</value>
--<desc>Built with debug capabilities</desc>
--</constant>
  CURL_VERSION_ASYNCHDNS    =     128,
--<constant>
--<name>CURL_VERSION_ASYNCHDNS</name>
--<value>128</value>
--<desc>Asynchronous DNS resolves</desc>
--</constant>
  CURL_VERSION_SPNEGO       =     256,
--<constant>
--<name>CURL_VERSION_SPNEGO</name>
--<value>256</value>
--<desc>SPNEGO auth is supported</desc>
--</constant>
  CURL_VERSION_LARGEFILE    =     512,
--<constant>
--<name>CURL_VERSION_LARGEFILE</name>
--<value>512</value>
--<desc>Supports files larger than 2GB</desc>
--</constant>
  CURL_VERSION_IDN          =   1024,
--<constant>
--<name>CURL_VERSION_IDN</name>
--<value>1024</value>
--<desc>Internationized Domain Names are supported</desc>
--</constant>
  CURL_VERSION_SSPI         =    2048,
--<constant>
--<name>CURL_VERSION_SSPI</name>
--<value>2048</value>
--<desc>Built against Windows SSPI</desc>
--</constant>
  CURL_VERSION_CONV         =    4096,
--<constant>
--<name>CURL_VERSION_CONV</name>
--<value>4096</value>
--<desc>Character conversions supported</desc>
--</constant>
  CURL_VERSION_CURLDEBUG    =    8192,
--<constant>
--<name>CURL_VERSION_CURLDEBUG</name>
--<value>8192</value>
--<desc>Debug memory tracking supported</desc>
--</constant>
  CURL_VERSION_TLSAUTH_SRP  =   16384,
--<constant>
--<name>CURL_VERSION_TLSAUTH_SRP</name>
--<value>16384</value>
--<desc>TLS-SRP auth is supported</desc>
--</constant>
  CURL_VERSION_NTLM_WB      =   32768,
--<constant>
--<name>CURL_VERSION_NTLM_WB</name>
--<value>32768</value>
--<desc>NTLM delegation to winbind helper is suported</desc>
--</constant>
  CURL_VERSION_HTTP2        =   65536,
--<constant>
--<name>CURL_VERSION_HTTP2</name>
--<value>65536</value>
--<desc>HTTP2 support built-in</desc>
--</constant>
  CURL_VERSION_GSSAPI       =  131072,
--<constant>
--<name>CURL_VERSION_GSSAPI</name>
--<value>131072</value>
--<desc>Built against a GSS-API library</desc>
--</constant>
  CURL_VERSION_KERBEROS5    =  262144,
--<constant>
--<name>CURL_VERSION_KERBEROS5</name>
--<value>262144</value>
--<desc>Kerberos V5 auth is supported</desc>
--</constant>
  CURL_VERSION_UNIX_SOCKETS =  524288,
--<constant>
--<name>CURL_VERSION_UNIX_SOCKETS</name>
--<value>524288</value>
--<desc>Unix domain sockets support</desc>
--</constant>
  CURL_VERSION_PSL          = 1048576
--<constant>
--<name>CURL_VERSION_PSL</name>
--<value>1048576</value>
--<desc>Mozilla's Public Suffix List, used for cookie domain verification</desc>
--</constant>

--------------------------------------------------------------------------------

public constant CURLPAUSE_RECV      = 1
--<constant>
--<name>CURLPAUSE_RECV</name>
--<value>1</value>
--<desc></desc>
--</constant>
public constant CURLPAUSE_RECV_CONT = 0
--<constant>
--<name>CURLPAUSE_RECV_CONT</name>
--<value>0</value>
--<desc></desc>
--</constant>

public constant CURLPAUSE_SEND      = 4
--<constant>
--<name>CURLPAUSE_SEND</name>
--<value>4</value>
--<desc></desc>
--</constant>
public constant CURLPAUSE_SEND_CONT = 0
--<constant>
--<name>CURLPAUSE_SEND_CONT</name>
--<value>0</value>
--<desc></desc>
--</constant>

public constant CURLPAUSE_ALL  = or_bits(CURLPAUSE_RECV, CURLPAUSE_SEND)
--<constant>
--<name>CURLPAUSE_ALL</name>
--<value>or_bits(CURLPAUSE_RECV, CURLPAUSE_SEND)</value>
--<desc></desc>
--</constant>
public constant CURLPAUSE_CONT = or_bits(CURLPAUSE_RECV_CONT, CURLPAUSE_SEND_CONT)
--<constant>
--<name>CURLPAUSE_CONT</name>
--<value>or_bits(CURLPAUSE_RECV_CONT, CURLPAUSE_SEND_CONT)</value>
--<desc></desc>
--</constant>


