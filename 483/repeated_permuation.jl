
#=

    The problem asks us to find the order of 
    permutation squared, summed together for all permutations

    First, think of each permutation in cycle representation
    (1,3)(2,4,5)

    Then, the order of this permutation is the lcm of the cycle lengths

    The strategy is as such, given a number N, first enumerate all non-negative
    solutions to the following equation

    1*x_1+2*x_2+3*x_3...n*x_n=n

    each solutions is interpreted as 
    "x_1 1 cycles, x_2 2 cycles,..." and so on

    For each solution, we can calculate the order easily.

    Next, we calculate how many permutations are of each specific type,
    using combinatorics.

    Finally, we do a weighted sum.
=#

#=
    The first problem, finding non-negative solutions to 
    1*x_1+2*x_2+3*x_3...n*x_n=n

    We can use a recursive method.
    Suppose we found all solutions where some of x_{k+1}...x_n are non-zero.
    Now we just need to find solutions to 
    1*x_1+2*x_2...k*x_k=n 

    The set of non-zero x_k we can choose is x_k=1,2,...floor(n/k)
    for each, we can solve the subproblems
    1*x_1...(k-1)x_{k-1} = n-k
    1*x_1...(k-1)x_{k-1} = n-2k
            .........
    1*x_1...(k-1)x_{k-1} = n-floor(n/k)k

    Now we can focus on finding solutions where all x_{k...n} are 0
=#
using Primes
using DataStructures

function find_solution_partition(n)
    tp1 = typeof((1,1))
    tp2 = typeof([[(1,1)]])
    table = Dict{tp1,tp2}()
    return find_solution_partition_(n,n,table;threshold=40)
end

function find_solution_partition_(n,k,table;threshold=40)
    #find all non-negative solutions to
    #1*x_1+2*x_2...k*x_k=n 

    #base cases
    if n == 0 
        return [Tuple{Int64,Int64}[]]
    elseif k > n
        return find_solution_partition_(n,n,table)
    elseif k == 1
        #since in the body, only k-1 appears, so this is a valid terminating case fo k
        return [[(n,k)]]
    elseif haskey(table,(n,k))
        return deepcopy(table[(n,k)])
    end

    solution = typeof([(1,1)])[]
    for i=k:k:n
        arr = find_solution_partition_(n-i,k-1,table)
        for tmp∈arr
            push!(tmp,(div(i,k),k))
        end
        append!(solution,arr)
    end
    if n <= threshold
        table[(n,k)] = deepcopy(solution)
    end

    #above loop solves the k variable situation. Keep on solving k-1 variable situation
    append!(solution,find_solution_partition_(n,k-1,table))
    return solution
end

#=
function find_solution_partition_(n,k,table;threshold=50)
    #find all non-negative solutions to
    #1*x_1+2*x_2...k*x_k=n 

    #base cases
    if n == 0 
        return [Tuple{Int64,Int64}[]]
    elseif k > n
        return find_solution_partition_(n,n,table)
    elseif k == 1
        #since in the body, only k-1 appears, so this is a valid terminating case fo k
        return [[(1,n)]]
    elseif haskey(table,(n,k))
        return table[(n,k)]
    end

    solution = typeof([(1,1)])[]
    for i=k:k:n
        arr = find_solution_partition_(n-i,k-1,table)
        append!(solution,arr)
        for i=0:length(arr)-1
            push!(solution[end-i],(k,div(i,k)))
        end
    end
    if n <= threshold
        table[(n,k)] = solution
    end

    #above loop solves the k variable situation. Keep on solving k-1 variable situation
    append!(solution,find_solution_partition_(n,k-1,table))
    return solution
end
=#

#=
function find_solution_partition_(n,k,table)
    #find all non-negative solutions to
    #1*x_1+2*x_2...k*x_k=n 

    #base cases
    if n == 0 
        return [Tuple{Int64,Int64}[]]
    elseif k > n
        return find_solution_partition_(n,n,table)
    elseif k == 1
        #since in the body, only k-1 appears, so this is a valid terminating case fo k
        return [[(1,n)]]
    elseif haskey(table,(n,k))
        return table[(n,k)]
    end

    solution = typeof([(1,1)])[]
    for i=k:k:n
        arr = find_solution_partition_(n-i,k-1,table)
        append!(solution,arr)
        for i=0:length(arr)-1
            push!(solution[end-i],(k,div(i,k)))
        end
    end
    table[(n,k)] = solution

    #above loop solves the k variable situation. Keep on solving k-1 variable situation
    append!(solution,find_solution_partition_(n,k-1,table))
    return solution
