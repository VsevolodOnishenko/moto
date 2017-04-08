//
//  PlaceObjectJSON.h
//  Moto-moto
//
//  Created by Vladimir Malakhov on 25.03.17.
//  Copyright © 2017 Vladimir Malakhov. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PlaceObjectJSON : NSObject

@property(nonatomic, readonly) NSArray *lng;
@property(nonatomic, readonly) NSArray *ltd;
@property(nonatomic, readonly) NSArray *type;
@property(nonatomic, readonly) NSArray *ID;

- (instancetype)initObjecttWithPosition:(NSArray *)lng ltd:(NSArray *)ltd type:(NSArray *)type ID:(NSArray *)ID;

@end
