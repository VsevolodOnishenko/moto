//
//  NotificationModel.h
//  Moto-moto
//
//  Created by Vladimir Malakhov on 15.03.17.
//  Copyright © 2017 Vladimir Malakhov. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NotificationModel : NSObject

@property (nonatomic, strong) NSArray *user;
@property (nonatomic, strong) NSArray *ID;
@property (nonatomic, strong) NSArray *time;

- (instancetype) initNotificationWithUserID:(NSArray *)user ID:(NSArray *)ID time:(NSArray *)time;

@end
