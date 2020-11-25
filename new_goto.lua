local tArgs = {...}
local face = 0
local r = 1
rednet.open("right")
local cx,cy,cz = gps.locate(2,false)
if #tArgs ~= 3 then
  print("Incorrect usage of Function.")
  print("goto <x> <y> <z>")
else
local gx = tonumber(tArgs[1])
local gy = tonumber(tArgs[2])
local gz = tonumber(tArgs[3])
local x
local y
local z
function PL()
  print("Going to:")
  write(gx) write(" ") write(gy) write(" ") print(gz)
  end
function c_face()
if face == 5 then
  face = 1
elseif face == 0 then
  face = 4
end
end
function get_Face()
while turtle.forward() == false do
   if turtle.up() == false then
        turtle.digUp()
   end
  end

nx,ny,nz = gps.locate(3,false)
if nx > cx then
  face = 1
end
if nx < cx then
  face = 3
end
if nz > cz then
  face = 2
end
if nz < cz then
  face = 4
end
end
function calc()
x = nx - gx
y = ny - gy
z = nz - gz
end
function setDir(dir)
while dir ~= face do
  turtle.turnLeft()
  face = face - 1
  c_face()
  end
end
function f()
while not turtle.forward() do
   if not turtle.up()  then
        turtle.digUp()
   end
   y = y + 1
  end
end
function go()
if x < 0 then
  setDir(1)
  while x ~= 0 do
   f()
   x = x + 1
  end
end
if x > 0 then
  setDir(3)
  while x ~= 0 do
   f()
   x = x - 1
  end
end
if z < 0 then
  setDir(2)
  while z ~= 0 do
   f()
   z = z + 1
  end
end
if z > 0 then
  setDir(4)
  while z ~= 0 do
   f()
   z = z - 1
  end
end
while y < 0 do
  if turtle.up() ~= true then
   turtle.digUp()
  end
  y = y + 1
end
while y > 0 do
  if turtle.down() ~= true then
   turtle.digDown()
  end
  y = y - 1
end
end



tonumber(gx)
tonumber(gy)
tonumber(gz)
PL()
get_Face()
calc()
go()

end