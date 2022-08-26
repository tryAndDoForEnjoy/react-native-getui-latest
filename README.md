# react-native-getui-latest



基于个推·消息推送Android SDK(3.2.12.0) 、iOS SDK(2.6.7.0)、@react-native-community/push-notification-

ios的react-native消息推送库。




## Install

```java
  
  // first install 
  npm install @react-native-community/push-notification-ios -s
  npm install react-native-getui-latest -s

  // then link
  react-native link @react-native-community/push-notification-ios
  react-native link react-native-getui-latest
  
  
```

## Config


### Android

目前android只支持在线接收个推推送消息，不支持厂商推送，消息到达后sdk会做相关处理并展示至系统通知栏中，RN端不需做任何处理。

#### 1、在MainActivity.java下添加如下代码:

```java

import android.os.Bundle;   // add this
import com.reactlibrary.ReactNativeGetuiLatestModule;  // add this
public class MainActivity extends ReactActivity {
    // add this
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        ReactNativeGetuiLatestModule.setMainApplication(this);   // 如果需RN端手动启动sdk添加此行
        // ReactNativeGetuiLatestModule.initPush(this);  // 原生端自启动添加此行
    }
    /**
     * Returns the name of the main component registered from JavaScript.
     * This is used to schedule rendering of the component.
     */
    @Override
    protected String getMainComponentName() {
        return "demo";
    }
}

```



#### 2、 配置GETUI_APPID



android/app/build.gradle文件中的 android.defaultConfig中的manifestPlaceholders添加相关参数，如下所示:



```java
  defaultConfig {
      manifestPlaceholders = [          
          GETUI_APPID       : "your appid",
      ]        
  }
```



android/app/src/main/AndroidManifest.xml添加如下内容:



```xml
<application
...
<!--此项需设置为true-->
android:allowBackup="true"   
...
>
<meta-data
    android:name="PUSH_APPID"
    android:value="your appid" />
</application>        

```



#### 3、设置gradle版本、minSdkVersion



打开android/build.gradle将gradle版本设置为4.0.1及以上,或使用3.3.3 、3.4.3 、3.5.4 、 3.6.4版

本;minSdkVersion设置为19，如下所示：



```java

dependencies {
        classpath 'com.android.tools.build:gradle:3.3.3'
}

// 设置minSdkVersion
ext {
    buildToolsVersion = "28.0.3"
    minSdkVersion = 19      // 修改此项
    compileSdkVersion = 28
    targetSdkVersion = 28
    supportLibVersion = "28.0.0"
}
```



#### 4、设置推送图标



客户端必须配置 push_small.png 资源文件，若客户端无该文件，会导致通知栏消息无法展示。

设置通知栏及通知栏顶部图标：为了修改默认的通知图标以及通知栏顶部提示小图标，请务必在资源目录的 

res/drawable-ldpi/、res/drawable-mdpi/、res/drawable-hdpi/、res/drawable-xhdpi/、res/drawable-

xxhdpi/ 等各分辨率目录下，放置相应尺寸的文件名为 push.png 和 push_small.png 的图片（该图片内容为您应

用自定义的图标文件），如图所示：

```javascript

Getui_SDK_Demo_AS_official/
    |- app/
    |    |- src/
    |       |- main/
    |         |- res/
    |             |- drawable-hdpi/
    |                 |- push.png
    |                 |- push_small.png
    |             |- drawable-ldpi/
    |                 |- push.png
    |                 |- push_small.png
    |             |- drawable-mdpi
    |                 |- push.png
    |                 |- push_small.png
    |             |- drawable-xhdpi
    |                 |- push.png
    |                 |- push_small.png
    |             |- drawable-xxhdpi
    |                 |- push.png
    |                 |- push_small.png
    | ......

```



#### 5、添加个推 maven 库地址



打开android/build.gradle,在allprojects.repositories 块中，添加个推 maven 库地址 ，如下所示：



```java

buildscript {
    ...
}

allprojects {
    repositories {
        ...
        // 添加此项
        maven {
            url "https://mvn.getui.com/nexus/content/repositories/releases/"
        }
        ...
    }
}

```


### IOS

ios端支持厂商推送(需要在App Store配置好推送证书)及个推推送，对于厂商推送已在原生端处理好

调用系统通知栏，个推推送需在RN端通过@react-native-community/push-notification-ios调用系

统通知栏。

#### 1、GTSDK导入

打开工程，将GTSDK导入，详见下图所示:

