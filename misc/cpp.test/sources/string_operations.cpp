#include "string_operations.h"
#include <string>

using namespace std;

string rmfrontspaces(string in_string)
{
  string out_string = in_string;
  while (out_string.substr(0,1) == " ")
    {
      out_string.erase(0,1);
    }
  return(out_string);
}
