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

-- We use underscore instead of dash when appending CVS in dev versions just
-- to make the BANNER define (used by src/session.c) be a valid SSH
-- banner. Release versions have no appended strings and may of course not
-- have dashes either.
public constant
  LIBSSH2_VERSION = "1.2.9"
--<constant>
--<name>LIBSSH2_VERSION</name>
--<value>"1.2.9"</value>
--<desc></desc>
--</constant>

-- The numeric version number is also available "in parts" by using these
-- defines:
public constant
  LIBSSH2_VERSION_MAJOR = 1,
--<constant>
--<name>LIBSSH2_VERSION_MAJOR</name>
--<value>1</value>
--<desc></desc>
--</constant>
  LIBSSH2_VERSION_MINOR = 2,
--<constant>
--<name>LIBSSH2_VERSION_MINOR</name>
--<value>2</value>
--<desc></desc>
--</constant>
  LIBSSH2_VERSION_PATCH = 9
--<constant>
--<name>LIBSSH2_VERSION_PATCH</name>
--<value>6</value>
--<desc></desc>
--</constant>

public constant
  SHA_DIGEST_LENGTH = 20,
--<constant>
--<name>SHA_DIGEST_LENGTH</name>
--<value>20</value>
--<desc></desc>
--</constant>
  MD5_DIGEST_LENGTH = 16
--<constant>
--<name>MD5_DIGEST_LENGTH</name>
--<value>16</value>
--<desc></desc>
--</constant>


-- This is the numeric version of the libssh2 version number, meant for easier
-- parsing and comparions by programs. The LIBSSH2_VERSION_NUM define will
-- always follow this syntax:

-- 0xXXYYZZ

-- Where XX, YY and ZZ are the main version, release and patch numbers in
-- hexadecimal (using 8 bits each). All three numbers are always represented
-- using two digits. 1.2 would appear as "0x010200" while version 9.11.7
-- appears as "0x090b07".

-- This 6-digit (24 bits) hexadecimal number does not show pre-release number,
-- and it is always a greater number in a more recent release. It makes
-- comparisons with greater than and less than work.
--
public constant
  LIBSSH2_VERSION_NUM = #010209
--<constant>
--<name>LIBSSH2_VERSION_NUM</name>
--<value>#010206</value>
--<desc></desc>
--</constant>

--
---- This is the date and time when the full source package was created. The
---- timestamp is not stored in CVS, as the timestamp is properly set in the
---- tarballs by the maketgz script.
----
---- The format of the date should follow this template:
----
---- "Mon Feb 12 11:35:33 UTC 2007"
--
public constant
  LIBSSH2_TIMESTAMP = "Sat Aug 13 08:19:51 UTC 2011"
--<constant>
--<name>LIBSSH2_TIMESTAMP</name>
--<value>"Sat Aug 13 08:19:51 UTC 2011"</value>
--<desc></desc>
--</constant>

-- Part of every banner, user specified or not
public constant
  LIBSSH2_SSH_BANNER = "SSH-2.0-libssh2_" & LIBSSH2_VERSION
--<constant>
--<name>LIBSSH2_SSH_BANNER</name>
--<value>"SSH-2.0-libssh2_1.2.9"</value>
--<desc></desc>
--</constant>

-- We*could* add a comment here if we so chose
public constant
  LIBSSH2_SSH_DEFAULT_BANNER = LIBSSH2_SSH_BANNER
--<constant>
--<name>LIBSSH2_SSH_DEFAULT_BANNER</name>
--<value>"SSH-2.0-libssh2_1.2.9"</value>
--<desc></desc>
--</constant>
public constant
  LIBSSH2_SSH_DEFAULT_BANNER_WITH_CRLF = LIBSSH2_SSH_DEFAULT_BANNER & "\r\n"
--<constant>
--<name>LIBSSH2_SSH_DEFAULT_BANNER_WITH_CRLF</name>
--<value>LIBSSH2_SSH_DEFAULT_BANNER & "\r\n"</value>
--<desc>"SSH-2.0-libssh2_1.2.9\r\n"</desc>
--</constant>

-- Default generate and safe prime sizes for diffie-hellman-group-exchange-sha1
public constant
  LIBSSH2_DH_GEX_MINGROUP = 1024,
--<constant>
--<name>LIBSSH2_DH_GEX_MINGROUP</name>
--<value>1024</value>
--<desc></desc>
--</constant>
  LIBSSH2_DH_GEX_OPTGROUP = 1536,
--<constant>
--<name>LIBSSH2_DH_GEX_OPTGROUP</name>
--<value>1536</value>
--<desc></desc>
--</constant>
  LIBSSH2_DH_GEX_MAXGROUP = 2048
--<constant>
--<name>LIBSSH2_DH_GEX_MAXGROUP</name>
--<value>2048</value>
--<desc></desc>
--</constant>

-- Defaults for pty requests*/
public constant
  LIBSSH2_TERM_WIDTH     = 80,
--<constant>
--<name>LIBSSH2_TERM_WIDTH</name>
--<value>80</value>
--<desc></desc>
--</constant>
  LIBSSH2_TERM_HEIGHT    = 24,
--<constant>
--<name>LIBSSH2_TERM_HEIGHT</name>
--<value>24</value>
--<desc></desc>
--</constant>
  LIBSSH2_TERM_WIDTH_PX  = 0,
