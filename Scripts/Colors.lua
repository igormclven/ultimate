--//================================================================

JudgmentColor = {
    ["Superb"]  = color("1.0, 0.4, 0.9, 1"),
    ["Pefect"]  = color("0.2, 0.7, 1.0, 1"),
    ["Great"]   = color("0.1, 1.0, 0.3, 1"),
    ["Good"]    = color("1.0, 0.9, 0.2, 1"),
    ["Bad"]     = color("0.8, 0.2, 0.9, 1"),
    ["Miss"]    = color("1.0, 0.1, 0.1, 1"),
}

local _GradeColor = {
    ["SS"]      = color("1.00, 0.85, 0.25, 1"),
    ["S+"]      = color("1.00, 0.85, 0.25, 1"),
    ["S"]       = color("1.00, 1.00, 1.00, 1"),
    ["AAAA"]    = color("0.50, 1.00, 1.00, 1"),
    ["AAA"]     = color("0.40, 0.90, 1.00, 1"),
    ["AA"]      = color("0.30, 0.80, 1.00, 1"),
    ["A"]       = color("0.20, 0.70, 1.00, 1"),
    ["B"]       = color("0.25, 1.00, 0.50, 1"),
    ["C"]       = color("1.00, 0.75, 0.50, 1"),
    ["D"]       = color("0.80, 0.40, 1.00, 1"),
    ["F"]       = color("1.00, 0.25, 0.25, 1"),
    ["Failed"]  = color("1.00, 0.10, 0.10, 1"),
}

--//================================================================

function HighlightColor() 
    return color("0.3,1,0.775,1");
end;

--//================================================================

function PlayerColor(pn,alpha)

    if pn == PLAYER_1 then 
        if alpha then
            return color("0.40,0.85,1,"..alpha) 
        else
            return color("0.40,0.85,1")
        end
    end;

    if pn == PLAYER_2 then 
        if alpha then
            return color("0.20,1,0.40,"..alpha) 
        else
            return color("0.20,1,0.40") 
        end;
    end;
    
    return color("1,1,1")
end

--//================================================================

function GradeColor(letter)
    if _GradeColor[letter] ~= nil then
        return _GradeColor[letter];
    else 
        return color("1,1,1,1");
    end;
end;

--//================================================================

function StepsColor(steps)
    local tint = {1,1,1,1}; 

    if steps then
        if PureType(steps) == "Single" then
            tint = {0.95,0.75,0.1,1};               
        elseif PureType(steps) == "Double" then
            tint = {0.2,0.9,0.2,1}; 
        elseif PureType(steps) == "Halfdouble" then
            tint = {0.8,0.1,0.6,1}; 
        elseif PureType(steps) == "Routine" then
            tint = {0.3,0.85,1,1};
        elseif PureType(steps) == "Solo" or PureType(steps) == "Couple" or PureType(steps) == "Real" then
            tint = {1,0.5,0.5,1};
        end;
    end;    

    return tint;
end;
