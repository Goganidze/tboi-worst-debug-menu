local TryGetPathForCard = true  --set false to disable unpredictable code





















































local Wtr = 20/13
local ibackthis = {}
if WORSTDEBUGMENU then
	if WORSTDEBUGMENU.ItemList and WORSTDEBUGMENU.ItemList.ModsPath then
		ibackthis.ModsPath = WORSTDEBUGMENU.ItemList.ModsPath
		ibackthis.CardIdToPath = WORSTDEBUGMENU.ItemList.CardIdToPath
	end
end

WORSTDEBUGMENU = RegisterMod("piss shit poop and menu", 1)

local game = Game()
local font = Font()
local sfx = SFXManager()
font:Load("font/upheaval.fnt")
local TextBoxFont = Font()
TextBoxFont:Load("font/pftempestasevencondensed.fnt")
local nilspr = Sprite()

---@type wga_menu
WORSTDEBUGMENU.wma = include("worst gui api")
---@type wga_menu
--WORSTDEBUGMENU.wma = WORSTDEBUGMENU.wma(WORSTDEBUGMENU)

local Menu = WORSTDEBUGMENU

TextBoxFont = Menu.wma.TextBoxFont

local function GenSprite(gfx,anim,frame)
	if gfx and anim then
	local spr = Sprite()
	spr:Load(gfx, true)
	spr:Play(anim)
	if frame then
		spr:SetFrame(frame)
	end
	return spr
	end
end
local function TabDeepCopy(tbl)
    local t = {}
	if type(tbl) ~= "table" then error("[1] is not a table",2) end
    for k, v in pairs(tbl) do
        if type(v) == "table" then
            t[k] = TabDeepCopy(v)
        else
            t[k] = v
        end
    end

    return t
end

local cacheplaces = {}
local function GetPlace(name)
	cacheplaces[name] = cacheplaces[name] or Vector(0,0)
	return cacheplaces[name]
end
local function TakePlace(name, vec)
	cacheplaces[name] = cacheplaces[name] or Vector(0,0)
	cacheplaces[name] = cacheplaces[name] + vec
end


Menu.strings = {
	["Room Name:"] = {en = "Room Name:", ru = "Имя Комнаты:"},
	["Grid:"] = {en = "Grid:", ru = "Клетка:"},
	["ToLog1"] = {en = "To", ru = "В"},
	["ToLog2"] = {en = "Log", ru = "Лог"},
	["TestRun1"] = {en = "Test", ru = "Тест."},
	["TestRun2"] = {en = "run", ru = "прогон"},
	["Cancel"] = {en = "Cancel", ru = "Отмена"},
	["Ok"] = {en = "Ok", ru = "Ок"},
	["emptyField"] = {en = "the field is empty", ru = "поле пустое"},
	["rooms"] = {en = "rooms", ru = "комнаты"},
	["incorrectNumber"] = {en = "number is incorrect", ru = "число некорректно"},
	["ExistRoomName"] = {en = "a room with this name already exists", ru = "комната с таким именем уже существует"},
	["Transition Name"] = {en = "The name of this transition", ru = "Имя данного перехода"},
	["Transition Target"] = {en = "Room name to transition", ru = "Имя комнаты для перехода"},
	["Transition TargetPoint"] = {en = "Name of the linked spawn point", ru = "Имя связанной точки спавна"},
	["Back"] = {en = "Back", ru = "Назад"},
	["newroom"] = {en = "New room", ru = "Новая комната"},
	["anotherFile"] = {en = "another file", ru = "другой файл"},
	["anm2FileFail"] = {en = "file not found", ru = "файл не найден"},
	["AnmFile"] = {en = "animation file", ru = "файл с анимациями"},
	["AnimName"] = {en = "name of the animation", ru = "название анимации"},
	["AnimOVerlayName"] = {en = "name of the overlay", ru = "название оверлейной анимации"},
	["Auto"] = {en = "Auto", ru = "Авто"},
	["layer"] = {en = "layer", ru = "слой"},
	["Rotation"] = {en = "Rotation", ru = "Поворот"},
	["use_alt_skin"] = {en = "use an alt skin", ru = "использовать альт. окрас"},

	["DefSpawnPoint"] = {en = "There must be only one DEF spawn point in the room", ru = "В комнате должна быть только одна DEF точка спавна"},
	["addEnvitext1"] = {en = "green square should completely", ru = "зелёный квадрат должен полностью"},
	["addEnvitext2"] = {en = "cover the sprite", ru = "закрывать спрайт"},
	["addEnviVisualBox"] = {en = "visual size of the sprite", ru = "визуальная коробка спрайта"},
	["addEnviSize"] = {en = "size", ru = "размер"},
	["addEnviPivot"] = {en = "offset", ru = "смещение"},
	["addEnviPos"] = {en = "position", ru = "позиция"},
	["spawnpoint_name"] = {en = "The name of this spawn point", ru = "Имя данной точки спавна"},
	["special_obj_name"] = {en = "name", ru = "Имя"},
	["nameTarget"] = {en = "target name", ru = "Имя цели"},
	["collisionMode"] = {en = "collision mode", ru = "режим коллизии"},
	["collisionMode1"] = {en = "along the edges", ru = "по краям"},
	["collisionMode2"] = {en = "only inside", ru = "только внутри"},
	["Scriptname"] = {en = "Script name", ru = "название скрипта"},

	["roomlist_hint"] = {en = nil, ru = "открывает список загруженных комнат"},
	["triggerNoTarget"] = {en = "Doesn't have a target", ru = "Отсутствует цель"},
	["ObjBlockedbyObj"] = {en = "overlapped on object layer [3]", ru = "перекрыто на слое объектов [3]"},

	--["spawn"] = {en = "spawn", ru = "спавн"},
	["EntSpawner odin"] = {en = "spawns at the point of click", ru = "спавн в точке клика"},
	["EntSpawner mnogo"] = {en = "creates a spawn point \n at the click point", ru = "создать точку спавна в точке клика"},
	["removeAllSpawnpoint"] = {en = "remove all spawn points", ru = "убрать все точки спавна"},
	["nasadSpawnpoint"] = {en = "remove the last spawn point", ru = "убрать последную точку спавна"},
	["povtorSpawnpoint"] = {en = "repeat last spawn", ru = "повторить последний спавн"},

	["scale"] = {en = "scale", ru = "размер"},
	["frame"] = {en = "frame", ru = "кадр"},
	['overlay frame'] = {en = "overlay frame", ru = "кадр оверлея"},
	["animation"] = {en = "animation", ru = "анимация"},
	["color"] = {en = "color", ru = "цвет"},
	["file"] = {en = "file", ru = "файл"},
	["removeoverlaylayer"] = {en = "remove overlay", ru = "убрать оверлей"},
	["overlaylayerchange"] = {en = "swap overlay and main animation", ru = "поменять местами оверлей и основную анимацию"},

	["playerindex"] = {en = "player", ru = "игрок"},
	["activeslot"] = {en = "slot for active item \n 1-main \n 2-schoolbag \n 3-pocket \n 4-dice bag", 
	ru = "слот для активки \n 1-основной \n 2-рюкзак \n 3-карманный \n 4-одноразовый карманный"},
	["useless_poisk"] = {en = "This button doesn't do anything \n It's just for clarity", ru = "Это кнопка ничего не делает, \n просто для наглядности"},
	["SpawnOnpedestal"] = {en = "spawn an item on a pedestal", ru = "спавн предмета на пьедестале"},

	["luamod_hintText"] = {en = "Reloads this menu",
		ru = "Перезагружает данное меню"},

	["debug_cmd_hint"] = {en = "Opens a quick access window\n to the console command \"debug\"",
		ru = "Открывает окно быстрого доступа \n к консольной команде \"debug\" "},

	["Stages_Selector_hint"] = {en = "Opens the Stages Selector window. \n supported StageAPI floors",
		ru = "Открывает окно с выбором этажей. \n поддерживаются этажи StageAPI"},

	["Ent_Spawner_Menu_hintText"] = {en = "Opens the entity spawning window. \n LMB to place",
		ru = "Открывает окно спавна сущностей. \n ЛКМ - поставить"},

	["Grid_Spawner_Menu_hintText"] = {en = "Opens the window of spwning grid elements. \n LMB to place, RMB to remove",
		ru = "Открывает окно спавна элементов сетки. \n ЛКМ - поставить, ПКМ - убрать"},

	["Anim_Test_Menu_hintText"] = {en = "Opens a window to view \n animations, colors",
		ru = "Открывает окно для просмотра \n анимаций, цветов"},

	["Item_List_Menu_hintText"] = {en = "Opens a window for giving out \n items, trinkets and cards. \n LMB to add, RMB to remove",
		ru = "Открывает окно выдачи \n предметов, брелоков и карт. \n ЛКМ - добавить, ПКМ - убрать"},

	["Sound_Test_Menu_hintText"] = {en = "Opens a window for sound test. \n Records used sounds",
		ru = "Открывает окно для теста звуков. \n Записывает используемые звуки"},

	["ByType"] = {en = "by type", ru = "по типу"},
	["itemlist_gulp"] = {en = "add as gulped", ru = "добавить как проглоченный"},
	["itemlist_gold"] = {en = "create as golden", ru = "сделать золотым"},
	["quality"] = {en = "quality", ru = "качество"},
	["max"] = {en = "max", ru = "макс"},
	["min"] = {en = "min", ru = "мин"},

	["volume"] = {en = "volume", ru = "громк."},
	["volume_rus_unshort"] = {en = "volume", ru = "громкость"},
	["pitch"] = {en = "pitch", ru = "питч"},
	["pan"] = {en = "pan", ru = "пан."},
	["pan_rus_unshort"] = {en = "pan", ru = "панорамирование"},
	["manual_sound"] = {en = "manually:", ru = "ручной id:"},
	["sound_record"] = {en = "sounds recording", ru = "запись звуков"},

	["ent_status"] = {en = "status", ru = "статусы"},
}

local function GetStr(str)
	if Menu.strings[str] then
		return Menu.strings[str][Options.Language] or Menu.strings[str].en or str
	else
		return str
	end
end


WORSTDEBUGMENU.UIs = {}
local UIs = {}  --WORSTDEBUGMENU.UIs
UIs.MenuUp = GenSprite("gfx/editor/ui copy.anm2","фон_вверх")
--function UIs.RoomEditor_debug() return GenSprite("gfx/editor/ui copy.anm2","room_editor_debug") end
--function UIs.luamod_debug() return GenSprite("gfx/editor/ui copy.anm2","luamod_debug") end
UIs.RoomEditor_debug = GenSprite("gfx/editor/ui copy.anm2","room_editor_debug")
UIs.luamod_debug = GenSprite("gfx/editor/ui copy.anm2","luamod_debug")
UIs.Var_Sel = GenSprite("gfx/editor/ui copy.anm2","sel_var", 2)
UIs.DebugCMD = GenSprite("gfx/editor/ui copy.anm2","debugcmd")
for i=1,15 do
	UIs["debugbtn" .. i] = GenSprite("gfx/editor/ui copy.anm2","debug"..i)
end
UIs.CloseBtn = GenSprite("gfx/editor/ui copy.anm2","закрыть")
UIs.textbox_custom = GenSprite("gfx/editor/ui copy.anm2","textbox_custom")
UIs.Chlen_1 = GenSprite("gfx/editor/ui copy.anm2","1 chel")
UIs.Chlen_multi = GenSprite("gfx/editor/ui copy.anm2","multi chlen")
UIs.reset = GenSprite("gfx/editor/ui copy.anm2","reset")
UIs.nasad = GenSprite("gfx/editor/ui copy.anm2","откат")
UIs.entspawnerpoint = GenSprite("gfx/editor/ui copy.anm2","точка спавна")
UIs.EntSpawner = GenSprite("gfx/editor/ui copy.anm2","ent spawn")
UIs.StageChanger = GenSprite("gfx/editor/ui copy.anm2","stage changer")
UIs.GrabMainMenu = GenSprite("gfx/editor/ui copy.anm2","хваталка")
UIs.GrabMainMenu.Color = Color(1,1,1,.5)
UIs.HintTextBG1 = GenSprite("gfx/editor/ui copy.anm2","фон_для_вспом_текста")
UIs.HintTextBG2 = GenSprite("gfx/editor/ui copy.anm2","фон_для_вспом_текста",1)
UIs.CCCCCCCC = GenSprite("gfx/editor/ui copy.anm2","брос")
UIs.MouseLockBtn = GenSprite("gfx/editor/ui copy.anm2","mouse lock")
UIs.MouseIsLocked = GenSprite("gfx/editor/ui copy.anm2","mouseIsLock")
UIs.GridSpawner = GenSprite("gfx/editor/ui copy.anm2","grid spawn")
UIs.AnimTaste = GenSprite("gfx/editor/ui copy.anm2","anim test")
UIs.Editbtn = GenSprite("gfx/editor/ui copy.anm2","editthis")

function UIs.CounterSmol() return GenSprite("gfx/editor/ui copy.anm2","счётчик_smol") end
function UIs.EmptyBtn() return GenSprite("gfx/editor/ui copy.anm2","empty btn") end
function UIs.reset() return GenSprite("gfx/editor/ui copy.anm2","reset") end
function UIs.nasad() return GenSprite("gfx/editor/ui copy.anm2","откат") end
function UIs.CCCCCCCC() return GenSprite("gfx/editor/ui copy.anm2","брос") end
function UIs.Chlen_1() return GenSprite("gfx/editor/ui copy.anm2","1 chel") end
function UIs.CounterUpSmol() return GenSprite("gfx/editor/ui copy.anm2","поднять_smol") end
function UIs.CounterDownSmol() return GenSprite("gfx/editor/ui copy.anm2","опустить_smol") end
function UIs.PrePage16() return GenSprite("gfx/editor/ui copy.anm2","лево_smol") end
function UIs.NextPage16() return GenSprite("gfx/editor/ui copy.anm2","право_smol") end
function UIs.Flag() return GenSprite("gfx/editor/ui copy.anm2","флажок") end



WORSTDEBUGMENU.MainOffset = Vector(0, 10)
function Menu.DebugMenuRender(off, mousepos)
	Menu.MainOffset = Vector(Menu.MainOffset.X, off)
	local MenuUpPos = Vector(Isaac.GetScreenWidth()/2, -50 + off)
	UIs.MenuUp.Color = Color(1,1,1,0.5)
	UIs.MenuUp:Render(MenuUpPos)
	UIs.MenuUp.Color = Color(1,1,1,1)

	if not WORSTDEBUGMENU.showMainMenu then
		Menu.wma.DetectMenuButtons("__debug_menu_grab")
		Menu.wma.RenderMenuButtons("__debug_menu_grab")
	else
		Menu.wma.DetectMenuButtons("__debug_menu")
		Menu.wma.RenderMenuButtons("__debug_menu")
	end
	
end

do
	Menu.PosForBtn = Vector(52,5) --Vector(222,5)

	local nilspr = Sprite()
	--"__debug_menu"
	function WORSTDEBUGMENU.AddButtonOnDebugBar(buttonName, size, sprite, pressFunc, renderFunc)
		local curPos = Menu.PosForBtn/1
		local self
		self = WORSTDEBUGMENU.wma.AddButton("__debug_menu", buttonName, curPos, size.X, size.Y, nilspr, pressFunc, renderFunc)
		self.posfunc = function()
			self.pos = Vector(curPos.X+Menu.MainOffset.X, curPos.Y+Menu.MainOffset.Y)
		end
		self.render = function(pos)
			--local ScrX = Isaac.GetScreenWidth()
			if sprite then
				sprite:SetFrame(self.IsSelected and 1 or 0)
				sprite:Render(pos,Vector(math.max(0, 52 - pos.X),0))
			end
			if renderFunc then
				renderFunc(pos, Vector(math.max(0, 52 - pos.X),0))
			end
		end
		Menu.PosForBtn.X = Menu.PosForBtn.X + size.X + 2
		return self
	end

	Menu.PlaceModeData = {}

	---@param name any
	---@param press fun(MouseBtn:integer, Mousepos:Vector)
	---@param logic fun(pos:Vector)
	---@param loss function
	function WORSTDEBUGMENU.PlaceMode(name, press, logic, loss)
		if name and logic then
			local prename = Menu.PlaceModeData.name
			if Menu.PlaceModeData.loss then
				Menu.PlaceModeData.loss()
			end
			if prename ~= name then
				Menu.PlaceModeData = {name = name, press = press, logic = logic, loss = loss}
			else
				Menu.PlaceModeData = {}
			end
		end
	end

	function Menu.isPlaceMode(name)
		return Menu.PlaceModeData.name and Menu.PlaceModeData.name == name
	end

	function Menu.RemoveOlaceModeByName(name)
		if Menu.PlaceModeData and Menu.PlaceModeData.name == name then
			Menu.PlaceModeData = {}
		end
	end

	function Menu.PlaceRender()
		if game:IsPaused() then return end
		local place = Menu.PlaceModeData
		if place then
			if place.logic then
				place.logic(Menu.wma.MousePos)
			end
			if place.press then
				if Menu.wma.IsMouseBtnTriggered(0) then
					place.press(0, Input.GetMousePosition(true))
				elseif Menu.wma.IsMouseBtnTriggered(1) then
					place.press(1, Input.GetMousePosition(true))
				end
			end
		end
	end

	Menu:AddCallback(ModCallbacks.MC_POST_RENDER, Menu.PlaceRender)

end

local grab1
local grab2
grab1 = WORSTDEBUGMENU.wma.AddButton("__debug_menu_grab", "grab", Vector(12,5), 64, 16, UIs.GrabMainMenu, function(button) 
	if button ~= 0 then return end
	WORSTDEBUGMENU.showMainMenu = true
end)
grab2 = WORSTDEBUGMENU.wma.AddButton("__debug_menu", "grab", Vector(12,-25), 64, 16, UIs.GrabMainMenu, function(button) 
	if button ~= 0 then return end
	WORSTDEBUGMENU.showMainMenu = false
end)
grab1.posfunc = function()
	grab1.pos = Vector(Isaac.GetScreenWidth() - 66, 50+Menu.MainOffset.Y)
end
grab2.posfunc = function()
	grab2.pos = Vector(Isaac.GetScreenWidth() - 66, 50+Menu.MainOffset.Y)
end
--WORSTDEBUGMENU.wma.ButtonSetHintText("__debug_menu", "open_editor", "test text")

local grab3
grab3 = Menu.wma.AddScrollBar("__debug_menu","moverX",Vector(52,-30),Vector(Isaac.GetScreenWidth()-120,10),nil,nil,
function(button, value)
	if button ~= 0 then return end
	Menu.MainOffset.X = -value -- (value-1) * grab3.x -- (value-.5) * 100
end,
function(pos, visible)
	if visible then
		Menu.wma.RenderCustomTextBox(pos+Vector(0,2),Vector(grab3.x,grab3.y-4),false)
	end
end,0.5,0,160)
grab3.posfunc = function()
	grab3.x = Isaac.GetScreenWidth()-120
	grab3.pos = Vector(52, 45+Menu.MainOffset.Y)
	grab3.endValue = Menu.PosForBtn.X-52
	grab3.visible = grab3.endValue > grab3.x
	grab3.canPressed = grab3.visible
end



local self
self = WORSTDEBUGMENU.wma.AddButton("__debug_menu", "mouseLock", Vector(4,-25), 16, 16, UIs.MouseLockBtn, function(button) 
	if button ~= 0 then return end
	Options.MouseControl = not Options.MouseControl
	--UIs.MouseIsLocked:SetFrame(Options.MouseControl and 0 or 1)
end,
function(pos)
	UIs.MouseIsLocked:SetFrame(Options.MouseControl and 0 or 1)
	UIs.MouseIsLocked:Render(pos)
end)
self.posfunc = function()
	self.pos = Vector(1,5+Menu.MainOffset.Y)
end

UIs.ShowMouse = GenSprite("gfx/editor/ui copy2.anm2","mouse_visible1")
UIs.ShowMouse1 = GenSprite("gfx/editor/ui copy2.anm2","mouse_visible")
local self
self = WORSTDEBUGMENU.wma.AddButton("__debug_menu", "mouseshow", Vector(4,-25), 16, 16, UIs.ShowMouse, function(button) 
	if button ~= 0 then return end
	Menu.wma.ShowFakeMouse = not Menu.wma.ShowFakeMouse
end,
function(pos)
	UIs.ShowMouse1:SetFrame(Menu.wma.ShowFakeMouse and 0 or 1)
	UIs.ShowMouse1:Render(pos)
end)
self.posfunc = function()
	self.pos = Vector(1,22+Menu.MainOffset.Y)
end

local function GetCurrentModPath() --эпитани
	if not debug then
		--use some very hacky trickery to get the path to this mod
		local _, err = pcall(require, "")
		local _, basePathStart = string.find(err, "no file '", 1)
		local _, modPathStart = string.find(err, "no file '", basePathStart)
		local modPathEnd, _ = string.find(err, ".lua'", modPathStart)
		local modPath = string.sub(err, modPathStart+1, modPathEnd-1)
		modPath = string.gsub(modPath, "\\", "/")

		return modPath
	else
		local _, _err = pcall(require, "")				-- require a file that doesn't exist
		-- Mod:Log(_err)
		for str in _err:gmatch("no file '.*/mods/.-.lua'\n") do
			return str:sub(1, -7):sub(10)
		end
	end
