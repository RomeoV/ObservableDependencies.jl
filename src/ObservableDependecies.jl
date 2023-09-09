module ObservableDependecies

export plot_observable_dependencies

using Graphs, GraphMakie

function plot_observable_dependencies(mod=Main)
    observable_names = filter(var->eval(Expr(:call, :typeof, var)) <: AbstractObservable,
                              names(mod))
    all_observables = map(eval, observable_names)
    g = DiGraph()
    add_vertices!(g, length(all_observables))

    consumed_observables = []

    for obs_lhs in all_observables
        for (is_consumed, map_callback) in obs_lhs.listeners
            if is_consumed == 1
                push!(consumed_observables, obs_lhs)
                continue
            else
                obs_rhs = map_callback.result
                lhs_idx = findfirst(==(obs_lhs), all_observables)
                rhs_idx = findfirst(==(obs_rhs), all_observables)
                if !isnothing(lhs_idx) && !isnothing(rhs_idx)
                    add_edge!(g, lhs_idx, rhs_idx)
                end
            end
        end
    end

    colors = [(obs ∈ consumed_observables ? :red : :black) for obs in all_observables]
    graphplot(g; nlabels=string.(observable_names), node_color=colors)
end

end # module ObservableDependecies
