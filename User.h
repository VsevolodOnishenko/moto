//
//  user_part.h
//  Moto-moto
//
//  Created by Vladimir Malakhov on 25.01.17.
//  Copyright © 2017 Vladimir Malakhov. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface User : NSObject

@property (nonatomic, strong) NSString *image_url;
@property (nonatomic, strong) NSString *fname;
@property (nonatomic, strong) NSString *lname;
@property (nonatomic, strong) NSString *ID;

- (instancetype) initUserWithImageURL:(NSString *)image_url fname:(NSString *)fname lname:(NSString *)lname ID:(NSString *)ID;

@end
