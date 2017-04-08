//
//  UserObjJSON.m
//  Moto-moto
//
//  Created by Vladimir Malakhov on 25.03.17.
//  Copyright © 2017 Vladimir Malakhov. All rights reserved.
//

#import "UserObjJSON.h"

@implementation UserObjJSON

- (instancetype)initUserWithlng:(NSArray *)lng ltd:(NSArray *)ltd image:(NSArray *)image ID:(NSArray *)ID {
    
    if ((self = [super init])) {
        
        _lng = lng;
        _ltd = ltd;
        _image = image;
        _ID = ID;
    }
    
    return self;
}

@end
