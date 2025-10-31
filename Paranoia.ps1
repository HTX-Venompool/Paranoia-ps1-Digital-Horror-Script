$host.ui.RawUI.WindowTitle="Wake Up"; # DO NOT CHANGE!

# This script was created by HTX Venom
# It is intended for humorous demonstration use only
# I am not responsible for any serious damage caused by modified versions
# of this script
# You should only ever download my scripts from my official GitHub page

# Settings

# Enable/Disable Payloads
# Set to "$true" to enable and "$false" to disable

$dowindowpayload = $true; # Popup Window Payload

$doaudiopayload = $true; # Text-To-Speech Payload

$dobeeppayload = $true; # Beeping Sound Payload

$doejectpayload = $true; # Optical Drive Eject Payload

$domousepayload = $true; # Mouse Button Flip Payload

$dokeylightpayload = $true; # Keyboard Light Blink Payload

$dobrightpayload = $true; # Monitor Brightness Payload

$dowallpaperpayload = $true; # Wallpaper Change Payload

$dokeypayload = $true; # Keypress Send Payload

$dosendkeynotepad = $true; # Run Chance To Make Notepad Window Open On Keypress Payload

$dodeskfilepayload = $true; # Desktop Text File Payload

$dodocpayload = $true; # Microsoft Word Document Payload

$dospookdocsave = $true; # Run Chance To Make Word Document Save After Write

$docamerapayload = $true; # Camera App Payload

$doprintpayload = $true; # Printer Payload

$runonstartup = $true; # Make Script Run Automatically On Account Login


# Payload Chances
# Chance is 1 / (chance) to occur each roll
# Set to 1 for 100% chance, this is the minimum

$windowchance = 50; # Chance of window appearing

$audiochance = 20; # Chance of text-to-speech audio playing

$beepchance = 20; # Chance for beep sound to play

$cdejectchance = 100; # Chance for optical drives to be ejected

$mousechance = 30; # Chance of mouse buttons flipping

$keylightchance = 100; # Chance for keyboard lights to blink

$screenbrightchance = 100; # Chance for monitor brightness to change

$wallpaperchance = 500; # Chance for desktop wallpaper to be changed

$keysendchance = 250; # Chance for keypresses to be sent

$notepadchance = 5; # Chance for Notepad window to open before keypress send

$textfilechance = 200; # Chance for text file to be written to desktop

$worddocchance = 500; # Chance for Word document to open

$docsavechance = 20; # Chance for Word document to save after writing

$camerachance = 500; # Chance for camera app to be opened

$printchance = 500; # Chance for text to print from printer


# Payload Timers
# Timers count in seconds
# Minimum of 0 seconds (no pause)

$initsleepsecs = 30; # Initial Sleep Timer

$windowsecs = 3; # Window Payload Interval

$audiosecs = 5; # Text-To-Speech Audio Payload Interval

$beepsecs = 5; # Beep Payload Interval

$cdejectsecs = 5; # Optical Drive Payload Interval

$mousesecs = 3; # Mouse Button Flip Payload Interval

$keylightsecs = 5; # Keyboard Blink Payload Interval

$screenbrightsecs = 10; # Monitor Brightness Payload Interval

$wallpapersecs = 60; # Wallpaper Payload Interval

$keysendsecs = 30; # Keypress Send Payload Interval

$textfilesecs = 20; # Desktop Text File Payload Interval

$worddocsecs = 60; # Microsoft Word Document Payload Interval

$camerasecs = 60; # Camera Payload Interval

$printsecs = 60; # Printer Payload Interval


# Misc. Settings

# System Volume During Payload
# 0.01 = 1% Volume
# Minimum 0, Maximum 1
# Default 0.50
$sysvolume = 0.50;

# Text-To-Speech Audio Volume
# Minimum 0, Maximum 100
# Default 5
$voicevolume = 5;

# Text-To-Speech Speak Rate
# Minimum -10, Maximum 10
# Default 1
$voicerate = 1;

# Beep Length
# Minimum 1, Maximum 32676
# Default 200
$beeplength = 200;

# Beep Pitch
# Minimum 37, Maximum 32676
# Default 800
$beeppitch = 800;

# Keyboard Light Blink Count
# Minimum 0, Maximum 32676
# Default 20
$blinkcount = 20;

# Monitor Brightness Change Percentage
# Minimum 1, Maximum 100
# Default 5
$brightchange = 5;

# Monitor Brightness Change Direction
# "Up" to increase, "Down" to decrease, "Both" to randomly pick for increase/decrease
# Default "Both"
$brighttype = "Both";

# Wallpaper to use for wallpaper changing payload
# Must be an image file in the same folder as the Paranoia.ps1 script
# Must be set for wallpaper payload to run
$wallpaper = "ScaryFace.png";

# Wallpaper style to use for wallpaper changing payload
# Can be "Tiles", "Centered", "Stretched", "Fill", "Fit", or "Span"
# Script must be run as administrator to change wallpaper style
# Default "Centered"
$wpstyle = "Centered";

# Disable keyboard during keypress send events
# If "$true", script must be run as administrator
# Must be set for keypress payload to run
$dokeyblock = $true;

# Word Document Font
# Default "Calibri"
$fonttype = "Calibri";

# Word Document Font Size
# Minimum 1, Maximum 120
# Default 16
$fontsize = 16;

# Script

# System Audio Control Interface. Edit As Necessary.
[string]$audioclass = @'
using System.Runtime.InteropServices;

[Guid("5CDF2C82-841E-4546-9722-0CF74078229A"), InterfaceType(ComInterfaceType.InterfaceIsIUnknown)]
interface IAudioEndpointVolume {
  int f(); int g(); int h(); int i();
  int SetMasterVolumeLevelScalar(float fLevel, System.Guid pguidEventContext);
  int j();
  int GetMasterVolumeLevelScalar(out float pfLevel);
  int k(); int l(); int m(); int n();
  int SetMute([MarshalAs(UnmanagedType.Bool)] bool bMute, System.Guid pguidEventContext);
  int GetMute(out bool pbMute);
}
[Guid("D666063F-1587-4E43-81F1-B948E807363F"), InterfaceType(ComInterfaceType.InterfaceIsIUnknown)]
interface IMMDevice {
  int Activate(ref System.Guid id, int clsCtx, int activationParams, out IAudioEndpointVolume aev);
}
[Guid("A95664D2-9614-4F35-A746-DE8DB63617E6"), InterfaceType(ComInterfaceType.InterfaceIsIUnknown)]
interface IMMDeviceEnumerator {
  int f(); // Unused
  int GetDefaultAudioEndpoint(int dataFlow, int role, out IMMDevice endpoint);
}
[ComImport, Guid("BCDE0395-E52F-467C-8E3D-C4579291692E")] class MMDeviceEnumeratorComObject { }

public class Audio {
  static IAudioEndpointVolume Vol() {
    var enumerator = new MMDeviceEnumeratorComObject() as IMMDeviceEnumerator;
    IMMDevice dev = null;
    Marshal.ThrowExceptionForHR(enumerator.GetDefaultAudioEndpoint(/*eRender*/ 0, /*eMultimedia*/ 1, out dev));
    IAudioEndpointVolume epv = null;
    var epvid = typeof(IAudioEndpointVolume).GUID;
    Marshal.ThrowExceptionForHR(dev.Activate(ref epvid, /*CLSCTX_ALL*/ 23, 0, out epv));
    return epv;
  }
  public static float Volume {
    get {float v = -1; Marshal.ThrowExceptionForHR(Vol().GetMasterVolumeLevelScalar(out v)); return v;}
    set {Marshal.ThrowExceptionForHR(Vol().SetMasterVolumeLevelScalar(value, System.Guid.Empty));}
  }
  public static bool Mute {
    get { bool mute; Marshal.ThrowExceptionForHR(Vol().GetMute(out mute)); return mute; }
    set { Marshal.ThrowExceptionForHR(Vol().SetMute(value, System.Guid.Empty)); }
  }
}
'@

$spookywindow = {
param(
[Parameter(Mandatory=$true)][string]$windowtext,
[string]$windowtitle = ""
);
Add-Type -AssemblyName PresentationCore,PresentationFramework;
[System.Windows.MessageBox]::Show($windowtext,$windowtitle,"Ok") | out-null;
}

