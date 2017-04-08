//
//  EventObjectJSON.m
//  Moto-moto
//
//  Created by Vladimir Malakhov on 28.03.17.
//  Copyright © 2017 Vladimir Malakhov. All rights reserved.
//

#import "EventObjectJSON.h"

@implementation EventObjectJSON

- (instancetype)initObjecttWithID:(NSArray *)ID ltd:(NSArray *)ltd lng:(NSArray *)lng time:(NSArray *)time UserID:(NSArray *)UserID {
    
    if ((self = [super init])) {
        
        _ID = ID;
        _ltd = ltd;
        _lng = lng;
        _time = time;
        _UserID = UserID;
    }
    
    return self;
}

@end
