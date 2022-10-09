--[[ =========================== Внутренние функции =========================== ]]--

function find_player_by_name(player_name)
  local player = game.players[player_name]
  if player == nil then
    local players = game.players
    for _,v in pairs(players) do
      local name = string.lower(v.name)
      if string.find(name, player_name) ~= nil then
        player = v
        break
      end
    end
  end
  return player
end


function split(inputstr, sep)
  if sep == nil then
          sep = "%s"
  end
  local t={}
  for str in string.gmatch(inputstr, "([^"..sep.."]+)") do
          table.insert(t, str)
  end
  return t
end



--[[ =========================== Ограничение эволюции =========================== ]]--

function limit_evolution()
  local max_factor = settings.global["abro-tweaks-maxfactor"].value
  local factor = game.forces["enemy"].evolution_factor
  if (factor >= max_factor) then
      game.forces["enemy"].evolution_factor = max_factor
  end
end

script.on_event(defines.events.on_tick, limit_evolution)



--[[ =========================== Команд телепортации =========================== ]]--

function tp_handler(command)
  if command.player_index ~= nil and command.parameter ~= nil then
    local sender = game.get_player(command.player_index)
    local player1 = nil
    local player2 = nil
    local player1_search_string = nil
    local player2_search_string = nil
    if sender.admin then

      if command.name == "goto" then
        player1 = sender
        player2_search_string = command.parameter
        player2 = find_player_by_name(command.parameter)

      elseif command.name == "call" then
        player1 = find_player_by_name(command.parameter)
        player1_search_string = command.parameter
        player2 = sender

      elseif command.name == "tp" then
        local args = split(command.parameter, " ")
        player1_search_string = args[1]
        player2_search_string = args[2]
        player1 = find_player_by_name(args[1])
        player2 = find_player_by_name(args[2])
      end

      if player1 ~= nil and player2 ~= nil then
        local pos = player2.position
        local ang = math.random(0,math.pi*2)
        local dist = math. random(2, settings.global["abro-tweaks-teleport-radius"].value)

        pos.x = pos.x + math.sin(ang)*dist
        pos.y = pos.y + math.cos(ang)*dist

        player1.teleport(pos, player2.surface)
        sender.print(player1.name.." телепортирован к "..player2.name)
      else
        if player1 == nil then
          sender.print("Не удалось найти игрока: "..player1_search_string)
        end
        if player2 == nil then
          sender.print("Не удалось найти игрока: "..player2_search_string)
        end
      end
    end
  end
end

commands.add_command("goto", {"commands-help.abro-tweaks-goto-help"}, tp_handler)
commands.add_command("call", {"commands-help.abro-tweaks-call-help"}, tp_handler)
commands.add_command("tp", {"commands-help.abro-tweaks-tp-help"}, tp_handler)



--[[ =========================== Команда /team =========================== ]]--

function team_handler(command)
  if command.player_index ~= nil and command.parameter ~= nil then
    local sender = game.get_player(command.player_index)
    local team = sender.force
    local color = sender.color
    local color_multiplier = settings.global["abro-tweaks-chat-color-multiplier"].value
    for _,v in pairs(team.players) do
      v.print(sender.name .. " [TEAM]: " .. command.parameter, {color.r*color_multiplier, color.g*color_multiplier, color.b*color_multiplier, color.a})
    end
  end
end

commands.add_command("team", {"commands-help.abro-tweaks-team-help"}, team_handler)



--[[ =========================== Глобальный чат =========================== ]]--

function global_chat(event)
  local enabled = settings.global["abro-tweaks-global-chat"].value
  if event.player_index ~= nil then
    local sender = game.get_player(event.player_index)
    local color = sender.color
    local team = sender.force
    for _,v in pairs(game.players) do
      if v.force ~= team then
        v.print(sender.name .. " [GLOBAL]: " .. event.parameter, {color.r*color_multiplier, color.g*color_multiplier, color.b*color_multiplier, color.a})
      end
    end
  end
end

script.on_event(defines.events.on_console_chat, global_chat)



--[[ =========================== Значение эволюции =========================== ]]--

function set_evolution_handler(command)
  if command.player_index ~= nil and command.parameter ~= nil then
    local sender = game.get_player(command.player_index)
    local value = tonumber(command.parameter)

    if value ~= nil and sender.admin then
      value = math.max(0,math.min(1,value))
      game.forces["enemy"].evolution_factor = value
      sender.print("Фактор эволюции теперь равен "..value)
      max_value = settings.global["abro-tweaks-maxfactor"].value
      if value > max_value then
        sender.print("Указанный фактор эволюции больше ограничителя ("..max_value.."). Эволюция будет сброшена до значения ограничителя.")
      end
    end
  end
end

commands.add_command("setevolution", {"commands-help.abro-tweaks-set-evolution"}, set_evolution_handler)
commands.add_command("evolve", {"commands-help.abro-tweaks-set-evolution"}, set_evolution_handler)



--[[ =========================== Сдвиг игрока =========================== ]]--

function shift_handler(command)
  if command.player_index ~= nil and command.parameter ~= nil then
    local sender = game.get_player(command.player_index)
    local xy = split(command.parameter, " ")
    local x = xy[1]
    local y = xy[2]

    if x ~= nil and y ~= nil and sender.admin then
      local pos = sender.position
      pos.x = pos.x + x
      pos.y = pos.y + y
  
      sender.teleport(pos)
    end
  end
end

commands.add_command("shift", {"commands-help.abro-tweaks-shift"}, shift_handler)

