-- _file_.e

include std/get.e
include std/io.e
include std/os.e
include std/convert.e
include std/filesys.e
include std/machine.e
include std/search.e
include std/text.e
include _common_.e
include _types_.e
include _search_.e
include _debug_.e
include _conv_.e
include _sequence_.e

atom mem4, mem8
mem4 = allocate(4)
mem8 = allocate(8)

------------------------------------------------------------------------------

public function remove_eol(sequence s)
--<function>
--<name>remove_eol</name>
--<digest>remove end of line characters from given sequence</digest>
--<desc>
--</desc>
--<param>
--<type>sequence</type>
--<name>s</name>
--<desc></desc>
--</param>
--<return>
--</return>
--<example>
-- puts(1, remove_eol("First Line\nSecond Line\r\nThird Line\rFourth Line") & "\n")
-- First Line Second Line Third Line Fourth Line
--</example>
--<see_also>
--</see_also>
--</function>
  s = replace_all(s, "\r\n", "")
  s = replace_all(s, "\r", "")
  s = replace_all(s, "\n", "")
  return s
end function

------------------------------------------------------------------------------

public function split_filename(sequence s)
--<function>
--<name>split_filename</name>
--<digest>splits a complete filename in drive, path, name and extension</digest>
--<desc>
--</desc>
--<param>
--<type>sequence</type>
--<name>s</name>
--<desc></desc>
--</param>
--<return>
--</return>
--<example>
-- s = split_filename("C:\path\filename.txt")
-- s is:
--.  [1] "C"
--.  [2] "\path"
--.  [3] "filename"
--.  [4] "txt"
--</example>
--<see_also>
--</see_also>
--</function>
  sequence drive, path, name, ext
  integer d, p, e     -- separators for drive, path and extension
  integer l

  l = length(s)
  drive = ""
  path = ""
  name = ""
  ext = ""
  if l = 0 then return {drive,path,name,ext} end if

  if equal(s, ".") then
    return {drive,".",name,ext}
  elsif equal(s, "..") then
    return {drive, "..",name,ext}
  end if
  d = find(':', s)
  if d > 1 then
    drive = s[1..d-1]
    s = remove(s, 1, d)
  end if
  p = rfind(SLASH, s)
  e = rfind('.', s)
  if (e > 1) and (e > p) then
    ext = s[e+1..$]
    s = remove(s, e, length(s))
  end if
  p = rfind(SLASH, s)
  if p > 0 then
    if p = 1 then
      path = {SLASH}
    else
      path = s[1..p-1]
    end if
    s = remove(s, 1, p)
  end if
  name = s
  return {drive,path,name,ext}
end function

------------------------------------------------------------------------------

public function file_drive(sequence filename)
--<function>
--<name>file_path</name>
--<digest>returns file drive</digest>
--<desc>
--</desc>
--<param>
--<type>sequence</type>
--<name>filename</name>
--<desc></desc>
--</param>
--<return>
--</return>
--<example>
-- s = file_drive("C:\path\filename.txt") --> "C"
--</example>
--<see_also>file_path(), file_base(), file_ext(), file_name()</see_also>
--</function>
  sequence s

  s = split_filename(filename)
  return s[1]
end function

------------------------------------------------------------------------------

public function file_path(sequence filename)
--<function>
--<name>file_path</name>
--<digest>returns file path</digest>
--<desc>
--</desc>
--<param>
--<type>sequence</type>
--<name>filename</name>
--<desc></desc>
--</param>
--<return>
--</return>
--<example>
-- s = file_path("C:\path\filename.txt") --> "\path"
--</example>
--<see_also>file_drive(), file_base(), file_ext(), file_name()</see_also>
--</function>
  sequence s

  s = split_filename(filename)
  return s[2]
end function

------------------------------------------------------------------------------

public function file_base(sequence filename)
--<function>
--<name>file_base</name>
--<digest>returns filename without extension or path</digest>
--<desc>
--</desc>
--<param>
--<type>sequence</type>
--<name>filename</name>
--<desc></desc>
--</param>
--<return>
--</return>
--<example>
-- s = file_base("C:\path\filename.txt") --> "filename"
--</example>
--<see_also>file_drive(), file_path(), file_ext(), file_name()</see_also>
--</function>
  sequence s

  s = split_filename(filename)
  return s[3]
end function

------------------------------------------------------------------------------

public function file_ext(sequence filename)
--<function>
--<name>file_ext</name>
--<digest>returns file extension</digest>
--<desc>
--</desc>
--<param>
--<type>sequence</type>
--<name>filename</name>
--<desc></desc>
--</param>
--<return>
--</return>
--<example>
-- s = file_ext("C:\path\filename.txt") --> "txt"
--</example>
--<see_also>file_drive(), file_path(), file_base(), file_name()</see_also>
--</function>
  sequence s

  s = split_filename(filename)
  return s[4]
end function

------------------------------------------------------------------------------

public function file_name(sequence filename)
--<function>
--<name>file_name</name>
--<digest>returns filename with extension, without path</digest>
--<desc>
--</desc>
--<param>
--<type>sequence</type>
--<name>filename</name>
--<desc></desc>
--</param>
--<return>
--</return>
--<example>
-- s = file_name("C:\path\filename.txt") --> "filename.txt"
--</example>
--<see_also>file_drive(), file_path(), file_base(), file_ext()</see_also>
--</function>
  sequence s

  s = split_filename(filename)
  if length(s[4]) then
    return s[3] & "." & s[4]
  else
    return s[3]
  end if