--<constant>
--<name>LIBSSH2_TERM_WIDTH_PX</name>
--<value>0</value>
--<desc></desc>
--</constant>
  LIBSSH2_TERM_HEIGHT_PX = 0
--<constant>
--<name>LIBSSH2_TERM_HEIGHT_PX</name>
--<value>0</value>
--<desc></desc>
--</constant>

public constant
  LIBSSH2_SOCKET_POLL_UDELAY = 250000
--<constant>
--<name>LIBSSH2_SOCKET_POLL_UDELAY</name>
--<value>250000</value>
--<desc>1/4 second</desc>
--</constant>

public constant
  LIBSSH2_SOCKET_POLL_MAXLOOPS = 120
--<constant>
--<name>LIBSSH2_SOCKET_POLL_MAXLOOPS</name>
--<value>120</value>
--<desc> 0.25 * 120 = 30 seconds</desc>
--</constant>

public constant
  LIBSSH2_PACKET_MAXCOMP = 32000
--<constant>
--<name>LIBSSH2_PACKET_MAXCOMP</name>
--<value>32000</value>
--<desc>
-- Maximum size to allow a payload to compress to, plays it safe by falling
-- short of spec limits
--</desc>
--</constant>

public constant
  LIBSSH2_PACKET_MAXDECOMP = 40000
--<constant>
--<name>LIBSSH2_PACKET_MAXDECOMP</name>
--<value>40000</value>
--<desc>
-- Maximum size to allow a payload to deccompress to, plays it safe by
-- allowing more than spec requires
--</desc>
--</constant>

public constant
  LIBSSH2_PACKET_MAXPAYLOAD = 40000
--<constant>
--<name>LIBSSH2_PACKET_MAXPAYLOAD</name>
--<value>40000</value>
--<desc>
-- Maximum size for an inbound compressed payload, plays it safe by
-- overshooting spec limits
--</desc>
--</constant>

-- libssh2_session_callback_set() constants*/
public constant
  LIBSSH2_CALLBACK_IGNORE     = 0,
--<constant>
--<name>LIBSSH2_CALLBACK_IGNORE</name>
--<value>0</value>
--<desc>Called when a SSH_MSG_IGNORE message is received</desc>
--</constant>
  LIBSSH2_CALLBACK_DEBUG      = 1,
--<constant>
--<name>LIBSSH2_CALLBACK_DEBUG</name>
--<value>1</value>
--<desc>Called when a SSH_MSG_DEBUG message is received</desc>
--</constant>
  LIBSSH2_CALLBACK_DISCONNECT = 2,
--<constant>
--<name>LIBSSH2_CALLBACK_DISCONNECT</name>
--<value>2</value>
--<desc>Called when a SSH_MSG_DISCONNECT message is received</desc>
--</constant>
  LIBSSH2_CALLBACK_MACERROR   = 3,
--<constant>
--<name>LIBSSH2_CALLBACK_MACERROR</name>
--<value>3</value>
--<desc>
-- Called when a mismatched MAC has been detected in the transport layer. If the
-- function returns 0, the packet will be accepted nonetheless.
--</desc>
--</constant>
  LIBSSH2_CALLBACK_X11        = 4
--<constant>
--<name>LIBSSH2_CALLBACK_X11</name>
--<value>4</value>
--<desc>Called when an X11 connection has been accepted</desc>
--</constant>

-- libssh2_session_method_pref() constants
public constant
  LIBSSH2_METHOD_KEX      = 0,
--<constant>
--<name>LIBSSH2_METHOD_KEX</name>
--<value>0</value>
--<desc></desc>
--</constant>
  LIBSSH2_METHOD_HOSTKEY  = 1,
--<constant>
--<name>LIBSSH2_METHOD_HOSTKEY</name>
--<value>1</value>
--<desc></desc>
--</constant>
  LIBSSH2_METHOD_CRYPT_CS = 2,
--<constant>
--<name>LIBSSH2_METHOD_CRYPT_CS</name>
--<value>2</value>
--<desc></desc>
--</constant>
  LIBSSH2_METHOD_CRYPT_SC = 3,
--<constant>
--<name>LIBSSH2_METHOD_CRYPT_SC</name>
--<value>3</value>
--<desc></desc>
--</constant>
  LIBSSH2_METHOD_MAC_CS   = 4,
--<constant>
--<name>LIBSSH2_METHOD_MAC_CS</name>
--<value>4</value>
--<desc></desc>
--</constant>
  LIBSSH2_METHOD_MAC_SC   = 5,
--<constant>
--<name>LIBSSH2_METHOD_MAC_SC</name>
--<value>5</value>
--<desc></desc>
--</constant>
  LIBSSH2_METHOD_COMP_CS  = 6,
--<constant>
--<name>LIBSSH2_METHOD_COMP_CS</name>
--<value>6</value>
--<desc></desc>
--</constant>
  LIBSSH2_METHOD_COMP_SC  = 7,
--<constant>
--<name>LIBSSH2_METHOD_COMP_SC</name>
--<value>7</value>
--<desc></desc>
--</constant>
  LIBSSH2_METHOD_LANG_CS  = 8,
