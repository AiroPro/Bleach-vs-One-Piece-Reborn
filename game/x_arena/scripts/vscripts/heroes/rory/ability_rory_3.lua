function bvo_rory_skill_3(keys)
	local caster = keys.caster
	local target = keys.target
	local ability = keys.ability
	local max_stack_use = ability:GetLevelSpecialValueFor("max_stack_use", ability:GetLevel() - 1 )

	local stacks_to_use
	local current_stack = caster:GetModifierStackCount( "bvo_rory_skill_0_buff_modifier", ability )
	if current_stack >= max_stack_use then
		stacks_to_use = max_stack_use
	else
		stacks_to_use = current_stack
	end

	ability.stacks_to_use = stacks_to_use

	local new_stack = current_stack - stacks_to_use
	if new_stack > 0 then
		caster:SetModifierStackCount( "bvo_rory_skill_0_buff_modifier", ability, new_stack )
	else
		caster:RemoveModifierByName("bvo_rory_skill_0_buff_modifier")
	end
end

function bvo_rory_skill_3_damage(keys)
	local caster = keys.caster
	local target = keys.target
	local ability = keys.ability
	local base_damage = ability:GetLevelSpecialValueFor("base_damage", (ability:GetLevel() - 1))
	local damage_per_stack = ability:GetLevelSpecialValueFor("raw_damage_per_stack", (ability:GetLevel() - 1))
	local agi_as_damage_per_stack = ability:GetLevelSpecialValueFor("agi_as_damage_per_stack", (ability:GetLevel() - 1))
	local stacks_to_use = ability.stacks_to_use

	local damageTable = {
		victim = target,
		attacker = caster,
		damage = base_damage + ( damage_per_stack * stacks_to_use ) + ( caster:GetAgility() * agi_as_damage_per_stack * stacks_to_use ),
		damage_type = DAMAGE_TYPE_MAGICAL,
	}
	ApplyDamage(damageTable)
	SendOverheadEventMessage(nil, OVERHEAD_ALERT_BONUS_POISON_DAMAGE, caster, ApplyDamage(damageTable) , nil)
end