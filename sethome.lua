x,y,z = gps.locate(2, true)
fs.delete("home.mr")
home = fs.open("home.mr", "w")

print("Setting home as " .. tostring(x) .. " " .. tostring(y) .. " " .. tostring(z))

home.writeLine(tostring(x))
home.writeLine(tostring(y))
home.writeLine(tostring(z))
home.close()
