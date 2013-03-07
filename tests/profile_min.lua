
function run_test(minfn, count)
  local res
  for i = 1, count do
    res = minfn(1, 2)
  end
  assert(res==1)
end

local fns = {
  mathmin = math.min,
  my_min = function(x, y)
    if x < y then return x else return y end
  end
}

local to_test = select(1, ...) or "mathmin"
local count = select(2, ...) or 50000000

print("Testing "..to_test.." "..count)
run_test(fns[to_test], count)
print("Done.")

