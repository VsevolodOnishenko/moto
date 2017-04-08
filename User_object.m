//
//  User_object.m
//  Moto-moto
//
//  Created by Vladimir Malakhov on 11.01.17.
//  Copyright © 2017 Vladimir Malakhov. All rights reserved.
//

#import "User_object.h"

@implementation User_object

- (instancetype)initWithPosition:(CLLocationCoordinate2D)position type:(NSString *)type ident:(NSString *)ident icon_user:(NSString *)icon_user;
{
    if ((self = [super init]))
    {
        _position = position;
        _type = type;
        _ident = ident;
        _icon_user = icon_user;
    }
    
    return self;
}

@end
