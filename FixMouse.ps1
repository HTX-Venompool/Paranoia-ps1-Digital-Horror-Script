Add-Type @"
using System;
using System.Runtime.InteropServices;
public class Mouse {
[DllImport("user32.dll")]
public static extern bool SwapMouseButton(bool fSwap);
}
"@
[Mouse]::SwapMouseButton($false) | out-null
exit