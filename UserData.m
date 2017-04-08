//
//  UserData.m
//  Moto-moto
//
//  Created by Vladimir Malakhov on 06.03.17.
//  Copyright © 2017 Vladimir Malakhov. All rights reserved.
//

#import "UserData.h"

@implementation UserData

- (instancetype) initUserDataWithToken:(NSString *)token ID:(NSString *)ID {
    
    self = [super init];
    
    if (self) {
        self.token = token;
        self.ID = ID;
    }
    
    return self;
}

@end
