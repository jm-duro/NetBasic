include std/dll.e
include std/filesys.e
include std/sequence.e
include lib/_machine_.e
include lib/_debug_.e
include lib/_curl_constants_.e
include lib/_curl_.e
include std/console.e

constant
  COOKIE_DOMAIN = 1, COOKIE_FLAG = 2, COOKIE_PATH = 3, COOKIE_SECURE = 4,
  COOKIE_EXPIRATION = 5, COOKIE_NAME = 6, COOKIE_VALUE = 7

function write_callback( atom ptr, atom size, atom nmemb, atom stream )
  atom realsize
  sequence data

  realsize = size * nmemb
  data = peek({ ptr, realsize })
  puts(stream, data)
  return realsize
end function

  atom write_cb
  integer pagefile

sequence s, s2, request
object res
atom curl
atom slist
  sequence token, cookies

f_debug = open("debug.log", "w")
with_debug = 1

-- function curl_read_callback(atom ptr, atom size, atom nmemb, atom stream)

? curl_strequal("first", "first")
-- 1

? curl_strequal("first", "first2")
-- 0

? curl_strnequal("first", "first2", 5)
-- 1

-- function curl_formadd(atom httppost, atom last_post, atom param)

-- function curl_formget(atom form, atom arg, atom app)

-- procedure curl_formfree(atom form)

puts(1, curl_getenv("SystemRoot") & "\n")
-- C:\WINDOWS

puts(1, curl_version() & "\n")
-- libcurl/7.50.3 WinSSL zlib/1.2.8

request = "https://www.google.fr/search?q=élégant"

res = curl_global_init(CURL_GLOBAL_DEFAULT)
curl = curl_easy_init()
printf(1, "curl = %d\n", curl)
-- curl = 35529856
if curl then
  s = curl_easy_escape(curl, request)
  puts(1, s & "\n")
  -- https%3A%2F%2Fwww.google.fr%2Fsearch%3Fq%3D%E9l%E9gant

  puts(1, curl_escape(request) & "\n")
  -- https%3A%2F%2Fwww.google.fr%2Fsearch%3Fq%3D%E9l%E9gant

  puts(f_debug, curl_easy_unescape(curl, s) & "\n")
  -- https://www.google.fr/search?q=élégant  (utf-8)

  puts(f_debug, curl_unescape(s) & "\n")
  -- https://www.google.fr/search?q=élégant  (utf-8)


-- procedure curl_free(atom p)

  slist = curl_slist_append(NULL, "toto")
  slist = curl_slist_append(slist, "titi")
  slist = curl_slist_append(slist, "tata")
  analyze_object(peek_curl_slist(slist, -1), "slist")

--  curl_slist_free_all(slist)
--  analyze_object(peek_curl_slist(slist, -1), "slist")

-- function curl_getdate(sequence string)

-- function curl_version_info()

-- function curl_easy_strerror(integer code)

-- function curl_easy_pause(atom handle, integer bitmask)

    curl_easy_setopt(curl, CURLOPT_PROXYTYPE, CURLPROXY_HTTP)
    curl_easy_setopt(curl, CURLOPT_PROXY, "")
    curl_easy_setopt(curl, CURLOPT_COOKIEFILE, InitialDir & SLASH & "cookies.txt")
    curl_easy_setopt(curl, CURLOPT_COOKIEJAR, InitialDir & SLASH & "cookies.txt")
    curl_easy_setopt(curl, CURLOPT_VERBOSE, 1)
    curl_easy_setopt(curl, CURLOPT_URL, "https://edf-70ans.r1a.eu/landing")
    curl_easy_setopt(curl, CURLOPT_FOLLOWLOCATION, 1)
    curl_easy_setopt(curl, CURLOPT_HTTPHEADER, "Connection: keep-alive")
    curl_easy_setopt(curl, CURLOPT_SSL_VERIFYPEER, 0)

    res = curl_easy_perform_ex(curl)

    printf(1, "Status: %d\n", {res[1]})
    printf(1, "Effective URL: %s\n", {res[2]})
    analyze_object(res[3], "Headers", f_debug)
    analyze_object(res[4], "Content", f_debug)

    cookies = curl_easy_getinfo(curl, CURLINFO_COOKIELIST)
    if not length(cookies) then
      puts(1, "(none)\n")
    else
      for i = 1 to length(cookies) do
         s = split(cookies[i], "\t")
        printf(1, "[%d]: %s = %s\n", {i, s[COOKIE_NAME], s[COOKIE_VALUE]})
      end for
    end if

    cookies = curl_extract_cookies(res[3], 1)
    analyze_object(cookies, "cookies")

    cookies = curl_extract_cookies(res[3])
    analyze_object(cookies, "cookies", f_debug)

    token = curl_extract_csrf_token(res[4])
    if length(token) then
      puts(1, "CRSF token: " & token & "\n")
    else
      puts(1, "CRSF token: (none)\n")
    end if

    curl_easy_reset(curl)

    curl_easy_setopt(curl, CURLOPT_PROXYTYPE, CURLPROXY_HTTP)
    curl_easy_setopt(curl, CURLOPT_PROXY, "")
    curl_easy_setopt(curl, CURLOPT_RESOLVE, "example.com")
    curl_easy_setopt(curl, CURLOPT_URL, "http://example.com")
    curl_easy_setopt(curl, CURLOPT_VERBOSE, 1)
    curl_easy_setopt(curl, CURLOPT_NOPROGRESS, 1)

    write_cb = cdecl_callback(routine_id("write_callback"))
    curl_easy_setopt(curl, CURLOPT_WRITEFUNCTION, write_cb )
    pagefile = open(InitialDir & SLASH & "page.html", "wb")
    if  (pagefile) then
      curl_easy_setopt(curl, CURLOPT_WRITEDATA, pagefile)
      res = curl_easy_perform(curl)
      if (res != CURLE_OK) then
        printf(2, "curl_easy_perform() failed: %s\n",
               {curl_easy_strerror(res)})
      else
        puts(1, "curl_easy_perform() succeeded\n")
      end if
      close(pagefile)
    end if

-- function curl_easy_duphandle(atom curl)

-- function curl_easy_recv(atom curl, atom buffer, integer buflen)

-- function curl_easy_send(atom curl, atom buffer, integer buflen)

  curl_easy_cleanup(curl)
end if

curl_global_cleanup()

close(f_debug)

integer ok

maybe_any_key()

