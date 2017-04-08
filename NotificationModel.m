//
//  NotificationModel.m
//  Moto-moto
//
//  Created by Vladimir Malakhov on 15.03.17.
//  Copyright © 2017 Vladimir Malakhov. All rights reserved.
//

#import "NotificationModel.h"

@implementation NotificationModel

- (instancetype) initNotificationWithUserID:(NSArray *)user ID:(NSArray *)ID time:(NSArray *)time {
    
    self = [super init];
    
    if (self) {
        
        self.user = user;
        self.ID = ID;
        self.time = time;
    }
    
    return self;
}

@end
