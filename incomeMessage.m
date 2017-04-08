//
//  incomeMessage.m
//  Moto-moto
//
//  Created by Vladimir Malakhov on 03.03.17.
//  Copyright © 2017 Vladimir Malakhov. All rights reserved.
//

#import "incomeMessage.h"

@implementation incomeMessage

- (instancetype) initMessage:(NSArray *)message author:(NSArray *)author date:(NSArray *)date {
    
    self = [super init];
    
    if (self) {
        self.message = message;
        self.author = author;
        self.date = date;
    }
    
    return self;
}

@end
