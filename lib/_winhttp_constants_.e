-- _winhttp_constants_.e

include std/dll.e
include std/math.e

public constant
  INTERNET_DEFAULT_PORT           = 0,
--<constant>
--<name>INTERNET_DEFAULT_PORT</name>
--<value>0</value>
--<desc>use the protocol-specific default</desc>
--</constant>
  INTERNET_DEFAULT_HTTP_PORT      = 80,
--<constant>
--<name>INTERNET_DEFAULT_HTTP_PORT</name>
--<value>80</value>
--<desc>use the HTTP default</desc>
--</constant>
  INTERNET_DEFAULT_HTTPS_PORT     = 443
--<constant>
--<name>INTERNET_DEFAULT_HTTPS_PORT</name>
--<value>443</value>
--<desc>use the HTTPS default</desc>
--</constant>

-- flags:
public constant
  WINHTTP_FLAG_ESCAPE_PERCENT        = #00000004,
--<constant>
--<name>WINHTTP_FLAG_ESCAPE_PERCENT</name>
--<value>#00000004</value>
--<desc>if escaping enabled, escape percent as well</desc>
--</constant>
  WINHTTP_FLAG_NULL_CODEPAGE         = #00000008,
--<constant>
--<name>WINHTTP_FLAG_NULL_CODEPAGE</name>
--<value>#00000008</value>
--<desc>assume all symbols are ASCII, use fast convertion</desc>
--</constant>
  WINHTTP_FLAG_ESCAPE_DISABLE        = #00000040,
--<constant>
--<name>WINHTTP_FLAG_ESCAPE_DISABLE</name>
--<value>#00000040</value>
--<desc>disable escaping</desc>
--</constant>
  WINHTTP_FLAG_ESCAPE_DISABLE_QUERY  = #00000080,
--<constant>
--<name>WINHTTP_FLAG_ESCAPE_DISABLE_QUERY</name>
--<value>#00000080</value>
--<desc>if escaping enabled escape path part, but do not escape query</desc>
--</constant>
  WINHTTP_FLAG_BYPASS_PROXY_CACHE    = #00000100,
--<constant>
--<name>WINHTTP_FLAG_BYPASS_PROXY_CACHE</name>
--<value>#00000100</value>
--<desc>add "pragma: no-cache" request header</desc>
--</constant>
  WINHTTP_FLAG_REFRESH               = WINHTTP_FLAG_BYPASS_PROXY_CACHE,
--<constant>
--<name>WINHTTP_FLAG_REFRESH</name>
--<value>WINHTTP_FLAG_BYPASS_PROXY_CACHE</value>
--<desc></desc>
--</constant>
  WINHTTP_FLAG_SECURE                = #00800000,
--<constant>
--<name>WINHTTP_FLAG_SECURE</name>
--<value>#00800000</value>
--<desc>use SSL if applicable (HTTPS)</desc>
--</constant>
  WINHTTP_FLAG_ASYNC                 = #10000000,
--<constant>
--<name>WINHTTP_FLAG_ASYNC</name>
--<value>#10000000</value>
--<desc>this session is asynchronous (where supported)</desc>
--</constant>

  SECURITY_FLAG_IGNORE_UNKNOWN_CA         = #00000100,
--<constant>
--<name>SECURITY_FLAG_IGNORE_UNKNOWN_CA</name>
--<value>#00000100</value>
--<desc></desc>
--</constant>
  SECURITY_FLAG_IGNORE_CERT_WRONG_USAGE   = #00000200,
--<constant>
--<name>SECURITY_FLAG_IGNORE_CERT_WRONG_USAGE</name>
--<value>#00000200</value>
--<desc></desc>
--</constant>
  SECURITY_FLAG_IGNORE_CERT_CN_INVALID    = #00001000,
--<constant>
--<name>SECURITY_FLAG_IGNORE_CERT_CN_INVALID</name>
--<value>#00001000</value>
--<desc>bad common name in X509 Cert.</desc>
--</constant>
  SECURITY_FLAG_IGNORE_CERT_DATE_INVALID  = #00002000
--<constant>
--<name>SECURITY_FLAG_IGNORE_CERT_DATE_INVALID</name>
--<value>#00002000</value>
--<desc>expired X509 Cert.</desc>
--</constant>


--
-- WINHTTP_ASYNC_RESULT - this structure is returned to the application via
-- the callback with WINHTTP_CALLBACK_STATUS_REQUEST_COMPLETE. It is not sufficient to
-- just return the result of the async operation. If the API failed then the
-- app cannot call GetLastError() because the thread context will be incorrect.
-- Both the value returned by the async API and any resultant error code are
-- made available. The app need not check dwError if dwResult indicates that
-- the API succeeded (in this case dwError will be ERROR_SUCCESS)
--

-- typedef struct
-- {
--     DWORD_PTR dwResult;  -- indicates which async API has encountered an error
--     dword dwError;       -- the error code if the API failed
-- }
-- WINHTTP_ASYNC_RESULT, * LPWINHTTP_ASYNC_RESULT;


--
-- HTTP_VERSION_INFO - query or set public HTTP version (1.0 or 1.1)
--

-- typedef struct
-- {
--     dword dwMajorVersion;
--     dword dwMinorVersion;
-- }
-- HTTP_VERSION_INFO, * LPHTTP_VERSION_INFO;


--
-- INTERNET_SCHEME - URL scheme type
--

-- typedef int INTERNET_SCHEME, * LPINTERNET_SCHEME;

public constant
  INTERNET_SCHEME_HTTP  = 1,
--<constant>
--<name>INTERNET_SCHEME_HTTP</name>
--<value>1</value>
--<desc></desc>
--</constant>
  INTERNET_SCHEME_HTTPS = 2,
--<constant>
--<name>INTERNET_SCHEME_HTTPS</name>
--<value>2</value>
--<desc></desc>
--</constant>
  INTERNET_SCHEME_FTP   = 3,
--<constant>
--<name>INTERNET_SCHEME_FTP</name>
--<value>3</value>
--<desc></desc>
--</constant>
  INTERNET_SCHEME_SOCKS = 4
--<constant>
--<name>INTERNET_SCHEME_SOCKS</name>
--<value>4</value>
--<desc></desc>
--</constant>

--
-- URL_COMPONENTS - the constituent parts of an URL. Used in WinHttpCrackUrl()
-- and WinHttpCreateUrl()
--
-- For WinHttpCrackUrl(), if a pointer field and its corresponding length field
-- are both 0 then that component is not returned. If the pointer field is NULL
-- but the length field is not zero, then both the pointer and length fields are
-- returned if both pointer and corresponding length fields are non-zero then
-- the pointer field points to a buffer where the component is copied. The
-- component may be un-escaped, depending on dwFlags
--
-- For WinHttpCreateUrl(), the pointer fields should be NULL if the component
-- is not required. If the corresponding length field is zero then the pointer
-- field is the address of a zero-terminated string. If the length field is not
-- zero then it is the string length of the corresponding pointer field
--

-- #pragma warning( disable : 4121 )   -- disable alignment warning

