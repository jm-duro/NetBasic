
include std/sequence.e
include std/filesys.e
include std/console.e
include lib/_search_.e
include lib/_file_.e
include lib/_debug_.e
include lib/_http_.e
include lib/_html_.e

sequence found1, found2
integer ok, max, n, parent
sequence html, xml, elements, s

f_debug = open(InitialDir&SLASH&"debug.log", "w")

s = parse_file(InitialDir & "\\page.html")
html = s[1]
elements = s[2]
analyze_object(elements, "elements", f_debug)

found1 = match_all_nested("information", elements)
analyze_object(found1, "found1", f_debug)
for i = 1 to length(found1) do
  log_puts(fetch(elements, found1[i]) & "\n")
  parent = get_parent_containing(found1[i], "Domain", elements, html)
  if parent > 1 then
    ok = i
    log_printf("\n=> parent found in elements[%d]\n", {parent})
    analyze_object(elements[parent],
                   sprintf("elements[%d]", parent),
                   f_debug)
  end if
end for
if ok then
  log_printf("\n=> %s found in elements[%d]\n",
             {fetch(elements, found1[ok]), found1[ok][1]})
  analyze_object(elements[found1[ok][1]],
                 sprintf("elements[%d]", found1[ok][1]),
                 f_debug)
  log_printf("\n=> link = %s\n",
             {get_closest_link(found1[ok], elements, html)})
end if
log_puts("\n")

found2 = match_all_nested("Domain", elements)
analyze_object(found2, "found2", f_debug)
for i = 1 to length(found2) do
  log_puts(fetch(elements, found2[i]) & "\n")
end for
ok = 0
max = 0
for i = 1 to length(found2) do
  for j = 1 to length(found1) do
    analyze_object(xml_path(found1[j][1], elements),
                   sprintf("xml_path(found1[%d][1])",j),
                   f_debug)
    analyze_object(xml_path(found2[i][1], elements),
                   sprintf("xml_path(found2[%d][1])",i),
                   f_debug)
    n = matching_length(xml_path(found1[j][1], elements),
                        xml_path(found2[i][1], elements))
    analyze_object(n, "n", f_debug)
    if n > max then
      max = n
      ok = j
    end if
  end for
end for
if ok then
  log_puts("\n=> " & fetch(elements, found1[ok]) & "\n")
  analyze_object(found1[ok], sprintf("found1[%d]", ok), f_debug)
end if
log_puts("\n")

xml =
  "<?xml version=\"1.0\" standalone=\"yes\" ?>" &
  "<list>" &
  "  <node id=\"proxmox\" claimed=\"true\" class=\"system\" handle=\"DMI:0002\">" &
  "    <description>Low Profile Desktop Computer</description>" &
  "    <product>()</product>" &
  "    <vendor>Hewlett-Packard</vendor>" &
  "  </node>" &
  "</list>"
log_puts(xml & "\n")

s = xml_to_sequence(xml)
analyze_object(s, "xml_to_sequence(xml)", f_debug)

xml = "<setting id=\"driver\" value=\"MOSCHIP usb-ethernet driver\" />"
log_puts(xml & "\n")

s = get_tag_name(xml)
--s will get value "setting"
analyze_object(s, "get_tag_name()", f_debug)

s = get_attributes(xml)
--s will get value {{"id", "driver"}, {"value", "MOSCHIP usb-ethernet driver"}}
analyze_object(s, "get_attributes()", f_debug)

s = get_attribute_value("id", xml)
--s will get value "driver"
analyze_object(s, "get_attribute_value(\"id\")", f_debug)

close(f_debug)

puts(1, "Fini !\n")
maybe_any_key()

