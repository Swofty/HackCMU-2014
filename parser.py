import sys


DEFINED_VARS = { }
FUNC_PARAM_VARS = set()
FUNCARGS = {}
INSIDE_FUNCTION_DEF = 0

pyFile = sys.argv[1]


def parseExpr(expr):
    def evalExpr(ex):
        if("," not in ex):
            if("+" in ex): return " add {0} {1} ".format(*ex.split("+"))
            elif("-" in ex): return " sub {0} {1} ".format(*ex.split("-"))
            elif("*" in ex): return " mul {0} {1} ".format(*ex.split("*"))
            elif("/" in ex): return " div {0} {1} ".format(*ex.split("/"))
            elif("**" in ex): return " pow {0} {1} ".format(*ex.split("**"))
            else: return " " + ex + " "
        else:
            return " ".join([evalExpr(part) for part in ex.split(",")])
    
    while("(" in expr):
        ifrontParens = [ ]
        pairs = [ ]
        for i in range(len(expr)):
            if(expr[i] == "("): ifrontParens.append(i)
            elif(expr[i] == ")"): pairs.append((ifrontParens.pop(), i, len(ifrontParens)))
        pairs.sort(key=lambda x:x[2]*-1)
        pair = pairs[0]
        deepestWithParen = expr[pair[0]:pair[1]+1]
        deepestWithoutParen = expr[pair[0]+1:pair[1]]
        expr = expr.replace(deepestWithParen, evalExpr(deepestWithoutParen))
    expr = evalExpr(expr)
    allTerms = expr.split()
    for i in range(len(allTerms)):
        term = allTerms[i]
        if(term in ["add", "sub", "mul", "div", "pow"]): continue
        elif(term in DEFINED_VARS or term in FUNC_PARAM_VARS): allTerms[i] = "var " + term
        elif(term in FUNCARGS): allTerms[i] = "call "+term+(" {}".format(FUNCARGS[term]))
            
    final = " ".join(allTerms)
    return final
    


def hDef(output, line):
    
    global INSIDE_FUNCTION_DEF
    global FUNC_PARAM_VARS
    INSIDE_FUNCTION_DEF += 1
    parenthIndex = line.index("(")
    secondParenth = line.index(")")
    name = line[4:parenthIndex]
    parameters = line[parenthIndex+1:secondParenth].split(",")
    for i in range(len(parameters)):
        parameters[i] = parameters[i].strip()
    output.write("start room {}\n".format(name))
    if(parameters[0] != ""):
        for p in parameters:
            output.write("parameter {}\n".format(p))
            FUNC_PARAM_VARS.add(p)

def hAssign(output, line):
    if(line.count("=")%2==0): return
    global DEFINED_VARS
    varName, varVal = line.split("=")
    varName, varVal = varName.strip(), varVal.strip()
    varVal = parseExpr(varVal)
    #if not('"' in varVal or "'" in varVal):
    #    try:
    #        float(varVal)
    #        break
    #    except ValueError:
    #        varVal = DEFINED_VARS[varVal]
    DEFINED_VARS[varName] = varVal
    return varName, varVal

def hIf(output, line):
    output.write("start condition\n")
    line = line.rstrip()
    indexIf = line.index("if")
    indexColon = line.index(":")
    indent = indexIf
    
    if(len(line) > indexColon+1):
        meat = [line[indexColon+1:]]
    else:
        meat = None
    boolCond = line[indexIf+2:indexColon]
    boolCond = boolCond.replace("(","").replace(")","")
    if ("==" in boolCond): op = "=="
    elif (">" in boolCond): op = ">"
    elif ("<" in boolCond): op = "<"
    varName, const = boolCond.split(op)
    
    output.write("if "+ op + " " + varName +" "+ const+"\n")
    return indent,meat
    
def hElif(output, line):
    line = line.rstrip()
    indexIf = line.index("elif")
    indexColon = line.index(":")
    indent = indexIf
    
    if(len(line) > indexColon+1):
        meat = [line[indexColon+1:]]
    else:
        meat = None
    boolCond = line[indexIf+4:indexColon]
    boolCond = boolCond.replace("(","").replace(")","")
    if ("==" in boolCond): op = "=="
    elif (">" in boolCond): op = ">"
    elif ("<" in boolCond): op = "<"
    varName, const = boolCond.split(op)
    output.write("elif "+ op + " " + varName +" "+ const +"\n")
    return indent,meat
    
