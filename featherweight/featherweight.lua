--
-- Featherweight
-- Very small functions that implement basic behaviors.
--
-- Where applicable, I refer to tables like so:
--   list: a table where integer keys between 1 and N are non-nil.
--   object: a table with no expected ordering to keys
--


local fw = {}


--- first( a, b, [c...] )
-- Returns first non-nil value from the parameters
-- Slightly optimized: a and b checks are unrolled from the loop
function fw.first(a, b, ...)
  if type(a)~="nil" then return a end
  if type(b)~="nil" then return b end
  for i = 1, select('#', ...) do
    local c = select(i, ...)
    if type(c)~="nil" then return c end
  end
end


--- callable( function )
-- returns true if function appears to be a valid function object
function fw.callable(fn)
  return type(fn)=="function" or
    (getmetatable(fn) and type(getmetatable(fn).__call)=="function")
end


--- meta( [table], style )
-- Returns a table who's metatable has been set to style
function fw.meta(object, style)
  if type(style)=="nil" then
    style, object = object, {}
  end
  return setmetatable(object, style)
end


-- Common weak reference tables
-- Example: x=meta(weakValue)
fw.weakKey = { __mode = "k" }
fw.weakValue = { __mode = "v" }
fw.weakKeyValue = { __mode = "kv" }


--- const( object )
-- Returns a new table where changing values is an error
-- Existing values are inherited from object.
do 
  local function _constnewindex(_, key)
    error("Const table error: "..key, 2)
  end

  function fw.const(object)
    local cont = setmetatable({}, {
      __index = object,
      __newindex = _constnewindex
    })
    return cont, object
  end
end


--- enum( list )
-- Returns a table where all indexes in list are keys whose value is the index in object
-- Example: enum { "one", "two", "three" } --> { one=1, two=2, three=3 }
function fw.enum(list)
  local object = {}
  for i = 1, #list do
    object[list[i]] = i
  end
  return object, list
end


-- keys( object )
-- Returns all keys from a table as a list (unsorted)
-- Note: only keys available from pairs, not inherited keys
function fw.keys( object )
  local list = {}
  for key, _ in pairs(object) do
    list[#list+1] = key
  end
  return list
end


--- shuffle( list )
-- Modifies a list to Fisher-Yates-Randomize its elements
function fw.shuffle(list)
  local N = #list
  for i = 1, N-1 do
    local r = math.random(i, N)
    if i ~= r then
      list[i], list[r] = list[r], list[i]
    end
  end
  return list
end


--- apply( function, [parameters...] )
-- Returns a function where the parameter list has been partially applied
function fw.apply(func, ...)
  local params, args = {}, {}
  local N = select('#', ...)
  for i = 1, N do params[i] = select(i, ...) end
  
  return function(...)
    for k, _ in pairs(args) do args[k] = nil end
    local M = select('#', ...)
    for i = 1, N do args[i] = params[i] end
    local i = N + 1
    for j = 1, M do
      args[i] = select(j, ...)
      i = i + 1
    end
    local unpack = unpack or table.unpack
    return func(unpack(args))
  end
end


--- compose( function, function, [functions...] )
-- Returns a callable table that composes function calls together
-- Result is fn1(fn2(fn3(etc(...))))
-- functional composure via metatable
do
  -- save on memory by reusing a table and not recursing
  local function collect(t, ...)
    local M, N = select('#',...), #t
    for i = 1, M do t[i] = select(i, ...) end
    for i = M+1, N do t[i] = nil end
    return t
  end

  local _mt = {
    __call = function(t, ...)
      local unpack = unpack or table.unpack
      local res = {...}
      for i = #t, 1, -1 do
        collect(res, t[i](unpack(res)))
      end
      return unpack(res)
    end
  }

  function fw.compose(...)
    return setmetatable({...}, _mt)
  end
end


--- fprintf( file, template, [options...] )
function fw.fprintf(file, str, ...)
  return f:write(str:format(...))
end


--- printf( template, [options...] )
function fw.printf(str, ...)
  return io.stdout:write(str:format(...))
end


--- memoize( function )
-- caches and returns the results of function(key) calls
-- function stored at table-value index to prevent key collision
do
  local funcIndex = {}

  local _mt = {
    __call = function(store, key, ...)
      local value = store[key]
      if type(value)=="nil" then
        value = store[funcIndex](key, ...)
        store[key] = value
      end
      return value
    end
  }

  function fw.memoize(fn)
    return setmetatable( {[funcIndex]=fn}, _mt )
  end
end


--- copy( object )
-- Returns a shallow copy of a table (metatable also copied)
function fw.copy(object)
  local child = {}
  for key, value in pairs(object) do
    child[key]=value
  end
  return setmetatable(child, getmetatable(object))
end


--- extend( parent, [child] )
-- returns a shallow copy of a table, without erasing existing keys in child
function fw.extend(parent, child)
  child = child or {}
  for key, value in pairs(parent) do
    if type(rawget(child, key))=="nil" then
      child[key]=value
    end
  end
  if not getmetatable(child) then
    setmetatable(child, getmetatable(object))
  end
  return child
end


--- mixin( destination, source, [more_sources...] )
-- Copies key/values from source object to destination object
-- Non-destructive (doesn't overwrite values already in object)
-- Left preference for which value is copied when sources have overlapping keys
-- Returns destination object
function fw.mixin(dst, ...)
  for i = 1, select('#', ...) do
    for key, value in pairs(select(i, ...)) do
      if type(rawget(dst, key))=="nil" then
        rawset(dst, key, value)
      end
    end
  end
  return dst
end


--- new( class )
-- Implements basic class instantiation (class.__index will be added)
-- Returns new instance object
function fw.new(class, ...)
  if type(class.__index)=="nil" then
    class.__index = class
  end
  local object = setmetatable({}, class)
  local init = object.init
  if init then
    init(object, ...)
  end
  return object
end


-- Convienience object for use as a parent class:
-- Example usage:
--   local myClass = fw.Object:extend { init = function(parameters) end }
--   myClass:mixin( someBehavior, someOtherBehavior )
--   local myInstance = myClass:new( parameters )
fw.Object = { extend = fw.extend, mixin = fw.mixin, new = fw.new }


--- flatten( list, [depth] )
-- Convert a list of lists in-place into a single list
function fw.flatten(list)
  local insert, remove = table.insert, table.remove
  local i = 1
  while i < #list do
    if type(list[i])=="table" then
      local sub = remove(list, i)
      for j = 1, #sub do
        insert(list, i, sub[j])
      end
    else
      i = i + 1
    end
  end
  return list
end


--- uniq( list, [comparator] )
-- Removes duplicate items from a list
function fw.uniq(list, cmp)
  local remove = table.remove
  local i = 1
  while i < #list do
    for j = #list, i+1 do
      if (cmp and cmp(list[i], list[j])) or (list[i]==list[j]) then
        remove(list, j)
      end
    end
    i = i + 1
  end
  return list
end


return fw

