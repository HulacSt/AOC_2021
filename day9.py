def getInput(file):
  with open("/Users/hulacst/Documents/wd/aoc_2021/" + file, "r") as inp:
    input = inp.read().split("\n")
    return([i for i in input if i != ''])

test = True

if(test):
  d = [
"2199943210",
"3987894921",
"9856789892",
"8767896789",
"9899965678"]
else:
  d = getInput('day9.input')

print(d)
print(len(d))


lowpoints = 0
for y in range(len(d)):
    height = len(d)
    for x in range(len(d[y])):
        point = int(d[y][x])
        width = len(d[y])
        xs = [x + o for o in [-1,1]]
        ys = [y + o for o in [-1,1]]
        xs_filtered = [x for x in xs if x >=0 & x < width]
        ys_filtered = [y for y in ys if y >= 0 & y < height]
        neighbors = [d[y + yo][x + xo] for yo in ys for xo in xs]
        print("point:", point, "neighbors:", neighbors)
        # if point < min(neighbors):
        #     lowpoints += (point + 1)
# print(lowpoints)
