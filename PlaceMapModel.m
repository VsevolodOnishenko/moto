//
//  PlaceMapModel.m
//  Moto-moto
//
//  Created by Vladimir Malakhov on 10.03.17.
//  Copyright © 2017 Vladimir Malakhov. All rights reserved.
//

#import "PlaceMapModel.h"

@implementation PlaceMapModel

- (instancetype)initPlaceMapWithTitle:(NSString *)title body:(NSString *)body category:(NSArray *)category image:(NSArray *)image contacts:(NSMutableDictionary *)contacts shedule:(NSString *)shedule lng:(float)lng ltd:(float)ltd{
    
    if ((self = [super init])) {
        
        _title = title;
        _body = body;
        _category = category;
        _image = image;
        _contacts = contacts;
        _shedule = shedule;
        _lng = lng;
        _ltd = ltd;
    }
    
    return self;
}

@end
