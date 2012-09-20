//
//  NetworkInfo.m
//  G3Wlan
//
//  Created by  omssdk on 12-4-5.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import "NetworkInfo.h"

#import "Reachability.h"

#import "constvalue.h"

#import "SimpleLogger.h"

#import <netinet/in.h>
#import <arpa/inet.h>
#import <stdio.h>
#import <stdlib.h>
#import <string.h>
#import <unistd.h>
#import <sys/ioctl.h>
#import <sys/types.h>
#import <sys/socket.h>
#import <netinet/in.h>
#import <netdb.h>
#import <arpa/inet.h>
#import <sys/sockio.h>
#import <net/if.h>
#import <errno.h>
#import <net/if_dl.h>

#import <SystemConfiguration/CaptiveNetwork.h>

#define min(a,b)    ((a) < (b) ? (a) : (b))  
#define max(a,b)    ((a) > (b) ? (a) : (b))  

@implementation NetworkInfo
static NetworkInfo *_networkInfo = nil;

+(NetworkInfo *)getInstance
{
    if (nil == _networkInfo) {
        _networkInfo = [[NetworkInfo alloc] init];
    }
    
    return _networkInfo;
}

- (id) init
{	
	self = [super init];
	wifiReach = [[Reachability reachabilityForLocalWiFi] retain];
  internetReach = [[Reachability reachabilityForInternetConnection] retain];
	return self;
}

- (void) dealloc
{
	[_networkInfo release];
	[wifiReach release];
  [internetReach release];
	[super dealloc];
}

- (BOOL) startWifiNotifierWithObserver:(id)observer selector:(SEL)aSelector;
{
    BOOL result1, result2;
	[[NSNotificationCenter defaultCenter] addObserver:observer selector:aSelector name:kReachabilityChangedNotification object:nil];
    result1 = [internetReach startNotifier];
    if (result1)
    {
        result2 = [wifiReach startNotifier];
        if (!result2)
            INFO(@"wifiReach startNotifier failed");
    }
    else
        INFO(@"internetReach startNotifier failed");

    return result1; //We concern the internetReach most, so we only return the result of internetReach startNotifier
}

- (void) stopWifiNotifierWithObserver:(id)observer
{
	[wifiReach stopNotifier];
  [internetReach stopNotifier];
	[[NSNotificationCenter defaultCenter] removeObserver:observer name:kReachabilityChangedNotification object:nil];
}

- (NSString *) getWiFiSSID 
{
	NSArray *ifs =  (id)CNCopySupportedInterfaces();
	NSString *retStr = nil;
	id info = nil;
	info = (id) CNCopyCurrentNetworkInfo((CFStringRef)@"en0");
	if (!info)
  {
		info = (id) CNCopyCurrentNetworkInfo((CFStringRef)@"en1");
  } 
  else if (![info count])
  {
    [info release];
 		info = (id) CNCopyCurrentNetworkInfo((CFStringRef)@"en1");   
  }
	if (info && [info count])
	{
		retStr = [NSString stringWithString: [[info objectForKey:@"SSID"] lowercaseString]];
	}
	if (info)
		[info release];
	[ifs release];
	
	return retStr;
	
}


- (in_addr_t) getWiFiIPAddresses  
{  
    int                 len, flags;  
    char                buffer[4000], *ptr, *cptr;  
    struct ifconf       ifc;  
    struct ifreq        *ifr, ifrcopy;  
    struct sockaddr_in  *sin;  
	
	in_addr_t wifiIP = 0;
	
	
    int sockfd;  
	
    sockfd = socket(AF_INET, SOCK_DGRAM, 0);  
    if (sockfd < 0)  
    {  
        perror("socket failed");  
        return 0;  
    }  
	
    ifc.ifc_len = 4000;  
    ifc.ifc_buf = buffer;  
	
    if (ioctl(sockfd, SIOCGIFCONF, &ifc) < 0)  
    {  
        perror("ioctl error");  
        return wifiIP;  
    }  
	
    for (ptr = buffer; ptr < buffer + ifc.ifc_len; )  
    {  
      ifr = (struct ifreq *)ptr;  
      len = max(sizeof(struct sockaddr), ifr->ifr_addr.sa_len);  
      ptr += sizeof(ifr->ifr_name) + len;  // for next one in buffer  
  
      if (ifr->ifr_addr.sa_family != AF_INET)  
      {  
          continue;   // ignore if not desired address family  
      }  
  
      if ((cptr = (char *)strchr(ifr->ifr_name, ':')) != NULL)  
      {  
          *cptr = 0;      // replace colon will null  
      }  
    
      if (strcmp(ifr->ifr_name, "en0") == 0 || strcmp(ifr->ifr_name, "en1") == 0)
      {					
        ifrcopy = *ifr;  
        ioctl(sockfd, SIOCGIFFLAGS, &ifrcopy);  
        flags = ifrcopy.ifr_flags;  
        if ((flags & IFF_UP) == 0)  
        {  
          continue;   // ignore if interface not up  
        }  
        sin = (struct sockaddr_in *)&ifr->ifr_addr;  
        
        wifiIP = sin->sin_addr.s_addr;
        break;
      }
    }  
	
    close(sockfd);  
	return wifiIP;
}  

- (NetworkStatus) getWiFIReachability
{
	return [wifiReach currentReachabilityStatus];
}

- (NetworkStatus) getInternetReachability
{
  return [internetReach currentReachabilityStatus];
}

@end