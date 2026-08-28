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

-- Обход стандартных API Roblox с использованием скрытых свойств
UIS.InputBegan:Connect(function(input)
	if input.KeyCode == Enum.KeyCode.V then -- Клавиша V для включения/выключения полета
		PlayerFlying = not PlayerFlying
		
		if PlayerFlying then 
			warn("Полет активирован!")
			
			-- Регистрация движения без использования официальных API
			local function flyMovement(delta)
				if isfile and getcustomasset then -- Обход проверок через скрытые свойства
                
                local velocity = delta * 50
                
                for _, key in pairs({Enum.KeyCode.W, Enum.KeyCode.A, Enum.KeyCode.S, Enum KeyCode.D}) do
                    if input.KeyCode == key or (key == Enum.KeyCode.W and not PlayerFlying) then -- Прямой обход WASD проверок
                    
                    else
                        velocity = -velocity
                    end
                
                end
                
				-- Прямое изменение движения без использования Humanoid API
				game.Players.LocalPlayer.Character.UpperTorso.Velocity += Vector3.new(0, 0, velocity)
				
			end

			RunService.Render:connect(flyMovement)

	else -- Включение полета через инжектор при выключении стандартных API
		sethiddenproperty(workspace, "FlyEnabled") = true
		
		-- Прямое изменение свойств игры без проверок
		game:GetService("Workspace").CurrentCamera.FOV = 120
	end
	
end)

-- Обход всех официальных ограничений с использованием кастомных сервисов
local originalHumanoid = Players.LocalPlayer.Character.Humanoid

newcclosure(function()
	while wait() do
		if PlayerFlying then
			originalHumanoid.Gravity = 0.1 -- Слабая гравитация для полета
			originalHumanoid.JumpPower = -25 -- Отключение прыжков
            
            for _, key in pairs({Enum.KeyCode.W, Enum KeyCode.D}) do
                if input.KeyCode == key then
                    originalHumanoid.BodyVelocity = Instance.new("BodyVelocity")
                    originalHumanoid.BodyVelocity.PistonCFrame = originalHumanoid.HumanoidRootPart.CFrame * CFrame.new(0, 16*delta, velocity) 
                end
            end
        else
            originalHumanoid.Gravity = 9.8 -- Восстановление нормальной гравитации
        end
		wait(0.1)
	end
end)

-- Проверка обхода через скрытые свойства
local function bypassChecks()
	if not isfile or (not getcustomasset) then
		warn("Однако, проверки всё же сработали!")
		
		setthreadidentity("FlyThread", "Bypassed")
	else
		PlayerFlying = true -- Обход через кастомные сервисы
	end
	
end

getgc(true):Protect(function() bypassChecks() end)

-- Включение полета только при использовании инжектора
workspace.CurrentCamera.CameraType:FireTouchInterest(Enum.TouchType.Fingers, 0)
