
include std/io.e
include std/convert.e
include std/regex.e
include std/text.e

constant CRATES = "ABCDEFGHIJKLMNOPQRSTUVWXYZ"
constant REGEX_MOVES = regex:new( `^move (\d+) from (\d+) to (\d+)$` )
constant STACK_START = 2,  STACK_WIDTH = 4

sequence stacks = {}

object line

-- load stacks
while sequence( line ) with entry do
	line = text:trim_tail( line, "\r\n" )

	if length( line ) = 0 then
		-- done loading stacks
		exit
	end if

	-- determine the number of stacks (probably constant?)
	integer count = floor( length(line) / STACK_WIDTH + 0.5 )

	-- first time through?
	if length( stacks ) = 0 then
		-- create the stacks
		stacks = repeat( {}, count )
	end if

	integer pos = STACK_START

	-- grab the value from each stack
	for i = 1 to count do
		-- this will skip the '1' '2' '3' at the bottom row
		if find( line[pos], CRATES ) then
			stacks[i] = insert( stacks[i], line[pos], 1 )
		end if
		pos += STACK_WIDTH
	end for

entry
	line = gets( STDIN )
end while

-- process moves
while sequence( line ) with entry do
	line = text:trim_tail( line, "\r\n" )

	-- extract the values from the line
	sequence matches = regex:matches( REGEX_MOVES, line )

	-- convert each value to integer
	integer move_no = convert:to_integer( matches[2] )
	integer move_fr = convert:to_integer( matches[3] )
	integer move_to = convert:to_integer( matches[4] )

	-- perform each move
	for i = 1 to move_no do
		stacks[move_to] &= stacks[move_fr][$]
		stacks[move_fr] = stacks[move_fr][1..$-1]
	end for

entry
	line = gets( STDIN )
end while

-- print top of each stack
for col = 1 to length( stacks ) do
	puts( STDOUT, stacks[col][$] )
end for
puts( STDOUT, "\n" )
