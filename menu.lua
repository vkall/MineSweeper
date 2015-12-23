
local buttons = {}

function init_menu()
	local button_width = 200
	local button_height = 40
	local button_x = love.graphics.getWidth()/2 - button_width/2
	local button_y = 200

	local restart_button = {
		text = "Restart",
		width = button_width,
		height = button_height,
		x = button_x,
		y = button_y,
		on_click = function() restart() end
	}
	table.insert(buttons, restart_button)

	button_y = button_y + button_height + 10

	local quit_button = {
		text = "Quit",
		width = button_width,
		height = button_height,
		x = button_x,
		y = button_y,
		on_click = function() love.event.quit() end
	}
	table.insert(buttons, quit_button)

end

function draw_menu()

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

	for i=1,#buttons do

		local btn = buttons[i]
		if x >= btn.x and x <= btn.x + btn.width and
			y >= btn.y and y <= btn.y + btn.height then

			btn.on_click()
			return
		end
	end
end
