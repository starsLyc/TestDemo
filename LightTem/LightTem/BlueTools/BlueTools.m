//
//  BlueTools.m
//  blue
//
//  Created by mac on 16/1/27.
//  Copyright © 2016年 yuanyuan. All rights reserved.
//

#import "BlueTools.h"
#import "UUID.h"
#import "LPBlueSqlManager.h"
#import "LPSaveRecordController.h"
#import "LPRecordInfoModel.h"
#import <AVFoundation/AVFoundation.h>



@interface BlueTools ()

@property (nonatomic,strong)  CBCharacteristic *batteryCharacteristic;// 电池电量的服务

@property (nonatomic,strong)  CBCharacteristic *timeCharacteristic;// 时间的读与写服务


@property (nonatomic,strong)  CBCharacteristic *serviceCharacteristic;// 血氧值与脉率的服务


@property (nonatomic,strong)  CBCharacteristic *stimulationCharacteristic;// 电刺激服务



@property (nonatomic,strong)  CBPeripheral *currentPeripheral;//当前设备

@property (nonatomic,strong)  NSString *driveName; //设备名字

@end


@implementation BlueTools



- (id)initWithDriveName:(NSString *)name
{
    self = [super init];
    if (self) {
      _centralManager = [[CBCentralManager alloc]initWithDelegate:self queue:nil];
        
        self.whetherElectrical = NO;
        self.NeedElectricalLenght = 0;
        
        self.isBeginLow = NO;
        self.isLowLenght = 0;
        
        self.driveName = name;
    }
    return self;
}

- (void)stopScan
{
    self.whetherElectrical = NO;
    self.NeedElectricalLenght = 0;
    
    self.isBeginLow = NO;
    self.isLowLenght = 0;
    self.currentPeripheral = nil;
    self.centralManager = nil;
    self.serviceCharacteristic = nil;
    self.timeCharacteristic = nil;
    self.serviceCharacteristic = nil;
    
    [_centralManager stopScan];
    self.blueStatue = NO;
}


//开始扫描
-(void)startBlueScan
{
    self.whetherElectrical = NO;
    self.NeedElectricalLenght = 0;
    
    self.isBeginLow = NO;
    self.isLowLenght = 0;
    self.blueStatue = YES;

    if(_centralManager == nil)
    {
        _centralManager = [[CBCentralManager alloc]initWithDelegate:self queue:nil];
    }
    
    [_centralManager scanForPeripheralsWithServices:nil options:nil];
    
}

//判断手机蓝牙状态
- (void)judjeCentralState
{
    switch(_centralManager.state) {
        case CBCentralManagerStatePoweredOn:
            [[NSNotificationCenter defaultCenter] postNotificationName:LPSnoreBlueChangeStatus object:@"3"];
            [self startBlueScan]; //开始扫描
            break;
        case CBCentralManagerStatePoweredOff:
//            [PXAlertView showAlertWithTitle:@"提示" message:@"请打开蓝牙"];
            [self stopScan];
            [[NSNotificationCenter defaultCenter] postNotificationName:LPSnoreBlueChangeStatus object:@"0"];
            break;
        case CBCentralManagerStateUnsupported:
            [[NSNotificationCenter defaultCenter] postNotificationName:LPSnoreBlueChangeStatus object:@"1"];
//            [PXAlertView showAlertWithTitle:@"提示" message:@"不支持蓝牙低功耗"];
            break;
        case CBCentralManagerStateUnauthorized:
            [self stopScan];
            [[NSNotificationCenter defaultCenter] postNotificationName:LPSnoreBlueChangeStatus object:@"2"];
//            [PXAlertView showAlertWithTitle:@"提示" message:@"app未经授权使用蓝牙低功耗"];
            break;
        default:
            break;
    }
}

#pragma mark   CBCentralManagerDelegate

//设备状态更新时候调用
- (void)centralManagerDidUpdateState:(CBCentralManager*)central
{
    [self judjeCentralState];
}


