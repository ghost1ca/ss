-- ############################################
-- monitor_button
-- version 0.1
-- http://hevohevo.hatenablog.com/
 
-- ################## config ##################
CtrlMonSide = "left"
MainMonSide = "left"
CharSymbol = ""
 
-- ################## functions ###############
function writeEventInfo(mon, event_name, btn)
  mon.setCursorPos(1,1)
  mon.clearLine()
  mon.write(string.format("%s [ %s ]", event_name, btn.name))
end
 
function writePosInfo(mon, goal_x, goal_y)
  mon.setCursorPos(1,2)
  mon.clearLine()
  mon.write(string.format("(%d,%d)", goal_x, goal_y))
end
 
-- local current_x, current_y = moveSymbol(mon, start_x, start_y, goal_x, goal_y)
function moveSymbol(mon, start_x, start_y, goal_x, goal_y)
  writePosInfo(mon, goal_x, goal_y)  
  mon.setCursorPos(start_x, start_y)
  mon.write(" ")
  mon.setCursorPos(goal_x,goal_y)
--   mon.write(CharSymbol)
 
  return goal_x, goal_y
end
 
-- return btns-table
function makeSixButtons(ctrl_mon)
  local names = {"MainDoor", "up", "quit", "left", "down", "right"}
  local mon_w, mon_h = ctrl_mon.getSize()
  local btn_w = math.floor(mon_w/3)
  local btn_h = math.floor(mon_h/2)
  ----------------------------
  -- btns[1]  btns[2]  btns[3]
  -- btns[4]  btns[5]  btns[6]
  ----------------------------
  local btns = {}
  local i = 1 -- btn index
  for row=1,2 do
    for col=1,3 do
      btns[i] = {name=names[i], min_x=1+(btn_w)*(col-1), max_x=btn_w*col, min_y=1+(btn_h)*(row-1), max_y=btn_h*row }
      i = i+1
    end
  end
 
  return btns
end
 
function drowButtons(mon, buttons)
  for i,b in pairs(buttons) do
    local center_x = math.floor((b.min_x + b.max_x)/2)
    local center_y = math.floor((b.min_y + b.max_y)/2)
    local center_label = math.floor(string.len(b.name)/2)
    mon.setCursorPos(center_x - center_label, center_y)
    mon.write(b.name)
  end
end
 
-- whichButton(buttons, 1, 1) => btn     (btn-table)
--                            => false   (don't pushed)
function whichButton(buttons, clicked_x, clicked_y)
  local function within(min_num, max_num, num)
          return (min_num <= num and max_num >= num)
        end
  local pushed_btn = false
 
  for i,v in pairs(buttons) do
    if within(v.min_x, v.max_x, clicked_x) and within(v.min_y, v.max_y, clicked_y) then
      pushed_btn = v
      break
    end
  end
  
  return pushed_btn
end
 
-- event_name, pushed_btn = pullPushButtonEvent(buttons_table, "top")
function pullPushButtonEvent(buttons, mon_dir)
  local pushed_btn = false
  repeat 
    local event, dir, x, y = os.pullEvent("monitor_touch")
    if mon_dir == dir then
      pushed_btn = whichButton(buttons, x, y)
    end
  until  pushed_btn
 
  return "push_button", pushed_btn
end
 
-- ################## main #####################
 
-- init main monitor
local main_mon = peripheral.wrap(MainMonSide)
main_mon.setTextScale(1)
main_mon.clear()
 
-- drow a charactor on main monitor
local main_mon_w, main_mon_h = main_mon.getSize()
local init_x = math.floor(main_mon_w/2)  -- charactor's initial pos.
local init_y = math.floor(main_mon_h/2)
local x, y = moveSymbol(main_mon, init_x, init_y, init_x, init_y) -- charactor's current pos.
 
-- init ctrl monitor
local ctrl_mon = peripheral.wrap(CtrlMonSide)
ctrl_mon.setTextScale(0.5)
ctrl_mon.clear()
 
-- make buttons and drow on ctrl monitor
local buttons = makeSixButtons(ctrl_mon)
drowButtons(ctrl_mon, buttons)
 
-- main loop
repeat
  local event_name, pushed_btn = pullPushButtonEvent(buttons, CtrlMonSide)
  writeEventInfo(main_mon, event_name, pushed_btn)
 
  if pushed_btn.name=="MainDoor" then -- move char to initial pos.
    -- x, y = moveSymbol(main_mon, x, y, init_x, init_y)
local password = "1324"
print("Sti parola fraiere?")
local scrie = read("*")
if scrie == password then
  main_mon.clear()
  main_mon.write("GRESSIIIIITTTTT")
  sleep(1000)
  main_mon.write("Am glumit intra !!!")
  redstone.setOutput("back", true)
  sleep(15000)
  redstone.setOutput("back", false)
else
  print("Ass Hole")
end
  elseif pushed_btn.name=="up" and y > 4 then
    x, y = moveSymbol(main_mon, x, y, x, y-1)
  elseif pushed_btn.name=="down" and y < main_mon_h  then
    x, y = moveSymbol(main_mon, x, y, x, y+1)
  elseif pushed_btn.name=="left" and x > 1 then
    -- x, y = moveSymbol(main_mon, x, y, x-1, y)
    -- rednet.open("top")
    -- rednet.send(2, "jos")
  elseif pushed_btn.name=="right" and x < main_mon_w then
    x, y = moveSymbol(main_mon, x, y, x+1, y)
  else
    -- do nothing
  end
 
  sleep(0) -- Don't delete because "monitor_touch" event is too sensitive.
until pushed_btn.name=="quit"
