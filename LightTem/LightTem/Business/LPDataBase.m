//
//  LPDataBase.m
//  LPSnor
//
//  Created by xlz on 16/8/15.
//  Copyright © 2016年 lepu. All rights reserved.
//

#import "LPDataBase.h"
#import "FMDB.h"

@implementation LPDataBase


+ (LPDataBase * ) sharedDatabase
{
    static LPDataBase * sqlDataBase=nil;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        [self checkDb];
        sqlDataBase =  [[LPDataBase alloc] init];
        
    });
    return sqlDataBase;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self openDatabase];
    }
    return self;
}

- (void)openDatabase
{
    NSString *documentsPath = [LPDataBase defDbPath];
    _database = [[FMDatabase alloc] initWithPath:documentsPath];
    [_database open];
}

+(NSString*) defDbPath
{
    NSString* dbPath= [NSHomeDirectory() stringByAppendingPathComponent:@"Documents/Snore.sqlite"];
    return dbPath;
}

+(BOOL)checkDb
{
    NSFileManager *fm = [NSFileManager defaultManager];
    NSString * targetDbFilePath = [self defDbPath];
    if ( [fm fileExistsAtPath: targetDbFilePath ])
    {
        return true;
    }
    
    NSError *error = nil;
    NSString *dbFileName = [[NSBundle mainBundle] pathForResource:@"Snore" ofType:@"sqlite"];
    [fm copyItemAtPath:dbFileName toPath:targetDbFilePath error:&error];
    if (error)
    {
        NSLog(@"copy db error %@",error);
        return NO;
    }else{
        NSLog(@"copy success, use %@", targetDbFilePath);
        return YES;
    }
}

@end

