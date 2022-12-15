
include std/io.e
include std/math.e
include std/sequence.e
include std/text.e
include std/utils.e

function calculate_score( sequence trees, integer row, integer col )

	integer n = length( trees ) -- quick shorthand for length

	sequence hslice = stdseq:slice( trees[row] ) -- horizontal slice (the row)
	sequence vslice = stdseq:vslice( trees, col ) -- vertical slice (the column)

	-- take each slice, except for edge trees
	sequence lslice = {}, uslice = {}, rslice = {}, dslice = {}
	if (col != 1) then lslice = stdseq:slice( hslice, 1, col - 1 ) end if -- left slice
	if (row != 1) then uslice = stdseq:slice( vslice, 1, row - 1 ) end if -- up slice
	if (col != n) then rslice = stdseq:slice( hslice, col + 1, n ) end if -- right slice
	if (row != n) then dslice = stdseq:slice( vslice, row + 1, n ) end if -- down slice

	-- reverse up/left slices so we're
	-- looking "out" from our position
	lslice = stdseq:reverse( lslice )
	uslice = stdseq:reverse( uslice )

	-- limit each slice to first instance of maximum value
	lslice = stdseq:slice( lslice, 1, find(1, lslice >= trees[row][col]) )
	uslice = stdseq:slice( uslice, 1, find(1, uslice >= trees[row][col]) )
	rslice = stdseq:slice( rslice, 1, find(1, rslice >= trees[row][col]) )
	dslice = stdseq:slice( dslice, 1, find(1, dslice >= trees[row][col]) )

	-- multiply number of trees for total score
	return length(lslice)*length(uslice)*length(rslice)*length(dslice)
end function

procedure main()

	sequence trees = {}

	object line

	-- load trees data
	while sequence( line ) with entry do
		line = text:trim( line )
		trees = append( trees, line )
	entry
		line = gets( STDIN )
	end while

	-- create matching grid of zeros
	sequence scores = xor_bits( trees, trees )

	-- determine if each tree is visible	
	for row = 1 to length( trees ) do
		for col = 1 to length( trees ) do
			-- determine visibility for this tree
			scores[row][col] = calculate_score( trees, row, col )
		end for
	end for

	-- print maximum score
	? math:max( scores )

end procedure

main()
