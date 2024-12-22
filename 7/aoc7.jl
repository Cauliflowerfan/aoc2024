using DelimitedFiles
using CSV, DataFrames

function inputreader(txtfile)
    input=readdlm(txtfile,':')
    input[:,2]=split.(input[:,2], " ")
    for i in 1:size(input)[1]
        input[i,2]=input[i,2][2:end]
        input[i,2]=Meta.parse.(input[i,2])
    end
    return input
end


function addermulter(vector, target, sum=0)
    if length(vector)==1 
        if sum+vector[1]==target || sum*vector[1]==target
            return true
        else
            return false
        end
    else
        return addermulter(vector[2:end], target, sum+vector[1]) ||
            addermulter(vector[2:end], target, sum*vector[1])
    end
end

function addermulterconcer(vector, target, sum=0)
    if length(vector)==1 
        if sum+vector[1]==target || sum*vector[1]==target ||
            Meta.parse(string(sum)*string(vector[1]))==target
            return true
        else
            return false
        end
    else
        return any([addermulterconcer(vector[2:end], target, sum+vector[1]) ,
            addermulterconcer(vector[2:end], target, sum*vector[1]),
            addermulterconcer(vector[2:end], target,
            Meta.parse(string(sum)*string(vector[1])))])
    end
end

function calibrationsummer(input)
    out=Threads.Atomic{Int}(0)
    Threads.@threads for i=1:size(input)[1]
        if addermulter(input[i,2],input[i,1])
            Threads.atomic_add!(out, input[i,1])
        end
    end
    return out
end

function calibrationsummer2(input)
    out=Threads.Atomic{Int}(0)
    Threads.@threads for i=1:size(input)[1]
        if addermulterconcer(input[i,2],input[i,1])
            Threads.atomic_add!(out, input[i,1])
        end
    end
    return out
end


input=inputreader("input.txt")
println(calibrationsummer(input))
println(calibrationsummer2(input))
