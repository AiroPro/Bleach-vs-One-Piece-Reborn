function bvo_akainu_skill_1( keys )
	local caster = keys.caster
	local ability = keys.ability
	local recharge_cd = ability:GetLevelSpecialValueFor("recharge_cd", ability:GetLevel() - 1 )

	--charge logic
	ability:EndCooldown()
	
	local current_stack = caster:GetModifierStackCount( "bvo_akainu_skill_1_modifier", ability )
	local new_stack = current_stack - 1
	if new_stack == 0 then
		caster:RemoveModifierByName("bvo_akainu_skill_1_modifier")
		--set remaining cd to next charge
		local mods = caster:FindAllModifiers()
		local charge = recharge_cd
		for _,mod in pairs(mods) do
			if mod:GetName() == "bvo_akainu_skill_1_load_modifier" then
				local time = recharge_cd - mod:GetElapsedTime()
				if time < charge then charge = time end
			end
		end
		ability:StartCooldown(charge)
	else
		caster:SetModifierStackCount("bvo_akainu_skill_1_modifier", ability, new_stack )
		ability:StartCooldown(ability:GetCooldown(ability:GetLevel() - 1))
	end
	ability.akainu_skill_1_stacks = ability.akainu_skill_1_stacks - 1
end

function bvo_akainu_skill_1_init(keys)
	local caster = keys.caster
	local ability = keys.ability
	local max_stacks = ability:GetLevelSpecialValueFor("max_stacks", ability:GetLevel() - 1 )

	if ability.akainu_skill_1_init == nil then
		ability.akainu_skill_1_init = true
		ability.akainu_skill_1_stacks = max_stacks
		caster:SetModifierStackCount( "bvo_akainu_skill_1_modifier", ability, max_stacks )
	else
		if ability.akainu_skill_1_stacks > 0 then
			caster:SetModifierStackCount( "bvo_akainu_skill_1_modifier", ability, ability.akainu_skill_1_stacks )
		else
			caster:RemoveModifierByName("bvo_akainu_skill_1_modifier")
		end
	end
end

function bvo_akainu_skill_1_charge(keys)
	local caster = keys.caster
	local ability = keys.ability
	local current_stack = caster:GetModifierStackCount( "bvo_akainu_skill_1_modifier", ability )
	ability.akainu_skill_1_stacks = ability.akainu_skill_1_stacks + 1
	if not caster:HasModifier("bvo_akainu_skill_1_modifier") then
		ability:ApplyDataDrivenModifier(caster, caster, "bvo_akainu_skill_1_modifier", {} )
	end
	caster:SetModifierStackCount( "bvo_akainu_skill_1_modifier", ability, current_stack + 1 )
end

function bvo_akainu_skill_1_hit(keys)
	local caster = keys.caster
	local target = keys.target
	local ability = keys.ability
	local multi = ability:GetLevelSpecialValueFor("str_multi", ability:GetLevel() - 1 )

	local damageTable = {
		victim = target,
		attacker = caster,
		damage = ( caster:GetStrength() * multi ),
		damage_type = DAMAGE_TYPE_MAGICAL,
	}
	ApplyDamage(damageTable)
	SendOverheadEventMessage(nil, OVERHEAD_ALERT_BONUS_POISON_DAMAGE, caster, ApplyDamage(damageTable) , nil)
end