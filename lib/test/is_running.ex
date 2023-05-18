include lib/_process_.e

  sequence processname
  
  sequence cmd = command_line()
  if length(cmd)< 3 then
    puts(1, "Syntax: is_running process_cmdline\n")
    abort(1)
  end if

  processname = cmd[3]
  puts(1, "processname: '" & processname & "'\n")
  if length(processname)>0 then
    if is_running(processname) then
      puts(1, "Process " & processname & " is running\n")
    else
      puts(1, "No process " & processname & " found\n")
    end if
  end if
