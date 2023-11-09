---@class menuTab
---@field IsMouseBtnTriggered fun(button)
---@field AddButton fun(menuName, buttonName, pos, sizeX, sizeY, sprite, pressFunc, renderFunc, notpressed, priority):EditorButton
---@field AddTextBox fun(menuName, buttonName, pos, size, sprite, resultCheckFunc, onlyNumber, renderFunc, priority):EditorButton
---@field AddGragZone fun(menuName, buttonName, pos, size, sprite, DragFunc, renderFunc, priority):EditorButton
---@field AddGragFloat fun(menuName, buttonName, pos, size, sprite, dragSpr, DragFunc, renderFunc, priority):EditorButton
---@field GetButton fun(menuName, buttonName, noError):EditorButton
---@field ButtonSetHintText fun(menuName, buttonName, text, NoError)
---@field RemoveButton fun(menuName, buttonName, NoError)
---@field FastCreatelist fun(Menuname, Pos, XSize, params, pressFunc, up)
---@field ShowWindow fun(menuName, pos, size, color )
---@field CloseWindow fun(MenuName)
---@field SetWindowSize fun(wind:Window, size:Vector)
---@field RenderCustomTextBox fun(pos, size, isSel)
---@field RenderCustomButton fun(pos, size, isSel)
---@field RenderButtonHintText function
---@field SelectedMenu any
---@field IsStickyMenu boolean
---@field MouseHintText string
---@field MousePos Vector
---@field HandleWindowControl function
---@field RenderWindows function
---@field Callbacks table
---@field OnFreePos boolean
---@field ScrollOffset Vector

return function(mod)

local menuTab = {}
menuTab.Callbacks = {}
local Callbacks = {
	WINDOW_PRE_RENDER = {},
	WINDOW_POST_RENDER = {},
}
local function addCallbackID(name)
	menuTab.Callbacks[name] = setmetatable({},{__concat = function(t,b) return "[WGA] "..name..b end})
end 
for i,k in pairs(Callbacks) do
	addCallbackID(i)
end

menuTab.MousePos = Vector(0,0)
menuTab.SelectedMenu = "grid"
menuTab.IsStickyMenu = false
menuTab.MouseSprite = nil
menuTab.SelectedGridType = ""
menuTab.GridListMenuPage = 1

menuTab.MenuData = {}
menuTab.MenuButtons = {}

--local mod = WORSTDEBUGMENU --RegisterMod("worst window api", 1)

local game = Game()
local Isaac = Isaac
local string = string
local Input = Input
local Vector = Vector
local font = Font()
font:Load("font/upheaval.fnt")
local TextBoxFont = Font()
TextBoxFont:Load("font/pftempestasevencondensed.fnt")

local function GetCurrentModPath() -- взято из epiphany
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
		local _, _err = pcall(require, "")	-- require a file that doesn't exist
		-- Mod:Log(_err)
		for str in _err:gmatch("no file '.*/mods/.-.lua'\n") do
			return str:sub(1, -7):sub(10)
		end
	end
end
local path = GetCurrentModPath()
TextBoxFont:Load(path .. "resources/font_e/pftempestasevencondensed_noShadow.fnt")



local function utf8_Sub(str, x, y)
	local x2, y2
	x2 = utf8.offset(str, x)
	if y then
		y2 = utf8.offset(str, y + 1)
		if y2 then
			y2 = y2 - 1
		end
	end
	if x2 == nil then error("bad argument #2 to 'sub' (position is not correct)",2) end
	return string.sub(str, x2, y2)
end

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

local function PrintTab(tab, level)
	level = level or 0
	
	if type(tab) == "table" then
		for i,k in pairs(tab) do
			local offset = ""
			if level and level>0 then
				for j = 0, level do
					offset = offset .. " "
				end
			end
			print(offset .. i,k)
			if type(k) == "table" then
				PrintTab(k, level+1)
			end
		end
	end
end
local DeepPrint = function(...)
	for i,k in pairs({...}) do
		if type(k) == "table" then 
			print(k)
			PrintTab(k,1)
		else
			print(k)
		end
	end
end
local function findAndRemove(tab, param)
	for i,k in pairs(tab) do
		if param == k then
			table.remove(tab, i)
		end
	end
end


menuTab.strings = {
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
}
local function GetStr(str)
	if menuTab.strings[str] then
		return menuTab.strings[str][Options.Language] or menuTab.strings[str].en or str
	else
		return str
	end
end


--menuTab.UIs = {}
local UIs = {} --menuTab.UIs
--[[
UIs.MenuUp = GenSprite("gfx/editor/ui copy.anm2","фон_вверх")
UIs.MouseGrab = GenSprite("gfx/editor/ui copy.anm2","mouse_grab")
UIs.Mouse_Tile_edit = GenSprite("gfx/editor/ui copy.anm2","mouse_tileEdit")
UIs.GridList = GenSprite("gfx/editor/ui copy.anm2","gridListMenu")
UIs.HintQ = GenSprite("gfx/editor/ui copy.anm2","hintQ")
UIs.ToLog = GenSprite("gfx/editor/ui copy.anm2","ВЛог")
UIs.TestRun = GenSprite("gfx/editor/ui copy.anm2","ТестовыйПрогон")
UIs.OverlayBarL = GenSprite("gfx/editor/ui copy.anm2","оверлей_лпц",0)
UIs.OverlayBarR = GenSprite("gfx/editor/ui copy.anm2","оверлей_лпц",1)
UIs.OverlayBarC = GenSprite("gfx/editor/ui copy.anm2","оверлей_лпц",2)
--UIs.OverlayTab1 = GenSprite("gfx/editor/ui copy.anm2","оверлей_вкладка",0)
--UIs.OverlayTab2 = GenSprite("gfx/editor/ui copy.anm2","оверлей_вкладка",1)
--UIs.PositionSbros = GenSprite("gfx/editor/ui copy.anm2","сброс поз")
UIs.TextBoxPopupBack = GenSprite("gfx/editor/ui copy.anm2","всплывашка")
UIs.MouseTextEd = GenSprite("gfx/editor/ui copy.anm2","mouse_textEd")]]
UIs.TextEdPos = GenSprite("gfx/editor/ui copy.anm2","TextEd_pos")
--[[
UIs.RoomSelectBack = GenSprite("gfx/editor/ui copy.anm2","фон_вверх")
UIs.RoomSelectBack.Rotation = -90
UIs.RoomSelect = GenSprite("gfx/editor/ui copy.anm2","room_select")
UIs.RoomSelectWarn = GenSprite("gfx/editor/ui copy.anm2","room_select_warn")
UIs.SpcEDIT_menu_Up = GenSprite("gfx/editor/ui copy.anm2","всплывашка_ручная")
UIs.SpcEDIT_menu_Cen = GenSprite("gfx/editor/ui copy.anm2","всплывашка_ручная",1)
UIs.SpcEDIT_menu_Down = GenSprite("gfx/editor/ui copy.anm2","всплывашка_ручная",2)
UIs.Flag = GenSprite("gfx/editor/ui copy.anm2","флажок")
UIs.Hint_MouseMoving = GenSprite("gfx/editor/ui copy.anm2","hint_mouse_move")
UIs.Hint_MouseMoving_Vert = GenSprite("gfx/editor/ui copy.anm2","hint_mouse_move",1)
UIs.Hint_tileEdit = GenSprite("gfx/editor/ui copy.anm2","hint_tile_edit")
UIs.RG_icon = GenSprite("gfx/editor/ui copy.anm2","рг")
if Isaac_Tower and not Isaac_Tower.RG then
	local gray = Color(1,1,1,1)
	gray:SetColorize(1,1,1,1)
	UIs.RG_icon.Color = gray
end]]
UIs.HintTextBG1 = GenSprite("gfx/editor/ui copy.anm2","фон_для_вспом_текста")
UIs.HintTextBG2 = GenSprite("gfx/editor/ui copy.anm2","фон_для_вспом_текста",1)
UIs.TextBoxBG = GenSprite("gfx/editor/ui copy.anm2","textbox_custom")
UIs.ButtonBG = GenSprite("gfx/editor/ui copy.anm2","button_custom")
--[[
UIs.SolidMode1 = GenSprite("gfx/editor/ui copy.anm2","твёрдаяКлетка")
UIs.SolidMode2 = GenSprite("gfx/editor/ui copy.anm2","прозрачнаяКлетка")
UIs.SolidMode3 = GenSprite("gfx/editor/ui copy.anm2","КлеткаБезКоллизии")
UIs.SolidMode4 = GenSprite("gfx/editor/ui copy.anm2","ЛомающиесяКлетка")
UIs.EnemiesMode1 = GenSprite("gfx/editor/ui copy.anm2","враги")
UIs.EnemiesMode2 = GenSprite("gfx/editor/ui copy.anm2","бонусы")
UIs.PinedPos = GenSprite("gfx/editor/special_tiles.anm2","pin point")
UIs.Setting = GenSprite("gfx/editor/ui copy.anm2","настройки")
]]
for i=0,6 do
	UIs["MenuActulae" .. i] = GenSprite("gfx/editor/ui copy.anm2","меню наконец то", i)
	UIs["MenuActulae" .. i].Color = Color(1,1,1,.25)
