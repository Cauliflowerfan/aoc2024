using IterTools

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

function antennatypes(input)
    chars=unique(input)
    deleteat!(chars,findfirst(isequal("."), chars))
    return chars
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

function is_antinode(chart, index, antenna)
    antennaindices=findtargetindices(chart, antenna)
    distances=antennaindices.-index
    for distance in eachcol(distances)
        if (distance !=[0,0]) && distance.*2 in eachcol(distances)
            return true
            break
        end
    end
    return false
end

function is_antinode_RH(chart, index, antenna)
    antennaindices=findtargetindices(chart, antenna)
    distances=antennaindices.-index
    for distance in eachcol(distances)
        for internodaldistance in (eachcol(distances.-distance))
            if internodaldistance==[0,0]
                continue
            elseif any(n->distance+internodaldistance.*n ==[0,0],0:50)
                return true
                break
            end
        end
    end
    return false
end



function find_antinodes(chart)
    out=Threads.Atomic{Int}(0)
    #antinodeindices=Matrix{Int}(undef, 2, 0)
    antennas=antennatypes(input)
    Threads.@threads for i=1:size(chart)[1]
        for j=1:size(chart)[2]
            if any(antenna->(is_antinode(chart, [i,j], antenna)),antennas)
                Threads.atomic_add!(out,1)
            end
        end
    end
    return out[]
end

function find_antinodes_RH(chart)
    out=Threads.Atomic{Int}(0)
    #antinodeindices=Matrix{Int}(undef, 2, 0)
    antennas=antennatypes(input)
    Threads.@threads for i=1:size(chart)[1]
        for j=1:size(chart)[2]
            if any(antenna->(is_antinode_RH(chart, [i,j], antenna)),antennas)
                Threads.atomic_add!(out,1)
            end
        end
    end
    return out[]
end





input=txt2matrix("input.txt")