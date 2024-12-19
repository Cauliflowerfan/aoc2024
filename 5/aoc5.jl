#Not very elegant but it works
using DelimitedFiles
rules=Int.(readdlm("rules.txt",'|'))
input=(readdlm("input.txt",','))
function checkrules(inputrow, rules)
    out=true
    for rule in eachrow(rules)
        if checkonerule(inputrow, rule)==false
            out=false
            break
        end
    end
    return out
end

function checkonerule(inputrow, rule)
    out=true
    if findfirst(isequal(rule[1]),inputrow)==nothing ||
        findfirst(isequal(rule[2]),inputrow)==nothing
    elseif findlast(isequal(rule[1]),inputrow)>findfirst(isequal(rule[2]),inputrow)
        out=false
    end
    return out
end


function middlefinder(row)
    lastnoindex=findlast(x->typeof(x)==Int64,row)
    out=row[Int((1+lastnoindex)/2)]
end

function middlesummer(input, rules)
    out=0
    for inputrow in eachrow(input)
        if checkrules(inputrow, rules)
            out+=middlefinder(inputrow)
        end
    end
    return out
end

function rowfixer(inputrow,rules)
    fixedrow=copy(inputrow)
    while checkrules(fixedrow, rules)==false
        brokenrule=rules[findfirst(x->!checkonerule(fixedrow, x),eachrow(rules)),:]
        leftpos=findfirst(isequal(brokenrule[2]),fixedrow)
        rightpos=findlast(isequal(brokenrule[1]),fixedrow)
        fixedrow[leftpos]=brokenrule[1]
        fixedrow[rightpos]=brokenrule[2]
    end
    return fixedrow
end

function middlesummerwithfix(input, rules)
    out=0
    for inputrow in eachrow(input)
        inputrow=rowfixer(inputrow,rules)
        out+=middlefinder(inputrow)
    end
    return out
end