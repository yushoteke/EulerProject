largest = 1929394959697989990
smallest = 1020304050607080990

upper_bound = Int(ceil(sqrt(largest)))
lower_bound = Int(floor(sqrt(smallest)))

#1389026624
#101010101010

threshold = 111000000
for i=1010101010:10:1389026624
    tmp = string(i^2)
    if (tmp[1]=='1' &&
        tmp[3]=='2' && 
        tmp[5]=='3' && 
        tmp[7]=='4' && 
        tmp[9]=='5' && 
        tmp[11]=='6' && 
        tmp[13]=='7' && 
        tmp[15]=='8' && 
        tmp[17]=='9' && 
        tmp[19]=='0' )
        println(tmp," ",i)
        break
    end
    if i > threshold
        println(i)
        threshold += 10000000
    end
end
