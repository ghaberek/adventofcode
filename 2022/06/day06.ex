
include std/io.e

constant MARKER_SIZE = 4

integer offset = 0, start = 0
sequence buffer = {}

integer ch

while not find( ch, {EOF,'\r','\n'} ) with entry do

	-- increment counter
	offset += 1

	-- convert ch to integer
	ch = ch - 'a' + 1

	-- append character to the buffer
	buffer = insert( buffer, ch, 1 )

	-- check buffer length
	if length( buffer ) < MARKER_SIZE then
		-- not enough characters
		ch = getc( STDIN )
		continue
	end if

	-- input characters are all 'a'-'z'
	-- so ch value will always be 1-26
	sequence counts = repeat( 0, 26 )

	-- count each character
	for i = 1 to MARKER_SIZE do
		ch = buffer[i]
		counts[ch] += 1
	end for

	-- here, "counts > 1" will be a sequence of
	-- boolean results (0 or 1), so if no count
	-- is greater than 1 then we have our start
	if find( 1, counts > 1 ) = 0 then
		start = offset
		exit
	end if

entry
	ch = getc( STDIN )
end while

? start
