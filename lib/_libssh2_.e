-- Copyright (c) 2004-2009, Sara Golemon <sarag@libssh2.org>
-- Copyright (c) 2009 by Daniel Stenberg
-- Copyright (c) 2010 Simon Josefsson <simon@josefsson.org>
-- All rights reserved.
--
-- Redistribution and use in source and binary forms,
-- with or without modification, are permitted provided
-- that the following conditions are met:
--
-- Redistributions of source code must retain the above
-- copyright notice, this list of conditions and the
-- following disclaimer.
--
-- Redistributions in binary form must reproduce the above
-- copyright notice, this list of conditions and the following
-- disclaimer in the documentation and/or other materials
-- provided with the distribution.
--
-- Neither the name of the copyright holder nor the names
-- of any other contributors may be used to endorse or
-- promote products derived from this software without
-- specific prior written permission.
--
-- THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND
-- CONTRIBUTORS "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES,
-- INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES
-- OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE
-- ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT OWNER OR
-- CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL,
-- SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING,
-- BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR
-- SERVICES LOSS OF USE, DATA, OR PROFITS OR BUSINESS
-- INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY,
-- WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING
-- NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE
-- USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY
-- OF SUCH DAMAGE.
--

include std/dll.e
include std/machine.e
public include _libssh2_constants_.e
include _dll_.e

constant
  libssh2_uint64_t = uint64,
  libssh2_int64_t = int64

-- Malloc callbacks

-- type
--   _LIBSSH2_SESSION = record
--   end
--  _LIBSSH2_CHANNEL  = record
--   end
--  _LIBSSH2_LISTENER = record
--   end
--  _LIBSSH2_KNOWNHOSTS = record
--   end
--  _LIBSSH2_AGENT = record
--   end
--
-- type
--   LIBSSH2_SESSION = _LIBSSH2_SESSION
--   LIBSSH2_CHANNEL = _LIBSSH2_CHANNEL
--   LIBSSH2_LISTENER = _LIBSSH2_LISTENER
--   LIBSSH2_KNOWNHOSTS = _LIBSSH2_KNOWNHOSTS
--   LIBSSH2_AGENT = _LIBSSH2_AGENT

constant
  PLIBSSH2_SESSION    = pointer,
  PLIBSSH2_CHANNEL    = pointer,
  PLIBSSH2_LISTENER   = pointer,
  PLIBSSH2_KNOWNHOSTS = pointer,
  PLIBSSH2_AGENT      = pointer
--
-- type
--   _LIBSSH2_USERAUTH_KBDINT_PROMPT = record
--     text: pointer
--     length: UInt
--     echo: byte
--   end {_LIBSSH2_USERAUTH_KBDINT_PROMPT}
--   LIBSSH2_USERAUTH_KBDINT_PROMPT = _LIBSSH2_USERAUTH_KBDINT_PROMPT
--   PLIBSSH2_USERAUTH_KBDINT_PROMPT = ^LIBSSH2_USERAUTH_KBDINT_PROMPT
--
-- type
--   _LIBSSH2_USERAUTH_KBDINT_RESPONSE = record
--     text: pointer
--     length: UInt
--   end {_LIBSSH2_USERAUTH_KBDINT_RESPONSE}
--   LIBSSH2_USERAUTH_KBDINT_RESPONSE = _LIBSSH2_USERAUTH_KBDINT_RESPONSE
--
-- -- 'publickey' authentication callback--
-- type
--  LIBSSH2_USERAUTH_PUBLICKEY_SIGN_FUNC = function(
--   atom session, var sig: PByte sig_len: size_t
--            global constant data: PByte data_len: size_t abstract: pointer): int cdecl
--
-- -- 'keyboard-interactive' authentication callback*/
-- type
--   LIBSSH2_USERAUTH_KBDINT_RESPONSE_FUNC = procedure (global constant name: pointer
--                 name_len: int
--                 global constant instruction: pointer
--                 instruction_len: int
--                 num_prompts: int
--                 global constant prompts: PLIBSSH2_USERAUTH_KBDINT_PROMPT
--                 var responses: LIBSSH2_USERAUTH_KBDINT_RESPONSE
--                 abstract: pointer) cdecl
-- -- Callbacks for special SSH packets*/
-- type
--   LIBSSH2_IGNORE_FUNC = procedure (atom session,
--                global constant message: pointer
--                message_len: int
--                abstract: pointer) cdecl
-- type
--   LIBSSH2_DEBUG_FUNC = procedure (atom session,
--                always_display: int
--                global constant message: pointer
--                message_len: int
--                global constant language: pointer
--                language_len: int
--                abstract: pointer) cdecl
-- type
--   LIBSSH2_DISCONNECT_FUNC = procedure(atom session,
--                reason: int
--                global constant message: pointer
--                message_len: int
--                global constant language: pointer
--                language_len: int
--                abstract: pointer) cdecl
-- type
--   LIBSSH2_PASSWD_CHANGEREQ_FUNC =  procedure(atom session,
--                var newpw: pointer
--                var newpw_len: int
--                abstract: pointer) cdecl
-- type
--   LIBSSH2_MACERROR_FUNC = function (atom session,
--               global constant packet: pointer
--               packet_len: int
--               abstract: pointer): int cdecl
-- type
--   LIBSSH2_X11_OPEN_FUNC = procedure (atom session,
--                atom channel,
--                global constant shost: pointer
--                sinteger port
--                abstract: pointer) cdecl
-- type
--   LIBSSH2_CHANNEL_CLOSE_FUNC = procedure (atom session,
--                var session_abstract: pointer
--                atom channel,
--                var channel_abstract: pointer) cdecl
--
-- type
--   PLIBSSH2_POLLFD = ^_LIBSSH2_POLLFD
--   _LIBSSH2_POLLFD = record
--     Type: byte
-- --  LIBSSH2_POLLFD_* below
--     socket: int
-- --  File descriptors -- examined with system select() call
--     atom channel,
-- --  Examined by checking internal state
--     listener: PLIBSSH2_LISTENER
-- --  Read polls only -- are inbound
-- -- connections waiting to be accepted?
--   end {fd}
--   LIBSSH2_POLLFD = _LIBSSH2_POLLFD
--
-- type
-- LIBSSH2_ALLOC_FUNC   = function(count: unsigned_int abstract: pointer): pointer cdecl
-- LIBSSH2_REALLOC_FUNC = function(ptr: pointer count: unsigned_int abstract: pointer): pointer cdecl
-- LIBSSH2_FREE_FUNC    = procedure(ptr: pointer abstract: pointer) cdecl
--
-- type
--  Pstruct_stat = ^struct_stat
--  struct_stat = record
--    st_dev: unsigned_int
--    st_ino: Word
--    st_mode: Word
--    st_nlink: Short
--    st_uid: Short
--    st_gid: Short
--    st_rdev: unsigned_int
--    st_size: long_int
--    st_atime: Int64
--    st_mtime: Int64
--    st_ctime: Int64
--  end
--
-- type
-- PLIBSSH2_KNOWNHOST = ^LIBSSH2_KNOWNHOST
-- LIBSSH2_KNOWNHOST = record
--     magic: UInt  -- magic stored by the library--
--     node: pointer -- handle to the internal representation of this host--
--     name: pointer -- this is NULL if no plain text host name exists--
--     key: pointer  -- key in base64/printable format--
--     typemask: int
-- end
--
-- type
--  libssh2_agent_publickey = record
--     magic: UInt         -- magic stored by the library--
--     node: pointer        -- handle to the internal representation of key--
--     blob: PUCHAR       -- public key blob--
--     blob_len: SIZE_T               -- length of the public key blob--
--     comment: pointer                 -- comment in printable format--
--   end
--   PLIBSSH2_AGENT_PUBLICKEY = ^libssh2_agent_publickey
--
-- type
--   LIBSSH2_TRACE_HANDLER_FUNC = procedure(atom session, P: pointer
--     constant C: pointer S: size_t) cdecl
constant
  PLIBSSH2_USERAUTH_KBDINT_PROMPT = pointer,
  PLIBSSH2_POLLFD = pointer,
  PLIBSSH2_KNOWNHOST = pointer,
  PLIBSSH2_AGENT_PUBLICKEY = pointer

constant
  LIBSSH2_USERAUTH_PUBLICKEY_SIGN_FUNC = pointer,
  LIBSSH2_USERAUTH_KBDINT_RESPONSE_FUNC = pointer,
  LIBSSH2_IGNORE_FUNC = pointer,
  LIBSSH2_DEBUG_FUNC = pointer,
  LIBSSH2_DISCONNECT_FUNC = pointer,
  LIBSSH2_PASSWD_CHANGEREQ_FUNC = pointer,
  LIBSSH2_MACERROR_FUNC = pointer,
  LIBSSH2_X11_OPEN_FUNC = pointer,
  LIBSSH2_CHANNEL_CLOSE_FUNC = pointer,
  LIBSSH2_ALLOC_FUNC   = pointer,
  LIBSSH2_REALLOC_FUNC = pointer,
  LIBSSH2_FREE_FUNC    = pointer,
  LIBSSH2_TRACE_HANDLER_FUNC = pointer

-- typedef struct _libssh2_publickey_attribute {
--     const char *name;
--     unsigned long name_len;
--     const char *value;
--     unsigned long value_len;
--     char mandatory;
-- } libssh2_publickey_attribute;

-- typedef struct _libssh2_publickey_list {
--     unsigned char *packet; /* For freeing */
--
--     const unsigned char *name;
--     unsigned long name_len;
--     const unsigned char *blob;
--     unsigned long blob_len;
--     unsigned long num_attrs;
--     libssh2_publickey_attribute *attrs; /* free me */
-- } libssh2_publickey_list;

constant
  PLIBSSH2_PUBLICKEY = pointer

--------------------------------------------------------------------------------

constant LIBSSH2_LIBRARY_DEFINITION = {
  {
    "libssh2", -- L_NAME
    "/usr/lib/x86_64-linux-gnu/libssh2.so", -- L_LNX_64
    0, -- L_LNX_32
    0, -- L_WIN_64
    "libssh2.dll"  -- L_WIN_32
  }
}

atom libssh2
libssh2 = register_library("libssh2", LIBSSH2_LIBRARY_DEFINITION)

--------------------------------------------------------------------------------

constant LIBSSH2_ROUTINE_DEFINITION = {
  {"+libssh2_agent_connect", {PLIBSSH2_AGENT}, int},
  {"+libssh2_agent_disconnect", {PLIBSSH2_AGENT}, int},
  {"+libssh2_agent_get_identity", {PLIBSSH2_AGENT} },
  {"+libssh2_agent_init", {PLIBSSH2_SESSION}, PLIBSSH2_AGENT},
  {"+libssh2_agent_list_identities", {PLIBSSH2_AGENT}, int},
  {"+libssh2_agent_userauth", {PLIBSSH2_AGENT} },
  {"+libssh2_banner_set", {PLIBSSH2_SESSION, pointer}, int},
  {"+libssh2_base64_decode", {PLIBSSH2_SESSION, pointer, pointer, pointer, unsigned_int}, int},
  {"+libssh2_channel_close", {PLIBSSH2_CHANNEL}, int},
  {"+libssh2_channel_direct_tcpip_ex", {PLIBSSH2_SESSION, pointer, int, pointer, int}, PLIBSSH2_CHANNEL},
  {"+libssh2_channel_eof", {PLIBSSH2_CHANNEL}, int},
  {"+libssh2_channel_exec", {PLIBSSH2_CHANNEL, pointer}, int},
  {"+libssh2_channel_flush_ex", {PLIBSSH2_CHANNEL, int}, int},
  {"+libssh2_channel_forward_accept", {PLIBSSH2_LISTENER}, PLIBSSH2_CHANNEL},
  {"+libssh2_channel_forward_cancel", {PLIBSSH2_LISTENER}, int},
  {"+libssh2_channel_forward_listen_ex", {PLIBSSH2_SESSION, pointer, int, pointer, int}, PLIBSSH2_LISTENER},
  {"+libssh2_channel_free", {PLIBSSH2_CHANNEL}, int},
  {"+libssh2_channel_get_exit_status", {PLIBSSH2_CHANNEL}, int},
-- libssh2_channel_get_exit_signal,
  {"+libssh2_channel_handle_extended_data2", {PLIBSSH2_CHANNEL, int}, int},
  {"+libssh2_channel_open_ex", {PLIBSSH2_SESSION, pointer, unsigned_int, unsigned_int, unsigned_int, pointer, unsigned_int}, PLIBSSH2_CHANNEL},
  {"+libssh2_channel_open_session", {PLIBSSH2_SESSION}, PLIBSSH2_CHANNEL},
  {"+libssh2_channel_process_startup", {PLIBSSH2_CHANNEL, pointer, unsigned_int, pointer, unsigned_int}, int},
  {"+libssh2_channel_read_ex", {PLIBSSH2_CHANNEL, int, pointer, size_t}, int},
  {"+libssh2_channel_receive_window_adjust", {PLIBSSH2_CHANNEL, long_int, byte}, long_int},
  {"+libssh2_channel_receive_window_adjust2", {PLIBSSH2_CHANNEL, long_int, byte, pointer}, int},
  {"+libssh2_channel_request_pty_ex", {PLIBSSH2_CHANNEL, pointer, unsigned_int, pointer, unsigned_int, int, int, int, int}, int},
  {"+libssh2_channel_request_pty_size_ex", {PLIBSSH2_CHANNEL, int, int, int, int}, int},
  {"+libssh2_channel_send_eof", {PLIBSSH2_CHANNEL}, int},
  {"+libssh2_channel_setenv_ex", {PLIBSSH2_CHANNEL, pointer, unsigned_int, pointer, unsigned_int}, int},
  {"+libssh2_channel_set_blocking", {PLIBSSH2_CHANNEL, unsigned_int}},
  {"+libssh2_channel_shell", {PLIBSSH2_CHANNEL}, int},
  {"+libssh2_channel_subsystem", {PLIBSSH2_CHANNEL, pointer}, int},
  {"+libssh2_channel_wait_closed", {PLIBSSH2_CHANNEL}, int},
  {"+libssh2_channel_wait_eof", {PLIBSSH2_CHANNEL}, int},
  {"+libssh2_channel_window_read_ex", {PLIBSSH2_CHANNEL, pointer, pointer}, unsigned_long},
  {"+libssh2_channel_window_write_ex", {PLIBSSH2_CHANNEL, pointer}, unsigned_long},
  {"+libssh2_channel_write_ex", {PLIBSSH2_CHANNEL, int, pointer, unsigned_long}, int},
  {"+libssh2_channel_x11_req_ex", {PLIBSSH2_CHANNEL, int, pointer, pointer, int}, int},
  {"+libssh2_exit", {} },
  {"+libssh2_free", {PLIBSSH2_SESSION, pointer} },
  {"+libssh2_hostkey_hash", {PLIBSSH2_SESSION, int}, pointer},
  {"+libssh2_init", {int}, int},
  {"+libssh2_keepalive_send", {PLIBSSH2_SESSION, pointer}, int},
  {"+libssh2_knownhost_add", {PLIBSSH2_KNOWNHOSTS, pointer, pointer, pointer, size_t, int, pointer}, int},
  {"+libssh2_knownhost_addc", {PLIBSSH2_KNOWNHOSTS, pointer, pointer, pointer, size_t, pointer, size_t, int, pointer}, int},
  {"+libssh2_knownhost_check", {PLIBSSH2_KNOWNHOSTS, pointer, pointer, size_t, int, pointer}, int},
  {"+libssh2_knownhost_checkp", {PLIBSSH2_KNOWNHOSTS, pointer, int, pointer, size_t, int, pointer}, int},
  {"+libssh2_knownhost_del", {PLIBSSH2_KNOWNHOSTS, PLIBSSH2_KNOWNHOST}, int},
  {"+libssh2_knownhost_get", {PLIBSSH2_KNOWNHOSTS, pointer, PLIBSSH2_KNOWNHOST}, int},
  {"+libssh2_knownhost_init", {PLIBSSH2_SESSION}, PLIBSSH2_KNOWNHOSTS},
  {"+libssh2_knownhost_readfile", {PLIBSSH2_KNOWNHOSTS, pointer, int}, int},
  {"+libssh2_knownhost_readline", {PLIBSSH2_KNOWNHOSTS, pointer, size_t, int}, int},
  {"+libssh2_knownhost_writefile", {PLIBSSH2_KNOWNHOSTS, pointer, int}, int},
  {"+libssh2_knownhost_writeline", {PLIBSSH2_KNOWNHOSTS, PLIBSSH2_KNOWNHOST, pointer, size_t, pointer, int}, int},
  {"+libssh2_poll", {pointer, unsigned_int, long_int}, int},
  {"+libssh2_poll_channel_read", {PLIBSSH2_CHANNEL, int}, int},
-- libssh2_publickey_add_ex
-- libssh2_publickey_init,
-- libssh2_publickey_list_fetch,
-- libssh2_publickey_list_free,
-- libssh2_publickey_remove_ex
-- libssh2_publickey_shutdown, ,
  {"+libssh2_scp_recv", {PLIBSSH2_SESSION, pointer, pointer}, PLIBSSH2_CHANNEL},
  {"+libssh2_scp_send64", {PLIBSSH2_SESSION, pointer, int, uint64, time_t, time_t}, PLIBSSH2_CHANNEL},
  {"+libssh2_scp_send_ex", {PLIBSSH2_SESSION, pointer, int, size_t, long_int, long_int}, PLIBSSH2_CHANNEL},
  {"+libssh2_session_block_directions", {PLIBSSH2_SESSION}, int},
  {"+libssh2_session_callback_set", {PLIBSSH2_SESSION, int, pointer}, pointer},
  {"+libssh2_session_disconnect_ex", {PLIBSSH2_SESSION, int, pointer, pointer}, int},
  {"+libssh2_session_flag", {PLIBSSH2_SESSION, int, int}, int},
  {"+libssh2_session_free", {PLIBSSH2_SESSION}, int},
  {"+libssh2_session_get_blocking", {PLIBSSH2_SESSION}, int},
  {"+libssh2_session_handshake", {PLIBSSH2_SESSION, pointer}, int},
  {"+libssh2_session_get_timeout", {PLIBSSH2_SESSION}, long},
  {"+libssh2_session_hostkey", {PLIBSSH2_SESSION, pointer, pointer}, pointer},
  {"+libssh2_session_init_ex", {LIBSSH2_ALLOC_FUNC, LIBSSH2_FREE_FUNC, LIBSSH2_REALLOC_FUNC, pointer}, PLIBSSH2_SESSION},
  {"+libssh2_session_last_errno", {PLIBSSH2_SESSION}, int},
  {"+libssh2_session_last_error", {PLIBSSH2_SESSION, pointer, pointer, int}, int},
  {"+libssh2_session_method_pref", {PLIBSSH2_SESSION, int, pointer}, int},
  {"+libssh2_session_methods", {PLIBSSH2_SESSION, int}, pointer},
  {"+libssh2_session_set_blocking", {PLIBSSH2_SESSION, int} },
  {"+libssh2_session_set_timeout", {PLIBSSH2_SESSION, long} },
  {"+libssh2_session_startup", {PLIBSSH2_SESSION, int}, int},
-- libssh2_sftp_close_handle",
-- libssh2_sftp_fstat_ex",
-- libssh2_sftp_fstatvfs",
-- libssh2_sftp_init",
-- libssh2_sftp_last_error",
-- libssh2_sftp_mkdir_ex",
-- libssh2_sftp_open_ex",
-- libssh2_sftp_read",
-- libssh2_sftp_readdir_ex",
-- libssh2_sftp_rename_ex",
-- libssh2_sftp_rmdir_ex",
-- libssh2_sftp_seek",
-- libssh2_sftp_seek64",
-- libssh2_sftp_shutdown",
-- libssh2_sftp_stat_ex",
-- libssh2_sftp_statvfs",
-- libssh2_sftp_symlink_ex",
-- libssh2_sftp_tell",
-- libssh2_sftp_tell64",
-- libssh2_sftp_unlink_ex",
-- libssh2_sftp_write",
  {"+libssh2_trace", {PLIBSSH2_SESSION, int}, int},
  {"+libssh2_trace_sethandler", {PLIBSSH2_SESSION, pointer, LIBSSH2_TRACE_HANDLER_FUNC}, int},
  {"+libssh2_userauth_authenticated", {PLIBSSH2_SESSION}, int},
  {"+libssh2_userauth_hostbased_fromfile_ex", {PLIBSSH2_SESSION, pointer, unsigned_int, pointer, pointer, pointer, pointer, unsigned_int, pointer, unsigned_int}, int},
  {"+libssh2_userauth_keyboard_interactive_ex", {PLIBSSH2_SESSION, pointer, unsigned_int, LIBSSH2_USERAUTH_KBDINT_RESPONSE_FUNC}, int},
  {"+libssh2_userauth_list", {PLIBSSH2_SESSION, pointer, unsigned_int}, pointer},
  {"+libssh2_userauth_password_ex", {PLIBSSH2_SESSION, pointer, unsigned_int, pointer, unsigned_int, LIBSSH2_PASSWD_CHANGEREQ_FUNC}, int},
  {"+libssh2_userauth_publickey", {PLIBSSH2_SESSION, pointer, pointer, pointer, pointer, pointer}, int},
  {"+libssh2_userauth_publickey_fromfile_ex", {PLIBSSH2_SESSION, pointer, unsigned_int, pointer, pointer, pointer}, int},
  {"+libssh2_version", {int}, pointer},
  {"+libssh2_publickey_init", {PLIBSSH2_SESSION}, PLIBSSH2_PUBLICKEY},
  {"+libssh2_publickey_add_ex", {PLIBSSH2_PUBLICKEY, pointer, unsigned_long, pointer, unsigned_long, char, unsigned_long, pointer}, int},
  {"+libssh2_publickey_remove_ex", {PLIBSSH2_PUBLICKEY, pointer, unsigned_long, pointer, unsigned_long}, int},
  {"+libssh2_publickey_list_fetch", {PLIBSSH2_PUBLICKEY, pointer, pointer}, int},
  {"+libssh2_publickey_list_free", {PLIBSSH2_PUBLICKEY, pointer} },
  {"+libssh2_publickey_shutdown", {PLIBSSH2_PUBLICKEY}, int}
}

