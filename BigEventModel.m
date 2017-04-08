//
//  BigEventModel.m
//  Moto-moto
//
//  Created by Vladimir Malakhov on 21.02.17.
//  Copyright © 2017 Vladimir Malakhov. All rights reserved.
//

#import "BigEventModel.h"

@implementation BigEventModel

- (instancetype)initWithImage:(NSString *)image title:(NSString *)title descr:(NSString *)description contacts:(NSDictionary *)contacts address:(NSString *)address time:(NSString *)time {
    
    if ((self = [super init]))
    {
        _image = image;
        _title = title;
        _descr = description;
        _contacts = contacts;
        _address = address;
        _time = time;
    }
    
    return self;
}

@end
