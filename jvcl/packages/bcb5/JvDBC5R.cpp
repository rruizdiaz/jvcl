//---------------------------------------------------------------------------

#include <vcl.h>
#pragma hdrstop
USERES("JvDBC5R.res");
USEUNIT("..\..\run\JvMemoryDataset.pas");
USEUNIT("..\..\run\JvCsvData.pas");
USEUNIT("..\..\run\JvCsvParse.pas");
USEUNIT("..\..\run\JvDBCombobox.pas");
USEUNIT("..\..\run\JvDBControls.pas");
USEUNIT("..\..\run\JvDBDatePickerEdit.pas");
USEUNIT("..\..\run\JvDBDateTimePicker.pas");
USEUNIT("..\..\run\JvDBLookup.pas");
USEUNIT("..\..\run\JvDBLookupTreeView.pas");
USEUNIT("..\..\run\JvDBProgressBar.pas");
USEUNIT("..\..\run\JvDBQueryParamsForm.pas");
USEUNIT("..\..\run\JvDBRadioPanel.pas");
USEUNIT("..\..\run\JvDBRemoteLogin.pas");
USEUNIT("..\..\run\JvDBRichEdit.pas");
USEUNIT("..\..\run\JvDBSpinEdit.pas");
USEUNIT("..\..\run\JvDBTreeView.pas");
USEUNIT("..\..\run\JvDBUtils.pas");
USEUNIT("..\..\run\JvDBLookupComboEdit.pas");
USEUNIT("..\..\common\JvDBConsts.pas");
USEPACKAGE("CJCL50.bpi");
USEPACKAGE("JvStdCtrlsC5R.bpi");
USEPACKAGE("JvSystemC5R.bpi");
USEPACKAGE("JvCoreC5R.bpi");
USEPACKAGE("vcl50.bpi");
USEPACKAGE("vcldb50.bpi");
USEPACKAGE("bcbsmp50.bpi");
USEPACKAGE("bcbie50.bpi");
//---------------------------------------------------------------------------
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
