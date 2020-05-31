require('timers')

function item_soul_devourer_stone(keys)
	local caster = keys.caster
	local target = keys.target
	local ability = keys.ability
	local damage = ability:GetLevelSpecialValueFor("base_damage", ability:GetLevel() - 1 )
	local jumps = ability:GetLevelSpecialValueFor("jumps", ability:GetLevel() - 1 )
	local percent = ability:GetLevelSpecialValueFor("percent_damage_increase", ability:GetLevel() - 1 )
	local leap_radius = ability:GetLevelSpecialValueFor("leap_radius", ability:GetLevel() - 1 )

	local percent = 1 + ( percent / 100 )

	local hit_units = {}
	table.insert(hit_units, target)
	
	local damageTable = {
		victim = target,
		attacker = caster,
		damage = damage,
		damage_type = DAMAGE_TYPE_MAGICAL,
	}

	ApplyDamage(damageTable)

	local particleName = "particles/units/heroes/hero_lion/lion_spell_finger_of_death.vpcf"
	local particle = ParticleManager:CreateParticle(particleName, PATTACH_CUSTOMORIGIN, caster)
	ParticleManager:SetParticleControl(particle, 2, caster:GetAbsOrigin())
	ParticleManager:SetParticleControlEnt(particle, 0, caster, PATTACH_POINT_FOLLOW, "attach_hitloc", caster:GetAbsOrigin(), true)
	ParticleManager:SetParticleControlEnt(particle, 1, target, PATTACH_POINT_FOLLOW, "attach_hitloc", target:GetAbsOrigin(), true)
	caster:EmitSound("Hero_Lion.FingerOfDeath")
	target:EmitSound("Hero_Lion.FingerOfDeathImpact")

	Timers:CreateTimer(0.1, function()
		item_soul_devourer_stone_chain(caster, target, jumps - 1, damage, hit_units, percent, leap_radius)
	end)
end

function item_soul_devourer_stone_chain(caster, target, jumps, damage, hit_units, percent_inc, leap_radius)
	jumps = jumps - 1

	damage = damage * percent_inc
	local localUnits = FindUnitsInRadius(caster:GetTeamNumber(),
	            target:GetAbsOrigin(),
	            nil,
	            leap_radius,
	            DOTA_UNIT_TARGET_TEAM_ENEMY,
	            DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,
	            DOTA_UNIT_TARGET_FLAG_FOW_VISIBLE + DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES,
	            FIND_ANY_ORDER,
	            false)

	if #localUnits > 0 then
		for _,unit in pairs(localUnits) do

			local hit_check = false

			for _,hit in pairs(hit_units) do
				if unit == hit then
					hit_check = true
					break
				end
			end

			if not hit_check then
				local damageTable = {
					victim = unit,
					attacker = caster,
					damage = damage,
					damage_type = DAMAGE_TYPE_MAGICAL,
				}

				ApplyDamage(damageTable)

				local particleName = "particles/units/heroes/hero_lion/lion_spell_finger_of_death.vpcf"
				local particle = ParticleManager:CreateParticle(particleName, PATTACH_CUSTOMORIGIN, caster)
				ParticleManager:SetParticleControl(particle, 2, unit:GetAbsOrigin())
				ParticleManager:SetParticleControlEnt(particle, 0, target, PATTACH_POINT_FOLLOW, "attach_hitloc", target:GetAbsOrigin(), true)
				ParticleManager:SetParticleControlEnt(particle, 1, unit, PATTACH_POINT_FOLLOW, "attach_hitloc", unit:GetAbsOrigin(), true)
				unit:EmitSound("Hero_Lion.FingerOfDeath")
				target:EmitSound("Hero_Lion.FingerOfDeathImpact")
				
				target = unit
				table.insert(hit_units, unit)
				break
			end
		end
	end

	if #localUnits == 1 and localUnits[1] == target then jumps = 0 end

	if jumps > 0 then
		Timers:CreateTimer(0.1, function()
			item_soul_devourer_stone_chain(caster, target, jumps, damage, hit_units, percent_inc, leap_radius)
		end)
	end
end