//
//  Event_object.m
//  Moto-moto
//
//  Created by Vladimir Malakhov on 11.01.17.
//  Copyright © 2017 Vladimir Malakhov. All rights reserved.
//

#import "Event_object.h"

@implementation Event_object

- (instancetype)initWithPosition:(CLLocationCoordinate2D)position type:(NSString *)type type_event:(NSString *)type_event time:(NSString *)time icons:(NSArray *)icons ID:(NSArray *)ID UserID:(NSArray *)UserID {
    
    if ((self = [super init]))
    {
        _position = position;
        _type = type;
        _type_event = type_event;
        _time = time;
        _icons = icons;
        
        _ID = ID;
        _UserID = UserID;
    }
    
    return self;
}

@end
