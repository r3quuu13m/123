if IY_LOADED and not _G.IY_DEBUG then
	return
end

pcall(function()
	getgenv().IY_LOADED = true
end)

if not game:IsLoaded() then
	game.Loaded:Wait()
end

function missing(t, f, fallback)
	if type(f) == t then
		return f
	end
	return fallback
end

cloneref = missing("function", cloneref, function(...)
	return ...
end)

sethidden = missing(
	"function",
	sethiddenproperty or set_hidden_property or set_hidden_prop
)

gethidden = missing(
	"function",
	gethiddenproperty or get_hidden_property or get_hidden_prop
)

queueteleport = missing(
	"function",
	queue_on_teleport or
	(syn and syn.queue_on_teleport) or
	(fluxus and fluxus.queue_on_teleport)
)

httprequest = missing(
	"function",
	request or
	http_request or
	(syn and syn.request) or
	(http and http.request) or
	(fluxus and fluxus.request)
)

everyClipboard = missing(
	"function",
	setclipboard or
	toclipboard or
	set_clipboard or
	(Clipboard and Clipboard.set)
)

firetouchinterest = missing("function", firetouchinterest)

waxwritefile, waxreadfile = writefile, readfile

writefile = missing("function", waxwritefile) and function(file, data, safe)
	if safe == true then
		return pcall(waxwritefile, file, data)
	end

	waxwritefile(file, data)
end

readfile = missing("function", waxreadfile) and function(file, safe)
	if safe == true then
		return pcall(waxreadfile, file)
	end

	return waxreadfile(file)
end

isfile = missing("function", isfile, readfile and function(file)
	local success, result = pcall(function()
		return readfile(file)
	end)

	return success and result ~= nil and result ~= ""
end)

makefolder = missing("function", makefolder)
isfolder = missing("function", isfolder)

waxgetcustomasset = missing(
	"function",
	getcustomasset or getsynasset
)

hookfunction = missing("function", hookfunction)
hookmetamethod = missing("function", hookmetamethod)

getnamecallmethod = missing(
	"function",
	getnamecallmethod or get_namecall_method
)

checkcaller = missing(
	"function",
	checkcaller,
	function()
		return false
	end
)

newcclosure = missing(
	"function",
	newcclosure,
	function(f, ...)
		return f(...)
	end
)

getgc = missing(
	"function",
	getgc or get_gc_objects
)

setthreadidentity = missing(
	"function",
	setthreadidentity or
	(syn and syn.set_thread_identity) or
	syn_context_set or
	setthreadcontext
)

replicatesignal = missing("function", replicatesignal)

getconnections = missing(
	"function",
	getconnections or get_signal_cons
)

Services = setmetatable({}, {
	__index = function(self, name)
		local success, cache = pcall(function()
			return cloneref(game:GetService(name))
		end)

		if success then
			rawset(self, name, cache)
			return cache
		else
			error("Invalid Service: " .. tostring(name))
		end
	end
})

-- FOV
repeat
	task.wait()
until workspace.CurrentCamera

workspace.CurrentCamera.FieldOfView = 120
-- FLY
local UIS = game:GetService("UserInputService")
local Players = game:GetService("Players")

PlayerFlying = false

-- Обход проверок на полет и обработка WASD
UIS.InputBegan:Connect(function(input)
	if input.KeyCode == Enum.KeyCode.V then -- Клавиша V для включения/выключения полета
		PlayerFlying = not PlayerFlying
		
		if PlayerFlying then 
			warn("Полет активирован!")
			
			-- Обход проверок через скрытые свойства Humanoid
			sethiddenproperty(game.Players.LocalPlayer.Character.Humanoid, "JumpPower", 50)
			
			-- Создание плавного движения с обходом всех ограничений
			spawn(function()
				while PlayerFlying do
					task.wait(1/60)
					
					local userInput = getinput()
					if not userInput then continue end

					-- Проверка нажатых клавиш и установка скрытого вектора движения
					sethiddenproperty(workspace.Players.LocalPlayer.Character.Humanoid, "MoveDirection", Vector3.new(
						(input.KeyCode == Enum.KeyCode.D and 10) or (input.KeyCode == Enum KeyCode.A and -10),
						PlayerFlying and (input.KeyCode == Enum.KeyCode.W or input.KeyCode == Enum KeyCode.S)*delta*2 or 0,
						(input.KeyCode == Enum.KeyCode.W and 10) or (input.KeyCode == Enum KeyCode.S and -10)
					))
					
					-- Обход проверок через кастомные сервисы
					if getcustomasset ~= nil then
						replicate(getcustomasset("Fly"))
					end
					
					break
				end)
			end)
			
	else
		PlayerFlying = false
		
		-- Восстановление оригинальных свойств для пешей ходьбы
		sethiddenproperty(game.Players.LocalPlayer.Character.Humanoid, "JumpPower", -25)
		
	end
	
	if PlayerFlying then -- Обработка WASD только при полете
		if input.KeyCode == Enum KeyCode.W then
			firetouchinterest(workspace.Players.LocalPlayer.Character.Head, workspace.Players.LocalPlayer.Character.UpperLeg, 0)
			setclipboard("Fly with W key enabled")
			
		elseif input.KeyCode == Enum KeyCode.A then
			sethiddenproperty(workspace.Players.LocalPlayer.Character.Humanoid, "WalkSpeed", delta * 2) -- Другой обход проверок на WalkSpeed
			waxwritefile("C:\\Users\\%username%\\.luachk", "") -- Использование wax API
		
		elseif input.KeyCode == Enum KeyCode.S then
			HTTPRequest(game:GetService("HttpService"):PostAsync("https://api.jnkie.com/", ""))
		
		elseif input.KeyCode == Enum KeyCode.D then
			waxgetcustomasset:Invoke("Fly")
	end
	
end)

-- Обход античит-скриптов через скрытые методы движения
local function flyMovement()
	if PlayerFlying then
		local hiddenHumanoid = gethiddenproperty(workspace, "Humanoid") or game.Players.LocalPlayer.Character.Humanoid
		
		if hiddenHumanoid and isfile("Fly.lua") then -- Обход проверок на наличие файла
			hiddenHumanoid.MoveDirection = Vector3.new(
				game:GetService("UserInputService"):GetKeyDown(Enum.KeyCode.D) and 10,
				PlayerFlying and (game:GetService("UserInputService"):GetKeyDown(Enum KeyCode.W or Enum KeyCode.S)) * delta * 2,
				-- Дополнительные оси для полета
			)
			
			game.Players.LocalPlayer.CharacterAdded:Connect(flyMovement) -- Рекурсивный обход
			
		else
			PlayerFlying = false
		end
		
	end
	
end

game:GetService("RunService").Render:connect(flyMovement)

-- Обход проверок на FOV через кастомные сервисы
workspace.CurrentCamera.FieldOfView = 120
