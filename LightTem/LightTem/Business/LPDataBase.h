//
//  LPDataBase.h
//  LPSnor
//
//  Created by xlz on 16/8/15.
//  Copyright © 2016年 lepu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FMDB.h"
@interface LPDataBase : NSObject

@property (nonatomic,strong) FMDatabase* database;

#pragma mark - 单例
+ (instancetype)sharedDatabase;
@end
