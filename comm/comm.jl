#!/usr/bin/env julia

f = open("comm.txt")
lines = readlines(f)
close(f)

maxtime = 0
for line in lines
    if line[1] == '['
        toks = split(line)
        time = parse(Int, toks[1][2:end-1]) + 1
        maxtime = max(maxtime, time)
    end
end

spks = zeros(maxtime, 80, 80)
for line in lines
    if line[1] == '['
        if contains(line, "number of spks")
            toks = split(line)
            time = parse(Int, toks[1][2:end-1]) + 1
            pid = parse(Int, toks[2][2:end-1]) + 1
            num = parse(Int, toks[end])
            spks[time,pid,:] = num
            spks[time,pid,pid] = 0
        end
    end
end

for i = 1:maxtime
    spks[i,:,:] = reshape(spks[i,:,:], 80, 80) + reshape(spks[i,:,:], 80, 80)'
end

#= using Gadfly =#
#= using DataFrames =#
#=  =#
#= for t = 50:maxtime =#
#=     p = spy(reshape(spks[t,:,:], 80, 80), =#
#=             Guide.title("Communication Matrix"), =#
#=             Guide.xlabel("Process ID"), =#
#=             Guide.ylabel("Process ID")) =#
#=     draw(PNG(@sprintf("%03.0f.png", t), 5inch, 5inch), p) =#
#= end =#

using Winston

for t = 1:maxtime
    imagesc(reshape(spks[t,:,:], 80, 80))
    savefig(@sprintf("%03.0f.png", t))
end

diffs1 = zeros(maxtime, 80, 80)
for i = 2:maxtime
    diffs1[i,:,:] = reshape(spks[i,:,:], 80, 80) - reshape(spks[i-1,:,:], 80, 80)
end

for t = 1:maxtime
    imagesc(reshape(diffs1[t,:,:], 80, 80))
    savefig(@sprintf("%03.0f.png", t))
end

d = 10

diffs10 = zeros(round(Int, floor(maxtime / d)), 80, 80)
for i = 1:round(Int, floor(maxtime / d))
    for j = 1:d
        diffs10[i,:,:] = reshape(diffs10[i,:,:], 80, 80) + reshape(diffs1[(i-1)*d+j,:,:], 80, 80)
    end
end

for t = 1:round(Int, floor(maxtime / d))
    imagesc(reshape(diffs10[t,:,:], 80, 80))
    savefig(@sprintf("%03.0f.png", t))
end
