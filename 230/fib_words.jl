
A = "1415926535"
B = "8979323846"

struct letter_finder
    A::String
    B::String
    L::Integer
    fib_table::Vector{Int128}
end

function letter_finder(A::String,B::String)
    l = [Int128(1),Int128(1)]

    while l[end] + l[end-1] > 0
        push!(l,l[end] + l[end-1])
    end
    
    return letter_finder(A,B,length(A),l)
end

function find_letter_helper(lf::letter_finder,n,i)
    if i == 1
        return Int(lf.A[n]) - 48
    elseif i == 2
        return Int(lf.B[n]) - 48
    end
    tmp = BigInt(lf.fib_table[i-2]) * lf.L
    if n > tmp
        return find_letter_helper(lf,n-tmp,i-1)
    else
        return find_letter_helper(lf,n,i-2)
    end
end

#suppose A,B have same length
function find_letter(lf::letter_finder,n)
    for i=3:170
        if n <= BigInt(lf.fib_table[i]) * lf.L
            return find_letter_helper(lf,n,i)
        end
    end
end

lf = letter_finder(A,B)
print(find_letter(lf,35))

A = "1415926535897932384626433832795028841971693993751058209749445923078164062862089986280348253421170679"
B = "8214808651328230664709384460955058223172535940812848111745028410270193852110555964462294895493038196"
lf = letter_finder(A,B)

tmp = BigInt(0)
for n=0:17
    tmp += 10^n * find_letter(lf,(127+19*n)*7^n)
end
print(tmp)