

import 'package:firebase_messaging/firebase_messaging.dart';

class PushNotificationProvider{

  FirebaseMessaging _firebaseMessaging = FirebaseMessaging();

  initNotifications(){

    _firebaseMessaging.requestNotificationPermissions();
    _firebaseMessaging.getToken().then((value) {
      print("TOKENFIREBASE: "+value);
    });

    _configure();
  }

  _configure(){
    _firebaseMessaging.subscribeToTopic("comunidad");
   _firebaseMessaging.configure(
       onMessage: (info){
         print("onMessage");
         print(info);
       },
       onResume: (info){
         print("onResume");
         print(info);
       },
       onLaunch: (info){
         print("onLaunch");
        print(info);
       }
   );
  }
}