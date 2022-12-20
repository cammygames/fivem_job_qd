local QBCore = exports['qb-core']:GetCoreObject()

function BuildGarageMenu(currentSelection, vehicleMenu, vehicles, event)
    local PlayerData = QBCore.Functions.GetPlayerData()

    for vehicle, data in pairs(vehicles) do
        local hasMinGrade = PlayerData.job.grade.level >= data.minGrade
        local hasDepartment = false
        local hasQualification = false
        local reqAllDep = data["allDepartmentsRequired"] or false
        local reqAllQual = data["allQualificationsRequired"] or false

        if #data.departments > 0 then
            if reqAllDep then
                hasDepartment = InAllOfDepartments(PlayerData, data.departments)
            else
                hasDepartment = InOneOfDepartments(PlayerData, data.departments)
            end
        else
            hasDepartment = true
        end

        if #data.qualifications > 0 then
            if reqAllQual then
                hasQualification = HasAllOfQualifications(PlayerData, data.qualifications)
            else
                hasQualification = HasAnyOfQualifications(PlayerData, data.qualifications)
            end
        else
            hasQualification = true
        end

        if hasMinGrade and hasDepartment and hasQualification then
            vehicleMenu[#vehicleMenu+1] = {
                header = data.display,
                txt = "",
                params = {
                    event = event,
                    args = {
                        vehicle = vehicle,
                        currentSelection = currentSelection
                    }
                }
            }
        end
    end

    return vehicleMenu
end

exports("BuildGarageMenu", BuildGarageMenu)