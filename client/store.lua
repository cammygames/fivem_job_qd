local QBCore = exports['qb-core']:GetCoreObject()

function BuildArmory(items, authorizedItems)
    local index = 1
    local PlayerData = QBCore.Functions.GetPlayerData()

    for _, armoryItem in pairs(items) do
        local hasMinGrade = PlayerData.job.grade.level >= armoryItem.minGrade
        local hasDepartment = false
        local hasQualification = false
        local reqAllDep = armoryItem["allDepartmentsRequired"] or false
        local reqAllQual = armoryItem["allQualificationsRequired"] or false

        if #armoryItem.departments > 0 then
            if reqAllDep then
                hasDepartment = InAllOfDepartments(PlayerData, armoryItem.departments)
            else
                hasDepartment = InOneOfDepartments(PlayerData, armoryItem.departments)
            end
        else
            hasDepartment = true
        end

        if #armoryItem.qualifications > 0 then
            if reqAllQual then
                hasQualification = HasAllOfQualifications(PlayerData, armoryItem.qualifications)
            else
                hasQualification = HasAnyOfQualifications(PlayerData, armoryItem.qualifications)
            end
        else
            hasQualification = true
        end

        if hasMinGrade and hasDepartment and hasQualification then
            authorizedItems.items[index] = armoryItem
            authorizedItems.items[index].slot = index
            index = index + 1
        end
    end

    return authorizedItems
end

exports("BuildArmory", BuildArmory)