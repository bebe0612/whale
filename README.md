# whale
a whale is navigator developed using navigation 2.0.

## Contents

1.Navigation

2.Dialog

3.Global

## Navigation Usage
### Push
You can push new page on specific page with `Whale.go()` method. It needs `on` argument and `to` argument which you want to push on page stack.
```dart
// These three method's exactly same operation

Whale.goByContext(from: context, to: AlarmView());
Whale.goByView(from: this or this.widget, to: AlarmView());
```
####Q. Why `to` argument type is Widget?
because of some projects which communicate with each page with callback function see below:
```dart
Whale.goByView(
  from: this,
  to: PostAddview(
    onPostAdded: (post){
      // some projects use callback to communicate with each page
      _addPost(post);  
    }
  ),
  toName: '/post-add',
);
```

### Pop
Like push operation, you can pop specific page by key or context.
```dart
Whale.backByContext(context);
Whale.backByView(this or this.widget);
```

### Replace
If you want to replace specific page to other, do below:
```dart
Whale.replaceByContext(from: context, to: AlarmView());
Whale.replaceByView(from: this or this.widget, to: AlarmView());
```
## Dialog Example

Whale manages dialog stack per page.
So, If you want to show dialog, you should select a page which will present it.

### Show Dialog
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
## Util Function

For convenience, Whale gives you some streams and methods. 

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