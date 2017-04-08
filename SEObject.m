//
//  SEObject.m
//  Moto-moto
//
//  Created by Vladimir Malakhov on 28.03.17.
//  Copyright © 2017 Vladimir Malakhov. All rights reserved.
//

#import "SEObject.h"

@implementation SEObject

- (instancetype) initObjectWithUserID:(int)UserID latitude:(float)latitude longitude:(float)longitude time:(int)time text:(NSString *)text type:(NSString *)type creatTime:(int)creatTime {
    
    self = [super init];
    
    if (self) {
        
        _UserID = UserID;
        _latitude = latitude;
        _longitude = longitude;
        _time = time;
        _text = text;
        _type = type;
        _creatTime = creatTime;
    }
    
    return self;
}

@end
