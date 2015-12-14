//
//  YANBaseUIViewController.h
//  YMoney
//
//  Created by Дмитрий on 26.11.15.
//  Copyright © 2015 DMA. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YMoney-Swift.h"

@class YMAAccountInfoModel;
@class YandexMoneyServer;

@interface YANBaseUIViewController : UIViewController <YandexServerObserver>

@property (strong, nonatomic) YandexMoneyServer* yandexMoneyServer;

@end

