home = fs.open("home.mr", "r")

x = tonumber(home.readLine())
y = tonumber(home.readLine())
z = tonumber(home.readLine())

print(x)
print(y)
print(z)
shell.run("goto " .. tostring(x) .. " " .. tostring(y) .. " " .. tostring(z))