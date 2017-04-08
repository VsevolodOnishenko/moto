//
//  incomeMessage.h
//  Moto-moto
//
//  Created by Vladimir Malakhov on 03.03.17.
//  Copyright © 2017 Vladimir Malakhov. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface incomeMessage : NSObject

@property (nonatomic, strong) NSArray *author;
@property (nonatomic, strong) NSArray *message;
@property (nonatomic, strong) NSArray *date;

- (instancetype) initMessage:(NSArray *)message author:(NSArray *)author date:(NSArray *)date;

@end
