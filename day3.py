def getInput(file):
  with open("/Users/hulacst/Documents/wd/aoc_2021/" + file, "r") as inp:
    input = inp.read().split("\n")
    return([i for i in input if i != ''])

test = True

if(test):
  d = ["00100","11110","10110","10111","10101","01111","00111","11100","10000","11001","00010","01010"]
else:
  d = getInput('day3.input')
  
  # part 1
# gamma rate
twisted = []
for i in range(len(d[0])):
  twisted.append([x[i] for x in d])
  
def most_common(lst):
    return max(set(lst), key=lst.count)

gamma_str = ""
for d in twisted:
  gamma_str = gamma_str + most_common(d)
  
sw = {
  "0": "1",
  "1": "0"
}

epsilon_str = "".join([sw[d] for d in gamma_str])
print(epsilon_str)
  
gamma = int(gamma_str,2)
epsilon = int(epsilon_str,2)

print(gamma)
print(epsilon)
print(gamma * epsilon)

# part 2 ========================================
def check_for_done(diag_report):
  if len(diag_report) == 1:
    return(int(diag_report[0], 2))
  else:
    return(None)

def evaluate_numbers(diag_report, bit_criteria):
  if len(diag_report) == 1:
    return(int(diag_report[0], 2))
  else:
    # do some shit
    pass

