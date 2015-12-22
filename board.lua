
function init_board(table, t_width, t_height, nr_mines)
	-- Init board 
	-- All values set to {show = false, number = 0, flag = false}

	for x = 1, t_width do
		table[x] = {}
		for y = 1, t_height do
			table[x][y] = {show = false, number = 0, flag = false}
		end
	end

	table = add_mines(table, nr_mines)
	table = count_mines(table)

	return table
end

function add_mines(table, nr_mines)
	-- Add mines randomly
	-- A mine is defined as the number 9

	if nr_mines > #table * #table[1] then
		print("Error in add_mines: Too many mines for the board")
		return table
	end
	math.randomseed(os.time())
	while nr_mines > 0 do
		local rand_x = math.random(#table)
		local rand_y = math.random(#table[1])
		if table[rand_x][rand_y].number == 0 then
	    	table[rand_x][rand_y].number = 9
	    	nr_mines = nr_mines - 1
		end
	end
	return table
end

function count_mines(table)
	-- Add numbers accoridng to the mines on the board

	local x_max = #table
	local y_max = #table[1]
	for x = 1, x_max do
		for y = 1, y_max do
			if table[x][y].number ~= 9 then
			    
				local m_count = 0

				if y > 1 and table[x][y-1].number == 9 then
					m_count = m_count + 1
				end
				if y < y_max and table[x][y+1].number == 9 then
					m_count = m_count + 1
				end

				if x > 1 then
					if y > 1 and table[x-1][y-1].number == 9 then
						m_count = m_count + 1
					end
					if table[x-1][y].number == 9 then
						m_count = m_count + 1
					end
					if y < y_max and table[x-1][y+1].number == 9 then
						m_count = m_count + 1
					end
				end

				if x < x_max then
					if y > 1 and table[x+1][y-1].number == 9 then
						m_count = m_count + 1
					end
					if table[x+1][y].number == 9 then
						m_count = m_count + 1
					end
					if y < y_max and table[x+1][y+1].number == 9 then
						m_count = m_count + 1
					end
				end

				table[x][y].number = m_count

			end
		end
	end

	return table
end

function print_table(table)
	-- print the table to console

	io.write("\n")
	for x = 1, #table do
		for y = 1, #table[x] do
			io.write(table[y][x].number .. " ")
		end
		io.write("\n")
	end
	io.write("\n")
end

function show_all(table)
	-- set all squares on to shown

	for x = 1, #table do
		for y = 1, #table[x] do
			table[x][y].show = true
		end
	end
	return table
end

function show_square(table, x, y)
	table[x][y].show = true
	if table[x][y].number == 0 then
		-- if square is 0, reqursively show all 
		-- zero-squares that are connected to this one

		local x_max = #table
		local y_max = #table[1]

		if x < x_max then
			if y > 1 and not table[x+1][y-1].show then
				table = show_square(table, x+1, y-1) -- right up
			end
			if not table[x+1][y].show then
				table = show_square(table, x+1, y) -- right
			end
			if y < y_max and not table[x+1][y+1].show then
				table = show_square(table, x+1, y+1) -- right down
			end
		end

		if x > 1 then
			if y > 1 and not table[x-1][y-1].show then
				table = show_square(table, x-1, y-1) -- left up
			end
			if not table[x-1][y].show then
				table = show_square(table, x-1, y) -- left
			end
			if y < y_max and not table[x-1][y+1].show then
				table = show_square(table, x-1, y+1) -- left down
			end
		end

		if y < y_max and not table[x][y+1].show then
			table = show_square(table, x, y+1) -- up
		end
		if y > 1 and not table[x][y-1].show then
			table = show_square(table, x, y-1) -- down
		end
	end

	return table
end

function count_hidden(table)
	-- return the number of hidden squares
	
	local count = 0
	for x = 1, #table do
		for y = 1, #table[x] do
			if not table[x][y].show then
				count = count + 1
			end
		end
	end
	return count
end

function draw_board()

	local hover_x = math.floor((love.mouse.getX()-x_offset)/square_width) + 1
	local hover_y = math.floor((love.mouse.getY()-y_offset)/square_height) + 1

	for x=1,board_width do
 		local pos_x = x_offset+((x-1)*square_width)
 		for y=1,board_height do
 			local pos_y = y_offset+((y-1)*square_height)
 			local square = board[x][y]
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
	 		if game_state.active and x == hover_x and y == hover_y and not square.show then
	 			-- hover over square
	 			love.graphics.setColor(255,255,255,50)
				love.graphics.rectangle("fill", pos_x, pos_y, square_width, square_height)	
	 		end

 			-- square outline
	 		love.graphics.setColor(0,0,0,200)
			love.graphics.rectangle("line", pos_x, pos_y, square_width, square_height)
 		end
 	end
 	if not game_state.active then
 		-- game ended, draw splash screen
 		-- background
 		love.graphics.setColor(255,255,255,200)
		love.graphics.rectangle("fill", 0, 0, love.window.getWidth(), love.window.getHeight())

		-- text
 		love.graphics.setColor(0,0,0,255)
		if game_state.won then
			love.graphics.printf("YOU WON!\nclick anywhere to restart", 0, love.window.getHeight()/2 - 50, love.window.getWidth(), "center")
		else
			love.graphics.printf("YOU LOST!\nclick anywhere to restart", 0, love.window.getHeight()/2 - 50, love.window.getWidth(), "center")
		end

 	end	

end

function board_mousepressed(x, y, button)
	local board_x = math.floor((x-x_offset)/square_width) + 1
	local board_y = math.floor((y-y_offset)/square_height) + 1

	if button == "l" then
		if board_x > 0 and board_x <= board_width and board_y > 0 and board_y <= board_height then
			if not board[board_x][board_y].flag then
				if board[board_x][board_y].number == 9 then
					-- clicked on mine, game over!
					game_state.active = false
					board = show_all(board)
					game_end = os.time()
				else
					-- show clicked square
					board = show_square(board, board_x, board_y)
					if count_hidden(board) == mines then
						-- all non-mines opened, win!
						game_state.active = false
						game_state.won = true 
						board = show_all(board)
						game_end = os.time()
					end
				end
			end
		end
	elseif button == "r" then
		if board_x > 0 and board_x <= board_width and board_y > 0 and board_y <= board_height then
			board[board_x][board_y].flag = not board[board_x][board_y].flag
		end

	end
end

