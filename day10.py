def getInput(file):
  with open("/Users/hulacst/Documents/wd/aoc_2021/" + file, "r") as inp:
    input = inp.read().split("\n")
    return([i for i in input if i != ''])

testin = """[({(<(())[]>[[{[]{<()<>>
[(()[<>])]({[<{<<[]>>(
{([(<{}[<>[]}>{[]{[(<()>
(((({<>}<{<{<>}{[]{[]{}
[[<[([]))<([[{}[[()]]]
[{[{({}]{}}([{[{{{}}([]
{<[[]]>}<{[{[{[]{()[[[]
[<(<(<(<{}))><([]([]()
<{([([[(<>()){}]>(<<{{
<{([{{}}[<[[[<>{}]]]>[]]""".split("\n")

illegal_count = {")": 0,
        "]": 0,
        "}": 0,
        ">": 0}

oc = {"(": ")",
    "[": "]",
    "{": "}",
    "<": ">"}

co = {")": "(",
      "]": "[",
      "}": "{",
      ">": "<"}

def check_line(line):
    counter = {")": 0,
        "]": 0,
        "}": 0,
        ">": 0}
    
    for l in line:
        if l in counter:
            counter[l] -= 1
        else:
            counter[oc[l]] += 1
        print(l)
        print(counter)  
        for c in counter:
            if(counter[c] < 0):
                return(c)

print(check_line(testin[2]))