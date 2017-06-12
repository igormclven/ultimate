
local curTime = -1;
local bpm = 60;
local curskin = {
    [PLAYER_1] = "",
    [PLAYER_2] = "",
}

local startup = GetTimeSinceStart()
local function UnscaledDelta()
    local dt = GetTimeSinceStart() - startup;
    startup = GetTimeSinceStart();
    return dt;
end;

local function UpdateTime(self, delta)
    --local _start = Global.song:GetSampleStart();
    --local _length = Global.song:GetSampleLength();
    --local _end = Global.song:MusicLengthSeconds();
    curTime = GAMESTATE:GetCurMusicSeconds();
    MESSAGEMAN:Broadcast("UpdateNotefield");
end

local t = Def.ActorFrame{
    InitCommand=function(self) self:SetUpdateFunction(UpdateTime); self:diffusealpha(0); end;
    StateChangedMessageCommand=function(self)
        self:stoptweening();
        self:linear(0.15);
        if Global.state == "SelectSteps" or
           Global.state == "SpeedMods" or
           Global.state == "Noteskins" then
           self:diffusealpha(1);
        else
            self:diffusealpha(0);
        end;
    end;
} 

local tex = Def.ActorFrameTexture{
    InitCommand= function(self)
        self:setsize(_screen.w, _screen.h)
        self:SetTextureName("notefield_overlay")
        self:EnableAlphaBuffer(true);
        self:EnablePreserveTexture(false)
        self:Create();
    end;
}

-- <Kyzentun> Luizsan: Yeah, it's touchy about the order.  I tried to make it less 
-- touchy in the notefield_targets branch, but good luck finding someone to build that.
for pn in ivalues(GAMESTATE:GetHumanPlayers()) do

    tex[#tex+1] = Def.NoteField{

        StepsChangedMessageCommand=cmd(playcommand,"Refresh");
        SpeedChangedMessageCommand=cmd(playcommand,"Refresh");
        FolderChangedMessageCommand=cmd(playcommand,"Refresh");
        NoteskinChangedMessageCommand=function(self,param)
            if param and param.noteskin and param.Player == pn then
                self:set_skin(param.noteskin, {});
            end;
        end;

        StateChangedMessageCommand=function(self)
            if Global.state == "Noteskins" then self:playcommand("Refresh"); end;
        end;

        RefreshCommand=function(self)
            if GAMESTATE:IsSideJoined(pn) then
                local steps = Global.pncursteps[pn] or GAMESTATE:GetCurrentSteps(pn);

                local skin = GetPreferredNoteskin(pn);
                local prefs = notefield_prefs_config:get_data(pn);

                self:set_vanish_type("FieldVanishType_RelativeToSelf")

                if curskin[pn] ~= skin then
                    self:set_skin(skin, {});
                    curskin = skin;
                end;

                self:set_steps(steps);

                local speed = prefs.speed_mod;
                local mode = prefs.speed_type;
                local bpm = Global.song:GetDisplayBpms()[2];

                apply_notefield_prefs_nopn(bpm, self, prefs)
                self:playcommand("WidthSet");
                self:set_curr_second(curTime);  
            end;
        end;

        WidthSetCommand=function(self,param)
            if GAMESTATE:IsSideJoined(pn) then
                local steps = Global.pncursteps[pn] or GAMESTATE:GetCurrentSteps(pn);
                local st = PureType(steps);

                if (st == "Double" or st == "Routine") or GAMESTATE:GetNumSidesJoined() == 1 then
                    self:set_base_values{
                        transform_pos_x = _screen.cx, 
                        transform_pos_y = _screen.cy,
                    }
                else
                    self:set_base_values{
                        transform_pos_x = _screen.cx + (self:get_width() + 24) * 0.5 * pnSide(pn), 
                        transform_pos_y = _screen.cy,
                    }
                end;
            end;
        end;

        UpdateNotefieldMessageCommand=function(self)
            if GAMESTATE:IsSideJoined(pn) then
                self:set_curr_second(curTime);
            end;
        end;
    };

end;

t[#t+1] = tex;

t[#t+1] = Def.Quad{
    InitCommand=cmd(diffuse,0.25,0.25,0.25,0.75;vertalign,top;xy,_screen.cx,_screen.cy-177;zoomto,520,247;fadeleft,0.2;faderight,0.2);
};

t[#t+1] = Def.Sprite{
    Texture = "notefield_overlay";
    InitCommand=cmd(zoom,0.515;xy,_screen.cx,_screen.cy-177;vertalign,top;diffusealpha,0);
    OnCommand=cmd(playcommand,"Reload");
    MusicWheelMessageCommand=cmd(playcommand,"Reload");
    ReloadCommand=cmd(stoptweening;diffusealpha,0;sleep,0.6;linear,0.25;diffusealpha,1);
}


return t;