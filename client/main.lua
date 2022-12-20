local QBCore = exports['qb-core']:GetCoreObject()
local DepartmentMenuID = nil
local QualificationMenuID = nil

RegisterNetEvent('departments:client:manage', function(data)
    local Menu = {
        {
            header = Lang:t('menu.manage') .." ".. data.player.name .. " - " .. Lang:t('menu.departments'),
            isMenuHeader = true,
            icon = "fa-solid fa-circle-info"
        },
    }

    for k, v in pairs(Config.Departments[data.work.name]) do
        local label = '❌ '

        if InDepartmentFromMeta(data.player.metadata, data.work, v.slug) then
            label = "🟢 " 
        end

        Menu[#Menu + 1] = {
            header = v.name,
            txt = label,
            params = {
                isServer = true,
                event = "departments:server:change",
                icon = "fa-solid fa-file-pen",
                args = {
                    cid = data.player.empSource,
                    department = v.slug
                }
            }
        }
    end

    Menu[#Menu + 1] = {
        header = Lang:t('menu.t_return'),
        icon = "fa-solid fa-angle-left",
        params = {
            event = "qb-bossmenu:client:ManageEmployee",
            args = data
        }
    }

    exports['qb-menu']:openMenu(Menu)
end)


RegisterNetEvent('qualifications:client:manage', function(data)
    local Menu = {
        {
            header = Lang:t('menu.manage') .." ".. data.player.name .. " - " .. Lang:t('menu.qualifications'),
            isMenuHeader = true,
            icon = "fa-solid fa-circle-info"
        },
    }

    for k, v in pairs(Config.Qualifications[data.work.name]) do
        local label = '❌ '

        if HasQualificationFromMeta(data.player.metadata, data.work, v.slug) then
            label = "🟢 " 
        end

        Menu[#Menu + 1] = {
            header = v.name,
            txt = label,
            params = {
                isServer = true,
                event = "qualifications:server:change",
                icon = "fa-solid fa-file-pen",
                args = {
                    cid = data.player.empSource,
                    qualification = v.slug
                }
            }
        }
    end

    Menu[#Menu + 1] = {
        header = Lang:t('menu.t_return'),
        icon = "fa-solid fa-angle-left",
        params = {
            event = "qb-bossmenu:client:ManageEmployee",
            args = data
        }
    }

    exports['qb-menu']:openMenu(Menu)
end)

local function AddDepartmentMenu()
    local DepartmentMenu = {
        header = Lang:t('menu.department.title'),
        txt = Lang:t('menu.department.subtitle'),
        params = {
            event = "departments:client:manage",
            icon = "fa-solid fa-file-pen",
        }
    }

    local QualificationMenu = {
        header = Lang:t('menu.qualification.title'),
        txt = Lang:t('menu.qualification.subtitle'),
        params = {
            event = "qualifications:client:manage",
            icon = "fa-solid fa-file-pen",
        }
    }

    DepartmentMenuID = exports["qb-management"]:AddEmployeeManagementMenuItem(DepartmentMenu)
    QualificationMenuID = exports["qb-management"]:AddEmployeeManagementMenuItem(QualificationMenu)
end

RegisterNetEvent('QBCore:Client:OnPlayerLoaded', function()
    AddDepartmentMenu()
end)

local function RemoveDepartmentMenu()
    if DepartmentMenuID then
        exports["qb-management"]:RemoveEmployeeManagementItem(DepartmentMenuID)
        DepartmentMenuID = nil
    end
    if QualificationMenuID then
        exports["qb-management"]:RemoveEmployeeManagementItem(QualificationMenuID)
        QualificationMenuID = nil
    end
end

RegisterNetEvent('QBCore:Client:OnPlayerUnload', function()
    AddDepartmentMenu()
end)

AddEventHandler('onResourceStop', function(resource)
    if resource == GetCurrentResourceName() then
        RemoveDepartmentMenu()
    end
end)
