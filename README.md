# Clift - iOS 0.2

This project was generated with Swift 5.0


## Requirements

- iOS 12.2+
- Swift 4.0
- Apple ID
- Xcode

Clone this repository and open on Xcode

## CocoaPods

Make sure the [Stripe](https://cocoapods.org/pods/Stripe) pod version is '19.0.1':  
*"../Pods/Podfile"*
``` swift
  pod 'Stripe', '~> 19.0.1'
```

- Run `sudo gem install cocoapods` to install cocoapods  
- Run `pod install` to update cocoa pods

- Inside *"../Pods"* locate at the ***TARGET***'s sidebar: `"Objectmapper+Realm"` 
***Build Settings*** tab -> ***Swift Compiler - Language*** -> ***Swift Language Version*** -> Select: `Swift 4`

- Inside *"../Pods"* locate at the ***TARGET***'s sidebar: `"Moya"`  
***Build Settings*** tab -> ***Swift Compiler - Language*** -> ***Swift Language Version*** -> Select: `Swift 4`

## Fonts

### Sources
Download the following font families
- [Tinos](https://axented.sharepoint.com/:f:/s/Axented/Enuq8NI9bZRHuodlpuX2OEUBUTgfkY7D-MLE8NeQstQHcQ?e=vYwrcg)
- [Poppins](https://fonts.google.com/specimen/Poppins)
- [Open Sans](https://fonts.google.com/specimen/Open+Sans)

Transfer the following TrueTypeFonts (ttf) files into :  *"clift_iOS/clift_iOS/Fonts"*
- *"Mihan-Regular.ttf"*
- *"Tinos-Bold.ttf"*
- *"Tinos-BoldItalic.ttf"*
- *"Tinos-Regular.ttf"*
- *"Tinos-RegularItalic2.ttf"*
- *"Tinos-RegularItalic.ttf"*
- *"OpenSans-Regular.ttf"*
- *"OpenSans-SemiBold.ttf"*
- *"Poppins-Bold.ttf"*
- *"Poppins-Medium.ttf"*
- *"Poppins-Regulat.ttf"*
- *"Poppins-SemiBold.ttf"*

 Make sure the font file is a target member of your app; otherwise, the font file will not be distributed as part of your app [more info](https://developer.apple.com/documentation/uikit/text_display_and_fonts/adding_a_custom_font_to_your_app)

 ## Build

 - To run, first make sure your apple ID is linked to the project: 
 Go into *"clift_iOS"* -> ***"Signing & Capabilities"*** tab -> ***"Team"*** (Select or Add an account)  
 - At the Xcode toolbar in the ***Scheme pop-up menu***, under iOS Simulators, choose and iphone template to run your project [more info](https://developer.apple.com/library/archive/referencelibrary/GettingStarted/DevelopiOSAppsSwift/BuildABasicUI.html#//apple_ref/doc/uid/TP40015214-CH5-SW12)
 
 ## Test Fligth
 - To depoy into Test Flight  
 - ***Xcode*** -> ***Product*** -> ***"Clean Build Folder"***
 - ***Xcode*** -> ***Product*** -> ***Scheme*** -> ***Edit Scheme*** -> ***Archive*** -> ***Build Configuration*** -> ***"Release"***
 - At the Xcode toolbar in the ***Scheme pop-up menu***, select ***Generic iOS Device***
 - At ***clift_iOS*** -> ***"General"*** tab-> ***Targets*** -> ***clift_iOS*** -> *make sure Dispay Name: "CLIFT"*, *Bundle Identifier: "com.cliftapp.clift"*
  - At ***clift_iOS*** -> ***"Signing & Capabilities"*** tab-> ***Release*** -> ***Team*** -> Select "Fernanda Cueva" Apple Account (See Credentials at Dashlane)
 - ***Xcode*** -> ***Product*** -> ***Archive*** (Wait for it to finish the process, around 10 minutes approximately)
 - At the new pop up window (this Window can also be accesed by goingo into ***Window*** tab -> ***Organizer***), select latest Archive -> ***Distribute App*** -> ***App Store Connect*** -> ***Upload*** -> ***Include bitcode for iOS content [checked]*** and ***Upload your app's symbols to receive symbolicated reports from Apple*** -> ***Automatically manage signing*** 
 - If asked for a private key [download](https://axented.sharepoint.com/sites/Axented/Shared%20Documents/Forms/AllItems.aspx?id=%2Fsites%2FAxented%2FShared%20Documents%2FAxented%2FClift%2FProduct%20Management%2FCertificates%5FClift%2Ezip&parent=%2Fsites%2FAxented%2FShared%20Documents%2FAxented%2FClift%2FProduct%20Management&p=true&originalPath=aHR0cHM6Ly9heGVudGVkLnNoYXJlcG9pbnQuY29tLzp1Oi9zL0F4ZW50ZWQvRVVYNUJlNUFvYXhLbkxZOUoyek5QZVlCTGdOQzVRQXViM2RJZzMtQ0YxbHdqUT9ydGltZT1PQWl4ZUtFcTJFZw) and install : *"AppleCliftCertificate.p12"* (get password at Dashlane)-> afterwards click on *"Manage certificate"* to add it -> at the *"Review clift:iOS.ipa contents:"* click ***Upload***
 - At [App Store Connect](https://appstoreconnect.apple.com/) go into ***"My Apps"*** -> ***"Clift"*** -> ***TestFlight*** where you can review the current state of the latest compiled version" ("Pendiente", "Pendiente de revisión", "En pruebas"), compiled version should go from "Pendiente" to "Pendiente de revision" in approximately 1 hour, after its done, Clift Testers at Test Flight will receive a notification where they can update the app and run it on their phones.

  

 
 





