//
//  PlaceObjectJSON.m
//  Moto-moto
//
//  Created by Vladimir Malakhov on 25.03.17.
//  Copyright © 2017 Vladimir Malakhov. All rights reserved.
//

#import "PlaceObjectJSON.h"

@implementation PlaceObjectJSON

- (instancetype)initObjecttWithPosition:(NSArray *)lng ltd:(NSArray *)ltd type:(NSArray *)type ID:(NSArray *)ID {
    
    if ((self = [super init])) {
        
        _lng = lng;
        _ltd = ltd;
        _type = type;
        _ID = ID;
    }
    
    return self;
}

@end
