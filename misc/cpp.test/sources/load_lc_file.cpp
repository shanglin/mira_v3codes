#include <iostream>
#include <fstream>
#include <string>
#include <vector>
#include "light_curve.h"
#include "string_operations.h"

using namespace std;

lightcurve load_lc_file (string f_lc)
{
  string delimiter = " ";
  string line, firstline, tsstring;
  int header,isub;
  int iline,n_obs;

  // check if header exists, and count number of observations
  ifstream cntmyfile(f_lc);
  if (cntmyfile.is_open())
    {
      getline(cntmyfile,firstline);
      string rest_string = rmfrontspaces(firstline);
      header = 1;
      if (rest_string.substr(0,1) == "-")
	{
	  header = 0;
	}
      for (isub=0;isub<=9;isub++)
	{
	  tsstring = to_string(isub);
	  if (rest_string.substr(0,1) == tsstring)
	    {
	      header = 0;
	    }
	}
      
      cntmyfile.unsetf(ios_base::skipws);
      n_obs = count(istream_iterator<char>(cntmyfile),istream_iterator<char>(), '\n');
      if (header == 0)
	{
	  n_obs = n_obs + 1;
	}
      cntmyfile.close();
    }
  else cout << "Unable to open file " << f_lc << "\n";

  
  // Load into light curve object
  vector<double> mjds (n_obs);
  vector<double> mags (n_obs);
  vector<double> errs (n_obs);

  ifstream myfile(f_lc);
  if (myfile.is_open())
    {
      lightcurve lc;
      if (header == 1)
	{
	  getline(myfile,line);
	}
      for (iline=0; iline < n_obs; iline++)
	{
	  getline(myfile,line);
	  string rest_string = rmfrontspaces(line);
	  mjds[iline] = stod(rest_string);
	  rest_string = rmfrontspaces(rest_string.substr(rest_string.find(delimiter),rest_string.length()));
	  mags[iline] = stod(rest_string);
	  rest_string = rmfrontspaces(rest_string.substr(rest_string.find(delimiter),rest_string.length()));
	  errs[iline] = stod(rest_string);
	}
      myfile.close();
    }
  else cout << "Unable to open file " << f_lc << "\n";
  lightcurve lc;
  lc.id = f_lc;
  lc.n_obs = n_obs;
  lc.mjd = mjds;
  lc.mag = mags;
  lc.err = errs;
  
  return lc;
}
