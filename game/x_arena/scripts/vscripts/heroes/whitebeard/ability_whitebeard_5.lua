function bvo_whitebeard_skill_5(keys)
	local caster = keys.caster
	caster:StartGestureWithPlaybackRate(ACT_DOTA_CAST_ABILITY_2, 1.8)
end

function bvo_whitebeard_skill_5_damage(keys)
	local caster = keys.caster
	local target = keys.target
	local ability = keys.ability
	local multi = ability:GetLevelSpecialValueFor("str_multi", ability:GetLevel() - 1 )

	local damageTable = {
		victim = target,
		attacker = caster,
		damage = ( caster:GetStrength() * multi ),
		damage_type = DAMAGE_TYPE_PURE,
	}
	ApplyDamage(damageTable)
	SendOverheadEventMessage(nil, OVERHEAD_ALERT_BONUS_POISON_DAMAGE, caster, ApplyDamage(damageTable) , nil)

	local particle = ParticleManager:CreateParticle("particles/custom/whitebeard/whitebeard_skill_5_hitcrack.vpcf", PATTACH_WORLDORIGIN, caster)
	ParticleManager:SetParticleControl(particle, 0, target:GetAbsOrigin())
end