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

function Moniker_OnLoad(frame)
    frame:RegisterEvent("VARIABLES_LOADED")

    SlashCmdList["MONIKER"] = Moniker_Commands
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

        DEFAULT_CHAT_FRAME:AddMessage(string.format("Moniker %s loaded",Moniker_Version), 0.4, 0.4, 1.0)
    end
end

function Moniker_InitializeMonikerSettings()
    MonikerSettings = {}
    MonikerSettings.version = "0.1"
    MonikerSettings.enabled = true
    MonikerSettings.format = "[%s]"
    MonikerSettings.monikers = {}
    MonikerSettings.monikers.main = ""
    MonikerSettings.channels = {}
    MonikerSettings.channels.whisper = true
    MonikerSettings.channels.party = true
    MonikerSettings.channels.guild = false
    MonikerSettings.channels.officer = false
    MonikerSettings.channels.raid = false
    MonikerSettings.channels.battleground = false
    MonikerSettings.channels.channel01 = false
    MonikerSettings.channels.channel02 = false
    MonikerSettings.channels.channel03 = false
    MonikerSettings.channels.channel04 = false
    MonikerSettings.channels.channel05 = false
    MonikerSettings.channels.channel06 = false
    MonikerSettings.channels.channel07 = false
    MonikerSettings.channels.channel08 = false
    MonikerSettings.channels.channel09 = false
    MonikerSettings.channels.channel10 = false
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
    local prefix = string.format(MonikerSettings.format, MonikerSettings.monikers.main)
    return prefix .. " " .. msg
end

function Moniker_ChannelIsEnabled(system, channel)
    if system == Moniker_ChannelDefinitions.whisper then
        return MonikerSettings.channels.whisper
    elseif system == Moniker_ChannelDefinitions.party then
        return MonikerSettings.channels.party
    elseif system == Moniker_ChannelDefinitions.guild then
        return MonikerSettings.channels.guild
    elseif system == Moniker_ChannelDefinitions.officer then
        return MonikerSettings.channels.officer
    elseif system == Moniker_ChannelDefinitions.battleground then
        return MonikerSettings.channels.battleground
    elseif system == "CHANNEL" then
        if channel == Moniker_ChannelDefinitions.channel01 then
            return MonikerSettings.channels.channel01
        elseif channel == Moniker_ChannelDefinitions.channel02 then
            return MonikerSettings.channels.channel02
        elseif channel == Moniker_ChannelDefinitions.channel03 then
            return MonikerSettings.channels.channel03
        elseif channel == Moniker_ChannelDefinitions.channel04 then
            return MonikerSettings.channels.channel04
        elseif channel == Moniker_ChannelDefinitions.channel05 then
            return MonikerSettings.channels.channel05
        elseif channel == Moniker_ChannelDefinitions.channel06 then
            return MonikerSettings.channels.channel06
        elseif channel == Moniker_ChannelDefinitions.channel07 then
            return MonikerSettings.channels.channel07
        elseif channel == Moniker_ChannelDefinitions.channel08 then
            return MonikerSettings.channels.channel08
        elseif channel == Moniker_ChannelDefinitions.channel09 then
            return MonikerSettings.channels.channel09
        elseif channel == Moniker_ChannelDefinitions.channel10 then
            return MonikerSettings.channels.channel10
        end
    end
    
    return false
end

function Moniker_Commands(msg)
    local command, parameters = Moniker_ParseCommand(msg)

    if command == "on" then
        Moniker_Enable(true)
    elseif command == "off" then
        Moniker_Enable(false)
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
        DEFAULT_CHAT_FRAME:AddMessage("Moniker enabled")
    else
        DEFAULT_CHAT_FRAME:AddMessage("Moniker disabled")
    end

    MonikerSettings.enabled = enable
end
