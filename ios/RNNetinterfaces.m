
#import "RNNetinterfaces.h"
//#import "getgateway.h"

#import <ifaddrs.h>
#import <arpa/inet.h>
#include <net/if.h>
#include <sys/types.h>
#include <netinet/in.h>
#include <TargetConditionals.h>

#define IOS_CELLULAR    @"pdp_ip0"
#define IOS_WIFI        @"en0"
//#define IOS_VPN       @"utun0"
#define IP_ADDR_IPv4    @"ipv4"
#define IP_ADDR_IPv6    @"ipv6"
#define IP_FLAGS        @"flags"
#define IF_NAME         @"name"
#define IP_ADDR         @"addr"
#define IP_NETMASK      @"netmask"
#define IP_DSTADDR      @"dstaddr"

@import SystemConfiguration.CaptiveNetwork;

@implementation RNNetinterfaces

// - (dispatch_queue_t)methodQueue
// {
//     return dispatch_get_main_queue();
//}

RCT_EXPORT_MODULE()

RCT_EXPORT_METHOD(getInterfaces:(RCTPromiseResolveBlock)resolve
                  rejecter:(RCTPromiseRejectBlock)reject)
{

    NSMutableDictionary *netif = [NSMutableDictionary dictionaryWithCapacity:8];

    @try {
        struct ifaddrs *interfaces;
        if(!getifaddrs(&interfaces)) {
            // Loop through linked list of interfaces
            struct ifaddrs *interface;
            for(interface=interfaces; interface; interface=interface->ifa_next) {
                const struct sockaddr_in *addr = (const struct sockaddr_in*)interface->ifa_addr;
                const struct sockaddr_in *netmask = (const struct sockaddr_in*)interface->ifa_netmask;
                const struct sockaddr_in *dstaddr = (const struct sockaddr_in*)interface->ifa_dstaddr;
                char addrBuf[ MAX(INET_ADDRSTRLEN, INET6_ADDRSTRLEN) ];
                char netmaskBuf[ MAX(INET_ADDRSTRLEN, INET6_ADDRSTRLEN) ];
                char dstaddrBuf[ MAX(INET_ADDRSTRLEN, INET6_ADDRSTRLEN) ];
                if(addr && (addr->sin_family==AF_INET || addr->sin_family==AF_INET6)) {
                    
                    NSString *name = [NSString stringWithUTF8String:interface->ifa_name];
                    if (!netif[name]) {
                        netif[name] = [NSMutableDictionary dictionaryWithCapacity:8];
                    }
                    // netif[name][IP_FLAGS] = interface->ifa_flags;
                    netif[name][IP_FLAGS] = [NSNumber numberWithUnsignedInt:interface->ifa_flags];
                    netif[name][IF_NAME] = name;
                    NSString *type;
                    if(addr->sin_family == AF_INET) {
                        if(inet_ntop(AF_INET, &addr->sin_addr, addrBuf, INET_ADDRSTRLEN)) {
                            type = IP_ADDR_IPv4;
                            netif[name][IP_ADDR_IPv4] = [NSMutableDictionary dictionaryWithCapacity:8];
                            netif[name][IP_ADDR_IPv4][IP_ADDR] = [NSString stringWithUTF8String:addrBuf];
                            if(netmask && inet_ntop(AF_INET, &netmask->sin_addr, netmaskBuf, INET_ADDRSTRLEN)) {
                                netif[name][IP_ADDR_IPv4][IP_NETMASK] = [NSString stringWithUTF8String:netmaskBuf];
                            }
                            if(dstaddr && inet_ntop(AF_INET, &dstaddr->sin_addr, dstaddrBuf, INET_ADDRSTRLEN)) {
                                netif[name][IP_ADDR_IPv4][IP_DSTADDR] = [NSString stringWithUTF8String:dstaddrBuf];
                            }
                        }
                    } else {
                        const struct sockaddr_in6 *addr6 = (const struct sockaddr_in6*)interface->ifa_addr;
                        const struct sockaddr_in6 *netmask6 = (const struct sockaddr_in6*)interface->ifa_netmask;
                        const struct sockaddr_in6 *dstaddr6 = (const struct sockaddr_in6*)interface->ifa_dstaddr;
                        if(inet_ntop(AF_INET6, &addr6->sin6_addr, addrBuf, INET6_ADDRSTRLEN)) {
                            type = IP_ADDR_IPv6;
                            netif[name][IP_ADDR_IPv6] = [NSMutableDictionary dictionaryWithCapacity:8];
                            netif[name][IP_ADDR_IPv6][IP_ADDR] = [NSString stringWithUTF8String:addrBuf];
                            if(netmask && inet_ntop(AF_INET6, &netmask6->sin6_addr, netmaskBuf, INET6_ADDRSTRLEN)) {
                                netif[name][IP_ADDR_IPv6][IP_NETMASK] = [NSString stringWithUTF8String:netmaskBuf];
                            }
                            if(dstaddr && inet_ntop(AF_INET6, &dstaddr6->sin6_addr, dstaddrBuf, INET6_ADDRSTRLEN)) {
                                netif[name][IP_ADDR_IPv6][IP_DSTADDR] = [NSString stringWithUTF8String:dstaddrBuf];
                            }
                        }
                    }
                }
            }
            // Free memory
            freeifaddrs(interfaces);
        }
        resolve(netif);

    }@catch (NSException *exception) {
        resolve(NULL);
    }

}


// RCT_EXPORT_METHOD(getInterfaces:(RCTPromiseResolveBlock)resolve
//                   rejecter:(RCTPromiseRejectBlock)reject)
// {

//     NSMutableDictionary *addresses = [NSMutableDictionary dictionaryWithCapacity:8];

//     @try {
//         struct ifaddrs *interfaces;
//         if(!getifaddrs(&interfaces)) {
//             // Loop through linked list of interfaces
//             struct ifaddrs *interface;
//             for(interface=interfaces; interface; interface=interface->ifa_next) {
//                 if(!(interface->ifa_flags & IFF_UP) /* || (interface->ifa_flags & IFF_LOOPBACK) */ ) {
//                     continue; // deeply nested code harder to read
//                 }
//                 const struct sockaddr_in *addr = (const struct sockaddr_in*)interface->ifa_addr;
//                 char addrBuf[ MAX(INET_ADDRSTRLEN, INET6_ADDRSTRLEN) ];
//                 if(addr && (addr->sin_family==AF_INET || addr->sin_family==AF_INET6)) {
//                     NSString *name = [NSString stringWithUTF8String:interface->ifa_name];
//                     NSString *type;
//                     if(addr->sin_family == AF_INET) {
//                         if(inet_ntop(AF_INET, &addr->sin_addr, addrBuf, INET_ADDRSTRLEN)) {
//                             type = IP_ADDR_IPv4;
//                         }
//                     } else {
//                         const struct sockaddr_in6 *addr6 = (const struct sockaddr_in6*)interface->ifa_addr;
//                         if(inet_ntop(AF_INET6, &addr6->sin6_addr, addrBuf, INET6_ADDRSTRLEN)) {
//                             type = IP_ADDR_IPv6;
//                         }
//                     }
//                     if(type) {
//                         NSString *key = [NSString stringWithFormat:@"%@/%@", name, type];
//                         addresses[key] = [NSString stringWithUTF8String:addrBuf];
//                     }
//                 }
//             }
//             // Free memory
//             freeifaddrs(interfaces);
//         }
//         resolve(addresses);

//     }@catch (NSException *exception) {
//         resolve(NULL);
//     }

// }


@end
  