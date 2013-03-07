--
-- Prototype Inheritance
--
-- Example usages:
--   object = proto.inherit(parent)
--   object = proto:inherit()
--   parent = proto:inherit(); child = parent:inherit()
--   instance = parent:new()

local proto = {}
local mt = {}

local safe = {
  __tostring = function(obj) return "object" end,
  __eq = function(obj, other) return false end,
}

function mt.__index(object, key)
  return rawget(object, '__proto')[key]
end

for _, mm in ipairs {
  '__add', '__call', '__concat', '__div', '__eq', '__le', '__lt',
  '__mod', '__mul', '__pow', '__sub', '__tostring', '__unm'
} do
  mt[mm] = function(object, ...)
    local method = object[mm] or safe[mm]
    return method(object, ...)
  end
end

-- inherit( parent, [body] )
-- Prototypical-Inheritance of a parent table (doesn't need to be otherwise special)
-- All metamethods are also inherited, with some default behaviors provided.
-- Returns the child object (or body)
function proto.inherit(parent, body)
  body = setmetatable(body or {}, mt)
  rawset(body, "__proto", parent)
  return body
end

-- new( parent, [parameters...] )
-- Instantiates an object from a parent and calls __init handler
-- returns new instance object
function proto.new(parent, ...)
  local instance = proto.inherit(parent)
  local init = parent.__init
  if init then init(instance, ...) end
  return instance
end

return proto

