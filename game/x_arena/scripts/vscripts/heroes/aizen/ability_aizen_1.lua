function bvo_aizen_skill_1_damage(keys)
	local caster = keys.caster
	local target = keys.target
	local ability = keys.ability
	local damage = ability:GetLevelSpecialValueFor("damage", (ability:GetLevel() - 1))
	local multi = ability:GetLevelSpecialValueFor("agi_multi", (ability:GetLevel() - 1))

	local damageTable = {
		victim = target,
		attacker = caster,
		damage = damage + ( caster:GetAgility() * multi ),
		damage_type = DAMAGE_TYPE_MAGICAL,
	}
	ApplyDamage(damageTable)
	SendOverheadEventMessage(nil, OVERHEAD_ALERT_BONUS_POISON_DAMAGE, caster, ApplyDamage(damageTable) , nil)
end