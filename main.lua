--[[if WORSTDEBUGMENU and WORSTDEBUGMENU.wma then
	--WORSTDEBUGMENU.wma.UIs = nil
	if WORSTDEBUGMENU.wma.UIs then
		for i,k in pairs(WORSTDEBUGMENU.wma.UIs) do
			WORSTDEBUGMENU.wma.UIs[i] = nil
		end
	end
	if WORSTDEBUGMENU.UIs then
		for i,k in pairs(WORSTDEBUGMENU.UIs) do
			WORSTDEBUGMENU.UIs[i] = nil
		end
	end
	if WORSTDEBUGMENU.wma.MenuData then
		for i,k in pairs(WORSTDEBUGMENU.wma.MenuData) do
			WORSTDEBUGMENU.wma.MenuData[i] = nil
		end
	end
	WORSTDEBUGMENU = {}
	Isaac.ExecuteCommand("clearcache")
end]]

WORSTDEBUGMENU = RegisterMod("piss shit poop and menu", 1)

local game = Game()
local font = Font()
font:Load("font/upheaval.fnt")

WORSTDEBUGMENU.wma = include("worst gui api")
---@type menuTab
WORSTDEBUGMENU.wma = WORSTDEBUGMENU.wma(WORSTDEBUGMENU)

local Menu = WORSTDEBUGMENU

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





local shouldReturnMouseControl
local function blockPlayerShot()
	--if Options.MouseControl == true then
	--	shouldReturnMouseControl = true
	--	Options.MouseControl = false
	--	Isaac.GetPlayer().ControlsCooldown = math.max(Isaac.GetPlayer().ControlsCooldown, 1)
	--end
end


WORSTDEBUGMENU.MainOffset = 10
function Menu.DebugMenuRender(off, mousepos)
	WORSTDEBUGMENU.MainOffset = off
	local MenuUpPos = Vector(Isaac.GetScreenWidth()/2, -50 + off)
	UIs.MenuUp.Color = Color(1,1,1,0.5)
	UIs.MenuUp:Render(MenuUpPos)
	UIs.MenuUp.Color = Color(1,1,1,1)

	if not WORSTDEBUGMENU.showMainMenu then
		WORSTDEBUGMENU.wma.DetectSelectedButton("__debug_menu_grab")
		WORSTDEBUGMENU.wma.RenderMenuButtons("__debug_menu_grab")
	else
		WORSTDEBUGMENU.wma.DetectSelectedButton("__debug_menu")
		WORSTDEBUGMENU.wma.RenderMenuButtons("__debug_menu")
	end
	
end

do
	local PosForBtn = Vector(222,5)

	function WORSTDEBUGMENU.AddButtonOnDebugBar(buttonName, size, sprite, pressFunc, renderFunc)
		local curPos = PosForBtn/1
		local self
		self = WORSTDEBUGMENU.wma.AddButton("__debug_menu", buttonName, curPos, size.X, size.Y, sprite, pressFunc, pressFunc)
		self.posfunc = function()
			self.pos = Vector(curPos.X, curPos.Y+WORSTDEBUGMENU.MainOffset)
		end
		PosForBtn.X = PosForBtn.X + size.X + 2
		return self
	end
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
	grab1.pos = Vector(Isaac.GetScreenWidth() - 66, 50+WORSTDEBUGMENU.MainOffset)
end
grab2.posfunc = function()
	grab2.pos = Vector(Isaac.GetScreenWidth() - 66, 50+WORSTDEBUGMENU.MainOffset)
end
--WORSTDEBUGMENU.wma.ButtonSetHintText("__debug_menu", "open_editor", "test text")



local self
self = WORSTDEBUGMENU.wma.AddButton("__debug_menu", "mouseLock", Vector(4,-25), 16, 16, UIs.MouseLockBtn, function(button) 
	if button ~= 0 then return end
	--blockPlayerShot()
	Options.MouseControl = not Options.MouseControl
	UIs.MouseIsLocked:SetFrame(Options.MouseControl and 0 or 1)
end,
function(pos)
	UIs.MouseIsLocked:Render(pos)
end)
self.posfunc = function()
	self.pos = Vector(1,5+WORSTDEBUGMENU.MainOffset)
