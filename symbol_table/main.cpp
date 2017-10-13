#include <iostream>
#include <fstream>
#include <malloc.h>
#include <sstream>
using namespace std;

int hash_buckets;
bool scope_flag;

class Symbol_info   {
    public:
        string symbol, symbol_type;
        Symbol_info *next;

};

class Symbol_table  {
    public:
        Symbol_info* arr[7];

        bool lookup(int count,string s) {
            ofstream outfile;
            outfile.open("output.txt", ios::app);

            int flag=0;
            Symbol_info *cur = arr[count];
            while(cur) {
                if(cur->symbol==s) {
                    flag=1;
                    //cout <<"Symbol found: " <<cur->symbol<<endl;  
                    outfile <<"Symbol found: " <<cur->symbol<<endl<< endl;
                    break;
                }
                cur=cur->next;

            } 
            
            if(flag==1) {
                return true;
            }
            else
            {
                //cout<< s << " Symbol not found"<< endl;
                outfile<< "Symbol not found\n"<< endl;
                return false;
            }

            outfile.close();
        }

        void remove(int count,string s) {
            ofstream outfile;
            outfile.open("output.txt", ios::app);

            int flag=0;
            Symbol_info *cur = arr[count];
            while(cur) {
                if(cur->symbol==s)
                {
                    flag=1;
                    //cout <<"\nSymbol found: " <<cur->symbol<<endl;  
                    outfile <<"Symbol found:" <<cur->symbol<<". Deleting."<< endl<< endl;
                    arr[count] = NULL;
                    break;

                }
                cur=cur->next;

            }

            if(flag==1) {
                //cout<< s<< " Deleted"<< endl;
                outfile.close();
            }

            else {
                //cout<< s << " Symbol not found, Cannot delete"<< endl;
                outfile<< "Symbol not found, Cannot delete\n"<< endl;
            }
        }


        void insert(string s1,string s2, int hash_buckets)        {
            /// should return a hash key where to insert
            /// cur is the position of has in the table
            int count;
            count= hash_key(s1, hash_buckets);

            Symbol_info *cur = arr[count];

            if(cur!=NULL) {
                bool search=lookup(count,s1);

                if(search) {
                    ofstream outfile;
                    outfile.open("output.txt", ios::app);
                    outfile <<"The symbol "<< s1<< " already exists at " <<count <<endl<< endl;
                    outfile.close();
                } else {
                    int level = 0;
                    
                    while(cur) {
                        if(cur->next!=NULL) {
                            cur=cur->next;
                            level++;
                        }
                        else {
                            Symbol_info *newOb=new Symbol_info;
                            newOb->symbol=s1;
                            newOb->symbol_type=s2;
                            cur->next=newOb;

                            cur->next->next=NULL;

                            ofstream outfile;
                            outfile.open("output.txt", ios::app);
                            outfile<< s1<< " Inserted in"<< " ScopeTable# 1"<< " at position "<< count<< ", "<< level<< endl<<endl; 
                            outfile.close();

    //                        string temp = s2.substr(0, s2.size()-1);
                            //cout<< "< "<< s1<<", "<< temp<< " >"<< " inserted"<< endl;

                            break;
                        }

                    }
                }

            }
            else {
                arr[count]=new Symbol_info;

                arr[count]->symbol=s1;
                arr[count]->symbol_type=s2;
                arr[count]->next=NULL;

                ofstream outfile;
                outfile.open("output.txt", ios::app);
                outfile<< s1<< " Inserted in"<< " ScopeTable# 1"<< " at position "<< count<< ", 0"<< endl<< endl;
                outfile.close();

//                string temp = s2.substr(0, s2.size()-1);
                //cout<< "< "<< s1<<", "<< temp<< " >"<< " inserted"<< endl;


            }

        }

        //    void insert(string s1,string s2)
        //    {
        //        /// should return a hash key where to insert
        //        int count;
        //
        //        count=hash_key(s1,7);
        //
        //
        //        Symbol_info *cur = arr[count];
        //
        //        if(cur!=NULL)
        //        {
        //
        //            //bool search=lookup(count,s1);
        //
        //            /*if(search)/// the symbol is already in the table
        //            {
        //                cout <<"(The symbol is already exists)"<<count<<endl;
        //            }
        //            else
        //            {*/
        //
        //            Symbol_info *newOb=new Symbol_info;
        //            newOb->symbol=s1;
        //            newOb->symbol_type=s2;
        //            cur->next=newOb;
        //
        //            while(cur)
        //            {
        //                if(cur->next!=NULL)
        //                {
        //                    cur=cur->next;
        //                }
        //                else
        //                {
        //                    cur->next=NULL;
        //
        //                    string temp = s2.substr(0, s2.size()-1);
        //                    cout<< "< "<< s1<<", "<< temp<< " >"<< " inserted"<< endl;
        //
        //                    break;
        //                }
        //
        //            }
        //            //}
        //
        //        }
        //        else
        //        {
        //
        //            arr[count]=new Symbol_info;
        //
        //            arr[count]->symbol=s1;
        //            arr[count]->symbol_type=s2;
        //            arr[count]->next=NULL;
        //
        //            string temp = s2.substr(0, s2.size()-1);
        //            cout<< "< "<< s1<<", "<< temp<< " >"<< " inserted"<< endl;
        //
        //
        //        }
        //
        //    }

