------------------------------------------------------------
-- Windows part extracted from Pete Stoner's code

-- wrapper for CreateToolhelpSnapshot. 
-- Will list running processes along with any associated 
-- files/dlls
--
-- Pete Stoner 16/06/2006
------------------------------------------------------------

-- Linux part is of my own
-- Jean-Marc Duro 24/08/2017

------------------------------------------------------------

include std/dll.e
include std/machine.e
include std/math.e
include std/wildcard.e
include std/filesys.e
include std/os.e
include std/io.e
include std/convert.e
include lib/_types_.e
without warning

without trace

ifdef WINDOWS then

-- Extract of Pete Stoner's code

constant 
 KERNEL32 = open_dll("Kernel32.dll"),

 dllSnapshot = define_c_func( KERNEL32, "CreateToolhelp32Snapshot", {C_LONG, C_LONG}, C_INT),    
 dllCloseHandle = define_c_func( KERNEL32, "CloseHandle", {C_INT}, C_INT),
 dllProcess32First = define_c_func( KERNEL32, "Process32First", {C_LONG, C_POINTER}, C_INT),
 dllProcess32Next = define_c_func( KERNEL32, "Process32Next", {C_LONG, C_POINTER}, C_INT)

global constant
  P_NAME    = 1,  -- process name
  P_ID      = 2   -- process ID
  
-- flags/constantss
constant 
 TH32CS_SNAPHEAPLIST = #1,
 TH32CS_SNAPPROCESS  = #2,
 TH32CS_SNAPTHREAD   = #4,
 TH32CS_SNAPMODULE   = #8,
 TH32CS_INHERIT      = #80000000,
 TH32CS_SNAPALL      = or_all({TH32CS_SNAPHEAPLIST, TH32CS_SNAPPROCESS, TH32CS_SNAPTHREAD, TH32CS_SNAPMODULE}),
 INVALID_HANDLE_VALUE = -1,--#0FFFFFFFF, 
 MAX_PATH            = 260,
 ERROR_NO_MORE_FILES = 18
 
-- typedef struct tagPROCESSENTRY32 
constant 
 PE32_th32ProcessID     = 8,   -- DWORD  Process identifier.
 PE32_szExeFile        = 36,   -- MAX_PATH, Pntr to a null-termed string for the executable file for the process.
 SIZEOF_PE32STRUCT      = 40 + MAX_PATH
-- end typedef struct _tagPROCESSENTRY32  

--------------------------------------------------------------------------------

public function get_process_id(sequence processname)
-- returns sequence containing a list of running processes
-- {filename, process id} 
  atom snapshotHandle
  object void, ret

  -- Set the size of the structure before using it.
  atom PROCESSENTRY32
  PROCESSENTRY32 = allocate(SIZEOF_PE32STRUCT)
  poke4(PROCESSENTRY32, SIZEOF_PE32STRUCT)

  sequence processes = {}

  -- Take a snapshot of all processes in the system.
  snapshotHandle = c_func(dllSnapshot, {TH32CS_SNAPALL, 0})--PROCESS, 0})
  if snapshotHandle = INVALID_HANDLE_VALUE then
    free(PROCESSENTRY32)
    return 0
  end if
  
  -- Retrieve information about the first process 
  ret = c_func(dllProcess32First, {snapshotHandle, PROCESSENTRY32})  
  if ret != 0 then
    -- Now walk the snapshot of processes, and
    -- get information about each process in turn
    while 1 do
      sequence name = peek_string(PROCESSENTRY32+PE32_szExeFile)
      integer pid = peek4u(PROCESSENTRY32+ PE32_th32ProcessID)
      if length(name) then
        if match(processname, name) then
          processes = append(processes, pid)
        end if
      end if
     
      if not c_func(dllProcess32Next, {snapshotHandle, PROCESSENTRY32}) then
        exit
      end if
     
    end while
  end if
   
  free(PROCESSENTRY32)
  void = c_func(dllCloseHandle, {snapshotHandle})
  return processes
 
end function   

elsifdef LINUX then

public function get_process_id(sequence processname)
-- Returns list of pids of processname instances
  sequence processes = {}
  object x = dir("/proc/*")
  integer ownPID = get_pid()
  if sequence(x) then           -- Exclude forbidden DIRs
    for i = 1 to length(x) do   -- Loop through DIR content
      sequence s = x[i]
      if find('d',s[D_ATTRIBUTES]) and
         not (equal(s[D_NAME],".") or equal(s[D_NAME],"..")) then  -- Check for SubDIRs
        if is_integer(s[D_NAME]) and (ownPID != to_number(s[D_NAME])) then
          integer fn = open("/proc/" & s[D_NAME] & "/cmdline", "rb")
          sequence name = ""
          integer c = getc(fn)
          while (c != EOF) do
            if c then name &= c end if  -- remove NULL
            c = getc(fn)
          end while
          close(fn)
          if sequence(name) and length(name) then
            if match(processname, name) then
              processes = append(processes, to_number(s[D_NAME]))
            end if
          end if
        end if
      end if
    end for
  end if
  return processes
end function

end ifdef

------------------------------------------------------------------------------

public function is_running(sequence processname)
-- Returns true if at least one instance of processname is running
  sequence processes
  
  processes = get_process_id(processname)
  return length(processes) > 0
end function
