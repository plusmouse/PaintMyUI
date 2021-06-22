local CORE_EVENTS = {
  "ADDON_LOADED"
}
PaintMyUICoreMixin = {}

function PaintMyUICoreMixin:OnLoad()
  FrameUtil.RegisterFrameForEvents(self, CORE_EVENTS)
end

function PaintMyUICoreMixin:OnEvent(eventName, name)
  if eventName == "ADDON_LOADED" and name == "PaintMyUI" then
    self.objects = GetAllRegions(UIParent)
    self:Paint(PAINT_MY_UI_COLOR)
    self.position = 255
    FrameUtil.UnregisterFrameForEvents(self, CORE_EVENTS)
  end
end

function PaintMyUICoreMixin:OnUpdate(elapsed)
  if self.objects == nil then
    return
  end

  self.position = self.position + elapsed * 255

  if self.position > 255*2 then
    self.position = 0
  end

  local color
  if self.position > 255 then
    color = CreateColorFromBytes(255, math.floor(255*2 - self.position), 0, 255)
  else
    color = CreateColorFromBytes(255, math.floor(self.position), 0, 255)
  end

  self:Paint(color)
end


function GetAllRegions(frame)
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
    for _, r in ipairs(GetAllRegions(c)) do
      if r:GetObjectType() == "Texture" then
        table.insert(result, r)
      end
    end
  end

  return result
end

function PaintMyUICoreMixin:Paint(color)
  for _, o in pairs(self.objects) do
    o:SetVertexColor(color.r, color.g, color.b, color.a)
  end
end