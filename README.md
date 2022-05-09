├── fonts
├── images
├── android
├── ios
├── lib
│   ├── CatagoryPage.dart
│   ├── DataProvider.dart
│   ├── Events.dart
│   ├── FolderPage.dart
│   ├── HomePage.dart
│   ├── PhotoFolderGridView.dart
│   ├── PhotoList.dart
│   ├── PhotoView.dart
│   ├── SearchResult.dart
│   ├── TensorflowResultPanel.dart
│   ├── bloc
│   │   └── photo_list
│   │       ├── PhotoListCubit.dart
│   │       └── PhotoListState.dart
│   ├── database
│   │   └── Photo.dart
│   ├── generated_plugin_registrant.dart
│   ├── main.dart
│   ├── model
│   │   └── FriendInfo.dart
│   ├── pages
│   │   ├── AddFriends.dart
│   │   ├── ScannerPage.dart
│   │   ├── Tabs.dart
│   │   ├── TestPage.dart
│   │   ├── friends
│   │   │   ├── FriendsPage.dart
│   │   │   └── FriendsSelectPage.dart
│   │   ├── photo_edit_page
│   │   │   └── PhotoEditPage.dart
│   │   ├── tabs
│   │   │   └── Setting.dart
│   │   └── user
│   │       ├── LoginPage.dart
│   │       ├── PassResetPage.dart
│   │       └── RegisterPage.dart
│   ├── res
│   │   └── listData.dart
│   ├── routes
│   │   ├── API.dart
│   │   └── Routes.dart
│   ├── tensorflow
│   │   └── TensorflowProvider.dart
│   ├── util
│   │   ├── CommonUtil.dart
│   │   ├── DialogUtil.dart
│   │   ├── FavoritesUtil.dart
│   │   ├── Global.dart
│   │   ├── ListUtil.dart
│   │   ├── PermissionUtil.dart
│   │   ├── RegExpUtil.dart
│   │   ├── ServiceUtil.dart
│   │   └── ShareUtil.dart
│   └── widgets
│       ├── AccountButton.dart
│       ├── ColorfulProgressBar.dart
│       ├── Form.dart
│       ├── GroupedView.dart
│       ├── HiddenAppbar.dart
│       ├── ListedPhoto.dart
│       ├── MultiChoiceChip.dart
│       ├── PhotoToolBar.dart
│       ├── SearchBar.dart
│       ├── SelectionToolBar.dart
│       ├── TabsDrawer.dart
│       ├── filter
│       │   ├── CarouselFlowDelegate.dart
│       │   ├── FilterItem.dart
│       │   ├── FilterSelector.dart
│       │   └── README.md
│       └── user
│           ├── CountdownButton.dart
│           ├── LoginForm.dart
│           ├── PassResetForm.dart
│           └── RegisterForm.dart
├── README.md
├── install_tensorflow.bat
├── pubspec.yaml

How to run

Fore-end application
  Windows：
    1.	Download flutter SDK
      Download from Flutter website：https://docs.flutter.dev/development/tools/sdk/releases
    2.	Unzip the Flutter SDK
    3.	Add the flutter SDK package to the environment variable
      Add flutter/bin into path
    4.	Test whether the flutter environment variable is successful
      Enter flutter at the command prompt. If the following image appears, the configuration is successful.
    5.	Android settings
      Download and install Android studio, start Android studio, and then execute the Android studio installation wizard. This will install the latest Android SDK, Android SDK platform tools and Android SDK build tools
    6.	Vscode configuration
      a. Install the plug-in flutter
      b. Call View > command palette... Enter 'doctor' and select 'fluent: run flutter doctor' action. Check whether there is a problem with the output in the 'output' window.
      c. At this time, vscode will ask you to specify the installation path of the shutter SDK and select locate, which is "the decompression path specified in step 1 + / bin".
      d. If step 2 displays no issue found, Indicates that the environment is installed successfully.
    7.	Run the flutter project
      Enter flutter pub to get all the dependencies
      Type flutter run to run the project
  Linux:
    1.	Download flutter SDK
      Download from Flutter website：https://docs.flutter.dev/development/tools/sdk/releases?tab=linux
    2.	Unzip the Flutter SDK
      Unzip the file in the terminal sudo tar xf [where you download]
    3.	Add flutter related path to system file
      Execute sudo GEDIT ~ /. From the command line bashrc
      Add at the end of the file:
        export FLUTTER_STORAGE_BASE_URL="https://mirrors.tuna.tsinghua.edu.cn/flutter" 
        export PUB_HOSTED_URL="https://mirrors.tuna.tsinghua.edu.cn/dart-pub"
        export PATH="$PATH:[flutter-path]/bin"
      Exit after saving
      On the command line, enter source ~ / Bashrc make changes effective
    4.	Enter flutter doctor on the command line, and the system will judge which dependencies are not configured at present
    5.	Test whether the flutter environment variable is successful
      Enter flutter at the command prompt. If the following image appears, the configuration is successful.
    6.	Android settings
      Download and install Android studio, start Android studio, and then execute the Android studio installation wizard. This will install the latest Android SDK, Android SDK platform tools and Android SDK build tools
    7.	Vscode configuration
      a. Install the plug-in flutter
      b. Call View > command palette... Enter 'doctor' and select 'fluent: run flutter doctor' action. Check whether there is a problem with the output in the 'output' window.
      c. At this time, vscode will ask you to specify the installation path of the shutter SDK and select locate, which is "the decompression path specified in step 1 + / bin".
      d. If step 2 displays no issue found, Indicates that the environment is installed successfully.
    8.	Run the flutter project
      Enter flutter pub to get all the dependencies
      Type flutter run to run the project




##Dependency requirements
Because you want to be compatible with photo_ The package of manager operation * requires kotlin version greater than 1.5.21
Kotlin >= `1.5.21`
Check the version of kotlin by searching for kotlin in file - > Settings - > plugins in Android studio
In Android / build Modify in gradle ` ext.kotlin_ Version ` is the version number of the current kotlin
