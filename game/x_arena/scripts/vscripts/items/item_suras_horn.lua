function с(keys)
	local caster = keys.caster
		
	caster:EmitSound("Item.GuardianGreaves.Activate")
	caster:GiveMana(caster:GetMaxMana())
end

function item_suras_horn_void(keys)
	local caster = keys.caster
	local target = keys.target
	local ability = keys.ability
	local burn = ability:GetLevelSpecialValueFor("burn", ability:GetLevel() - 1 )
	local damage_per_mana = ability:GetLevelSpecialValueFor("damage_per_mana", ability:GetLevel() - 1 )

	if caster:IsIllusion() and not caster:HasModifier("item_mirror_of_kalandra_illu_modifier") then return end
	--Manavoid
	if target:GetMaxMana() > 0 and not target:IsMagicImmune() then
		local max = target:GetMaxMana()
		local missing = max - target:GetMana()

		local damageTable = { 
			victim = target,
			attacker = caster,
			damage = missing * damage_per_mana,
			damage_type = DAMAGE_TYPE_MAGICAL,
		}
		ApplyDamage(damageTable)
		target:EmitSound("Hero_Antimage.ManaVoid") 

		--local particle = ParticleManager:CreateParticle("particles/units/heroes/hero_antimage/antimage_manavoid.vpcf", PATTACH_POINT, target)
		--ParticleManager:SetParticleControl(particle, 0, Vector(0, 0, 0) )
		--ParticleManager:SetParticleControl(particle, 1, Vector(275, 0, 0) )
	end
end 

function item_suras_horn_burn(keys)
	local caster = keys.caster
	local target = keys.target
	local ability = keys.ability
	local burn = ability:GetLevelSpecialValueFor("burn", ability:GetLevel() - 1 )
	local percent_burn = ability:GetLevelSpecialValueFor("percent_burn", ability:GetLevel() - 1 ) / 100

	--Manaburn
	if target:GetMaxMana() > 0 then
		burn = burn + target:GetMaxMana() * percent_burn
		if caster:IsIllusion() and not caster:HasModifier("item_mirror_of_kalandra_illu_modifier") then
			burn = burn / 2
		end
		local targetMana = target:GetMana()
		local burned = targetMana - burn
		if burned < 0 then burned = 0 end
		target:SetMana(burned)
		local burned_mana = targetMana - burned
		local damageTable = {
			victim = target,
			attacker = caster,
			damage = burned_mana,
			damage_type = DAMAGE_TYPE_PURE,
		}
		ApplyDamage(damageTable)

		local particleName = "particles/generic_gameplay/generic_manaburn.vpcf"
		ParticleManager:CreateParticle(particleName, PATTACH_ABSORIGIN_FOLLOW, target)
		SendOverheadEventMessage(nil, OVERHEAD_ALERT_BONUS_POISON_DAMAGE, caster, ApplyDamage(damageTable) , nil)
	end
end