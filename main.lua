require "board"

function love.load()
	-- game settings
	board_width = 20
	board_height = 20
	mines = 10

	-- create board
	board = {}
	board = init_board(board, board_width, board_height)
	board = add_mines(board, mines)
	board = count_mines(board)
	print_table(board)

	-- window settings
	love.graphics.setBackgroundColor(20,20,20,255)
	square_width = 25
	square_height = 25
	x_offset = 5
	y_offset = 45

	love.window.setMode((square_width*board_width)+(x_offset*2), (square_height*board_height)+(y_offset+x_offset), {resizable=false})

	font = love.graphics.newFont("monofonto.ttf", 25)
	love.graphics.setFont(font)

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

	-- game states
	game_active = true
	game_won = false
	game_start = os.time()
	game_end = os.time()
end

function love.update(dt)

end

function love.mousepressed(x, y, button)
   	if game_active then
		board_x = math.floor((x-x_offset)/square_width) + 1
		board_y = math.floor((y-y_offset)/square_height) + 1

		if button == "l" then
			if board_x > 0 and board_x <= board_width and board_y > 0 and board_y <= board_height then
				if board[board_x][board_y].number == 9 then
					-- clicked on mine, game over!
					game_active = false
					board = show_all(board)
					game_end = os.time()
				else
					-- show clicked square
					board = show_square(board, board_x, board_y)
					if count_hidden(board) == mines then
						-- all non-mines opened, win!
						game_active = false
						game_won = true 
						board = show_all(board)
						game_end = os.time()
					end
				end
			end

		elseif button == "r" then
			if board_x > 0 and board_x <= board_width and board_y > 0 and board_y <= board_height then
				board[board_x][board_y].flag = not board[board_x][board_y].flag
			end

		end
	else
		-- game is not active, restart game on click
		love.load()
   	end
end

function love.draw()
	love.graphics.clear()

	hover_x = math.floor((love.mouse.getX()-x_offset)/square_width) + 1
	hover_y = math.floor((love.mouse.getY()-y_offset)/square_height) + 1

	if game_active then
		game_end = os.time()
	end

	love.graphics.setColor(255,255,255,255)
	font = love.graphics.newFont("monofonto.ttf", 40)
	love.graphics.printf("Mines: " .. mines, 20, 10, love.window.getWidth()-40, "left")
	love.graphics.printf("Time: " .. os.difftime(game_end, game_start), 20, 10, love.window.getWidth()-40, "right")


 	for x=1,board_width do
 		pos_x = x_offset+((x-1)*square_width)
 		for y=1,board_height do
 			pos_y = y_offset+((y-1)*square_height)
 			square = board[x][y]
 			if square.show then
	 			-- draw shown square
	 			-- background
	 			love.graphics.setColor(170,220,250,255)
				love.graphics.rectangle("fill", pos_x, pos_y, square_width, square_height)
	 			
	 			-- square text
	 			if square.number ~= 0 then
	 				love.graphics.setColor(number_colors[square.number])
	 				if square.number == 9 then
	 					-- mine
	 					love.graphics.print("M", pos_x+7, pos_y)
	 				else
	 					-- number
	 					love.graphics.print(square.number, pos_x+7, pos_y)
	 				end
	 			end
	 		else
	 			-- draw hidden square
	 			-- background
	 			love.graphics.setColor(95,175,250,255)
				love.graphics.rectangle("fill", pos_x, pos_y, square_width, square_height)
				if square.flag then
					-- flagged square
	 				love.graphics.setColor(number_colors[9])
					love.graphics.print("F", pos_x+7, pos_y)
				end
	 		end
	 		if game_active and x == hover_x and y == hover_y and not square.show then
	 			-- hover over square
	 			love.graphics.setColor(255,255,255,50)
				love.graphics.rectangle("fill", pos_x, pos_y, square_width, square_height)	
	 		end

 			-- square outline
	 		love.graphics.setColor(0,0,0,200)
			love.graphics.rectangle("line", pos_x, pos_y, square_width, square_height)
 		end
 	end
 	if not game_active then
 		-- game ended, draw splash screen
 		-- background
 		love.graphics.setColor(255,255,255,200)
		love.graphics.rectangle("fill", 0, 0, love.window.getWidth(), love.window.getHeight())

		-- text
 		love.graphics.setColor(0,0,0,255)
		font = love.graphics.newFont("monofonto.ttf", 60)
		if game_won then
			love.graphics.printf("YOU WON!\nclick anywhere to restart", 0, love.window.getHeight()/2 - 50, love.window.getWidth(), "center")
		else
			love.graphics.printf("YOU LOST!\nclick anywhere to restart", 0, love.window.getHeight()/2 - 50, love.window.getWidth(), "center")
		end

 	end	
end
