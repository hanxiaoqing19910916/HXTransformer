//
//  BTDeviceInfo.m
//  BTAnalytics
//
//  Created by hanxiaoqing on 16/4/12.
//  Copyright © 2016年 Babeltime. All rights reserved.
//

#import "BTDeviceInfo.h"
#import <UIKit/UIKit.h>
//#import "ZYXKeyChainManager.h"
#import "sys/sysctl.h" //获取设备型号需包含
#import "Reachability.h"
#import  <CoreTelephony/CTCarrier.h> //获取运营商
#import  <CoreTelephony/CTTelephonyNetworkInfo.h> //获取运营商网络类型

// 获取ip地址需要包含的头文件
#import <ifaddrs.h>
#import <arpa/inet.h>


@implementation BTDeviceInfo

+ (instancetype)currentDevInfo {
    static BTDeviceInfo *_instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _instance = [[self alloc] init];
    });
    return _instance;
}
// 机型
- (NSString *)Model {
    
    return [self getDeviceModel];
}

 // 设备分辨率
- (NSString *)Resolution {
    
    return [self stringFromResolution];
}

// 操作系统
- (NSString *)OS {
    
   return [UIDevice currentDevice].systemVersion;
    
}

// 联网方式
- (NSString *)NetMode {
    
   return [self netWorkStates];
}

// 网络运营商
- (NSString *)Operator {
    
    return [self getCarrier];
}



+ (BOOL)isNetWorkEnable {
    
    Reachability *reach = [Reachability reachabilityForInternetConnection];
    NetworkStatus status = [reach currentReachabilityStatus];
    if ((status == ReachableViaWiFi) || (status == ReachableViaWWAN)) {
        return YES;
    } else {
        return NO;
    }
    
}

- (NSString *)deviceUuid
{
    return [self.class getDeviceUuid];
}

- (NSString *)nowUnixTime
{
    return [self.class logCreateUnixTime];
}

#warning 获取uuid
+ (NSString *)getDeviceUuid {
    return @"uuid";
}


- (NSString*)getCarrier
{
    CTTelephonyNetworkInfo *info = [[CTTelephonyNetworkInfo alloc] init];
    CTCarrier *carrier = [info subscriberCellularProvider];
    NSString * mcc = [carrier mobileCountryCode];
    NSString * mnc = [carrier mobileNetworkCode];
    if (mnc == nil || mnc.length <1 || [mnc isEqualToString:@"SIM Not Inserted"]) {
        return @"Unknown";
    } else {
        if ([mcc isEqualToString:@"460"]) {
            NSInteger MNC = [mnc intValue];
            switch (MNC) {
                case 00:
                case 02:
                case 07:
                    return @"中国移动";
                    break;
                case 01:
                case 06:
                    return @"中国联通";
                    break;
                case 03:
                case 05:
                    return @"中国电信";
                    break;
                case 20:
                    return @"中国铁通";
                    break;
                default:
                    break;
            }
        }
    }
    
    return @"Unknown";
}

- (NSString *)stringFromResolution
{
    CGSize screenSize = [UIScreen mainScreen].currentMode.size;
    unichar c = [[NSString stringWithFormat:@"*"] characterAtIndex:0];
    return [NSString stringWithFormat:@"%0.0f%c%0.0f",screenSize.width,c,screenSize.height];
}


- (NSString *)netWorkStates
{
    NSString *stateString;
    Reachability *reach = [Reachability reachabilityForInternetConnection];
    NetworkStatus status = [reach currentReachabilityStatus];
    switch (status) {
        case NotReachable:
            stateString = @"NotReachable";
            break;
        case ReachableViaWiFi:
            stateString = @"wifi";
            break;
        case ReachableViaWWAN:
            stateString = [self radioAccessTechnology];
            break;
        default:
            stateString = @"Unknown";
            break;
    }
    return stateString;
    
    
}

