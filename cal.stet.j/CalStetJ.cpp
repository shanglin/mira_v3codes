#include <iostream>
#include <fstream>
#include <string>
#include <vector>
#include <math.h>

using namespace std;

template <typename T> int sgn(T val) {
    return (T(0) < val) - (val < T(0));
}


// Some string operations to deal with file names and file headers
string rm_front_spaces(string in_string) {
  string out_string = in_string;
  while (out_string.substr(0,1) == " ") {
      out_string.erase(0,1);
    }
  return(out_string);
}

string trim_path_from_file_name(string in_string) {
  string out_string = in_string;
  size_t slash_pos = in_string.find_last_of("/\\");
  return(out_string.substr(slash_pos+1));
}

string rm_last_if_slash(string in_string) {
  string out_string = in_string;
  if (in_string.substr(in_string.size()-1) == "/")
    out_string = out_string.substr(0,in_string.size()-1);
  return(in_string);
}

float calstetj(string f_lc,string delimiter) {
  string line, firstline, tsstring;
  int header, isub;
  int iline, n_obs;
  float stetj = 0;

  // (1) check if header exists, and count number of observations
  ifstream cntmyfile(f_lc);
  if (cntmyfile.is_open()) {
      getline(cntmyfile,firstline);
      string rest_string = rm_front_spaces(firstline);
      header = 1;
      if (rest_string.substr(0,1) == "-")
	header = 0;
      for (isub=0;isub<=9;isub++) {
	tsstring = to_string(isub);
	if (rest_string.substr(0,1) == tsstring)
	  header = 0;
      }
	    
      cntmyfile.unsetf(ios_base::skipws);
      n_obs = count(istream_iterator<char>(cntmyfile),
		   istream_iterator<char>(), '\n');
      if (header == 0)
	n_obs = n_obs + 1;
      cntmyfile.close();
  } else {
    cout << "Unable to open file " << f_lc << "\n";
    abort();
  }
  // (2) load file
  vector<float> mjds (n_obs);
  vector<float> mags (n_obs);
  vector<float> errs (n_obs);
  
  ifstream lcfile(f_lc);
  if (header == 1)
    getline(lcfile,line);
  for (iline=0; iline < n_obs; iline++) {
    getline(lcfile,line);
    string rest_string = rm_front_spaces(line);
    mjds[iline] = stod(rest_string);
    rest_string = rm_front_spaces(rest_string.substr(rest_string.find(delimiter),rest_string.length()));
    mags[iline] = stod(rest_string);
    rest_string = rm_front_spaces(rest_string.substr(rest_string.find(delimiter),rest_string.length()));
    errs[iline] = stod(rest_string);
  }
  lcfile.close();
  if (n_obs < 5)
    stetj = -99.999;
  else {
    // (3) calculate stetson's J index
    float sum_mag = 0, sum_err = 0, mean_mag;
    float sqrt_nobs_s = float(n_obs)/(n_obs - 1);
    float p_i;
    for (iline = 0; iline < n_obs; iline++) {
      sum_mag = sum_mag + mags[iline] / (errs[iline] * errs[iline]);
      sum_err = sum_err + 1./(errs[iline] * errs[iline]);
    }
    mean_mag = sum_mag/sum_err;
    for (iline = 0; iline < n_obs; iline++) {
      p_i = sqrt_nobs_s * ((mags[iline] - mean_mag) / errs[iline]) * ((mags[iline] - mean_mag) / errs[iline]) - 1;
      stetj = stetj + sgn(p_i) * sqrt(fabs(p_i));
    }
    stetj = stetj / n_obs;
  }
  return stetj;
}


int main(int argc, char* argv[ ]) {
  
  string delimiter = " "; // delimiter for the input light curve file. " " is good enough for multiple-space delimited files
  string output_dir = "./"; // directory that used to save output files (frequency spectra)
  string output_extension = ".variabilityJ.dat"; // extension of output file names.

  string model_name = argv[0];
  string syntax_prom = "********** Syntax ***********\n ./" 
    + model_name + 
    " -f light_curve_file_name (Compute a single light curve) \n OR \n ./"
    + model_name + 
    " -l list_file_name (Compute a list of light curves)\n*****************************\n";

 
  if (argc > 2) {
    string f_lc, f_list, file_type = argv[1];
    string f_output, f_lc_trim, shell_command;
    float stetj;
      
    output_dir = rm_last_if_slash(output_dir);
    shell_command = "mkdir -p " + output_dir;
    const char *ts_command = shell_command.c_str();
    system(ts_command);

    if (file_type == "-f") {
      
      f_lc = argv[2];
      stetj = calstetj(f_lc,delimiter);
      cout << "   >> J = " << stetj << "\n";
      
    } else if (file_type == "-l") {
      
      f_list = argv[2];
      ifstream list_file (f_list);
      if (list_file.is_open()) {
	unsigned counter = 0;
	while (!list_file.eof()) {
	  list_file >> f_lc;
	  stetj = calstetj(f_lc,delimiter);
	  cout << f_lc << " " << stetj << "\n";
	  // counter++;
	  // string f_status = f_list + ".status.txt";
	  // ofstream out_status(f_status);
	  // out_status << counter << "   " << f_lc_trim << "\n";
	  // out_status.close();
	  // cout << counter << "   " << f_lc_trim << "\n";
	}
	list_file.close();
      } else {
	  cout << "Cannot open file " << f_list << ". Please double check the file name.\n";
	  abort();
      }
    } else
      cout << syntax_prom;
  }
  else 
    cout << syntax_prom;
  return 0; 
}  
