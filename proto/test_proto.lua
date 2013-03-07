
local proto = require 'proto'

function test_prototypes()
  local Foo = proto:inherit{ x=1 }
  function Foo:__init(z) self.z = z end

  local Bar = assert( Foo:inherit { y=2 } )
  function Bar:__init(z) Bar.__proto.__init(self, z) end
  assert( Bar.x == 1 )

  local baz = Bar:new(3)
  assert( baz.x == 1 )
  assert( baz.y == 2 )
  assert( baz.z == 3 )
end

test_prototypes()