/**
 CTRadioAccessTechnologyGPRS         //介于2G和3G之间，也叫2.5G ,过度技术
 CTRadioAccessTechnologyEdge         //EDGE为GPRS到第三代移动通信的过渡，EDGE俗称2.75G
 CTRadioAccessTechnologyWCDMA
 CTRadioAccessTechnologyHSDPA            //亦称为3.5G(3?G)
 CTRadioAccessTechnologyHSUPA            //3G到4G的过度技术
 CTRadioAccessTechnologyCDMA1x       //3G
 CTRadioAccessTechnologyCDMAEVDORev0    //3G标准
 CTRadioAccessTechnologyCDMAEVDORevA
 CTRadioAccessTechnologyCDMAEVDORevB
 CTRadioAccessTechnologyeHRPD        //电信使用的一种3G到4G的演进技术， 3.75G
 CTRadioAccessTechnologyLTE          //接近4G
 */
- (NSString *)radioAccessTechnology
{
    CTTelephonyNetworkInfo *networkInfo = [[CTTelephonyNetworkInfo alloc] init];
    if ([networkInfo.currentRadioAccessTechnology isEqualToString:@"CTRadioAccessTechnologyGPRS"]){
        //GPRS网络
        return @"GPRS";
    }
    if ([networkInfo.currentRadioAccessTechnology isEqualToString:@"CTRadioAccessTechnologyEdge"]){
        //2.75G的EDGE网络
        return @"2G";
    }
    if ([networkInfo.currentRadioAccessTechnology isEqualToString:@"CTRadioAccessTechnologyWCDMA"]) {
        //3G WCDMA网络
        return @"3G";
    }
    if ([networkInfo.currentRadioAccessTechnology  isEqualToString:@"CTRadioAccessTechnologyCDMA1x"]){
        //CDMA2G网络
        return @"2G";
    }
    if ([networkInfo.currentRadioAccessTechnology isEqualToString:@"CTRadioAccessTechnologyCDMAEVDORev0"]){
        //CDMA的EVDORev0
        return @"3G";
    }
    if ([networkInfo.currentRadioAccessTechnology isEqualToString:@"CTRadioAccessTechnologyCDMAEVDORevA"]){
        //CDMA的EVDORevA
        return @"3G";
    }
    if ([networkInfo.currentRadioAccessTechnology isEqualToString:@"CTRadioAccessTechnologyCDMAEVDORevB"]){
        //CDMA的EVDORev0
        return @"3G";
    }
    if ([networkInfo.currentRadioAccessTechnology
         isEqualToString:@"CTRadioAccessTechnologyLTE"]){
        //LTE4G网络
        return @"4G";
    }
    return @"unknow";
}

- (BOOL)catchJailbrokenState {
    BOOL jailbroken = NO;
    NSString *cydiaPath = @"/Applications/Cydia.app";
    NSString *aptPath = @"/private/var/lib/apt/";
    if([[NSFileManager defaultManager] fileExistsAtPath:cydiaPath]) {
        jailbroken = YES;
    }
    if([[NSFileManager defaultManager] fileExistsAtPath:aptPath]) {
        jailbroken = YES;
    }
    return jailbroken;
}

