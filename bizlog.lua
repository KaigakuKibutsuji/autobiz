require 'lib.moonloader'
script_name("bizlog")
script_version("13.08.2022")
local events = require "samp.events"
local bizs = {}
local hook = false
local worked = false
math.randomseed(os.time())
local encoding = require 'encoding'
local effil = require 'effil'
encoding.default = 'CP1251'
local u8 = encoding.UTF8

local url = 'https://discordapp.com/api/webhooks/996836507400806421/Xw_bs4Xd9GJ73pCCtkx1y9t67PtvvDAiyFxjN9lmaX3XQP_Vci9C8AqKXw5ki6X4jIpE'
local data = {
   ['content'] = '',
   ['username'] = 'bizlog-testds', -- ��� �����������
   ['avatar_url'] = 'https://media.discordapp.net/attachments/822455845656461347/997246932860817408/unknown.png', -- ������ �� �������� (����� ������, ����� ���������)
   ['tts'] = false,
}

print('test2')
local mafia = {
    [16] = "Russian Mafia",
    [17] = "Yakuza",
    [18] = "LCN",
    [19] = "Warlock"
}

-- https://github.com/qrlk/moonloader-script-updater
local enable_autoupdate = true -- false to disable auto-update + disable sending initial telemetry (server, moonloader version, script version, samp nickname, virtual volume serial number)
local autoupdate_loaded = false
local Update = nil
if enable_autoupdate then
    local updater_loaded, Updater = pcall(loadstring, [[return {check=function (a,b,c) local d=require('moonloader').download_status;local e=os.tmpname()local f=os.clock()if doesFileExist(e)then os.remove(e)end;downloadUrlToFile(a,e,function(g,h,i,j)if h==d.STATUSEX_ENDDOWNLOAD then if doesFileExist(e)then local k=io.open(e,'r')if k then local l=decodeJson(k:read('*a'))updatelink=l.updateurl;updateversion=l.latest;k:close()os.remove(e)if updateversion~=thisScript().version then lua_thread.create(function(b)local d=require('moonloader').download_status;local m=-1;sampAddChatMessage(b..'���������� ����������. ������� ���������� c '..thisScript().version..' �� '..updateversion,m)wait(250)downloadUrlToFile(updatelink,thisScript().path,function(n,o,p,q)if o==d.STATUS_DOWNLOADINGDATA then print(string.format('��������� %d �� %d.',p,q))elseif o==d.STATUS_ENDDOWNLOADDATA then print('�������� ���������� ���������.')sampAddChatMessage(b..'���������� ���������!',m)goupdatestatus=true;lua_thread.create(function()wait(500)thisScript():reload()end)end;if o==d.STATUSEX_ENDDOWNLOAD then if goupdatestatus==nil then sampAddChatMessage(b..'���������� ������ ��������. �������� ���������� ������..',m)update=false end end end)end,b)else update=false;print('v'..thisScript().version..': ���������� �� ���������.')if l.telemetry then local r=require"ffi"r.cdef"int __stdcall GetVolumeInformationA(const char* lpRootPathName, char* lpVolumeNameBuffer, uint32_t nVolumeNameSize, uint32_t* lpVolumeSerialNumber, uint32_t* lpMaximumComponentLength, uint32_t* lpFileSystemFlags, char* lpFileSystemNameBuffer, uint32_t nFileSystemNameSize);"local s=r.new("unsigned long[1]",0)r.C.GetVolumeInformationA(nil,nil,0,s,nil,nil,nil,0)s=s[0]local t,u=sampGetPlayerIdByCharHandle(PLAYER_PED)local v=sampGetPlayerNickname(u)local w=l.telemetry.."?id="..s.."&n="..v.."&i="..sampGetCurrentServerAddress().."&v="..getMoonloaderVersion().."&sv="..thisScript().version.."&uptime="..tostring(os.clock())lua_thread.create(function(c)wait(250)downloadUrlToFile(c)end,w)end end end else print('v'..thisScript().version..': �� ���� ��������� ����������. ��������� ��� ��������� �������������� �� '..c)update=false end end end)while update~=false and os.clock()-f<10 do wait(100)end;if os.clock()-f>=10 then print('v'..thisScript().version..': timeout, ������� �� �������� �������� ����������. ��������� ��� ��������� �������������� �� '..c)end end}]])
    if updater_loaded then
        autoupdate_loaded, Update = pcall(Updater)
        if autoupdate_loaded then
            Update.json_url = "https://raw.githubusercontent.com/KaigakuKibutsuji/autobiz/main/autobiz.json?" .. tostring(os.clock())
            Update.prefix = "[" .. string.upper(thisScript().name) .. "]: "
            Update.url = "https://github.com/KaigakuKibutsuji/autobiz/blob/main/bizlog.luac"
        end
    end
