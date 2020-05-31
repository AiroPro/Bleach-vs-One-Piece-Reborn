function bvo_anzu_skill_5( keys )
	local caster = keys.caster
	local target = keys.target
	local ability = keys.ability
	local extra_gold = ability:GetLevelSpecialValueFor("extra_gold", ability:GetLevel() - 1 )
	local int_as_gold = ability:GetLevelSpecialValueFor("int_as_gold", ability:GetLevel() - 1 )

	local totalGoldGain = extra_gold + (caster:GetIntellect() * int_as_gold)
	if caster:GetTeam() == DOTA_TEAM_BADGUYS then
		for _,hero in pairs(_G.tHeroesDire) do
			local particle = ParticleManager:CreateParticle("particles/econ/items/bounty_hunter/bounty_hunter_hunters_hoard/bounty_hunter_hoard_track_reward.vpcf", PATTACH_ABSORIGIN_FOLLOW, hero)
			ParticleManager:SetParticleControl(particle, 0, hero:GetAbsOrigin()) 
			ParticleManager:SetParticleControl(particle, 1, hero:GetAbsOrigin())
			ParticleManager:SetParticleControl(particle, 2, hero:GetAbsOrigin())
			ParticleManager:SetParticleControl(particle, 3, hero:GetAbsOrigin())
			hero:EmitSound("DOTA_Item.Hand_Of_Midas")
			hero:ModifyGold(totalGoldGain, true, 0)
			_G:PopupNumbers(hero, "gold", Vector(255, 200, 33), 1.0, totalGoldGain, POPUP_SYMBOL_PRE_PLUS, nil, false)
		end
	elseif caster:GetTeam() == DOTA_TEAM_GOODGUYS then
		for _,hero in pairs(_G.tHeroesRadiant) do
			local particle = ParticleManager:CreateParticle("particles/econ/items/bounty_hunter/bounty_hunter_hunters_hoard/bounty_hunter_hoard_track_reward.vpcf", PATTACH_ABSORIGIN_FOLLOW, hero)
			ParticleManager:SetParticleControl(particle, 0, hero:GetAbsOrigin())
			ParticleManager:SetParticleControl(particle, 1, hero:GetAbsOrigin())
			ParticleManager:SetParticleControl(particle, 2, hero:GetAbsOrigin())
			ParticleManager:SetParticleControl(particle, 3, hero:GetAbsOrigin())
			hero:EmitSound("DOTA_Item.Hand_Of_Midas")
			hero:ModifyGold(totalGoldGain, true, 0)
			_G:PopupNumbers(hero, "gold", Vector(255, 200, 33), 1.0, totalGoldGain, POPUP_SYMBOL_PRE_PLUS, nil, false)
		end
	end
end

function bvo_anzu_skill_5_selfhit( keys )
	local caster = keys.caster
	local attacker = keys.attacker
	local damage = keys.attack_damage
	local ability = keys.ability
	local self_damage_percent = ability:GetLevelSpecialValueFor("self_damage_percent", ability:GetLevel() - 1 ) / 100

	if damage > 1 and attacker and caster and attacker~=caster then
		local damageTable = {
			victim = attacker,
			attacker = caster,
			damage = damage * self_damage_percent,
			damage_type = DAMAGE_TYPE_PURE,
		}
		ApplyDamage(damageTable)
		SendOverheadEventMessage(nil, OVERHEAD_ALERT_BONUS_POISON_DAMAGE, caster, ApplyDamage(damageTable) , nil)
	end
end