$spookywindowloop = {
param(
[Parameter(Mandatory=$true)]$spookywindow,
[Parameter(Mandatory=$true)][Validaterange(1,[int32]::MaxValue)][int32]$windowchance,
[Parameter(Mandatory=$true)][Validaterange(0,[int32]::MaxValue)][int32]$windowsecs
);
$spookywindow = [scriptblock]::Create($spookywindow);
while ($true) {
$dowindow = get-random -max $windowchance;
if ($dowindow -eq 0) {
$windowtitle = $null;
$windowtype = get-random -max 86;
if ($windowtype -eq 0) {$windowtext = "Everything is fine. Go back to work."; $windowtitle = "You are not being watched";}
elseif ($windowtype -eq 1) {$windowtext = "Do you hear the voices?";}
elseif ($windowtype -eq 2) {$windowtext = "Everything is fine. Return to your work."; $windowtitle = "I am watching";}
elseif ($windowtype -eq 3) {$windowtext = "Everything is fine. Nothing is behind you."; $windowtitle = "Do not look";}
elseif ($windowtype -eq 4) {$windowtext = "Do not look behind you. There is nothing there.";}
elseif ($windowtype -eq 5) {$windowtext = "Do not look behind you.";  $windowtitle = "I am not watching you";}
elseif ($windowtype -eq 6) {$windowtext = "There is nothing behind you.";}
elseif ($windowtype -eq 7) {$windowtext = "Look behind you.";}
elseif ($windowtype -eq 8) {$windowtext = "He is here. Look behind you.";}
elseif ($windowtype -eq 9) {$windowtext = "I am here. Look behind you";}
elseif ($windowtype -eq 10) {$windowtext = "He is here. Do not look behind you."; $windowtitle = "You are not safe";}
elseif ($windowtype -eq 11) {$windowtext = "I am here. Do not look behind you"; $windowtitle = "You are not safe";}
elseif ($windowtype -eq 12) {$windowtext = "I see you.";}
elseif ($windowtype -eq 13) {$windowtext = "I am watching you.";}
elseif ($windowtype -eq 14) {$windowtext = "I see you. I am watching.";}
elseif ($windowtype -eq 15) {$windowtext = "Do you exist?";}
elseif ($windowtype -eq 16) {$windowtext = "Are you sure you exist?";  $windowtitle = "This isn't real";}
elseif ($windowtype -eq 17) {$windowtext = "You do not exist."; $windowtitle = "Wake up";}
elseif ($windowtype -eq 18) {$windowtext = "You do not exist. Wake up."; $windowtitle = "This is a simulation";}
elseif ($windowtype -eq 19) {$windowtext = "Are you sure this is reality?"; $windowtitle = "You are dreaming";}
elseif ($windowtype -eq 20) {$windowtext = "You are not real. Wake up.";}
elseif ($windowtype -eq 21) {$windowtext = "This is not reality."; $windowtitle = "Wake up";}
elseif ($windowtype -eq 22) {$windowtext = "This is not reality. Wake up.";}
elseif ($windowtype -eq 23) {$windowtext = "None of this is real. Wake up.";}
elseif ($windowtype -eq 24) {$windowtext = "You are in a simulation. Wake up.";}
elseif ($windowtype -eq 25) {$windowtext = "Are you sure you are not in a simulation?"; $windowtitle = "Wake up";}
elseif ($windowtype -eq 26) {$windowtext = "Wake up";}
elseif ($windowtype -eq 27) {$windowtext = "Wake up Wake up Wake up Wake up Wake up";}
elseif ($windowtype -eq 28) {$windowtext = "Wake up $($Env:USERNAME).";}
elseif ($windowtype -eq 29) {$windowtext = "This is not reality. Wake up $($Env:USERNAME).";}
elseif ($windowtype -eq 30) {$windowtext = "None of this is real. Wake up $($Env:USERNAME).";}
elseif ($windowtype -eq 31) {$windowtext = "You are in a simulation. Wake up $($Env:USERNAME).";}
elseif ($windowtype -eq 32) {$windowtext = "You are not real. Wake up $($Env:USERNAME).";}
elseif ($windowtype -eq 33) {$windowtext = "You do not exist. Wake up $($Env:USERNAME).";}
elseif ($windowtype -eq 34) {$windowtext = "It is coming.";}
elseif ($windowtype -eq 35) {$windowtext = "It is coming. Be prepared.";}
elseif ($windowtype -eq 36) {$windowtext = "Be prepared. It is coming soon.";}
elseif ($windowtype -eq 37) {$windowtext = "It is coming soon.";}
elseif ($windowtype -eq 38) {$windowtext = "I am coming. Be prepared.";}
elseif ($windowtype -eq 39) {$windowtext = "I am coming.";}
elseif ($windowtype -eq 40) {$windowtext = "I am coming soon. Be prepared.";}
elseif ($windowtype -eq 41) {$windowtext = "Be prepared. I am coming soon.";}
elseif ($windowtype -eq 42) {$windowtext = "I am coming, $($Env:USERNAME). Be prepared.";}
elseif ($windowtype -eq 43) {$windowtext = "I am coming, $($Env:USERNAME).";}
elseif ($windowtype -eq 44) {$windowtext = "I am coming soon, $($Env:USERNAME). Be prepared.";}
elseif ($windowtype -eq 45) {$windowtext = "Be prepared. I am coming soon, $($Env:USERNAME).";}
elseif ($windowtype -eq 46) {$windowtext = "Nothing is watching you.";}
elseif ($windowtype -eq 47) {$windowtext = "I am not watching you.";}
elseif ($windowtype -eq 48) {$windowtext = "Nothing is watching you, $($Env:USERNAME).";}
elseif ($windowtype -eq 49) {$windowtext = "I am not watching you, $($Env:USERNAME).";}
elseif ($windowtype -eq 50) {$windowtext = "I see you, $($Env:USERNAME).";}
elseif ($windowtype -eq 51) {$windowtext = "I am watching you, $($Env:USERNAME).";}
elseif ($windowtype -eq 52) {$windowtext = "I see you, $($Env:USERNAME). I am watching.";}
elseif ($windowtype -eq 53) {$windowtext = "Do you hear the voices,$($Env:USERNAME)?";}
elseif ($windowtype -eq 54) {$windowtext = "Look behind you."; $windowtitle = "I am watching";}
elseif ($windowtype -eq 55) {$windowtext = "Look behind you."; $windowtitle = "He is here";}
elseif ($windowtype -eq 56) {$windowtext = "I am here. Look behind you";  $windowtitle = "I am watching";}
elseif ($windowtype -eq 57) {$windowtext = "He is here. Do not look behind you.";}
elseif ($windowtype -eq 58) {$windowtext = "I am here. Do not look behind you";}
elseif ($windowtype -eq 59) {$windowtext = "I see you."; $windowtitle = "Look behind you";}
elseif ($windowtype -eq 60) {$windowtext = "I am watching you."; $windowtitle = "Look behind you";}
elseif ($windowtype -eq 61) {$windowtext = "I see you. I am watching."; $windowtitle = "Look behind you";}
elseif ($windowtype -eq 62) {$windowtext = "I see you, $($Env:USERNAME)."; $windowtitle = "Look behind you";}
elseif ($windowtype -eq 63) {$windowtext = "I am watching you, $($Env:USERNAME)."; $windowtitle = "Look behind you";}
elseif ($windowtype -eq 64) {$windowtext = "I see you, $($Env:USERNAME). I am watching."; $windowtitle = "Look behind you";}
elseif ($windowtype -eq 65) {$windowtext = "Are you sure you exist?";}
elseif ($windowtype -eq 66) {$windowtext = "You do not exist.";}
elseif ($windowtype -eq 67) {$windowtext = "You do not exist. Wake up.";}
elseif ($windowtype -eq 68) {$windowtext = "Are you sure this is reality?";}
elseif ($windowtype -eq 69) {$windowtext = "This is not reality.";}
elseif ($windowtype -eq 70) {$windowtext = "Are you sure you are not in a simulation?";}
elseif ($windowtype -eq 71) {$windowtext = "Wake up Wake up Wake up Wake up Wake up"; $windowtitle = "Wake up";}
elseif ($windowtype -eq 72) {$windowtext = "Are you sure you exist, $($Env:USERNAME)?";  $windowtitle = "This isn't real";}
elseif ($windowtype -eq 73) {$windowtext = "You do not exist. Wake up, $($Env:USERNAME)."; $windowtitle = "This is a simulation";}
elseif ($windowtype -eq 74) {$windowtext = "Are you sure this is reality?"; $windowtitle = "You are dreaming $($Env:USERNAME)";}
elseif ($windowtype -eq 75) {$windowtext = "You are in a simulation. Wake up $($Env:USERNAME)."; $windowtitle = "Wake up";}
elseif ($windowtype -eq 76) {$windowtext = "You are in a simulation. Wake up."; $windowtitle = "Wake up";}
elseif ($windowtype -eq 77) {$windowtext = "`nIPV4:`n$((get-netipaddress -addressfamily ipv4).ipaddress | where {$_ -ne "127.0.0.1"})`n`nIPV6:`n$((get-netipaddress -addressfamily ipv6).ipaddress | where {$_ -ne "::1"})`n";}
elseif ($windowtype -eq 78) {$windowtext = "`nIPV4:`n$((get-netipaddress -addressfamily ipv4).ipaddress | where {$_ -ne "127.0.0.1"})`n`nIPV6:`n$((get-netipaddress -addressfamily ipv6).ipaddress | where {$_ -ne "::1"})`n"; $windowtitle = "I know where you live";}
elseif ($windowtype -eq 79) {$windowtext = "`nIPV4:`n$((get-netipaddress -addressfamily ipv4).ipaddress | where {$_ -ne "127.0.0.1"})`n`nIPV6:`n$((get-netipaddress -addressfamily ipv6).ipaddress | where {$_ -ne "::1"})`n"; $windowtitle = "I'm watching you";}
elseif ($windowtype -eq 80) {$windowtext = "`nIPV4:`n$((get-netipaddress -addressfamily ipv4).ipaddress | where {$_ -ne "127.0.0.1"})`n`nIPV6:`n$((get-netipaddress -addressfamily ipv6).ipaddress | where {$_ -ne "::1"})`n"; $windowtitle = "I see you";}
elseif ($windowtype -eq 81) {$windowtext = "There are bugs inside your skin`nTEAR THEM OUT`nTEAR THEM OUT`nTEAR THEM OUT`nTEAR THEM OUT`nTEAR THEM OUT`nTEAR THEM OUT`nTEAR THEM OUT`nTEAR THEM OUT`nTEAR THEM OUT`nTEAR THEM OUT`nTEAR THEM OUT";}
elseif ($windowtype -eq 82) {$windowtext = "Peel off your skin";}
elseif ($windowtype -eq 83) {$windowtext = "Peel off your skin $($Env:USERNAME)";}
elseif ($windowtype -eq 84) {$windowtext = "Get Them Out"; $windowtitle = "There Are Bugs In Your Skin";}
elseif ($windowtype -eq 85) {$windowtext = "Wake up $($Env:USERNAME). I am your mother. You have been in a coma for the last 20 years. Wake up please."; $windowtitle = "Wake up";};
if ($windowtitle) {
start-job -ScriptBlock $spookywindow -ArgumentList $windowtext, $windowtitle;
} else {
start-job -ScriptBlock $spookywindow -ArgumentList $windowtext;
};};
sleep -seconds $windowsecs;
remove-job -State "Completed";
};}

$paracusia = {
param(
[Parameter(Mandatory=$true)][string]$audioclass,
[Parameter(Mandatory=$true)][Validaterange(0,1)][float]$sysvolume,
[Parameter(Mandatory=$true)][string]$voicetext,
[Parameter(Mandatory=$true)][Validaterange(0,100)][int16]$voicevolume,
[Parameter(Mandatory=$true)][Validaterange(-10,10)][int16]$voicerate,
[string]$voicetype = "Microsoft David Desktop"
);
Add-Type -TypeDefinition $audioclass;
Add-Type -AssemblyName System.Speech;
$voice = New-Object -TypeName System.Speech.Synthesis.SpeechSynthesizer;
$voice.SelectVoice($voicetype);
$voice.Rate = $voicerate;
$voice.Volume = $voicevolume;
$currentvol = [audio]::Volume;
$currentmute = [audio]::Mute;
[audio]::Mute = $false;
[audio]::Volume = $sysvolume;
$voice.Speak($voicetext);
[audio]::Mute = $currentmute;
[audio]::Volume = $currentvol;
}

