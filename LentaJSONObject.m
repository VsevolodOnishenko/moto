//
//  LentaJSONObject.m
//  Moto-moto
//
//  Created by Vladimir Malakhov on 31.03.17.
//  Copyright © 2017 Vladimir Malakhov. All rights reserved.
//

#import "LentaJSONObject.h"

@implementation LentaJSONObject

- (instancetype) initLentaObjectWithID:(NSArray *)ID image_url:(NSArray *)image_url title:(NSArray *)title {
    
    self = [super init];
    
    if (self) {
        
        _ID = ID;
        _image_url = image_url;
        _title = title;
    }
    
    return self;
}

@end