-- typedef struct
-- {
--     dword   dwStructSize;       -- size of this structure. Used in version check
--     LPWSTR  lpszScheme;         -- pointer to scheme name
--     dword   dwSchemeLength;     -- length of scheme name
--     INTERNET_SCHEME nScheme;    -- enumerated scheme type (if known)
--     LPWSTR  lpszHostName;       -- pointer to host name
--     dword   dwHostNameLength;   -- length of host name
--     INTERNET_PORT nPort;        -- converted port number
--     LPWSTR  lpszUserName;       -- pointer to user name
--     dword   dwUserNameLength;   -- length of user name
--     LPWSTR  lpszPassword;       -- pointer to password
--     dword   dwPasswordLength;   -- length of password
--     LPWSTR  lpszUrlPath;        -- pointer to URL-path
--     dword   dwUrlPathLength;    -- length of URL-path
--     LPWSTR  lpszExtraInfo;      -- pointer to extra information (e.g. ?foo or #foo)
--     dword   dwExtraInfoLength;  -- length of extra information
-- }
-- URL_COMPONENTS, * LPURL_COMPONENTS;

-- #pragma warning( default : 4121 )   -- restore alignment warning

--
-- WINHTTP_PROXY_INFO - structure supplied with WINHTTP_OPTION_PROXY to get/
-- set proxy information on a WinHttpOpen() handle
--

-- typedef struct
-- {
--     dword  dwAccessType;      -- see WINHTTP_ACCESS_* types below
--     LPWSTR lpszProxy;         -- proxy server list
--     LPWSTR lpszProxyBypass;   -- proxy bypass list
-- }
-- WINHTTP_PROXY_INFO, * LPWINHTTP_PROXY_INFO;



-- typedef struct
-- {
--     dword   dwFlags;
--     dword   dwAutoDetectFlags;
--     LPCWSTR lpszAutoConfigUrl;
--     LPVOID  lpvReserved;
--     dword   dwReserved;
--     bool    fAutoLogonIfChallenged;
-- }
-- WINHTTP_AUTOPROXY_OPTIONS;

public constant
  WINHTTP_AUTOPROXY_AUTO_DETECT           = #00000001,
--<constant>
--<name>WINHTTP_AUTOPROXY_AUTO_DETECT</name>
--<value>#00000001</value>
--<desc></desc>
--</constant>
  WINHTTP_AUTOPROXY_CONFIG_URL            = #00000002,
--<constant>
--<name>WINHTTP_AUTOPROXY_CONFIG_URL</name>
--<value>#00000002</value>
--<desc></desc>
--</constant>
  WINHTTP_AUTOPROXY_HOST_KEEPCASE         = #00000004,
--<constant>
--<name>WINHTTP_AUTOPROXY_HOST_KEEPCASE</name>
--<value>#00000004</value>
--<desc></desc>
--</constant>
  WINHTTP_AUTOPROXY_HOST_LOWERCASE        = #00000008,
--<constant>
--<name>WINHTTP_AUTOPROXY_HOST_LOWERCASE</name>
--<value>#00000008</value>
--<desc></desc>
--</constant>
  WINHTTP_AUTOPROXY_RUN_INPROCESS         = #00010000,
--<constant>
--<name>WINHTTP_AUTOPROXY_RUN_INPROCESS</name>
--<value>#00010000</value>
--<desc></desc>
--</constant>
  WINHTTP_AUTOPROXY_RUN_OUTPROCESS_ONLY   = #00020000,
--<constant>
--<name>WINHTTP_AUTOPROXY_RUN_OUTPROCESS_ONLY</name>
--<value>#00020000</value>
--<desc></desc>
--</constant>
  WINHTTP_AUTOPROXY_NO_DIRECTACCESS       = #00040000,
--<constant>
--<name>WINHTTP_AUTOPROXY_NO_DIRECTACCESS</name>
--<value>#00040000</value>
--<desc></desc>
--</constant>
  WINHTTP_AUTOPROXY_NO_CACHE_CLIENT       = #00080000,
--<constant>
--<name>WINHTTP_AUTOPROXY_NO_CACHE_CLIENT</name>
--<value>#00080000</value>
--<desc></desc>
--</constant>
  WINHTTP_AUTOPROXY_NO_CACHE_SVC          = #00100000,
--<constant>
--<name>WINHTTP_AUTOPROXY_NO_CACHE_SVC</name>
--<value>#00100000</value>
--<desc></desc>
--</constant>
  WINHTTP_AUTOPROXY_SORT_RESULTS          = #00400000
--<constant>
--<name>WINHTTP_AUTOPROXY_SORT_RESULTS</name>
--<value>#00400000</value>
--<desc></desc>
--</constant>

--
-- Flags for dwAutoDetectFlags
--
public constant
  WINHTTP_AUTO_DETECT_TYPE_DHCP           = #00000001,
--<constant>
--<name>WINHTTP_AUTO_DETECT_TYPE_DHCP</name>
--<value>#00000001</value>
--<desc>Flag for dwAutoDetectFlags</desc>
--</constant>
  WINHTTP_AUTO_DETECT_TYPE_DNS_A          = #00000002
--<constant>
--<name>WINHTTP_AUTO_DETECT_TYPE_DNS_A</name>
--<value>#00000002</value>
--<desc>Flag for dwAutoDetectFlags</desc>
--</constant>

--
-- WINHTTP_PROXY_RESULT - structure containing parsed proxy result,
-- see WinHttpGetProxyForUrlEx and WinHttpGetProxyResult, use WinHttpFreeProxyResult to free its members.
--

-- typedef struct _WINHTTP_PROXY_RESULT_ENTRY
-- {
--     bool            fProxy;                -- Is this a proxy or DIRECT?
--     bool            fBypass;               -- If DIRECT, is it bypassing a proxy (intranet) or is all traffic DIRECT (internet)
--     INTERNET_SCHEME ProxyScheme;           -- The scheme of the proxy, SOCKS, HTTP (CERN Proxy), HTTPS (SSL through Proxy)
--     PWSTR           pwszProxy;             -- Hostname of the proxy.
--     INTERNET_PORT   ProxyPort;             -- Port of the proxy.
-- } WINHTTP_PROXY_RESULT_ENTRY;

-- typedef struct _WINHTTP_PROXY_RESULT
-- {
--     dword cEntries;
--     WINHTTP_PROXY_RESULT_ENTRY *pEntries;
-- } WINHTTP_PROXY_RESULT;

--
-- WINHTTP_CERTIFICATE_INFO lpBuffer - contains the certificate returned from
-- the server
--

-- typedef struct
-- {
--     -- ftExpiry - date the certificate expires.
--     FILETIME ftExpiry;
--
--     -- ftStart - date the certificate becomes valid.
--     FILETIME ftStart;
--
--     -- lpszSubjectInfo - the name of organization, site, and server
--     --   the cert. was issued for.
--     LPWSTR lpszSubjectInfo;
--
--     -- lpszIssuerInfo - the name of orgainzation, site, and server
--     --   the cert was issues by.
--     LPWSTR lpszIssuerInfo;
--
--     -- lpszProtocolName - the name of the protocol used to provide the secure
--     --   connection.
--     LPWSTR lpszProtocolName;
--
--     -- lpszSignatureAlgName - the name of the algorithm used for signing
--     --  the certificate.
--     LPWSTR lpszSignatureAlgName;
--
--     -- lpszEncryptionAlgName - the name of the algorithm used for
--     --  doing encryption over the secure channel (SSL) connection.
--     LPWSTR lpszEncryptionAlgName;
--
--     -- dwKeySize - size of the key.
--     dword dwKeySize;
--
-- }
-- WINHTTP_CERTIFICATE_INFO;

-- #ifdef _WS2DEF_
--
-- typedef struct
-- {
--     dword cbSize;
--     SOCKADDR_STORAGE LocalAddress;  -- local ip, local port
--     SOCKADDR_STORAGE RemoteAddress; -- remote ip, remote port
--
-- }WINHTTP_CONNECTION_INFO;
--
-- #endif

--
-- constants for WinHttpTimeFromSystemTime
--

public constant
  WINHTTP_TIME_FORMAT_BUFSIZE   = 62
--<constant>
--<name>WINHTTP_TIME_FORMAT_BUFSIZE</name>
--<value>62</value>
--<desc>constant for WinHttpTimeFromSystemTime</desc>
--</constant>

--
-- options manifests for WinHttp{Query|Set}Option
--

public constant
  WINHTTP_OPTION_CALLBACK                       =   1,
--<constant>
--<name>WINHTTP_OPTION_CALLBACK</name>
--<value>1</value>
--<desc></desc>
--</constant>
  WINHTTP_FIRST_OPTION                          = WINHTTP_OPTION_CALLBACK,
--<constant>
--<name>WINHTTP_FIRST_OPTION</name>
--<value>WINHTTP_OPTION_CALLBACK</value>
--<desc></desc>
--</constant>
  WINHTTP_OPTION_RESOLVE_TIMEOUT                =   2,
--<constant>
--<name>WINHTTP_OPTION_RESOLVE_TIMEOUT</name>
--<value>2</value>
--<desc></desc>
--</constant>
  WINHTTP_OPTION_CONNECT_TIMEOUT                =   3,
--<constant>
--<name>WINHTTP_OPTION_CONNECT_TIMEOUT</name>
--<value>3</value>
--<desc></desc>
--</constant>
  WINHTTP_OPTION_CONNECT_RETRIES                =   4,
--<constant>
--<name>WINHTTP_OPTION_CONNECT_RETRIES</name>
--<value>4</value>
--<desc></desc>
--</constant>
  WINHTTP_OPTION_SEND_TIMEOUT                   =   5,
--<constant>
--<name>WINHTTP_OPTION_SEND_TIMEOUT</name>
--<value>5</value>
--<desc></desc>
--</constant>
  WINHTTP_OPTION_RECEIVE_TIMEOUT                =   6,
--<constant>
--<name>WINHTTP_OPTION_RECEIVE_TIMEOUT</name>
--<value>6</value>
--<desc></desc>
--</constant>
  WINHTTP_OPTION_RECEIVE_RESPONSE_TIMEOUT       =   7,
--<constant>
--<name>WINHTTP_OPTION_RECEIVE_RESPONSE_TIMEOUT</name>
--<value>7</value>
--<desc></desc>
--</constant>
  WINHTTP_OPTION_HANDLE_TYPE                    =   9,
--<constant>
--<name>WINHTTP_OPTION_HANDLE_TYPE</name>
--<value>9</value>
--<desc></desc>
--</constant>
  WINHTTP_OPTION_READ_BUFFER_SIZE               =  12,
--<constant>
--<name>WINHTTP_OPTION_READ_BUFFER_SIZE</name>
--<value>12</value>
--<desc></desc>
--</constant>
  WINHTTP_OPTION_WRITE_BUFFER_SIZE              =  13,
--<constant>
--<name>WINHTTP_OPTION_WRITE_BUFFER_SIZE</name>
--<value>13</value>
--<desc></desc>
--</constant>
  WINHTTP_OPTION_PARENT_HANDLE                  =  21,
--<constant>
--<name>WINHTTP_OPTION_PARENT_HANDLE</name>
--<value>21</value>
--<desc></desc>
--</constant>
  WINHTTP_OPTION_EXTENDED_ERROR                 =  24,
--<constant>
--<name>WINHTTP_OPTION_EXTENDED_ERROR</name>
--<value>24</value>
--<desc></desc>
--</constant>
  WINHTTP_OPTION_SECURITY_FLAGS                 =  31,
--<constant>
--<name>WINHTTP_OPTION_SECURITY_FLAGS</name>
--<value>31</value>
--<desc></desc>
--</constant>
  WINHTTP_OPTION_SECURITY_CERTIFICATE_STRUCT    =  32,
--<constant>
--<name>WINHTTP_OPTION_SECURITY_CERTIFICATE_STRUCT</name>
--<value>32</value>
--<desc></desc>
--</constant>
  WINHTTP_OPTION_URL                            =  34,
--<constant>
--<name>WINHTTP_OPTION_URL</name>
--<value>34</value>
--<desc></desc>
--</constant>
  WINHTTP_OPTION_SECURITY_KEY_BITNESS           =  36,
--<constant>
--<name>WINHTTP_OPTION_SECURITY_KEY_BITNESS</name>
--<value>36</value>
--<desc></desc>
--</constant>
  WINHTTP_OPTION_PROXY                          =  38,
--<constant>
--<name>WINHTTP_OPTION_PROXY</name>
--<value>38</value>
--<desc></desc>
--</constant>
  WINHTTP_OPTION_PROXY_RESULT_ENTRY             =  39,
--<constant>
--<name>WINHTTP_OPTION_PROXY_RESULT_ENTRY</name>
--<value>39</value>
--<desc></desc>
--</constant>
  WINHTTP_OPTION_USER_AGENT                     =  41,
--<constant>
--<name>WINHTTP_OPTION_USER_AGENT</name>
--<value>41</value>
--<desc></desc>
--</constant>
  WINHTTP_OPTION_CONTEXT_VALUE                  =  45,
--<constant>
--<name>WINHTTP_OPTION_CONTEXT_VALUE</name>
--<value>45</value>
--<desc></desc>
--</constant>
  WINHTTP_OPTION_CLIENT_CERT_CONTEXT            =  47,
--<constant>
--<name>WINHTTP_OPTION_CLIENT_CERT_CONTEXT</name>
--<value>47</value>
--<desc></desc>
--</constant>
  WINHTTP_OPTION_REQUEST_PRIORITY               =  58,
--<constant>
--<name>WINHTTP_OPTION_REQUEST_PRIORITY</name>
--<value>58</value>
--<desc></desc>
--</constant>
  WINHTTP_OPTION_HTTP_VERSION                   =  59,
--<constant>
--<name>WINHTTP_OPTION_HTTP_VERSION</name>
--<value>59</value>
--<desc></desc>
--</constant>
  WINHTTP_OPTION_DISABLE_FEATURE                =  63,
--<constant>
--<name>WINHTTP_OPTION_DISABLE_FEATURE</name>
--<value>63</value>
--<desc></desc>
--</constant>
  WINHTTP_OPTION_CODEPAGE                       =  68,
--<constant>
--<name>WINHTTP_OPTION_CODEPAGE</name>
--<value>68</value>
--<desc></desc>
--</constant>
  WINHTTP_OPTION_MAX_CONNS_PER_SERVER           =  73,
--<constant>
--<name>WINHTTP_OPTION_MAX_CONNS_PER_SERVER</name>
--<value>73</value>
--<desc></desc>
--</constant>
  WINHTTP_OPTION_MAX_CONNS_PER_1_0_SERVER       =  74,
--<constant>
--<name>WINHTTP_OPTION_MAX_CONNS_PER_1_0_SERVER</name>
--<value>74</value>
--<desc></desc>
--</constant>
  WINHTTP_OPTION_AUTOLOGON_POLICY               =  77,
--<constant>
--<name>WINHTTP_OPTION_AUTOLOGON_POLICY</name>
--<value>77</value>
--<desc></desc>
--</constant>
  WINHTTP_OPTION_SERVER_CERT_CONTEXT            =  78,
--<constant>
--<name>WINHTTP_OPTION_SERVER_CERT_CONTEXT</name>
--<value>78</value>
--<desc></desc>
--</constant>
  WINHTTP_OPTION_ENABLE_FEATURE                 =  79,
--<constant>
--<name>WINHTTP_OPTION_ENABLE_FEATURE</name>
--<value>79</value>
--<desc></desc>
--</constant>
  WINHTTP_OPTION_WORKER_THREAD_COUNT            =  80,
--<constant>
--<name>WINHTTP_OPTION_WORKER_THREAD_COUNT</name>
--<value>80</value>
--<desc></desc>
--</constant>
  WINHTTP_OPTION_PASSPORT_COBRANDING_TEXT       =  81,
--<constant>
--<name>WINHTTP_OPTION_PASSPORT_COBRANDING_TEXT</name>
--<value>81</value>
--<desc></desc>
--</constant>
  WINHTTP_OPTION_PASSPORT_COBRANDING_URL        =  82,
--<constant>
--<name>WINHTTP_OPTION_PASSPORT_COBRANDING_URL</name>
--<value>82</value>
--<desc></desc>
--</constant>
  WINHTTP_OPTION_CONFIGURE_PASSPORT_AUTH        =  83,
--<constant>
--<name>WINHTTP_OPTION_CONFIGURE_PASSPORT_AUTH</name>
--<value>83</value>
--<desc></desc>
--</constant>
  WINHTTP_OPTION_SECURE_PROTOCOLS               =  84,
--<constant>
--<name>WINHTTP_OPTION_SECURE_PROTOCOLS</name>
--<value>84</value>
--<desc></desc>
--</constant>
  WINHTTP_OPTION_ENABLETRACING                  =  85,
--<constant>
--<name>WINHTTP_OPTION_ENABLETRACING</name>
--<value>85</value>
--<desc></desc>
--</constant>
  WINHTTP_OPTION_PASSPORT_SIGN_OUT              =  86,
--<constant>
--<name>WINHTTP_OPTION_PASSPORT_SIGN_OUT</name>
--<value>86</value>
--<desc></desc>
--</constant>
  WINHTTP_OPTION_PASSPORT_RETURN_URL            =  87,
--<constant>
--<name>WINHTTP_OPTION_PASSPORT_RETURN_URL</name>
--<value>87</value>
--<desc></desc>
--</constant>
  WINHTTP_OPTION_REDIRECT_POLICY                =  88,
--<constant>
--<name>WINHTTP_OPTION_REDIRECT_POLICY</name>
--<value>88</value>
--<desc></desc>
--</constant>
  WINHTTP_OPTION_MAX_HTTP_AUTOMATIC_REDIRECTS   =  89,
--<constant>
--<name>WINHTTP_OPTION_MAX_HTTP_AUTOMATIC_REDIRECTS</name>
--<value>89</value>
--<desc></desc>
--</constant>
  WINHTTP_OPTION_MAX_HTTP_STATUS_CONTINUE       =  90,
--<constant>
--<name>WINHTTP_OPTION_MAX_HTTP_STATUS_CONTINUE</name>
--<value>90</value>
--<desc></desc>
--</constant>
  WINHTTP_OPTION_MAX_RESPONSE_HEADER_SIZE       =  91,
--<constant>
--<name>WINHTTP_OPTION_MAX_RESPONSE_HEADER_SIZE</name>
--<value>91</value>
--<desc></desc>
--</constant>
  WINHTTP_OPTION_MAX_RESPONSE_DRAIN_SIZE        =  92,
--<constant>
--<name>WINHTTP_OPTION_MAX_RESPONSE_DRAIN_SIZE</name>
--<value>92</value>
--<desc></desc>
--</constant>
  WINHTTP_OPTION_CONNECTION_INFO                =  93,
--<constant>
--<name>WINHTTP_OPTION_CONNECTION_INFO</name>
--<value>93</value>
--<desc></desc>
--</constant>
  WINHTTP_OPTION_CLIENT_CERT_ISSUER_LIST        =  94,
--<constant>
--<name>WINHTTP_OPTION_CLIENT_CERT_ISSUER_LIST</name>
--<value>94</value>
--<desc></desc>
--</constant>
  WINHTTP_OPTION_SPN                            =  96,
--<constant>
--<name>WINHTTP_OPTION_SPN</name>
--<value>96</value>
--<desc></desc>
--</constant>
  WINHTTP_OPTION_GLOBAL_PROXY_CREDS             =  97,
--<constant>
--<name>WINHTTP_OPTION_GLOBAL_PROXY_CREDS</name>
--<value>97</value>
--<desc></desc>
--</constant>
  WINHTTP_OPTION_GLOBAL_SERVER_CREDS            =  98,
--<constant>
--<name>WINHTTP_OPTION_GLOBAL_SERVER_CREDS</name>
--<value>98</value>
--<desc></desc>
--</constant>
  WINHTTP_OPTION_UNLOAD_NOTIFY_EVENT            =  99,
--<constant>
--<name>WINHTTP_OPTION_UNLOAD_NOTIFY_EVENT</name>
--<value>99</value>
--<desc></desc>
--</constant>
  WINHTTP_OPTION_REJECT_USERPWD_IN_URL          = 100,
--<constant>
--<name>WINHTTP_OPTION_REJECT_USERPWD_IN_URL</name>
--<value>100</value>
--<desc></desc>
--</constant>
  WINHTTP_OPTION_USE_GLOBAL_SERVER_CREDENTIALS  = 101,
--<constant>
--<name>WINHTTP_OPTION_USE_GLOBAL_SERVER_CREDENTIALS</name>
--<value>101</value>
--<desc></desc>
--</constant>
  WINHTTP_OPTION_RECEIVE_PROXY_CONNECT_RESPONSE = 103,
--<constant>
--<name>WINHTTP_OPTION_RECEIVE_PROXY_CONNECT_RESPONSE</name>
--<value>103</value>
--<desc></desc>
--</constant>
  WINHTTP_OPTION_IS_PROXY_CONNECT_RESPONSE      = 104,
--<constant>
--<name>WINHTTP_OPTION_IS_PROXY_CONNECT_RESPONSE</name>
--<value>104</value>
--<desc></desc>
--</constant>
  WINHTTP_OPTION_SERVER_SPN_USED                = 106,
--<constant>
--<name>WINHTTP_OPTION_SERVER_SPN_USED</name>
--<value>106</value>
--<desc></desc>
--</constant>
  WINHTTP_OPTION_PROXY_SPN_USED                 = 107,
--<constant>
--<name>WINHTTP_OPTION_PROXY_SPN_USED</name>
--<value>107</value>
--<desc></desc>
--</constant>
  WINHTTP_OPTION_SERVER_CBT                     = 108,
--<constant>
--<name>WINHTTP_OPTION_SERVER_CBT</name>
--<value>108</value>
--<desc></desc>
--</constant>
  WINHTTP_OPTION_UNSAFE_HEADER_PARSING          = 110,
--<constant>
--<name>WINHTTP_OPTION_UNSAFE_HEADER_PARSING</name>
--<value>110</value>
--<desc></desc>
--</constant>
  WINHTTP_OPTION_ASSURED_NON_BLOCKING_CALLBACKS = 111,
--<constant>
--<name>WINHTTP_OPTION_ASSURED_NON_BLOCKING_CALLBACKS</name>
--<value>111</value>
--<desc></desc>
--</constant>
  WINHTTP_OPTION_UPGRADE_TO_WEB_SOCKET          = 114,
--<constant>
--<name>WINHTTP_OPTION_UPGRADE_TO_WEB_SOCKET</name>
--<value>114</value>
--<desc></desc>
--</constant>
  WINHTTP_OPTION_WEB_SOCKET_CLOSE_TIMEOUT       = 115,
--<constant>
--<name>WINHTTP_OPTION_WEB_SOCKET_CLOSE_TIMEOUT</name>
--<value>115</value>
--<desc></desc>
--</constant>
  WINHTTP_OPTION_WEB_SOCKET_KEEPALIVE_INTERVAL  = 116,
--<constant>
--<name>WINHTTP_OPTION_WEB_SOCKET_KEEPALIVE_INTERVAL</name>
--<value>116</value>
--<desc></desc>
--</constant>
  WINHTTP_OPTION_DECOMPRESSION                  = 118,
--<constant>
--<name>WINHTTP_OPTION_DECOMPRESSION</name>
--<value>118</value>
--<desc></desc>
--</constant>
  WINHTTP_OPTION_WEB_SOCKET_RECEIVE_BUFFER_SIZE = 122,
--<constant>
--<name>WINHTTP_OPTION_WEB_SOCKET_RECEIVE_BUFFER_SIZE</name>
--<value>122</value>
--<desc></desc>
--</constant>
  WINHTTP_OPTION_WEB_SOCKET_SEND_BUFFER_SIZE    = 123,
--<constant>
--<name>WINHTTP_OPTION_WEB_SOCKET_SEND_BUFFER_SIZE</name>
--<value>123</value>
--<desc></desc>
--</constant>
  WINHTTP_OPTION_CONNECTION_FILTER              = 131,
--<constant>
--<name>WINHTTP_OPTION_CONNECTION_FILTER</name>
--<value>131</value>
--<desc></desc>
--</constant>
  WINHTTP_LAST_OPTION                           = WINHTTP_OPTION_CONNECTION_FILTER,
--<constant>
--<name>WINHTTP_LAST_OPTION</name>
--<value>WINHTTP_OPTION_CONNECTION_FILTER</value>
--<desc></desc>
--</constant>

  WINHTTP_OPTION_USERNAME                      = #1000,
--<constant>
--<name>WINHTTP_OPTION_USERNAME</name>
--<value>#1000</value>
--<desc></desc>
--</constant>
  WINHTTP_OPTION_PASSWORD                      = #1001,
--<constant>
--<name>WINHTTP_OPTION_PASSWORD</name>
--<value>#1001</value>
--<desc></desc>
--</constant>
  WINHTTP_OPTION_PROXY_USERNAME                = #1002,
--<constant>
--<name>WINHTTP_OPTION_PROXY_USERNAME</name>
--<value>#1002</value>
--<desc></desc>
--</constant>
  WINHTTP_OPTION_PROXY_PASSWORD                = #1003
--<constant>
--<name>WINHTTP_OPTION_PROXY_PASSWORD</name>
--<value>#1003</value>
--<desc></desc>
--</constant>

public constant
  WINHTTP_CONNS_PER_SERVER_UNLIMITED    = #FFFFFFFF
--<constant>
--<name>WINHTTP_CONNS_PER_SERVER_UNLIMITED</name>
--<value>#FFFFFFFF</value>
--<desc>manifest value for WINHTTP_OPTION_MAX_CONNS_PER_SERVER and WINHTTP_OPTION_MAX_CONNS_PER_1_0_SERVER</desc>
--</constant>

--
-- Values for WINHTTP_OPTION_DECOMPRESSION
--

public constant
  WINHTTP_DECOMPRESSION_FLAG_GZIP     = #00000001,
--<constant>
--<name>WINHTTP_DECOMPRESSION_FLAG_GZIP</name>
--<value>#00000001</value>
--<desc></desc>
--</constant>
  WINHTTP_DECOMPRESSION_FLAG_DEFLATE  = #00000002
--<constant>
--<name>WINHTTP_DECOMPRESSION_FLAG_DEFLATE</name>
--<value>#00000002</value>
--<desc></desc>
--</constant>

public constant
  WINHTTP_DECOMPRESSION_FLAG_ALL = or_bits(
    WINHTTP_DECOMPRESSION_FLAG_GZIP,
    WINHTTP_DECOMPRESSION_FLAG_DEFLATE)
--<constant>
--<name>WINHTTP_DECOMPRESSION_FLAG_ALL</name>
--<value>or_bits(WINHTTP_DECOMPRESSION_FLAG_GZIP, WINHTTP_DECOMPRESSION_FLAG_DEFLATE)</value>
--<desc></desc>
--</constant>

public constant
  -- values for WINHTTP_OPTION_AUTOLOGON_POLICY
  WINHTTP_AUTOLOGON_SECURITY_LEVEL_MEDIUM   = 0,
  WINHTTP_AUTOLOGON_SECURITY_LEVEL_LOW      = 1,
  WINHTTP_AUTOLOGON_SECURITY_LEVEL_HIGH     = 2,
  WINHTTP_AUTOLOGON_SECURITY_LEVEL_DEFAULT  = WINHTTP_AUTOLOGON_SECURITY_LEVEL_MEDIUM,

  -- values for WINHTTP_OPTION_REDIRECT_POLICY
  WINHTTP_OPTION_REDIRECT_POLICY_NEVER                        = 0,
  WINHTTP_OPTION_REDIRECT_POLICY_DISALLOW_HTTPS_TO_HTTP       = 1,
  WINHTTP_OPTION_REDIRECT_POLICY_ALWAYS                       = 2,

  WINHTTP_OPTION_REDIRECT_POLICY_LAST    = WINHTTP_OPTION_REDIRECT_POLICY_ALWAYS,
  WINHTTP_OPTION_REDIRECT_POLICY_DEFAULT = WINHTTP_OPTION_REDIRECT_POLICY_DISALLOW_HTTPS_TO_HTTP,

  WINHTTP_DISABLE_PASSPORT_AUTH    = #00000000,
  WINHTTP_ENABLE_PASSPORT_AUTH     = #10000000,
  WINHTTP_DISABLE_PASSPORT_KEYRING = #20000000,
  WINHTTP_ENABLE_PASSPORT_KEYRING  = #40000000,

  -- values for WINHTTP_OPTION_DISABLE_FEATURE
  WINHTTP_DISABLE_COOKIES                   = #00000001,
  WINHTTP_DISABLE_REDIRECTS                 = #00000002,
  WINHTTP_DISABLE_AUTHENTICATION            = #00000004,
  WINHTTP_DISABLE_KEEP_ALIVE                = #00000008,

  -- values for WINHTTP_OPTION_ENABLE_FEATURE
  WINHTTP_ENABLE_SSL_REVOCATION             = #00000001,
  WINHTTP_ENABLE_SSL_REVERT_IMPERSONATION   = #00000002,

  -- values for WINHTTP_OPTION_SPN
  WINHTTP_DISABLE_SPN_SERVER_PORT           = #00000000,
  WINHTTP_ENABLE_SPN_SERVER_PORT            = #00000001,
  WINHTTP_OPTION_SPN_MASK                   = WINHTTP_ENABLE_SPN_SERVER_PORT
--<constant>
--<name>WINHTTP_AUTOLOGON_SECURITY_LEVEL_MEDIUM</name>
--<value>0</value>
--<desc></desc>
--</constant>
--<constant>
--<name>WINHTTP_AUTOLOGON_SECURITY_LEVEL_LOW</name>
--<value>1</value>
--<desc></desc>
--</constant>
--<constant>
--<name>WINHTTP_AUTOLOGON_SECURITY_LEVEL_HIGH</name>
--<value>2</value>
--<desc></desc>
--</constant>
--<constant>
--<name>WINHTTP_AUTOLOGON_SECURITY_LEVEL_DEFAULT</name>
--<value>WINHTTP_AUTOLOGON_SECURITY_LEVEL_MEDIUM</value>
--<desc></desc>
--</constant>
--<constant>
--<name>WINHTTP_OPTION_REDIRECT_POLICY_NEVER</name>
--<value>0</value>
--<desc></desc>
--</constant>
--<constant>
--<name>WINHTTP_OPTION_REDIRECT_POLICY_DISALLOW_HTTPS_TO_HTTP</name>
--<value>1</value>
--<desc></desc>
--</constant>
--<constant>
--<name>WINHTTP_OPTION_REDIRECT_POLICY_ALWAYS</name>
--<value>2</value>
--<desc></desc>
--</constant>
--<constant>
--<name>WINHTTP_OPTION_REDIRECT_POLICY_LAST</name>
--<value>WINHTTP_OPTION_REDIRECT_POLICY_ALWAYS</value>
--<desc></desc>
--</constant>
--<constant>
--<name>WINHTTP_OPTION_REDIRECT_POLICY_DEFAULT</name>
--<value>WINHTTP_OPTION_REDIRECT_POLICY_DISALLOW_HTTPS_TO_HTTP</value>
--<desc></desc>
--</constant>
--<constant>
--<name>WINHTTP_DISABLE_PASSPORT_AUTH</name>
--<value>#00000000</value>
--<desc></desc>
--</constant>
--<constant>
--<name>WINHTTP_ENABLE_PASSPORT_AUTH</name>
--<value>#10000000</value>
--<desc></desc>
--</constant>
--<constant>
--<name>WINHTTP_DISABLE_PASSPORT_KEYRING</name>
--<value>#20000000</value>
--<desc></desc>
--</constant>
--<constant>
--<name>WINHTTP_ENABLE_PASSPORT_KEYRING</name>
--<value>#40000000</value>
--<desc></desc>
--</constant>
--<constant>
--<name>WINHTTP_DISABLE_COOKIES</name>
--<value>#00000001</value>
--<desc></desc>
--</constant>
--<constant>
--<name>WINHTTP_DISABLE_REDIRECTS</name>
--<value>#00000002</value>
--<desc></desc>
--</constant>
--<constant>
--<name>WINHTTP_DISABLE_AUTHENTICATION</name>
--<value>#00000004</value>
--<desc></desc>
--</constant>
--<constant>
--<name>WINHTTP_DISABLE_KEEP_ALIVE</name>
--<value>#00000008</value>
--<desc></desc>
--</constant>
--<constant>
--<name>WINHTTP_ENABLE_SSL_REVOCATION</name>
--<value>#00000001</value>
--<desc></desc>
--</constant>
--<constant>
--<name>WINHTTP_ENABLE_SSL_REVERT_IMPERSONATION</name>
--<value>#00000002</value>
--<desc></desc>
--</constant>
--<constant>
--<name>WINHTTP_DISABLE_SPN_SERVER_PORT</name>
--<value>#00000000</value>
--<desc></desc>
--</constant>
--<constant>
--<name>WINHTTP_ENABLE_SPN_SERVER_PORT</name>
--<value>#00000001</value>
--<desc></desc>
--</constant>
--<constant>
--<name>WINHTTP_OPTION_SPN_MASK</name>
--<value>WINHTTP_ENABLE_SPN_SERVER_PORT</value>
--<desc></desc>
--</constant>

-- typedef struct tagWINHTTP_CREDS
-- {
--     LPSTR lpszUserName;
--     LPSTR lpszPassword;
--     LPSTR lpszRealm;
--     dword dwAuthScheme;
--     LPSTR lpszHostName;
--     dword dwPort;
-- } WINHTTP_CREDS, *PWINHTTP_CREDS;

-- structure for WINHTTP_OPTION_GLOBAL_SERVER_CREDS and
-- WINHTTP_OPTION_GLOBAL_PROXY_CREDS
-- typedef struct tagWINHTTP_CREDS_EX
-- {
--     LPSTR lpszUserName;
--     LPSTR lpszPassword;
--     LPSTR lpszRealm;
--     dword dwAuthScheme;
--     LPSTR lpszHostName;
--     dword dwPort;
--     LPSTR lpszUrl;
-- } WINHTTP_CREDS_EX, *PWINHTTP_CREDS_EX;

--
-- winhttp handle types
--
public constant
  WINHTTP_HANDLE_TYPE_SESSION = 1,
  WINHTTP_HANDLE_TYPE_CONNECT = 2,
  WINHTTP_HANDLE_TYPE_REQUEST = 3
--<constant>
--<name>WINHTTP_HANDLE_TYPE_SESSION</name>
--<value>1</value>
--<desc></desc>
--</constant>
--<constant>
--<name>WINHTTP_HANDLE_TYPE_CONNECT</name>
--<value>2</value>
--<desc></desc>
--</constant>
--<constant>
--<name>WINHTTP_HANDLE_TYPE_REQUEST</name>
--<value>3</value>
--<desc></desc>
--</constant>

--
-- values for auth schemes
--
public constant
  WINHTTP_AUTH_SCHEME_BASIC      = #00000001,
  WINHTTP_AUTH_SCHEME_NTLM       = #00000002,
  WINHTTP_AUTH_SCHEME_PASSPORT   = #00000004,
  WINHTTP_AUTH_SCHEME_DIGEST     = #00000008,
  WINHTTP_AUTH_SCHEME_NEGOTIATE  = #00000010
--<constant>
--<name>WINHTTP_AUTH_SCHEME_BASIC</name>
--<value>#00000001</value>
--<desc></desc>
--</constant>
--<constant>
--<name>WINHTTP_AUTH_SCHEME_NTLM</name>
--<value>#00000002</value>
--<desc></desc>
--</constant>
--<constant>
--<name>WINHTTP_AUTH_SCHEME_PASSPORT</name>
--<value>#00000004</value>
--<desc></desc>
--</constant>
--<constant>
--<name>WINHTTP_AUTH_SCHEME_DIGEST</name>
--<value>#00000008</value>
--<desc></desc>
--</constant>
--<constant>
--<name>WINHTTP_AUTH_SCHEME_NEGOTIATE</name>
--<value>#00000010</value>
--<desc></desc>
--</constant>

-- WinHttp supported Authentication Targets
public constant
  WINHTTP_AUTH_TARGET_SERVER = #00000000,
  WINHTTP_AUTH_TARGET_PROXY  = #00000001
--<constant>
--<name>WINHTTP_AUTH_TARGET_SERVER</name>
--<value>#00000000</value>
--<desc></desc>
--</constant>
--<constant>
--<name>WINHTTP_AUTH_TARGET_PROXY</name>
--<value>#00000001</value>
--<desc></desc>
--</constant>

--
-- values for WINHTTP_OPTION_SECURITY_FLAGS
--

-- query only
public constant
  SECURITY_FLAG_SECURE          = #00000001, -- can query only
  SECURITY_FLAG_STRENGTH_WEAK   = #10000000,
  SECURITY_FLAG_STRENGTH_MEDIUM = #40000000,
  SECURITY_FLAG_STRENGTH_STRONG = #20000000
--<constant>
--<name>SECURITY_FLAG_SECURE</name>
--<value>#00000001</value>
--<desc></desc>
--</constant>
--<constant>
--<name>SECURITY_FLAG_STRENGTH_WEAK</name>
--<value>#10000000</value>
--<desc></desc>
--</constant>
--<constant>
--<name>SECURITY_FLAG_STRENGTH_MEDIUM</name>
--<value>#40000000</value>
--<desc></desc>
--</constant>
--<constant>
--<name>SECURITY_FLAG_STRENGTH_STRONG</name>
--<value>#20000000</value>
--<desc></desc>
--</constant>



-- Secure connection error status flags
public constant
  WINHTTP_CALLBACK_STATUS_FLAG_CERT_REV_FAILED         = #00000001,
  WINHTTP_CALLBACK_STATUS_FLAG_INVALID_CERT            = #00000002,
  WINHTTP_CALLBACK_STATUS_FLAG_CERT_REVOKED            = #00000004,
  WINHTTP_CALLBACK_STATUS_FLAG_INVALID_CA              = #00000008,
  WINHTTP_CALLBACK_STATUS_FLAG_CERT_CN_INVALID         = #00000010,
  WINHTTP_CALLBACK_STATUS_FLAG_CERT_DATE_INVALID       = #00000020,
  WINHTTP_CALLBACK_STATUS_FLAG_CERT_WRONG_USAGE        = #00000040,
  WINHTTP_CALLBACK_STATUS_FLAG_SECURITY_CHANNEL_ERROR  = #80000000
--<constant>
--<name>WINHTTP_CALLBACK_STATUS_FLAG_CERT_REV_FAILED</name>
--<value>#00000001</value>
--<desc></desc>
--</constant>
--<constant>
--<name>WINHTTP_CALLBACK_STATUS_FLAG_INVALID_CERT</name>
--<value>#00000002</value>
--<desc></desc>
--</constant>
--<constant>
--<name>WINHTTP_CALLBACK_STATUS_FLAG_CERT_REVOKED</name>
--<value>#00000004</value>
--<desc></desc>
--</constant>
--<constant>
--<name>WINHTTP_CALLBACK_STATUS_FLAG_INVALID_CA</name>
--<value>#00000008</value>
--<desc></desc>
--</constant>
--<constant>
--<name>WINHTTP_CALLBACK_STATUS_FLAG_CERT_CN_INVALID</name>
--<value>#00000010</value>
--<desc></desc>
--</constant>
--<constant>
--<name>WINHTTP_CALLBACK_STATUS_FLAG_CERT_DATE_INVALID</name>
--<value>#00000020</value>
--<desc></desc>
--</constant>
--<constant>
--<name>WINHTTP_CALLBACK_STATUS_FLAG_CERT_WRONG_USAGE</name>
--<value>#00000040</value>
--<desc></desc>
--</constant>
--<constant>
--<name>WINHTTP_CALLBACK_STATUS_FLAG_SECURITY_CHANNEL_ERROR</name>
--<value>#80000000</value>
--<desc></desc>
--</constant>

public constant
  WINHTTP_FLAG_SECURE_PROTOCOL_SSL2   = #00000008,
  WINHTTP_FLAG_SECURE_PROTOCOL_SSL3   = #00000020,
  WINHTTP_FLAG_SECURE_PROTOCOL_TLS1   = #00000080,
  WINHTTP_FLAG_SECURE_PROTOCOL_TLS1_1 = #00000200,
  WINHTTP_FLAG_SECURE_PROTOCOL_TLS1_2 = #00000800
--<constant>
--<name>WINHTTP_FLAG_SECURE_PROTOCOL_SSL2</name>
--<value>#00000008</value>
--<desc></desc>
--</constant>
--<constant>
--<name>WINHTTP_FLAG_SECURE_PROTOCOL_SSL3</name>
--<value>#00000020</value>
--<desc></desc>
--</constant>
--<constant>
--<name>WINHTTP_FLAG_SECURE_PROTOCOL_TLS1</name>
--<value>#00000080</value>
--<desc></desc>
--</constant>
--<constant>
--<name>WINHTTP_FLAG_SECURE_PROTOCOL_TLS1_1</name>
--<value>#00000200</value>
--<desc></desc>
--</constant>
--<constant>
--<name>WINHTTP_FLAG_SECURE_PROTOCOL_TLS1_2</name>
--<value>#00000800</value>
--<desc></desc>
--</constant>

public constant
  WINHTTP_FLAG_SECURE_PROTOCOL_ALL = or_all({WINHTTP_FLAG_SECURE_PROTOCOL_SSL2,
                                             WINHTTP_FLAG_SECURE_PROTOCOL_SSL3,
                                             WINHTTP_FLAG_SECURE_PROTOCOL_TLS1})
--<constant>
--<name>WINHTTP_FLAG_SECURE_PROTOCOL_ALL</name>
--<value>or_all({WINHTTP_FLAG_SECURE_PROTOCOL_SSL2</value>
--<desc></desc>
--</constant>
--<constant>
--<name>WINHTTP_FLAG_SECURE_PROTOCOL_SSL3</name>
--<value>
--</value>
--<desc></desc>
--</constant>
--<constant>
--<name>WINHTTP_FLAG_SECURE_PROTOCOL_TLS1})</name>
--<value>
--</value>
--<desc></desc>
--</constant>

public constant
  WINHTTP_FLAG_SECURE_PROTOCOL_MODERN = or_all({
--<constant>
--<name>WINHTTP_FLAG_SECURE_PROTOCOL_MODERN</name>
--<value>or_all({</value>
--<desc></desc>
--</constant>
       WINHTTP_FLAG_SECURE_PROTOCOL_SSL3,   WINHTTP_FLAG_SECURE_PROTOCOL_TLS1,
       WINHTTP_FLAG_SECURE_PROTOCOL_TLS1_1, WINHTTP_FLAG_SECURE_PROTOCOL_TLS1_2})

--
-- callback function for WinHttpSetStatusCallback
--

-- typedef VOID(CALLBACK * WINHTTP_STATUS_CALLBACK)(
--    IN HINTERNET hInternet,
--    IN DWORD_PTR dwContext,
--    IN dword dwInternetStatus,
--    IN LPVOID lpvStatusInformation OPTIONAL,
--    IN dword dwStatusInformationLength
--    );



--
-- status manifests for WinHttp status callback
--

public constant
  WINHTTP_CALLBACK_STATUS_RESOLVING_NAME          = #00000001,
  WINHTTP_CALLBACK_STATUS_NAME_RESOLVED           = #00000002,
  WINHTTP_CALLBACK_STATUS_CONNECTING_TO_SERVER    = #00000004,
  WINHTTP_CALLBACK_STATUS_CONNECTED_TO_SERVER     = #00000008,
  WINHTTP_CALLBACK_STATUS_SENDING_REQUEST         = #00000010,
  WINHTTP_CALLBACK_STATUS_REQUEST_SENT            = #00000020,
  WINHTTP_CALLBACK_STATUS_RECEIVING_RESPONSE      = #00000040,
  WINHTTP_CALLBACK_STATUS_RESPONSE_RECEIVED       = #00000080,
  WINHTTP_CALLBACK_STATUS_CLOSING_CONNECTION      = #00000100,
  WINHTTP_CALLBACK_STATUS_CONNECTION_CLOSED       = #00000200,
  WINHTTP_CALLBACK_STATUS_HANDLE_CREATED          = #00000400,
  WINHTTP_CALLBACK_STATUS_HANDLE_CLOSING          = #00000800,
  WINHTTP_CALLBACK_STATUS_DETECTING_PROXY         = #00001000,
  WINHTTP_CALLBACK_STATUS_REDIRECT                = #00004000,
  WINHTTP_CALLBACK_STATUS_INTERMEDIATE_RESPONSE   = #00008000,
  WINHTTP_CALLBACK_STATUS_SECURE_FAILURE          = #00010000,
  WINHTTP_CALLBACK_STATUS_HEADERS_AVAILABLE       = #00020000,
  WINHTTP_CALLBACK_STATUS_DATA_AVAILABLE          = #00040000,
  WINHTTP_CALLBACK_STATUS_READ_COMPLETE           = #00080000,
  WINHTTP_CALLBACK_STATUS_WRITE_COMPLETE          = #00100000,
  WINHTTP_CALLBACK_STATUS_REQUEST_ERROR           = #00200000,
  WINHTTP_CALLBACK_STATUS_SENDREQUEST_COMPLETE    = #00400000,
  WINHTTP_CALLBACK_STATUS_GETPROXYFORURL_COMPLETE = #01000000,
  WINHTTP_CALLBACK_STATUS_CLOSE_COMPLETE          = #02000000,
  WINHTTP_CALLBACK_STATUS_SHUTDOWN_COMPLETE       = #04000000
--<constant>
--<name>WINHTTP_CALLBACK_STATUS_RESOLVING_NAME</name>
--<value>#00000001</value>
--<desc></desc>
--</constant>
--<constant>
--<name>WINHTTP_CALLBACK_STATUS_NAME_RESOLVED</name>
--<value>#00000002</value>
--<desc></desc>
--</constant>
--<constant>
--<name>WINHTTP_CALLBACK_STATUS_CONNECTING_TO_SERVER</name>
--<value>#00000004</value>
--<desc></desc>
--</constant>
--<constant>
--<name>WINHTTP_CALLBACK_STATUS_CONNECTED_TO_SERVER</name>
--<value>#00000008</value>
--<desc></desc>
--</constant>
--<constant>
--<name>WINHTTP_CALLBACK_STATUS_SENDING_REQUEST</name>
--<value>#00000010</value>
--<desc></desc>
--</constant>
--<constant>
--<name>WINHTTP_CALLBACK_STATUS_REQUEST_SENT</name>
--<value>#00000020</value>
--<desc></desc>
--</constant>
--<constant>
--<name>WINHTTP_CALLBACK_STATUS_RECEIVING_RESPONSE</name>
--<value>#00000040</value>
--<desc></desc>
--</constant>
--<constant>
--<name>WINHTTP_CALLBACK_STATUS_RESPONSE_RECEIVED</name>
--<value>#00000080</value>
--<desc></desc>
--</constant>
--<constant>
--<name>WINHTTP_CALLBACK_STATUS_CLOSING_CONNECTION</name>
--<value>#00000100</value>
--<desc></desc>
--</constant>
--<constant>
--<name>WINHTTP_CALLBACK_STATUS_CONNECTION_CLOSED</name>
--<value>#00000200</value>
--<desc></desc>
--</constant>
--<constant>
--<name>WINHTTP_CALLBACK_STATUS_HANDLE_CREATED</name>
--<value>#00000400</value>
--<desc></desc>
--</constant>
--<constant>
--<name>WINHTTP_CALLBACK_STATUS_HANDLE_CLOSING</name>
--<value>#00000800</value>
--<desc></desc>
--</constant>
--<constant>
--<name>WINHTTP_CALLBACK_STATUS_DETECTING_PROXY</name>
--<value>#00001000</value>
--<desc></desc>
--</constant>
--<constant>
--<name>WINHTTP_CALLBACK_STATUS_REDIRECT</name>
--<value>#00004000</value>
--<desc></desc>
--</constant>
--<constant>
--<name>WINHTTP_CALLBACK_STATUS_INTERMEDIATE_RESPONSE</name>
--<value>#00008000</value>
--<desc></desc>
--</constant>
--<constant>
--<name>WINHTTP_CALLBACK_STATUS_SECURE_FAILURE</name>
--<value>#00010000</value>
--<desc></desc>
--</constant>
--<constant>
--<name>WINHTTP_CALLBACK_STATUS_HEADERS_AVAILABLE</name>
--<value>#00020000</value>
--<desc></desc>
--</constant>
--<constant>
--<name>WINHTTP_CALLBACK_STATUS_DATA_AVAILABLE</name>
--<value>#00040000</value>
--<desc></desc>
--</constant>
--<constant>
--<name>WINHTTP_CALLBACK_STATUS_READ_COMPLETE</name>
--<value>#00080000</value>
--<desc></desc>
--</constant>
--<constant>
--<name>WINHTTP_CALLBACK_STATUS_WRITE_COMPLETE</name>
--<value>#00100000</value>
--<desc></desc>
--</constant>
--<constant>
--<name>WINHTTP_CALLBACK_STATUS_REQUEST_ERROR</name>
--<value>#00200000</value>
--<desc></desc>
--</constant>
--<constant>
--<name>WINHTTP_CALLBACK_STATUS_SENDREQUEST_COMPLETE</name>
--<value>#00400000</value>
--<desc></desc>
--</constant>
--<constant>
--<name>WINHTTP_CALLBACK_STATUS_GETPROXYFORURL_COMPLETE</name>
--<value>#01000000</value>
--<desc></desc>
--</constant>
--<constant>
--<name>WINHTTP_CALLBACK_STATUS_CLOSE_COMPLETE</name>
--<value>#02000000</value>
--<desc></desc>
--</constant>
--<constant>
--<name>WINHTTP_CALLBACK_STATUS_SHUTDOWN_COMPLETE</name>
--<value>#04000000</value>
--<desc></desc>
--</constant>

-- API Enums for WINHTTP_CALLBACK_STATUS_REQUEST_ERROR:
public constant
  API_RECEIVE_RESPONSE     = 1,
  API_QUERY_DATA_AVAILABLE = 2,
  API_READ_DATA            = 3,
  API_WRITE_DATA           = 4,
  API_SEND_REQUEST         = 5,
  API_GET_PROXY_FOR_URL    = 6
--<constant>
--<name>API_RECEIVE_RESPONSE</name>
--<value>1</value>
--<desc></desc>
--</constant>
--<constant>
--<name>API_QUERY_DATA_AVAILABLE</name>
--<value>2</value>
--<desc></desc>
--</constant>
--<constant>
--<name>API_READ_DATA</name>
--<value>3</value>
--<desc></desc>
--</constant>
--<constant>
--<name>API_WRITE_DATA</name>
--<value>4</value>
--<desc></desc>
--</constant>
--<constant>
--<name>API_SEND_REQUEST</name>
--<value>5</value>
--<desc></desc>
--</constant>
--<constant>
--<name>API_GET_PROXY_FOR_URL</name>
--<value>6</value>
--<desc></desc>
--</constant>

public constant
  WINHTTP_CALLBACK_FLAG_RESOLVE_NAME      = or_bits(WINHTTP_CALLBACK_STATUS_RESOLVING_NAME,
                                                    WINHTTP_CALLBACK_STATUS_NAME_RESOLVED),
  WINHTTP_CALLBACK_FLAG_CONNECT_TO_SERVER = or_bits(WINHTTP_CALLBACK_STATUS_CONNECTING_TO_SERVER,
                                                    WINHTTP_CALLBACK_STATUS_CONNECTED_TO_SERVER),
  WINHTTP_CALLBACK_FLAG_SEND_REQUEST      = or_bits(WINHTTP_CALLBACK_STATUS_SENDING_REQUEST,
                                                    WINHTTP_CALLBACK_STATUS_REQUEST_SENT),
  WINHTTP_CALLBACK_FLAG_RECEIVE_RESPONSE  = or_bits(WINHTTP_CALLBACK_STATUS_RECEIVING_RESPONSE,
                                                    WINHTTP_CALLBACK_STATUS_RESPONSE_RECEIVED),
  WINHTTP_CALLBACK_FLAG_CLOSE_CONNECTION  = or_bits(WINHTTP_CALLBACK_STATUS_CLOSING_CONNECTION,
                                                    WINHTTP_CALLBACK_STATUS_CONNECTION_CLOSED),
  WINHTTP_CALLBACK_FLAG_HANDLES           = or_bits(WINHTTP_CALLBACK_STATUS_HANDLE_CREATED,
                                                    WINHTTP_CALLBACK_STATUS_HANDLE_CLOSING)
--<constant>
--<name>WINHTTP_CALLBACK_FLAG_RESOLVE_NAME</name>
--<value>or_bits(WINHTTP_CALLBACK_STATUS_RESOLVING_NAME</value>
--<desc></desc>
--</constant>
--<constant>
--<name>WINHTTP_CALLBACK_STATUS_NAME_RESOLVED)</name>
--<value>
--</value>
--<desc></desc>
--</constant>
--<constant>
--<name>WINHTTP_CALLBACK_FLAG_CONNECT_TO_SERVER</name>
--<value>or_bits(WINHTTP_CALLBACK_STATUS_CONNECTING_TO_SERVER</value>
--<desc></desc>
--</constant>
--<constant>
--<name>WINHTTP_CALLBACK_STATUS_CONNECTED_TO_SERVER)</name>
--<value>
--</value>
--<desc></desc>
--</constant>
--<constant>
--<name>WINHTTP_CALLBACK_FLAG_SEND_REQUEST</name>
--<value>or_bits(WINHTTP_CALLBACK_STATUS_SENDING_REQUEST</value>
--<desc></desc>
--</constant>
--<constant>
--<name>WINHTTP_CALLBACK_STATUS_REQUEST_SENT)</name>
--<value>
--</value>
--<desc></desc>
--</constant>
--<constant>
--<name>WINHTTP_CALLBACK_FLAG_RECEIVE_RESPONSE</name>
--<value>or_bits(WINHTTP_CALLBACK_STATUS_RECEIVING_RESPONSE</value>
--<desc></desc>
--</constant>
--<constant>
--<name>WINHTTP_CALLBACK_STATUS_RESPONSE_RECEIVED)</name>
--<value>
--</value>
--<desc></desc>
--</constant>
--<constant>
--<name>WINHTTP_CALLBACK_FLAG_CLOSE_CONNECTION</name>
--<value>or_bits(WINHTTP_CALLBACK_STATUS_CLOSING_CONNECTION</value>
--<desc></desc>
--</constant>
--<constant>
--<name>WINHTTP_CALLBACK_STATUS_CONNECTION_CLOSED)</name>
--<value>
--</value>
--<desc></desc>
--</constant>
--<constant>
--<name>WINHTTP_CALLBACK_FLAG_HANDLES</name>
--<value>or_bits(WINHTTP_CALLBACK_STATUS_HANDLE_CREATED</value>
--<desc></desc>
--</constant>
--<constant>
--<name>WINHTTP_CALLBACK_STATUS_HANDLE_CLOSING)</name>
--<value>
--</value>
--<desc></desc>
--</constant>

public constant
  WINHTTP_CALLBACK_FLAG_DETECTING_PROXY         = WINHTTP_CALLBACK_STATUS_DETECTING_PROXY,
  WINHTTP_CALLBACK_FLAG_REDIRECT                = WINHTTP_CALLBACK_STATUS_REDIRECT,
  WINHTTP_CALLBACK_FLAG_INTERMEDIATE_RESPONSE   = WINHTTP_CALLBACK_STATUS_INTERMEDIATE_RESPONSE,
  WINHTTP_CALLBACK_FLAG_SECURE_FAILURE          = WINHTTP_CALLBACK_STATUS_SECURE_FAILURE,
  WINHTTP_CALLBACK_FLAG_SENDREQUEST_COMPLETE    = WINHTTP_CALLBACK_STATUS_SENDREQUEST_COMPLETE,
  WINHTTP_CALLBACK_FLAG_HEADERS_AVAILABLE       = WINHTTP_CALLBACK_STATUS_HEADERS_AVAILABLE,
  WINHTTP_CALLBACK_FLAG_DATA_AVAILABLE          = WINHTTP_CALLBACK_STATUS_DATA_AVAILABLE,
  WINHTTP_CALLBACK_FLAG_READ_COMPLETE           = WINHTTP_CALLBACK_STATUS_READ_COMPLETE,
  WINHTTP_CALLBACK_FLAG_WRITE_COMPLETE          = WINHTTP_CALLBACK_STATUS_WRITE_COMPLETE,
  WINHTTP_CALLBACK_FLAG_REQUEST_ERROR           = WINHTTP_CALLBACK_STATUS_REQUEST_ERROR,
  WINHTTP_CALLBACK_FLAG_GETPROXYFORURL_COMPLETE = WINHTTP_CALLBACK_STATUS_GETPROXYFORURL_COMPLETE
--<constant>
--<name>WINHTTP_CALLBACK_FLAG_DETECTING_PROXY</name>
--<value>WINHTTP_CALLBACK_STATUS_DETECTING_PROXY</value>
--<desc></desc>
--</constant>
--<constant>
--<name>WINHTTP_CALLBACK_FLAG_REDIRECT</name>
--<value>WINHTTP_CALLBACK_STATUS_REDIRECT</value>
--<desc></desc>
--</constant>
--<constant>
--<name>WINHTTP_CALLBACK_FLAG_INTERMEDIATE_RESPONSE</name>
--<value>WINHTTP_CALLBACK_STATUS_INTERMEDIATE_RESPONSE</value>
--<desc></desc>
--</constant>
--<constant>
--<name>WINHTTP_CALLBACK_FLAG_SECURE_FAILURE</name>
--<value>WINHTTP_CALLBACK_STATUS_SECURE_FAILURE</value>
--<desc></desc>
--</constant>
--<constant>
--<name>WINHTTP_CALLBACK_FLAG_SENDREQUEST_COMPLETE</name>
--<value>WINHTTP_CALLBACK_STATUS_SENDREQUEST_COMPLETE</value>
--<desc></desc>
--</constant>
--<constant>
--<name>WINHTTP_CALLBACK_FLAG_HEADERS_AVAILABLE</name>
--<value>WINHTTP_CALLBACK_STATUS_HEADERS_AVAILABLE</value>
--<desc></desc>
--</constant>
--<constant>
--<name>WINHTTP_CALLBACK_FLAG_DATA_AVAILABLE</name>
--<value>WINHTTP_CALLBACK_STATUS_DATA_AVAILABLE</value>
--<desc></desc>
--</constant>
--<constant>
--<name>WINHTTP_CALLBACK_FLAG_READ_COMPLETE</name>
--<value>WINHTTP_CALLBACK_STATUS_READ_COMPLETE</value>
--<desc></desc>
--</constant>
--<constant>
--<name>WINHTTP_CALLBACK_FLAG_WRITE_COMPLETE</name>
--<value>WINHTTP_CALLBACK_STATUS_WRITE_COMPLETE</value>
--<desc></desc>
--</constant>
--<constant>
--<name>WINHTTP_CALLBACK_FLAG_REQUEST_ERROR</name>
--<value>WINHTTP_CALLBACK_STATUS_REQUEST_ERROR</value>
--<desc></desc>
--</constant>
--<constant>
--<name>WINHTTP_CALLBACK_FLAG_GETPROXYFORURL_COMPLETE</name>
--<value>WINHTTP_CALLBACK_STATUS_GETPROXYFORURL_COMPLETE</value>
--<desc></desc>
--</constant>

public constant
  WINHTTP_CALLBACK_FLAG_ALL_COMPLETIONS = or_all({WINHTTP_CALLBACK_STATUS_SENDREQUEST_COMPLETE,
                                                  WINHTTP_CALLBACK_STATUS_HEADERS_AVAILABLE,
                                                  WINHTTP_CALLBACK_STATUS_DATA_AVAILABLE,
                                                  WINHTTP_CALLBACK_STATUS_READ_COMPLETE,
                                                  WINHTTP_CALLBACK_STATUS_WRITE_COMPLETE,
                                                  WINHTTP_CALLBACK_STATUS_REQUEST_ERROR,
                                                  WINHTTP_CALLBACK_STATUS_GETPROXYFORURL_COMPLETE})
--<constant>
--<name>WINHTTP_CALLBACK_FLAG_ALL_COMPLETIONS</name>
--<value>or_all({WINHTTP_CALLBACK_STATUS_SENDREQUEST_COMPLETE</value>
--<desc></desc>
--</constant>
--<constant>
--<name>WINHTTP_CALLBACK_STATUS_HEADERS_AVAILABLE</name>
--<value>
--</value>
--<desc></desc>
--</constant>
--<constant>
--<name>WINHTTP_CALLBACK_STATUS_DATA_AVAILABLE</name>
--<value>
--</value>
--<desc></desc>
--</constant>
--<constant>
--<name>WINHTTP_CALLBACK_STATUS_READ_COMPLETE</name>
--<value>
--</value>
--<desc></desc>
--</constant>
--<constant>
--<name>WINHTTP_CALLBACK_STATUS_WRITE_COMPLETE</name>
--<value>
--</value>
--<desc></desc>
--</constant>
--<constant>
--<name>WINHTTP_CALLBACK_STATUS_REQUEST_ERROR</name>
--<value>
--</value>
--<desc></desc>
--</constant>
--<constant>
--<name>WINHTTP_CALLBACK_STATUS_GETPROXYFORURL_COMPLETE})</name>
--<value>
--</value>
--<desc></desc>
--</constant>

public constant
  WINHTTP_CALLBACK_FLAG_ALL_NOTIFICATIONS = #FFFFFFFF
--<constant>
--<name>WINHTTP_CALLBACK_FLAG_ALL_NOTIFICATIONS</name>
--<value>#FFFFFFFF</value>
--<desc></desc>
--</constant>

--
-- if the following value is returned by WinHttpSetStatusCallback, then
-- probably an invalid (non-code) address was supplied for the callback
--
public constant
  -- WINHTTP_INVALID_STATUS_CALLBACK = #FFFFFFFF
  WINHTTP_INVALID_STATUS_CALLBACK = -1
--<constant>
--<name>WINHTTP_INVALID_STATUS_CALLBACK</name>
--<value>-1</value>
--<desc></desc>
--</constant>

-- type
--  WINHTTP_STATUS_CALLBACK = procedure(hInternet: HINTERNET dwContext: PDWORD
--    dwInternetStatus: dword lpvStatusInformation: pointer dwStatusInformationLength: dword) stdcall
--  PWINHTTP_STATUS_CALLBACK = ^WINHTTP_STATUS_CALLBACK

--
-- WinHttpQueryHeaders info levels. Generally, there is one info level
-- for each potential RFC822/HTTP/MIME header that an HTTP server
-- may send as part of a request response.
--
-- The WINHTTP_QUERY_RAW_HEADERS info level is provided for clients
-- that choose to perform their own header parsing.
--

public constant
  WINHTTP_QUERY_MIME_VERSION                 =  0,
  WINHTTP_QUERY_CONTENT_TYPE                 =  1,
  WINHTTP_QUERY_CONTENT_TRANSFER_ENCODING    =  2,
  WINHTTP_QUERY_CONTENT_ID                   =  3,
  WINHTTP_QUERY_CONTENT_DESCRIPTION          =  4,
  WINHTTP_QUERY_CONTENT_LENGTH               =  5,
  WINHTTP_QUERY_CONTENT_LANGUAGE             =  6,
  WINHTTP_QUERY_ALLOW                        =  7,
  WINHTTP_QUERY_PUBLIC                       =  8,
  WINHTTP_QUERY_DATE                         =  9,
  WINHTTP_QUERY_EXPIRES                      = 10,
  WINHTTP_QUERY_LAST_MODIFIED                = 11,
  WINHTTP_QUERY_MESSAGE_ID                   = 12,
  WINHTTP_QUERY_URI                          = 13,
  WINHTTP_QUERY_DERIVED_FROM                 = 14,
  WINHTTP_QUERY_COST                         = 15,
  WINHTTP_QUERY_LINK                         = 16,
  WINHTTP_QUERY_PRAGMA                       = 17,
  WINHTTP_QUERY_VERSION                      = 18,  -- special: part of status line
  WINHTTP_QUERY_STATUS_CODE                  = 19,  -- special: part of status line
  WINHTTP_QUERY_STATUS_TEXT                  = 20,  -- special: part of status line
  WINHTTP_QUERY_RAW_HEADERS                  = 21,  -- special: all headers as ASCIIZ
  WINHTTP_QUERY_RAW_HEADERS_CRLF             = 22,  -- special: all headers
  WINHTTP_QUERY_CONNECTION                   = 23,
  WINHTTP_QUERY_ACCEPT                       = 24,
  WINHTTP_QUERY_ACCEPT_CHARSET               = 25,
  WINHTTP_QUERY_ACCEPT_ENCODING              = 26,
  WINHTTP_QUERY_ACCEPT_LANGUAGE              = 27,
  WINHTTP_QUERY_AUTHORIZATION                = 28,
  WINHTTP_QUERY_CONTENT_ENCODING             = 29,
  WINHTTP_QUERY_FORWARDED                    = 30,
  WINHTTP_QUERY_FROM                         = 31,
  WINHTTP_QUERY_IF_MODIFIED_SINCE            = 32,
  WINHTTP_QUERY_LOCATION                     = 33,
  WINHTTP_QUERY_ORIG_URI                     = 34,
  WINHTTP_QUERY_REFERER                      = 35,
  WINHTTP_QUERY_RETRY_AFTER                  = 36,
  WINHTTP_QUERY_SERVER                       = 37,
  WINHTTP_QUERY_TITLE                        = 38,
  WINHTTP_QUERY_USER_AGENT                   = 39,
  WINHTTP_QUERY_WWW_AUTHENTICATE             = 40,
  WINHTTP_QUERY_PROXY_AUTHENTICATE           = 41,
  WINHTTP_QUERY_ACCEPT_RANGES                = 42,
  WINHTTP_QUERY_SET_COOKIE                   = 43,
  WINHTTP_QUERY_COOKIE                       = 44,
  WINHTTP_QUERY_REQUEST_METHOD               = 45,  -- special: GET/POST etc.
  WINHTTP_QUERY_REFRESH                      = 46,
  WINHTTP_QUERY_CONTENT_DISPOSITION          = 47,

-- HTTP 1.1 defined headers
  WINHTTP_QUERY_AGE                          = 48,
  WINHTTP_QUERY_CACHE_CONTROL                = 49,
  WINHTTP_QUERY_CONTENT_BASE                 = 50,
  WINHTTP_QUERY_CONTENT_LOCATION             = 51,
  WINHTTP_QUERY_CONTENT_MD5                  = 52,
  WINHTTP_QUERY_CONTENT_RANGE                = 53,
  WINHTTP_QUERY_ETAG                         = 54,
  WINHTTP_QUERY_HOST                         = 55,
  WINHTTP_QUERY_IF_MATCH                     = 56,
  WINHTTP_QUERY_IF_NONE_MATCH                = 57,
  WINHTTP_QUERY_IF_RANGE                     = 58,
  WINHTTP_QUERY_IF_UNMODIFIED_SINCE          = 59,
  WINHTTP_QUERY_MAX_FORWARDS                 = 60,
  WINHTTP_QUERY_PROXY_AUTHORIZATION          = 61,
  WINHTTP_QUERY_RANGE                        = 62,
  WINHTTP_QUERY_TRANSFER_ENCODING            = 63,
  WINHTTP_QUERY_UPGRADE                      = 64,
  WINHTTP_QUERY_VARY                         = 65,
  WINHTTP_QUERY_VIA                          = 66,
  WINHTTP_QUERY_WARNING                      = 67,
  WINHTTP_QUERY_EXPECT                       = 68,
  WINHTTP_QUERY_PROXY_CONNECTION             = 69,
  WINHTTP_QUERY_UNLESS_MODIFIED_SINCE        = 70,
  WINHTTP_QUERY_PROXY_SUPPORT                = 75,
  WINHTTP_QUERY_AUTHENTICATION_INFO          = 76,
  WINHTTP_QUERY_PASSPORT_URLS                = 77,
  WINHTTP_QUERY_PASSPORT_CONFIG              = 78,
  WINHTTP_QUERY_MAX                          = 78,

  -- WINHTTP_QUERY_CUSTOM - if this special value is supplied as the dwInfoLevel
  -- parameter of WinHttpQueryHeaders() then the lpBuffer parameter contains the
  -- name of the header we are to query
  WINHTTP_QUERY_CUSTOM                       = 65535
--<constant>
--<name>WINHTTP_QUERY_MIME_VERSION</name>
--<value>0</value>
--<desc></desc>
--</constant>
--<constant>
--<name>WINHTTP_QUERY_CONTENT_TYPE</name>
--<value>1</value>
--<desc></desc>
--</constant>
--<constant>
--<name>WINHTTP_QUERY_CONTENT_TRANSFER_ENCODING</name>
--<value>2</value>
--<desc></desc>
--</constant>
--<constant>
--<name>WINHTTP_QUERY_CONTENT_ID</name>
--<value>3</value>
--<desc></desc>
--</constant>
--<constant>
--<name>WINHTTP_QUERY_CONTENT_DESCRIPTION</name>
--<value>4</value>
--<desc></desc>
--</constant>
--<constant>
--<name>WINHTTP_QUERY_CONTENT_LENGTH</name>
--<value>5</value>
--<desc></desc>
--</constant>
--<constant>
--<name>WINHTTP_QUERY_CONTENT_LANGUAGE</name>
--<value>6</value>
--<desc></desc>
--</constant>
--<constant>
--<name>WINHTTP_QUERY_ALLOW</name>
--<value>7</value>
--<desc></desc>
--</constant>
--<constant>
--<name>WINHTTP_QUERY_PUBLIC</name>
--<value>8</value>
--<desc></desc>
--</constant>
--<constant>
--<name>WINHTTP_QUERY_DATE</name>
--<value>9</value>
--<desc></desc>
--</constant>
--<constant>
--<name>WINHTTP_QUERY_EXPIRES</name>
--<value>10</value>
--<desc></desc>
--</constant>
--<constant>
--<name>WINHTTP_QUERY_LAST_MODIFIED</name>
--<value>11</value>
--<desc></desc>
--</constant>
--<constant>
--<name>WINHTTP_QUERY_MESSAGE_ID</name>
--<value>12</value>
--<desc></desc>
--</constant>
--<constant>
--<name>WINHTTP_QUERY_URI</name>
--<value>13</value>
--<desc></desc>
--</constant>
--<constant>
--<name>WINHTTP_QUERY_DERIVED_FROM</name>
--<value>14</value>
--<desc></desc>
--</constant>
--<constant>
--<name>WINHTTP_QUERY_COST</name>
--<value>15</value>
--<desc></desc>
--</constant>
--<constant>
--<name>WINHTTP_QUERY_LINK</name>
--<value>16</value>
--<desc></desc>
--</constant>
--<constant>
--<name>WINHTTP_QUERY_PRAGMA</name>
--<value>17</value>
--<desc></desc>
--</constant>
--<constant>
--<name>WINHTTP_QUERY_VERSION</name>
--<value>18</value>
--<desc></desc>
--</constant>
--<constant>
--<name>WINHTTP_QUERY_STATUS_CODE</name>
--<value>19</value>
--<desc></desc>
--</constant>
--<constant>
--<name>WINHTTP_QUERY_STATUS_TEXT</name>
--<value>20</value>
--<desc></desc>
--</constant>
--<constant>
--<name>WINHTTP_QUERY_RAW_HEADERS</name>
--<value>21</value>
--<desc></desc>
--</constant>
--<constant>
--<name>WINHTTP_QUERY_RAW_HEADERS_CRLF</name>
--<value>22</value>
--<desc></desc>
--</constant>
--<constant>
--<name>WINHTTP_QUERY_CONNECTION</name>
--<value>23</value>
--<desc></desc>
--</constant>
--<constant>
--<name>WINHTTP_QUERY_ACCEPT</name>
--<value>24</value>
--<desc></desc>
--</constant>
--<constant>
--<name>WINHTTP_QUERY_ACCEPT_CHARSET</name>
--<value>25</value>
--<desc></desc>
--</constant>
--<constant>
--<name>WINHTTP_QUERY_ACCEPT_ENCODING</name>
--<value>26</value>
--<desc></desc>
--</constant>
--<constant>
--<name>WINHTTP_QUERY_ACCEPT_LANGUAGE</name>
--<value>27</value>
--<desc></desc>
--</constant>
--<constant>
--<name>WINHTTP_QUERY_AUTHORIZATION</name>
--<value>28</value>
--<desc></desc>
--</constant>
--<constant>
--<name>WINHTTP_QUERY_CONTENT_ENCODING</name>
--<value>29</value>
--<desc></desc>
--</constant>
--<constant>
--<name>WINHTTP_QUERY_FORWARDED</name>
--<value>30</value>
--<desc></desc>
--</constant>
--<constant>
--<name>WINHTTP_QUERY_FROM</name>
--<value>31</value>
--<desc></desc>
--</constant>
--<constant>
--<name>WINHTTP_QUERY_IF_MODIFIED_SINCE</name>
--<value>32</value>
--<desc></desc>
--</constant>
--<constant>
--<name>WINHTTP_QUERY_LOCATION</name>
--<value>33</value>
--<desc></desc>
--</constant>
--<constant>
--<name>WINHTTP_QUERY_ORIG_URI</name>
--<value>34</value>
--<desc></desc>
--</constant>
--<constant>
--<name>WINHTTP_QUERY_REFERER</name>
--<value>35</value>
--<desc></desc>
--</constant>
--<constant>
--<name>WINHTTP_QUERY_RETRY_AFTER</name>
--<value>36</value>
--<desc></desc>
--</constant>
--<constant>
--<name>WINHTTP_QUERY_SERVER</name>
--<value>37</value>
--<desc></desc>
--</constant>
--<constant>
--<name>WINHTTP_QUERY_TITLE</name>
--<value>38</value>
--<desc></desc>
--</constant>
--<constant>
--<name>WINHTTP_QUERY_USER_AGENT</name>
--<value>39</value>
--<desc></desc>
--</constant>
--<constant>
--<name>WINHTTP_QUERY_WWW_AUTHENTICATE</name>
--<value>40</value>
--<desc></desc>
--</constant>
--<constant>
--<name>WINHTTP_QUERY_PROXY_AUTHENTICATE</name>
--<value>41</value>
--<desc></desc>
--</constant>
--<constant>
--<name>WINHTTP_QUERY_ACCEPT_RANGES</name>
--<value>42</value>
--<desc></desc>
--</constant>
--<constant>
--<name>WINHTTP_QUERY_SET_COOKIE</name>
--<value>43</value>
--<desc></desc>
--</constant>
--<constant>
--<name>WINHTTP_QUERY_COOKIE</name>
--<value>44</value>
--<desc></desc>
--</constant>
--<constant>
--<name>WINHTTP_QUERY_REQUEST_METHOD</name>
--<value>45</value>
--<desc></desc>
--</constant>
--<constant>
--<name>WINHTTP_QUERY_REFRESH</name>
--<value>46</value>
--<desc></desc>
--</constant>
--<constant>
--<name>WINHTTP_QUERY_CONTENT_DISPOSITION</name>
--<value>47</value>
--<desc></desc>
--</constant>
--<constant>
--<name>WINHTTP_QUERY_AGE</name>
--<value>48</value>
--<desc></desc>
--</constant>
--<constant>
--<name>WINHTTP_QUERY_CACHE_CONTROL</name>
--<value>49</value>
--<desc></desc>
--</constant>
--<constant>
--<name>WINHTTP_QUERY_CONTENT_BASE</name>
--<value>50</value>
--<desc></desc>
--</constant>
--<constant>
--<name>WINHTTP_QUERY_CONTENT_LOCATION</name>
--<value>51</value>
--<desc></desc>
--</constant>
--<constant>
--<name>WINHTTP_QUERY_CONTENT_MD5</name>
--<value>52</value>
--<desc></desc>
--</constant>
--<constant>
--<name>WINHTTP_QUERY_CONTENT_RANGE</name>
--<value>53</value>
--<desc></desc>
--</constant>
--<constant>
--<name>WINHTTP_QUERY_ETAG</name>
--<value>54</value>
--<desc></desc>
--</constant>
--<constant>
--<name>WINHTTP_QUERY_HOST</name>
--<value>55</value>
--<desc></desc>
--</constant>
--<constant>
--<name>WINHTTP_QUERY_IF_MATCH</name>
--<value>56</value>
--<desc></desc>
--</constant>
--<constant>
--<name>WINHTTP_QUERY_IF_NONE_MATCH</name>
--<value>57</value>
--<desc></desc>
--</constant>
--<constant>
--<name>WINHTTP_QUERY_IF_RANGE</name>
--<value>58</value>
--<desc></desc>
--</constant>
--<constant>
--<name>WINHTTP_QUERY_IF_UNMODIFIED_SINCE</name>
--<value>59</value>
--<desc></desc>
--</constant>
--<constant>
--<name>WINHTTP_QUERY_MAX_FORWARDS</name>
--<value>60</value>
--<desc></desc>
--</constant>
--<constant>
--<name>WINHTTP_QUERY_PROXY_AUTHORIZATION</name>
--<value>61</value>
--<desc></desc>
--</constant>
--<constant>
--<name>WINHTTP_QUERY_RANGE</name>
--<value>62</value>
--<desc></desc>
--</constant>
--<constant>
--<name>WINHTTP_QUERY_TRANSFER_ENCODING</name>
--<value>63</value>
--<desc></desc>
--</constant>
--<constant>
--<name>WINHTTP_QUERY_UPGRADE</name>
--<value>64</value>
--<desc></desc>
--</constant>
--<constant>
--<name>WINHTTP_QUERY_VARY</name>
--<value>65</value>
--<desc></desc>
--</constant>
--<constant>
--<name>WINHTTP_QUERY_VIA</name>
--<value>66</value>
--<desc></desc>
--</constant>
--<constant>
--<name>WINHTTP_QUERY_WARNING</name>
--<value>67</value>
--<desc></desc>
--</constant>
--<constant>
--<name>WINHTTP_QUERY_EXPECT</name>
--<value>68</value>
--<desc></desc>
--</constant>
--<constant>
--<name>WINHTTP_QUERY_PROXY_CONNECTION</name>
--<value>69</value>
--<desc></desc>
--</constant>
--<constant>
--<name>WINHTTP_QUERY_UNLESS_MODIFIED_SINCE</name>
--<value>70</value>
--<desc></desc>
--</constant>
--<constant>
--<name>WINHTTP_QUERY_PROXY_SUPPORT</name>
--<value>75</value>
--<desc></desc>
--</constant>
--<constant>
--<name>WINHTTP_QUERY_AUTHENTICATION_INFO</name>
--<value>76</value>
--<desc></desc>
--</constant>
--<constant>
--<name>WINHTTP_QUERY_PASSPORT_URLS</name>
--<value>77</value>
--<desc></desc>
--</constant>
--<constant>
--<name>WINHTTP_QUERY_PASSPORT_CONFIG</name>
--<value>78</value>
--<desc></desc>
--</constant>
--<constant>
--<name>WINHTTP_QUERY_MAX</name>
--<value>78</value>
--<desc></desc>
--</constant>
--<constant>
--<name>WINHTTP_QUERY_CUSTOM</name>
--<value>65535</value>
--<desc></desc>
--</constant>

public constant
  -- WINHTTP_QUERY_FLAG_REQUEST_HEADERS - if this bit is set in the dwInfoLevel
  -- parameter of WinHttpQueryHeaders() then the request headers will be queried
  -- for the request information
  WINHTTP_QUERY_FLAG_REQUEST_HEADERS         = #80000000,

  -- WINHTTP_QUERY_FLAG_SYSTEMTIME - if this bit is set in the dwInfoLevel
  -- parameter of WinHttpQueryHeaders() AND the header being queried contains
  -- date information, e.g. the "Expires:" header then lpBuffer will contain a
  -- SYSTEMTIME structure containing the date and time information converted
  --  from the header string
  WINHTTP_QUERY_FLAG_SYSTEMTIME              = #40000000,

  -- WINHTTP_QUERY_FLAG_NUMBER - if this bit is set in the dwInfoLevel parameter
  -- of HttpQueryHeader(), then the value of the header will be converted to a
  -- number before being returned to the caller, if applicable
  WINHTTP_QUERY_FLAG_NUMBER                  = #20000000
--<constant>
--<name>WINHTTP_QUERY_FLAG_REQUEST_HEADERS</name>
--<value>#80000000</value>
--<desc></desc>
--</constant>
--<constant>
--<name>WINHTTP_QUERY_FLAG_SYSTEMTIME</name>
--<value>#40000000</value>
--<desc></desc>
--</constant>
--<constant>
--<name>WINHTTP_QUERY_FLAG_NUMBER</name>
--<value>#20000000</value>
--<desc></desc>
--</constant>

--
-- HTTP Response Status Codes:
--
public constant
  HTTP_STATUS_CONTINUE            = 100,  -- OK to continue with request
  HTTP_STATUS_SWITCH_PROTOCOLS    = 101,  -- server has switched protocols in upgrade header

  HTTP_STATUS_OK                  = 200,  -- request completed
  HTTP_STATUS_CREATED             = 201,  -- object created, reason = new URI
  HTTP_STATUS_ACCEPTED            = 202,  -- async completion (TBS)
  HTTP_STATUS_PARTIAL             = 203,  -- partial completion
  HTTP_STATUS_NO_CONTENT          = 204,  -- no info to return
  HTTP_STATUS_RESET_CONTENT       = 205,  -- request completed, but clear form
  HTTP_STATUS_PARTIAL_CONTENT     = 206,  -- partial GET fulfilled
  HTTP_STATUS_WEBDAV_MULTI_STATUS = 207,  -- WebDAV Multi-Status

  HTTP_STATUS_AMBIGUOUS           = 300,  -- server couldn't decide what to return
  HTTP_STATUS_MOVED               = 301,  -- object permanently moved
  HTTP_STATUS_REDIRECT            = 302,  -- object temporarily moved
  HTTP_STATUS_REDIRECT_METHOD     = 303,  -- redirection w/ new access method
  HTTP_STATUS_NOT_MODIFIED        = 304,  -- if-modified-since was not modified
  HTTP_STATUS_USE_PROXY           = 305,  -- redirection to proxy, location header specifies proxy to use
  HTTP_STATUS_REDIRECT_KEEP_VERB  = 307,  -- HTTP/1.1: keep same verb
  HTTP_STATUS_PERMANENT_REDIRECT  = 308,  -- Object permanently moved keep verb

  HTTP_STATUS_BAD_REQUEST         = 400,  -- invalid syntax
  HTTP_STATUS_DENIED              = 401,  -- access denied
  HTTP_STATUS_PAYMENT_REQ         = 402,  -- payment required
  HTTP_STATUS_FORBIDDEN           = 403,  -- request forbidden
  HTTP_STATUS_NOT_FOUND           = 404,  -- object not found
  HTTP_STATUS_BAD_METHOD          = 405,  -- method is not allowed
  HTTP_STATUS_NONE_ACCEPTABLE     = 406,  -- no response acceptable to client found
  HTTP_STATUS_PROXY_AUTH_REQ      = 407,  -- proxy authentication required
  HTTP_STATUS_REQUEST_TIMEOUT     = 408,  -- server timed out waiting for request
  HTTP_STATUS_CONFLICT            = 409,  -- user should resubmit with more info
  HTTP_STATUS_GONE                = 410,  -- the resource is no longer available
  HTTP_STATUS_LENGTH_REQUIRED     = 411,  -- the server refused to accept request w/o a length
  HTTP_STATUS_PRECOND_FAILED      = 412,  -- precondition given in request failed
  HTTP_STATUS_REQUEST_TOO_LARGE   = 413,  -- request entity was too large
  HTTP_STATUS_URI_TOO_LONG        = 414,  -- request URI too long
  HTTP_STATUS_UNSUPPORTED_MEDIA   = 415,  -- unsupported media type
  HTTP_STATUS_RETRY_WITH          = 449,  -- retry after doing the appropriate action.

  HTTP_STATUS_SERVER_ERROR        = 500,  -- internal server error
  HTTP_STATUS_NOT_SUPPORTED       = 501,  -- required not supported
  HTTP_STATUS_BAD_GATEWAY         = 502,  -- error response received from gateway
  HTTP_STATUS_SERVICE_UNAVAIL     = 503,  -- temporarily overloaded
  HTTP_STATUS_GATEWAY_TIMEOUT     = 504,  -- timed out waiting for gateway
  HTTP_STATUS_VERSION_NOT_SUP     = 505,  -- HTTP version not supported

  HTTP_STATUS_FIRST               = HTTP_STATUS_CONTINUE,
  HTTP_STATUS_LAST                = HTTP_STATUS_VERSION_NOT_SUP
--<constant>
--<name>HTTP_STATUS_CONTINUE</name>
--<value>100</value>
--<desc></desc>
--</constant>
--<constant>
--<name>HTTP_STATUS_SWITCH_PROTOCOLS</name>
--<value>101</value>
--<desc></desc>
--</constant>
--<constant>
--<name>HTTP_STATUS_OK</name>
--<value>200</value>
--<desc></desc>
--</constant>
--<constant>
--<name>HTTP_STATUS_CREATED</name>
--<value>201</value>
--<desc></desc>
--</constant>
--<constant>
--<name>HTTP_STATUS_ACCEPTED</name>
--<value>202</value>
--<desc></desc>
--</constant>
--<constant>
--<name>HTTP_STATUS_PARTIAL</name>
--<value>203</value>
--<desc></desc>
--</constant>
--<constant>
--<name>HTTP_STATUS_NO_CONTENT</name>
--<value>204</value>
--<desc></desc>
--</constant>
--<constant>
--<name>HTTP_STATUS_RESET_CONTENT</name>
--<value>205</value>
--<desc></desc>
--</constant>
--<constant>
--<name>HTTP_STATUS_PARTIAL_CONTENT</name>
--<value>206</value>
--<desc></desc>
--</constant>
--<constant>
--<name>HTTP_STATUS_WEBDAV_MULTI_STATUS</name>
--<value>207</value>
--<desc></desc>
--</constant>
--<constant>
--<name>HTTP_STATUS_AMBIGUOUS</name>
--<value>300</value>
--<desc></desc>
--</constant>
--<constant>
--<name>HTTP_STATUS_MOVED</name>
--<value>301</value>
--<desc></desc>
--</constant>
--<constant>
--<name>HTTP_STATUS_REDIRECT</name>
--<value>302</value>
--<desc></desc>
--</constant>
--<constant>
--<name>HTTP_STATUS_REDIRECT_METHOD</name>
--<value>303</value>
--<desc></desc>
--</constant>
--<constant>
--<name>HTTP_STATUS_NOT_MODIFIED</name>
--<value>304</value>
--<desc></desc>
--</constant>
--<constant>
--<name>HTTP_STATUS_USE_PROXY</name>
--<value>305</value>
--<desc></desc>
--</constant>
--<constant>
--<name>HTTP_STATUS_REDIRECT_KEEP_VERB</name>
--<value>307</value>
--<desc></desc>
--</constant>
--<constant>
--<name>HTTP_STATUS_PERMANENT_REDIRECT</name>
--<value>308</value>
--<desc></desc>
--</constant>
--<constant>
--<name>HTTP_STATUS_BAD_REQUEST</name>
--<value>400</value>
--<desc></desc>
--</constant>
--<constant>
--<name>HTTP_STATUS_DENIED</name>
--<value>401</value>
--<desc></desc>
--</constant>
--<constant>
--<name>HTTP_STATUS_PAYMENT_REQ</name>
--<value>402</value>
--<desc></desc>
--</constant>
--<constant>
--<name>HTTP_STATUS_FORBIDDEN</name>
--<value>403</value>
--<desc></desc>
--</constant>
--<constant>
--<name>HTTP_STATUS_NOT_FOUND</name>
--<value>404</value>
--<desc></desc>
--</constant>
--<constant>
--<name>HTTP_STATUS_BAD_METHOD</name>
--<value>405</value>
--<desc></desc>
--</constant>
--<constant>
--<name>HTTP_STATUS_NONE_ACCEPTABLE</name>
--<value>406</value>
--<desc></desc>
--</constant>
--<constant>
--<name>HTTP_STATUS_PROXY_AUTH_REQ</name>
--<value>407</value>
--<desc></desc>
--</constant>
--<constant>
--<name>HTTP_STATUS_REQUEST_TIMEOUT</name>
--<value>408</value>
--<desc></desc>
--</constant>
--<constant>
--<name>HTTP_STATUS_CONFLICT</name>
--<value>409</value>
--<desc></desc>
--</constant>
--<constant>
--<name>HTTP_STATUS_GONE</name>
--<value>410</value>
--<desc></desc>
--</constant>
--<constant>
--<name>HTTP_STATUS_LENGTH_REQUIRED</name>
--<value>411</value>
--<desc></desc>
--</constant>
--<constant>
--<name>HTTP_STATUS_PRECOND_FAILED</name>
--<value>412</value>
--<desc></desc>
--</constant>
--<constant>
--<name>HTTP_STATUS_REQUEST_TOO_LARGE</name>
--<value>413</value>
--<desc></desc>
--</constant>
--<constant>
--<name>HTTP_STATUS_URI_TOO_LONG</name>
--<value>414</value>
--<desc></desc>
--</constant>
--<constant>
--<name>HTTP_STATUS_UNSUPPORTED_MEDIA</name>
--<value>415</value>
--<desc></desc>
--</constant>
--<constant>
--<name>HTTP_STATUS_RETRY_WITH</name>
--<value>449</value>
--<desc></desc>
--</constant>
--<constant>
--<name>HTTP_STATUS_SERVER_ERROR</name>
--<value>500</value>
--<desc></desc>
--</constant>
--<constant>
--<name>HTTP_STATUS_NOT_SUPPORTED</name>
--<value>501</value>
--<desc></desc>
--</constant>
--<constant>
--<name>HTTP_STATUS_BAD_GATEWAY</name>
--<value>502</value>
--<desc></desc>
--</constant>
--<constant>
--<name>HTTP_STATUS_SERVICE_UNAVAIL</name>
--<value>503</value>
--<desc></desc>
--</constant>
--<constant>
--<name>HTTP_STATUS_GATEWAY_TIMEOUT</name>
--<value>504</value>
--<desc></desc>
--</constant>
--<constant>
--<name>HTTP_STATUS_VERSION_NOT_SUP</name>
--<value>505</value>
--<desc></desc>
--</constant>
--<constant>
--<name>HTTP_STATUS_FIRST</name>
--<value>HTTP_STATUS_CONTINUE</value>
--<desc></desc>
--</constant>
--<constant>
--<name>HTTP_STATUS_LAST</name>
--<value>HTTP_STATUS_VERSION_NOT_SUP</value>
--<desc></desc>
--</constant>

--
-- flags for CrackUrl() and CombineUrl()
--
public constant
  ICU_NO_ENCODE          = #20000000,  -- Don't convert unsafe characters to escape sequence
  ICU_DECODE             = #10000000,  -- Convert %XX escape sequences to characters
  ICU_NO_META            = #08000000,  -- Don't convert .. etc. meta path sequences
  ICU_ENCODE_SPACES_ONLY = #04000000,  -- Encode spaces only
  ICU_BROWSER_MODE       = #02000000,  -- Special encode/decode rules for browser
  ICU_ENCODE_PERCENT     = #00001000   -- Encode any percent (ASCII25)
--<constant>
--<name>ICU_NO_ENCODE</name>
--<value>#20000000</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ICU_DECODE</name>
--<value>#10000000</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ICU_NO_META</name>
--<value>#08000000</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ICU_ENCODE_SPACES_ONLY</name>
--<value>#04000000</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ICU_BROWSER_MODE</name>
--<value>#02000000</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ICU_ENCODE_PERCENT</name>
--<value>#00001000</value>
--<desc></desc>
--</constant>

        -- signs encountered, default is to not encode percent.

--
-- flags for WinHttpCrackUrl() and WinHttpCreateUrl()
--
public constant
  ICU_ESCAPE             = #80000000,  -- (un)escape URL characters
  ICU_ESCAPE_AUTHORITY   = #00002000,  -- causes InternetCreateUrlA to escape chars in authority components (user, pwd, host)
  ICU_REJECT_USERPWD     = #00004000   -- rejects usrls whick have username/pwd sections
--<constant>
--<name>ICU_ESCAPE</name>
--<value>#80000000</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ICU_ESCAPE_AUTHORITY</name>
--<value>#00002000</value>
--<desc></desc>
--</constant>
--<constant>
--<name>ICU_REJECT_USERPWD</name>
--<value>#00004000</value>
--<desc></desc>
--</constant>

public constant
  -- WinHttpOpen dwAccessType values (also for WINHTTP_PROXY_INFO::dwAccessType)
  WINHTTP_ACCESS_TYPE_DEFAULT_PROXY   = 0,
  WINHTTP_ACCESS_TYPE_NO_PROXY        = 1,
  WINHTTP_ACCESS_TYPE_NAMED_PROXY     = 3,
  WINHTTP_ACCESS_TYPE_AUTOMATIC_PROXY = 4,

  -- WinHttpOpen prettifiers for optional parameters
  WINHTTP_NO_PROXY_NAME     = NULL,
  WINHTTP_NO_PROXY_BYPASS   = NULL,

  WINHTTP_NO_CLIENT_CERT_CONTEXT = NULL,

  -- WinHttpOpenRequest prettifers for optional parameters
  WINHTTP_NO_REFERER             = NULL,
  WINHTTP_DEFAULT_ACCEPT_TYPES   = NULL
--<constant>
--<name>WINHTTP_ACCESS_TYPE_DEFAULT_PROXY</name>
--<value>0</value>
--<desc></desc>
--</constant>
--<constant>
--<name>WINHTTP_ACCESS_TYPE_NO_PROXY</name>
--<value>1</value>
--<desc></desc>
--</constant>
--<constant>
--<name>WINHTTP_ACCESS_TYPE_NAMED_PROXY</name>
--<value>3</value>
--<desc></desc>
--</constant>
--<constant>
--<name>WINHTTP_ACCESS_TYPE_AUTOMATIC_PROXY</name>
--<value>4</value>
--<desc></desc>
--</constant>
--<constant>
--<name>WINHTTP_NO_PROXY_NAME</name>
--<value>NULL</value>
--<desc></desc>
--</constant>
--<constant>
--<name>WINHTTP_NO_PROXY_BYPASS</name>
--<value>NULL</value>
--<desc></desc>
--</constant>
--<constant>
--<name>WINHTTP_NO_CLIENT_CERT_CONTEXT</name>
--<value>NULL</value>
--<desc></desc>
--</constant>
--<constant>
--<name>WINHTTP_NO_REFERER</name>
--<value>NULL</value>
--<desc></desc>
--</constant>
--<constant>
--<name>WINHTTP_DEFAULT_ACCEPT_TYPES</name>
--<value>NULL</value>
--<desc></desc>
--</constant>

--
-- values for dwModifiers parameter of WinHttpAddRequestHeaders()
--

public constant
  WINHTTP_ADDREQ_INDEX_MASK      = #0000FFFF,
  WINHTTP_ADDREQ_FLAGS_MASK      = #FFFF0000,

-- WINHTTP_ADDREQ_FLAG_ADD_IF_NEW - the header will only be added if it doesn't
-- already exist
  WINHTTP_ADDREQ_FLAG_ADD_IF_NEW = #10000000,

-- WINHTTP_ADDREQ_FLAG_ADD - if WINHTTP_ADDREQ_FLAG_REPLACE is set but the header is
-- not found then if this flag is set, the header is added anyway, so long as
-- there is a valid header-value
  WINHTTP_ADDREQ_FLAG_ADD        = #20000000,

-- WINHTTP_ADDREQ_FLAG_COALESCE - coalesce headers with same name. e.g.
-- "Accept: text/*" and "Accept: audio/*" with this flag results in a single
--<constant>
--<name>WINHTTP_ADDREQ_INDEX_MASK</name>
--<value>#0000FFFF</value>
--<desc></desc>
--</constant>
--<constant>
--<name>WINHTTP_ADDREQ_FLAGS_MASK</name>
--<value>#FFFF0000</value>
--<desc></desc>
--</constant>
--<constant>
--<name>WINHTTP_ADDREQ_FLAG_ADD_IF_NEW</name>
--<value>#10000000</value>
--<desc></desc>
--</constant>
--<constant>
--<name>WINHTTP_ADDREQ_FLAG_ADD</name>
--<value>#20000000</value>
--<desc></desc>
--</constant>
--<constant>
--<name>-- "Accept: text</name>
--<value></value>
--<desc></desc>
--</constant>
-- header: "Accept: text/*, audio/*"
  WINHTTP_ADDREQ_FLAG_COALESCE_WITH_COMMA     = #40000000,
  WINHTTP_ADDREQ_FLAG_COALESCE_WITH_SEMICOLON = #01000000,
  WINHTTP_ADDREQ_FLAG_COALESCE                = WINHTTP_ADDREQ_FLAG_COALESCE_WITH_COMMA,

-- WINHTTP_ADDREQ_FLAG_REPLACE - replaces the specified header. Only one header can
-- be supplied in the buffer. If the header to be replaced is not the first
-- in a list of headers with the same name, then the relative index should be
-- supplied in the low 8 bits of the dwModifiers parameter. If the header-value
-- part is missing, then the header is removed
  WINHTTP_ADDREQ_FLAG_REPLACE    = #80000000,

  WINHTTP_IGNORE_REQUEST_TOTAL_LENGTH = 0,

-- WinHttpSendRequest prettifiers for optional parameters.
  WINHTTP_NO_ADDITIONAL_HEADERS   = NULL,
  WINHTTP_NO_REQUEST_DATA         = NULL,


-- WinHttpQueryHeaders prettifiers for optional parameters.
  WINHTTP_HEADER_NAME_BY_INDEX           = NULL,
  WINHTTP_NO_OUTPUT_BUFFER               = NULL,
  WINHTTP_NO_HEADER_INDEX                = NULL

-- typedef struct
-- {
--     bool    fAutoDetect;
--     LPWSTR  lpszAutoConfigUrl;
--     LPWSTR  lpszProxy;
--     LPWSTR  lpszProxyBypass;
-- } WINHTTP_CURRENT_USER_IE_PROXY_CONFIG;

public constant
  WINHTTP_ERROR_LAST                      = 12186,

  WINHTTP_RESET_STATE                     = #00000001,
  WINHTTP_RESET_SWPAD_CURRENT_NETWORK     = #00000002,
  WINHTTP_RESET_SWPAD_ALL                 = #00000004,
  WINHTTP_RESET_SCRIPT_CACHE              = #00000008,
  WINHTTP_RESET_ALL                       = #0000FFFF,
  WINHTTP_RESET_NOTIFY_NETWORK_CHANGED    = #00010000,
  WINHTTP_RESET_OUT_OF_PROC               = #00020000


