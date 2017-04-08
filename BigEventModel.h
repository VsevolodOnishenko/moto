//
//  BigEventModel.h
//  Moto-moto
//
//  Created by Vladimir Malakhov on 21.02.17.
//  Copyright © 2017 Vladimir Malakhov. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BigEventModel : NSObject

@property (nonatomic, readonly) NSString *image;
@property (nonatomic, readonly) NSString *title;
@property (nonatomic, readonly) NSString *descr;
@property (nonatomic, readonly) NSDictionary *contacts;
@property (nonatomic, readonly) NSString *address;
@property (nonatomic, readonly) NSString *time;

- (instancetype)initWithImage:(NSString *)image title:(NSString *)title descr:(NSString *)description contacts:(NSDictionary *)contacts address:(NSString *)address time:(NSString *)time;

@end
