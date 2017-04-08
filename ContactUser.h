//
//  ContactUser.h
//  Moto-moto
//
//  Created by Vladimir Malakhov on 01.03.17.
//  Copyright © 2017 Vladimir Malakhov. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ContactUser : NSObject

@property (nonatomic, strong) NSArray *image;
@property (nonatomic, strong) NSArray *fname;
@property (nonatomic, strong) NSArray *lname;
@property (nonatomic, strong) NSArray *ident;

- (instancetype) initUserWithImage:(NSArray *)image fname:(NSArray *)fname lname:(NSArray *)lname ident:(NSArray *)ident;

@end
