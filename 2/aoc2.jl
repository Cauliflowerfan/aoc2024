function isstrictlyincreasing(vector)
    #vectorshiftedbyone=vector[1:end-1]
    vectorcheck=vector[2:end]-vector[1:end-1]
    out=true
    for element in vectorcheck
        if element <= 0
            out = false
        end
    end
    return out
end

function isstrictlydecreasing(vector)
    #vectorshiftedbyone=vector[1:end-1]
    vectorcheck=vector[2:end]-vector[1:end-1]
    out=true
    for element in vectorcheck
        if element >= 0
            out = false
        end
    end
    return out
end

function maxstep(vector)
    vectorcheck=broadcast(abs,vector[2:end]-vector[1:end-1])
    return maximum(vectorcheck)
end

function minstep(vector)
    vectorcheck=broadcast(abs,vector[2:end]-vector[1:end-1])
    return minimum(vectorcheck)
end

function safelevel(vector)
    return ((isstrictlyincreasing(vector) || isstrictlydecreasing(vector)) &&
    abs(maxstep(vector))<=3 && abs(minstep(vector)>=1))
end

function dampenersafe(vector)
    out=false
    for i=1:length(vector)
        if safelevel(deleteat!(copy(vector),i))
            out=true
        end
    end
    return out
end


using DelimitedFiles
input=readdlm("input.txt")
numbersafelevels=0
for mrow in eachrow(input)
    row=copy(mrow)
    while !(row[end] isa Number)
        pop!(row)
    end
    if dampenersafe(row)
        global numbersafelevels+=1
    end
end
print(numbersafelevels)