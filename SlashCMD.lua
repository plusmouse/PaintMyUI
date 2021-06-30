function PaintMyUI_SetupSlashCMD()
  SlashCmdList["PaintMyUI"] = PaintMyUI_SlashCMDHandler
  SLASH_PaintMyUI1 = "/paintmyui"
  SLASH_PaintMyUI2 = "/pmui"
end

function PaintMyUI_SlashCMDHandler()
  local info = UIDropDownMenu_CreateInfo()
  local originalColor = PAINT_MY_UI_COLOR
  info.r = PAINT_MY_UI_COLOR.r
  info.g = PAINT_MY_UI_COLOR.g
  info.b = PAINT_MY_UI_COLOR.b

  info.swatchFunc = function()
    local r, g, b = ColorPickerFrame:GetColorRGB()
    PAINT_MY_UI_COLOR = {r = r, g = g, b = b}
    PaintMyUICore:Paint()
  end
  info.cancelFunc = function()
    PAINT_MY_UI_COLOR = originalColor
    PaintMyUICore:Paint()
  end

  OpenColorPicker(info)
end