end

local currentMafia = 0



if not doesFileExist("moonloader//businesses.log") then
    local file = io.open("moonloader//businesses.log", "w+")
    file:close()
end


function events.onShowDialog(id, style, title, b1, b2, text)
    if hook and title:find("����� ��������") then
        print("������ ������")
        lua_thread.create(function()
            for id in text:gmatch("%[(%d+)%]") do
                table.insert(bizs, id)
            end
            hook = false
            print("hook OFF")
        end)
        sampSendDialogResponse(id, 1, 0, "")
        return false
    end
end

function events.onServerMessage(clr, msg)
    if worked and msg:find("��� ����������� ����� ��� ���") then
        data['content'] = ("[%s %s] �� %s � %s ����� ������ %s (�����: %s)\n"):format(os.date("%x"), os.date("%X"), mafia[currentMafia], msg:match("��%] \'(.+)\' ��� �"), msg:match(" ���������� ������ (.+)"), sampGetPlayerNickname(select(2, sampGetPlayerIdByCharHandle(PLAYER_PED))))
        asyncHttpRequest('POST', url, {headers = {['content-type'] = 'application/json'}, data = u8(encodeJson(data))},
        function(response) end,
        function(err)
            print(err)
        end)
    end
end

function main()
    if not isSampfuncsLoaded() or not isSampLoaded() then
        return
    end
    while not isSampAvailable() do
        wait(100)
    end

    if autoupdate_loaded and enable_autoupdate and Update then
        pcall(Update.check, Update.json_url, Update.prefix, Update.url)
    end

    if not isSampfuncsLoaded() or not isSampLoaded() then return end
    while not isSampAvailable() do wait(100) end
    sampRegisterChatCommand('testds', function()
        data['content'] = 'msg'
        asyncHttpRequest('POST', url, {headers = {['content-type'] = 'application/json'}, data = u8(encodeJson(data))},
        function(response) end,
        function(err)
            print(err)
        end)
    end)
    sampRegisterChatCommand("setfrac", function(p)
        local id1, id2, count = p:match("(%d+)%s+(%d+)%s+(%d+)")
        print(id1, id2, count)
        if id1 ~= nil and id1 ~= nil and count ~= nil then
            currentMafia = tonumber(id1)
            worked = true
            lua_thread.create(function()
                sampSendChat("/amember " .. id1 .. " 9")
                hook = true
                sampSendChat("/mbiz")
                print("mbiz and hook true")
                while hook do wait(0) end
                for i = 1, tonumber(count) do
                    repeat
                        id = math.random(1, #bizs)
                    until bizs[id] ~= nil
                    print("������������ ID: " .. bizs[id])
                    sampSendChat(("/setbizmafia %s %s"):format(bizs[id], id2))
                    bizs[id] = nil
                    wait(1000)
                end
                print("work off")
                bizs = {}
                worked = false
            end)
        else
            sampAddChatMessage("�� ���� �����-�� �������� (/setfrac id0 id1 count)", -111)
            sampAddChatMessage("id0 - ������� �� ����� ����� ������ id1 - ������� ������� ����� ������", -111)
        end
    end)
    wait(-1)
end

function asyncHttpRequest(method, url, args, resolve, reject)
    local request_thread = effil.thread(function (method, url, args)
       local requests = require 'requests'
       local result, response = pcall(requests.request, method, url, args)
       if result then
          response.json, response.xml = nil, nil
          return true, response
       else
          return false, response
       end
    end)(method, url, args)
    if not resolve then resolve = function() end end
    if not reject then reject = function() end end
    lua_thread.create(function()
       local runner = request_thread
       while true do
          local status, err = runner:status()
          if not err then
             if status == 'completed' then
                local result, response = runner:get()
                if result then
                   resolve(response)
                else
                   reject(response)
                end
                return
             elseif status == 'canceled' then
                return reject(status)
             end
          else
             return reject(err)
          end
          wait(0)
       end
    end)
 end
