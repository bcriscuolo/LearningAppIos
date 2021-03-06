/*
 * Copyright (c) 2016, salesforce.com, inc.
 * All rights reserved.
 * Licensed under the BSD 3-Clause license.
 * For full license text, see LICENSE.txt file in the repo root  or https://opensource.org/licenses/BSD-3-Clause
 */

#import "AppDelegate.h"
#import <UserNotifications/UserNotifications.h>

@interface AppDelegate (ETPush) <UNUserNotificationCenterDelegate, ExactTargetCloudPageWithAlertDelegate>

- (BOOL)application : (UIApplication *)application shouldInitETSDKWithOptions : (NSDictionary *)launchOptions;

@end
