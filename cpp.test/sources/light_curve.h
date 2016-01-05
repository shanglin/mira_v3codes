#include <string>

using namespace std;

class lightcurve
{
public:
  string id;
  string sid = "";
  int n_obs;
  float f_true = -1;
  vector<double> mjd;
  vector<double> mag;
  vector<double> err;
};
