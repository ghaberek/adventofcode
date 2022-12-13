
include std/io.e
include std/convert.e
include std/math.e
include std/text.e

integer cur_cal = 0
integer max_cal = 0

object line

while sequence( line ) with entry do
	line = text:trim( line )
	if length( line ) then
		-- add value to current elf
		cur_cal += convert:to_integer( line )
	else
		-- update maximum calories
		max_cal = math:max({ max_cal, cur_cal })
		-- reset current elf
		cur_cal = 0
	end if
entry
	line = gets( STDIN )
end while

? max_cal
