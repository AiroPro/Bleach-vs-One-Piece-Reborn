require('timers')

function bvo_orihime_skill_1(keys)
	local caster = keys.caster
	local point = keys.target_points[1]

	local casterPos = caster:GetAbsOrigin()
	local front = caster:GetForwardVector()

	for i = 1, 10 do
		Timers:CreateTimer(0.075 * i, function()

			local forward = casterPos + front * 100 * i
			local dummy = CreateUnitByName("npc_dummy_unit", forward, false, nil, nil, caster:GetTeam())

			dummy:AddAbility("custom_point_dummy")

			local abl = dummy:FindAbilityByName("custom_point_dummy")
			if abl ~= nil then abl:SetLevel(1) end

			local particleName = ""
			ParticleManager:CreateParticle(particleName, PATTACH_ABSORIGIN, dummy)

			Timers:CreateTimer(3.0, function()
				UTIL_Remove(dummy)
			end)

		end)
	end
end

function bvo_orihime_skill_1_damage(keys)
    local caster = keys.caster
    local target = keys.target
    local multi = keys.multi


	local int = caster:GetIntellect()

	local damageTable = {
		victim = target,
		attacker = caster,
		damage = int * multi,
		damage_type = DAMAGE_TYPE_MAGICAL,
	}

	ApplyDamage(damageTable)
	SendOverheadEventMessage(nil, OVERHEAD_ALERT_BONUS_POISON_DAMAGE, caster, ApplyDamage(damageTable) , nil)
end

function bvo_ace_skill_1_damage(keys)
    local caster = keys.caster
    local target = keys.target
    local multi = keys.multi


	local agi = caster:GetAgility()

	local damageTable = {
		victim = target,
		attacker = caster,
		damage = agi * multi,
		damage_type = DAMAGE_TYPE_MAGICAL,
	}

	ApplyDamage(damageTable)
	SendOverheadEventMessage(nil, OVERHEAD_ALERT_BONUS_POISON_DAMAGE, caster, ApplyDamage(damageTable) , nil)
end

function bvo_zoro_skill_1_damage(keys)
    local caster = keys.caster
    local target = keys.target
    local multi = keys.multi

 
	local str = caster:GetStrength()

	local damageTable = {
		victim = target,
		attacker = caster,
		damage = str * multi,
		damage_type = DAMAGE_TYPE_MAGICAL,
	}
	ApplyDamage(damageTable)
	SendOverheadEventMessage(nil, OVERHEAD_ALERT_BONUS_POISON_DAMAGE, caster, ApplyDamage(damageTable) , nil)
end

function bvo_zoro_skill_4_damage(keys)
    local caster = keys.caster
    local target = keys.target
    local multi = keys.multi

 
	local str = caster:GetStrength()

	local damageTable = {
		victim = target,
		attacker = caster,
		damage = str * multi,
		damage_type = DAMAGE_TYPE_MAGICAL,
	}

	ApplyDamage(damageTable)
	SendOverheadEventMessage(nil, OVERHEAD_ALERT_BONUS_POISON_DAMAGE, caster, ApplyDamage(damageTable) , nil)
end

function bvo_megumin_skill_1(keys)
    local caster = keys.caster
    local target = keys.target
    local multi = keys.multi

 
	local Int = caster:GetIntellect()

	local damageTable = {
		victim = target,
		attacker = caster,
		damage = Int * multi,
		damage_type = DAMAGE_TYPE_MAGICAL,
	}

	ApplyDamage(damageTable)
	SendOverheadEventMessage(nil, OVERHEAD_ALERT_BONUS_POISON_DAMAGE, caster, ApplyDamage(damageTable) , nil)
end

function bvo_byakuya__skill_1(keys)
    local caster = keys.caster
    local target = keys.target
    local multi = keys.multi

 
	local agi = caster:GetAgility()

	local damageTable = {
		victim = target,
		attacker = caster,
		damage = agi * multi,
		damage_type = DAMAGE_TYPE_MAGICAL,
	}

	ApplyDamage(damageTable)
	SendOverheadEventMessage(nil, OVERHEAD_ALERT_BONUS_POISON_DAMAGE, caster, ApplyDamage(damageTable) , nil)
end

