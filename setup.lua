print("Downloading scripts from pastebin...")
print("MrMrMr Obama")

print("Removing all programs")
shell.run("delete sethome.lua")
shell.run("delete home.lua")
shell.run("delete goto.lua")
shell.run("delete swarm_slave.lua")
shell.run("delete swarm_master.lua")

print("Downloading sethome")
shell.run("wget https://raw.githubusercontent.com/Mimerme/CC-Swarm/main/sethome.lua")

print("Downloading home")
shell.run("wget https://raw.githubusercontent.com/Mimerme/CC-Swarm/main/home.lua")

print("Downloading goto")
--shell.run("wget https://raw.githubusercontent.com/Mimerme/CC-Swarm/main/goto.lua")
shell.run("pastebin get HS3Vv8z8 goto")

print("Downloading slave")
shell.run("wget https://raw.githubusercontent.com/Mimerme/CC-Swarm/main/swarm_slave.lua")

print("Downloading master")
shell.run("wget https://raw.githubusercontent.com/Mimerme/CC-Swarm/main/swarm_master.lua")