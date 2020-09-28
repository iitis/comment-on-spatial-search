using LinearAlgebra
using LightGraphs
using Expokit
##

function normalize_eigen(eigdec)
    n = length(eigdec.values)
    λ1, λ2, λn = eigdec.values[[n,n-1,1]]
    eigdec.values .-= λn
    eigdec.values ./= λ1 - λn
    # eigen.values .-= (λ2 + λn)/2
    # eigen.values ./= λ1 - (λ2 + λn)/2
    eigdec
end

function true_probability(h::AbstractArray, t::Float64)
    n = size(h, 1)
    init_state = fill(1/sqrt(n), n)
    f_state = expmv(t, -1im*h, init_state)
    abs2(f_state[1])
end

function compute_gammas(h, n, p)
    gamma1 = 1/(n*p)

    eigdec = eigen(h)
    gamma2 = 1/eigdec.values[end]

    eigs = eigdec.values[1:end-1] ./ eigdec.values[end]
    a = eigdec.vectors[1,1:end-1]
    nominator = sum(abs2.(a) ./ (1 .- eigs))
    denominator = sum(abs2.(a))
    gamma3 = gamma2*nominator/denominator

    opt_time = pi/2/(abs(eigdec.vectors[1,end]) / sqrt(sum(abs2.(a) ./ (1 .- eigs).^2 )))

    opt_time, gamma1, gamma2, gamma3
end


# h = get_hamiltonian(erdos_renyi(10, 0.5), :adjacency_matrix)
# println(eigvals(h))

function data(n::Int, p::Float64)
    #println("> $(nv(g))")
    g = erdos_renyi(n, p)
    h = Symmetric(Matrix{Float64}(adjacency_matrix(g, Float64)))
    eigdec = eigen(h)

    gammas = compute_gammas(h, n, p)

    result
end
