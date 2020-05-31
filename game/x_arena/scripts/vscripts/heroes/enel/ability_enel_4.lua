function bvo_enel_skill_4_melee(keys)
	local caster = keys.caster
	local attacker = keys.attacker
	local ability = keys.ability
	local int_multi = ability:GetLevelSpecialValueFor("int_multi", ability:GetLevel() - 1 )

	local damageTable = {
		victim = attacker,
		attacker = caster,
		damage = caster:GetIntellect() * int_multi,
		damage_type = DAMAGE_TYPE_PURE,
	}

	ApplyDamage(damageTable)
	
	
	local particleName = "particles/econ/items/sven/sven_warcry_ti5/sven_warcry_cast_arc_lightning.vpcf"
	ParticleManager:CreateParticle(particleName, PATTACH_ABSORIGIN, attacker)
	attacker:EmitSound("Hero_Zuus.ArcLightning.Cast")
	SendOverheadEventMessage(nil, OVERHEAD_ALERT_BONUS_POISON_DAMAGE, caster, ApplyDamage(damageTable) , nil)
end

function bvo_enel_skill_4_cast(keys)
	local caster = keys.caster
	local target = keys.unit
	local caster_ability = keys.event_ability
	local ability = keys.ability
	local int_multi = ability:GetLevelSpecialValueFor("int_multi", ability:GetLevel() - 1 )

	if caster_ability == nil or caster_ability:IsItem() or caster_ability:IsPassive() then return end

	local damageTable = {
		victim = target,
		attacker = caster,
		damage = caster:GetIntellect() * int_multi,
		damage_type = DAMAGE_TYPE_PURE,
	}

	ApplyDamage(damageTable)

	local particleName = "particles/econ/items/sven/sven_warcry_ti5/sven_warcry_cast_arc_lightning.vpcf"
	ParticleManager:CreateParticle(particleName, PATTACH_ABSORIGIN, target)
	target:EmitSound("Hero_Zuus.ArcLightning.Cast")
	SendOverheadEventMessage(nil, OVERHEAD_ALERT_BONUS_POISON_DAMAGE, caster, ApplyDamage(damageTable) , nil)
end

function bvo_enel_skill_4_apply(keys)
	local caster = keys.caster
	local ability = keys.ability
	local radius = ability:GetLevelSpecialValueFor("radius", ability:GetLevel() - 1 )

	local localUnits = FindUnitsInRadius(caster:GetTeamNumber(),
	            caster:GetAbsOrigin(),
	            nil,
	            radius,
	            DOTA_UNIT_TARGET_TEAM_ENEMY,
	            DOTA_UNIT_TARGET_HERO,
	            DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES,
	            FIND_ANY_ORDER,
	            false)

	for _,unit in pairs(localUnits) do
		ability:ApplyDataDrivenModifier(caster, unit, "bvo_enel_skill_4_debuff_modifier", {duration=1.0} )
	end
end