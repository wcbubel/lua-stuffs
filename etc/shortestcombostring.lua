-- for readability in permgen
function swap( a, b ) return b, a end

-- recursive generation of all substrings, calls fn() with each
function permgen(a, n, fn)
  if n == 0 then fn(a)
  else
    for i = 1, n do
      a[n], a[i] = swap(a[n], a[i])
      permgen(a, n-1, fn)
      a[n], a[i] = swap(a[n], a[i])
    end
  end
end

-- Generic Iterator for permutating a table's values
function permutations(a)
  local n = #a
  local co = coroutine.create(function() permgen(a, n, coroutine.yield) end)
  return function ()
    local code, ret = coroutine.resume(co)
    return ret
  end
end

-- combines two substrings by detecting a single common suffix/prefix
function combine( a, b )
  if not a then return b end
  for i = 1, b:len() do
    local s = a..b:sub(-i)
    if s:sub(-b:len())==b then return s end
  end
  return a..b
end

-- compress a string by substring combination
function compress( ... )
  local s
  for i = 1, select("#", ...) do
    s = combine( s, select( i, ... ) )
  end
  return s
end

-- shows all permutations, with stings compressed where possible
function generateCompressedList( words )
  local list = {}
  for v in permutations(words) do
    table.insert( list, compress( unpack(v) ) )
  end
  table.sort( list, function(a,b)
    if a:len() == b:len() then return a < b
    else return a:len() < b:len() end
  end )
  return list
end

-- prints all compressed permutations of the 4 defined words
function main()
  local words = { "testing", "ginger", "german", "minutes" }
  local compressed = generateCompressedList( words )
  for _, v in ipairs( compressed ) do
    print(v)
  end
end

-- Typo detection after all global functions declared
setmetatable(_G, {
  __newindex=function(t,k,v) error("undeclared global var: "..k) end,
  __index=function(t,k) error("undeclared global var:"..k) end
})

main()

