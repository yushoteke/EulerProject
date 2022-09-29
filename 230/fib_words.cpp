#include <string>
#include <iostream>

using namespace std;

class fib_letter_finder
{
private:
    string A;
    string B;
    int l;
    long long fib[90];
    long long find_letter_helper(long long n, int i)
    {
        // assume the boundary conditions are taken care of
        // in the public method
        // Assume A is 0th, B is 1st
        if (i==0){
            //cout << A[n-1];
            return ((long long)A[n-1]) - 48;
        }else if (i==1){
            return ((long long)B[n-1]) - 48;
        }
        if (n > fib[i-2] * l){
            return find_letter_helper(n-fib[i-2]*l,i-1);
        }else{
            return find_letter_helper(n,i-2);
        }
        //return 0;
    }

public:
    fib_letter_finder(string A, string B)
    {
        //assume A and B are same size
        this->A = A;
        this->B = B;
        l = A.size();
        fib[0] = 1;
        fib[1] = 1;
        for (int i=2;i<90;i++){
            fib[i] = fib[i-1] + fib[i-2];
        }
    }
    long long find_nth_letter(long long n)
    {
        /*
        Fibonacci words are made by concatenating previous two words.
        The first few are A,B,AB,BAB,ABBAB,BABABBAB and so on.
        Suppose we want to find the nth letter in the ith word, Wi.
        Wi can be broken into two parts, (W_{i-2})(W_{i-1})
        if n > len(W_{i-2}), then equivalent to find (n-len(W_{i-2}))th letter of
        W_{i-1}. Or else, equivalent to finding nth letter of W_{i-2}
        */

        
        if (n <= l){
            return (long long)A[n-1];
        }

        for (int i=2;i<90;i++){
            if (n <= fib[i] * l){
                return find_letter_helper(n,i);
            }
        }
        return 0;
    }
};

long long myPow(long long x, unsigned int p)
{
  if (p == 0) return 1;
  if (p == 1) return x;
  
  int tmp = myPow(x, p/2);
  if (p%2 == 0) return tmp * tmp;
  else return x * tmp * tmp;
}

int main()
{
    //string A = "1415926535";
    //string B = "8979323846";
    string A = "1415926535897932384626433832795028841971693993751058209749445923078164062862089986280348253421170679";
    string B = "8214808651328230664709384460955058223172535940812848111745028410270193852110555964462294895493038196";
    fib_letter_finder f = fib_letter_finder(A,B);
    //cout <<f.find_nth_letter(27) << endl;

    long long tmp = 0;
    for (int n=0;n<18;n++){
        tmp += myPow(10,n) * f.find_nth_letter((127+19*n)*myPow(7,n));
    }
    cout << tmp;
    return 0;
}