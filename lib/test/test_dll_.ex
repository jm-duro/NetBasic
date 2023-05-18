include std/dll.e
include std/machine.e
include std/console.e
include lib/_debug_.e
include lib/_dll_.e
include lib/_machine_.e

constant CURL_LIBRARY_DEFINITION = {
  {
    "libcurl",                                -- L_NAME
    "/usr/lib/x86_64-linux-gnu/libcurl.so.4", -- L_LNX_64
    "/usr/lib/i386-linux-gnu/libcurl.so.4",   -- L_LNX_32
    InitialDir & "\\libcurl.dll",             -- L_WIN_64
    InitialDir & "\\libcurl.dll"              -- L_WIN_32
  }
}

constant CURL_ROUTINE_DEFINITION = {
  {"curl_getenv",       {pointer}, pointer},
  {"curl_version_info", {pointer}, pointer}
}

? size_of(pointer)

atom p, hwnd, libcurl, xcurl_version_info
sequence structure

structure = {pointer, int, float}
p = NULL
p = allocate_structure(p, structure)
? p

hwnd = allocate(4)
? hwnd
poke4(hwnd, 9999)

write_structure(p, structure, {hwnd, 12, 25.2} )
? peek4u(peek_pointer(p))

analyze_object(read_structure(p, structure), "read_structure")

free_structure(p, structure, {hwnd, 0, 0} )
? peek4u(peek_pointer(p))

libcurl = register_library("libcurl", CURL_LIBRARY_DEFINITION)

xcurl_version_info = register_routine(libcurl, "curl_version_info",
                                 CURL_ROUTINE_DEFINITION)

p = c_func(xcurl_version_info, {3})
? peek_string(p)

integer ok

maybe_any_key()