![](https://github.com/tryAndDoForEnjoy/react-native-getui-latest/blob/main/2.png)


点击<font color="red">add</font>


![](https://github.com/tryAndDoForEnjoy/react-native-getui-latest/blob/main/1.png)



在导入时，Xcode正常情况下会自动添加引用，但是偶尔也会不添加，注意检查下图中的引用路径，

如果报错找不到库或者头文件，一般都是下面的引用没有添加。



![](https://github.com/tryAndDoForEnjoy/react-native-getui-latest/blob/main/3.png)



#### 2、在项目设置中添加以下系统库支持：



```
libc++.tbd
libz.tbd
libsqlite3.tbd
libresolv.tbd
Security.framework
MobileCoreServices.framework
SystemConfiguration.framework
CoreTelephony.framework
AVFoundation.framework
CoreLocation.framework
UserNotifications.framework (iOS 10 及以上需添加，使用 Optional 方式接入)

```


#### 3、开启推送功能

点击下图中的<font color="red">“+”</font>添加以下配置：Access WiFi Information、Push Notifications、Background Modes -> Remote 

notifications. 详见下图所示：



![](https://github.com/tryAndDoForEnjoy/react-native-getui-latest/blob/main/4.png)



#### 4、相关原生代码添加

找到工程中的AppDelegate.h添加以下内容：

``` obj-c

#import <React/RCTBridgeDelegate.h>
#import <UIKit/UIKit.h>
// add this
#import <GTSDK/GeTuiSdk.h>
#import <UserNotifications/UNUserNotificationCenter.h>
#define kGtAppId @"your appid"
#define kGtAppKey @"your appkey"
#define kGtAppSecret @"your appsecret"
#import "RNGetuiPush.h"
// 添加UNUserNotificationCenterDelegate、GeTuiSdkDelegate
@interface AppDelegate : UIResponder <UIApplicationDelegate, RCTBridgeDelegate, UNUserNotificationCenterDelegate, GeTuiSdkDelegate>

@property (nonatomic, strong) UIWindow *window;

@end

```

找到工程中的AppDelegate.m添加以下内容：


```obj-c
...
// add this
#import <UserNotifications/UserNotifications.h>
#import <RNCPushNotificationIOS.h>
...

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
  // 接入个推
  [GeTuiSdk startSdkWithAppId:kGtAppId appKey:kGtAppKey appSecret:kGtAppSecret delegate:self launchingOptions:launchOptions];
  // 注册远程通知
  [GeTuiSdk registerRemoteNotification: (UNAuthorizationOptionSound | UNAuthorizationOptionAlert | UNAuthorizationOptionBadge)];
  ...
  [self.window makeKeyAndVisible];
  // add this
  UNUserNotificationCenter *center = [UNUserNotificationCenter currentNotificationCenter];
  center.delegate = self;
  return YES;
}


#pragma mark - 个推相关添加
/// 收到透传消息
/// @param userInfo    推送消息内容
/// @param fromGetui   YES: 个推通道  NO：苹果apns通道
/// @param offLine     是否是离线消息，YES.是离线消息
/// @param appId       应用的appId
/// @param taskId      推送消息的任务id
/// @param msgId       推送消息的messageid
/// @param completionHandler 用来在后台状态下进行操作（通过苹果apns通道的消息 才有此参数值）
- (void)GeTuiSdkDidReceiveSlience:(NSDictionary *)userInfo fromGetui:(BOOL)fromGetui offLine:(BOOL)offLine appId:(NSString *)appId taskId:(NSString *)taskId msgId:(NSString *)msgId fetchCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler {
    [[NSNotificationCenter defaultCenter]postNotificationName:DID_RECEIVE_GTPAYLOAD_NOTIFICATION object:@{@"type":@"payload",@"userInfo":userInfo}];
}


#pragma mark - @react-native-community/push-notification-ios相关添加

// Required for the register event.
- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken
{
 [RNCPushNotificationIOS didRegisterForRemoteNotificationsWithDeviceToken:deviceToken];
}
// Required for the notification event. You must call the completion handler after handling the remote notification.
- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo
fetchCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler
{
  [RNCPushNotificationIOS didReceiveRemoteNotification:userInfo fetchCompletionHandler:completionHandler];
}
// Required for the registrationError event.
- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error
{
 [RNCPushNotificationIOS didFailToRegisterForRemoteNotificationsWithError:error];
}
// Required for localNotification event
- (void)userNotificationCenter:(UNUserNotificationCenter *)center
didReceiveNotificationResponse:(UNNotificationResponse *)response
         withCompletionHandler:(void (^)(void))completionHandler
{
  [RNCPushNotificationIOS didReceiveNotificationResponse:response];
}
-(void)userNotificationCenter:(UNUserNotificationCenter *)center
willPresentNotification:(UNNotification *)notification
withCompletionHandler:(void (^)(UNNotificationPresentationOptions options))completionHandler
{
  completionHandler(UNNotificationPresentationOptionSound | UNNotificationPresentationOptionAlert | UNNotificationPresentationOptionBadge);
}

```



## Usage

```javascript
import { NativeAppEventEmitter } from 'react-native';
import GetuiSdk from 'react-native-getui-latest'
import PushNotificationIOS from '@react-native-community/push-notification-ios';

const {
	startSdk,    // 手动启动sdk  android only 
	clientId,		 // 获取cid
	version,		 // 获取版本号
	isPushTurnedOn,   // 获取sdk运行状态 
} = GetuiSdk;

// 手动启动示例  --android原生端调用ReactNativeGetuiLatestModule.setMainApplication(this);

startSdk( isSuccessed => {
	if(isSuccessed) {
		clientId(cid => {
			console.log(cid)
		})
	}
})

// 自启动示例  --android原生端调用ReactNativeGetuiLatestModule.initPush(this);

clientId( cid => {
	console.log(cid)
})

// ios端对于个推的消息处理
componentDidMount() {
	NativeAppEventEmitter.addListener('receiveRemoteNotification', (notification) => {
			switch(notification.type) {
				case 'paylaod':
					PushNotificationIOS
						.presentLocalNotification(notification.userInfo)   // 取决于userInfo数据结构  
					break;
				default: 
					break;
			}
		})
}

```


## 问题反馈



问题反馈至[Meyun](wks19921023@163.com) 