end function

------------------------------------------------------------------------------

public function file_type(sequence filename)
--<function>
--<name>file_type</name>
--<digest>Get the type of a file</digest>
--<desc></desc>
--<param>
--<type>sequence</type>
--<name>filename</name>
--<desc>name of the file to query. It must not have wildcards.</desc>
--</param>
--<return>
-- integer:
--     * -1 if file could be multiply defined
--     *  0 if filename does not exist
--     *  1 if filename is a file
--     *  2 if filename is a directory
--</return>
--<example>
--</example>
--<see_also>dir()</see_also>
--</function>
  object dirfil

  if find('*', filename) or find('?', filename) then
    return FILETYPE_UNDEFINED
  end if

ifdef WINDOWS then
    if length(filename) = 2 and filename[2] = ':' then
      filename &= "\\"
    end if
end ifdef

  dirfil = dir(filename)
  if sequence(dirfil) then
    if length( dirfil ) > 1 or find('d', dirfil[1][2]) or (length(filename)=3 and filename[2]=':') then
      return FILETYPE_DIRECTORY
    else
      return FILETYPE_FILE
    end if
  else
    return FILETYPE_NOT_FOUND
  end if
end function

------------------------------------------------------------------------------

public function file_size(sequence filename)
--<function>
--<name>file_size</name>
--<digest>Returns the size of a file</digest>
--<desc>
--</desc>
--<param>
--<type>sequence</type>
--<name>filename</name>
--<desc>name of the file to search size of</desc>
--</param>
--<return>
-- atom: size of file if existing or -1 else
--</return>
--<example>
-- a = file_size("C:\\path\\filename")
--</example>
--<see_also>
--</see_also>
--</function>
  object   x

  x = dir(filename)        -- Get DIR information of file
  if atom(x) then return -1 end if
  if length(x) != 1 then return -1 end if
  return x[1][D_SIZE]
end function

------------------------------------------------------------------------------

public function dir_size(sequence rootdir)
--<function>
--<name>dir_size</name>
--<digest>Returns sum of all file sizes from rootdir and all subdirs</digest>
--<desc>
--</desc>
--<param>
--<type>sequence</type>
--<name>rootdir</name>
--<desc>directory to search size of</desc>
--</param>
--<return>
-- atom
--</return>
--<example>
-- a = dir_size("C:\\path\\subpath")
--</example>
--<see_also>
--</see_also>
--</function>
  object   x
  sequence s, name
  atom     bytes

  s = split_filename(rootdir)
  name = rootdir[length(s[1])+2..$]
  if platform() = WIN32 then
    x = dir(rootdir & SLASH & "*.*")        -- Get DIR information of all files
  else
    x = dir(rootdir & SLASH & "*")        -- Get DIR information of all files
  end if
  bytes = 0
  if sequence(x) then             -- Exclude forbidden DIRs
	for i = 1 to length(x) do   -- Loop through DIR content
	  s = x[i]
      if find('d',s[D_ATTRIBUTES]) then  -- Check for SubDIRs
		if not (equal(s[D_NAME],".") or equal(s[D_NAME],"..")) then
		    bytes += dir_size(rootdir & "\\" & s[D_NAME])
		end if
	  else
		bytes += s[D_SIZE]       -- Sum Bytes!
	  end if
	end for
  end if
  return bytes
end function

------------------------------------------------------------------------------

public function parent_dir(sequence path)
--<function>
--<name>parent_dir</name>
--<digest>returns parent dir of given path</digest>
--<desc>
-- remove last sub directory from path if there is one and return it.
-- if root return empty sequence
-- path has to point to a folder and not to a file
--</desc>
--<param>
--<type>sequence</type>
--<name>path</name>
--<desc></desc>
--</param>
--<return>
--</return>
--<example>
-- parent_dir(".") --> ".."
-- parent_dir("C:\path\subpath") --> "\path"
--</example>
--<see_also>
--</see_also>
--</function>
  if ends({SLASH}, path) then
    if length(path) = 1 then
      return 0
    else
      path = path[1..$-1]
    end if
  end if
  if equal(path, ".") then
    return ".."
  elsif equal(path, "..") then
    return ".." & SLASH & ".."
  elsif ends("..", path) then
    return path & SLASH & ".."
  elsif ends(".", path) then
    return file_path(path) & SLASH & ".."
  end if
  if equal(path, ".") then
    return ".."
  elsif equal(path, "..") then
    return ".." & SLASH & ".."
  else
    return file_path(path)
  end if
end function -- parent_dir()

------------------------------------------------------------------------------

