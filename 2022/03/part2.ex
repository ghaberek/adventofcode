
include std/io.e
include std/text.e

constant GROUP_SIZE = 3
constant PRIORITY = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ"

integer total_priority = 0

object line

while sequence( line ) with entry do
	line = text:trim( line )

	-- put this line into a group
	line = {line}

	-- read more lines into the group
	while length( line ) < GROUP_SIZE do
		line = append( line, gets(STDIN) )
		line[$] = text:trim( line[$] )
	end while

	integer shared = 0

	-- lookup each item in each sack
	for i = 1 to GROUP_SIZE do

		-- look at the items in the first sack
		for j = 1 to length( line[1] ) do
			integer count = 1

			-- compare it against the other sacks
			for k = 2 to length( line ) do
				-- increase count if item is found
				count += find( line[1][j], line[k] ) != 0
			end for

			-- is this item in each sack?
			if count = GROUP_SIZE then
				-- save the item and stop looking
				shared = line[1][j]
				exit
			end if

		end for

		-- did we find the item?
		if shared then
			-- stop looking
			exit
		end if

		-- rotate the items to try again
		line = line[2..$] & line[1..1]

	end for

	-- add the priority of the value to total
	total_priority += find( shared, PRIORITY )

entry
	line = gets( STDIN )
end while

? total_priority
