require('timers')

function bvo_rem_skill_5( keys )
	local ability = keys.ability

	local interval = ability:GetLevelSpecialValueFor( "interval", ability:GetLevel() - 1 )
	local delay = ability:GetLevelSpecialValueFor( "delay", ability:GetLevel() - 1 )
	local spread = ability:GetLevelSpecialValueFor( "spread", ability:GetLevel() - 1 )
	local waves = ability:GetLevelSpecialValueFor( "waves", ability:GetLevel() - 1 )

	local radius = ability:GetLevelSpecialValueFor( "radius", ability:GetLevel() - 1 )
	local damage = ability:GetLevelSpecialValueFor( "damage", ability:GetLevel() - 1 )
	local multi = ability:GetLevelSpecialValueFor( "agi_multi", ability:GetLevel() - 1 )
	--Torrents
	for i = 0, waves - 1 do
		Timers:CreateTimer(i * interval, function ()
			bvo_rem_skill_5_torrent({
				damage = damage,
				multi = multi,
				delay = delay,
				amount = 1 + i + i * (spread - 1),
				distance = radius * i,
				caster = keys.caster,
				radius = radius,
				forward = keys.caster:GetForwardVector(),
				point = keys.target_points[1]
			})
		end)
	end
end

function bvo_rem_skill_5_torrent( keys )
	local damage = keys.damage
	local multi = keys.multi
	local delay = keys.delay

	local allHeroes = HeroList:GetAllHeroes()
	local amount = keys.amount
	local distance = keys.distance

	local caster = keys.caster
	local radius = keys.radius
	local forward = keys.forward
	local target = keys.point

	local targetOffset = target + forward * distance

	--Torrents
	local tableVector = {}
	local tablefxIndex = {}

	local a = amount
	for i = 1, a do
		local rotation = QAngle( 0, i * 360 / a, 0 )
		local rot_vector = RotatePosition(target, rotation, targetOffset)

		tableVector[i] = rot_vector
		--Particle
		local fxIndex = ParticleManager:CreateParticle("particles/econ/items/kunkka/divine_anchor/hero_kunkka_dafx_skills/kunkka_spell_torrent_bubbles_fxset.vpcf", PATTACH_ABSORIGIN, caster)
		ParticleManager:SetParticleControl( fxIndex, 0, rot_vector )
		tablefxIndex[i] = fxIndex

		--Sfx
		for k, v in pairs( allHeroes ) do
			if v:GetPlayerID() then
				EmitSoundOnClient( "Ability.pre.Torrent", PlayerResource:GetPlayer( v:GetPlayerID() ) )
			end
		end
	end
	--Destroy particles after delay
	Timers:CreateTimer(delay, function()
		for i = 1, #tableVector do
			--Particle
			local particle =  ParticleManager:CreateParticle("particles/econ/items/kunkka/divine_anchor/hero_kunkka_dafx_skills/kunkka_spell_torrent_splash_fxset.vpcf", PATTACH_CUSTOMORIGIN, caster)
			ParticleManager:SetParticleControl(particle, 0, tableVector[i])
			--Sfx
			local dummy = CreateUnitByName( "npc_dummy_unit", target, false, caster, caster, caster:GetTeamNumber() )
			EmitSoundOn( "Ability.Torrent", dummy )
			dummy:ForceKill( true )
			--Damage
			local localUnits = FindUnitsInRadius(caster:GetTeamNumber(),
			            tableVector[i],
			            nil,
			            radius,
			            DOTA_UNIT_TARGET_TEAM_ENEMY,
			            DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,
			            DOTA_UNIT_TARGET_FLAG_NONE,
			            FIND_ANY_ORDER,
			            false)

			for _,unit in pairs(localUnits) do
				local damageTable = {
					victim = unit,
					attacker = caster,
					damage = ( caster:GetAgility() * multi ) + damage,
					damage_type = DAMAGE_TYPE_MAGICAL,
				}
				ApplyDamage(damageTable)
				SendOverheadEventMessage(nil, OVERHEAD_ALERT_BONUS_POISON_DAMAGE, caster, ApplyDamage(damageTable) , nil)
			end
			--Kill particle
			ParticleManager:DestroyParticle( tablefxIndex[i], false )
		end
	end)
end