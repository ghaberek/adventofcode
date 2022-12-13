
include std/io.e
include std/convert.e
include std/sequence.e
include std/text.e

integer overlapped = 0

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

	-- increment the counter if A overlaps B or B overlaps A
	overlapped += ((minA <= minB and minB <= maxA) or (minA <= maxB and maxB <= maxA))
			or ((minB <= minA and minA <= maxB) or (minB <= maxA and maxA <= maxB))

entry
	line = gets( STDIN )
	lineno += 1
end while

? overlapped