public procedure replace_text(sequence old_file, sequence new_file, sequence old, sequence new)
--<procedure>
--<name>replace_text</name>
--<digest>replaces all occurences of a sub-string by another in a file</digest>
--<desc>
-- result is written in a new file
-- old file is not affected
--</desc>
--<param>
--<type>sequence</type>
--<name>old_file</name>
--<desc></desc>
--</param>
--<param>
--<type>sequence</type>
--<name>new_file</name>
--<desc></desc>
--</param>
--<param>
--<type>sequence</type>
--<name>old</name>
--<desc>text to be replaced</desc>
--</param>
--<param>
--<type>sequence</type>
--<name>new</name>
--<desc>new text</desc>
--</param>
--<example>
-- replace_text("test_file_.bak", "new_file_.bak", "this", "that")
--</example>
--<see_also>
--</see_also>
--</procedure>
  sequence s
  integer f_in, f_tmp
  object line

  s = {}
  f_in = open(old_file, "r")
  f_tmp = open("temp.$$$", "w")
  if (f_in != -1) and (f_tmp != -1) then
    while 1 do
      line = gets(f_in)
      if atom(line) then
        exit
      end if
      puts(f_tmp, replace_all(line, old, new))
    end while
    close(f_in)
    close(f_tmp)
  end if
  system("copy temp.$$$ " & new_file, 2)
  system("del temp.$$$", 2)
end procedure

------------------------------------------------------------------------------

public function read_csv(sequence filename, integer skip_headers)
--<function>
--<name>read_csv</name>
--<digest>reads a CSV file in a sequence</digest>
--<desc>
-- CSV separator is a semicolon
-- CSV strings may be surrounded by quotes
--</desc>
--<param>
--<type>sequence</type>
--<name>filename</name>
--<desc>CSV file to read</desc>
--</param>
--<param>
--<type>integer</type>
--<name>skip_headers</name>
--<desc>if set skip first line in CSV file</desc>
--</param>
--<return>
--</return>
--<example>
-- analyze_object(read_csv("test.csv", 0), "read_csv")
-- read_csv =
-- .  [1]
-- .  .  [1] "Name"
-- .  .  [2] "Bytes"
-- .  .  [3] "Size"
-- .  .  [4] "#Files"
-- .  .  [5] "Most recent"
-- .  [2]
-- .  .  [1] "Z:\"
-- .  .  [2] 56144659864
-- .  .  [3] "52,29 GB"
-- .  .  [4] 23855
-- .  .  [5] 2016
-- .  [3]
-- .  .  [1] "Z:" & SLASH & "BlackBox"
-- .  .  [2] 81699302
-- .  .  [3] "77,91 MB"
-- .  .  [4] 4
-- .  .  [5] 2012
-- .  [4]
-- .  .  [1] "Z:" & SLASH & "Dying_Gasp"
-- .  .  [2] 7757074
-- .  .  [3] "7,40 MB"
-- .  .  [4] 66
-- .  .  [5] 2015
-- .  [5]
-- .  .  [1] "Z:" & SLASH & "Temp"
-- .  .  [2] 812629032
-- .  .  [3] "774,98 MB"
-- .  .  [4] 641
-- .  .  [5] 2016
-- analyze_object(read_csv("test.csv", 1), "read_csv")
-- read_csv =
-- .  [1]
-- .  .  [1] "Z:\"
-- .  .  [2] 56144659864
-- .  .  [3] "52,29 GB"
-- .  .  [4] 23855
-- .  .  [5] 2016
-- .  [2]
-- .  .  [1] "Z:" & SLASH & "BlackBox"
-- .  .  [2] 81699302
-- .  .  [3] "77,91 MB"
-- .  .  [4] 4
-- .  .  [5] 2012
-- .  [3]
-- .  .  [1] "Z:" & SLASH & "Dying_Gasp"
-- .  .  [2] 7757074
-- .  .  [3] "7,40 MB"
-- .  .  [4] 66
-- .  .  [5] 2015
-- .  [4]
-- .  .  [1] "Z:" & SLASH & "Temp"
-- .  .  [2] 812629032
-- .  .  [3] "774,98 MB"
-- .  .  [4] 641
-- .  .  [5] 2016
--</example>
--<see_also>
--</see_also>
--</function>
  sequence section
  integer f_in
  object line

  section = {}
  f_in = open(filename, "r")
  if f_in != -1 then
    if skip_headers then
      line = gets(f_in)
      if atom(line) then
        close(f_in)
        return section
      end if
    end if

    while 1 do
      line = gets(f_in)
      if atom(line) then
        close(f_in)
        return section
      end if
      line = trim(line[1..length(line)-1])
      if length(line)>0 then
        section = append(section, split_n_convert(line, ";") )
      end if
    end while
    close(f_in)
  else
    error_message("Cannot open " & filename & "!", 1)
  end if
  return section
end function

------------------------------------------------------------------------------

public function sequence_to_csv(sequence section)
--<function>
--<name>sequence_to_csv</name>
--<digest>converts a sequence to a CSV line</digest>
--<desc>
-- CSV separator is a semicolon
-- CSV strings are surrounded by quotes
--</desc>
--<param>
--<type>sequence</type>
--<name>section</name>
--<desc></desc>
--</param>
--<return>
--</return>
--<example>
-- puts(1, sequence_to_csv({1,"Two",3,"Four"}) & "\n")
-- 1;"Two";3;"Four"
--</example>
--<see_also>
--</see_also>
--</function>
  integer l
  sequence line

  if atom(section) then
    line = to_string(section)
  else
    l = length(section)
    line = {}
    if l > 0 then
      for j = 1 to l-1 do
        if atom(section[j]) or is_date(section[j]) then
          line &= to_string(section[j])&";"
        else
          line &= "\""&to_string(section[j])&"\";"
        end if
      end for
      if atom(section[l]) or is_date(section[l]) then
        line &= to_string(section[l])
      else
        line &= "\""&to_string(section[l])&"\""
      end if
    end if
  end if
  return line
