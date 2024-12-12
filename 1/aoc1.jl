cumdifference(a,b)=sum(broadcast(abs,(a-b)))

function similiarityscore(a,b)
    left=(a)
    out=0
    for number in left
        out+=number*count(==(number),b)
    end
    return out
end


using DelimitedFiles
input=readdlm("input.txt")
a=sort(input[:,1])
b=sort(input[:,2])
out=cumdifference(a,b)
print(out)
out=similiarityscore(a,b)
print(out)