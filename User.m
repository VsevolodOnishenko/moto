//
//  user_part.m
//  Moto-moto
//
//  Created by Vladimir Malakhov on 25.01.17.
//  Copyright © 2017 Vladimir Malakhov. All rights reserved.
//

#import "User.h"

@implementation User

- (instancetype) initUserWithImageURL:(NSString *)image_url fname:(NSString *)fname lname:(NSString *)lname ID:(NSString *)ID {
    
    self = [super init];
    
    if (self) {
        self.image_url = image_url;
        self.fname = fname;
        self.lname = lname;
        self.ID = ID;
    }
    
    return self;
}

@end
