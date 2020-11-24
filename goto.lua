local d_x, d_y, d_z = ...
local s_x, s_y, s_z = gps.locate()

if s_x == nil then
    print("Failed to locate turtle. GPS down?")
    return
end


turtle_avoidance = true

--[[orientation will be:
-x = 1
-z = 2
+x = 3
+z = 4
This matches exactly with orientation in game, except that Minecraft uses 0 for +z instead of 4.
--]]
function getOrientation()
    refuelIfNeed()
    loc1 = vector.new(gps.locate(2, false))
    if not turtle.forward() then
        for j=1,6 do
                if not turtle.forward() then
                    checkTurtleFront()
                    turtle.dig()
            else break end
        end
    end
    loc2 = vector.new(gps.locate(2, false))
    heading = loc2 - loc1
    turtle.back()
    return ((heading.x + math.abs(heading.x) * 2) + (heading.z + math.abs(heading.z) * 3))
end


function refuelIfNeed()
    while turtle.getFuelLevel() <= 0 do
        print("Attempting to refuel")
        for i=1, 16 do
            turtle.select(i)
            turtle.refuel(1)
        end
    end
end

function checkTurtleFront() --Don't break other turtles. Wait for other turtles to finish performing their actions or halt otherwise
    if not turtle_avoidance then
        return
    end

    if turtle.getItemDetail(16) == nil or turtle.getItemDetail(16).name ~= "computercraft:turtle_normal" then
        print("No turtle in the 16th slot!")
    end
    turtle.select(16)

    while turtle.compare() do
        print("waiting front...")
        os.sleep(1)
    end
end

function checkTurtleUp() --Don't break other turtles. Wait for other turtles to finish performing their actions or halt otherwise
    if not turtle_avoidance then
        return
    end

    if turtle.getItemDetail(16).name ~= "computercraft:turtle_normal" then
        print("No turtle in the 16th slot!")
    end
    turtle.select(16)

    while turtle.compareUp() do
        print("waiting up...")
        os.sleep(1)
    end
end

function checkTurtleDown() --Don't break other turtles. Wait for other turtles to finish performing their actions or halt otherwise
    if not turtle_avoidance then
        return
    end

    if turtle.getItemDetail(16).name ~= "computercraft:turtle_normal" then
        print("No turtle in the 16th slot!")
    end
    turtle.select(16)

    while turtle.compareDown() do
        print("waiting down...")
        os.sleep(1)
    end
end


--[[orientation will be:
-x = 1
-z = 2
+x = 3
+z = 4
This matches exactly with orientation in game, except that Minecraft uses 0 for +z instead of 4.
--]]
function faceDir(target_dir)
    local dir = getOrientation()
    -- face the right direction
    if dir ~= target_dir then
        local turns = target_dir - dir
        print(turns)

        if turns > 0 then
            for i = 1, turns do
                print("TURN RIGHT")
                turtle.turnRight()
            end
        elseif turns < 0 then
            for i = 1, 4 + turns do
                print("TURN LEFT")
                turtle.turnLeft()
            end
        end
    end
end

z_diff = d_z - s_z
x_diff = d_x - s_x
y_diff = d_y - s_y

if y_diff > 0 then
    print("Moving along +Y")
    for i = 1, math.abs(y_diff) do
        refuelIfNeed()
        if not turtle.up() then
            refuelIfNeed()
            checkTurtleUp()
            turtle.digUp()
            refuelIfNeed()
            turtle.up()
        end
    end
end

if z_diff > 0 then
    print("Moving along +Z")
    faceDir(4)
elseif z_diff < 0 then
    print("Moving along -Z")
    faceDir(2)
end

-- travel along the Z-axis first
for i = 1, math.abs(z_diff) do
    refuelIfNeed()
    if not turtle.forward() then
        refuelIfNeed()
        checkTurtleFront()
        turtle.dig()
        refuelIfNeed()
        turtle.forward()
    end
end

-- then the X-axis
if x_diff > 0 then
    print("Moving along +X")
    faceDir(3)
elseif x_diff < 0 then
    print("Moving along -X")
    faceDir(1)
end

for i = 1, math.abs(x_diff) do
    refuelIfNeed()
    if not turtle.forward() then
        refuelIfNeed()
        checkTurtleFront()
        turtle.dig()
        refuelIfNeed()
        turtle.forward()
    end
end

-- then the Y-axis

if y_diff < 0 then
    print("Moving along -Y")
    for i = 1, math.abs(y_diff) do
        refuelIfNeed()
        if not turtle.down() then
            refuelIfNeed()
            checkTurtleDown()
            turtle.digDown()
            refuelIfNeed()
            turtle.down()
        end
    end
end


--for i = 1, x_diff do
--    if not turtle.forward() then
--        turtle.dig()
--        turtle.forward()
--    end
--end