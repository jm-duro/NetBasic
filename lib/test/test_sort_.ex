include std/sort.e
include std/text.e
include std/console.e
include lib/_common_.e
include lib/_debug_.e
include lib/_sort_.e

f_debug = open("debug.log", "w")

constant student_ages = {18,21,16,23,17,16,20,20,19}
sequence sorted_ages
sorted_ages = ext_sort( student_ages )
analyze_object(sorted_ages, "sorted_ages", f_debug)
-- result is {16,16,17,18,19,20,20,21,23}

sequence students
students = {{"Anne",18},   {"Bob",21},
            {"Chris",16},  {"Diane",23},
            {"Eddy",17},   {"Freya",16},
            {"George",20}, {"Heidi",20},
            {"Ian",19}}
sequence sorted_byage
function byage(object a, object b)
 ----- If the ages are the same, compare the names otherwise just compare ages.
    if equal(a[2], b[2]) then
        return compare(upper(a[1]), upper(b[1]))
    end if
    return compare(a[2], b[2])
end function

sorted_byage = ext_custom_sort( routine_id("byage"), students, {} )
-- result is {{"Chris",16}, {"Freya",16},
--            {"Eddy",17},  {"Anne",18},
--            {"Ian",19},   {"George",20},
--            {"Heidi",20}, {"Bob",21},
--            {"Diane",23}}
analyze_object(sorted_byage, "sorted_byage", f_debug)

sorted_byage = ext_custom_sort( routine_id("byage"), students, {{"order", REVERSE_ORDER}} )
-- result is {{"Diane",23}, {"Bob",21},
--            {"Heidi",20}, {"George",20},
--            {"Ian",19},   {"Anne",18},
--            {"Eddy",17},  {"Freya",16},
--            {"Chris",16}}
analyze_object(sorted_byage, "sorted_byage", f_debug)

students = {{"Anne","Baxter",18}, {"Bob","Palmer",21},
            {"Chris","du Pont",16},{"Diane","Fry",23},
            {"Eddy","Ammon",17},{"Freya","Brash",16},
            {"George","Gungle",20},{"Heidi","Smith",20},
            {"Ian","Sidebottom",19}}
sequence sorted
function colsort(object a, object b, sequence cols)
    integer sign
    for i = 1 to length(cols) do
        if cols[i] < 0 then
            sign = -1
            cols[i] = -cols[i]
        else
            sign = 1
        end if
        if not equal(a[cols[i]], b[cols[i]]) then
            return sign * compare(upper(a[cols[i]]), upper(b[cols[i]]))
        end if
    end for

    return 0
end function

-- Order is age:descending, Surname, Given Name
sequence column_order
column_order = {-3,2,1}
sorted = ext_custom_sort( routine_id("colsort"), students, {{"data",{column_order}}} )
-- result is
-- {
--     {"Diane","Fry",23},
--     {"Bob","Palmer",21},
--     {"George","Gungle",20},
--     {"Heidi","Smith",20},
--     {"Ian","Sidebottom",19},
--     {"Anne", "Baxter", 18 },
--     {"Eddy","Ammon",17},
--     {"Freya","Brash",16},
--     {"Chris","du Pont",16}
-- }
analyze_object(sorted, "sorted", f_debug)

sorted = ext_custom_sort( routine_id("colsort"), students, {{"data",{column_order}},{"order", REVERSE_ORDER}} )
-- result is
-- {
--     {"Chris","du Pont",16},
--     {"Freya","Brash",16},
--     {"Eddy","Ammon",17},
--     {"Anne", "Baxter", 18 },
--     {"Ian","Sidebottom",19},
--     {"Heidi","Smith",20},
--     {"George","Gungle",20},
--     {"Bob","Palmer",21},
--     {"Diane","Fry",23}
-- }
analyze_object(sorted, "sorted", f_debug)

close(f_debug)

maybe_any_key()

