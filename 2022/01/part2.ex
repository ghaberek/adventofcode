
include std/io.e
include std/convert.e
include std/math.e
include std/text.e

constant TOP_ELVES = 3

integer cur_cal = 0
sequence max_cal = repeat( 0, TOP_ELVES )

object line

while sequence( line ) with entry do
	line = text:trim( line )
	if length( line ) then
		-- add value to current elf
		cur_cal += convert:to_integer( line )
	else
		-- look for potential maximum
		for i = 1 to TOP_ELVES do
			if cur_cal > max_cal[i] then
				-- insert the current value
				max_cal = splice( max_cal, cur_cal, i )
				exit
			end if
		end for
		-- reset current elf
		cur_cal = 0
	end if
entry
	line = gets( STDIN )
end while

? math:sum( max_cal[1..TOP_ELVES] )
