using DelimitedFiles

function txt2matrix(file)
    input=readdlm(file)
    ydim=length(input)
    xdim=length(input[1])
    #out=Array{String}(xdim, ydim)
    out=fill("",xdim,ydim)
    for i=1:xdim, j=1:ydim
        out[i,j]=string((input[j])[i])
    end
    return out
end

function findtargetindices(chart, target)
    out=Matrix{Int}(undef, 2, 0)
    for i=1:size(chart)[1], j=1:size(chart)[2]
        if chart[i,j]==target
            out=hcat(out, [i,j])
        end
    end
    return out
end

function guard_step(position,facing, chart)
    rightrotation = [0 -1;1 0]
    newcoord = position+facing
    if all(1 .<= newcoord .<= size(chart))
        if chart[newcoord...]=="#"
            return position, rightrotation*facing, true
        else
            return newcoord, facing, true
        end
    else
        return position, facing, false
    end
end

function guard_patrol(startpos, startfacing, chart)
    guardinchart=true
    position=startpos
    facing=startfacing
    history=[position]
    visited_spots=copy(chart)
    visited_spots[position...]="X"

    while guardinchart
        position, facing, guardinchart=guard_step(position,facing, chart)
        push!(history, position)
        visited_spots[position...]="X"
    end
    return visited_spots
end

function guard_patrol_loops(startpos, startfacing, chart)
    guardinchart=true
    position=startpos
    facing=startfacing
    history=Set([(position, facing)])
    while guardinchart
        position, facing, guardinchart=guard_step(position,facing, chart)
        if (position, facing) in history && guardinchart
            return true
            break
        end
        push!(history, (position,facing))
    end
    return false
end


function obstacleplacer(startpos, startfacing, chart)
    loopcount=0
    for i=1:size(chart)[1], j=1:size(chart)[2]
        if [i,j]==startpos
            continue
        else
            original=chart[i,j]
            chart[i,j]="#"
            if guard_patrol_loops(startpos, startfacing, chart)
                loopcount+=1
            end
            chart[i,j]=original
        end
    end
    return loopcount
end

function obstacleplacer_MT(startpos, startfacing, chart)
    loopcount = Threads.Atomic{Int}(0)
    Threads.@threads for i=1:size(chart)[1]
        local_chart = copy(chart)
        for j=1:size(chart)[2]
            if [i,j]==startpos
                continue
            else
                original=local_chart[i,j]
                local_chart[i,j]="#"
                if guard_patrol_loops(startpos, startfacing, local_chart)
                    Threads.atomic_add!(loopcount, 1)
                end
                local_chart[i,j]=original
            end
        end
    end
    return loopcount
end

input=txt2matrix("input.txt")
startpos=findtargetindices(input, "^")
startfacing=[0,-1]
rightrotation = [0 -1;1 0]
vs=guard_patrol(startpos,startfacing,input)
println(count(isequal("X"),vs))
println(obstacleplacer_MT(startpos, startfacing, input))