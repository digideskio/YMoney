//
//  YANBaseUIViewController.m
//  YMoney
//
//  Created by Дмитрий on 26.11.15.
//  Copyright © 2015 DMA. All rights reserved.
//

#import "YANBaseUIViewController.h"
#import "YMAAccountInfoModel.h"
#import "YANYandexMoneyServer.h"
#import "YMoney-Swift.h"

@interface YANBaseUIViewController ()

@end

@implementation YANBaseUIViewController


- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    NSString* token = [self loadTokenFromStorage];
    self.yandexMoneyServer = [[YANYandexMoneyServer alloc] initWithAccessToken:token];
    [self.yandexMoneyServer subscribeOnEvents:self];
}

-(void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    [self.yandexMoneyServer unSubscribeOnEvents:self];
}

- (void)onInternetConnectionLost {

}

- (void)onReceiveAccountInfo:(YMAAccountInfoModel *)accountInfo {

}

- (void)onNeedToRefreshToken {
    
}

-(void) onTokenAccepted {
    
}

-(void) onReceiveToken:(NSString *)accessToken {
    
}

-(void) onReceiveLastOperations:(NSArray *)operations {
    
}

-(void) onReceiveNextOperations:(NSArray *)operations {
    
}

# pragma mark - private methods

-(NSString *)loadTokenFromStorage {
    KeyStorage* keyStorage = [KeyStorage forTest];
    NSError *error;
    NSString* token = [keyStorage loadDataForKey:@"Token" error:&error];
    return token;
}


@end
