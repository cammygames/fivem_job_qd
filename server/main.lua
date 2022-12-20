local QBCore = exports['qb-core']:GetCoreObject()


function ExploitBan(id, reason)
	MySQL.insert('INSERT INTO bans (name, license, discord, ip, reason, expire, bannedby) VALUES (?, ?, ?, ?, ?, ?, ?)', {
		GetPlayerName(id),
		QBCore.Functions.GetIdentifier(id, 'license'),
		QBCore.Functions.GetIdentifier(id, 'discord'),
		QBCore.Functions.GetIdentifier(id, 'ip'),
		reason,
		2147483647,
		'job_qd'
	})
	TriggerEvent('qb-log:server:CreateLog', 'bans', 'Player Banned', 'red', string.format('%s was banned by %s for %s', GetPlayerName(id), 'job_qd', reason), true)
	DropPlayer(id, 'You were permanently banned by the server for: Exploiting')
end

local function AddQualification(Player, qualification)
    local existing = Player.PlayerData.metadata.qualifications or {}
    local jobQual = existing[Player.PlayerData.job.name] or {}

    if not HasQualification(Player.PlayerData, qualification) then 
        table.insert(jobQual, QualificationExists(Player.PlayerData.job.name, qualification))
    end

    existing[Player.PlayerData.job.name] = jobQual

    Player.Functions.SetMetaData('qualifications', existing)
end

QBCore.Commands.Add('addqual', Lang:t('commands.qualification.add.title'), { { name = Lang:t('commands.id.name'), help = Lang:t('commands.id.help') }, { name = Lang:t('commands.qualification.add.qualification.name'), help = Lang:t('commands.qualification.add.qualification.help') } }, true, function(source, args)
    local src = source
    local Player = QBCore.Functions.GetPlayer(tonumber(args[1]))
    local qual = tostring(args[2])


    if Player then
        if QualificationExists(Player.PlayerData.job.name, qual) then
            if HasQualification(Player.PlayerData, qual) then
                TriggerClientEvent('QBCore:Notify', src, Lang:t('error.already_has.qualification'), 'error')
            else
                AddQualification(Player, qual)
                TriggerClientEvent('QBCore:Notify', src, Lang:t('success.qualification.added'), 'success')
            end     
        else
            TriggerClientEvent('QBCore:Notify', src, Lang:t('error.not_found.qualification'), 'error')

        end
    else
        TriggerClientEvent('QBCore:Notify', src, Lang:t('error.not_online'), 'error')
    end

end, 'admin')

local function RemoveQualification(Player, qualification)
    local existing = Player.PlayerData.metadata.qualifications or {}
    local new = {}

    for _, v in pairs(existing[Player.PlayerData.job.name] or {}) do
        if v.slug ~= qualification then
            table.insert(new, v)
        end
    end

    existing[Player.PlayerData.job.name] = new

    Player.Functions.SetMetaData('qualifications', existing)
end

QBCore.Commands.Add('removequal', Lang:t('commands.qualification.remove.title'), { { name = Lang:t('commands.id.name'), help = Lang:t('commands.id.help') }, { name = Lang:t('commands.qualification.remove.qualification.name'), help = Lang:t('commands.qualification.remove.qualification.help') } }, true, function(source, args)
    local src = source
    local Player = QBCore.Functions.GetPlayer(tonumber(args[1]))
    local qual = tostring(args[2])

    if Player then
        if QualificationExists(Player.PlayerData.job.name, qual) then
            if HasQualification(Player.PlayerData, qual) then
                RemoveQualification(Player, qual)
                TriggerClientEvent('QBCore:Notify', src, Lang:t('success..removed'), 'success')
            else
                TriggerClientEvent('QBCore:Notify', src, Lang:t('error.does_not_have.qualification'), 'error')
            end
        else
            TriggerClientEvent('QBCore:Notify', src, Lang:t('error.not_found.qualification'), 'error')
        end
    else
        TriggerClientEvent('QBCore:Notify', src, Lang:t('error.not_online'), 'error')
    end
end, 'admin')

RegisterNetEvent("qualifications:server:change", function (data)
    local src = source
	local Player = QBCore.Functions.GetPlayer(src)
	local Employee = QBCore.Functions.GetPlayerByCitizenId(data.cid)

	if not Player.PlayerData.job.isboss then ExploitBan(src, 'QualificationChange Exploiting') return end
	
	if Employee then
        local qualification = QualificationExists(Player.PlayerData.job.name, data.qualification)
        if qualification then
            if HasQualification(Employee.PlayerData, data.qualification) then
                RemoveQualification(Employee, data.qualification)
                TriggerClientEvent('QBCore:Notify', src, Lang:t('success.qualification.removed'), "success")
                TriggerClientEvent('QBCore:Notify', Employee.PlayerData.source, Lang:t('success.qualification.removed').." " ..qualification.name..".", "success")
            else
                AddQualification(Employee, data.qualification)
                TriggerClientEvent('QBCore:Notify', src, Lang:t('success.qualification.added'), "success")
                TriggerClientEvent('QBCore:Notify', Employee.PlayerData.source, Lang:t('success.qualification.added').." " ..qualification.name..".", "success")
            end
        else
            TriggerClientEvent('QBCore:Notify', src, Lang:t('error.not_found.qualification'), "error")
        end
	else
		TriggerClientEvent('QBCore:Notify', src, Lang:t('error.not_online'), "error")
	end
    
	TriggerClientEvent('qb-bossmenu:client:OpenMenu', src)
end)

