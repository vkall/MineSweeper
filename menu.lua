
local buttons = {}
local settings = {}

function init_menu()
	local button_width = 200
	local button_height = 40
	local button_x = love.graphics.getWidth()/2 - button_width/2
	local button_y = 200

	local setting_width = 20
	local setting_x = button_x + button_width - setting_width

	buttons = {}
	settings = {}

	local mine_setting = {
		width = setting_width,
		height = button_height,
		x = setting_x,
		y = button_y,
		text_x = button_x,
		draw_text = function() love.graphics.print("Mines: " .. mines, button_x, button_y + 7) end,
		on_up_click = function() mines = mines + 1 end,
		on_down_click = function() mines = mines - 1 end
	}
	table.insert(settings, mine_setting)

	local row_setting = {
		width = setting_width,
		height = button_height,
		x = setting_x,
		y = mine_setting.y + button_height + 10,
		text_x = button_x,
		draw_text = function() love.graphics.print("Rows: " .. board_height, button_x, mine_setting.y + button_height + 17) end,
		on_up_click = function() board_height = board_height + 1 end,
		on_down_click = function() board_height = board_height - 1 end
	}
	table.insert(settings, row_setting)

	local column_setting = {
		width = setting_width,
		height = button_height,
		x = setting_x,
		y = row_setting.y + button_height + 10,
		text_x = button_x,
		draw_text = function() love.graphics.print("Columns: " .. board_width, button_x, row_setting.y + button_height + 17) end,
		on_up_click = function() board_width = board_width + 1 end,
		on_down_click = function() board_width = board_width - 1 end
	}
	table.insert(settings, column_setting)

	local restart_button = {
		text = "Restart",
		width = button_width,
		height = button_height,
		x = button_x,
		y = column_setting.y + button_height + 10,
		on_click = function() restart() end
	}
	table.insert(buttons, restart_button)

	local quit_button = {
		text = "Quit",
		width = button_width,
		height = button_height,
		x = button_x,
		y = restart_button.y + button_height + 10,
		on_click = function() love.event.quit() end
	}
	table.insert(buttons, quit_button)

end

function draw_menu()


	for i=1,#settings do

		local btn = settings[i]
	
		if love.mouse.getX() >= btn.x and love.mouse.getX() <= btn.x + btn.width and
			love.mouse.getY() >= btn.y and love.mouse.getY() <= (btn.y + btn.height / 2 - 1) then
			love.graphics.setColor(150,150,150,255)
		else
			love.graphics.setColor(100,100,100,255)
		end
		local triangle = {btn.x, (btn.y + btn.height / 2 - 1), (btn.x + btn.width / 2), btn.y, (btn.x + btn.width), (btn.y + btn.height / 2 - 1)}
		love.graphics.polygon("fill", triangle)

		if love.mouse.getX() >= btn.x and love.mouse.getX() <= btn.x + btn.width and
			love.mouse.getY() >= (btn.y + btn.height / 2 + 1) and love.mouse.getY() <= (btn.y + btn.height) then
			love.graphics.setColor(150,150,150,255)
		else
			love.graphics.setColor(100,100,100,255)
		end
		triangle = {btn.x, (btn.y + btn.height / 2 + 1), (btn.x + btn.width / 2), (btn.y + btn.height), (btn.x + btn.width), (btn.y + btn.height / 2 + 1)}
		love.graphics.polygon("fill", triangle)

		love.graphics.setColor(255,255,255,255)
		btn.draw_text()
	end

	for i=1,#buttons do

		local btn = buttons[i]
	
		if love.mouse.getX() >= btn.x and love.mouse.getX() <= btn.x + btn.width and
			love.mouse.getY() >= btn.y and love.mouse.getY() <= btn.y + btn.height then
			love.graphics.setColor(150,150,150,255)
		else
			love.graphics.setColor(100,100,100,255)
		end
		love.graphics.rectangle("fill", btn.x , btn.y, btn.width, btn.height, 5)
		love.graphics.setColor(255,255,255,255)
		love.graphics.printf(btn.text, btn.x, btn.y + 7, btn.width, "center")
	end
end

function menu_mousepressed(x, y, button, istouch)

	for i=1,#settings do

		local btn = settings[i]
			
		if x >= btn.x and x <= btn.x + btn.width and
			y >= btn.y and y <= (btn.y + btn.height / 2 - 1) then
			
			btn.on_up_click()
			return

		elseif x >= btn.x and x <= btn.x + btn.width and
			y >= (btn.y + btn.height / 2 + 1) and y <= (btn.y + btn.height) then

			btn.on_down_click()
			return
		end
	end

	for i=1,#buttons do

		local btn = buttons[i]
		if x >= btn.x and x <= btn.x + btn.width and
			y >= btn.y and y <= btn.y + btn.height then

			btn.on_click()
			return
		end
	end
end
