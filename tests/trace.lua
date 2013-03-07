
hook_enabled = false

function hook(ev)
  if not hook_enabled then return end
  local info=debug.getinfo(2)
  for k, v in pairs(info) do
    io.write(" "..tostring(k)..":"..tostring(v).." |")
  end
  for i = 1, 5 do
    local k, v = debug.getlocal(2, i)
    io.write("| "..tostring(k)..":"..tostring(v).." ")
  end
  io.write("\n")
end

function trace(fn, ...)
  print("---")
  debug.sethook(hook, "c")
  hook_enabled = true
  local ret = {fn(...)}
  hook_enabled = false
  debug.sethook(nil)
  print("---")
  return unpack(ret)
end

fib = function(x,y,z)
  return ((x<2) and x) or (fib(x-2)+fib(x-1))
end

print("result:", trace(fib,2))

