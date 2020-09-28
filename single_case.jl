using Distributed 
addprocs(1)


using LightGraphs
using NPZ
using SparseArrays
##

@everywhere include("2004_12686_tex_utils.jl")

##

#@everywhere rand_graph(n::Int) = erdos_renyi(n, 0.1)

repeating = 10
p_powers = reverse([-.25, -.4, -.5, -.6, -.75])

for n=[1000, 2000, 5000, 10_000, 20_000, 30_000, 40_000], m=1:repeating
    println()
    
    @show n
    for p_pow = p_powers
        @show p_pow
        filename = "data/single_cases_plot_$n-$p_pow-$m.npz"
        if isfile(filename)
            println("skipped")
            continue
        end

        
        p = n^p_pow

        g = erdos_renyi(n, eval(p))
        adj = Symmetric(Matrix{Float64}(adjacency_matrix(g, Float64)))
        println("Gamma calculation")
        @time gam_res = compute_gammas(adj, n, eval(p))
        
        data_t = (0:0.01:1.) .* (2*gam_res[1])
        gammas = gam_res[2:end]

        data = zeros(length(data_t), 0)
        data = hcat(data, data_t)
        for gamma = gammas
            data_p = zeros(length(data_t))
            h = sparse(gamma*adj)
            h[1,1] += 1
            @time data_p = pmap(t->true_probability(h, t), data_t)
            data = hcat(data, data_p)
        end
        npzwrite(filename, data)
    end
end




#rmprocs()