--<constant>
--<name>LIBSSH2_METHOD_LANG_CS</name>
--<value>8</value>
--<desc></desc>
--</constant>
  LIBSSH2_METHOD_LANG_SC  = 9
--<constant>
--<name>LIBSSH2_METHOD_LANG_SC</name>
--<value>9</value>
--<desc></desc>
--</constant>

-- session.flags bits*/
public constant
  LIBSSH2_FLAG_SIGPIPE = #00000001,
--<constant>
--<name>LIBSSH2_FLAG_SIGPIPE</name>
--<value>#00000001</value>
--<desc></desc>
--</constant>
  LIBSSH2_FLAG_COMPRESS = #00000002
--<constant>
--<name>LIBSSH2_FLAG_COMPRESS</name>
--<value>#00000002</value>
--<desc></desc>
--</constant>

--  Requested Events
--  Returned Events

-- Poll FD Descriptor Types*/
public constant
  LIBSSH2_POLLFD_SOCKET   = 1,
--<constant>
--<name>LIBSSH2_POLLFD_SOCKET</name>
--<value>1</value>
--<desc></desc>
--</constant>
  LIBSSH2_POLLFD_CHANNEL  = 2,
--<constant>
--<name>LIBSSH2_POLLFD_CHANNEL</name>
--<value>2</value>
--<desc></desc>
--</constant>
  LIBSSH2_POLLFD_LISTENER = 3
--<constant>
--<name>LIBSSH2_POLLFD_LISTENER</name>
--<value>3</value>
--<desc></desc>
--</constant>

-- Note: Win32 Doesn't actually have a poll() implementation, so some of these
-- values are faked with select() data
-- Poll FD events/revents -- Match sys/poll.h where possible*/
public constant
  LIBSSH2_POLLFD_POLLIN          = #0001,
--<constant>
--<name>LIBSSH2_POLLFD_POLLIN</name>
--<value>#0001</value>
--<desc>Data available to be read</desc>
--</constant>
  LIBSSH2_POLLFD_POLLPRI         = #0002,
--<constant>
--<name>LIBSSH2_POLLFD_POLLPRI</name>
--<value>#0002</value>
--<desc>Priority data available to be read, -- Socket only</desc>
--</constant>
  LIBSSH2_POLLFD_POLLEXT         = #0002, -- Extended data available to be read, -- Channel only
--<constant>
--<name>LIBSSH2_POLLFD_POLLEXT</name>
--<value>#0002</value>
--<desc></desc>
--</constant>
  LIBSSH2_POLLFD_POLLOUT         = #0004, -- Can may be written -- Socket/Channel
--<constant>
--<name>LIBSSH2_POLLFD_POLLOUT</name>
--<value>#0004</value>
--<desc></desc>
--</constant>
  LIBSSH2_POLLFD_POLLERR         = #0008, -- Error Condition -- Socket
--<constant>
--<name>LIBSSH2_POLLFD_POLLERR</name>
--<value>#0008</value>
--<desc></desc>
--</constant>
  LIBSSH2_POLLFD_POLLHUP         = #0010, -- HangUp/EOF -- Socket
--<constant>
--<name>LIBSSH2_POLLFD_POLLHUP</name>
--<value>#0010</value>
--<desc></desc>
--</constant>
  LIBSSH2_POLLFD_SESSION_CLOSED  = #0010, -- Session Disconnect
  LIBSSH2_POLLFD_POLLNVAL        = #0020, -- Invalid request -- Socket Only
  LIBSSH2_POLLFD_POLLEX          = #0040, -- Exception Condition -- Socket/Win32
  LIBSSH2_POLLFD_CHANNEL_CLOSED  = #0080, -- Channel Disconnect
  LIBSSH2_POLLFD_LISTENER_CLOSED = #0080  -- Listener Disconnect
--<constant>
--<name>LIBSSH2_POLLFD_SESSION_CLOSED</name>
--<value>#0010</value>
--<desc></desc>
--</constant>
--<constant>
--<name>LIBSSH2_POLLFD_POLLNVAL</name>
--<value>#0020</value>
--<desc></desc>
--</constant>
--<constant>
--<name>LIBSSH2_POLLFD_POLLEX</name>
--<value>#0040</value>
--<desc></desc>
--</constant>
--<constant>
--<name>LIBSSH2_POLLFD_CHANNEL_CLOSED</name>
--<value>#0080</value>
--<desc></desc>
--</constant>
--<constant>
--<name>LIBSSH2_POLLFD_LISTENER_CLOSED</name>
--<value>#0080</value>
--<desc></desc>
--</constant>

public constant
  HAVE_LIBSSH2_SESSION_BLOCK_DIRECTION = 1
--<constant>
--<name>HAVE_LIBSSH2_SESSION_BLOCK_DIRECTION</name>
--<value>1</value>
--<desc></desc>
--</constant>

-- Block Direction Types
public constant
  LIBSSH2_SESSION_BLOCK_INBOUND  = #0001,
  LIBSSH2_SESSION_BLOCK_OUTBOUND = #0002
--<constant>
--<name>LIBSSH2_SESSION_BLOCK_INBOUND</name>
--<value>#0001</value>
--<desc></desc>
--</constant>
--<constant>
--<name>LIBSSH2_SESSION_BLOCK_OUTBOUND</name>
--<value>#0002</value>
--<desc></desc>
--</constant>

