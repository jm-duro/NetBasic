include lib/_html_.e
------------------------------------------------------------------------------

procedure click_statement()
-- ex: click supprimer [icon] [ of ["CLIP"] "1234ABC0" ]
--                     [ in "liste des services BE" [ "under", "JMD" ] ] 
-- les items entre crochets ne sont requis que s'il y a plusieurs items de même nom
-- type peut valoir: link, text, button, field, image, icon, menu
  sequence result, link, html, elements, found1
  object target_name, target_type, col_header, assoc, section, parent, s
  integer ok, up

  result = analyzeSyntax({
    "click", "<name>", '[', "<type>", ']',
    '[', "of", '[', "<header>", ']', "<assoc>", ']',
    '[', "in", "<section>", '[', "under", "<parent>", ']', ']'
  })
  target_name = get_result_item("<name>", result, 0)
  target_type = get_result_item("<type>", result, 0)
  col_header = get_result_item("<header>", result, 0)
  assoc = get_result_item("<assoc>", result, 0)
  section = get_result_item("<section>", result, 0)
  parent = get_result_item("<parent>", result, 0)
  analyze_object(target_name, "name", {{"output", f_debug}})
  analyze_object(target_type, "type", {{"output", f_debug}})
  analyze_object(col_header, "header", {{"output", f_debug}})
  analyze_object(assoc, "assoc", {{"output", f_debug}})
  analyze_object(section, "section", {{"output", f_debug}})
  analyze_object(parent, "parent", {{"output", f_debug}})
  html = wd_get_page_source(sessionId)
  elements = parse_sequence(html)
  analyze_object(elements, "elements", {{"output", f_debug}})
  found1 = search_target(target_name, elements)
  analyze_object(found1, "found1", {{"output", f_debug}})
  ok = 0
  if length(found1) = 1 then  -- unique selector
    ok = 1
  else                        -- many items corresponding to the description
    for i = 1 to length(found1) do
      up = get_parent_containing(found1[i], assoc, elements, html)
      if up > 1 then   -- up=1 => whole document
        ok = i
        log_printf("\n=> up found in elements[%d]\n", {up})
        analyze_object(elements[up],
                       sprintf("elements[%d]", up),
                       {{"output", f_debug}})
      end if
    end for
  end if
  if ok then
    log_printf("\n=> %s found in elements[%d]\n",
               {fetch(elements, found1[ok]), found1[ok][1]})
    analyze_object(elements[found1[ok][1]],
                   sprintf("elements[%d]", found1[ok][1]),
                   {{"output", f_debug}})
    link = get_closest_link(found1[ok], elements, html)
    log_printf("\n=> link = %s\n", {link})
  else
    error_message("No link to '" & target_name & "' identified!", 1)
  end if
end procedure

