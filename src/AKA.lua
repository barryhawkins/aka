-- AKA.lua

function AKA_InitializeChannelDefinitions()
    local channels = {}
    channels.whisper = "WHISPER"
    channels.party = "PARTY"
    channels.guild = "GUILD"
    channels.officer = "OFFICER"
    channels.raid = "RAID"
    channels.battleground = "BATTLEGROUND"
    channels.channel01 = 1
    channels.channel02 = 2
    channels.channel03 = 3
    channels.channel04 = 4
    channels.channel05 = 5
    channels.channel06 = 6
    channels.channel07 = 7
    channels.channel08 = 8
    channels.channel09 = 9
    channels.channel10 = 10
    return channels
end

local AKA_Version = "0.7.2"
local AKA_SystemSendChatMessage
local AKA_ChannelDefinitions = AKA_InitializeChannelDefinitions()
local AKA_CharacterName
local AKA_CharacterFaction
local AKA_LocalizedCharacterFaction
local AKA_CurrentRealm
local AKA_RealmFactionKey

function AKA_OnLoad(frame)
    frame:RegisterEvent("VARIABLES_LOADED")
    frame:RegisterEvent("PLAYER_ENTERING_WORLD")

    SlashCmdList["AKA"] = AKA_Controller
    SLASH_AKA1 = "/aka"
end

function AKA_OnEvent(frame, event)
    if (event == "VARIABLES_LOADED") then
        if (not AKASettings) then
            AKA_InitializeAKASettings()
        end

        AKA_SystemSendChatMessage = SendChatMessage
        SendChatMessage = AKA_DecorateSendChatMessage

        DEFAULT_CHAT_FRAME:AddMessage(string.format(AKA_VERSION_LOADED, AKA_Version, AKA_TrueFalseAsOnOff(AKASettings.enabled)), 0.4, 0.4, 1.0)
    end

    if (event == "PLAYER_ENTERING_WORLD") then
        AKA_CurrentRealm = AKA_GetCurrentRealm()
        AKA_CharacterFaction = AKA_GetCurrentFaction()
        AKA_CharacterName = AKA_GetCurrentCharacterName()
        AKA_RealmFactionKey = string.format("%s %s", AKA_CurrentRealm, AKA_CharacterFaction)

        if (not AKASettings.realms[AKA_RealmFactionKey]) then
            AKASettings.realms[AKA_RealmFactionKey] = AKA_RealmSettingsFactory()
        end
    end
end

function AKA_InitializeAKASettings()
    AKASettings = {}
    AKASettings.version = AKA_Version
    AKASettings.enabled = true
    AKASettings.format = "(%s)"
    AKASettings.realms = {}
end

function AKA_RealmSettingsFactory()
    local realmSettings = {}
    realmSettings.aliases = {}
    realmSettings.aliases.main = ""
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

function AKA_DecorateSendChatMessage(msg, system, language, channel)
    if AKASettings.enabled then
        if AKA_ChannelIsEnabled(system, channel) then
            msg = AKA_AddPrefix(msg)
        end
    end
    AKA_SystemSendChatMessage(msg, system, language, channel)
end

function AKA_AddPrefix(msg)
    if AKASettings.realms[AKA_RealmFactionKey].aliases.main == AKA_CharacterName then
        return string.format("(%s) %s", AKA_DICT_MAIN, msg)
    elseif AKASettings.realms[AKA_RealmFactionKey].aliases.main == "" then
        DEFAULT_CHAT_FRAME:AddMessage(AKA_ENABLED_MAIN_BLANK, 0.4, 0.4, 1.0)
        return msg
    else
        local prefix = string.format(AKASettings.format, AKASettings.realms[AKA_RealmFactionKey].aliases.main)
        return string.format("%s %s", prefix, msg)
    end
end

