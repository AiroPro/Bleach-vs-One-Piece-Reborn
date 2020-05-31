require('timers')

function bvo_brook_skill_5(keys)
	local caster = keys.caster
	local target = keys.target
	local ability = keys.ability
	local delay = ability:GetLevelSpecialValueFor("delay", ability:GetLevel() - 1 )

	caster.brook_skill_5_origin = caster:GetAbsOrigin()
	caster.brook_skill_5_point = target:GetAbsOrigin()
	caster.brook_skill_5_forward = caster:GetForwardVector()

	local max_runs = (delay / 2) / 0.03
	local runs = 0
	Timers:CreateTimer(0.03, function ()
		if runs < max_runs then
			runs = runs + 1
			caster:SetAbsOrigin( caster:GetAbsOrigin() - caster:GetForwardVector() * 4 )
			return 0.03
		end
		caster:AddNoDraw()
		return nil
	end)
end

function bvo_brook_skill_5_end(keys)
	local caster = keys.caster
	local ability = keys.ability
	local point = caster.brook_skill_5_point
	local delay = ability:GetLevelSpecialValueFor("delay", ability:GetLevel() - 1 )

	local offset = 0
	local endPoint = point + ( caster.brook_skill_5_forward * 128 ) - caster.brook_skill_5_forward * offset
	while not GridNav:CanFindPath(caster.brook_skill_5_origin, endPoint) do
		offset = offset + 8
		endPoint = point + ( caster.brook_skill_4_forward * 128 ) - caster.brook_skill_5_forward * offset
	end
	FindClearSpaceForUnit(caster, endPoint, false)
	caster:RemoveNoDraw()
	caster:EmitSound("Hero_Beastmaster.Attack")
	caster:StartGestureWithPlaybackRate(ACT_DOTA_ATTACK2, 3.0)

	local max_runs = (delay / 2) / 0.03
	local runs = 0
	Timers:CreateTimer(0.03, function ()
		if runs < max_runs then
			runs = runs + 1
			caster:SetAbsOrigin( caster:GetAbsOrigin() + caster:GetForwardVector() * 4 )
			return 0.03
		end
		return nil
	end)
end

function bvo_brook_skill_5_damage(keys)
	local caster = keys.caster
	local ability = keys.ability
	local target = keys.target
	local damage = ability:GetLevelSpecialValueFor("damage", ability:GetLevel() - 1 )
	local multi = ability:GetLevelSpecialValueFor("agi_multi", ability:GetLevel() - 1 )

	local damageTable = {
		victim = target,
		attacker = caster,
		damage = caster:GetAgility() * multi + damage,
		damage_type = DAMAGE_TYPE_PHYSICAL,
	}
	ApplyDamage(damageTable)
	SendOverheadEventMessage(nil, OVERHEAD_ALERT_BONUS_POISON_DAMAGE, caster, ApplyDamage(damageTable) , nil)
end