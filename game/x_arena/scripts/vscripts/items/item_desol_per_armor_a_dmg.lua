function item_desol_per_armor_a_dmg( keys )
	local caster = keys.caster
	local target = keys.target
	local ability = keys.ability
	local dur = ability:GetLevelSpecialValueFor("duration", ability:GetLevel() - 1 )
	local max_stacks = ability:GetLevelSpecialValueFor("max_stacks", ability:GetLevel() - 1 )

	if caster:IsIllusion() and not caster:HasModifier("item_mirror_of_kalandra_illu_modifier") then return end

	if not target:HasModifier("item_corrupted_custom_shatter_modifier") then
		ability:ApplyDataDrivenModifier(caster, target, "item_corrupted_custom_shatter_modifier", {duration=dur})
		target:SetModifierStackCount( "item_corrupted_custom_shatter_modifier", ability, 1 )
	else
		local current_stack = target:GetModifierStackCount( "item_corrupted_custom_shatter_modifier", ability )
		if current_stack < max_stacks then
			target:SetModifierStackCount( "item_corrupted_custom_shatter_modifier", ability, current_stack + 1 )
		end
	end

	local mods = target:FindAllModifiers()
	for _,mod in pairs(mods) do
		if mod:GetName() == "item_corrupted_custom_shatter_modifier" then
			mod:ForceRefresh()
			break
		end
	end
end
