//
//  OutcomeReqObj.m
//  Moto-moto
//
//  Created by Vladimir Malakhov on 03.04.17.
//  Copyright © 2017 Vladimir Malakhov. All rights reserved.
//

#import "OutcomeReqObj.h"

@implementation OutcomeReqObj

- (instancetype) initUserWithImage:(NSArray *)image fname:(NSArray *)fname lname:(NSArray *)lname ident:(NSArray *)ident time:(NSArray *)time {
    
    self = [super init];
    
    if (self) {
        
        self.image = image;
        self.fname = fname;
        self.lname = lname;
        self.ident = ident;
        self.time = time;
    }
    
    return self;
}

@end
