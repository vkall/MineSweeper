require "board"

function love.load()
	board_width = 15
	board_height = 15
	mines = 20

	board = {}
	board = init_board(board, board_width, board_height)
	board = add_mines(board, mines)
	board = count_mines(board)
	print_table(board)

	square_width = 25
	square_height = 25
	success = love.window.setMode((square_width*board_width)+10, (square_height*board_height)+10, {resizable=false})

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
		{255,0,0,255}, -- Bomb
	}

	game_active = true
end

function love.update(dt)

end

function love.mousepressed(x, y, button)
   	if game_active then
		board_x = math.floor((x-5)/square_width) + 1
		board_y = math.floor((y-5)/square_height) + 1

		if button == "l" then
			if board_x > 0 and board_x <= board_width and board_y > 0 and board_y <= board_height then
				if board[board_x][board_y].number == 9 then
					-- Bomb, game over
					game_active = false
					board = show_all(board)
				else
					-- Show clicked square
					board = show_square(board, board_x, board_y)
				end
			end

		elseif button == "r" then
			if board_x > 0 and board_x <= board_width and board_y > 0 and board_y <= board_height then
				board[board_x][board_y].flag = not board[board_x][board_y].flag
			end

		end
	else
		-- Restart game
		love.load()
   	end
end

function love.draw()

 	love.graphics.setColor(170,220,250,255)

	hover_x = math.floor((love.mouse.getX()-5)/square_width) + 1
	hover_y = math.floor((love.mouse.getY()-5)/square_height) + 1

 	for x=1,board_width do
 		pos_x = 5+((x-1)*square_width)
 		for y=1,board_height do
 			pos_y = 5+((y-1)*square_height)
 			square = board[x][y]
 			if square.show then
	 			-- square background
	 			love.graphics.setColor(170,220,250,255)
				love.graphics.rectangle("fill", pos_x, pos_y, square_width, square_height)
	 			
	 			-- square text
	 			if square.number ~= 0 then
	 				love.graphics.setColor(number_colors[square.number])
	 				if square.number == 9 then
	 					love.graphics.print("B", pos_x+7, pos_y)
	 				else
	 					love.graphics.print(square.number, pos_x+7, pos_y)
	 				end
	 			end
	 		else
	 			love.graphics.setColor(95,175,250,255)
				love.graphics.rectangle("fill", pos_x, pos_y, square_width, square_height)
				if square.flag then
	 				love.graphics.setColor(number_colors[9])
					love.graphics.print("F", pos_x+7, pos_y)
				end
	 		end
	 		if game_active and x == hover_x and y == hover_y and not square.show then
	 			-- Hover over square
	 			love.graphics.setColor(255,255,255,50)
				love.graphics.rectangle("fill", pos_x, pos_y, square_width, square_height)	
	 		end

 			-- square outline
	 		love.graphics.setColor(0,0,0,200)
			love.graphics.rectangle("line", pos_x, pos_y, square_width, square_height)
 		end
 	end
 	if not game_active then
 		love.graphics.setColor(255,255,255,200)
		love.graphics.rectangle("fill", 0, 0, love.window.getWidth(), love.window.getHeight())

 		love.graphics.setColor(0,0,0,255)
		font = love.graphics.newFont("monofonto.ttf", 50)
		love.graphics.printf("GAME OVER\nclick anywhere to restart", 0, love.window.getHeight()/2 - 50, love.window.getWidth(), "center")

 	end	
end
