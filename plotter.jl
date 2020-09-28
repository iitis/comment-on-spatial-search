using PyPlot
using NPZ
using LaTeXStrings
using Statistics

rc("text", usetex=true)
rc("font", family="serif")

p_powers = [-.25, -.4, -.5, -.6, -.75]
ns = [1000, 2000, 5000, 10_000,20_000,]# 50_000, 100_000]
repeating = 10

cla()
fig, axs = subplots(length(ns), length(p_powers))
for (ind_n, n) = enumerate(ns), (ind_p, p_pow) = enumerate(p_powers)
    mean_ideal = Float64[]
    mean_np = Float64[]
    for m=1:repeating
        data = npzread("data/single_cases_plot_$n-$p_pow-$m.npz")
        data_t = data[:,1]
        data_t ./= maximum(data_t)
        
	push!(mean_ideal, maximum(data[:,4]))
        push!(mean_np, maximum(data[:,2]))

        axs[ind_n,ind_p].plot(data_t, data[:,4], "k-", label=L"exact", linewidth=.6)
        axs[ind_n,ind_p].plot(data_t, data[:,2], "r--", label=L"$ 1/(np) $", linewidth=.6)
        #axs[ind_n,ind_p].plot(data_t, data[:,3], "b.-", label=L"$1/\lambda_1", linewidth=.1)
    end
    axs[ind_n,ind_p].hlines(mean(mean_ideal), 0, 1, linestyle=":", color="k", linewidth=.7)
    axs[ind_n,ind_p].hlines(mean(mean_np), 0, 1, linestyle=":", color="r", linewidth=.7)
    axs[ind_n,ind_p].label_outer()
    axs[ind_n,ind_p].set_ylim(.0,1.0)
end

for (i, n) = enumerate(ns)
    axs[i,1].text(-.85,0.5,"n= $n", verticalalignment="center", rotation=90)
    axs[i,1].set(ylabel=L"\rm succ.\ prob.")
end    
for (j, p_pow) = enumerate(p_powers)
    axs[1,j].set_title(latexstring("p=1/n^{$(abs(p_pow))}"), loc="center")
    axs[length(ns),j].set(xlabel=L"\rm time")
end


savefig("the_plot.pdf")
