def getInput(file):
    with open("/Users/hulacst/Documents/wd/aoc_2021/" + file, "r") as inp:
        input = inp.read().split("\n")
    return([int(i) for i in input if i != ''])

test = False
  
d = getInput('day1.input')
if(test):
  d = [199,200,208,210,200,207,240,269,260,263]
# print(range(1,len(d1)))

c = [0]

for i in range(1,len(d)):
  if d[i] > d[i-1]:
    c.append(1)

# print(sum(c))

# part two
sm = 0
threes = [d[i] + d[i+1] + d[i + 2] for i in range(0,len(d)-2)]
for i in range(1,len(threes)):
  if threes[i] > threes[i-1]:
    sm += 1
    
print(sm)
