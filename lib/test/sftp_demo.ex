include lib/_debug_.e
include lib/Sockets.ew
include lib/WSErrors.ew
include lib/_libssh2_.e
include w32tk.e as tk
include win32lib.ew

constant
  App     = "SFTP client demo",
  Ver     = "v0.0.1"

integer
  Form1, lblCurDir, btnGet, btnPut, ListView1, edHost, edPort,
  rbIP4, rbIP6, GroupBox1, cbTryAll, cbPass, cbKeybInt, cbPKey, cbPKeyAgent,
  btnConnect, btnDisconnect, edUser, edPass, cbKeepAlive, btnDelete, btnRename,
  btnMkSymlink, btnResSymlink, btnMkDir, StatusBar1, edPkey, edPrivkey,
  edPrivkpass, btnSelPkey, btnSelPrivkey, btnSetPerms

sequence labels
  
------------------------------------------------------------------------------

procedure btnGetClick(integer self, integer event, sequence parms)
end procedure

------------------------------------------------------------------------------

procedure btnPutClick(integer self, integer event, sequence parms)
end procedure

------------------------------------------------------------------------------

procedure ListView1DblClick(integer self, integer event, sequence parms)
end procedure

------------------------------------------------------------------------------

procedure cbTryAllClick(integer self, integer event, sequence parms)
end procedure

------------------------------------------------------------------------------

procedure btnConnectClick(integer self, integer event, sequence parms)
end procedure

------------------------------------------------------------------------------

procedure btnDisconnectClick(integer self, integer event, sequence parms)
end procedure

------------------------------------------------------------------------------

procedure btnDeleteClick(integer self, integer event, sequence parms)
end procedure

------------------------------------------------------------------------------

procedure btnRenameClick(integer self, integer event, sequence parms)
end procedure

------------------------------------------------------------------------------

procedure btnMkSymlinkClick(integer self, integer event, sequence parms)
end procedure

------------------------------------------------------------------------------

procedure btnResSymlinkClick(integer self, integer event, sequence parms)
end procedure

------------------------------------------------------------------------------

procedure btnMkDirClick(integer self, integer event, sequence parms)
end procedure

------------------------------------------------------------------------------

procedure btnSelPkeyClick(integer self, integer event, sequence parms)
end procedure

------------------------------------------------------------------------------

procedure btnSelPrivkeyClick(integer self, integer event, sequence parms)
end procedure

------------------------------------------------------------------------------

procedure onActivate_Form1( integer pSelf, integer pEvent, sequence pParams )
  if WSAStartup() = SOCKET_ERROR then -- must be called before using Winsock API
    void = message_box ("Failed WSAStartup()", "Winsock Error", MB_OK)
    abort (1)
  end if
  setText({StatusBar1, 2}, "libssh2 ver: " & libssh2_version(0))
end procedure  -- onActivate_Form1

------------------------------------------------------------------------------

procedure onClose_Form1 (integer self, integer event, sequence params)
  void = WSACleanup()
  close(f_debug)
end procedure  -- onClose_Form1

------------------------------------------------------------------------------

