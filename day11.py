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
        self.rows = len(input)
        self.columns = len(input[0])
        # print(self.octs)

    def parse(self):
        self.octs = []
        for line in self.raw_input:
            self.octs.append([int(x) for x in line])
    
    def neighbors(self, r, c):
        offsets = [[a,b] for a in range(-1,2) for b in range(-1,2)]
        offsets.remove([0,0])
        b = [[a+r,b+c] for [a,b] in offsets]
        c = [[a,b] for [a,b] in b if a >= 0 and b >= 0 and a < self.rows and b < self.columns]
        return(c)
        
    def checkFlashReady(self):
        rtf = []
        for r in range(self.rows):
            for c in range(self.columns):
                if self.octs[r][c] == 10:
                    rtf.append([r,c])
        return(rtf)

    def flash(self, row, column):
        neighbor_indices = self.neighbors(row,column)
        for [r,c] in neighbor_indices:
            self.octs[r][c] += 1
        self.flashes += 1

    def increase(self):
        self.octs = [[x + 1 for x in r] for r in self.octs]
        

    def prepareNext(self):
        self.octs = [[0 if x > 9 else x for x in r] for r in self.octs]
    
    def print(self):
        print("\n")
        for l in self.octs:
            print("".join(str(l)))
        print('flashes: ', self.flashes)

    def run(self):
        counter = 0
        while(counter < 100):
            self.increase()
            rtf = self.checkFlashReady()
            while len(rtf) > 0:
                for f in rtf:
                    self.flash(f[0], f[1])
                # self.prepareNext()
                rtf = self.checkFlashReady()
                self.print()
            self.prepareNext()
            counter += 1
        # self.print()
        print(self.flashes)
            
        

a = Octopodes(testin)
a.run()