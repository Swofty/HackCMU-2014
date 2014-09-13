import sys

KEYWORDS = ["def", "=", "if", "return"]

KEYWORDS_FUNCTIONS = {"def" : hDef,
                      "=": hAssign,
                      "if": hIf,
                      "return": hReturn }

DEFINED_VARS = { }

INSIDE_FUNCTION_DEF = False

pyFile = sys.argv[1]


def parseExpr(expr):
    def is_number(num):
    try:
        float(num)
        return True
    except ValueError:
        return False
    tempExpr = expr
    parens = expr.count("(")
    for each in xrange(parens):
        startparen = expr.index("(")
        endparen = expr.index(")")
        for index in range(startparen:endparen+1):
            if (not (tempExpr[index]=="(" or tempExpr[index]==")")):
                tempExpr[index] = " "
        tempExpr[startparen] = " "
        tempExpr[endparen] = " "
    tempExpr = tempexpr.strip()
    if(tempExpr in DEFINED_VARS):
        output.write(" var " )+ tempExpr)
    elif(tempExpr in FUNCARGS):
        output.write(" call " + tempExpr +" "+ FUNCARGS[tempExpr])
    




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
        if(not line.isspace())
            meat.append(line)
        lineNumber+=1
    return meat,lineNumber-1

    
def hReturn(output, line):
    
    #output.write("
    

OUTPUT = open("outputs.ccr", "w")

def parse(lines):
    global FUNCARGS = {}
    for line in lines:
        if("def" == line[:3]):
            modLine = line[:3].lstrip()
            funcName = modLine[:modline.index("(")].rstrip()
            args = len(line) - len(line.replace(",", "")) + 1
            FUNCARGS[funcName] = args
            
    lineNumber = 0
    totalLines = len(lines)
    while(lineNumber<totalLines):
        line = lines[lineNumber]
        for kywrd in KEYWORDS:
            if kywrd in line:
                if(kywrd == "if"):
                    indent,meat = hIf(output, line)
                    if(meat == None):
                        meat,lineNumber = fIfmid(output,lines,lineNumber+1,indent)
                    parse(meat)
                    a = 1
                    ltemp = lines[lineNumber+a]
                    while(ltemp.isspace())
                        a+=1
                        ltemp=lines[lineNumber+a]
                    if not("elif" in ltemp or "else" in ltemp):
                        OUTPUT.write("end condition\n")
                elif(kywrd == "elif"):
                    indent,meat = hElif(output, line)
                    if(meat == None):
                        meat,lineNumber = fIfmid(output,lines,lineNumber+1,indent)
                    parse(meat)
                    a = 1
                    ltemp = lines[lineNumber+a]
                    while(ltemp.isspace())
                        a+=1
                        ltemp=lines[lineNumber+a]
                    if not("elif" in ltemp or "else" in ltemp):
                        OUTPUT.write("end condition\n")
                elif(kywrd == "else"):
                    indent,meat = hElse(output, line)
                    if(meat == None):
                        meat,lineNumber = fIfmid(output,lines,lineNumber+1,indent)
                    parse(meat)
                    OUTPUT.write("end condition\n")
                    
                else:
                    KEYWORDS_FUNCTIONS[kywrd](f, line)
                    
                    
        lineNumber+=1
with open(pyFile, "r") as pf:
    pflines = pf.readlines()
   

parse(pflines)

OUTPUT.close()














