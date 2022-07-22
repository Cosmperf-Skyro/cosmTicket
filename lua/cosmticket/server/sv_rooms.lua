local rooms =  {}
local storage = {}

local function mountRoomsToDefault()
    print("Mouting default rooms admin ..")

    for key, pos in ipairs(cosmticket.Config.adminRooms) do
        local room_id = #storage +1
        local room = {
            ["id"] = room_id,
            ["position"] = pos,
            ["admin"] = 0,
            ["admin_oldpos"] = 0,
            ["target"] = 0,
            ["target_oldpos"] = 0,
            ["avaible"] = true
        }

        storage[room_id] = room
    end

    PrintTable(storage)
    print("Default admin rooms mounted !")
end

function rooms.takeRoom(admin, target)
    local self = cosmticket
    local utils = cosmticket.Utils

    if (not utils.IsValidPlayer(admin)) then
        return false, "Bad admin"
    end

    if (not utils.IsValidPlayer(target)) then
        return false, "Bad target"
    end

    local room = rooms.getAvaibleOne()
    if (!room) then
        return false, "All rooms are taken"
    end
    
    room["admin"] = admin
    room["target"] = target
    return room
end

//
function rooms.getAvaibleOne()
    local res = false
    for room_id, room in ipairs(storage) do
        if room["avaible"] then
            res = room
            room["avaible"] = false
            break
        end
    end

    return res
end

function rooms.get(id)
    local room = storage[id]
    return room
end

//
function rooms.teleportTo(id)
    local self = cosmticket
    local utils = cosmticket.Utils

    local room = rooms.get(id)
    if (!room) then
        return false, "Unknow room"
    end

    if (room["avaible"]) then
        return false, "Room is avaible"
    end

    if (not utils.IsValidPlayer(room["admin"])) then
        return false, "Bad admin"
    end

    if (not utils.IsValidPlayer(room["target"])) then
        return false, "Bad target"
    end

    room["admin_oldpos"] = room["admin"]:GetPos()
    room["target_oldpos"] = room["target"]:GetPos()

    room["admin"]:SetPos(room["position"])
    room["target"]:SetPos(room["position"])
    return true
end

function rooms.returnToPosition(id)
    local self = cosmticket
    local utils = cosmticket.Utils

    local room = rooms.get(id)
    if (!room) then
        return false, "Unknow room"
    end

    if (room["avaible"]) then
        return false, "Room is avaible"
    end

    if (not utils.IsValidPlayer(room["admin"])) then
        return false, "Bad admin"
    end

    if (not utils.IsValidPlayer(room["target"])) then
        return false, "Bad target"
    end

    room["admin"]:SetPos(room["admin_oldpos"])
    room["target"]:SetPos(room["target_oldpos"])
    return true
end

function rooms.stopUse(id)
    local room = rooms.get(id)
    if (!room) then
        return false, "Unknow room"
    end

    if (room["avaible"]) then
        return false, "Room is avaible"
    end

    // Reset room data
    room["avaible"] = true
    room["admin"] = 0
    room["admin_oldpos"] = 0
    room["target"] = 0
    room["target_oldpos"] = 0

    return true
end

mountRoomsToDefault()
cosmticket.Rooms = rooms