//
//  CenterController.m
//  ApalaPi
//
//  Created by chuanyhu on 14-1-8.
//  Copyright (c) 2014年 feiffan. All rights reserved.
//

#import "KBCoordinatingContext.h"
#import <AdSupport/AdSupport.h>
#import <sys/socket.h>
#import <sys/sysctl.h>
#import <net/if.h>
#import <net/if_dl.h>

//#import <CoreTelephony/CTCarrier.h>
//#import <CoreTelephony/CTTelephonyNetworkInfo.h>

@interface KBCoordinatingContext (){
    
    
}


- (void) initialize;

@end


@implementation KBCoordinatingContext


static KBCoordinatingContext *sharedControll = nil;


- (void) initialize
{

//    _deviceInfo = [[LPDeviceInfo alloc] init];
//    [self loadDeviceInfo];
    
    //检查文件夹是否创建
//    [KBFileOperation createDocumentsSubDir:@"cache/objects"];
//    [KBFileOperation createDocumentsSubDir:@"medialib"];
    
    self.battery = @"";
   
    
}


- (void)startBlueScane //开始蓝牙扫描
{
    
    if(_blueManager == nil)
    {
        _blueManager = [[BlueTools alloc] initWithDriveName:@"Snore"];
    }
    [_blueManager startBlueScan];

}


- (void)stopBlueScane //开始蓝牙扫描
{
    [_blueManager stopScan];
    self.blueManager = nil;
    self.battery = @"";
    
    
    
}


+ (KBCoordinatingContext *) sharedInstance
{
    if (sharedControll == nil)
    {
        sharedControll = [[super allocWithZone:NULL] init];
        [sharedControll initialize];
    }
    
    return sharedControll;
}

+ (id) allocWithZone:(NSZone *)zone
{
    return [KBCoordinatingContext sharedInstance];
}

- (id) copyWithZone:(NSZone*)zone
{
    return self;
}

//- (id) retain
//{
//    return self;
//}

//- (NSUInteger) retainCount
//{
//    return NSUIntegerMax;
//}


//- (oneway void) release
//{
//    // do nothing
//}

//- (id) autorelease
//{
//    return self;
//}








- (void)loadDeviceInfo
{
    //获取设备号
//    NSLog(@"%@",[UIDevice currentDevice].name);// Kangwan-iPod5
//    NSLog(@"%@",[UIDevice currentDevice].model);// iPod touch
//    NSLog(@"%@",[UIDevice currentDevice].localizedModel);// iPod touch
//    NSLog(@"%@",[UIDevice currentDevice].systemName);//  iPhone OS
//    NSLog(@"%@",[UIDevice currentDevice].systemVersion);//  7.0.3
//    NSLog(@"%d",[UIDevice currentDevice].userInterfaceIdiom);//  0
//    NSLog(@"%@",[[[UIDevice currentDevice] identifierForVendor] UUIDString]);// 设备UDID：<__NSConcreteUUID 0x165c4d80> D95C02A7-CE19-491C-A58A-BB74E04552B3
    
    //电话
//    CTTelephonyNetworkInfo *info = [[CTTelephonyNetworkInfo alloc] init];
//    
//    CTCarrier *carrier = info.subscriberCellularProvider;
//    NSString* network = [NSString stringWithFormat:@"%@-%@",[carrier carrierName],[carrier mobileNetworkCode]];
//    NSLog(@"%@",network);
    
//    NSString *os = [NSString stringWithFormat:@"%@ %@",[[UIDevice currentDevice] systemName],[UIDevice currentDevice].systemVersion];
//    
//    CGRect rect = [[UIApplication sharedApplication]keyWindow].frame;
  
    
   
    
//    LPDeviceInfo* deviceInfo = [[LPDeviceInfo alloc]init];
    
//    NSDictionary *infoDic = [[NSBundle mainBundle] infoDictionary];
//    NSString *clientBundleVersion = [infoDic objectForKey:@"CFBundleVersion"];
//    NSString *versionCode = [infoDic objectForKey:@"CFBundleShortVersionString"];
//
////    NSString *clientVersion = [infoDic objectForKey:@"CFBundleShortVersionString"];
//    NSString *deviceId = [[[UIDevice currentDevice] identifierForVendor] UUIDString];
//    NSLog(@"UUIDString  %@",deviceId);
//
////
//    NSString *identifierForAdvertising = [[ASIdentifierManager sharedManager].advertisingIdentifier UUIDString];
//    NSLog(@"identifierForAdvertising  %@",identifierForAdvertising);
//    _deviceInfo.deviceId = @"1";  //Iphone标示
//    _deviceInfo.osVersion = [UIDevice currentDevice].systemVersion;
//    _deviceInfo.deviceModel = [KBCoordinatingContext getCurrentDeviceModel];
//    
//    _deviceInfo.deviceSN = identifierForAdvertising;
//    
//    _deviceInfo.appBuildVersion = clientBundleVersion;
//    _deviceInfo.versionCode = versionCode;
//    _deviceInfo.applicationID = @"8";   //项目 月子会所 id
//    _deviceInfo.iosDeviceToken = @"";
//    _deviceInfo.GeTuiCID  = @"";
//    
//    LPIPAddress* ipaddress = [[LPIPAddress alloc] init];
//    NSString* ip = [ipaddress getIPAddress:YES];
//    _deviceInfo.ipAddress = ip;
    

    
}



//获得设备型号
+ (NSString *)getCurrentDeviceModel
{
    int mib[2];
    size_t len;
    char *machine;
    mib[0] = CTL_HW;
    mib[1] = HW_MACHINE;
    sysctl(mib, 2, NULL, &len, NULL, 0);
    machine = malloc(len);
    sysctl(mib, 2, machine, &len, NULL, 0);
    
    NSString *platform = [NSString stringWithCString:machine encoding:NSASCIIStringEncoding];
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
    if ([platform isEqualToString:@"iPhone8,2"]) return @"iPhone 6S Plus (A1701)";
    if ([platform isEqualToString:@"iPhone8,1"]) return @"iPhone 6S (A1700)";
    
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


- (NSString *)idfaString {
    
    NSBundle *adSupportBundle = [NSBundle bundleWithPath:@"/System/Library/Frameworks/AdSupport.framework"];
    [adSupportBundle load];
    
    if (adSupportBundle == nil) {
        return @"";
    }
    else{
        
        Class asIdentifierMClass = NSClassFromString(@"ASIdentifierManager");
        
        if(asIdentifierMClass == nil){
            return @"";
        }
        else{
            
            //for no arc
            //ASIdentifierManager *asIM = [[[asIdentifierMClass alloc] init] autorelease];
            //for arc
            ASIdentifierManager *asIM = [[asIdentifierMClass alloc] init];
            
            if (asIM == nil) {
                return @"";
            }
            else{
                
                if(asIM.advertisingTrackingEnabled){
                    return [asIM.advertisingIdentifier UUIDString];
                }
                else{
                    return [asIM.advertisingIdentifier UUIDString];
                }
            }
        }
    }
}

- (NSString *)idfvString
{
    if([[UIDevice currentDevice] respondsToSelector:@selector( identifierForVendor)]) {
        return [[UIDevice currentDevice].identifierForVendor UUIDString];
    }
    
    return @"";
}




@end