integer
  xlibssh2_agent_connect, xlibssh2_agent_disconnect, xlibssh2_agent_free,
  xlibssh2_agent_get_identity, xlibssh2_agent_init,
  xlibssh2_agent_list_identities, xlibssh2_agent_userauth, xlibssh2_banner_set,
  xlibssh2_base64_decode, xlibssh2_channel_close,
  xlibssh2_channel_direct_tcpip_ex, xlibssh2_channel_eof,
  xlibssh2_channel_flush_ex, xlibssh2_channel_forward_accept,
  xlibssh2_channel_forward_cancel, xlibssh2_channel_forward_listen_ex,
  xlibssh2_channel_free, xlibssh2_channel_get_exit_signal,
  xlibssh2_channel_get_exit_status, xlibssh2_channel_handle_extended_data,
  xlibssh2_channel_handle_extended_data2, xlibssh2_channel_open_ex,
  xlibssh2_channel_process_startup, xlibssh2_channel_read_ex,
  xlibssh2_channel_receive_window_adjust,
  xlibssh2_channel_receive_window_adjust2, xlibssh2_channel_request_pty_ex,
  xlibssh2_channel_request_pty_size_ex, xlibssh2_channel_send_eof,
  xlibssh2_channel_set_blocking, xlibssh2_channel_setenv_ex,
  xlibssh2_channel_wait_closed, xlibssh2_channel_wait_eof,
  xlibssh2_channel_window_read_ex, xlibssh2_channel_window_write_ex,
  xlibssh2_channel_write_ex, xlibssh2_channel_x11_req_ex, xlibssh2_exit,
  xlibssh2_free, xlibssh2_hostkey_hash, xlibssh2_init,
  xlibssh2_keepalive_config, xlibssh2_keepalive_send, xlibssh2_knownhost_add,
  xlibssh2_knownhost_addc, xlibssh2_knownhost_check, xlibssh2_knownhost_checkp,
  xlibssh2_knownhost_del, xlibssh2_knownhost_free, xlibssh2_knownhost_get,
  xlibssh2_knownhost_init, xlibssh2_knownhost_readfile,
  xlibssh2_knownhost_readline, xlibssh2_knownhost_writefile,
  xlibssh2_knownhost_writeline, xlibssh2_poll, xlibssh2_poll_channel_read,
  xlibssh2_publickey_add_ex, xlibssh2_publickey_init,
  xlibssh2_publickey_list_fetch, xlibssh2_publickey_list_free,
  xlibssh2_publickey_remove_ex, xlibssh2_publickey_shutdown, xlibssh2_scp_recv,
  xlibssh2_scp_send64, xlibssh2_scp_send_ex, xlibssh2_session_abstract,
  xlibssh2_session_block_directions, xlibssh2_session_callback_set,
  xlibssh2_session_disconnect_ex, xlibssh2_session_flag, xlibssh2_session_free,
  xlibssh2_session_get_blocking, xlibssh2_session_get_timeout,
  xlibssh2_session_handshake, xlibssh2_session_hostkey,
  xlibssh2_session_init_ex, xlibssh2_session_last_errno,
  xlibssh2_session_last_error, xlibssh2_session_method_pref,
  xlibssh2_session_methods, xlibssh2_session_set_blocking,
  xlibssh2_session_set_timeout, xlibssh2_session_startup,
  xlibssh2_sftp_close_handle, xlibssh2_sftp_fstat_ex, xlibssh2_sftp_fstatvfs,
  xlibssh2_sftp_init, xlibssh2_sftp_last_error, xlibssh2_sftp_mkdir_ex,
  xlibssh2_sftp_open_ex, xlibssh2_sftp_read, xlibssh2_sftp_readdir_ex,
  xlibssh2_sftp_rename_ex, xlibssh2_sftp_rmdir_ex, xlibssh2_sftp_seek,
  xlibssh2_sftp_seek64, xlibssh2_sftp_shutdown, xlibssh2_sftp_stat_ex,
  xlibssh2_sftp_statvfs, xlibssh2_sftp_symlink_ex, xlibssh2_sftp_tell,
  xlibssh2_sftp_tell64, xlibssh2_sftp_unlink_ex, xlibssh2_sftp_write,
  xlibssh2_trace, xlibssh2_trace_sethandler, xlibssh2_userauth_authenticated,
  xlibssh2_userauth_hostbased_fromfile_ex,
  xlibssh2_userauth_keyboard_interactive_ex, xlibssh2_userauth_list,
  xlibssh2_userauth_password_ex, xlibssh2_userauth_publickey,
  xlibssh2_userauth_publickey_fromfile_ex, xlibssh2_version

xlibssh2_agent_connect = 0
xlibssh2_agent_disconnect = 0
xlibssh2_agent_free = 0
xlibssh2_agent_get_identity = 0
xlibssh2_agent_init = 0
xlibssh2_agent_list_identities = 0
xlibssh2_agent_userauth = 0
xlibssh2_banner_set = 0
xlibssh2_base64_decode = 0
xlibssh2_channel_close = 0
xlibssh2_channel_direct_tcpip_ex = 0
xlibssh2_channel_eof = 0
xlibssh2_channel_flush_ex = 0
xlibssh2_channel_forward_accept = 0
xlibssh2_channel_forward_cancel = 0
xlibssh2_channel_forward_listen_ex = 0
xlibssh2_channel_free = 0
xlibssh2_channel_get_exit_signal = 0
xlibssh2_channel_get_exit_status = 0
xlibssh2_channel_handle_extended_data = 0
xlibssh2_channel_handle_extended_data2 = 0
xlibssh2_channel_open_ex = 0
xlibssh2_channel_process_startup = 0
xlibssh2_channel_read_ex = 0
xlibssh2_channel_receive_window_adjust = 0
xlibssh2_channel_receive_window_adjust2 = 0
xlibssh2_channel_request_pty_ex = 0
xlibssh2_channel_request_pty_size_ex = 0
xlibssh2_channel_send_eof = 0
xlibssh2_channel_set_blocking = 0
xlibssh2_channel_setenv_ex = 0
xlibssh2_channel_wait_closed = 0
xlibssh2_channel_wait_eof = 0
xlibssh2_channel_window_read_ex = 0
xlibssh2_channel_window_write_ex = 0
xlibssh2_channel_write_ex = 0
xlibssh2_channel_x11_req_ex = 0
xlibssh2_exit = 0
xlibssh2_free = 0
xlibssh2_hostkey_hash = 0
xlibssh2_init = 0
xlibssh2_keepalive_config = 0
xlibssh2_keepalive_send = 0
xlibssh2_knownhost_add = 0
xlibssh2_knownhost_addc = 0
xlibssh2_knownhost_check = 0
xlibssh2_knownhost_checkp = 0
xlibssh2_knownhost_del = 0
xlibssh2_knownhost_free = 0
xlibssh2_knownhost_get = 0
xlibssh2_knownhost_init = 0
xlibssh2_knownhost_readfile = 0
xlibssh2_knownhost_readline = 0
xlibssh2_knownhost_writefile = 0
xlibssh2_knownhost_writeline = 0
xlibssh2_poll = 0
xlibssh2_poll_channel_read = 0
xlibssh2_publickey_add_ex = 0
xlibssh2_publickey_init = 0
xlibssh2_publickey_list_fetch = 0
xlibssh2_publickey_list_free = 0
xlibssh2_publickey_remove_ex = 0
xlibssh2_publickey_shutdown = 0
xlibssh2_scp_recv = 0
xlibssh2_scp_send64 = 0
xlibssh2_scp_send_ex = 0
xlibssh2_session_abstract = 0
xlibssh2_session_block_directions = 0
xlibssh2_session_callback_set = 0
xlibssh2_session_disconnect_ex = 0
xlibssh2_session_flag = 0
xlibssh2_session_free = 0
xlibssh2_session_get_blocking = 0
xlibssh2_session_get_timeout = 0
xlibssh2_session_handshake = 0
xlibssh2_session_hostkey = 0
xlibssh2_session_init_ex = 0
xlibssh2_session_last_errno = 0
xlibssh2_session_last_error = 0
xlibssh2_session_method_pref = 0
xlibssh2_session_methods = 0
xlibssh2_session_set_blocking = 0
xlibssh2_session_set_timeout = 0
xlibssh2_session_startup = 0
xlibssh2_sftp_close_handle = 0
xlibssh2_sftp_fstat_ex = 0
xlibssh2_sftp_fstatvfs = 0
xlibssh2_sftp_init = 0
xlibssh2_sftp_last_error = 0
xlibssh2_sftp_mkdir_ex = 0
xlibssh2_sftp_open_ex = 0
xlibssh2_sftp_read = 0
xlibssh2_sftp_readdir_ex = 0
xlibssh2_sftp_rename_ex = 0
xlibssh2_sftp_rmdir_ex = 0
xlibssh2_sftp_seek = 0
xlibssh2_sftp_seek64 = 0
xlibssh2_sftp_shutdown = 0
xlibssh2_sftp_stat_ex = 0
xlibssh2_sftp_statvfs = 0
xlibssh2_sftp_symlink_ex = 0
xlibssh2_sftp_tell = 0
xlibssh2_sftp_tell64 = 0
xlibssh2_sftp_unlink_ex = 0
xlibssh2_sftp_write = 0
xlibssh2_trace = 0
xlibssh2_trace_sethandler = 0
xlibssh2_userauth_authenticated = 0
xlibssh2_userauth_hostbased_fromfile_ex = 0
xlibssh2_userauth_keyboard_interactive_ex = 0
xlibssh2_userauth_list = 0
xlibssh2_userauth_password_ex = 0
xlibssh2_userauth_publickey = 0
xlibssh2_userauth_publickey_fromfile_ex = 0
xlibssh2_version = 0

--------------------------------------------------------------------------------
-- Global API
--------------------------------------------------------------------------------

