
List = {}
List.__index = List

function List.new()
  local self = { _next={}, _prev={}, _head=false, _tail=false }
  return setmetatable(self, List)
end

function List:append( item )
  if self._next[item] then return end
  if not self._head then
    self._head = item
    self._tail = item
  else
    local prev = self._tail
    self._next[prev] = item
    self._prev[item] = prev
    self._tail = item
  end
end

function List:walk( func )
  local item = self._head
  while item do
    func(item)
    item = self._next[item]
  end
end

l = List.new()
l:append{1}
l:append{3}
l:append{5}
l:append{7}
l:append{9}
l:append{2}
l:append{4}
l:append{6}
l:append{8}

l:walk( function(item)
  print( item[1] )
end)


