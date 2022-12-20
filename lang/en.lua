local Translations = {
    error = {
        not_online = 'Player not online',
        not_found = {
            qualification = 'Qualification not found',
            department = 'Department not found'
        },
        already_has = {
            qualification = 'Player already has this qualification',
            department = 'Player is already a member of this department'
        },
        does_not_have = {
            qualification = 'Player does not have this qualification',
            department = 'Player is not a member of this department'
        }
    },
    success = {
        qualification = {
            added = "Qualification Added",
            removed = "Qualification Removed",
        },
        department = {
            added = "Department Membership Added",
            removed = "Department Membership Removed",
            management = {
                added = "You have been added to",
                removed = "You have been removed from"
            }
        }
    },
    commands = {
        id = { name = 'id', help = 'Player ID' },
        qualification = {
            add = {
                title = 'Give A Player A Qualification (Admin Only)',
                qualification = { name = 'qualification', help = 'Qualification slug' }
            },
            remove = {
                title = 'Remove A Players Qualification (Admin only)',
                qualification = { name = 'qualification', help = 'Qualification slug' }
            }
        },
        department = {
            add = {
                title = 'Give A Player A Department Membership (Admin Only)',
                id = { name = 'id', help = 'Player ID' },
                department = { name = 'department', help = 'Department slug' }
            },
            remove = {
                title = 'Remove A Players Department Membership (Admin only)',
                id = { name = 'id', help = 'Player ID' },
                department = { name = 'department', help = 'Department slug' }
            }
        }
    },
    menu = {
        manage = "Manage",
        departments = "Departments",
        qualifications = "Qualifications",
        t_return = "Return",
        department = {
            title = "Manage Departments",
            subtitle = "Department management"
        },
        qualification = {
            title = "Manage Qualifications",
            subtitle = "Qualification management"
        }
    }
}

Lang = Locale:new({
    phrases = Translations,
    warnOnMissing = true
})
