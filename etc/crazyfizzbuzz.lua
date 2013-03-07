
function lolzz(fibu, n, i) return ((i%n)==0) and io.write(fibu.."zz") end
function fizz(i) return lolzz("Fi", 3, i) end
function buzz(i) return lolzz("Bu", 5, i) end
function test(a, b) return a or b end
function fizzbuzz(i) return test(fizz(i), buzz(i)) or io.write(i) end

for i = 1, 100 do
  fizzbuzz(i)
  io.write('   ')
end

