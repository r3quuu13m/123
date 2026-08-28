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

local UIS = game:GetService("UserInputService")
local Players = game:GetService("Players")

local UIS = game:GetService("UserInputService")
local Players = game:GetService("Players")

PlayerFlying = false

-- Функция для проверки наличия Humanoid в персонаже
function checkHumanoid(obj)
    return obj and (obj:IsA('Model') or obj:IsA('BasePart')) and findmetatable('Character'):FindFirstChild(obj)
end

UIS.InputBegan:Connect(function(input)
	if input.KeyCode == Enum.KeyCode.V then -- Клавиша V для включения/выключения полета
		PlayerFlying = not PlayerFlying
		
		if PlayerFlying then
			warn("Полет активирован!")
			
			game.Players.LocalPlayer.Character.Humanoid.JumpPower = 50
		else
			game.Players.LocalPlayer.Character.Humanoid.JumpPower = -25
		end
			
	end
	
	if input.KeyCode == Enum.KeyCode.W and PlayerFlying then
		game.Players.LocalPlayer.Character.Humanoid:ChangeDirection(0, 16)
		
	elseif input.KeyCode == Enum.KeyCode.A and PlayerFlying then
		
	elseif input.KeyCode == Enum.KeyCode.S and PlayerFlying then
		
	elseif input.KeyCode == Enum KeyCode.D and PlayerFlying then
		
	end
	
end)

-- Обход проверок на перемещение
if game.Players.LocalPlayer.Character:FindFirstChild('Humanoid') then
    local humanoid = game.Players.LocalPlayer.Character.Humanoid
    
    -- Используем скрытые свойства для управления полетом
    gethiddenproperty(humanoid, "CanFly")
    
    -- Включение плавного перемещения при полете
    humanoid.MoveDirection = nil
end

-- Дополнительные инструменты для полета
local function flyMovement(delta)
	if PlayerFlying then
		local userInput = getinput()
		
		-- Обновление вектора движения в зависимости от нажатых клавиш
		local velocity = Instance.new('Vector3')
		
		if userInput.KeyCode == Enum.KeyCode.W then
			velocity.Y += delta * 10 -- Движение вперед (вверх по Y)
		elseif userInput.KeyCode == Enum KeyCode.S then
			velocity.Y -= delta * 10 -- Движение назад (вниз по Y)
		end
		
		-- Применение движения к Humanoid
		humanoid.MoveDirection = velocity
	end
	
end

game:GetService('RunService').Render:waitForHeartbeat(0.5):connect(flyMovement)
