require('timers')

function bvo_whitebeard_skill_4(keys)
	local caster = keys.caster
	local target = keys.target
	local ability = keys.ability
	local multi = ability:GetLevelSpecialValueFor("str_multi", ability:GetLevel() - 1 )

	local damageTable = {
		victim = target,
		attacker = caster,
		damage = ( caster:GetStrength() * multi ),
		damage_type = DAMAGE_TYPE_MAGICAL,
	}
	ApplyDamage(damageTable)
	SendOverheadEventMessage(nil, OVERHEAD_ALERT_BONUS_POISON_DAMAGE, caster, ApplyDamage(damageTable) , nil)
end

function bvo_whitebeard_skill_4_effect(keys)
	local caster = keys.caster
	local ability = keys.ability
	local duration = ability:GetLevelSpecialValueFor("stun_duration", ability:GetLevel() - 1 )
	local radius = ability:GetLevelSpecialValueFor("radius", ability:GetLevel() - 1 )

	local particle = ParticleManager:CreateParticle("particles/custom/whitebeard_skill_4.vpcf", PATTACH_WORLDORIGIN, caster)
	ParticleManager:SetParticleControl(particle, 0, caster:GetAbsOrigin())
	ParticleManager:SetParticleControl(particle, 1, Vector(radius, radius, radius))
	Timers:CreateTimer(duration, function ()
		ParticleManager:DestroyParticle(particle, false)
	end)

	local particle2 = ParticleManager:CreateParticle("particles/units/heroes/hero_leshrac/leshrac_split_earth.vpcf", PATTACH_WORLDORIGIN, caster)
	ParticleManager:SetParticleControl(particle2, 0, caster:GetAbsOrigin())
	ParticleManager:SetParticleControl(particle2, 1, Vector(radius, radius, radius))
end