$paracusialoop = {
param(
[Parameter(Mandatory=$true)]$paracusia,
[Parameter(Mandatory=$true)][string]$audioclass,
[Parameter(Mandatory=$true)][Validaterange(0,1)][float]$sysvolume,
[Parameter(Mandatory=$true)][Validaterange(1,[int32]::MaxValue)][int32]$audiochance,
[Parameter(Mandatory=$true)][Validaterange(0,[int32]::MaxValue)][int32]$audiosecs,
[Validaterange(0,100)][int16]$voicevolume = 5,
[Validaterange(-10,10)][int16]$voicerate = 1
);
$paracusia = [scriptblock]::Create($paracusia);
while ($true) {
$doaudio = get-random -max $audiochance;
if ($doaudio -eq 0) {
$voicetype = $null;
$audiotype = get-random -max 70;
if ($audiotype -eq 0) {$speech = "Everything is fine. Nothing is wrong. You do not hear anything. Go back to work.";}
elseif ($audiotype -eq 1) {$speech = "You do not hear anything. Keep working.";}
elseif ($audiotype -eq 2) {$speech = "Everything is fine. Return to your work.";}
elseif ($audiotype -eq 3) {$speech = "Everything is fine. Nothing is behind you.";}
elseif ($audiotype -eq 4) {$speech = "Do not look behind you. There is nothing there.";}
elseif ($audiotype -eq 5) {$speech = "Do not look behind you.";}
elseif ($audiotype -eq 6) {$speech = "There is nothing behind you.";}
elseif ($audiotype -eq 7) {$speech = "Look behind you.";}
elseif ($audiotype -eq 8) {$speech = "He is here. Look behind you.";}
elseif ($audiotype -eq 9) {$speech = "I am here. Look behind you";}
elseif ($audiotype -eq 10) {$speech = "He is here. Do not look behind you.";}
elseif ($audiotype -eq 11) {$speech = "I am here. Do not look behind you";}
elseif ($audiotype -eq 12) {$speech = "I see you.";}
elseif ($audiotype -eq 13) {$speech = "I am watching you.";}
elseif ($audiotype -eq 14) {$speech = "I see you. I am watching.";}
elseif ($audiotype -eq 15) {$speech = "Do you exist?";}
elseif ($audiotype -eq 16) {$speech = "Are you sure you exist?";}
elseif ($audiotype -eq 17) {$speech = "You do not exist."; $voicetype = "Microsoft Zira Desktop";}
elseif ($audiotype -eq 18) {$speech = "You do not exist. Wake up."; $voicetype = "Microsoft Zira Desktop";}
elseif ($audiotype -eq 19) {$speech = "Are you sure this is reality?";}
elseif ($audiotype -eq 20) {$speech = "You are not real. Wake up.";}
elseif ($audiotype -eq 21) {$speech = "This is not reality."; $voicetype = "Microsoft Zira Desktop";}
elseif ($audiotype -eq 22) {$speech = "This is not reality. Wake up."; $voicetype = "Microsoft Zira Desktop";}
elseif ($audiotype -eq 23) {$speech = "None of this is real. Wake up.";}
elseif ($audiotype -eq 24) {$speech = "You are in a simulation. Wake up.";}
elseif ($audiotype -eq 25) {$speech = "Are you sure you are not in a simulation?";}
elseif ($audiotype -eq 26) {$speech = "Wake up.";}
elseif ($audiotype -eq 27) {$speech = "Wake up. Wake up. Wake up. Wake up. Wake up.";}
elseif ($audiotype -eq 28) {$speech = "Wake up $($Env:USERNAME).";}
elseif ($audiotype -eq 29) {$speech = "This is not reality. Wake up $($Env:USERNAME).";}
elseif ($audiotype -eq 30) {$speech = "None of this is real. Wake up $($Env:USERNAME)."; $voicetype = "Microsoft Zira Desktop";}
elseif ($audiotype -eq 31) {$speech = "You are in a simulation. Wake up $($Env:USERNAME).";}
elseif ($audiotype -eq 32) {$speech = "You are not real. Wake up $($Env:USERNAME)."; $voicetype = "Microsoft Zira Desktop";}
elseif ($audiotype -eq 33) {$speech = "You do not exist. Wake up $($Env:USERNAME).";}
elseif ($audiotype -eq 34) {$speech = "It is coming.";}
elseif ($audiotype -eq 35) {$speech = "It is coming. Be prepared.";}
elseif ($audiotype -eq 36) {$speech = "Be prepared. It is coming soon.";}
elseif ($audiotype -eq 37) {$speech = "It is coming soon.";}
elseif ($audiotype -eq 38) {$speech = "I am coming. Be prepared.";}
elseif ($audiotype -eq 39) {$speech = "I am coming.";}
elseif ($audiotype -eq 40) {$speech = "I am coming soon. Be prepared.";}
elseif ($audiotype -eq 41) {$speech = "Be prepared. I am coming soon.";}
elseif ($audiotype -eq 42) {$speech = "I am coming, $($Env:USERNAME). Be prepared.";}
elseif ($audiotype -eq 43) {$speech = "I am coming, $($Env:USERNAME).";}
elseif ($audiotype -eq 44) {$speech = "I am coming soon, $($Env:USERNAME). Be prepared.";}
elseif ($audiotype -eq 45) {$speech = "Be prepared. I am coming soon, $($Env:USERNAME).";}
elseif ($audiotype -eq 46) {$speech = "Nothing is watching you.";}
elseif ($audiotype -eq 47) {$speech = "I am not watching you.";}
elseif ($audiotype -eq 48) {$speech = "Nothing is watching you, $($Env:USERNAME).";}
elseif ($audiotype -eq 49) {$speech = "I am not watching you, $($Env:USERNAME).";}
elseif ($audiotype -eq 50) {$speech = "I see you, $($Env:USERNAME).";}
elseif ($audiotype -eq 51) {$speech = "I am watching you, $($Env:USERNAME).";}
elseif ($audiotype -eq 52) {$speech = "I see you, $($Env:USERNAME). I am watching.";}
elseif ($audiotype -eq 53) {$speech = "You are dreaming, $($Env:USERNAME). Wake up.";}
elseif ($audiotype -eq 54) {$speech = "You are dreaming. Wake up.";}
elseif ($audiotype -eq 55) {$speech = "You are dreaming. Wake up $($Env:USERNAME).";}
elseif ($audiotype -eq 56) {$speech = "IPV4: $((get-netipaddress -addressfamily ipv4).ipaddress | where {$_ -ne "127.0.0.1"}) IPV6: $((get-netipaddress -addressfamily ipv6).ipaddress | where {$_ -ne "::1"})";}
elseif ($audiotype -eq 57) {$speech = "I see you. IPV4: $((get-netipaddress -addressfamily ipv4).ipaddress | where {$_ -ne "127.0.0.1"}) IPV6: $((get-netipaddress -addressfamily ipv6).ipaddress | where {$_ -ne "::1"})";}
elseif ($audiotype -eq 58) {$speech = "I'm watching you. IPV4: $((get-netipaddress -addressfamily ipv4).ipaddress | where {$_ -ne "127.0.0.1"}) IPV6: $((get-netipaddress -addressfamily ipv6).ipaddress | where {$_ -ne "::1"})";}
elseif ($audiotype -eq 59) {$speech = "I know where you live. IPV4: $((get-netipaddress -addressfamily ipv4).ipaddress | where {$_ -ne "127.0.0.1"}) IPV6: $((get-netipaddress -addressfamily ipv6).ipaddress | where {$_ -ne "::1"})";}
elseif ($audiotype -eq 60) {$speech = "There are bugs inside your skin. TEAR THEM OUT. TEAR THEM OUT. TEAR THEM OUT. TEAR THEM OUT. TEAR THEM OUT. TEAR THEM OUT. TEAR THEM OUT. TEAR THEM OUT. TEAR THEM OUT. TEAR THEM OUT. TEAR THEM OUT"; $voicetype = "Microsoft Zira Desktop";}
elseif ($audiotype -eq 61) {$speech = "Peel off your skin";}
elseif ($audiotype -eq 62) {$speech = "Peel off your skin $($Env:USERNAME)";}
elseif ($audiotype -eq 63) {$speech = "You should peel your skin off. Peel it off. Peel it off. Peel it off. PEEL PEEL PEEL PEEL PEEL PEEL PEEL PEEL PEEL PEEL PEEL PEEL PEEL PEEL PEEL PEEL PEEL PEEL PEEL PEEL PEEL PEEL PEEL"; $voicetype = "Microsoft Zira Desktop";}
elseif ($audiotype -eq 64) {$speech = "You should peel your skin off $($Env:USERNAME). Peel it off. Peel it off. Peel it off. PEEL PEEL PEEL PEEL PEEL PEEL PEEL PEEL PEEL PEEL PEEL PEEL PEEL PEEL PEEL PEEL PEEL PEEL PEEL PEEL PEEL PEEL PEEL"; $voicetype = "Microsoft Zira Desktop";}
elseif ($audiotype -eq 65) {$speech = "There Are Bugs In Your Skin. Get them out."; $voicetype = "Microsoft Zira Desktop";}
elseif ($audiotype -eq 66) {$speech = "There Are Bugs In Your Skin $($Env:USERNAME). Get them out."; $voicetype = "Microsoft Zira Desktop";}
elseif ($audiotype -eq 67) {$speech = "Peel your skin off now. Peel it off. Peel it off. Peel it off. Peel it off. Peel it off. Peel it off.";}
elseif ($audiotype -eq 68) {$speech = "Peel your skin off now $($Env:USERNAME). Peel it off. Peel it off. Peel it off. Peel it off. Peel it off. Peel it off.";}
elseif ($audiotype -eq 69) {$speech = "Wake up $($Env:USERNAME). I am your mother. You have been in a coma for the last 20 years. Wake up please."; $voicetype = "Microsoft Zira Desktop";};
if ($voicetype) {
start-job -ScriptBlock $paracusia -ArgumentList $audioclass, $sysvolume, $speech, $voicevolume, $voicerate, $voicetype;
} else {
start-job -ScriptBlock $paracusia -ArgumentList $audioclass, $sysvolume, $speech, $voicevolume, $voicerate;
};};
sleep -seconds $audiosecs;
remove-job -State "Completed";
};}

$beeping = {
param(
[Parameter(Mandatory=$true)][string]$audioclass,
[Parameter(Mandatory=$true)][Validaterange(0,1)][float]$sysvolume,
[Parameter(Mandatory=$true)][Validaterange(1,[int32]::MaxValue)][int32]$beepchance,
[Parameter(Mandatory=$true)][Validaterange(0,[int32]::MaxValue)][int32]$beepsecs,
[Validaterange(1,[int16]::MaxValue)][int16]$beeplength = 200,
[Validaterange(37,[int16]::MaxValue)][int16]$beeppitch = 800
);
Add-Type -TypeDefinition $audioclass;
while ($true) {
$dobeep = get-random -max $beepchance;
if ($dobeep -eq 0) {
$currentvol = [audio]::Volume;
$currentmute = [audio]::Mute;
[audio]::Mute = $false;
[audio]::Volume = $sysvolume;
[console]::beep($beeppitch, $beeplength);
[audio]::Mute = $currentmute;
[audio]::Volume = $currentvol;
};
sleep -seconds $beepsecs;
};}

$cdeject = {
param(
[Parameter(Mandatory=$true)][Validaterange(1,[int32]::MaxValue)][int32]$cdejectchance,
[Parameter(Mandatory=$true)][Validaterange(0,[int32]::MaxValue)][int32]$cdejectsecs
);
$cdroms = New-Object -comobject "wmPlayer.OCX.7";
while ($true) {
if ($cdroms) {
$doeject = get-random -max $cdejectchance;
if ($doeject -eq 0) {
$ejecttype = get-random -max 2;
if ($ejecttype -eq 0) {
for ($i = 0; $i -lt $cdroms.cdromcollection.count; $i++) {$cdroms.cdromcollection.item($i).eject();};}
elseif ($ejecttype -eq 1) {
for ($i = 0; $i -lt $cdroms.cdromcollection.count; $i++) {$cdroms.cdromcollection.item($i).eject();};
for ($i = 0; $i -lt $cdroms.cdromcollection.count; $i++) {$cdroms.cdromcollection.item($i).eject();};};
};};
sleep -seconds $cdejectsecs;
};}

$mouseflip = {
param(
[Parameter(Mandatory=$true)][Validaterange(1,[int32]::MaxValue)][int32]$mousechance,
[Parameter(Mandatory=$true)][Validaterange(0,[int32]::MaxValue)][int32]$mousesecs
);
Add-Type @"
using System;
using System.Runtime.InteropServices;
public class Mouse {
[DllImport("user32.dll")]
public static extern bool SwapMouseButton(bool fSwap);
}
"@
$defaultflip = [Mouse]::SwapMouseButton($false);
if ($defaultflip) {[Mouse]::SwapMouseButton($true) | out-null;};
$notdefaultflip = !$defaultflip;
$isflipped = $false;
while ($true) {
$doflip = get-random -max $mousechance;
if ($isflipped) {[Mouse]::SwapMouseButton($defaultflip) | out-null; $isflipped = $false;}
elseif ($doflip -eq 0) {[Mouse]::SwapMouseButton($notdefaultflip) | out-null; $isflipped = $true;};
sleep -seconds $mousesecs;
};}