end
do
	local path = GetCurrentModPath()
	Menu.Path = path
	local fz,fx = string.find(path,"mods/[%S%s]-/")
	local luamodPath = string.sub(path,fz+5,fx-1)

	WORSTDEBUGMENU.AddButtonOnDebugBar( "luamod", Vector(32,32), UIs.luamod_debug, 
	function(button) 
		if button ~= 0 then return end
		Isaac.ExecuteCommand("luamod " .. luamodPath)
	end)
	Menu.wma.ButtonSetHintText("__debug_menu", "luamod", GetStr("luamod_hintText"))
end



WORSTDEBUGMENU.debugcmd_Menu = {active = false, pos = Vector(0,0), name = "_debugcmd"}
local debugcmd = WORSTDEBUGMENU.debugcmd_Menu

do
	local sizev =  Vector(14*19,40)

	WORSTDEBUGMENU.AddButtonOnDebugBar("debugcmd_Menu", Vector(32,32), UIs.DebugCMD, 
	function(button) 
		if button ~= 0 then return end
		debugcmd.active = not debugcmd.active
		debugcmd.pos = self.pos + Vector(0, 30)
		WORSTDEBUGMENU.wma.ShowWindow(debugcmd.name, debugcmd.pos, sizev)
	end)

	Menu.wma.ButtonSetHintText("__debug_menu", "debugcmd_Menu", GetStr("debug_cmd_hint"))

	---------
	for i=1,14 do
		local self
		self = WORSTDEBUGMENU.wma.AddButton("_debugcmd", "debug"..i, Vector(i*18-14,13), 18, 17, UIs["debugbtn" .. i] , function(button) 
			if button ~= 0 then return end
			Isaac.ExecuteCommand("debug " .. i)
			self.IsActived = not self.IsActived
		end, function(pos)
			if self.IsActived then
				UIs.Var_Sel:Render(self.pos + Vector(2,12))
			end
		end)
	end



	local MouseOldPos, OldRenderPos = Vector(0,0), Vector(0,0)
	function Menu.DebugCmdRender(mousepos)
		--if debugcmd.CanMove then
			if debugcmd.CanMove and Input.IsMouseBtnPressed(0) then
				local offset = mousepos - MouseOldPos
				debugcmd.pos = OldRenderPos + offset
			else
				MouseOldPos = mousepos/1
				OldRenderPos = debugcmd.pos/1
				debugcmd.CanMove = false
			end
		--end
		--WORSTDEBUGMENU.wma.RenderCustomMenuBack(debugcmd.pos,sizev)
		--WORSTDEBUGMENU.wma.DetectSelectedButton(WORSTDEBUGMENU.debugcmd_Menu.name)
		--WORSTDEBUGMENU.wma.RenderMenuButtons(WORSTDEBUGMENU.debugcmd_Menu.name)
	end

	Menu:AddCallback(ModCallbacks.MC_PRE_GAME_EXIT, function()
		for i=1,14 do
			Menu.wma.GetButton("_debugcmd", "debug"..i).IsActived = false
		end
	end)
end


do

	local MouseIsMoved = false
	local oldMousePos = Isaac.WorldToScreen(Input.GetMousePosition(true))-game.ScreenShakeOffset
	oldMousePos = oldMousePos.X + oldMousePos.Y
	local mousedalay = 0
	local menuOffset = 35

	function Menu.DebugMenu(_, name)
		if name ~= "WMA-RenderAboveHUD" then return end
		if Isaac_Tower and (Isaac_Tower.InAction or Isaac_Tower.editor.InEditor) then return end
		
		if not game:IsPaused() then
			if not Menu.wma.IsStickyMenu then
				Menu.wma.SelectedMenu = "__debug_menu"
			end
			Menu.wma.MouseHintText = nil

			local pos = Isaac.WorldToScreen(Input.GetMousePosition(true))-game.ScreenShakeOffset
			local check = pos.X+pos.Y
			if oldMousePos ~= check and math.abs(oldMousePos - check) > 3 then
				oldMousePos = check
				MouseIsMoved = true
				mousedalay = 60
				--menuOffset = 0
			end
			mousedalay = math.max(0,mousedalay-1)
			if not Menu.showMainMenu then
				if mousedalay<=0 then
					MouseIsMoved = false
					menuOffset = menuOffset * 0.9 + 60 * 0.1
				else
					menuOffset = menuOffset * 0.9 + 50 * 0.1
				end
			else
				menuOffset = menuOffset * 0.9
			end

			Menu.wma.MousePos = pos
			
			--WORSTDEBUGMENU.wma.HandleWindowControl()
			if MouseIsMoved or menuOffset < 60 then
				Menu.DebugMenuRender(-menuOffset, pos)
			end

			--if debugcmd.active then
			--	WORSTDEBUGMENU.DebugCmdRender(pos)
			--end
			Menu.wma.HandleWindowControl()
			Menu.wma.RenderWindows()

			Menu.wma.DetectSelectedButtonActuale()
			if Menu.wma.MouseHintText then
				local pos = Menu.wma.MousePos
				--DrawStringScaledBreakline(font, Isaac_Tower.editor.MouseHintText, pos.X, pos.Y, 0.5, 0.5, KColor(0.1,0.1,0.2,1), 60, "Left")
				Menu.wma.RenderButtonHintText(Menu.wma.MouseHintText, pos+Vector(8,8))
			end

			Menu.wma.LastOrderRender()
		end

		--local spr = GenSprite("gfx/editor/aaaatest.anm2", "1")
		--spr:Render(Vector(200,200))

	end

	Menu:AddCallback(ModCallbacks.MC_GET_SHADER_PARAMS, Menu.DebugMenu)

end

