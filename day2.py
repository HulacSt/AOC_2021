def getInput(file):
    with open("/Users/hulacst/Documents/wd/aoc_2021/" + file, "r") as inp:
        input = inp.read().split("\n")
    return([i for i in input if i != ''])
test = False
  

if(test):
  d = ["forward 5","down 5","forward 8","up 3","down 8","forward 2"]
else:
  d = getInput('day2.input')

# part 1
  
dKey = {
  "forward": [1,0],
  "down":    [0,1],
  "up":      [0,-1],
}

def parse_instruction(txt):
  return(txt.split(' '))

def make_movement(raw_instruction):
  pi = parse_instruction(raw_instruction)
  direction_string = pi[0]
  mag = int(pi[1])
  direction = dKey[direction_string]
  direction_with_magnitude = [i * mag for i in direction]
  return(direction_with_magnitude)

# print(make_movement("forward 3"))

def add_movement(movement, l0 = [0,0]):
  l2 = [l0[0] + movement[0], l0[1] + movement[1]]
  return(l2)

# make it go
location = [0,0]
for m in d:
  movement = make_movement(m)
  # print()
  location = add_movement(movement, location)

# print(location)

#answer 1
# print(location[0] * location[1])

# part 2 -------

# down X increases your aim by X units.
# up X decreases your aim by X units.
# forward X does two things:
# It increases your horizontal position by X units.
# It increases your depth by your aim multiplied by X.


def move(instruction, old_loc):
  pi = parse_instruction(instruction)
  mvt = pi[0]
  x = int(pi[1])
  # [position, depth, aim]
  position = old_loc[0]
  depth = old_loc[1]
  aim = old_loc[2]
  if mvt == 'down':
    aim += x
  elif mvt == 'up':
    aim -= x
  elif mvt == 'forward':
    position += x
    depth = depth + aim * x
  return([position, depth, aim])

loc = [0,0,0]
for i in d:
  loc = move(i, loc)

# print(loc)
# print(loc[0] * loc[1])

# now just messing around

  
for x in d:
  cmd,mag = x.split(' ')
  print(cmd,mag)
