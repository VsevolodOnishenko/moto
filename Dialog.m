//
//  Dialog.m
//  Moto-moto
//
//  Created by Vladimir Malakhov on 06.03.17.
//  Copyright © 2017 Vladimir Malakhov. All rights reserved.
//

#import "Dialog.h"

@implementation Dialog

- (instancetype) initDialogWithLastMessageText:(NSArray *)lastMessageText lastMessageDate:(NSArray *)lastMessageDate unreadCount:(NSArray *)unreadCount {
    
    self = [super init];
    
    if (self) {
        self.lastMessageText = lastMessageText;
        self.lastMessageDate = lastMessageDate;
        self.unreadCount = unreadCount;
    }
    
    return self;
}

@end
