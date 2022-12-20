function QualificationExists (job, slug)
    for _, v in pairs(Config.Qualifications[job]) do
        if v.slug == slug then
            return v
        end
    end

    return false
end

exports("QualificationExists", QualificationExists)

function HasQualification(PlayerData, qual)
    if PlayerData.metadata.qualifications then
        if PlayerData.metadata.qualifications[PlayerData.job.name] then       
            for _, v in pairs(PlayerData.metadata.qualifications[PlayerData.job.name]) do
                if v.slug == qual then
                    return true
                end
            end
        end
    end

    return false
end

exports("HasQualification", HasQualification)

function HasQualificationFromMeta(metadata, job, qual)
    local qualifications = metadata.qualifications or {}
    if qualifications[job.name] then
        for _, v in pairs(qualifications[job.name]) do
            if v.slug == qual then
                return true
            end
        end
    end

    return false
end

exports("HasQualificationFromMeta", HasQualificationFromMeta)

function HasAnyOfQualifications(PlayerData, list)
    if #list < 1 then
        return true
    end

    for _, v in pairs(list) do
        local result = HasQualification(PlayerData, v)

        if result then
            return true
        end
    end

    return false
end

exports("HasAnyOfQualifications", HasAnyOfQualifications)


function HasAllOfQualifications(PlayerData, list)
    if #list < 1 then
        return true
    end

    local total = 0

    for _, v in pairs(list) do
        local result = HasQualification(PlayerData, v)

        if result then
            total = total + 1
        end
    end

    if #list == total then
        return true
    end

    return false
end

exports("HasAllOfQualifications", HasAllOfQualifications)

--- Departments ---
function DepartmentExists(job, slug)
    for _, v in pairs(Config.Departments[job]) do
        if v.slug == slug then
            return v
        end
    end

    return false
end

exports("DepartmentExists", DepartmentExists)

function InDepartment(PlayerData, department)
    if PlayerData.metadata.departments then
        if PlayerData.metadata.departments[PlayerData.job.name] then       
            for _, v in pairs(PlayerData.metadata.departments[PlayerData.job.name]) do
                if v.slug == department then
                    return true
                end
            end
        end
    end

    return false
end

exports("InDepartment", InDepartment)

function InDepartmentFromMeta(metadata, job, department)
    local departments = metadata.departments or {}
    if departments[job.name] then       
        for _, v in pairs(departments[job.name]) do
            if v.slug == department then
                return true
            end
        end
    end

    return false
end

exports("InDepartmentFromMeta", InDepartmentFromMeta)

function InOneOfDepartments(PlayerData, list)
    if #list < 1 then
        return true
    end

    for _, v in pairs(list) do
        local result = InDepartment(PlayerData, v)

        if result then
            return true
        end
    end

    return false
end

exports("InOneOfDepartments", InOneOfDepartments)

function InAllOfDepartments(PlayerData, list)
    if #list < 1 then
        return true
    end

    local total = 0

    for _, v in pairs(list) do
        local result = InDepartment(PlayerData, v)

        if result then
            total = total + 1
        end
    end

    if #list == total then
        return true
    end

    return false
end

exports("InAllOfDepartments", InAllOfDepartments)
