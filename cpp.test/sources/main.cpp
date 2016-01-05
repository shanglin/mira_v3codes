#include <iostream>
#include <fstream>
#include <string>
#include <vector>
#include <iomanip>
#include "string_operations.h"
#include "light_curve.h"

using namespace std;

int main(int argc, char* argv[ ])
{
  if (argc >1)
    {
      string f_lc = argv[1];
      lightcurve lc;
      lightcurve load_lc_file (string f_lc);
      lc = load_lc_file(f_lc);
      ofstream myfile ("example.txt");
      if (myfile.is_open())
	{
	  for (int i=0;i<lc.n_obs;i++)
	    {
	      double value = lc.mjd[i];
	      myfile << fixed << setprecision(8) << value << "\n";
	    }
	  myfile.close();
	}   
    }
  else {
    cout << "Syntax: ./MiraStar light_curve_file_name [other arguments] \n";
      }
  return 0; 
}


  
