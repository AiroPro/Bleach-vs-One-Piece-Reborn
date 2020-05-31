function bvo_rory_skill_4(keys)
	local caster = keys.caster
	local target = keys.target
	local ability = keys.ability
	local duration = ability:GetLevelSpecialValueFor("duration", ability:GetLevel() - 1 )

	caster:EmitSound("Hero_Terrorblade.Sunder.Cast")
	target:EmitSound("Hero_Terrorblade.Sunder.Target")

	-- Show the particle caster-> target
	local particleName = "particles/units/heroes/hero_terrorblade/terrorblade_sunder.vpcf"

	local particle = ParticleManager:CreateParticle( particleName, PATTACH_POINT_FOLLOW, target )
	ParticleManager:SetParticleControlEnt(particle, 0, target, PATTACH_POINT_FOLLOW, "attach_hitloc", target:GetAbsOrigin(), true)
	ParticleManager:SetParticleControlEnt(particle, 1, caster, PATTACH_POINT_FOLLOW, "attach_hitloc", target:GetAbsOrigin(), true)

	local particle2 = ParticleManager:CreateParticle( particleName, PATTACH_POINT_FOLLOW, caster )
	ParticleManager:SetParticleControlEnt(particle2, 0, caster, PATTACH_POINT_FOLLOW, "attach_hitloc", target:GetAbsOrigin(), true)
	ParticleManager:SetParticleControlEnt(particle2, 1, target, PATTACH_POINT_FOLLOW, "attach_hitloc", target:GetAbsOrigin(), true)


	ability:ApplyDataDrivenModifier(caster, caster, "bvo_rory_skill_4_modifier", {duration=duration})
	ability:ApplyDataDrivenModifier(caster, target, "bvo_rory_skill_4_modifier_enemy", {duration=duration})

	ability.target = target

	caster.bvo_rory_skill_4_hp_old = caster:GetHealth()
	caster.bvo_rory_skill_4_hp = caster:GetHealth()
end

function bvo_rory_skill_4_track(keys)
	local caster = keys.caster

	caster.bvo_rory_skill_4_hp_old = caster.bvo_rory_skill_4_hp_old or caster:GetMaxHealth()
	caster.bvo_rory_skill_4_hp = caster.bvo_rory_skill_4_hp or caster:GetMaxHealth()

	caster.bvo_rory_skill_4_hp_old = caster.bvo_rory_skill_4_hp
	caster.bvo_rory_skill_4_hp = caster:GetHealth()
end

function bvo_rory_skill_4_damage(keys)
	local caster = keys.caster
	local ability = keys.ability
	local target = ability.target
	local damage = keys.damage

	if damage > 1 and target and caster and target~=caster then
		if target ~= nil and target:IsAlive() then
			local damageTable = {
				victim = target,
				attacker = caster,
				damage = damage,
				damage_type = DAMAGE_TYPE_PURE,
			}
			ApplyDamage(damageTable)
			SendOverheadEventMessage(nil, OVERHEAD_ALERT_BONUS_POISON_DAMAGE, caster, ApplyDamage(damageTable) , nil)

			local new_health = caster.bvo_rory_skill_4_hp_old
			if new_health > caster:GetMaxHealth() then
				new_health = caster:GetMaxHealth()
			end
			caster:SetHealth(new_health)
		end
	end
end

function bvo_rory_skill_4_end(keys)
	local caster = keys.caster
	local ability = keys.ability

	caster:RemoveModifierByName("bvo_rory_skill_4_modifier")
	if ability.target ~= nil then
		ability.target:RemoveModifierByName("bvo_rory_skill_4_modifier_enemy")
		ability.target = nil
	end
end