function AKA_ChannelIsEnabled(system, channel)
    if system == AKA_ChannelDefinitions.whisper then
        return AKASettings.realms[AKA_RealmFactionKey].channels.whisper
    elseif system == AKA_ChannelDefinitions.party then
        return AKASettings.realms[AKA_RealmFactionKey].channels.party
    elseif system == AKA_ChannelDefinitions.guild then
        return AKASettings.realms[AKA_RealmFactionKey].channels.guild
    elseif system == AKA_ChannelDefinitions.officer then
        return AKASettings.realms[AKA_RealmFactionKey].channels.officer
    elseif system == AKA_ChannelDefinitions.battleground then
        return AKASettings.realms[AKA_RealmFactionKey].channels.battleground
    elseif system == "CHANNEL" then
        if channel == AKA_ChannelDefinitions.channel01 then
            return AKASettings.realms[AKA_RealmFactionKey].channels.channel01
        elseif channel == AKA_ChannelDefinitions.channel02 then
            return AKASettings.realms[AKA_RealmFactionKey].channels.channel02
        elseif channel == AKA_ChannelDefinitions.channel03 then
            return AKASettings.realms[AKA_RealmFactionKey].channels.channel03
        elseif channel == AKA_ChannelDefinitions.channel04 then
            return AKASettings.realms[AKA_RealmFactionKey].channels.channel04
        elseif channel == AKA_ChannelDefinitions.channel05 then
            return AKASettings.realms[AKA_RealmFactionKey].channels.channel05
        elseif channel == AKA_ChannelDefinitions.channel06 then
            return AKASettings.realms[AKA_RealmFactionKey].channels.channel06
        elseif channel == AKA_ChannelDefinitions.channel07 then
            return AKASettings.realms[AKA_RealmFactionKey].channels.channel07
        elseif channel == AKA_ChannelDefinitions.channel08 then
            return AKASettings.realms[AKA_RealmFactionKey].channels.channel08
        elseif channel == AKA_ChannelDefinitions.channel09 then
            return AKASettings.realms[AKA_RealmFactionKey].channels.channel09
        elseif channel == AKA_ChannelDefinitions.channel10 then
            return AKASettings.realms[AKA_RealmFactionKey].channels.channel10
        end
    end
    
    return false
end

function AKA_Controller(msg)
    local command, parameters = AKA_ParseCommand(msg)

    if command == "on" then
        AKA_Enable(true)
    elseif command == "off" then
        AKA_Enable(false)
    elseif command == "" then
        AKA_DisplayHelp()
    elseif command == "help" then
        AKA_DisplayHelp()
    elseif command == "conf" then
        AKA_DisplayConfiguration()
    elseif command == "main" then
        AKA_SetMain(parameters)
    elseif command == "guild" then
        AKA_ToggleGuildChannel()
    elseif command == "whisper" then
        AKA_ToggleWhisperChannel()
    elseif (tonumber(command) and ((tonumber(command) >= 1) and (tonumber(command) <=10))) then
        AKA_ToggleNumericChannel(command)
    elseif command == "reset" then
        AKA_ResetDefaults()
    else
        AKA_CommandNotRecognized(command)
    end
end

function AKA_ParseCommand(msg)
    if msg then
        local s, e, command = string.find(msg, "(%S+)")
        if s then
            return command, string.sub(msg, e + 2)
        else
            return ""
        end
    end
end

function AKA_Enable(enable)
    if enable then
        DEFAULT_CHAT_FRAME:AddMessage(AKA_ENABLED, 0.4, 0.4, 1.0)
    else
        DEFAULT_CHAT_FRAME:AddMessage(AKA_DISABLED, 0.4, 0.4, 1.0)
    end

    AKASettings.enabled = enable
end

function AKA_SetMain(name)
    local oldName = AKASettings.realms[AKA_RealmFactionKey].aliases.main
    AKASettings.realms[AKA_RealmFactionKey].aliases.main = name
    DEFAULT_CHAT_FRAME:AddMessage(string.format(AKA_MAIN_SET_VALUE, oldName, name), 0.4, 0.4, 1.0)
end

function AKA_ToggleGuildChannel()
    if AKASettings.realms[AKA_RealmFactionKey].channels.guild == true then
        AKASettings.realms[AKA_RealmFactionKey].channels.guild = false
        DEFAULT_CHAT_FRAME:AddMessage(AKA_DISABLED_FOR_GUILD, 0.4, 0.4, 1.0)
    else
        AKASettings.realms[AKA_RealmFactionKey].channels.guild = true
        DEFAULT_CHAT_FRAME:AddMessage(AKA_ENABLED_FOR_GUILD, 0.4, 0.4, 1.0)
    end
end

function AKA_ToggleWhisperChannel()
    if AKASettings.realms[AKA_RealmFactionKey].channels.whisper == true then
        AKASettings.realms[AKA_RealmFactionKey].channels.whisper = false
        DEFAULT_CHAT_FRAME:AddMessage(AKA_DISABLED_FOR_WHISPER, 0.4, 0.4, 1.0)
    else
        AKASettings.realms[AKA_RealmFactionKey].channels.whisper = true
        DEFAULT_CHAT_FRAME:AddMessage(AKA_ENABLED_FOR_WHISPER, 0.4, 0.4, 1.0)
    end
end

