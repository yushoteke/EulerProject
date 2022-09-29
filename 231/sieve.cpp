/*
    In this file, attempt to create an efficient data structure
    for representing the results of sieve of erathosthenes.

    The idea is as follows: suppose we want to sieve up to N.
    Then create an 2d array [N,M], where M is the index of the
    smallest primorial that's larger than N.
    At the same time, keep a table of prime powers, so that when we're sieving,
    we always stack prime powers, for easy future reference.
*/
#include <memory>
#include <unordered_map>
#include <utility>
#include <iostream>
#include <vector>
using namespace std;

class prime_factor_table
{
private:
    int **sieve_table;
    int log_primorial;
    int N;
    unordered_map<int, pair<int, int>> prime_powers;

public:
    prime_factor_table(int N)
    {
        this->N = N;
        int first_primes[25] = {2, 3, 5, 7, 11, 13, 17, 19, 23,
                                29, 31, 37, 41, 43, 47, 53, 59,
                                61, 67, 71, 73, 79, 83, 89, 97};

        long long tmp = 1;
        for (int i = 0; i < 25; i++)
        {
            if (tmp >= N)
            {
                log_primorial = i + 1;
                break;
            }
            else
            {
                tmp *= first_primes[i];
            }
        }

        cout << "initializing sieve table..." << endl;
        sieve_table = new int *[N];
        for (int i = 0; i < N; i++)
        {
            sieve_table[i] = new int[log_primorial];
            for (int j = 0; j < log_primorial; j++)
            {
                sieve_table[i][j] = 0;
            }
        }
        

        // initialize the table to sieve
        cout <<  "initializing table..." << endl;
        vector<int> table;
        for (int i = 0; i < N; i++)
        {
            table.push_back(i);
        }

        cout << "sieving table..." << endl;
        for (int i = 2; i < N; i++)
        {
            if(i%100000==0){
                cout << i << " ";
            }

            int factor = table[i];
            if (table[i] == 1)
            {
                continue;
            }
            // check whether factor is registered in prime power table
            // if not, then factor is prime
            if (prime_powers.find(factor) == prime_powers.end())
            {
                long long tmp = 1;
                for (int k = 1; k < 65; k++)
                {
                    tmp *= factor;
                    prime_powers[tmp] = make_pair(factor, k);
                }
            }

            for (int j = i; j < N; j += i)
            {
                table[j] /= factor;
                for (int k = 0; k < log_primorial; k++)
                {
                    if (sieve_table[j][k] == 0)
                    {
                        sieve_table[j][k] = factor;
                        break;
                    }
                    else if (sieve_table[j][k] % factor == 0)
                    {
                        sieve_table[j][k] *= factor;
                        break;
                    }
                }
            }
        }
    }
    ~prime_factor_table()
    {
        for (int i = 0; i < N; ++i)
        {
            delete[] sieve_table[i]; // deletes an inner array of integer;
        }

        delete[] sieve_table; // delete pointer holding array of pointers;
    }
    void print_prime_table()
    {
        for (int i = 2; i < N; i++)
        {
            cout << i << ":";
            for (int j = 0; j < log_primorial; j++)
            {
                if (sieve_table[i][j] != 0)
                {
                    cout << sieve_table[i][j] << " ";
                }
                else
                {
                    break;
                }
            }
            cout << endl;
        }
    }
    void get_prime_power_factor(vector<pair<int,int>> &v,int k){
        // push the prime power factors of k into the back of v
        // if k is too big, do nothing
        if (k >= N || k < 2)
        {
            return;
        }
        for (int i = 0; i < log_primorial; i++)
        {
            if (sieve_table[k][i] != 0)
            {
                int tmp = sieve_table[k][i];
                v.push_back(prime_powers[tmp]);
            }
            else
            {
                return;
            }
        }
    }
    void get_prime_power_factor(vector<int> &v, int k)
    {
        // push the prime power factors of k into the back of v
        // if k is too big, do nothing
        if (k >= N || k < 2)
        {
            return;
        }
        for (int i = 0; i < log_primorial; i++)
        {
            if (sieve_table[k][i] != 0)
            {
                v.push_back(sieve_table[k][i]);
            }
            else
            {
                return;
            }
        }
    }
    pair<int, int> query_prime_power(int k)
    {
        //if k is prime power, return the corresponding pair (p,n) such that k=p^n
        //else return (-1,-1)
        if (k >= N || k < 2)
        {
            return make_pair(-1,-1);
        }
        if (prime_powers.find(k) != prime_powers.end()){
            return prime_powers[k];
        }else{
            return make_pair(-1,-1);
        }
    }
};

int main()
{
    /*
    prime_factor_table t = prime_factor_table(10000);
    // t.print_prime_table();
    vector<int> v = vector<int>();
    t.get_prime_power_factor(v, 4983);
    for (int i = 0; i < v.size(); i++)
    {
        cout << v[i] << " ";
    }
    auto factor151 = t.query_prime_power(151);
    cout <<"151:" << factor151.first << "^" << factor151.second;
    */

   int N =20000000;
    int K = 15000000;

    prime_factor_table tt = prime_factor_table(N+2);
    unordered_map<int,int> p_n;
    //find prime factors of \binom{20000000}{15000000}
    vector< pair<int,int> > w;
    
    
    for (int i=K+1;i<N+1;i++){
        w.clear();
        tt.get_prime_power_factor(w,i);
        for (int j=0;j<w.size();j++){
            if (p_n.find(w[j].first)==p_n.end()){
                p_n[w[j].first] = 0;
            }
            p_n[w[j].first] += w[j].second;
        }
    }

    for (int i=2;i<N-K+1;i++){
        w.clear();
        tt.get_prime_power_factor(w,i);
        for (int j=0;j<w.size();j++){
            if (p_n.find(w[j].first)==p_n.end()){
                p_n[w[j].first] = 0;
            }
            p_n[w[j].first] -= w[j].second;
        }
    }

    long long result = 0;
    cout << endl;
    for (auto it:p_n){
        //cout << it.first << " " << it.second << endl;
        result += it.first * it.second;
    }
    cout << "result:" << result << endl;
    return 0;
}