end function

------------------------------------------------------------------------------

public procedure write_csv(sequence filename, sequence section)
--<procedure>
--<name>write_csv</name>
--<digest>writes a sequence of lines in a CSV file</digest>
--<desc>
-- CSV separator is a semicolon
-- CSV strings are surrounded by quotes
--</desc>
--<param>
--<type>sequence</type>
--<name>filename</name>
--<desc></desc>
--</param>
--<param>
--<type>sequence</type>
--<name>section</name>
--<desc></desc>
--</param>
--<example>
-- write_csv("test2.csv", {{1,"Two",3,"Four"},{1,"Two",3,"Four"}})
-- analyze_object(read_csv("test2.csv", 1), "read_csv")
-- read_csv =
-- .  [1]
-- .  .  [1] 1
-- .  .  [2] "Two"
-- .  .  [3] 3
-- .  .  [4] "Four"
--</example>
--<see_also>
--</see_also>
--</procedure>
  integer f_out

  f_out = open(filename, "w")
  if f_out != -1 then
    for i = 1 to length(section) do
      puts(f_out, sequence_to_csv(section[i])&"\n")
    end for
    close(f_out)
  end if
end procedure

------------------------------------------------------------------------------

public procedure append_csv(sequence filename, sequence section)
--<procedure>
--<name>append_csv</name>
--<digest>appends a sequence of lines to a CSV file</digest>
--<desc>
--</desc>
--<param>
--<type>sequence</type>
--<name>filename</name>
--<desc></desc>
--</param>
--<param>
--<type>sequence</type>
--<name>section</name>
--<desc></desc>
--</param>
--<example>
-- append_csv("test2.csv", {{1,"Two",3,"Four"},{1,"Two",3,"Four"}})
--</example>
--<see_also>
--</see_also>
--</procedure>
  integer f_out

  f_out = open(filename, "a")
  if f_out != -1 then
    for i = 1 to length(section) do
      puts(f_out, sequence_to_csv(section[i])&"\n")
    end for
    close(f_out)
  end if
end procedure

-----------------------------------------------------------------------------

public function find_param_name(sequence list, sequence param)
--<function>
--<name>find_param_name</name>
--<digest>find the index of a parameter in a list of strings "parameter=value"</digest>
--<desc>
--</desc>
--<param>
--<type>sequence</type>
--<name>list</name>
--<desc>list of strings to search in</desc>
--</param>
--<param>
--<type>sequence</type>
--<name>param</name>
--<desc>parameter name to search for</desc>
--</param>
--<return>
-- integer: requested index
--</return>
--<example>
-- sequence params
-- params = {"first=1","second=2","third=three"}
-- ? find_param_name(params, "third")
-- 3
--</example>
--<see_also>set_param_value(), get_param_value()</see_also>
--</function>
  for i = 1 to length(list) do
    if match(param & "=", list[i]) then  -- param matches
      return i
    end if
  end for
  return 0
end function

-----------------------------------------------------------------------------

public function get_param_value(sequence list, sequence param, sequence default="")
--<function>
--<name>get_param_value</name>
--<digest>find the value of a parameter in a list of strings "parameter=value"</digest>
--<desc>
--</desc>
--<param>
--<type>sequence</type>
--<name>list</name>
--<desc>list of strings to search in</desc>
--</param>
--<param>
--<type>sequence</type>
--<name>param</name>
--<desc>parameter name to search for</desc>
--</param>
--<return>
-- sequence: requested value if found, default value if not
--</return>
--<example>
-- puts(1,get_param_value(params, "second") & "\n")
-- 2
--</example>
--<see_also>find_param_name(), set_param_value()</see_also>
--</function>
  integer i, n

  i = find_param_name(list, param)
  if i then  -- param matches
    n = find('=', list[i])
    if n then
      return dequote(trim(list[i][n+1..$]))
    else
      return ""
    end if
  end if
  return default
end function

-----------------------------------------------------------------------------

public function set_param_value(sequence list, sequence param, sequence value,
                                integer add=1)
