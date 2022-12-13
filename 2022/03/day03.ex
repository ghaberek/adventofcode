
include std/io.e
include std/text.e

constant PRIORITY = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ"

integer total_priority = 0

object line

while sequence( line ) with entry do
	line = text:trim( line )

	-- find the middle (line is always even)
	integer mid = length(line) / 2

	-- separate into two sacks
	sequence sack1 = line[1..mid]
	sequence sack2 = line[mid+1..$]

	integer shared = 0

	-- look for the shared value
	for i = 1 to mid do
		if find( sack1[i], sack2 ) then
			shared = sack1[i]
			exit
		end if
		if find( sack2[i], sack1 ) then
			shared = sack2[i]
			exit
		end if
	end for

	-- add the priority of the value to total
	total_priority += find( shared, PRIORITY )

entry
	line = gets( STDIN )
end while

? total_priority
