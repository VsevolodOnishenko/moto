//
//  Dialog.h
//  Moto-moto
//
//  Created by Vladimir Malakhov on 06.03.17.
//  Copyright © 2017 Vladimir Malakhov. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Dialog : NSObject

@property (nonatomic, strong) NSArray *lastMessageText;
@property (nonatomic, strong) NSArray *lastMessageDate;
@property (nonatomic, strong) NSArray *unreadCount;

- (instancetype) initDialogWithLastMessageText:(NSArray *)lastMessageText lastMessageDate:(NSArray *)lastMessageDate unreadCount:(NSArray *)unreadCount;

@end
