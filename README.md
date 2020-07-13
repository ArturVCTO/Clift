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
 





