//---------------------------------------------------------------------------

#include <vcl.h>
#pragma hdrstop
USERES("JvBDEC5D.res");
USEUNIT("..\..\design\JvBDESecurityEditor.pas");
USEUNIT("..\..\design\JvBDEEditors.pas");
USEUNIT("..\..\design\JvBDEMemTableEditor.pas");
USEUNIT("..\..\design\JvBDEReg.pas");
USEPACKAGE("CJCL50.bpi");
USEPACKAGE("JvSystemC5R.bpi");
USEPACKAGE("JvDlgsC5R.bpi");
USEPACKAGE("JvStdCtrlsC5R.bpi");
USEPACKAGE("JvDBC5R.bpi");
USEPACKAGE("JvBDEC5R.bpi");
USEPACKAGE("JvDBC5D.bpi");
USEPACKAGE("JvCoreC5R.bpi");
USEPACKAGE("dcldb50.bpi");
USEPACKAGE("vcl50.bpi");
USEPACKAGE("vcldb50.bpi");
USEPACKAGE("vclbde50.bpi");
USEPACKAGE("bcbsmp50.bpi");

#pragma package(smart_init)
//---------------------------------------------------------------------------

//   Package source.
//---------------------------------------------------------------------------

#pragma argsused
int WINAPI DllEntryPoint(HINSTANCE hinst, unsigned long reason, void*)
{
        return 1;
}
//---------------------------------------------------------------------------

