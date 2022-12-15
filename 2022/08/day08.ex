
include std/io.e
include std/math.e
include std/sequence.e
include std/text.e

function is_visible( sequence trees, integer row, integer col )

	integer n = length( trees ) -- quick shorthand for length

	sequence hslice = stdseq:slice( trees[row], 1 ) -- horizontal slice (the row)
	sequence vslice = stdseq:vslice( trees, col )   -- vertical slice (the column)

	sequence lslice = stdseq:slice( hslice, 1, col ) -- left slice
	sequence tslice = stdseq:slice( vslice, 1, row ) -- top slice
	sequence rslice = stdseq:slice( hslice, col, n ) -- right slice
	sequence bslice = stdseq:slice( vslice, row, n ) -- bottom slice

	-- reverse right/bottom slices
	rslice = stdseq:reverse( rslice )
	bslice = stdseq:reverse( bslice )

	-- to determine visibility from each edge, we check to see if the
	-- first instance of the largest item is at the end of the slice.
	integer left   = (col = 1) or (find(math:max(lslice), lslice) = length(lslice))
	integer top    = (row = 1) or (find(math:max(tslice), tslice) = length(tslice))
	integer right  = (col = n) or (find(math:max(rslice), rslice) = length(rslice))
	integer bottom = (row = n) or (find(math:max(bslice), bslice) = length(bslice))

	return left or top or right or bottom
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
	sequence visible = xor_bits( trees, trees )

	-- determine if each tree is visible	
	for row = 1 to length( trees ) do
		for col = 1 to length( trees ) do
			-- determine visibility for this tree
			visible[row][col] = is_visible( trees, row, col )
		end for
	end for

	-- values are 1 or 0 so a
	-- sum provides the count
	? math:sum( visible )

end procedure

main()
