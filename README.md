# whale
a flutter navigation 2.0 router for mobile app.

---
## Navigation Example
### Push & Push All

### Pop & Pop Until

### Replace & Replace All
asd

---
## Dialog Example

### Showing dialog on specific page
```dart
Whale.showDialogWithContext(
  context,
  CustomDialog(
    title: 'Hi, there!',
    subTitle: 'Welcome to my app.',
    onCloseButtonPressed: () {
        
    }
  ),
  key: 'IntroDialog', 
);
```

---
## Util Function

### Get current page stack
You can get current page stack

``` dart
String url = Whale.getCurrentUrl();
print(url);
// '/TreatmentHomeView/AlarmListView/AlarmDetailView
```
### Listening back button press event (Android)
You can listen back button press event stream anywhere like below :
``` dart 
var subscription = Whale.backButtonStream((event){
    PageConfig pageConfig = event.onPageConfig;
    print(pageConfig.pageName);
});
```