        void print() {
            ofstream outfile;
            outfile.open("output.txt", ios::app);

            for(int i=0;i<7;i++)
            {
                Symbol_info *cur = arr[i];
                if(cur) {
                    outfile<< i;
                    while(cur) {
                        outfile<< " -->"<< cur->symbol<< " "<< cur->symbol_type;
                            //outfile << "("<<cur->symbol<<","<<cur->symbol_type<<")->";
                            //outfile <<cur->symbol<<","<<cur->symbol_type<< endl;

                        //string st=cur->symbol+","+cur->symbol_type;
                            //cout << st<<endl;
                            //cout <<"-->"<<endl;
                            //cout << "("<<cur->symbol<<","<<cur->symbol_type<<")->";

                        cur=cur->next;

                            //cout<< cur->symbol;
        //                    if(!cur)
        //                    {
        //                        //outfile <<"NULL";
        //                        //cout << "NULL";
        //                    }

                        }
                }

                else {
                    outfile<< i<< "-->"<< endl;
                }

                if(arr[i]) {
                    outfile <<endl;
                }

            }


            outfile<< endl;
            outfile.close();
        }

        /// return the hash key for the string
        int hash_key(string word,unsigned int hashtable_size)
        {
            unsigned int counter, hashAddress =0;
            for (counter =0; word[counter]!='\0'; counter++)
            {

                hashAddress = word[counter] + (hashAddress << 7) + (hashAddress << 17) - hashAddress;
            }
            return (hashAddress%hashtable_size);
        }

};      //End of symboltable class

int main() {
    string temp;
    fstream datafile("input.txt", ios::in);
    string input0, input1, input2;

    Symbol_table obtable;
    Symbol_table obtable2;

    ofstream outfile;
    outfile.open("output.txt", ios::out);
    outfile.close();

    for (int i = 0; i < 7; i++) {
        obtable.arr[i] = NULL;  
    }

    for (int i = 0; i < 7; i++) {
        obtable2.arr[i] = NULL;  
    }

    if (!datafile) {
        cout << "can't open file" << endl;
        return 0;

    }

    getline(datafile, temp, '\n');
    hash_buckets = stoi(temp);

    stringstream ss;
    string line;

    if (datafile) {
        while (getline(datafile, line)) {
            ofstream outfile;
            outfile.open("output.txt", ios::app);

            outfile<< line<< endl;
            outfile.close();
            ss << line;
            while (getline(ss, input0, ' ')) {

                if (input0 == "P") {
                    obtable.print();
                }

                else if (input0 == "I") {
                    getline(ss, input1, ' ');
                    getline(ss, input2);

                    if (input1 != "" && input2 != "" ) {
                        if (scope_flag){
                            obtable.insert(input1, input2, hash_buckets);
                        } else {
                            obtable2.insert(input1, input2, hash_buckets);
                        }
                        input1 = "";
                        input2 = "";
                    }
                    //else if (!hash_buckets)
                        //cout << "Symbol table full cannot insert " << input1<< endl;

                } else if (input0 == "L") {
                    getline(ss, input1, '\n');
                    input1.pop_back();
                    int count2 = obtable.hash_key(input1, 7);
                    obtable.lookup(count2, input1);
                    input1 = "";
                }

                else if (input0 == "D"){
                    getline (ss, input1, '\n');
                    input1.pop_back();
                    int count2 = obtable.hash_key(input1, 7);
                    obtable.remove(count2, input1);
                    input1 = "";
                }

                else if (input0 == "S"){
                    scope_flag = 1;
                }

                else if (input0 == "E"){
                    scope_flag = 0;
                }

            }       /// End of while

            ss.clear();
        }           /// End of while

    }

    //int choice;
/*
 *    while (true) {
 *        cout << "\n1.insert\n2.lookup\n3.print\n4.Delete\n5.other number to exit\nEnter choice:";
 *        cin >> choice;
 *        switch (choice) {
 *            case 1: {
 *                        cout << "Input1:";
 *                        cin >> input1;
 *                        cout << "Input2:";
 *                        cin >> input2;
 *                        obtable.insert(input1, input2);
 *                        break;
 *                    }
 *
 *            case 2: {
 *                        cout << "Enter:";
 *                        cin >> input1;
 *                        int count2 = obtable.hash_key(input1, 7);
 *                        obtable.lookup(count2, input1);
 *                        break;
 *                    }
 *
 *            case 3: {
 *                        obtable.print();
 *                        break;
 *                    }
 *            case 4: {
 *                        cout << "Enter:";
 *                        cin >> input1;
 *                        int count2 = obtable.hash_key(input1, 7);
 *                        obtable.remove(count2, input1);
 *                        break;
 *                    }
 *            default: {
 *                         return 0;
 *                     }
 *
 *        }
 *    }
 */


}

