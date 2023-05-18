-- md5.e - The MD5 Message-Digest Algorithm - 'clean' version 1.11
-- Copyright (C) 2000  Davi Tassinari de Figueiredo
--
-- If you wish to contact me, send an e-mail to davitf@usa.net .
--
-- You can get the latest version of this program from my Euphoria page:
-- http://davitf.n3.net/
--
--
-- License terms and disclaimer:
--
-- Permission is granted to anyone to use this software for any purpose,
-- including commercial applications, and to alter it and redistribute it
-- freely, subject to the following restrictions:
--
-- 1. The origin of this software must not be misrepresented; you must not
--    claim that you wrote the original software or remove the original
--    authors' names.
-- 2. Altered source versions must be plainly marked as such, and must not
--    be misrepresented as being the original software.
-- 3. All source distributions, with or without modifications, must be
--    distributed under this license. If this software's source code is
--    distributed as part of a larger product, this item does not apply to
--    the rest of the product.
-- 4. If you use this software in a product, an acknowledgment in the
--    product documentation is required. If the source code for the product
--    is not freely distributed, you must include information on how to
--    freely obtain the original software's source code.
--
-- This software is provided 'as-is', without any express or implied
-- warranty.  In no event will the authors be held liable for any damages
-- arising from the use of this software.
--
-- If you want to distribute this software in a way not allowed by this
-- license, or distribute the source under different license terms, contact
-- the authors for permission.


include std/math.e
include std/convert.e
include std/io.e
include _conv_.e

-- 'General-purpose' routines

-- The bitwise functions in Euphoria (xor_bits, and_bits, or_bits, not_bits)
-- return signed numbers. The following functions return unsigned numbers.

function uxor(atom data1,atom data2)
    atom result
    result=xor_bits(data1,data2)
    if result<0 then return result+#100000000 else return result end if
end function

function uand(atom data1,atom data2)
    atom result
    result=and_bits(data1,data2)
    if result<0 then return result+#100000000 else return result end if
end function

function uor(atom data1,atom data2)
    atom result
    result=or_bits(data1,data2)
    if result<0 then return result+#100000000 else return result end if
end function

function unot(atom data)
    atom result
    result=not_bits(data)
    if result<0 then return result+#100000000 else return result end if
end function


