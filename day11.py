def getInput(file):
  with open("/Users/hulacst/Documents/wd/aoc_2021/" + file, "r") as inp:
    input = inp.read().split("\n")
    return([i for i in input if i != ''])

inp = getInput('day11.input')
testin = """5483143223
2745854711
5264556173
6141336146
6357385478
4167524645
2176841721
6882881134
4846848554
5283751526""".split("\n")

# print(testin)
# print(inp)



class Octopodes:
    def __init__(self, input):
        self.raw_input = input
        self.parse()
        self.flashes = 0
        self.rows = range(len(input))
        self.columns = range(len(input[0]))
        # print(self.octs)

    def parse(self):
        self.octs = []
        for line in self.raw_input:
            self.octs.append([int(x) for x in line])
    
    def neighbors(self, r, c):
        offsets = [[a,b] for a in range(-1,2) for b in range(-1,2)]
        offsets.remove([0,0])
        b = [[a+r,b+c] for [a,b] in offsets if a >= 0 and b >= 0 and a <= self.rows and b <= self.columns]
        return(b)
        

    def checkFlashReady(self):
        rtf = []
        for r in self.rows:
            for c in self.columns:
                if self.oct[r][c] >= 9:
                    self.rtf.append([r,c])
        return(rtf)

    def flash(self, row, column):
        els = self.octs
        neighbor_indices = self.neighbors(row,column)



    def increase(self):
        return([[x + 1 for x in r] for r in self.octs])
        

    def prepareNext(self):
        return([[0 if x > 9 else x for x in r] for r in self.octs])
    
    def print(self):
        print(self.octs)

a = Octopodes(testin)
a.print()
b = a.increase()
# b.print()