local Unit = require("Unit")

local function debugPrint(...)
    print(...)
end

local Spells = {};

local currentSpells = {{name = "heal"}}

local function GiveError(error, fromFunction)
    debugPrint(error .. " from function ", fromFunction)
end

function Spells:CAST(spellName, castingUnit, targetTeam, targetIndex, enemies, allies)
    local casterTeam = castingUnit:getTeam()

    if spellName == nil or spellName == "" then
        GiveError("No Spell In Slot", "CAST")
        return
    end

    if spellName == "heal"then
        debugPrint("Caster Team: " .. casterTeam .. " Target Team: " .. tostring(targetTeam))
        if (targetTeam ~= casterTeam and not (casterTeam == "player" and targetTeam == "ally")) or targetTeam == nil then
            GiveError("Must Target Unit on Same Team", "Heal, CAST")
            return
        end

        
        if casterTeam == "player" then
            if castingUnit:getMana() <= 20 then
                GiveError("Not Enough Mana", "Heal, CAST")
                return
            end
            allies[targetIndex]:addHealth(50)
            castingUnit:minusMana(20)
        end

        if casterTeam == "enemy" then
            enemies[targetIndex]:addHealth(50)
        end
    end
end

function Spells:GET_SPELLSLOT(spellSlot)
    if currentSpells[spellSlot] == nil then
        GiveError("No Spell In Slot", "GET_SPELLSLOT")
        return
    end
    return currentSpells[spellSlot].name or nil
end

local function NewClass()
    return setmetatable({}, {__index = Spells})
end

return NewClass()