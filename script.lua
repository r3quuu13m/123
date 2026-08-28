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

local RunService = game:GetService("RunService")
local Camera = workspace.CurrentCamera

-- Элемент интерфейса для отображения FOV
local HUD = script.Parent.Parent.HUD or Instance.new("ScreenGui")

if not HUD then 
    HUD = Instance.new("ScreenGui")
    HUD.Parent = Players.LocalPlayer
end

HUD.Descendants:clear()

local FOVMeter = Instance.new("TextLabel", HUD)
FOVMeter.Size = UDim2.fromScale(0, 0.15)
FOVMeter.Position = UDim2.fromPercent(0, 0.94, 0, 0) -- Правый нижний угол
FOVMeter.Text = "Fov: "
FOVMeter.Font = Enum.Font.SourceCode
FOVMeter.Color = Color3.new(1, 1, 1)

local ValueText = Instance.new("TextLabel", FOVMeter)
ValueText.Size = UDim2.fromScale(-0.5, -0.5)
ValueText.Position = UDim2.fromScale(0.95, 0) -- Правый нижний угол
ValueText.TextSize = Enum.TextSize.Size64
ValueText.Text = "120"
ValueText.Font = FOVMeter.Font

-- Обновление FOV при каждом кадре
RunService.RenderStepped:connect(function()
    if Camera.FieldOfView == 120 then -- Проверка успешного изменения FOV через инжектор
        ValueText.Text = "120"
    else 
        warn("Ошибка: FOV не установлен в значение 120")
    end
    
end)
