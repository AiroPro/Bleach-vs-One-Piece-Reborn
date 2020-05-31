require('timers')

function bvo_enel_skill_5( keys )
	local caster = keys.caster
	local point = keys.target_points[1]
	local ability = keys.ability
	local duration = ability:GetLevelSpecialValueFor("duration", ability:GetLevel() - 1 )
	local radius = ability:GetLevelSpecialValueFor("radius", ability:GetLevel() - 1 )
	local int_multi = ability:GetLevelSpecialValueFor("int_multi", ability:GetLevel() - 1 )

	caster.castPoint5 = point

	local scale = 0

	local particleName = "particles/custom/enel/raigo.vpcf"
	local particle = ParticleManager:CreateParticle(particleName, PATTACH_ABSORIGIN, caster)
	ParticleManager:SetParticleControl(particle, 0, point)

	local sound_dummy = CreateUnitByName("npc_dummy_unit", point, false, nil, nil, caster:GetTeam())
	sound_dummy:AddAbility("custom_point_dummy")
	local abl = sound_dummy:FindAbilityByName("custom_point_dummy")
	if abl ~= nil then abl:SetLevel(1) end

	sound_dummy:EmitSound("Ability.static.loop")
	Timers:CreateTimer(duration - 0.1, function ()
		if caster:IsAlive() and caster:HasModifier("bvo_enel_skill_5_hot_modifier") then
			local localUnits = FindUnitsInRadius(caster:GetTeamNumber(),
		            point,
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
					damage = caster:GetIntellect() * int_multi,
					damage_type = DAMAGE_TYPE_MAGICAL,
				}
				ApplyDamage(damageTable)

				local particleName = "particles/econ/items/sven/sven_warcry_ti5/sven_warcry_cast_arc_lightning.vpcf"
				ParticleManager:CreateParticle(particleName, PATTACH_ABSORIGIN, unit)
				unit:EmitSound("Hero_Zuus.ArcLightning.Cast")
				SendOverheadEventMessage(nil, OVERHEAD_ALERT_BONUS_POISON_DAMAGE, caster, ApplyDamage(damageTable) , nil)
			end

			caster:RemoveModifierByName( "bvo_enel_skill_5_hot_modifier" )
		end
		if not sound_dummy:IsNull() and sound_dummy ~= nil then
			sound_dummy:StopSound("Ability.static.loop")
			sound_dummy:RemoveSelf()
		end
	end)

	caster.dummySkill5 = sound_dummy

	Timers:CreateTimer(0.0, function ()
		if caster.dummySkill5 ~= nil and not caster.dummySkill5:IsNull() then
			scale = scale + 20
			ParticleManager:SetParticleControl(particle, 1, Vector(scale,scale,scale))
			return 0.25
		else
			ParticleManager:DestroyParticle(particle, true)
			return nil
		end
	end)
end

function bvo_enel_skill_5_checkDistance( keys )
	local caster = keys.caster
	local ability = keys.ability
	local point = caster.castPoint5
	local break_distance = ability:GetLevelSpecialValueFor("break_distance", ability:GetLevel() - 1 )

	local distance = ( point - caster:GetAbsOrigin() ):Length2D()
	if distance <= break_distance then
		return
	end

	caster:RemoveModifierByName( "bvo_enel_skill_5_hot_modifier" )
end

function bvo_enel_skill_5_endTether( keys )
	local caster = keys.caster
	local ability = keys.ability

	if caster.dummySkill5 ~= nil and not caster.dummySkill5:IsNull() then
		caster:RemoveModifierByName( "bvo_enel_skill_5_hot_modifier" )
		caster:EmitSound("Hero_Disruptor.StaticStorm.End")
		caster.dummySkill5:StopSound("Ability.static.loop")
		caster.dummySkill5:RemoveSelf()
		caster.dummySkill5 = nil
	end
end