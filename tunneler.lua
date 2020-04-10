local args = {...};
local speaker = peripheral.find("speaker");
local notes = {
    ["F#0"] = 0,
    ["G0"] = 1,
    ["G#0"] = 2,
    ["A0"]= 3,
    ["A#0"] = 4,
    ["B0"] = 5,
    ["C1"] = 6,
    ["C#1"] = 7,
    ["D1"] = 8,
    ["D#1"] = 9,
    ["E1"] = 10,
    ["F1"] = 11,
    ["F#1"] = 12,
    ["G1"] = 13,
    ["G#1"] = 14,
    ["A1"] = 15,
    ["A#1"] = 16,
    ["B1"] = 17,
    ["C2"] = 18,
    ["C#2"] = 19,
    ["D2"] = 20,
    ["D#2"] = 21,
    ["E2"] = 22,
    ["F2"] = 23,
    ["F#2"] = 24
};

local moonTheme = {
    {{"F#0"}, 0.15}, -- Bar
    {{"C1"}, 0.15},
    {{"F1"}, 0.15},
    {{"G1"}, 0.15},
    {{"C1"}, 0.15},
    {{"F1"}, 0.15},
    {{"G1"}, 0.15},
    {{"C1"}, 0.15},
    {{"B1"}, 0.15}, -- Bar
    {{"C1"}, 0.15},
    {{"B1"}, 0.15},
    {{"A1"}, 0.15},
    {{"C1"}, 0.15},
    {{"A1"}, 0.15},
    {{"G1"}, 0.15},
    {{"F1"}, 0.15},
    {{"F#0", "C1"}, 0.15},  -- Bar
    {{"C1"}, 0.15},
    {{"F1"}, 0.15},
    {{"G1"}, 0.15},
    {{"C1"}, 0.15},
    {{"F1"}, 0.15},
    {{"G1"}, 0.15},
    {{"C1"}, 0.15},
    {{"B1"}, 0.15}, -- Bar
    {{"C1"}, 0.15},
    {{"B1", "F1"}, 0.15},
    {{"A1"}, 0.15},
    {{"C1", "G1"}, 0.15},
    {{"A1"}, 0.15},
    {{"G1", "B1"}, 0.15},
    {{"F1"}, 0.15},
    {{"F#0", "B1"}, 0.15},  -- Bar
    {{"C1"}, 0.15},
    {{"F1"}, 0.15},
    {{"G1", "A1"}, 0.15},
    {{"C1", "A1"}, 0.15},
    {{"F1"}, 0.15},
    {{"G1"}, 0.15},
    {{"C1"}, 0.15},
    {{"B1"}, 0.15}, -- Bar
    {{"C1"}, 0.15},
    {{"B1"}, 0.15},
    {{"A1"}, 0.15},
    {{"C1", "G1"}, 0.15},
    {{"A1"}, 0.15},
    {{"G1", "F1"}, 0.15},
    {{"F1"}, 0.15},
    {{"F#0", "C2"}, 0.15},  -- Bar
    {{"C1"}, 0.15},
    {{"F1"}, 0.15},
    {{"G1"}, 0.15},
    {{"C1"}, 0.15},
    {{"F1"}, 0.15},
    {{"G1", "F1"}, 0.15},
    {{"C1"}, 0.15},
    {{"B1"}, 0.15}, -- Bar
    {{"C1"}, 0.15},
    {{"B1"}, 0.15},
    {{"A1"}, 0.15},
    {{"C1", "F2"}, 0.15},
    {{"A1"}, 0.15},
    {{"G1"}, 0.15},
    {{"F1", "F2"}, 0.15},
}

function playTune(tune)
    for k, v in pairs(tune) do
        speaker.playNote("flute", 0.25, notes[v[1][1]]);
        if (v[1][2] ~= nil) then
            speaker.playNote("flute", 3, notes[v[1][2]]);
        end
        sleep(v[2]);
    end
end

local args = {...};
local fuelSlot = nil;
local inventorySlots = 16;
local dugBlocks = 1;

function modulus(a, b)
    return (a - math.floor(a/b)*b)
end

function isEven(x)
    return modulus(x, 2) == 0;
end

function isOdd(x)
    return not isEven(x);
end

