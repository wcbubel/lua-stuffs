
function closure_bind(fn, obj)
  return function(...) return fn(obj, ...) end
end

local mt = { __call = function(o, ...) return o.fn(o.obj, ...) end }

function metatable_bind(fn, obj)
  return setmetatable({fn=fn, obj=obj}, mt)
end

function modify(object, value)
  object.value = value
end

function test_binding(bind, count)
  local obj = {}
  local modify = modify
  for i = 1, count do
    local t = bind(modify, obj)
    t(i)
  end
  assert( obj.value == count )
end

local binding, count = select(1, ...)
local start = os.time()
collectgarbage()
test_binding( _G[binding], tonumber(count) )
print(os.time()-start, collectgarbage("count"))

