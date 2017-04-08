//
//  EventObjectJSON.h
//  Moto-moto
//
//  Created by Vladimir Malakhov on 28.03.17.
//  Copyright © 2017 Vladimir Malakhov. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface EventObjectJSON : NSObject

@property(nonatomic, readonly) NSArray *ID;
@property(nonatomic, readonly) NSArray *ltd;
@property(nonatomic, readonly) NSArray *lng;
@property(nonatomic, readonly) NSArray *time;
@property(nonatomic, readonly) NSArray *UserID;

- (instancetype)initObjecttWithID:(NSArray *)ID ltd:(NSArray *)ltd lng:(NSArray *)lng time:(NSArray *)time UserID:(NSArray *)UserID;

@end
