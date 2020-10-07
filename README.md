SimpleApp13
====

Simple iOS13 SwiftUI and Combine app 

# First Run 

- `git clone git@github.com:mschmulen/simpleApp13.git`
- CMD+R to run in simulator

# General Overview 

TODO

--- 

# Misc Notes 

### Configure for Production vs Development iCloud services:

- `com.apple.developer.icloud-container-environment` property in the SimpleApp.entitlements file


## Release Notes

##### Build 44, WIP
- wizard for creating Activity descriptions
- 

##### Build 43
- Convert to SwiftUI2 and iOS 14 
- minor improvements

##### Build 42, Released
- fix for fulfillmentStatus
- beautify the notification for chat

##### Build 41, Released
- Sharing infrastructure work
- fix, remove "+" in "new activity" card


##### Build 40, Released
- Remove the emoji type floating accessory above the cards
- rename "bucks Something" to "Reward something"
- improvement on bucks/rewards data models to support purchase player and also definition reference
- added Rewards and bucks to the main family page.
- Button on "fulfilling" purcheased "rewards" on reward detail screen.
- misc clean up.


##### Build 39, Released
- More work on Silent Push notifications 
- Fix for the Chat push notification ( you need to delete your old stuff )
- Deeplinking dev view for testing

##### Build 38, Released

- Fix for chat preview update.
- Update MainFamilyTab look and feel.
- Added "Complete" button to activity.
- Deeplink to family tab when an action is updated
- Chat improvements
- DeepLinking and Notification management ( check out the dev view in the user profile )
- Notification for Family chat deep links to the chat page
- miscellaneous pixel pushing  

