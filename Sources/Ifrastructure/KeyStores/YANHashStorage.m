//
//  YANHashStorage.m
//  YMoney
//
//  Created by Дмитрий on 09.12.15.
//  Copyright © 2015 DMA. All rights reserved.
//

#import "YANHashStorage.h"
#import "YMAAccountInfoModel.h"
#import "YMAHistoryOperationModel.h"
#import "YMoney-Swift.h"


@implementation YANHashStorage {
    KeyStorage * _keyStorage;
}

static NSString *const accountInfoKey = @"accountInfo";
static NSString *const operationHistoryKey = @"operationHistory";

+(instancetype) sharedInstance {
    static dispatch_once_t pred;
    static id shared = nil;
    dispatch_once(&pred, ^{
        shared = [[super alloc] initUniqueInstance];
    });
    return shared;
}

-(instancetype) initUniqueInstance {
    if(self = [super init]) {
        _keyStorage = [[KeyStorage alloc] init];
    }
    return self;
}

-(void) saveAccountInfo:(YMAAccountInfoModel*) accountInfo {
    [_keyStorage saveData:accountInfo forKey:accountInfoKey];
}

-(YMAAccountInfoModel *) loadAccountInfo {
    NSError *error;
    return [_keyStorage loadDataForKey:accountInfoKey error:&error];
}

-(void) saveOperationHistory:(NSArray<YMAHistoryOperationModel*> *) operations {
    [_keyStorage saveData:operations forKey:operationHistoryKey];
}

-(NSArray<YMAHistoryOperationModel*> *) loadOperationHistory {
    NSError *error;
    return [_keyStorage loadDataForKey:operationHistoryKey error:&error];
}

-(void) cleanStorage {
    [_keyStorage cleanKeyStorage];
}

@end
