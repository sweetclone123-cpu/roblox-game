--!strict

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Config = require(ReplicatedStorage:WaitForChild("RojoShared"):WaitForChild("Config"))

print(string.format("[%s] Client ready", Config.ProjectName))
