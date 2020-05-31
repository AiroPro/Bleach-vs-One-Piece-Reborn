function bvo_anzu_skill_1( keys )
	local caster = keys.caster
	local target = keys.target
	local ability = keys.ability
	local multi = keys.multi
	local int = caster:GetIntellect()
	local percent = ability:GetLevelSpecialValueFor("percent", ability:GetLevel() - 1 ) / 100
	local multiplier = ability:GetLevelSpecialValueFor("multiplier", ability:GetLevel() - 1 )
	local gold_damage = ability:GetLevelSpecialValueFor("gold_damage", ability:GetLevel() - 1 )
	local radius = ability:GetLevelSpecialValueFor("radius", ability:GetLevel() - 1 )
	local aoe_damage_percent = ability:GetLevelSpecialValueFor("aoe_damage_percent", ability:GetLevel() - 1 ) / 100
	
	caster:EmitSound("DOTA_Item.Hand_Of_Midas")
	local particle = ParticleManager:CreateParticle("particles/items2_fx/hand_of_midas.vpcf", PATTACH_ABSORIGIN_FOLLOW, caster)  
	ParticleManager:SetParticleControlEnt(particle, 1, caster, PATTACH_POINT_FOLLOW, "attach_hitloc", caster:GetAbsOrigin(), false)

	local particle2 = ParticleManager:CreateParticle("particles/generic_gameplay/rune_bounty_owner.vpcf", PATTACH_ABSORIGIN_FOLLOW, target)  
	ParticleManager:SetParticleControl(particle2, 0, target:GetAbsOrigin())

	local gold_gain = 0
	if target:IsHero() then
		gold_gain = target:GetGold() * percent

		local damageTable = {
			victim = target,
			attacker = caster,
			damage = gold_gain + multi * int,
			damage_type = DAMAGE_TYPE_PURE,
		}
		ApplyDamage(damageTable)
		SendOverheadEventMessage(nil, OVERHEAD_ALERT_BONUS_POISON_DAMAGE, caster, ApplyDamage(damageTable) , nil)
	else
		gold_gain = target:GetGoldBounty() * multiplier * gold_damage

		local damageTable = {
			victim = target,
			attacker = caster,
			damage = gold_gain + multi * int,
			damage_type = DAMAGE_TYPE_PURE,
		}
		ApplyDamage(damageTable)
		SendOverheadEventMessage(nil, OVERHEAD_ALERT_BONUS_POISON_DAMAGE, caster, ApplyDamage(damageTable) , nil)
	end

	--aoe damage
	local localUnits = FindUnitsInRadius(caster:GetTeamNumber(),
            target:GetAbsOrigin(),
            nil,
            radius,
            DOTA_UNIT_TARGET_TEAM_ENEMY,
            DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,
            DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES,
            FIND_ANY_ORDER,
            false)

	for _,unit in pairs(localUnits) do
		if unit ~= target then
			local damageTable = {
				victim = unit,
				attacker = caster,
				damage = gold_gain * aoe_damage_percent,
				damage_type = DAMAGE_TYPE_PURE,
			}
			ApplyDamage(damageTable)
			SendOverheadEventMessage(nil, OVERHEAD_ALERT_BONUS_POISON_DAMAGE, caster, ApplyDamage(damageTable) , nil)
		end
	end
end