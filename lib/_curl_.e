--  Project
------- _   _ ____  _
----___| | | |  _ \| |
---/ __| | | | |_) | |
--| (__| |_| |  _ <| |
---\___|\___/|_| \_\_____|
--
-- Copyright (C) 1998 - 2016, Daniel Stenberg, <daniel@haxx.se>, et al.
--
-- This software is licensed as described in the file COPYING, which
-- you should have received as part of this distribution. The terms
-- are also available at https://curl.haxx.se/docs/copyright.html.
--
-- You may opt to use, copy, modify, merge, publish, distribute and/or sell
-- copies of the Software, and permit persons to whom the Software is
-- furnished to do so, under the terms of the COPYING file.
--
-- This software is distributed on an "AS IS" basis, WITHOUT WARRANTY OF ANY
-- KIND, either express or implied.
--
--------------------------------------------------------------------------------
--
-- some routines are borrowed from Raymond Smith's eulibcurl2
--
--------------------------------------------------------------------------------
--
-- If you have libcurl problems, all docs and details are found here:
--   https://curl.haxx.se/libcurl/
--
-- curl-library mailing list subscription and unsubscription web interface:
--   https://cool.haxx.se/mailman/listinfo/curl-library/

include std/dll.e
include std/machine.e
include std/text.e
include std/search.e
include std/sequence.e
include std/convert.e
include _eumem_.e
include _search_.e
include _machine_.e
include _debug_.e
include _sequence_.e
include _html_.e
include _dll_.e
include _curl_constants_.e

global constant
  HTTP_STATUS=1, HTTP_URL=2, HTTP_HEADERS=3, HTTP_BODY=4

atom curl_options_list
curl_options_list = NULL

atom
  xcurl_strequal, xcurl_strnequal, xcurl_formadd, xcurl_formget, xcurl_formfree,
  xcurl_getenv, xcurl_version, xcurl_easy_escape, xcurl_escape,
  xcurl_easy_unescape, xcurl_unescape, xcurl_free, xcurl_global_init,
  xcurl_global_init_mem, xcurl_global_cleanup, xcurl_slist_append,
  xcurl_slist_free_all, xcurl_getdate,
  xcurl_version_info, xcurl_easy_strerror,
  xcurl_easy_pause, xcurl_easy_init, xcurl_easy_setopt,
  xcurl_easy_perform, xcurl_easy_cleanup, xcurl_easy_getinfo,
  xcurl_easy_duphandle, xcurl_easy_reset, xcurl_easy_recv, xcurl_easy_send

constant CURL_LIBRARY_DEFINITION = {
  {
    "libcurl",                                -- L_NAME
    "/usr/lib/x86_64-linux-gnu/libcurl.so.4", -- L_LNX_64
    "/usr/lib/i386-linux-gnu/libcurl.so.4",   -- L_LNX_32
    0,                                        -- L_WIN_64
    InitialDir & "\\libcurl.dll"              -- L_WIN_32
  }
}

atom libcurl
libcurl = register_library("libcurl", CURL_LIBRARY_DEFINITION)

constant CURL_ROUTINE_DEFINITION = {
  {"+curl_strequal",        {pointer, pointer}, int},
  {"+curl_strnequal",       {pointer, pointer, size_t}, int},
  {"+curl_formadd",         {pointer, pointer, pointer}, int},
  {"+curl_formget",         {pointer, pointer, pointer}, int},
  {"+curl_formfree",        {pointer} },
  {"+curl_getenv",          {pointer}, pointer},
  {"+curl_version",         {}, pointer},
  {"+curl_easy_escape",     {pointer, pointer, int}, pointer},
  {"+curl_escape",          {pointer, int}, pointer},
  {"+curl_easy_unescape",   {pointer, pointer, int, pointer}, pointer},
  {"+curl_unescape",        {pointer, int}, pointer},
  {"+curl_free",            {pointer} },
  {"+curl_global_init",     {long}, int},
  {"+curl_global_init_mem", {long, pointer, pointer, pointer, pointer, pointer}, int},
  {"+curl_global_cleanup",  {} },
  {"+curl_slist_append",    {pointer, pointer}, pointer},
  {"+curl_slist_free_all",  {pointer} },
  {"+curl_getdate",         {pointer, pointer}, time_t},
  {"+curl_version_info",    {pointer}, pointer},
  {"+curl_easy_strerror",   {int}, pointer},
  {"+curl_easy_pause",      {pointer, int}, int},
  {"+curl_easy_init",       {}, pointer},
  {"+curl_easy_setopt",     {pointer, int, pointer}, int},
  {"+curl_easy_perform",    {pointer}, int},
  {"+curl_easy_cleanup",    {pointer} },
  {"+curl_easy_getinfo",    {pointer, int, pointer}, int},
  {"+curl_easy_duphandle",  {pointer}, pointer},
  {"+curl_easy_reset",      {pointer} },
  {"+curl_easy_recv",       {pointer, pointer, size_t, pointer}, int},
  {"+curl_easy_send",       {pointer, pointer, size_t, pointer}, int}
}

xcurl_strequal        = 0
xcurl_strnequal       = 0
xcurl_formadd         = 0
xcurl_formget         = 0
xcurl_formfree        = 0
xcurl_getenv          = 0
xcurl_version         = 0
xcurl_easy_escape     = 0
xcurl_escape          = 0
xcurl_easy_unescape   = 0
xcurl_unescape        = 0
xcurl_free            = 0
xcurl_global_init     = 0
xcurl_global_init_mem = 0
xcurl_global_cleanup  = 0
xcurl_slist_append    = 0
xcurl_slist_free_all  = 0
xcurl_getdate         = 0
xcurl_version_info    = 0
xcurl_easy_strerror   = 0
xcurl_easy_pause      = 0
xcurl_easy_init       = 0
xcurl_easy_setopt     = 0
xcurl_easy_perform    = 0
xcurl_easy_cleanup    = 0
xcurl_easy_getinfo    = 0
xcurl_easy_duphandle  = 0
xcurl_easy_reset      = 0
xcurl_easy_recv       = 0
xcurl_easy_send       = 0

--------------------------------------------------------------------------------

constant SETOPT_OPTIONS = {
  {CURLOPT_ACCEPTTIMEOUT_MS,            "CURLOPT_ACCEPTTIMEOUT_MS"},
  {CURLOPT_ACCEPT_ENCODING,             "CURLOPT_ACCEPT_ENCODING"},
  {CURLOPT_ADDRESS_SCOPE,               "CURLOPT_ADDRESS_SCOPE"},
  {CURLOPT_APPEND,                      "CURLOPT_APPEND"},
  {CURLOPT_AUTOREFERER,                 "CURLOPT_AUTOREFERER"},
  {CURLOPT_BUFFERSIZE,                  "CURLOPT_BUFFERSIZE"},
  {CURLOPT_CAINFO,                      "CURLOPT_CAINFO"},
  {CURLOPT_CAPATH,                      "CURLOPT_CAPATH"},
  {CURLOPT_CERTINFO,                    "CURLOPT_CERTINFO"},
  {CURLOPT_CHUNK_BGN_FUNCTION,          "CURLOPT_CHUNK_BGN_FUNCTION"},
  {CURLOPT_CHUNK_DATA,                  "CURLOPT_CHUNK_DATA"},
  {CURLOPT_CHUNK_END_FUNCTION,          "CURLOPT_CHUNK_END_FUNCTION"},
  {CURLOPT_CLOSESOCKETDATA,             "CURLOPT_CLOSESOCKETDATA"},
  {CURLOPT_CLOSESOCKETFUNCTION,         "CURLOPT_CLOSESOCKETFUNCTION"},
  {CURLOPT_CONNECTTIMEOUT,              "CURLOPT_CONNECTTIMEOUT"},
  {CURLOPT_CONNECTTIMEOUT_MS,           "CURLOPT_CONNECTTIMEOUT_MS"},
  {CURLOPT_CONNECT_ONLY,                "CURLOPT_CONNECT_ONLY"},
  {CURLOPT_CONNECT_TO,                  "CURLOPT_CONNECT_TO"},
  {CURLOPT_CONV_FROM_NETWORK_FUNCTION,  "CURLOPT_CONV_FROM_NETWORK_FUNCTION"},
  {CURLOPT_CONV_FROM_UTF8_FUNCTION,     "CURLOPT_CONV_FROM_UTF8_FUNCTION"},
  {CURLOPT_CONV_TO_NETWORK_FUNCTION,    "CURLOPT_CONV_TO_NETWORK_FUNCTION"},
  {CURLOPT_COOKIE,                      "CURLOPT_COOKIE"},
  {CURLOPT_COOKIEFILE,                  "CURLOPT_COOKIEFILE"},
  {CURLOPT_COOKIEJAR,                   "CURLOPT_COOKIEJAR"},
  {CURLOPT_COOKIELIST,                  "CURLOPT_COOKIELIST"},
  {CURLOPT_COOKIESESSION,               "CURLOPT_COOKIESESSION"},
  {CURLOPT_COPYPOSTFIELDS,              "CURLOPT_COPYPOSTFIELDS"},
  {CURLOPT_CRLF,                        "CURLOPT_CRLF"},
  {CURLOPT_CRLFILE,                     "CURLOPT_CRLFILE"},
  {CURLOPT_CUSTOMREQUEST,               "CURLOPT_CUSTOMREQUEST"},
  {CURLOPT_DEBUGDATA,                   "CURLOPT_DEBUGDATA"},
  {CURLOPT_DEBUGFUNCTION,               "CURLOPT_DEBUGFUNCTION"},
  {CURLOPT_DEFAULT_PROTOCOL,            "CURLOPT_DEFAULT_PROTOCOL"},
  {CURLOPT_DIRLISTONLY,                 "CURLOPT_DIRLISTONLY"},
  {CURLOPT_DNS_CACHE_TIMEOUT,           "CURLOPT_DNS_CACHE_TIMEOUT"},
  {CURLOPT_DNS_INTERFACE,               "CURLOPT_DNS_INTERFACE"},
  {CURLOPT_DNS_LOCAL_IP4,               "CURLOPT_DNS_LOCAL_IP4"},
  {CURLOPT_DNS_LOCAL_IP6,               "CURLOPT_DNS_LOCAL_IP6"},
  {CURLOPT_DNS_SERVERS,                 "CURLOPT_DNS_SERVERS"},
  {CURLOPT_DNS_USE_GLOBAL_CACHE,        "CURLOPT_DNS_USE_GLOBAL_CACHE"},
  {CURLOPT_EGDSOCKET,                   "CURLOPT_EGDSOCKET"},
  {CURLOPT_ERRORBUFFER,                 "CURLOPT_ERRORBUFFER"},
  {CURLOPT_EXPECT_100_TIMEOUT_MS,       "CURLOPT_EXPECT_100_TIMEOUT_MS"},
  {CURLOPT_FAILONERROR,                 "CURLOPT_FAILONERROR"},
  {CURLOPT_FILETIME,                    "CURLOPT_FILETIME"},
  {CURLOPT_FNMATCH_DATA,                "CURLOPT_FNMATCH_DATA"},
  {CURLOPT_FNMATCH_FUNCTION,            "CURLOPT_FNMATCH_FUNCTION"},
  {CURLOPT_FOLLOWLOCATION,              "CURLOPT_FOLLOWLOCATION"},
  {CURLOPT_FORBID_REUSE,                "CURLOPT_FORBID_REUSE"},
  {CURLOPT_FRESH_CONNECT,               "CURLOPT_FRESH_CONNECT"},
  {CURLOPT_FTPPORT,                     "CURLOPT_FTPPORT"},
  {CURLOPT_FTPSSLAUTH,                  "CURLOPT_FTPSSLAUTH"},
  {CURLOPT_FTP_ACCOUNT,                 "CURLOPT_FTP_ACCOUNT"},
  {CURLOPT_FTP_ALTERNATIVE_TO_USER,     "CURLOPT_FTP_ALTERNATIVE_TO_USER"},
  {CURLOPT_FTP_CREATE_MISSING_DIRS,     "CURLOPT_FTP_CREATE_MISSING_DIRS"},
  {CURLOPT_FTP_FILEMETHOD,              "CURLOPT_FTP_FILEMETHOD"},
  {CURLOPT_FTP_RESPONSE_TIMEOUT,        "CURLOPT_FTP_RESPONSE_TIMEOUT"},
  {CURLOPT_FTP_SKIP_PASV_IP,            "CURLOPT_FTP_SKIP_PASV_IP"},
  {CURLOPT_FTP_SSL_CCC,                 "CURLOPT_FTP_SSL_CCC"},
  {CURLOPT_FTP_USE_EPRT,                "CURLOPT_FTP_USE_EPRT"},
  {CURLOPT_FTP_USE_EPSV,                "CURLOPT_FTP_USE_EPSV"},
  {CURLOPT_FTP_USE_PRET,                "CURLOPT_FTP_USE_PRET"},
  {CURLOPT_GSSAPI_DELEGATION,           "CURLOPT_GSSAPI_DELEGATION"},
  {CURLOPT_HEADER,                      "CURLOPT_HEADER"},
  {CURLOPT_HEADERDATA,                  "CURLOPT_HEADERDATA"},
  {CURLOPT_HEADERFUNCTION,              "CURLOPT_HEADERFUNCTION"},
  {CURLOPT_HEADEROPT,                   "CURLOPT_HEADEROPT"},
  {CURLOPT_HTTP200ALIASES,              "CURLOPT_HTTP200ALIASES"},
  {CURLOPT_HTTPAUTH,                    "CURLOPT_HTTPAUTH"},
  {CURLOPT_HTTPGET,                     "CURLOPT_HTTPGET"},
  {CURLOPT_HTTPHEADER,                  "CURLOPT_HTTPHEADER"},
  {CURLOPT_HTTPPOST,                    "CURLOPT_HTTPPOST"},
  {CURLOPT_HTTPPROXYTUNNEL,             "CURLOPT_HTTPPROXYTUNNEL"},
  {CURLOPT_HTTP_CONTENT_DECODING,       "CURLOPT_HTTP_CONTENT_DECODING"},
  {CURLOPT_HTTP_TRANSFER_DECODING,      "CURLOPT_HTTP_TRANSFER_DECODING"},
  {CURLOPT_HTTP_VERSION,                "CURLOPT_HTTP_VERSION"},
  {CURLOPT_IGNORE_CONTENT_LENGTH,       "CURLOPT_IGNORE_CONTENT_LENGTH"},
  {CURLOPT_INFILESIZE,                  "CURLOPT_INFILESIZE"},
  {CURLOPT_INFILESIZE_LARGE,            "CURLOPT_INFILESIZE_LARGE"},
  {CURLOPT_INTERFACE,                   "CURLOPT_INTERFACE"},
  {CURLOPT_INTERLEAVEDATA,              "CURLOPT_INTERLEAVEDATA"},
  {CURLOPT_INTERLEAVEFUNCTION,          "CURLOPT_INTERLEAVEFUNCTION"},
  {CURLOPT_IOCTLDATA,                   "CURLOPT_IOCTLDATA"},
  {CURLOPT_IOCTLFUNCTION,               "CURLOPT_IOCTLFUNCTION"},
  {CURLOPT_IPRESOLVE,                   "CURLOPT_IPRESOLVE"},
  {CURLOPT_ISSUERCERT,                  "CURLOPT_ISSUERCERT"},
  {CURLOPT_KEYPASSWD,                   "CURLOPT_KEYPASSWD"},
  {CURLOPT_KRBLEVEL,                    "CURLOPT_KRBLEVEL"},
  {CURLOPT_LOCALPORT,                   "CURLOPT_LOCALPORT"},
  {CURLOPT_LOCALPORTRANGE,              "CURLOPT_LOCALPORTRANGE"},
  {CURLOPT_LOGIN_OPTIONS,               "CURLOPT_LOGIN_OPTIONS"},
  {CURLOPT_LOW_SPEED_LIMIT,             "CURLOPT_LOW_SPEED_LIMIT"},
  {CURLOPT_LOW_SPEED_TIME,              "CURLOPT_LOW_SPEED_TIME"},
  {CURLOPT_MAIL_AUTH,                   "CURLOPT_MAIL_AUTH"},
  {CURLOPT_MAIL_FROM,                   "CURLOPT_MAIL_FROM"},
  {CURLOPT_MAIL_RCPT,                   "CURLOPT_MAIL_RCPT"},
  {CURLOPT_MAXCONNECTS,                 "CURLOPT_MAXCONNECTS"},
  {CURLOPT_MAXFILESIZE,                 "CURLOPT_MAXFILESIZE"},
  {CURLOPT_MAXFILESIZE_LARGE,           "CURLOPT_MAXFILESIZE_LARGE"},
  {CURLOPT_MAXREDIRS,                   "CURLOPT_MAXREDIRS"},
  {CURLOPT_MAX_RECV_SPEED_LARGE,        "CURLOPT_MAX_RECV_SPEED_LARGE"},
  {CURLOPT_MAX_SEND_SPEED_LARGE,        "CURLOPT_MAX_SEND_SPEED_LARGE"},
  {CURLOPT_NETRC,                       "CURLOPT_NETRC"},
  {CURLOPT_NETRC_FILE,                  "CURLOPT_NETRC_FILE"},
  {CURLOPT_NEW_DIRECTORY_PERMS,         "CURLOPT_NEW_DIRECTORY_PERMS"},
  {CURLOPT_NEW_FILE_PERMS,              "CURLOPT_NEW_FILE_PERMS"},
  {CURLOPT_NOBODY,                      "CURLOPT_NOBODY"},
  {CURLOPT_NOPROGRESS,                  "CURLOPT_NOPROGRESS"},
  {CURLOPT_NOPROXY,                     "CURLOPT_NOPROXY"},
  {CURLOPT_NOSIGNAL,                    "CURLOPT_NOSIGNAL"},
  {CURLOPT_OPENSOCKETDATA,              "CURLOPT_OPENSOCKETDATA"},
  {CURLOPT_OPENSOCKETFUNCTION,          "CURLOPT_OPENSOCKETFUNCTION"},
  {CURLOPT_PASSWORD,                    "CURLOPT_PASSWORD"},
  {CURLOPT_PATH_AS_IS,                  "CURLOPT_PATH_AS_IS"},
  {CURLOPT_PINNEDPUBLICKEY,             "CURLOPT_PINNEDPUBLICKEY"},
  {CURLOPT_PIPEWAIT,                    "CURLOPT_PIPEWAIT"},
  {CURLOPT_PORT,                        "CURLOPT_PORT"},
  {CURLOPT_POST,                        "CURLOPT_POST"},
  {CURLOPT_POSTFIELDS,                  "CURLOPT_POSTFIELDS"},
  {CURLOPT_POSTFIELDSIZE,               "CURLOPT_POSTFIELDSIZE"},
  {CURLOPT_POSTFIELDSIZE_LARGE,         "CURLOPT_POSTFIELDSIZE_LARGE"},
  {CURLOPT_POSTQUOTE,                   "CURLOPT_POSTQUOTE"},
  {CURLOPT_POSTREDIR,                   "CURLOPT_POSTREDIR"},
  {CURLOPT_PREQUOTE,                    "CURLOPT_PREQUOTE"},
  {CURLOPT_PRIVATE,                     "CURLOPT_PRIVATE"},
  {CURLOPT_PROGRESSDATA,                "CURLOPT_PROGRESSDATA"},
  {CURLOPT_PROGRESSFUNCTION,            "CURLOPT_PROGRESSFUNCTION"},
  {CURLOPT_PROTOCOLS,                   "CURLOPT_PROTOCOLS"},
  {CURLOPT_PROXY,                       "CURLOPT_PROXY"},
  {CURLOPT_PROXYAUTH,                   "CURLOPT_PROXYAUTH"},
  {CURLOPT_PROXYHEADER,                 "CURLOPT_PROXYHEADER"},
  {CURLOPT_PROXYPASSWORD,               "CURLOPT_PROXYPASSWORD"},
  {CURLOPT_PROXYPORT,                   "CURLOPT_PROXYPORT"},
  {CURLOPT_PROXYTYPE,                   "CURLOPT_PROXYTYPE"},
  {CURLOPT_PROXYUSERNAME,               "CURLOPT_PROXYUSERNAME"},
  {CURLOPT_PROXYUSERPWD,                "CURLOPT_PROXYUSERPWD"},
  {CURLOPT_PROXY_SERVICE_NAME,          "CURLOPT_PROXY_SERVICE_NAME"},
  {CURLOPT_PROXY_TRANSFER_MODE,         "CURLOPT_PROXY_TRANSFER_MODE"},
  {CURLOPT_PUT,                         "CURLOPT_PUT"},
  {CURLOPT_QUOTE,                       "CURLOPT_QUOTE"},
  {CURLOPT_RANDOM_FILE,                 "CURLOPT_RANDOM_FILE"},
  {CURLOPT_RANGE,                       "CURLOPT_RANGE"},
  {CURLOPT_READDATA,                    "CURLOPT_READDATA"},
  {CURLOPT_READFUNCTION,                "CURLOPT_READFUNCTION"},
  {CURLOPT_REDIR_PROTOCOLS,             "CURLOPT_REDIR_PROTOCOLS"},
  {CURLOPT_REFERER,                     "CURLOPT_REFERER"},
  {CURLOPT_RESOLVE,                     "CURLOPT_RESOLVE"},
  {CURLOPT_RESUME_FROM,                 "CURLOPT_RESUME_FROM"},
  {CURLOPT_RESUME_FROM_LARGE,           "CURLOPT_RESUME_FROM_LARGE"},
  {CURLOPT_RTSP_CLIENT_CSEQ,            "CURLOPT_RTSP_CLIENT_CSEQ"},
  {CURLOPT_RTSP_REQUEST,                "CURLOPT_RTSP_REQUEST"},
  {CURLOPT_RTSP_SERVER_CSEQ,            "CURLOPT_RTSP_SERVER_CSEQ"},
  {CURLOPT_RTSP_SESSION_ID,             "CURLOPT_RTSP_SESSION_ID"},
  {CURLOPT_RTSP_STREAM_URI,             "CURLOPT_RTSP_STREAM_URI"},
  {CURLOPT_RTSP_TRANSPORT,              "CURLOPT_RTSP_TRANSPORT"},
  {CURLOPT_SASL_IR,                     "CURLOPT_SASL_IR"},
  {CURLOPT_SEEKDATA,                    "CURLOPT_SEEKDATA"},
  {CURLOPT_SEEKFUNCTION,                "CURLOPT_SEEKFUNCTION"},
  {CURLOPT_SERVICE_NAME,                "CURLOPT_SERVICE_NAME"},
  {CURLOPT_SHARE,                       "CURLOPT_SHARE"},
  {CURLOPT_SOCKOPTDATA,                 "CURLOPT_SOCKOPTDATA"},
  {CURLOPT_SOCKOPTFUNCTION,             "CURLOPT_SOCKOPTFUNCTION"},
  {CURLOPT_SOCKS5_GSSAPI_NEC,           "CURLOPT_SOCKS5_GSSAPI_NEC"},
  {CURLOPT_SOCKS5_GSSAPI_SERVICE,       "CURLOPT_SOCKS5_GSSAPI_SERVICE"},
  {CURLOPT_SSH_AUTH_TYPES,              "CURLOPT_SSH_AUTH_TYPES"},
  {CURLOPT_SSH_HOST_PUBLIC_KEY_MD5,     "CURLOPT_SSH_HOST_PUBLIC_KEY_MD5"},
  {CURLOPT_SSH_KEYDATA,                 "CURLOPT_SSH_KEYDATA"},
  {CURLOPT_SSH_KEYFUNCTION,             "CURLOPT_SSH_KEYFUNCTION"},
  {CURLOPT_SSH_KNOWNHOSTS,              "CURLOPT_SSH_KNOWNHOSTS"},
  {CURLOPT_SSH_PRIVATE_KEYFILE,         "CURLOPT_SSH_PRIVATE_KEYFILE"},
  {CURLOPT_SSH_PUBLIC_KEYFILE,          "CURLOPT_SSH_PUBLIC_KEYFILE"},
  {CURLOPT_SSLCERT,                     "CURLOPT_SSLCERT"},
  {CURLOPT_SSLCERTTYPE,                 "CURLOPT_SSLCERTTYPE"},
  {CURLOPT_SSLENGINE,                   "CURLOPT_SSLENGINE"},
  {CURLOPT_SSLENGINE_DEFAULT,           "CURLOPT_SSLENGINE_DEFAULT"},
  {CURLOPT_SSLKEY,                      "CURLOPT_SSLKEY"},
  {CURLOPT_SSLKEYTYPE,                  "CURLOPT_SSLKEYTYPE"},
  {CURLOPT_SSLVERSION,                  "CURLOPT_SSLVERSION"},
  {CURLOPT_SSL_CIPHER_LIST,             "CURLOPT_SSL_CIPHER_LIST"},
  {CURLOPT_SSL_CTX_DATA,                "CURLOPT_SSL_CTX_DATA"},
  {CURLOPT_SSL_CTX_FUNCTION,            "CURLOPT_SSL_CTX_FUNCTION"},
  {CURLOPT_SSL_ENABLE_ALPN,             "CURLOPT_SSL_ENABLE_ALPN"},
  {CURLOPT_SSL_ENABLE_NPN,              "CURLOPT_SSL_ENABLE_NPN"},
  {CURLOPT_SSL_FALSESTART,              "CURLOPT_SSL_FALSESTART"},
  {CURLOPT_SSL_OPTIONS,                 "CURLOPT_SSL_OPTIONS"},
  {CURLOPT_SSL_SESSIONID_CACHE,         "CURLOPT_SSL_SESSIONID_CACHE"},
  {CURLOPT_SSL_VERIFYHOST,              "CURLOPT_SSL_VERIFYHOST"},
  {CURLOPT_SSL_VERIFYPEER,              "CURLOPT_SSL_VERIFYPEER"},
  {CURLOPT_SSL_VERIFYSTATUS,            "CURLOPT_SSL_VERIFYSTATUS"},
  {CURLOPT_STDERR,                      "CURLOPT_STDERR"},
  {CURLOPT_STREAM_DEPENDS,              "CURLOPT_STREAM_DEPENDS"},
  {CURLOPT_STREAM_DEPENDS_E,            "CURLOPT_STREAM_DEPENDS_E"},
  {CURLOPT_STREAM_WEIGHT,               "CURLOPT_STREAM_WEIGHT"},
  {CURLOPT_TCP_FASTOPEN,                "CURLOPT_TCP_FASTOPEN"},
  {CURLOPT_TCP_KEEPALIVE,               "CURLOPT_TCP_KEEPALIVE"},
  {CURLOPT_TCP_KEEPIDLE,                "CURLOPT_TCP_KEEPIDLE"},
  {CURLOPT_TCP_KEEPINTVL,               "CURLOPT_TCP_KEEPINTVL"},
  {CURLOPT_TCP_NODELAY,                 "CURLOPT_TCP_NODELAY"},
  {CURLOPT_TELNETOPTIONS,               "CURLOPT_TELNETOPTIONS"},
  {CURLOPT_TFTP_BLKSIZE,                "CURLOPT_TFTP_BLKSIZE"},
  {CURLOPT_TFTP_NO_OPTIONS,             "CURLOPT_TFTP_NO_OPTIONS"},
  {CURLOPT_TIMECONDITION,               "CURLOPT_TIMECONDITION"},
  {CURLOPT_TIMEOUT,                     "CURLOPT_TIMEOUT"},
  {CURLOPT_TIMEOUT_MS,                  "CURLOPT_TIMEOUT_MS"},
  {CURLOPT_TIMEVALUE,                   "CURLOPT_TIMEVALUE"},
  {CURLOPT_TLSAUTH_PASSWORD,            "CURLOPT_TLSAUTH_PASSWORD"},
  {CURLOPT_TLSAUTH_TYPE,                "CURLOPT_TLSAUTH_TYPE"},
  {CURLOPT_TLSAUTH_USERNAME,            "CURLOPT_TLSAUTH_USERNAME"},
  {CURLOPT_TRANSFERTEXT,                "CURLOPT_TRANSFERTEXT"},
  {CURLOPT_TRANSFER_ENCODING,           "CURLOPT_TRANSFER_ENCODING"},
  {CURLOPT_UNIX_SOCKET_PATH,            "CURLOPT_UNIX_SOCKET_PATH"},
  {CURLOPT_UNRESTRICTED_AUTH,           "CURLOPT_UNRESTRICTED_AUTH"},
  {CURLOPT_UPLOAD,                      "CURLOPT_UPLOAD"},
  {CURLOPT_URL,                         "CURLOPT_URL"},
  {CURLOPT_USERAGENT,                   "CURLOPT_USERAGENT"},
  {CURLOPT_USERNAME,                    "CURLOPT_USERNAME"},
  {CURLOPT_USERPWD,                     "CURLOPT_USERPWD"},
  {CURLOPT_USE_SSL,                     "CURLOPT_USE_SSL"},
  {CURLOPT_VERBOSE,                     "CURLOPT_VERBOSE"},
  {CURLOPT_WILDCARDMATCH,               "CURLOPT_WILDCARDMATCH"},
  {CURLOPT_WRITEDATA,                   "CURLOPT_WRITEDATA"},
  {CURLOPT_WRITEFUNCTION,               "CURLOPT_WRITEFUNCTION"},
  {CURLOPT_XFERINFODATA,                "CURLOPT_XFERINFODATA"},
  {CURLOPT_XFERINFOFUNCTION,            "CURLOPT_XFERINFOFUNCTION"},
  {CURLOPT_XOAUTH2_BEARER,              "CURLOPT_XOAUTH2_BEARER"}
}

--------------------------------------------------------------------------------

constant GETINFO_OPTIONS = {
  {CURLINFO_CONTENT_TYPE,               "CURLINFO_CONTENT_TYPE"},
  {CURLINFO_EFFECTIVE_URL,              "CURLINFO_EFFECTIVE_URL"},
  {CURLINFO_FTP_ENTRY_PATH,             "CURLINFO_FTP_ENTRY_PATH"},
  {CURLINFO_LOCAL_IP,                   "CURLINFO_LOCAL_IP"},
  {CURLINFO_PRIMARY_IP,                 "CURLINFO_PRIMARY_IP"},
  {CURLINFO_PRIVATE,                    "CURLINFO_PRIVATE"},
  {CURLINFO_REDIRECT_URL,               "CURLINFO_REDIRECT_URL"},
  {CURLINFO_RTSP_SESSION_ID,            "CURLINFO_RTSP_SESSION_ID"},
  {CURLINFO_ACTIVESOCKET,               "CURLINFO_ACTIVESOCKET"},
  {CURLINFO_APPCONNECT_TIME,            "CURLINFO_APPCONNECT_TIME"},
  {CURLINFO_CONNECT_TIME,               "CURLINFO_CONNECT_TIME"},
  {CURLINFO_CONTENT_LENGTH_DOWNLOAD,    "CURLINFO_CONTENT_LENGTH_DOWNLOAD"},
  {CURLINFO_CONTENT_LENGTH_UPLOAD,      "CURLINFO_CONTENT_LENGTH_UPLOAD"},
  {CURLINFO_NAMELOOKUP_TIME,            "CURLINFO_NAMELOOKUP_TIME"},
  {CURLINFO_PRETRANSFER_TIME,           "CURLINFO_PRETRANSFER_TIME"},
  {CURLINFO_REDIRECT_TIME,              "CURLINFO_REDIRECT_TIME"},
  {CURLINFO_SIZE_DOWNLOAD,              "CURLINFO_SIZE_DOWNLOAD"},
  {CURLINFO_SIZE_UPLOAD,                "CURLINFO_SIZE_UPLOAD"},
  {CURLINFO_SPEED_DOWNLOAD,             "CURLINFO_SPEED_DOWNLOAD"},
  {CURLINFO_SPEED_UPLOAD,               "CURLINFO_SPEED_UPLOAD"},
  {CURLINFO_STARTTRANSFER_TIME,         "CURLINFO_STARTTRANSFER_TIME"},
  {CURLINFO_TOTAL_TIME,                 "CURLINFO_TOTAL_TIME"},
  {CURLINFO_CONDITION_UNMET,            "CURLINFO_CONDITION_UNMET"},
  {CURLINFO_FILETIME,                   "CURLINFO_FILETIME"},
  {CURLINFO_HEADER_SIZE,                "CURLINFO_HEADER_SIZE"},
  {CURLINFO_HTTP_CONNECTCODE,           "CURLINFO_HTTP_CONNECTCODE"},
  {CURLINFO_HTTP_VERSION,               "CURLINFO_HTTP_VERSION"},
  {CURLINFO_HTTPAUTH_AVAIL,             "CURLINFO_HTTPAUTH_AVAIL"},
  {CURLINFO_LASTSOCKET,                 "CURLINFO_LASTSOCKET"},
  {CURLINFO_LOCAL_PORT,                 "CURLINFO_LOCAL_PORT"},
  {CURLINFO_NUM_CONNECTS,               "CURLINFO_NUM_CONNECTS"},
  {CURLINFO_OS_ERRNO,                   "CURLINFO_OS_ERRNO"},
  {CURLINFO_PRIMARY_PORT,               "CURLINFO_PRIMARY_PORT"},
  {CURLINFO_PROXYAUTH_AVAIL,            "CURLINFO_PROXYAUTH_AVAIL"},
  {CURLINFO_REDIRECT_COUNT,             "CURLINFO_REDIRECT_COUNT"},
  {CURLINFO_REQUEST_SIZE,               "CURLINFO_REQUEST_SIZE"},
  {CURLINFO_RESPONSE_CODE,              "CURLINFO_RESPONSE_CODE"},
  {CURLINFO_RTSP_CLIENT_CSEQ,           "CURLINFO_RTSP_CLIENT_CSEQ"},
  {CURLINFO_RTSP_CSEQ_RECV,             "CURLINFO_RTSP_CSEQ_RECV"},
  {CURLINFO_RTSP_SERVER_CSEQ,           "CURLINFO_RTSP_SERVER_CSEQ"},
  {CURLINFO_SSL_VERIFYRESULT,           "CURLINFO_SSL_VERIFYRESULT"},
  {CURLINFO_CERTINFO,                   "CURLINFO_CERTINFO"},
  {CURLINFO_COOKIELIST,                 "CURLINFO_COOKIELIST"},
  {CURLINFO_SSL_ENGINES,                "CURLINFO_SSL_ENGINES"},
  {CURLINFO_TLS_SESSION,                "CURLINFO_TLS_SESSION"},
  {CURLINFO_TLS_SSL_PTR,                "CURLINFO_TLS_SSL_PTR"}
}




--------------------------------------------------------------------------------
-- LIBCURL STRUCTURES
--------------------------------------------------------------------------------


-- struct curl_httppost {
--   struct curl_httppost *next;       -- next entry in the list
--   char *name;                       -- pointer to allocated name
--   long namelength;                  -- length of name length
--   char *contents;                   -- pointer to allocated data contents
--   long contentslength;              -- length of contents field, see also
--                                 --  -- CURL_HTTPPOST_LARGE
--   char *buffer;                     -- pointer to allocated buffer contents
--   long bufferlength;                -- length of buffer field
--   char *contenttype;                -- Content-Type
--   struct curl_slist* contentheader; -- list of extra headers for this form
--   struct curl_httppost *more;       -- if one field name has more than one
--                                 --  -- file, this link should link to following
--                                 --  -- files
--   long flags;                       -- as defined below
--   char *showfilename;               -- The file name to show. If not set, the
--                                 --  -- actual file name will be used (if this
--                                 --  -- is a file part)
--   void *userp;                      -- custom pointer used for
--                                 --  -- HTTPPOST_CALLBACK posts
--   curl_off_t contentlen;            -- alternative length of contents
--                                 --  -- field. Used if CURL_HTTPPOST_LARGE is
--                                 --  -- set. Added in 7.46.0
-- };

--------------------------------------------------------------------------------

-- Content of this structure depends on information which is known and is
--    achievable (e.g. by FTP LIST parsing). Please see the url_easy_setopt(3) man
--    page for callbacks returning this structure -- some fields are mandatory,
--    some others are optional. The FLAG field has special meaning.

-- struct curl_fileinfo {
--   char *filename;
--   curlfiletype filetype;
--   time_t time;
--   unsigned int perm;
--   int uid;
--   int gid;
--   curl_off_t size;
--   long int hardlinks;

--------------------------------------------------------------------------------

--   struct {
--     -- If some of these fields is not NULL, it is a pointer to b_data.
--     char *time;
--     char *perm;
--     char *user;
--     char *group;
--     char *target; -- pointer to the target filename of a symlink
--   } strings;

 --  unsigned int flags;

--   -- used internally
--   char * b_data;
--   size_t b_size;
--   size_t b_used;
-- };

--------------------------------------------------------------------------------

-- struct curl_sockaddr {
--   int family;
--   int socktype;
--   int protocol;
--   unsigned int addrlen; -- addrlen was a socklen_t type before 7.18.0 but it
--                         -- turned really ugly and painful on the systems that
--                         -- lack this type
--   struct sockaddr addr;
-- };

--------------------------------------------------------------------------------

-- struct curl_khkey {
--   const char *key; -- points to a zero-terminated string encoded with base64
--                    -- if len is zero, otherwise to the "raw" data
--   size_t len;
--   public enum curl_khtype keytype;
-- };

--------------------------------------------------------------------------------

-- structure to be used as parameter for CURLFORM_ARRAY
--
-- struct curl_forms {
--   CURLformoption option;
--   const char **value;
-- };

--------------------------------------------------------------------------------

-- linked-list structure for the CURLOPT_QUOTE option (and other)
--
-- struct curl_slist {
--   char *data;
--   struct curl_slist *next;
-- };

-- struct curl_slist *
--   slist = curl_slist_append(slist, param)
--   s = peek_curl_slist(slist, max)

--------------------------------------------------------------------------------

-- info about the certificate chain, only for OpenSSL builds. Asked
--    for with CURLOPT_CERTINFO / CURLINFO_CERTINFO
--
-- struct curl_certinfo {
--   int num_of_certs;             -- number of certificates with information
--   struct curl_slist **certinfo; -- for each index in this array, there's a
--                                 -- linked list with textual information in the
--                                 -- format "name: value"
-- };

--------------------------------------------------------------------------------

-- Information about the SSL library used and the respective internal SSL
--    handle, which can be used to obtain further information regarding the
--    connection. Asked for with CURLINFO_TLS_SSL_PTR or CURLINFO_TLS_SESSION.
--
-- struct curl_tlssessioninfo {
--   curl_sslbackend backend;
--   void *internals;
-- };

--------------------------------------------------------------------------------

-- Structures for querying information about the curl library at runtime.

-- typedef struct {
--   CURLversion age;          -- age of the returned struct
--   const char *version;      -- LIBCURL_VERSION
--   unsigned int version_num; -- LIBCURL_VERSION_NUM
--   const char *host;         -- OS/host/cpu/machine when configured
--   int features;             -- bitmask, see defines below
--   const char *ssl_version;  -- human readable string
--   long ssl_version_num;     -- not used anymore, always 0
--   const char *libz_version; -- human readable string
--   -- protocols is terminated by an entry with a NULL protoname
--   const char * const *protocols;

--   -- The fields below this were added in CURLVERSION_SECOND
--   const char *ares;
--   int ares_num;

--   -- This field was added in CURLVERSION_THIRD
--   const char *libidn;

--   -- These field were added in CURLVERSION_FOURTH

--   -- Same as '_libiconv_version' if built with HAVE_ICONV
--   int iconv_ver_num;

--   const char *libssh_version; -- human readable string

-- } curl_version_info_data;




--------------------------------------------------------------------------------
-- LIBCURL CALLBACKS
--------------------------------------------------------------------------------

-- if splitting of data transfer is enabled, this callback is called before
--    download of an individual chunk started. Note that parameter "remains" works
--    only for FTP wildcard downloading (for now), otherwise is not used

-- typedef long (*curl_chunk_bgn_callback)(const void *transfer_info,
--                                 --      void *ptr,
--                                 --      int remains);

--------------------------------------------------------------------------------

-- This is the CURLOPT_PROGRESSFUNCTION callback proto. It is now considered
--   deprecated but was the only choice up until 7.31.0
--
-- Ttypedef int (*curl_progress_callback)(void *clientp,
--                                 --    double dltotal,
--                                 --    double dlnow,
--                                 --    double ultotal,
--                                 --    double ulnow);

--------------------------------------------------------------------------------

-- This is the CURLOPT_XFERINFOFUNCTION callback proto. It was introduced in
--    7.32.0, it avoids floating point and provides more detailed information.
--
-- typedef int (*curl_xferinfo_callback)(void *clientp,
--                                 --    curl_off_t dltotal,
--                                 --    curl_off_t dlnow,
--                                 --    curl_off_t ultotal,
--                                 --    curl_off_t ulnow);

--------------------------------------------------------------------------------

-- typedef long (*curl_chunk_bgn_callback)(const void *transfer_info,
--                                 --      void *ptr,
--                                 --      int remains);

--------------------------------------------------------------------------------

-- If splitting of data transfer is enabled this callback is called after
--    download of an individual chunk finished.
--    Note! After this callback was set then it have to be called FOR ALL chunks.
--    Even if downloading of this chunk was skipped in CHUNK_BGN_FUNC.
--    This is the reason why we don't need "transfer_info" parameter in this
--    callback and we are not interested in "remains" parameter too.

-- typedef long (*curl_chunk_end_callback)(void *ptr);

--------------------------------------------------------------------------------

-- callback type for wildcard downloading pattern matching. If the
--    string matches the pattern, return CURL_FNMATCHFUNC_MATCH value, etc.

-- typedef int (*curl_fnmatch_callback)(void *ptr,
--                                 --   const char *pattern,
--                                 --   const char *string);

--------------------------------------------------------------------------------

-- typedef int (*curl_seek_callback)(void *instream,
--                                 --curl_off_t offset,
--                                 --int origin); -- 'whence'

--------------------------------------------------------------------------------

-- typedef int (*curl_sockopt_callback)(void *clientp,
--                                 --   curl_socket_t curlfd,
--                                 --   curlsocktype purpose);

--------------------------------------------------------------------------------

public function curl_write_callback(atom ptr, atom size, atom nmemb, atom stream)
--<function>
--<name>curl_write_callback</name>
--<digest></digest>
--<desc>
--</desc>
--<param>
--<type>atom</type>
--<name>ptr</name>
--<desc></desc>
--</param>
--<param>
--<type>atom</type>
--<name>size</name>
--<desc></desc>
--</param>
--<param>
--<type>atom</type>
--<name>nmemb</name>
--<desc></desc>
--</param>
--<param>
--<type>atom</type>
--<name>stream</name>
--<desc></desc>
--</param>
--<return>
--</return>
--<example>
--</example>
--<see_also>
--</see_also>
--</function>
  atom realsize
  sequence data

  realsize = size * nmemb
  data = peek({ ptr, realsize })

  ram_space[stream] = append( ram_space[stream], data )

  return realsize
end function

--------------------------------------------------------------------------------

public function curl_read_callback(atom ptr, atom size, atom nmemb, atom stream)
--<function>
--<name>curl_read_callback</name>
--<digest></digest>
--<desc>
--</desc>
--<param>
--<type>atom</type>
--<name>ptr</name>
--<desc></desc>
--</param>
--<param>
--<type>atom</type>
--<name>size</name>
--<desc></desc>
--</param>
--<param>
--<type>atom</type>
--<name>nmemb</name>
--<desc></desc>
--</param>
--<param>
--<type>atom</type>
--<name>stream</name>
--<desc></desc>
--</param>
--<return>
--</return>
--<example>
--</example>
--<see_also>
--</see_also>
--</function>
--  stream = stream -- stop warning
  poke(ptr, ram_space[stream])
  return size * nmemb
end function

--------------------------------------------------------------------------------

-- typedef curl_socket_t
-- (*curl_opensocket_callback)(void *clientp,
--                             curlsocktype purpose,
--                             struct curl_sockaddr *address);

--------------------------------------------------------------------------------

-- typedef int
-- (*curl_closesocket_callback)(void *clientp, curl_socket_t item);

--------------------------------------------------------------------------------

-- typedef curlioerr (*curl_ioctl_callback)(CURL *handle,
--                                 --       int cmd,
--                                 --       void *clientp);

--------------------------------------------------------------------------------

-- typedef int (*curl_debug_callback)
--        (CURL *handle,      -- the handle/transfer this concerns
--         curl_infotype type, -- what kind of data
--         char *data,        -- points to the data
--         size_t size,       -- size of the data pointed to
--         void *userptr);    -- whatever the user please

--------------------------------------------------------------------------------

-- This prototype applies to all conversion callbacks
--
-- typedef CURLcode (*curl_conv_callback)(char *buffer, size_t length);

--------------------------------------------------------------------------------

-- typedef CURLcode (*curl_ssl_ctx_callback)(CURL *curl,     -- easy handle
--                                 --        void *ssl_ctx,  -- actually an
--                                 --                        -- OpenSSL SSL_CTX
--                                 --        void *userptr);

--------------------------------------------------------------------------------

-- typedef int
--   (*curl_sshkeycallback) (CURL *easy,     -- easy handle
--                           const struct curl_khkey *knownkey, -- known
--                           const struct curl_khkey *foundkey, -- found
--                           public enum curl_khmatch, -- libcurl's view on the keys
--                           void *clientp); -- custom pointer passed from app

--------------------------------------------------------------------------------

-- callback public function for curl_formget()
-- The void *arg pointer will be the one passed as second argument to
--   curl_formget().
-- The character buffer passed to it must not be freed.
-- Should return the buffer length passed to it as the argument "len" on
--   success.

-- typedef size_t (*curl_formget_callback)(void *arg, const char *buf,
--                                 --      size_t len);

--------------------------------------------------------------------------------

-- typedef void (*curl_lock_function)(CURL *handle,
--                                 -- curl_lock_data data,
--                                 -- curl_lock_access locktype,
--                                 -- void *userptr);
-- typedef void (*curl_unlock_function)(CURL *handle,
--                                 --   curl_lock_data data,
--                                 --   void *userptr);




--------------------------------------------------------------------------------
-- LIBCURL ROUTINES
--------------------------------------------------------------------------------

public function curl_strequal(sequence s1, sequence s2)
--<function>
--<name>curl_strequal</name>
--<digest>checks whether two strings are equal.</digest>
--<desc>subject for removal in a future libcurl</desc>
--<param>
--<type>sequence</type>
--<name>s1</name>
--<desc>first string to compare</desc>
--</param>
--<param>
--<type>sequence</type>
--<name>s2</name>
--<desc>second string to compare</desc>
--</param>
--<return>
-- integer
-- * 1 ; the strings are identical.
-- * 0 ; the strings are different.
--</return>
--<example>
-- ? curl_strequal("first", "first")
-- 1
-- ? curl_strequal("first", "first2")
-- 0
--</example>
--<see_also>curl_strnequal</see_also>
--</function>
  atom addr_s1, addr_s2
  integer ret

  if not xcurl_strequal then
    xcurl_strequal = register_routine(libcurl, "+curl_strequal",
                                      CURL_ROUTINE_DEFINITION)
  end if
  addr_s1 = allocate_string(s1)
  addr_s2 = allocate_string(s2)
  ret = c_func(xcurl_strequal, {addr_s1, addr_s2})
  free(addr_s1)
  free(addr_s2)
  return ret
end function

--------------------------------------------------------------------------------

public function curl_strnequal(sequence s1, sequence s2, atom n)
--<function>
--<name>curl_strnequal</name>
--<digest>checks whether the first n chars of two strings are equal.</digest>
--<desc>subject for removal in a future libcurl</desc>
--<param>
--<type>sequence</type>
--<name>s1</name>
--<desc>first string to compare.</desc>
--</param>
--<param>
--<type>sequence</type>
--<name>s2</name>
--<desc>second string to compare.</desc>
--</param>
--<param>
--<type>atom</type>
--<name>n</name>
--<desc>number of chars to compare</desc>
--</param>
--<return>
-- integer
-- * 1 ; the first n chars of the strings are identical.
-- * 0 ; the first n chars of the strings are different.
--</return>
--<example>
-- ? curl_strnequal("first", "first2", 5)
-- 1
--</example>
--<see_also>curl_strequal</see_also>
--</function>
  atom addr_s1, addr_s2
  integer ret

  if not xcurl_strnequal then
    xcurl_strnequal = register_routine(libcurl, "+curl_strnequal",
                                       CURL_ROUTINE_DEFINITION)
  end if
  addr_s1 = allocate_string(s1)
  addr_s2 = allocate_string(s2)
  ret = c_func(xcurl_strnequal, {addr_s1, addr_s2, n})
  free(addr_s1)
  free(addr_s2)
  return ret
end function

--------------------------------------------------------------------------------

public function curl_formadd(atom httppost, atom last_post, atom param)
--<function>
--<name>curl_formadd</name>
--<digest></digest>
--<desc>
-- Pretty advanced public function for building multi-part formposts. Each
-- invoke adds one part that together construct a full post.
-- Then use CURLOPT_HTTPPOST to send it off to libcurl.
--</desc>
--<param>
--<type>atom</type>
--<name>httppost</name>
--<desc>address of a pointer on a struct curl_httppost</desc>
--</param>
--<param>
--<type>atom</type>
--<name>last_post</name>
--<desc>address of a pointer on a struct curl_httppost</desc>
--</param>
--<param>
--<type>atom</type>
--<name>param</name>
--<desc>?</desc>
--</param>
--<return>
-- integer
--</return>
--<example>
--</example>
--<see_also>curl_formget, curl_formfree</see_also>
--</function>
  if not xcurl_formadd then
    xcurl_formadd = register_routine(libcurl, "+curl_formadd",
                                     CURL_ROUTINE_DEFINITION)
  end if
  return c_func(xcurl_formadd, {httppost, last_post, param})
end function

--------------------------------------------------------------------------------

public function curl_formget(atom form, atom arg, atom app)
--<function>
--<name>curl_formget</name>
--<digest>Serialize a curl_httppost struct built with curl_formadd().</digest>
--<desc>
-- Accepts a void pointer as second argument which will be passed to
-- the curl_formget_callback public function.
--</desc>
--<param>
--<type>atom</type>
--<name>form</name>
--<desc></desc>
--</param>
--<param>
--<type>atom</type>
--<name>arg</name>
--<desc></desc>
--</param>
--<param>
--<type>atom</type>
--<name>app</name>
--<desc>curl_formget_callback</desc>
--</param>
--<return>
-- Returns 0 on success.
--</return>
--<example>
--</example>
--<see_also>
--</see_also>
--</function>
  if not xcurl_formget then
    xcurl_formget = register_routine(libcurl, "+curl_formget",
                                     CURL_ROUTINE_DEFINITION)
  end if
  return c_func(xcurl_formget, {form, arg, app})
end function

--------------------------------------------------------------------------------

public procedure curl_formfree(atom form)
--<procedure>
--<name>curl_formfree</name>
--<digest>Free a multipart formpost previously built with curl_formadd().</digest>
--<desc>
--</desc>
--<param>
--<type>atom</type>
--<name>form</name>
--<desc></desc>
--</param>
--<return>
--</return>
--<example>
--</example>
--<see_also>
--</see_also>
--</procedure>
  if not xcurl_formfree then
    xcurl_formfree = register_routine(libcurl, "+curl_formfree",
                                      CURL_ROUTINE_DEFINITION)
  end if
  c_proc(xcurl_formfree, {form})
end procedure

--------------------------------------------------------------------------------

public function curl_getenv(sequence variable)
--<function>
--<name>curl_getenv</name>
--<digest></digest>
--<desc>DEPRECATED</desc>
--<param>
--<type>sequence</type>
--<name>variable</name>
--<desc></desc>
--</param>
--<return>
--</return>
--<example>
-- puts(1, curl_getenv("SystemRoot") & "\n")
-- C:\WINDOWS
--</example>
--<see_also>
--</see_also>
--</function>
  atom addr, ret
  sequence s

  if not xcurl_getenv then
    xcurl_getenv = register_routine(libcurl, "+curl_getenv",
                                    CURL_ROUTINE_DEFINITION)
  end if
  addr = allocate_string(variable)
  ret = c_func(xcurl_getenv, {addr})
  s = peek_string(ret)
  free(addr)
  return s
end function

--------------------------------------------------------------------------------

public function curl_version()
--<function>
--<name>curl_version</name>
--<digest>Returns a static ascii string of the libcurl version.</digest>
--<desc>
--</desc>
--<return>
--</return>
--<example>
-- puts(1, curl_version() & "\n")
-- libcurl/7.50.3 WinSSL zlib/1.2.8
--</example>
--<see_also>
--</see_also>
--</function>
  atom ret

  if not xcurl_version then
    xcurl_version = register_routine(libcurl, "+curl_version",
                                     CURL_ROUTINE_DEFINITION)
  end if
  ret = c_func(xcurl_version, {})
  return peek_string(ret)
end function

--------------------------------------------------------------------------------

--**

public function curl_easy_escape(atom handle, sequence string)
--<function>
--<name>curl_easy_escape</name>
--<digest>Escapes URL strings</digest>
--<desc>
-- Converts all letters consider illegal in URLs to their %XX versions
--</desc>
--<param>
--<type>atom</type>
--<name>handle</name>
--<desc></desc>
--</param>
--<param>
--<type>sequence</type>
--<name>string</name>
--<desc></desc>
--</param>
--<return>
-- Returns a new allocated string or NULL if an error occurred.
--</return>
--<example>
-- request = "https://www.google.fr/search?q=élégant"
-- puts(1, curl_easy_escape(curl, request) & "\n")
-- https%3A%2F%2Fwww.google.fr%2Fsearch%3Fq%3D%E9l%E9gant
--</example>
--<see_also>
--</see_also>
--</function>
  atom addr, ret
  sequence s

  if not xcurl_easy_escape then
    xcurl_easy_escape = register_routine(libcurl, "+curl_easy_escape",
                                         CURL_ROUTINE_DEFINITION)
  end if
  addr = allocate_string(string)
  ret = c_func(xcurl_easy_escape, {handle, addr, length(string)})
  s = peek_string(ret)
  free(addr)
  return s
end function

--------------------------------------------------------------------------------

public function curl_escape(sequence string)
--<function>
--<name>curl_escape</name>
--<digest></digest>
--<desc>
-- the previous version
--</desc>
--<param>
--<type>sequence</type>
--<name>string</name>
--<desc></desc>
--</param>
--<return>
--</return>
--<example>
-- request = "https://www.google.fr/search?q=élégant"
-- puts(1, curl_escape(request) & "\n")
-- https%3A%2F%2Fwww.google.fr%2Fsearch%3Fq%3D%E9l%E9gant
--</example>
--<see_also>
--</see_also>
--</function>
  atom addr, ret
  sequence s

  if not xcurl_escape then
    xcurl_escape = register_routine(libcurl, "+curl_escape",
                                    CURL_ROUTINE_DEFINITION)
  end if
  addr = allocate_string(string)
  ret = c_func(xcurl_escape, {addr, length(string)})
  s = peek_string(ret)
  free(addr)
  return s
end function

--------------------------------------------------------------------------------

public function curl_easy_unescape(atom handle, sequence string)
--<function>
--<name>curl_easy_unescape</name>
--<digest>Unescapes URL encoding in strings</digest>
--<desc>
-- Converts all %XX codes to their 8bit versions.
-- Conversion Note: On non-ASCII platforms the ASCII %XX codes are
-- converted into the host encoding.
--</desc>
--<param>
--<type>atom</type>
--<name>handle</name>
--<desc></desc>
--</param>
--<param>
--<type>sequence</type>
--<name>string</name>
--<desc></desc>
--</param>
--<return>
-- Returns a new allocated string or NULL if an error occurred.
--</return>
--<example>
-- s = "https%3A%2F%2Fwww.google.fr%2Fsearch%3Fq%3D%E9l%E9gant"
-- puts(f_debug, curl_easy_unescape(curl, s) & "\n")
-- https://www.google.fr/search?q=élégant  (utf-8)
--</example>
--<see_also>
--</see_also>
--</function>
  atom addr, len, ret
  sequence s

  if not xcurl_easy_unescape then
    xcurl_easy_unescape = register_routine(libcurl, "+curl_easy_unescape",
                                           CURL_ROUTINE_DEFINITION)
  end if
  addr = allocate_string(string)
  len = allocate(4)
  ret = c_func(xcurl_easy_unescape, {handle, addr, length(string), len})
  s = peek_string(ret)
  free(addr)
  free(len)
  return s
end function

--------------------------------------------------------------------------------

public function curl_unescape(sequence string)
--<function>
--<name>curl_unescape</name>
--<digest></digest>
--<desc>
-- the previous version
--</desc>
--<param>
--<type>sequence</type>
--<name>string</name>
--<desc></desc>
--</param>
--<return>
--</return>
--<example>
-- s = "https%3A%2F%2Fwww.google.fr%2Fsearch%3Fq%3D%E9l%E9gant"
-- puts(f_debug, curl_easy_unescape(curl, s) & "\n")
-- https://www.google.fr/search?q=élégant  (utf-8)
--</example>
--<see_also>
--</see_also>
--</function>
  atom addr, ret
  sequence s

  if not xcurl_unescape then
    xcurl_unescape = register_routine(libcurl, "+curl_unescape",
                                      CURL_ROUTINE_DEFINITION)
  end if
  addr = allocate_string(string)
  ret = c_func(xcurl_unescape, {addr, length(string)})
  s = peek_string(ret)
  free(addr)
  return s
end function

--------------------------------------------------------------------------------

public procedure curl_free(atom p)
--<procedure>
--<name>curl_free</name>
--<digest></digest>
--<desc>
-- Provided for de-allocation in the same translation unit that did the
-- allocation.
--</desc>
--<param>
--<type>atom</type>
--<name>p</name>
--<desc></desc>
--</param>
--<return>
--</return>
--<example>
--</example>
--<see_also>
--</see_also>
--</procedure>
  if not xcurl_free then
    xcurl_free = register_routine(libcurl, "+curl_free",
                                  CURL_ROUTINE_DEFINITION)
  end if
  c_proc(xcurl_free, {p})
end procedure

--------------------------------------------------------------------------------

public function curl_global_init(atom flags)
--<function>
--<name>curl_global_init</name>
--<digest></digest>
--<desc>
-- curl_global_init() should be invoked exactly once for each application that
-- uses libcurl and before any call of other libcurl functions.
--
-- This public function is not thread-safe!
--</desc>
--<param>
--<type>atom</type>
--<name>flags</name>
--<desc></desc>
--</param>
--<return>
--</return>
--<example>
-- res = curl_global_init(CURL_GLOBAL_DEFAULT)
--</example>
--<see_also>
--</see_also>
--</function>
  if not xcurl_global_init then
    xcurl_global_init = register_routine(libcurl, "+curl_global_init",
                                         CURL_ROUTINE_DEFINITION)
  end if
  return c_func(xcurl_global_init, {flags})
end function

--------------------------------------------------------------------------------

-- NAME curl_global_init_mem()
--
-- DESCRIPTION
--
-- curl_global_init() or curl_global_init_mem() should be invoked exactly once
-- for each application that uses libcurl.  This public function can be used to
-- initialize libcurl and set user defined memory management callback
-- functions.  Users can implement memory management routines to check for
-- memory leaks, check for mis-use of the curl library etc.  User registered
-- callback routines with be invoked by this library instead of the system
-- memory management routines like malloc, free etc.
--
--  if not xcurl_global_init_mem then
--    xcurl_global_init_mem = register_routine(libcurl, "+curl_global_init_mem",
--                                             CURL_ROUTINE_DEFINITION)
--  end if

--------------------------------------------------------------------------------

public function curl_slist_append(atom slist, sequence string)
--<function>
--<name>curl_slist_append</name>
--<digest>Appends a string to a linked list.</digest>
--<desc>If no list exists, it will be created first.</desc>
--<param>
--<type>atom</type>
--<name>slist</name>
--<desc></desc>
--</param>
--<param>
--<type>sequence</type>
--<name>string</name>
--<desc></desc>
--</param>
--<return>
-- Returns the new list, after appending.
--</return>
--<example>
-- slist = curl_slist_append(NULL, "toto")
-- slist = curl_slist_append(slist, "titi")
--</example>
--<see_also>
--</see_also>
--</function>
  atom addr, ret

  if not xcurl_slist_append then
    xcurl_slist_append = register_routine(libcurl, "+curl_slist_append",
                                          CURL_ROUTINE_DEFINITION)
  end if
  addr = allocate_string(string)
  ret = c_func(xcurl_slist_append, {slist, addr})
  free(addr)
  return ret
end function

--------------------------------------------------------------------------------

public procedure curl_slist_free_all(atom slist)
--<procedure>
--<name>curl_slist_free_all</name>
--<digest>free a previously built curl_slist.</digest>
--<desc>
--</desc>
--<param>
--<type>atom</type>
--<name>slist</name>
--<desc></desc>
--</param>
--<return>
--</return>
--<example>
-- curl_slist_free_all(slist)
--</example>
--<see_also>
--</see_also>
--</procedure>
  if not xcurl_slist_free_all then
    xcurl_slist_free_all = register_routine(libcurl, "+curl_slist_free_all",
                                            CURL_ROUTINE_DEFINITION)
  end if
  c_proc(xcurl_slist_free_all, {slist})
end procedure

--------------------------------------------------------------------------------

public function peek_curl_slist( atom slist, integer max )
--<function>
--<name>peek_curl_slist</name>
--<digest>return the content of a slist as a sequence</digest>
--<desc>
--</desc>
--<param>
--<type>atom</type>
--<name>slist</name>
--<desc></desc>
--</param>
--<param>
--<type>integer</type>
--<name>max</name>
--<desc></desc>
--</param>
--<return>
--</return>
--<example>
-- slist = curl_slist_append(NULL, "toto")
-- slist = curl_slist_append(slist, "titi")
-- slist = curl_slist_append(slist, "tata")
-- analyze_object(peek_curl_slist(slist, -1), "slist")
-- slist =
-- .  [1] "toto"
-- .  [2] "titi"
-- .  [3] "tata"
--</example>
--<see_also>
--</see_also>
--</function>
  sequence strings, str, s
  atom next

  log_puts("peek_curl_slist\n")
  strings = {}
  log_printf("slist = %d\n", slist)
  if slist = NULL then return strings end if
  next = slist
  while next != NULL do
    s = peek_pointer({next,2})
    analyze_object(s, sprintf("item@%d",next), f_debug)
    if s[1] = NULL then return strings end if
    str = peek_string( s[1] )
    analyze_object(str, "str", f_debug)
    strings = append( strings, str )
    if (max != -1) and (length(strings) = max) then exit end if
    next = s[2]
    log_printf("next = %d\n", next)
--    if next = NULL then return strings end if
  end while
  return strings
end function

--------------------------------------------------------------------------------

public procedure curl_global_cleanup()
--<procedure>
--<name>curl_global_cleanup</name>
--<digest></digest>
--<desc>
-- curl_global_cleanup() should be invoked exactly once for each application
-- that uses libcurl
--</desc>
--<example>
-- curl_global_cleanup()
--</example>
--<see_also>
--</see_also>
--</procedure>
  if not xcurl_global_cleanup then
    xcurl_global_cleanup = register_routine(libcurl, "+curl_global_cleanup",
                                            CURL_ROUTINE_DEFINITION)
  end if
  c_proc(xcurl_global_cleanup, {})
end procedure

--------------------------------------------------------------------------------

public function curl_getdate(sequence string)
--<function>
--<name>curl_getdate</name>
--<digest></digest>
--<desc>
-- Returns the time, in seconds since 1 Jan 1970 of the time string given in
-- the first argument. The time argument in the second parameter is unused
-- and should be set to NULL.
--</desc>
--<param>
--<type>sequence</type>
--<name>string</name>
--<desc></desc>
--</param>
--<return>
--</return>
--<example>
--</example>
--<see_also>
--</see_also>
--</function>
  atom addr, ret

  if not xcurl_getdate then
    xcurl_getdate = register_routine(libcurl, "+curl_getdate",
                                     CURL_ROUTINE_DEFINITION)
  end if
  addr = allocate_string(string)
  ret = c_func(xcurl_getdate, {addr, NULL})
  free(addr)
  return ret
end function

--------------------------------------------------------------------------------

public function curl_version_info()
--<function>
--<name>curl_version_info</name>
--<digest>returns a pointer to a static copy of the version info struct.</digest>
--<desc>
--</desc>
--<return>
--</return>
--<example>
--</example>
--<see_also>
--</see_also>
--</function>
  if not xcurl_version_info then
    xcurl_version_info = register_routine(libcurl, "+curl_version_info",
                                          CURL_ROUTINE_DEFINITION)
  end if
  return c_func(xcurl_version_info, {CURLVERSION_NOW})
end function

--------------------------------------------------------------------------------

public function curl_easy_strerror(integer code)
--<function>
--<name>curl_easy_strerror</name>
--<digest>turns a CURLcode value into the equivalent human readable error string.</digest>
--<desc>
-- This is useful for printing meaningful error messages.
--</desc>
--<param>
--<type>integer</type>
--<name>code</name>
--<desc></desc>
--</param>
--<return>
--</return>
--<example>
--</example>
--<see_also>
--</see_also>
--</function>
  atom ret

  if not xcurl_easy_strerror then
    xcurl_easy_strerror = register_routine(libcurl, "+curl_easy_strerror",
                                           CURL_ROUTINE_DEFINITION)
  end if
  ret = c_func(xcurl_easy_strerror, {code})
  return peek_string(ret)
end function

--------------------------------------------------------------------------------

public function curl_easy_pause(atom handle, integer bitmask)
--<function>
--<name>curl_easy_pause</name>
--<digest>pauses or unpauses transfers.</digest>
--<desc>
-- Select the new state by setting the bitmask, use the convenience defines.
--</desc>
--<param>
--<type>atom</type>
--<name>handle</name>
--<desc></desc>
--</param>
--<param>
--<type>integer</type>
--<name>bitmask</name>
--<desc></desc>
--</param>
--<return>
--</return>
--<example>
--</example>
--<see_also>
--</see_also>
--</function>
  if not xcurl_easy_pause then
    xcurl_easy_pause = register_routine(libcurl, "+curl_easy_pause",
                                        CURL_ROUTINE_DEFINITION)
  end if
  return c_func(xcurl_easy_pause, {handle, bitmask})
end function

--------------------------------------------------------------------------------

public function curl_easy_init()
--<function>
--<name>curl_easy_init</name>
--<digest></digest>
--<desc>
--</desc>
--<return>
--</return>
--<example>
-- curl = curl_easy_init()
-- if curl then
--   -- do some stuff
-- end if
--</example>
--<see_also>
--</see_also>
--</function>
  if not xcurl_easy_init then
    xcurl_easy_init = register_routine(libcurl, "+curl_easy_init",
                                       CURL_ROUTINE_DEFINITION)
  end if
  return c_func(xcurl_easy_init, {})
end function

--------------------------------------------------------------------------------

public procedure curl_easy_setopt(atom curl, integer option, object param)
--<procedure>
--<name>curl_easy_setopt</name>
--<digest></digest>
--<desc>
--</desc>
--<param>
--<type>atom</type>
--<name>curl</name>
--<desc></desc>
--</param>
--<param>
--<type>integer</type>
--<name>option</name>
--<desc></desc>
--</param>
--<param>
--<type>object</type>
--<name>param</name>
--<desc></desc>
--</param>
--<return>
--</return>
--<example>
-- curl_easy_setopt(curl, CURLOPT_PROXYTYPE, CURLPROXY_HTTP)
-- curl_easy_setopt(curl, CURLOPT_PROXY, "")
-- curl_easy_setopt(curl, CURLOPT_COOKIEFILE, InitialDir & SLASH & "cookies.txt")
-- curl_easy_setopt(curl, CURLOPT_COOKIEJAR, InitialDir & SLASH & "cookies.txt")
-- curl_easy_setopt(curl, CURLOPT_VERBOSE, 1)
-- curl_easy_setopt(curl, CURLOPT_URL, "https://edf-70ans.r1a.eu/landing")
-- curl_easy_setopt(curl, CURLOPT_FOLLOWLOCATION, 1)
-- curl_easy_setopt(curl, CURLOPT_HTTPHEADER, "Connection: keep-alive")
-- curl_easy_setopt(curl, CURLOPT_SSL_VERIFYPEER, 0)
--</example>
--<see_also>
--</see_also>
--</procedure>
  integer code
  object o

  if not xcurl_easy_setopt then
    xcurl_easy_setopt = register_routine(libcurl, "+curl_easy_setopt",
                                         CURL_ROUTINE_DEFINITION)
  end if
  if find(option, {
    CURLOPT_ACCEPT_ENCODING, CURLOPT_CAINFO, CURLOPT_CAPATH, CURLOPT_COOKIE,
    CURLOPT_COOKIEFILE, CURLOPT_COOKIEJAR, CURLOPT_COOKIELIST,
    CURLOPT_COPYPOSTFIELDS, CURLOPT_CRLFILE, CURLOPT_CUSTOMREQUEST,
    CURLOPT_DEFAULT_PROTOCOL, CURLOPT_DNS_INTERFACE, CURLOPT_DNS_LOCAL_IP4,
    CURLOPT_DNS_LOCAL_IP6, CURLOPT_DNS_SERVERS, CURLOPT_EGDSOCKET,
    CURLOPT_FTP_ACCOUNT, CURLOPT_FTP_ALTERNATIVE_TO_USER,
    CURLOPT_FTPPORT, CURLOPT_INTERFACE, CURLOPT_ISSUERCERT, CURLOPT_KEYPASSWD,
    CURLOPT_KRBLEVEL, CURLOPT_LOGIN_OPTIONS, CURLOPT_MAIL_AUTH,
    CURLOPT_MAIL_FROM, CURLOPT_NETRC_FILE, CURLOPT_NOPROXY, CURLOPT_PASSWORD,
    CURLOPT_PINNEDPUBLICKEY, CURLOPT_POSTFIELDS, CURLOPT_PREQUOTE,
    CURLOPT_PROXY, CURLOPT_PROXY_SERVICE_NAME, CURLOPT_PROXYPASSWORD,
    CURLOPT_PROXYUSERNAME, CURLOPT_PROXYUSERPWD, CURLOPT_RANDOM_FILE,
    CURLOPT_RANGE, CURLOPT_REFERER, CURLOPT_RTSP_SESSION_ID,
    CURLOPT_RTSP_STREAM_URI, CURLOPT_RTSP_TRANSPORT, CURLOPT_SERVICE_NAME,
    CURLOPT_SOCKS5_GSSAPI_SERVICE, CURLOPT_SSH_HOST_PUBLIC_KEY_MD5,
    CURLOPT_SSH_KNOWNHOSTS, CURLOPT_SSH_PRIVATE_KEYFILE,
    CURLOPT_SSH_PUBLIC_KEYFILE, CURLOPT_SSL_CIPHER_LIST, CURLOPT_SSLCERT,
    CURLOPT_SSLCERTTYPE, CURLOPT_SSLENGINE, CURLOPT_SSLKEY,
    CURLOPT_SSLKEYTYPE, CURLOPT_TLSAUTH_PASSWORD, CURLOPT_TLSAUTH_TYPE,
    CURLOPT_TLSAUTH_USERNAME, CURLOPT_UNIX_SOCKET_PATH, CURLOPT_URL,
    CURLOPT_USERAGENT, CURLOPT_USERNAME, CURLOPT_USERPWD,
    CURLOPT_XOAUTH2_BEARER}
  ) then  -- char *
    if atom(param) then  -- NULL
      code = c_func(xcurl_easy_setopt, {curl, option, param})
    else
      code = c_func(xcurl_easy_setopt, {curl, option, allocate_string(param)})
    end if

  elsif option = CURLOPT_ERRORBUFFER then  -- char *
    code = c_func(xcurl_easy_setopt, {curl, option, param})

  elsif find(option, {
    CURLOPT_CHUNK_BGN_FUNCTION, CURLOPT_CHUNK_END_FUNCTION,
    CURLOPT_CLOSESOCKETFUNCTION, CURLOPT_CONV_FROM_NETWORK_FUNCTION,
    CURLOPT_CONV_FROM_UTF8_FUNCTION, CURLOPT_CONV_TO_NETWORK_FUNCTION,
    CURLOPT_DEBUGFUNCTION, CURLOPT_FNMATCH_FUNCTION, CURLOPT_HEADERFUNCTION,
    CURLOPT_INTERLEAVEFUNCTION, CURLOPT_IOCTLFUNCTION,
    CURLOPT_OPENSOCKETFUNCTION, CURLOPT_PROGRESSFUNCTION,
    CURLOPT_READFUNCTION, CURLOPT_SEEKFUNCTION, CURLOPT_SOCKOPTFUNCTION,
    CURLOPT_SSH_KEYFUNCTION, CURLOPT_SSL_CTX_FUNCTION, CURLOPT_WRITEFUNCTION,
    CURLOPT_XFERINFOFUNCTION}
  ) then  -- callback
--    code = c_func(xcurl_easy_setopt, {curl, option, cdecl_callback(param)})
    code = c_func(xcurl_easy_setopt, {curl, option, param})

  elsif find(option, {
    CURLOPT_STREAM_DEPENDS, CURLOPT_STREAM_DEPENDS_E}
  ) then  -- CURL *
    code = c_func(xcurl_easy_setopt, {curl, option, param})

  elsif find(option, {
    CURLOPT_INFILESIZE_LARGE, CURLOPT_MAX_RECV_SPEED_LARGE,
    CURLOPT_MAX_SEND_SPEED_LARGE, CURLOPT_MAXFILESIZE_LARGE,
    CURLOPT_POSTFIELDSIZE_LARGE, CURLOPT_RESUME_FROM_LARGE}
  ) then  -- curl_off_t
    code = c_func(xcurl_easy_setopt, {curl, option, param})

--  elsif option = CURLOPT_SHARE then   -- CURLSH *
--    code = c_func(xcurl_easy_setopt, {curl, option, param})

  elsif option = CURLOPT_STDERR then  -- FILE *
    code = c_func(xcurl_easy_setopt, {curl, option, param})

  elsif find(option, {
    CURLOPT_ACCEPTTIMEOUT_MS, CURLOPT_ADDRESS_SCOPE, CURLOPT_APPEND,
    CURLOPT_AUTOREFERER, CURLOPT_BUFFERSIZE, CURLOPT_CERTINFO,
    CURLOPT_CONNECT_ONLY, CURLOPT_CONNECTTIMEOUT, CURLOPT_CONNECTTIMEOUT_MS,
    CURLOPT_COOKIESESSION, CURLOPT_CRLF, CURLOPT_DIRLISTONLY,
    CURLOPT_DNS_CACHE_TIMEOUT, CURLOPT_DNS_USE_GLOBAL_CACHE,
    CURLOPT_EXPECT_100_TIMEOUT_MS, CURLOPT_FAILONERROR, CURLOPT_FILETIME,
    CURLOPT_FOLLOWLOCATION, CURLOPT_FORBID_REUSE, CURLOPT_FRESH_CONNECT,
    CURLOPT_FTP_CREATE_MISSING_DIRS, CURLOPT_FTP_FILEMETHOD,
    CURLOPT_FTP_RESPONSE_TIMEOUT, CURLOPT_FTP_SKIP_PASV_IP,
    CURLOPT_FTP_SSL_CCC, CURLOPT_FTP_USE_EPRT, CURLOPT_FTP_USE_EPSV,
    CURLOPT_FTP_USE_PRET, CURLOPT_FTPSSLAUTH, CURLOPT_GSSAPI_DELEGATION,
    CURLOPT_HEADER, CURLOPT_HEADEROPT, CURLOPT_HTTP_CONTENT_DECODING,
    CURLOPT_HTTP_TRANSFER_DECODING, CURLOPT_HTTP_VERSION, CURLOPT_HTTPAUTH,
    CURLOPT_HTTPGET, CURLOPT_HTTPPROXYTUNNEL, CURLOPT_IGNORE_CONTENT_LENGTH,
    CURLOPT_INFILESIZE, CURLOPT_IPRESOLVE, CURLOPT_LOCALPORT,
    CURLOPT_LOCALPORTRANGE, CURLOPT_LOW_SPEED_LIMIT, CURLOPT_LOW_SPEED_TIME,
    CURLOPT_MAXCONNECTS, CURLOPT_MAXFILESIZE, CURLOPT_MAXREDIRS,
    CURLOPT_NETRC, CURLOPT_NEW_DIRECTORY_PERMS, CURLOPT_NEW_FILE_PERMS,
    CURLOPT_NOBODY, CURLOPT_NOPROGRESS, CURLOPT_NOSIGNAL, CURLOPT_PATH_AS_IS,
    CURLOPT_PIPEWAIT, CURLOPT_PORT, CURLOPT_POST, CURLOPT_POSTFIELDSIZE,
    CURLOPT_POSTREDIR, CURLOPT_PROTOCOLS, CURLOPT_PROXY_TRANSFER_MODE,
    CURLOPT_PROXYAUTH, CURLOPT_PROXYPORT, CURLOPT_PROXYTYPE, CURLOPT_PUT,
    CURLOPT_REDIR_PROTOCOLS, CURLOPT_RESUME_FROM, CURLOPT_RTSP_CLIENT_CSEQ,
    CURLOPT_RTSP_REQUEST, CURLOPT_RTSP_SERVER_CSEQ, CURLOPT_SASL_IR,
    CURLOPT_SOCKS5_GSSAPI_NEC, CURLOPT_SSH_AUTH_TYPES,
    CURLOPT_SSL_ENABLE_ALPN, CURLOPT_SSL_ENABLE_NPN, CURLOPT_SSL_FALSESTART,
    CURLOPT_SSL_OPTIONS, CURLOPT_SSL_SESSIONID_CACHE, CURLOPT_SSL_VERIFYHOST,
    CURLOPT_SSL_VERIFYPEER, CURLOPT_SSL_VERIFYSTATUS,
    CURLOPT_SSLENGINE_DEFAULT, CURLOPT_SSLVERSION, CURLOPT_STREAM_WEIGHT,
    CURLOPT_TCP_FASTOPEN, CURLOPT_TCP_KEEPALIVE, CURLOPT_TCP_KEEPIDLE,
    CURLOPT_TCP_KEEPINTVL, CURLOPT_TCP_NODELAY, CURLOPT_TFTP_BLKSIZE,
    CURLOPT_TFTP_NO_OPTIONS, CURLOPT_TIMECONDITION, CURLOPT_TIMEOUT,
    CURLOPT_TIMEOUT_MS, CURLOPT_TIMEVALUE, CURLOPT_TRANSFER_ENCODING,
    CURLOPT_TRANSFERTEXT, CURLOPT_UNRESTRICTED_AUTH, CURLOPT_UPLOAD,
    CURLOPT_USE_SSL, CURLOPT_VERBOSE, CURLOPT_WILDCARDMATCH}
  ) then  -- long
    code = c_func(xcurl_easy_setopt, {curl, option, param})

  elsif option = CURLOPT_HTTPPOST then  -- struct curl_httppost *
    code = c_func(xcurl_easy_setopt, {curl, option, param})

  elsif find(option, {
    CURLOPT_CONNECT_TO, CURLOPT_HTTP200ALIASES, CURLOPT_HTTPHEADER,
    CURLOPT_MAIL_RCPT, CURLOPT_POSTQUOTE, CURLOPT_PROXYHEADER,
    CURLOPT_QUOTE, CURLOPT_RESOLVE, CURLOPT_TELNETOPTIONS}
  ) then  -- struct curl_slist *
    curl_options_list = curl_slist_append(curl_options_list, param)
    code = c_func(xcurl_easy_setopt, {curl, option, curl_options_list})

  elsif find(option, {
    CURLOPT_CHUNK_DATA, CURLOPT_CLOSESOCKETDATA, CURLOPT_DEBUGDATA,
    CURLOPT_FNMATCH_DATA, CURLOPT_HEADERDATA, CURLOPT_INTERLEAVEDATA,
    CURLOPT_IOCTLDATA, CURLOPT_OPENSOCKETDATA, CURLOPT_PRIVATE,
    CURLOPT_PROGRESSDATA, CURLOPT_READDATA, CURLOPT_SEEKDATA,
    CURLOPT_SOCKOPTDATA, CURLOPT_SSH_KEYDATA, CURLOPT_SSL_CTX_DATA,
    CURLOPT_WRITEDATA, CURLOPT_XFERINFODATA}
  ) then  -- void *
    code = c_func(xcurl_easy_setopt, {curl, option, param})

  end if
  if (code != CURLE_OK) then
    o = vlookup(option, SETOPT_OPTIONS, 1, 2, {})
    if atom(o) then
      error_message(sprintf("Unknown option '%d'", {option}), 1)
    else
      error_message(sprintf("Failed to set option '%s'", {o}), 1)
    end if
  end if
end procedure

--------------------------------------------------------------------------------

public function curl_easy_perform(atom curl)
--<function>
--<name>curl_easy_perform</name>
--<digest></digest>
--<desc>
--</desc>
--<param>
--<type>atom</type>
--<name>curl</name>
--<desc></desc>
--</param>
--<return>
--</return>
--<example>
-- curl_easy_setopt(curl, CURLOPT_PROXYTYPE, CURLPROXY_HTTP)
-- curl_easy_setopt(curl, CURLOPT_PROXY, "")
-- curl_easy_setopt(curl, CURLOPT_RESOLVE, "example.com")
-- curl_easy_setopt(curl, CURLOPT_URL, "http://example.com")
-- curl_easy_setopt(curl, CURLOPT_VERBOSE, 1)
-- curl_easy_setopt(curl, CURLOPT_NOPROGRESS, 1)
-- res = curl_easy_perform(curl)
-- if (res != CURLE_OK) then
--   printf(2, "curl_easy_perform() failed: %s\n",
--             {curl_easy_strerror(res)})
-- else
--   puts(1, "curl_easy_perform() succeeded\n")
-- end if
--</example>
--<see_also>
--</see_also>
--</function>
  if not xcurl_easy_perform then
    xcurl_easy_perform = register_routine(libcurl, "+curl_easy_perform",
                                          CURL_ROUTINE_DEFINITION)
  end if
  return c_func(xcurl_easy_perform, {curl})
end function

--------------------------------------------------------------------------------

public procedure curl_easy_cleanup(atom curl)
--<procedure>
--<name>curl_easy_cleanup</name>
--<digest></digest>
--<desc>
--</desc>
--<param>
--<type>atom</type>
--<name>curl</name>
--<desc></desc>
--</param>
--<return>
--</return>
--<example>
-- curl_easy_cleanup(curl)
--</example>
--<see_also>
--</see_also>
--</procedure>
  if not xcurl_easy_cleanup then
    xcurl_easy_cleanup = register_routine(libcurl, "+curl_easy_cleanup",
                                          CURL_ROUTINE_DEFINITION)
  end if
  c_proc(xcurl_easy_cleanup, {curl})
end procedure

--------------------------------------------------------------------------------

public function curl_easy_getinfo(atom curl, integer option)
--<function>
--<name>curl_easy_getinfo</name>
--<digest>request internal information from the curl session</digest>
--<desc>
-- Intended to get used *AFTER* a performed transfer.
-- All results from this public function are undefined until the
-- transfer is completed.
--</desc>
--<param>
--<type>atom</type>
--<name>curl</name>
--<desc></desc>
--</param>
--<param>
--<type>integer</type>
--<name>option</name>
--<desc></desc>
--</param>
--<return>
-- requested data or -1 on error
--</return>
--<example>
-- res = curl_easy_perform_ex(curl)
-- cookies = curl_easy_getinfo(curl, CURLINFO_COOKIELIST)
-- if not length(cookies) then
--   puts(1, "(none)\n")
-- else
--   for i = 1 to length(cookies) do
--     s = split_string(cookies[i], "\t")
--     printf(1, "[%d]: %s = %s\n", {i, s[6], s[7]})
--   end for
-- end if
--</example>
--<see_also>
--</see_also>
--</function>
  atom ret, param
  object o, res
  
  if not xcurl_easy_getinfo then
    xcurl_easy_getinfo = register_routine(libcurl, "+curl_easy_getinfo",
                                          CURL_ROUTINE_DEFINITION)
  end if
  if find(option, {
    CURLINFO_APPCONNECT_TIME, CURLINFO_CONNECT_TIME,
	CURLINFO_CONTENT_LENGTH_DOWNLOAD, CURLINFO_CONTENT_LENGTH_UPLOAD,
	CURLINFO_NAMELOOKUP_TIME, CURLINFO_PRETRANSFER_TIME, CURLINFO_REDIRECT_TIME,
	CURLINFO_SIZE_DOWNLOAD, CURLINFO_SIZE_UPLOAD, CURLINFO_SPEED_DOWNLOAD,
	CURLINFO_SPEED_UPLOAD, CURLINFO_STARTTRANSFER_TIME, CURLINFO_TOTAL_TIME}
  ) then  -- DOUBLE
    param = allocate(8)

  elsif find(option, {
    CURLINFO_CONDITION_UNMET, CURLINFO_FILETIME, CURLINFO_HEADER_SIZE,
	CURLINFO_HTTP_CONNECTCODE, CURLINFO_HTTP_VERSION, CURLINFO_HTTPAUTH_AVAIL,
	CURLINFO_LASTSOCKET, CURLINFO_LOCAL_PORT, CURLINFO_NUM_CONNECTS,
	CURLINFO_OS_ERRNO, CURLINFO_PRIMARY_PORT, CURLINFO_PROXYAUTH_AVAIL,
	CURLINFO_REDIRECT_COUNT, CURLINFO_REQUEST_SIZE, CURLINFO_RESPONSE_CODE,
	CURLINFO_RTSP_CLIENT_CSEQ, CURLINFO_RTSP_CSEQ_RECV,
	CURLINFO_RTSP_SERVER_CSEQ, CURLINFO_SSL_VERIFYRESULT}
  ) then  -- LONG
    param = allocate(4)

  elsif find(option, {
    CURLINFO_CERTINFO, CURLINFO_COOKIELIST, CURLINFO_SSL_ENGINES,
	CURLINFO_TLS_SESSION, CURLINFO_TLS_SSL_PTR}
  ) then  -- SLIST
    param = curl_slist_append(NULL, "")
--    param = NULL

  elsif option = CURLINFO_ACTIVESOCKET then  -- SOCKET
    param = allocate(4)

  elsif find(option, {
    CURLINFO_CONTENT_TYPE, CURLINFO_EFFECTIVE_URL, CURLINFO_FTP_ENTRY_PATH,
	CURLINFO_LOCAL_IP, CURLINFO_PRIMARY_IP, CURLINFO_PRIVATE,
	CURLINFO_REDIRECT_URL, CURLINFO_RTSP_SESSION_ID}
  ) then  -- STRING
    param = allocate_string("")

  end if
  
  res = -1
  ret = c_func(xcurl_easy_getinfo, {curl, option, param})
--  analyze_object(ret, "ret", f_debug)
  
  if ret = CURLE_UNKNOWN_OPTION then
    o = vlookup(option, GETINFO_OPTIONS, 1, 2, {})
    if atom(o) then
      error_message(sprintf("Unknown option '%d'", {option}), 1)
    else
      error_message(sprintf("Unknown option '%s'", {o[2]}), 1)
    end if
  end if

  if find(option, {
    CURLINFO_CONTENT_TYPE, CURLINFO_EFFECTIVE_URL,
    CURLINFO_FTP_ENTRY_PATH, CURLINFO_LOCAL_IP,
    CURLINFO_PRIMARY_IP, CURLINFO_PRIVATE,
    CURLINFO_REDIRECT_URL, CURLINFO_RTSP_SESSION_ID}
  ) then  -- char **
    if ret = CURLE_OK then
      res = peek_string(peek_pointer(param))
    else
      log_printf("Curl curl_easy_getinfo failed: %s\n",
             {curl_easy_strerror(ret)})
      res = -1
    end if
    free(param)

  elsif option = CURLINFO_ACTIVESOCKET then  -- curl_socket_t *
    if ret = CURLE_OK then
      res = peek4u(param)
    else
      log_printf("Curl curl_easy_getinfo failed: %s\n",
             {curl_easy_strerror(ret)})
      res = -1
    end if
    free(param)

  elsif find(option, {
    CURLINFO_APPCONNECT_TIME, CURLINFO_CONNECT_TIME,
    CURLINFO_CONTENT_LENGTH_DOWNLOAD, CURLINFO_CONTENT_LENGTH_UPLOAD,
    CURLINFO_NAMELOOKUP_TIME, CURLINFO_PRETRANSFER_TIME,
    CURLINFO_REDIRECT_TIME, CURLINFO_SIZE_DOWNLOAD,
    CURLINFO_SIZE_UPLOAD, CURLINFO_SPEED_DOWNLOAD, CURLINFO_SPEED_UPLOAD,
    CURLINFO_STARTTRANSFER_TIME, CURLINFO_TOTAL_TIME}
  ) then  -- double *
    if ret = CURLE_OK then
      res = float64_to_atom(peek({param,8}))  -- peek8s(param)
    else
      log_printf("Curl curl_easy_getinfo failed: %s\n",
             {curl_easy_strerror(ret)})
      res = -1
    end if
    free(param)

  elsif find(option, {
    CURLINFO_CONDITION_UNMET, CURLINFO_FILETIME, CURLINFO_HEADER_SIZE,
    CURLINFO_HTTP_CONNECTCODE, CURLINFO_HTTP_VERSION,
    CURLINFO_HTTPAUTH_AVAIL, CURLINFO_LASTSOCKET, CURLINFO_LOCAL_PORT,
    CURLINFO_NUM_CONNECTS, CURLINFO_OS_ERRNO, CURLINFO_PRIMARY_PORT,
    CURLINFO_PROXYAUTH_AVAIL, CURLINFO_REDIRECT_COUNT,
    CURLINFO_REQUEST_SIZE, CURLINFO_RESPONSE_CODE,
    CURLINFO_RTSP_CLIENT_CSEQ, CURLINFO_RTSP_CSEQ_RECV,
    CURLINFO_RTSP_SERVER_CSEQ, CURLINFO_SSL_VERIFYRESULT}
  ) then  -- long *
    if ret = CURLE_OK then
      res = peek4s(param)
    else
      log_printf("Curl curl_easy_getinfo failed: %s\n",
             {curl_easy_strerror(ret)})
      res = -1
    end if
    free(param)

  elsif option = CURLINFO_CERTINFO then  -- struct curl_certinfo *
    if ret = CURLE_OK then
      analyze_object(param, "param", f_debug)
      o = peek_pointer({peek_pointer(param),2})
      analyze_object(o, "o", f_debug)
      if o[2] then
        res = peek_curl_slist(peek_pointer(o[2]), -1)
        curl_slist_free_all(param)
      end if
    else
      log_printf("Curl curl_easy_getinfo failed: %s\n",
             {curl_easy_strerror(ret)})
      res = -1
    end if

  elsif find(option, {
    CURLINFO_COOKIELIST, CURLINFO_SSL_ENGINES}
  ) then  -- struct curl_slist **
    if ret = CURLE_OK then
      res = peek_curl_slist(peek_pointer(param), -1)
    else
      log_printf("Curl curl_easy_getinfo failed: %s\n",
             {curl_easy_strerror(ret)})
      res = -1
    end if
    curl_slist_free_all(param)


  elsif find(option, {
    CURLINFO_TLS_SESSION, CURLINFO_TLS_SSL_PTR}
  ) then  -- struct curl_tlssessioninfo **
    if ret = CURLE_OK then
      res = peek_curl_slist(peek_pointer(param), -1)
    else
      log_printf("Curl curl_easy_getinfo failed: %s\n",
             {curl_easy_strerror(ret)})
      res = -1
    end if
    curl_slist_free_all(param)

  end if
  return res
end function

--------------------------------------------------------------------------------

public function curl_easy_duphandle(atom curl)
--<function>
--<name>curl_easy_duphandle</name>
--<digest></digest>
--<desc>
-- Creates a new curl session handle with the same options set for the handle
-- passed in. Duplicating a handle could only be a matter of cloning data and
-- options, internal state info and things like persistent connections cannot
-- be transferred. It is useful in multithreaded applications when you can run
-- curl_easy_duphandle() for each new thread to avoid a series of identical
-- curl_easy_setopt() invokes in every thread.
--</desc>
--<param>
--<type>atom</type>
--<name>curl</name>
--<desc></desc>
--</param>
--<return>
--</return>
--<example>
--</example>
--<see_also>
--</see_also>
--</function>
  if not xcurl_easy_duphandle then
    xcurl_easy_duphandle = register_routine(libcurl, "+curl_easy_duphandle",
                                            CURL_ROUTINE_DEFINITION)
  end if
  return c_func(xcurl_easy_duphandle, {curl})
end function

--------------------------------------------------------------------------------

public procedure curl_easy_reset(atom curl)
--<procedure>
--<name>curl_easy_reset</name>
--<digest></digest>
--<desc>
-- Re-initializes a CURL handle to the default values. This puts back the
-- handle to the same state as it was in when it was just created.
--
-- It does keep: live connections, the Session ID cache, the DNS cache and the
-- cookies.
--</desc>
--<param>
--<type>atom</type>
--<name>curl</name>
--<desc></desc>
--</param>
--<return>
--</return>
--<example>
-- curl_easy_reset(curl)
--</example>
--<see_also>
--</see_also>
--</procedure>
  if not xcurl_easy_reset then
    xcurl_easy_reset = register_routine(libcurl, "+curl_easy_reset",
                                        CURL_ROUTINE_DEFINITION)
  end if
  c_proc(xcurl_easy_reset, {curl})
end procedure

--------------------------------------------------------------------------------

public function curl_easy_recv(atom curl, atom buffer, integer buflen)
--<function>
--<name>curl_easy_recv</name>
--<digest></digest>
--<desc>
-- Receives data from the connected socket. Use after successful
-- curl_easy_perform() with CURLOPT_CONNECT_ONLY option.
--</desc>
--<param>
--<type>atom</type>
--<name>curl</name>
--<desc></desc>
--</param>
--<param>
--<type>atom</type>
--<name>buffer</name>
--<desc></desc>
--</param>
--<param>
--<type>integer</type>
--<name>buflen</name>
--<desc></desc>
--</param>
--<return>
--</return>
--<example>
--</example>
--<see_also>
--</see_also>
--</function>
  atom addr, ret
  integer len

  if not xcurl_easy_recv then
    xcurl_easy_recv = register_routine(libcurl, "+curl_easy_recv",
                                       CURL_ROUTINE_DEFINITION)
  end if
  addr = allocate(4)
  ret = c_func(xcurl_easy_recv, {curl, buffer, buflen, addr})
  len = peek4s(addr)
  free(addr)
  return {ret, buffer, len}
end function

--------------------------------------------------------------------------------

public function curl_easy_send(atom curl, atom buffer, integer buflen)
--<function>
--<name>curl_easy_send</name>
--<digest></digest>
--<desc>
-- Sends data over the connected socket. Use after successful
-- curl_easy_perform() with CURLOPT_CONNECT_ONLY option.
--</desc>
--<param>
--<type>atom</type>
--<name>curl</name>
--<desc></desc>
--</param>
--<param>
--<type>atom</type>
--<name>buffer</name>
--<desc></desc>
--</param>
--<param>
--<type>integer</type>
--<name>buflen</name>
--<desc></desc>
--</param>
--<return>
--</return>
--<example>
--</example>
--<see_also>
--</see_also>
--</function>
  atom addr, ret
  integer len

  if not xcurl_easy_send then
    xcurl_easy_send = register_routine(libcurl, "+curl_easy_send",
                                       CURL_ROUTINE_DEFINITION)
  end if
  addr = allocate(4)
  ret = c_func(xcurl_easy_send, {curl, buffer, buflen, addr})
  len = peek4s(addr)
  free(addr)
  return {ret, len}
end function

--------------------------------------------------------------------------------

public function curl_extract_cookies( sequence headers, integer raw=0 )
--<function>
--<name>curl_extract_cookies</name>
--<digest>extract cookies from sequence of headers</digest>
--<desc>
--   option raw defaults to no (only cookie name and value returned)
--   only last header is considered in case of redirection
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
-- res = curl_easy_perform_ex(curl)
-- cookies = curl_extract_cookies(res[3], 1)
-- analyze_object(cookies, "cookies")
--
-- cookies = curl_extract_cookies(res[3])
-- analyze_object(cookies, "cookies", f_debug)
--</example>
--<see_also></see_also>
--</function>
  sequence result, s, cookie
  integer p
  
  result = {}
  if length(headers) = 0 then return {} end if
  for i = 1 to length(headers[$]) do
    if begins("Set-Cookie:", headers[$][i]) then
      if raw then
        result = append(result, headers[$][i])
      else
        s = headers[$][i][13..$]
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

public function curl_extract_csrf_token( sequence content )
--<function>
--<name>curl_extract_csrf_token</name>
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
--    res = curl_easy_perform_ex(curl)
--    token = curl_extract_csrf_token(res[4])
--</example>
--<see_also></see_also>
--</function>
  object o
  sequence token

  if length(content) = 0 then return "" end if
  o = find_all_text(content, "<meta", "/>", 1)
  if atom(o) then return "" end if
  analyze_object(o, "o", f_debug)
  for i = 1 to length(o) do
    if match("name=\"csrf-token\"", o[i]) then
      token = get_attribute_value("content", o[i])
      return dequote(token, {})
    end if
  end for
  return ""
end function

--------------------------------------------------------------------------------

public function curl_easy_perform_ex( atom handle )
--<function>
--<name>curl_easy_perform_ex</name>
--<digest>gets a page</digest>
--<desc>
-- in case of redirection, if CURLOPT_FOLLOWLOCATION is set, there may be many
-- headers and URL returned may be different than original URL
--</desc>
--<param>
--<type>atom</type>
--<name>handle</name>
--<desc>CURL session handle</desc>
--</param>
--<return>
-- sequence
-- * status  : HTTP status
-- * url     : effective URL (useful if redirection is followed)
-- * headers : sequence of headers
-- * content : HTML Page content
--</return>
--<example>
-- curl_easy_setopt(curl, CURLOPT_URL, "https://edf-70ans.r1a.eu/landing")
-- curl_easy_setopt(curl, CURLOPT_FOLLOWLOCATION, 1)
-- curl_easy_setopt(curl, CURLOPT_SSL_VERIFYPEER, 0)
-- res = curl_easy_perform_ex(curl)
-- printf(1, "Status: %d\n", {res[1]})
-- printf(1, "Effective URL: %s\n", {res[2]})
-- analyze_object(res[3], "Headers", f_debug)
-- analyze_object(res[4], "Content", f_debug)
--</example>
--<see_also>curl_easy_perform</see_also>
--</function>
  atom write_cb, pcontent, pheaders, result
  sequence content, headers, url, s, section
  object status

  write_cb = cdecl_callback(routine_id("curl_write_callback"))
  curl_easy_setopt(handle, CURLOPT_HEADERFUNCTION, write_cb)
  curl_easy_setopt(handle, CURLOPT_WRITEFUNCTION,  write_cb)

  pheaders = memAlloc( "" )
  pcontent = memAlloc( "" )
  curl_easy_setopt(handle, CURLOPT_HEADERDATA, pheaders)
  curl_easy_setopt(handle, CURLOPT_WRITEDATA,  pcontent )

  result = curl_easy_perform( handle )
  if (result != CURLE_OK) then
    error_message(sprintf("Curl perform failed: %s\n",
                          {curl_easy_strerror(result)}),
                  1)
  end if

  status = curl_easy_getinfo(handle, CURLINFO_RESPONSE_CODE)
  url = curl_easy_getinfo(handle, CURLINFO_EFFECTIVE_URL)
  content = join(ram_space[pcontent], "")
  headers = join(ram_space[pheaders], "")
--  s = ram_space[pheaders]
--  headers = {}
--  section = {}
--  for i = 1 to length(s) do
--    if equal(s[i], "\r\n") then
--      headers = append(headers, section)
--      section = {}
--    else
--      section = append(section, trim(s[i]))
--    end if
--  end for
  memFree( pheaders )
  memFree( pcontent )

  return {status, url, headers, content}
end function

--------------------------------------------------------------------------------

function curl_send(atom curl)
  object res

  res = curl_easy_perform_ex(curl)
  if f_debug and with_debug then
    log_printf("Status: %d\n", {res[HTTP_STATUS]})
    log_printf("Effective URL: %s\n", {res[HTTP_URL]})
    analyze_object(res[HTTP_HEADERS], "Headers", f_debug)
    analyze_object(res[HTTP_BODY], "Content", f_debug)
  end if
  return res
end function

--------------------------------------------------------------------------------

public function curl_get(atom curl, sequence url)
--<function>
--<name>curl_get</name>
--<digest>sends a GET request to an URL and gets the page</digest>
--<desc>
-- intended to be used with REST APIs
--</desc>
--<param>
--<type>atom</type>
--<name>handle</name>
--<desc>CURL session handle</desc>
--</param>
--<param>
--<type>sequence</type>
--<name>url</name>
--<desc>URL to get the page from</desc>
--</param>
--<return>
-- sequence
-- * status  : HTTP status
-- * url     : effective URL (useful if redirection is followed)
-- * headers : sequence of headers
-- * content : HTML Page content
--</return>
--<example>
-- curl_easy_setopt(curl, CURLOPT_FOLLOWLOCATION, 1)
-- curl_easy_setopt(curl, CURLOPT_SSL_VERIFYPEER, 0)
-- res = curl_get(curl, "https://edf-70ans.r1a.eu/landing")
-- printf(1, "Status: %d\n", {res[1]})
-- printf(1, "Effective URL: %s\n", {res[2]})
-- analyze_object(res[3], "Headers", f_debug)
-- analyze_object(res[4], "Content", f_debug)
--</example>
--<see_also>curl_easy_perform, curl_post, curl_delete</see_also>
--</function>
  log_puts("\nGET " & object_dump(url) & "\n")
  curl_easy_setopt(curl, CURLOPT_URL, url)
--    curl_easy_setopt(curl, CURLOPT_POSTFIELDS, NULL)
  curl_easy_setopt(curl, CURLOPT_POSTFIELDSIZE, 0)
  curl_easy_setopt(curl, CURLOPT_POST, 0)

  return curl_send(curl)
end function

--------------------------------------------------------------------------------

public function curl_post(atom curl, sequence url, object data)
--<function>
--<name>curl_post</name>
--<digest>sends a POST request to an URL and gets the page</digest>
--<desc>
-- intended to be used with REST APIs
--</desc>
--<param>
--<type>atom</type>
--<name>handle</name>
--<desc>CURL session handle</desc>
--</param>
--<param>
--<type>sequence</type>
--<name>url</name>
--<desc>URL to get the page from</desc>
--</param>
--<param>
--<type>sequence</type>
--<name>data</name>
--<desc>data to send in the body of the request</desc>
--</param>
--<return>
-- sequence
-- * status  : HTTP status
-- * url     : effective URL (useful if redirection is followed)
-- * headers : sequence of headers
-- * content : HTML Page content
--</return>
--<example>
  -- object res = curl_post(curl, CHROME_DRIVER & "/session/" & sessionId & "/timeouts/implicit_wait", "{" &
  --                   "\"sessionId\": \"" & sessionId & "\", " &
  --                   sprintf("\"ms\": %d", ms) &
  --                 "}")
-- printf(1, "Status: %d\n", {res[1]})
-- printf(1, "Effective URL: %s\n", {res[2]})
-- analyze_object(res[3], "Headers", f_debug)
-- analyze_object(res[4], "Content", f_debug)
--</example>
--<see_also>curl_easy_perform, curl_easy_perform_ex, curl_get, curl_delete</see_also>
--</function>
  log_puts("\nPOST " & object_dump(url) & " " & object_dump(data) & "\n")
  curl_easy_setopt(curl, CURLOPT_URL, url)
  curl_easy_setopt(curl, CURLOPT_POST, 1)
  curl_easy_setopt(curl, CURLOPT_POSTFIELDS, data)
--    curl_easy_setopt(curl, CURLOPT_POSTFIELDSIZE, length(data))

  return curl_send(curl)
end function

--------------------------------------------------------------------------------

public function curl_delete(atom curl, sequence url)
--<function>
--<name>curl_delete</name>
--<digest>sends a DELETE request to an URL and gets the page</digest>
--<desc>
-- intended to be used with REST APIs
--</desc>
--<param>
--<type>atom</type>
--<name>handle</name>
--<desc>CURL session handle</desc>
--</param>
--<param>
--<type>sequence</type>
--<name>url</name>
--<desc>URL to get the page from</desc>
--</param>
--<return>
-- sequence
-- * status  : HTTP status
-- * url     : effective URL (useful if redirection is followed)
-- * headers : sequence of headers
-- * content : HTML Page content
--</return>
--<example>
-- object res = curl_delete(curl, CHROME_DRIVER & "/session/" & sessionId)
--</example>
--<see_also>curl_easy_perform, curl_easy_perform_ex, curl_post, curl_get</see_also>
--</function>
  log_puts("\nDELETE " & object_dump(url) & "\n")
  curl_easy_setopt(curl, CURLOPT_URL, url)
--  curl_easy_setopt(curl, CURLOPT_POSTFIELDS, NULL)
  curl_easy_setopt(curl, CURLOPT_POSTFIELDSIZE, 0)
  curl_easy_setopt(curl, CURLOPT_POST, 0)
  curl_easy_setopt(curl, CURLOPT_CUSTOMREQUEST, "DELETE")

  return curl_send(curl)
end function
