home = fs.open("home.mr", "r")

x = tonumber(home.readLine())
y = tonumber(home.readLine())
z = tonumber(home.readLine())


shell.run("goto " .. tostring(x) .. " " .. tostring(y) .. " " .. tostring(z))