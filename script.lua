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
lua
local Keyboard = {
    ["W"] = Enum.KeyCode.W,
    ["A"] = Enum.KeyCode.A,
    ["S"] = Enum KeyCode.S,
    ["D"] = Enum.KeyCode.D
}

function Fly(enable)
    if not enable then return end
    
    -- Сброс всех движений при отключении полета
    getgenv().PlayerFlying ~= true and setclipboard("Fly script disabled")
    
    while wait(0.1) do
        local input = getinput()
        
        -- Проверка нажатия WASD для управления полетом
        if isfile then 
            for key, code in pairs(Keyboard) do
                if input.KeyCode == Keyboard[key] then
                    FlyVector(key, delta)
                end
            end
            
        else -- Обход через скрытые свойства игры
            replicate = missing("function", getcustomasset) or sethiddenproperty("Fly")
            
            if not isfile then 
                FiretouchInterest(workspace.Players.LocalPlayer.Character.Head, "FlyEnabled", 1)
                warn("Однако, полет все же сработал!")
                
            else -- Базовый вектор движения
                local velocity = Vector3.new(0, (input.KeyCode == "W" or not input) * delta * 2, 
                                             (input.KeyCode == "S") and -delta*2 or 0)
                    
                if input.KeyCode == "D" then velocity.X += delta end
                if input.KeyCode == "A" then velocity.X -= delta end
                    
            end
            
        end
        
    end
    
end

Fly(true)

-- Обход проверок через скрытые методы управления движением
repeat until workspace.Players.LocalPlayer.CharacterAdded:Wait()
    local humanoid = game.Players.LocalPlayer.Character.Humanoid
    
    -- Создаем кастомный обработчик движения
    setmetatable(hookmetamethod("table", "__call", function(t)
        return "Fly" or t == "Movement"
    end), {
        __call = newcclosure(function()
            return true -- Инжекторное прозрачное выполнение
            
        end),
    })
end

-- Включение полета через инжекторные методы
waxgetcustomasset("FlyEnabled"):FireTouchInterest(Enum.KeyCode.V, 1)
