
function init_board(table, t_width, t_height)
	-- Init board 
	-- All values set to {show = false, number = 0, flag = false}

	for x = 1, t_width do
		table[x] = {}
		for y = 1, t_height do
			table[x][y] = {show = false, number = 0, flag = false}
		end
	end

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
		rand_x = math.random(#table)
		rand_y = math.random(#table[1])
		if table[rand_x][rand_y].number == 0 then
	    	table[rand_x][rand_y].number = 9
	    	nr_mines = nr_mines - 1
		end
	end
	return table
end

function count_mines(table)
	-- Add numbers accoridng to the mines on the board

	x_max = #table
	y_max = #table[1]
	for x = 1, x_max do
		for y = 1, y_max do
			if table[x][y].number ~= 9 then
			    
				m_count = 0

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

		x_max = #table
		y_max = #table[1]

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
	
	count = 0
	for x = 1, #table do
		for y = 1, #table[x] do
			if not table[x][y].show then
				count = count + 1
			end
		end
	end
	return count
end
