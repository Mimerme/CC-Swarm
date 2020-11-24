print("Downloading scripts from pastebin...")
print("MrMrMr Obama")

print("Removing all programs")
shell.run("delete sethome")
shell.run("delete home")
shell.run("delete goto")
shell.run("delete swarm_slave")
shell.run("delete swarm_master")

print("Downloading sethome")
shell.run("wget https://raw.githubusercontent.com/Mimerme/CC-Swarm/main/sethome.lua")

print("Downloading home")
shell.run("wget https://raw.githubusercontent.com/Mimerme/CC-Swarm/main/home.lua")

print("Downloading goto")
shell.run("wget https://raw.githubusercontent.com/Mimerme/CC-Swarm/main/goto.lua")

print("Downloading slave")
shell.run("wget https://raw.githubusercontent.com/Mimerme/CC-Swarm/main/swarm_slave.lua")

print("Downloading master")
shell.run("wget https://raw.githubusercontent.com/Mimerme/CC-Swarm/main/swarm_master.lua")