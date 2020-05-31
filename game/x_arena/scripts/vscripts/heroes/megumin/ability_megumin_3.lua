require('timers')

function bvo_megumin_skill_3( keys )
	keys.ability.target_cast_point = keys.target_points[1]

	bvo_megumin_skill_4_refresh( keys.ability, keys.caster )
end

function bvo_megumin_skill_3_cast( keys )
	local caster = keys.caster
	local ability = keys.ability
	local point = ability.target_cast_point
	local radius = ability:GetLevelSpecialValueFor("radius", ability:GetLevel() - 1 )
	local damage = ability:GetLevelSpecialValueFor("damage", ability:GetLevel() - 1 )
	local multi = ability:GetLevelSpecialValueFor("int_multi", ability:GetLevel() - 1 )
	local target_radius = ability:GetLevelSpecialValueFor("target_radius", ability:GetLevel() - 1 )

	local max_offset = target_radius - radius
	local _x = RandomInt(-max_offset, max_offset)
	local _y = RandomInt(-max_offset, max_offset)

	point = point + Vector(_x, _y, 0)

	local particle = ParticleManager:CreateParticle("particles/econ/items/invoker/invoker_apex/invoker_sun_strike_immortal1.vpcf", PATTACH_WORLDORIGIN, caster)
	ParticleManager:SetParticleControl(particle, 0, point)
	ParticleManager:SetParticleControl(particle, 1, Vector(radius, radius, radius))

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
			damage = damage + caster:GetIntellect() * multi,
			damage_type = DAMAGE_TYPE_MAGICAL,
		}
		ApplyDamage(damageTable)
		SendOverheadEventMessage(nil, OVERHEAD_ALERT_BONUS_POISON_DAMAGE, caster, ApplyDamage(damageTable) , nil)
		ability:ApplyDataDrivenModifier(caster, unit, "bvo_megumin_skill_1_modifier", {duration=0.1})
	end

	local dummy = CreateUnitByName("npc_dummy_unit", point, false, nil, nil, caster:GetTeam())
	dummy:AddAbility("custom_point_dummy")
	local abl = dummy:FindAbilityByName("custom_point_dummy")
	if abl ~= nil then abl:SetLevel(1) end
	dummy:EmitSound("Hero_Invoker.SunStrike.Ignite.Apex")
	Timers:CreateTimer(3.0, function ()
		dummy:RemoveSelf()
	end)
end

function bvo_megumin_skill_3_interval( keys )
	local caster = keys.caster
	local ability = keys.ability
	local blasts = ability:GetLevelSpecialValueFor("blasts", ability:GetLevel() - 1 )

	local intervals = 4 / blasts

	Timers:CreateTimer(intervals + 0.1, function ()
		if not caster:HasModifier("bvo_megumin_skill_3_channel_modifier") then return nil end

		bvo_megumin_skill_3_cast( keys )

		return intervals
	end)
end

function bvo_megumin_skill_4_refresh( ability, caster )
	if caster:HasModifier("bvo_megumin_skill_4_modifier") then
		caster:RemoveModifierByName("bvo_megumin_skill_4_modifier")
		ability:EndCooldown()
	end
end