-- Moniker.lua

function Moniker_InitializeChannelDefinitions()
    local channels = {}
    channels.whisper = "WHISPER"
    channels.party = "PARTY"
    channels.guild = "GUILD"
    channels.officer = "OFFICER"
    channels.raid = "RAID"
    channels.battleground = "BATTLEGROUND"
    channels.channel01 = "01"
    channels.channel02 = "02"
    channels.channel03 = "03"
    channels.channel04 = "04"
    channels.channel05 = "05"
    channels.channel06 = "06"
    channels.channel07 = "07"
    channels.channel08 = "08"
    channels.channel09 = "09"
    channels.channel10 = "10"
    return channels
end

local Moniker_Version = "0.1"
local Moniker_SystemSendChatMessage
local Moniker_ChannelDefinitions = Moniker_InitializeChannelDefinitions()
local Moniker_CharacterName
local Moniker_CharacterFaction
local Moniker_LocalizedCharacterFaction
local Moniker_CurrentRealm
local Moniker_RealmFactionKey

function Moniker_OnLoad(frame)
    frame:RegisterEvent("VARIABLES_LOADED")
    frame:RegisterEvent("PLAYER_ENTERING_WORLD")

    SlashCmdList["MONIKER"] = Moniker_Controller
    SLASH_MONIKER1 = "/moniker"
    SLASH_MONIKER2 = "/mnk"
end

function Moniker_OnEvent(frame, event)
    if (event == "VARIABLES_LOADED") then
        if (not MonikerSettings) then
            Moniker_InitializeMonikerSettings()
        end

        Moniker_SystemSendChatMessage = SendChatMessage
        SendChatMessage = Moniker_DecorateSendChatMessage

        DEFAULT_CHAT_FRAME:AddMessage(string.format(MONIKER_VERSION_LOADED, Moniker_Version), 0.4, 0.4, 1.0)
    end

    if (event == "PLAYER_ENTERING_WORLD") then
        Moniker_CurrentRealm = Moniker_GetCurrentRealm()
        Moniker_CharacterFaction = Moniker_GetCurrentFaction()
        Moniker_CharacterName = Moniker_GetCurrentCharacterName()
        Moniker_RealmFactionKey = string.format("%s %s", Moniker_CurrentRealm, Moniker_CharacterFaction)

        if (not MonikerSettings.realms[Moniker_RealmFactionKey]) then
            MonikerSettings.realms[Moniker_RealmFactionKey] = Moniker_RealmSettingsFactory()
        end
    end
end

function Moniker_InitializeMonikerSettings()
    MonikerSettings = {}
    MonikerSettings.version = "0.1"
    MonikerSettings.enabled = true
    MonikerSettings.format = "(%s)"
    MonikerSettings.realms = {}
end

function Moniker_RealmSettingsFactory()
    local realmSettings = {}
    realmSettings.monikers = {}
    realmSettings.monikers.main = ""
    realmSettings.channels = {}
    realmSettings.channels.whisper = false
    realmSettings.channels.party = false
    realmSettings.channels.guild = false
    realmSettings.channels.officer = false
    realmSettings.channels.raid = false
    realmSettings.channels.battleground = false
    realmSettings.channels.channel01 = false
    realmSettings.channels.channel02 = false
    realmSettings.channels.channel03 = false
    realmSettings.channels.channel04 = false
    realmSettings.channels.channel05 = false
    realmSettings.channels.channel06 = false
    realmSettings.channels.channel07 = false
    realmSettings.channels.channel08 = false
    realmSettings.channels.channel09 = false
    realmSettings.channels.channel10 = false
    return realmSettings
end

function Moniker_DecorateSendChatMessage(msg, system, language, channel)
    if MonikerSettings.enabled then
        if Moniker_ChannelIsEnabled(system, channel) then
            msg = Moniker_AddPrefix(msg)
        end
    end
    Moniker_SystemSendChatMessage(msg, system, language, channel)
end

function Moniker_AddPrefix(msg)
    if MonikerSettings.realms[Moniker_RealmFactionKey].monikers.main == Moniker_CharacterName then
        return msg
    elseif MonikerSettings.realms[Moniker_RealmFactionKey].monikers.main == "" then
        DEFAULT_CHAT_FRAME:AddMessage(MONIKER_ENABLED_MAIN_BLANK, 0.4, 0.4, 1.0)
        return msg
    else
        local prefix = string.format(MonikerSettings.format, MonikerSettings.realms[Moniker_RealmFactionKey].monikers.main)
        return string.format("%s %s", prefix, msg)
    end
end