function splitString (inputstr, sep)
    if sep == nil then
            sep = "%s";
    end
    local t={};
    for str in string.gmatch(inputstr, "([^"..sep.."]+)") do
            table.insert(t, str);
    end
    return t;
end

local Status = {
    Starting = 0,
    Working = 1,
    PitStop = 2,
    Returning = 3,
    Parking = 4,
    Stopped = 5,
    Egg = 6
}
local status = Status.Starting;

local FilterMode = {
    Blacklist = 0,
    Whitelist = 1,
    None = 2
}
local filterMode = FilterMode.Blacklist;
local filteredItems = {};

function addFilterID(id)
    filteredItems[id] = true;
end

function removeFilterId(id)
    filteredItems[id] = nil;
end

function filterInventory()
    if (filterMode == FilterMode.None) then return end;

    local dropped = false;
    for i = 1, inventorySlots do
        local itemDetail = turtle.getItemDetail(i);
        if (itemDetail ~= nil) then
            if (filterMode == FilterMode.Whitelist) then
                if (filteredItems[itemDetail.name] == nil) then
                    turtle.select(i);
                    turtle.dropUp();
                    dropped = true;
                end
            else
                if (filteredItems[itemDetail.name] ~= nil) then
                    turtle.select(i);
                    turtle.dropUp();
                    dropped = true;
                end
            end
        end
    end

    if (dropped) then
        turtle.select(fuelSlot);
    end
end

function isInventoryFull()
    local count = 0;
    for i = 1, inventorySlots do
        if (turtle.getItemDetail(i) ~= nil) then
            count = count + 1;
        end
    end

    return count == inventorySlots;
end

local junkBlacklist = {
    "minecraft:cobblestone",
    "minecraft:sand",
    "minecraft:planks",
    "minecraft:dirt",
    "astralsorcery:blockmarble",
    "quark:marble",
    "chisel:marble2",
    "minecraft:stone",
    "quark:basalt",
    "astralsorcery:blockbasalt",
    "chisel:basalt2",
    "chisel:limestone2",
    "minecraft:sandstone",
    "minecraft:clay_ball",
    "minecraft:gravel"
}

function loadJunkBlacklist()
    filterMode = FilterMode.Blacklist;
    for k, v in pairs (junkBlacklist) do
        addFilterID(v);
    end
end

function roundNumber(num, numDecimalPlaces)
    local mult = 10^(numDecimalPlaces or 0);
    return math.floor(num * mult + 0.5) / mult;
end

local vectorMeta = getmetatable(vector.new(0, 0, 0));
function vector.zero()
    return vector.new(0, 0, 0);
end
function vector.forward()
    return vector.new(1, 0, 0)
end
function vector.right()
    return vector.new(0, 0, 1)
end
function vector.up()
    return vector.new(0, 1, 0)
end
vectorMeta.__index["getForwardAxis"] = function(vec)
    return vec.x;
end
vectorMeta.__index["getRightAxis"] = function(vec)
    return vec.z;
end
vectorMeta.__index["getUpAxis"] = function(vec)
    return vec.y;
end
vectorMeta.__index["setForwardAxis"] = function(vec, val)
    vec.x = val;
end
vectorMeta.__index["setRightAxis"] = function(vec, val)
    vec.z = val;
end
vectorMeta.__index["setUpAxis"] = function(vec, val)
    vec.y = val;
end
vectorMeta.__index["movementCost"] = function(vec)
    return vec.x + vec.y + vec.z;
end
function vectorMeta.__eq(a, b)
    return (a.x == b.x and a.y == b.y and a.z == b.z);
end
local bounds = vector.zero();
local localPosition = vector.zero();
local localRotation = -vector.forward();
local returnPosition = vector.zero();
local returning = false;
local pitStopping = false;

function getHomingCost()
    return localPosition:movementCost();
end

function getReturnCost()
    return returnPosition:movementCost();
end

function shouldRefuel(fuelThreshold)
    if (fuelThreshold == nil) then return false; end;
    if (turtle.getFuelLevel() > fuelThreshold) then
        return false;
    end
    return true;
end

function isValidFuel()
    return turtle.refuel(0);
end

