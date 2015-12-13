//
// Created by Дмитрий on 12.10.15.
// Copyright (c) 2015 DMA. All rights reserved.
//

#import <Foundation/Foundation.h>

@class Cash;


@interface YANBalance : NSObject

/// Значение текущего баланса. Досупно только для чтения.
@property(nonatomic, nonnull, readonly) Cash *currentBalance;

/// @brief Инициализатор "init" не поддерживатеся.
/// @param startCash не может быть пустым.
- (nonnull instancetype)initWithCash:(nonnull Cash *)startCash;

@end