-- Hash Types
public constant
  LIBSSH2_HOSTKEY_HASH_MD5  = 1,
  LIBSSH2_HOSTKEY_HASH_SHA1 = 2
--<constant>
--<name>LIBSSH2_HOSTKEY_HASH_MD5</name>
--<value>1</value>
--<desc></desc>
--</constant>
--<constant>
--<name>LIBSSH2_HOSTKEY_HASH_SHA1</name>
--<value>2</value>
--<desc></desc>
--</constant>

-- Hostkey Types
public constant
  LIBSSH2_HOSTKEY_TYPE_UNKNOWN = 0,
  LIBSSH2_HOSTKEY_TYPE_RSA     = 1,
  LIBSSH2_HOSTKEY_TYPE_DSS     = 2
--<constant>
--<name>LIBSSH2_HOSTKEY_TYPE_UNKNOWN</name>
--<value>0</value>
--<desc></desc>
--</constant>
--<constant>
--<name>LIBSSH2_HOSTKEY_TYPE_RSA</name>
--<value>1</value>
--<desc></desc>
--</constant>
--<constant>
--<name>LIBSSH2_HOSTKEY_TYPE_DSS</name>
--<value>2</value>
--<desc></desc>
--</constant>

-- Disconnect Codes (defined by SSH protocol)
public constant
  SSH_DISCONNECT_HOST_NOT_ALLOWED_TO_CONNECT    =  1,
  SSH_DISCONNECT_PROTOCOL_ERROR                 =  2,
  SSH_DISCONNECT_KEY_EXCHANGE_FAILED            =  3,
  SSH_DISCONNECT_RESERVED                       =  4,
  SSH_DISCONNECT_MAC_ERROR                      =  5,
  SSH_DISCONNECT_COMPRESSION_ERROR              =  6,
  SSH_DISCONNECT_SERVICE_NOT_AVAILABLE          =  7,
  SSH_DISCONNECT_PROTOCOL_VERSION_NOT_SUPPORTED =  8,
  SSH_DISCONNECT_HOST_KEY_NOT_VERIFIABLE        =  9,
  SSH_DISCONNECT_CONNECTION_LOST                = 10,
  SSH_DISCONNECT_BY_APPLICATION                 = 11,
  SSH_DISCONNECT_TOO_MANY_CONNECTIONS           = 12,
  SSH_DISCONNECT_AUTH_CANCELLED_BY_USER         = 13,
  SSH_DISCONNECT_NO_MORE_AUTH_METHODS_AVAILABLE = 14,
  SSH_DISCONNECT_ILLEGAL_USER_NAME              = 15
--<constant>
--<name>SSH_DISCONNECT_HOST_NOT_ALLOWED_TO_CONNECT</name>
--<value>1</value>
--<desc></desc>
--</constant>
--<constant>
--<name>SSH_DISCONNECT_PROTOCOL_ERROR</name>
--<value>2</value>
--<desc></desc>
--</constant>
--<constant>
--<name>SSH_DISCONNECT_KEY_EXCHANGE_FAILED</name>
--<value>3</value>
--<desc></desc>
--</constant>
--<constant>
--<name>SSH_DISCONNECT_RESERVED</name>
--<value>4</value>
--<desc></desc>
--</constant>
--<constant>
--<name>SSH_DISCONNECT_MAC_ERROR</name>
--<value>5</value>
--<desc></desc>
--</constant>
--<constant>
--<name>SSH_DISCONNECT_COMPRESSION_ERROR</name>
--<value>6</value>
--<desc></desc>
--</constant>
--<constant>
--<name>SSH_DISCONNECT_SERVICE_NOT_AVAILABLE</name>
--<value>7</value>
--<desc></desc>
--</constant>
--<constant>
--<name>SSH_DISCONNECT_PROTOCOL_VERSION_NOT_SUPPORTED</name>
--<value>8</value>
--<desc></desc>
--</constant>
--<constant>
--<name>SSH_DISCONNECT_HOST_KEY_NOT_VERIFIABLE</name>
--<value>9</value>
--<desc></desc>
--</constant>
--<constant>
--<name>SSH_DISCONNECT_CONNECTION_LOST</name>
--<value>10</value>
--<desc></desc>
--</constant>
--<constant>
--<name>SSH_DISCONNECT_BY_APPLICATION</name>
--<value>11</value>
--<desc></desc>
--</constant>
--<constant>
--<name>SSH_DISCONNECT_TOO_MANY_CONNECTIONS</name>
--<value>12</value>
--<desc></desc>
--</constant>
--<constant>
--<name>SSH_DISCONNECT_AUTH_CANCELLED_BY_USER</name>
--<value>13</value>
--<desc></desc>
--</constant>
--<constant>
--<name>SSH_DISCONNECT_NO_MORE_AUTH_METHODS_AVAILABLE</name>
--<value>14</value>
--<desc></desc>
--</constant>
--<constant>
--<name>SSH_DISCONNECT_ILLEGAL_USER_NAME</name>
--<value>15</value>
--<desc></desc>
--</constant>

-- Error Codes (defined by libssh2)*/
public constant
  LIBSSH2_ERROR_NONE = 0