constant power_2={       #1,       #2,       #4,       #8,  -- This table
            #10,      #20,      #40,      #80,  -- is used to
               #100,     #200,     #400,     #800,  -- avoid using
              #1000,    #2000,    #4000,    #8000,  -- power(2,n)
             #10000,   #20000,   #40000,   #80000,  -- in rol(),
            #100000,  #200000,  #400000,  #800000,  -- making the
           #1000000, #2000000, #4000000, #8000000,  -- routine a bit
          #10000000,#20000000,#40000000,#80000000,  -- faster.
         #100000000}

function rol(atom word,integer bits)
    -- rol() rotates the bits of a word (32-bit number)
    -- the specified number of bits
    return remainder(word*power_2[bits+1],#100000000)+floor(word/power_2[33-bits])
end function

-- End of general-purpose routines


constant table_T={
#D76AA478, #E8C7B756, #242070DB, #C1BDCEEE, #F57C0FAF, #4787C62A, #A8304613,
#FD469501, #698098D8, #8B44F7AF, #FFFF5BB1, #895CD7BE, #6B901122, #FD987193,
#A679438E, #49B40821, #F61E2562, #C040B340, #265E5A51, #E9B6C7AA, #D62F105D,
#02441453, #D8A1E681, #E7D3FBC8, #21E1CDE6, #C33707D6, #F4D50D87, #455A14ED,
#A9E3E905, #FCEFA3F8, #676F02D9, #8D2A4C8A, #FFFA3942, #8771F681, #6D9D6122,
#FDE5380C, #A4BEEA44, #4BDECFA9, #F6BB4B60, #BEBFBC70, #289B7EC6, #EAA127FA,
#D4EF3085, #04881D05, #D9D4D039, #E6DB99E5, #1FA27CF8, #C4AC5665, #F4292244,
#432AFF97, #AB9423A7, #FC93A039, #655B59C3, #8F0CCC92, #FFEFF47D, #85845DD1,
#6FA87E4F, #FE2CE6E0, #A3014314, #4E0811A1, #F7537E82, #BD3AF235, #2AD7D2BB,
#EB86D391}

constant m_block={ 1, 2, 3, 4, 5, 6, 7, 8, 9,10,11,12,13,14,15,16,
           2, 7,12, 1, 6,11,16, 5,10,15, 4, 9,14, 3, 8,13,
           6, 9,12,15, 2, 5, 8,11,14, 1, 4, 7,10,13,16, 3,
           1, 8,15, 6,13, 4,11, 2, 9,16, 7,14, 5,12, 3,10}

constant c_words={#67452301,#EFCDAB89,#98BADCFE,#10325476}

sequence words

function divide_in_words(sequence message)
    -- Divides the string into words (32-bit numbers)

    sequence words
    words=repeat(0,length(message)/4)
    for word=1 to length(message)/4 do
    words[word]=bytes_to_int(message[word*4-3..word*4])
    end for
    return words

end function


procedure process_block(sequence block)
    -- Updates the words according to the contents of the block

    atom a,b,c,d

    block=divide_in_words(block)

    a=words[1]
    b=words[2]
    c=words[3]
    d=words[4]

    -- Round 1
    for step=1 to 16 by 4 do

    a = remainder(b + rol( remainder(a + block[m_block[step]] + table_T[step] +
        uor(and_bits(b,c),and_bits(not_bits(b),d)),
        #100000000),7),#100000000)

    d = remainder(a + rol( remainder(d + block[m_block[step+1]] + table_T[step+1] +
        uor(and_bits(a,b),and_bits(not_bits(a),c)),
        #100000000),12),#100000000)

    c = remainder(d + rol( remainder(c + block[m_block[step+2]] + table_T[step+2] +
        uor(and_bits(d,a),and_bits(not_bits(d),b)),
        #100000000),17),#100000000)

    b = remainder(c + rol( remainder(b + block[m_block[step+3]] + table_T[step+3] +
        uor(and_bits(c,d),and_bits(not_bits(c),a)),
        #100000000),22),#100000000)

    end for


    -- Round 2
    for step=17 to 32 by 4 do

    a = remainder(b + rol( remainder(a + block[m_block[step]] + table_T[step] +
        uor(and_bits(b,d),and_bits(c,not_bits(d))),
        #100000000),5),#100000000)

    d = remainder(a + rol( remainder(d + block[m_block[step+1]] + table_T[step+1] +
        uor(and_bits(a,c),and_bits(b,not_bits(c))),
        #100000000),9),#100000000)

    c = remainder(d + rol( remainder(c + block[m_block[step+2]] + table_T[step+2] +
        uor(and_bits(d,b),and_bits(a,not_bits(b))),
        #100000000),14),#100000000)

    b = remainder(c + rol( remainder(b + block[m_block[step+3]] + table_T[step+3] +
        uor(and_bits(c,a),and_bits(d,not_bits(a))),
        #100000000),20),#100000000)

    end for


    -- Round 3
    for step=33 to 48 by 4 do

    a = remainder(b + rol( remainder(a + block[m_block[step]] + table_T[step] +
        uxor(b,xor_bits(c,d)),
        #100000000),4),#100000000)

    d = remainder(a + rol( remainder(d + block[m_block[step+1]] + table_T[step+1] +
        uxor(a,xor_bits(b,c)),
        #100000000),11),#100000000)

    c = remainder(d + rol( remainder(c + block[m_block[step+2]] + table_T[step+2] +
        uxor(d,xor_bits(a,b)),
        #100000000),16),#100000000)

    b = remainder(c + rol( remainder(b + block[m_block[step+3]] + table_T[step+3] +
        uxor(c,xor_bits(d,a)),
        #100000000),23),#100000000)

    end for


    -- Round 4
    for step=49 to 64 by 4 do

    a = remainder(b + rol( remainder(a + block[m_block[step]] + table_T[step] +
        uxor(c,or_bits(b,not_bits(d))),
        #100000000),6),#100000000)

    d = remainder(a + rol( remainder(d + block[m_block[step+1]] + table_T[step+1] +
        uxor(b,or_bits(a,not_bits(c))),
        #100000000),10),#100000000)

    c = remainder(d + rol( remainder(c + block[m_block[step+2]] + table_T[step+2] +
        uxor(a,or_bits(d,not_bits(b))),
        #100000000),15),#100000000)

    b = remainder(c + rol( remainder(b + block[m_block[step+3]] + table_T[step+3] +
        uxor(d,or_bits(c,not_bits(a))),
        #100000000),21),#100000000)

    end for


    -- Update the words
    words[1]=remainder(words[1]+a,#100000000)
    words[2]=remainder(words[2]+b,#100000000)
    words[3]=remainder(words[3]+c,#100000000)
    words[4]=remainder(words[4]+d,#100000000)

end procedure


function pad_message(sequence message)
    -- Add bytes to the end of the message so it can be divided
    -- in an exact number of 64-byte blocks.

    atom bytes_to_add
    bytes_to_add=64-remainder(length(message)+9,64)
    if bytes_to_add=64 then bytes_to_add=0 end if

    message=message&128&repeat(0,bytes_to_add)&
      int_to_bytes(length(message)*8)&{0,0,0,0}

    return message
end function


public function md5(sequence message)
    -- Given a string, returns a 16-byte hash of it.

    words=c_words   -- Initialize the H words

    message=pad_message(message)    -- Add bytes to the message

    -- Process each 64-byte block
    for pos_in_message=1 to length(message) by 64 do
       process_block(message[pos_in_message..pos_in_message+63])
    end for

    -- Convert hash into bytes
    return int_to_bytes(words[1])&    -- Return the hash
       int_to_bytes(words[2])&
       int_to_bytes(words[3])&
       int_to_bytes(words[4])

end function

------------------------------------------------------------------------------
-- added function

public function md5sum(sequence filename)
--<function>
--<name>md5sum</name>
--<digest>returns MD5 checksum of a file</digest>
--<desc></desc>
--<param>
--<type>sequence</type>
--<name>filename</name>
--<desc>the filename to compute</desc>
--</param>
--<return>
-- sequence: an hexadecimal MD5 hash string of the file content
--</return>
--<example>
-- s = md5sum(sequence filename)
--</example>
--<see_also>md5()</see_also>
--</function>
  sequence whole_file

  whole_file = read_file(filename)
  return hex_string(md5(whole_file))
end function

