
## How to run

### Fore-end application


  **Windows:**  
+ Download flutter SDK  Download from Flutter website：https://docs.flutter.dev/development/tools/sdk/releases  
+ Unzip the Flutter SDK.  
+ Add the flutter SDK package to the environment variable.  
> Add `flutter/bin` into `path`  
+ Test whether the flutter environment variable is successful.  
> Enter flutter at the command prompt. If the following image appears, the configuration is successful.  
+ Android settings.  
> Download and install Android studio, start Android studio, and then execute the Android studio installation wizard.  
- Run the flutter project.  
> Enter flutter pub to get all the dependencies  
> Type flutter run to run the project  
      
  **Linux**:  
- Download flutter SDK  
>Download from Flutter website：https://docs.flutter.dev/development/tools/sdk/releases?tab=linux  
- Unzip the Flutter SDK  
>Unzip the file in the terminal `sudo tar xf [where you download]`  
- Add flutter related path to system file  
>Execute `sudo GEDIT ~ /. From the command line bashrc`  
>Add at the end of the file:  
        `export FLUTTER_STORAGE_BASE_URL="https://mirrors.tuna.tsinghua.edu.cn/flutter" `  
        `export PUB_HOSTED_URL="https://mirrors.tuna.tsinghua.edu.cn/dart-pub"`  
        `export PATH="$PATH:[flutter-path]/bin"`  
>Exit after saving  
>On the command line, enter `source ~ / Bashrc make changes effective`  
- Enter flutter doctor on the command line, and the system will judge which dependencies are not configured at present  
- Test whether the flutter environment variable is successful  
>Enter flutter at the command prompt. If the following image appears, the configuration is successful.  
- Android settings  
>Download and install Android studio, start Android studio, and then execute the Android studio installation wizard. This will install the latest Android SDK, Android SDK platform tools and Android SDK build tools  
-	Run the flutter project  
>Enter flutter pub to get all the dependencies  
>Type flutter run to run the project  




##Dependency requirements  
Because you want to be compatible with photo_ The package of manager operation * requires kotlin version greater than 1.5.21  
Kotlin >= `1.5.21`  
Check the version of kotlin by searching for kotlin in file - > Settings - > plugins in Android studio  
In Android / build Modify in gradle ` ext.kotlin_ Version ` is the version number of the current kotlin  
