rednet.CHANNEL_BROADCAST = 69420

local PROTO = "SWARM"
local HOST = "OBAMA"
local listen_timeout = 60

local keep_alive_freq = 0.5
local keep_alive_timeout = 0

rednet.open("right")

local retry = ...

print("Looking for a master...")
id = rednet.lookup(PROTO, HeOST)

if not id then
    print("Failed to find master with HOST: " .. HOST .. " PROTO: " .. PROTO)
    return
end

print("Found potential master with id: " .. tostring(id))
rednet.send(id, "pair_slave", PROTO)

local id,msg,proto = rednet.receive(PROTO, listen_timeout)

if msg == "pair_master" then
    local master_id = id
else
    print("Paring handhsake failed")
    return
end


function recvCmd()
    while true do
        print("Waiting for instruction from master...")

        while true do
            local id, msg, proto = rednet.receive(PROTO)

            -- lol. hardcode the handhshake msgs we need to ignore
            if msg ~= "pair_master" and msg ~= "am_alive" then
                print(msg)
                shell.run(msg)
                rednet.send(id, "task_finish", PROTO)
            end
        end
    end
end

disconnected = false;
-- only restablishes connections with computers of the same ID
function keepAlive()
  while true do
    rednet.send(id, "keep_alive", PROTO)
    local master_id, msg, proto = rednet.receive(PROTO, keep_alive_timeout)

    if master_id == nil then
      print("Master is unresponsive. Disconnected?")
      disconnected = true
    else
        if disconnected then
            disconnected = false
            print("Connection restablished :)")
        end
    end

    os.sleep(keep_alive_freq)
  end
end

parallel.waitForAll(recvCmd, keepAlive)