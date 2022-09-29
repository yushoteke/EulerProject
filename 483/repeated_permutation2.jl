#=
    The first filehas some performance issues.

    After analysis, I think the biggest problem is memory.
    During the search, because it is recursive, to reduce the complexity
    from exponential to subexponential, I need to store the results in a dictionary.
    However, as n gets bigger, the solution also gets subexponentially bigger. As a results,
    a lot of memory is taken up and GC takes alot of time.

    To remedy this, instead of storing the results, I'm going to store a result reconstructor,
    which stores the minimum amount of information required to reconstruct the result.

    After the search is finished, I only need to reconstruct the full table once
=#
using DataStructures

function count_num_solutions(n)
    table = Dict{typeof((1,1)),Int64}()
    return count_num_solutions_(n,n,table)
end

function count_num_solutions_(n,k,table)
    #find all non-negative solutions to
    #1*x_1+2*x_2...k*x_k=n 

    #base cases
    if n == 0 
        return 1
    elseif k > n
        return count_num_solutions_(n,n,table)
    elseif k == 1
        #since in the body, only k-1 appears, so this is a valid terminating case fo k
        return 1
    elseif haskey(table,(n,k))
        return table[(n,k)]
    end

    num_solution = 0
    for i=k:k:n
        num_solution += count_num_solutions_(n-i,k-1,table)
    end
    table[(n,k)] = num_solution

    #above loop solves the k variable situation. Keep on solving k-1 variable situation
    return num_solution + count_num_solutions_(n,k-1,table)
end

println(count_num_solutions(7))
println(count_num_solutions(8))
println(count_num_solutions(100))
println(count_num_solutions(350))

#=
    Actually, after writing a function to test the number of solutions to the equation
    1*x_1+2*x_2+3*x_3...n*x_n=n

    The number of non-negative solutions is 14779002588763

    The previous approach is beyond unrealistic.
    Need to actually solve this mathematically.
=#

@time count_num_solutions(350)

function count_num_restricted(N)
    #count the number of solutions to 1*x_1+2*x_2+3*x_3...n*x_n=n
    #where x_1<=r_1,x_2<=r_2...x_n<=r_n
    restriction = Dict(1=>30,2=>24,3=>22,4=>20,5=>19,6=>19,7=>18,8=>18,9=>17,10=>17,
                        11=>17,12=>16,13=>16,14=>16,15=>16)
    for i=16:23
        restriction[i] = 15
    end
    table = Dict{typeof((1,1)),Int64}()
    return count_num_restricted_(N,N,table,DefaultDict(N,restriction))
end

function count_num_restricted_(n,k,table,restriction)
    if k > n
        return count_num_restricted_(n,n,table,restriction)
    elseif k == 1
        return restriction[k] < n ? 0 : 1
    elseif n == 0
        return 1
    elseif haskey(table,(n,k))
        return table[(n,k)]
    end

    num_solution = 0
    for i=k:k:n
        if restriction[k] < (i÷k)
            break
        end
        num_solution += count_num_restricted_(n-i,k-1,table,restriction)
    end
    table[(n,k)] = num_solution

    return num_solution + count_num_restricted_(n,k-1,table,restriction)
end

println(count_num_restricted(350))


