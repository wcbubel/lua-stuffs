math.randomseed(os.time());
markov_chain = {}

-- Produce Markov Chain, counting chances of words.
for line in io.lines() do
  local w1="";
  local w2="\n";
  local current;
  local prior;
  for current in string.gmatch(line, "[%c%w]+") do
    prior = w1.." "..w2;
    markov_chain[prior] = markov_chain[prior] or {};
    markov_chain[prior][current] = (markov_chain[prior][current] or 0) + 1;
    w1 = w2;
    w2 = current;
  end
  prior = w1.." "..w2;
  markov_chain[prior] = markov_chain[prior] or {};
  markov_chain[prior]["\n"] = (markov_chain[prior]["\n"] or 0) + 1;
end

-- Convert counts over to percentages.
for i, v in pairs(markov_chain) do
  local max=0;
  for j, u in pairs(v) do
    max = max + u;
  end
  for j, u in pairs(v) do
    v[j] = u / max;
  end
end

-- Produce test sentence.
w1="";
w2 = "\n";
for i=1, 1024 do
  local r = math.random();
  local c = 1.0 - r;
  local nextword;
  local prior = w1.." "..w2;
  for j, u in pairs(markov_chain[prior]) do
    nextword = j;
    c = c - u;
    if c <= 0 then
      break;
    end
  end
  if nextword == nil then break; end
  io.write( nextword.." " );
  if nextword == "\n" then break; end
  w1 = w2;
  w2 = nextword;
end

-- eof
