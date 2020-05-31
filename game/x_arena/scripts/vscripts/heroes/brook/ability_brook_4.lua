require('timers')

function bvo_brook_skill_4(keys)
	local caster = keys.caster
	local ability = keys.ability
	local delay = ability:GetLevelSpecialValueFor("delay", ability:GetLevel() - 1 )

	caster.brook_skill_4_origin = caster:GetAbsOrigin()
	caster.brook_skill_4_point = keys.target_points[1]
	caster.brook_skill_4_forward = caster:GetForwardVector()

	ability:ApplyDataDrivenModifier(caster, caster, "bvo_brook_skill_4_caster", {duration=delay})

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

function bvo_brook_skill_4_cast(keys)
	local caster = keys.caster
	local ability = keys.ability
	local point = caster.brook_skill_4_point
	local multi = ability:GetLevelSpecialValueFor("agi_multi", ability:GetLevel() - 1 )
	local damage = ability:GetLevelSpecialValueFor("damage", ability:GetLevel() - 1 )
	local radius = ability:GetLevelSpecialValueFor("radius", ability:GetLevel() - 1 )

	local offset = 0
	local endPoint = point + ( caster.brook_skill_4_forward * (radius / 2) ) - caster.brook_skill_4_forward * offset
	while not GridNav:CanFindPath(caster.brook_skill_4_origin, endPoint) do
		offset = offset + 8
		endPoint = point + ( caster.brook_skill_4_forward * (radius / 2) ) - caster.brook_skill_4_forward * offset
	end
	FindClearSpaceForUnit(caster, endPoint, false)
	caster:RemoveNoDraw()
	caster:EmitSound("Hero_Beastmaster.Attack")
	caster:StartGestureWithPlaybackRate(ACT_DOTA_ATTACK2, 2.5)

	local localUnits = FindUnitsInRadius(caster:GetTeamNumber(),
            point,
            nil,
            radius,
            DOTA_UNIT_TARGET_TEAM_ENEMY,
            DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,
            DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES,
            FIND_ANY_ORDER,
            false)

	for _,unit in pairs(localUnits) do
		local fxIndex = ParticleManager:CreateParticle( "particles/units/heroes/hero_nyx_assassin/nyx_assassin_vendetta_blood.vpcf", PATTACH_CUSTOMORIGIN, caster )
		ParticleManager:SetParticleControl( fxIndex, 0, caster:GetAbsOrigin() )
		ParticleManager:SetParticleControl( fxIndex, 1, unit:GetAbsOrigin() )

		unit:EmitSound("Hero_PhantomAssassin.CoupDeGrace.Arcana")

		local damageTable = {
			victim = unit,
			attacker = caster,
			damage = caster:GetAgility() * multi + damage,
			damage_type = DAMAGE_TYPE_PHYSICAL,
		}
		ApplyDamage(damageTable)
		SendOverheadEventMessage(nil, OVERHEAD_ALERT_BONUS_POISON_DAMAGE, caster, ApplyDamage(damageTable) , nil)
	end
end