--<function>
--<name>set_param_value</name>
--<digest>sets the value of a parameter in a list of strings "parameter=value"</digest>
--<desc>
-- if add is false (0), parameter value must exist to be modified
-- if add is true (1), a non-existing parameter will be added
--</desc>
--<param>
--<type>sequence</type>
--<name>list</name>
--<desc></desc>
--</param>
--<param>
--<type>sequence</type>
--<name>param</name>
--<desc>parameter name</desc>
--</param>
--<param>
--<type>sequence</type>
--<name>value</name>
--<desc>parameter value</desc>
--</param>
--<param>
--<type>integer</type>
--<name>add</name>
--<desc>
-- indicates to add value if not already existing. defaults to 1
--</desc>
--</param>
--<return>
-- sequence: modified list
--</return>
--<example>
-- sequence params
-- params = {"first=1","second=2","third=three"}
-- analyze_object(set_param_value(params, "third", "3"), "set_param_value")
-- set_param_value =
-- .  [1] "first=1"
-- .  [2] "second=2"
-- .  [3] "third=3"
-- analyze_object(set_param_value(params, "fourth", "4", 0), "set_param_value")
-- set_param_value =
-- .  [1] "first=1"
-- .  [2] "second=2"
-- .  [3] "third=three"
--    ("add" is not set so parameter "fourth" is not added)
-- analyze_object(set_param_value(params, "fourth", "4"), "set_param_value")
-- set_param_value =
-- .  [1] "first=1"
-- .  [2] "second=2"
-- .  [3] "third=three"
-- .  [4] "fourth=4"
--</example>
--<see_also>find_param_name(), get_param_value()</see_also>
--</function>
  integer i, eq

  i = find_param_name(list, param)
  if i then  -- param matches
    eq = find('=', list[i])
    list[i] = list[i][1..eq] & value
  else
    if add then
      list = append(list, param & "=" & value)
    end if
  end if
  return list
end function

------------------------------------------------------------------------------

