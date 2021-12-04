def getInput(file):
  with open("/Users/hulacst/Documents/wd/aoc_2021/" + file, "r") as inp:
    input = inp.read().split("\n")
    return([i for i in input if i != ''])

test = False

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
for digit in twisted:
  gamma_str = gamma_str + most_common(digit)
  
sw = {
  "0": "1",
  "1": "0"
}

epsilon_str = "".join([sw[d] for d in gamma_str])
# print(epsilon_str)
  
gamma = int(gamma_str,2)
epsilon = int(epsilon_str,2)

# print(gamma)
# print(epsilon)
# print(gamma * epsilon)

# part 2 ========================================
class DiagnosisReport:
  def __init__(self, initial_report, bit_criteria):
    self.report = initial_report
    self.bit_criteria = bit_criteria
    self.width = len(self.report[0])

  def checkDone(self):
    return(len(self.report) == 1)

  def reportOut(self):
    return(int(self.report[0], 2))

  def whichToKeep(self, lst):
    zeroes = len([d for d in lst if d == '0'])
    ones   = len([d for d in lst if d == '1'])
    if zeroes > ones:
      out = '0'
    else:
      out = '1'
    switcheroo = {
      "0": "1",
      "1": "0"
    }
    if self.bit_criteria == "co2":
      out = switcheroo[out]
    return(out)

  def pluckDigit(self, digit_index):
    # print("====digit_index:", digit_index)
    # print("==============lines==============")
    # print([line for line in self.report])
    out = [line[digit_index] for line in self.report]
    # print("====polucked:", out)
    return(out)

  def whichIndexes(self, digit_index, keeping_bit):
    ds = self.pluckDigit(digit_index)
    inds = [i for i in range(len(ds)) if ds[i] == keeping_bit]
    return(inds)

  def filter(self, indicies_to_keep):
    self.report = [self.report[i] for i in indicies_to_keep]

  def runIteration(self):
    done = False
    digit_index = 0
    # print('width:', self.width)
    while not done and digit_index < self.width:
      # print("=======digit_index:", digit_index)
      these_digits  = self.pluckDigit(digit_index)
      # print("=======these_digits:", these_digits)
      keeper_bit    = self.whichToKeep(these_digits)
      # print("=======keeper bit:", keeper_bit)
      keep_indicies = self.whichIndexes(digit_index, keeping_bit=keeper_bit)
      # print("=======keeper rows:", keep_indicies)
      self.filter(keep_indicies)
      done = self.checkDone()
      if done:
        return(self.reportOut())
      digit_index += 1


o2 = (DiagnosisReport(initial_report = d, bit_criteria='o2').runIteration())
co2 = (DiagnosisReport(initial_report = d, bit_criteria='co2').runIteration())
print(o2 * co2)