end

local self
self = WORSTDEBUGMENU.wma.AddButton("__debug_menu", "luamod", Vector(86,-25), 32, 32, UIs.luamod_debug, function(button) 
	if button ~= 0 then return end
	--blockPlayerShot()
	Isaac.ExecuteCommand("luamod mouse debug menu")
end, function(pos)
	--self.pos = Vector(86,5+WORSTDEBUGMENU.MainOffset)
end, nil, 100)
self.posfunc = function()
	self.pos = Vector(86,5+WORSTDEBUGMENU.MainOffset)
end




WORSTDEBUGMENU.debugcmd_Menu = {active = false, pos = Vector(0,0), name = "_debugcmd"}
local debugcmd = WORSTDEBUGMENU.debugcmd_Menu

do
	local sizev =  Vector(14*19,40)

	local self
	self = WORSTDEBUGMENU.wma.AddButton("__debug_menu", "debugcmd_Menu", Vector(52,5), 32, 32, UIs.DebugCMD, function(button) 
		if button ~= 0 then return end
		blockPlayerShot()
		debugcmd.active = not debugcmd.active
		debugcmd.pos = self.pos + Vector(0, 30)
		WORSTDEBUGMENU.wma.ShowWindow(debugcmd.name, debugcmd.pos, sizev)
	end, function(pos)
		--self.pos = Vector(52, 5+WORSTDEBUGMENU.MainOffset)
		--font:DrawStringScaledUTF8("aaaaaa",pos.X+1,pos.Y-1,0.5,0.5,KColor(0.2,0.2,0.2,0.8),0,false) 
	end)
	self.posfunc = function()
		self.pos = Vector(52, 5+WORSTDEBUGMENU.MainOffset)
	end

	local self
	self = WORSTDEBUGMENU.wma.AddButton("_debugcmd", "plashka", Vector(0,0), sizev.X, sizev.Y, Sprite() , function(button) 
		if button ~= 0 then return end
		--debugcmd.CanMove = true
	end, nil, nil, 10)
	self.BlockPress = true
	---------
	for i=1,14 do
		local self
		self = WORSTDEBUGMENU.wma.AddButton("_debugcmd", "debug"..i, Vector(i*18-14,13), 18, 17, UIs["debugbtn" .. i] , function(button) 
			if button ~= 0 then return end
			Isaac.ExecuteCommand("debug " .. i)
			blockPlayerShot()
			self.IsActived = not self.IsActived
		end, function(pos)
			--self.pos = Vector((i-1)*18+6,13) + debugcmd.pos
			if self.IsActived then
				UIs.Var_Sel:Render(self.pos + Vector(2,12))
			end
		end)
		--self.posfunc = function()
		--	self.pos = Vector((i-1)*18+6,13) + debugcmd.pos 
		--end
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
			
			if shouldReturnMouseControl then
				Options.MouseControl = true
				shouldReturnMouseControl = false
			end

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
		end

		--local spr = GenSprite("gfx/editor/aaaatest.anm2", "1")
		--spr:Render(Vector(200,200))


	end

	Menu:AddCallback(ModCallbacks.MC_GET_SHADER_PARAMS, Menu.DebugMenu)

end