do
	WORSTDEBUGMENU.StageSel = {name = "Stages_Selector", size = Vector(126,219), pos = Vector(87,35), btn = {}}
	local StageSel = WORSTDEBUGMENU.StageSel
	local sizev = StageSel.size

	--[[local self
	self = WORSTDEBUGMENU.wma.AddButton("__debug_menu", "Stages_Selector_Menu", Vector(120,5), 32, 32, UIs.StageChanger, function(button) 
		if button ~= 0 then return end
		---@type Window
		StageSel.wind = WORSTDEBUGMENU.wma.ShowWindow(StageSel.name, StageSel.pos, sizev)
		Menu.StageSel.DefaultSpawnButton()
	end)
	self.posfunc = function()
		self.pos = Vector(120, 5+Menu.MainOffset.Y)
	end]]

	local self
	self = Menu.AddButtonOnDebugBar("Stages_Selector_Menu", Vector(32, 32), UIs.StageChanger, function(button) 
		if button ~= 0 then return end
		---@type Window
		StageSel.wind = WORSTDEBUGMENU.wma.ShowWindow(StageSel.name, StageSel.pos, sizev)
		Menu.StageSel.DefaultSpawnButton()
	end)
	Menu.wma.ButtonSetHintText("__debug_menu","Stages_Selector_Menu",GetStr("Stages_Selector_hint"))

	local function GenSprite2(anm2, anim, frame0, frame2)
		local spr = GenSprite(anm2, anim)
		if frame0 then spr:SetLayerFrame(0, frame0) end
		if frame2 then spr:SetLayerFrame(2, frame2) end
		spr.Offset = Vector(14,4)
		spr.Scale = Vector(.7,.7)
		return spr
	end

	--[[for i=0, 27 do
		local spr = GenSprite("gfx/ui/customTransition/progress.anm2", "Levels")
		spr:SetLayerFrame(0, i)
		StageSel.sprs[i] = spr
	end
	StageSel.stageGoto = {
		""
	}]]
	local nilspr = Sprite()

	local anm2 = "gfx/ui/customTransition/progress.anm2"
	StageSel.btn = {
		{
			{spr = GenSprite2(anm2, "Levels", 0, 1), GoTo = "1"}, {spr = GenSprite2(anm2, "Levels", 1, 1), GoTo = "1a"},
			{spr = GenSprite2(anm2, "Levels", 2, 1), GoTo = "1b"}, {spr = GenSprite2(anm2, "Levels", 19, 1), GoTo = "1c"},
			{spr = GenSprite2(anm2, "Levels", 20, 1), GoTo = "1d"}
		},
		{
			{spr = GenSprite2(anm2, "Levels", 0, 2), GoTo = "2"}, {spr = GenSprite2(anm2, "Levels", 1, 2), GoTo = "2a"},
			{spr = GenSprite2(anm2, "Levels", 2, 2), GoTo = "2b"}, {spr = GenSprite2(anm2, "Levels", 19, 2), GoTo = "2c"},
			{spr = GenSprite2(anm2, "Levels", 20, 2), GoTo = "2d"}
		},
		{
			{spr = GenSprite2(anm2, "Levels", 3, 1), GoTo = "3"}, {spr = GenSprite2(anm2, "Levels", 4, 1), GoTo = "3a"},
			{spr = GenSprite2(anm2, "Levels", 5, 1), GoTo = "3b"}, {spr = GenSprite2(anm2, "Levels", 21, 1), GoTo = "3c"},
			{spr = GenSprite2(anm2, "Levels", 22, 1), GoTo = "3d"}
		},
		{
			{spr = GenSprite2(anm2, "Levels", 3, 2), GoTo = "4"}, {spr = GenSprite2(anm2, "Levels", 4, 2), GoTo = "4a"},
			{spr = GenSprite2(anm2, "Levels", 5, 2), GoTo = "4b"}, {spr = GenSprite2(anm2, "Levels", 21, 2), GoTo = "4c"},
			{spr = GenSprite2(anm2, "Levels", 22, 2), GoTo = "4d"}
		},
		{
			{spr = GenSprite2(anm2, "Levels", 6, 1), GoTo = "5"}, {spr = GenSprite2(anm2, "Levels", 7, 1), GoTo = "5a"},
			{spr = GenSprite2(anm2, "Levels", 8, 1), GoTo = "5b"}, {spr = GenSprite2(anm2, "Levels", 23, 1), GoTo = "5c"},
			{spr = GenSprite2(anm2, "Levels", 24, 1), GoTo = "5d"}
		},
		{
			{spr = GenSprite2(anm2, "Levels", 6, 2), GoTo = "6"}, {spr = GenSprite2(anm2, "Levels", 7, 2), GoTo = "6a"},
			{spr = GenSprite2(anm2, "Levels", 8, 2), GoTo = "6b"}, {spr = GenSprite2(anm2, "Levels", 23, 2), GoTo = "6c"},
			{spr = GenSprite2(anm2, "Levels", 24, 2), GoTo = "6d"}
		},
		{
			{spr = GenSprite2(anm2, "Levels", 9, 1), GoTo = "7"}, {spr = GenSprite2(anm2, "Levels", 10, 1), GoTo = "7a"},
			{spr = GenSprite2(anm2, "Levels", 11, 1), GoTo = "7b"}, {spr = GenSprite2(anm2, "Levels", 25, 1), GoTo = "7c"},
		},
		{
			{spr = GenSprite2(anm2, "Levels", 9, 2), GoTo = "8"}, {spr = GenSprite2(anm2, "Levels", 10, 2), GoTo = "8a"},
			{spr = GenSprite2(anm2, "Levels", 11, 2), GoTo = "8b"}, {spr = GenSprite2(anm2, "Levels", 25, 2), GoTo = "8c"},
		},
		{ {spr = GenSprite2(anm2, "Levels", 12, 0), GoTo = "9"} },
		{
			{spr = GenSprite2(anm2, "Levels", 13, 0), GoTo = "10"}, {spr = GenSprite2(anm2, "Levels", 14, 0), GoTo = "10a"},
		},
		{
			{spr = GenSprite2(anm2, "Levels", 15, 0), GoTo = "11"}, {spr = GenSprite2(anm2, "Levels", 16, 0), GoTo = "11a"},
		},
		{ {spr = GenSprite2(anm2, "Levels", 18, 0), GoTo = "12"} },
		{ {spr = GenSprite2(anm2, "Levels", 27, 1), GoTo = "13"}, {spr = GenSprite2(anm2, "Levels", 27, 2), GoTo = "13a"} },
	}
	local IgnoreList = {Necropolis=true, ["Catacombs XL"]=true,
		["Utero Greed"]=true,["Necropolis Greed"]=true,["Necropolis XL"]=true,
		["Utero XL"]=true,["Utero 2"]=true,["Catacombs"]=true,
		["Necropolis 2"]=true,["Catacombs Greed"]=true,["Catacombs 2"]=true,
		["Utero"]=true,}


	local toClear = {}

	function Menu.StageSel.ClearStageButton()
		for i=1,#toClear do
			Menu.wma.RemoveButton(StageSel.name, toClear[i], true)
		end
	end

	function Menu.StageSel.DefaultSpawnButton()
		StageSel.StageAPI = false
		Menu.StageSel.ClearStageButton()
		for i,k in pairs(StageSel.btn ) do
			for j, stage in pairs(k) do
				local sel = false

				local pos = Vector(j*22-24,i*13+6)
				pos.Y = pos.Y + math.ceil(math.min(9,i)/2)*3

				---@type EditorButton
				local self
				self = WORSTDEBUGMENU.wma.AddButton(StageSel.name, i..","..j, pos, 20, 14, nilspr, function(button) 
					if button ~= 0 then return end
					Isaac.ExecuteCommand("stage "..stage.GoTo)
				end, function(pos)
					stage.spr:Render(pos)
					if not sel and self.IsSelected then
						sel = true
						stage.spr:SetLayerFrame(3,1)
					elseif not self.IsSelected and sel then
						stage.spr:SetLayerFrame(3,0)
						sel = false
					end
				end)
				toClear[#toClear+1] = i..","..j
			end
		end
	end
	function Menu.StageSel.StageAPISpawnButton()
		Menu.StageSel.ClearStageButton()
		if StageAPI then
			--StageSel.StageAPI = true
			local shitpiss = GenSprite2(anm2, "Levels", 27, 2)
			shitpiss:SetLayerFrame(3,1)
			local stageList = {}
			local localIgnore = {}
			for i, stage in pairs(StageAPI.CustomStages) do
				if not IgnoreList[i] and not localIgnore[i] and not string.find(i,"XL") and not string.find(i," 2") then
					local index = #stageList+1
					stageList[index] = {stage}
					if StageAPI.CustomStages[i .. " 2"] then
						stageList[index][#stageList[index]+1] = StageAPI.CustomStages[i .. " 2"]
						localIgnore[i .. " 2"] = true
					end
				end
			end
			StageSel.StageAPI = #stageList
			for i,k in pairs(stageList ) do
				for j,stage in pairs(k) do
					local sel = false
					
					local pos = Vector(j*22-24,i*13+6)
					pos.Y = pos.Y + math.ceil(math.min(9,i)/2)*3

					local spr = GenSprite2("stageapi/transition/progress.anm2", "Levels")
					if stage.TransitionIcon then
						spr:ReplaceSpritesheet(2, stage.TransitionIcon or "")
					end
					spr:SetLayerFrame(2,1)
					spr:LoadGraphics()

					---@type EditorButton
					local self
					self = WORSTDEBUGMENU.wma.AddButton(StageSel.name, i..","..j, pos, 20, 14, nilspr, function(button) 
						if button ~= 0 then return end
						Isaac.ExecuteCommand("cstage "..stage.Name)
					end, function(pos)
						spr:RenderLayer(2,pos)
						if j == 2 then
							shitpiss:RenderLayer(2, pos)
						end
						if self.IsSelected then
							shitpiss:RenderLayer(3, pos)
						end
					end)
					toClear[#toClear+1] = i..","..j
				end
			end
		end
	end

	
	if StageAPI then
		local self
		---@type EditorButton
		self = Menu.wma.AddButton(StageSel.name, "default", Vector(3,9), 50, 10, nilspr, function(button) 
			if button ~= 0 then return end
			Menu.StageSel.DefaultSpawnButton()
			local size = (#StageSel.btn*18 -30) + math.ceil(math.min(9,#StageSel.btn)/2)*3
			StageSel.wind:SetSize(Vector(StageSel.wind.size.X, size))
		end, function(pos)
			Menu.wma.RenderCustomTextBox(pos, Vector(self.x, self.y), self.IsSelected)
			font:DrawStringScaledUTF8(GetStr("default"),pos.X+2,pos.Y,0.5,0.5,KColor(0.1,0.1,0.2,1),0,false)
		end)

		local self
		---@type EditorButton
		self = Menu.wma.AddButton(StageSel.name, "stageAPI", Vector(3+51,9), 50, 10, nilspr, function(button) 
			if button ~= 0 then return end
			Menu.StageSel.StageAPISpawnButton()
			local ypos = StageSel.StageAPI*18 + 24
			local size = ypos + math.ceil(math.min(9,StageSel.StageAPI)/2)*3
			StageSel.wind:SetSize(Vector(StageSel.wind.size.X, size))
		end, function(pos)
			Menu.wma.RenderCustomTextBox(pos, Vector(self.x, self.y), self.IsSelected)
			font:DrawStringScaledUTF8("StageAPI",pos.X+2,pos.Y,0.5,0.5,KColor(0.1,0.1,0.2,1),0,false)
		end)
	end


	function Menu:StageSelectorPreRender(pos)
		if not StageSel.StageAPI  then
			--local ypos = #StageSel.btn*18 -30
			--local size = ypos + math.ceil(math.min(9,#StageSel.btn)/2)*3
			--StageSel.wind.size.Y = size

			UIs.HintTextBG2.Color = Color(.5,.5,.5)
			UIs.HintTextBG2.Scale = Vector(55, 1)
			UIs.HintTextBG2:Render(pos +  Vector(1,47+3))
			UIs.HintTextBG2:Render(pos +  Vector(1,47+29+3))
			UIs.HintTextBG2:Render(pos +  Vector(1,47+29+29+3))
			UIs.HintTextBG2:Render(pos +  Vector(1,47+29+29+29+3))
		else
			local ypos = StageSel.StageAPI*18 + 24
			local size = ypos + math.ceil(math.min(9,StageSel.StageAPI)/2)*3
			StageSel.wind.size.Y = size
		end
	end
	Menu:AddCallback(Menu.wma.Callbacks.WINDOW_PRE_RENDER, Menu.StageSelectorPreRender, StageSel.name)

end




do
	Menu.EntSpawner = {name = "Ent_Spawner", size = Vector(126,86), pos = Vector(87,35), btn = {}, TVS = {10,0,0},
		SpawnMode = 0, SpawnList = {}}
	local EntSpawner = Menu.EntSpawner
	local sizev = EntSpawner.size

	--[[local self
	self = Menu.wma.AddButton("__debug_menu", "Ent_Spawner_Menu", Vector(154,5), 32, 32, UIs.EntSpawner, function(button) 
		if button ~= 0 then return end
		---@type Window
		EntSpawner.wind = Menu.wma.ShowWindow(EntSpawner.name, EntSpawner.pos, sizev)
	end)
	self.posfunc = function()
		self.pos = Vector(154, 5+Menu.MainOffset.Y)
	end]]

	local self
	self = Menu.AddButtonOnDebugBar("Ent_Spawner_Menu", Vector(32, 32), UIs.EntSpawner, function(button) 
		if button ~= 0 then return end
		---@type Window
		EntSpawner.wind = Menu.wma.ShowWindow(EntSpawner.name, EntSpawner.pos, sizev)
	end)
	Menu.wma.ButtonSetHintText("__debug_menu", "Ent_Spawner_Menu", GetStr("Ent_Spawner_Menu_hintText"))
	
	local self
	self = Menu.wma.AddTextBox(EntSpawner.name, "type", Vector(5,24), Vector(32,16), nil, 
	function(result)
		if not result then
			return true
		else
			if not tonumber(result) then
				return GetStr("incorrectNumber")
			end
			EntSpawner.TVS[1] = math.max(2, math.ceil( tonumber(result) ) )
			self.text = EntSpawner.TVS[1]
			return false
		end
	end, true, function(pos)
		font:DrawStringScaledUTF8("type",pos.X+1,pos.Y-9,0.5,0.5,KColor(0.1,0.1,0.2,1),0,false)
	end)
	self.text = EntSpawner.TVS[1]

	local self
	self = Menu.wma.AddTextBox(EntSpawner.name, "var", Vector(39,24), Vector(32,16), nil, 
	function(result)
		if not result then
			return true
		else
			if not tonumber(result) then
				return GetStr("incorrectNumber")
			end
			EntSpawner.TVS[2] = math.max(0, tonumber(result) )
			self.text = EntSpawner.TVS[2]
			return false
		end
	end, true, function(pos)
		font:DrawStringScaledUTF8("var",pos.X+1,pos.Y-9,0.5,0.5,KColor(0.1,0.1,0.2,1),0,false)
	end)
	self.text = EntSpawner.TVS[2]

	local self
	self = Menu.wma.AddTextBox(EntSpawner.name, "subtype", Vector(73,24), Vector(32,16), nil, 
	function(result)
		if not result then
			return true
		else
			if not tonumber(result) then
				return GetStr("incorrectNumber")
			end
			EntSpawner.TVS[3] =  math.max(0, tonumber(result) )
			self.text = EntSpawner.TVS[3]
			return false
		end
	end, true, function(pos)
		font:DrawStringScaledUTF8("subtype",pos.X+1,pos.Y-9,0.5,0.5,KColor(0.1,0.1,0.2,1),0,false)
	end)
	self.text = EntSpawner.TVS[3]

	local self
	self = Menu.wma.AddButton(EntSpawner.name, "odin_chel", Vector(73,48), 16, 16, UIs.Chlen_1(), function(button) 
		if button ~= 0 then return end
		Menu.PlaceMode("EntSpawner_odin", nil, Menu.EntSpawnerLogic, 
		function()
			EntSpawner.SpawnMode = 0
		end)
		if Menu.isPlaceMode("EntSpawner_odin") then
			EntSpawner.SpawnMode = EntSpawner.SpawnMode == 1 and 0 or 1
		end
	end,
	function(pos)
		if EntSpawner.SpawnMode == 1 then
			UIs.Var_Sel:Render(self.pos+Vector(1.5,13))
		end
	end)
	Menu.wma.ButtonSetHintTextR(self, GetStr("EntSpawner odin"))

	local self
	self = Menu.wma.AddButton(EntSpawner.name, "mnogo_chel", Vector(91,48), 16, 16, UIs.Chlen_multi, function(button) 
		if button ~= 0 then return end

		Menu.PlaceMode("EntSpawner_mnogo", nil, Menu.EntSpawnerLogic, 
		function()
			EntSpawner.SpawnMode = 0
		end)
		if Menu.isPlaceMode("EntSpawner_mnogo") then
			EntSpawner.SpawnMode = EntSpawner.SpawnMode == 2 and 0 or 2
		end
	end,
	function(pos)
		if EntSpawner.SpawnMode == 2 then
			UIs.Var_Sel:Render(self.pos+Vector(1.5,13))
		end
	end)
	Menu.wma.ButtonSetHintTextR(self, GetStr("EntSpawner mnogo"))

	local self
	self = Menu.wma.AddButton(EntSpawner.name, "стереть", Vector(19,48), 16, 16, UIs.CCCCCCCC(), function(button) 
		if button ~= 0 then return end
		EntSpawner.SpawnList = {}
		EntSpawner.LastSpawns = {}
	end)
	Menu.wma.ButtonSetHintTextR(self, GetStr("removeAllSpawnpoint"))

	local self
	self = Menu.wma.AddButton(EntSpawner.name, "nasad", Vector(37,48), 16, 16, UIs.nasad(), function(button) 
		if button ~= 0 then return end
		if #EntSpawner.SpawnList > 0 then
			table.remove(EntSpawner.SpawnList, #EntSpawner.SpawnList)
		end
	end)
	Menu.wma.ButtonSetHintTextR(self, GetStr("nasadSpawnpoint"))

	local self
	self = Menu.wma.AddButton(EntSpawner.name, "povtor", Vector(55,48), 16, 16, UIs.reset(), function(button) 
		if button ~= 0 then return end
		if EntSpawner.LastSpawns then
			EntSpawner.EntSpawner_SpawnList(EntSpawner.LastSpawns)
		end
	end)
	Menu.wma.ButtonSetHintTextR(self, GetStr("povtorSpawnpoint"))

	local self
	self = Menu.wma.AddButton(EntSpawner.name, "multispawn", Vector(73,66), 34, 16, nil, function(button) 
		if button ~= 0 then return end
		if EntSpawner.SpawnList then
			EntSpawner.EntSpawner_SpawnList(EntSpawner.SpawnList)
		end
	end, function(pos)
		Menu.wma.RenderCustomButton(pos, Vector(self.x,self.y), self.IsSelected)
		font:DrawStringScaledUTF8(GetStr("spawn"),pos.X-.5+self.x/2,pos.Y+1,0.5,0.5,KColor(0.1,0.1,0.2,1),1,true)
	end)

	function EntSpawner.EntSpawner_SpawnList(tab)
		for i=1, #tab do
			local dat = tab[i]
			Isaac.Spawn(dat[1], dat[2], dat[3], dat[4], Vector(0,0), nil)
		end
		EntSpawner.LastSpawns = TabDeepCopy(tab)
	end

	function Menu.EntSpawnerLogic()
		if EntSpawner.SpawnMode > 0 and EntSpawner.wind then
			local mousePos = Menu.wma.MousePos
			UIs.entspawnerpoint:Render(mousePos)
			if Menu.wma.OnFreePos and Menu.wma.IsMouseBtnTriggered(0) then
				local pos = Input.GetMousePosition(true)
				local tvs = EntSpawner.TVS
				
				if EntSpawner.SpawnMode == 1 then
					EntSpawner.EntSpawner_SpawnList({{tvs[1], tvs[2], tvs[3], pos}})
				elseif EntSpawner.SpawnMode == 2 then
					EntSpawner.SpawnList[#EntSpawner.SpawnList+1] = {tvs[1], tvs[2], tvs[3], pos}
				end
			end
		end
	end

	function Menu.EntSpawnerRender()
		if game:IsPaused() then return end
		if EntSpawner.wind and EntSpawner.wind.Removed then
			EntSpawner.wind = nil
		end
		--[[if EntSpawner.SpawnMode > 0 and EntSpawner.wind then
			local mousePos = Menu.wma.MousePos
			UIs.entspawnerpoint:Render(mousePos)
			if Menu.wma.OnFreePos and Menu.wma.IsMouseBtnTriggered(0) then
				local pos = Input.GetMousePosition(true)
				local tvs = EntSpawner.TVS
				
				if EntSpawner.SpawnMode == 1 then
					EntSpawner.EntSpawner_SpawnList({{tvs[1], tvs[2], tvs[3], pos}})
					--EntSpawner.LastSpawns = TabDeepCopy({{tvs[1], tvs[2], tvs[3], pos}})
				elseif EntSpawner.SpawnMode == 2 then
					EntSpawner.SpawnList[#EntSpawner.SpawnList+1] = {tvs[1], tvs[2], tvs[3], pos}
					--EntSpawner.LastSpawns = TabDeepCopy(EntSpawner.SpawnList)
				end
			end
		end]]
		if EntSpawner.wind then
			if #EntSpawner.SpawnList>0 then
				UIs.entspawnerpoint.Color = Color(1,1,1,.5)
				for i=1, #EntSpawner.SpawnList do
					local dat = EntSpawner.SpawnList[i]
					local pos = Isaac.WorldToScreen(dat[4])
					UIs.entspawnerpoint:Render(pos)
					local text = dat[1] .. "." .. dat[2] .. "." .. dat[3]
					font:DrawStringScaledUTF8(text, pos.X-5, pos.Y-7, 0.5,0.5,KColor(0.9,0.9,0.9,1),0,false)
				end
				UIs.entspawnerpoint.Color = Color(1,1,1,1)
			end
		end

		--[[if Menu.GridSpawner.wind and Menu.GridSpawner.wind.Removed then
			Menu.GridSpawner.wind = nil
		end
		if Menu.GridSpawner.wind then
			local room = game:GetRoom()
			local mousePos = Menu.wma.MousePos
			local pos = Input.GetMousePosition(true)
			if Menu.GridSpawner.SpawnMode == 1 and Menu.GridSpawner.TVS ~= -1 then
				local index = room:GetGridIndex(pos)
				local RenderPos = Isaac.WorldToScreen(room:GetGridPosition(room:GetGridIndex(pos)))

				UIs.entspawnerpoint:Render(RenderPos)
				if Menu.wma.OnFreePos and Menu.wma.IsMouseBtnTriggered(0) then
					--local pos = Input.GetMousePosition(true)
					local tvs = Menu.GridSpawner.TVS
					Isaac.ExecuteCommand("gridspawn "..Menu.GridSpawner.TVS.." "..index)
				elseif Menu.wma.OnFreePos and Menu.wma.IsMouseBtnTriggered(1) then
					room:RemoveGridEntity(index, 0, false)
				end
			elseif Menu.GridSpawner.SpawnMode == 2 then
				local index = room:GetGridIndex(pos)
				local RenderPos = Isaac.WorldToScreen(room:GetGridPosition(room:GetGridIndex(pos)))

				UIs.entspawnerpoint:Render(RenderPos)
				if Menu.wma.OnFreePos and Menu.wma.IsMouseBtnTriggered(0) then
					local grid = room:GetGridEntity(index)
					--if grid then
						Menu.GridSpawner.SelGridIndex = grid
						Menu.GridSpawner.btn.vardata.text = grid and grid.VarData or ""
						Menu.GridSpawner.btn.state.text = grid and grid.State or ""
					--end
				elseif Menu.wma.IsMouseBtnTriggered(1) then
					Menu.GridSpawner.SelGridIndex = nil
					Menu.GridSpawner.btn.vardata.text = ""
					Menu.GridSpawner.btn.state.text = ""
				end
			end
		end]]

		Menu.ItemListRender()
	end

	Menu:AddCallback(ModCallbacks.MC_POST_RENDER, Menu.EntSpawnerRender)
end

do --UIs.GridSpawner
	
	Menu.GridSpawner = {name = "Grid_Spawner", size = Vector(166,56), pos = Vector(140,35), btn = {}, TVS = 0,
		SpawnMode = 0, GridName = "decoration", 
	}
	local GridSpawner = Menu.GridSpawner
	local sizev = GridSpawner.size

	--[[local self
	self = Menu.wma.AddButton("__debug_menu", "Grid_Spawner_Menu", Vector(188,5), 32, 32, UIs.GridSpawner, function(button) 
		if button ~= 0 then return end
		---@type Window
		GridSpawner.wind = Menu.wma.ShowWindow(GridSpawner.name, GridSpawner.pos, sizev)
	end)
	self.posfunc = function()
		self.pos = Vector(188, 5+Menu.MainOffset.Y)
	end]]

	local self
	self = Menu.AddButtonOnDebugBar("Grid_Spawner_Menu", Vector(32, 32), UIs.GridSpawner, function(button) 
		if button ~= 0 then return end
		---@type Window
		GridSpawner.wind = Menu.wma.ShowWindow(GridSpawner.name, GridSpawner.pos, sizev)
	end)
	Menu.wma.ButtonSetHintText("__debug_menu", "Grid_Spawner_Menu", GetStr("Grid_Spawner_Menu_hintText"))
	
	local GridList = {
		{0, "decoration",},
		{1000 , "rock"},
		{1001 , "bomb rock"},
		{1002 , "alt rock"},
		{1003 , "tinted rock"},
		{1008 , "marked skull"},
		{1009 , "event rock"},
		{1010 , "spiked rock"},
		{1011 , "fool's gold rock"},
		{1300 , "tnt"},
		{1490 , "red poop"},
		{1494 , "rainbow poop"},
		{1495 , "corny poop"},
		{1496 , "golden poop"},
		{1497 , "black poop"},
		{1498 , "white poop"},
		{1499 , "giant poop"},
		{1500 , "poop"},
		{1501 , "charming poop"},
		{1900 , "block"},
		{1901 , "pillar"},
		{1930 , "spikes"},
		{"1931" , "retracting spikes D1/5"},
		{"1931.1" , "retracting spikes D2/5"},
		{"1931.2" , "retracting spikes D3/5"},
		{"1931.3" , "retracting spikes D4/5"},
		{"1931.4" , "retracting spikes D5/5"},
		{"1931.5" , "retracting spikes U1/5"},
		{"1931.6" , "retracting spikes U2/5"},
		{"1931.7" , "retracting spikes U3/5"},
		{"1931.8" , "retracting spikes U4/5"},
		{"1931.9" , "retracting spikes U5/5"},
		{1940 , "cobweb"},
		{1999 , "invisible block"},
		{3000 , "pit"},
		{3001 , "fissire spawner"},
		{3002 , "event rail"},
		{3009 , "event pit"},
		{4000 , "key block"},
		{4500 , "pressure plate"},
		{"4500.1" , "reward plate"},
		{"4500.2" , "greed plate"},
		{"4500.3" , "rail plate"},
		{"4500.9" , "kill plate"},
		{"4500.10" , "event plate 0"},
		{"4500.11" , "event plate 1"},
		{"4500.12" , "event plate 2"},
		{"4500.13" , "event plate 3"},
		{5000 , "devil statue "},
		{5001 , "angel statue "},
		{6000 , "rail (horizontal) "},
		{"6000.1" , "rail (vertical) "},
		{"6000.2" , "rail (down-to-right) "},
		{"6000.3" , "rail (down-to-left) "},
		{"6000.4" , "rail (up-to-right) "},
		{"6000.5" , "rail (up-to-left) "},
		{"6000.6" , "rail (crossroad) "},
		{"6000.7" , "rail (end-left) "},
		{"6000.8" , "rail (ent-left) "},
		{"6000.9" , "rail (end-up) "},
		{"6000.10" , "rail (end-down) "},
		{"6000.16" , "rail (cart-left) "},
		{"6000.17" , "rail (cart-up) "},
		{"6000.32" , "rail (cart-right) "},
		{"6000.33" , "rail (cart-down) "},
		{"6000.80" , "rail (MS hori 1) "},
		{"6000.81" , "rail (MS vert 1) "},
		{"6000.82" , "rail (MS d-r) "},
		{"6000.83" , "rail (MS d-l) "},
		{"6000.84" , "rail (MS u-r) "},
		{"6000.85" , "rail (MS u-l) "},
		{"6000.96" , "rail (MS hori 2) "},
		{"6000.97" , "rail (MS vert 2) "},
		{"6000.98" , "rail (MS d-r 2) "},
		{"6000.99" , "rail (MS d-l 2) "},
		{"6000.100" , "rail (MS u-r 2) "},
		{"6000.101" , "rail (MS u-l 2) "},
		{"6000.112" , "rail (MS hori 3) "},
		{"6000.113" , "rail (MS ver 3) "},
		{"6001" , "rail pit hori"},
		{"6001.1" , "rail pit vert"},
		{"6001.2" , "rail pit d-r"},
		{"6001.3" , "rail pit d-l"},
		{"6001.4" , "rail pit u-r"},
		{"6001.5" , "rail pit u-l"},
		{"6001.6" , "rail pit crossroad"},
		{"6001.16" , "rail pit cart-l"},
		{"6001.17" , "rail pit cart-u"},
		{"6001.32" , "rail pit cart-r"},
		{"6001.33" , "rail pit cart-d"},
		{6100 , "teleporter (square)"},
		{"6100.1" , "teleporter (moon)"},
		{"6100.2" , "teleporter (rhombus)"},
		{"6100.3" , "teleporter (M)"},
		{"6100.4" , "teleporter (pentagram)"},
		{"6100.5" , "teleporter (cross)"},
		{"6100.6" , "teleporter (triangle)"},
		{9000 , "trap door"},
		{"9000.1" , "void portal"},
		{9100 , "crawlspace"},
		{10000 , "gravity"},
--		{ , ""},
	}


	local self
	self = Menu.wma.AddButton(GridSpawner.name, "type", Vector(5,16), 152,16, nil, 
	function(button)
		if button ~= 0 then return end
		
		Menu.wma.FastCreatelist(GridSpawner.name, self.pos - GridSpawner.wind.pos, self.x, GridList, 
		function(_,arg1,arg2)
			GridSpawner.TVS = arg1
			GridSpawner.GridName = arg2
		end, false)
		
		Menu.wma.ScrollOffset.X = self.Offset and self.Offset.X or Menu.wma.ScrollOffset.X
		Menu.wma.ScrollOffset.Y = self.Offset and self.Offset.Y or Menu.wma.ScrollOffset.Y

	end, function(pos)
		Menu.wma.RenderCustomTextBox(pos, Vector(self.x,14), self.IsSelected)
		font:DrawStringScaledUTF8(GridSpawner.GridName,pos.X+3,pos.Y+1,0.5,0.5,KColor(0.1,0.1,0.2,1),0,false)

		if Menu.wma.GetButton(GridSpawner.name, "_Listshadow") 
		and Menu.wma.ScrollOffset then
			self.Offset = Menu.wma.ScrollOffset/1
		end
		
		--Menu.wma.DetectSelectedButton(GridSpawner.name..1)
		--Menu.wma.RenderMenuButtons(GridSpawner.name..1)
	end)

	local self
	self = Menu.wma.AddButton(GridSpawner.name, "odin_chel", Vector(5,32), 16, 16, UIs.Chlen_1(), function(button) 
		if button ~= 0 then return end
		Menu.PlaceMode("GridSpawner_odin", Menu.GridSpawnerPlacePress, Menu.GridSpawnerPlaceLogic, function()
			GridSpawner.SpawnMode = 0
		end)
		if Menu.isPlaceMode("GridSpawner_odin") then
			GridSpawner.SpawnMode = GridSpawner.SpawnMode == 1 and 0 or 1
		end
	end,
	function(pos)
		if GridSpawner.SpawnMode == 1 then
			UIs.Var_Sel:Render(self.pos+Vector(1.5,13))
		end
	end)

	local self
	self = Menu.wma.AddButton(GridSpawner.name, "edit_grid", Vector(22,32), 16, 16, UIs.Editbtn, function(button) 
		if button ~= 0 then return end
		Menu.PlaceMode("GridSpawner_edit", Menu.GridSpawnerPlacePress, Menu.GridSpawnerPlaceLogic, function()
			GridSpawner.SpawnMode = 0
		end)
		if Menu.isPlaceMode("GridSpawner_edit") then
			GridSpawner.SpawnMode = GridSpawner.SpawnMode == 2 and 0 or 2
		end
	end,
	function(pos)
		if GridSpawner.SpawnMode == 2 then
			UIs.Var_Sel:Render(self.pos+Vector(1.5,13))
		end
	end)

	--[[local self
	self = Menu.wma.AddButton(GridSpawner.name, "gridData", Vector(5,60), 32,16, nil, 
	function(button)
		if button ~= 0 then return end
		
	end, function(pos)
		if GridSpawner.SelGridIndex then
			Menu.wma.RenderCustomTextBox(pos, Vector(self.x,14), self.IsSelected)
			font:DrawStringScaledUTF8("VarData", pos.X+3,pos.Y-10,0.5,0.5,KColor(0.1,0.1,0.2,1),0,false)

			font:DrawStringScaledUTF8(GridSpawner.SelGridIndex.VarData, pos.X+3,pos.Y+1,0.5,0.5,KColor(0.1,0.1,0.2,1),0,false)

			
			GridSpawner.size.Y = 82
		else
			GridSpawner.size.Y = 56
		end
	end)]]

	GridSpawner.btn.vardata = Menu.wma.AddTextBox(GridSpawner.name, "gridVarData", Vector(5,60), Vector(32,16), nil, 
	function(result)
		if not result then
			return true
		else
			if not tonumber(result) then
				return GetStr("incorrectNumber")
			end
			if GridSpawner.SelGridIndex then
				GridSpawner.SelGridIndex.VarData = result
			end
			return true
		end
	end, true, function(pos)
		if GridSpawner.SelGridIndex then
			--Menu.wma.RenderCustomTextBox(pos, Vector(self.x,14), self.IsSelected)
			font:DrawStringScaledUTF8("VarData", pos.X-1,pos.Y-10,0.5,0.5,KColor(0.1,0.1,0.2,1),0,false)
			
			GridSpawner.size.Y = 82
			GridSpawner.btn.vardata.canPressed = true
			GridSpawner.btn.vardata.visible = true

			if Isaac.GetFrameCount() % 10 == 0 then
				GridSpawner.btn.vardata.text = GridSpawner.SelGridIndex.VarData
			end
		else
			GridSpawner.size.Y = 56
			GridSpawner.btn.vardata.canPressed = false
			GridSpawner.btn.vardata.visible = false
		end
	end)
	GridSpawner.btn.vardata.text = ""

	GridSpawner.btn.state = Menu.wma.AddTextBox(GridSpawner.name, "gridState", Vector(47,60), Vector(32,16), nil, 
	function(result)
		if not result then
			return true
		else
			if not tonumber(result) then
				return GetStr("incorrectNumber")
			end
			if GridSpawner.SelGridIndex then
				GridSpawner.SelGridIndex.State = result
			end
			return true
		end
	end, true, function(pos)
		if GridSpawner.SelGridIndex then
			--Menu.wma.RenderCustomTextBox(pos, Vector(self.x,14), self.IsSelected)
			font:DrawStringScaledUTF8("state", pos.X+3,pos.Y-10,0.5,0.5,KColor(0.1,0.1,0.2,1),0,false)
			
			GridSpawner.btn.state.canPressed = true
			GridSpawner.btn.state.visible = true
			if Isaac.GetFrameCount() % 10 == 0 then
				GridSpawner.btn.state.text = GridSpawner.SelGridIndex.State
			end
		else
			GridSpawner.btn.state.canPressed = false
			GridSpawner.btn.state.visible = false
		end
	end)
	GridSpawner.btn.state.text = ""

	function Menu.GridSpawnerPlacePress(btn, mousePos)
		if Menu.GridSpawner.wind then
			local room = game:GetRoom()
			local pos = Input.GetMousePosition(true)
			if Menu.GridSpawner.SpawnMode == 1 and Menu.GridSpawner.TVS ~= -1 then
				local index = room:GetGridIndex(pos)

				if Menu.wma.OnFreePos and btn == (0) then
					--local pos = Input.GetMousePosition(true)
					local tvs = Menu.GridSpawner.TVS
					Isaac.ExecuteCommand("gridspawn "..Menu.GridSpawner.TVS.." "..index)
				elseif Menu.wma.OnFreePos and btn == (1) then
					room:RemoveGridEntity(index, 0, false)
				end
			elseif Menu.GridSpawner.SpawnMode == 2 then
				local index = room:GetGridIndex(pos)

				if Menu.wma.OnFreePos and btn == (0) then
					local grid = room:GetGridEntity(index)
					--if grid then
						Menu.GridSpawner.SelGridIndex = grid
						Menu.GridSpawner.btn.vardata.text = grid and grid.VarData or ""
						Menu.GridSpawner.btn.state.text = grid and grid.State or ""
					--end
				elseif btn == (1) then
					Menu.GridSpawner.SelGridIndex = nil
					Menu.GridSpawner.btn.vardata.text = ""
					Menu.GridSpawner.btn.state.text = ""
				end
			end
		end
	end
	function Menu.GridSpawnerPlaceLogic(mousePos)
		if Menu.GridSpawner.wind and Menu.GridSpawner.wind.Removed then
			Menu.GridSpawner.wind = nil
		end
		if Menu.GridSpawner.wind then
			local room = game:GetRoom()
			local pos = Input.GetMousePosition(true)
			if Menu.GridSpawner.SpawnMode == 1 and Menu.GridSpawner.TVS ~= -1 then
				local index = room:GetGridIndex(pos)
				local RenderPos = Isaac.WorldToScreen(room:GetGridPosition(room:GetGridIndex(pos)))

				UIs.entspawnerpoint:Render(RenderPos)
			elseif Menu.GridSpawner.SpawnMode == 2 then
				local index = room:GetGridIndex(pos)
				local RenderPos = Isaac.WorldToScreen(room:GetGridPosition(room:GetGridIndex(pos)))

				UIs.entspawnerpoint:Render(RenderPos)
			end
		end
	end


end

do
	function UIs.Box48() return GenSprite("gfx/editor/ui copy.anm2","контейнер") end
	function UIs.play() return GenSprite("gfx/editor/ui copy.anm2","play btn") end
	function UIs.pause() return GenSprite("gfx/editor/ui copy.anm2","pause btn") end
	UIs.ubratOverlay = GenSprite("gfx/editor/ui copy.anm2","erazer")
	UIs.pomenyatOverlay = GenSprite("gfx/editor/ui copy.anm2","две закруглённые стрелки")
	--WORSTDEBUGMENU.AddButtonOnDebugBar(buttonName, size, sprite, pressFunc, renderFunc)

	Menu.AnimTest = {name = "Anim_Test", subnames = {}, size = Vector(166+24,196), btn = {}, anim = {anm2 = "", animation = "", 
	col = Color(1,1,1,1), colorize = Color(1,1,1,0)}}
	local AnimTest = Menu.AnimTest
	local sizev = AnimTest.size

	AnimTest.anim.spr = GenSprite("gfx/editor/ui copy.anm2","режим_сетки")   --Sprite()
	AnimTest.anim.RenderPos = Vector(0,0)

	local self
	self = WORSTDEBUGMENU.AddButtonOnDebugBar("Anim_Test_Menu", Vector(32,32), UIs.AnimTaste, function(button) 
		if button ~= 0 then return end
		---@type Window
		AnimTest.wind = Menu.wma.ShowWindow(AnimTest.name, self.pos+Vector(0,15), sizev)
		for i,k in pairs(AnimTest.subnames) do
			AnimTest.wind:SetSubMenuVisible(k, false)
		end
		AnimTest.wind:SetSubMenuVisible(AnimTest.subnames.file, true)
		AnimTest.wind:SetSize(AnimTest.size+Vector(0,16))
	end, nil)
	Menu.wma.ButtonSetHintText("__debug_menu", "Anim_Test_Menu", GetStr("Anim_Test_Menu_hintText"))
	
	local function UpdateLstFrame()
		AnimTest.anim.lastFrame = 0
		local frame = AnimTest.anim.spr:GetFrame()
		local overframe = AnimTest.anim.spr:GetOverlayFrame()

		AnimTest.anim.spr:SetLastFrame()
		AnimTest.anim.lastFrame = AnimTest.anim.spr:GetFrame()
		local anim = AnimTest.anim.spr:GetAnimation()
		AnimTest.anim.spr:Play(AnimTest.anim.spr:GetOverlayAnimation(), true)
		AnimTest.anim.spr:SetLastFrame()
		AnimTest.anim.lastOverlayFrame = AnimTest.anim.spr:GetFrame()

		AnimTest.anim.spr:Play(anim, true)
		AnimTest.anim.spr:SetFrame(frame)  --lastOverlayFrame
	end
	UpdateLstFrame()

	TakePlace(AnimTest.name, Vector(0,12))
	local v = GetPlace(AnimTest.name)
	local si = Vector(166,48)
	local self
	self = Menu.wma.AddGragZone(AnimTest.name, "preview", Vector(12,v.Y), si, nil, function(button, newpos, prepos)
		if button ~= 0 then return end
		AnimTest.anim.RenderPos = newpos
	end, function(pos)
		Menu.wma.RenderCustomButton(pos, si, self.IsSelected)
		AnimTest.anim.spr:Render(pos+Vector(84,24)+AnimTest.anim.RenderPos)
		if Isaac.GetFrameCount() % 2 == 0 then
			AnimTest.anim.spr:Update()
			if AnimTest.anim.AutoPlay and not AnimTest.anim.OnPause and AnimTest.anim.spr:IsFinished(AnimTest.anim.spr:GetAnimation()) then
				AnimTest.anim.spr:Play(AnimTest.anim.spr:GetAnimation(), true)
			end --AutoOverlayPlay
			if AnimTest.anim.AutoOverlayPlay and not AnimTest.anim.OnOverlayPause and AnimTest.anim.spr:IsOverlayFinished(AnimTest.anim.spr:GetOverlayAnimation()) then
				AnimTest.anim.spr:PlayOverlay(AnimTest.anim.spr:GetOverlayAnimation(), true)
			end
		end

		local sc = AnimTest.anim.col
		local col --= Color(sc.R, sc.G, sc.B, sc.A /2 )
		if self.IsSelected then
			col = Color(sc.R, sc.G, sc.B, sc.A /2, sc.RO, sc.GO, sc.BO )
		else
			col = Color(sc.R, sc.G, sc.B, sc.A , sc.RO, sc.GO, sc.BO )
		end
		local scR = AnimTest.anim.colorize
		col:SetColorize(scR.R,scR.G,scR.B,scR.A)
		AnimTest.anim.spr.Color = col

		--[[if self.IsSelected then
			local sc = AnimTest.anim.col
			local col = Color(sc.R, sc.G, sc.B, sc.A /2 )
			AnimTest.anim.spr.Color = Color(sc.R, sc.G, sc.B, sc.A /2 )
		else
			local sc = AnimTest.anim.col
			AnimTest.anim.spr.Color = Color(sc.R, sc.G, sc.B, sc.A )
		end]]
	end)
	TakePlace(AnimTest.name, Vector(0,si.Y+2))

	local v = GetPlace(AnimTest.name) --cutscenes/credits.anm2
	local self
	self = Menu.wma.AddButton(AnimTest.name, "play", Vector(12,v.Y), 16, 16, UIs.play(), function(button) 
		if button ~= 0 then return end
		AnimTest.anim.spr:Play(AnimTest.anim.spr:GetAnimation(), true)
	end)
	local self
	self = Menu.wma.AddButton(AnimTest.name, "pause", Vector(30,v.Y), 16, 16, UIs.pause(), function(button) 
		if button ~= 0 then return end
		
		if not AnimTest.anim.spr:IsPlaying() then
			AnimTest.anim.OnPause = false
			local frame = AnimTest.anim.spr:GetFrame()
			AnimTest.anim.spr:Play(AnimTest.anim.spr:GetAnimation(), true)
			AnimTest.anim.spr:SetFrame(frame)	
		else
			AnimTest.anim.spr:Stop()
			AnimTest.anim.OnPause = true
		end
	end)
	local self
	self = Menu.wma.AddButton(AnimTest.name, "autoplay", Vector(48,v.Y), 16, 16, UIs.reset(), function(button) 
		if button ~= 0 then return end
		AnimTest.anim.AutoPlay = not AnimTest.anim.AutoPlay
	end, function(pos)
		if AnimTest.anim.AutoPlay then
			UIs.Var_Sel:Render(pos+Vector(2,0))
			self.spr.Color = Color(1,1,1,.5)
			self.spr:RenderLayer(1,pos)
			self.spr.Color = Color(1,1,1,1)
		end
	end)

	local self ----------------------------------------
	self = Menu.wma.AddButton(AnimTest.name, "Oplay", Vector(70,v.Y), 16, 16, UIs.play(), function(button) 
		if button ~= 0 then return end
		AnimTest.anim.spr:PlayOverlay(AnimTest.anim.spr:GetOverlayAnimation(), true)
	end, function(pos)
		TextBoxFont:DrawStringScaledUTF8("o",pos.X+1,pos.Y+6,1,1,KColor(0.19,0.2,0.21,1),1,true)
	end)
	local self
	self = Menu.wma.AddButton(AnimTest.name, "Opause", Vector(88,v.Y), 16, 16, UIs.pause(), function(button) 
		if button ~= 0 then return end
		
		if not AnimTest.anim.spr:IsOverlayPlaying() then
			AnimTest.anim.OnOverlayPause = false
			local frame = AnimTest.anim.spr:GetOverlayFrame()
			AnimTest.anim.spr:PlayOverlay(AnimTest.anim.spr:GetOverlayAnimation(), true)
			AnimTest.anim.spr:SetOverlayFrame(frame)	
		else
			AnimTest.anim.spr:StopOverlay()
			AnimTest.anim.OnOverlayPause = true
		end
	end, function(pos)
		TextBoxFont:DrawStringScaledUTF8("o",pos.X+1,pos.Y+6,1,1,KColor(0.19,0.2,0.21,1),1,true)
	end)
	local self
	self = Menu.wma.AddButton(AnimTest.name, "Oautoplay", Vector(106,v.Y), 16, 16, UIs.reset(), function(button) 
		if button ~= 0 then return end
		AnimTest.anim.AutoOverlayPlay = not AnimTest.anim.AutoOverlayPlay
	end, function(pos)
		if AnimTest.anim.AutoOverlayPlay then
			UIs.Var_Sel:Render(pos+Vector(2,0))
			self.spr.Color = Color(1,1,1,.5)
			self.spr:RenderLayer(1,pos)
			self.spr.Color = Color(1,1,1,1)
		end
		TextBoxFont:DrawStringScaledUTF8("o",pos.X+1,pos.Y+6,1,1,KColor(0.19,0.2,0.21,1),1,true)
	end)
	TakePlace(AnimTest.name, Vector(0,self.y+2))


	local vG = GetPlace(AnimTest.name)/1

	AnimTest.subnames.file = "Anim_Test_file"

	local self
	self = Menu.wma.AddButton(AnimTest.name, "fileset", Vector(12,vG.Y+5), 32, 12, nil, function(button) 
		if button ~= 0 then return end
		for i,k in pairs(AnimTest.subnames) do
			AnimTest.wind:SetSubMenuVisible(k, false)
		end
		AnimTest.wind:SetSubMenuVisible(AnimTest.subnames.file, true)
		AnimTest.wind:SetSize(AnimTest.size+Vector(0,14))
		UpdateLstFrame()
	end,
	function(pos)
		Menu.wma.RenderCustomButton(pos, Vector(self.x, self.y), self.IsSelected)
		font:DrawStringScaledUTF8(GetStr("file"),pos.X+16,pos.Y+1,0.5,0.5,KColor(0.1,0.1,0.2,1),1,true)
	end)
	vG.Y = vG.Y+18 + self.y

	AnimTest.btn.anm2 = Menu.wma.AddTextBox(AnimTest.subnames.file, "anm2", Vector(12,vG.Y), Vector(166,16), nil, 
	function(result)
		if not result then
			return true
		else
			if #result < 1 or not string.find(result,"%S") then
				return GetStr("emptyField")
			end
			--local ret = true
			if not string.find(result, ".anm2") then
				result = result .. ".anm2"
			end
			
			local tespt = Sprite()
			tespt:Load(result, true)
			if tespt:GetDefaultAnimation() == "" then
				return GetStr("anm2FileFail")
			end
			AnimTest.anim.anm2 = (result) 
			AnimTest.anim.spr:Load(result, true)
			AnimTest.anim.spr:Play(AnimTest.anim.spr:GetDefaultAnimation() )
			AnimTest.anim.animation = AnimTest.anim.spr:GetDefaultAnimation()
			AnimTest.btn.anim.text = AnimTest.anim.animation
			AnimTest.btn.overlay.text = ""
			AnimTest.anim.overlayPriority = nil
			--self.text = AnimTest.TVS[2]
			UpdateLstFrame()
			return true
		end
	end, false, function(pos)
		font:DrawStringScaledUTF8(GetStr("AnmFile"),pos.X+1,pos.Y-9,0.5,0.5,KColor(0.1,0.1,0.2,1),0,false)
	end)
	AnimTest.btn.anm2.text = "gfx/"
	vG.Y = vG.Y+16 + self.y

	AnimTest.btn.anim = Menu.wma.AddTextBox(AnimTest.subnames.file, "anim", Vector(12,vG.Y), Vector(166,16), nil, 
	function(result)
		if not result then
			return true
		else
			if #result < 1 or not string.find(result,"%S") then
				return GetStr("emptyField")
			end
			AnimTest.anim.spr:Play(result, true )
			UpdateLstFrame()
			if AnimTest.anim.spr:GetAnimation() == result then
				AnimTest.anim.animation = AnimTest.anim.spr:GetDefaultAnimation()
				return true
			end
			return false
		end
	end, false, function(pos)
		font:DrawStringScaledUTF8(GetStr("AnimName"),pos.X+1,pos.Y-9,0.5,0.5,KColor(0.1,0.1,0.2,1),0,false)
	end)
	AnimTest.btn.anim.text = ""
	vG.Y = vG.Y+12 + AnimTest.btn.anim.y

	AnimTest.btn.overlay = Menu.wma.AddTextBox(AnimTest.subnames.file, "overlay_anim", Vector(12,vG.Y), Vector(166,16), nil, 
	function(result)
		if not result then
			return true
		else
			if #result < 1 or not string.find(result,"%S") then
				return GetStr("emptyField")
			end
			AnimTest.anim.spr:PlayOverlay(result, true )
			UpdateLstFrame()
			if AnimTest.anim.spr:GetOverlayAnimation() == result then
				AnimTest.anim.overlay = AnimTest.anim.spr:GetDefaultAnimation()
				return true
			end
			return false
		end
	end, false, function(pos)
		font:DrawStringScaledUTF8(GetStr("AnimOVerlayName"),pos.X+1,pos.Y-9,0.5,0.5,KColor(0.1,0.1,0.2,1),0,false)
	end)
	AnimTest.btn.overlay.text = ""
	vG.Y = vG.Y+0 + AnimTest.btn.anim.y

	local self
	self = Menu.wma.AddButton(AnimTest.subnames.file, "overlayclear", Vector(12,vG.Y+5), 16, 16, UIs.ubratOverlay, function(button) 
		if button ~= 0 then return end
		AnimTest.anim.spr:RemoveOverlay()
		AnimTest.btn.overlay.text = ""
	end)
	Menu.wma.ButtonSetHintTextR(self, GetStr("removeoverlaylayer"))
	local self
	self = Menu.wma.AddButton(AnimTest.subnames.file, "overlaylayer", Vector(30,vG.Y+5), 16, 16, UIs.pomenyatOverlay, function(button) 
		if button ~= 0 then return end
		AnimTest.anim.spr:SetOverlayRenderPriority(not AnimTest.anim.overlayPriority)
		AnimTest.anim.overlayPriority = not AnimTest.anim.overlayPriority
	end)
	Menu.wma.ButtonSetHintTextR(self, GetStr("overlaylayerchange"))
	vG.Y = vG.Y+18 + self.y
	--UIs.ubratOverlay = GenSprite("gfx/editor/ui copy.anm2","erazer")
	--UIs.pomenyatOverlay



	UIs.ColorDrager = GenSprite("gfx/editor/ui copy.anm2", "color_drag")
	UIs.ColorDrager.Scale = Vector(136/140/2,1)
	local nilspr = Sprite()

	AnimTest.subnames.color = "Anim_Test_color"
	local vG = GetPlace(AnimTest.name)/1

	local self
	self = Menu.wma.AddButton(AnimTest.name, "colorset", Vector(46,vG.Y+5), 32, 12, nil, function(button) 
		if button ~= 0 then return end
		for i,k in pairs(AnimTest.subnames) do
			AnimTest.wind:SetSubMenuVisible(k, false)
		end
		AnimTest.wind:SetSubMenuVisible(AnimTest.subnames.color, true)
		AnimTest.wind:SetSize(Vector(AnimTest.size.X, AnimTest.size.Y + 34))
	end,
	function(pos)
		Menu.wma.RenderCustomButton(pos, Vector(self.x, self.y), self.IsSelected)
		font:DrawStringScaledUTF8(GetStr("color"),pos.X+16,pos.Y+1,0.5,0.5,KColor(0.1,0.1,0.2,1),1,true)
	end)
	vG.Y = vG.Y+18 + self.y
	local leftv = 24
	
	local selfR
	selfR = Menu.wma.AddTextBox(AnimTest.subnames.color, "Tred", Vector(leftv-22,vG.Y-1), Vector(21,10), nil, 
	function(result)
		if not result then
			return true
		else
			if not tonumber(result) then
				return GetStr("incorrectNumber")
			end
			AnimTest.anim.col.R = result / 256
			return true
		end
	end, true, nil, 1)
	selfR.text = math.ceil(AnimTest.anim.col.R * 255)
	selfR.textoffset = Vector(-1,-2)
	local self
	self = Menu.wma.AddGragFloat(AnimTest.subnames.color, "red", Vector(leftv,vG.Y), Vector(136/2,10), nilspr, nil, 
	function(button, value, oldvalue)
		if button ~= 0 then return end
		AnimTest.anim.col.R = value
		selfR.text = math.ceil(value * 255)
	end, function(pos)
		font:DrawStringScaledUTF8("color",pos.X+3,pos.Y-9,0.5,0.5,KColor(0.1,0.1,0.2,1),0,false)
		--font:DrawStringScaledUTF8(math.ceil(AnimTest.anim.col.R * 255), pos.X-10,pos.Y-1,0.5,0.5,KColor(0.1,0.1,0.2,1),1,true)
		UIs.ColorDrager:RenderLayer(0, pos)
		self.dragCurPos.X = math.min(self.x, math.max(0, AnimTest.anim.col.R * self.x))
	end)

	local selfR
	selfR = Menu.wma.AddTextBox(AnimTest.subnames.color, "TredO", Vector(leftv+69+2,vG.Y-1), Vector(21,10), nil, 
	function(result)
		if not result then
			return true
		else
			if not tonumber(result) then
				return GetStr("incorrectNumber")
			end
			AnimTest.anim.col.RO = result / 256
			return true
		end
	end, true, nil, 1)
	selfR.text = math.ceil(AnimTest.anim.col.RO * 255)
	selfR.textoffset = Vector(-1,-2)
	local self
	self = Menu.wma.AddGragFloat(AnimTest.subnames.color, "redO", Vector(leftv+69+26,vG.Y), Vector(136/2,10), nilspr, nil, 
	function(button, value, oldvalue)
		if button ~= 0 then return end
		AnimTest.anim.col.RO = value
		selfR.text = math.ceil(value * 255)
	end, function(pos)
		font:DrawStringScaledUTF8(GetStr("offset"),pos.X+3,pos.Y-9,0.5,0.5,KColor(0.1,0.1,0.2,1),0,false)
		--font:DrawStringScaledUTF8(math.ceil(AnimTest.anim.col.RO * 255), pos.X-10,pos.Y-1,0.5,0.5,KColor(0.1,0.1,0.2,1),1,true)
		UIs.ColorDrager:RenderLayer(0, pos)
		self.dragCurPos.X = math.min(self.x, math.max(0, AnimTest.anim.col.RO * self.x))
	end, 0)
	vG.Y = vG.Y+2 + self.y

	local selfR
	selfR = Menu.wma.AddTextBox(AnimTest.subnames.color, "Tgreen", Vector(leftv-22,vG.Y-1), Vector(21,10), nil, 
	function(result)
		if not result then
			return true
		else
			if not tonumber(result) then
				return GetStr("incorrectNumber")
			end
			AnimTest.anim.col.G = result / 256
			return true
		end
	end, true, nil, 1)
	selfR.text = math.ceil(AnimTest.anim.col.G * 255)
	selfR.textoffset = Vector(-1,-2)
	local self
	self = Menu.wma.AddGragFloat(AnimTest.subnames.color, "green", Vector(leftv,vG.Y), Vector(136/2,10), nilspr, nil, 
	function(button, value, oldvalue)
		if button ~= 0 then return end
		AnimTest.anim.col.G = value
		selfR.text = math.ceil(value * 255)
	end, function(pos)
		--font:DrawStringScaledUTF8(math.ceil(AnimTest.anim.col.G * 255), pos.X-10,pos.Y-1,0.5,0.5,KColor(0.1,0.1,0.2,1),1,true)
		UIs.ColorDrager:RenderLayer(1, pos)
		self.dragCurPos.X = math.min(self.x, math.max(0, AnimTest.anim.col.G * self.x))
	end)

	local selfR
	selfR = Menu.wma.AddTextBox(AnimTest.subnames.color, "TgreenO", Vector(leftv+69+2,vG.Y-1), Vector(21,10), nil, 
	function(result)
		if not result then
			return true
		else
			if not tonumber(result) then
				return GetStr("incorrectNumber")
			end
			AnimTest.anim.col.GO = result / 256
			return true
		end
	end, true, nil, 1)
	selfR.text = math.ceil(AnimTest.anim.col.GO * 255)
	selfR.textoffset = Vector(-1,-2)
	local self
	self = Menu.wma.AddGragFloat(AnimTest.subnames.color, "greenO", Vector(leftv+69+26,vG.Y), Vector(136/2,10), nilspr, nil, 
	function(button, value, oldvalue)
		if button ~= 0 then return end
		AnimTest.anim.col.GO = value
		selfR.text = math.ceil(value * 255)
	end, function(pos)
		--font:DrawStringScaledUTF8(math.ceil(AnimTest.anim.col.GO * 255), pos.X-10,pos.Y-1,0.5,0.5,KColor(0.1,0.1,0.2,1),1,true)
		UIs.ColorDrager:RenderLayer(1, pos)
		self.dragCurPos.X = math.min(self.x, math.max(0, AnimTest.anim.col.GO * self.x))
	end, 0)
	vG.Y = vG.Y+2 + self.y

	local selfR
	selfR = Menu.wma.AddTextBox(AnimTest.subnames.color, "Tblue", Vector(leftv-22,vG.Y-1), Vector(21,10), nil, 
	function(result)
		if not result then
			return true
		else
			if not tonumber(result) then
				return GetStr("incorrectNumber")
			end
			AnimTest.anim.col.B = result / 256
			return true
		end
	end, true, nil, 1)
	selfR.text = math.ceil(AnimTest.anim.col.B * 255)
	selfR.textoffset = Vector(-1,-2)
	local self
	self = Menu.wma.AddGragFloat(AnimTest.subnames.color, "blue", Vector(leftv,vG.Y), Vector(136/2,10), nilspr, nil, 
	function(button, value, oldvalue)
		if button ~= 0 then return end
		AnimTest.anim.col.B = value
		selfR.text = math.ceil(value * 255)
	end, function(pos)
		--font:DrawStringScaledUTF8(math.ceil(AnimTest.anim.col.B * 255), pos.X-10,pos.Y-1,0.5,0.5,KColor(0.1,0.1,0.2,1),1,true)
		UIs.ColorDrager:RenderLayer(2, pos)
		self.dragCurPos.X = math.min(self.x, math.max(0, AnimTest.anim.col.B * self.x))
	end)

	local selfR
	selfR = Menu.wma.AddTextBox(AnimTest.subnames.color, "TblueO", Vector(leftv+69+2,vG.Y-1), Vector(21,10), nil, 
	function(result)
		if not result then
			return true
		else
			if not tonumber(result) then
				return GetStr("incorrectNumber")
			end
			AnimTest.anim.col.BO = result / 256
			return true
		end
	end, true, nil, 1)
	selfR.text = math.ceil(AnimTest.anim.col.BO * 255)
	selfR.textoffset = Vector(-1,-2)
	local self
	self = Menu.wma.AddGragFloat(AnimTest.subnames.color, "blueO", Vector(leftv+69+26,vG.Y), Vector(136/2,10), nilspr, nil, 
	function(button, value, oldvalue)
		if button ~= 0 then return end
		AnimTest.anim.col.BO = value
		selfR.text = math.ceil(value * 255)
	end, function(pos)
		--font:DrawStringScaledUTF8(math.ceil(AnimTest.anim.col.BO * 255), pos.X-10,pos.Y-1,0.5,0.5,KColor(0.1,0.1,0.2,1),1,true)
		UIs.ColorDrager:RenderLayer(2, pos)
		self.dragCurPos.X = math.min(self.x, math.max(0, AnimTest.anim.col.BO * self.x))
	end, 0)
	vG.Y = vG.Y+2 + self.y

	local selfR
	selfR = Menu.wma.AddTextBox(AnimTest.subnames.color, "Talpha", Vector(leftv-22,vG.Y-1), Vector(21,10), nil, 
	function(result)
		if not result then
			return true
		else
			if not tonumber(result) then
				return GetStr("incorrectNumber")
			end
			AnimTest.anim.col.A = result / 256
			return true
		end
	end, true, nil, 1)
	selfR.text = math.ceil(AnimTest.anim.col.A * 255)
	selfR.textoffset = Vector(-1,-2)
	local self
	self = Menu.wma.AddGragFloat(AnimTest.subnames.color, "alpha", Vector(leftv,vG.Y), Vector(136/2,10), nilspr, nil, 
	function(button, value, oldvalue)
		if button ~= 0 then return end
		AnimTest.anim.col.A = value
		selfR.text = math.ceil(value * 255)
	end, function(pos)
		--font:DrawStringScaledUTF8(math.ceil(AnimTest.anim.col.A * 255), pos.X-10,pos.Y-1,0.5,0.5,KColor(0.1,0.1,0.2,1),1,true)
		UIs.ColorDrager:RenderLayer(3, pos)
		self.dragCurPos.X = math.min(self.x, math.max(0, AnimTest.anim.col.A* self.x))
	end)


	vG.Y = vG.Y+18 + self.y  --colorize
	
	local selfR
	selfR = Menu.wma.AddTextBox(AnimTest.subnames.color, "TredOf", Vector(leftv-22,vG.Y-1), Vector(21,10), nil, 
	function(result)
		if not result then
			return true
		else
			if not tonumber(result) then
				return GetStr("incorrectNumber")
			end
			AnimTest.anim.colorize.R = result / 256
			return true
		end
	end, true, nil, 1)
	selfR.text = math.ceil(AnimTest.anim.colorize.R * 255)
	selfR.textoffset = Vector(-1,-2)
	local self
	self = Menu.wma.AddGragFloat(AnimTest.subnames.color, "redOf", Vector(leftv,vG.Y), Vector(136/2,10), nilspr, nil, 
	function(button, value, oldvalue)
		if button ~= 0 then return end
		AnimTest.anim.colorize.R = value
		selfR.text = math.ceil(value * 255)
	end, function(pos)
		font:DrawStringScaledUTF8(GetStr("colorize"),pos.X+3,pos.Y-9,0.5,0.5,KColor(0.1,0.1,0.2,1),0,false)
		--font:DrawStringScaledUTF8(math.ceil(AnimTest.anim.colorize.R * 255), pos.X-10,pos.Y-1,0.5,0.5,KColor(0.1,0.1,0.2,1),1,true)
		UIs.ColorDrager:RenderLayer(0, pos)
		self.dragCurPos.X = math.min(self.x, math.max(0, AnimTest.anim.colorize.R * self.x))
	end)
	vG.Y = vG.Y+2 + self.y

	local selfR
	selfR = Menu.wma.AddTextBox(AnimTest.subnames.color, "TgreenOf", Vector(leftv-22,vG.Y-1), Vector(21,10), nil, 
	function(result)
		if not result then
			return true
		else
			if not tonumber(result) then
				return GetStr("incorrectNumber")
			end
			AnimTest.anim.colorize.G = result / 256
			return true
		end
	end, true, nil, 1)
	selfR.text = math.ceil(AnimTest.anim.colorize.G * 255)
	selfR.textoffset = Vector(-1,-2)
	local self
	self = Menu.wma.AddGragFloat(AnimTest.subnames.color, "greenOf", Vector(leftv,vG.Y), Vector(136/2,10), nilspr, nil, 
	function(button, value, oldvalue)
		if button ~= 0 then return end
		AnimTest.anim.colorize.G = value
		selfR.text = math.ceil(value * 255)
	end, function(pos)
		--font:DrawStringScaledUTF8(math.ceil(AnimTest.anim.colorize.G * 255), pos.X-10,pos.Y-1,0.5,0.5,KColor(0.1,0.1,0.2,1),1,true)
		UIs.ColorDrager:RenderLayer(1, pos)
		self.dragCurPos.X = math.min(self.x, math.max(0, AnimTest.anim.colorize.G * self.x))
	end)
	vG.Y = vG.Y+2 + self.y

	local selfR
	selfR = Menu.wma.AddTextBox(AnimTest.subnames.color, "TblueOf", Vector(leftv-22,vG.Y-1), Vector(21,10), nil, 
	function(result)
		if not result then
			return true
		else
			if not tonumber(result) then
				return GetStr("incorrectNumber")
			end
			AnimTest.anim.colorize.B = result / 256
			return true
		end
	end, true, nil, 1)
	selfR.text = math.ceil(AnimTest.anim.colorize.B * 255)
	selfR.textoffset = Vector(-1,-2)
	local self
	self = Menu.wma.AddGragFloat(AnimTest.subnames.color, "blueOf", Vector(leftv,vG.Y), Vector(136/2,10), nilspr, nil, 
	function(button, value, oldvalue)
		if button ~= 0 then return end
		AnimTest.anim.colorize.B = value
		selfR.text = math.ceil(value * 255)
	end, function(pos)
		--font:DrawStringScaledUTF8(math.ceil(AnimTest.anim.colorize.B * 255), pos.X-10,pos.Y-1,0.5,0.5,KColor(0.1,0.1,0.2,1),1,true)
		UIs.ColorDrager:RenderLayer(2, pos)
		self.dragCurPos.X = math.min(self.x, math.max(0, AnimTest.anim.colorize.B * self.x))
	end)
	vG.Y = vG.Y+2 + self.y

	local selfR
	selfR = Menu.wma.AddTextBox(AnimTest.subnames.color, "TalphaOf", Vector(leftv-22,vG.Y-1), Vector(21,10), nil, 
	function(result)
		if not result then
			return true
		else
			if not tonumber(result) then
				return GetStr("incorrectNumber")
			end
			AnimTest.anim.colorize.A = result / 256
			return true
		end
	end, true, nil, 1)
	selfR.text = math.ceil(AnimTest.anim.colorize.A * 255)
	selfR.textoffset = Vector(-1,-2)
	local self
	self = Menu.wma.AddGragFloat(AnimTest.subnames.color, "alphaOf", Vector(leftv,vG.Y), Vector(136/2,10), nilspr, nil, 
	function(button, value, oldvalue)
		if button ~= 0 then return end
		AnimTest.anim.colorize.A = value
		selfR.text = math.ceil(value * 255)
	end, function(pos)
		--font:DrawStringScaledUTF8(math.ceil(AnimTest.anim.colorize.A * 255), pos.X-10,pos.Y-1,0.5,0.5,KColor(0.1,0.1,0.2,1),1,true)
		UIs.ColorDrager:RenderLayer(3, pos)
		self.dragCurPos.X = math.min(self.x, math.max(0, AnimTest.anim.colorize.A * self.x))
	end, 0)

	local raindow = function(x)
		local c
		local w = x * 245 + 380
		if (w >= 380 and w < 440) then
			c = Color
				(-(w - 440.) / (440. - 380.), 0.0, 1.0);
		elseif (w >= 440 and w < 490) then
			c = Color
				(0.0, (w - 440.) / (490. - 440.), 1.0 );
		elseif (w >= 490 and w < 510) then
			c = Color
				(0.0, 1.0, -(w - 510.) / (510. - 490.) );
		elseif (w >= 510 and w < 580) then
			c = Color
				( (w - 510.) / (580. - 510.), 1.0, 0.0 );
		elseif (w >= 580 and w < 645) then
			c = Color
				( 1.0, -(w - 645.) / (645. - 580.), 0.0 );
		elseif (w >= 645 and w <= 780) then
			c = Color
				(1.0, 0.0, 0.0 );
		else
			c = Color
				(0.0, 0.0, 0.0 );
		end
		return c
	end

	---@type table
	local fumo
	fumo = Menu.wma.AddButton(AnimTest.subnames.color, "fumo", Vector(100,150), 64, 16, nil, function(button) 
		if button ~= 0 then return end
		if fumo.IsSelected and fumo.IsSelected > 20 then
			--fumo.IsActived = not fumo.IsActived
			if not fumo.IsActived then
				fumo.IsActived = true
				fumo.fumo = GenSprite("gfx/editor/fumo.anm2","fumo")
				fumo.fumo.PlaybackSpeed = .5
			elseif not fumo.mode then
				fumo.mode = 1
			elseif fumo.mode == 1 then
				fumo.mode = 2
			else
				fumo.fumo = nil
				fumo.IsActived = false
				fumo.mode = nil
				fumo.fakefumo.trail:Remove()
				fumo.fakefumo = nil
			end
		end
	end,
	function(pos)
		local frame = Isaac.GetFrameCount()
		if fumo.IsSelected and fumo.IsSelected > 20 then
			fumo.fumoColor = raindow( (frame % 120 + 1) / 120) --Color((frame % 60 )/ 60, ((frame-20) % 60 )/ 60, ((frame-40) % 60) / 60, 1)
	
			Menu.wma.RenderCustomButton(pos, Vector(fumo.x, fumo.y), fumo.IsSelected, raindow( ((frame) % 120 + 1) / 120))
			Menu.wma.RenderCustomButton(pos+Vector(1,1), Vector(fumo.x-2, fumo.y-2), fumo.IsSelected)
			font:DrawStringScaledUTF8("fumo", pos.X+self.x/2-2, pos.Y+3, 0.5,0.5,KColor(fumo.fumoColor.R, fumo.fumoColor.G, fumo.fumoColor.B,1),1,true)
		end
		if fumo.fumo then 
			if fumo.mode then
				local c = Color(1,1,1,1)
				local rn = raindow( ((frame+40) % 60 + 1) / 60)
				c:SetColorize(rn.R+.3, rn.G+.3, rn.B+.3, 1)
				fumo.fumo.Color = c

				if fumo.mode == 2 then
				
					if not fumo.fakefumo then
						local rng = RNG()
						rng:SetSeed(game:GetSeeds():GetStartSeed(), 35)
						fumo.fakefumo = {Pos = pos/1, Vel = Vector(0, 0), VelRot = Vector.FromAngle(rng:RandomInt(360)), rng = rng}
						local tpos = Isaac.ScreenToWorld(fumo.fakefumo.Pos) - Vector(Isaac.GetScreenWidth()*Wtr,0)
						fumo.fakefumo.trail = Isaac.Spawn(EntityType.ENTITY_EFFECT, EffectVariant.SPRITE_TRAIL, 0, 
							tpos, Vector(0,0), nil):ToEffect()
						fumo.fakefumo.trail.MinRadius = .02
						fumo.fakefumo.trail.Scale = 20
						fumo.fakefumo.trail:GetSprite().Scale = Vector(15,1)
					else
						local screenX, screenY = Isaac.GetScreenWidth(), Isaac.GetScreenHeight()
						local fumms = fumo.fakefumo
						fumms.Vel = fumms.Vel * 0.9 + fumms.VelRot * 0.3
						fumms.Pos = fumms.Pos + fumms.Vel
						fumms.VelRot = fumms.VelRot:Rotated((fumms.rng:RandomInt(20)-10)/1)
						local nextpos = fumms.Pos + fumms.Vel*2
						if nextpos.X < 0 then
							fumms.VelRot = fumms.VelRot * 0.9 + Vector(.4,fumms.VelRot.Y)
						elseif nextpos.X > screenX-62 then
							fumms.VelRot = fumms.VelRot * 0.9 + Vector(-.4,fumms.VelRot.Y)
						elseif nextpos.Y < 44 then
							fumms.VelRot = fumms.VelRot * 0.9 + Vector(fumms.VelRot.X,.4)
						elseif nextpos.Y > screenY-62 then
							fumms.VelRot = fumms.VelRot * 0.9 + Vector(fumms.VelRot.X,-.4)
						end
						fumms.VelRot:Resize(1)
						local worpos = (fumms.Pos+fumms.Vel-Vector(screenX*1.5,0))*Wtr - Isaac.WorldToRenderPosition(Vector(0,0))   --Isaac.ScreenToWorld(fumms.Pos)
						fumms.trail.Color = c
						--fumms.trail.Velocity = (worpos+Vector(117/2-20,128/2-10)-fumms.trail.Position)
						fumms.trail.Position = (worpos+Vector(117/2-20,128/2-10))
						fumms.trail:Render(Vector(screenX*1.5,0))

						pos = fumms.Pos
					end
				end
			end
			fumo.fumo:Render(pos+Vector(fumo.x/1.5, fumo.y/1.5)) 
			fumo.fumo:Update() 
			if fumo.fumo:IsFinished() then
				fumo.fumo:Play(fumo.fumo:GetAnimation(), true)
			end
		end
	end, false, -1)
	fumo.fumoColor = Color(1,1,1,1)


	local vG = GetPlace(AnimTest.name)/1

	AnimTest.subnames.anim = "Anim_Test_anim"

	local self
	self = Menu.wma.AddButton(AnimTest.name, "animset", Vector(80,vG.Y+5), 56, 12, nil, function(button) 
		if button ~= 0 then return end
		for i,k in pairs(AnimTest.subnames) do
			AnimTest.wind:SetSubMenuVisible(k, false)
		end
		AnimTest.wind:SetSubMenuVisible(AnimTest.subnames.anim, true)
		AnimTest.wind:SetSize(AnimTest.size)
	end,
	function(pos)
		Menu.wma.RenderCustomButton(pos, Vector(self.x, self.y), self.IsSelected)
		font:DrawStringScaledUTF8(GetStr("animation"),pos.X+self.x/2,pos.Y+1,0.5,0.5,KColor(0.1,0.1,0.2,1),1,true)
	end)
	vG.Y = vG.Y+18 + self.y

	local self
	self = Menu.wma.AddGragFloat(AnimTest.subnames.anim, "frame", Vector(20,vG.Y), Vector(160,10), nil, nil, 
	function(button, value, oldvalue)
		if button ~= 0 then return end
		AnimTest.anim.spr:SetFrame(math.floor(value*AnimTest.anim.lastFrame+0.5))
	end, function(pos)
		font:DrawStringScaledUTF8(GetStr("frame"),pos.X+3,pos.Y-9,0.5,0.5,KColor(0.1,0.1,0.2,1),0,false)
		font:DrawStringScaledUTF8(AnimTest.anim.spr:GetFrame() or "",pos.X-8,pos.Y-1,0.5,0.5,KColor(0.1,0.1,0.2,1),1,true)
		Menu.wma.RenderCustomTextBox(pos, Vector(self.x, self.y-2), self.IsSelected)
		self.dragCurPos.X = ((AnimTest.anim.spr:GetFrame()/AnimTest.anim.lastFrame)) * self.x
	end, 0)
	vG.Y = vG.Y+8 + self.y
	
	local self
	self = Menu.wma.AddGragFloat(AnimTest.subnames.anim, "overlayframe", Vector(20,vG.Y), Vector(160,10), nil, nil, 
	function(button, value, oldvalue)
		if button ~= 0 then return end
		AnimTest.anim.spr:SetOverlayFrame(math.floor(value*AnimTest.anim.lastOverlayFrame+0.5))
	end, function(pos)
		font:DrawStringScaledUTF8(GetStr("overlay frame"),pos.X+3,pos.Y-9,0.5,0.5,KColor(0.1,0.1,0.2,1),0,false)
		---@diagnostic disable-next-line
		font:DrawStringScaledUTF8(AnimTest.anim.spr:GetOverlayFrame() or "",pos.X-8,pos.Y-1,0.5,0.5,KColor(0.1,0.1,0.2,1),1,true)
		Menu.wma.RenderCustomTextBox(pos, Vector(self.x, self.y-2), self.IsSelected)
		local frame = AnimTest.anim.spr:GetOverlayFrame()
		if frame == -1 then
			self.dragCurPos.X = 0
		else
			self.dragCurPos.X = ((AnimTest.anim.spr:GetOverlayFrame()/AnimTest.anim.lastOverlayFrame)) * self.x
		end
	end, 0)
	vG.Y = vG.Y+2 + self.y

	local self
	self = Menu.wma.AddTextBox(AnimTest.subnames.anim, "scale", Vector(60,vG.Y+4), Vector(32, 16), nil, 
	function(result) 
		if not result then
			return true
		else
			if not tonumber(result) then
				return GetStr("incorrectNumber")
			end
			AnimTest.anim.spr.Scale = Vector(result, AnimTest.anim.spr.Scale.Y)
			self.text = result
			return false
		end
	end, true,
	function(pos)
		font:DrawStringScaledUTF8(GetStr("scale"),pos.X-52,pos.Y+3,0.5,0.5,KColor(0.1,0.1,0.2,1),0,false)
		font:DrawStringScaledUTF8("X",pos.X-13,pos.Y-2,1,1,KColor(0.1,0.1,0.2,1),0,false)
		self.text = string.format("%.2f", AnimTest.anim.spr.Scale.X)
	end)
	self.text = 1

	local self
	self = Menu.wma.AddTextBox(AnimTest.subnames.anim, "scaleY", Vector(60+70,vG.Y+4), Vector(32, 16), nil, 
	function(result) 
		if not result then
			return true
		else
			if not tonumber(result) then
				return GetStr("incorrectNumber")
			end
			AnimTest.anim.spr.Scale = Vector(AnimTest.anim.spr.Scale.X, result)
			self.text = result
			return false
		end
	end, true,
	function(pos)
		--Menu.wma.RenderCustomTextBox(pos, Vector(self.x, self.y), self.IsSelected)
		font:DrawStringScaledUTF8("Y",pos.X-13,pos.Y-2,1,1,KColor(0.1,0.1,0.2,1),0,false)
		self.text = string.format("%.2f", AnimTest.anim.spr.Scale.Y)
	end)
	self.text = 1

	local self
	self = Menu.wma.AddButton(AnimTest.subnames.anim, "scaleXu", Vector(93,vG.Y+5-1), 16, 8, UIs.CounterUpSmol(), function(button) 
		if button ~= 0 then return end
		AnimTest.anim.spr.Scale = Vector(AnimTest.anim.spr.Scale.X+0.1, AnimTest.anim.spr.Scale.Y)
	end)
	local self
	self = Menu.wma.AddButton(AnimTest.subnames.anim, "scaleXd", Vector(93,vG.Y+5+7), 16, 8, UIs.CounterDownSmol(), function(button) 
		if button ~= 0 then return end
		AnimTest.anim.spr.Scale = Vector(AnimTest.anim.spr.Scale.X-0.1, AnimTest.anim.spr.Scale.Y)
	end)
	local self
	self = Menu.wma.AddButton(AnimTest.subnames.anim, "scaleYu", Vector(130+34,vG.Y+5-1), 16, 8, UIs.CounterUpSmol(), function(button) 
		if button ~= 0 then return end
		AnimTest.anim.spr.Scale = Vector(AnimTest.anim.spr.Scale.X, AnimTest.anim.spr.Scale.Y+0.1)
	end)
	local self
	self = Menu.wma.AddButton(AnimTest.subnames.anim, "scaleYd", Vector(130+34,vG.Y+5+7), 16, 8, UIs.CounterDownSmol(), function(button) 
		if button ~= 0 then return end
		AnimTest.anim.spr.Scale = Vector(AnimTest.anim.spr.Scale.X, AnimTest.anim.spr.Scale.Y-0.1)
	end)
	vG.Y = vG.Y+28 + self.y

	local self
	self = Menu.wma.AddGragFloat(AnimTest.subnames.anim, "rotation", Vector(20,vG.Y), Vector(160,10), nil, nil, 
	function(button, value, oldvalue)
		if button ~= 0 then return end
		AnimTest.anim.spr.Rotation = value*359
	end, function(pos)
		font:DrawStringScaledUTF8(GetStr("Rotation"),pos.X+3,pos.Y-9,0.5,0.5,KColor(0.1,0.1,0.2,1),0,false)
		Menu.wma.RenderCustomTextBox(pos, Vector(self.x, self.y-2), self.IsSelected)
		local rot = math.ceil(AnimTest.anim.spr.Rotation) -- string.format("%.2f", AnimTest.anim.spr.Rotation)
		font:DrawStringScaledUTF8(rot,pos.X-8,pos.Y-1,0.5,0.5,KColor(0.1,0.1,0.2,1),1,true)
	end, 0)
	vG.Y = vG.Y+2 + self.y
	
end

do
	local config = Isaac.GetItemConfig()
	local itemsize = config:GetCollectibles().Size
	local trinkesize = config:GetTrinkets().Size
	local cardsize = config:GetCards().Size
	--function UIs.Box48() return GenSprite("gfx/editor/ui copy.anm2","контейнер") end
	function UIs.poisk() return GenSprite("gfx/editor/ui copy2.anm2","поиск") end
	UIs.itemlist = GenSprite("gfx/editor/ui copy2.anm2","item list")
	--WORSTDEBUGMENU.AddButtonOnDebugBar(buttonName, size, sprite, pressFunc, renderFunc)

	Menu.ItemList = {name = "Item_List", size = Vector(250,156), btn = {}, poisk = {text = ""}, curtype = "col", list = {}, page = 1,
		MainList = {}, playerindex = 0, activeslot = 0, extrafilter = {MinQual=0, MaxQual=4},
		subnames = {
			trink_e = "Item_List_trinkets", filter = "Item_List_filter", 
			fil_col = "Item_List_filter_col", fil_trink = "Item_List_filter_trink", fil_card = "Item_List_filter_card"
		},
	}
	local ItemList = Menu.ItemList
	local sizev = ItemList.size

	local gridposZero = Vector(10,30)
	local nilspr = Sprite()
	local v16 = Vector(16,16+8) * .5
	local v16c = Vector(16,17) * .5
	local v5 = Vector(.5,.5)

	---@return "col" | "trin" | "card"
	local function IsType()
		return ItemList.curtype
	end

	local ItemTypeToStr = {
		--ItemConfig.
		{en = "PASSIVE", ru = "ПАССИВНЫЙ"},
		{en = "TRINKET", ru = "БРЕЛОК"},
		{en = "ACTIVE", ru = "АКТИВНЫЙ"},
		{en = "FAMILIAR", ru = "СПУТНИК"},
	}

	ItemList.IsGen = false
	function ItemList.PreGenList()
		if ItemList.extrafilter then
			if ItemList.extrafilter.OnlyType then
				local breake = true
				for i,k in pairs(ItemList.extrafilter.OnlyType) do
					breake = false
				end
				if breake then
					ItemList.extrafilter.OnlyType = nil
				end
			end
		end
		local extrafilter = ItemList.extrafilter
		if ItemList.MainList[IsType()] and ItemList.poisk.text == "" then
			ItemList.list[IsType()] = ItemList.MainList[IsType()]
		end
		local poisktext = ItemList.poisk.text
		
		ItemList.list[IsType()] = {}
		local list = ItemList.list[IsType()]
		if IsType() == "col" then
			for i=1, itemsize do
				local id = i
				local item = config:GetCollectible(id)
				if item then
					local itemname = item.Name
					itemname = string.gsub(itemname, "_", " ")
					itemname = string.gsub(itemname, "#", "")
					itemname = string.gsub(itemname, "NAME", "")

					local desc = item.Description

					local addthit = poisktext == "" 
					or string.find(string.lower(itemname), string.lower(poisktext))
					or string.find(string.lower(desc), string.lower(poisktext))
					if extrafilter.OnlyType and not extrafilter.OnlyType[item.Type] then
						addthit = false
					end
					if extrafilter.UseQual then
						local q = item.Quality or 0
						if extrafilter.MinQual > q or extrafilter.MaxQual < q then
							addthit = false
						end
					end
					if addthit then
						--local conf = config:GetCollectible(id)
						local hint = "ID: " .. id .." \n " 
						.. "TYPE: " .. (ItemTypeToStr[item.Type][Options.Language] or ItemTypeToStr[item.Type].en) .." \n " .." \n " 
						.. itemname .." \n " .. desc
						list[#list+1] = {Name = itemname, Description = desc, id = id, hint = hint}
					end
				end
			end
		elseif IsType() == "trin" then
			for i=1, trinkesize-1 do
				local id = i
				local item = config:GetTrinket(id)
				if item then
					local itemname = item.Name
					itemname = string.gsub(itemname, "_", " ")
					itemname = string.gsub(itemname, "#", "")
					itemname = string.gsub(itemname, "NAME", "")

					local desc = item.Description
					if poisktext == "" 
					or string.find(string.lower(itemname), string.lower(poisktext))
					or string.find(string.lower(desc), string.lower(poisktext)) then
						local conf = config:GetTrinket(id)
						local hint = "ID: " .. id .." \n " 
						.. "TYPE: " .. (ItemTypeToStr[conf.Type][Options.Language] or ItemTypeToStr[conf.Type].en) .." \n " .." \n " 
						.. itemname .." \n " .. desc
						list[#list+1] = {Name = itemname, Description = desc, id = id, hint = hint}
					end
				end
			end
		elseif IsType() == "card" then
			for i=1, cardsize-1 do
				local id = i
				local item = config:GetCard(id)
				if item then
					local itemname = item.Name
					itemname = string.gsub(itemname, "_", " ")
					itemname = string.gsub(itemname, "#", "")
					itemname = string.gsub(itemname, "NAME", "")

					local desc = item.Description
					if poisktext == "" 
					or string.find(string.lower(itemname), string.lower(poisktext))
					or string.find(string.lower(desc), string.lower(poisktext)) then
						local conf = config:GetCard(id)
						local hint = "ID: " .. id .." \n " .." \n "
						.. itemname .." \n " .. desc
						list[#list+1] = {Name = itemname, Description = desc, id = id, hint = hint}
					end
				end
			end
		end
		if not ItemList.MainList[IsType()] then
			--ItemList.IsGen = true
			ItemList.MainList[IsType()] = TabDeepCopy(ItemList.list[IsType()])
		end
	end

	function ItemList.tryMakeCardSprite(id, name)
		if ItemList.CardIdToPath[id] then
			local path = "mods/" .. ItemList.CardIdToPath[id] .. "/content/gfx/ui_cardfronts.anm2"
			return GenSprite(path, name)
		elseif ItemList.ModsPath then
			for i=1, #ItemList.ModsPath do
				local path = "mods/" .. ItemList.ModsPath[i] .. "/content/gfx/ui_cardfronts.anm2"
				local spr = GenSprite(path, name)
				if spr:GetAnimation() == name then
					return spr
				end
			end
		end
		return nilspr
	end
	

	function ItemList.GetCollectibleList(num)
		local start = (num-1) * 70 -- 21 * 4
		--local num = 0
		local typ = IsType()
		for j=0, 4 do
			for x=1, 14 do
				local index = start + j*14 + x

				local item = ItemList.list[typ][index] --config:GetCollectible(id)
				--local id = item.id
				local btnstr = j..","..x
				
				if item  then
					local id = item.id
					
					local conf --= config:GetCollectible(id)
					if typ == "col" then
						conf = config:GetCollectible(id)
					elseif typ == "trin" then
						conf = config:GetTrinket(id)
					elseif typ == "card" then
						conf = config:GetCard(id)
					end
					local itemname = item.Name
					--itemname = string.gsub(itemname, "_", " ")
					--itemname = string.gsub(itemname, "#", "")
					--itemname = string.gsub(itemname, "NAME", "")

					local desc = item.Description

					local spr --= GenSprite("gfx/005.100_collectible.anm2","PlayerPickup")
					if typ == "col" then
						spr = GenSprite("gfx/005.100_collectible.anm2","PlayerPickup")
						local gfx = conf.GfxFileName
						spr:ReplaceSpritesheet(1, gfx)
						spr:LoadGraphics()
						spr.Offset = v16
						spr.Scale = v5
					elseif typ == "trin" then
						spr = GenSprite("gfx/005.350_trinket.anm2","Idle")
						local gfx = conf.GfxFileName
						spr:ReplaceSpritesheet(0, gfx)
						spr:LoadGraphics()
						spr.Offset = v16
						spr.Scale = v5
					elseif typ == "card" then
						if id < 98 then
							spr = GenSprite("gfx/editor/cards.anm2", "апчхи", id-1)
							spr.Scale = v5
						else
							spr = ItemList.tryMakeCardSprite(id, conf.HudAnim)
							spr.Scale = v5
							spr.Offset = v16c
						end
					end
					local pos = gridposZero + Vector((x-1)*33, j*33) * .5
					local self
					self = Menu.wma.AddButton(ItemList.name, btnstr , pos, 16, 16, UIs.EmptyBtn(), function(button)
						if ItemList.predestal then
							if button == 0 then
								--Isaac.GetPlayer():AddCollectible(id, 20)
								ItemList.itemToSpawn = {spr = spr, type = typ, index = ItemList.playerindex, add = true, id = id}
							elseif button == 1 then
								--Isaac.GetPlayer():RemoveCollectible(id)
								ItemList.itemToSpawn = nil --{spr = spr, type = typ, index = ItemList.playerindex, remove = true, id = id}
							end
						else
							if button == 0 then
								--Isaac.GetPlayer():AddCollectible(id, 20)
								ItemList.item = {type = typ, index = ItemList.playerindex, add = true, id = id}
							elseif button == 1 then
								--Isaac.GetPlayer():RemoveCollectible(id)
								ItemList.item = {type = typ, index = ItemList.playerindex, remove = true, id = id}
							end
						end
					end,
					function(pos)
						--Menu.wma.RenderCustomButton(pos, Vector(self.x, self.y), self.IsSelected)
						spr:Render(pos)
					end)
					local text = item.hint
					--[[if typ == "col" or typ == "trin" then
						local typeitem = ItemTypeToStr[conf.Type][Options.Language] or ItemTypeToStr[conf.Type].en
						text = "ID: " .. id .." \n " 
						.. "TYPE: " .. typeitem .." \n " .." \n " 
						.. itemname .." \n " .. desc
					elseif typ == "trin" then

					end]]
					Menu.wma.ButtonSetHintText(ItemList.name, btnstr, text)
				else
					Menu.wma.RemoveButton(ItemList.name, btnstr)
				end
			end
		end
		if ItemList.page > 1 then
			local self
			self = Menu.wma.AddButton(ItemList.name, "pre", Vector(10,130), 16, 16, UIs.PrePage16(), function(button) 
				if button ~= 0 then return end
				ItemList.page = ItemList.page - 1
				ItemList.GetCollectibleList(ItemList.page)
			end)
		else
			Menu.wma.RemoveButton(ItemList.name, "pre")
		end
		
		if ((ItemList.page) * 70) < #ItemList.list[typ] then
			local self
			self = Menu.wma.AddButton(ItemList.name, "next", Vector(224,130), 16, 16, UIs.NextPage16(), function(button) 
				if button ~= 0 then return end
				ItemList.page = ItemList.page + 1
				ItemList.GetCollectibleList(ItemList.page)
			end)
		else
			Menu.wma.RemoveButton(ItemList.name, "next")
		end
	end

	Menu:AddCallback(ModCallbacks.MC_POST_UPDATE, function()
		if ItemList.item then
			if ItemList.item.type == "col" then
				if ItemList.item.add then
					if ItemList.activeslot > 1 then
						Isaac.GetPlayer(ItemList.item.index):SetPocketActiveItem(ItemList.item.id, ItemList.activeslot)
					else
						Isaac.GetPlayer(ItemList.item.index):AddCollectible(ItemList.item.id, -1, nil, ItemList.activeslot)
					end
				elseif ItemList.item.remove then
					Isaac.GetPlayer(ItemList.item.index):RemoveCollectible(ItemList.item.id, nil, ItemList.activeslot)
				end
			elseif ItemList.item.type == "trin" then
				if ItemList.item.add then
					local id = ItemList.item.id
					if ItemList.goldtrink then
						id = id + TrinketType.TRINKET_GOLDEN_FLAG
					end
					if ItemList.gulp then
						if Renderer then
							Isaac.GetPlayer(ItemList.item.index):AddSmeltedTrinket(id)
						else
							local player = Isaac.GetPlayer(ItemList.item.index)
							local tr1, tr2, tr3 = player:GetTrinket(0), player:GetTrinket(1), player:GetTrinket(2)
							if tr1 ~= 0 then
								player:TryRemoveTrinket(tr1)
							end
							if tr2 ~= 0 then
								player:TryRemoveTrinket(tr2)
							end
							if tr3 ~= 0 then
								player:TryRemoveTrinket(tr3)
							end
							
							player:AddTrinket(id)
							player:UseActiveItem(CollectibleType.COLLECTIBLE_SMELTER, UseFlag.USE_NOANIM)

							if tr1 ~= 0 then
								player:AddTrinket(tr1, false)
							end
							if tr2 ~= 0 then
								player:AddTrinket(tr2, false)
							end
							if tr3 ~= 0 then
								player:AddTrinket(tr3, false)
							end
						end
					else
						Isaac.GetPlayer(ItemList.item.index):AddTrinket(id)
					end
				elseif ItemList.item.remove then
					Isaac.GetPlayer(ItemList.item.index):TryRemoveTrinket(ItemList.item.id)
				end
			elseif ItemList.item.type == "card" then
				if ItemList.item.add then
					Isaac.GetPlayer(ItemList.item.index):AddCard(ItemList.item.id)
				elseif ItemList.item.remove then
				end
			end
			ItemList.item = nil
		end
	end)

	local self
	self = WORSTDEBUGMENU.AddButtonOnDebugBar("Item_List_Menu", Vector(32,32), UIs.itemlist, function(button) 
		if button ~= 0 then return end
		---@type Window
		ItemList.wind = Menu.wma.ShowWindow(ItemList.name, self.pos+Vector(0,15), sizev)
		for i,k in pairs(ItemList.subnames) do
			ItemList.wind:SetSubMenuVisible(k, false)
		end
		if not ItemList.IsGen then
			ItemList.PreGenList()
		end

		ItemList.GetCollectibleList(ItemList.page)
		
		if ItemList.page > 1 then
			local self
			self = Menu.wma.AddButton(ItemList.name, "pre", Vector(10,130), 16, 16, UIs.PrePage16(), function(button) 
				if button ~= 0 then return end
				ItemList.page = ItemList.page - 1
				ItemList.GetCollectibleList(ItemList.page)
			end)
		end
		if (ItemList.page) * 70 < itemsize then
			local self
			self = Menu.wma.AddButton(ItemList.name, "next", Vector(224,130), 16, 16, UIs.NextPage16(), function(button) 
				if button ~= 0 then return end
				ItemList.page = ItemList.page + 1
				ItemList.GetCollectibleList(ItemList.page)
			end)
		end
	end, nil)
	Menu.wma.ButtonSetHintText("__debug_menu", "Item_List_Menu", GetStr("Item_List_Menu_hintText"))

	local self
	self = Menu.wma.AddButton(ItemList.name, "поиск", Vector(10,12), 16, 16, UIs.poisk(), function(button) 
		if button ~= 0 then return end
		ItemList.page = 1
		ItemList.PreGenList()
		ItemList.GetCollectibleList(ItemList.page)
	end)
	Menu.wma.ButtonSetHintText(ItemList.name, "поиск", GetStr("useless_poisk"))

	UIs.ItemList_col = GenSprite("gfx/editor/ui copy2.anm2","itemlist_collectible")
	local self
	self = Menu.wma.AddButton(ItemList.name, "collectible", Vector(158,12), 16, 16, UIs.ItemList_col, function(button) 
		if button ~= 0 then return end
		ItemList.page = 1
		ItemList.curtype = "col"
		ItemList.PreGenList()
		ItemList.GetCollectibleList(ItemList.page)

		ItemList.wind:SetSubMenuVisible(ItemList.subnames.trink_e, false)
		if ItemList.FilterOpen then
			ItemList.wind:SetSubMenuVisible(ItemList.subnames.fil_col, true)
			ItemList.wind:SetSubMenuVisible(ItemList.subnames.fil_trink, false)
			ItemList.wind:SetSubMenuVisible(ItemList.subnames.fil_card, false)
		end
	end)
	UIs.ItemList_trink = GenSprite("gfx/editor/ui copy2.anm2","itemlist_trinket")
	local self
	self = Menu.wma.AddButton(ItemList.name, "trinket", Vector(176,12), 16, 16, UIs.ItemList_trink, function(button) 
		if button ~= 0 then return end
		ItemList.page = 1
		ItemList.curtype = "trin"
		ItemList.PreGenList()
		ItemList.GetCollectibleList(ItemList.page)

		ItemList.wind:SetSubMenuVisible(ItemList.subnames.trink_e, true)
		if ItemList.FilterOpen then
			ItemList.wind:SetSubMenuVisible(ItemList.subnames.fil_col, false)
			ItemList.wind:SetSubMenuVisible(ItemList.subnames.fil_trink, true)
			ItemList.wind:SetSubMenuVisible(ItemList.subnames.fil_card, false)
		end
	end)
	UIs.ItemList_card = GenSprite("gfx/editor/ui copy2.anm2","itemlist_card")
	local self
	self = Menu.wma.AddButton(ItemList.name, "card", Vector(194,12), 16, 16, UIs.ItemList_card, function(button) 
		if button ~= 0 then return end
		ItemList.page = 1
		ItemList.curtype = "card"
		ItemList.PreGenList()
		ItemList.GetCollectibleList(ItemList.page)

		ItemList.wind:SetSubMenuVisible(ItemList.subnames.trink_e, false)
		if ItemList.FilterOpen then
			ItemList.wind:SetSubMenuVisible(ItemList.subnames.fil_col, false)
			ItemList.wind:SetSubMenuVisible(ItemList.subnames.fil_trink, false)
			ItemList.wind:SetSubMenuVisible(ItemList.subnames.fil_card, true)
		end
	end)

	local self
	self = Menu.wma.AddButton(ItemList.name, "playerindex", Vector(28+34,130), 52, 16, nil, function(button) 
		if button ~= 0 then return end
		ItemList.playerindex = (ItemList.playerindex + 1) % (game:GetNumPlayers())
	end,
	function(pos)
		Menu.wma.RenderCustomButton(pos, Vector(self.x, self.y), self.IsSelected)
		font:DrawStringScaledUTF8(GetStr("playerindex") .. " " .. ItemList.playerindex, pos.X+2,pos.Y+2,.5,.5,KColor(0.1,0.1,0.2,1),0,false)
	end)

	UIs.ActiveSlot = GenSprite("gfx/editor/ui copy2.anm2","slots")
	UIs.ActiveSlotOverlay = GenSprite("gfx/editor/ui copy2.anm2","slots_ov")
	local self
	self = Menu.wma.AddButton(ItemList.name, "activeslot", Vector(116,130), 16, 16, UIs.ActiveSlot, function(button) 
		if button ~= 0 then return end
		if ItemList.predestal then
			ItemList.predestal = not ItemList.predestal
			UIs.ActiveSlot.Color = Color(1,1,1,1)
			Menu.RemoveOlaceModeByName("ItemList_OnRock")
		else
			ItemList.activeslot = (ItemList.activeslot + 1) % 4
		end
	end,
	function(pos)
		if ItemList.predestal or IsType() ~= "col" then
			UIs.ActiveSlot.Color = Color(1,1,1,.4)
		else
			UIs.ActiveSlot.Color = Color(1,1,1,1)
			UIs.ActiveSlotOverlay:SetFrame(ItemList.activeslot)
			UIs.ActiveSlotOverlay:Render(pos)
		end
	end)
	Menu.wma.ButtonSetHintText(ItemList.name, "activeslot", GetStr("activeslot"))


	UIs.ItemRock = GenSprite("gfx/editor/ui copy2.anm2","пьедистал")
	local self
	self = Menu.wma.AddButton(ItemList.name, "onrock", Vector(134,130), 16, 16, UIs.ItemRock, function(button) 
		if button ~= 0 then return end
		ItemList.predestal = not ItemList.predestal
		UIs.ActiveSlot.Color = Color(1,1,1,1)

		Menu.PlaceMode("ItemList_OnRock", ItemList.PlacePress, ItemList.PlaceLogic, 
		function()
			ItemList.predestal = nil
			UIs.ActiveSlot.Color = Color(1,1,1,1)
		end)
	end,
	function(pos)
		if ItemList.predestal then
			UIs.Var_Sel:Render(pos+Vector(2,8))
		end
	end)
	Menu.wma.ButtonSetHintText(ItemList.name, "onrock", GetStr("SpawnOnpedestal"))

	function ItemList.PlacePress(btn, pos)
		if not ItemList.itemToSpawn or btn ~= 0 or not ItemList.wind or ItemList.wind.IsHided or not Menu.wma.OnFreePos then return end

		local tt = IsType()
		if tt == "col" then
			Isaac.Spawn(5,100, ItemList.itemToSpawn.id, pos, Vector(0,0), Isaac.GetPlayer(ItemList.playerindex))
		elseif tt == "trin" then
			local id = ItemList.itemToSpawn.id
			if ItemList.goldtrink then
				id = id + TrinketType.TRINKET_GOLDEN_FLAG
			end
			Isaac.Spawn(5,350, id, pos, Vector(0,0), Isaac.GetPlayer(ItemList.playerindex))
		elseif tt == "card" then
			Isaac.Spawn(5,300, ItemList.itemToSpawn.id, pos, Vector(0,0), Isaac.GetPlayer(ItemList.playerindex))
		end
	end

	function ItemList.PlaceLogic(pos)
		if ItemList.wind and ItemList.wind.Removed then
			ItemList.wind = nil
		end
		if ItemList.predestal and ItemList.wind and not ItemList.wind.IsHided
		and ItemList.itemToSpawn and ItemList.itemToSpawn.spr then
			
			UIs.entspawnerpoint:Render(pos)
			local prescale = ItemList.itemToSpawn.spr.Scale/1
			ItemList.itemToSpawn.spr.Scale = Vector(1,1)
			ItemList.itemToSpawn.spr:Render(pos+Vector(-8,-16))
			ItemList.itemToSpawn.spr.Scale = prescale
		end
	end

	local self
	self = Menu.wma.AddTextBox(ItemList.name, "poisktext", Vector(28,12), Vector(128, 16), nil, 
	function(result) 
		if not result then
			return true
		else
			if #result < 1 or not string.find(result,"%S") then
				--return GetStr("emptyField")
				result = ""
			end
			ItemList.poisk.text = result
			ItemList.page = 1
			ItemList.PreGenList()
			ItemList.GetCollectibleList(ItemList.page)
			return true
		end
	end, false,
	function(pos)
		--Menu.wma.RenderCustomTextBox(pos, Vector(self.x, self.y), self.IsSelected)
		--font:DrawStringScaledUTF8("Y",pos.X-13,pos.Y-2,1,1,KColor(0.1,0.1,0.2,1),0,false)
	end)
	self.text = ""
	--ItemList.subnames.trink_e

	UIs.GulpedTrink = GenSprite("gfx/editor/ui copy2.anm2","gulp_trink")
	local self
	self = Menu.wma.AddButton(ItemList.subnames.trink_e, "gulp", Vector(152,130), 16, 16, UIs.GulpedTrink, function(button) 
		if button ~= 0 then return end
		ItemList.gulp = not ItemList.gulp
	end,
	function(pos)
		if ItemList.gulp then
			UIs.Var_Sel:Render(pos+Vector(2,8))
		end
	end)
	Menu.wma.ButtonSetHintText(ItemList.subnames.trink_e, "gulp", GetStr("itemlist_gulp"))
	UIs.GoldemTrink = GenSprite("gfx/editor/ui copy2.anm2","gold_trink")
	local self
	self = Menu.wma.AddButton(ItemList.subnames.trink_e, "gold", Vector(170,130), 16, 16, UIs.GoldemTrink, function(button) 
		if button ~= 0 then return end
		ItemList.goldtrink = not ItemList.goldtrink
	end,
	function(pos)
		if ItemList.goldtrink then
			UIs.Var_Sel:Render(pos+Vector(2,8))
		end
	end)
	Menu.wma.ButtonSetHintText(ItemList.subnames.trink_e, "gold", GetStr("itemlist_gold"))

	local line
	UIs.ItemFilter= GenSprite("gfx/editor/ui copy2.anm2","filter")
	local self
	self = Menu.wma.AddButton(ItemList.name, "filter", Vector(224.5,12), 16, 16, UIs.ItemFilter, function(button) 
		if button ~= 0 then return end
		ItemList.FilterOpen = not ItemList.FilterOpen
		ItemList.wind:SetSubMenuVisible(ItemList.subnames.filter, ItemList.FilterOpen)

		if ItemList.FilterOpen then
			ItemList.wind:SetSize( Vector(ItemList.size.X+70,ItemList.size.Y) )
			local istype = IsType()
			if istype == "col" then
				ItemList.wind:SetSubMenuVisible(ItemList.subnames.fil_col, true)
			elseif istype == "trin" then
				ItemList.wind:SetSubMenuVisible(ItemList.subnames.fil_trink, true)
			else
				ItemList.wind:SetSubMenuVisible(ItemList.subnames.fil_card, true)
			end
		else
			ItemList.wind:SetSize( ItemList.size )

			ItemList.wind:SetSubMenuVisible(ItemList.subnames.fil_col, false)
			ItemList.wind:SetSubMenuVisible(ItemList.subnames.fil_trink, false)
			ItemList.wind:SetSubMenuVisible(ItemList.subnames.fil_card, false)
		end
	end,
	function (pos)
		if ItemList.FilterOpen then
			UIs.HintTextBG1.Color = Color(.5,.5,.5)
			UIs.HintTextBG1.Scale = Vector(.5, (ItemList.wind.size.Y-22)/2)
			UIs.HintTextBG1:Render(pos +  Vector(19,0))
		end
	end)

	---------------------------------------------------------------
	local rlvec = Vector(248,24)

	local self
	self = Menu.wma.AddButton(ItemList.subnames.fil_col, "fil_passive", rlvec/1, 62, 10, nilspr, function(button) 
		if button ~= 0 then return end
		self.Show = not self.Show
		if ItemList.extrafilter.OnlyType then
			ItemList.extrafilter.OnlyType[ItemType.ITEM_PASSIVE] = self.Show or nil
		else
			ItemList.extrafilter.OnlyType = {[ItemType.ITEM_PASSIVE] = self.Show}
		end
		
		ItemList.page = 1
		ItemList.PreGenList()
		ItemList.GetCollectibleList(ItemList.page)
	end, function(pos)
		Menu.wma.RenderCustomButton(pos, Vector(self.x,self.y), self.IsSelected)
		local text = ItemTypeToStr[ItemType.ITEM_PASSIVE][Options.Language] or ItemTypeToStr[ItemType.ITEM_PASSIVE].en
		--font:DrawStringScaledUTF8(text, pos.X +1, pos.Y, .5, .5, KColor(0.1,0.1,0.2,1),0,false)
		if not self.Show then
			--UIs.Var_Sel:Render(pos+Vector(-5,-2))
			font:DrawStringScaledUTF8(text, pos.X +1, pos.Y+1, .5, .5, KColor(0.4,0.5,0.7,1),0,false)
		else
			font:DrawStringScaledUTF8(text, pos.X +1, pos.Y+1, .5, .5, KColor(0.1,0.1,0.2,1),0,false)
		end
		font:DrawStringScaledUTF8(GetStr("ByType"), pos.X, pos.Y-12, .5, .5, KColor(0.1,0.1,0.2,1),0,false)
	end)
	rlvec.Y = rlvec.Y + 11

	local self
	self = Menu.wma.AddButton(ItemList.subnames.fil_col, "fil_active", rlvec/1, 62, 10, nilspr, function(button) 
		if button ~= 0 then return end
		self.Show = not self.Show
		if ItemList.extrafilter.OnlyType then
			ItemList.extrafilter.OnlyType[ItemType.ITEM_ACTIVE] = self.Show or nil
		else
			ItemList.extrafilter.OnlyType = {[ItemType.ITEM_ACTIVE] = self.Show}
		end
		
		ItemList.page = 1
		ItemList.PreGenList()
		ItemList.GetCollectibleList(ItemList.page)
	end, function(pos)
		Menu.wma.RenderCustomButton(pos, Vector(self.x,self.y), self.IsSelected)
		local text = ItemTypeToStr[ItemType.ITEM_ACTIVE][Options.Language] or ItemTypeToStr[ItemType.ITEM_ACTIVE].en
		--font:DrawStringScaledUTF8(text, pos.X +1, pos.Y, .5, .5, KColor(0.1,0.1,0.2,1),0,false)
		if not self.Show then
			--UIs.Var_Sel:Render(pos+Vector(-5,-2))
			font:DrawStringScaledUTF8(text, pos.X +1, pos.Y+1, .5, .5, KColor(0.4,0.5,0.7,1),0,false)
		else
			font:DrawStringScaledUTF8(text, pos.X +1, pos.Y+1, .5, .5, KColor(0.1,0.1,0.2,1),0,false)
		end
	end)
	rlvec.Y = rlvec.Y + 11

	local self
	self = Menu.wma.AddButton(ItemList.subnames.fil_col, "fil_fam", rlvec/1, 62, 10, nilspr, function(button) 
		if button ~= 0 then return end
		self.Show = not self.Show
		if ItemList.extrafilter.OnlyType then
			ItemList.extrafilter.OnlyType[ItemType.ITEM_FAMILIAR] = self.Show or nil
		else
			ItemList.extrafilter.OnlyType = {[ItemType.ITEM_FAMILIAR] = self.Show}
		end
		
		ItemList.page = 1
		ItemList.PreGenList()
		ItemList.GetCollectibleList(ItemList.page)
	end, function(pos)
		Menu.wma.RenderCustomButton(pos, Vector(self.x,self.y), self.IsSelected)
		local text = ItemTypeToStr[ItemType.ITEM_FAMILIAR][Options.Language] or ItemTypeToStr[ItemType.ITEM_FAMILIAR].en
		--font:DrawStringScaledUTF8(text, pos.X +1, pos.Y, .5, .5, KColor(0.1,0.1,0.2,1),0,false)
		if not self.Show then
			--UIs.Var_Sel:Render(pos+Vector(-5,-2))
			font:DrawStringScaledUTF8(text, pos.X +1, pos.Y+1, .5, .5, KColor(0.4,0.5,0.7,1),0,false)
		else
			font:DrawStringScaledUTF8(text, pos.X +1, pos.Y+1, .5, .5, KColor(0.1,0.1,0.2,1),0,false)
		end
	end)
	rlvec.Y = rlvec.Y + 14

	local self
	self = Menu.wma.AddButton(ItemList.subnames.fil_col, "qul", rlvec/1, 12, 12, nilspr, function(button) 
		if button ~= 0 then return end
		self.Show = not self.Show
		ItemList.extrafilter.UseQual = not ItemList.extrafilter.UseQual
		
		ItemList.page = 1
		ItemList.PreGenList()
		ItemList.GetCollectibleList(ItemList.page)
	end, function(pos)
		Menu.wma.RenderCustomButton(pos, Vector(self.x,self.y), self.IsSelected)
		if self.Show then
			self.flag:Render(pos)
		end
		font:DrawStringScaledUTF8(GetStr("quality"), pos.X+13, pos.Y+.5, .5, .5, KColor(0.1,0.1,0.2,1),0,false)
	end)
	self.flag = UIs.Flag() self.flag.Offset = Vector(-2,-3)
	rlvec.Y = rlvec.Y + 20

	local self
	self = Menu.wma.AddCounter(ItemList.subnames.fil_col, "qul_counter_min", rlvec/1, 32, nil,
	Menu.wma.DefNumberResultCheck(function(result)
		local toret
		if result>4 or result<0 then
			toret = false
			result = math.max(0, math.min(4, result))
			self.text = result
		end
		ItemList.extrafilter.MinQual = result

		if ItemList.extrafilter.UseQual then
			ItemList.page = 1
			ItemList.PreGenList()
			ItemList.GetCollectibleList(ItemList.page)
		end
		return toret
	end),
	function(pos)
		font:DrawStringScaledUTF8(GetStr("min"), pos.X+1, pos.Y-8, .5, .5, KColor(0.1,0.1,0.2,1),0,false)
	end, true, 0, 0, 4, true)

	local self
	self = Menu.wma.AddCounter(ItemList.subnames.fil_col, "qul_counter_max", rlvec/1+Vector(35,0), 32, nil,
	Menu.wma.DefNumberResultCheck(function(result)
		local toret
		if result>4 or result<0 then
			toret = false
			result = math.max(0, math.min(4, result))
			self.text = result
		end
		ItemList.extrafilter.MaxQual = result

		if ItemList.extrafilter.UseQual then
			ItemList.page = 1
			ItemList.PreGenList()
			ItemList.GetCollectibleList(ItemList.page)
		end
		return toret
	end),
	function(pos)
		font:DrawStringScaledUTF8(GetStr("max"), pos.X+1, pos.Y-8, .5, .5, KColor(0.1,0.1,0.2,1),0,false)
	end, true, 4, 0, 4, true)


	local self
	self = Menu.wma.AddButton(ItemList.subnames.fil_trink, "nil", Vector(230,12), 16, 16, nilspr, function(button) 
	end)

	local self
	self = Menu.wma.AddButton(ItemList.subnames.fil_card, "nil", Vector(230,12), 16, 16, nilspr, function(button) 
	end)


	Menu:AddCallback("WORSTDEBUGMENU_GET_MODS_PATH", function()
		if SamaelMod then
			return SamaelMod, "samael_897795840"
		end
	end)
	Menu:AddCallback("WORSTDEBUGMENU_GET_MODS_PATH", function()
		if MASTEMA  then
			return MASTEMA , "mastema_2548070298"
		end
	end)

	function ItemList.GetModErrorConteinerFunc(func)
		if CBEncapsulationFx.EncapsulatedFunc[func] then
			for i,k in pairs(CBEncapsulationFx.EncapsulatedFunc) do
				if k == func and i ~= func then
					return i
				end
			end
		end
	end

	--Это может сломать запуск? ДА!
	function ItemList.TryGenCardpathList()
		local calls = Isaac.GetCallbacks(ModCallbacks.MC_USE_CARD)
		ItemList.CardIdToPath = {}
		ItemList.ModsPath = {}
		local mods = {}

		local precalls = Isaac.GetCallbacks("WORSTDEBUGMENU_GET_MODS_PATH")
		for i=1, #precalls do
			local cal = precalls[i]
			local result, result2 = cal.Function()
			if type(result2) == "string" then
				mods[result] = {path = result2, ids = {}}
				ItemList.ModsPath[#ItemList.ModsPath+1] = result2
			end
		end
		
		for i=1, #calls do
			local cal = calls[i]
			mods[cal.Mod] = mods[cal.Mod] or {path = -1, ids = {}}

			if mods[cal.Mod].path == -1 then
				local func = cal.Function
				if CBEncapsulationFx then
					func = ItemList.GetModErrorConteinerFunc(func) or func
				end
				local ok, gg = pcall(func)
				if gg then
					local fz,fx = string.find(gg,"mods/[%S%s]-/")
					if fz and fx then
						local path = string.sub(gg,fz+5,fx-1)
						print("found path: ", path)
						if path then
							mods[cal.Mod].path = path
							ItemList.ModsPath[#ItemList.ModsPath+1] = path
						end
					end
				end
			end

			if cal.Param then
				mods[cal.Mod].ids[cal.Param] = true
			--	ItemList.CardIdToPath[cal.Param] = mods[cal.Mod].path
			end
		end
		for i,k in pairs(mods) do
			if k.path ~= -1 then
				for id in pairs(k.ids) do
					ItemList.CardIdToPath[id] = k.path
				end
			end
		end
		local sfx = SFXManager()
		local mun = -1
		::loop::
		mun = mun + 1
		if not pcall(function() sfx:Stop(mun) end) and mun < 1300 then
			goto loop
		end
	end
	if not Isaac.GetPlayer() and TryGetPathForCard then
		ItemList.TryGenCardpathList()
	elseif ibackthis.ModsPath then
		ItemList.ModsPath = ibackthis.ModsPath
		ItemList.CardIdToPath = ibackthis.CardIdToPath
	end

	UIs.ThisGuy = GenSprite("gfx/editor/ui copy2.anm2","этого")
	function Menu.ItemListRender()
		if not ItemList.wind or ItemList.wind.Removed or ItemList.wind.IsHided or not ItemList.playerindex then return end
		local player = Isaac.GetPlayer(ItemList.playerindex)
		local renderpos = Isaac.WorldToScreen(player.Position)
		UIs.ThisGuy:Render(renderpos+Vector(0.5,-40))
	end

end

do
	UIs.SoundTest = GenSprite("gfx/editor/ui copy2.anm2","sound test")
	UIs.blockThis = GenSprite("gfx/editor/ui copy2.anm2","blocksy")
	UIs.playsoundsmol = GenSprite("gfx/editor/ui copy2.anm2","sound play")
	UIs.blockThis.Scale = Vector(.5,.5)
	--UIs.blockThis = function() return GenSprite("gfx/editor/ui copy2.anm2","blocksy") end

	Menu.SoundTest = {name = "SoundTest", subnames = {}, size = Vector(220,190), btn = {}, 
		list = {}, revlist = {}, block = {}, max = 60, showmax = 15, listpos = 0, RecordEnabled = true,
		volume = 1, pitch = 1, pan = 0
	}
	local SoundTest = Menu.SoundTest
	local sizev = SoundTest.size

	local self
	self = WORSTDEBUGMENU.AddButtonOnDebugBar("Sound_Test_Menu", Vector(32,32), UIs.SoundTest, function(button) 
		if button ~= 0 then return end
		---@type Window
		SoundTest.wind = Menu.wma.ShowWindow(SoundTest.name, self.pos+Vector(0,15), sizev)
		for i,k in pairs(SoundTest.subnames) do
			SoundTest.wind:SetSubMenuVisible(k, false)
		end
	end, nil)
	Menu.wma.ButtonSetHintText("__debug_menu", "Sound_Test_Menu", GetStr("Sound_Test_Menu_hintText"))

	local list, revlist = SoundTest.list, SoundTest.revlist

	local rebild
	local function makelistbtn(i)
		local offst = font:GetStringWidthUTF8("222 ")/2

		local posX =  12 + i*9
		local ar = list[i]
		local self
		local block
		self = Menu.wma.AddButton(SoundTest.name, "list"..i, Vector(32, posX), 176, 9, nilspr, function(button)
			if button ~= 0 then return end
			sfx:Play(list[i][1], SoundTest.volume, 5, false, SoundTest.pitch, SoundTest.pan)
		end, function(pos, visible)
			if list[i] and visible then
				if not self.IsSelected then
					if i%2 == 0 then
						--Menu.wma.RenderCustomButton(pos, Vector(self.x,self.y), self.IsSelected)
						UIs.HintTextBG1.Color = Color(.8,.8,.8, .5)
					else
						--Menu.wma.RenderCustomTextBox(pos, Vector(self.x,self.y), self.IsSelected)
						UIs.HintTextBG1.Color = Color(1.2, 1.2, 1.2, .5)
					end
				else
					UIs.HintTextBG1.Color = Color(0.7, 1.0, 1.3, .5, .2,.2,.4)
				end
				UIs.HintTextBG1.Scale = Vector(self.x/2, self.y/2)
				UIs.HintTextBG1:Render(pos)

				local kc = KColor(0.1,0.1,0.2,1)
				--[[if list[i][3] then
					font:DrawStringScaledUTF8(list[i][1], pos.X+1, pos.Y-1, .5, .5, KColor(0.1,0.1,0.2,1),0,false)
					font:DrawStringScaledUTF8(list[i][2], pos.X+1+offst, pos.Y-1, .5, .5, KColor(0.1,0.1,0.2,1),0,false)
				else
					font:DrawStringScaledUTF8(list[i][2], pos.X+1, pos.Y-1, .5, .5, KColor(0.1,0.1,0.2,1),0,false)
				end]]
				if self.IsSelected then
					if list[i][3] then
						---@type string
						local text = list[i][2]
						if font:GetStringWidth(text)/2 + offst > 160 then
							if utf8.len(text) > 23 then
								text = Menu.wma.utf8_Sub(text, 0, 23) .. "..."
							else
								text = Menu.wma.utf8_Sub(text, 0, utf8.len(text)-2) .. "..."
							end
						end
						font:DrawStringScaledUTF8(list[i][1], pos.X+1, pos.Y-1, .5, .5, KColor(0.1,0.1,0.2,1),0,false)
						font:DrawStringScaledUTF8(text, pos.X+1+offst, pos.Y-1, .5, .5, KColor(0.1,0.1,0.2,1),0,false)
					else
						local text = list[i][2]
						if font:GetStringWidth(text)/2 > 160 then
							if utf8.len(text) > 27 then
								text = Menu.wma.utf8_Sub(text, 0, 23+4) .. "..."
							else
								text = Menu.wma.utf8_Sub(text, 0, utf8.len(text)-2) .. "..."
							end
						end
						font:DrawStringScaledUTF8(text, pos.X+1, pos.Y-1, .5, .5, KColor(0.1,0.1,0.2,1),0,false)
					end

					UIs.playsoundsmol:Render(pos + Vector(self.x-11,1))
				else
					if list[i][3] then
						font:DrawStringScaledUTF8(list[i][1], pos.X+1, pos.Y-1, .5, .5, KColor(0.1,0.1,0.2,1),0,false)
						font:DrawStringScaledUTF8(list[i][2], pos.X+1+offst, pos.Y-1, .5, .5, KColor(0.1,0.1,0.2,1),0,false)
					else
						font:DrawStringScaledUTF8(list[i][2], pos.X+1, pos.Y-1, .5, .5, KColor(0.1,0.1,0.2,1),0,false)
					end
				end
			elseif not list[i] then
				Menu.wma.RemoveButton(SoundTest.name, "list"..i)
			end
		end, nil, 1)
		self.posfunc = function()
			self.posref.Y = SoundTest.listpos + posX
			block.posref.Y = SoundTest.listpos + posX
			local pos = self.pos.Y - SoundTest.wind.pos.Y
			--if self.posref.Y-12 > SoundTest.showmax*9 or self.posref.Y < 12 then
			if pos-12 > SoundTest.showmax*9 or pos < 12 then
				self.visible = false
				self.canPressed = false
				block.visible = false
				block.canPressed = false
			else
				self.visible = true
				self.canPressed = true
				block.visible = true
				block.canPressed = true
			end
		end

		SoundTest.btn[i] = self

		local sp = UIs.EmptyBtn()
		sp.Scale = Vector(.5,.5)
		block = Menu.wma.AddButton(SoundTest.name, "block"..i, Vector(12, 12 + i*9), 9, 9, sp, function(button)
			if button ~= 0 then return end
			revlist[list[i][1]] = nil
			local pre = #list
			table.remove(list, i)
			SoundTest.btn[pre] = nil
			Menu.wma.RemoveButton(SoundTest.name, "list"..i)
			Menu.wma.RemoveButton(SoundTest.name, "block"..i)
			rebild()
		end, function(pos, visible)
			if list[i] and visible then
				UIs.blockThis:RenderLayer(1, pos)
			elseif not list[i] then
				Menu.wma.RemoveButton(SoundTest.name, "block"..i)
			end
		end, nil, 0)
	end

	rebild = function(add)
		for i=1, #list do
			makelistbtn(i)
		end
	end

	local self
	self = Menu.wma.AddButton(SoundTest.name, "sound_record", Vector(0,0), 1, 1, nilspr, function(button) 
	end, function(pos)
		UIs.HintTextBG1.Color = Color(1.2,1.2,1.2)
		UIs.HintTextBG1.Scale = Vector(101, 5)
		UIs.HintTextBG1:Render(pos + Vector(6,9+1))
		UIs.HintTextBG1.Scale = Vector(101, 8)
		UIs.HintTextBG1:Render(pos + Vector(6,15+SoundTest.showmax*9))

		if SoundTest.RecordEnabled then
			for name, id in pairs(SoundEffect) do
				if sfx:IsPlaying(id) and not revlist[id] then
					local tid = tostring(id)
					local del = false
					local message
					if font:GetStringWidthUTF8(tid .. " ")/2 < 18 then
						del = true
						message = "- " .. tostring(name)
					else
						message = tid .. " - " .. tostring(name)
					end

					revlist[id] = true
					list[#list+1] = {id, message, del}
					if #list > SoundTest.max then
						revlist[list[1][1]] = nil
						table.remove(list, 1)
					end
				end
			end
		end
		for i=1, SoundTest.max do
			if list[i] and not SoundTest.btn[i] then
				makelistbtn(i)
			end
		end
	end, true)

	--[[for i=1, SoundTest.max do
		local self
		self = Menu.wma.AddButton(SoundTest.name, "list"..i, Vector(24, 12 + i*9), 180, 9, nilspr, function(button) 
		end, function(pos)
			if list[i] then
				Menu.wma.RenderCustomButton(pos, Vector(self.x,self.y), self.IsSelected)
				font:DrawStringScaledUTF8(list[i][2], pos.X+1, pos.Y-1, .5, .5, KColor(0.1,0.1,0.2,1),0,false)
			end
		end)
		SoundTest.btn[i] = self
	end]]

	local self
	self = Menu.wma.AddScrollBar(SoundTest.name, "list_bar",Vector(210,20),Vector(7,SoundTest.showmax*9-6),nil,nil,
	function(button, value)
		if button ~= 0 then return end
		--print(value, self.dragCurPos)
		SoundTest.listpos = -value
	end,
	function(pos, visible)
		if visible then

			Menu.wma.RenderCustomTextBox(pos+Vector(1,0),Vector(self.x-2,self.y),false)
		end
	end,0,0,SoundTest.max*9-6, 2)
	self.posfunc = function()
		self.endValue = #list*9
		self.visible = self.endValue > self.x
		self.canPressed = self.visible
	end
	self.visible = false
	self.canPressed = false


	local self
	self = Menu.wma.AddButton(SoundTest.name, "recordseter", Vector(20,10), 16, 10, nilspr, function(button) 
		if button ~= 0 then return end
		SoundTest.RecordEnabled = not SoundTest.RecordEnabled
	end, function(pos, visible)
		Menu.wma.RenderCustomButton2(pos, self)
		if SoundTest.RecordEnabled then
			self.flag:Render(pos + Vector(0,-5))
		end
		font:DrawStringScaledUTF8(GetStr("sound_record"), pos.X+2+self.x, pos.Y, .5, .5, KColor(0.1,0.1,0.2,1),0,false)
	end, nil, -2)
	self.flag = UIs.Flag()

	local self
	self = Menu.wma.AddCounter(SoundTest.name, "volume", Vector(6,SoundTest.showmax*9+15), 76, nil, 
	Menu.wma.DefNumberResultCheck(
	function (newText)
		SoundTest.volume = tonumber(newText)
		self.text = SoundTest.volume
		return false
	end)
	, function (pos, visible)
		--Menu.wma.RenderCustomTextBox(pos,Vector(self.x,self.y),false)
		font:DrawStringScaledUTF8(GetStr("volume"), pos.X+1, pos.Y+3, .5, .5, KColor(0.1,0.1,0.2,1),0,false)
		--font:DrawStringScaledUTF8(string.format("%.2f", tostring(self.text)), pos.X+42, pos.Y+3, .5, .5, KColor(0.1,0.1,0.2,1),0,false)
	end,
	true, 1, function (btn)
		self.text = self.text - .1
		SoundTest.volume = tonumber(self.text)
		self.text = math.abs(self.text)<0.1 and 0 or self.text
	end, function (btn)
		self.text = self.text + .1
		SoundTest.volume = tonumber(self.text)
		self.text = math.abs(self.text)<0.1 and 0 or self.text
	end,nil,-1)
	self.textoffset = Vector(38,0)
	if Options.Language == "ru" then
		Menu.wma.ButtonSetHintText(SoundTest.name, "volume", GetStr("volume_rus_unshort"))
	end

	local self
	self = Menu.wma.AddCounter(SoundTest.name, "pitch", Vector(6+76,SoundTest.showmax*9+15), 70, nil, 
	Menu.wma.DefNumberResultCheck(
	function (newText)
		SoundTest.pitch = tonumber(newText)
		self.text = SoundTest.pitch
		return false
	end)
	, function (pos, visible)
		--Menu.wma.RenderCustomTextBox(pos,Vector(self.x,self.y),false)
		font:DrawStringScaledUTF8(GetStr("pitch"), pos.X+1, pos.Y+3, .5, .5, KColor(0.1,0.1,0.2,1),0,false)
		--font:DrawStringScaledUTF8(string.format("%.2f", tostring(self.text)), pos.X+42, pos.Y+3, .5, .5, KColor(0.1,0.1,0.2,1),0,false)
	end,
	true, 1, function (btn)
		self.text = self.text - .1
		SoundTest.pitch = tonumber(self.text)
		self.text = math.abs(self.text)<0.1 and 0 or self.text
	end, function (btn)
		self.text = self.text + .1
		SoundTest.pitch = tonumber(self.text)
		self.text = math.abs(self.text)<0.1 and 0 or self.text
	end,nil,-1)
	self.textoffset = Vector(38-6,0)

	local self
	self = Menu.wma.AddCounter(SoundTest.name, "pan", Vector(6+80+66,SoundTest.showmax*9+15), 62, nil, 
	Menu.wma.DefNumberResultCheck(
	function (newText)
		SoundTest.pan = tonumber(newText) % 4
		self.text = SoundTest.pan
		return false
	end)
	, function (pos, visible)
		font:DrawStringScaledUTF8(GetStr("pan"), pos.X+1, pos.Y+3, .5, .5, KColor(0.1,0.1,0.2,1),0,false)
	end,
	true, 0, function (btn)
		self.text = math.max(-1, self.text - .25) % 4
		SoundTest.pan = tonumber(self.text)
		self.text = math.abs(self.text)<0.1 and 0 or self.text
	end, function (btn)
		self.text = math.min(5,  self.text + .25) % 4
		SoundTest.pan = tonumber(self.text)
		self.text = math.abs(self.text)<0.1 and 0 or self.text
	end, nil, -1)
	self.textoffset = Vector(26-6,0)
	if Options.Language == "ru" then
		Menu.wma.ButtonSetHintText(SoundTest.name, "pan", GetStr("pan_rus_unshort"))
	end


	local self
	self = Menu.wma.AddTextBox(SoundTest.name, "manual", Vector(6+54, SoundTest.showmax*9+36), Vector(32,12), nil,
	function(newResult)
		if #newResult == 0 then
			SoundTest.ManID = nil
			return true
		end
		if not tonumber(newResult) then
			return GetStr("incorrectNumber")
		end
		newResult = tonumber(newResult)
		if newResult < 1 then
			self.text = 1
			SoundTest.ManID = 1
		else
			self.text = math.ceil(newResult)
			SoundTest.ManID = self.text
		end
		return false
	end, true, 
	function(pos, Visible)
		font:DrawStringScaledUTF8(GetStr("manual_sound"), pos.X+1-54, pos.Y+1, .5, .5, KColor(0.1,0.1,0.2,1),0,false)
	end)
	self.textoffset = Vector(0,-1)

	UIs.playsoundbig = function() return GenSprite("gfx/editor/ui copy2.anm2","sound play b") end
	local self
	self = Menu.wma.AddButton(SoundTest.name, "play manll id", Vector(60 + 34, SoundTest.showmax*9+34), 16, 16, UIs.playsoundbig(), function(button)
		if button ~= 0 then return end
		if SoundTest.ManID then
			sfx:Play(SoundTest.ManID, SoundTest.volume, 5, false, SoundTest.pitch, SoundTest.pan)

			if not revlist[SoundTest.ManID] then
				local tid = tostring(SoundTest.ManID)
				local del = false
				local message
				local name = "???"
				for i,k in pairs(SoundEffect) do
					if k == SoundTest.ManID then
						name = i
						break
					end
				end
				if font:GetStringWidthUTF8(tid .. " ")/2 < 18 then
					del = true
					message = "- " .. tostring(name)
				else
					message = tid .. " - " .. tostring(name)
				end

				revlist[SoundTest.ManID] = true
				list[#list+1] = {SoundTest.ManID, message, del}
				if #list > SoundTest.max then
					revlist[list[1][1]] = nil
					table.remove(list, 1)
				end
				makelistbtn(#list)
			end
		end
	end)
end

do
	UIs.EntDebug = GenSprite("gfx/editor/ui copy2.anm2","ent test")
	--UIs.blockThis = function() return GenSprite("gfx/editor/ui copy2.anm2","blocksy") end
	for i=0, 7 do
		UIs["EntDebug_debug" .. i] = GenSprite("gfx/editor/ui copy2.anm2","ent_debug", i)
	end

	Menu.EntDebug = {name = "EntDebug", subnames = {status = "Ent_Debug_Menu_status"}, size = Vector(160,80), btn = {}, 
		mode = "all",
	}
	local EntDebug = Menu.EntDebug
	local sizev = EntDebug.size
	local btn = EntDebug.btn

	local self
	self = WORSTDEBUGMENU.AddButtonOnDebugBar("Ent_Debug_Menu", Vector(32,32), UIs.EntDebug, function(button) 
		if button ~= 0 then return end
		---@type Window
		EntDebug.wind = Menu.wma.ShowWindow(EntDebug.name, self.pos+Vector(0,15), sizev)
		for i,k in pairs(EntDebug.subnames) do
			EntDebug.wind:SetSubMenuVisible(k, false)
		end
		EntDebug.wind:SetSubMenuVisible(EntDebug.subnames.status, true)
	end, nil)
	Menu.wma.ButtonSetHintText("__debug_menu", "Ent_Debug_Menu", GetStr("Ent_Debug_Menu_hintText"))

	local vl = Vector(6, 14)
	local self
	self = Menu.wma.AddButton(EntDebug.name, "status", vl/1, 47, 12, nilspr, function(button)
		if button ~= 0 then return end
		for i,k in pairs(EntDebug.subnames) do
			EntDebug.wind:SetSubMenuVisible(k, false)
		end
		EntDebug.wind:SetSubMenuVisible(EntDebug.subnames.status, true)
	end, function(pos, visible)
		Menu.wma.RenderCustomButton2(pos, self)
		font:DrawStringScaledUTF8(GetStr("ent_status"), pos.X+2, pos.Y, .5, .5, KColor(0.1,0.1,0.2,1),0,false)
	end)


	local vg = Vector(6, 34)
	btn.fear = Menu.wma.AddButton(EntDebug.subnames.status, "fear", vg/1, 16, 16, UIs.EmptyBtn(), function(button)
		if button ~= 0 then return end
		btn.fear.IsActived = not btn.fear.IsActived
	end, function(pos, visible)
		UIs.EntDebug_debug0:Render(pos)
		if btn.fear.IsActived then
			UIs.Var_Sel:Render(btn.fear.pos + Vector(2,12))
		end
	end)

	vg.X = vg.X + 18

	btn.charm = Menu.wma.AddButton(EntDebug.subnames.status, "charm", vg/1, 16, 16, UIs.EmptyBtn(), function(button)
		if button ~= 0 then return end
		btn.charm.IsActived = not btn.charm.IsActived
	end, function(pos, visible)
		UIs.EntDebug_debug1:Render(pos)
		if btn.charm.IsActived then
			UIs.Var_Sel:Render(btn.charm.pos + Vector(2,12))
		end
	end)

	vg.X = vg.X + 18

	btn.confus = Menu.wma.AddButton(EntDebug.subnames.status, "confus", vg/1, 16, 16, UIs.EmptyBtn(), function(button)
		if button ~= 0 then return end
		btn.confus.IsActived = not btn.confus.IsActived
	end, function(pos, visible)
		UIs.EntDebug_debug4:Render(pos)
		if btn.confus.IsActived then
			UIs.Var_Sel:Render(btn.confus.pos + Vector(2,12))
		end
	end)

	vg.X = vg.X + 18

	btn.friend = Menu.wma.AddButton(EntDebug.subnames.status, "friend", vg/1, 16, 16, UIs.EmptyBtn(), function(button)
		if button ~= 0 then return end
		btn.friend.IsActived = not btn.friend.IsActived
	end, function(pos, visible)
		UIs.EntDebug_debug5:Render(pos)
		if btn.friend.IsActived then
			UIs.Var_Sel:Render(btn.friend.pos + Vector(2,12))
		end
	end)

	vg.X = vg.X + 18

	btn.stone = Menu.wma.AddButton(EntDebug.subnames.status, "stone", vg/1, 16, 16, UIs.EmptyBtn(), function(button)
		if button ~= 0 then return end
		btn.stone.IsActived = not btn.stone.IsActived
	end, function(pos, visible)
		UIs.EntDebug_debug2:Render(pos)
		if btn.stone.IsActived then
			UIs.Var_Sel:Render(btn.stone.pos + Vector(2,12))
		end
	end)

	vg.X = vg.X + 18

	btn.midas = Menu.wma.AddButton(EntDebug.subnames.status, "midas", vg/1, 16, 16, UIs.EmptyBtn(), function(button)
		if button ~= 0 then return end
		btn.midas.IsActived = not btn.midas.IsActived
	end, function(pos, visible)
		UIs.EntDebug_debug6:Render(pos)
		if btn.midas.IsActived then
			UIs.Var_Sel:Render(btn.midas.pos + Vector(2,12))
		end
	end)

	vg.X = vg.X + 18

	btn.smol = Menu.wma.AddButton(EntDebug.subnames.status, "smol", vg/1, 16, 16, UIs.EmptyBtn(), function(button)
		if button ~= 0 then return end
		btn.smol.IsActived = not btn.smol.IsActived
	end, function(pos, visible)
		UIs.EntDebug_debug7:Render(pos)
		if btn.smol.IsActived then
			UIs.Var_Sel:Render(btn.smol.pos + Vector(2,12))
		end
	end)

	vg.X = vg.X + 18


	local fear
	local charm
	local confus
	local friend
	local stone
	local midas
	local smol
	---@param ent Entity
	local function ApplyStatusEffects(ent, ref)
		if fear then
			ent:AddFear(ref, 1)
		end
		if charm then
			ent:AddCharmed(ref, 1)
		end
		if confus then
			ent:AddConfusion(ref, 1, false)
		end
		if friend then
			ent:AddCharmed(ref, -1)
		end
		if stone then
			ent:AddFreeze(ref, 1)
		end
		if midas then
			ent:AddMidasFreeze(ref, 1)
		end
		if smol then
			ent:AddShrink(ref, 2)
		end
	end

	Menu:AddCallback(ModCallbacks.MC_POST_UPDATE, function()
		if EntDebug.wind and not EntDebug.wind.IsHided then
			local playerref = EntityRef(Isaac.GetPlayer())
			local flag = 0
			 fear = btn.fear.IsActived
			 charm = btn.charm.IsActived
			 confus = btn.confus.IsActived
			 friend = btn.friend.IsActived
			 stone = btn.stone.IsActived
			 midas = btn.midas.IsActived
			 smol = btn.smol.IsActived

			if btn.fear.IsActived then
				flag = flag | EntityFlag.FLAG_FEAR
			end
			if EntDebug.mode == "all" then
				local list = Isaac.FindInRadius(Vector(320,280), 600, EntityPartition.ENEMY)
				for i=1, #list do
					local ent = list[i]
					--ent:AddEntityFlags()
					--[[if fear then
						ent:AddFear(EntityRef(ent), 1)
					end
					if charm then
						ent:AddCharmed(playerref, 1)
					end
					if confus then
						ent:AddConfusion(playerref, 1, false)
					end]]
					ApplyStatusEffects(ent, playerref)
				end
			end
		end
	end)
end




-- Thanks Cucco
Menu:AddCallback(ModCallbacks.MC_POST_PLAYER_INIT, function()
	if #Isaac.FindByType(EntityType.ENTITY_PLAYER) == 0 then
		Isaac.ExecuteCommand("reloadshaders")
	end
end)