public function read_ini_file(sequence filename)
--<function>
--<name>read_ini_file</name>
--<digest>reads a file structured as an INI file</digest>
--<desc>
-- result is a sequence { {section name, section content}, ... }
-- each section content is a list of parameters and values { "parameter=value", ... }
--</desc>
--<param>
--<type>sequence</type>
--<name>filename</name>
--<desc></desc>
--</param>
--<return>
--</return>
--<example>
-- file test.ini contains following lines:
-- [Telnet]
-- host=127.0.0.1
-- port=23
--
-- [SSH]
-- host=127.0.0.1
-- port=22
--
-- [FTP]
-- host=127.0.0.1
-- port=21
--
-- analyze_object(read_ini_file("test.ini"), "read_ini")
-- read_ini =
-- .  [1]
-- .  .  [1] "Telnet"
-- .  .  [2]
-- .  .  .  [1] "host=127.0.0.1"
-- .  .  .  [2] "port=23"
-- .  [2]
-- .  .  [1] "SSH"
-- .  .  [2]
-- .  .  .  [1] "host=127.0.0.1"
-- .  .  .  [2] "port=22"
-- .  [3]
-- .  .  [1] "FTP"
-- .  .  [2]
-- .  .  .  [1] "host=127.0.0.1"
-- .  .  .  [2] "port=21"
--</example>
--<see_also>write_ini_file()</see_also>
--</function>
  integer p
  sequence content, section, params, lines

  content = {}
  section = ""
  params = {}
  if not file_exists(filename) then return 0 end if
  lines = read_lines(filename)
  if begins({#EF,#BB,#BF}, lines[1]) then  -- UTF-8 BOM
    lines[1] = remove(lines[1], 1, 3)
  end if
  for i = 1 to length( lines ) do
    if length(lines[i]) then
      -- check section
      if lines[i][1] = '[' then
        p = find(']', lines[i])
        if p = 0 then
          log_puts("Missing closing bracket: exiting")
          return 0
        end if
        if length(section) then
          content = append(content, {section, params})
        end if
        section = lines[i][2..p-1]
        params = {}
      else
        if length(section)=0 then
          log_puts("Missing section: exiting")
          return 0
        end if
        -- read params
        lines[i] = trim_head(lines[i])
        if (length(lines[i]) > 0) and not begins(";", lines[i]) then
          params = append(params, lines[i])
        end if
      end if
    end if
  end for
  if length(section) then
    content = append(content, {section, params})
  end if
  return content
end function

------------------------------------------------------------------------------

public procedure write_ini_file(sequence filename, sequence content)
--<procedure>
--<name>write_ini_file</name>
--<digest>writes a sequence of lines in an INI file</digest>
--<desc>
--</desc>
--<param>
--<type>sequence</type>
--<name>filename</name>
--<desc></desc>
--</param>
--<param>
--<type>sequence</type>
--<name>content</name>
--<desc>
-- { {section name, section content}, ... }
-- each section content is a list of parameters and values { "parameter=value", ... }
--</desc>
--</param>
--<example>
-- write_ini_file("test2.ini", {{"Section",{"name=value"}}})
-- [Section]
-- name=value
--</example>
--<see_also>read_ini_file()</see_also>
--</procedure>
  integer f_out

  f_out = open(filename, "w")
  for i = 1 to length(content) do
    puts(f_out, "["&content[i][1]&"]\n")
    for j = 1 to length(content[i][2]) do
      if length(content[i][2]) > 0 then
        puts(f_out, content[i][2][j]&"\n")
      end if
    end for
    puts(f_out, "\n")
  end for
  close(f_out)
end procedure

------------------------------------------------------------------------------

public function get_ini_section(sequence ini, sequence section)
--<function>
--<name>get_ini_section</name>
--<digest>extracts a section from an INI file content</digest>
--<desc>
-- file content has to be read previously with read_ini_file()
--</desc>
--<param>
--<type>sequence</type>
--<name>ini</name>
--<desc>INI file content</desc>
--</param>
--<param>
--<type>sequence</type>
--<name>section</name>
--<desc>section name</desc>
--</param>
--<return>
-- sequence: selected section content
--</return>
--<example>
-- ini = read_ini_file("test.ini")
-- s = get_ini_section(ini, "SSH")
-- s may be (example):
-- .  [1] "host=127.0.0.1"
-- .  [2] "port=22"
--</example>search_ini(), read_ini()<see_also>
--</see_also>
--</function>
  object x

  x = find_in_array(section, ini, {{"target_field", -1}})
  if atom(x) then return 0 end if
  if length(x)<2 then return 0 end if
  return x[2]
end function

------------------------------------------------------------------------------

public function search_ini(sequence ini, sequence section, sequence key,
                           sequence default="")
--<function>
--<name>search_ini</name>
--<digest>reads an element of an INI file</digest>
--<desc>
-- file content has to be read previously with read_ini_file()
--</desc>
--<param>
--<type>sequence</type>
--<name>ini</name>
--<desc>INI file content</desc>
--</param>
--<param>
--<type>sequence</type>
--<name>section</name>
--<desc>section of ini file to search in</desc>
--</param>
--<param>
--<type>sequence</type>
--<name>key</name>
--<desc>key to search for</desc>
--</param>
--<param>
--<type>sequence</type>
--<name>default</name>
--<desc>default value returned if search fails</desc>
--</param>
--<return>
-- sequence: searched parameter value or default value if not found
--</return>
--<example>
-- puts(1, search_ini(ini, "FTP", "port") & "\n")
-- 21
--</example>
--<see_also>read_ini(), write_ini()</see_also>
--</function>
  object words

  words = get_ini_section(ini, section)
  -- analyze_object(words, "words", f_debug)
  if sequence(words) and length(words) then
    return get_param_value(words, key, default)
  end if
  return default
end function

------------------------------------------------------------------------------

public function read_ini(sequence file, sequence section, sequence name, object default)
--<function>
--<name>read_ini</name>
--<digest>reads an element of an INI file</digest>
--<desc>
--</desc>
--<param>
--<type>sequence</type>
--<name>file</name>
--<desc>INI file name</desc>
--</param>
--<param>
--<type>sequence</type>
--<name>section</name>
--<desc></desc>
--</param>
--<param>
--<type>sequence</type>
--<name>name</name>
--<desc></desc>
--</param>
--<param>
--<type>object</type>
--<name>default</name>
--<desc>default value to return if read failed</desc>
--</param>
--<return>
--</return>
--<example>
-- puts(1, read_ini("test.ini", "Telnet", "port", -1) & "\n")
-- 23
--</example>
--<see_also>search_ini(), write_ini()</see_also>
--</function>
  sequence secParams
  object ini, x

  ini = read_ini_file(file)
  if atom(ini) then return default end if
  x = get_ini_section(ini, section)
  if atom(x) then return default else secParams = x end if
  x = get_param_value(secParams, name)
  if atom(x) then return default else return x end if
end function

------------------------------------------------------------------------------

public procedure write_ini(sequence file, sequence section, sequence name, object value)
--<procedure>
--<name>write_ini</name>
--<digest>writes an element of an INI file</digest>
--<desc>
--</desc>
--<param>
--<type>sequence</type>
--<name>file</name>
--<desc>INI file name</desc>
--</param>
--<param>
--<type>sequence</type>
--<name>section</name>
--<desc></desc>
--</param>
--<param>
--<type>sequence</type>
--<name>name</name>
--<desc></desc>
--</param>
--<param>
--<type>object</type>
--<name>value</name>
--<desc></desc>
--</param>
--<example>
-- write_ini("test.ini", "Telnet", "port", "223")
-- [Telnet]
-- host=127.0.0.1
-- port=223
--
-- write_ini("test.ini", "HTTP", "host", "127.0.0.1")
-- [HTTP]
-- host=127.0.0.1
--
-- write_ini("test.ini", "HTTP", "port", "80")
-- [HTTP]
-- host=127.0.0.1
-- port=80
--</example>
--<see_also>search_ini(), read_ini()</see_also>
--</procedure>
  sequence s
  object ini
  integer sec

  ini = read_ini_file(file)
  if atom(ini) then return end if
  sec = find_in_array(section, ini, {})   --find section
  if sec=0 then    -- new section
    ini = append(ini, {section, {name & "=" & value}})
  else   -- existing section
    s = ini[sec]
    if length(s)<2 then  -- empty section
      s = append( s, {name & "=" & value} )
    else
      s[2] = set_param_value(s[2], name, value, 1)
    end if
    ini[sec] = s
  end if
  write_ini_file(file, ini)
end procedure


------------------------------------------------------------------------------

public function get_uint8(integer fn)
--<function>
--<name>get_uint8</name>
--<digest></digest>
--<desc>
--</desc>
--<param>
--<type>integer</type>
--<name>fn</name>
--<desc></desc>
--</param>
--<return>
--</return>
--<example>
--</example>
--<see_also>
--</see_also>
--</function>
-- read a single unsigned byte at current position in file
  integer i

  i = getc(fn)
  if i = -1 then   -- end of file
    return {GET_EOF, 0}
  else
    return {GET_SUCCESS, i}
  end if
end function

------------------------------------------------------------------------------

public function get_int8(integer fn)
--<function>
--<name>get_int8</name>
--<digest></digest>
--<desc>
--</desc>
--<param>
--<type>integer</type>
--<name>fn</name>
--<desc></desc>
--</param>
--<return>
--</return>
--<example>
--</example>
--<see_also>
--</see_also>
--</function>
-- read a single signed byte at current position in file
  integer i

  i = getc(fn)
  if i = -1 then   -- end of file
    return {GET_EOF, 0}
  else
    if i >= #80 then
      return {GET_SUCCESS, i-#100}
    else
      return {GET_SUCCESS, i}
    end if
  end if
end function

------------------------------------------------------------------------------

public function get_uint16(integer fn)
--<function>
--<name>get_uint16</name>
--<digest></digest>
--<desc>
--</desc>
--<param>
--<type>integer</type>
--<name>fn</name>
--<desc></desc>
--</param>
--<return>
--</return>
--<example>
--</example>
--<see_also>
--</see_also>
--</function>
-- read a 2 byte unsigned word at current position in file
  sequence s

  s = get_bytes(fn, 2)
  if length(s) < 2 then   -- end of file
    return {GET_EOF, 0}
  else
    return {GET_SUCCESS, s[1] + s[2]*#100}
  end if
end function

------------------------------------------------------------------------------

public function get_int16(integer fn)
--<function>
--<name>get_int16</name>
--<digest></digest>
--<desc>
--</desc>
--<param>
--<type>integer</type>
--<name>fn</name>
--<desc></desc>
--</param>
--<return>
--</return>
--<example>
--</example>
--<see_also>
--</see_also>
--</function>
-- read a 2 byte signed word at current position in file
  integer i
  sequence s

  s = get_bytes(fn, 2)
  if length(s) < 2 then   -- end of file
    return {GET_EOF, 0}
  else
    i = s[1] + s[2]*#100
    if i >= #8000 then
      return {GET_SUCCESS, i - #10000}
    else
      return {GET_SUCCESS, i}
    end if
  end if
end function

------------------------------------------------------------------------------

public function get_uint32(integer fn)
--<function>
--<name>get_uint32</name>
--<digest></digest>
--<desc>
--</desc>
--<param>
--<type>integer</type>
--<name>fn</name>
--<desc></desc>
--</param>
--<return>
--</return>
--<example>
--</example>
--<see_also>
--</see_also>
--</function>
-- read a 4 byte unsigned integer at current position in file
  sequence s

  s = get_bytes(fn, 4)
  if length(s) < 4 then   -- end of file
    return {GET_EOF, 0}
  else
    return {GET_SUCCESS, bytes_to_int(s)}
  end if
end function

------------------------------------------------------------------------------

public function get_int32(integer fn)
--<function>
--<name>get_int32</name>
--<digest></digest>
--<desc>
--</desc>
--<param>
--<type>integer</type>
--<name>fn</name>
--<desc></desc>
--</param>
--<return>
--</return>
--<example>
--</example>
--<see_also>
--</see_also>
--</function>
-- read a 4 byte signed integer at current position in file
  atom a
  sequence s

  s = get_bytes(fn, 4)
  if length(s) < 4 then   -- end of file
    return {GET_EOF, 0}
  else
    a = bytes_to_int(s)
    if a >= #80000000 then
      return {GET_SUCCESS, a - #100000000}
    else
      return {GET_SUCCESS, a}
    end if
  end if
end function

------------------------------------------------------------------------------

public function get_uint64(integer fn)
--<function>
--<name>get_uint64</name>
--<digest></digest>
--<desc>
--</desc>
--<param>
--<type>integer</type>
--<name>fn</name>
--<desc></desc>
--</param>
--<return>
--</return>
--<example>
--</example>
--<see_also>
--</see_also>
--</function>
-- read a 8 byte long integer at current position in file
  sequence s

  s = get_bytes(fn, 8)
  if length(s) < 8 then   -- end of file
    return {GET_EOF, 0.0}
  else
    return {GET_SUCCESS, bytes_to_int(s[1..4]) + bytes_to_int(s[5..8]*#10000)}
  end if
end function

------------------------------------------------------------------------------

public function get_float32(integer fn)
--<function>
--<name>get_float32</name>
--<digest></digest>
--<desc>
--</desc>
--<param>
--<type>integer</type>
--<name>fn</name>
--<desc></desc>
--</param>
--<return>
--</return>
--<example>
--</example>
--<see_also>
--</see_also>
--</function>
-- read a 4 byte float at current position in file
  sequence s

  s = get_bytes(fn, 4)
  if length(s) < 4 then   -- end of file
    return {GET_EOF, 0.0}
  else
    return {GET_SUCCESS, float32_to_atom(s)}
  end if
end function

------------------------------------------------------------------------------

public function get_float64(integer fn)
--<function>
--<name>get_float64</name>
--<digest></digest>
--<desc>
--</desc>
--<param>
--<type>integer</type>
--<name>fn</name>
--<desc></desc>
--</param>
--<return>
--</return>
--<example>
--</example>
--<see_also>
--</see_also>
--</function>
-- read a 8 byte float at current position in file
  sequence s

  s = get_bytes(fn, 8)
  if length(s) < 8 then   -- end of file
    return {GET_EOF, 0.0}
  else
    return {GET_SUCCESS, float64_to_atom(s)}
  end if
end function

------------------------------------------------------------------------------

public function get_string(integer fn)
--<function>
--<name>get_string</name>
--<digest></digest>
--<desc>
--</desc>
--<param>
--<type>integer</type>
--<name>fn</name>
--<desc></desc>
--</param>
--<return>
--</return>
--<example>
--</example>
--<see_also>
--</see_also>
--</function>
-- read a variable size 0-terminated string at current position in file
  sequence s
  integer n

  s = {}
  while 1 do
    n = getc(fn)
    if n = -1 then return {GET_EOF, ""} elsif n = 0 then exit end if
    s = append(s, n)
  end while
  return {GET_SUCCESS, s}
end function

------------------------------------------------------------------------------

public procedure put_int8(integer fn, integer i)
--<procedure>
--<name>put_int8</name>
--<digest></digest>
--<desc>
--</desc>
--<param>
--<type>integer</type>
--<name>fn</name>
--<desc></desc>
--</param>
--<param>
--<type>integer</type>
--<name>i</name>
--<desc></desc>
--</param>
--<example>
--</example>
--<see_also>
--</see_also>
--</procedure>
-- ok = put a single signed/unsigned byte at current position in file
  if i > #100 then return end if
  puts(fn, i)
end procedure

------------------------------------------------------------------------------

public procedure put_int16(integer fn, integer i)
--<procedure>
--<name>put_int16</name>
--<digest></digest>
--<desc>
--</desc>
--<param>
--<type>integer</type>
--<name>fn</name>
--<desc></desc>
--</param>
--<param>
--<type>integer</type>
--<name>i</name>
--<desc></desc>
--</param>
--<example>
--</example>
--<see_also>
--</see_also>
--</procedure>
-- ok = put a 2 byte signed/unsigned word at current position in file
  integer l, h

  if i > #10000 then return end if
  l = remainder(i, #100)
  h = floor(i / #100)
  puts(fn, {l, h})
end procedure

------------------------------------------------------------------------------

public procedure put_int32(integer fn, atom a)
--<procedure>
--<name>put_int32</name>
--<digest></digest>
--<desc>
--</desc>
--<param>
--<type>integer</type>
--<name>fn</name>
--<desc></desc>
--</param>
--<param>
--<type>atom</type>
--<name>a</name>
--<desc></desc>
--</param>
--<example>
--</example>
--<see_also>
--</see_also>
--</procedure>
-- ok = put a 4 byte signed/unsigned integer at current position in file
  sequence s

  if a > #100000000 then return end if
  poke4(mem4, a)
  s = peek({mem4, 4})
  puts(fn, s)
end procedure

------------------------------------------------------------------------------

public procedure put_int64(integer fn, atom a)
--<procedure>
--<name>put_int64</name>
--<digest></digest>
--<desc>
--</desc>
--<param>
--<type>integer</type>
--<name>fn</name>
--<desc></desc>
--</param>
--<param>
--<type>atom</type>
--<name>a</name>
--<desc></desc>
--</param>
--<example>
--</example>
--<see_also>
--</see_also>
--</procedure>
-- ok = put a 8 byte signed/unsigned long integer at current position in file
  sequence s

  if a > #10000000000000000 then return end if
  poke4(mem8, remainder(a, #100000000))
  poke4(mem8+4, floor(a / #100000000))
  s = peek({mem8, 8})
  puts(fn, s)
end procedure

------------------------------------------------------------------------------

public procedure put_float32(integer fn, atom a)
--<procedure>
--<name>put_float32</name>
--<digest></digest>
--<desc>
--</desc>
--<param>
--<type>integer</type>
--<name>fn</name>
--<desc></desc>
--</param>
--<param>
--<type>atom</type>
--<name>a</name>
--<desc></desc>
--</param>
--<example>
--</example>
--<see_also>
--</see_also>
--</procedure>
-- ok = put a 4 byte float at current position in file
  sequence s

  s = atom_to_float32(a)
  puts(fn, s)
end procedure

------------------------------------------------------------------------------

public procedure put_float64(integer fn, atom a)
--<procedure>
--<name>put_float64</name>
--<digest></digest>
--<desc>
--</desc>
--<param>
--<type>integer</type>
--<name>fn</name>
--<desc></desc>
--</param>
--<param>
--<type>atom</type>
--<name>a</name>
--<desc></desc>
--</param>
--<example>
--</example>
--<see_also>
--</see_also>
--</procedure>
-- ok = put a 8 byte float at current position in file
  sequence s

  s = atom_to_float64(a)
  puts(fn, s)
end procedure

------------------------------------------------------------------------------

public procedure put_string(integer fn, sequence s)
--<procedure>
--<name>put_string</name>
--<digest></digest>
--<desc>
--</desc>
--<param>
--<type>integer</type>
--<name>fn</name>
--<desc></desc>
--</param>
--<param>
--<type>sequence</type>
--<name>s</name>
--<desc></desc>
--</param>
--<see_also>
--</see_also>
--</procedure>
-- put a variable size 0-terminated string at current position in file
  sequence buffer

  buffer = s&0
  puts(fn, buffer)
end procedure
