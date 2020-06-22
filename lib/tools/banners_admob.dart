
import 'package:firebase_admob/firebase_admob.dart';
import 'package:flutter/cupertino.dart';

class BannersAdmob{

  BannerAd myCustomBaner;

  BannersAdmob(){
    FirebaseAdMob.instance.initialize(appId: FirebaseAdMob.testAppId);

  }

  BannerAd large(BuildContext context){
    var large = BannerAd(
      adUnitId: "ca-app-pub-3019721532428168/2302766225",
      size: AdSize.banner,
      listener: (MobileAdEvent event){
        if (event == MobileAdEvent.loaded){
          myCustomBaner..show(
            anchorType: AnchorType.bottom,
            anchorOffset: MediaQuery.of(context).size.height * 0.15
          );
        }
      }
    );

    return myCustomBaner = large..load();
  }

  dispose(){
    myCustomBaner.dispose();
  }

}