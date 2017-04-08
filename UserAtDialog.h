//
//  UserAtDialog.h
//  Moto-moto
//
//  Created by Vladimir Malakhov on 06.03.17.
//  Copyright © 2017 Vladimir Malakhov. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UserAtDialog : NSObject

@property (nonatomic, strong) NSArray *image_url;
@property (nonatomic, strong) NSArray *fname;
@property (nonatomic, strong) NSArray *lname;
@property (nonatomic, strong) NSArray *ID;

- (instancetype) initUserWithImageURL:(NSArray *)image_url fname:(NSArray *)fname lname:(NSArray *)lname ID:(NSArray *)ID;

@end
