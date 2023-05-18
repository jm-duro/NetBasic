include lib/_types_.e
include std/console.e

printf(1, "positive(1) = %d\n", {positive(1)})
printf(1, "positive(0) = %d\n", {positive(0)})
printf(1, "positive(-1) = %d\n", {positive(-1)})

printf(1, "is_space(9) = %d\n", {is_space(9)})
printf(1, "is_space(10) = %d\n", {is_space(10)})
printf(1, "is_space(11) = %d\n", {is_space(11)})
printf(1, "is_space(12) = %d\n", {is_space(12)})
printf(1, "is_space(13) = %d\n", {is_space(13)})
printf(1, "is_space(32) = %d\n", {is_space(32)})
printf(1, "is_space('A') = %d\n", {is_space('A')})

printf(1, "is_alpha('A') = %d\n", {is_alpha('A')})
printf(1, "is_alpha('Z') = %d\n", {is_alpha('Z')})
printf(1, "is_alpha('a') = %d\n", {is_alpha('a')})
printf(1, "is_alpha('z') = %d\n", {is_alpha('z')})
printf(1, "is_alpha('0') = %d\n", {is_alpha('0')})

printf(1, "is_digit('0') = %d\n", {is_digit('0')})
printf(1, "is_digit('9') = %d\n", {is_digit('9')})
printf(1, "is_digit('A') = %d\n", {is_digit('A')})

printf(1, "is_string('0') = %d\n", {is_string('0')})
printf(1, "is_string(10) = %d\n", {is_string(10)})
printf(1, "is_string(\"abc0\") = %d\n", {is_string("abc0")})
printf(1, "is_string({\"abc\",0}) = %d\n", {is_string({"abc",0})})
printf(1, "is_string({\"abc\"}) = %d\n", {is_string({"abc"})})

printf(1, "is_number(\"+1,000,000.12\") = %d\n", {is_number("+1,000,000.12")})
printf(1, "is_number(\"-3.14\") = %d\n", {is_number("-3.14")})
printf(1, "is_number(\"+1.000.000,12\") = %d\n", {is_number("+1.000.000,12")})
printf(1, "is_number(\"-3,14\") = %d\n", {is_number("-3,14")})
printf(1, "is_number({\"0\",0}) = %d\n", {is_number({"0",0})})
printf(1, "is_number({\"0\"}) = %d\n", {is_number({"0"})})

printf(1, "is_date(\"09/11\") = %d\n", {is_date("09/11")})
printf(1, "is_date(\"10/08/1960\") = %d\n", {is_date("10/08/1960")})
printf(1, "is_date(\"10/08/60\") = %d\n", {is_date("10/08/60")})
printf(1, "is_date(\"1/08/60\") = %d\n", {is_date("1/08/60")})
printf(1, "is_date(\"10/8/60\") = %d\n", {is_date("10/8/60")})
printf(1, "is_date(\"10/8/6\") = %d\n", {is_date("10/8/6")})
printf(1, "is_date(\"Aug 10 1960\") = %d\n", {is_date("Aug 10 1960")})
printf(1, "is_date(\"10 August 1960\") = %d\n", {is_date("10 August 1960")})

printf(1, "is_hex(\"1A\") = %d\n", {is_hex("1A")})
printf(1, "is_hex(\"#CA\") = %d\n", {is_hex("#CA")})
printf(1, "is_hex(\"#10\") = %d\n", {is_hex("#10")})

printf(1, "is_identifier(\"0id\") = %d\n", {is_identifier("0id")})
printf(1, "is_identifier(\"_id\") = %d\n", {is_identifier("_id")})
printf(1, "is_identifier(\"_ID0\") = %d\n", {is_identifier("_ID0")})
printf(1, "is_identifier(\"my-id\") = %d\n", {is_identifier("my-id")})

integer ok

maybe_any_key()

