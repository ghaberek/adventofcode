
include std/io.e
include std/convert.e
include std/regex.e
include std/text.e

constant MAX_DISK_SPACE = 70000000
constant MIN_FREE_SPACE = 30000000

constant REGEX_CMDCD = regex:new( `^\$ cd (.+)$` )
constant REGEX_CMDLS = regex:new( `^\$ ls$` )
constant REGEX_LSDIR = regex:new( `^dir (.+)$` )
constant REGEX_LSFILE = regex:new( `^(\d+) (.+)$`)

enum E_NAME, E_SIZE, E_PDIR

sequence entries = {{"/",0,0}}
sequence stack = {1}

object line

-- process commands to build the file system
while sequence( line ) with entry do
	line = text:trim( line )

	if regex:is_match( REGEX_CMDLS, line ) then
		-- process "ls" command

		-- (NOP?)

	elsif regex:is_match( REGEX_CMDCD, line ) then
		-- process "cd" command

		sequence matches = regex:matches( REGEX_CMDCD, line )

		if equal( matches[2], "/" ) then

			-- reset stack to root
			stack = {1}

		elsif equal( matches[2], ".." ) then

			-- move up one directory
			stack = stack[1..$-1]

		else

			-- find the directory with matching name
			integer found = 0

			-- search for dir name after current position
			for i = stack[$] + 1 to length( entries ) do
				if equal( entries[i][E_NAME], matches[2] & "/" )
						and entries[i][E_PDIR] = stack[$] then
					-- found matching directory
					found = i
					exit
				end if
			end for

			-- add this dir to stack
			stack = append( stack, found )

		end if

	elsif regex:is_match( REGEX_LSDIR, line ) then
		-- process directory entry

		sequence matches = regex:matches( REGEX_LSDIR, line )

		-- add dir to list with current dir as its parent
		entries = append( entries, {matches[2] & "/",0,stack[$]} )

	elsif regex:is_match( REGEX_LSFILE, line ) then
		-- process file entry

		sequence matches = regex:matches( REGEX_LSFILE, line )
		integer size = convert:to_integer( matches[2] )

		-- add file to list with current dir as its parent
		entries = append( entries, {matches[3],size,stack[$]} )

		integer parent = stack[$]

		-- add size to each parent
		while parent != 0 do
			entries[parent][E_SIZE] += size
			parent = entries[parent][E_PDIR]
		end while

	end if

entry
	line = gets( STDIN )
end while

-- determine minimum size we need to make available
integer minimum = MIN_FREE_SPACE - (MAX_DISK_SPACE - entries[1][E_SIZE])

-- assume we're deleting the root directory first
integer selected = entries[1][E_SIZE]

for i = 2 to length( entries ) do

	if entries[i][E_NAME][$] = '/'        -- is this entry a directory?
		and minimum < entries[i][E_SIZE]  -- and is it over our minimum?
		and entries[i][E_SIZE] < selected -- and is it under our current?
	then
		selected = entries[i][E_SIZE]
	end if

end for

? selected
