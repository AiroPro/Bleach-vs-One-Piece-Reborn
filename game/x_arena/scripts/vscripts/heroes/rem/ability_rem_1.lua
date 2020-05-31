function bvo_rem_skill_1( keys )
	local caster = keys.caster
	local ability = keys.ability
	local damage = ability:GetLevelSpecialValueFor("damage", ability:GetLevel() - 1 )
	local multiplier = ability:GetLevelSpecialValueFor("str_multi", ability:GetLevel() - 1 )
	local radius = ability:GetLevelSpecialValueFor("radius", ability:GetLevel() - 1 )

	caster:EmitSound("Hero_Spectre.DaggerCast")

	local forward = caster:GetForwardVector()
	--aoe damage
	local localUnits = FindUnitsInRadius(caster:GetTeamNumber(),
            caster:GetAbsOrigin() + forward * 160,
            nil,
            radius,
            DOTA_UNIT_TARGET_TEAM_ENEMY,
            DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,
            DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES,
            FIND_ANY_ORDER,
            false)

	for _,unit in pairs(localUnits) do
		local fxIndex = ParticleManager:CreateParticle( "particles/units/heroes/hero_nyx_assassin/nyx_assassin_vendetta_blood.vpcf", PATTACH_CUSTOMORIGIN, caster )
		ParticleManager:SetParticleControl( fxIndex, 0, caster:GetAbsOrigin() )
		ParticleManager:SetParticleControl( fxIndex, 1, unit:GetAbsOrigin() )
		
		unit:EmitSound("Hero_Bloodseeker.Attack")

		local damageTable = {
			victim = unit,
			attacker = caster,
			damage = damage + caster:GetStrength() * multiplier,
			damage_type = DAMAGE_TYPE_PHYSICAL,
		}
		ApplyDamage(damageTable)
		SendOverheadEventMessage(nil, OVERHEAD_ALERT_BONUS_POISON_DAMAGE, caster, ApplyDamage(damageTable) , nil)
	end
end