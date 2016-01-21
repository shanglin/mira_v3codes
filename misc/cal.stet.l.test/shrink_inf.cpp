#include <iostream>
#include <fstream>
#include <string>

using namespace std;

int main(int argc, char* argv[ ]) {
  if (argc != 2) {
    cout << " Please feed with .inf file name.\n";
    abort();
  } else {
    int n_lines, iline;
    string f_inf, line, frame, jd;
    
    f_inf = argv[1];
    ifstream cntmyfile(f_inf);
    if (cntmyfile.is_open()) {
      cntmyfile.unsetf(ios_base::skipws);
      n_lines = count(istream_iterator<char>(cntmyfile),
		      istream_iterator<char>(), '\n');
      cntmyfile.close();
    } else {
      cout << "Cannot open file " << f_inf << endl;
      abort();
    }
    ifstream myfile(f_inf);
    for (iline=0; iline < n_lines; iline++) {
      getline(myfile, line);
      frame = line.substr(0,15);
      jd = line.substr(65,12);
      cout << frame << jd << endl;
    }
    myfile.close();
  }
}
	
      
