//
//  UserAtDialog.m
//  Moto-moto
//
//  Created by Vladimir Malakhov on 06.03.17.
//  Copyright © 2017 Vladimir Malakhov. All rights reserved.
//

#import "UserAtDialog.h"

@implementation UserAtDialog

- (instancetype) initUserWithImageURL:(NSArray *)image_url fname:(NSArray *)fname lname:(NSArray *)lname ID:(NSArray *)ID {
    
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