public function libssh2_init(integer flags)
--<function>
--<name>libssh2_init</name>
--<digest>global library initialization</digest>
--<desc>
-- Initialize the libssh2 functions.  This typically initialize the
-- crypto library.  It uses a public state, and is not thread safe.
-- You must make sure this function is not called concurrently.
--</desc>
--<param>
--<type>integer</type>
--<name>flags</name>
--<desc>
-- Flags can be:
-- 0:                       Normal initialize
-- LIBSSH2_INIT_NO_CRYPTO:  Do not initialize the crypto library (ie.
--                          OPENSSL_add_cipher_algorithms() for OpenSSL
--</desc>
--</param>
--<return>
-- Returns 0 if succeeded, or a negative value for error.
--</return>
--<example>
--</example>
--<see_also>libssh2_exit()</see_also>
--</function>
  if not xlibssh2_init then
    xlibssh2_init = register_routine(libssh2,
        "+libssh2_init", LIBSSH2_ROUTINE_DEFINITION)
  end if
  return c_func(xlibssh2_init, {flags})
end function

--------------------------------------------------------------------------------

public procedure libssh2_exit()
--<procedure>
--<name>libssh2_exit</name>
--<digest>global library deinitialization</digest>
--<desc>
-- Exit the libssh2 functions and free's all memory used internally.
--</desc>
--<example>
--</example>
--<see_also>libssh2_init()</see_also>
--</procedure>
  if not xlibssh2_exit then
    xlibssh2_exit = register_routine(libssh2,
        "+libssh2_exit", LIBSSH2_ROUTINE_DEFINITION)
  end if
  c_proc(xlibssh2_exit, {})
end procedure

--------------------------------------------------------------------------------
-- Session API
--------------------------------------------------------------------------------

--------------------------------------------------------------------------------

public procedure libssh2_banner_set(atom session, sequence banner)
--<procedure>
--<name>libssh2_banner_set</name>
--<digest>set the SSH protocol banner for the local client</digest>
--<desc>
-- Set the banner that will be sent to the remote host when the SSH session is
-- started with libssh2_session_handshake()
-- This is optional; a banner corresponding to the protocol and libssh2 version
-- will be sent by default.
--</desc>
--<param>
--<type>atom</type>
--<name>session</name>
--<desc>Session instance as returned by libssh2_session_init()</desc>
--</param>
--<param>
--<type>sequence</type>
--<name>banner</name>
--<desc>user defined banner</desc>
--</param>
--<example>
--</example>
--<see_also>libssh2_session_handshake()</see_also>
--</procedure>
  atom addr

  if not xlibssh2_banner_set then
    xlibssh2_banner_set = register_routine(libssh2,
        "+libssh2_banner_set", LIBSSH2_ROUTINE_DEFINITION)
  end if
  addr = allocate_string(banner)
  void = c_func(xlibssh2_banner_set, {session, banner})
  free(addr)
end procedure

--------------------------------------------------------------------------------

public function libssh2_session_init()
--<function>
--<name>libssh2_session_init</name>
--<digest></digest>
--<desc>
-- Initializes an SSH session object. By default system memory allocators
-- (malloc(), free(), realloc()) will be used for any dynamically allocated memory
-- blocks. Alternate memory allocation functions may be specified using the
-- extended version of this API call, and/or optional application specific data
-- may be attached to the session object.
--</desc>
--<return>
-- Pointer to a newly allocated LIBSSH2_SESSION instance, or NULL on errors.
--</return>
--<example>
--</example>
--<see_also>libssh2_session_free(), libssh2_session_startup()</see_also>
--</function>
  if not xlibssh2_session_init_ex then
    xlibssh2_session_init_ex = register_routine(libssh2,
        "+libssh2_session_init_ex", LIBSSH2_ROUTINE_DEFINITION)
  end if
  return c_func(xlibssh2_session_init_ex, {NULL, NULL, NULL, NULL})
end function

--------------------------------------------------------------------------------

public function libssh2_session_callback_set(
                    atom session, integer cbtype, atom callback)
--<function>
--<name>libssh2_session_callback_set</name>
--<digest>set a callback function</digest>
--<desc>
-- Sets a custom callback handler for a previously initialized session
-- object. Callbacks are triggered by the receipt of special packets at the
-- Transport layer. To disable a callback, set it to NULL.
--</desc>
--<param>
--<type>atom</type>
--<name>session</name>
--<desc>Session instance as returned by libssh2_session_init_ex()</desc>
--</param>
--<param>
--<type>integer</type>
--<name>cbtype</name>
--<desc>Callback type. One of the types listed in Callback Types.</desc>
--</param>
--<param>
--<type>atom</type>
--<name>callback</name>
--<desc>
-- Pointer to custom callback function. The prototype for this function must
-- match the associated callback declaration macro.
--</desc>
--</param>
--<return>
-- Pointer to previous callback handler. Returns NULL if no prior callback
-- handler was set or the callback type was unknown.
--</return>
--<example>
--</example>
--<see_also>libssh2_session_init()</see_also>
--</function>
  if not xlibssh2_session_callback_set then
    xlibssh2_session_callback_set = register_routine(libssh2,
        "+libssh2_session_callback_set", LIBSSH2_ROUTINE_DEFINITION)
  end if
  return c_func(xlibssh2_session_callback_set, {session, cbtype, callback})
end function

--------------------------------------------------------------------------------

public function libssh2_session_handshake(atom session, atom sock)
--<function>
--<name>libssh2_session_handshake</name>
--<digest>Perform the SSH handshake</digest>
--<desc>
--</desc>
--<param>
--<type>atom</type>
--<name>session</name>
--<desc>Session instance as returned by libssh2_session_init_ex()</desc>
--</param>
--<param>
--<type>atom</type>
--<name>sock</name>
--<desc><b>must</b> be populated with an opened and connected socket.</desc>
--</param>
--<return>
-- Returns: 0 on success, or non-zero on failure
--</return>
--<example>
--</example>
--<see_also>libssh2_session_startup()</see_also>
--</function>
  if not xlibssh2_session_handshake then
    xlibssh2_session_handshake = register_routine(libssh2,
        "+libssh2_session_handshake", LIBSSH2_ROUTINE_DEFINITION)
  end if
  return c_func(xlibssh2_session_handshake, {session, sock})
end function

--------------------------------------------------------------------------------

public function libssh2_session_startup(atom session, integer sock)
--<function>
--<name>libssh2_session_startup</name>
--<digest>begin transport layer</digest>
--<desc>
-- Starting in libssh2 version 1.2.8 this function is considered deprecated. Use
-- <i>libssh2_session_handshake()</i> instead.
--</desc>
--<param>
--<type>atom</type>
--<name>session</name>
--<desc>Session instance as returned by libssh2_session_init_ex()</desc>
--</param>
--<param>
--<type>integer</type>
--<name>sock</name>
--<desc><b>must</b> be populated with an opened and connected socket.</desc>
--</param>
--<return>
-- Returns 0 on success, negative on failure.
--</return>
--<example>
--</example>
--<see_also>libssh2_session_free(), libssh2_session_init()</see_also>
--</function>
  if not xlibssh2_session_startup then
    xlibssh2_session_startup = register_routine(libssh2,
        "+libssh2_session_startup", LIBSSH2_ROUTINE_DEFINITION)
  end if
  return c_func(xlibssh2_session_startup, {session, sock})
end function

--------------------------------------------------------------------------------

public function libssh2_session_free(atom session)
--<function>
--<name>libssh2_session_free</name>
--<digest>frees resources associated with a session instance</digest>
--<desc>
-- Frees all resources associated with a session instance.
-- Typically called after libssh2_session_disconnect_ex()
--</desc>
--<param>
--<type>atom</type>
--<name>session</name>
--<desc></desc>
--</param>
--<return>
-- Return 0 on success or negative on failure.  It returns
-- LIBSSH2_ERROR_EAGAIN when it would otherwise block. While
-- LIBSSH2_ERROR_EAGAIN is a negative number, it isn't really a failure per se.
--</return>
--<example>
--</example>
--<see_also>libssh2_session_init_ex(), libssh2_session_disconnect_ex()</see_also>
--</function>
  if not xlibssh2_session_free then
    xlibssh2_session_free = register_routine(libssh2,
        "+libssh2_session_free", LIBSSH2_ROUTINE_DEFINITION)
  end if
  return c_func(xlibssh2_session_free, {session})
end function

--------------------------------------------------------------------------------

public function libssh2_session_disconnect(atom session, sequence description)
--<function>
--<name>libssh2_session_disconnect</name>
--<digest>terminate transport layer</digest>
--<desc>
-- Send a disconnect message to the remote host associated with <i>session</i>,
-- along with a <i>SSH_DISCONNECT_BY_APPLICATION</> symbol and a verbose
-- <i>description</i>.
--</desc>
--<param>
--<type>atom</type>
--<name>session</name>
--<desc>Session instance as returned by libssh2_session_init_ex()</desc>
--</param>
--<param>
--<type>sequence</type>
--<name>description</name>
--<desc>Human readable reason for disconnection.</desc>
--</param>
--<return>
-- Return 0 on success or negative on failure.  It returns
-- LIBSSH2_ERROR_EAGAIN when it would otherwise block. While
-- LIBSSH2_ERROR_EAGAIN is a negative number, it isn't really a failure per se.
--</return>
--<example>
--</example>
--<see_also>libssh2_session_init()</see_also>
--</function>
  if not xlibssh2_session_disconnect_ex then
    xlibssh2_session_disconnect_ex = register_routine(libssh2,
        "+libssh2_session_disconnect_ex", LIBSSH2_ROUTINE_DEFINITION)
  end if
  return c_func(xlibssh2_session_disconnect_ex,
                {session, SSH_DISCONNECT_BY_APPLICATION,
                 allocate_string(description), allocate_string("")})
end function

--------------------------------------------------------------------------------

public function libssh2_session_methods(atom session, integer method_type)
--<function>
--<name>libssh2_session_methods</name>
--<digest>return the currently active algorithms</digest>
--<desc>
-- Returns the actual method negotiated for a particular transport parameter.
--</desc>
--<param>
--<type>atom</type>
--<name>session</name>
--<desc></desc>
--</param>
--<param>
--<type>integer</type>
--<name>method_type</name>
--<desc>
-- one of the method type constants: LIBSSH2_METHOD_KEX, LIBSSH2_METHOD_HOSTKEY,
-- LIBSSH2_METHOD_CRYPT_CS, LIBSSH2_METHOD_CRYPT_SC, LIBSSH2_METHOD_MAC_CS,
-- LIBSSH2_METHOD_MAC_SC, LIBSSH2_METHOD_COMP_CS, LIBSSH2_METHOD_COMP_SC,
-- LIBSSH2_METHOD_LANG_CS, LIBSSH2_METHOD_LANG_SC.
--</desc>
--</param>
--<return>
-- Negotiated method or NULL if the session has not yet been started.
--</return>
--<example>
--</example>
--<see_also>libssh2_session_init()</see_also>
--</function>
  if not xlibssh2_session_methods then
    xlibssh2_session_methods = register_routine(libssh2,
        "+libssh2_session_methods", LIBSSH2_ROUTINE_DEFINITION)
  end if
  return c_func(xlibssh2_session_methods, {session, method_type})
end function

--------------------------------------------------------------------------------

public function libssh2_session_abstract(atom session)
--<function>
--<name>libssh2_session_abstract</name>
--<digest>return a pointer to a session's abstract pointer</digest>
--<desc>
-- Return a pointer to where the abstract pointer provided to
-- <b>libssh2_session_init_ex()</b> is stored. By providing a doubly
-- de-referenced pointer, the internal storage of the session instance may be
-- modified in place.
--</desc>
--<param>
--<type>atom</type>
--<name>session</name>
--<desc>Session instance as returned by libssh2_session_init()</desc>
--</param>
--<return>
-- A pointer to session internal storage who's contents points to previously
-- provided abstract data.
--</return>
--<example>
--</example>
--<see_also>libssh2_session_init()</see_also>
--</function>
  if not xlibssh2_session_abstract then
    xlibssh2_session_abstract = register_routine(libssh2,
        "+libssh2_session_abstract", LIBSSH2_ROUTINE_DEFINITION)
  end if
  return c_func(xlibssh2_session_abstract, {session})
end function

--------------------------------------------------------------------------------

public function libssh2_session_last_error(atom session)
--<function>
--<name>libssh2_session_last_error</name>
--<digest>get the most recent error</digest>
--<desc>
-- Determine the most recent error condition and its cause.
--</desc>
--<param>
--<type>atom</type>
--<name>session</name>
--<desc>Session instance as returned by libssh2_session_init()</desc>
--</param>
--<return>
-- Error message
--</return>
--<example>
--</example>
--<see_also>libssh2_session_last_errno()</see_also>
--</function>
-- function libssh2_session_last_error(session: PLIBSSH2_SESSION;
--                                     var errmsg: PAnsiChar;
--                                     var errmsg_len: Integer;
--                                     want_buf: Integer): Integer; cdecl;
  atom errmsg, errmsg_len
  integer res

  if not xlibssh2_session_last_error then
    xlibssh2_session_last_error = register_routine(libssh2,
        "+libssh2_session_last_error", LIBSSH2_ROUTINE_DEFINITION)
  end if
  errmsg = allocate(257)
  errmsg_len = allocate(4)
  poke4(errmsg_len, 257)
  res = c_func(xlibssh2_session_last_error,
                {session, errmsg, errmsg_len, 0})
  if res > 0 then
    return peek({errmsg, errmsg_len})
  end if
  return ""
end function

--------------------------------------------------------------------------------

public function libssh2_session_last_errno(atom session)
--<function>
--<name>libssh2_session_last_errno</name>
--<digest>get the most recent error number</digest>
--<desc>
-- Determine the most recent error condition.
--</desc>
--<param>
--<type>atom</type>
--<name>session</name>
--<desc>Session instance as returned by libssh2_session_init()</desc>
--</param>
--<return>
-- Numeric error code corresponding to the the Error Code constants.
--</return>
--<example>
--</example>
--<see_also>libssh2_session_last_error()</see_also>
--</function>
  if not xlibssh2_session_last_errno then
    xlibssh2_session_last_errno = register_routine(libssh2,
        "+libssh2_session_last_errno", LIBSSH2_ROUTINE_DEFINITION)
  end if
  return c_func(xlibssh2_session_last_errno, {session})
end function

--------------------------------------------------------------------------------

public function libssh2_session_flag(atom session, integer flag, integer value)
--<function>
--<name>libssh2_session_flag</name>
--<digest>Set options for the created session.</digest>
--<desc>
-- <i>flag</i> is the option to set, while <i>value</i> is typically set
-- to 1 or 0 to enable or disable the option.
--</desc>
--<param>
--<type>atom</type>
--<name>session</name>
--<desc></desc>
--</param>
--<param>
--<type>integer</type>
--<name>flag</name>
--<desc>
-- * LIBSSH2_FLAG_SIGPIPE
--   If set, libssh2 will not attempt to block SIGPIPEs but will let them trigger
--   from the underlying socket layer.
-- * LIBSSH2_FLAG_COMPRESS
--   If set - before the connection negotiation is performed - libssh2 will try to
--   negotiate compression enabling for this connection. By default libssh2 will
--   not attempt to use compression.
--</desc>
--</param>
--<param>
--<type>integer</type>
--<name>value</name>
--<desc></desc>
--</param>
--<return>
-- Returns regular libssh2 error code.
--</return>
--<example>
--</example>
--<see_also>
--</see_also>
--</function>
  if not xlibssh2_session_flag then
    xlibssh2_session_flag = register_routine(libssh2,
        "+libssh2_session_flag", LIBSSH2_ROUTINE_DEFINITION)
  end if
  return c_func(xlibssh2_session_flag, {session, flag, value})
end function

--------------------------------------------------------------------------------

public procedure libssh2_session_set_blocking(atom session, integer blocking)
--<procedure>
--<name>libssh2_session_set_blocking</name>
--<digest>set or clear blocking mode on session</digest>
--<desc>
-- Set or clear blocking mode on the selected on the session.  This will
-- instantly affect any channels associated with this session. If a read is
-- performed on a session with no data currently available, a blocking session
-- will wait for data to arrive and return what it receives.  A non-blocking
-- session will return immediately with an empty buffer.  If a write is performed
-- on a session with no room for more data, a blocking session will wait for
-- room.  A non-blocking session will return immediately without writing
-- anything.
--</desc>
--<param>
--<type>atom</type>
--<name>session</name>
--<desc>session instance as returned by libssh2_session_init()</desc>
--</param>
--<param>
--<type>integer</type>
--<name>blocking</name>
--<desc>Set to a non-zero value to make the channel block, or zero to make it non-blocking.</desc>
--</param>
--<example>
--</example>
--<see_also>libssh2_session_get_blocking()</see_also>
--</procedure>
  if not xlibssh2_session_set_blocking then
    xlibssh2_session_set_blocking = register_routine(libssh2,
        "+libssh2_session_set_blocking", LIBSSH2_ROUTINE_DEFINITION)
  end if
  c_proc(xlibssh2_session_set_blocking, {session, blocking})
end procedure

--------------------------------------------------------------------------------

public function libssh2_session_get_blocking(atom session)
--<function>
--<name>libssh2_session_get_blocking</name>
--<digest>get blocking mode on session</digest>
--<desc>
--</desc>
--<param>
--<type>atom</type>
--<name>session</name>
--<desc>session instance as returned by libssh2_session_init()</desc>
--</param>
--<return>
-- Returns 0 if the state of the session has previously be set to non-blocking
-- and it returns 1 if the state was set to blocking.
--</return>
--<example>
--</example>
--<see_also>libssh2_session_set_blocking()</see_also>
--</function>
  if not xlibssh2_session_get_blocking then
    xlibssh2_session_get_blocking = register_routine(libssh2,
        "+libssh2_session_get_blocking", LIBSSH2_ROUTINE_DEFINITION)
  end if
  return c_func(xlibssh2_session_get_blocking, {session})
end function

--------------------------------------------------------------------------------

public procedure libssh2_session_set_timeout(atom session, atom timeout)
--<procedure>
--<name>libssh2_session_set_timeout</name>
--<digest>set timeout for blocking functions</digest>
--<desc>
-- Set the <b>timeout</> in milliseconds for how long a blocking the libssh2
-- function calls may wait until they consider the situation an error and return
-- LIBSSH2_ERROR_TIMEOUT.

-- By default or if you set the timeout to zero, libssh2 has no timeout for
-- blocking functions.
--</desc>
--<param>
--<type>atom</type>
--<name>session</name>
--<desc></desc>
--</param>
--<param>
--<type>atom</type>
--<name>timeout</name>
--<desc></desc>
--</param>
--<example>
--</example>
--<see_also>libssh2_session_get_timeout()</see_also>
--</procedure>
  c_proc(xlibssh2_session_set_timeout, {session, timeout})
end procedure

--------------------------------------------------------------------------------

public function libssh2_session_get_timeout(atom session)
--<function>
--<name>libssh2_session_get_timeout</name>
--<digest>get the timeout for blocking functions</digest>
--<desc>
-- Returns the <b>timeout</b> (in milliseconds) for how long a blocking the
-- libssh2 function calls may wait until they consider the situation an error and
-- return LIBSSH2_ERROR_TIMEOUT.

-- By default libssh2 has no timeout (zero) for blocking functions.
--</desc>
--<param>
--<type>atom</type>
--<name>session</name>
--<desc></desc>
--</param>
--<return>
-- The value of the timeout setting.
--</return>
--<example>
--</example>
--<see_also>libssh2_session_set_timeout()</see_also>
--</function>
  return c_func(xlibssh2_session_get_timeout, {session})
end function

--------------------------------------------------------------------------------

public function libssh2_poll(atom fds, integer nfds, atom timeout)
--<function>
--<name>libssh2_poll</name>
--<digest>poll for activity on a socket, channel or listener</digest>
--<desc>
-- This function is deprecated. Do note use. We encourage users to instead use
-- the <i>poll()</i> or <i>select()</i> functions to check for socket activity or
-- when specific sockets are ready to get recevied from or send to.

-- Poll for activity on a socket, channel, listener, or any combination of these
-- three types. The calling semantics for this function generally match
-- <i>poll(2)</i> however the structure of fds is somewhat more complex in order
-- to accommodate the disparate datatypes, POLLFD constants have been namespaced
-- to avoid platform discrepancies, and revents has additional values defined.
--</desc>
--<param>
--<type>atom</type>
--<name>fds</name>
--<desc></desc>
--</param>
--<param>
--<type>integer</type>
--<name>nfds</name>
--<desc></desc>
--</param>
--<param>
--<type>atom</type>
--<name>timeout</name>
--<desc></desc>
--</param>
--<return>
-- Number of fds with interesting events.
--</return>
--<example>
--</example>
--<see_also>libssh2_poll_channel_read()</see_also>
--</function>
-- function libssh2_poll(var fds: LIBSSH2_POLLFD;
--                       nfds: UInt;
--                       timeout: LongInt): Integer; cdecl  ;
  if not xlibssh2_poll then
    xlibssh2_poll = register_routine(libssh2,
        "+libssh2_poll", LIBSSH2_ROUTINE_DEFINITION)
  end if
  return c_func(xlibssh2_poll, {fds, nfds, timeout})
end function

--------------------------------------------------------------------------------

public function libssh2_poll_channel_read(atom channel, integer extended)
--<function>
--<name>libssh2_poll_channel_read</name>
--<digest>check if data is available</digest>
--<desc>
-- This function is deprecated. Do note use.
--
-- <i>libssh2_poll_channel_read()</i> checks to see if data is available in the
-- <i>channel</i>'s read buffer. No attempt is made with this method to see if
-- packets are available to be processed. For full polling support, use
-- <i>libssh2_poll()</i>.
--</desc>
--<param>
--<type>atom</type>
--<name>channel</name>
--<desc></desc>
--</param>
--<param>
--<type>integer</type>
--<name>extended</name>
--<desc></desc>
--</param>
--<return>
-- Returns 1 when data is available and 0 otherwise.
--</return>
--<example>
--</example>
--<see_also>libssh2_poll()</see_also>
--</function>
  if not xlibssh2_poll_channel_read then
    xlibssh2_poll_channel_read = register_routine(libssh2,
        "+libssh2_poll_channel_read", LIBSSH2_ROUTINE_DEFINITION)
  end if
  return c_func(xlibssh2_poll_channel_read, {channel, extended})
end function

--------------------------------------------------------------------------------

public function libssh2_session_block_directions(atom session)
--<function>
--<name>libssh2_session_block_directions</name>
--<digest>get directions to wait for</digest>
--<desc>
-- When any of libssh2 functions return <b>LIBSSH2_ERROR_EAGAIN</b> an application
-- should wait for the socket to have data available for reading or
-- writing. Depending on the return value of
-- <i>libssh2_session_block_directions()</i> an application should wait for read,
-- write or both.
--
-- Application should wait for data to be available for socket prior to calling a
-- libssh2 function again. If <b>LIBSSH2_SESSION_BLOCK_INBOUND</b> is set select
-- should contain the session socket in readfds set.  Correspondingly in case of
-- <b>LIBSSH2_SESSION_BLOCK_OUTBOUND</b> writefds set should contain the socket.
--</desc>
--<param>
--<type>atom</type>
--<name>session</name>
--<desc>Session instance as returned by <b>libssh2_session_init()</b></desc>
--</param>
--<return>
-- Returns the set of directions as a binary mask. Can be a combination of:
-- * LIBSSH2_SESSION_BLOCK_INBOUND: Inbound direction blocked.
-- * LIBSSH2_SESSION_BLOCK_OUTBOUND: Outbound direction blocked.
--</return>
--<example>
--</example>
--<see_also>
--</see_also>
--</function>
  if not xlibssh2_session_block_directions then
    xlibssh2_session_block_directions = register_routine(libssh2,
        "+libssh2_session_block_directions", LIBSSH2_ROUTINE_DEFINITION)
  end if
  return c_func(xlibssh2_session_block_directions, {session})
end function

--------------------------------------------------------------------------------

public function libssh2_hostkey_hash(atom session, integer hash_type)
--<function>
--<name>libssh2_hostkey_hash</name>
--<digest>Returns hash signature</digest>
--<desc>
-- Returned buffer should NOT be freed
-- Length of buffer is determined by hash type
-- i.e. MD5 == 16, SHA1 == 20
--</desc>
--<param>
--<type>atom</type>
--<name>session</name>
--<desc></desc>
--</param>
--<param>
--<type>integer</type>
--<name>hash_type</name>
--<desc></desc>
--</param>
--<return>
--</return>
--<example>
--</example>
--<see_also>
--</see_also>
--</function>
  if not xlibssh2_hostkey_hash then
    xlibssh2_hostkey_hash = register_routine(libssh2,
        "+libssh2_hostkey_hash", LIBSSH2_ROUTINE_DEFINITION)
  end if
  return c_func(xlibssh2_hostkey_hash, {session, hash_type})
end function

--------------------------------------------------------------------------------

public function libssh2_session_hostkey(
                    atom session, integer len, integer Type)
--<function>
--<name>libssh2_session_hostkey</name>
--<digest>get the remote key</digest>
--<desc>
-- Returns a pointer to the current host key, the value <i>len</i> points to will
-- get the length of the key.
--
-- The value <i>type</i> points to the type of hostkey which is one of:
-- * LIBSSH2_HOSTKEY_TYPE_RSA, LIBSSH2_HOSTKEY_TYPE_DSS, or
-- * LIBSSH2_HOSTKEY_TYPE_UNKNOWN.
--</desc>
--<param>
--<type>atom</type>
--<name>session</name>
--<desc></desc>
--</param>
--<param>
--<type>integer</type>
--<name>len</name>
--<desc></desc>
--</param>
--<param>
--<type>integer</type>
--<name>Type</name>
--<desc></desc>
--</param>
--<return>
-- A pointer, or NULL if something went wrong.
--</return>
--<example>
--</example>
--<see_also>libssh2_knownhost_check(), libssh2_knownhost_add()</see_also>
--</function>
-- function libssh2_session_hostkey(session: PLIBSSH2_SESSION;
--                                  var len: size_t;
--                                  var Type: Integer): PAnsiChar; cdecl;
  atom res
  
  if not xlibssh2_session_hostkey then
    xlibssh2_session_hostkey = register_routine(libssh2,
        "+libssh2_session_hostkey", LIBSSH2_ROUTINE_DEFINITION)
  end if
  res = c_func(xlibssh2_session_hostkey, {session, len, Type})
  if res then
    return {res, len, Type}
  else
    return res
  end if
end function

--------------------------------------------------------------------------------

public function libssh2_session_method_pref(
                    atom session, integer method_type, atom prefs)
--<function>
--<name>libssh2_session_method_pref</name>
--<digest>set preferred key exchange method</digest>
--<desc>
-- Set preferred methods to be negotiated. These
-- preferrences must be set prior to calling libssh2_session_startup()
-- as they are used during the protocol initiation phase.
--</desc>
--<param>
--<type>atom</type>
--<name>session</name>
--<desc>Session instance as returned by libssh2_session_init()</desc>
--</param>
--<param>
--<type>integer</type>
--<name>method_type</name>
--<desc>One of the Method Type constants.</desc>
--</param>
--<param>
--<type>atom</type>
--<name>prefs</name>
--<desc>
-- Comma delimited list of preferred methods to use with the most preferred
-- listed first and the least preferred listed last.
-- If a method is listed which is not supported by libssh2 it will be
-- ignored and not sent to the remote host during protocol negotiation.
--</desc>
--</param>
--<return>
-- Return 0 on success or negative on failure.  It returns LIBSSH2_ERROR_EAGAIN
-- when it would otherwise block. While LIBSSH2_ERROR_EAGAIN is a negative
-- number, it isn't really a failure per se.
--</return>
--<example>
--</example>
--<see_also>libssh2_session_init(), libssh2_session_startup()</see_also>
--</function>
  if not xlibssh2_session_method_pref then
    xlibssh2_session_method_pref = register_routine(libssh2,
        "+libssh2_session_method_pref", LIBSSH2_ROUTINE_DEFINITION)
  end if
  return c_func(xlibssh2_session_method_pref, {session, method_type, prefs})
end function

--------------------------------------------------------------------------------
-- Userauth API
--------------------------------------------------------------------------------

--------------------------------------------------------------------------------

public function libssh2_userauth_list(
                    atom session, sequence username)
--<function>
--<name>libssh2_userauth_list</name>
--<digest>list supported authentication methods</digest>
--<desc>
-- Send a <b>SSH_USERAUTH_NONE</b> request to the remote host. Unless the remote
-- host is configured to accept none as a viable authentication scheme
-- (unlikely), it will return <b>SSH_USERAUTH_FAILURE</b> along with a listing of
-- what authentication schemes it does support. In the unlikely event that none
-- authentication succeeds, this method with return NULL. This case may be
-- distinguished from a failing case by examining
-- <i>libssh2_userauth_authenticated()</i>.
--</desc>
--<param>
--<type>atom</type>
--<name>session</name>
--<desc>Session instance as returned by libssh2_session_init()</desc>
--</param>
--<param>
--<type>sequence</type>
--<name>username</name>
--<desc>
-- Username which will be used while authenticating. Note that most server
-- implementations do not permit attempting authentication with different
-- usernames between requests. Therefore this must be the same username you
-- will use on later userauth calls.
--</desc>
--</param>
--<return>
-- On success a comma delimited list of supported authentication schemes. This
-- list is internally managed by libssh2. On failure returns NULL.
--</return>
--<example>
--</example>
--<see_also>libssh2_session_init()</see_also>
--</function>
  atom puser
  atom res

  if not xlibssh2_userauth_list then
    xlibssh2_userauth_list = register_routine(libssh2,
        "+libssh2_userauth_list", LIBSSH2_ROUTINE_DEFINITION)
  end if
  puser = allocate_string(username)
  res = c_func(xlibssh2_userauth_list, {session, puser, length(username)+1})
  free(puser)
  if res = NULL then
    return res
  else
    return peek_string(res)
  end if
end function

--------------------------------------------------------------------------------

public function libssh2_userauth_authenticated(atom session)
--<function>
--<name>libssh2_userauth_authenticated</name>
--<digest>return authentication status</digest>
--<desc>
-- Indicates whether or not the named session has been successfully authenticated.
--</desc>
--<param>
--<type>atom</type>
--<name>session</name>
--<desc>Session instance as returned by libssh2_session_init()</desc>
--</param>
--<return>
-- Returns 1 if authenticated and 0 if not.
--</return>
--<example>
--</example>
--<see_also>libssh2_session_init()</see_also>
--</function>
  if not xlibssh2_userauth_authenticated then
    xlibssh2_userauth_authenticated = register_routine(libssh2,
        "+libssh2_userauth_authenticated", LIBSSH2_ROUTINE_DEFINITION)
  end if
  return c_func(xlibssh2_userauth_authenticated, {session})
end function

--------------------------------------------------------------------------------

public function libssh2_userauth_password(atom session, sequence username,
                    sequence password, atom passwd_change_cb)
--<function>
--<name>libssh2_userauth_password</name>
--<digest>authenticate a session with username and password</digest>
--<desc>
-- Attempt basic password authentication. Note that many SSH servers
-- which appear to support ordinary password authentication actually have
-- it disabled and use Keyboard Interactive authentication (routed via
-- PAM or another authentication backed) instead.
--</desc>
--<param>
--<type>atom</type>
--<name>session</name>
--<desc>Session instance as returned by libssh2_session_init()</desc>
--</param>
--<param>
--<type>sequence</type>
--<name>username</name>
--<desc>Name of user to attempt plain password authentication for.</desc>
--</param>
--<param>
--<type>sequence</type>
--<name>password</name>
--<desc>Password to use for authenticating username.</desc>
--</param>
--<param>
--<type>atom</type>
--<name>passwd_change_cb</name>
--<desc>
-- If the host accepts authentication but requests that the password be
-- changed, this callback will be issued.
-- If no callback is defined, but server required password change,
-- authentication will fail.
--</desc>
--</param>
--<return>
-- Return 0 on success or negative on failure.  It returns
-- * LIBSSH2_ERROR_EAGAIN when it would otherwise block. While
-- * LIBSSH2_ERROR_EAGAIN is a negative number, it isn't really a failure per se.
--</return>
--<example>
--</example>
--<see_also>libssh2_session_init()</see_also>
--</function>
  integer res
  atom puser, ppass

  if not xlibssh2_userauth_password_ex then
    xlibssh2_userauth_password_ex = register_routine(libssh2,
        "+libssh2_userauth_password_ex", LIBSSH2_ROUTINE_DEFINITION)
  end if
  puser = allocate_string(username)
  ppass = allocate_string(password)
  res = c_func(xlibssh2_userauth_password_ex,
               {session, puser, length(username)+1, ppass,
               length(password)+1, passwd_change_cb})
  free(puser)
  free(ppass)
  return res
end function

--------------------------------------------------------------------------------

public function libssh2_userauth_publickey(atom session, atom user,
                    sequence pubkeydata, atom sign_callback, atom abstract)
--<function>
--<name>libssh2_userauth_publickey</name>
--<digest>authenticate using a callback function</digest>
--<desc>
-- Authenticate with the <i>sign_callback</i> callback that matches the prototype
-- below
-- <code>
-- function name(atom session, atom sig, atom sig_len,
--               atom data, atom data_len, atom abstract)
-- </code>
--</desc>
--<param>
--<type>atom</type>
--<name>session</name>
--<desc>Session instance as returned by libssh2_session_init()</desc>
--</param>
--<param>
--<type>atom</type>
--<name>user</name>
--<desc></desc>
--</param>
--<param>
--<type>sequence</type>
--<name>pubkeydata</name>
--<desc></desc>
--</param>
--<param>
--<type>atom</type>
--<name>sign_callback</name>
--<desc></desc>
--</param>
--<param>
--<type>atom</type>
--<name>abstract</name>
--<desc></desc>
--</param>
--<return>
-- Return 0 on success or negative on failure.
--</return>
--<example>
--</example>
--<see_also>libssh2_userauth_publickey_fromfile()</see_also>
--</function>
  atom ppubkeydata
  integer res

  if not xlibssh2_userauth_publickey then
    xlibssh2_userauth_publickey = register_routine(libssh2,
        "+libssh2_userauth_publickey", LIBSSH2_ROUTINE_DEFINITION)
  end if
  ppubkeydata = allocate_string(pubkeydata)
  res = c_func(xlibssh2_userauth_publickey, {session, user,
               ppubkeydata, length(pubkeydata)+1, sign_callback, abstract})
  free(ppubkeydata)
  return res
end function

--------------------------------------------------------------------------------

public function libssh2_userauth_publickey_fromfile(
                    atom session, sequence username, atom publickey,
                    atom privatekey, atom passphrase)
--<function>
--<name>libssh2_userauth_publickey_fromfile</name>
--<digest>authenticate a session with a public key, read from a file</digest>
--<desc>
-- Attempt public key authentication using a PEM encoded private key file stored on disk
--</desc>
--<param>
--<type>atom</type>
--<name>session</name>
--<desc>Session instance as returned by libssh2_session_init()</desc>
--</param>
--<param>
--<type>sequence</type>
--<name>username</name>
--<desc>Remote user name to authenticate as.</desc>
--</param>
--<param>
--<type>atom</type>
--<name>publickey</name>
--<desc>Path and name of public key file. (e.g. /etc/ssh/hostkey.pub)</desc>
--</param>
--<param>
--<type>atom</type>
--<name>privatekey</name>
--<desc>Path and name of private key file. (e.g. /etc/ssh/hostkey)</desc>
--</param>
--<param>
--<type>atom</type>
--<name>passphrase</name>
--<desc>Passphrase to use when decoding private key file.</desc>
--</param>
--<return>
-- Return 0 on success or negative on failure.  It returns LIBSSH2_ERROR_EAGAIN
-- when it would otherwise block. While LIBSSH2_ERROR_EAGAIN is a negative
-- number, it isn't really a failure per se.
--</return>
--<example>
--</example>
--<see_also>libssh2_session_init()</see_also>
--</function>
  atom puser
  integer res

  if not xlibssh2_userauth_publickey_fromfile_ex then
    xlibssh2_userauth_publickey_fromfile_ex = register_routine(libssh2,
        "+libssh2_userauth_publickey_fromfile_ex", LIBSSH2_ROUTINE_DEFINITION)
  end if
  puser = allocate_string(username)
  res = c_func(xlibssh2_userauth_publickey_fromfile_ex,
                {session, puser, length(username)+1, publickey, privatekey,
                passphrase})
  free(puser)
  return res
end function

--------------------------------------------------------------------------------

public function libssh2_userauth_hostbased_fromfile(
                    atom session, sequence username, atom publickey,
                    atom privatekey, atom passphrase, sequence hostname)
--<function>
--<name>libssh2_userauth_hostbased_fromfile</name>
--<digest></digest>
--<desc>
--</desc>
--<param>
--<type>atom</type>
--<name>session</name>
--<desc></desc>
--</param>
--<param>
--<type>sequence</type>
--<name>username</name>
--<desc></desc>
--</param>
--<param>
--<type>atom</type>
--<name>publickey</name>
--<desc></desc>
--</param>
--<param>
--<type>atom</type>
--<name>privatekey</name>
--<desc></desc>
--</param>
--<param>
--<type>atom</type>
--<name>passphrase</name>
--<desc></desc>
--</param>
--<param>
--<type>sequence</type>
--<name>hostname</name>
--<desc></desc>
--</param>
--<return>
--</return>
--<example>
--</example>
--<see_also>
--</see_also>
--</function>
  atom puser, phost
  integer res

  if not xlibssh2_userauth_hostbased_fromfile_ex then
    xlibssh2_userauth_hostbased_fromfile_ex = register_routine(libssh2,
        "+libssh2_userauth_hostbased_fromfile_ex", LIBSSH2_ROUTINE_DEFINITION)
  end if
  puser = allocate_string(username)
  phost = allocate_string(hostname)
  res = c_func(xlibssh2_userauth_hostbased_fromfile_ex,
                {session, puser, length(username)+1, publickey, privatekey,
                 passphrase, phost, length(hostname)+1, username,
                 length(username)+1})
  free(puser)
  free(phost)
  return res
end function

--------------------------------------------------------------------------------

public function libssh2_userauth_keyboard_interactive(
                    atom session, sequence username, atom response_callback)
--<function>
--<name>libssh2_userauth_keyboard_interactive</name>
--<digest>authenticate a session using keyboard-interactive authentication</digest>
--<desc>
-- Attempts keyboard-interactive (challenge/response) authentication.
--
-- Note that many SSH servers will always issue a single "password" challenge,
-- requesting actual password as response, but it is not required by the
-- protocol, and various authentication schemes, such as smartcard authentication
-- may use keyboard-interactive authentication type too.
--</desc>
--<param>
--<type>atom</type>
--<name>session</name>
--<desc>Session instance as returned by <i>libssh2_session_init_ex()</i>.</desc>
--</param>
--<param>
--<type>sequence</type>
--<name>username</name>
--<desc>Name of user to attempt keyboard-interactive authentication for.</desc>
--</param>
--<param>
--<type>atom</type>
--<name>response_callback</name>
--<desc>
-- As authentication proceeds, the host issues several (1 or more) challenges and
-- requires responses. This callback will be called at this moment. The callback
-- is responsible to obtain responses for the challenges, fill the provided data
-- structure and then return control. Responses will be sent to the host.
-- String values will be free()ed by the library.
-- The callback prototype must match this:
--
--<code>
-- procedure response(atom name, integer name_len,
--                    atom instruction, integer instruction_len,
--                    integer num_prompts, atom prompts,
--                    atom responses, atom abstract)
--</code>
--</desc>
--</param>
--<return>
-- Return 0 on success or negative on failure.  It returns LIBSSH2_ERROR_EAGAIN
-- when it would otherwise block. While LIBSSH2_ERROR_EAGAIN is a negative
-- number, it isn't really a failure per se.
--</return>
--<example>
--</example>
--<see_also>libssh2_session_init()</see_also>
--</function>
  atom puser
  integer res

  if not xlibssh2_userauth_keyboard_interactive_ex then
    xlibssh2_userauth_keyboard_interactive_ex = register_routine(libssh2,
        "+libssh2_userauth_keyboard_interactive_ex", LIBSSH2_ROUTINE_DEFINITION)
  end if
  puser = allocate_string(username)
  res = c_func(xlibssh2_userauth_keyboard_interactive_ex,
                {session, puser, length(username)+1, response_callback})
  free(puser)
  return res
end function

--------------------------------------------------------------------------------
-- Channel API
--------------------------------------------------------------------------------

--------------------------------------------------------------------------------

---- response_callback is provided with filled by library prompts array,
---- but client must allocate and fill individual responses. Responses
---- array is already allocated. Responses data will be freed by libssh2
---- after callback return, but before subsequent callback invokation.

--------------------------------------------------------------------------------

public function libssh2_channel_forward_cancel(atom listener)
--<function>
--<name>libssh2_channel_forward_cancel</name>
--<digest></digest>
--<desc>
--</desc>
--<param>
--<type>atom</type>
--<name>listener</name>
--<desc></desc>
--</param>
--<return>
--</return>
--<example>
--</example>
--<see_also>
--</see_also>
--</function>
  if not xlibssh2_channel_forward_cancel then
    xlibssh2_channel_forward_cancel = register_routine(libssh2,
        "+libssh2_channel_forward_cancel", LIBSSH2_ROUTINE_DEFINITION)
  end if
  return c_func(xlibssh2_channel_forward_cancel, {listener})
end function

--------------------------------------------------------------------------------

public function libssh2_channel_forward_accept(atom listener)
--<function>
--<name>libssh2_channel_forward_accept</name>
--<digest></digest>
--<desc>
--</desc>
--<param>
--<type>atom</type>
--<name>listener</name>
--<desc></desc>
--</param>
--<return>
--</return>
--<example>
--</example>
--<see_also>
--</see_also>
--</function>
  if not xlibssh2_channel_forward_accept then
    xlibssh2_channel_forward_accept = register_routine(libssh2,
        "+libssh2_channel_forward_accept", LIBSSH2_ROUTINE_DEFINITION)
  end if
  return c_func(xlibssh2_channel_forward_accept, {listener})
end function

--------------------------------------------------------------------------------

public function libssh2_channel_process_startup(
                    atom channel, atom request, integer request_len,
                    atom message, integer message_len)
--<function>
--<name>libssh2_channel_process_startup</name>
--<digest></digest>
--<desc>
--</desc>
--<param>
--<type>atom</type>
--<name>channel</name>
--<desc></desc>
--</param>
--<param>
--<type>atom</type>
--<name>request</name>
--<desc></desc>
--</param>
--<param>
--<type>integer</type>
--<name>request_len</name>
--<desc></desc>
--</param>
--<param>
--<type>atom</type>
--<name>message</name>
--<desc></desc>
--</param>
--<param>
--<type>integer</type>
--<name>message_len</name>
--<desc></desc>
--</param>
--<return>
--</return>
--<example>
--</example>
--<see_also>
--</see_also>
--</function>
  if not xlibssh2_channel_process_startup then
    xlibssh2_channel_process_startup = register_routine(libssh2,
        "+libssh2_channel_process_startup", LIBSSH2_ROUTINE_DEFINITION)
  end if
  return c_func(xlibssh2_channel_process_startup,
                {channel, request, request_len, message, message_len})
end function

--------------------------------------------------------------------------------

-- libssh2_channel_receive_window_adjust is DEPRECATED, do not use!*/

public function libssh2_channel_receive_window_adjust(
                    atom channel, atom adjustment, integer force)
--<function>
--<name>libssh2_channel_receive_window_adjust</name>
--<digest></digest>
--<desc>
--</desc>
--<param>
--<type>atom</type>
--<name>channel</name>
--<desc></desc>
--</param>
--<param>
--<type>atom</type>
--<name>adjustment</name>
--<desc></desc>
--</param>
--<param>
--<type>integer</type>
--<name>force</name>
--<desc></desc>
--</param>
--<return>
--</return>
--<example>
--</example>
--<see_also>
--</see_also>
--</function>
  if not xlibssh2_channel_receive_window_adjust then
    xlibssh2_channel_receive_window_adjust = register_routine(libssh2,
        "+libssh2_channel_receive_window_adjust", LIBSSH2_ROUTINE_DEFINITION)
  end if
  return c_func(xlibssh2_channel_receive_window_adjust,
                {channel, adjustment, force})
end function

--------------------------------------------------------------------------------

public function libssh2_channel_receive_window_adjust2(atom channel,
                    atom adjustment, integer force, atom storewindow)
--<function>
--<name>libssh2_channel_receive_window_adjust2</name>
--<digest></digest>
--<desc>
--</desc>
--<param>
--<type>atom</type>
--<name>channel</name>
--<desc></desc>
--</param>
--<param>
--<type>atom</type>
--<name>adjustment</name>
--<desc></desc>
--</param>
--<param>
--<type>integer</type>
--<name>force</name>
--<desc></desc>
--</param>
--<param>
--<type>atom</type>
--<name>storewindow</name>
--<desc></desc>
--</param>
--<return>
--</return>
--<example>
--</example>
--<see_also>
--</see_also>
--</function>
-- function libssh2_channel_receive_window_adjust2(channel: PLIBSSH2_CHANNEL;
--                                                 adjustment: LongInt;
--                                                 force: Byte;
--                                                 var storewindow: ULong): Integer; cdecl  ;
  if not xlibssh2_channel_receive_window_adjust2 then
    xlibssh2_channel_receive_window_adjust2 = register_routine(libssh2,
        "+libssh2_channel_receive_window_adjust2", LIBSSH2_ROUTINE_DEFINITION)
  end if
  return c_func(xlibssh2_channel_receive_window_adjust2,
                {channel, adjustment, force, storewindow})
end function

--------------------------------------------------------------------------------

public procedure libssh2_channel_set_blocking(atom channel, integer blocking)
--<procedure>
--<name>libssh2_channel_set_blocking</name>
--<digest></digest>
--<desc>
--</desc>
--<param>
--<type>atom</type>
--<name>channel</name>
--<desc></desc>
--</param>
--<param>
--<type>integer</type>
--<name>blocking</name>
--<desc></desc>
--</param>
--<example>
--</example>
--<see_also>
--</see_also>
--</procedure>
  if not xlibssh2_channel_set_blocking then
    xlibssh2_channel_set_blocking = register_routine(libssh2,
        "+libssh2_channel_set_blocking", LIBSSH2_ROUTINE_DEFINITION)
  end if
  c_proc(xlibssh2_channel_set_blocking, {channel, blocking})
end procedure

--------------------------------------------------------------------------------


public procedure libssh2_channel_handle_extended_data(
              atom channel, integer ignore_mode)
--<procedure>
--<name>libssh2_channel_handle_extended_data</name>
--<digest></digest>
--<desc>
-- DEPRECATED, do not use!
--</desc>
--<param>
--<type>atom</type>
--<name>channel</name>
--<desc></desc>
--</param>
--<param>
--<type>integer</type>
--<name>ignore_mode</name>
--<desc></desc>
--</param>
--<example>
--</example>
--<see_also>
--</see_also>
--</procedure>
  if not xlibssh2_channel_handle_extended_data then
    xlibssh2_channel_handle_extended_data = register_routine(libssh2,
        "+libssh2_channel_handle_extended_data", LIBSSH2_ROUTINE_DEFINITION)
  end if
  c_proc(xlibssh2_channel_handle_extended_data, {channel, ignore_mode})
end procedure

--------------------------------------------------------------------------------

public function libssh2_channel_handle_extended_data2(
                    atom channel, integer ignore_mode)
--<function>
--<name>libssh2_channel_handle_extended_data2</name>
--<digest></digest>
--<desc>
--</desc>
--<param>
--<type>atom</type>
--<name>channel</name>
--<desc></desc>
--</param>
--<param>
--<type>integer</type>
--<name>ignore_mode</name>
--<desc></desc>
--</param>
--<return>
--</return>
--<example>
--</example>
--<see_also>
--</see_also>
--</function>
  if not xlibssh2_channel_handle_extended_data2 then
    xlibssh2_channel_handle_extended_data2 = register_routine(libssh2,
        "+libssh2_channel_handle_extended_data2", LIBSSH2_ROUTINE_DEFINITION)
  end if
  return c_func(xlibssh2_channel_handle_extended_data2, {channel, ignore_mode})
end function

--------------------------------------------------------------------------------

public function libssh2_channel_get_exit_status(atom channel)
--<function>
--<name>libssh2_channel_get_exit_status</name>
--<digest></digest>
--<desc>
--</desc>
--<param>
--<type>atom</type>
--<name>channel</name>
--<desc></desc>
--</param>
--<return>
--</return>
--<example>
--</example>
--<see_also>
--</see_also>
--</function>
  if not xlibssh2_channel_get_exit_status then
    xlibssh2_channel_get_exit_status = register_routine(libssh2,
        "+libssh2_channel_get_exit_status", LIBSSH2_ROUTINE_DEFINITION)
  end if
  return c_func(xlibssh2_channel_get_exit_status, {channel})
end function

--------------------------------------------------------------------------------

public function libssh2_channel_send_eof(atom channel)
--<function>
--<name>libssh2_channel_send_eof</name>
--<digest></digest>
--<desc>
--</desc>
--<param>
--<type>atom</type>
--<name>channel</name>
--<desc></desc>
--</param>
--<return>
--</return>
--<example>
--</example>
--<see_also>
--</see_also>
--</function>
  if not xlibssh2_channel_send_eof then
    xlibssh2_channel_send_eof = register_routine(libssh2,
        "+libssh2_channel_send_eof", LIBSSH2_ROUTINE_DEFINITION)
  end if
  return c_func(xlibssh2_channel_send_eof, {channel})
end function

--------------------------------------------------------------------------------

public function libssh2_channel_eof(atom channel)
--<function>
--<name>libssh2_channel_eof</name>
--<digest></digest>
--<desc>
--</desc>
--<param>
--<type>atom</type>
--<name>channel</name>
--<desc></desc>
--</param>
--<return>
--</return>
--<example>
--</example>
--<see_also>
--</see_also>
--</function>
  if not xlibssh2_channel_eof then
    xlibssh2_channel_eof = register_routine(libssh2,
        "+libssh2_channel_eof", LIBSSH2_ROUTINE_DEFINITION)
  end if
  return c_func(xlibssh2_channel_eof, {channel})
end function

--------------------------------------------------------------------------------

public function libssh2_channel_wait_eof(atom channel)
--<function>
--<name>libssh2_channel_wait_eof</name>
--<digest></digest>
--<desc>
--</desc>
--<param>
--<type>atom</type>
--<name>channel</name>
--<desc></desc>
--</param>
--<return>
--</return>
--<example>
--</example>
--<see_also>
--</see_also>
--</function>
  if not xlibssh2_channel_wait_eof then
    xlibssh2_channel_wait_eof = register_routine(libssh2,
        "+libssh2_channel_wait_eof", LIBSSH2_ROUTINE_DEFINITION)
  end if
  return c_func(xlibssh2_channel_wait_eof, {channel})
end function

--------------------------------------------------------------------------------

public function libssh2_channel_close(atom channel)
--<function>
--<name>libssh2_channel_close</name>
--<digest></digest>
--<desc>
--</desc>
--<param>
--<type>atom</type>
--<name>channel</name>
--<desc></desc>
--</param>
--<return>
--</return>
--<example>
--</example>
--<see_also>
--</see_also>
--</function>
  if not xlibssh2_channel_close then
    xlibssh2_channel_close = register_routine(libssh2,
        "+libssh2_channel_close", LIBSSH2_ROUTINE_DEFINITION)
  end if
  return c_func(xlibssh2_channel_close, {channel})
end function

--------------------------------------------------------------------------------

public function libssh2_channel_wait_closed(atom channel)
--<function>
--<name>libssh2_channel_wait_closed</name>
--<digest></digest>
--<desc>
--</desc>
--<param>
--<type>atom</type>
--<name>channel</name>
--<desc></desc>
--</param>
--<return>
--</return>
--<example>
--</example>
--<see_also>
--</see_also>
--</function>
  if not xlibssh2_channel_wait_closed then
    xlibssh2_channel_wait_closed = register_routine(libssh2,
        "+libssh2_channel_wait_closed", LIBSSH2_ROUTINE_DEFINITION)
  end if
  return c_func(xlibssh2_channel_wait_closed, {channel})
end function

--------------------------------------------------------------------------------

public function libssh2_channel_free(atom channel)
--<function>
--<name>libssh2_channel_free</name>
--<digest></digest>
--<desc>
--</desc>
--<param>
--<type>atom</type>
--<name>channel</name>
--<desc></desc>
--</param>
--<return>
--</return>
--<example>
--</example>
--<see_also>
--</see_also>
--</function>
  if not xlibssh2_channel_free then
    xlibssh2_channel_free = register_routine(libssh2,
        "+libssh2_channel_free", LIBSSH2_ROUTINE_DEFINITION)
  end if
  return c_func(xlibssh2_channel_free, {channel})
end function

--------------------------------------------------------------------------------

public function libssh2_base64_decode(atom session, sequence source)
--<function>
--<name>libssh2_base64_decode</name>
--<digest>decode a base64 encoded string</digest>
--<desc>
-- This function is deemed DEPRECATED and will be removed from libssh2 in a
-- future version. Don't use it!
-- 
-- Decode a base64 chunk and store it into a newly allocated buffer.
-- 'dest_len' will be set to hold the length of the returned buffer that '*dest'
-- will point to.
-- 
-- The returned buffer is allocated by this function, but it is not clear how to
-- free that memory!
--</desc>
--<param>
--<type>atom</type>
--<name>session</name>
--<desc></desc>
--</param>
--<param>
--<type>atom</type>
--<name>dest</name>
--<desc></desc>
--</param>
--<param>
--<type>atom</type>
--<name>dest_len</name>
--<desc></desc>
--</param>
--<param>
--<type>atom</type>
--<name>src</name>
--<desc></desc>
--</param>
--<param>
--<type>integer</type>
--<name>src_len</name>
--<desc></desc>
--</param>
--<return>
--</return>
--<example>
--</example>
--<see_also>
--</see_also>
--</function>
-- function libssh2_base64_decode(session: PLIBSSH2_SESSION;
--                                var dest: PAnsiChar;
--                                var dest_len: Uint;
--                                const src: PAnsiChar;
--                                src_len: Uint): Integer; cdecl;
  atom dst, dst_len, src
  integer src_len
  integer rc
  sequence dest

  if not xlibssh2_base64_decode then
    xlibssh2_base64_decode = register_routine(libssh2,
        "+libssh2_base64_decode", LIBSSH2_ROUTINE_DEFINITION)
  end if
  dest = ""
  dst = allocate(#4000)
  --dst = NULL
  dst_len = allocate(4)
  poke4(dst_len, #4000)
  --src = allocate_string(source)
  src = allocate(length(source))
  poke(src, source)
  src_len = allocate(4)
  poke4(src_len, length(source))
  rc = c_func(xlibssh2_base64_decode, {session, dst, dst_len, src, src_len})
  if rc > 0 then
    dest = peek({dst, dst_len})
  end if
  free(dst)
  free(dst_len)
  free(src)
  return dest
end function

--------------------------------------------------------------------------------

public function libssh2_version(integer req_version_num)
--<function>
--<name>libssh2_version</name>
--<digest>return the libssh2 version number</digest>
--<desc>
-- If <i>required_version</i> is lower than or equal to the version number of the
-- libssh2 in use, the version number of libssh2 is returned
--</desc>
--<param>
--<type>integer</type>
--<name>req_version_num</name>
--<desc>
-- should be the version number as constructed by the LIBSSH2_VERSION_NUM
-- constant, which is a 24 bit number in the 0xMMmmpp format.
-- MM for major, mm for minor and pp for patch
-- number.
--</desc>
--</param>
--<return>
-- The version number of libssh2 is returned or NULL if the
-- <i>required_version</i> isn't fulfilled.
--</return>
--<example>
-- To make sure you run with the correct libssh2 version:
-- <code>
--  if not libssh2_version(LIBSSH2_VERSION_NUM) then
--    printf (2, &quot;Runtime libssh2 version too old!\n&quot;)
--    abort(1)
--  end if
-- </code>
-- Unconditionally get the version number:
-- <code>
-- printf(1, &quot;libssh2 version: %s&quot;, libssh2_version(0) )
-- </code>
--</example>
--<see_also>
--</see_also>
--</function>
  atom addr
  
  if not xlibssh2_version then
    xlibssh2_version = register_routine(libssh2,
        "+libssh2_version", LIBSSH2_ROUTINE_DEFINITION)
  end if
  addr = c_func(xlibssh2_version, {req_version_num})
  if addr != NULL then
    return peek_string(addr)
  end if
  return 0
end function

--------------------------------------------------------------------------------

public function libssh2_knownhost_init(atom session)
--<function>
--<name>libssh2_knownhost_init</name>
--<digest>Init a collection of known hosts.</digest>
--<desc>
--</desc>
--<param>
--<type>atom</type>
--<name>session</name>
--<desc></desc>
--</param>
--<return>
-- Returns the pointer to a collection.
--</return>
--<example>
--</example>
--<see_also>
--</see_also>
--</function>
  if not xlibssh2_knownhost_init then
    xlibssh2_knownhost_init = register_routine(libssh2,
        "+libssh2_knownhost_init", LIBSSH2_ROUTINE_DEFINITION)
  end if
  return c_func(xlibssh2_knownhost_init, {session})
end function

--------------------------------------------------------------------------------

public function libssh2_knownhost_add(atom hosts, atom host, atom salt,
                    atom key, atom keylen, integer typemask, atom store)
--<function>
--<name>libssh2_knownhost_add</name>
--<digest>Add a host and its associated key to the collection of known hosts.</digest>
--<desc>
-- The 'type' argument specifies on what format the given host is:
--
-- plain  - ascii "hostname.domain.tld"
-- sha1   - SHA1(<salt> <host>) base64-encoded!
-- custom - another hash
--
-- If 'sha1' is selected as type, the salt must be provided to the salt
-- argument. This too base64 encoded.
--
-- The SHA-1 hash is what OpenSSH can be told to use in known_hosts files.  If
-- a custom type is used, salt is ignored and you must provide the host
-- pre-hashed when checking for it in the libssh2_knownhost_check() public function.
--</desc>
--<param>
--<type>atom</type>
--<name>hosts</name>
--<desc></desc>
--</param>
--<param>
--<type>atom</type>
--<name>host</name>
--<desc></desc>
--</param>
--<param>
--<type>atom</type>
--<name>salt</name>
--<desc></desc>
--</param>
--<param>
--<type>atom</type>
--<name>key</name>
--<desc></desc>
--</param>
--<param>
--<type>atom</type>
--<name>keylen</name>
--<desc></desc>
--</param>
--<param>
--<type>integer</type>
--<name>typemask</name>
--<desc></desc>
--</param>
--<param>
--<type>atom</type>
--<name>store</name>
--<desc></desc>
--</param>
--<return>
--</return>
--<example>
--</example>
--<see_also>
--</see_also>
--</function>
-- function libssh2_knownhost_add(hosts: PLIBSSH2_KNOWNHOSTS;
--                       host,
--                       salt,
--                       key: PAnsiChar; keylen: size_t; typemask: Integer;
--                       var store: PLIBSSH2_KNOWNHOST): Integer; cdecl ;
  if not xlibssh2_knownhost_add then
    xlibssh2_knownhost_add = register_routine(libssh2,
        "+libssh2_knownhost_add", LIBSSH2_ROUTINE_DEFINITION)
  end if
  return c_func(xlibssh2_knownhost_add,
                {hosts, host, salt, key, keylen, typemask, store})
end function

--------------------------------------------------------------------------------

public function libssh2_knownhost_addc(atom hosts, atom host, atom salt,
                    atom key, atom keylen, atom comment, atom commentlen,
                    integer typemask, atom store)
--<function>
--<name>libssh2_knownhost_addc</name>
--<digest>Add a host and its associated key to the collection of known hosts.</digest>
--<desc>
-- The 'type' argument specifies on what format the given host and keys are:
-- plain  - ascii "hostname.domain.tld"
-- sha1   - SHA1(<salt> <host>) base64-encoded!
-- custom - another hash
--
-- If 'sha1' is selected as type, the salt must be provided to the salt
-- argument. This too base64 encoded.
--
-- The SHA-1 hash is what OpenSSH can be told to use in known_hosts files.  If
-- a custom type is used, salt is ignored and you must provide the host
-- pre-hashed when checking for it in the libssh2_knownhost_check() public function.
--</desc>
--<param>
--<type>atom</type>
--<name>hosts</name>
--<desc></desc>
--</param>
--<param>
--<type>atom</type>
--<name>host</name>
--<desc></desc>
--</param>
--<param>
--<type>atom</type>
--<name>salt</name>
--<desc></desc>
--</param>
--<param>
--<type>atom</type>
--<name>key</name>
--<desc></desc>
--</param>
--<param>
--<type>atom</type>
--<name>keylen</name>
--<desc>
-- may be omitted (zero) if the key is provided as a NULL-terminated
-- base64-encoded string.
--</desc>
--</param>
--<param>
--<type>atom</type>
--<name>comment</name>
--<desc>
-- NULL indicates there is no comment and the entry will end directly after the
-- key when written out to a file.
-- An empty string "" will indicate an empty comment which will cause a single
-- space to be written after the key.
--</desc>
--</param>
--<param>
--<type>atom</type>
--<name>commentlen</name>
--<desc></desc>
--</param>
--<param>
--<type>integer</type>
--<name>typemask</name>
--<desc></desc>
--</param>
--<param>
--<type>atom</type>
--<name>store</name>
--<desc></desc>
--</param>
--<return>
--</return>
--<example>
--</example>
--<see_also>
--</see_also>
--</function>
-- function libssh2_knownhost_addc(hosts: PLIBSSH2_KNOWNHOSTS;
--                        host,
--                        salt,
--                        key: PAnsiChar;
--                        keylen: size_t;
--                        comment: PAnsiChar;
--                        commentlen: size_t; typemask: Integer;
--                        var store: PLIBSSH2_KNOWNHOST): Integer; cdecl ;
  if not xlibssh2_knownhost_addc then
    xlibssh2_knownhost_addc = register_routine(libssh2,
        "+libssh2_knownhost_addc", LIBSSH2_ROUTINE_DEFINITION)
  end if
  return c_func(xlibssh2_knownhost_addc, {hosts, host, salt,
                    key, keylen, comment, commentlen, typemask, store})
end function

--------------------------------------------------------------------------------

public function libssh2_knownhost_check(atom hosts, atom host,
                    atom key, atom keylen, integer typemask, atom knownhost)
--<function>
--<name>libssh2_knownhost_check</name>
--<digest>Check a host and its associated key against the collection of known hosts.</digest>
--<desc>
-- The type is the type/format of the given host name.
--
-- plain  - ascii "hostname.domain.tld"
-- custom - prehashed base64 encoded. Note that this cannot use any salts.
--</desc>
--<param>
--<type>atom</type>
--<name>hosts</name>
--<desc></desc>
--</param>
--<param>
--<type>atom</type>
--<name>host</name>
--<desc></desc>
--</param>
--<param>
--<type>atom</type>
--<name>key</name>
--<desc></desc>
--</param>
--<param>
--<type>atom</type>
--<name>keylen</name>
--<desc></desc>
--</param>
--<param>
--<type>integer</type>
--<name>typemask</name>
--<desc></desc>
--</param>
--<param>
--<type>atom</type>
--<name>knownhost</name>
--<desc>may be set to NULL if you don't care about that info.</desc>
--</param>
--<return> LIBSSH2_KNOWNHOST_CHECK_* values</return>
--<example>
--</example>
--<see_also>
--</see_also>
--</function>
-- function libssh2_knownhost_check(hosts: PLIBSSH2_KNOWNHOSTS;
--                         host, key: PAnsiChar; keylen: size_t;
--                         typemask: Integer;
--                         var knownhost: PLIBSSH2_KNOWNHOST): Integer; cdecl;
  if not xlibssh2_knownhost_check then
    xlibssh2_knownhost_check = register_routine(libssh2,
        "+libssh2_knownhost_check", LIBSSH2_ROUTINE_DEFINITION)
  end if
  return c_func(xlibssh2_knownhost_check,
                {hosts, host, key, keylen, typemask, knownhost})
end function

--------------------------------------------------------------------------------

public function libssh2_knownhost_checkp(atom hosts, sequence hostname, integer port,
                    atom key, atom keylen, integer typemask, atom knownhost)
--<function>
--<name>libssh2_knownhost_checkp</name>
--<digest>Check a host and its associated key against the collection of known hosts.</digest>
--<desc>
-- this global function is identical to libssh2_knownhost_check but takes an
-- additional port argument that allows libssh2 to do a better check
--</desc>
--<param>
--<type>atom</type>
--<name>hosts</name>
--<desc></desc>
--</param>
--<param>
--<type>sequence</type>
--<name>host</name>
--<desc></desc>
--</param>
--<param>
--<type>integer</type>
--<name>port</name>
--<desc></desc>
--</param>
--<param>
--<type>atom</type>
--<name>key</name>
--<desc></desc>
--</param>
--<param>
--<type>atom</type>
--<name>keylen</name>
--<desc></desc>
--</param>
--<param>
--<type>integer</type>
--<name>typemask</name>
--<desc></desc>
--</param>
--<param>
--<type>atom</type>
--<name>knownhost</name>
--<desc></desc>
--</param>
--<return>
--</return>
--<example>
--</example>
--<see_also>
--</see_also>
--</function>
-- function libssh2_knownhost_checkp(hosts: PLIBSSH2_KNOWNHOSTS;
--                          const host: PAnsiChar; port: Integer;
--                          const key: PAnsiChar; keylen: size_t;
--                          typemask: Integer;
--                          var knownhost: PLIBSSH2_KNOWNHOST): Integer; cdecl ;
  atom res, host
  
  if not xlibssh2_knownhost_checkp then
    xlibssh2_knownhost_checkp = register_routine(libssh2,
        "+libssh2_knownhost_checkp", LIBSSH2_ROUTINE_DEFINITION)
  end if
  host = allocate_string(hostname)
  res = c_func(xlibssh2_knownhost_checkp,
                {hosts, host, port, key, keylen, typemask, knownhost})
  if res then
    return {res, host}
  else
    return res
  end if
end function

--------------------------------------------------------------------------------

public function libssh2_knownhost_del(atom hosts, atom entr)
--<function>
--<name>libssh2_knownhost_del</name>
--<digest>Remove a host from the collection of known hosts.</digest>
--<desc>
--  The 'entry' struct is retrieved by a call to libssh2_knownhost_check().
--</desc>
--<param>
--<type>atom</type>
--<name>hosts</name>
--<desc></desc>
--</param>
--<param>
--<type>atom</type>
--<name>entry</name>
--<desc></desc>
--</param>
--<return>
--</return>
--<example>
--</example>
--<see_also>
--</see_also>
--</function>
  if not xlibssh2_knownhost_del then
    xlibssh2_knownhost_del = register_routine(libssh2,
        "+libssh2_knownhost_del", LIBSSH2_ROUTINE_DEFINITION)
  end if
  return c_func(xlibssh2_knownhost_del, {hosts, entr})
end function

--------------------------------------------------------------------------------

public procedure libssh2_knownhost_free(atom hosts)
--<procedure>
--<name>libssh2_knownhost_free</name>
--<digest>Free an entire collection of known hosts.</digest>
--<desc>
--</desc>
--<param>
--<type>atom</type>
--<name>hosts</name>
--<desc></desc>
--</param>
--<example>
--</example>
--<see_also>
--</see_also>
--</procedure>
  if not xlibssh2_knownhost_free then
    xlibssh2_knownhost_free = register_routine(libssh2,
        "+libssh2_knownhost_free", LIBSSH2_ROUTINE_DEFINITION)
  end if
  c_proc(xlibssh2_knownhost_free, {hosts})
end procedure

--------------------------------------------------------------------------------

public function libssh2_knownhost_readline(
                    atom hosts, atom line, atom len, integer Type)
--<function>
--<name>libssh2_knownhost_readline</name>
--<digest>Pass in a line of a file of 'type'. It makes libssh2 read this line.</digest>
--<desc>
-- LIBSSH2_KNOWNHOST_FILE_OPENSSH is the only supported type.
--</desc>
--<param>
--<type>atom</type>
--<name>hosts</name>
--<desc></desc>
--</param>
--<param>
--<type>atom</type>
--<name>line</name>
--<desc></desc>
--</param>
--<param>
--<type>atom</type>
--<name>len</name>
--<desc></desc>
--</param>
--<param>
--<type>integer</type>
--<name>Type</name>
--<desc></desc>
--</param>
--<return>
--</return>
--<example>
--</example>
--<see_also>
--</see_also>
--</function>
  if not xlibssh2_knownhost_readline then
    xlibssh2_knownhost_readline = register_routine(libssh2,
        "+libssh2_knownhost_readline", LIBSSH2_ROUTINE_DEFINITION)
  end if
  return c_func(xlibssh2_knownhost_readline, {hosts, line, len, Type})
end function

--------------------------------------------------------------------------------

public function libssh2_knownhost_readfile(
                    atom hosts, sequence filename, integer Type)
--<function>
--<name>libssh2_knownhost_readfile</name>
--<digest>Add hosts+key pairs from a given file.</digest>
--<desc>
-- This implementation currently only knows one 'type'
-- (LIBSSH2_KNOWNHOST_FILE_OPENSSH), all others are reserved for future use.
--</desc>
--<param>
--<type>atom</type>
--<name>hosts</name>
--<desc></desc>
--</param>
--<param>
--<type>sequence</type>
--<name>filename</name>
--<desc></desc>
--</param>
--<param>
--<type>integer</type>
--<name>Type</name>
--<desc></desc>
--</param>
--<return>
-- Returns a negative value for error or number of successfully added hosts.
--</return>
--<example>
--</example>
--<see_also>
--</see_also>
--</function>
  if not xlibssh2_knownhost_readfile then
    xlibssh2_knownhost_readfile = register_routine(libssh2,
        "+libssh2_knownhost_readfile", LIBSSH2_ROUTINE_DEFINITION)
  end if
  return c_func(xlibssh2_knownhost_readfile, {hosts, allocate_string(filename), Type})
end function

--------------------------------------------------------------------------------

public function libssh2_knownhost_writeline(atom hosts, atom known,
                    atom buffer, atom buflen, atom outlen, integer Type)
--<function>
--<name>libssh2_knownhost_writeline</name>
--<digest>Ask libssh2 to convert a known host to an output line for storage.</digest>
--<desc>
-- This implementation currently only knows one 'type' (openssh), all others
-- are reserved for future use.
--</desc>
--<param>
--<type>atom</type>
--<name>hosts</name>
--<desc></desc>
--</param>
--<param>
--<type>atom</type>
--<name>known</name>
--<desc></desc>
--</param>
--<param>
--<type>atom</type>
--<name>buffer</name>
--<desc></desc>
--</param>
--<param>
--<type>atom</type>
--<name>buflen</name>
--<desc></desc>
--</param>
--<param>
--<type>atom</type>
--<name>outlen</name>
--<desc></desc>
--</param>
--<param>
--<type>integer</type>
--<name>Type</name>
--<desc></desc>
--</param>
--<return>
-- returns LIBSSH2_ERROR_BUFFER_TOO_SMALL if the given output buffer is too
-- small to hold the desired output.
--</return>
--<example>
--</example>
--<see_also>
--</see_also>
--</function>
-- function libssh2_knownhost_writeline(hosts: PLIBSSH2_KNOWNHOSTS;
--                             known: PLIBSSH2_KNOWNHOST;
--                             buffer: PAnsiChar; buflen: size_t;
--                             var outlen: size_t;
--                             Type: Integer): Integer; cdecl;
  if not xlibssh2_knownhost_writeline then
    xlibssh2_knownhost_writeline = register_routine(libssh2,
        "+libssh2_knownhost_writeline", LIBSSH2_ROUTINE_DEFINITION)
  end if
  return c_func(xlibssh2_knownhost_writeline,
                {hosts, known, buffer, buflen, outlen, Type})
end function

--------------------------------------------------------------------------------

public function libssh2_knownhost_writefile(
                    atom hosts, sequence filename, integer Type)
--<function>
--<name>libssh2_knownhost_writefile</name>
--<digest>Write hosts+key pairs to a given file.</digest>
--<desc>
-- This implementation currently only knows one 'type' (openssh), all others
-- are reserved for future use.
--</desc>
--<param>
--<type>atom</type>
--<name>hosts</name>
--<desc></desc>
--</param>
--<param>
--<type>sequence</type>
--<name>filename</name>
--<desc></desc>
--</param>
--<param>
--<type>integer</type>
--<name>Type</name>
--<desc></desc>
--</param>
--<return>
--</return>
--<example>
--</example>
--<see_also>
--</see_also>
--</function>
  if not xlibssh2_knownhost_writefile then
    xlibssh2_knownhost_writefile = register_routine(libssh2,
        "+libssh2_knownhost_writefile", LIBSSH2_ROUTINE_DEFINITION)
  end if
  return c_func(xlibssh2_knownhost_writefile, {hosts, allocate_string(filename), Type})
end function

--------------------------------------------------------------------------------

public function libssh2_knownhost_get(atom hosts, atom store, atom prev)
--<function>
--<name>libssh2_knownhost_get</name>
--<digest>Traverse the internal list of known hosts.</digest>
--<desc>
--  Pass NULL to 'prev' to get the first one, or pass a pointer to the
-- previously returned one to get the next.
--</desc>
--<param>
--<type>atom</type>
--<name>hosts</name>
--<desc></desc>
--</param>
--<param>
--<type>atom</type>
--<name>store</name>
--<desc></desc>
--</param>
--<param>
--<type>atom</type>
--<name>prev</name>
--<desc></desc>
--</param>
--<return>
-- Returns:
-- * 0 if a fine host was stored in 'store'
-- * 1 if end of hosts
-- * [negative] on errors
--</return>
--<example>
--</example>
--<see_also>
--</see_also>
--</function>
-- function libssh2_knownhost_get(hosts: PLIBSSH2_KNOWNHOSTS;
--                       var store: PLIBSSH2_KNOWNHOST;
--                       prev: PLIBSSH2_KNOWNHOST): Integer; cdecl;
  if not xlibssh2_knownhost_get then
    xlibssh2_knownhost_get = register_routine(libssh2,
        "+libssh2_knownhost_get", LIBSSH2_ROUTINE_DEFINITION)
  end if
  return c_func(xlibssh2_knownhost_get, {hosts, store, prev})
end function

--------------------------------------------------------------------------------

public function libssh2_agent_init(atom session)
--<function>
--<name>libssh2_agent_init</name>
--<digest>Init an ssh-agent handle.</digest>
--<desc>
--</desc>
--<param>
--<type>atom</type>
--<name>session</name>
--<desc></desc>
--</param>
--<return>
-- Returns the pointer to the handle.
--</return>
--<example>
--</example>
--<see_also>
--</see_also>
--</function>
  if not xlibssh2_agent_init then
    xlibssh2_agent_init = register_routine(libssh2,
        "+libssh2_agent_init", LIBSSH2_ROUTINE_DEFINITION)
  end if
  return c_func(xlibssh2_agent_init, {session})
end function

--------------------------------------------------------------------------------

public function libssh2_agent_connect(atom agent)
--<function>
--<name>libssh2_agent_connect</name>
--<digest>Connect to an ssh-agent.</digest>
--<desc>
--</desc>
--<param>
--<type>atom</type>
--<name>agent</name>
--<desc></desc>
--</param>
--<return>
-- Returns 0 if succeeded, or a negative value for error.
--</return>
--<example>
--</example>
--<see_also>
--</see_also>
--</function>
  if not xlibssh2_agent_connect then
    xlibssh2_agent_connect = register_routine(libssh2,
        "+libssh2_agent_connect", LIBSSH2_ROUTINE_DEFINITION)
  end if
  return c_func(xlibssh2_agent_connect, {agent})
end function

--------------------------------------------------------------------------------

public function libssh2_agent_list_identities(atom agent)
--<function>
--<name>libssh2_agent_list_identities</name>
--<digest>Request an ssh-agent to list identities.</digest>
--<desc>
--</desc>
--<param>
--<type>atom</type>
--<name>agent</name>
--<desc></desc>
--</param>
--<return>
-- Returns 0 if succeeded, or a negative value for error.
--</return>
--<example>
--</example>
--<see_also>
--</see_also>
--</function>
  if not xlibssh2_agent_list_identities then
    xlibssh2_agent_list_identities = register_routine(libssh2,
        "+libssh2_agent_list_identities", LIBSSH2_ROUTINE_DEFINITION)
  end if
  return c_func(xlibssh2_agent_list_identities, {agent})
end function

--------------------------------------------------------------------------------

public function libssh2_agent_get_identity(atom agent, atom store, atom prev)
--<function>
--<name>libssh2_agent_get_identity</name>
--<digest>Traverse the internal list of public keys.</digest>
--<desc>
-- Pass NULL to 'prev' to get the first one, or pass a pointer to the previously
-- returned one to get the next.
--</desc>
--<param>
--<type>atom</type>
--<name>agent</name>
--<desc></desc>
--</param>
--<param>
--<type>atom</type>
--<name>store</name>
--<desc></desc>
--</param>
--<param>
--<type>atom</type>
--<name>prev</name>
--<desc></desc>
--</param>
--<return>
-- Returns:
-- * 0 if a fine public key was stored in 'store'
-- * 1 if end of public keys
-- [negative] on errors
--</return>
--<example>
--</example>
--<see_also>
--</see_also>
--</function>
-- function libssh2_agent_get_identity(agent: PLIBSSH2_AGENT;
--                 var store: PLIBSSH2_AGENT_PUBLICKEY;
--                 prev: PLIBSSH2_AGENT_PUBLICKEY): Integer; cdecl;
  if not xlibssh2_agent_get_identity then
    xlibssh2_agent_get_identity = register_routine(libssh2,
        "+libssh2_agent_get_identity", LIBSSH2_ROUTINE_DEFINITION)
  end if
  return c_func(xlibssh2_agent_get_identity, {agent, store, prev})
end function

--------------------------------------------------------------------------------

public function libssh2_agent_userauth(atom agent, atom pointer, atom identity)
--<function>
--<name>libssh2_agent_userauth</name>
--<digest>Do publickey user authentication with the help of ssh-agent.</digest>
--<desc>
--</desc>
--<param>
--<type>atom</type>
--<name>agent</name>
--<desc></desc>
--</param>
--<param>
--<type>atom</type>
--<name>pointer</name>
--<desc></desc>
--</param>
--<param>
--<type>atom</type>
--<name>identity</name>
--<desc></desc>
--</param>
--<return>
-- Returns 0 if succeeded, or a negative value for error.
--</return>
--<example>
--</example>
--<see_also>
--</see_also>
--</function>
  if not xlibssh2_agent_userauth then
    xlibssh2_agent_userauth = register_routine(libssh2,
        "+libssh2_agent_userauth", LIBSSH2_ROUTINE_DEFINITION)
  end if
  return c_func(xlibssh2_agent_userauth, {agent, pointer, identity})
end function

--------------------------------------------------------------------------------

public function libssh2_agent_disconnect(atom agent)
--<function>
--<name>libssh2_agent_disconnect</name>
--<digest>Close a connection to an ssh-agent.</digest>
--<desc>
--</desc>
--<param>
--<type>atom</type>
--<name>agent</name>
--<desc></desc>
--</param>
--<return>
-- Returns 0 if succeeded, or a negative value for error.
--</return>
--<example>
--</example>
--<see_also>
--</see_also>
--</function>
  if not xlibssh2_agent_disconnect then
    xlibssh2_agent_disconnect = register_routine(libssh2,
        "+libssh2_agent_disconnect", LIBSSH2_ROUTINE_DEFINITION)
  end if
  return c_func(xlibssh2_agent_disconnect, {agent})
end function

--------------------------------------------------------------------------------

public procedure libssh2_agent_free(atom agent)
--<procedure>
--<name>libssh2_agent_free</name>
--<digest>Free an ssh-agent handle.</digest>
--<desc>
-- also frees the internal collection of public keys.
--</desc>
--<param>
--<type>atom</type>
--<name>agent</name>
--<desc></desc>
--</param>
--<example>
--</example>
--<see_also>
--</see_also>
--</procedure>
  if not xlibssh2_agent_free then
    xlibssh2_agent_free = register_routine(libssh2,
        "+libssh2_agent_free", LIBSSH2_ROUTINE_DEFINITION)
  end if
  c_proc(xlibssh2_agent_free, {agent})
end procedure

--------------------------------------------------------------------------------

public procedure libssh2_keepalive_config(
              atom session, integer want_reply, integer interval)
--<procedure>
--<name>libssh2_keepalive_config</name>
--<digest>Set how often keepalive messages should be sent.</digest>
--<desc>
-- Note that non-blocking applications are responsible for sending the
-- keepalive messages using libssh2_keepalive_send().
--</desc>
--<param>
--<type>atom</type>
--<name>session</name>
--<desc></desc>
--</param>
--<param>
--<type>integer</type>
--<name>want_reply</name>
--<desc>
-- indicates whether the keepalive messages should request a response
-- from the server.
--</desc>
--</param>
--<param>
--<type>integer</type>
--<name>interval</name>
--<desc>
-- number of seconds that can pass without any i/O
-- use 0 (the default) to disable keepalives.
-- To avoid some busy-loop corner-cases, if you specify an interval of 1
-- it will be treated as 2.
--</desc>
--</param>
--<example>
--</example>
--<see_also>
--</see_also>
--</procedure>
  if not xlibssh2_keepalive_config then
    xlibssh2_keepalive_config = register_routine(libssh2,
        "+libssh2_keepalive_config", LIBSSH2_ROUTINE_DEFINITION)
  end if
  c_proc(xlibssh2_keepalive_config, {session, want_reply, interval})
end procedure

--------------------------------------------------------------------------------

public function libssh2_keepalive_send(atom session)
--<function>
--<name>libssh2_keepalive_send</name>
--<digest>Send a keepalive message if needed.</digest>
--<desc>
--</desc>
--<param>
--<type>atom</type>
--<name>session</name>
--<desc>session handle</desc>
--</param>
--<return>
-- Returns how many seconds you can sleep after this call before you need to
-- call it again on success, or -1 if failed.
--</return>
--<example>
--</example>
--<see_also>
--</see_also>
--</function>
  atom seconds_to_next
  integer res

  if not xlibssh2_keepalive_send then
    xlibssh2_keepalive_send = register_routine(libssh2,
        "+libssh2_keepalive_send", LIBSSH2_ROUTINE_DEFINITION)
  end if
  seconds_to_next = allocate(4)
  if c_func(xlibssh2_keepalive_send, {session, seconds_to_next}) then
    free(seconds_to_next)
    error_message("libssh2_keepalive_send failed", 0)
    return -1
  else
    res = peek4s(seconds_to_next)
    free(seconds_to_next)
    return res
  end if
end function

--------------------------------------------------------------------------------

public function libssh2_trace(atom session, integer bitmask)
--<function>
--<name>libssh2_trace</name>
--<digest></digest>
--<desc>
--</desc>
--<param>
--<type>atom</type>
--<name>session</name>
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
  if not xlibssh2_trace then
    xlibssh2_trace = register_routine(libssh2,
        "+libssh2_trace", LIBSSH2_ROUTINE_DEFINITION)
  end if
  return c_func(xlibssh2_trace, {session, bitmask})
end function

--------------------------------------------------------------------------------

public function libssh2_trace_sethandler(
                    atom session, atom context, atom callback)
--<function>
--<name>libssh2_trace_sethandler</name>
--<digest></digest>
--<desc>
--</desc>
--<param>
--<type>atom</type>
--<name>session</name>
--<desc></desc>
--</param>
--<param>
--<type>atom</type>
--<name>context</name>
--<desc></desc>
--</param>
--<param>
--<type>atom</type>
--<name>callback</name>
--<desc></desc>
--</param>
--<return>
--</return>
--<example>
--</example>
--<see_also>
--</see_also>
--</function>
  if not xlibssh2_trace_sethandler then
    xlibssh2_trace_sethandler = register_routine(libssh2,
        "+libssh2_trace_sethandler", LIBSSH2_ROUTINE_DEFINITION)
  end if
  return c_func(xlibssh2_trace_sethandler, {session, context, callback})
end function

--------------------------------------------------------------------------------

public function libssh2_channel_open_session(atom session)
--<function>
--<name>libssh2_channel_open_session</name>
--<digest></digest>
--<desc>
--</desc>
--<param>
--<type>atom</type>
--<name>session</name>
--<desc></desc>
--</param>
--<return>
--</return>
--<example>
--</example>
--<see_also>
--</see_also>
--</function>
  if not xlibssh2_channel_open_ex then
    xlibssh2_channel_open_ex = register_routine(libssh2,
        "+libssh2_channel_open_ex", LIBSSH2_ROUTINE_DEFINITION)
  end if
  return c_func(xlibssh2_channel_open_ex,
                {session, allocate_string("session"), length("session")+1,
                 LIBSSH2_CHANNEL_WINDOW_DEFAULT, LIBSSH2_CHANNEL_PACKET_DEFAULT,
                 NULL, 0})
end function

--------------------------------------------------------------------------------

public function libssh2_channel_direct_tcpip(atom session, 
                    sequence host, integer port, sequence shost, integer sport)
--<function>
--<name>libssh2_channel_direct_tcpip</name>
--<digest></digest>
--<desc>
--</desc>
--<param>
--<type>atom</type>
--<name>session</name>
--<desc></desc>
--</param>
--<param>
--<type>sequence</type>
--<name>host</name>
--<desc></desc>
--</param>
--<param>
--<type>integer</type>
--<name>port</name>
--<desc></desc>
--</param>
--<param>
--<type>sequence</type>
--<name>shost</name>
--<desc></desc>
--</param>
--<param>
--<type>integer</type>
--<name>sport</name>
--<desc></desc>
--</param>
--<return>
--</return>
--<example>
--</example>
--<see_also>
--</see_also>
--</function>
  if not xlibssh2_channel_direct_tcpip_ex then
    xlibssh2_channel_direct_tcpip_ex = register_routine(libssh2,
        "+libssh2_channel_direct_tcpip_ex", LIBSSH2_ROUTINE_DEFINITION)
  end if
  return c_func(xlibssh2_channel_direct_tcpip_ex, {session,
                 allocate_string(host), port, allocate_string(shost), sport})
end function

--------------------------------------------------------------------------------

public function libssh2_channel_forward_listen(atom session, integer port)
--<function>
--<name>libssh2_channel_forward_listen</name>
--<digest></digest>
--<desc>
--</desc>
--<param>
--<type>atom</type>
--<name>session</name>
--<desc></desc>
--</param>
--<param>
--<type>integer</type>
--<name>port</name>
--<desc></desc>
--</param>
--<return>
--</return>
--<example>
--</example>
--<see_also>
--</see_also>
--</function>
-- function libssh2_channel_forward_listen_ex(session: PLIBSSH2_SESSION;
--                                            const host: PAnsiChar;
--                                            port: Integer;
--                                            var bound_port: Integer;
--                                            queue_maxsize: Integer): PLIBSSH2_LISTENER cdecl  ;
  integer i

  if not xlibssh2_channel_forward_listen_ex then
    xlibssh2_channel_forward_listen_ex = register_routine(libssh2,
        "+libssh2_channel_forward_listen_ex", LIBSSH2_ROUTINE_DEFINITION)
  end if
  i = 0
  return c_func(xlibssh2_channel_forward_listen_ex,
                {session, NULL, port, i, 16})
end function

--------------------------------------------------------------------------------

public function libssh2_channel_setenv(atom channel, sequence varname, sequence value)
--<function>
--<name>libssh2_channel_setenv</name>
--<digest></digest>
--<desc>
--</desc>
--<param>
--<type>atom</type>
--<name>channel</name>
--<desc></desc>
--</param>
--<param>
--<type>sequence</type>
--<name>varname</name>
--<desc></desc>
--</param>
--<param>
--<type>sequence</type>
--<name>value</name>
--<desc></desc>
--</param>
--<return>
--</return>
--<example>
--</example>
--<see_also>
--</see_also>
--</function>
  if not xlibssh2_channel_setenv_ex then
    xlibssh2_channel_setenv_ex = register_routine(libssh2,
        "+libssh2_channel_setenv_ex", LIBSSH2_ROUTINE_DEFINITION)
  end if
  return c_func(xlibssh2_channel_setenv_ex,
                {channel, allocate_string(varname), length(varname)+1,
                 allocate_string(value), length(value)+1})
end function

--------------------------------------------------------------------------------

public function libssh2_channel_request_pty(atom channel, sequence term)
--<function>
--<name>libssh2_channel_request_pty</name>
--<digest></digest>
--<desc>
--</desc>
--<param>
--<type>atom</type>
--<name>channel</name>
--<desc></desc>
--</param>
--<param>
--<type>sequence</type>
--<name>term</name>
--<desc></desc>
--</param>
--<return>
--</return>
--<example>
--</example>
--<see_also>
--</see_also>
--</function>
  if not xlibssh2_channel_request_pty_ex then
    xlibssh2_channel_request_pty_ex = register_routine(libssh2,
        "+libssh2_channel_request_pty_ex", LIBSSH2_ROUTINE_DEFINITION)
  end if
  return c_func(xlibssh2_channel_request_pty_ex,
                {channel, allocate_string(term), length(term)+1, NULL, 0,
                LIBSSH2_TERM_WIDTH, LIBSSH2_TERM_HEIGHT,
                LIBSSH2_TERM_WIDTH_PX, LIBSSH2_TERM_HEIGHT_PX})
end function

--------------------------------------------------------------------------------

public function libssh2_channel_request_pty_size(
                    atom channel, integer width, integer height)
--<function>
--<name>libssh2_channel_request_pty_size</name>
--<digest></digest>
--<desc>
--</desc>
--<param>
--<type>atom</type>
--<name>channel</name>
--<desc></desc>
--</param>
--<param>
--<type>integer</type>
--<name>width</name>
--<desc></desc>
--</param>
--<param>
--<type>integer</type>
--<name>height</name>
--<desc></desc>
--</param>
--<return>
--</return>
--<example>
--</example>
--<see_also>
--</see_also>
--</function>
  if not xlibssh2_channel_request_pty_size_ex then
    xlibssh2_channel_request_pty_size_ex = register_routine(libssh2,
        "+libssh2_channel_request_pty_size_ex", LIBSSH2_ROUTINE_DEFINITION)
  end if
  return c_func(xlibssh2_channel_request_pty_size_ex,
                {channel, width, height, 0, 0})
end function

--------------------------------------------------------------------------------

public function libssh2_channel_x11_req(atom channel, integer screen_number)
--<function>
--<name>libssh2_channel_x11_req</name>
--<digest></digest>
--<desc>
--</desc>
--<param>
--<type>atom</type>
--<name>channel</name>
--<desc></desc>
--</param>
--<param>
--<type>integer</type>
--<name>screen_number</name>
--<desc></desc>
--</param>
--<return>
--</return>
--<example>
--</example>
--<see_also>
--</see_also>
--</function>
  if not xlibssh2_channel_x11_req_ex then
    xlibssh2_channel_x11_req_ex = register_routine(libssh2,
        "+libssh2_channel_x11_req_ex", LIBSSH2_ROUTINE_DEFINITION)
  end if
  return c_func(xlibssh2_channel_x11_req_ex,
                {channel, 0, NULL, NULL, screen_number})
end function

--------------------------------------------------------------------------------

public function libssh2_channel_shell(atom channel)
--<function>
--<name>libssh2_channel_shell</name>
--<digest></digest>
--<desc>
--</desc>
--<param>
--<type>atom</type>
--<name>channel</name>
--<desc></desc>
--</param>
--<return>
--</return>
--<example>
--</example>
--<see_also>
--</see_also>
--</function>
  if not xlibssh2_channel_process_startup then
    xlibssh2_channel_process_startup = register_routine(libssh2,
        "+libssh2_channel_process_startup", LIBSSH2_ROUTINE_DEFINITION)
  end if
  return c_func(xlibssh2_channel_process_startup,
                {channel, allocate_string("shell"), length("shell")+1, NULL, 0})
end function

--------------------------------------------------------------------------------

public function libssh2_channel_exec(atom channel, atom buf, integer buflen)
--<function>
--<name>libssh2_channel_exec</name>
--<digest></digest>
--<desc>
--</desc>
--<param>
--<type>atom</type>
--<name>channel</name>
--<desc></desc>
--</param>
--<param>
--<type>atom</type>
--<name>buf</name>
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
  if not xlibssh2_channel_process_startup then
    xlibssh2_channel_process_startup = register_routine(libssh2,
        "+libssh2_channel_process_startup", LIBSSH2_ROUTINE_DEFINITION)
  end if
  return c_func(xlibssh2_channel_process_startup,
                {channel, allocate_string("exec"), length("exec")+1,
                 buf, buflen})
end function

--------------------------------------------------------------------------------

public function libssh2_channel_subsystem(atom channel, sequence subsystem)
--<function>
--<name>libssh2_channel_subsystem</name>
--<digest></digest>
--<desc>
--</desc>
--<param>
--<type>atom</type>
--<name>channel</name>
--<desc></desc>
--</param>
--<param>
--<type>sequence</type>
--<name>subsystem</name>
--<desc></desc>
--</param>
--<return>
--</return>
--<example>
--</example>
--<see_also>
--</see_also>
--</function>
  if not xlibssh2_channel_process_startup then
    xlibssh2_channel_process_startup = register_routine(libssh2,
        "+libssh2_channel_process_startup", LIBSSH2_ROUTINE_DEFINITION)
  end if
  return c_func(xlibssh2_channel_process_startup,
                {channel, allocate_string("subsystem"), length("subsystem")+1,
                 allocate_string(subsystem), length(subsystem)+1})
end function

--------------------------------------------------------------------------------

public function libssh2_channel_read_ex(atom channel, integer stream_id,
                                        atom buf, integer buflen)
--<function>
--<name>libssh2_channel_read_ex</name>
--<digest>read data from a channel stream</digest>
--<desc>
-- Attempt to read data from an active channel stream.
--</desc>
--<param>
--<type>atom</type>
--<name>channel</name>
--<desc>active channel stream to read from.</desc>
--</param>
--<param>
--<type>integer</type>
--<name>stream_id</name>
--<desc>substream ID number (e.g. 0 or SSH_EXTENDED_DATA_STDERR)</desc>
--</param>
--<param>
--<type>atom</type>
--<name>buf</name>
--<desc></desc>
--</param>
--<param>
--<type>integer</type>
--<name>buflen</name>
--<desc></desc>
--</param>
--<return>
-- Actual number of bytes read or negative on failure. It returns
-- LIBSSH2_ERROR_EAGAIN when it would otherwise block. While
-- LIBSSH2_ERROR_EAGAIN is a negative number, it isn't really a failure per se.
--
-- Note that a return value of zero (0) can in fact be a legitimate value and
-- only signals that no payload data was read. It is not an error.
--</return>
--<example>
--</example>
--<see_also>libssh2_poll_channel_read()</see_also>
--</function>
  if not xlibssh2_channel_read_ex then
    xlibssh2_channel_read_ex = register_routine(libssh2,
        "+libssh2_channel_read_ex", LIBSSH2_ROUTINE_DEFINITION)
  end if
  return c_func(xlibssh2_channel_read_ex, {channel, stream_id, buf, buflen})
end function

--------------------------------------------------------------------------------

public function libssh2_channel_read(atom channel, atom buf, integer buflen)
--<function>
--<name>libssh2_channel_read</name>
--<digest>read data from a channel stream</digest>
--<desc>
-- Attempt to read data from an active channel stream.
--</desc>
--<param>
--<type>atom</type>
--<name>channel</name>
--<desc>active channel stream to read from.</desc>
--</param>
--<param>
--<type>atom</type>
--<name>buf</name>
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
  return libssh2_channel_read_ex(channel, 0, buf, buflen)
end function

--------------------------------------------------------------------------------

public function libssh2_channel_read_stderr(atom channel, atom buf, integer buflen)
--<function>
--<name>libssh2_channel_read_stderr</name>
--<digest></digest>
--<desc>
--</desc>
--<param>
--<type>atom</type>
--<name>channel</name>
--<desc></desc>
--</param>
--<param>
--<type>atom</type>
--<name>buf</name>
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
  return libssh2_channel_read_ex(channel, SSH_EXTENDED_DATA_STDERR, buf, buflen)
end function

--------------------------------------------------------------------------------

public function libssh2_channel_window_read(atom channel)
--<function>
--<name>libssh2_channel_window_read</name>
--<digest></digest>
--<desc>
--</desc>
--<param>
--<type>atom</type>
--<name>channel</name>
--<desc></desc>
--</param>
--<return>
--</return>
--<example>
--</example>
--<see_also>
--</see_also>
--</function>
-- function libssh2_channel_window_read_ex(channel: PLIBSSH2_CHANNEL;
--                                         var read_avail: LongInt;
--                                         var window_size_initial: LongInt): ULong; cdecl  ;
  integer i

  if not xlibssh2_channel_window_read_ex then
    xlibssh2_channel_window_read_ex = register_routine(libssh2,
        "+libssh2_channel_window_read_ex", LIBSSH2_ROUTINE_DEFINITION)
  end if
  i = 0
  return c_func(xlibssh2_channel_window_read_ex, {channel, i, i})
end function

--------------------------------------------------------------------------------

public function libssh2_channel_write(atom channel, atom buf, integer buflen)
--<function>
--<name>libssh2_channel_write</name>
--<digest>Check the status of the write window</digest>
--<desc>
-- Returns the number of bytes which may be safely written on the channel
-- without blocking. 'window_size_initial' (if passed) will be populated with
-- the size of the initial window as defined by the channel_open request
--</desc>
--<param>
--<type>atom</type>
--<name>channel</name>
--<desc></desc>
--</param>
--<param>
--<type>atom</type>
--<name>buf</name>
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
  if not xlibssh2_channel_write_ex then
    xlibssh2_channel_write_ex = register_routine(libssh2,
        "+libssh2_channel_write_ex", LIBSSH2_ROUTINE_DEFINITION)
  end if
  return c_func(xlibssh2_channel_write_ex, {channel, 0, buf, buflen})
end function

--------------------------------------------------------------------------------

public function libssh2_channel_write_stderr(
                    atom channel, atom buf, integer buflen)
--<function>
--<name>libssh2_channel_write_stderr</name>
--<digest></digest>
--<desc>
--</desc>
--<param>
--<type>atom</type>
--<name>channel</name>
--<desc></desc>
--</param>
--<param>
--<type>atom</type>
--<name>buf</name>
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
-- function libssh2_channel_window_write_ex(channel: PLIBSSH2_CHANNEL;
--                                          var window_size_initial: LongInt): ULong; cdecl  ;
  if not xlibssh2_channel_window_write_ex then
    xlibssh2_channel_window_write_ex = register_routine(libssh2,
        "+libssh2_channel_window_write_ex", LIBSSH2_ROUTINE_DEFINITION)
  end if
  return c_func(xlibssh2_channel_write_ex,
                {channel, SSH_EXTENDED_DATA_STDERR, buf, buflen})
end function

--------------------------------------------------------------------------------

public function libssh2_channel_window_write(atom channel)
--<function>
--<name>libssh2_channel_window_write</name>
--<digest></digest>
--<desc>
--</desc>
--<param>
--<type>atom</type>
--<name>channel</name>
--<desc></desc>
--</param>
--<return>
--</return>
--<example>
--</example>
--<see_also>
--</see_also>
--</function>
  integer i

  if not xlibssh2_channel_window_write_ex then
    xlibssh2_channel_window_write_ex = register_routine(libssh2,
        "+libssh2_channel_window_write_ex", LIBSSH2_ROUTINE_DEFINITION)
  end if
  i = 0
  return c_func(xlibssh2_channel_window_write_ex, {channel, i})
end function

--------------------------------------------------------------------------------

public procedure libssh2_channel_ignore_extended_data(atom channel, integer ignore)
--<procedure>
--<name>libssh2_channel_ignore_extended_data</name>
--<digest></digest>
--<desc>
-- DEPRECATED
-- Future uses should use libssh2_channel_handle_extended_data() directly if
-- LIBSSH2_CHANNEL_EXTENDED_DATA_MERGE is passed, extended data will be read
-- (FIFO) from the standard data channel
--</desc>
--<param>
--<type>atom</type>
--<name>channel</name>
--<desc></desc>
--</param>
--<param>
--<type>integer</type>
--<name>ignore</name>
--<desc></desc>
--</param>
--<example>
--</example>
--<see_also>
--</see_also>
--</procedure>
  integer i

  if not xlibssh2_channel_handle_extended_data then
    xlibssh2_channel_handle_extended_data = register_routine(libssh2,
        "+libssh2_channel_handle_extended_data", LIBSSH2_ROUTINE_DEFINITION)
  end if
  if ignore != 0 then
    i = LIBSSH2_CHANNEL_EXTENDED_DATA_IGNORE
  else
    i = LIBSSH2_CHANNEL_EXTENDED_DATA_NORMAL
  end if
  c_proc(xlibssh2_channel_handle_extended_data, {channel, i})
end procedure

--------------------------------------------------------------------------------

public function libssh2_channel_flush(atom channel)
--<function>
--<name>libssh2_channel_flush</name>
--<digest></digest>
--<desc>
--</desc>
--<param>
--<type>atom</type>
--<name>channel</name>
--<desc></desc>
--</param>
--<return>
--</return>
--<example>
--</example>
--<see_also>
--</see_also>
--</function>
  if not xlibssh2_channel_flush_ex then
    xlibssh2_channel_flush_ex = register_routine(libssh2,
        "+libssh2_channel_flush_ex", LIBSSH2_ROUTINE_DEFINITION)
  end if
  return c_func(xlibssh2_channel_flush_ex, {channel, 0})
end function

--------------------------------------------------------------------------------

public function libssh2_channel_flush_stderr(atom channel)
--<function>
--<name>libssh2_channel_flush_stderr</name>
--<digest></digest>
--<desc>
--</desc>
--<param>
--<type>atom</type>
--<name>channel</name>
--<desc></desc>
--</param>
--<return>
--</return>
--<example>
--</example>
--<see_also>
--</see_also>
--</function>
  if not xlibssh2_channel_flush_ex then
    xlibssh2_channel_flush_ex = register_routine(libssh2,
        "+libssh2_channel_flush_ex", LIBSSH2_ROUTINE_DEFINITION)
  end if
  return c_func(xlibssh2_channel_flush_ex, {channel, SSH_EXTENDED_DATA_STDERR})
end function

--------------------------------------------------------------------------------
-- SCP
--------------------------------------------------------------------------------

--------------------------------------------------------------------------------

public function libssh2_scp_send(
                    atom session, atom path, integer mode, integer size)
--<function>
--<name>libssh2_scp_send</name>
--<digest>Send a file via SCP</digest>
--<desc>
-- Deprecated since libssh2 1.2.6. Use <i>libssh2_scp_send64()</i> instead.
--</desc>
--<param>
--<type>atom</type>
--<name>session</name>
--<desc>Session instance as returned by libssh2_session_init_ex()</desc>
--</param>
--<param>
--<type>atom</type>
--<name>path</name>
--<desc>Full path and filename of file to transfer to. That is the remote file name.</desc>
--</param>
--<param>
--<type>integer</type>
--<name>mode</name>
--<desc>File access mode to create file with</desc>
--</param>
--<param>
--<type>integer</type>
--<name>size</name>
--<desc>Size of file being transmitted (Must be known ahead of time precisely)</desc>
--</param>
--<return>
-- Pointer to a newly allocated LIBSSH2_CHANNEL instance, or NULL on errors.
--</return>
--<example>
--</example>
--<see_also>libssh2_channel_open(), libssh2_scp_send64()</see_also>
--</function>
  if not xlibssh2_scp_send_ex then
    xlibssh2_scp_send_ex = register_routine(libssh2,
        "+libssh2_scp_send_ex", LIBSSH2_ROUTINE_DEFINITION)
  end if
  return c_func(xlibssh2_scp_send_ex, {session, path, mode, size, 0, 0})
end function

--------------------------------------------------------------------------------

public function libssh2_scp_send64(atom session, atom path,
                    integer mode, atom size, atom mtime, atom atime)
--<function>
--<name>libssh2_scp_send64</name>
--<digest>Send a file via SCP</digest>
--<desc>
--</desc>
--<param>
--<type>atom</type>
--<name>session</name>
--<desc>Session instance as returned by libssh2_session_init()</desc>
--</param>
--<param>
--<type>atom</type>
--<name>path</name>
--<desc>Full path and filename of file to transfer to. That is the remote file name.</desc>
--</param>
--<param>
--<type>integer</type>
--<name>mode</name>
--<desc>File access mode to create file with</desc>
--</param>
--<param>
--<type>atom</type>
--<name>size</name>
--<desc>
-- Size of file being transmitted (Must be known ahead of time).
-- Note that this needs to be passed on as variable type libssh2_uint64_t.
-- This type is 64 bit on modern operating systems and compilers.
--</desc>
--</param>
--<param>
--<type>atom</type>
--<name>mtime</name>
--<desc>mtime to assign to file being created</desc>
--</param>
--<param>
--<type>atom</type>
--<name>atime</name>
--<desc>
-- atime to assign to file being created (Set this and mtime to zero to
-- instruct remote host to use current time).
--</desc>
--</param>
--<return>
-- Pointer to a newly allocated LIBSSH2_CHANNEL instance, or NULL on errors.
--</return>
--<example>
--</example>
--<see_also>libssh2_channel_open()</see_also>
--</function>
  if not xlibssh2_scp_send64 then
    xlibssh2_scp_send64 = register_routine(libssh2,
        "+libssh2_scp_send64", LIBSSH2_ROUTINE_DEFINITION)
  end if
  return c_func(xlibssh2_scp_send64, {session, path, mode, size, mtime, atime})
end function

public function libssh2_scp_recv(atom session, atom path, atom sb)
--<function>
--<name>libssh2_scp_recv</name>
--<digest>request a remote file via SCP</digest>
--<desc>
-- This receives files larger than 2 GB, but is unable to report the proper size
-- on platforms where the st_size member of struct stat is limited to 2 GB
-- (e.g. windows).
--</desc>
--<param>
--<type>atom</type>
--<name>session</name>
--<desc>Session instance as returned by libssh2_session_init()</desc>
--</param>
--<param>
--<type>atom</type>
--<name>path</name>
--<desc>Full path and filename of file to transfer. That is the remote file name.</desc>
--</param>
--<param>
--<type>atom</type>
--<name>sb</name>
--<desc>Populated with remote file's size, mode, mtime, and atime</desc>
--</param>
--<return>
-- Pointer to a newly allocated LIBSSH2_CHANNEL instance, or NULL on errors.
--</return>
--<example>
--</example>
--<see_also>libssh2_session_init(), libssh2_channel_open()</see_also>
--</function>
-- function libssh2_scp_recv(session: PLIBSSH2_SESSION;
--                           const path: PAnsiChar;
--                           var sb: struct_stat): PLIBSSH2_CHANNEL; cdecl  ;
  if not xlibssh2_scp_recv then
    xlibssh2_scp_recv = register_routine(libssh2,
        "+libssh2_scp_recv", LIBSSH2_ROUTINE_DEFINITION)
  end if
  return c_func(xlibssh2_scp_recv, {session, path, sb})
end function

--------------------------------------------------------------------------------
-- Publickey Subsystem
--------------------------------------------------------------------------------

--public function libssh2_publickey_init(atom session)

--xlibssh2_publickey_add_ex(atom pkey,
--                                         const unsigned char *name,
--                                         unsigned long name_len,
--                                         const unsigned char *blob,
--                                         unsigned long blob_len, char overwrite,
--                                         unsigned long num_attrs,
--                                         const libssh2_publickey_attribute attrs[]);
--
--public function libssh2_publickey_add(atom pkey, sequence name, blob, blob_len, overwrite,
--                              num_attrs, attrs)
--  atom addr
--
--  addr = allocate_string(name)
--  res = c_func(xlibssh2_publickey_add_ex,
--               {pkey, name, length(name)+1, blob, blob_len, overwrite,
--                num_attrs, attrs})
--  free(addr)
--  return res
--end function

--xlibssh2_publickey_remove_ex(PLIBSSH2_PUBLICKEY pkey,
--                                            const unsigned char *name,
--                                            unsigned long name_len,
--                                            const unsigned char *blob,
--                                            unsigned long blob_len);
--public function libssh2_publickey_remove(pkey, name, blob, blob_len) \
--  libssh2_publickey_remove_ex((pkey), (name), strlen(name), (blob), (blob_len))

--public function libssh2_publickey_list_fetch(PLIBSSH2_PUBLICKEY pkey,
--                             unsigned long *num_keys,
--                             libssh2_publickey_list **pkey_list);
--public procedure libssh2_publickey_list_free(PLIBSSH2_PUBLICKEY pkey,
--                                             libssh2_publickey_list *pkey_list);

--public function libssh2_publickey_shutdown(PLIBSSH2_PUBLICKEY pkey);

