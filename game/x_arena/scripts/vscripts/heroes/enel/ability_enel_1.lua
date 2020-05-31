require('timers')

function bvo_enel_skill_1( keys )
	local caster = keys.caster
	local point = keys.target_points[1]
	local ability = keys.ability
	local bolt_amount = ability:GetLevelSpecialValueFor("bolt_amount", ability:GetLevel() - 1 )
	local radius = ability:GetLevelSpecialValueFor("radius", ability:GetLevel() - 1 )
	local offset = ability:GetLevelSpecialValueFor("offset", ability:GetLevel() - 1 )
	local interval = ability:GetLevelSpecialValueFor("interval", ability:GetLevel() - 1 )
	local damage = ability:GetLevelSpecialValueFor("damage", ability:GetLevel() - 1 )
	local int_multi = ability:GetLevelSpecialValueFor("int_multi", ability:GetLevel() - 1 )

	local forward = caster:GetForwardVector()
	for i = 0, bolt_amount do
		Timers:CreateTimer(interval * i, function ()
			local castPoint = point + ( forward * ( i * offset ) )
			castPoint = GetGroundPosition( castPoint, nil )

			local dummy = CreateUnitByName("npc_dummy_unit", castPoint, false, nil, nil, caster:GetTeam())
			dummy:AddAbility("custom_point_dummy")
			local abl = dummy:FindAbilityByName("custom_point_dummy")
			if abl ~= nil then abl:SetLevel(1) end
			dummy:EmitSound("Hero_Zuus.LightningBolt")
			Timers:CreateTimer(3.0, function ()
				dummy:RemoveSelf()
			end)

			local particleName = "particles/custom/enel/bvo_enel_skill_1_zeus_arcana_thundergods_wrath_start.vpcf"
			local particle = ParticleManager:CreateParticle(particleName, PATTACH_CUSTOMORIGIN, dummy)
			ParticleManager:SetParticleControl(particle , 0, castPoint)
			ParticleManager:SetParticleControl(particle , 1, castPoint)
			ParticleManager:SetParticleControl(particle , 2, castPoint)

			local localUnits = FindUnitsInRadius(caster:GetTeamNumber(),
			            castPoint,
			            nil,
			            radius,
			            DOTA_UNIT_TARGET_TEAM_ENEMY,
			            DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,
			            DOTA_UNIT_TARGET_FLAG_NONE,
			            FIND_ANY_ORDER,
			            false)

			for _,unit in pairs(localUnits) do
				local damageTable = {
					victim = unit,
					attacker = caster,
					damage = caster:GetIntellect() * int_multi + damage,
					damage_type = DAMAGE_TYPE_MAGICAL,
				}
				ApplyDamage(damageTable)
				SendOverheadEventMessage(nil, OVERHEAD_ALERT_BONUS_POISON_DAMAGE, caster, ApplyDamage(damageTable) , nil)
			end
		end)
	end
end

function enel_skill_1(keys)
	local caster = keys.caster
	local target = keys.target

	local c_int = caster:GetIntellect()

	local p_dmg = 150 + (c_int * 2)

	local damageTable = {
		victim = target,
		attacker = caster,
		damage = p_dmg,
		damage_type = DAMAGE_TYPE_MAGICAL,
	}

	ApplyDamage(damageTable)
	SendOverheadEventMessage(nil, OVERHEAD_ALERT_BONUS_POISON_DAMAGE, caster, ApplyDamage(damageTable) , nil)
end

function enel_skill_1_extra(keys)
	local caster = keys.caster
	local casterPos = caster:GetAbsOrigin()
	local point = keys.target_points[1]
	local amount = keys.Bolts

	local particleName = "particles/econ/items/zeus/arcana_chariot/zeus_arcana_thundergods_wrath_start.vpcf"
	local particle = ParticleManager:CreateParticle(particleName, PATTACH_CUSTOMORIGIN, caster)
	ParticleManager:SetParticleControl(particle , 0, point)
	ParticleManager:SetParticleControl(particle , 1, point)
	ParticleManager:SetParticleControl(particle , 2, point)

	Timers:CreateTimer(0.3, function()
		skill_1_extra_chain_effect(amount, point, caster, casterPos)
		skill_1_extra_chain(amount, point, caster, casterPos)

		local dummy = CreateUnitByName("npc_dummy_unit", point, false, nil, nil, caster:GetTeam())
		dummy:AddAbility("custom_point_dummy")
		local abl = dummy:FindAbilityByName("custom_point_dummy")
		if abl ~= nil then abl:SetLevel(1) end
		dummy:EmitSound("Hero_Zuus.LightningBolt")
		Timers:CreateTimer(3.0, function ()
			dummy:RemoveSelf()
		end)
	end)
end

function skill_1_extra_chain(amount, point, caster, pos)
	if amount > 0 then
		amount = amount - 1
		local origin = pos + (point - pos)
		local abl = caster:FindAbilityByName("bvo_enel_skill_1_extra")
		local range = caster:FindAbilityByName("bvo_enel_skill_1"):GetLevel() - 1
		local point_cast = origin + ((point - pos):Normalized() * (64 * (range - amount)))
		local caster_teamNo = caster:GetTeamNumber()

		Timers:CreateTimer(0.3, function()
			caster:CastAbilityOnPosition(point_cast, abl, caster_teamNo)
			skill_1_extra_chain(amount, point, caster, pos)
		end)
	end
end

function skill_1_extra_chain_effect(amount, point, caster, pos)
	if amount > 0 then
		amount = amount - 1
		local origin = pos + (point - pos)
		local range = caster:FindAbilityByName("bvo_enel_skill_1"):GetLevel() - 1
		local point_cast = origin + ((point - pos):Normalized() * (64 * (range - amount)))

		local particleName = "particles/econ/items/zeus/arcana_chariot/zeus_arcana_thundergods_wrath_start.vpcf"
		local particle = ParticleManager:CreateParticle(particleName, PATTACH_CUSTOMORIGIN, caster)
		ParticleManager:SetParticleControl(particle , 0, point_cast)
		ParticleManager:SetParticleControl(particle , 1, point_cast)
		ParticleManager:SetParticleControl(particle , 2, point_cast)

		Timers:CreateTimer(0.3, function()
			skill_1_extra_chain_effect(amount, point, caster, pos)

			local dummy = CreateUnitByName("npc_dummy_unit", point_cast, false, nil, nil, caster:GetTeam())
			dummy:AddAbility("custom_point_dummy")
			local abl = dummy:FindAbilityByName("custom_point_dummy")
			if abl ~= nil then abl:SetLevel(1) end
			dummy:EmitSound("Hero_Zuus.LightningBolt")
			Timers:CreateTimer(3.0, function ()
				dummy:RemoveSelf()
			end)
		end)
	end
end