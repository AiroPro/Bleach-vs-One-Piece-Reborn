function bvo_anzu_skill_3(keys)
	local caster = keys.caster

	caster:Heal(caster:GetMaxHealth() * (keys.RegenPercentPerSecond / 100) * keys.Interval, caster)
	caster:GiveMana(caster:GetMaxMana() * (keys.RegenPercentPerSecond / 100) * keys.Interval)

	if caster:GetManaPercent() == 100 and caster:GetHealthPercent() == 100 then
		caster:RemoveModifierByName("bvo_anzu_skill_3_modifier")
	end
end

function bvo_anzu_skill_3_wake( keys )
	local caster = keys.caster
	local attacker = keys.attacker
	local ability = keys.ability
	local multi = keys.multi
	local int = caster:GetIntellect()
	local damage_per_health = ability:GetLevelSpecialValueFor("damage_per_health", (ability:GetLevel() - 1))

	if not attacker:IsHero() then return end

	caster:RemoveModifierByName("bvo_anzu_skill_3_modifier")

	local damage = caster:GetMaxHealth() - caster:GetHealth()

	local damageTable = {
		victim = attacker,
		attacker = caster,
		damage = damage * damage_per_health + multi * int,
		damage_type = DAMAGE_TYPE_PURE,
	}
	ApplyDamage(damageTable)
	SendOverheadEventMessage(nil, OVERHEAD_ALERT_BONUS_POISON_DAMAGE, caster, ApplyDamage(damageTable) , nil)
end

function bvo_anzu_skill_3_stop( keys )
	local caster = keys.caster
	local ability = keys.ability

	if ability:IsCooldownReady() then
		caster:StopSound("BleachVsOnePieceReborn.AnzuSkill3")
	end
end

function bvo_anzu_skill_3_stop_force( keys )
	keys.caster:StopSound("BleachVsOnePieceReborn.AnzuSkill3")
end