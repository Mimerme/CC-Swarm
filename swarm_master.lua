rednet.CHANNEL_BROADCAST = 69420
local listen_timeout = 60
local PROTO = "SWARM"
local HOST = "OBAMA"

task_queue = {}
slave_status = {}

rednet.open("right")
rednet.host(PROTO, HOST)


debug = ...
if debug == "d" then
    print(">>> DEBUG MODE <<<")
end

print("Starting listening for slaves")

slaves = {}
slave_count = 0


print("Press <Enter> when you're done setting up the slaves")

local function recv()
    id, msg, proto = rednet.receive(PROTO, listen_timeout)
end

local function pull()
    event, key = os.pullEvent("key")
end

while true do
    parallel.waitForAny(recv, pull)

    if id then
        if msg == "pair_slave" or msg == "keep_alive" then
            if task_queue[id] == nil then
                slaves[slave_count] = id
                slave_count = slave_count + 1
                slave_status[id] = false
                task_queue[id] = {}
                print("New slave: " .. tostring(id))
            end
            
            rednet.send(id, "pair_master", PROTO)
        end

    elseif key == keys.enter then
        print("Finished pairing for slaves")
        break
    end

    id = nil
    msg = nil
    proto = nil
    event = nil
    key = nil
end

print("Paired " .. tostring(slave_count) .. " slaves")
rednet.unhost(PROTO)

function Split(s, delimiter)
    chunks = {}
    for substring in s:gmatch("%S+") do
        table.insert(chunks, substring)
    end
    return chunks
end

function table.slice(tbl, first, last, step)
    local sliced = {}
    
    for i = first or 1, last or #tbl, step or 1 do
        sliced[#sliced+1] = tbl[i]
    end

    return sliced
end

function userInput()
    -- fuck u implement goto plz. this entire language is pure evil
    -- https://forums.technicpack.net/topic/23235-computercraft-goto-style-statement/
    while true do
    while true do
        io.output():write("mrmrmr> ")
        local input = io.input():read()
        local splits = Split(input, " ")

        if splits[1] == "test" then
            print("Broadcasting a test message to all computers")
            for k,v in pairs(slaves) do
                print(v)
                rednet.send(v, "This is a test message", PROTO)
            end
        elseif splits[1] == "all" then
            if (#splits < 2) then
                print("Usage: all <shell command>")
                break
            end

            local task = table.concat(table.slice(splits, 2, #splits), " ")
            print("Q-ing task " .. task .. " for all computers ")                

            for id, tasks in pairs(task_queue) do
                table.insert(tasks, task)
            end
        elseif splits[1] == "task" then                
            if (#splits < 3) then
                print("Usage: task <computer ID> <shell command>")
                break
            end

            local target_id = tonumber(splits[2])
            local task = table.concat(table.slice(splits, 3, #splits), " ")
            print("Q-ing task " .. task .. " for computer " .. tostring(target_id))

            if(task_queue[target_id] ~= nil) then
                table.insert(task_queue[target_id], task)
            else
                print("Invalid computer id. Usage: task <computer ID> <shell command>")
                break
            end
        elseif splits[1] == "ls" or splits[1] == "slaves" or splits[1] == "slavikindividuals" then                
            print("=======================================")
            for indexlolishouldvemadethisonedatastructure, slave in pairs(slaves) do
                print("ID: " .. tostring(slave))
                print("------------------------")

                for x, y in pairs(task_queue[slave]) do
                    print(y)
                end

                print("Doing: " .. tostring(slave_status[slave]))
            end    
            print("=======================================")
        elseif splits[1] == "lst" then

            local comp_id = tonumber(splits[2])
            if (task_queue[comp_id] == nil or comp_id == nil) then
                print("Invalid computer id. Usage: lst <computer ID>")
                break
            end

            print("=======================================")

            for x, y in pairs(task_queue[comp_id]) do
                print(y)
            end

            print("Doing: " .. tostring(slave_status[comp_id]))
            print("=======================================")

        end
            
    end
    end
end

function handleQueue()
    while true do
        for id,tasks in pairs(task_queue) do
            --print(id)
            --print(#tasks)
            --print("------------")
            if #tasks ~= 0 and slave_status[id] == false then
                local task = table.remove(tasks)
                if debug == "d" then print("Sending task \"" .. task .. "\" to computer " .. id) end
                rednet.send(id, task, PROTO)
                slave_status[id] = true
            end
        end
        os.sleep(1)
    end
end

function handleDones()
    while true do
        local id, msg, proto = rednet.receive(PROTO)

        if msg == "task_finish" and slave_status[id] == true then
            slave_status[id] = false
        end
    end
end

function keepAlive()
    while true do
        local id, msg, proto = rednet.receive(PROTO)

        if msg == "keep_alive" then
            rednet.send(id, "am_alive", PROTO)
        end
    end
end

parallel.waitForAll(userInput, handleQueue, handleDones, keepAlive)