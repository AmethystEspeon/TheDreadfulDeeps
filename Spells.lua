local function debugPrint(...)
    print(...)
end

--CONSTANTS--
local maxPlayerSpells = 10;

local Spells = {};

--Player Spells Variables--
local knownSpells = {};
local playerSpellSlots = {};


local function GiveError(error, fromFunction)
    debugPrint(error .. " from function ", fromFunction)
end

function Spells:setKnownSpells(playerUnit)
   knownSpells = playerUnit.spells
end

function Spells:CAST(spellName, castingUnit, targetTeam, targetIndex, enemies, allies)
    local castingTeam = castingUnit:getTeam()

    if spellName == nil or spellName == "" then
        GiveError("No Spell In Slot", "CAST")
        return
    end

    if spellName == "heal" then
        local spell = castingUnit:getSpell(spellName)
        if not Spells:isCastable(spell, spellName, castingUnit, castingTeam, targetTeam, targetIndex, enemies, allies, "same") then
            debugPrint("Not castable")
            return
        end
        if castingTeam == "player" then
            if allies[targetIndex]:getHealth() >= allies[targetIndex]:getMaxHealth() then
                GiveError("Target is already at max health", "Heal, CAST")
                return
            end
            allies[targetIndex]:addHealth(50)
            castingUnit:minusMana(20)
        end
        if spell.maxCooldown then
            spell.currentCooldown = spell.maxCooldown
        end
    end

    if spellName == "cauterize" then
        local spell = castingUnit:getSpell(spellName)
        if not Spells:isCastable(spell, spellName, castingUnit, castingTeam, targetTeam, targetIndex, enemies, allies, "same") then
            debugPrint("Not castable")
            return
        end
        if castingTeam == "player" then
            if allies[targetIndex]:getHealth() >= allies[targetIndex]:getMaxHealth() then
                GiveError("Target is already at max health", "Heal, CAST")
                return
            end
            allies[targetIndex]:minusHealth(25)
            allies[targetIndex]:addBuff("cauterize", 3, 0.25, false)
        end
        if spell.maxCooldown then
            spell.currentCooldown = spell.maxCooldown
        end
    end
end

function Spells:tick(buffName, target)
    if buffName == "cauterize" then
        target:addHealth(5)
    end
end

function Spells:isCastable(spell, spellName, castingUnit, castingTeam, targetTeam, targetIndex, enemies, allies, allowedTargets)
    --For checking ally vs enemy w/o dealing with player
    local fixedCastingTeam = castingTeam
    local fixedTargetTeam = targetTeam
    if fixedCastingTeam == "player" then
        fixedCastingTeam = "ally"
    end
    if fixedTargetTeam == "player" then
        fixedTargetTeam = "ally"
    end

    --Checking player-only conditions--
    if castingTeam == "player" then
        if not Spells:getKnownSpell(spellName) then
            GiveError("Don't know spell", "checkIfCastable")
            return false
        end
        if spell.manaCost and castingUnit:getMana() < spell.manaCost then
            GiveError("Not Enough Mana", "checkIfCastable")
            return false
        end
    end

    --Checking if target is allowed--
    if allowedTargets == "any" then
        if targetTeam == nil then
            GiveError("Must Target Unit", "isCastable")
            return false
        end
    end

    if allowedTargets == "same" or allowedTargets == "dead" then
        if fixedTargetTeam ~= fixedCastingTeam or targetTeam == nil then
            GiveError("Must Target Unit on Same Team", "checkIfCastable")
            return false
        end
    end

    if allowedTargets == "opposed" then
        if targetTeam == castingTeam then
            GiveError("Must Target Unit on Opposite Team", "checkIfCastable")
            return false
        end
    end

    if allowedTargets ~= "dead" then
        if fixedTargetTeam == "enemy" then
            if enemies[targetIndex]:isDead() then
                GiveError("Must Target Living Unit", "checkIfCastable")
                return false
            end
        end
        if fixedTargetTeam == "ally" then
            if allies[targetIndex]:isDead() then
                GiveError("Must Target Living Unit", "checkIfCastable")
                return false
            end
        end
    end

    --Checking inherent spell conditions--
    if spell.currentCooldown > 0 then
        GiveError("Spell On Cooldown", "checkIfCastable")
        return false
    end

    return true
