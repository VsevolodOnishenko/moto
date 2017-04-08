//
//  UserObjJSON.h
//  Moto-moto
//
//  Created by Vladimir Malakhov on 25.03.17.
//  Copyright © 2017 Vladimir Malakhov. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UserObjJSON : NSObject

@property(nonatomic, readonly) NSArray *lng;
@property(nonatomic, readonly) NSArray *ltd;
@property(nonatomic, readonly) NSArray *image;
@property(nonatomic, readonly) NSArray *ID;

- (instancetype)initUserWithlng:(NSArray *)lng ltd:(NSArray *)ltd image:(NSArray *)image ID:(NSArray *)ID;

@end
