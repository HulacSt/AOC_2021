# import matplotlib.pyplot as plt
def getInput(file):
  with open("/Users/hulacst/Documents/wd/aoc_2021/" + file, "r") as inp:
    input = inp.read().split("\n")
    return([i for i in input if i != ''])

fish = [3,4,3,1,2]
test = False
if not test:
    fish = (getInput('day6.input')[0]).split(",")
    fish = [int(n) for n in fish]

# print(fish)
def runDown(fish):
    new_fish = [8 for x in fish if x == 0]
    f1 = [x-1 for x in fish]
    f2 = f1 + new_fish
    f3 = [6 if x < 0 else x for x in f2]
    # f2 = [f1.append(8) for x in f1 if x == 0]
    # print(new_fish)
    return(f3)

def runXtimes(fish, times):
    for t in range(times):
        fish = runDown(fish)
    return(fish)

# print(len(runXtimes(fish, 18)))

# iterations = [i+1 for i in range(80)]
# n_fish = [len(runXtimes(fish,x)) for x in iterations]

# now go to day6.r and try a regression

# 12/7
# part 2
# try again with just counts rather than a huge list
def initial_count(fish):
  d = {}
  for v in range(9):
    d[v] = 0
    
  for f in fish:
    d[f]  += 1
  return(d)

def run_day(cnts):
  counts = cnts
  new_fish = counts[0]
  for i in range(1,len(counts)):
    counts[i-1] = counts[i]
  counts[8] = new_fish
  counts[6] += new_fish
  # print(counts)
  return(counts)

def run_n_times(initial_counts, n):
  counts = initial_counts
  i = 0
  while i < n:
    counts = run_day(counts)
    # print(counts)
    i += 1
  return(counts)

def calculate_total(final_counts):
  return(sum(final_counts.values()))


ic = initial_count(fish)
a5 = run_n_times(ic,256)
print(a5)
print(calculate_total(a5))
    

  