end
--[[
UIs.RoomEditor_debug = GenSprite("gfx/editor/ui copy.anm2","room_editor_debug")
UIs.luamod_debug = GenSprite("gfx/editor/ui copy.anm2","luamod_debug")


function UIs.Box48() return GenSprite("gfx/editor/ui copy.anm2","контейнер") end
function UIs.Counter() return GenSprite("gfx/editor/ui copy.anm2","счётчик") end
function UIs.CounterSmol() return GenSprite("gfx/editor/ui copy.anm2","счётчик_smol") end
function UIs.CounterUp() return GenSprite("gfx/editor/ui copy.anm2","поднять") end
function UIs.CounterDown() return GenSprite("gfx/editor/ui copy.anm2","опустить") end
function UIs.CounterUpSmol() return GenSprite("gfx/editor/ui copy.anm2","поднять_smol") end
function UIs.CounterDownSmol() return GenSprite("gfx/editor/ui copy.anm2","опустить_smol") end
function UIs.PrePage() return GenSprite("gfx/editor/ui copy.anm2","лево") end
function UIs.NextPage() return GenSprite("gfx/editor/ui copy.anm2","право") end
function UIs.OverlayTab1() return GenSprite("gfx/editor/ui copy.anm2","оверлей_вкладка1") end
function UIs.OverlayTab2() return GenSprite("gfx/editor/ui copy.anm2","оверлей_вкладка2") end
function UIs.PopupTextBox() return GenSprite("gfx/editor/ui copy.anm2","контейнер_всплывашки") end
function UIs.ButtonWide() return GenSprite("gfx/editor/ui copy.anm2","кнопка_широкая") end
function UIs.Erase() return GenSprite("gfx/editor/ui copy.anm2","стереть") end
function UIs.TextBoxSmol() return GenSprite("gfx/editor/ui copy.anm2","конт_текста_smol") end
]]
function UIs.Var_Sel()    end
--[[
function UIs.Edit_Button() return GenSprite("gfx/editor/ui copy.anm2","кнопка_редакта") end
function UIs.FlagBtn() return GenSprite("gfx/editor/ui copy.anm2","кнопка флага") end
function UIs.TextBox() return GenSprite("gfx/editor/ui copy.anm2","конт_текста") end
function UIs.BigPlus() return GenSprite("gfx/editor/ui copy.anm2","плюс") end
function UIs.GridModeOn() return GenSprite("gfx/editor/ui copy.anm2","режим_сетки") end
function UIs.GridModeOff() return GenSprite("gfx/editor/ui copy.anm2","режим_сетки_выкл") end
function UIs.PositionSbros() return GenSprite("gfx/editor/ui copy.anm2","сброс поз") end
function UIs.GridOverlayTab1() return GenSprite("gfx/editor/ui copy.anm2","вкладка1") end
function UIs.GridOverlayTab2() return GenSprite("gfx/editor/ui copy.anm2","вкладка2") end
]]
function UIs.CloseBtn() return GenSprite("gfx/editor/ui copy.anm2","закрыть") end

local MouseBtnIsPressed = {[0] = 0,0,0}
function menuTab.IsMouseBtnTriggered(button)
	if not MouseBtnIsPressed[button] then
		MouseBtnIsPressed[button] = 1
		return true
	else
		return MouseBtnIsPressed[button] == 1
	end
end
mod:AddCallback(ModCallbacks.MC_POST_RENDER, function() -- MC_POST_UPDATE MC_POST_RENDER
	for i,k in pairs(MouseBtnIsPressed) do
		if Input.IsMouseBtnPressed(i) then
			MouseBtnIsPressed[i] = MouseBtnIsPressed[i] + 1
		else
			MouseBtnIsPressed[i] = 0
		end
	end
end)

---@class EditorButton 
---@field name any
---@field pos Vector
---@field posref Vector
---@field x number
---@field y number
---@field spr Sprite
---@field func function
---@field render function
---@field canPressed boolean
---@field hintText table
---@field IsSelected boolean
---@field posfunc function
---@field IsTextBox boolean
---@field text string
---@field visible boolean
---@field isDragZone boolean?
---@field dragPrePos Vector?
---@field dragCurPos Vector?
---@field isDrager boolean?
---@field dragtype integer?
---@field dragspr Sprite?

---@class EditorMenu
---@field sortList table<integer, {["btn"]:any, ["Priority"]:integer, }>
---@field somethingPressed boolean
---@field Buttons table<string, EditorButton>
---@field CalledByWindow Window?

---@return EditorMenu?
function menuTab.GetMenu(menuName)
	if menuTab.MenuData[menuName] then
		return menuTab.MenuData[menuName]
	end
end

---@return nil|EditorButton
function menuTab.GetButton(menuName, buttonName, Error)
	if not menuTab.MenuData[menuName] then
		if not Error then return end
		error("This menu does not exist",2)
	elseif not menuTab.MenuData[menuName].Buttons[buttonName] then
		if not Error then return end
		error("This button does not exist",2)
	end
	return menuTab.MenuData[menuName] and menuTab.MenuData[menuName].Buttons[buttonName]
end

function menuTab.GetButtons(menuName, Error)
	if not menuTab.MenuData[menuName] then
		if not Error then return end
		error("This menu does not exist",2)
	elseif not menuTab.MenuData[menuName].Buttons then
		if not Error then return end
		error("This button does not exist",2)
	end
	return menuTab.MenuData[menuName] and menuTab.MenuData[menuName].Buttons
end

---@param func fun(self:EditorButton)
function menuTab.AddButtonPosFunc(menuName, buttonName, func)
	menuTab.GetButton(menuName, buttonName).posfunc = func
end

function menuTab.RemoveButton(menuName, buttonName, NoError)
	if not menuTab.MenuData[menuName] then
		if NoError then return end
		error("This menu does not exist",2)
	elseif not menuTab.MenuData[menuName].Buttons[buttonName] then
		return
		--error("This button does not exist",2)
	end
	menuTab.MenuData[menuName].Buttons[buttonName] = nil
	for i,k in pairs(menuTab.MenuData[menuName].sortList) do
		if k.btn == buttonName then
			table.remove(menuTab.MenuData[menuName].sortList, i)
		end
	end
end

