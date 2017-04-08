//
//  SEObject.h
//  Moto-moto
//
//  Created by Vladimir Malakhov on 28.03.17.
//  Copyright © 2017 Vladimir Malakhov. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SEObject : NSObject

@property (nonatomic, readonly) int time;
@property (nonatomic, readonly) int creatTime;
@property (nonatomic, readonly) NSString *text;
@property (nonatomic, readonly) NSString *type;
@property (nonatomic, readonly) float latitude;
@property (nonatomic, readonly) float longitude;
@property (nonatomic, readonly) int UserID;

- (instancetype) initObjectWithUserID:(int)UserID latitude:(float)latitude longitude:(float)longitude time:(int)time text:(NSString *)text type:(NSString *)type creatTime:(int)creatTime;

@end
