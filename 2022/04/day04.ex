
include std/io.e
include std/convert.e
include std/sequence.e
include std/text.e

integer contained = 0

object line
integer lineno = 0

while sequence( line ) with entry do
	line = text:trim( line )

	-- split into assignments pairs
	line = stdseq:split( line, ',' )

	-- split pairs into upper/lower values
	sequence A = stdseq:split( line[1], '-' )
	sequence B = stdseq:split( line[2], '-' )

	-- convert values into integers
	integer minA = convert:to_integer( A[1] )
	integer maxA = convert:to_integer( A[2] )
	integer minB = convert:to_integer( B[1] )
	integer maxB = convert:to_integer( B[2] )

	-- increment the counter if A contains B or B contains A
	contained += (minA <= minB and maxB <= maxA) or (minB <= minA and maxA <= maxB)

entry
	line = gets( STDIN )
	lineno += 1
end while

? contained