function findFuelSlot()
    for i = 1, inventorySlots do
        if (turtle.getItemDetail(i) ~= nil) then
            turtle.select(i);
            if (isValidFuel()) then
                fuelSlot = i;
                return true;
            end
        end
    end
    fuelSlot = nil;
    return false;
end

function refuel(fuelThreshold)
    if (not isValidFuel()) then
        if (not findFuelSlot()) then
            return false;
        end
    end
    
    while (turtle.getFuelLevel() < fuelThreshold) do
        local success = turtle.refuel(1);
        if (not success) then
            return false;
        end
    end
    return true;
end

function dumpInventoryInStorage()
    for i = 1, inventorySlots do
        local slot = (fuelSlot or 0) + i;
        if (slot > 16) then
            slot = slot - 16;
        end
        local itemDetail = turtle.getItemDetail(slot);
        if (itemDetail ~= nil) then
            turtle.select(slot);
            turtle.drop();
        end
    end
end

function restockFuelFromStorage()
    fuelSlot = 1;
    turtle.select(fuelSlot);
    local completed = false;
    local prevStackCount = 0;
    local stackCount = 0;
    repeat
        turtle.suck();
        local itemDetail = turtle.getItemDetail(fuelSlot);
        if (itemDetail == nil) then
            return false;
        else
            if (not isValidFuel()) then
                turtle.drop();
                return false;
            end

            stackCount = itemDetail.count;
            if (stackCount == prevStackCount) then
                turtle.select(fuelSlot + 1);
                turtle.drop();
                turtle.select(fuelSlot);
                completed = true;
            end
            prevStackCount = stackCount;
        end
    until completed

    return true;
end

function pitStop(bResuming)
    if (not bResuming) then
        setStatus(Status.PitStop);
        setReturnPosition();
    end

    moveToCoordinates(vector.zero(), true);
    faceDirection(-vector.forward());

    dumpInventoryInStorage();
    restockFuelFromStorage();

    repeat
        fueled = refuel((getReturnCost() * 2) + 1);
        if (not fueled) then
            restockFuelFromStorage();
        end
    until fueled;


    setStatus(Status.Returning);
    returnToWork();
end

function parkTurtle()
    setStatus(Status.Parking);

    moveToCoordinates(vector.zero(), true);
    faceDirection(-vector.forward());
    dumpInventoryInStorage();

    setStatus(Status.Stopped);
end

function returnToWork()
    moveToCoordinates(returnPosition, true);
    setReturnPosition(vector.zero());

    setStatus(Status.Working);
    return true;
end

local Direction = {
    Forward = {axis = "x", flip = false, sign = 1},
    Right = {axis = "z", flip = false, sign = 1},
    Up = {axis = "y", flip = false, sign = 1},
    Backward = {axis = "x", flip = true, sign = -1},
    Left = {axis = "z", flip = true, sign = -1},
    Down = {axis = "y", flip = true, sign = -1}
};
local DigDirection = {
    Up = 0,
    Down = 1,
    Forward = 2
};
local TransformedDirectionVectors = {
    [DigDirection.Up] = {
        x = vector.forward(),
        y = vector.up(),
        z = vector.right()
    },
    [DigDirection.Down] = {
        x = vector.forward(),
        y = -vector.up(),
        z = vector.right()
    },
    [DigDirection.Forward] = {
        x = vector.right(),
        y = vector.forward(),
        z = vector.up()
    }
};
local DirectionVectors = {
    x = vector.forward(),
    y = vector.up(),
    z = vector.right()
};

function flipRightAxis()
    Direction.Right.flip = not Direction.Right.flip;
    Direction.Left.flip = not Direction.Left.flip;
end

local digDirection = DigDirection.Down;

function createStartupFile()
    local h = fs.open('/startup', 'w');
    local name = fs.getName(shell.getRunningProgram());

    h.write("shell.run(\"" .. name .. " --resume\");");

    h.close();
end

