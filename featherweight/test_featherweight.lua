
local fw = require 'featherweight'

local tests = {}

function tests.callable()
  assert( fw.callable(function() end) )
  assert( fw.callable(setmetatable({}, {__call=function() end})) )
  assert( not fw.callable("function") )
  assert( not fw.callable(42) )
end

function tests.copy()
  local first = { uncle="bob" }
  local second = fw.copy(first)
  assert(second.uncle == "bob")
end

function tests.meta()
  local obj = fw.meta(fw.weakValue)
  assert(getmetatable(obj)==fw.weakValue)
end

function tests.const()
  local tab = fw.const { apple="yummy" }
  assert( tab.apple == "yummy" )
end

function tests.enum()
  local list = { "one", "two", "three" }
  local enum = fw.enum(list)
  assert( enum.one == 1 )
  assert( enum.two == 2 )
  assert( enum.three == 3 )
end

function tests.shuffle()
  -- can't test that it's actually random, but can assure code runs
  local list = {1, 2, 3, 4}
  assert( fw.shuffle(list) )
end

function tests.bind()
  local object = { value = 0 }
  local function adjust_value(object, value) object.value = value end
  local binding = fw.apply(adjust_value, object)
  binding(1)
  assert(object.value == 1)
end

function tests.memoize()
  local function fib(x)
    if x < 2 then
      return x
    else
      return fib(x-1) + fib(x-2)
    end
  end
  fib = assert(fw.memoize(fib))
  assert( fib(20) == 6765 )
end

function tests.compose()
  local function a(x) return x + 1 end
  local function b(x) return x + 2 end
  local function c(x) return x + 4 end
  local function d(x) return x + 8 end
  local fn = fw.compose(a, b, c, d)
  assert( fn(0)==15 )
end

function tests.flatten()
  local list = { 1, 2, { 3, 4, { 5, 6 } }, 7 }
  fw.flatten(list)
  assert(type(list[3])~="table")
end

function tests.objects()
  local Klass = fw.Object:extend { x = 1 }
  function Klass:init(y)
    self.y = y
  end
  Klass:mixin { z = 3 }

  local inst = Klass:new(2)
  assert(inst.x==1)
  assert(inst.y==2)
  assert(inst.z==3)
  assert(not Klass.y)
end


do
  local function perform_test(name, test)
    print("Test:", name)
    local b, err = pcall(test)
    if not b then print(err) end
  end

  local runtests
  local ARGC = select('#', ...)
  if ARGC == 0 then
    runtests = tests
  else
    runtests = {}
    for i = 1, ARGC do
      local testname = select(i, ...)
      runtests[testname] = tests[testname]
    end
  end

  for key, fn in pairs(runtests) do
    perform_test(key, fn)
  end
end