end
=#

#=
function find_solution_partition_(n,k,table)
    #find all non-negative solutions to
    #1*x_1+2*x_2...k*x_k=n 

    #base cases
    if n == 0 
        return [Tuple{Int64,Int64}[]]
    elseif k > n
        return find_solution_partition_(n,n,table)
    elseif k == 1
        #since in the body, only k-1 appears, so this is a valid terminating case fo k
        return [[(1,n)]]
    elseif haskey(table,(n,k))
        return deepcopy(table[(n,k)])
    end

    solution = typeof([(1,1)])[]
    for i=k:k:n
        arr = find_solution_partition_(n-i,k-1,table)
        for tmp∈arr
            push!(tmp,(k,div(i,k)))
        end
        append!(solution,arr)
    end
    table[(n,k)] = deepcopy(solution)

    #above loop solves the k variable situation. Keep on solving k-1 variable situation
    append!(solution,find_solution_partition_(n,k-1,table))
    return solution
end
=#


function calc_combination_naive(list_tuples)
    N = sum(map(x->x[1]*x[2],list_tuples))
    sol = factorial(BigInt(N))
    for tup ∈ list_tuples
        n = BigInt(tup[1])
        k = BigInt(tup[2])
        sol = sol //(k^n) // factorial(n)
    end
    return sol
end

function calc_combination(list_tuples)
    N = sum(map(x->x[1]*x[2],list_tuples))
    sol = Dict{Int64,Int64}()
    for i=1:N
        mergewith!(+,sol,factor(Dict,i))
    end
    for tup ∈ list_tuples
        n = tup[1]
        k = tup[2]
        tmp = factor(Dict,k)
        map!(x->x * n,values(tmp))
        mergewith!(-,sol,tmp)
        for i=1:n 
            mergewith!(-,sol,factor(Dict,i))
        end
    end
    try
        return prod([x.first ^ x.second for x in sol])
    catch e
        println(list_tuples)
    end
end

function get_cycle(list_tuples)
    cycle_lengths = map(x->BigInt(x[2]),list_tuples)
    return lcm(cycle_lengths...)
end

function study_weight_distribution()
    N=80
    println("calculating partitions...")
    @time partitions = find_solution_partition(N)
    println("calculating weights...")
    #@time weights = map(x->calc_combination_naive(x),partitions)
    @time weights = map(x->calc_combination(x),partitions)
    println("calculating cycle lengths...")
    @time cycle_length = map(x->get_cycle(x),partitions)
    total_weight = map(x->x[1]*x[2]^2,zip(weights,cycle_length)) .// factorial(BigInt(N))
    return zip(total_weight,partitions)
end

function problem_483()
    N = 3
    println("calculating partitions...")
    partitions = find_solution_partition(N)
    println("calculating weights...")
    #weights = map(x->calc_combination_naive(x),partitions)
    weights = map(x->calc_combination(x),partitions)
    println("calculating cycle lengths...")
    cycle_length = map(x->get_cycle(x),partitions)
    println("partitions:",partitions)
    println("weights:",weights)
    println("lengths:",cycle_length)
    total_weight = sum(map(x->x[1]*x[2]^2,zip(weights,cycle_length)))
    average_weight = total_weight // factorial(BigInt(N))

    return average_weight
end

function benchmark()
    for n=5:5:100
        println(n)
        @time find_solution_partition(n)
    end
end

#println(length(find_solution_partition(7))==15)

#benchmark()
#@code_warntype find_solution_partition(7)

#solution = problem_483()
#println(solution)
#println(BigFloat(solution))
#study = study_weight_distribution()
calc_combination([(22, 1), (1, 2), (1, 3), (2, 4), (1, 5), (1, 6), (1, 34)])