
NewAddon = {};
NewAddon.fully_loaded = false;
NewAddon.default_options = {

	-- main frame position
	frameRef = "CENTER",
	frameX = 0,
	frameY = 0,
	hide = false,

	-- sizing
	frameW = 200,
	frameH = 200,
};


function NewAddon.OnReady()

	-- set up default options
	_G.NewAddonPrefs = _G.NewAddonPrefs or {};

	for k,v in pairs(NewAddon.default_options) do
		if (not _G.NewAddonPrefs[k]) then
			_G.NewAddonPrefs[k] = v;
		end
	end

	NewAddon.CreateUIFrame();
end

function NewAddon.OnSaving()

	if (NewAddon.UIFrame) then
		local point, relativeTo, relativePoint, xOfs, yOfs = NewAddon.UIFrame:GetPoint()
		_G.NewAddonPrefs.frameRef = relativePoint;
		_G.NewAddonPrefs.frameX = xOfs;
		_G.NewAddonPrefs.frameY = yOfs;
	end
end

function NewAddon.OnUpdate()
	if (not NewAddon.fully_loaded) then
		return;
	end

	if (NewAddonPrefs.hide) then 
		return;
	end

	NewAddon.UpdateFrame();
end

function NewAddon.OnEvent(frame, event, ...)

	if (event == 'ADDON_LOADED') then
		local name = ...;
		if name == 'NewAddon' then
			NewAddon.OnReady();
		end
		return;
	end

	if (event == 'PLAYER_LOGIN') then

		NewAddon.fully_loaded = true;
		return;
	end

	if (event == 'PLAYER_LOGOUT') then
		NewAddon.OnSaving();
		return;
	end
end

function NewAddon.CreateUIFrame()

	-- create the UI frame
	NewAddon.UIFrame = CreateFrame("Frame",nil,UIParent);
	NewAddon.UIFrame:SetFrameStrata("BACKGROUND")
	NewAddon.UIFrame:SetWidth(_G.NewAddonPrefs.frameW);
	NewAddon.UIFrame:SetHeight(_G.NewAddonPrefs.frameH);

	-- make it black
	NewAddon.UIFrame.texture = NewAddon.UIFrame:CreateTexture();
	NewAddon.UIFrame.texture:SetAllPoints(NewAddon.UIFrame);
	NewAddon.UIFrame.texture:SetTexture(0, 0, 0);

	-- position it
	NewAddon.UIFrame:SetPoint(_G.NewAddonPrefs.frameRef, _G.NewAddonPrefs.frameX, _G.NewAddonPrefs.frameY);

	-- make it draggable
	NewAddon.UIFrame:SetMovable(true);
	NewAddon.UIFrame:EnableMouse(true);

	-- create a button that covers the entire addon
	NewAddon.Cover = CreateFrame("Button", nil, NewAddon.UIFrame);
	NewAddon.Cover:SetFrameLevel(128);
	NewAddon.Cover:SetPoint("TOPLEFT", 0, 0);
	NewAddon.Cover:SetWidth(_G.NewAddonPrefs.frameW);
	NewAddon.Cover:SetHeight(_G.NewAddonPrefs.frameH);
	NewAddon.Cover:EnableMouse(true);
	NewAddon.Cover:RegisterForClicks("AnyUp");
	NewAddon.Cover:RegisterForDrag("LeftButton");
	NewAddon.Cover:SetScript("OnDragStart", NewAddon.OnDragStart);
	NewAddon.Cover:SetScript("OnDragStop", NewAddon.OnDragStop);
	NewAddon.Cover:SetScript("OnClick", NewAddon.OnClick);

	-- add a main label - just so we can show something
	NewAddon.Label = NewAddon.Cover:CreateFontString(nil, "OVERLAY");
	NewAddon.Label:SetPoint("CENTER", NewAddon.UIFrame, "CENTER", 2, 0);
	NewAddon.Label:SetJustifyH("LEFT");
	NewAddon.Label:SetFont([[Fonts\FRIZQT__.TTF]], 12, "OUTLINE");
	NewAddon.Label:SetText(" ");
	NewAddon.Label:SetTextColor(1,1,1,1);
	NewAddon.SetFontSize(NewAddon.Label, 20);
end

function NewAddon.SetFontSize(string, size)

	local Font, Height, Flags = string:GetFont()
	if (not (Height == size)) then
		string:SetFont(Font, size, Flags)
	end
end

function NewAddon.OnDragStart(frame)
	NewAddon.UIFrame:StartMoving();
	NewAddon.UIFrame.isMoving = true;
	GameTooltip:Hide()
end

function NewAddon.OnDragStop(frame)
	NewAddon.UIFrame:StopMovingOrSizing();
	NewAddon.UIFrame.isMoving = false;
end

function NewAddon.OnClick(self, aButton)
	if (aButton == "RightButton") then
		print("show menu here!");
	end
end

function NewAddon.UpdateFrame()

	-- update the main frame state here
	NewAddon.Label:SetText(string.format("%d", GetTime()));
end


NewAddon.EventFrame = CreateFrame("Frame");
NewAddon.EventFrame:Show();
NewAddon.EventFrame:SetScript("OnEvent", NewAddon.OnEvent);
NewAddon.EventFrame:SetScript("OnUpdate", NewAddon.OnUpdate);
NewAddon.EventFrame:RegisterEvent("ADDON_LOADED");
NewAddon.EventFrame:RegisterEvent("PLAYER_LOGIN");
NewAddon.EventFrame:RegisterEvent("PLAYER_LOGOUT");
