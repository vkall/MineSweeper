require "board"
require "menu"

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

	board = init_board(board, board_width, board_height, mines)
	print_table(board)

	-- set window size based on board dimensions
	love.window.setMode((square_width*board_width)+(x_offset*2), (square_height*board_height)+(y_offset+x_offset), {resizable=false})

	init_menu()

	settings_button = {
		text = "Settings",
		width = 90,
		height = 28,
		x = love.graphics.getWidth() - 100,
		y = 8,
		on_click = function() game_state.show_menu = not game_state.show_menu end
	}

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

function love.mousepressed(x, y, button, istouch)
   	if game_state.active then
		if x >= settings_button.x and x <= settings_button.x + settings_button.width and
			y >= settings_button.y and y <= settings_button.y + settings_button.height then

			settings_button.on_click()
		elseif game_state.show_menu then
			menu_mousepressed(x, y, button, istouch)
		else
			board_mousepressed(x, y, button, istouch)
		end
	else
		-- game is not active, restart game on click
		restart()
   	end
end

function love.keypressed(k)
   if k == 'escape' then
      game_state.show_menu = not game_state.show_menu
   end
end

function love.draw()
	love.graphics.clear()

	-- Settings button
	if love.mouse.getX() >= settings_button.x and love.mouse.getX() <= settings_button.x + settings_button.width and
		love.mouse.getY() >= settings_button.y and love.mouse.getY() <= settings_button.y + settings_button.height then
		love.graphics.setColor(150,150,150,255)
	else
		love.graphics.setColor(100,100,100,255)
	end
	love.graphics.rectangle("fill", settings_button.x , settings_button.y, settings_button.width, settings_button.height, 5)
	love.graphics.setColor(255,255,255,255)
	love.graphics.printf(settings_button.text, settings_button.x, settings_button.y, settings_button.width, "center")

	if game_state.show_menu then
		draw_menu()
	else
		love.graphics.setColor(255,255,255,255)
		love.graphics.printf("Mines: " .. mines .. " - Time: " .. os.difftime(game_end, game_start) , 10, 10, love.graphics.getWidth()-20, "left")
	 	draw_board()
 	end
end
