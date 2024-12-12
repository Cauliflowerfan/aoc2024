input=open(io->read(io, String), "example.txt")
function mul_and_do_finder(string)
    out=[]
    i=1
    while i<length(string)
        matchindex=findnext(("mul("*r"[0-9]{1,3}"*","*r"[0-9]{1,3}"*
        ")"), input, i)
        if matchindex==nothing
            break
        else
            out=vcat(out, string[matchindex])
            i=matchindex[end]
        end
    end
    return out
end

function stringcaller(string)
    out=eval(Meta.parse(string))
end

function mul_and_do_finder(string)
    out=[]
    i=1
    while i<length(string)
        matchindex=findnext(r"mul\([0-9]{1,3}\,[0-9]{1,3}\)|do\(\)|don't\(\)", input, i)
        if matchindex==nothing
            break
        else
            out=vcat(out, string[matchindex])
            i=matchindex[end]
        end
    end
    return out
end

function mulcalculator(calls)
    out=0
    enable=true
    for call in calls
        if call=="don't()"
            enable=0
        elseif call=="do()"
            enable=1
        else
            out+=stringcaller(call)*enable
        end
    end
    return out
end

        

sum=0

mulcalls=mul_and_do_finder(input)



mul(x,y)=x*y
print(sum)

