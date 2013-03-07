-- Radix Tree Lookup

-- Recursively Adds a word to a tree.
function add_to_tree( a, fullword, part )
  part = part or fullword;
  if part:len() < 1 then
    a[fullword]=true;
  else
    local s = part:sub( 1, 1 )
    if type(a[s])~="table" then
      a[s] = {};
    end
    add_to_tree( a[s], fullword, part:sub(2) )
  end
end

-- Prints all words in the dictionary.
function radix_traverse( a )
  for k, v in pairs(a) do
    if type(v)=="boolean" then
      print(k)
    elseif type(v)=="table" then
      radix_traverse( v );
    end
  end
end

-- Performs a partial lookup on a word.
function partial_lookup( a, part )
  if part:len() < 1 then
    radix_traverse( a )
  else
    local s = part:sub( 1, 1 )
    if type(a[s])=="table" then
      partial_lookup( a[s], part:sub(2) )
    end
  end
end

dict = {}
add_to_tree( dict, "foo" )
add_to_tree( dict, "bar" )
add_to_tree( dict, "foobar" )
add_to_tree( dict, "bart" )
print("* List of all dictionary words.")
radix_traverse( dict )
print("* Partial Lookup on fo.")
partial_lookup( dict, "fo" );
print("* Partial Lookup on ba.")
partial_lookup( dict, "ba" );

-- EOF
