require('timers')

function bvo_rory_skill_5(keys)
	local caster = keys.caster
	local target = keys.target
	local ability = keys.ability
	local agi_as_damage_per_stack = ability:GetLevelSpecialValueFor("agi_as_damage_per_stack", ability:GetLevel() - 1 )
	local raw_damage_per_stack = ability:GetLevelSpecialValueFor("raw_damage_per_stack", ability:GetLevel() - 1 )
	local base_damage = ability:GetLevelSpecialValueFor("base_damage", ability:GetLevel() - 1 )

	caster:StartGestureWithPlaybackRate(ACT_DOTA_CAST_ABILITY_3, 1.0)

	local dur = 1.0

	ability:ApplyDataDrivenModifier(caster, target, "bvo_rory_skill_5_modifier_enemy", {duration=dur})
	ability:ApplyDataDrivenModifier(caster, caster, "bvo_rory_skill_5_modifier", {duration=dur})

	caster:Stop()
	target:Stop()

	Timers:CreateTimer(dur, function()
		caster:RemoveModifierByName("bvo_rory_skill_5_modifier")
		target:RemoveModifierByName("bvo_rory_skill_5_modifier_enemy")

		local all_stacks = caster:GetModifierStackCount( "bvo_rory_skill_0_buff_modifier", ability )
		caster:RemoveModifierByName("bvo_rory_skill_0_buff_modifier")

		target:EmitSound("Hero_Leshrac.Split_Earth")
		local particle = ParticleManager:CreateParticle("particles/units/heroes/hero_leshrac/leshrac_split_earth.vpcf", PATTACH_WORLDORIGIN, caster)
		ParticleManager:SetParticleControl(particle, 0, target:GetAbsOrigin())
		ParticleManager:SetParticleControl(particle, 1, Vector(600, 600, 600))

		local particle2 = ParticleManager:CreateParticle("particles/units/heroes/hero_centaur/centaur_warstomp.vpcf", PATTACH_ABSORIGIN_FOLLOW, target)
		ParticleManager:SetParticleControl(particle2, 1, Vector(600, 0, 600))
		target:EmitSound("Hero_Brewmaster.ThunderClap")

		local damageTable = {
			victim = target,
			attacker = caster,
			damage = base_damage + ( caster:GetAgility() * agi_as_damage_per_stack * all_stacks ) + ( raw_damage_per_stack * all_stacks ),
			damage_type = DAMAGE_TYPE_PURE,
		}
		ApplyDamage(damageTable)
		SendOverheadEventMessage(nil, OVERHEAD_ALERT_BONUS_POISON_DAMAGE, caster, ApplyDamage(damageTable) , nil)

		ability:ApplyDataDrivenModifier(caster, target, "bvo_rory_skill_5_stun_modifier", {duration=1.0})
	end)
end