--<constant>
--<name>LIBSSH2_ERROR_NONE</name>
--<value>0</value>
--<desc></desc>
--</constant>
public constant
  LIBSSH2_ERROR_SOCKET_NONE             =  -1,
  LIBSSH2_ERROR_BANNER_NONE             =  -2,
  LIBSSH2_ERROR_BANNER_SEND             =  -3,
  LIBSSH2_ERROR_INVALID_MAC             =  -4,
  LIBSSH2_ERROR_KEX_FAILURE             =  -5,
  LIBSSH2_ERROR_ALLOC                   =  -6,
  LIBSSH2_ERROR_SOCKET_SEND             =  -7,
  LIBSSH2_ERROR_KEY_EXCHANGE_FAILURE    =  -8,
  LIBSSH2_ERROR_TIMEOUT                 =  -9,
  LIBSSH2_ERROR_HOSTKEY_INIT            = -10,
  LIBSSH2_ERROR_HOSTKEY_SIGN            = -11,
  LIBSSH2_ERROR_DECRYPT                 = -12,
  LIBSSH2_ERROR_SOCKET_DISCONNECT       = -13,
  LIBSSH2_ERROR_PROTO                   = -14,
  LIBSSH2_ERROR_PASSWORD_EXPIRED        = -15,
  LIBSSH2_ERROR_FILE                    = -16,
  LIBSSH2_ERROR_METHOD_NONE             = -17,
  LIBSSH2_ERROR_AUTHENTICATION_FAILED   = -18,
  LIBSSH2_ERROR_PUBLICKEY_UNRECOGNIZED  = LIBSSH2_ERROR_AUTHENTICATION_FAILED,
  LIBSSH2_ERROR_PUBLICKEY_UNVERIFIED    = -19,
  LIBSSH2_ERROR_CHANNEL_OUTOFORDER      = -20,
  LIBSSH2_ERROR_CHANNEL_FAILURE         = -21,
  LIBSSH2_ERROR_CHANNEL_REQUEST_DENIED  = -22,
  LIBSSH2_ERROR_CHANNEL_UNKNOWN         = -23,
  LIBSSH2_ERROR_CHANNEL_WINDOW_EXCEEDED = -24,
  LIBSSH2_ERROR_CHANNEL_PACKET_EXCEEDED = -25,
  LIBSSH2_ERROR_CHANNEL_CLOSED          = -26,
  LIBSSH2_ERROR_CHANNEL_EOF_SENT        = -27,
  LIBSSH2_ERROR_SCP_PROTOCOL            = -28,
  LIBSSH2_ERROR_ZLIB                    = -29,
  LIBSSH2_ERROR_SOCKET_TIMEOUT          = -30,
  LIBSSH2_ERROR_SFTP_PROTOCOL           = -31,
  LIBSSH2_ERROR_REQUEST_DENIED          = -32,
  LIBSSH2_ERROR_METHOD_NOT_SUPPORTED    = -33,
  LIBSSH2_ERROR_INVAL                   = -34,
  LIBSSH2_ERROR_INVALID_POLL_TYPE       = -35,
  LIBSSH2_ERROR_PUBLICKEY_PROTOCOL      = -36,
  LIBSSH2_ERROR_EAGAIN                  = -37,
  LIBSSH2_ERROR_BUFFER_TOO_SMALL        = -38,
  LIBSSH2_ERROR_BAD_USE                 = -39,
  LIBSSH2_ERROR_COMPRESS                = -40,
  LIBSSH2_ERROR_OUT_OF_BOUNDARY         = -41,
  LIBSSH2_ERROR_AGENT_PROTOCOL          = -42