function menuTab.ButtonSetHintText(menuName, buttonName, text, NoError)
	if not menuTab.MenuData[menuName] then
		if NoError then return end
		error("This menu does not exist",2)
	elseif not menuTab.MenuData[menuName].Buttons[buttonName] then
		if NoError then return end
		error("This button does not exist",2)
	end
	if menuTab.MenuData[menuName].Buttons[buttonName] then
		local BoxWidth = 150
		local str = {}
		if BoxWidth ~= 0 then
			local maxWidth = 0
			local spaceLeft = BoxWidth
			local words = {}
			for word in string.gmatch(text, '([^ ]+)') do --Split string into individual words
				words[#words+1] = word;
			end
			text = ""
			for i=1, #words do
				local wordLength = font:GetStringWidthUTF8(words[i])*0.5
				if (words[i] == "\n") then --Word is purely breakline
					--text = text.."\n"
					str[#str+1] = text
					text = ""
				elseif (utf8_Sub(words[i], 1, 2) == "\n") then --Word starts with breakline
					spaceLeft = BoxWidth - wordLength
					text = text..words[i].." "
				elseif (wordLength > spaceLeft) then --Word breaks text boundary
					spaceLeft = BoxWidth - wordLength
					str[#str+1] = text
					text = ""
					text = words[i].." " --text.."\n"..
				else --Word is fine
					maxWidth = math.max(BoxWidth-spaceLeft, maxWidth)
					spaceLeft = spaceLeft - wordLength
					text = text..words[i].." "
				end
				maxWidth = math.max(BoxWidth-spaceLeft+2, maxWidth)
			end
			str[#str+1] = text
			str.Width = maxWidth
		end
		--for i,k in pairs(str) do
		--	Isaac.DebugString(i .. k)
		--end
		menuTab.MenuData[menuName].Buttons[buttonName].hintText = str
	end
end

---@return EditorButton|nil
function menuTab.AddButton(menuName, buttonName, pos, sizeX, sizeY, sprite, pressFunc, renderFunc, notpressed, priority)
    if menuName and buttonName then
		menuTab.MenuData[menuName] = menuTab.MenuData[menuName] or {sortList = {}, Buttons = {}}
		local menu = menuTab.MenuData[menuName]
		if menu.Buttons[buttonName] then
			menuTab.RemoveButton(menuName, buttonName)
		end
		menu.sortList = menu.sortList or {}
		menu.Buttons = menu.Buttons or {}
		menu.Buttons[buttonName] = {name = buttonName, pos = pos, posref = Vector(pos.X,pos.Y), x = sizeX, y = sizeY, spr = sprite, 
			func = pressFunc, render = renderFunc, canPressed = not notpressed, visible = true}
		
		priority = priority or 0
		local Spos = #menu.sortList+1
		for i=#menu.sortList,1,-1 do
			if menu.sortList[i].Priority <= priority then
				break
			else
				Spos = Spos-1
			end
		end
		table.insert(menu.sortList, Spos, {btn = buttonName, Priority = priority})
		return menu.Buttons[buttonName]
    end
end

---@class Window
---@field pos Vector
---@field size Vector
---@field color Color
---@field InFocus integer
---@field MovingByMouse boolean
---@field MouseOldPos Vector
---@field OldPos Vector
---@field Removed boolean
---@field plashka EditorButton
---@field SubMenus table?
---@field somethingPressed boolean
menuTab.WindowMeta = {}
menuTab.WindowMetaTable = {__index = menuTab.WindowMeta}
--TSJDNHC.FGrid.__index = TSJDNHC.Grid



menuTab.Windows = {menus = {}, order = {}}

local nilspr = Sprite()
local nilfunc = function() end
---@return Window?
function menuTab.ShowWindow(menuName, pos, size, color )
	if menuName then
		pos = pos or Vector(0,0)
		size = size or Vector(32,32)
		if menuTab.Windows.menus[menuName] then
			menuTab.Windows.menus[menuName].pos = pos
			return menuTab.Windows.menus[menuName]
		end

		menuTab.Windows.menus[menuName] = {pos = pos, size = size, color = color, MouseOldPos = menuTab.MousePos, OldPos = Vector(pos.X,pos.Y)}
		menuTab.Windows.order[#menuTab.Windows.order+1] = menuName

		if not menuTab.GetButton(menuName, "__close") then
			local self
			self = menuTab.AddButton(menuName, "__close", Vector(size.X-16,0), 16, 8, UIs.CloseBtn() , function(button) 
				if button ~= 0 then return end
				menuTab.CloseWindow(menuName)
			end)
		end
		if not menuTab.GetButton(menuName, "__blockplashka") then
			local self
			self = menuTab.AddButton(menuName, "__blockplashka", Vector(0,0), size.X, size.Y, nilspr, nilfunc , nil, nil, 10)
			self.BlockPress = true
			menuTab.Windows.menus[menuName].plashka = self
		end

		setmetatable(menuTab.Windows.menus[menuName], menuTab.WindowMetaTable)

		return menuTab.Windows.menus[menuName]
	end
end
function menuTab.CloseWindow(menuName)
	findAndRemove(menuTab.Windows.order, menuName)
	menuTab.Windows.menus[menuName].Removed = true
	menuTab.Windows.menus[menuName] = nil
end

---@param wind Window
---@param size Vector
function menuTab.WindowMeta.SetSize(wind, size)
	if wind and size and size.X then
		wind.size = size
		wind.plashka.x = size.X
		wind.plashka.y = size.Y
	end
end

---@param wind Window
---@param MenuName any
---@param Add boolean
function menuTab.WindowMeta.SetSubMenu(wind, MenuName, Add) --useless
	wind.SubMenus = wind.SubMenus or {}
	if Add == false then
		wind.SubMenus[MenuName] = nil
	else
		wind.SubMenus[MenuName] = Add and {visible = false}
	end
end

---@param wind Window
---@param MenuName any
---@param Vis boolean
function menuTab.WindowMeta.SetSubMenuVisible(wind, MenuName, Vis)
	wind.SubMenus = wind.SubMenus or {}
	if not wind.SubMenus[MenuName] then
		menuTab.WindowMeta.SetSubMenu(wind, MenuName, true)
	end
	wind.SubMenus[MenuName].visible = Vis
end

---@param wind Window
---@param MenuName any
function menuTab.WindowMeta.IsSubMenuVisible(wind, MenuName)
	wind.SubMenus = wind.SubMenus or {}
	if not wind.SubMenus[MenuName] then
		menuTab.WindowMeta.SetSubMenu(wind, MenuName, false)
	end
	return wind.SubMenus[MenuName].visible
end


---@return EditorButton|nil
function menuTab.AddTextBox(menuName, buttonName, pos, size, sprite, resultCheckFunc, onlyNumber, renderFunc, priority)
    if menuName and buttonName then
		menuTab.MenuData[menuName] = menuTab.MenuData[menuName] or {sortList = {}, Buttons = {}}
		local menu = menuTab.MenuData[menuName]
		if menu.Buttons[buttonName] then
			menuTab.RemoveButton(menuName, buttonName)
		end

		local resultCheck = function(newtext)
			local result = resultCheckFunc(newtext)
			if result == true then
				if onlyNumber then
					menu.Buttons[buttonName].text = tonumber(newtext)
				else
					menu.Buttons[buttonName].text = newtext
				end
				return true
			elseif result == false then
				return true
			elseif type(result) == "string" then
				return result
			end
		end

		menu.sortList = menu.sortList or {}
		menu.Buttons = menu.Buttons or {}
		menu.Buttons[buttonName] = {name = buttonName, pos = pos, posref = Vector(pos.X,pos.Y), x = size.X, y = size.Y, spr = sprite, 
			resultCheckFunc = resultCheckFunc, render = renderFunc, canPressed = true, visible = true}
		local self = menu.Buttons[buttonName]
		self.IsTextBox = true
		self.func = function(button)
			if button ~= 0 then return end
			self.TextBoxinFocus = true
			menuTab.OpenTextbox(menuName, buttonName, onlyNumber, resultCheck, self.text or self.starttext)
		end

		priority = priority or 0
		local Spos = #menu.sortList+1
		for i=#menu.sortList,1,-1 do
			if menu.sortList[i].Priority <= priority then
				break
			else
				Spos = Spos-1
			end
		end
		table.insert(menu.sortList, Spos, {btn = buttonName, Priority = priority})
		return menu.Buttons[buttonName]
    end
end

menuTab.SelectedDragZone = nil

---@return EditorButton|nil
function menuTab.AddGragZone(menuName, buttonName, pos, size, sprite, DragFunc, renderFunc, priority)
    if menuName and buttonName then
		menuTab.MenuData[menuName] = menuTab.MenuData[menuName] or {sortList = {}, Buttons = {}}
		local menu = menuTab.MenuData[menuName]
		if menu.Buttons[buttonName] then
			menuTab.RemoveButton(menuName, buttonName)
		end
		menu.sortList = menu.sortList or {}
		menu.Buttons = menu.Buttons or {}
		menu.Buttons[buttonName] = {name = buttonName, pos = pos, posref = Vector(pos.X,pos.Y), x = size.X, y = size.Y, spr = sprite, 
			func = DragFunc, render = renderFunc, canPressed = true, visible = true, isDragZone = true,
			dragPrePos = Vector(0,0), dragCurPos = Vector(0,0)
		}
		
		priority = priority or 0
		local Spos = #menu.sortList+1
		for i=#menu.sortList,1,-1 do
			if menu.sortList[i].Priority <= priority then
				break
			else
				Spos = Spos-1
			end
		end
		table.insert(menu.sortList, Spos, {btn = buttonName, Priority = priority})
		return menu.Buttons[buttonName]
    end
end

function UIs.DefDragBG() return GenSprite("gfx/editor/ui copy.anm2","def_drag") end
function UIs.DefDragDrager() return GenSprite("gfx/editor/ui copy.anm2","drag_drager") end

---@return EditorButton|nil
function menuTab.AddGragFloat(menuName, buttonName, pos, size, sprite, dragSpr, DragFunc, renderFunc, startValue, priority)
    if menuName and buttonName then
		startValue = startValue or 1
		menuTab.MenuData[menuName] = menuTab.MenuData[menuName] or {sortList = {}, Buttons = {}}
		local menu = menuTab.MenuData[menuName]
		if menu.Buttons[buttonName] then
			menuTab.RemoveButton(menuName, buttonName)
		end
		menu.sortList = menu.sortList or {}
		menu.Buttons = menu.Buttons or {}
		menu.Buttons[buttonName] = {name = buttonName, pos = pos, posref = Vector(pos.X,pos.Y), x = size.X, y = size.Y, spr = sprite, 
			func = DragFunc, render = renderFunc, canPressed = true, visible = true, isDrager = true, dragtype = 1, dragspr = UIs.DefDragDrager(),
			dragPrePos = Vector(startValue*size.X,0), dragCurPos = Vector(startValue*size.X,0)
		}
		
		priority = priority or 0
		local Spos = #menu.sortList+1
		for i=#menu.sortList,1,-1 do
			if menu.sortList[i].Priority <= priority then
				break
			else
				Spos = Spos-1
			end
		end
		table.insert(menu.sortList, Spos, {btn = buttonName, Priority = priority})
		return menu.Buttons[buttonName]
    end
end




menuTab.Keyboard = {}
menuTab.Keyboard.SelLang = "en"
menuTab.Keyboard.Languages = {"en","ru"}
menuTab.Keyboard.Chars = {}

menuTab.Keyboard.Chars.OnlyNumberBtnList = {[48] = 0,[49] = 1,[50] = 2,[51] = 3,[52] = 4,[53] = 5,[54] = 6,[55] = 7,[56] = 8,[57] = 9,
	[320] = 0,[321] = 1,[322] = 2,[323] = 3,[324] = 4,[325] = 5,[326] = 6,[327] = 7,[328] = 8,[329] = 9,
	[259] = -1, [261] = -1, [45] = "-", [46] = ".", [333] = "-" }
	menuTab.Keyboard.Chars.ShiftOnlyNumberBtnList = {[48] = ")",[53] = "%",[56] = "*",[57] = "(",
[320] = 0,[321] = 1,[322] = 2,[323] = 3,[324] = 4,[325] = 5,[326] = 6,[327] = 7,[328] = 8,[329] = 9,
[259] = -1, [261] = -1, [333] = "-" }

menuTab.Keyboard.Chars.CharBtnList = { en = {
		[48] = 0,[49] = 1,[50] = 2,[51] = 3,[52] = 4,[53] = 5,[54] = 6,[55] = 7,[56] = 8,[57] = 9,[61] = "=",
		[65] = "a", [66] = "b",[67] = "c",[68] = "d",[69] = "e",[70] = "f",[71] = "g",[72] = "h",[73] = "i",[74] = "j",[75] = "k",
		[76] = "l",[77] = "m",[78] = "n",[79] = "o",[80] = "p",[81] = "q",[82] = "r",[83] = "s",[84] = "t",[85] = "u",[86] = "v",[87] = "w",
		[88] = "x",[89] = "y",[90] = "z",[47] = "/",[44] = ",",[45] = "-",[46] = ".",[333] = "-" ,
		[32] = " ", [259] = -1, [261] = -1,
	},
	ru = {
		[48] = 0,[49] = 1,[50] = 2,[51] = 3,[52] = 4,[53] = 5,[54] = 6,[55] = 7,[56] = 8,[57] = 9, [61] = "=",
		[65] = "ф", [66] = "и",[67] = "с",[68] = "в",[69] = "у",[70] = "а",[71] = "п",[72] = "р",[73] = "ш",[74] = "о",[75] = "л",
		[76] = "д",[77] = "ь",[78] = "т",[79] = "щ",[80] = "з",[81] = "й",[82] = "к",[83] = "ы",[84] = "е",[85] = "г",[86] = "м",[87] = "ц",
		[88] = "ч",[89] = "н",[90] = "я",[47] = ".",[44] = "б",[45] = "-",[46] = "ю",[333] = "-" , [91] = "х",[93] = "ъ",
		[59] = "ж", [39] = "э",
		[32] = " ", [259] = -1, [261] = -1,
	},
}

menuTab.Keyboard.Chars.ShiftCharBtnList = { en = {
		[48] = ")",[49] = "!",[50] = "@",[51] = "#",[52] = "$",[53] = "%",[54] = "^",[55] = "&",[56] = "*",[57] = "(",
		[65] = "A", [66] = "B",[67] = "C",[68] = "D",[69] = "E",[70] = "F",[71] = "G",[72] = "H",[73] = "I",[74] = "J",[75] = "K",
		[76] = "L",[77] = "M",[78] = "N",[79] = "O",[80] = "P",[81] = "Q",[82] = "R",[83] = "S",[84] = "T",[85] = "U",[86] = "V",[87] = "W",
		[88] = "X",[89] = "Y",[90] = "Z",[47] = "?",[44] = "<",[45] = "_",[46] = ">",[333] = "-" ,[61] = "+",
		[32] = " ", [259] = -1, [261] = -1,
	},
	ru = {
		[48] = ")",[49] = "!",[50] = "@",[51] = "#",[52] = "$",[53] = "%",[54] = "^",[55] = "&",[56] = "*",[57] = "(", [61] = "+",
		[65] = "Ф", [66] = "И",[67] = "С",[68] = "В",[69] = "У",[70] = "А",[71] = "П",[72] = "Р",[73] = "Ш",[74] = "О",[75] = "Л",
		[76] = "Д",[77] = "Ь",[78] = "Т",[79] = "Щ",[80] = "З",[81] = "Й",[82] = "К",[83] = "Ы",[84] = "Е",[85] = "Г",[86] = "М",[87] = "Ц",
		[88] = "Ч",[89] = "Н",[90] = "Я",[47] = ",",[44] = "Б",[45] = "-",[46] = "Ю",[333] = "-" , [91] = "Х",[93] = "Ъ", 
		[32] = " ", [259] = -1, [261] = -1,
	},
}

menuTab.TextboxPopup = {MenuName = "TextboxPopup", OnlyNumber = false, Text = "", InFocus = true, TextPos = 0, lastChar = "",
	TextPosMoveDelay = 0, errorMes = -1}

function menuTab.OpenTextboxPopup(onlyNumber, resultCheckFunc, startText) --tab, key, 
	local Menuname = menuTab.TextboxPopup.MenuName
	--menuTab.MenuData[Menuname] = {sortList = {}, Buttons = {}}
	local mousePosi = Vector(0,0)
	local buttonPos = Vector(0,0)

	menuTab.TextboxPopup.DontremoveSticky = false
	menuTab.TextboxPopup.LastMenu = menuTab.SelectedMenu..""
	menuTab.SelectedMenu = Menuname
	if not menuTab.IsStickyMenu then
		menuTab.IsStickyMenu = true
	else
		menuTab.TextboxPopup.DontremoveSticky = true
	end
	menuTab.TextboxPopup.OnlyNumber = onlyNumber and true or false
	menuTab.TextboxPopup.ResultCheck = resultCheckFunc
	menuTab.TextboxPopup.Text = startText and tostring(startText) or ""
	menuTab.TextboxPopup.TextPos = startText and utf8.len(menuTab.TextboxPopup.Text) or 0
	--menuTab.TextboxPopup.TabKey = {tab, key}

	local centerPos = menuTab.ScreenCenter - Vector(94,24) --Vector(Isaac.GetScreenWidth()/2-94, Isaac.GetScreenHeight()/2-24)
	local self
	self = menuTab.AddButton(Menuname, "TextBox", centerPos, 164, 32, UIs.PopupTextBox(), function(button) 
		if button ~= 0 then return end
		menuTab.TextboxPopup.InFocus = true
		local mouseClickPos = mousePosi-buttonPos
		
		if menuTab.MouseSprite and menuTab.MouseSprite:GetAnimation() == "mouse_textEd" then
			local num = 0
			for i = utf8.len(menuTab.TextboxPopup.Text),0,-1 do
				local CutPos = font:GetStringWidthUTF8(utf8_Sub(menuTab.TextboxPopup.Text, 0, i))/2
				if CutPos < mouseClickPos.X then
					menuTab.TextboxPopup.TextPos = i
					break
				end
			end
			--menuTab.TextboxPopup.TextPos
		end
	end, function(pos)
		--menuTab.GetButton(Menuname, "TextBox").pos = menuTab.ScreenCenter - Vector(94,24)
		self.pos = menuTab.ScreenCenter - Vector(94,24)

		buttonPos = pos
		font:DrawStringScaledUTF8(menuTab.TextboxPopup.Text,pos.X+3,pos.Y+10,0.5,0.5,KColor(0.1,0.1,0.2,1),0,false)
		if menuTab.TextboxPopup.InFocus then
			local poloskaPos = font:GetStringWidthUTF8(utf8_Sub(menuTab.TextboxPopup.Text, 0, menuTab.TextboxPopup.TextPos))
			UIs.TextEdPos:Render(pos+Vector(3+poloskaPos/2,9))
			UIs.TextEdPos:Update()
		end

		if type(menuTab.TextboxPopup.errorMes) == "string" then
			local renderPos = pos + Vector(92,-20)

			font:DrawStringScaledUTF8(menuTab.TextboxPopup.errorMes,renderPos.X+0.5,renderPos.Y-0.5,0.5,0.5,KColor(1,1,1,1),1,true)
			font:DrawStringScaledUTF8(menuTab.TextboxPopup.errorMes,renderPos.X-0.5,renderPos.Y+0.5,0.5,0.5,KColor(1,1,1,1),1,true)
			font:DrawStringScaledUTF8(menuTab.TextboxPopup.errorMes,renderPos.X+0.5,renderPos.Y+0.5,0.5,0.5,KColor(1,1,1,1),1,true)
			font:DrawStringScaledUTF8(menuTab.TextboxPopup.errorMes,renderPos.X-0.5,renderPos.Y-0.5,0.5,0.5,KColor(1,1,1,1),1,true)

			font:DrawStringScaledUTF8(menuTab.TextboxPopup.errorMes,renderPos.X,renderPos.Y,0.5,0.5,KColor(1,0.2,0.2,1),1,true)
		end
	end)

	local self
	self = menuTab.AddButton(Menuname, "Cancel", centerPos+Vector(12,44), 64, 16, UIs.ButtonWide(), function(button) 
		if button ~= 0 then return end
		menuTab.CloseTextboxPopup()
	end, function(pos)
		--menuTab.GetButton(Menuname, "Cancel").pos = menuTab.ScreenCenter - Vector(94,24)+Vector(12,44)
		self.pos = menuTab.ScreenCenter - Vector(94,24)+Vector(12,44)
		font:DrawStringScaledUTF8(GetStr("Cancel"),pos.X+30,pos.Y+3,0.5,0.5,KColor(0.1,0.1,0.2,1),1,true)
	end)
	local self
	self = menuTab.AddButton(Menuname, "Ok", centerPos+Vector(112,44), 64, 16, UIs.ButtonWide(), function(button) 
		if button ~= 0 then return end
		local result = menuTab.TextboxPopup.ResultCheck(menuTab.TextboxPopup.Text)
		if result == true then
			menuTab.CloseTextboxPopup()
		elseif type(result) == "string" then
			menuTab.TextboxPopup.errorMes = result
		end
	end, function(pos)
		self.pos = menuTab.ScreenCenter - Vector(94,24)+Vector(112,44)
		--menuTab.GetButton(Menuname, "Ok").pos = menuTab.ScreenCenter - Vector(94,24)+Vector(112,44)
		font:DrawStringScaledUTF8(GetStr("Ok"),pos.X+30,pos.Y+3,0.5,0.5,KColor(0.1,0.1,0.2,1),1,true)

		if not game:IsPaused() and Input.IsButtonTriggered(Keyboard.KEY_ENTER,0) then
			local result = menuTab.TextboxPopup.ResultCheck(menuTab.TextboxPopup.Text)
			if result == true then
				menuTab.CloseTextboxPopup()
			elseif type(result) == "string" then
				menuTab.TextboxPopup.errorMes = result
			end
		end
	end)

	local ctrlVPressed = false

	menuTab.MenuLogic[Menuname] = function(MousePos)
		mousePosi = MousePos
		
		if (menuTab.IsMouseBtnTriggered(0) or menuTab.IsMouseBtnTriggered(1)) 
		--and menuTab.MenuButtons[Menuname].TextBox.spr:GetFrame() == 0 then
		and menuTab.GetButton(Menuname, "TextBox").spr:GetFrame() == 0 then
			menuTab.TextboxPopup.InFocus = false
		end
		if menuTab.TextboxPopup.InFocus then

			local mouseClickPos = mousePosi-buttonPos
			local textlong = math.max(font:GetStringWidthUTF8(menuTab.TextboxPopup.Text)/2, 160)
			
			if mouseClickPos.X > 1 and mouseClickPos.X < textlong+1 and mouseClickPos.Y>4 and mouseClickPos.Y<27 then
				if not menuTab.MouseSprite or menuTab.MouseSprite:GetAnimation() ~= "mouse_textEd" then
					menuTab.MouseSprite = UIs.MouseTextEd
				elseif Input.IsMouseBtnPressed(0) then
					menuTab.MouseSprite:SetFrame(1)
				else
					menuTab.MouseSprite:SetFrame(0)
				end
			elseif menuTab.MouseSprite and menuTab.MouseSprite:GetAnimation() == "mouse_textEd" then
				menuTab.MouseSprite = nil
			end


			local maxN = utf8.len(menuTab.TextboxPopup.Text)
			if menuTab.TextboxPopup.TextPosMoveDelay <= 0 
			or menuTab.TextboxPopup.TextPosMoveDelay > 15 and menuTab.TextboxPopup.TextPosMoveDelay%2==0 then
				if Input.IsButtonPressed(Keyboard.KEY_RIGHT,0) then
					menuTab.TextboxPopup.TextPos = math.min(menuTab.TextboxPopup.TextPos + 1,maxN)
					--menuTab.TextboxPopup.TextPosMoveDelay = 5
				elseif Input.IsButtonPressed(Keyboard.KEY_LEFT,0) then
					menuTab.TextboxPopup.TextPos = math.max(menuTab.TextboxPopup.TextPos - 1, 0)
					--menuTab.TextboxPopup.TextPosMoveDelay = 5
				end
			end
			if Input.IsButtonPressed(Keyboard.KEY_RIGHT,0) or Input.IsButtonPressed(Keyboard.KEY_LEFT,0) then
				menuTab.TextboxPopup.TextPosMoveDelay = menuTab.TextboxPopup.TextPosMoveDelay + 1
			else
				menuTab.TextboxPopup.TextPosMoveDelay = 0
			end
			local shift = Input.IsButtonPressed(Keyboard.KEY_LEFT_SHIFT,0) or Input.IsButtonPressed(Keyboard.KEY_RIGHT_SHIFT,0)

			if shift and Input.IsButtonTriggered(Keyboard.KEY_LEFT_ALT,0) then
				--menuTab.Keyboard.SelLang = "en"
				local fnext = false
				local flast
				for i,k in pairs(menuTab.Keyboard.Languages) do
					if fnext then
						menuTab.Keyboard.SelLang = k
						fnext = nil
						break
					end

					if menuTab.Keyboard.SelLang == k then
						fnext = true
					else
						flast = k
					end
				end
				if fnext then
					menuTab.Keyboard.SelLang = flast
				end
			end
			
			local newChar
			local remove
			local charTable
			local ignoreKeybord = false

			if menuTab.TextboxPopup.OnlyNumber then
				if shift then
					charTable = menuTab.Keyboard.Chars.ShiftOnlyNumberBtnList
				else
					charTable = menuTab.Keyboard.Chars.OnlyNumberBtnList
				end
			else
				if shift then
					charTable = menuTab.Keyboard.Chars.ShiftCharBtnList
				else
					charTable = menuTab.Keyboard.Chars.CharBtnList
				end
				charTable = charTable[menuTab.Keyboard.SelLang] or charTable["en"]
			end

			--if menuTab.TextboxPopup.OnlyNumber then
			--	for btn,b in pairs(OnlyNumberBtnList) do
			--		if Input.IsButtonPressed(btn,0) then
			--			if menuTab.TextboxPopup.lastChar ~= btn then
			--				newChar = b
			--				menuTab.TextboxPopup.lastChar = btn
			--			end
			--		elseif menuTab.TextboxPopup.lastChar == btn then
			--			menuTab.TextboxPopup.lastChar = nil
			--		end
			--	end
			--else
			if not ctrlVPressed and Input.IsButtonPressed(Keyboard.KEY_LEFT_CONTROL,0) and Input.IsButtonPressed(Keyboard.KEY_V,0) then
				ctrlVPressed = true
				ignoreKeybord = true
				newChar = Isaac.GetClipboard and Isaac.GetClipboard()
			elseif not (Input.IsButtonPressed(Keyboard.KEY_LEFT_CONTROL,0) or Input.IsButtonPressed(Keyboard.KEY_V,0)) then
				ctrlVPressed = false
			else
				ignoreKeybord = true
			end
			if not ignoreKeybord then
				for btn,b in pairs(charTable) do
					if Input.IsButtonPressed(btn,0) then
						if menuTab.TextboxPopup.lastChar ~= btn then
							newChar = b
							menuTab.TextboxPopup.lastChar = btn
						end
					elseif menuTab.TextboxPopup.lastChar == btn then
						menuTab.TextboxPopup.lastChar = nil
					end
				end
			end
			if newChar then
				--local minusPos = utf8.offset(menuTab.TextboxPopup.Text, menuTab.TextboxPopup.TextPos-1)
				local curjspos = menuTab.TextboxPopup.TextPos --utf8.offset(menuTab.TextboxPopup.Text, menuTab.TextboxPopup.TextPos)
				local secoPos = menuTab.TextboxPopup.TextPos+1 -- utf8.offset(menuTab.TextboxPopup.Text, menuTab.TextboxPopup.TextPos+1)
				
				local firstPart = utf8_Sub(menuTab.TextboxPopup.Text, 0, curjspos)
				local secondPart = utf8_Sub(menuTab.TextboxPopup.Text, secoPos)
				if newChar == -1 then
					if menuTab.TextboxPopup.TextPos>0 then
						menuTab.TextboxPopup.Text = utf8_Sub(firstPart, 0, utf8.len(firstPart)-1) .. secondPart
						menuTab.TextboxPopup.TextPos = menuTab.TextboxPopup.TextPos - 1
					end
				else
					menuTab.TextboxPopup.Text = firstPart .. newChar .. secondPart
					menuTab.TextboxPopup.TextPos = menuTab.TextboxPopup.TextPos + utf8.len(newChar)
				end
			end
		end
	end

	mod:RemoveCallback(ModCallbacks.MC_INPUT_ACTION, menuTab.InputFilter)
	mod:AddCallback(ModCallbacks.MC_INPUT_ACTION, menuTab.InputFilter)
end

function menuTab.OpenTextbox(menu, button, onlyNumber, resultCheckFunc, startText) --tab, key, 
	local Menuname = menuTab.TextboxPopup.MenuName
	--menuTab.MenuData[Menuname] = {sortList = {}, Buttons = {}}
	local mousePosi = Vector(0,0)
	local buttonPos = Vector(0,0)

	menuTab.TextboxPopup.InFocus = true
	menuTab.TextboxPopup.TargetBtn = {menu, button}
	menuTab.TextboxPopup.OnlyNumber = onlyNumber and true or false
	menuTab.TextboxPopup.ResultCheck = resultCheckFunc
	menuTab.TextboxPopup.Text = startText and tostring(startText) or ""
	menuTab.TextboxPopup.TextPos = startText and utf8.len(menuTab.TextboxPopup.Text) or 0
	--menuTab.TextboxPopup.TabKey = {tab, key}

	local ctrlVPressed = false

	menuTab.TextboxPopup.KeyLogic = function(MousePos)
		mousePosi = MousePos

		if (menuTab.IsMouseBtnTriggered(0) or menuTab.IsMouseBtnTriggered(1)) 
		--and menuTab.MenuButtons[Menuname].TextBox.spr:GetFrame() == 0 then
		and not menuTab.GetButton(menu, button).IsSelected
		then
			menuTab.TextboxPopup.InFocus = false

			local result = menuTab.TextboxPopup.ResultCheck(menuTab.TextboxPopup.Text)
			if result == true then
				menuTab.CloseTextbox()
			elseif type(result) == "string" then
				menuTab.TextboxPopup.errorMes = result
				menuTab.GetButton(menu, button).errorMes = result
				menuTab.GetButton(menu, button).showError = 60
				menuTab.CloseTextbox()
			end
		end
		if Input.IsButtonPressed(Keyboard.KEY_ENTER, 0)  then
			local result = menuTab.TextboxPopup.ResultCheck(menuTab.TextboxPopup.Text)
			if result == true then
				menuTab.CloseTextbox()
			elseif type(result) == "string" then
				menuTab.TextboxPopup.errorMes = result
				menuTab.GetButton(menu, button).errorMes = result
				menuTab.GetButton(menu, button).showError = 60
			end
		end
		if menuTab.TextboxPopup.InFocus then
			Isaac.GetPlayer().ControlsCooldown = math.max(Isaac.GetPlayer().ControlsCooldown, 3)


			local mouseClickPos = mousePosi-buttonPos
			local textlong = math.max(font:GetStringWidthUTF8(menuTab.TextboxPopup.Text)/2, 160)
			
			--[[if mouseClickPos.X > 1 and mouseClickPos.X < textlong+1 and mouseClickPos.Y>4 and mouseClickPos.Y<27 then
				if not menuTab.MouseSprite or menuTab.MouseSprite:GetAnimation() ~= "mouse_textEd" then
					menuTab.MouseSprite = UIs.MouseTextEd
				elseif Input.IsMouseBtnPressed(0) then
					menuTab.MouseSprite:SetFrame(1)
				else
					menuTab.MouseSprite:SetFrame(0)
				end
			elseif menuTab.MouseSprite and menuTab.MouseSprite:GetAnimation() == "mouse_textEd" then
				menuTab.MouseSprite = nil
			end]]


			local maxN = utf8.len(menuTab.TextboxPopup.Text)
			if menuTab.TextboxPopup.TextPosMoveDelay <= 0 
			or menuTab.TextboxPopup.TextPosMoveDelay > 15 and menuTab.TextboxPopup.TextPosMoveDelay%2==0 then
				if Input.IsButtonPressed(Keyboard.KEY_RIGHT,0) then
					menuTab.TextboxPopup.TextPos = math.min(menuTab.TextboxPopup.TextPos + 1,maxN)
					--menuTab.TextboxPopup.TextPosMoveDelay = 5
				elseif Input.IsButtonPressed(Keyboard.KEY_LEFT,0) then
					menuTab.TextboxPopup.TextPos = math.max(menuTab.TextboxPopup.TextPos - 1, 0)
					--menuTab.TextboxPopup.TextPosMoveDelay = 5
				end
			end
			if Input.IsButtonPressed(Keyboard.KEY_RIGHT,0) or Input.IsButtonPressed(Keyboard.KEY_LEFT,0) then
				menuTab.TextboxPopup.TextPosMoveDelay = menuTab.TextboxPopup.TextPosMoveDelay + 1
			else
				menuTab.TextboxPopup.TextPosMoveDelay = 0
			end
			local shift = Input.IsButtonPressed(Keyboard.KEY_LEFT_SHIFT,0) or Input.IsButtonPressed(Keyboard.KEY_RIGHT_SHIFT,0)

			if shift and Input.IsButtonTriggered(Keyboard.KEY_LEFT_ALT,0) then
				--menuTab.Keyboard.SelLang = "en"
				local fnext = false
				local flast
				for i,k in pairs(menuTab.Keyboard.Languages) do
					if fnext then
						menuTab.Keyboard.SelLang = k
						fnext = nil
						break
					end

					if menuTab.Keyboard.SelLang == k then
						fnext = true
					else
						flast = k
					end
				end
				if fnext then
					menuTab.Keyboard.SelLang = flast
				end
			end
			
			local newChar
			local remove
			local charTable
			local ignoreKeybord = false

			if menuTab.TextboxPopup.OnlyNumber then
				if shift then
					charTable = menuTab.Keyboard.Chars.ShiftOnlyNumberBtnList
				else
					charTable = menuTab.Keyboard.Chars.OnlyNumberBtnList
				end
			else
				if shift then
					charTable = menuTab.Keyboard.Chars.ShiftCharBtnList
				else
					charTable = menuTab.Keyboard.Chars.CharBtnList
				end
				charTable = charTable[menuTab.Keyboard.SelLang] or charTable["en"]
			end

			--if menuTab.TextboxPopup.OnlyNumber then
			--	for btn,b in pairs(OnlyNumberBtnList) do
			--		if Input.IsButtonPressed(btn,0) then
			--			if menuTab.TextboxPopup.lastChar ~= btn then
			--				newChar = b
			--				menuTab.TextboxPopup.lastChar = btn
			--			end
			--		elseif menuTab.TextboxPopup.lastChar == btn then
			--			menuTab.TextboxPopup.lastChar = nil
			--		end
			--	end
			--else
			if not ctrlVPressed and Input.IsButtonPressed(Keyboard.KEY_LEFT_CONTROL,0) and Input.IsButtonPressed(Keyboard.KEY_V,0) then
				ctrlVPressed = true
				ignoreKeybord = true
				newChar = Isaac.GetClipboard and Isaac.GetClipboard()
			elseif not (Input.IsButtonPressed(Keyboard.KEY_LEFT_CONTROL,0) and Input.IsButtonPressed(Keyboard.KEY_V,0)) then
				ctrlVPressed = false
			else
				ignoreKeybord = true
			end
			if not ignoreKeybord then
				for btn,b in pairs(charTable) do
					if Input.IsButtonPressed(btn,0) then
						if menuTab.TextboxPopup.lastChar ~= btn then
							newChar = b
							menuTab.TextboxPopup.lastChar = btn
						end
					elseif menuTab.TextboxPopup.lastChar == btn then
						menuTab.TextboxPopup.lastChar = nil
					end
				end
			end
			if newChar then
				--local minusPos = utf8.offset(menuTab.TextboxPopup.Text, menuTab.TextboxPopup.TextPos-1)
				local curjspos = menuTab.TextboxPopup.TextPos --utf8.offset(menuTab.TextboxPopup.Text, menuTab.TextboxPopup.TextPos)
				local secoPos = menuTab.TextboxPopup.TextPos+1 -- utf8.offset(menuTab.TextboxPopup.Text, menuTab.TextboxPopup.TextPos+1)
				
				local firstPart = utf8_Sub(menuTab.TextboxPopup.Text, 0, curjspos)
				local secondPart = utf8_Sub(menuTab.TextboxPopup.Text, secoPos)
				if newChar == -1 then
					if menuTab.TextboxPopup.TextPos>0 then
						menuTab.TextboxPopup.Text = utf8_Sub(firstPart, 0, utf8.len(firstPart)-1) .. secondPart
						menuTab.TextboxPopup.TextPos = menuTab.TextboxPopup.TextPos - 1
					end
				else
					menuTab.TextboxPopup.Text = firstPart .. newChar .. secondPart
					menuTab.TextboxPopup.TextPos = menuTab.TextboxPopup.TextPos + utf8.len(newChar)
				end
			end
		end
	end

	mod:RemoveCallback(ModCallbacks.MC_INPUT_ACTION, menuTab.InputFilter)
	mod:AddCallback(ModCallbacks.MC_INPUT_ACTION, menuTab.InputFilter)
end

local blockact = {[ButtonAction.ACTION_FULLSCREEN]=true, [ButtonAction.ACTION_RESTART]=true, [ButtonAction.ACTION_MUTE]=true,
	[ButtonAction.ACTION_PAUSE] = true}
function menuTab.InputFilter(_, ent, InputHook, ButtonAction)
	if menuTab.TextboxPopup.InFocus and not game:IsPaused() and blockact[ButtonAction] and (InputHook == 0 or InputHook == 1) then
		return false
	end
end
--mod:AddCallback(ModCallbacks.MC_INPUT_ACTION, menuTab.InputProxy)

function menuTab.CloseTextboxPopup(accept)
	if not accept then
		menuTab.SelectedMenu = menuTab.TextboxPopup.LastMenu
		if not menuTab.TextboxPopup.DontremoveSticky then
			menuTab.IsStickyMenu = false
		end

		menuTab.TextboxPopup = {MenuName = "TextboxPopup", OnlyNumber = false, Text = "", InFocus = false, 
			TextPos = 0, lastChar = "", TextPosMoveDelay = 0, errorMes = -1}
		mod:RemoveCallback(ModCallbacks.MC_INPUT_ACTION, menuTab.InputFilter)
	end
end

function menuTab.CloseTextbox()
	menuTab.TextboxPopup = {MenuName = "TextboxPopup", OnlyNumber = false, Text = "", InFocus = false, 
		TextPos = 0, lastChar = "", TextPosMoveDelay = 0, errorMes = -1, TargetBtn = nil}
	mod:RemoveCallback(ModCallbacks.MC_INPUT_ACTION, menuTab.InputFilter)
end

function menuTab.RenderTextBoxButton(button, pos)
	TextBoxFont:DrawStringScaledUTF8(menuTab.TextboxPopup.Text,pos.X+3,pos.Y,1,1,KColor(0.1,0.1,0.2,1),0,false)
	if menuTab.TextboxPopup.InFocus then
		local poloskaPos = TextBoxFont:GetStringWidthUTF8(utf8_Sub(menuTab.TextboxPopup.Text, 0, menuTab.TextboxPopup.TextPos))
		UIs.TextEdPos:Render(pos+Vector(3+poloskaPos,1))
		UIs.TextEdPos:Update()
	end
	
	--[[if type(menuTab.TextboxPopup.errorMes) == "string" then
		local renderPos = pos + Vector(92,-20)

		font:DrawStringScaledUTF8(menuTab.TextboxPopup.errorMes,renderPos.X+0.5,renderPos.Y-0.5,0.5,0.5,KColor(1,1,1,1),1,true)
		font:DrawStringScaledUTF8(menuTab.TextboxPopup.errorMes,renderPos.X-0.5,renderPos.Y+0.5,0.5,0.5,KColor(1,1,1,1),1,true)
		font:DrawStringScaledUTF8(menuTab.TextboxPopup.errorMes,renderPos.X+0.5,renderPos.Y+0.5,0.5,0.5,KColor(1,1,1,1),1,true)
		font:DrawStringScaledUTF8(menuTab.TextboxPopup.errorMes,renderPos.X-0.5,renderPos.Y-0.5,0.5,0.5,KColor(1,1,1,1),1,true)

		font:DrawStringScaledUTF8(menuTab.TextboxPopup.errorMes,renderPos.X,renderPos.Y,0.5,0.5,KColor(1,0.2,0.2,1),1,true)
	end]]
end

function menuTab.RenderButtonHintText(text, pos)
	--DrawStringScaledBreakline(font, menuTab.MouseHintText, pos.X, pos.Y, 0.5, 0.5, KColor(0.1,0.1,0.2,1), 60, "Left")
	local Center = false
	local BoxWidth = 0
    local line = 0
	if type(text) == "table" then
		UIs.HintTextBG1.Color = Color(1,1,1,0.5)
		UIs.HintTextBG2.Color = Color(1,1,1,0.5)
		UIs.HintTextBG2.Scale = Vector(text.Width/2+2.5,18*#text/4+2.5)
		UIs.HintTextBG2:Render(pos-Vector(2.5,2.5))
		UIs.HintTextBG1.Scale = Vector(text.Width/2+1,18*#text/4+1)
		UIs.HintTextBG1:Render(pos-Vector(1,1))

		for li, word in ipairs(text) do
			font:DrawStringScaledUTF8(word, pos.X, pos.Y+(line*font:GetLineHeight()*0.5), 0.5, 0.5, KColor(0.1,0.1,0.2,1), BoxWidth, Center)
			line = line + 1
		end
	elseif type(text) == "string" then
		for word in string.gmatch(text, '([^\n]+)') do
			font:DrawStringScaledUTF8(word, pos.X, pos.Y+(line*font:GetLineHeight()*0.5), 0.5, 0.5, KColor(0.1,0.1,0.2,1), BoxWidth, Center)
			line = line + 1
		end
	end
end
function menuTab.RenderCustomMenuBack(pos, size, col)
	if pos and size then
		for i=0,6 do
			UIs["MenuActulae"..i].Color = col or Color(1,1,1,.25)
		end

		local x,y = size.X, size.Y
		UIs.MenuActulae0.Scale = size/8 - Vector(0,2)
		UIs.MenuActulae0:Render(pos+Vector(0,8))
		UIs.MenuActulae1:Render(pos)
		UIs.MenuActulae2:Render(pos+Vector(x,0))
		UIs.MenuActulae3:Render(pos+Vector(0,y))
		UIs.MenuActulae4:Render(pos+Vector(x,y))
		UIs.MenuActulae5.Scale = Vector((x-16)/8,1)
		UIs.MenuActulae5:Render(pos+Vector(8,0))
		UIs.MenuActulae6.Scale = Vector((x-16)/8,1)
		UIs.MenuActulae6:Render(pos+Vector(8,y))
	end
end

UIs.TextBoxBG2v = GenSprite("gfx/editor/ui copy.anm2", "custom textbox_bg")

function menuTab.RenderCustomTextBox(pos, size, isSel)
	if pos and size then
		if isSel then
			UIs.TextBoxBG2v:SetFrame(1)
		else
			UIs.TextBoxBG2v:SetFrame(0)
		end
		UIs.TextBoxBG2v.Scale = Vector(size.X/2 ,size.Y/2)
		UIs.TextBoxBG2v:RenderLayer(0, pos)

		UIs.TextBoxBG2v.Scale = Vector(size.X/2 ,size.Y/2-1)
		UIs.TextBoxBG2v:RenderLayer(1, pos+Vector(1,1))

		--[[if isSel then
			UIs.TextBoxBG:SetFrame(1)
		else
			UIs.TextBoxBG:SetFrame(0)
		end
		UIs.TextBoxBG.Scale = Vector(1,size.Y/16)
		UIs.TextBoxBG:RenderLayer(0, pos)

		UIs.TextBoxBG.Scale = Vector(size.X, size.Y/16)
		UIs.TextBoxBG:RenderLayer(1, pos+Vector(1,0))

		UIs.TextBoxBG.Scale = Vector(1,size.Y/16)
		UIs.TextBoxBG:RenderLayer(0, pos+ Vector(size.X,0))]]
	end
end

UIs.ButtonBG2v = GenSprite("gfx/editor/ui copy.anm2", "custom button_bg")

function menuTab.RenderCustomButton(pos, size, isSel)
	if pos and size then
		if isSel then
			UIs.ButtonBG2v:SetFrame(1)
		else
			UIs.ButtonBG2v:SetFrame(0)
		end
		UIs.ButtonBG2v.Scale = Vector(size.X/2 ,size.Y/2)
		UIs.ButtonBG2v:RenderLayer(0, pos)

		UIs.ButtonBG2v.Scale = Vector(size.X/2-1 ,size.Y/2-1)
		UIs.ButtonBG2v:RenderLayer(1, pos+Vector(1,1))

		--[[if isSel then
			UIs.ButtonBG:SetFrame(1)
		else
			UIs.ButtonBG:SetFrame(0)
		end

		UIs.ButtonBG.Scale = Vector(size.X, size.Y/14)
		UIs.ButtonBG:RenderLayer(1, pos+Vector(0, -size.Y/14), Vector(0,1), Vector(0,1))

		UIs.ButtonBG.Scale = Vector(size.X, 1)
		UIs.ButtonBG:RenderLayer(1, pos+Vector(1,-15), Vector(0,15))
		UIs.ButtonBG.Scale = Vector(size.X, 1)
		UIs.ButtonBG:RenderLayer(1, pos+Vector(1,size.Y-16), Vector(0,15))


		UIs.ButtonBG.Scale = Vector(1,size.Y/16)
		UIs.ButtonBG:RenderLayer(0, pos)

		UIs.ButtonBG.Scale = Vector(1,size.Y/16)
		UIs.ButtonBG:RenderLayer(0, pos+ Vector(size.X,0))]]
	end
end


function menuTab.RenderMenuButtons(menuName)
  	if type(menuTab.MenuData[menuName]) == "table" and #menuTab.MenuData[menuName].sortList>0 then

		

		local IstextboxMenu = menuTab.TextboxPopup.TargetBtn 
			and menuTab.TextboxPopup.TargetBtn[1] == menuName
			
		for i=#menuTab.MenuData[menuName].sortList,1,-1 do
			local dat = menuTab.MenuData[menuName].sortList[i]
			---@type EditorButton
			local btn = menuTab.MenuData[menuName].Buttons[dat.btn]
			if btn.posfunc then
				btn.posfunc(btn)
			end
			if btn.visible then
				local renderPos = btn.pos or Vector(50,50)
				if btn.spr then
					btn.spr:Render(renderPos)
				end
				if btn.IsTextBox then
					if not btn.spr then
						menuTab.RenderCustomTextBox(btn.pos, Vector(btn.x,btn.y), btn.IsSelected)
					end
					if IstextboxMenu and menuTab.TextboxPopup.TargetBtn[2] == btn.name then
						menuTab.RenderTextBoxButton(btn, btn.pos)
					elseif btn.text then
						TextBoxFont:DrawStringScaledUTF8(btn.text, btn.pos.X+3, btn.pos.Y, 1,1,KColor(0.1,0.1,0.2,1),0,false)
					end
					--menuTab.GetButton(menu, button).errorMes = result
					--menuTab.GetButton(menu, button).showError = 60
					if btn.errorMes and type(btn.errorMes) == "string" then
						if not btn.showError or btn.showError < 0 then
							btn.errorMes = nil
							btn.showError = nil
						else
							local alpha = btn.showError < 10 and (btn.showError/10) or 1
							local aplha = btn.showError > 10 and 1 or alpha/3

							local renderPos = btn.pos + Vector(btn.x/2,-20)

							font:DrawStringScaledUTF8(btn.errorMes,renderPos.X+0.5,renderPos.Y-0.5,0.5,0.5,KColor(1,1,1,aplha),1,true)
							font:DrawStringScaledUTF8(btn.errorMes,renderPos.X-0.5,renderPos.Y+0.5,0.5,0.5,KColor(1,1,1,aplha),1,true)
							font:DrawStringScaledUTF8(btn.errorMes,renderPos.X+0.5,renderPos.Y+0.5,0.5,0.5,KColor(1,1,1,aplha),1,true)
							font:DrawStringScaledUTF8(btn.errorMes,renderPos.X-0.5,renderPos.Y-0.5,0.5,0.5,KColor(1,1,1,aplha),1,true)

							font:DrawStringScaledUTF8(btn.errorMes,renderPos.X,renderPos.Y,0.5,0.5,KColor(1,0.2,0.2,alpha),1,true)
							btn.showError = btn.showError - 1
						end
					end
				end
			end

			if btn.render then
				btn.render(btn.pos, btn.visible)
			end
			if btn.isDrager then
				local pos = btn.pos + btn.dragCurPos 
				btn.dragspr:Render(pos+Vector(0,-2))
			end
		end

		if IstextboxMenu then
			menuTab.TextboxPopup.KeyLogic(menuTab.MousePos)
		end
	end
end

local DetectSelectedButtonBuffer = {}
local DetectSelectedButtonBufferRef = {}
function menuTab.DetectSelectedButton(menu, bool)
	if not DetectSelectedButtonBufferRef[menu] then
		if bool then
			table.insert(DetectSelectedButtonBuffer, 1, menu)
		else
			DetectSelectedButtonBuffer[#DetectSelectedButtonBuffer+1] = menu
		end
		DetectSelectedButtonBufferRef[menu] = true
	end
end
if Isaac.GetCursorSprite and Isaac.GetCursorSprite():GetFilename() == "" then
	Isaac.GetCursorSprite():Load("gfx/ui/cursor.anm2", true)
	Isaac.GetCursorSprite():Play("Idle")
end
function menuTab.DetectSelectedButtonActuale()
	local mousePos = menuTab.MousePos
	local onceTouch = false
	menuTab.OnFreePos = true
	for ahhoh = #DetectSelectedButtonBuffer, 1,-1 do
		local menu = DetectSelectedButtonBuffer[ahhoh]
		
		--if menuTab.TextboxPopup.TargetBtn and menuTab.TextboxPopup.TargetBtn[1] == menu then
		--	menuTab.TextboxPopup.KeyLogic(mousePos)
		--end

		if type(menuTab.MenuData[menu]) == "table" then
			--local mousePos = menuTab.MousePos

			--local onceTouch = false
			local somethingPressed = false
			for i, dt in pairs(menuTab.MenuData[menu].sortList) do
				---@type EditorButton
				local k = menuTab.MenuData[menu].Buttons[dt.btn]
				if not k then
					print("Not exist Button ", k, menu, dt.btn)
				end
				if k.canPressed then
					if not onceTouch and mousePos.X >= k.pos.X and mousePos.Y >= k.pos.Y
						and mousePos.X < (k.pos.X + k.x) and mousePos.Y < (k.pos.Y + k.y) then

						menuTab.OnFreePos = false
						onceTouch = true
						if not k.IsSelected then
							k.IsSelected = 0
							if k.spr then
								k.spr:SetFrame(1)
							end
						else
							k.IsSelected = k.IsSelected + 1
							if k.isDrager and mousePos.X > k.dragCurPos.X-3 and mousePos.X < k.dragCurPos.X+3 then
								k.dragspr:SetFrame(1)
							end
						end

						if not k.BlockPress then
							somethingPressed = true
							if menuTab.IsMouseBtnTriggered(0) and not menuTab.MouseDoNotPressOnButtons then
								if k.isDragZone then
									menuTab.SelectedDragZone = k
									--k.dragPrePos = k.dragPrePos or mousePos/1
									--k.dragCurPos = mousePos
									k.dragPreMousePos =  mousePos/1
								elseif k.isDrager then
									menuTab.SelectedDrager = k
									k.dragPrePos = Vector(mousePos.X-k.pos.X,0)
									--k.dragCurPos = Vector(mousePos.X,0)
									k.dragPreMousePos = mousePos/1
								else
									k.func(0)
								end
								break
							elseif menuTab.IsMouseBtnTriggered(1) and not menuTab.MouseDoNotPressOnButtons then
								k.func(1)
								break
							end
						else
							break
						end
					else
						if k.IsSelected then
							k.IsSelected = nil
							if k.spr then
								k.spr:SetFrame(0)
							end
							if k.dragspr then
								k.dragspr:SetFrame(0)
							end
						end
					end
				end
				if k.hintText and k.IsSelected and k.IsSelected > 10 then
					menuTab.MouseHintText = k.hintText
				end
			end
			print(menu, menuTab.MenuData[menu].somethingPressed, somethingPressed)
			menuTab.MenuData[menu].somethingPressed = somethingPressed
			local wind =  menuTab.MenuData[menu].CalledByWindow
			if wind then
				wind.somethingPressed = wind.somethingPressed or somethingPressed
			end
			menuTab.MenuData[menu].CalledByWindow = nil
		end
		--if menuTab.MouseDoNotPressOnButtons then
		menuTab.MouseDoNotPressOnButtons = nil
		--end
	end
	DetectSelectedButtonBuffer = {}
	DetectSelectedButtonBufferRef = {}

	if menuTab.SelectedDragZone then
		local k = menuTab.SelectedDragZone
		if Input.IsMouseBtnPressed(0) then
			k.dragCurPos = k.dragPrePos + mousePos - k.dragPreMousePos
			k.func(0, k.dragCurPos, k.dragPrePos)
		else
			--k.dragPrePos = Vector(0,0)
			k.dragPreMousePos = mousePos/1 -- k.dragPrePos
			k.dragPrePos = k.dragCurPos
			menuTab.SelectedDragZone = nil
		end

	elseif menuTab.SelectedDrager then
		local k = menuTab.SelectedDrager
		if Input.IsMouseBtnPressed(0) then
			k.dragCurPos.X = k.dragPrePos.X + mousePos.X - k.dragPreMousePos.X
			k.dragCurPos.X = math.min( k.x, math.max( 0, k.dragCurPos.X))
			local proc = k.dragCurPos.X / k.x
			k.func(0, proc, k.dragPrePos.X / k.x)
		else
			--k.dragPrePos = Vector(0,0)
			k.dragPreMousePos = mousePos/1 -- k.dragPrePos
			k.dragPrePos = k.dragCurPos
			menuTab.SelectedDrager = nil
		end

	end
end

function menuTab.HandleWindowControl()
	local mousePos = menuTab.MousePos
	local wind = menuTab.Windows

	local onceTouch = false
	local orderCopy = TabDeepCopy(wind.order)
	if not orderCopy then return end
	for order = 1, #orderCopy do
		local menuName = orderCopy[order]
		---@type Window
		local window = wind.menus[ menuName ]

		--menuTab.CurrentWindowControl = window

		if order == 1 then
			if window.SubMenus then
				for name, tab in pairs(window.SubMenus) do
					if tab.visible then
						menuTab.DetectSelectedButton(name)
						menuTab.GetMenu(name).CalledByWindow = window
					end
				end
			end
			menuTab.DetectSelectedButton(menuName)
			menuTab.GetMenu(menuName).CalledByWindow = window
		end
		if window.plashka then
			window.plashka.x = window.size.X
			window.plashka.y = window.size.Y
		end
		
		if not onceTouch and mousePos.X >= window.pos.X and mousePos.Y >= window.pos.Y
		and mousePos.X < (window.pos.X + window.size.X) and mousePos.Y < (window.pos.Y + window.size.Y) then

			onceTouch = true
			if not window.InFocus then
				window.InFocus = 0
			else
				window.InFocus = window.InFocus + 1
			end
			if (menuTab.IsMouseBtnTriggered(0) or menuTab.IsMouseBtnTriggered(1)) 
			and not menuTab.MouseDoNotPressOnButtons
			and not (menuTab.ScrollListIsOpen and Input.IsButtonPressed(Keyboard.KEY_SPACE, 0)) then
				findAndRemove(wind.order, menuName)
				table.insert(wind.order, 1, menuName)
				
			end
			if order ~= 1 then
				if window.SubMenus then
					for name, tab in pairs(window.SubMenus) do
						if tab.visible then
							menuTab.DetectSelectedButton(name)
							menuTab.GetMenu(name).CalledByWindow = window
						end
					end
				end
				menuTab.DetectSelectedButton(menuName, true)
				menuTab.GetMenu(menuName).CalledByWindow = window
			end
			if menuTab.IsMouseBtnTriggered(0) and not window.somethingPressed then
				window.MovingByMouse = true
			elseif not Input.IsMouseBtnPressed(0) then
				window.MovingByMouse = false
			end
		else
			if onceTouch then
				window.MovingByMouse = false
			end
			if window.InFocus then
				window.InFocus = nil
			end
		end
		window.somethingPressed = nil
		--menuTab.CurrentWindowControl = nil
	end
end


function menuTab.RenderWindows()
	local mousePos = menuTab.MousePos
	local wind = menuTab.Windows
	for i=#wind.order, 1, -1 do
		local menuName = wind.order[i]
		---@type Window
		local window = wind.menus[ menuName ]

		if window.MovingByMouse and not Input.IsButtonPressed(Keyboard.KEY_SPACE, 0) and not menuTab.ScrollListIsOpen then
			local offset = mousePos - window.MouseOldPos
			window.pos = window.OldPos + offset
		else
			window.MouseOldPos = mousePos/1
			window.OldPos = window.pos/1
		end

		menuTab.RenderCustomMenuBack(window.pos,window.size, i==1 and Color(1,1,1,.5) or Color(.6,.6,.6,.5))

		Isaac.RunCallbackWithParam(menuTab.Callbacks.WINDOW_PRE_RENDER, menuName, window.pos, window)

		---@type table<integer, EditorButton>?
		local buttons = menuTab.GetButtons(menuName)
		if buttons then
			for i,k in pairs(buttons) do
				k.pos = window.pos + k.posref
			end
		end
		if window.SubMenus then
			for name, tab in pairs(window.SubMenus) do
				if tab.visible then
					---@type table<integer, EditorButton>?
					local buttons = menuTab.GetButtons(name)
					if buttons then
						for i,k in pairs(buttons) do
							k.pos = window.pos + k.posref
						end
					end
				end
			end
		end

		menuTab.RenderMenuButtons(menuName)

		if window.SubMenus then
			for name, tab in pairs(window.SubMenus) do
				if tab.visible then
					menuTab.RenderMenuButtons(name)
				end
			end
		end

		Isaac.RunCallbackWithParam(menuTab.Callbacks.WINDOW_POST_RENDER, menuName, window.pos, window)
		--if i~=1 then
		--	menuTab.RenderCustomMenuBack(window.pos,window.size, Color(.2,.2,.2,.5))
		--end
	end
end

---@param Menuname string
---@param Pos Vector|function --почему тут функция?
---@param XSize number
---@param params  table
---@param pressFunc function
function menuTab.FastCreatelist(Menuname, Pos, XSize, params, pressFunc, up)
	--local Menuname = Menuname
	--local centerPos = Vector(Isaac.GetScreenWidth()/2, Isaac.GetScreenHeight()/2) - Vector(200, 160) --Vector(Isaac.GetScreenWidth()/2, Isaac.GetScreenHeight()/2)
	local Rpos = Pos
	local Lnum = 0
	local frame = 0
	local XScale = XSize/96

	local MouseOldPos = Vector(0,0)
	menuTab.ScrollOffset = Vector(0,0)
	local offsetPos = menuTab.ScrollOffset
	--local StartPos = Rpos/1
	local OldRenderPos = Vector(0,0)

	local Sadspr = UIs.Var_Sel()
	Sadspr.Scale = Vector(XScale,0.5)
	Sadspr.Color = Color(0,0,0,0.2)
	Sadspr.Offset = Vector(2,2)

	menuTab.ScrollListIsOpen = true
	local self
	self = menuTab.AddButton(Menuname, "_Listshadow", Rpos+Vector(0,up and -16 or 16), 96, 9, Sadspr, function(button) 
		if button ~= 0 then return end
	end, function(pos)
		Sadspr.Scale = Vector(XScale,0.5*Lnum)
		if frame>1 and not Input.IsButtonPressed(Keyboard.KEY_SPACE, 0) and (menuTab.IsMouseBtnTriggered(0) or menuTab.IsMouseBtnTriggered(1)) then
			menuTab.RemoveButton(Menuname, "_Listshadow")
			menuTab.ScrollListIsOpen = false
			mod:RemoveCallback(ModCallbacks.MC_INPUT_ACTION, menuTab.SpaceInputFilter)
		else
			local butPos
			if up then
				butPos = Rpos-Vector(0,8*(Lnum+1)) + offsetPos
			else
				butPos = Rpos+Vector(0,16) + offsetPos
			end
			self.posref = butPos 
			--[[
			menuTab.GetButton(Menuname, "_Listshadow").pos = butPos 
			UIs.Hint_MouseMoving_Vert.Color = Color(5,5,5,1)
			local renderPos = Vector(146,Isaac.GetScreenHeight()-15)
			UIs.Hint_MouseMoving_Vert:Render(renderPos-Vector(0,1))
			UIs.Hint_MouseMoving_Vert:Render(renderPos+Vector(0,1))
			UIs.Hint_MouseMoving_Vert:Render(renderPos-Vector(1,0))
			UIs.Hint_MouseMoving_Vert:Render(renderPos+Vector(1,0))
			UIs.Hint_MouseMoving_Vert.Color = Color.Default
			UIs.Hint_MouseMoving_Vert:Render(renderPos)]]
		end
		frame = frame + 1

		local MousePos = menuTab.MousePos
		if Input.IsButtonPressed(Keyboard.KEY_SPACE, 0) then
			--if MousePos.X < 120 and Isaac_Tower.editor.BlockPlaceGrid ~= false then
				--Isaac_Tower.editor.BlockPlaceGrid = true
			--end
			menuTab.MouseDoNotPressOnButtons = true
			--if not menuTab.MouseSprite or menuTab.MouseSprite:GetAnimation() ~= "mouse_grab" then
			--	menuTab.MouseSprite = UIs.MouseGrab
			--end
			if Input.IsMouseBtnPressed(0) then
				--menuTab.MouseSprite:SetFrame(1)
				local offset = MousePos - MouseOldPos
				offsetPos.Y = OldRenderPos.Y + offset.Y
			else
				--menuTab.MouseSprite:SetFrame(0)
				MouseOldPos = MousePos/1
				OldRenderPos = offsetPos/1
			end
			
			--menuTab.ScrollOffset = offsetPos
		--elseif menuTab.MouseSprite and menuTab.MouseSprite:GetAnimation() == "mouse_grab" then
		--	menuTab.MouseSprite = nil
		end
	end,true,-1)

	local maxOff = 0
	for rnam, romdat in pairs(params) do
		local key, index
		if type(romdat) == "table" then
			key, index = romdat[1], romdat[2]
		else
			key, index = rnam, romdat 
		end
		local qnum = Lnum+0
		local bntName = "_List" .. tostring(qnum)
		local Repos 
		if up then
			Repos = Rpos - Vector(0, qnum*8 + 16)
		else
			Repos = Rpos + Vector(0, qnum*8 + 16)
		end
		--local frame = 0
		local Sspr = UIs.Var_Sel()
		Sspr.Scale = Vector(XScale,0.5)
		
		local strW = font:GetStringWidthUTF8(tostring(key))/2
		maxOff = maxOff < strW and strW or maxOff

		local self
		self = menuTab.AddButton(Menuname, bntName, Repos, XSize, 9, Sspr, function(button)
			if frame<2 then return end
			pressFunc(button, key, index)
			menuTab.RemoveButton(Menuname, bntName)
		end, 
		function(pos)
			--local strW = font:GetStringWidthUTF8(tostring(qnum+1))/2
			--maxOff = maxOff < strW and strW or maxOff
			font:DrawStringScaledUTF8(tostring(key),pos.X+1,pos.Y-1,0.5,0.5,KColor(0.2,0.2,0.2,0.8),0,false) 
			font:DrawStringScaledUTF8(tostring(index),pos.X+maxOff+5,pos.Y-1,0.5,0.5,KColor(0.1,0.1,0.2,1),0,false) 
			
			if not self.IsSelected and frame>2 and not Input.IsButtonPressed(Keyboard.KEY_SPACE, 0) and (menuTab.IsMouseBtnTriggered(0) or menuTab.IsMouseBtnTriggered(1)) then
				menuTab.RemoveButton(Menuname, bntName)
			else
				self.posref = Repos + offsetPos
			end
			
		end,nil,-2)
		Lnum = Lnum + 1
	end

	mod:RemoveCallback(ModCallbacks.MC_INPUT_ACTION, menuTab.SpaceInputFilter)
	mod:AddCallback(ModCallbacks.MC_INPUT_ACTION, menuTab.SpaceInputFilter)
end
local blockact = {[ButtonAction.ACTION_ITEM]=true}
function menuTab.SpaceInputFilter(_, ent, InputHook, ButtonAction)
	if menuTab.TextboxPopup.InFocus and not game:IsPaused() and blockact[ButtonAction] and (InputHook == 0 or InputHook == 1) then
		return false
	end
end



return menuTab
end