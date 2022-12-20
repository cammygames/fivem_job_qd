## QB-Management Changes

1. cl_boss.lua
   1. Add below line 4
    ```lua
    local DynamicEmployeeMenuItems = {}
    local function AddEmployeeManagementMenuItem(data, id)
        local menuID = id or (#DynamicEmployeeMenuItems + 1)
        DynamicEmployeeMenuItems[menuID] = deepcopy(data)
        return menuID
    end

    exports("AddEmployeeManagementMenuItem", AddEmployeeManagementMenuItem)

    local function RemoveEmployeeManagementItem(id)
        DynamicEmployeeMenuItems[id] = nil
    end

    exports("RemoveEmployeeManagementItem", RemoveEmployeeManagementItem)
    ```
    2. Add arround line 190 (inside of the qb-bossmenu:client:ManageEmployee event)
    ```lua
    for _, v in pairs(DynamicEmployeeMenuItems) do
        v.params["args"] = data
        EmployeeMenu[#EmployeeMenu + 1] = v
    end
    ```
2. sv_boss.lua
   1. below line 128 add
   ```lua
   metadata = isOnline.PlayerData.metadata,
   ```
   2. below line 136 add
   ```lua
   metadata = json.decode(value.metadata),
   ```

## How to implement Departments & Qualifications in qb-policejob
1. In the event qb-police:client:openArmoury
   Replace 
   ```lua
    local index = 1
        for _, armoryItem in pairs(Config.Items.items) do
            for i=1, #armoryItem.authorizedJobGrades do
                if armoryItem.authorizedJobGrades[i] == PlayerJob.grade.level then
                    authorizedItems.items[index] = armoryItem
                    authorizedItems.items[index].slot = index
                    index = index + 1
                end
            end
        end
   ```
   With
   ```lua
        authorizedItems = exports["job_qd"]:BuildArmory(Config.Items.items, authorizedItems)
   ```
2. In Config.Items.items add the following to every item
   ```lua
        qualifications = {},
        departments = {}
   ```
3. In Config.Items.items change
   ```lua
        authorizedJobGrades = {0, 1, 2, 3, 4}
   ```
   to
   ```lua
        minGrade = 0,
   ```
   your item should now look something like this
   ```lua
        [5] = {
            name = "pistol_ammo",
            price = 0,
            amount = 5,
            info = {},
            type = "item",
            slot = 5,
            minGrade = 0,
            qualifications = {},
            departments = {}
        },
   ```

## How to implement Departments & Qualifications in qb-ambulancejob
1. In the event qb-ambulancejob:armory
   Replace 
   ```lua
        if onDuty then
            TriggerServerEvent("inventory:server:OpenInventory", "shop", "hospital", Config.Items)
        end
   ```
   With
   ```lua
        if onDuty then
            local authorizedItems = {
                label = Config.Items.label,
                slots = Config.Items.slots,
                items = {}
            }
            authorizedItems = exports["job_qd"]:BuildArmory(Config.Items.items, authorizedItems)
            TriggerServerEvent("inventory:server:OpenInventory", "shop", "hospital", authorizedItems)
        end
   ```
2. In Config.Items.items add the following to every item
   ```lua
        qualifications = {},
        departments = {}
   ```
3. In Config.Items.items change
   ```lua
        authorizedJobGrades = {0, 1, 2, 3, 4}
   ```
   to
   ```lua
        minGrade = 0,
   ```
   your item should now look something like this
   ```lua
        [1] = {
            name = "radio",
            price = 0,
            amount = 50,
            info = {},
            type = "item",
            slot = 1,
            minGrade = 0,
            departments = {},
            qualifications = {}
        },
    ```

## How to add a department
See Config.Departments for the format

## How to add a qualification
See Config.Qualifications for the format

## Aailable Exports
### Qualification Exports
1. QualificationExists
   ```lua
        exports["job_qd"]:QualificationExists(job, slug)
   ```
   Returns bool or table
   Example Use
   ```lua
    local PlayerData = QBCore.Functions.GetPlayerData()
    local qualification = exports["job_qd"]:QualificationExists(PlayerData.job.name, "test")
    if qualification then
        print("Qualification Exists " .. qualification.name)
    else
        print("Qualification Does Not Exist")
    end
   ```
