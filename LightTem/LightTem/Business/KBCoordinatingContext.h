//
//  CenterController.h
//  ApalaPi
//
//  Created by chuanyhu on 14-1-8.
//  Copyright (c) 2014年 feiffan. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BlueTools.h"
#import "LPRecordsListModel.h"


@interface KBCoordinatingContext : NSObject

@property (nonatomic,strong)BlueTools* blueManager;


@property (nonatomic,strong)NSString* battery; //当前设备的电量


@property (nonatomic,strong)LPRecordsListModel* listModel;   //每次点击测量的时候都创建一个新的对象，并赋值


+ (KBCoordinatingContext *) sharedInstance;


- (void)startBlueScane; //开始蓝牙扫描

- (void)stopBlueScane; //停止蓝牙扫描















@end