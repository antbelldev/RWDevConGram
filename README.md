# RWDevConGram

## Installation

1. Install Cocoapods : `sudo gem install cocoapods`
2. Create a directory, clone the repo :
* `cd ~/path/to/directory`
* `git init`
* `git clone https://github.com/antoinebell/RWDevConGram.git`
3. Init Cocoapods : `pod init`
4. Open `Podfile` with Xcode
5. Uncomment `use_frameworks!`
6. Add under these requirements :
* `pod 'Firebase/Core'`
* `pod 'Firebase/Auth'`
* `pod 'Firebase/Storage'`
* `pod 'Firebase/Database'`
* `pod 'Tags'`
7. Run `pod install`
8. Open the `.xcworkspace` project file
9. Build and run !