-- Application Initialization
function appInit()
  integer lRC
  atom flags

  f_debug = open(InitialDir&"\\debug.log", "w")
  lRC = 0
  labels = {}

  Form1 = create(Window, App & " " & Ver, 0, 1, 1, 730, 440, 0)

  lblCurDir = createEx(LText, "::", Form1, 8, 120, 6, 13, 0, 0)

  btnGet = createEx(PushButton, "Get file", Form1,  8, 355, 75, 23, 0, 0)
  setEnable(btnGet, w32False)
  setHandler(btnGet, w32HClick, routine_id("btnGetClick"))

  btnPut = createEx(PushButton, "Put file", Form1,  89, 355, 75, 23, 0, 0)
  setEnable(btnPut, w32False)
  setHandler(btnPut, w32HClick, routine_id("btnPutClick"))

  ListView1 = create(ListView, {"Name", "Type", "Size (bytes)", "Perm (octal)",
                                 "UID/GID", "Lastmod"},
                      Form1, 8, 136, 692, 213,
                      tk:or_all({LVS_REPORT,LVS_SHOWSELALWAYS}))

  setReadOnly(ListView1, w32True)
  flags = tk:or_all({LVS_EX_GRIDLINES,LVS_EX_FULLROWSELECT})
  VOID = sendMessage(ListView1, LVM_SETEXTENDEDLISTVIEWSTYLE, flags, flags)
  void = sendMessage(ListView1, LVM_SETCOLUMNWIDTH, 0, 250)
  void = sendMessage(ListView1, LVM_SETCOLUMNWIDTH, 1, 60)
  void = sendMessage(ListView1, LVM_SETCOLUMNWIDTH, 2, 80)
  void = sendMessage(ListView1, LVM_SETCOLUMNWIDTH, 3, 70)
  void = sendMessage(ListView1, LVM_SETCOLUMNWIDTH, 4, 80)
  void = sendMessage(ListView1, LVM_SETCOLUMNWIDTH, 5, 120)
  setColumn(ListView1, 3, {"",-1,'>'} )
  setColumn(ListView1, 4, {"",-1,'>'} )
  setColumn(ListView1, 6, {"",-1,'>'} )
  setHandler(ListView1, w32HClick, routine_id("ListView1DblClick"))

  labels = append(labels, createEx(LText, "Host:", Form1, 8, 8, 26, 13, 0, 0))
  edHost = createEx(EditText, "172.20.160.106", Form1, 8, 24, 153, 21, 0, 0)

  labels = append(labels, createEx(LText, "Port:", Form1, 167, 8, 24, 13, 0, 0))
  edPort = createEx(EditText, "22", Form1, 167, 24, 42, 21, 0, 0)

  rbIP4 = createEx(Radio, "IPv4", Form1, 8, 51, 49, 17, 0, 0)
  setCheck(rbIP4, w32True)
  rbIP6 = createEx(Radio, "IPv6", Form1, 63, 51, 50, 17, 0, 0)

  GroupBox1 = createEx(Group, "Auth mode", Form1, 542, 8, 158, 109, 0, 0)
  cbTryAll = createEx(CheckBox, "Try all", GroupBox1, 9, 16, 97, 17, 0, 0)
  setCheck(cbTryAll, w32True)
  setHandler(cbTryAll, w32HClick, routine_id("cbTryAllClick"))
  cbPass = createEx(CheckBox, "Password", GroupBox1, 24, 34, 97, 17, 0, 0)
  setEnable(cbPass, w32False)
  cbKeybInt = createEx(CheckBox, "Keybd interactive", GroupBox1, 24, 50, 105, 17, 0, 0)
  setEnable(cbKeybInt, w32False)
  cbPKey = createEx(CheckBox, "Public key", GroupBox1, 24, 67, 97, 17, 0, 0)
  setEnable(cbPKey, w32False)
  cbPKeyAgent = createEx(CheckBox, "Public key via agent", GroupBox1, 24, 84, 114, 17, 0, 0)
  setEnable(cbPKeyAgent, w32False)

  btnConnect = createEx(DefPushButton, "Connect", Form1, 8, 74, 75, 23, 0, 0)
  setHandler(btnConnect, w32HClick, routine_id("btnConnectClick"))

  btnDisconnect = createEx(PushButton, "Disconnect", Form1, 89, 74, 75, 23, 0, 0)
  setHandler(btnDisconnect, w32HClick, routine_id("btnDisconnectClick"))

  labels = append(labels, createEx(LText, "Username:", Form1, 224, 8, 52, 13, 0, 0))
  edUser = createEx(EditText, "admnis", Form1, 224, 24, 137, 21, 0, 0)

  labels = append(labels, createEx(LText, "Password:", Form1, 223, 46, 50, 13, 0, 0))
  edPass = createEx(EditText, "Zero1:sde1", Form1, 223, 62, 137, 21, 0, 0)

  cbKeepAlive = createEx(CheckBox, "Keepalive", Form1, 119, 51, 65, 17, 0, 0)
  setCheck(cbKeepAlive, w32True)

  btnDelete = createEx(PushButton, "Delete", Form1, 170, 355, 75, 23, 0, 0)
  setEnable(btnDelete, w32False)
  setHandler(btnDelete, w32HClick, routine_id("btnDeleteClick"))

  btnRename = createEx(PushButton, "Rename", Form1, 251, 355, 75, 23, 0, 0)
  setEnable(btnRename, w32False)
  setHandler(btnRename, w32HClick, routine_id("btnRenameClick"))

  btnMkSymlink = createEx(PushButton, "Make symlink", Form1, 332, 355, 93, 23, 0, 0)
  setEnable(btnMkSymlink, w32False)
  setHandler(btnMkSymlink, w32HClick, routine_id("btnMkSymlinkClick"))

  btnResSymlink = createEx(PushButton, "Resolve symlink", Form1, 431, 355, 93, 23, 0, 0)
  setEnable(btnResSymlink, w32False)
  setHandler(btnResSymlink, w32HClick, routine_id("btnResSymlinkClick"))

  btnMkDir = createEx(PushButton, "Make directory", Form1, 530, 355, 95, 23, 0, 0)
  setEnable(btnMkDir, w32False)
  setHandler(btnMkDir, w32HClick, routine_id("btnMkDirClick"))

  StatusBar1 = create(StatusBar, "", Form1, 0, {{500},-1}, 0, 0, 0)

  labels = append(labels, createEx(LText, "Public key path:", Form1, 366, 8, 76, 13, 0, 0))
  edPkey = createEx(EditText, "", Form1, 366, 24, 137, 21, 0, 0)

  labels = append(labels, createEx(LText, "Private key path:", Form1, 366, 46, 83, 13, 0, 0))
  edPrivkey = createEx(EditText, "", Form1, 366, 62, 137, 21, 0, 0)

  labels = append(labels, createEx(LText, "Private key passphrase:", Form1, 366, 84, 116, 13, 0, 0))
  edPrivkpass = createEx(EditText, "", Form1, 366, 100, 137, 21, 0, 0)

  btnSelPkey = createEx(PushButton, "...", Form1, 507, 24, 25, 21, 0, 0)
  setHandler(btnSelPkey, w32HClick, routine_id("btnSelPkeyClick"))

  btnSelPrivkey = createEx(PushButton, "...", Form1, 507, 62, 25, 21, 0, 0)
  setHandler(btnSelPrivkey, w32HClick, routine_id("btnSelPrivkeyClick"))

  btnSetPerms = createEx(PushButton, "Set perms", Form1, 631, 355, 69, 23, 0, 0)
  setEnable(btnSetPerms, w32False)

  setHandler (Form1, w32HActivate, routine_id ("onActivate_Form1"))
  setHandler (Form1, w32HClose,    routine_id ("onClose_Form1"))
  return lRC
end function   -- appInit

------------------------------------------------------------------------------

-- Main
if appInit() = 0 then
  WinMain(Form1, Normal)
end if