- (NSString *)getDeviceModel {
    size_t size;
    int nR = sysctlbyname("hw.machine", NULL, &size, NULL, 0);
    char *machine = (char *)malloc(size);
    nR = sysctlbyname("hw.machine", machine, &size, NULL, 0);
    NSString *platform = [NSString stringWithCString:machine encoding:NSUTF8StringEncoding];
    free(machine);
    
    if ([platform isEqualToString:@"iPhone1,1"]) return @"iPhone 2G (A1203)";
    if ([platform isEqualToString:@"iPhone1,2"]) return @"iPhone 3G (A1241/A1324)";
    if ([platform isEqualToString:@"iPhone2,1"]) return @"iPhone 3GS (A1303/A1325)";
    if ([platform isEqualToString:@"iPhone3,1"]) return @"iPhone 4 (A1332)";
    if ([platform isEqualToString:@"iPhone3,2"]) return @"iPhone 4 (A1332)";
    if ([platform isEqualToString:@"iPhone3,3"]) return @"iPhone 4 (A1349)";
    if ([platform isEqualToString:@"iPhone4,1"]) return @"iPhone 4S (A1387/A1431)";
    if ([platform isEqualToString:@"iPhone5,1"]) return @"iPhone 5 (A1428)";
    if ([platform isEqualToString:@"iPhone5,2"]) return @"iPhone 5 (A1429/A1442)";
    if ([platform isEqualToString:@"iPhone5,3"]) return @"iPhone 5c (A1456/A1532)";
    if ([platform isEqualToString:@"iPhone5,4"]) return @"iPhone 5c (A1507/A1516/A1526/A1529)";
    if ([platform isEqualToString:@"iPhone6,1"]) return @"iPhone 5s (A1453/A1533)";
    if ([platform isEqualToString:@"iPhone6,2"]) return @"iPhone 5s (A1457/A1518/A1528/A1530)";
    if ([platform isEqualToString:@"iPhone7,1"]) return @"iPhone 6 Plus (A1522/A1524)";
    if ([platform isEqualToString:@"iPhone7,2"]) return @"iPhone 6 (A1549/A1586)";
    if ([platform isEqualToString:@"iPhone8,1"]) return @"iPhone 6s ";
    if ([platform isEqualToString:@"iPhone8,2"]) return @"iPhone 6s Plus";
    if ([platform isEqualToString:@"iPhone9,1"]) return @"iPhone 7";
    if ([platform isEqualToString:@"iPhone9,2"]) return @"iPhone 7 Plus";
    
    if ([platform isEqualToString:@"iPod1,1"])   return @"iPod Touch 1G (A1213)";
    if ([platform isEqualToString:@"iPod2,1"])   return @"iPod Touch 2G (A1288)";
    if ([platform isEqualToString:@"iPod3,1"])   return @"iPod Touch 3G (A1318)";
    if ([platform isEqualToString:@"iPod4,1"])   return @"iPod Touch 4G (A1367)";
    if ([platform isEqualToString:@"iPod5,1"])   return @"iPod Touch 5G (A1421/A1509)";
    
    if ([platform isEqualToString:@"iPad1,1"])   return @"iPad 1G (A1219/A1337)";
    
    if ([platform isEqualToString:@"iPad2,1"])   return @"iPad 2 (A1395)";
    if ([platform isEqualToString:@"iPad2,2"])   return @"iPad 2 (A1396)";
    if ([platform isEqualToString:@"iPad2,3"])   return @"iPad 2 (A1397)";
    if ([platform isEqualToString:@"iPad2,4"])   return @"iPad 2 (A1395+New Chip)";
    if ([platform isEqualToString:@"iPad2,5"])   return @"iPad Mini 1G (A1432)";
    if ([platform isEqualToString:@"iPad2,6"])   return @"iPad Mini 1G (A1454)";
    if ([platform isEqualToString:@"iPad2,7"])   return @"iPad Mini 1G (A1455)";
    
    if ([platform isEqualToString:@"iPad3,1"])   return @"iPad 3 (A1416)";
    if ([platform isEqualToString:@"iPad3,2"])   return @"iPad 3 (A1403)";
    if ([platform isEqualToString:@"iPad3,3"])   return @"iPad 3 (A1430)";
    if ([platform isEqualToString:@"iPad3,4"])   return @"iPad 4 (A1458)";
    if ([platform isEqualToString:@"iPad3,5"])   return @"iPad 4 (A1459)";
    if ([platform isEqualToString:@"iPad3,6"])   return @"iPad 4 (A1460)";
    
    if ([platform isEqualToString:@"iPad4,1"])   return @"iPad Air (A1474)";
    if ([platform isEqualToString:@"iPad4,2"])   return @"iPad Air (A1475)";
    if ([platform isEqualToString:@"iPad4,3"])   return @"iPad Air (A1476)";
    if ([platform isEqualToString:@"iPad4,4"])   return @"iPad Mini 2G (A1489)";
    if ([platform isEqualToString:@"iPad4,5"])   return @"iPad Mini 2G (A1490)";
    if ([platform isEqualToString:@"iPad4,6"])   return @"iPad Mini 2G (A1491)";
    
    if ([platform isEqualToString:@"i386"])      return @"iPhone Simulator";
    if ([platform isEqualToString:@"x86_64"])    return @"iPhone Simulator";
    return platform;
    
}


