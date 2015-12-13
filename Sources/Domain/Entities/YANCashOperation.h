//
// Created by Дмитрий on 12.10.15.
// Copyright (c) 2015 DMA. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum Direction {
    IN,
    OUT
} OperationDirection;

@class Cash;

@interface YANCashOperation : NSObject

/// Дата операции. Не может быть нулевой.
@property(nonatomic, nonnull, readonly) NSDate *operationDate;

/// Описание операции. Не может быть нулевой.
@property(nonatomic, nonnull, readonly) NSString *operationDescription;

/// Сумма опреации. Не может быть нулевой.
@property(nonatomic, nonnull, readonly) Cash *operationSum;

/// Направление операции. Платежи или пополнения.
@property(nonatomic, readonly) OperationDirection operationDirection;

/// @brief Первичный инициализатор. Инициализатор "init" не поддерживатеся.
/// @param аргументы не должны быть нулевыми.
- (nonnull instancetype)initOperationWithDate:(nonnull NSDate *)operationDate
                                  description:(nonnull NSString *)operationDescription
                                         cash:(nonnull Cash *)operationSum
                                    direction:(OperationDirection )operationDirection;
@end