def hElse(output, line):
    line = line.rstrip()
    indexIf = line.index("else")
    indexColon = line.index(":")
    indent = indexIf
    if(len(line) > indexColon+1):
        meat = [line[indexColon+1:]]
    else:
        meat = None
    output.write("else\n")
    return indent,meat
    
    
def hIfmid(output,lines,lineNumber,indent):
    meat=[]
    def getIndent(l):
        return len(l) - len(l.lstrip())
    while(getIndent(lines[lineNumber]) > indent):
        line = lines[lineNumber]
        if(not line.isspace()):
            meat.append(line)
        lineNumber+=1
    return meat,lineNumber-1

    
def hReturn(output, line):
    line = line.replace("return", "").lstrip()
    output.write("return "+parseExpr(line) + "\n")
    return
    

    
    
OUTPUT = open("outputs.ccr", "w")

def parse(lines):
    global FUNCARGS
    global INSIDE_FUNCTION_DEF
    ifd_startval = INSIDE_FUNCTION_DEF
    for line in lines:
        if("def" == line[:3]):
            modLine = line[3:].lstrip()
            funcName = modLine[:modLine.index("(")].rstrip()
            args = line.count(",") + 1
            FUNCARGS[funcName] = args
            
    lineNumber = 0
    totalLines = len(lines)
    while(lineNumber<totalLines):
        kywrdFound = False
        line = lines[lineNumber]
        if (line==line.lstrip() and lineNumber!=0 and INSIDE_FUNCTION_DEF):
            INSIDE_FUNCTION_DEF -= 1
            OUTPUT.write("end room\n")
        for kywrd in KEYWORDS:
            if kywrd in line:
                kywrdFound = True
                if(kywrd == "if" and ("elif" not in line) and line.strip().startswith("if")):
                    
                    indent,meat = hIf(OUTPUT, line)
                    if(meat == None):
                        meat,lineNumber = hIfmid(OUTPUT,lines,lineNumber+1,indent)
                    
                    parse(meat)
                    a = 1
                    ltemp = lines[lineNumber+a]
                    while(ltemp.isspace()):
                        a+=1
                        ltemp=lines[lineNumber+a]
                    if not("elif" in ltemp or "else" in ltemp):
                        OUTPUT.write("end condition\n")
                elif(kywrd == "elif" and line.strip().startswith("elif")):
                    
                    indent,meat = hElif(OUTPUT, line)
                    if(meat == None):
                        meat,lineNumber = hIfmid(OUTPUT,lines,lineNumber+1,indent)
                    parse(meat)
                    a = 1
                    ltemp = lines[lineNumber+a]
                    while(ltemp.isspace()):
                        a+=1
                        ltemp=lines[lineNumber+a]
                    if not("elif" in ltemp or "else" in ltemp):
                        OUTPUT.write("end condition\n")
                elif(kywrd == "else" and line.strip().startswith("else")):
                    
                    indent,meat = hElse(OUTPUT, line)
                    if(meat == None):
                        meat,lineNumber = hIfmid(OUTPUT,lines,lineNumber+1,indent)
                    parse(meat)
                    
                    OUTPUT.write("end condition\n")
                elif(kywrd == "if" and "elif" in line):
                    continue
                    
                else:
                    KEYWORDS_FUNCTIONS[kywrd](OUTPUT, line)
        if not(kywrdFound or line.isspace()):
            res = parseExpr(line)
            OUTPUT.write(res + "\n")
        lineNumber+=1
    if(INSIDE_FUNCTION_DEF > ifd_startval):
        INSIDE_FUNCTION_DEF -= 1
        OUTPUT.write("end room\n")
    

    
with open(pyFile, "r") as pf:
    pflines = pf.readlines()
   
KEYWORDS = ["def", "=", "if", "elif", "else", "return"]

KEYWORDS_FUNCTIONS = {"def" : hDef,
                      "=": hAssign,
                      "if": hIf,
                      "elif" : hElif,
                      "else" : hElse,
                      "return": hReturn }
parse(pflines)
OUTPUT.write("END OF FILE\n")

OUTPUT.close()














