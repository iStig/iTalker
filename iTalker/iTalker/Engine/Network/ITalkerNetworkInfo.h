//
//  NetworkInfo.h
//  G3Wlan
//
//  Created by  omssdk on 12-4-5.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Reachability.h"

@class Reachability;

@interface NetworkInfo : NSObject {

	Reachability *wifiReach;
  Reachability *internetReach;

}

+ (NetworkInfo *)getInstance;
- (BOOL) startWifiNotifierWithObserver:(id)observer selector:(SEL)aSelector;
- (void) stopWifiNotifierWithObserver:(id)observer;
- (NSString *) getWiFiSSID; 
- (in_addr_t) getWiFiIPAddresses;
- (NetworkStatus) getWiFIReachability;
- (NetworkStatus) getInternetReachability;
@end
