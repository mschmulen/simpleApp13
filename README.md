SimpleApp13
====

Simple iOS13 SwiftUI and Combine app 

## First Run 

- `git clone git@github.com:mschmulen/simpleApp13.git`
- CMD+R to run in simulator

## General Overview 

- Global AppState `ObservableObject` as dependecy injected and shared app state.
- TopLevel app experience is 3 tabs (TopTabView) with Boats (BoatView), Marinas (MarinaView), and User (UserView) tabs.
- Parent context view to manage and display the 3 "Top Views": TopTabView, AuthenticationView, PurchaseView

## Sessions

*WIP Potential topics* TBD

- Beautify AuthenticationView  and PurchaseView
- Local Storage to persist simple user state
- Remote data services
- `Bindable` View properties.
- SwiftUI Detail View of models ( with edit )


---

## Time Log

- v0.1.1, basic app infastructure of global app state, three tabs, 2 models, with user, device and purchase service. (~2_hr)
- v0.1.2, basic app infastructure of global app state, three tabs, 2 models, with user, device and purchase service. (~45_min)

