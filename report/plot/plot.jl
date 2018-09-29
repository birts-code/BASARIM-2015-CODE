#!/usr/bin/env julia

using Gadfly
using DataFrames

### ints

x = [1, 2, 4, 8, 16, 32, 64, 128]
y = [152, 2502, 2502, 2502, 2502, 2502, 2502, 2502]
t = x .* y

df1 = DataFrame(x=x, y=y, message="single")
df2 = DataFrame(x=x, y=t, message="total")

p = plot(vcat(df1, df2),
         x="x", y="y",
         color="message",
         Scale.x_log2(labels=x -> string(int(2 ^ x))),
         Scale.y_log10,
         Geom.point, Geom.line,
         Guide.title("# ints (in MPI Allgather)"),
         Guide.xlabel("# Processes"),
         Guide.ylabel("# ints"))

draw(PDF(joinpath("pdfs", "ints.pdf"), 5inch, 5inch), p)

### spikes

x = [1, 2, 4, 8, 16, 32, 64, 128]
y = [42138, 21069, 10534, 5267, 2633, 1316, 658, 329]
t = x .* y

df1 = DataFrame(x=x, y=y, message="single")
df2 = DataFrame(x=x, y=t, message="total")

p = plot(vcat(df1, df2),
         x="x", y="y",
         color="message",
         Scale.x_log2(labels=x -> string(int(2 ^ x))),
         Scale.y_log10,
         Geom.point, Geom.line,
         Guide.title("# spikes sent (in MPI Allgatherv)"),
         Guide.xlabel("# Processes"),
         Guide.ylabel("# Messages"))

draw(PDF(joinpath("pdfs", "spikes.pdf"), 5inch, 5inch), p)

### times-shared

x = [1, 2, 4, 8, 16, 32, 64, 128]
y = [4568, 2329, 1218, 709, 557, 292, 250, 247]
s = ones(length(y)) * y[1] ./ y

df1 = DataFrame(x=x, y=s, speedup="real")
df2 = DataFrame(x=[1,128], y=[1,128], speedup="ideal")

p = plot(vcat(df1, df2),
         x="x", y="y",
         color="speedup",
         Scale.x_log2(labels=x -> string(int(2 ^ x))),
         Scale.y_log2(labels=x -> string(int(2 ^ x))),
         Geom.point, Geom.line,
         Guide.title("Speedups on Shared Memory"),
         Guide.xlabel("# Processes"),
         Guide.ylabel("Speedup"))

draw(PDF(joinpath("pdfs", "times-shared.pdf"), 5inch, 5inch), p)

### times-distributed

x = [1, 5, 10, 20, 40, 80]
y = [11938, 1565, 565, 173, 68, 38]
s = ones(length(y)) * y[1] ./ y

df1 = DataFrame(x=x, y=s, speedup="real")
df2 = DataFrame(x=[1,80], y=[1,80], speedup="ideal")

p = plot(vcat(df1, df2),
         x="x", y="y",
         color="speedup",
         Scale.x_log2(labels=x -> string(int(2 ^ x))),
         Scale.y_log2(labels=x -> string(int(2 ^ x))),
         Geom.point, Geom.line,
         Guide.title("Speedups on Distributed Memory"),
         Guide.xlabel("# Processes"),
         Guide.ylabel("Speedup"))

draw(PDF(joinpath("pdfs", "times-distributed.pdf"), 5inch, 5inch), p)

### communication matrix

f = open("comm.txt")
lines = readlines(f)
close(f)

spks = zeros(80, 80)
for line in lines
    if contains(line, "number of spks")
        toks = split(line)
        pid = int(toks[1][2:end-1]) + 1
        num = int(toks[end])
        spks[pid,:] = num
        spks[pid,pid] = 0
    end
end

spks = spks + spks'

p = spy(spks,
        Guide.title("Communication Matrix"),
        Guide.xlabel("Process ID"),
        Guide.ylabel("Process ID"))

draw(PDF(joinpath("pdfs", "communication-matrix.pdf"), 5inch, 5inch), p)

### communication times

x = [5, 10]  # nodes
y1 = [5.615, 6.331]  # 4 process per node [20-5, 40-10] (original)
y2 = [5.354, 5.645]  # 4 process per node [20-5, 40-10] (optimized)
y3 = [6.988, 6.879]  # 8 process per node [40-5, 80-10] (original)
y4 = [6.013, 5.705]  # 8 process per node [40-5, 80-10] (optimized)

df1 = DataFrame(x=x, y=y1, time="4 process per node (original)")
df2 = DataFrame(x=x, y=y2, time="4 process per node (optimized)")
df3 = DataFrame(x=x, y=y3, time="8 process per node (original)")
df4 = DataFrame(x=x, y=y4, time="8 process per node (optimized)")

p = plot(vcat(df1, df2, df3, df4),
         x="x", y="y",
         color="time",
         Geom.point, Geom.line,
         Guide.title("Communication Times"),
         Guide.xlabel("# Nodes"),
         Guide.ylabel("Communication Time (secs)"))

draw(PDF(joinpath("pdfs", "communication-times.pdf"), 5inch, 5inch), p)