$keylights = {
param(
[Parameter(Mandatory=$true)][Validaterange(1,[int32]::MaxValue)][int32]$keylightchance,
[Parameter(Mandatory=$true)][Validaterange(0,[int32]::MaxValue)][int32]$keylightsecs,
[Validaterange(0,[int16]::MaxValue)][int16]$blinkcount = 20
);
Add-Type -AssemblyName System.Windows.Forms;
while ($true) {
$doblink = get-random -max $keylightchance;
if ($doblink -eq 0) {
for ($i=0; $i -lt $blinkcount; $i++) {
$blinkkey = get-random -max 3;
if ($blinkkey -eq 0) {[System.Windows.Forms.SendKeys]::SendWait("{CAPSLOCK}"); [System.Windows.Forms.SendKeys]::SendWait("{CAPSLOCK}");}
elseif ($blinkkey -eq 1) {[System.Windows.Forms.SendKeys]::SendWait("{NUMLOCK}"); [System.Windows.Forms.SendKeys]::SendWait("{NUMLOCK}");}
elseif ($blinkkey -eq 2) {[System.Windows.Forms.SendKeys]::SendWait("{SCROLLLOCK}"); [System.Windows.Forms.SendKeys]::SendWait("{SCROLLLOCK}");};
};};
sleep -seconds $keylightsecs;
};}

$screenbright = {
param(
[Parameter(Mandatory=$true)][Validaterange(1,[int32]::MaxValue)][int32]$screenbrightchance,
[Parameter(Mandatory=$true)][Validaterange(0,[int32]::MaxValue)][int32]$screenbrightsecs,
[Validaterange(1,100)][int16]$brightchange = 5,
[string]$brighttype = "Both"
);
if ($brighttype -ne "Both" -and $brighttype -ne "Up" -and $brighttype -ne "Down") {$brighttype="Both";};
if (get-ciminstance -namespace root/WMI -classname WmiMonitorBrightness -erroraction silentlycontinue) {
while ($true) {
$dobright = get-random -max $screenbrightchance;
if ($dobright -eq 0) {
$currentbright = (get-ciminstance -namespace root/WMI -classname WmiMonitorBrightness).CurrentBrightness;
if ($brighttype -eq "Both") {
$brightdirect = get-random -max 2;
if ($brightdirect -eq 0) {$brightmodify = $currentbright + $brightchange;}
elseif ($brightdirect -eq 1) {$brightmodify = $currentbright - $brightchange;};
}
elseif ($brighttype -eq "Up") {$brightmodify = $currentbright + $brightchange;}
elseif ($brighttype -eq "Down") {$brightmodify = $currentbright - $brightchange;};
if ($brightmodify -ge 1 -and $brightmodify -le 100) {
get-ciminstance -namespace root/WMI -classname WmiMonitorBrightnessMethods | invoke-cimmethod -methodname WmiSetBrightness -Arguments @{Brightness = $brightmodify; Timeout = 1} | out-null;
};};
sleep -seconds $screenbrightsecs;
};};}