function Moniker_ChannelIsEnabled(system, channel)
    if system == Moniker_ChannelDefinitions.whisper then
        return MonikerSettings.realms[Moniker_RealmFactionKey].channels.whisper
    elseif system == Moniker_ChannelDefinitions.party then
        return MonikerSettings.realms[Moniker_RealmFactionKey].channels.party
    elseif system == Moniker_ChannelDefinitions.guild then
        return MonikerSettings.realms[Moniker_RealmFactionKey].channels.guild
    elseif system == Moniker_ChannelDefinitions.officer then
        return MonikerSettings.realms[Moniker_RealmFactionKey].channels.officer
    elseif system == Moniker_ChannelDefinitions.battleground then
        return MonikerSettings.realms[Moniker_RealmFactionKey].channels.battleground
    elseif system == "CHANNEL" then
        if channel == Moniker_ChannelDefinitions.channel01 then
            return MonikerSettings.realms[Moniker_RealmFactionKey].channels.channel01
        elseif channel == Moniker_ChannelDefinitions.channel02 then
            return MonikerSettings.realms[Moniker_RealmFactionKey].channels.channel02
        elseif channel == Moniker_ChannelDefinitions.channel03 then
            return MonikerSettings.realms[Moniker_RealmFactionKey].channels.channel03
        elseif channel == Moniker_ChannelDefinitions.channel04 then
            return MonikerSettings.realms[Moniker_RealmFactionKey].channels.channel04
        elseif channel == Moniker_ChannelDefinitions.channel05 then
            return MonikerSettings.realms[Moniker_RealmFactionKey].channels.channel05
        elseif channel == Moniker_ChannelDefinitions.channel06 then
            return MonikerSettings.realms[Moniker_RealmFactionKey].channels.channel06
        elseif channel == Moniker_ChannelDefinitions.channel07 then
            return MonikerSettings.realms[Moniker_RealmFactionKey].channels.channel07
        elseif channel == Moniker_ChannelDefinitions.channel08 then
            return MonikerSettings.realms[Moniker_RealmFactionKey].channels.channel08
        elseif channel == Moniker_ChannelDefinitions.channel09 then
            return MonikerSettings.realms[Moniker_RealmFactionKey].channels.channel09
        elseif channel == Moniker_ChannelDefinitions.channel10 then
            return MonikerSettings.realms[Moniker_RealmFactionKey].channels.channel10
        end
    end
    
    return false
end

function Moniker_Controller(msg)
    local command, parameters = Moniker_ParseCommand(msg)

    if command == "on" then
        Moniker_Enable(true)
    elseif command == "off" then
        Moniker_Enable(false)
    elseif command == "main" then
        Moniker_SetMain(parameters)
    elseif command == "guild" then
        Moniker_ToggleGuildChannel()
    elseif command == "whisper" then
        Moniker_ToggleWhisperChannel()
    elseif command == "reset" then
        Moniker_ResetDefaults()
    else
        Moniker_CommandNotRecognized(command)
    end
end

function Moniker_ParseCommand(msg)
    if msg then
        local s, e, command = string.find(msg, "(%S+)")
        if s then
            return command, string.sub(msg, e + 2)
        else
            return ""
        end
    end
end

function Moniker_Enable(enable)
    if enable then
        DEFAULT_CHAT_FRAME:AddMessage(MONIKER_ENABLED, 0.4, 0.4, 1.0)
    else
        DEFAULT_CHAT_FRAME:AddMessage(MONIKER_DISABLED, 0.4, 0.4, 1.0)
    end

    MonikerSettings.enabled = enable
end

function Moniker_SetMain(name)
    local oldName = MonikerSettings.realms[Moniker_RealmFactionKey].monikers.main
    MonikerSettings.realms[Moniker_RealmFactionKey].monikers.main = name
    DEFAULT_CHAT_FRAME:AddMessage(string.format(MONIKER_MAIN_SET_VALUE, oldName, name), 0.4, 0.4, 1.0)
end

function Moniker_ToggleGuildChannel()
    if MonikerSettings.realms[Moniker_RealmFactionKey].channels.guild == true then
        MonikerSettings.realms[Moniker_RealmFactionKey].channels.guild = false
        DEFAULT_CHAT_FRAME:AddMessage(MONIKER_DISABLED_FOR_GUILD, 0.4, 0.4, 1.0)
    else
        MonikerSettings.realms[Moniker_RealmFactionKey].channels.guild = true
        DEFAULT_CHAT_FRAME:AddMessage(MONIKER_ENABLED_FOR_GUILD, 0.4, 0.4, 1.0)
    end
end

function Moniker_ToggleWhisperChannel()
    if MonikerSettings.realms[Moniker_RealmFactionKey].channels.whisper == true then
        MonikerSettings.realms[Moniker_RealmFactionKey].channels.whisper = false
        DEFAULT_CHAT_FRAME:AddMessage(MONIKER_DISABLED_FOR_WHISPER, 0.4, 0.4, 1.0)
    else
        MonikerSettings.realms[Moniker_RealmFactionKey].channels.whisper = true
        DEFAULT_CHAT_FRAME:AddMessage(MONIKER_ENABLED_FOR_WHISPER, 0.4, 0.4, 1.0)
    end
end

function Moniker_ResetDefaults()
    Moniker_InitializeMonikerSettings()
    DEFAULT_CHAT_FRAME:AddMessage(MONIKER_RESET_TO_DEFAULT, 0.4, 0.4, 1.0)
end

function Moniker_GetCurrentCharacterName()
    return UnitName("player")
end

function Moniker_GetCurrentFaction()
    return UnitFactionGroup("player")
end

function Moniker_GetCurrentRealm()
    return GetRealmName()
end

function Moniker_CommandNotRecognized(command)
    DEFAULT_CHAT_FRAME:AddMessage(string.format(MONIKER_COMMAND_NOT_RECOGNIZED,command), 0.4, 0.4, 1.0)
end
