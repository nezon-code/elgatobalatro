--- STEAMODDED HEADER
--- MOD_NAME: Cat Joker
--- MOD_ID: GATOBALATRO
--- MOD_AUTHOR: [nezon]
--- MOD_DESCRIPTION: A joker that adds an use for 3s. 
--- PREFIX: gato
----------------------------------------------
------------MOD CODE -------------------------
-- CREDITS TO BBBaltro/nsluke. The code is NOT mine!!!!!!!!!!!!!!!!!!!!!

local success, dpAPI = pcall(require, "debugplus-api")
if success and dpAPI.isVersionCompatible(1) then -- Make sure DebugPlus is available and compatible
    local debugplus = dpAPI.registerID("gato")
    logger = debugplus.logger -- Provides the logger object
end

local gato = {
    elgatobalatro = {                                    
        name = "El Gato Balatro",                               
        text = {
            "{C:green}#4# in #3#{} chance of",       
            "{X:red,C:white}X#2#{} for each {C:attention}3{} played",
        },
        config = { extra = { mult = 0, x_mult = 3, odds = 3, normal = 1 } },  
        pos = { x = 0, y = 0 },                         
        rarity = 3,                                     --rarity 1=common, 2=uncommen, 3=rare, 4=legendary
        cost = 10,                                      
        blueprint_compat = true,  
        eternal_compat = true,  
        unlocked = true,  
        atlas = nil,  
        discovered = false,  
        soul_pos = nil,             

        calculate = function(self, context)  
            if context.individual and context.cardarea == G.play then
                if context.other_card:get_id() == 3 then
                    if pseudorandom('gatobalatro') < G.GAME.probabilities.normal/self.ability.extra.odds then
                        return {
                            x_mult = self.ability.extra.x_mult,
                            card = self
                        }
                    end
                end
            end     
        end,

        loc_def = function(self) --defines variables to use in the UI. you can use #1# for example to show the mult variable, and #2# for x_mult
            return { self.ability.extra.mult, self.ability.extra.x_mult, self.ability.extra.odds, G.GAME and G.GAME.probabilities.normal or 1  }
        end
    },

}


function SMODS.INIT.GATOBALATRO()
    --localization for the info queue key
    G.localization.descriptions.Other["gatobala"] = {
        name = "some localization", --tooltip name
        text = {
            "Idk",   --tooltip text.		
            "What localizations",   --you can add as many lines as you want
            "Do lmao :3"    --more than 5 lines look odd
        }
    }
    init_localization()

    --Create and register jokers
    for k, v in pairs(gato) do --for every object in 'jokers'
        local joker = SMODS.Joker:new(v.name, k, v.config, v.pos, { name = v.name, text = v.text }, v.rarity, v.cost,
            v.unlocked, v.discovered, v.blueprint_compat, v.eternal_compat, v.effect, v.atlas, v.soul_pos)
        joker:register()

        if not v.atlas then --if atlas=nil then use single sprites. In this case you have to save your sprite as slug.png (for example j_examplejoker.png)
            SMODS.Sprite:new("j_" .. k, SMODS.findModByID("GATOBALATRO").path, "j_" .. k .. ".png", 71, 95, "asset_atli")
                :register()
        end

        --add jokers calculate function:
        SMODS.Jokers[joker.slug].calculate = v.calculate
        --add jokers loc_def:
        SMODS.Jokers[joker.slug].loc_def = v.loc_def
        --if tooltip is present, add jokers tooltip
        if (v.tooltip ~= nil) then
            SMODS.Jokers[joker.slug].tooltip = v.tooltip
        end
    end
end
  
----------------------------------------------
------------MOD CODE END----------------------
    