2. HasQualification
   ```lua
        exports["job_qd"]:HasQualification(PlayerData, slug)
   ```
   Returns bool
   Example Use
   ```lua
    local PlayerData = QBCore.Functions.GetPlayerData()
    if exports["job_qd"]:HasQualification(PlayerData, "test") then
        print("Player has qualification")
    else
        print("Player does not have qualification")
    end
   ```
3. HasQualificationFromMeta
   ```lua
        exports["job_qd"]:HasQualificationFromMeta(metadata, job, slug)
   ```
   returns bool
   Example Use
   ```lua
    local PlayerData = QBCore.Functions.GetPlayerData()
    if exports["job_qd"]:HasQualificationFromMeta(PlayerData.metadata, PlayerData.job, "test") then
        print("Player has qualification")
    else
        print("Player does not have qualification")
    end    
   ```
4. HasAnyOfQualifications
   ```lua
        exports["job_qd"]:HasAnyOfQualifications(PlayerData, list)
   ```
   returns bool
   Example Use
   ```lua
    local PlayerData = QBCore.Functions.GetPlayerData()
    if exports["job_qd"]:HasAnyOfQualifications(PlayerData, {"test", "other"}) then
        print("Player has atleast one of the qualifications")
    else
        print("Player does not have any of the qualifications")
    end
   ```
5. HasAllOfQualifications
   ```lua
        exports["job_qd"]:HasAllOfQualifications(PlayerData, list)
   ```
   returns bool
   Example Use
   ```lua
    local PlayerData = QBCore.Functions.GetPlayerData()
    if exports["job_qd"]:HasAllOfQualifications(PlayerData, {"test", "other"}) then
        print("Player has all the qualifications")
    else
        print("Player does not have all the qualifications")
    end
   ```

### Department Exports
1. DepartmentExists
   ```lua
        exports["job_qd"]:DepartmentExists(job, slug)
   ```
   Returns bool or table
   Example Use
   ```lua
    local PlayerData = QBCore.Functions.GetPlayerData()
    local department = exports["job_qd"]:DepartmentExists(PlayerData.job.name, "test")
    if department then
        print("Department Exists " .. department.name)
    else
        print("Department Does Not Exist")
    end
   ```
2. InDepartment
   ```lua
        exports["job_qd"]:InDepartment(PlayerData, slug)
   ```
   Returns bool
   Example Use
   ```lua
    local PlayerData = QBCore.Functions.GetPlayerData()
    if exports["job_qd"]:InDepartment(PlayerData, "test") then
        print("Player is in department")
    else
        print("Player is not in department")
    end
   ```
3. InDepartmentFromMeta
   ```lua
        exports["job_qd"]:InDepartmentFromMeta(metadata, job, slug)
   ```
   returns bool
   Example Use
   ```lua
    local PlayerData = QBCore.Functions.GetPlayerData()
    if exports["job_qd"]:InDepartmentFromMeta(PlayerData.metadata, PlayerData.job, "test") then
        print("Player is in department")
    else
        print("Player is not in department")
    end    
   ```
4. InOneOfDepartments
   ```lua
        exports["job_qd"]:InOneOfDepartments(PlayerData, list)
   ```
   returns bool
   Example Use
   ```lua
    local PlayerData = QBCore.Functions.GetPlayerData()
    if exports["job_qd"]:InOneOfDepartments(PlayerData, {"test", "other"}) then
        print("Player is in atleast one of the departments")
    else
        print("Player is not in any of the departments")
    end
   ```
5. InAllOfDepartments
   ```lua
        exports["job_qd"]:InAllOfDepartments(PlayerData, list)
   ```
   returns bool
   Example Use
   ```lua
    local PlayerData = QBCore.Functions.GetPlayerData()
    if exports["job_qd"]:InAllOfDepartments(PlayerData, {"test", "other"}) then
        print("Player is in all the departments")
    else
        print("Player is not in all the departments")
    end
   ```
6. BuildArmory
   ```lua
        exports["job_qd"]:BuildArmory(items, authorizedItems)
   ```
   Example Use
   ```lua
        authorizedItems = exports["job_qd"]:BuildArmory(Config.Items.items, authorizedItems)
   ```
7. BuildGarageMenu
   ```lua
        exports["job_qd"]:BuildGarageMenu(currentSelection, vehicleMenu, vehicles, event)
   ```
   Example Use
   ```lua
        vehicleMenu = exports["job_qd"]:BuildGarageMenu(nil, vehicleMenu, Config.AuthorizedVehicles, "ambulance:client:TakeOutVehicle")
   ```
