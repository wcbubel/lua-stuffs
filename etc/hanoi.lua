-- Towers of Hanoi

print( arg[1] );
moves = 0;

function move(n, src, dst)
  moves = moves + 1;
end


function tower( count, begin, aux, ender )
  if count > 0 then
    -- print( string.format("%i (%i, %i, %i)-->(%i, %i, %i)", count, begin, aux, ender, begin, ender, aux ) );
    tower( count-1, begin, ender, aux );
    move( count, begin, ender );
    -- print( string.format("And --> %i (%i, %i, %i)", count, aux, begin, ender ) );
    tower( count-1, aux, begin, ender );
  end
end

c = arg[1] or 3
c = math.floor(c);

tower( c, 1, 2, 3 )
print( "Moves:", moves );

-- EOF
