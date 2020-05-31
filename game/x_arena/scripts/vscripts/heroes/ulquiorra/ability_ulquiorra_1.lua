require('timers')

function bvo_ulquiorra_skill_1(keys)
	local caster = keys.caster
	local ability = keys.ability
	local point = keys.target_points[1]
	local radius = ability:GetLevelSpecialValueFor("radius", (ability:GetLevel() - 1))

	local dummy = CreateUnitByName("npc_dummy_unit", point, false, caster, caster, caster:GetTeamNumber())
	dummy:AddAbility("custom_point_dummy")
	local abl = dummy:FindAbilityByName("custom_point_dummy")
	if abl ~= nil then abl:SetLevel(1) end

	dummy:EmitSound("Hero_EmberSpirit.FireRemnant.Explode")

	Timers:CreateTimer(3.0, function ()
		dummy:RemoveSelf()
	end)

	local particleName = "particles/custom/ulquiorra/ulquiorra_skill_1.vpcf"
	local particle = ParticleManager:CreateParticle(particleName, PATTACH_CUSTOMORIGIN, dummy)
	ParticleManager:SetParticleControl( particle, 0, point )
	ParticleManager:SetParticleControl( particle, 1, Vector(radius, 0, 0) )
	ParticleManager:SetParticleControl( particle, 2, Vector(radius, 0, 0) )
	ParticleManager:SetParticleControl( particle, 3, Vector(radius, 0, 0) )
end


function bvo_ulquiorra_skill_1_dmg(keys)
	local caster = keys.caster
	local target = keys.target
	local ability = keys.ability
	local multi = keys.multi
	local agi = caster:GetAgility()

	local damageTable = {
		victim = target,
		attacker = caster,
		damage = multi * agi,
		damage_type = DAMAGE_TYPE_PHYSICAL,
	}

	ApplyDamage(damageTable)
	SendOverheadEventMessage(nil, OVERHEAD_ALERT_BONUS_POISON_DAMAGE, caster, ApplyDamage(damageTable) , nil)
end