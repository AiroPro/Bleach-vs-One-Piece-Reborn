require('timers')

function bvo_whitebeard_skill_3(keys)
	local caster = keys.caster
	local target = keys.target
	local ability = keys.ability
	local multi = keys.multi
	local damage = ability:GetLevelSpecialValueFor("damage", ability:GetLevel() - 1 ) / 100

	local damageTable = {
		victim = target,
		attacker = caster,
		damage = ( target:GetMaxHealth() * damage ) * multi,
		damage_type = DAMAGE_TYPE_PHYSICAL,
	}
	ApplyDamage(damageTable)
	SendOverheadEventMessage(nil, OVERHEAD_ALERT_BONUS_POISON_DAMAGE, caster, ApplyDamage(damageTable) , nil)

	ability.playSoundC = true
	ability.playSoundH = true
end

function bvo_whitebeard_skill_3_stun(keys)
	local caster = keys.caster
	local target = keys.target
	local ability = keys.ability
	local stun_duration = ability:GetLevelSpecialValueFor("stun_duration", ability:GetLevel() - 1 )

	if ability.playSoundC == nil then ability.playSoundC = true end
	if ability.playSoundH == nil then ability.playSoundH = true end
	local casterPos = caster:GetAbsOrigin()

	if target:IsHero() then
		ability:ApplyDataDrivenModifier(caster, target, "bvo_whitebeard_skill_3_hero_modifier", {duration=stun_duration / 2})
		if ability.playSoundH then
			ability.playSoundH = false

			Timers:CreateTimer(stun_duration / 2, function ()
				local dummy = CreateUnitByName("npc_dummy_unit", casterPos, false, nil, nil, caster:GetTeam())
				dummy:AddAbility("custom_point_dummy")
				local abl = dummy:FindAbilityByName("custom_point_dummy")
				if abl ~= nil then abl:SetLevel(1) end
				dummy:EmitSound("Hero_Centaur.HoofStomp")
				Timers:CreateTimer(3.0, function ()
					dummy:RemoveSelf()
				end)
			end)
		end
	else
		ability:ApplyDataDrivenModifier(caster, target, "bvo_whitebeard_skill_3_creep_modifier", {duration=stun_duration})
		if ability.playSoundC then
			ability.playSoundC = false

			Timers:CreateTimer(stun_duration, function ()
				local dummy = CreateUnitByName("npc_dummy_unit", casterPos, false, nil, nil, caster:GetTeam())
				dummy:AddAbility("custom_point_dummy")
				local abl = dummy:FindAbilityByName("custom_point_dummy")
				if abl ~= nil then abl:SetLevel(1) end
				dummy:EmitSound("Hero_Centaur.HoofStomp")
				Timers:CreateTimer(3.0, function ()
					dummy:RemoveSelf()
				end)
			end)
		end
	end
end

function bvo_whitebeard_skill_3_effect(keys)
	local caster = keys.caster

	local particle = ParticleManager:CreateParticle("particles/custom/whitebeard/whitebeard_skill_3.vpcf", PATTACH_WORLDORIGIN, caster)
	ParticleManager:SetParticleControl(particle, 0, caster:GetAbsOrigin())
	Timers:CreateTimer(1.5, function ()
		ParticleManager:DestroyParticle(particle, false)
	end)
end