//发现设备时调用     RSSI:蓝牙信号强度
- (void)centralManager:(CBCentralManager *)central didDiscoverPeripheral:(CBPeripheral *)peripheral advertisementData:(NSDictionary *)advertisementData RSSI:(NSNumber *)RSSI
{
    NSLog(@"name  %@   %@",peripheral.name,peripheral.RSSI);
//    NSUUID* identifierUUID = [[NSUUID alloc] initWithUUIDString:@"2A6054D9-8EEB-E65E-05AA-2D1330E307A6"];
    if ([peripheral.name hasPrefix:_driveName] /* && [peripheral.identifier isEqual:identifierUUID]*/) {
        NSLog(@"尝试连接");
        [_centralManager stopScan];
        //连接设备
        [_centralManager connectPeripheral:peripheral options:[NSDictionary dictionaryWithObject:[NSNumber numberWithBool:YES] forKey:CBConnectPeripheralOptionNotifyOnDisconnectionKey]];
        
        
        self.currentPeripheral = peripheral;
        self.currentPeripheral.delegate = self;
        //寻找服务
//        [currentPeripheral discoverServices:nil];
        
    }
}


//连接成功调用
-(void)centralManager:(CBCentralManager *)central didConnectPeripheral:(CBPeripheral *)peripheral
{
    NSLog(@"连接成功");
    [[NSNotificationCenter defaultCenter] postNotificationName:LPSnoreBlueChangeStatus object:@"4"];
    self.whetherElectrical = NO;
    self.NeedElectricalLenght = 0;
    
    self.isBeginLow = NO;
    self.isLowLenght = 0;
//    [LCProgressHUD showSuccess:@"连接成功"];
//    currentPeripheral = peripheral;
//    currentPeripheral.delegate = self;
    //寻找服务
//    [LPSoundSingle sharedInstance].isStartMeasurement = YES;
    [self.currentPeripheral discoverServices:nil];

}

//断开连接时调用
- (void)centralManager:(CBCentralManager *)central didDisconnectPeripheral:(CBPeripheral *)peripheral error:(NSError *)error
{
    NSLog(@"断开");
//    [[NSNotificationCenter defaultCenter] postNotificationName:LPSnoreBlueChangeStatus object:@"4"];

//    [WCAlertView showAlertWithTitle:@"与设备的连接已断开，是否重连" message:nil customizationBlock:^(WCAlertView *alertView) {
//        
//    } completionBlock:^(NSUInteger buttonIndex, WCAlertView *alertView) {
//        
//        [[KBCoordinatingContext sharedInstance] stopBlueScane];
//        
//        LPRecordsListModel* model = [KBCoordinatingContext sharedInstance].listModel;
//        //如果是YES的时候，表面数据已经插入了数据库，所以这个时候要更新数据库
//        
//        [LPSoundSingle sharedInstance].isStartMeasurement = NO;
//        self.blueStatue = NO;
//
//
//        
//        if (model.whetherInsert == YES) {
//            model.EndTime = [LPDateTimeUtil fmtyyyyMMddHHmmss:[NSDate date]];
//            if ([LPSaveRecordController sharedDatabase].isRecording) {
//                [[LPSaveRecordController sharedDatabase] FinishRecordByUniqueId:model.RecordsId];
//                model.RecordingCount = [NSString stringWithFormat:@"%d",[model.RecordingCount intValue] + 1];
//                [LPBlueSqlManager updateRecordsListModel:model];
//            }
//            [LPBlueSqlManager updateRecordsListModel:model];
//        }
//
//        if(buttonIndex == 1)
//        {
//            [KBCoordinatingContext sharedInstance].listModel = nil;
    self.currentPeripheral = nil;
    self.centralManager = nil;
    self.serviceCharacteristic = nil;
    self.timeCharacteristic = nil;
    self.serviceCharacteristic = nil;
//        }
//        else
//        {
    [KBCoordinatingContext sharedInstance].listModel.EndTime = [LPDateTimeUtil fmtyyyyMMddHHmmss:[NSDate date]];
    [[KBCoordinatingContext sharedInstance] startBlueScane];
    [self performSelector:@selector(stopBluetoothScane) withObject:nil afterDelay:20*60];
//        }
//    } cancelButtonTitle:@"重连" otherButtonTitles:@"取消", nil];
}


