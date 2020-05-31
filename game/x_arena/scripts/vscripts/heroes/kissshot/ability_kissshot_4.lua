function bvo_kissshot_skill_4( keys )
	local caster = keys.caster
	local ability = keys.ability
	local point = keys.target_points[1]

	local damage = ability:GetLevelSpecialValueFor( "damage", ability:GetLevel() - 1 )
	local str_multi = ability:GetLevelSpecialValueFor( "str_multi", ability:GetLevel() - 1 )
	local aoe = ability:GetLevelSpecialValueFor( "aoe", ability:GetLevel() - 1 )
	local stun_duration = ability:GetLevelSpecialValueFor( "stun_duration", ability:GetLevel() - 1 )

	local localUnits = FindUnitsInRadius(caster:GetTeamNumber(),
			            point,
			            nil,
			            aoe,
			            DOTA_UNIT_TARGET_TEAM_ENEMY,
			            DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,
			            DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES,
			            FIND_ANY_ORDER,
			            false)

	for _,unit in pairs(localUnits) do
		ability:ApplyDataDrivenModifier(caster, unit, "bvo_kissshot_skill_4_stun", {duration=stun_duration})
		
		local damageTable = {
			victim = unit,
			attacker = caster,
			damage = ( caster:GetStrength() * str_multi ) + damage,
			damage_type = DAMAGE_TYPE_PURE,
		}
		ApplyDamage(damageTable)
		SendOverheadEventMessage(nil, OVERHEAD_ALERT_BONUS_POISON_DAMAGE, caster, ApplyDamage(damageTable) , nil)
	end
end