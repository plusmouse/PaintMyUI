local function GetAllTextures(frame)
  local result = {}

  if frame:IsForbidden() then
    return result
  end

  for _, r in ipairs({frame:GetRegions()}) do
    if r:GetObjectType() == "Texture" then
      table.insert(result, r)
    end
  end

  for _, c in ipairs({frame:GetChildren()}) do
    for _, r in ipairs(GetAllTextures(c)) do
      table.insert(result, r)
    end
  end

  return result
end

local CORE_EVENTS = {
  "ADDON_LOADED"
}
PaintMyUICoreMixin = {}

function PaintMyUICoreMixin:OnLoad()
  FrameUtil.RegisterFrameForEvents(self, CORE_EVENTS)
end

function PaintMyUICoreMixin:OnEvent(eventName, name)
  if eventName == "ADDON_LOADED" then
    PAINT_MY_UI_COLOR = PAINT_MY_UI_COLOR or {r = 1, g = 0, b = 1}

    self:Paint(GetAllTextures(UIParent), PAINT_MY_UI_COLOR)
  end
end

function PaintMyUICoreMixin:Paint(textures, color)
  for _, o in pairs(textures) do
    o:SetVertexColor(color.r, color.g, color.b, color.a)
  end
end
