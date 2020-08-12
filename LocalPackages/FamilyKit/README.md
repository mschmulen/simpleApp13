FamilyKit
===

FamilyKit provide persistance for User and family related data

---

# FamilyKitAppState

Top State management for FamilyKit

### Usage
```
let familyKitAppState = FamilyKitAppState ( container: container)
familyKitAppState.onStartup()
```

--- 

# Models

### CKUser

### CKKidModel

### CKAdultModel

# Services 

### CKUserService

``` 
var container = CKContainer.default()
container = CKContainer(identifier: CKContainerIdentifier)

let service = CKUSerService<CKKitModel>(container: container)
service.fetch(completion: { result in
 switch result {
 case .success(let models) :
     print( "success \(models)")
 case .failure(let error):
     print( "error \(error)")
 }
})
service.subscribe()
service.listenForNotifications()
```


### CKPrivateModelService and CKPublicModelService

##### Usage:
 
``` 
var container = CKContainer.default()
container = CKContainer(identifier: CKContainerIdentifier)

let service = CKPrivateModelService<CKKitModel>(container: container)
service.fetch(completion: { result in
 switch result {
 case .success(let models) :
     print( "success \(models)")
 case .failure(let error):
     print( "error \(error)")
 }
})
service.subscribe()
service.listenForNotifications()
```






## TODO 

- rebuild the ActivityDefinition and ActiveActivity
- dont forget to add parameters ?? 
- add minAge and maxAge to Activity

