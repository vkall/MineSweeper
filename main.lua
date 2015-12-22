require "board"


-- initial game settings
board_width = 25
board_height = 25
mines = 40
board = {}

-- window settings
square_width = 25
square_height = 25
x_offset = 5
y_offset = 45

number_colors = {
	{0,0,0,255}, -- 1
	{0,0,150,255}, -- 2
	{0,100,100,255}, -- 3
	{0,150,0,255}, -- 4
	{150,150,0,255}, -- 5
	{150,0,150,255}, -- 6
	{130,130,130,255}, -- 7
	{150,0,0,255}, -- 8
	{255,0,0,255}, -- Mine
}

function love.load()

	love.graphics.setBackgroundColor(20,20,20,255)
	font = love.graphics.newFont("monofonto.ttf", 25)
	love.graphics.setFont(font)

	restart()

end

function restart() 

	-- create board
	board = init_board(board, board_width, board_height, mines)
	print_table(board)

	-- set window size based on board dimensions
	love.window.setMode((square_width*board_width)+(x_offset*2), (square_height*board_height)+(y_offset+x_offset), {resizable=false})

	-- game states
	game_state = {
		active = true,
		won = false,
		show_menu = false 
	}
	game_start = os.time()
	game_end = os.time()

end


function love.update(dt)

	if game_state.active then
		game_end = os.time()
	end

end

function love.mousepressed(x, y, button)
   	if game_state.active then
		board_mousepressed(x, y, button)
	else
		-- game is not active, restart game on click
		restart()
   	end
end

function love.draw()
	love.graphics.clear()

	love.graphics.setColor(255,255,255,255)
	love.graphics.printf("Mines: " .. mines .. " - Time: " .. os.difftime(game_end, game_start) , 10, 10, love.window.getWidth()-20, "left")

	-- Settings button
	love.graphics.setColor(150,150,150,255)
	love.graphics.rectangle("fill", love.window.getWidth() - 100 , 8, 90, 28)
	love.graphics.setColor(255,255,255,255)
	love.graphics.print("Settings", love.window.getWidth() - 95 , 8)

	if game_state.show_menu then

	else
	 	draw_board()
 	end
end
