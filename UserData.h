//
//  UserData.h
//  Moto-moto
//
//  Created by Vladimir Malakhov on 06.03.17.
//  Copyright © 2017 Vladimir Malakhov. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UserData : NSObject

@property (nonatomic, strong) NSString *token;
@property (nonatomic, strong) NSString *ID;

- (instancetype) initUserDataWithToken:(NSString *)token ID:(NSString *)ID;

@end
