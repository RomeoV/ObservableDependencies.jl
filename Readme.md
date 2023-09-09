## ObservableDependencies.jl
This project only contains a single function, `plot_observable_dependencies`, that finds all the observables in a module and plots their dependencies.
This can be useful when debugging a big dependency mess.

Plots observables that have a `on` listener as red (I use `on` to consume signals).

Example

``` julia
n1 = Observable(1)
n2 = @lift 2*$n1
on(n2, priority=1) do n2
    Consume()
end
n3 = @lift 2*$n1
n4 = @lift $n1 + $n1

plot_observable_dependencies(Main)
```
