require('timers')

function bvo_mihawk_skill_5(keys)
	local caster = keys.caster
	local target = keys.target
	local ability = keys.ability
	local multi = ability:GetLevelSpecialValueFor("str_multi", ability:GetLevel() - 1 )

	local targetPos = target:GetAbsOrigin()
	caster:StartGestureWithPlaybackRate(ACT_DOTA_CAST_ABILITY_4, 1.0)

	ability:ApplyDataDrivenModifier(caster, target, "bvo_mihawk_skill_5_modifier_enemy", {duration=1.5})
	ability:ApplyDataDrivenModifier(caster, caster, "bvo_mihawk_skill_5_modifier", {duration=1.5})

	caster:Stop()
	target:Stop()

	local dummys = {}

	Timers:CreateTimer(0.5, function()
		for i = 0, 7 do
	    	local rotation = QAngle( 0, 45 * i, 0 )
			local rot_vector = RotatePosition(targetPos, rotation, targetPos + Vector(0, 160, 0))

			local dummy = CreateUnitByName("npc_dummy_unit", rot_vector, false, caster, caster, caster:GetTeamNumber())
			dummy:AddAbility("custom_point_dummy")
			local abl = dummy:FindAbilityByName("custom_point_dummy")
			if abl ~= nil then abl:SetLevel(1) end

			dummy:SetOriginalModel("models/hero_mihawk2/hero_mihawk2_base.vmdl")
			dummy:SetModel("models/hero_mihawk2/hero_mihawk2_base.vmdl")
			dummy:SetModelScale(1.2)
			local diff = dummy:GetAbsOrigin() - targetPos
			dummy:SetForwardVector(-diff)
			dummy:StartGestureWithPlaybackRate(ACT_DOTA_ATTACK, 0.6)

			table.insert(dummys, dummy)
		end
	end)

	Timers:CreateTimer(1.5, function()
		for _,dummy in pairs(dummys) do
			dummy:RemoveSelf()
		end

		FindClearSpaceForUnit(caster, targetPos + caster:GetForwardVector() * 180, false)
		ProjectileManager:ProjectileDodge(caster)
		
		caster:EmitSound("Hero_Antimage.Attack")
		local fxIndex = ParticleManager:CreateParticle( "particles/units/heroes/hero_nyx_assassin/nyx_assassin_vendetta_blood.vpcf", PATTACH_CUSTOMORIGIN, caster )
		local str = caster:GetStrength()
		ParticleManager:SetParticleControl( fxIndex, 0, caster:GetAbsOrigin() )
		ParticleManager:SetParticleControl( fxIndex, 1, target:GetAbsOrigin() )

		caster:RemoveModifierByName("bvo_mihawk_skill_5_modifier") 
		target:RemoveModifierByName("bvo_mihawk_skill_5_modifier_enemy")
		caster:MoveToTargetToAttack(target)
		local damageTable = {
			victim = target,
			attacker = caster,
			damage = 2000 + (str * multi),
			damage_type = DAMAGE_TYPE_PHYSICAL,
		}
		ApplyDamage(damageTable)
		SendOverheadEventMessage(nil, OVERHEAD_ALERT_BONUS_POISON_DAMAGE, caster, ApplyDamage(damageTable) , nil)
	end)
end