function saveStatus()
    local h = fs.open("./tunnelingProgress", 'w');
    
    h.writeLine(tostring(status));
    h.writeLine(tostring(digDirection));
    h.writeLine(tostring(dugBlocks));

    h.writeLine(tostring(localPosition.x));
    h.writeLine(tostring(localPosition.y));
    h.writeLine(tostring(localPosition.z));

    h.writeLine(tostring(localRotation.x));
    h.writeLine(tostring(localRotation.y));
    h.writeLine(tostring(localRotation.z));

    h.writeLine(tostring(bounds.x));
    h.writeLine(tostring(bounds.y));
    h.writeLine(tostring(bounds.z));

    h.writeLine(tostring(returnPosition.x));
    h.writeLine(tostring(returnPosition.y));
    h.writeLine(tostring(returnPosition.z));

    h.writeLine(tostring(filterMode));
    
    for k, v in pairs (filteredItems) do
        h.writeLine(k);
    end

    h.close();
end

function loadStatus()
    filteredItems = {};

    if (not fs.exists("./tunnelingProgress")) then
        print("Resume File Doesn't Exist");
        return false;
    end
    
    local h = fs.open("./tunnelingProgress", 'r');

    status = tonumber(h.readLine());
    digDirection = tonumber(h.readLine());
    dugBlocks = tonumber(h.readLine());

    localPosition.x = tonumber(h.readLine());
    localPosition.y = tonumber(h.readLine());
    localPosition.z = tonumber(h.readLine());

    localRotation.x = tonumber(h.readLine());
    localRotation.y = tonumber(h.readLine());
    localRotation.z = tonumber(h.readLine());

    bounds.x = tonumber(h.readLine());
    bounds.y = tonumber(h.readLine());
    bounds.z = tonumber(h.readLine());

    returnPosition.x = tonumber(h.readLine());
    returnPosition.y = tonumber(h.readLine());
    returnPosition.z = tonumber(h.readLine());

    filterMode = tonumber(h.readLine());

    if (
        localPosition.x == nil or
        localPosition.y == nil or
        localPosition.z == nil or
        localRotation.x == nil or
        localRotation.y == nil or
        localRotation.z == nil or
        bounds.x == nil or
        bounds.y == nil or
        bounds.z == nil or
        returnPosition.x == nil or
        returnPosition.y == nil or
        returnPosition.z == nil or
        status == nil or
        filterMode == nil or
        digDirection == nil or
        dugBlocks == nil
    ) then
        print("Resume File is Corrupt");
        return false;
    end
    
    local line = h.readLine();
    while (line) do
        addFilterID(line);
        line = h.readLine();
    end

    h.close();

    return true;
end

function setReturnPosition()
    returnPosition = vector.new(localPosition.x, localPosition.y, localPosition.z);
    saveStatus();
end

function setStatus(sts)
    status = sts;
    saveStatus();
end

function setDugBlocks(num)
    dugBlocks = num;
    saveStatus();
end

function setDigDirection(dir)
    digDirection = dir;
    saveStatus();
end

function setLocalPosition(pos)
    localPosition = pos;
    saveStatus();
end

function setLocalRotation(rot)
    localRotation = rot;
    saveStatus();
end

function rotateRight()
    if (localRotation == vector.forward()) then
        setLocalRotation(vector.right());
    elseif (localRotation == vector.right()) then
        setLocalRotation(-vector.forward());
    elseif (localRotation == -vector.forward()) then
        setLocalRotation(-vector.right());
    elseif (localRotation == -vector.right()) then
        setLocalRotation(vector.forward());
    end
    turtle.turnRight();
end

function rotateLeft()
    if (localRotation == vector.forward()) then
        setLocalRotation(-vector.right());
    elseif (localRotation == -vector.right()) then
        setLocalRotation(-vector.forward());
    elseif (localRotation == -vector.forward()) then
        setLocalRotation(vector.right());
    elseif (localRotation == vector.right()) then
        setLocalRotation(vector.forward());
    end
    turtle.turnLeft();
end

function faceDirection(vectorDirection)
    if (vectorDirection == -localRotation) then
        rotateRight();
        rotateRight();
    elseif (vectorDirection ~= localRotation) then
        if (localRotation == vector.forward()) then
            if (vectorDirection == vector.right()) then
                rotateRight();
            elseif (vectorDirection == -vector.right()) then
                rotateLeft();
            end
        elseif (localRotation == -vector.forward()) then
            if (vectorDirection == vector.right()) then
                rotateLeft();
            elseif (vectorDirection == -vector.right()) then
                rotateRight();
            end
        elseif (localRotation == vector.right()) then
            if (vectorDirection == vector.forward()) then
                rotateLeft();
            elseif (vectorDirection == -vector.forward()) then
                rotateRight();
            end
        elseif (localRotation == -vector.right()) then
            if (vectorDirection == vector.forward()) then
                rotateRight();
            elseif (vectorDirection == -vector.forward()) then
                rotateLeft();
            end
        end
    end
