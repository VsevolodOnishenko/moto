//
//  POIItem.m
//  Moto-moto
//
//  Created by Vladimir Malakhov on 30.11.16.
//  Copyright © 2016 Vladimir Malakhov. All rights reserved.
//

#import "POIItem.h"

@implementation Place_object

- (instancetype)initWithPosition:(CLLocationCoordinate2D)position type:(NSString *)type icons:(NSMutableArray *)icons i:(NSNumber *)i category:(NSArray *)category {
    
    if ((self = [super init])) {
        
        _position = position;
        _type = type;
        _icons = icons;
        _i = i;
        _category = category;
    }
    
    return self;
}

@end