--<constant>
--<name>LIBSSH2_ERROR_SOCKET_NONE</name>
--<value>-1</value>
--<desc>The socket is invalid.</desc>
--</constant>
--<constant>
--<name>LIBSSH2_ERROR_BANNER_NONE</name>
--<value>-2</value>
--<desc></desc>
--</constant>
--<constant>
--<name>LIBSSH2_ERROR_BANNER_SEND</name>
--<value>-3</value>
--<desc>Unable to send banner to remote host.</desc>
--</constant>
--<constant>
--<name>LIBSSH2_ERROR_INVALID_MAC</name>
--<value>-4</value>
--<desc></desc>
--</constant>
--<constant>
--<name>LIBSSH2_ERROR_KEX_FAILURE</name>
--<value>-5</value>
--<desc>Encryption key exchange with the remote host failed.</desc>
--</constant>
--<constant>
--<name>LIBSSH2_ERROR_ALLOC</name>
--<value>-6</value>
--<desc>An internal memory allocation call failed.</desc>
--</constant>
--<constant>
--<name>LIBSSH2_ERROR_SOCKET_SEND</name>
--<value>-7</value>
--<desc>Unable to send data on socket.</desc>
--</constant>
--<constant>
--<name>LIBSSH2_ERROR_KEY_EXCHANGE_FAILURE</name>
--<value>-8</value>
--<desc></desc>
--</constant>
--<constant>
--<name>LIBSSH2_ERROR_TIMEOUT</name>
--<value>-9</value>
--<desc>timeout for blocking functions occured.</desc>
--</constant>
--<constant>
--<name>LIBSSH2_ERROR_HOSTKEY_INIT</name>
--<value>-10</value>
--<desc></desc>
--</constant>
--<constant>
--<name>LIBSSH2_ERROR_HOSTKEY_SIGN</name>
--<value>-11</value>
--<desc></desc>
--</constant>
--<constant>
--<name>LIBSSH2_ERROR_DECRYPT</name>
--<value>-12</value>
--<desc></desc>
--</constant>
--<constant>
--<name>LIBSSH2_ERROR_SOCKET_DISCONNECT</name>
--<value>-13</value>
--<desc></desc>
--</constant>
--<constant>
--<name>LIBSSH2_ERROR_PROTO</name>
--<value>-14</value>
--<desc>An invalid SSH protocol response was received on the socket.</desc>
--</constant>
--<constant>
--<name>LIBSSH2_ERROR_PASSWORD_EXPIRED</name>
--<value>-15</value>
--<desc></desc>
--</constant>
--<constant>
--<name>LIBSSH2_ERROR_FILE</name>
--<value>-16</value>
--<desc></desc>
--</constant>
--<constant>
--<name>LIBSSH2_ERROR_METHOD_NONE</name>
--<value>-17</value>
--<desc>no method has been set</desc>
--</constant>
--<constant>
--<name>LIBSSH2_ERROR_AUTHENTICATION_FAILED</name>
--<value>-18</value>
--<desc>Failed, Invalid username/password or public/private key.</desc>
--</constant>
--<constant>
--<name>LIBSSH2_ERROR_PUBLICKEY_UNRECOGNIZED</name>
--<value>LIBSSH2_ERROR_AUTHENTICATION_FAILED</value>
--<desc>Authentication using the supplied public key was not accepted.</desc>
--</constant>
--<constant>
--<name>LIBSSH2_ERROR_PUBLICKEY_UNVERIFIED</name>
--<value>-19</value>
--<desc>The username/public key combination was invalid.</desc>
--</constant>
--<constant>
--<name>LIBSSH2_ERROR_CHANNEL_OUTOFORDER</name>
--<value>-20</value>
--<desc></desc>
--</constant>
--<constant>
--<name>LIBSSH2_ERROR_CHANNEL_FAILURE</name>
--<value>-21</value>
--<desc></desc>
--</constant>
--<constant>
--<name>LIBSSH2_ERROR_CHANNEL_REQUEST_DENIED</name>
--<value>-22</value>
--<desc></desc>
--</constant>
--<constant>
--<name>LIBSSH2_ERROR_CHANNEL_UNKNOWN</name>
--<value>-23</value>
--<desc></desc>
--</constant>
--<constant>
--<name>LIBSSH2_ERROR_CHANNEL_WINDOW_EXCEEDED</name>
--<value>-24</value>
--<desc></desc>
--</constant>
--<constant>
--<name>LIBSSH2_ERROR_CHANNEL_PACKET_EXCEEDED</name>
--<value>-25</value>
--<desc></desc>
--</constant>
--<constant>
--<name>LIBSSH2_ERROR_CHANNEL_CLOSED</name>
--<value>-26</value>
--<desc>The channel has been closed.</desc>
--</constant>
--<constant>
--<name>LIBSSH2_ERROR_CHANNEL_EOF_SENT</name>
--<value>-27</value>
--<desc>The channel has been requested to be closed.</desc>
--</constant>
--<constant>
--<name>LIBSSH2_ERROR_SCP_PROTOCOL</name>
--<value>-28</value>
--<desc></desc>
--</constant>
--<constant>
--<name>LIBSSH2_ERROR_ZLIB</name>
--<value>-29</value>
--<desc></desc>
--</constant>
--<constant>
--<name>LIBSSH2_ERROR_SOCKET_TIMEOUT</name>
--<value>-30</value>
--<desc></desc>
--</constant>
--<constant>
--<name>LIBSSH2_ERROR_SFTP_PROTOCOL</name>
--<value>-31</value>
--<desc>An invalid SFTP protocol response was received on the socket, or an SFTP operation caused an errorcode to be returned by the server.</desc>
--</constant>
--<constant>
--<name>LIBSSH2_ERROR_REQUEST_DENIED</name>
--<value>-32</value>
--<desc>The remote server refused the request.</desc>
--</constant>
--<constant>
--<name>LIBSSH2_ERROR_METHOD_NOT_SUPPORTED</name>
--<value>-33</value>
--<desc>The requested method is not supported.</desc>
--</constant>
--<constant>
--<name>LIBSSH2_ERROR_INVAL</name>
--<value>-34</value>
--<desc>The requested method type was invalid.</desc>
--</constant>
--<constant>
--<name>LIBSSH2_ERROR_INVALID_POLL_TYPE</name>
--<value>-35</value>
--<desc></desc>
--</constant>
--<constant>
--<name>LIBSSH2_ERROR_PUBLICKEY_PROTOCOL</name>
--<value>-36</value>
--<desc></desc>
--</constant>
--<constant>
--<name>LIBSSH2_ERROR_EAGAIN</name>
--<value>-37</value>
--<desc>Marked for non-blocking I/O but the call would block.</desc>
--</constant>
--<constant>
--<name>LIBSSH2_ERROR_BUFFER_TOO_SMALL</name>
--<value>-38</value>
--<desc>Any of the given 'buffer' or 'longentry' buffers are too small to fit the requested object name.</desc>
--</constant>
--<constant>
--<name>LIBSSH2_ERROR_BAD_USE</name>
--<value>-39</value>
--<desc></desc>
--</constant>
--<constant>
--<name>LIBSSH2_ERROR_COMPRESS</name>
--<value>-40</value>
--<desc></desc>
--</constant>
--<constant>
--<name>LIBSSH2_ERROR_OUT_OF_BOUNDARY</name>
--<value>-41</value>
--<desc></desc>
--</constant>
--<constant>
--<name>LIBSSH2_ERROR_AGENT_PROTOCOL</name>
--<value>-42</value>
--<desc></desc>
--</constant>

