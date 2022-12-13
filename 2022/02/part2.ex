
include std/io.e
include std/text.e

constant REVERSHAMBO = {
  --  A   B   C (Rock/Paper/Scissors)
	{'Z','X','Y'}, -- Lose
	{'X','Y','Z'}, -- Draw
	{'Y','Z','X'}  -- Win
}

integer total_score = 0

object line

while sequence( line ) with entry do
	line = text:trim( line )

	-- read opponent throw and desired score
	integer op_throw = line[1] - 'A' + 1
	integer my_score = line[3] - 'X' + 1

	-- lookup required player throw for this round
	integer my_throw = REVERSHAMBO[my_score][op_throw] - 'X' + 1

	-- add player throw and score to total
	total_score += my_throw + (my_score - 1) * 3

entry
	line = gets( STDIN )
end while

? total_score
