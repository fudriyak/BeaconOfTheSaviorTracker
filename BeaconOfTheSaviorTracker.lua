local BEACON_OF_THE_SAVIOR_SPELL_ID = 1244893

local function IsSupportedUnit(unit)
    return unit and (
        unit == "player" or
        unit:match("^party") or
        unit:match("^raid")
    )
end

local function IsMyBeaconOfTheSaviorOnUnit(unit)
    local aura = C_UnitAuras.GetUnitAuraBySpellID(unit, BEACON_OF_THE_SAVIOR_SPELL_ID)
    if aura and aura.sourceUnit and UnitIsUnit(aura.sourceUnit, "player") then
        return true
    end
    return false
end

local buffer_frame = nil
local buffer_color = nil
local function RemoveBufferFrameColor(frame)
    if not buffer_frame then
        buffer_frame = frame
        buffer_color = {frame.healthBar:GetStatusBarColor()}
    end

    if buffer_frame and buffer_color and frame.unit ~= buffer_frame.unit then
        buffer_frame.healthBar:SetStatusBarColor(unpack(buffer_color))

        buffer_frame = frame
        buffer_color= {frame.healthBar:GetStatusBarColor()}
    end
end

local function ColorUnitFrame(frame)
    if not frame or not frame.healthBar then return end

    local unit = frame.unit

    if unit and IsSupportedUnit(unit) then
        RemoveBufferFrameColor(frame)
        frame.healthBar:SetStatusBarColor(0, 1, 0)
    end
end


local functionsNames = {
    "CompactUnitFrame_UpdateAll",
    "CompactUnitFrame_UpdateHealth",
    "CompactUnitFrame_UpdateAuras",
}

for _, functionName in ipairs(functionsNames) do
    hooksecurefunc(functionName, function(frame)
        if not frame or not frame.unit then return end
        if(IsMyBeaconOfTheSaviorOnUnit(frame.unit)) then
            ColorUnitFrame(frame)
        end
    end)
end