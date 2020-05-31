function bvo_kissshot_skill_5(keys)
	local caster = keys.caster
	local target = keys.target
	local ability = keys.ability
	local chance_to_kill = ability:GetLevelSpecialValueFor( "chance_to_kill", ability:GetLevel() - 1 )
	local str_multi = ability:GetLevelSpecialValueFor( "str_multi", ability:GetLevel() - 1 )

	if caster:GetLevel() > target:GetLevel() then
		local roll = RandomInt(1, 100)
		if roll > chance_to_kill then
			target:Kill(ability, caster)
		else
			local damageTable = {
				victim = target,
				attacker = caster,
				damage = ( caster:GetStrength() * str_multi ),
				damage_type = DAMAGE_TYPE_PHYSICAL,
			}
			ApplyDamage(damageTable)
		end
	else
		local damageTable = {
			victim = target,
			attacker = caster,
			damage = ( caster:GetStrength() * str_multi ),
			damage_type = DAMAGE_TYPE_PHYSICAL,
		}
		ApplyDamage(damageTable)
		SendOverheadEventMessage(nil, OVERHEAD_ALERT_BONUS_POISON_DAMAGE, caster, ApplyDamage(damageTable) , nil)
	end
end