function AKA_ToggleNumericChannel(channel)
    local channel_name = AKA_FormatNumericChannelName(channel)

    if AKASettings.realms[AKA_RealmFactionKey].channels[channel_name] == true then
        AKASettings.realms[AKA_RealmFactionKey].channels[channel_name] = false
        DEFAULT_CHAT_FRAME:AddMessage(string.format(AKA_DISABLED_FOR_CHANNEL, channel), 0.4, 0.4, 1.0)
    else
        AKASettings.realms[AKA_RealmFactionKey].channels[channel_name] = true
        DEFAULT_CHAT_FRAME:AddMessage(string.format(AKA_ENABLED_FOR_CHANNEL, channel), 0.4, 0.4, 1.0)
    end
end

function AKA_ResetDefaults()
    AKA_InitializeAKASettings()
    AKASettings.realms[AKA_RealmFactionKey] = AKA_RealmSettingsFactory()
    DEFAULT_CHAT_FRAME:AddMessage(AKA_RESET_TO_DEFAULT, 0.4, 0.4, 1.0)
end

function AKA_DisplayHelp()
    DEFAULT_CHAT_FRAME:AddMessage(AKA_HELP_PREAMBLE, 0.4, 0.4, 1.0)
    DEFAULT_CHAT_FRAME:AddMessage(AKA_HELP_NOARG, 0.4, 0.4, 1.0)
    DEFAULT_CHAT_FRAME:AddMessage(AKA_HELP_HELP, 0.4, 0.4, 1.0)
    DEFAULT_CHAT_FRAME:AddMessage(AKA_HELP_GUILD, 0.4, 0.4, 1.0)
    DEFAULT_CHAT_FRAME:AddMessage(AKA_HELP_WHISPER, 0.4, 0.4, 1.0)
    DEFAULT_CHAT_FRAME:AddMessage(AKA_HELP_CHANNEL, 0.4, 0.4, 1.0)
    DEFAULT_CHAT_FRAME:AddMessage(AKA_HELP_MAIN, 0.4, 0.4, 1.0)
    DEFAULT_CHAT_FRAME:AddMessage(AKA_HELP_CONF, 0.4, 0.4, 1.0)
    DEFAULT_CHAT_FRAME:AddMessage(AKA_HELP_ON, 0.4, 0.4, 1.0)
    DEFAULT_CHAT_FRAME:AddMessage(AKA_HELP_OFF, 0.4, 0.4, 1.0)
    DEFAULT_CHAT_FRAME:AddMessage(AKA_HELP_RESET, 0.4, 0.4, 1.0)
end

function AKA_DisplayConfiguration()
    local config = {}
    current_realm = AKASettings.realms[AKA_RealmFactionKey]

    config[#config + 1] = string.format(AKA_CONF_REALM_PREAMBLE, AKA_CurrentRealm, AKA_CharacterFaction)
    config[#config + 1] = string.format(AKA_CONF_LABEL_MAIN, current_realm.aliases.main)
    config[#config + 1] = string.format(AKA_CONF_LABEL_GUILD, AKA_TrueFalseAsOnOff(current_realm.channels.guild))
    config[#config + 1] = string.format(AKA_CONF_LABEL_PARTY, AKA_TrueFalseAsOnOff(current_realm.channels.party))
    config[#config + 1] = string.format(AKA_CONF_LABEL_WHISPER, AKA_TrueFalseAsOnOff(current_realm.channels.whisper))
    for i = 1, 10 do
        local channel_number = tostring(i)
        local channel_name = AKA_FormatNumericChannelName(tostring(i))
        config[#config + 1] = string.format(AKA_CONF_LABEL_CHANNEL, channel_number, AKA_TrueFalseAsOnOff(current_realm.channels[channel_name]))
    end
    config[#config + 1] = AKA_CONF_GLOBAL_PREAMBLE
    config[#config + 1] = string.format(AKA_CONF_LABEL_ENABLED, AKA_TrueFalseAsOnOff(AKASettings.enabled))

    DEFAULT_CHAT_FRAME:AddMessage(table.concat(config), 0.4, 0.4, 1.0)
end

function AKA_GetCurrentCharacterName()
    return UnitName("player")
end

function AKA_GetCurrentFaction()
    return UnitFactionGroup("player")
end

function AKA_GetCurrentRealm()
    return GetRealmName()
end

function AKA_CommandNotRecognized(command)
    DEFAULT_CHAT_FRAME:AddMessage(string.format(AKA_COMMAND_NOT_RECOGNIZED,command), 0.4, 0.4, 1.0)
end

function AKA_FormatNumericChannelName(channel)
    if #channel == 1 then
        return string.format("channel0%s", channel)
    else
        return string.format("channel%s", channel)
    end
end

function AKA_TrueFalseAsOnOff(value)
    if value == true then
        return "on"
    else
        return "off"
    end
end
