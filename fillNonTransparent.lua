--fills all the non-transparent pixels in a layer with the current foreground color

local fgcolor = app.fgColor
local sprite = app.activeSprite

if not sprite then 
	return app.alert("There is no active sprite")
end

local cel = app.activeCel
if not cel then	
	return app.alert("There is no active image")
end

local img = cel.image:clone()

if img.colorMode == ColorMode.RGB then


	local transparent = app.pixelColor.rgba(0, 0, 0, 0)
	for it in img:pixels() do
		if it() ~= transparent then
			it(app.pixelColor.rgba(fgcolor.red, fgcolor.green, fgcolor.blue, fgcolor.alpha))
		end
	end
	
	
	app.command.DeselectMask()
end

if img.colorMode == ColorMode.INDEXED then

	local transparent = img.spec.transparentColor
	for it in img:pixels() do
		if it() ~= transparent then
			it(fgcolor)
		end
	end
	
	
	app.command.DeselectMask()
end
	

cel.image = img
app.refresh()