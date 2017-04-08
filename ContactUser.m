//
//  ContactUser.m
//  Moto-moto
//
//  Created by Vladimir Malakhov on 01.03.17.
//  Copyright © 2017 Vladimir Malakhov. All rights reserved.
//

#import "ContactUser.h"

@implementation ContactUser

- (instancetype) initUserWithImage:(NSArray *)image fname:(NSArray *)fname lname:(NSArray *)lname ident:(NSArray *)ident {
    
    self = [super init];
    
    if (self) {
        
        self.image = image;
        self.fname = fname;
        self.lname = lname;
        self.ident = ident;
    }
    
    return self;
}

@end
