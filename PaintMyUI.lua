local function GetAllTextures(frame, check)
  local result = {}

  if frame:IsForbidden() then
    return result
  end

  for _, r in ipairs({frame:GetRegions()}) do
    if r:GetObjectType() == "Texture" and (not check or check(r)) then
      table.insert(result, r)
    end
  end

  for _, c in ipairs({frame:GetChildren()}) do
    for _, r in ipairs(GetAllTextures(c, check)) do
      table.insert(result, r)
    end
  end

  return result
end

local function NineSlicesCheck(region)
  if region:GetParent() and region:GetParent():GetParent() then
    local lookingFor = region:GetParent()
    for key, value in pairs(region:GetParent():GetParent()) do
      if value == lookingFor and key == "NineSlice" then
        return true
      end
    end
  end
  return false
end

local function AllRegionsCheck(region)
  return true
end

local function Paint(textures, color)
  for _, o in pairs(textures) do
    o:SetVertexColor(color.r, color.g, color.b, color.a)
  end
end

local CORE_EVENTS = {
  "ADDON_LOADED"
}
PaintMyUICoreMixin = {}

function PaintMyUICoreMixin:OnLoad()
  FrameUtil.RegisterFrameForEvents(self, CORE_EVENTS)
  PaintMyUI_SetupSlashCMD()
end

function PaintMyUICoreMixin:OnEvent(eventName, name)
  if eventName == "ADDON_LOADED" then
    PAINT_MY_UI_COLOR = PAINT_MY_UI_COLOR or {r = 1, g = 0, b = 1}
    self.textures = GetAllTextures(UIParent, NineSlicesCheck)

    self:Paint()
  end
end

function PaintMyUICoreMixin:Paint()
  Paint(self.textures, PAINT_MY_UI_COLOR)
end
