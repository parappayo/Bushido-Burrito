AIR for Android instructions

1. Configuration:

	- edit 'bat\SetupSDK.bat' for paths to Flex SDK and Android SDK (default should be ok)
	
	- install your device's USB drivers:
	    http://developer.android.com/sdk/oem-usb.html
	- enable "USB debugging" on your Android device:
	    Parameters > Applications > Development > USB Debugging


2. Creating a self-signed certificate:

	- run 'bat\CreateCertificate.bat' to generate your self-signed certificate,

	(!) wait a minute before packaging.


3. Build from FlashDevelop as usual (F8)


4. Run/debug the application on the desktop as usual (F5 or Ctrl+Enter)


5. Install AIR runtime on your device:

	- run 'bat\InstallAirRuntime.bat'


6. Running/debugging the application on the device:

	6.a. Build/Debug directly on device
	- edit 'Run.bat' and change the run target 'goto desktop' by 'goto android-debug'
	- build & run as usual (Ctrl+Enter or F5) to package, install & run the application on your device
	
	6.b. Debug occasionally on device
	- Debug-build from FlashDevelop (F8)
	- run 'PackageApp.bat' to package and install a debug version of the application
	- start FlashDevelop debugger: Debug > Start Remote Session
	- start the application on device
	- the application should connect to FlashDevelop interactive debugger as usual


7. Packaging for release:

	- Before building for Ouya, you need to copy an icon here:

C:\Program Files (x86)\FlashDevelop\Tools\flexsdk\lib\android\lib\resources\app_entry\res\drawable-xhdpi\ouya_icon.png

	- This icon must have dimensions 732x412 and will appear in the app store.

	- Release-build from FlashDevelop (F8)
	- run 'PackageApp.bat' and select Android "captive"
	- you may need to edit SetupApplication.bat to contain the password
	  for the keystore file (.p12) being used.

8. Modifying package for the Ouya store

	- You may need to change your package name to match whatever
	  the Ouya store settings are.

	- NOTE: Air prepends "air." to whatever your package name is when
	  building.  To avoid trouble, take this into account when creating
	  your game listing on the Ouya site.

	Helpful guide here,

http://helpx.adobe.com/air/kb/opt-out-air-application-analytics.html

http://forums.adobe.com/message/4964198

	You can check this using the aapt tool,

		aapt dump badging dist/BlackSquare.apk

	And try to fix it (but I couldn't get this to work),

		aapt package --rename-manifest-package com.ghostpxs.BlackSquare dist/BlackSquare

http://stackoverflow.com/questions/9862138/how-can-i-change-the-application-package-name-for-an-android-app-via-command-lin

http://stackoverflow.com/questions/15206553/android-rename-package-in-eclipse