- (void)stopBluetoothScane
{
    if (self.currentPeripheral == nil) {
        [WCAlertView showAlertWithTitle:@"重连止鼾器设备失败" message:nil customizationBlock:^(WCAlertView *alertView) {
            
        } completionBlock:^(NSUInteger buttonIndex, WCAlertView *alertView) {
            [KBCoordinatingContext sharedInstance].blueManager = nil;
            [LPBlueSqlManager updateRecordsListModel:[KBCoordinatingContext sharedInstance].listModel];
        } cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
    }
}



//连接失败时调用
-(void)centralManager:(CBCentralManager *)central didFailToConnectPeripheral:(CBPeripheral *)peripheral error:(NSError *)error
{
//    [LCProgressHUD showFailure:@"连接失败"];
    NSLog(@"连接失败");
    self.currentPeripheral = nil;
    self.centralManager = nil;
    self.serviceCharacteristic = nil;
    self.timeCharacteristic = nil;
    self.serviceCharacteristic = nil;
    [KBCoordinatingContext sharedInstance].blueManager = nil;
#pragma mark 蓝牙配对失败之后，重新扫描连接
    [[KBCoordinatingContext sharedInstance] startBlueScane];

}


//寻找服务  1.
- (void)peripheral:(CBPeripheral *)peripheral didDiscoverServices:(NSError *)error
{
    NSLog(@"寻找服务");
    NSArray *services = [peripheral services];
    for (CBService *service in services) {
        
//         NSLog(@"UUID   :%@",service.UUID);
        if ([service.UUID isEqual:[CBUUID UUIDWithString:LPSnoreBattery]]) {
//            NSLog(@"LPSnoreBattery %@",service.UUID);
            [peripheral discoverCharacteristics:nil forService:service];
        }
        else if ([service.UUID isEqual:[CBUUID UUIDWithString:LPSnoreSpO2]])
        {
            [peripheral discoverCharacteristics:nil forService:service];
        }
//        else if ([service.UUID isEqual:[CBUUID UUIDWithString:LPSnorePulse]])
//        {
//            [peripheral discoverCharacteristics:nil forService:service];
//        }
        else if ([service.UUID isEqual:[CBUUID UUIDWithString:LPSnorTime]])
        {
            [peripheral discoverCharacteristics:nil forService:service];
        }
        else if ([service.UUID isEqual:[CBUUID UUIDWithString:LPSnorElectricalStimulation]])
        {
            [peripheral discoverCharacteristics:nil forService:service];
        }
    }
}


//找到characteristic   有新数据 读取     2.
- (void)peripheral:(CBPeripheral *)peripheral didDiscoverCharacteristicsForService:(CBService *)service error:(NSError *)error
{
    
//    NSLog(@"characteristics:%@",[service characteristics]);
    NSArray *characteristics = [service characteristics];
    
    for (CBCharacteristic *cb in characteristics) {
        if ([[cb UUID] isEqual:[CBUUID UUIDWithString:LPSnoreBatteryValue]]) {
//            NSLog(@"LPSnoreBatteryNumerical");
            [peripheral setNotifyValue:YES forCharacteristic:cb];
        }
        else if ([[cb UUID] isEqual:[CBUUID UUIDWithString:LPSnoreSpO2Value]])
        {
            [peripheral setNotifyValue:YES forCharacteristic:cb];
        }
        else if ([[cb UUID] isEqual:[CBUUID UUIDWithString:LPSnorePulseValue]])
        {
            [peripheral setNotifyValue:YES forCharacteristic:cb];
        }
        else if ([[cb UUID] isEqual:[CBUUID UUIDWithString:LPSnorTimeValue]])
        {
            [peripheral setNotifyValue:YES forCharacteristic:cb];
        }
        else if ([[cb UUID] isEqual:[CBUUID UUIDWithString:LPSnorElectricalStimulationValue]])
        {
            [peripheral setNotifyValue:YES forCharacteristic:cb];
        }
    }
}

//通知调用    3.
- (void)peripheral:(CBPeripheral *)peripheral didUpdateNotificationStateForCharacteristic:(CBCharacteristic *)characteristic error:(NSError *)error
{
    NSLog(@"通知调用    3.  %@",characteristic);
    [peripheral readValueForCharacteristic:characteristic];
}

//读取数据   4.
- (void)peripheral:(CBPeripheral *)peripheral didUpdateValueForCharacteristic:(CBCharacteristic *)characteristic error:(NSError *)error
{
    
    if ([[characteristic UUID] isEqual:[CBUUID UUIDWithString:LPSnoreBatteryValue]]) {

        self.batteryCharacteristic = characteristic;
        NSData *data = characteristic.value;
        if (data.length != 0) {
            Byte *testByte = (Byte *)[data bytes];

            unichar theChar = testByte[0] & 0x00FF;
            NSString* battery = [NSString stringWithFormat:@"%d",theChar];
            [[NSNotificationCenter defaultCenter] postNotificationName:LPSnoreGetBattery object:battery];
//            NSLog(@"电池电量   %d",theChar);
        }
    }
    else if ([[characteristic UUID] isEqual:[CBUUID UUIDWithString:LPSnoreSpO2Value]])
    {
        NSData *data = characteristic.value;
        
        Byte *testByte = (Byte *)[data bytes];
        if (data.length != 0) {
            unichar theChar = testByte[0] & 0x00FF;
            unichar theChar1 = testByte[1] & 0x00FF;
            
            static BOOL isInsert = NO;
            if (isInsert) {
                LPRecordInfoModel* model = [[LPRecordInfoModel alloc] init];
                model.BloodOx = [NSString stringWithFormat:@"%d",theChar];
                model.Pulse = [NSString stringWithFormat:@"%d",theChar1];
                model.RecordsId = [KBCoordinatingContext sharedInstance].listModel.RecordsId;
                model.Time = [LPDateTimeUtil fmtyyyyMMddHHmmss:[NSDate date]];
                model.StimulateGear = @"0";
#pragma mark 尝试判断是否需要电刺激
                [self compareElectricalSizeWithDefalutWithModel:model];
            }
            else
            {
                isInsert = YES;
            }
        }
    }

    else if ([[characteristic UUID] isEqual:[CBUUID UUIDWithString:LPSnorTimeValue]])
    {
        NSLog(@"获取时间服务");
        
        NSData *data = characteristic.value;
        
        NSDate* date = [self getEquipmentTimeWithData:data];
        if (date == nil) {
             [self performSelector:@selector(gotoCalibrationEquipmentTime) withObject:nil afterDelay:2.0f];
        }
        else
        {
            NSTimeInterval timer = [date timeIntervalSinceDate:[NSDate date]];
    #pragma mark  当时间差超过30秒的时候去校准设备的时间
            static int writeTimeCount = 0;
            if (timer > 30 || timer < -30) {
                if (writeTimeCount > 3) {
                    NSLog(@"时间校准3次都失败了");
                    return;
                }
                writeTimeCount ++;
                [self performSelector:@selector(gotoCalibrationEquipmentTime) withObject:nil afterDelay:2.0f];
            }
            else
            {
                if (writeTimeCount > 0) {
                    writeTimeCount = 0; 
                    [WCAlertView showAlertWithTitle:@"设备时间校准成功" message:nil customizationBlock:^(WCAlertView *alertView) {
                        
                    } completionBlock:^(NSUInteger buttonIndex, WCAlertView *alertView) {
                        
                    } cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
                }
            }
        }
        self.timeCharacteristic = characteristic;
    }
    else if ([[characteristic UUID] isEqual:[CBUUID UUIDWithString:LPSnorElectricalStimulationValue]])
    {
        NSLog(@"获取电刺激服务");
        self.stimulationCharacteristic = characteristic;
    }
}

//写入数据
- (void)writeData:(NSString *)dataStr
{
    NSData * valueData = [dataStr dataUsingEncoding:NSUTF8StringEncoding];
    [_currentPeripheral writeValue:valueData forCharacteristic:_serviceCharacteristic
                                   type:CBCharacteristicWriteWithResponse];
}



- (void)writeTimeWithData:(NSData*)temp
{
    [_currentPeripheral writeValue:temp forCharacteristic:_timeCharacteristic type:CBCharacteristicWriteWithResponse];
}

- (void)writeElectricalStimulationWithData:(NSData*)temp
{
    [_currentPeripheral writeValue:temp forCharacteristic:_stimulationCharacteristic type:CBCharacteristicWriteWithResponse];

}


- (void)readTimeServiceAction
{
    if(_timeCharacteristic != nil)
    {
        [self.currentPeripheral readValueForCharacteristic:_timeCharacteristic];
    }
}



- (NSString *) dataToHexString:(NSData*)data
{
    NSUInteger          len = [data length];
    char *              chars = (char *)[data bytes];
    NSMutableString *   hexString = [[NSMutableString alloc] init];
    
    for(NSUInteger i = 0; i < len; i++ )
    {
        [hexString appendString:[NSString stringWithFormat:@"%0.2hhx", chars[i]]];
    }
    return hexString;
}



#pragma mark 尝试去获取电池电量
- (void)readEquipmentBattery
{
    /*
      为了获取电池电量，所以在蓝牙连接成功之后，应该先扫描设备的电池服务，将将其保存下来
     */
    //设备去读取电池电量
    if(_batteryCharacteristic != nil)
    {
        [self.currentPeripheral readValueForCharacteristic:_batteryCharacteristic];
    }
}


#pragma mark  给用户一个电刺激  根据档位

- (void)sendOneBatteryStimulusSignal:(NSString*)stimulusGear
{
    if(self.currentPeripheral != nil)
    {
#pragma mark 发电刺激信号
        Byte temp_data[1];
        temp_data[0] = [stimulusGear intValue];
        NSData *adata = [[NSData alloc] initWithBytes:temp_data length:1];
        [_currentPeripheral writeValue:adata forCharacteristic:_stimulationCharacteristic type:CBCharacteristicWriteWithResponse];
    }
}



- (void)updateSnoreSqlWithModel:(LPRecordInfoModel*)model
//- (void)updateSnoreSqlWithBlood:(unichar)blood andPulse:(unichar)pulse
{
    NSString* bloodOx = model.BloodOx;
    NSString* pulseFree = model.Pulse;
    
    LPRecordsListModel* listModel = [KBCoordinatingContext sharedInstance].listModel;
#pragma mark  每次测量的时候重新给listModel初始化
    if (listModel == nil) {
        
        [LPSoundSingle sharedInstance].isStartMeasurement = YES;
        
        listModel = [[LPRecordsListModel alloc] init];
        listModel.MaxBloodOx = bloodOx;
        listModel.MinPulse = pulseFree;
        listModel.RecordsId = [NSString stringWithFormat:@"%0.0f",[NSDate timeIntervalSinceReferenceDate]];
    
        listModel.StartTime = [LPDateTimeUtil fmtyyyyMMddHHmmss:[NSDate date]];
        listModel.EndTime = @"";
        listModel.RecordingCount = @"0";
        listModel.ElectricalCount = @"0";
        listModel.whetherInsert = NO;
        
        listModel.DefaultGear = [[NSUserDefaults standardUserDefaults] objectForKey:LPSetElectricalStimulationGear];
        
        [KBCoordinatingContext sharedInstance].listModel = listModel;
    }
    
    BOOL isNeedUpdate = NO;
    if ([listModel.MaxBloodOx intValue] < [bloodOx intValue]) {
        listModel.MaxBloodOx = bloodOx;
        isNeedUpdate = YES;
    }
    
    if([listModel.MinPulse intValue] == 0)
    {
        listModel.MinPulse = pulseFree;
    }
    else
    {
        if ([listModel.MinPulse intValue] > [pulseFree intValue]) {
            listModel.MinPulse = pulseFree;
            isNeedUpdate = YES;
        }
    }
    
    if (listModel.whetherInsert == YES && isNeedUpdate == YES) {
#pragma mark 如果最小的脉率与最大的血氧值有改变就更新数据库
        [LPBlueSqlManager updateRecordsListModel:listModel];
    }
    
    NSDate* listModelStartTime = [LPDateTimeUtil parseyyyyMMddHHmmss:listModel.StartTime];
    NSTimeInterval timeLenght = [[NSDate date] timeIntervalSinceDate:listModelStartTime];
    if (fabs(timeLenght)  >= 60  && listModel.whetherInsert == NO) {
        listModel.whetherInsert = YES;
        [LPBlueSqlManager insertRecordsListModel:listModel];
    }
    
    if (model.RecordsId.length == 0) {
        model.RecordsId = listModel.RecordsId;
    }
    
    [LPBlueSqlManager insertRecordEntryWithModel:model];
}




- (NSDate*)getEquipmentTimeWithData:(NSData*)data
{
    Byte *testByte = (Byte *)[data bytes];
    int year = testByte[0] + testByte[1]*256;
    int month = testByte[2];
    int day = testByte[3];
    int hour = testByte[4];
    int mintue = testByte[5];
    int sennds = testByte[6];
    //        int week = testByte[7];
    NSString* timeString = [NSString stringWithFormat:@"%d-%d-%d %d:%d:%d",year,month,day,hour,mintue,sennds];
//    NSLog(@"timeString  %@",timeString);
    NSDate* date = [LPDateTimeUtil parseyyyyMMddHHmmss:timeString];
//    return @"2016-0"
    return date;
    
}


#pragma mark 校准设备时间
- (void)gotoCalibrationEquipmentTime
{

    NSDate* date = [NSDate date];
//    date = [LPDateTimeUtil parseyyyyMMddHHmmss:@"2016-08-15 10:09:25"];
    int year = (int)[date year];

    int month = (int)[date month];
    int day = (int)[date day];
    int hour = (int)[date hour];
    int minute = (int)[date minute];
    int seconds = (int)[date seconds];
    int week = (int)[date week];
    Byte temp_data[10];


    temp_data[0] = year & 0x00FF;
    temp_data[1] =(year & 0xFF00)>>8;
    temp_data[2] = month;
    temp_data[3] = day;
    temp_data[4] = hour;
    temp_data[5] = minute;
    temp_data[6] = seconds;
    temp_data[7] = week;
    temp_data[8] = 0;
    temp_data[9] = 1;


//    NSString* dateString = [[NSString  allow ] ini]
    NSData *adata = [[NSData alloc] initWithBytes:temp_data length:10];
    [self writeTimeWithData:adata];
    
#pragma mark 校准时间之后，6秒之后再去读取时间，如果时间相差不超过30s，提示用户时间校准成功
    [self performSelector:@selector(readTimeServiceAction) withObject:nil afterDelay:6.0f];
    
    

//    NSNumber
//    Byte

//    NSString *yearString = [NSString stringWithFormat:@"%@",[[NSString alloc] initWithFormat:@"%1x",year]];
//    NSString *monthString = [NSString stringWithFormat:@"%@",[[NSString alloc] initWithFormat:@"%1x",month]];
//    NSString *dayString = [NSString stringWithFormat:@"%@",[[NSString alloc] initWithFormat:@"%1x",day]];
//    NSString *hourString = [NSString stringWithFormat:@"%@",[[NSString alloc] initWithFormat:@"%1x",hour]];
//    NSString *minuteString = [NSString stringWithFormat:@"%@",[[NSString alloc] initWithFormat:@"%1x",minute]];
//    NSString *secondsString = [NSString stringWithFormat:@"%@",[[NSString alloc] initWithFormat:@"%1x",seconds]];
//    NSString *weekString = [NSString stringWithFormat:@"%@",[[NSString alloc] initWithFormat:@"%1x",week]];
//
//
//    NSString* hexString = [NSString stringWithFormat:@"%@%@%@%@%@%@%@%@%@",yearString,monthString,dayString,hourString,minuteString,secondsString,weekString,@"00",@"01"];
//
}





#pragma mark   比较血氧值与默认值的大小
- (void)compareElectricalSizeWithDefalutWithModel:(LPRecordInfoModel*)model
{
#pragma 血氧值小于50 不考虑   还没有插入数据列表的数据也不考虑
    
    int currentBloodOx = [model.BloodOx  intValue];
    
    LPRecordsListModel* listModel = [KBCoordinatingContext sharedInstance].listModel;
    
    NSString* bloodOxKey = [NSString stringWithFormat:@"%@",[[NSUserDefaults standardUserDefaults] objectForKey:LPBloodOXygenElectricalKey]];
    if (currentBloodOx  <= 50 || listModel.whetherInsert == NO || [bloodOxKey isEqualToString:@"0"]) {
        model.StimulateGear = @"0";
        [self updateSnoreSqlWithModel:model];
        
        if (currentBloodOx < 50) {
            self.isLowLenght ++;
        }
        
        NSLog(@"isLowLenght  %d",self.isLowLenght);
        if (self.isLowLenght > 120) {
#pragma mark  连续120秒都小于50的时候，进行提示
            if (self.isBeginLow) {
                self.isLowLenght  = 0;
//                开始是大于50，后来小于50了，这个时候提示并断开蓝牙连接，保存数据
                if (listModel.whetherInsert == YES) {
                    listModel.EndTime = [LPDateTimeUtil fmtyyyyMMddHHmmss:[NSDate date]];
                    if ([LPSaveRecordController sharedDatabase].isRecording) {
                        [[LPSaveRecordController sharedDatabase] FinishRecordByUniqueId:listModel.RecordsId];
                        listModel.RecordingCount = [NSString stringWithFormat:@"%d",[listModel.RecordingCount intValue] + 1];
                    }
                    [LPBlueSqlManager updateRecordsListModel:listModel];
                }
                
                [[KBCoordinatingContext sharedInstance] stopBlueScane];
                
                [WCAlertView showAlertWithTitle:@"您的设备可能意外脱落，已给您停止了本次测量" message:nil customizationBlock:^(WCAlertView *alertView) {
                    
                } completionBlock:^(NSUInteger buttonIndex, WCAlertView *alertView) {
                    
                } cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            }
            else
            {
                self.isLowLenght  = 0;
                if (listModel.whetherInsert == YES) {
                    listModel.EndTime = [LPDateTimeUtil fmtyyyyMMddHHmmss:[NSDate date]];
                    if ([LPSaveRecordController sharedDatabase].isRecording) {
                        [[LPSaveRecordController sharedDatabase] FinishRecordByUniqueId:listModel.RecordsId];
                        listModel.RecordingCount = [NSString stringWithFormat:@"%d",[listModel.RecordingCount intValue] + 1];
                    }
                    [LPBlueSqlManager updateRecordsListModel:listModel];
                }
                [[KBCoordinatingContext sharedInstance] stopBlueScane];
                NSLog(@"播放提示音乐");
//                dispatch_async(dispatch_get_main_queue(), ^{
                [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayback error:nil];
                NSString* urlString =  [[NSBundle mainBundle] pathForResource:@"snore" ofType:@"m4r"];
                NSURL* url = [NSURL URLWithString:urlString];
                SystemSoundID sound;
                AudioServicesCreateSystemSoundID((__bridge CFURLRef)url,&sound);
                AudioServicesPlaySystemSound(sound);
                [[LPSoundSingle sharedInstance] performSelector:@selector(audioSetCategoryType) withObject:nil afterDelay:10.0f];
//                [[AVAudioSession sharedInstance] performSelector:@selector(setCategory:) withObject:AVAudioSessionCategoryPlayAndRecord afterDelay:10.0f];
//                    AVAudioPlayer* player = [[AVAudioPlayer alloc]initWithContentsOfURL:url error:nil];
//                    //缓冲一下在播放
//                    [player prepareToPlay];
//                    [player play];
//                    player.delegate = self;
                
                    
//                });
              
                
                
                //连上设备之后，一直低于50 ，设备有问题，播放音效
                [WCAlertView showAlertWithTitle:@"您的本次数据异常，请检查仪器是否正常" message:nil customizationBlock:^(WCAlertView *alertView) {
                    
                } completionBlock:^(NSUInteger buttonIndex, WCAlertView *alertView) {
                    
                } cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
                
            }
        }
    }
    else
    {
        
        if (currentBloodOx > 50) {
            self.isLowLenght = 0;
            self.isBeginLow = YES;
        }
        
         NSString* bloodOx = [NSString stringWithFormat:@"%@",[[NSUserDefaults standardUserDefaults] objectForKey:LPSetBlood0xygenValue]];
    #pragma mark 如果当血氧值低于设置值的时候，开始计时，并将停止自适应档位的时间设为0
        if (currentBloodOx < [bloodOx intValue] && currentBloodOx != 0) {
            NSLog(@"开始电刺激计时  %d",currentBloodOx);
            self.NeedElectricalLenght ++;
            self.whetherElectrical =  YES;
        }
        else
        {
            NSLog(@"    结束电刺激计时  %d",currentBloodOx);
    #pragma mark  如果高于的时候  不需要电刺激，所以置为0 与 NO
            self.NeedElectricalLenght = 0;
            self.whetherElectrical = NO;
        }
    #pragma mark 每隔20秒一次电刺激，取余,当余数是0,且可以电刺激的时候，且 NeedElectricalLenght 不为0的时候
        int index = self.NeedElectricalLenght%20;
        NSLog(@"index = %d,  NeedElectricalLenght = %d",index,self.NeedElectricalLenght);
        if (index == 0 && self.whetherElectrical == YES && self.NeedElectricalLenght != 0) {

            
            NSString* gear = listModel.DefaultGear;
            NSString* electricalDynamic = [NSString stringWithFormat:@"%@",[[NSUserDefaults standardUserDefaults] objectForKey:LPElectricalDynamicKey]];
    #pragma mark  加一次电刺激，更新数据库的内容
            listModel.ElectricalCount = [NSString stringWithFormat:@"%d",[listModel.ElectricalCount intValue] + 1];
            [LPBlueSqlManager updateRecordsListModel:listModel];

    //        self.NeedElectricalLenght = 0;
    //        self.whetherElectrical = NO;
    //        self.addGear = 0;
    //        [self compareElectricalStimulationGear];
    #pragma mark 如果连续120秒都处于低档位，并连续在设定档位电刺激了5次，没有打开动态调整，就继续普通电刺激，打开了动态调整，就加档位电刺激
            if (self.NeedElectricalLenght%120 == 0) {
                
                if([electricalDynamic isEqualToString:@"1"])
                {
    #pragma mark 最高不电刺激档位超过设定的二挡
                    int newGear = [listModel.DefaultGear intValue] +1;
                    NSString* electricalGear = [NSString stringWithFormat:@"%@",[[NSUserDefaults standardUserDefaults] objectForKey:LPSetElectricalStimulationGear]];
                    int electri = [electricalGear intValue];
                    if (newGear > electri +2) {
                        newGear = electri + 2;
                    }
                    if (newGear > 6) {
                        newGear = 6;
                    }
                    listModel.DefaultGear = [NSString stringWithFormat:@"%d",newGear];
                   
    #pragma mark 自适应档位 发送电刺激，并插入数据库
                    NSLog(@"给用户电刺激  加档 %@  档位",listModel.DefaultGear);
                    model.StimulateGear = listModel.DefaultGear;
                    [self sendOneBatteryStimulusSignal:listModel.DefaultGear];
                    [LPBlueSqlManager insertElectricalSqlRecord:listModel.RecordsId andGear:listModel.DefaultGear];
                }
                else
                {
                    NSLog(@"给用户电刺激  普通的  %@  档位",listModel.DefaultGear);
                    model.StimulateGear = listModel.DefaultGear;
                    [self sendOneBatteryStimulusSignal:listModel.DefaultGear];
                    [LPBlueSqlManager insertElectricalSqlRecord:listModel.RecordsId andGear:listModel.DefaultGear];
                }
            }
            else
            {
#pragma mark 当加过一次档位之后，只要血氧值没有回到正常值之上，就继续持续这个档位20秒一次电刺激
                NSLog(@"给用户电刺激  listModel的  %@  档位",gear);
                model.StimulateGear = gear;
                [self sendOneBatteryStimulusSignal:gear];
                [LPBlueSqlManager insertElectricalSqlRecord:listModel.RecordsId andGear:gear];
            }
        }
        else
        {
            model.StimulateGear = @"0";
        }
        [self updateSnoreSqlWithModel:model];

    }
}





@end