end

function Spells:getSpellSlotByNumber(spellSlot)
    if playerSpellSlots[spellSlot] == nil then
        GiveError("No Spell In Slot", "GET_SPELLSLOT")
        return
    end
    return playerSpellSlots[spellSlot].name or nil
end

function Spells:drawCooldown(imageFile, maxCooldown, currentCooldown, x, y, scale)
    love.graphics.push()
    love.graphics.scale(scale)
    x = x/scale
    y = y/scale
    local percent = currentCooldown / maxCooldown
    if percent > 1 then
        percent = 1
    end
    local image = love.graphics.newImage(imageFile)
    love.graphics.setColor(1,1,1,1)
    love.graphics.draw(image, x, y)
    local function stencilFunction()
        love.graphics.rectangle("fill", x, y, image:getWidth(), image:getHeight())
    end
    love.graphics.stencil(stencilFunction, "replace", 1)
    love.graphics.setStencilTest("greater", 0)
    love.graphics.setColor(0.2,0.2,0.2,.7)
    love.graphics.arc("fill", x+1/2*image:getWidth(), y+1/2*image:getHeight(), image:getWidth()*1.5, -1/2*math.pi,math.pi*2*percent-1/2*math.pi)
    love.graphics.setStencilTest()
    love.graphics.pop()
end

function Spells:addSpell(unit, newSpell)
    for i=1, #unit.spells do
        if unit.spells[i].name == newSpell.name then
            debugPrint("Replacing Spell with new version")
            table.remove(unit.spells, i)
        end
    end
    table.insert(unit.spells,newSpell)
end

function Spells:removePlayerSpell(spellName)
    for i=1, #knownSpells do
        if knownSpells[i].name == spellName then
            table.remove(knownSpells, i)
            return
        end
    end
    GiveError("Spell Not Known", "removePlayerSpell")
end

function Spells:setSpellSlot(spellSlot, knownSpell)
    playerSpellSlots[spellSlot] = knownSpell
end

function Spells:getSpellSlot(spellSlot)
    if playerSpellSlots[spellSlot] == nil then
        --GiveError("No Spell In Slot", "getSpellSlot")
        return nil
    end
    return playerSpellSlots[spellSlot]
end

function Spells:getKnownSpell(spellName)
    for i=1, #knownSpells do
        --debugPrint("Known Spell: " .. knownSpells[i].name)
        if knownSpells[i].name == spellName then
            return knownSpells[i]
        end
    end
    GiveError("Spell Not Known", "getKnownSpell")
    return nil
end

function Spells:ProgressSpellCooldowns(allyUnits, enemyUnits, dt)
    local allies = allyUnits or {};
    local enemies = enemyUnits or {};
    --Player Cooldowns--
    for i=1, #knownSpells do
        if knownSpells[i].currentCooldown > 0 then
            knownSpells[i].currentCooldown = knownSpells[i].currentCooldown - dt
            if knownSpells[i].currentCooldown < 0 then
                knownSpells[i].currentCooldown = 0
            end
        end
    end
    for i=1, #allies do
        for j=1, #allies[i].spells do
            if allies[i].spells[j].currentCooldown > 0 then
                allies[i].spells[j].currentCooldown = allies[i].spells[j].currentCooldown - dt
                if allies[i].spells[j].currentCooldown < 0 then
                    allies[i].spells[j].currentCooldown = 0
                end
            end
        end
    end
    for i=1, #enemies do
        for j=1, #enemies[i].spells do
            if enemies[i].spells[j].currentCooldown > 0 then
                enemies[i].spells[j].currentCooldown = enemies[i].spells[j].currentCooldown - dt
                if enemies[i].spells[j].currentCooldown < 0 then
                    enemies[i].spells[j].currentCooldown = 0
                end
            end
        end
    end
end

local function NewClass()
    return setmetatable({}, {__index = Spells});
end

return NewClass()