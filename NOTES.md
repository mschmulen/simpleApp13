Notes
===



# CloudKit



## CloudKit sharing


#### CloudKit Sharing was introduced at WWDC 2016 https://developer.apple.com/videos/play/wwdc2016/226/


#### https://medium.com/@valv0/custom-cloudkit-sharing-workflow-522d67ec0c00

CloudKit comes with a built-in feature related to sharing private data among participants on a container, namely CKShare.


MyRecord: CKRecord {
    var name: String
    var privateShareUrl: String 
}

Marked as part of a RecordZone that will be shared with selected participants


Shared Zone = "FamilyZone"


Who share should be in charge of:
1. Create the CKShare
1. Pass it to a specific UICloudSharingController
1. Create a URL to share using third party apps


Users that want to be added need to:
1. Click on the link for accepting the shared url
1. Implement some delegates on the UIApplication

- enabling userDiscoverability among app users, otherwise the rest of the process will not work due to privacy constraints 




## Family Sharing 


---










##### OLD  Reference :  https://stackoverflow.com/questions/31660156/cloudkit-share-data-between-different-icloud-accounts-but-not-with-everyone

There are a couple of ways to achieve something like this. In all cases it comes down to:

1. Add a CKReference field that will be populated with the ID of the user that you want to share with.
1. Make sure your predicate will filter for that CKReference field where the ID is yours (shared with you)

Where and how you store that CKReference depends on how you want to share.

1. If you only want to share with only one person, then just include that CKReference field into your main recordType. Do not add it to the message as you stated in your question. Add an extra field.
1. If you want to share to a limited number of people, then you could add a field to your recordType which is a list of CKReference.
1. If you want to share with a large group of people, then you could add a group recordType which would have a groupID plus a groupMembers recordType where you would store all user CKReference id's who are member of that group.

In all cases the solution would be secure. It all comes down to the predicates that you define in your app. If one of your predicate filters is incorrect, then it could happen that someone sees something that is not for him.



### Misc Notes

https://developer.apple.com/forums/thread/76420


The limit of 750 references does NOT apply to the parent/child references when using CKShare! But you can only share 5.000 CKRecords in total using a CKShare - otherwise, this undocumented limit will hit you

Maximum number of source references to a single target where the action is delete self = 750



---



