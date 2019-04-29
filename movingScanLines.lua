--fills all the non-transparent pixels in a layer with the current foreground color



local sprite = app.activeSprite

if not sprite then 
	return app.alert("There is no active sprite")
end


local frame = app.activeFrame





local fgcolor = app.fgColor
local scanLineColor = Color(fgcolor.index+1)
if not scanLineColor then
  return app.alert("Error: There is no line color specified. Please put it on the next index from your foreground color")
end


local baseLayer = app.activeLayer


local data = 
  Dialog():slider{id="frequency", label="Frequency", min=1, max=10, value=1}
          :slider{id="intensity", label="Intensity", min=1, max=110, value=60}
          :button{id="ok", text="OK"}
          :button{id="cancel", text="Cancel"}
          :show().data

if not data.ok then
  return
end

local frequency = data.frequency
local intensity = data.intensity
app.transaction(
  function()
    sprite:newLayer()
    local layer = app.activeLayer
    layer.opacity = intensity+10
    layer.blendMode = BlendMode.MULTIPLY
    layer.name = "Scanlines"
    local baseCels = baseLayer.cels
    
    local frameNum = 1 --for when the user changes the speed setting
    for currentFrame = 1, #baseCels do
      local baseCel = baseLayer:cel(currentFrame)
      local baseImg = baseCel.image
      local scanCel = sprite:newCel(layer, currentFrame, baseImg:clone(), baseCel.position)
      local scanImg = scanCel.image
      local transparent = app.pixelColor.rgba(0, 0, 0, 0)
      for x = 0, scanImg.width, 1 do
          for y = 0, scanImg.height, 1 do
            if baseImg:getPixel(x, y) ~= transparent then
              if frameNum%2 == 0 then
                if y%2 == 0 then
                  scanImg:drawPixel(x, y, Color{r=0, g=0, b=0, a=255})
                end
              else
                if (y+1)%2 == 0 then
                  scanImg:drawPixel(x, y, Color{r=0, g=0, b=0, a=255})
                end
              end
              
            end
          end
      end
    if currentFrame%frequency == 0 then 
      frameNum = frameNum + 1
      end
    end
	end)
  
	
app.alert("Scanlines Added Successfully")
app.command.DeselectMask()

	

app.refresh()