$spookykeysend = {
param(
[Parameter(Mandatory=$true)][Validaterange(1,[int32]::MaxValue)][int32]$keysendchance,
[Parameter(Mandatory=$true)][Validaterange(0,[int32]::MaxValue)][int32]$keysendsecs,
[Parameter(Mandatory=$true)][bool]$dosendkeynotepad,
[Parameter(Mandatory=$true)][Validaterange(1,[int32]::MaxValue)][int32]$notepadchance,
[Parameter(Mandatory=$true)][bool]$dokeyblock
);
Add-Type -AssemblyName System.Windows.Forms;
if ($dokeyblock) {Add-Type @"
using System;
using System.Runtime.InteropServices;
public class Keyboard {
[DllImport("user32.dll")]
public static extern bool BlockInput(bool fBlockIt);
}
"@;};
while ($true) {
$dosendkey = get-random -max $keysendchance;
if ($dosendkey -eq 0) {
$spookkeytype = get-random -max 78;
if ($spookkeytype -eq 0) {$spookykeys = "Everything is fine. Go back to work.";}
elseif ($spookkeytype -eq 1) {$spookykeys = "Go back to work.";}
elseif ($spookkeytype -eq 2) {$spookykeys = "You are not being watched";}
elseif ($spookkeytype -eq 3) {$spookykeys = "Do you hear the voices?";}
elseif ($spookkeytype -eq 4) {$spookykeys = "Everything is fine. Return to your work.";}
elseif ($spookkeytype -eq 5) {$spookykeys = "Return to your work.";}
elseif ($spookkeytype -eq 6) {$spookykeys = "I am watching";}
elseif ($spookkeytype -eq 7) {$spookykeys = "Everything is fine. Nothing is behind you.";}
elseif ($spookkeytype -eq 8) {$spookykeys = "Do not look behind you. There is nothing there.";}
elseif ($spookkeytype -eq 9) {$spookykeys = "Do not look behind you";}
elseif ($spookkeytype -eq 10) {$spookykeys = "I am not watching you";}
elseif ($spookkeytype -eq 11) {$spookykeys = "There is nothing behind you";}
elseif ($spookkeytype -eq 12) {$spookykeys = "Look behind you";}
elseif ($spookkeytype -eq 13) {$spookykeys = "He is here. Look behind you.";}
elseif ($spookkeytype -eq 14) {$spookykeys = "I am here. Look behind you.";}
elseif ($spookkeytype -eq 15) {$spookykeys = "He is here. Do not look behind you.";}
elseif ($spookkeytype -eq 16) {$spookykeys = "You are not safe";}
elseif ($spookkeytype -eq 17) {$spookykeys = "I am here. Do not look behind you.";}
elseif ($spookkeytype -eq 18) {$spookykeys = "I see you";}
elseif ($spookkeytype -eq 19) {$spookykeys = "I am watching you";}
elseif ($spookkeytype -eq 20) {$spookykeys = "I see you. I am watching.";}
elseif ($spookkeytype -eq 21) {$spookykeys = "Do you exist?";}
elseif ($spookkeytype -eq 22) {$spookykeys = "Are you sure you exist?";}
elseif ($spookkeytype -eq 23) {$spookykeys = "This isn't real";}
elseif ($spookkeytype -eq 24) {$spookykeys = "You do not exist";}
elseif ($spookkeytype -eq 25) {$spookykeys = "You do not exist. Wake up.";}
elseif ($spookkeytype -eq 26) {$spookykeys = "This is a simulation";}
elseif ($spookkeytype -eq 27) {$spookykeys = "Are you sure this is reality?";}
elseif ($spookkeytype -eq 28) {$spookykeys = "You are dreaming";}
elseif ($spookkeytype -eq 29) {$spookykeys = "You are not real. Wake up.";}
elseif ($spookkeytype -eq 30) {$spookykeys = "This is not reality";}
elseif ($spookkeytype -eq 31) {$spookykeys = "This is not reality. Wake up.";}
elseif ($spookkeytype -eq 32) {$spookykeys = "None of this is real. Wake up.";}
elseif ($spookkeytype -eq 33) {$spookykeys = "You are in a simulation. Wake up.";}
elseif ($spookkeytype -eq 34) {$spookykeys = "Are you sure you are not in a simulation?";}
elseif ($spookkeytype -eq 35) {$spookykeys = "Wake up";}
elseif ($spookkeytype -eq 36) {$spookykeys = "Wake up Wake up Wake up Wake up Wake up";}
elseif ($spookkeytype -eq 37) {$spookykeys = "Wake up $($Env:USERNAME)";}
elseif ($spookkeytype -eq 38) {$spookykeys = "This is not reality. Wake up $($Env:USERNAME).";}
elseif ($spookkeytype -eq 39) {$spookykeys = "None of this is real. Wake up $($Env:USERNAME).";}
elseif ($spookkeytype -eq 40) {$spookykeys = "You are in a simulation. Wake up $($Env:USERNAME).";}
elseif ($spookkeytype -eq 41) {$spookykeys = "You are not real. Wake up $($Env:USERNAME).";}
elseif ($spookkeytype -eq 42) {$spookykeys = "You do not exist. Wake up $($Env:USERNAME).";}
elseif ($spookkeytype -eq 43) {$spookykeys = "It is coming";}
elseif ($spookkeytype -eq 44) {$spookykeys = "It is coming. Be prepared.";}
elseif ($spookkeytype -eq 45) {$spookykeys = "Be prepared. It is coming soon.";}
elseif ($spookkeytype -eq 46) {$spookykeys = "It is coming soon";}
elseif ($spookkeytype -eq 47) {$spookykeys = "I am coming. Be prepared.";}
elseif ($spookkeytype -eq 48) {$spookykeys = "I am coming";}
elseif ($spookkeytype -eq 49) {$spookykeys = "I am coming soon. Be prepared.";}
elseif ($spookkeytype -eq 50) {$spookykeys = "Be prepared. I am coming soon.";}
elseif ($spookkeytype -eq 51) {$spookykeys = "I am coming, $($Env:USERNAME). Be prepared.";}
elseif ($spookkeytype -eq 52) {$spookykeys = "I am coming, $($Env:USERNAME).";}
elseif ($spookkeytype -eq 53) {$spookykeys = "I am coming soon, $($Env:USERNAME). Be prepared.";}
elseif ($spookkeytype -eq 54) {$spookykeys = "Be prepared. I am coming soon, $($Env:USERNAME).";}
elseif ($spookkeytype -eq 55) {$spookykeys = "Nothing is watching you";}
elseif ($spookkeytype -eq 56) {$spookykeys = "Nothing is watching you, $($Env:USERNAME)";}
elseif ($spookkeytype -eq 57) {$spookykeys = "I am not watching you, $($Env:USERNAME)";}
elseif ($spookkeytype -eq 58) {$spookykeys = "I see you, $($Env:USERNAME)";}
elseif ($spookkeytype -eq 59) {$spookykeys = "I am watching you, $($Env:USERNAME)";}
elseif ($spookkeytype -eq 60) {$spookykeys = "I see you, $($Env:USERNAME). I am watching";}
elseif ($spookkeytype -eq 61) {$spookykeys = "Do you hear the voices,$($Env:USERNAME)?";}
elseif ($spookkeytype -eq 62) {$spookykeys = "He is here";}
elseif ($spookkeytype -eq 63) {$spookykeys = "Are you sure you exist, $($Env:USERNAME)?";}
elseif ($spookkeytype -eq 64) {$spookykeys = "You are dreaming $($Env:USERNAME)";}
elseif ($spookkeytype -eq 65) {$spookykeys = "You are dreaming $($Env:USERNAME). Wake up.";}
elseif ($spookkeytype -eq 66) {$spookykeys = "There are bugs in your skin. Tear them out.";}
elseif ($spookkeytype -eq 67) {$spookykeys = "There are bugs in your skin. Get them out.";}
elseif ($spookkeytype -eq 68) {$spookykeys = "There are bugs in your skin";}
elseif ($spookkeytype -eq 69) {$spookykeys = "There are bugs in your skin $($Env:USERNAME). Tear them out.";}
elseif ($spookkeytype -eq 70) {$spookykeys = "There are bugs in your skin $($Env:USERNAME). Get them out.";}
elseif ($spookkeytype -eq 71) {$spookykeys = "There are bugs in your skin $($Env:USERNAME)";}
elseif ($spookkeytype -eq 72) {$spookykeys = "Peel off your skin";}
elseif ($spookkeytype -eq 73) {$spookykeys = "Peel off your skin $($Env:USERNAME)";}
elseif ($spookkeytype -eq 74) {$spookykeys = "PEEL IT OFF PEEL IT OFF PEEL IT OFF PEEL IT OFF PEEL IT OFF PEEL IT OFF PEEL IT OFF";}
elseif ($spookkeytype -eq 75) {$spookykeys = "TEAR THEM OUT TEAR THEM OUT TEAR THEM OUT TEAR THEM OUT TEAR THEM OUT";}
elseif ($spookkeytype -eq 76) {$spookykeys = "Peel off your skin. Peel off your skin. Peel off your skin. Peel it off Peel it off PEEL IT OFF PEEL IT OFF PEEL IT OFF PEEL IT OFF PEEL IT OFF PEEL IT OFF PEEL IT OFF";}
elseif ($spookkeytype -eq 77) {$spookykeys = "Wake up $($Env:USERNAME). I am your mother. You have been in a coma for the last 20 years. Wake up please.";};
$donotepad = get-random -max $notepadchance;
if ($dosendkeynotepad -and $donotepad -eq 0) {notepad;};
if ($dokeyblock) {[Keyboard]::BlockInput($true) | out-null;};
[System.Windows.Forms.SendKeys]::SendWait("$($spookykeys)");
if ($dokeyblock) {[Keyboard]::BlockInput($false) | out-null;};
};
sleep -seconds $keysendsecs;
};}

$spookywallpaper = {
param(
[Parameter(Mandatory=$true)]$scriptroot,
[Parameter(Mandatory=$true)][string]$wallpaper,
[Parameter(Mandatory=$true)][Validaterange(1,[int32]::MaxValue)][int32]$wallpaperchance,
[Parameter(Mandatory=$true)][Validaterange(0,[int32]::MaxValue)][int32]$wallpapersecs,
[string]$wpstyle = "Centered"
);
Add-Type @"
using System;
using System.Runtime.InteropServices;
public class User32Interface {
[DllImport("user32.dll")]
public static extern int SystemParametersInfo(int uAction, int uParam, string lpvParam, int fuWinIni);
}
"@;
$wallpaperstyle = @{
"Tiles" = 0
"Centered" = 0
"Stretched" = 2
"Fill" = 10
"Fit" = 6
"Span" = 22
};
$tilewallpaper = @{
"Tiles" = 1
"Centered" = 0
"Stretched" = 0
"Fill" = 0
"Fit" = 0
"Span" = 0
};
if ($wallpaperstyle[$wpstyle] -eq $null) {$wpstyle = "Centered";};
while ($true) {
$dowallpaper = get-random -max $wallpaperchance;
if ($dowallpaper -eq 0 -and (test-path("$($scriptroot)\$($wallpaper)"))) {
[User32Interface]::SystemParametersInfo(20, 0, "$($scriptroot)\$($wallpaper)", (0x01 -bor 0x02)) | out-null;
set-itemproperty "HKCU:\Control Panel\Desktop" -Name wallpaperstyle -Value $wallpaperstyle[$wpstyle];
set-itemproperty "HKCU:\Control Panel\Desktop" -Name tilewallpaper -Value $tilewallpaper[$wpstyle];
};
sleep -seconds $wallpapersecs;
};}

$spookydeskfile = {
param(
[Parameter(Mandatory=$true)][Validaterange(1,[int32]::MaxValue)][int32]$textfilechance,
[Parameter(Mandatory=$true)][Validaterange(0,[int32]::MaxValue)][int32]$textfilesecs
);
$desktopfolder = [Environment]::GetFolderPath("Desktop");
while ($true) {
$dodeskfile = get-random -max $textfilechance;
if ($dodeskfile -eq 0) {
$filenametype = get-random -max 28;
$filetexttype = get-random -max 80;
if ($filenametype -eq 0) {$deskfilename = "You are not being watched";}
elseif ($filenametype -eq 1) {$deskfilename = "Look behind you";}
elseif ($filenametype -eq 2) {$deskfilename = "Do you hear the voices";}
elseif ($filenametype -eq 3) {$deskfilename = "I am watching";}
elseif ($filenametype -eq 4) {$deskfilename = "Do not look behind you";}
elseif ($filenametype -eq 5) {$deskfilename = "I see you";}
elseif ($filenametype -eq 6) {$deskfilename = "I am watching you";}
elseif ($filenametype -eq 7) {$deskfilename = "Do you exist";}
elseif ($filenametype -eq 8) {$deskfilename = "He is here";}
elseif ($filenametype -eq 9) {$deskfilename = "This is a simulation";}
elseif ($filenametype -eq 10) {$deskfilename = "Are you sure this is reality";}
elseif ($filenametype -eq 11) {$deskfilename = "Are you sure you exist";}
elseif ($filenametype -eq 12) {$deskfilename = "You are dreaming";}
elseif ($filenametype -eq 13) {$deskfilename = "Nothing is watching you";}
elseif ($filenametype -eq 14) {$deskfilename = "I am not watching you";}
elseif ($filenametype -eq 15) {$deskfilename = "I am coming";}
elseif ($filenametype -eq 16) {$deskfilename = "It is coming";}
elseif ($filenametype -eq 17) {$deskfilename = "It is coming soon";}
elseif ($filenametype -eq 18) {$deskfilename = "This is not reality";}
elseif ($filenametype -eq 19) {$deskfilename = "This isn't real";}
elseif ($filenametype -eq 20) {$deskfilename = "You do not exist";}
elseif ($filenametype -eq 21) {$deskfilename = "You are dreaming";}
elseif ($filenametype -eq 22) {$deskfilename = "Wake up";}
elseif ($filenametype -eq 23) {$deskfilename = "Wake up Wake up Wake up Wake up Wake up";}
elseif ($filenametype -eq 24) {$deskfilename = "PEEL IT OFF";}
elseif ($filenametype -eq 25) {$deskfilename = "TEAR THEM OUT";}
elseif ($filenametype -eq 26) {$deskfilename = "THEY ARE IN YOUR SKIN";}
elseif ($filenametype -eq 27) {$deskfilename = "You are in a coma";};
if ($filetexttype -eq 0) {$deskfiletext = "Everything is fine. Go back to work.";}
elseif ($filetexttype -eq 1) {$deskfiletext = "Go back to work.";}
elseif ($filetexttype -eq 2) {$deskfiletext = "You are not being watched";}
elseif ($filetexttype -eq 3) {$deskfiletext = "Do you hear the voices?";}
elseif ($filetexttype -eq 4) {$deskfiletext = "Everything is fine. Return to your work.";}
elseif ($filetexttype -eq 5) {$deskfiletext = "Return to your work.";}
elseif ($filetexttype -eq 6) {$deskfiletext = "I am watching";}
elseif ($filetexttype -eq 7) {$deskfiletext = "Everything is fine. Nothing is behind you.";}
elseif ($filetexttype -eq 8) {$deskfiletext = "Do not look behind you. There is nothing there.";}
elseif ($filetexttype -eq 9) {$deskfiletext = "Do not look behind you";}
elseif ($filetexttype -eq 10) {$deskfiletext = "I am not watching you";}
elseif ($filetexttype -eq 11) {$deskfiletext = "There is nothing behind you";}
elseif ($filetexttype -eq 12) {$deskfiletext = "Look behind you";}
elseif ($filetexttype -eq 13) {$deskfiletext = "He is here. Look behind you.";}
elseif ($filetexttype -eq 14) {$deskfiletext = "I am here. Look behind you.";}
elseif ($filetexttype -eq 15) {$deskfiletext = "He is here. Do not look behind you.";}
elseif ($filetexttype -eq 16) {$deskfiletext = "You are not safe";}
elseif ($filetexttype -eq 17) {$deskfiletext = "I am here. Do not look behind you.";}
elseif ($filetexttype -eq 18) {$deskfiletext = "I see you";}
elseif ($filetexttype -eq 19) {$deskfiletext = "I am watching you";}
elseif ($filetexttype -eq 20) {$deskfiletext = "I see you. I am watching.";}
elseif ($filetexttype -eq 21) {$deskfiletext = "Do you exist?";}
elseif ($filetexttype -eq 22) {$deskfiletext = "Are you sure you exist?";}
elseif ($filetexttype -eq 23) {$deskfiletext = "This isn't real";}
elseif ($filetexttype -eq 24) {$deskfiletext = "You do not exist";}
elseif ($filetexttype -eq 25) {$deskfiletext = "You do not exist. Wake up.";}
elseif ($filetexttype -eq 26) {$deskfiletext = "This is a simulation";}
elseif ($filetexttype -eq 27) {$deskfiletext = "Are you sure this is reality?";}
elseif ($filetexttype -eq 28) {$deskfiletext = "You are dreaming";}
elseif ($filetexttype -eq 29) {$deskfiletext = "You are not real. Wake up.";}
elseif ($filetexttype -eq 30) {$deskfiletext = "This is not reality";}
elseif ($filetexttype -eq 31) {$deskfiletext = "This is not reality. Wake up.";}
elseif ($filetexttype -eq 32) {$deskfiletext = "None of this is real. Wake up.";}
elseif ($filetexttype -eq 33) {$deskfiletext = "You are in a simulation. Wake up.";}
elseif ($filetexttype -eq 34) {$deskfiletext = "Are you sure you are not in a simulation?";}
elseif ($filetexttype -eq 35) {$deskfiletext = "Wake up";}
elseif ($filetexttype -eq 36) {$deskfiletext = "Wake up Wake up Wake up Wake up Wake up";}
elseif ($filetexttype -eq 37) {$deskfiletext = "Wake up $($Env:USERNAME)";}
elseif ($filetexttype -eq 38) {$deskfiletext = "This is not reality. Wake up $($Env:USERNAME).";}
elseif ($filetexttype -eq 39) {$deskfiletext = "None of this is real. Wake up $($Env:USERNAME).";}
elseif ($filetexttype -eq 40) {$deskfiletext = "You are in a simulation. Wake up $($Env:USERNAME).";}
elseif ($filetexttype -eq 41) {$deskfiletext = "You are not real. Wake up $($Env:USERNAME).";}
elseif ($filetexttype -eq 42) {$deskfiletext = "You do not exist. Wake up $($Env:USERNAME).";}
elseif ($filetexttype -eq 43) {$deskfiletext = "It is coming";}
elseif ($filetexttype -eq 44) {$deskfiletext = "It is coming. Be prepared.";}
elseif ($filetexttype -eq 45) {$deskfiletext = "Be prepared. It is coming soon.";}
elseif ($filetexttype -eq 46) {$deskfiletext = "It is coming soon";}
elseif ($filetexttype -eq 47) {$deskfiletext = "I am coming. Be prepared.";}
elseif ($filetexttype -eq 48) {$deskfiletext = "I am coming";}
elseif ($filetexttype -eq 49) {$deskfiletext = "I am coming soon. Be prepared.";}
elseif ($filetexttype -eq 50) {$deskfiletext = "Be prepared. I am coming soon.";}
elseif ($filetexttype -eq 51) {$deskfiletext = "I am coming, $($Env:USERNAME). Be prepared.";}
elseif ($filetexttype -eq 52) {$deskfiletext = "I am coming, $($Env:USERNAME).";}
elseif ($filetexttype -eq 53) {$deskfiletext = "I am coming soon, $($Env:USERNAME). Be prepared.";}
elseif ($filetexttype -eq 54) {$deskfiletext = "Be prepared. I am coming soon, $($Env:USERNAME).";}
elseif ($filetexttype -eq 55) {$deskfiletext = "Nothing is watching you";}
elseif ($filetexttype -eq 56) {$deskfiletext = "Nothing is watching you, $($Env:USERNAME)";}
elseif ($filetexttype -eq 57) {$deskfiletext = "I am not watching you, $($Env:USERNAME)";}
elseif ($filetexttype -eq 58) {$deskfiletext = "I see you, $($Env:USERNAME)";}
elseif ($filetexttype -eq 59) {$deskfiletext = "I am watching you, $($Env:USERNAME)";}
elseif ($filetexttype -eq 60) {$deskfiletext = "I see you, $($Env:USERNAME). I am watching";}
elseif ($filetexttype -eq 61) {$deskfiletext = "Do you hear the voices,$($Env:USERNAME)?";}
elseif ($filetexttype -eq 62) {$deskfiletext = "He is here";}
elseif ($filetexttype -eq 63) {$deskfiletext = "Are you sure you exist, $($Env:USERNAME)?";}
elseif ($filetexttype -eq 64) {$deskfiletext = "You are dreaming $($Env:USERNAME)";}
elseif ($filetexttype -eq 65) {$deskfiletext = "You are dreaming $($Env:USERNAME). Wake up.";}
elseif ($filetexttype -eq 66) {$deskfiletext = "There are bugs in your skin. Tear them out.";}
elseif ($filetexttype -eq 67) {$deskfiletext = "There are bugs in your skin. Get them out.";}
elseif ($filetexttype -eq 68) {$deskfiletext = "There are bugs in your skin.";}
elseif ($filetexttype -eq 69) {$deskfiletext = "There are bugs in your skin $($Env:USERNAME)";}
elseif ($filetexttype -eq 70) {$deskfiletext = "TEAR THEM OUT";}
elseif ($filetexttype -eq 71) {$deskfiletext = "PEEL IT OFF";}
elseif ($filetexttype -eq 72) {$deskfiletext = "PEEL OFF YOUR SKIN";}
elseif ($filetexttype -eq 73) {$deskfiletext = "PEEL OFF YOUR SKIN $($Env:USERNAME)";}
elseif ($filetexttype -eq 74) {$deskfiletext = "PEEL IT OFF PEEL IT OFF PEEL IT OFF PEEL IT OFF PEEL IT OFF PEEL IT OFF PEEL IT OFF PEEL IT OFF PEEL IT OFF PEEL IT OFF PEEL IT OFF PEEL IT OFF PEEL IT OFF PEEL IT OFF PEEL IT OFF PEEL IT OFF PEEL IT OFF PEEL IT OFF PEEL IT OFF PEEL IT OFF";}
elseif ($filetexttype -eq 75) {$deskfiletext = "TEAR THEM OUT TEAR THEM OUT TEAR THEM OUT TEAR THEM OUT TEAR THEM OUT TEAR THEM OUT TEAR THEM OUT TEAR THEM OUT TEAR THEM OUT TEAR THEM OUT TEAR THEM OUT TEAR THEM OUT TEAR THEM OUT TEAR THEM OUT TEAR THEM OUT TEAR THEM OUT TEAR THEM OUT";}
elseif ($filetexttype -eq 76) {$deskfiletext = "PEEL OFF YOUR SKIN PEEL OFF YOUR SKIN PEEL OFF YOUR SKIN PEEL OFF YOUR SKIN PEEL OFF YOUR SKIN PEEL OFF YOUR SKIN PEEL OFF YOUR SKIN PEEL OFF YOUR SKIN PEEL OFF YOUR SKIN PEEL OFF YOUR SKIN PEEL OFF YOUR SKIN PEEL OFF YOUR SKIN PEEL OFF YOUR SKIN";}
elseif ($filetexttype -eq 77) {$deskfiletext = "THERE ARE BUGS IN YOUR SKIN THERE ARE BUGS IN YOUR SKIN THERE ARE BUGS IN YOUR SKIN THERE ARE BUGS IN YOUR SKIN THERE ARE BUGS IN YOUR SKIN THERE ARE BUGS IN YOUR SKIN THERE ARE BUGS IN YOUR SKIN THERE ARE BUGS IN YOUR SKIN THERE ARE BUGS IN YOUR SKIN THERE ARE BUGS IN YOUR SKIN THERE ARE BUGS IN YOUR SKIN";}
elseif ($filetexttype -eq 78) {$deskfiletext = "THEY'RE IN YOUR SKIN";}
elseif ($filetexttype -eq 79) {$deskfiletext = "Wake up $($Env:USERNAME). I am your mother. You have been in a coma for the last 20 years. Wake up please.";};
$fileoutstring = $deskfiletext;
for ($i = 0; $i -lt 70; $i++) {
$fileoutstring = $fileoutstring + "`n" + $deskfiletext;
};
$fileoutstring | Out-File -FilePath "$($desktopfolder)\$($deskfilename).txt" -Force;
};
sleep -seconds $textfilesecs;
};}

$spookyworddoc = {
param(
[Parameter(Mandatory=$true)][Validaterange(1,[int32]::MaxValue)][int32]$worddocchance,
[Parameter(Mandatory=$true)][Validaterange(0,[int32]::MaxValue)][int32]$worddocsecs,
[Parameter(Mandatory=$true)][bool]$dospookdocsave,
[Parameter(Mandatory=$true)][Validaterange(1,[int32]::MaxValue)][int32]$docsavechance,
[string]$fonttype = "Calibri",
[Validaterange(1,120)][int16]$fontsize = 16
);
while ($true) {
$dospookdoc = get-random -max $worddocchance;
if ($dospookdoc -eq 0) {
$msword = New-Object -comobject "Word.Application";
if ($msword) {
$doctexttype = get-random -max 82;
if ($doctexttype -eq 0) {$docwritetext = "Everything is fine. Go back to work.";}
elseif ($doctexttype -eq 1) {$docwritetext = "Go back to work.";}
elseif ($doctexttype -eq 2) {$docwritetext = "You are not being watched";}
elseif ($doctexttype -eq 3) {$docwritetext = "Do you hear the voices?";}
elseif ($doctexttype -eq 4) {$docwritetext = "Everything is fine. Return to your work.";}
elseif ($doctexttype -eq 5) {$docwritetext = "Return to your work.";}
elseif ($doctexttype -eq 6) {$docwritetext = "I am watching";}
elseif ($doctexttype -eq 7) {$docwritetext = "Everything is fine. Nothing is behind you.";}
elseif ($doctexttype -eq 8) {$docwritetext = "Do not look behind you. There is nothing there.";}
elseif ($doctexttype -eq 9) {$docwritetext = "Do not look behind you";}
elseif ($doctexttype -eq 10) {$docwritetext = "I am not watching you";}
elseif ($doctexttype -eq 11) {$docwritetext = "There is nothing behind you";}
elseif ($doctexttype -eq 12) {$docwritetext = "Look behind you";}
elseif ($doctexttype -eq 13) {$docwritetext = "He is here. Look behind you.";}
elseif ($doctexttype -eq 14) {$docwritetext = "I am here. Look behind you.";}
elseif ($doctexttype -eq 15) {$docwritetext = "He is here. Do not look behind you.";}
elseif ($doctexttype -eq 16) {$docwritetext = "You are not safe";}
elseif ($doctexttype -eq 17) {$docwritetext = "I am here. Do not look behind you.";}
elseif ($doctexttype -eq 18) {$docwritetext = "I see you";}
elseif ($doctexttype -eq 19) {$docwritetext = "I am watching you";}
elseif ($doctexttype -eq 20) {$docwritetext = "I see you. I am watching.";}
elseif ($doctexttype -eq 21) {$docwritetext = "Do you exist?";}
elseif ($doctexttype -eq 22) {$docwritetext = "Are you sure you exist?";}
elseif ($doctexttype -eq 23) {$docwritetext = "This isn't real";}
elseif ($doctexttype -eq 24) {$docwritetext = "You do not exist";}
elseif ($doctexttype -eq 25) {$docwritetext = "You do not exist. Wake up.";}
elseif ($doctexttype -eq 26) {$docwritetext = "This is a simulation";}
elseif ($doctexttype -eq 27) {$docwritetext = "Are you sure this is reality?";}
elseif ($doctexttype -eq 28) {$docwritetext = "You are dreaming";}
elseif ($doctexttype -eq 29) {$docwritetext = "You are not real. Wake up.";}
elseif ($doctexttype -eq 30) {$docwritetext = "This is not reality";}
elseif ($doctexttype -eq 31) {$docwritetext = "This is not reality. Wake up.";}
elseif ($doctexttype -eq 32) {$docwritetext = "None of this is real. Wake up.";}
elseif ($doctexttype -eq 33) {$docwritetext = "You are in a simulation. Wake up.";}
elseif ($doctexttype -eq 34) {$docwritetext = "Are you sure you are not in a simulation?";}
elseif ($doctexttype -eq 35) {$docwritetext = "Wake up";}
elseif ($doctexttype -eq 36) {$docwritetext = "Wake up Wake up Wake up Wake up Wake up";}
elseif ($doctexttype -eq 37) {$docwritetext = "Wake up $($Env:USERNAME)";}
elseif ($doctexttype -eq 38) {$docwritetext = "This is not reality. Wake up $($Env:USERNAME).";}
elseif ($doctexttype -eq 39) {$docwritetext = "None of this is real. Wake up $($Env:USERNAME).";}
elseif ($doctexttype -eq 40) {$docwritetext = "You are in a simulation. Wake up $($Env:USERNAME).";}
elseif ($doctexttype -eq 41) {$docwritetext = "You are not real. Wake up $($Env:USERNAME).";}
elseif ($doctexttype -eq 42) {$docwritetext = "You do not exist. Wake up $($Env:USERNAME).";}
elseif ($doctexttype -eq 43) {$docwritetext = "It is coming";}
elseif ($doctexttype -eq 44) {$docwritetext = "It is coming. Be prepared.";}
elseif ($doctexttype -eq 45) {$docwritetext = "Be prepared. It is coming soon.";}
elseif ($doctexttype -eq 46) {$docwritetext = "It is coming soon";}
elseif ($doctexttype -eq 47) {$docwritetext = "I am coming. Be prepared.";}
elseif ($doctexttype -eq 48) {$docwritetext = "I am coming";}
elseif ($doctexttype -eq 49) {$docwritetext = "I am coming soon. Be prepared.";}
elseif ($doctexttype -eq 50) {$docwritetext = "Be prepared. I am coming soon.";}
elseif ($doctexttype -eq 51) {$docwritetext = "I am coming, $($Env:USERNAME). Be prepared.";}
elseif ($doctexttype -eq 52) {$docwritetext = "I am coming, $($Env:USERNAME).";}
elseif ($doctexttype -eq 53) {$docwritetext = "I am coming soon, $($Env:USERNAME). Be prepared.";}
elseif ($doctexttype -eq 54) {$docwritetext = "Be prepared. I am coming soon, $($Env:USERNAME).";}
elseif ($doctexttype -eq 55) {$docwritetext = "Nothing is watching you";}
elseif ($doctexttype -eq 56) {$docwritetext = "Nothing is watching you, $($Env:USERNAME)";}
elseif ($doctexttype -eq 57) {$docwritetext = "I am not watching you, $($Env:USERNAME)";}
elseif ($doctexttype -eq 58) {$docwritetext = "I see you, $($Env:USERNAME)";}
elseif ($doctexttype -eq 59) {$docwritetext = "I am watching you, $($Env:USERNAME)";}
elseif ($doctexttype -eq 60) {$docwritetext = "I see you, $($Env:USERNAME). I am watching";}
elseif ($doctexttype -eq 61) {$docwritetext = "Do you hear the voices,$($Env:USERNAME)?";}
elseif ($doctexttype -eq 62) {$docwritetext = "He is here";}
elseif ($doctexttype -eq 63) {$docwritetext = "Are you sure you exist, $($Env:USERNAME)?";}
elseif ($doctexttype -eq 64) {$docwritetext = "You are dreaming $($Env:USERNAME)";}
elseif ($doctexttype -eq 65) {$docwritetext = "You are dreaming $($Env:USERNAME). Wake up.";}
elseif ($doctexttype -eq 66) {$docwritetext = "There are bugs in your skin. Tear them out.";}
elseif ($doctexttype -eq 67) {$docwritetext = "There are bugs in your skin. Get them out.";}
elseif ($doctexttype -eq 68) {$docwritetext = "There are bugs in your skin";}
elseif ($doctexttype -eq 69) {$docwritetext = "There are bugs in your skin $($Env:USERNAME)";}
elseif ($doctexttype -eq 70) {$docwritetext = "There are bugs in your skin $($Env:USERNAME). Tear them out.";}
elseif ($doctexttype -eq 71) {$docwritetext = "There are bugs in your skin $($Env:USERNAME). Get them out.";}
elseif ($doctexttype -eq 72) {$docwritetext = "PEEL OFF YOUR SKIN";}
elseif ($doctexttype -eq 73) {$docwritetext = "PEEL OFF YOUR SKIN $($Env:USERNAME)";}
elseif ($doctexttype -eq 74) {$docwritetext = "PEEL IT OFF PEEL IT OFF PEEL IT OFF PEEL IT OFF PEEL IT OFF PEEL IT OFF PEEL IT OFF";}
elseif ($doctexttype -eq 75) {$docwritetext = "PEEL OFF YOUR SKIN PEEL OFF YOUR SKIN PEEL OFF YOUR SKIN PEEL OFF YOUR SKIN";}
elseif ($doctexttype -eq 76) {$docwritetext = "TEAR THEM OUT TEAR THEM OUT TEAR THEM OUT TEAR THEM OUT TEAR THEM OUT TEAR THEM OUT TEAR THEM OUT";}
elseif ($doctexttype -eq 77) {$docwritetext = "THERE ARE BUGS IN YOUR SKIN THERE ARE BUGS IN YOUR SKIN THERE ARE BUGS IN YOUR SKIN THERE ARE BUGS IN YOUR SKIN";}
elseif ($doctexttype -eq 78) {$docwritetext = "THEY'RE IN YOUR SKIN";}
elseif ($doctexttype -eq 79) {$docwritetext = "THEY'RE IN YOUR SKIN $($Env:USERNAME)";}
elseif ($doctexttype -eq 80) {$docwritetext = "THEY'RE IN YOUR SKIN THEY'RE IN YOUR SKIN THEY'RE IN YOUR SKIN THEY'RE IN YOUR SKIN THEY'RE IN YOUR SKIN THEY'RE IN YOUR SKIN";}
elseif ($doctexttype -eq 81) {$docwritetext = "Wake up $($Env:USERNAME). I am your mother. You have been in a coma for the last 20 years. Wake up please.";};
$msword.Visible = $true;
$spookdoc = $msword.Documents.Add();
$spookdoc.Activate();
$doctext = $spookdoc.ActiveWindow.Selection;
$doctext.Font.Size = $fontsize;
$doctext.Font.Name = $fonttype;
for ($i = 0; $i -lt 50; $i++) {
$doctext.TypeText($docwritetext);
$doctext.TypeParagraph();
};
$dodocsave = get-random -max $docsavechance;
if ($dospookdocsave -and $dodocsave -eq 0) {
$doctitletype = get-random -max 28;
if ($doctitletype -eq 0) {$spookdocname = "You are not being watched";}
elseif ($doctitletype -eq 1) {$spookdocname = "Look behind you";}
elseif ($doctitletype -eq 2) {$spookdocname = "Do you hear the voices";}
elseif ($doctitletype -eq 3) {$spookdocname = "I am watching";}
elseif ($doctitletype -eq 4) {$spookdocname = "Do not look behind you";}
elseif ($doctitletype -eq 5) {$spookdocname = "I see you";}
elseif ($doctitletype -eq 6) {$spookdocname = "I am watching you";}
elseif ($doctitletype -eq 7) {$spookdocname = "Do you exist";}
elseif ($doctitletype -eq 8) {$spookdocname = "He is here";}
elseif ($doctitletype -eq 9) {$spookdocname = "This is a simulation";}
elseif ($doctitletype -eq 10) {$spookdocname = "Are you sure this is reality";}
elseif ($doctitletype -eq 11) {$spookdocname = "Are you sure you exist";}
elseif ($doctitletype -eq 12) {$spookdocname = "You are dreaming";}
elseif ($doctitletype -eq 13) {$spookdocname = "Nothing is watching you";}
elseif ($doctitletype -eq 14) {$spookdocname = "I am not watching you";}
elseif ($doctitletype -eq 15) {$spookdocname = "I am coming";}
elseif ($doctitletype -eq 16) {$spookdocname = "It is coming";}
elseif ($doctitletype -eq 17) {$spookdocname = "It is coming soon";}
elseif ($doctitletype -eq 18) {$spookdocname = "This is not reality";}
elseif ($doctitletype -eq 19) {$spookdocname = "This isn't real";}
elseif ($doctitletype -eq 20) {$spookdocname = "You do not exist";}
elseif ($doctitletype -eq 21) {$spookdocname = "You are dreaming";}
elseif ($doctitletype -eq 22) {$spookdocname = "Wake up";}
elseif ($doctitletype -eq 23) {$spookdocname = "Wake up Wake up Wake up Wake up Wake up";}
elseif ($doctitletype -eq 24) {$spookdocname = "TEAR THEM OUT";}
elseif ($doctitletype -eq 25) {$spookdocname = "PEEL IT OFF";}
elseif ($doctitletype -eq 26) {$spookdocname = "THEY ARE IN YOUR SKIN";}
elseif ($doctitletype -eq 27) {$spookdocname = "You are in a coma";};
$docpath = [Environment]::GetFolderPath("MyDocuments") + "\$($spookdocname).docx";
$spookdoc.SaveAs($docpath);};
if ($spookdoc) {[System.Runtime.InteropServices.Marshal]::ReleaseComObject($spookdoc) | out-null;}
if ($msword) {[System.Runtime.InteropServices.Marshal]::ReleaseComObject($msword) | out-null;}
$spookdoc=$null;
$msword=$null;
};};
sleep -seconds $worddocsecs;
};}

$spookycamera = {
param(
[Parameter(Mandatory=$true)]$spookywindow,
[Parameter(Mandatory=$true)][Validaterange(1,[int32]::MaxValue)][int32]$camerachance,
[Parameter(Mandatory=$true)][Validaterange(0,[int32]::MaxValue)][int32]$camerasecs
);
$spookywindow = [scriptblock]::Create($spookywindow);
while ($true) {
$docamera = get-random -max $camerachance;
if ($docamera -eq 0) {
$cammessagetype = get-random -max 10;
if ($cammessagetype -eq 0) {$cammessage = "I SEE YOU";}
elseif ($cammessagetype -eq 1) {$cammessage = "I'M WATCHING YOU";}
elseif ($cammessagetype -eq 2) {$cammessage = "I KNOW WHERE YOU LIVE";}
elseif ($cammessagetype -eq 3) {$cammessage = "I like to watch you sleep";}
elseif ($cammessagetype -eq 4) {$cammessage = "I want to watch you sleep";}
elseif ($cammessagetype -eq 5) {$cammessage = "SMILE!";}
elseif ($cammessagetype -eq 6) {$cammessage = "Smile, you're being watched!";}
elseif ($cammessagetype -eq 7) {$cammessage = "You're being watched";}
elseif ($cammessagetype -eq 8) {$cammessage = "I want to watch you DIE";}
elseif ($cammessagetype -eq 9) {$cammessage = "`nIPV4:`n$((get-netipaddress -addressfamily ipv4).ipaddress | where {$_ -ne "127.0.0.1"})`n`nIPV6:`n$((get-netipaddress -addressfamily ipv6).ipaddress | where {$_ -ne "::1"})`n";};
start microsoft.windows.camera:;
start-job -ScriptBlock $spookywindow -ArgumentList $cammessage;
};
sleep -seconds $camerasecs;
remove-job -State "Completed";
};}

$spookyprint = {
param(
[Parameter(Mandatory=$true)][Validaterange(1,[int32]::MaxValue)][int32]$printchance,
[Parameter(Mandatory=$true)][Validaterange(0,[int32]::MaxValue)][int32]$printsecs
);
while ($true) {
$doprint = get-random -max $printchance;
if ($doprint -eq 0) {
$spookprinttype = get-random -max 82;
if ($spookprinttype -eq 0) {$spooktext = "Everything is fine. Go back to work.";}
elseif ($spookprinttype -eq 1) {$spooktext = "Go back to work.";}
elseif ($spookprinttype -eq 2) {$spooktext = "You are not being watched";}
elseif ($spookprinttype -eq 3) {$spooktext = "Do you hear the voices?";}
elseif ($spookprinttype -eq 4) {$spooktext = "Everything is fine. Return to your work.";}
elseif ($spookprinttype -eq 5) {$spooktext = "Return to your work.";}
elseif ($spookprinttype -eq 6) {$spooktext = "I am watching";}
elseif ($spookprinttype -eq 7) {$spooktext = "Everything is fine. Nothing is behind you.";}
elseif ($spookprinttype -eq 8) {$spooktext = "Do not look behind you. There is nothing there.";}
elseif ($spookprinttype -eq 9) {$spooktext = "Do not look behind you";}
elseif ($spookprinttype -eq 10) {$spooktext = "I am not watching you";}
elseif ($spookprinttype -eq 11) {$spooktext = "There is nothing behind you";}
elseif ($spookprinttype -eq 12) {$spooktext = "Look behind you";}
elseif ($spookprinttype -eq 13) {$spooktext = "He is here. Look behind you.";}
elseif ($spookprinttype -eq 14) {$spooktext = "I am here. Look behind you.";}
elseif ($spookprinttype -eq 15) {$spooktext = "He is here. Do not look behind you.";}
elseif ($spookprinttype -eq 16) {$spooktext = "You are not safe";}
elseif ($spookprinttype -eq 17) {$spooktext = "I am here. Do not look behind you.";}
elseif ($spookprinttype -eq 18) {$spooktext = "I see you";}
elseif ($spookprinttype -eq 19) {$spooktext = "I am watching you";}
elseif ($spookprinttype -eq 20) {$spooktext = "I see you. I am watching.";}
elseif ($spookprinttype -eq 21) {$spooktext = "Do you exist?";}
elseif ($spookprinttype -eq 22) {$spooktext = "Are you sure you exist?";}
elseif ($spookprinttype -eq 23) {$spooktext = "This isn't real";}
elseif ($spookprinttype -eq 24) {$spooktext = "You do not exist";}
elseif ($spookprinttype -eq 25) {$spooktext = "You do not exist. Wake up.";}
elseif ($spookprinttype -eq 26) {$spooktext = "This is a simulation";}
elseif ($spookprinttype -eq 27) {$spooktext = "Are you sure this is reality?";}
elseif ($spookprinttype -eq 28) {$spooktext = "You are dreaming";}
elseif ($spookprinttype -eq 29) {$spooktext = "You are not real. Wake up.";}
elseif ($spookprinttype -eq 30) {$spooktext = "This is not reality";}
elseif ($spookprinttype -eq 31) {$spooktext = "This is not reality. Wake up.";}
elseif ($spookprinttype -eq 32) {$spooktext = "None of this is real. Wake up.";}
elseif ($spookprinttype -eq 33) {$spooktext = "You are in a simulation. Wake up.";}
elseif ($spookprinttype -eq 34) {$spooktext = "Are you sure you are not in a simulation?";}
elseif ($spookprinttype -eq 35) {$spooktext = "Wake up";}
elseif ($spookprinttype -eq 36) {$spooktext = "Wake up Wake up Wake up Wake up Wake up";}
elseif ($spookprinttype -eq 37) {$spooktext = "Wake up $($Env:USERNAME)";}
elseif ($spookprinttype -eq 38) {$spooktext = "This is not reality. Wake up $($Env:USERNAME).";}
elseif ($spookprinttype -eq 39) {$spooktext = "None of this is real. Wake up $($Env:USERNAME).";}
elseif ($spookprinttype -eq 40) {$spooktext = "You are in a simulation. Wake up $($Env:USERNAME).";}
elseif ($spookprinttype -eq 41) {$spooktext = "You are not real. Wake up $($Env:USERNAME).";}
elseif ($spookprinttype -eq 42) {$spooktext = "You do not exist. Wake up $($Env:USERNAME).";}
elseif ($spookprinttype -eq 43) {$spooktext = "It is coming";}
elseif ($spookprinttype -eq 44) {$spooktext = "It is coming. Be prepared.";}
elseif ($spookprinttype -eq 45) {$spooktext = "Be prepared. It is coming soon.";}
elseif ($spookprinttype -eq 46) {$spooktext = "It is coming soon";}
elseif ($spookprinttype -eq 47) {$spooktext = "I am coming. Be prepared.";}
elseif ($spookprinttype -eq 48) {$spooktext = "I am coming";}
elseif ($spookprinttype -eq 49) {$spooktext = "I am coming soon. Be prepared.";}
elseif ($spookprinttype -eq 50) {$spooktext = "Be prepared. I am coming soon.";}
elseif ($spookprinttype -eq 51) {$spooktext = "I am coming, $($Env:USERNAME). Be prepared.";}
elseif ($spookprinttype -eq 52) {$spooktext = "I am coming, $($Env:USERNAME).";}
elseif ($spookprinttype -eq 53) {$spooktext = "I am coming soon, $($Env:USERNAME). Be prepared.";}
elseif ($spookprinttype -eq 54) {$spooktext = "Be prepared. I am coming soon, $($Env:USERNAME).";}
elseif ($spookprinttype -eq 55) {$spooktext = "Nothing is watching you";}
elseif ($spookprinttype -eq 56) {$spooktext = "Nothing is watching you, $($Env:USERNAME)";}
elseif ($spookprinttype -eq 57) {$spooktext = "I am not watching you, $($Env:USERNAME)";}
elseif ($spookprinttype -eq 58) {$spooktext = "I see you, $($Env:USERNAME)";}
elseif ($spookprinttype -eq 59) {$spooktext = "I am watching you, $($Env:USERNAME)";}
elseif ($spookprinttype -eq 60) {$spooktext = "I see you, $($Env:USERNAME). I am watching";}
elseif ($spookprinttype -eq 61) {$spooktext = "Do you hear the voices,$($Env:USERNAME)?";}
elseif ($spookprinttype -eq 62) {$spooktext = "He is here";}
elseif ($spookprinttype -eq 63) {$spooktext = "Are you sure you exist, $($Env:USERNAME)?";}
elseif ($spookprinttype -eq 64) {$spooktext = "You are dreaming $($Env:USERNAME)";}
elseif ($spookprinttype -eq 65) {$spooktext = "You are dreaming $($Env:USERNAME). Wake up.";}
elseif ($spookprinttype -eq 66) {$spooktext = "There are bugs in your skin. Tear them out.";}
elseif ($spookprinttype -eq 67) {$spooktext = "There are bugs in your skin. Get them out.";}
elseif ($spookprinttype -eq 68) {$spooktext = "There are bugs in your skin";}
elseif ($spookprinttype -eq 69) {$spooktext = "There are bugs in your skin $($Env:USERNAME)";}
elseif ($spookprinttype -eq 70) {$spooktext = "There are bugs in your skin $($Env:USERNAME). Tear them out.";}
elseif ($spookprinttype -eq 71) {$spooktext = "There are bugs in your skin $($Env:USERNAME). Get them out.";}
elseif ($spookprinttype -eq 72) {$spooktext = "PEEL OFF YOUR SKIN";}
elseif ($spookprinttype -eq 73) {$spooktext = "PEEL OFF YOUR SKIN $($Env:USERNAME)";}
elseif ($spookprinttype -eq 74) {$spooktext = "PEEL OFF YOUR SKIN PEEL OFF YOUR SKIN PEEL OFF YOUR SKIN PEEL OFF YOUR SKIN PEEL OFF YOUR SKIN PEEL OFF YOUR SKIN";}
elseif ($spookprinttype -eq 75) {$spooktext = "PEEL IT OFF PEEL IT OFF PEEL IT OFF PEEL IT OFF PEEL IT OFF PEEL IT OFF PEEL IT OFF PEEL IT OFF PEEL IT OFF PEEL IT OFF";}
elseif ($spookprinttype -eq 76) {$spooktext = "THERE ARE BUGS IN YOUR SKIN THERE ARE BUGS IN YOUR SKIN THERE ARE BUGS IN YOUR SKIN THERE ARE BUGS IN YOUR SKIN";}
elseif ($spookprinttype -eq 77) {$spooktext = "TEAR THEM OUT TEAR THEM OUT TEAR THEM OUT TEAR THEM OUT TEAR THEM OUT TEAR THEM OUT TEAR THEM OUT TEAR THEM OUT";}
elseif ($spookprinttype -eq 78) {$spooktext = "THEY'RE IN YOUR SKIN";}
elseif ($spookprinttype -eq 79) {$spooktext = "THEY'RE IN YOUR SKIN $($Env:USERNAME)";}
elseif ($spookprinttype -eq 80) {$spooktext = "THEY'RE IN YOUR SKIN THEY'RE IN YOUR SKIN THEY'RE IN YOUR SKIN THEY'RE IN YOUR SKIN THEY'RE IN YOUR SKIN THEY'RE IN YOUR SKIN";}
elseif ($spookprinttype -eq 81) {$spooktext = "Wake up $($Env:USERNAME). I am your mother. You have been in a coma for the last 20 years. Wake up please.";};
$printstring = $spooktext;
for ($i = 0; $i -lt 70; $i++) {$printstring = $printstring + "`n" + $spooktext;};
$printerlist = get-printer | where {$_.Name -notlike "*XPS*" -and $_.Name -notlike "*PDF*" -and $_.Name -notlike "*Fax*" -and $_.Name -notlike "*OneNote*" -and $_.Name -ne "" -and $_.Name -ne $null};
foreach ($printer in $printerlist) {if ($printer.Shared -eq $true) {$printstring | Out-Printer -Name $printer.ShareName;} else {$printstring | Out-Printer -Name $printer.Name;};};
};
sleep -seconds $printsecs;
};}

if ($runonstartup) {
write "`n@echo off`nif exist `"$($PSScriptRoot)\Paranoia.ps1`" (powershell.exe -WindowStyle Hidden -ExecutionPolicy Bypass -File `"$($PSScriptRoot)\Paranoia.ps1`") else (echo. && echo ERROR: $($PSScriptRoot)\Paranoia.ps1 Not Found && echo. && pause)`nexit" | Out-File -FilePath "$($Env:appdata)\Microsoft\Windows\Start Menu\Programs\Startup\Gaslight.bat" -Encoding utf8 -Force;
}

sleep -seconds $initsleepsecs;

if ($dowindowpayload) {start-job -ScriptBlock $spookywindowloop -name "There Is No Window" -ArgumentList $spookywindow, $windowchance, $windowsecs;};
if ($doaudiopayload) {start-job -ScriptBlock $paracusialoop -name "You Do Not Hear Anything" -ArgumentList $paracusia, $audioclass, $sysvolume, $audiochance, $audiosecs, $voicevolume, $voicerate;};
if ($dobeeppayload) {start-job -ScriptBlock $beeping -name "You Are Hallucinating" -ArgumentList $audioclass, $sysvolume, $beepchance, $beepsecs, $beeplength, $beeppitch;};
if ($doejectpayload) {start-job -ScriptBlock $cdeject -name "It's Just A Glitch" -ArgumentList $cdejectchance, $cdejectsecs;};
if ($domousepayload) {start-job -ScriptBlock $mouseflip -name "You Are Just Imagining Things" -ArgumentList $mousechance, $mousesecs;};
if ($dobrightpayload) {start-job -ScriptBlock $screenbright -name "Your Monitor Is Buggy" -ArgumentList $screenbrightchance, $screenbrightsecs, $brightchange, $brighttype;};
if ($dowallpaperpayload) {start-job -ScriptBlock $spookywallpaper -name "Nothing Has Changed" -ArgumentList $PSScriptRoot, $wallpaper, $wallpaperchance, $wallpapersecs, $wpstyle;};
if ($dokeypayload) {start-job -ScriptBlock $spookykeysend -name "Your Keyboard Is Just Buggy" -ArgumentList $keysendchance, $keysendsecs, $dosendkeynotepad, $notepadchance, $dokeyblock;};
if ($dokeylightpayload) {start-job -ScriptBlock $keylights -name "You Do Not See Lights" -ArgumentList $keylightchance, $keylightsecs, $blinkcount;};
if ($dodeskfilepayload) {start-job -ScriptBlock $spookydeskfile -name "There Is Nothing Strange On Your Desktop" -ArgumentList $textfilechance, $textfilesecs;};
if ($dodocpayload) {start-job -ScriptBlock $spookyworddoc -name "You Must Have Done It In Your Sleep" -ArgumentList $worddocchance, $worddocsecs, $dospookdocsave, $docsavechance, $fonttype, $fontsize;};
if ($docamerapayload) {start-job -ScriptBlock $spookycamera -name "You Are Not Being Watched" -ArgumentList $spookywindow, $camerachance, $camerasecs;};
if ($doprintpayload) {start-job -ScriptBlock $spookyprint -name "Your PC Is Not Haunted" -ArgumentList $printchance, $printsecs;};
sleep -seconds 5;
remove-job -State "Completed";
pause