public constant
  LIBSSH2_INIT_NO_CRYPTO = #0001  -- Do not initialize the crypto library (ie., -- OPENSSL_add_cipher_algoritms() for OpenSSL
--<constant>
--<name>LIBSSH2_INIT_NO_CRYPTO</name>
--<value>#0001</value>
--<desc></desc>
--</constant>

-- Channel API
public constant
  LIBSSH2_CHANNEL_WINDOW_DEFAULT = 65536,
  LIBSSH2_CHANNEL_PACKET_DEFAULT = 32768,
  LIBSSH2_CHANNEL_MINADJUST      = 1024
--<constant>
--<name>LIBSSH2_CHANNEL_WINDOW_DEFAULT</name>
--<value>65536</value>
--<desc></desc>
--</constant>
--<constant>
--<name>LIBSSH2_CHANNEL_PACKET_DEFAULT</name>
--<value>32768</value>
--<desc></desc>
--</constant>
--<constant>
--<name>LIBSSH2_CHANNEL_MINADJUST</name>
--<value>1024</value>
--<desc></desc>
--</constant>

-- Extended Data Handling
public constant
  LIBSSH2_CHANNEL_EXTENDED_DATA_NORMAL = 0,
  LIBSSH2_CHANNEL_EXTENDED_DATA_IGNORE = 1,
  LIBSSH2_CHANNEL_EXTENDED_DATA_MERGE  = 2
--<constant>
--<name>LIBSSH2_CHANNEL_EXTENDED_DATA_NORMAL</name>
--<value>0</value>
--<desc></desc>
--</constant>
--<constant>
--<name>LIBSSH2_CHANNEL_EXTENDED_DATA_IGNORE</name>
--<value>1</value>
--<desc></desc>
--</constant>
--<constant>
--<name>LIBSSH2_CHANNEL_EXTENDED_DATA_MERGE</name>
--<value>2</value>
--<desc></desc>
--</constant>

public constant
  SSH_EXTENDED_DATA_STDERR = 1
--<constant>
--<name>SSH_EXTENDED_DATA_STDERR</name>
--<value>1</value>
--<desc></desc>
--</constant>

-- Returned by any function that would block during a read/write opperation*/
public constant
  LIBSSH2CHANNEL_EAGAIN = LIBSSH2_ERROR_EAGAIN
--<constant>
--<name>LIBSSH2CHANNEL_EAGAIN</name>
--<value>LIBSSH2_ERROR_EAGAIN</value>
--<desc></desc>
--</constant>

public constant
  LIBSSH2_CHANNEL_FLUSH_EXTENDED_DATA = -1,
  LIBSSH2_CHANNEL_FLUSH_ALL           = -2
--<constant>
--<name>LIBSSH2_CHANNEL_FLUSH_EXTENDED_DATA</name>
--<value>-1</value>
--<desc></desc>
--</constant>
--<constant>
--<name>LIBSSH2_CHANNEL_FLUSH_ALL</name>
--<value>-2</value>
--<desc></desc>
--</constant>

public constant
  HAVE_LIBSSH2_KNOWNHOST_API = #010101, -- since 1.1.1
  HAVE_LIBSSH2_VERSION_API   = #010100  -- libssh2_version since 1.1
--<constant>
--<name>HAVE_LIBSSH2_KNOWNHOST_API</name>
--<value>#010101</value>
--<desc></desc>
--</constant>
--<constant>
--<name>HAVE_LIBSSH2_VERSION_API</name>
--<value>#010100</value>
--<desc></desc>
--</constant>

-- host format (2 bits)--
public constant
  LIBSSH2_KNOWNHOST_TYPE_MASK   = #FFFF,
  LIBSSH2_KNOWNHOST_TYPE_PLAIN  = 1,
  LIBSSH2_KNOWNHOST_TYPE_SHA1   = 2, -- always base64 encoded
  LIBSSH2_KNOWNHOST_TYPE_CUSTOM = 3
--<constant>
--<name>LIBSSH2_KNOWNHOST_TYPE_MASK</name>
--<value>#FFFF</value>
--<desc></desc>
--</constant>
--<constant>
--<name>LIBSSH2_KNOWNHOST_TYPE_PLAIN</name>
--<value>1</value>
--<desc></desc>
--</constant>
--<constant>
--<name>LIBSSH2_KNOWNHOST_TYPE_SHA1</name>
--<value>2</value>
--<desc></desc>
--</constant>
--<constant>
--<name>LIBSSH2_KNOWNHOST_TYPE_CUSTOM</name>
--<value>3</value>
--<desc></desc>
--</constant>

-- key format (2 bits)--
public constant
  LIBSSH2_KNOWNHOST_KEYENC_RAW    = #10000,
  LIBSSH2_KNOWNHOST_KEYENC_BASE64 = #20000,
  LIBSSH2_KNOWNHOST_KEYENC_MASK   = #30000
