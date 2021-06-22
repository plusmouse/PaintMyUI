local CORE_EVENTS = {
  "ADDON_LOADED"
}
PaintMyUICoreMixin = {}

function PaintMyUICoreMixin:OnLoad()
  FrameUtil.RegisterFrameForEvents(self, CORE_EVENTS)
end

function PaintMyUICoreMixin:OnEvent(eventName, name)
  if eventName == "ADDON_LOADED" and name == "PaintMyUI" then
    FrameUtil.UnregisterFrameForEvents(self, CORE_EVENTS)

    self:Paint(GetAllTextures(UIParent), PAINT_MY_UI_COLOR)
  end
end

function GetAllTextures(frame)
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
      if r:GetObjectType() == "Texture" then
        table.insert(result, r)
      end
    end
  end

  return result
end

function PaintMyUICoreMixin:Paint(textures, color)
  for _, o in pairs(textures) do
    o:SetVertexColor(color.r, color.g, color.b, color.a)
  end
end