--- Departments ---

local function AddDepartment(Player, department)
    local existing = Player.PlayerData.metadata.departments or {}
    local jobQual = existing[Player.PlayerData.job.name] or {}

    if not InDepartment(Player.PlayerData, department) then
        table.insert(jobQual, DepartmentExists(Player.PlayerData.job.name, department))
    end

    existing[Player.PlayerData.job.name] = jobQual

    Player.Functions.SetMetaData('departments', existing)
end

QBCore.Commands.Add('adddepart', Lang:t('commands.department.add.title'), { { name = Lang:t('commands.id.name'), help = Lang:t('commands.id.help') }, { name = Lang:t('commands.department.add.department.name'), help = Lang:t('commands.department.add.department.help') } }, true, function(source, args)
    local src = source
    local Player = QBCore.Functions.GetPlayer(tonumber(args[1]))
    local department = tostring(args[2])


    if Player then
        if DepartmentExists(Player.PlayerData.job.name, department) then
            if InDepartment(Player.PlayerData, department) then
                TriggerClientEvent('QBCore:Notify', src, Lang:t('error.already_has.department'), 'error')
            else
                AddDepartment(Player, department)
                TriggerClientEvent('QBCore:Notify', src, Lang:t('success.department.added'), 'success')
            end     
        else
            TriggerClientEvent('QBCore:Notify', src, Lang:t('error.not_found.department'), 'error')

        end
    else
        TriggerClientEvent('QBCore:Notify', src, Lang:t('error.not_online'), 'error')
    end
end, 'admin')

local function RemoveDepartment(Player, department)
    local existing = Player.PlayerData.metadata.departments or {}
    local new = {}

    for _, v in pairs(existing[Player.PlayerData.job.name] or {}) do
        if v.slug ~= department then
            table.insert(new, v)
        end
    end

    existing[Player.PlayerData.job.name] = new

    Player.Functions.SetMetaData('departments', existing)
end

QBCore.Commands.Add('removedep', Lang:t('commands.department.remove.title'), { { name = Lang:t('commands.id.name'), help = Lang:t('commands.id.help') }, { name = Lang:t('commands.department.remove.department.name'), help = Lang:t('commands.department.remove.department.help') } }, true, function(source, args)
    local src = source
    local Player = QBCore.Functions.GetPlayer(tonumber(args[1]))
    local department = tostring(args[2])

    if Player then
        if DepartmentExists(Player.PlayerData.job.name, department) then
            if InDepartment(Player.PlayerData, department) then
                RemoveDepartment(Player, department)
                TriggerClientEvent('QBCore:Notify', src, Lang:t('success.department.removed'), 'success')
            else
                TriggerClientEvent('QBCore:Notify', src, Lang:t('error.does_not_have.department'), 'error')
            end
        else
            TriggerClientEvent('QBCore:Notify', src, Lang:t('error.not_found.department'), 'error')
        end
    else
        TriggerClientEvent('QBCore:Notify', src, Lang:t('error.not_online'), 'error')
    end
end, 'admin')

RegisterNetEvent("departments:server:change", function (data)
    local src = source
	local Player = QBCore.Functions.GetPlayer(src)
	local Employee = QBCore.Functions.GetPlayerByCitizenId(data.cid)

	if not Player.PlayerData.job.isboss then ExploitBan(src, 'DepartmentChange Exploiting') return end
	
	if Employee then
        local department = DepartmentExists(Player.PlayerData.job.name, data.department)
        if department then
            if InDepartment(Employee.PlayerData, data.department) then
                RemoveDepartment(Employee, data.department)
                TriggerClientEvent('QBCore:Notify', src, Lang:t('success.department.removed'), "success")
                TriggerClientEvent('QBCore:Notify', Employee.PlayerData.source, Lang:t('success.department.management.removed').." " ..department.name..".", "success")
            else
                AddDepartment(Employee, data.department)
                TriggerClientEvent('QBCore:Notify', src, Lang:t('success.department.added'), "success")
                TriggerClientEvent('QBCore:Notify', Employee.PlayerData.source, Lang:t('success.department.management.added').." " ..department.name..".", "success")
            end
        else
            TriggerClientEvent('QBCore:Notify', src, Lang:t('error.not_found.department'), "error")
        end
	else
		TriggerClientEvent('QBCore:Notify', src, Lang:t('error.not_online'), "error")
	end
    
	TriggerClientEvent('qb-bossmenu:client:OpenMenu', src)
end)