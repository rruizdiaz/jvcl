//---------------------------------------------------------------------------

#include <vcl.h>
#pragma hdrstop
USERES("JvMMC5R.res");
USEUNIT("..\..\run\JvWavePlayer.pas");
USEUNIT("..\..\run\JvAni.pas");
USEUNIT("..\..\run\JvAniFile.pas");
USEUNIT("..\..\run\JvAnimate.pas");
USEUNIT("..\..\run\JvAnimatedImage.pas");
USEUNIT("..\..\run\JvAVICapture.pas");
USEUNIT("..\..\run\JvBmpAnimator.pas");
USEUNIT("..\..\run\JvGIF.pas");
USEUNIT("..\..\run\JvGIFCtrl.pas");
USEUNIT("..\..\run\JvGradient.pas");
USEUNIT("..\..\run\JvGradientHeaderPanel.pas");
USEUNIT("..\..\run\JvIconList.pas");
USEUNIT("..\..\run\JvId3v1.pas");
USEUNIT("..\..\run\JvId3v2.pas");
USEUNIT("..\..\run\JvID3v2Base.pas");
USEUNIT("..\..\run\JvId3v2Types.pas");
USEUNIT("..\..\run\JvImageRotate.pas");
USEUNIT("..\..\run\JvImageTransform.pas");
USEUNIT("..\..\run\JvImageWindow.pas");
USEUNIT("..\..\run\JvPcx.pas");
USEUNIT("..\..\run\JvPicClip.pas");
USEUNIT("..\..\run\JvSlider.pas");
USEUNIT("..\..\run\JvSpecialImage.pas");
USEUNIT("..\..\run\JvSpecialProgress.pas");
USEUNIT("..\..\run\JvSplashWindow.pas");
USEUNIT("..\..\run\JvStarfield.pas");
USEUNIT("..\..\run\JvVirtualKeySelectionFrame.pas");
USEUNIT("..\..\run\JvWaitingGradient.pas");
USEUNIT("..\..\run\JvWaitingProgress.pas");
USEUNIT("..\..\common\VFW.pas");
USEPACKAGE("vcl50.bpi");
USEPACKAGE("CJCL50.bpi");
USEPACKAGE("JvCoreC5R.bpi");
USEPACKAGE("bcbsmp50.bpi");
USEPACKAGE("bcbie50.bpi");
USEPACKAGE("JvSystemC5R.bpi");
USEPACKAGE("JvCtrlsC5R.bpi");
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