--<constant>
--<name>LIBSSH2_KNOWNHOST_KEYENC_RAW</name>
--<value>#10000</value>
--<desc></desc>
--</constant>
--<constant>
--<name>LIBSSH2_KNOWNHOST_KEYENC_BASE64</name>
--<value>#20000</value>
--<desc></desc>
--</constant>
--<constant>
--<name>LIBSSH2_KNOWNHOST_KEYENC_MASK</name>
--<value>#30000</value>
--<desc></desc>
--</constant>

-- type of key (2 bits)--
public constant
  LIBSSH2_KNOWNHOST_KEY_MASK   = #C0000,
  LIBSSH2_KNOWNHOST_KEY_SHIFT  = #00012,
  LIBSSH2_KNOWNHOST_KEY_RSA1   = #10000,
  LIBSSH2_KNOWNHOST_KEY_SSHRSA = #B0000,
  LIBSSH2_KNOWNHOST_KEY_SSHDSS = #C0000
--<constant>
--<name>LIBSSH2_KNOWNHOST_KEY_MASK</name>
--<value>#C0000</value>
--<desc></desc>
--</constant>
--<constant>
--<name>LIBSSH2_KNOWNHOST_KEY_SHIFT</name>
--<value>#00012</value>
--<desc></desc>
--</constant>
--<constant>
--<name>LIBSSH2_KNOWNHOST_KEY_RSA1</name>
--<value>#10000</value>
--<desc></desc>
--</constant>
--<constant>
--<name>LIBSSH2_KNOWNHOST_KEY_SSHRSA</name>
--<value>#B0000</value>
--<desc></desc>
--</constant>
--<constant>
--<name>LIBSSH2_KNOWNHOST_KEY_SSHDSS</name>
--<value>#C0000</value>
--<desc></desc>
--</constant>

public constant
  LIBSSH2_KNOWNHOST_CHECK_MATCH     = 0,
  LIBSSH2_KNOWNHOST_CHECK_MISMATCH  = 1,
  LIBSSH2_KNOWNHOST_CHECK_NOTFOUND  = 2,
  LIBSSH2_KNOWNHOST_CHECK_FAILURE   = 3
--<constant>
--<name>LIBSSH2_KNOWNHOST_CHECK_MATCH</name>
--<value>0</value>
--<desc></desc>
--</constant>
--<constant>
--<name>LIBSSH2_KNOWNHOST_CHECK_MISMATCH</name>
--<value>1</value>
--<desc></desc>
--</constant>
--<constant>
--<name>LIBSSH2_KNOWNHOST_CHECK_NOTFOUND</name>
--<value>2</value>
--<desc></desc>
--</constant>
--<constant>
--<name>LIBSSH2_KNOWNHOST_CHECK_FAILURE</name>
--<value>3</value>
--<desc></desc>
--</constant>

public constant
  LIBSSH2_KNOWNHOST_FILE_OPENSSH = 1
--<constant>
--<name>LIBSSH2_KNOWNHOST_FILE_OPENSSH</name>
--<value>1</value>
--<desc></desc>
--</constant>

public constant
 HAVE_LIBSSH2_AGENT_API = #010202 -- since 1.2.2
--<constant>
--<name>HAVE_LIBSSH2_AGENT_API</name>
--<value>#010202</value>
--<desc></desc>
--</constant>

public constant
  LIBSSH2_TRACE_TRANS     = #0002,
  LIBSSH2_TRACE_KEX       = #0004,
  LIBSSH2_TRACE_AUTH      = #0008,
  LIBSSH2_TRACE_CONN      = #0010,
  LIBSSH2_TRACE_SCP       = #0020,
  LIBSSH2_TRACE_SFTP      = #0040,
  LIBSSH2_TRACE_ERROR     = #0080,
  LIBSSH2_TRACE_PUBLICKEY = #0100,
  LIBSSH2_TRACE_SOCKET    = #0200
--<constant>
--<name>LIBSSH2_TRACE_TRANS</name>
--<value>#0002</value>
--<desc></desc>
--</constant>
--<constant>
--<name>LIBSSH2_TRACE_KEX</name>
--<value>#0004</value>
--<desc></desc>
--</constant>
--<constant>
--<name>LIBSSH2_TRACE_AUTH</name>
--<value>#0008</value>
--<desc></desc>
--</constant>
--<constant>
--<name>LIBSSH2_TRACE_CONN</name>
--<value>#0010</value>
--<desc></desc>
--</constant>
--<constant>
--<name>LIBSSH2_TRACE_SCP</name>
--<value>#0020</value>
--<desc></desc>
--</constant>
--<constant>
--<name>LIBSSH2_TRACE_SFTP</name>
--<value>#0040</value>
--<desc></desc>
--</constant>
--<constant>
--<name>LIBSSH2_TRACE_ERROR</name>
--<value>#0080</value>
--<desc></desc>
--</constant>
--<constant>
--<name>LIBSSH2_TRACE_PUBLICKEY</name>
--<value>#0100</value>
--<desc></desc>
--</constant>
--<constant>
--<name>LIBSSH2_TRACE_SOCKET</name>
--<value>#0200</value>
--<desc></desc>
--</constant>

