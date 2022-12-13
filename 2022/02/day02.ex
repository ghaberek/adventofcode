
include std/io.e
include std/text.e

enum WIN = 6,
	LOSE = 0,
	DRAW = 3

constant ROSHAMBO = {
	-- Opponent vs Player
	{DRAW,LOSE,WIN},
	{WIN,DRAW,LOSE},
	{LOSE,WIN,DRAW}
}

integer total_score = 0

object line

while sequence( line ) with entry do
	line = text:trim( line )

	-- read opponent and player throws
	integer op_throw = line[1] - 'A' + 1
	integer my_throw = line[3] - 'X' + 1

	-- lookup win/lose/draw for this round
	integer round_score = ROSHAMBO[my_throw][op_throw]

	-- add player throw and score to total
	total_score += my_throw + round_score

entry
	line = gets( STDIN )
end while

? total_score
