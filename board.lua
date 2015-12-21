
function init_board(table, t_width, t_height)
	-- Init board
	for x = 1, t_width do
		table[x] = {}
		for y = 1, t_height do
			table[x][y] = {show = false, number = 0, flag = false}
		end
	end

	return table
end

function add_mines(table, nr_mines)
	-- Add mines
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
	-- Add numbers
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
		x_max = #table
		y_max = #table[1]

		if x < x_max then
			if y > 1 and not table[x+1][y-1].show then
				table = show_square(table, x+1, y-1)
			end
			if not table[x+1][y].show then
				table = show_square(table, x+1, y)
			end
			if y < y_max and not table[x+1][y+1].show then
				table = show_square(table, x+1, y+1)
			end
		end

		if x > 1 then
			if y > 1 and not table[x-1][y-1].show then
				table = show_square(table, x-1, y-1)
			end
			if not table[x-1][y].show then
				table = show_square(table, x-1, y)
			end
			if y < y_max and not table[x-1][y+1].show then
				table = show_square(table, x-1, y+1)
			end
		end

		if y < y_max and not table[x][y+1].show then
			table = show_square(table, x, y+1)
		end
		if y > 1 and not table[x][y-1].show then
			table = show_square(table, x, y-1)
		end
	end

	return table
end

function count_hidden(table)
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
