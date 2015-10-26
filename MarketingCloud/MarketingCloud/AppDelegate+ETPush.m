//
//  AppDelegate+ETPush.m
//  Generated by the Salesforce Marketing Cloud App Accelerator.
//

#import "AppDelegate+ETPush.h"
#import "ETPush.h" // From the SDK
#import "AppDelegate+ETPushConstants.h"

@implementation AppDelegate (ETPush)

- (BOOL)application:(UIApplication *)application shouldInitETSDKWithOptions:(NSDictionary *)launchOptions {
    BOOL successful = NO;
    NSError *error = nil;
    
#ifdef DEBUG
    /**
     To enable Debug Log set to YES
    */
    [ETPush setETLoggerToRequiredState:YES];
    /**
     Configure and set initial settings of the JB4ASDK
     */
    successful = [[ETPush pushManager] configureSDKWithAppID:kETAppID_Debug         // set the Debug ID
                                              andAccessToken:kETAccessToken_Debug   // set the Debug Access Token
                                               withAnalytics:YES
                                         andLocationServices:YES
                                               andCloudPages:YES
                                             withPIAnalytics:YES
                                                       error:&error];
#else
    /**
     Configure and set initial settings of the JB4ASDK
    */
    successful = [[ETPush pushManager] configureSDKWithAppID:kETAppID_Prod          // set the Production ID
                                              andAccessToken:kETAccessToken_Prod    // set the Production Access Token
                                               withAnalytics:YES
                                         andLocationServices:YES
                                               andCloudPages:YES
                                             withPIAnalytics:YES
                                                       error:&error];
#endif
    /**
     If configureSDKWithAppID returns NO, check the error object for detailed failure info. See PushConstants.h for codes.
     The features of the JB4ASDK will NOT be useable unless configureSDKWithAppID returns YES.
    */
    if (!successful) {
        dispatch_async(dispatch_get_main_queue(), ^{
            /**
               something has failed in the configureSDKWithAppID call - show error message
             */
            [[[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Failed configureSDKWithAppID!", @"Failed configureSDKWithAppID!")
                                        message:[error localizedDescription]
                                       delegate:nil
                              cancelButtonTitle:NSLocalizedString(@"OK", @"OK")
                              otherButtonTitles:nil] show];
            
        });
    }
    else {
        /**
          Register for push notifications - enable all notification types, no categories
         */
        UIUserNotificationSettings *settings = [UIUserNotificationSettings settingsForTypes:
                                                UIUserNotificationTypeBadge |
                                                UIUserNotificationTypeSound |
                                                UIUserNotificationTypeAlert
                                                                                 categories:nil];
        
        [[ETPush pushManager] registerUserNotificationSettings:settings];
        [[ETPush pushManager] registerForRemoteNotifications];
        /**
         Start geoLocation
         */
        [[ETLocationManager locationManager]startWatchingLocation];
        
        /**
         Begins fence retrieval from ET of Geofences.
         */
        [ETRegion retrieveGeofencesFromET];
        
        /**
         Begins fence retrieval from ET of Beacons.
         */
        [ETRegion retrieveProximityFromET];
        
        /**
         Inform the JB4ASDK of the launch options - possibly UIApplicationLaunchOptionsRemoteNotificationKey or UIApplicationLaunchOptionsLocalNotificationKey
         */
         [[ETPush pushManager] applicationLaunchedWithOptions:launchOptions];
    }
    
    return YES;
}

- (void)application:(UIApplication *)application didRegisterUserNotificationSettings:(UIUserNotificationSettings *)notificationSettings {
    /**
     inform the JB4ASDK of the requested notification settings
    */
    [[ETPush pushManager] didRegisterUserNotificationSettings:notificationSettings];
}

- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
    /**
      inform the JB4ASDK of the device token
     */
    [[ETPush pushManager] registerDeviceToken:deviceToken];
}

-(void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error {
    /**
     inform the JB4ASDK that the device failed to register and did not receive a device token
    */
    [[ETPush pushManager] applicationDidFailToRegisterForRemoteNotificationsWithError:error];
}


-(void)application:(UIApplication *)application didReceiveLocalNotification:(UILocalNotification *)notification {
    /**
     inform the JB4ASDK that the device received a local notification
     */
    [[ETPush pushManager] handleLocalNotification:notification];
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo fetchCompletionHandler:(void (^)(UIBackgroundFetchResult result))handler {
    /**
      inform the JB4ASDK that the device received a remote notification
     */
    [[ETPush pushManager] handleNotification:userInfo forApplicationState:application.applicationState];
    
    /**
      Is it a silent push?
     */
    if (userInfo[@"aps"][@"content-available"]) {
        /**
          Received a silent remote notification...
          Indicate a silent push
         */
        [[UIApplication sharedApplication] setApplicationIconBadgeNumber:1];
    } else {
        /** 
          Received a remote notification...
          Clear the badge
         */
        [[ETPush pushManager] resetBadgeCount];
    }
    
    handler(UIBackgroundFetchResultNoData);
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    /**
     Use this method to disable Location Services through the MobilePush SDK.
     */
    [[ETLocationManager locationManager]stopWatchingLocation];
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    /**
     Use this method to initiate Location Services through the MobilePush SDK.
     */
    [[ETLocationManager locationManager]startWatchingLocation];
}



@end