+ (NSString *)logCreateUnixTime {
    //获取当前时间
    NSDate *localDate = [NSDate date];
    //转化为UNIX时间戳
    long UnixTime = (long)[localDate timeIntervalSince1970];
    return [NSString stringWithFormat:@"%ld", UnixTime];
}


- (NSString *)ipAddress {
    return [self getIPAddress];
}
//获取ip地址
- (NSString *)getIPAddress {
    
    NSString *address = @"error";
    struct ifaddrs *interfaces = NULL;
    struct ifaddrs *temp_addr = NULL;
    int success = 0;
    // retrieve the current interfaces - returns 0 on success
    success = getifaddrs(&interfaces);
    if (success == 0) {
        // Loop through linked list of interfaces
        temp_addr = interfaces;
        while (temp_addr != NULL) {
//            NSLog(@"ifa_name===%@",[NSString stringWithUTF8String:temp_addr->ifa_name]);
            // Check if interface is en0 which is the wifi connection on the iPhone
            if ([[NSString stringWithUTF8String:temp_addr->ifa_name] isEqualToString:@"en0"] || [[NSString stringWithUTF8String:temp_addr->ifa_name] isEqualToString:@"pdp_ip0"])
            {
                //如果是IPV4地址，直接转化
                if (temp_addr->ifa_addr->sa_family == AF_INET){
                    // Get NSString from C String
                    address = [self formatIPV4Address:((struct sockaddr_in *)temp_addr->ifa_addr)->sin_addr];
                }
                
                //如果是IPV6地址
                else if (temp_addr->ifa_addr->sa_family == AF_INET6){
                    address = [self formatIPV6Address:((struct sockaddr_in6 *)temp_addr->ifa_addr)->sin6_addr];
                    if (address && ![address isEqualToString:@""] && ![address.uppercaseString hasPrefix:@"FE80"]) break;
                }
            }
            
            temp_addr = temp_addr->ifa_next;
        }
    }
    // Free memory
    freeifaddrs(interfaces);
    return address;
}

- (NSString *)formatIPV6Address:(struct in6_addr)ipv6Addr{
    NSString *address = nil;
    
    char dstStr[INET6_ADDRSTRLEN];
    char srcStr[INET6_ADDRSTRLEN];
    memcpy(srcStr, &ipv6Addr, sizeof(struct in6_addr));
    if(inet_ntop(AF_INET6, srcStr, dstStr, INET6_ADDRSTRLEN) != NULL){
        address = [NSString stringWithUTF8String:dstStr];
    }
    
    return address;
}

//for IPV4
- (NSString *)formatIPV4Address:(struct in_addr)ipv4Addr{
    NSString *address = nil;
    
    char dstStr[INET_ADDRSTRLEN];
    char srcStr[INET_ADDRSTRLEN];
    memcpy(srcStr, &ipv4Addr, sizeof(struct in_addr));
    if(inet_ntop(AF_INET, srcStr, dstStr, INET_ADDRSTRLEN) != NULL){
        address = [NSString stringWithUTF8String:dstStr];
    }
    
    return address;
}

@end