do
	WORSTDEBUGMENU.StageSel = {name = "Stages_Selector", size = Vector(126,190), pos = Vector(87,35), btn = {}}
	local StageSel = WORSTDEBUGMENU.StageSel
	local sizev = StageSel.size

	local self
	self = WORSTDEBUGMENU.wma.AddButton("__debug_menu", "Stages_Selector_Menu", Vector(120,5), 32, 32, UIs.StageChanger, function(button) 
		if button ~= 0 then return end
		blockPlayerShot()
		---@type Window
		StageSel.wind = WORSTDEBUGMENU.wma.ShowWindow(StageSel.name, StageSel.pos, sizev)
		Menu.StageSel.DefaultSpawnButton()
	end)
	self.posfunc = function()
		self.pos = Vector(120, 5+WORSTDEBUGMENU.MainOffset)
	end

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
					blockPlayerShot()
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
					spr:ReplaceSpritesheet(2, stage.TransitionIcon)
					spr:SetLayerFrame(2,1)
					spr:LoadGraphics()

					---@type EditorButton
					local self
					self = WORSTDEBUGMENU.wma.AddButton(StageSel.name, i..","..j, pos, 20, 14, nilspr, function(button) 
						if button ~= 0 then return end
						blockPlayerShot()
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
			blockPlayerShot()
			Menu.StageSel.DefaultSpawnButton()
		end, function(pos)
			Menu.wma.RenderCustomTextBox(pos, Vector(self.x, self.y), self.IsSelected)
			font:DrawStringScaledUTF8(GetStr("default"),pos.X+2,pos.Y,0.5,0.5,KColor(0.1,0.1,0.2,1),0,false)
		end)

		local self
		---@type EditorButton
		self = Menu.wma.AddButton(StageSel.name, "stageAPI", Vector(3+51,9), 50, 10, nilspr, function(button) 
			if button ~= 0 then return end
			blockPlayerShot()
			Menu.StageSel.StageAPISpawnButton()
		end, function(pos)
			Menu.wma.RenderCustomTextBox(pos, Vector(self.x, self.y), self.IsSelected)
			font:DrawStringScaledUTF8("StageAPI",pos.X+2,pos.Y,0.5,0.5,KColor(0.1,0.1,0.2,1),0,false)
		end)
	end


	function Menu:StageSelectorPreRender(pos)
		if not StageSel.StageAPI  then
			local ypos = #StageSel.btn*18 -30
			local size = ypos + math.ceil(math.min(9,#StageSel.btn)/2)*3
			StageSel.wind.size.Y = size

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

	local self
	self = Menu.wma.AddButton("__debug_menu", "Ent_Spawner_Menu", Vector(154,5), 32, 32, UIs.EntSpawner, function(button) 
		if button ~= 0 then return end
		blockPlayerShot()
		---@type Window
		EntSpawner.wind = Menu.wma.ShowWindow(EntSpawner.name, EntSpawner.pos, sizev)
	end)
	self.posfunc = function()
		self.pos = Vector(154, 5+Menu.MainOffset)
	end
	
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
	self = Menu.wma.AddButton(EntSpawner.name, "odin_chel", Vector(73,48), 16, 16, UIs.Chlen_1, function(button) 
		if button ~= 0 then return end
		blockPlayerShot()
		EntSpawner.SpawnMode = EntSpawner.SpawnMode == 1 and 0 or 1
	end,
	function(pos)
		if EntSpawner.SpawnMode == 1 then
			UIs.Var_Sel:Render(self.pos+Vector(1.5,13))
		end
	end)
	local self
	self = Menu.wma.AddButton(EntSpawner.name, "mnogo_chel", Vector(91,48), 16, 16, UIs.Chlen_multi, function(button) 
		if button ~= 0 then return end
		blockPlayerShot()
		EntSpawner.SpawnMode = EntSpawner.SpawnMode == 2 and 0 or 2
	end,
	function(pos)
		if EntSpawner.SpawnMode == 2 then
			UIs.Var_Sel:Render(self.pos+Vector(1.5,13))
		end
	end)
	local self
	self = Menu.wma.AddButton(EntSpawner.name, "стереть", Vector(19,48), 16, 16, UIs.CCCCCCCC, function(button) 
		if button ~= 0 then return end
		blockPlayerShot()
		EntSpawner.SpawnList = {}
		EntSpawner.LastSpawns = {}
	end)
	local self
	self = Menu.wma.AddButton(EntSpawner.name, "nasad", Vector(37,48), 16, 16, UIs.nasad, function(button) 
		if button ~= 0 then return end
		blockPlayerShot()
		if #EntSpawner.SpawnList > 0 then
			table.remove(EntSpawner.SpawnList, #EntSpawner.SpawnList)
		end
	end)
	local self
	self = Menu.wma.AddButton(EntSpawner.name, "povtor", Vector(55,48), 16, 16, UIs.reset, function(button) 
		if button ~= 0 then return end
		blockPlayerShot()
		if EntSpawner.LastSpawns then
			EntSpawner.EntSpawner_SpawnList(EntSpawner.LastSpawns)
		end
	end)
	local self
	self = Menu.wma.AddButton(EntSpawner.name, "multispawn", Vector(73,66), 32, 16, nil, function(button) 
		if button ~= 0 then return end
		blockPlayerShot()
		if EntSpawner.SpawnList then
			EntSpawner.EntSpawner_SpawnList(EntSpawner.SpawnList)
		end
	end, function(pos)
		Menu.wma.RenderCustomButton(pos, Vector(32,14), self.IsSelected)
		font:DrawStringScaledUTF8("spawn",pos.X+1,pos.Y-1,0.5,0.5,KColor(0.1,0.1,0.2,1),0,false)
	end)

	function EntSpawner.EntSpawner_SpawnList(tab)
		for i=1, #tab do
			local dat = tab[i]
			Isaac.Spawn(dat[1], dat[2], dat[3], dat[4], Vector(0,0), nil)
		end
		EntSpawner.LastSpawns = TabDeepCopy(tab)
	end

	function Menu.EntSpawnerRender()
		if game:IsPaused() then return end
		if EntSpawner.wind and EntSpawner.wind.Removed then
			EntSpawner.wind = nil
		end
		if EntSpawner.SpawnMode > 0 and EntSpawner.wind then
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
		end
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

		if Menu.GridSpawner.wind and Menu.GridSpawner.wind.Removed then
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
		end
	end

	Menu:AddCallback(ModCallbacks.MC_POST_RENDER, Menu.EntSpawnerRender)
end

do --UIs.GridSpawner
	
	Menu.GridSpawner = {name = "Grid_Spawner", size = Vector(166,56), pos = Vector(140,35), btn = {}, TVS = 0,
		SpawnMode = 0, GridName = "decoration", 
	}
	local GridSpawner = Menu.GridSpawner
	local sizev = GridSpawner.size

	local self
	self = Menu.wma.AddButton("__debug_menu", "Grid_Spawner_Menu", Vector(188,5), 32, 32, UIs.GridSpawner, function(button) 
		if button ~= 0 then return end
		blockPlayerShot()
		---@type Window
		GridSpawner.wind = Menu.wma.ShowWindow(GridSpawner.name, GridSpawner.pos, sizev)
	end)
	self.posfunc = function()
		self.pos = Vector(188, 5+Menu.MainOffset)
	end
	
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
		blockPlayerShot()
		
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

		if Menu.wma.GetButton(GridSpawner.name, "_Listshadow", true) 
		and Menu.wma.ScrollOffset then
			self.Offset = Menu.wma.ScrollOffset/1
		end
		
		--Menu.wma.DetectSelectedButton(GridSpawner.name..1)
		--Menu.wma.RenderMenuButtons(GridSpawner.name..1)
	end)

	local self
	self = Menu.wma.AddButton(GridSpawner.name, "odin_chel", Vector(5,32), 16, 16, UIs.Chlen_1, function(button) 
		if button ~= 0 then return end
		blockPlayerShot()
		GridSpawner.SpawnMode = GridSpawner.SpawnMode == 1 and 0 or 1
	end,
	function(pos)
		if GridSpawner.SpawnMode == 1 then
			UIs.Var_Sel:Render(self.pos+Vector(1.5,13))
		end
	end)

	local self
	self = Menu.wma.AddButton(GridSpawner.name, "edit_grid", Vector(22,32), 16, 16, UIs.Editbtn, function(button) 
		if button ~= 0 then return end
		blockPlayerShot()
		GridSpawner.SpawnMode = GridSpawner.SpawnMode == 2 and 0 or 2
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
		blockPlayerShot()
		
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


end

do
	function UIs.Box48() return GenSprite("gfx/editor/ui copy.anm2","контейнер") end
	--WORSTDEBUGMENU.AddButtonOnDebugBar(buttonName, size, sprite, pressFunc, renderFunc)

	Menu.AnimTest = {name = "Anim_Test", size = Vector(166,186), btn = {}, anim = {anm2 = "", animation = "", col = Color(1,1,1,1)}}
	local AnimTest = Menu.AnimTest
	local sizev = AnimTest.size

	AnimTest.anim.spr = GenSprite("gfx/editor/ui copy.anm2","режим_сетки")   --Sprite()
	AnimTest.anim.RenderPos = Vector(0,0)

	local self
	self = WORSTDEBUGMENU.AddButtonOnDebugBar("Anim_Test_Menu", Vector(32,32), UIs.AnimTaste, function(button) 
		if button ~= 0 then return end
		blockPlayerShot()
		---@type Window
		AnimTest.wind = Menu.wma.ShowWindow(AnimTest.name, self.pos+Vector(0,15), sizev)
	end, nil)
	
	--[[local self
	self = Menu.wma.AddButton(AnimTest.name, "preview", Vector(22,32), 32, 32, UIs.Box48(), function(button) 
		if button ~= 0 then return end
	end,
	function(pos)
		AnimTest.anim.spr:Render(pos+Vector(16,16))
	end, true)]]

	local si = Vector(140,48)
	local self
	self = Menu.wma.AddGragZone(AnimTest.name, "preview", Vector(12,12), si, nil, function(button, newpos, prepos)
		if button ~= 0 then return end
		AnimTest.anim.RenderPos = newpos
	end, function(pos)
		Menu.wma.RenderCustomButton(pos, si, self.IsSelected)
		AnimTest.anim.spr:Render(pos+Vector(60,24)+AnimTest.anim.RenderPos)
		if Isaac.GetFrameCount() % 2 == 0 then
			AnimTest.anim.spr:Update()
		end

		if self.IsSelected then
			local sc = AnimTest.anim.col
			AnimTest.anim.spr.Color = Color(sc.R, sc.G, sc.B, sc.A /2 )
		else
			local sc = AnimTest.anim.col
			AnimTest.anim.spr.Color = Color(sc.R, sc.G, sc.B, sc.A )
		end
	end)

	AnimTest.btn.anm2 = Menu.wma.AddTextBox(AnimTest.name, "anm2", Vector(12,92), Vector(140,16), nil, 
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
				--ret = false
				--AnimTest.btn.anm2.text = result
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
			--self.text = AnimTest.TVS[2]
			return true
		end
	end, false, function(pos)
		font:DrawStringScaledUTF8(GetStr("AnmFile"),pos.X+1,pos.Y-9,0.5,0.5,KColor(0.1,0.1,0.2,1),0,false)
	end)
	AnimTest.btn.anm2.text = "gfx/"

	AnimTest.btn.anim = Menu.wma.AddTextBox(AnimTest.name, "anim", Vector(12,120), Vector(140,16), nil, 
	function(result)
		if not result then
			return true
		else
			if #result < 1 or not string.find(result,"%S") then
				return GetStr("emptyField")
			end
			AnimTest.anim.spr:Play(result, true )
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


end






-- Thanks Cucco
Menu:AddCallback(ModCallbacks.MC_POST_PLAYER_INIT, function()
	if #Isaac.FindByType(EntityType.ENTITY_PLAYER) == 0 then
		Isaac.ExecuteCommand("reloadshaders")
	end
end)