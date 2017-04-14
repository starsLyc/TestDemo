//
//  BlueTools.h
//  blue
//
//  Created by mac on 16/1/27.
//  Copyright © 2016年 yuanyuan. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreBluetooth/CoreBluetooth.h>
#import "LPSaveRecordController.h"
#import "LPSoundSingle.h"


@class BlueTools;
@protocol BlueToolsDelegate <NSObject>

- (void)receiveData:(NSString *)str;

@end

@interface BlueTools : NSObject<CBCentralManagerDelegate,CBPeripheralDelegate>

@property (nonatomic, strong) CBCentralManager *centralManager;


@property (nonatomic,assign) BOOL blueStatue;




#pragma mark  是否电刺激 及 电刺激的档位

@property (nonatomic,assign)BOOL whetherElectrical;  //是否电刺激

@property (nonatomic,assign)int NeedElectricalLenght;  //需要电刺激的次数

@property (nonatomic,assign)BOOL isBeginLow;  //是否是开始就低于50血氧

@property (nonatomic,assign)int isLowLenght;  //低于血氧的长度



@property(nonatomic,weak)id<BlueToolsDelegate>delegate;

- (id)initWithDriveName:(NSString *)name;

-(void)startBlueScan;                 //扫描设备
- (void)stopScan;

- (void)writeData:(NSString *)dataStr;    //写入数据

- (void)writeTimeWithData:(NSData*)temp;


- (void)writeElectricalStimulationWithData:(NSData*)temp;



- (void)readTimeServiceAction;


#pragma mark 尝试去获取电池电量

- (void)readEquipmentBattery;


#pragma mark  给用户一个电刺激  根据档位

- (void)sendOneBatteryStimulusSignal:(NSString*)stimulusGear;

#pragma mark  将文字类型重新定义

- (void)audioSetCategoryType;





@end
