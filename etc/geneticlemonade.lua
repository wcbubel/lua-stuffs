
-- Global list of lemonade qualities.
lemonade_qualities =
{
  salt = -1;
  egg  = -1;
  onion = -1;
  apple = -1;
  lemon = 1;
  water = 1;
  sugar = 1;
}

population = 7;
generations = 50;

function fitness( chromosone )
  local score = 0;
  local k, v;
  for k, v in pairs(chromosone) do
    if v then score = score + lemonade_qualities[k]; end;
  end
  return score;
end

function randomize_quality( c, s )
  if math.random(1, 2) == 2 then c[s] = true; else c[s] = false; end
end

function reproduce_quality( bull, cow, quality )
  if math.random(1, 100) <=4 then
    randomize_quality( cow, quality );
  else
    if math.random(1, 2)==1 then
      cow[quality] = bull[quality];
    end
  end
end

function reproduce( bull, cow )
  local k, v;
  if bull~=cow then
    for k, v in pairs(lemonade_qualities) do
      reproduce_quality( bull, cow, k );
    end
  end
end

function reproduce_population_with_bull( p, bull )
  local i, v;
  for i, v in ipairs(p) do
    reproduce( bull, v );
  end
end

function create_random_chromosone()
  local cow = {};
  local k, v;
  for k, v in pairs(lemonade_qualities) do
    randomize_quality( cow, k );
  end
  return cow;
end

function create_random_population( population )
  local p, i;
  p = {};
  for i = 1, population do
    p[i] = create_random_chromosone();
  end
  return p;
end

function score_population( p )
  local score;
  local i, v;
  score = {};
  for i, v in ipairs(p) do
    score[i] = fitness(v);
  end
  return score;
end

function get_bull_of_population( p )
  local bull = p[1];
  local score = score_population( p );
  local best = score[1];
  local i, v;
  for i, v in ipairs(score) do
    if best < v then
      bull = p[i];
      best = v;
    end
  end
  return bull;
end

function print_chromosone( c )
  local outp = "";
  local k, v;
  for k, v in pairs(c) do
    if v then outp = outp .. k .. " "; end
  end
  return outp;
end

function print_population( p )
  local outp = "";
  local i, v;
  for i, v in ipairs(p) do
    outp = outp .. i .. " " .. print_chromosone( v ) .. "\n";
  end
  print(outp);
end

math.randomseed( os.time() );

p = create_random_population( population );

for i = 1, generations do
  bull = get_bull_of_population( p );
  reproduce_population_with_bull( p, bull );

  outp = i .. " ";
  for k, v in ipairs(p) do
    if v == bull then outp = outp .. "bull "; else outp = outp .. "cow "; end
  end
  outp = outp .. fitness(bull) .. " ";
  outp = outp .. print_chromosone( bull );
  print( outp );
end

print_population( p );

-- EOF