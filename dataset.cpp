#include <iostream>
#include <set>
#include <map>
#include <sstream>
#include <fstream>
#include <vector>
using namespace std;

using ll = int;
using vi = vector<ll>;
using vvi = vector<vi>;

struct Pac{
    string id, gen;
    int n;
};

vector<Pac> ds;
set<string> gens_, id_;
map<string, int> gens, id;
vvi db;

void read_dataset(const string& filename){
    ifstream in(filename);
    string line;
    getline(in, line); // col names
    while (getline(in, line)){
        stringstream ss(line);
        Pac p;
        int basura; ss >> basura;
        ss >> p.id >> p.gen >> p.n;
        ds.push_back(p);
        gens_.insert(p.gen);
        id_.insert(p.id);
    }
}

void modify_dataset(){
    int i = 0;
    for (auto it = gens_.begin(); it != gens_.end(); it++) gens[*it] = i++;
    i = 0;
    for (auto it = id_.begin(); it != id_.end(); it++) id[*it] = i++;
    db = vvi(id.size(), vi(gens.size(), 0));
    for (Pac p : ds) {
        db[id[p.id]][gens[p.gen]] = p.n; 
    }
}

void print_dataset(const string& filename){
    ofstream myfile; myfile.open (filename);
    myfile << "id";
    for (auto it2 = gens.begin(); it2 != gens.end(); it2++) myfile << ',' << it2->first;
    myfile << endl;
    for (auto it = id.begin(); it != id.end(); it++){
        myfile << it->first;
        for (auto it2 = gens.begin(); it2 != gens.end(); it2++){
            myfile << ',' << db[it->second][it2->second];
        }
        myfile << endl;
    }
}

int main(){
    read_dataset("kmeans.txt");
    modify_dataset();
    print_dataset("kmeans.csv");
}
