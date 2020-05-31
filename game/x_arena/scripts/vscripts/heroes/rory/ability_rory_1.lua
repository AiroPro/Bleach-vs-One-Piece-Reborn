require('timers')

function bvo_rory_skill_1(keys)
	local caster = keys.caster
	local ability = keys.ability
	local base_damage = ability:GetLevelSpecialValueFor("base_damage", (ability:GetLevel() - 1))
	local damage_per_stack = ability:GetLevelSpecialValueFor("damage_per_stack", (ability:GetLevel() - 1))
	local max_stack_use = ability:GetLevelSpecialValueFor("max_stack_use", ability:GetLevel() - 1 )
	local radius = ability:GetLevelSpecialValueFor("radius", (ability:GetLevel() - 1))

	local stacks_to_use
	local current_stack = caster:GetModifierStackCount( "bvo_rory_skill_0_buff_modifier", ability )
	if current_stack >= max_stack_use then
		stacks_to_use = max_stack_use
	else
		stacks_to_use = current_stack
	end

	local new_stack = current_stack - stacks_to_use
	if new_stack > 0 then
		caster:SetModifierStackCount( "bvo_rory_skill_0_buff_modifier", ability, new_stack )
	else
		caster:RemoveModifierByName("bvo_rory_skill_0_buff_modifier")
	end

	local particle = ParticleManager:CreateParticle("particles/econ/items/juggernaut/bladekeeper_bladefury/_dc_juggernaut_blade_fury.vpcf", PATTACH_WORLDORIGIN, caster)
	ParticleManager:SetParticleControl(particle, 0, caster:GetAbsOrigin())
	ParticleManager:SetParticleControl(particle, 5, Vector(radius, radius, radius))
	Timers:CreateTimer(0.4, function ()
		ParticleManager:DestroyParticle(particle, false)
	end)

	caster:EmitSound("Hero_Juggernaut.BladeDance")
	local localUnits = FindUnitsInRadius(caster:GetTeamNumber(),
	            caster:GetAbsOrigin(),
	            nil,
	            radius,
	            DOTA_UNIT_TARGET_TEAM_ENEMY,
	            DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,
	            DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES,
	            FIND_ANY_ORDER,
	            false)

	for _,unit in pairs(localUnits) do
		local damageTable = {
			victim = unit,
			attacker = caster,
			damage = base_damage + ( damage_per_stack * stacks_to_use ),
			damage_type = DAMAGE_TYPE_PHYSICAL,
		}
		ApplyDamage(damageTable)
		SendOverheadEventMessage(nil, OVERHEAD_ALERT_BONUS_POISON_DAMAGE, caster, ApplyDamage(damageTable) , nil)
	end
end