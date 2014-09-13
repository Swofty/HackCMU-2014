import sys

KEYWORDS = ["def", "=", "if", "return"]

KEYWORDS_FUNCTIONS = {"def" : hDef,
                      "=": hAssign,
                      "if": hIf,
                      "return": hReturn }

DEFINED_VARS = { }
INSIDE_FUNCTION_DEF = False

pyFile = sys.argv[1]

def hDef(output, line):
    global INSIDE_FUNCTION_DEF
    INSIDE_FUNCTION_DEF = True
    parenthIndex = line.index("(")
    secondParenth = line.index(")")
    name = line[4:parenthIndex]
    parameters = line[parenthIndex+1:secondParenth].split(",")
    for i in range(len(parameters)):
        parameters[i] = parameters[i].strip()
    output.write("start room {}\n".format(name))
    for p in parameters:
        output.write("parameter {}\n".format(p))

def hAssign(output, line):
    global DEFINED_VARS
    varName, varVal = line.split("=")
    varName, varVal = varName.strip(), varVal.strip()
    if not('"' in varVal or "'" in varVal):
        try:
            float(varVal)
            break
        except ValueError:
            varVal = DEFINED_VARS[varVal]
    DEFINED_VARS[varName] = varVal
    return varName, varVal

def hIf(output, line):
    output.write("start condition\n")
    line = line.rstrip()
    indexIf = line.index("if")
    indexColon = line.index(":")
    indent = indexIf
    if(len(line) > indexColon+1):
        meat = line[indexColon+1:]
    booleanCond = line[indexIf+2:indexColon]
    
    return indent
    
def hReturn(output, line):
    #output.write("
    

with open(pyFile, "r") as pf:
    with open("outputs.crl", "w") as f:
        line = pf.readline()
        while(line != ""):
            for kywrd in KEYWORDS:
                if kywrd in line():
                    if(kywrd == "if"):
                        indent = hIf(f, line)
                    else:
                        KEYWORDS_FUNCTIONS[kywrd](f, line)
            
















