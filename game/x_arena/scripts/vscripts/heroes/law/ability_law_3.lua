function bvo_law_skill_3(keys)
	local caster = keys.caster
	local target = keys.target
	local ability = keys.ability
	local multi = ability:GetLevelSpecialValueFor("hp_damage", ability:GetLevel() - 1 ) / 100
	
	local e_multi = 1.0
	if target:HasModifier("bvo_law_skill_5_modifier") then
		e_multi = 2.0
	end

	local damageTable = {
		victim = target,
		attacker = caster,
		damage = ( target:GetMaxHealth() * multi ) * e_multi,
		damage_type = DAMAGE_TYPE_PURE,
	}
	ApplyDamage(damageTable)
	SendOverheadEventMessage(nil, OVERHEAD_ALERT_BONUS_POISON_DAMAGE, caster, ApplyDamage(damageTable) , nil)
end