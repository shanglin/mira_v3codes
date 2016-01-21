#include <iostream>
#include <fstream>
#include <string>
#include <vector>

using namespace std;

class lightcurve
{
private:
  vector<double> mjd;
  vector<double> mag;
  vector<double> err;
};

string rmfrontspaces(string in_string)
{
  string out_string = in_string;
  while (out_string.substr(0,1) == " ")
    {
      out_string.erase(0,1);
    }
  return(out_string);
}

int main()
{
  string f_flc = "flcs/test.flc";
  string delimiter = " ";
  string line;
  string firstline;
  string tsstring;
  int header,isub;
  int iline,n_obs;

  // Count file lines && check header exists
  ifstream cntmyfile(f_flc);
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
  else cout << "Unable to open file " << f_flc << "\n";

  vector<double> mjds (n_obs);
  vector<double> mags (n_obs);
  vector<double> errs (n_obs);
  
  // Load into light curve object
  ifstream myfile(f_flc);
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
  else cout << "Unable to open file " << f_flc << "\n";
  return 0;
}