end

function move(directionData, bForced)
    if (not bForced) then
        if (isInventoryFull()) then
            pitStop();
            return;
        elseif (shouldRefuel(getHomingCost())) then
            if (not refuel(getHomingCost() + 1)) then
                pitStop();
            end
        end
    end

    local axis = directionData.axis;
    local flip = directionData.flip;
    local sign = directionData.sign;
    local localMovementVector = TransformedDirectionVectors[digDirection][axis];
    if (flip) then
        localMovementVector = -localMovementVector;
    end

    local internalMovementVector = DirectionVectors[axis];

    local success = false;
    if (localMovementVector == vector.up()) then
        repeat
            if (turtle.detectUp()) then
                turtle.digUp();
            end
            success = turtle.up();
        until success
    elseif (localMovementVector == -vector.up()) then
        repeat
            if (turtle.detectDown()) then
                turtle.digDown();
            end
            success = turtle.down();
        until success
    else
        faceDirection(localMovementVector);
        repeat
            if (turtle.detect()) then
                turtle.dig();
            end
            success = turtle.forward();
        until success
    end

    setLocalPosition(localPosition + (internalMovementVector * sign));
end

function moveToCoordinates(newPosition, bForced)
    while (newPosition.x ~= localPosition.x) do
        if (newPosition.x > localPosition.x) then
            move(Direction.Forward, bForced);
        else
            move(Direction.Backward, bForced);
        end
    end

    while (newPosition.y ~= localPosition.y) do
        if (newPosition.y > localPosition.y) then
            move(Direction.Up, bForced);
        else
            move(Direction.Down, bForced);
        end
    end

    while (newPosition.z ~= localPosition.z) do
        if (newPosition.z > localPosition.z) then
            move(Direction.Right, bForced);
        else
            move(Direction.Left, bForced);
        end
    end
end

function printUsage()
    print("Length Width Depth DigDirection(Up, Down, Forward)");
    print("Place the turtle adjacent and facing a chest");
    print("\tSettings:");
    print("\t\t--resume");
    print("\t\t-filter x,...");
    print("\t\t-filter junk");
    print("\t\t-unfilter x,...");
    print("\t\t-unfilter all");
    print("\t\t-filtermode(Blacklist,Whitelist,None)");
end

function readArguments()
    local argCount = #args;
    local error = false;
    if (args[1] == "--resume") then
        return loadStatus();
    elseif (args[1] == "--moon") then
        setStatus(Status.Egg);
        setDigDirection(DigDirection.Up);
        return true;
    elseif (argCount < 4 or args[1] == "help") then
        error = true;
    end

    local currentParameter = nil;

    local function filterFunc(arg)
        if (arg == "junk") then
            loadJunkBlacklist();
        else
            local explodedArg = splitString(arg, ",");
            for k, v in pairs (explodedArg) do
                addFilterID(v);
            end
        end
        
        currentParameter = nil;

        return true;
    end

    local function unfilterFunc(arg)
        if (arg == "all") then
            filteredItems = {};
        else
            local explodedArg = splitString(arg, ",");
            for k, v in pairs (explodedArg) do
                removeFilterId(v);
            end
        end
        
        currentParameter = nil;

        return true;
    end

    local function filtermodeFunc(arg)
        arg = string.lower(arg);
        if (#arg > 1) then
            arg = string.upper(string.sub(arg, 1, 1)) .. string.lower(string.sub(arg, 2));
            if (FilterMode[arg] ~= nil) then
                filterMode = FilterMode[arg];
                return true;
            end
        end

        return true;
    end

    local parameters = {
        ["filter"] = filterFunc,
        ["unfilter"] = unfilterFunc,
        ["filtermode"] = filtermodeFunc
    }

    local function processArguments()
        for i = 5, #args do
            if (currentParameter == nil) then
                local arg = string.sub(args[i], 2);
                if (parameters[arg] ~= nil) then
                    currentParameter = arg;
                end
            else
                local arg = args[i];
                if (not parameters[currentParameter](arg)) then
                    return false;
                end
            end
        end
        return true;
    end

    local forwardAxis = tonumber(args[1]);
    local upAxis = tonumber(args[3]);
    local rightAxis = tonumber(args[2]);
    
    if (forwardAxis == nil or upAxis == nil or rightAxis == nil) then
        error = true;
    else
        bounds:setForwardAxis(forwardAxis);
        bounds:setUpAxis(upAxis);
        bounds:setRightAxis(rightAxis);

        local direction = string.lower(args[4]);
        if (#direction > 1) then
            direction = string.upper(string.sub(direction, 1, 1)) .. string.lower(string.sub(direction, 2));
            if (DigDirection[direction] ~= nil) then
                setDigDirection(DigDirection[direction]);

                if (not processArguments()) then
                    error = true;
                end
            else
                error = true;
            end
        else
            error = true;
        end
    end

    if (error) then
        printUsage();
        return false;
    end
    
    return true;
end

function doEasterEggTune()
    playTune(moonTheme);
end

local easterEggHeight = 13;

function doEasterEggMovement()
    for i = 1, easterEggHeight do
        rotateRight();
        moveToCoordinates(vector.up() * i);
    end
    moveToCoordinates(vector.zero());
    setStatus(Status.Stopped);
end

function doEasterEgg()
    moveToCoordinates(vector.zero());
    dumpInventoryInStorage();
    restockFuelFromStorage();
    refuel(easterEggHeight * 2);
    parallel.waitForAll(doEasterEggTune, doEasterEggMovement); 
end

function start()
    createStartupFile();

    if (not readArguments()) then
        return false;
    end

    if (status == Status.Starting) then
        dumpInventoryInStorage();
        restockFuelFromStorage();
        refuel(2);
    elseif (status == Status.PitStop) then
        pitStop(true);
    elseif (status == Status.Returning) then
        returnToWork();
    elseif (status == Status.Parking) then
        parkTurtle();
    elseif (status == Status.Stopped) then
        print("Cannot resume, turtle has finished its work.");
        return false;
    elseif (status == Status.Egg) then
        doEasterEgg();
        return false;
    end
    return true;
end

function getBoundsVolume()
    return bounds.x * bounds.y * bounds.z;
end

function dig()
    setStatus(Status.Working);

    local x = localPosition.x;
    local y = localPosition.y;
    local z = localPosition.z;
    local maxX = bounds.x - 1;
    local maxY = bounds.y - 1;
    local maxZ = bounds.z - 1;

    local zEven = isEven(z);
    local yEven = isEven(y);
    local xEven = isEven(x);

    if (yEven) then
        if (zEven) then
            if (x < maxX) then
                x = x + 1;
            else
                if (z < maxZ) then
                    z = z + 1;
                else
                    if (y < maxY) then
                        y = y + 1;
                    else
                        return true;
                    end
                end
            end
        else
            if (x > 0) then
                x = x - 1;
            else
                if (z < maxZ) then
                    z = z + 1;
                else
                    if (y < maxY) then
                        y = y + 1;
                    else
                        return true;
                    end
                end
            end
        end
    else
        if (zEven) then
            if (x > 0) then
                x = x - 1;
            else
                if (z > 0) then
                    z = z - 1;
                else
                    if (y < maxY) then
                        y = y + 1;
                    else
                        return true;
                    end
                end
            end
        else
            if (x < maxX) then
                x = x + 1;
            else
                if (z > 0) then
                    z = z - 1;
                else
                    if (y < maxY) then
                        y = y + 1;
                    else
                        return true;
                    end
                end
            end
        end
    end
    newPos = vector.new(x, y, z);

    moveToCoordinates(newPos);
    setDugBlocks(dugBlocks + 1);
    filterInventory();

    local digProgress = (1 / getBoundsVolume() * dugBlocks) * 100;
    print("Dig Progress:", tostring(roundNumber(digProgress, 2)) .. "%");
    return false;
end

function loop()
    return dig();
end

function exit()
    parkTurtle();
end

function init()
    if (start()) then
        while (not loop()) do end;
    end
    exit();
end

init();
