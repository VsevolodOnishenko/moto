//
//  OutcomeReqObj.h
//  Moto-moto
//
//  Created by Vladimir Malakhov on 03.04.17.
//  Copyright © 2017 Vladimir Malakhov. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface OutcomeReqObj : NSObject

@property (nonatomic, strong) NSArray *image;
@property (nonatomic, strong) NSArray *fname;
@property (nonatomic, strong) NSArray *lname;
@property (nonatomic, strong) NSArray *ident;
@property (nonatomic, strong) NSArray *time;

- (instancetype) initUserWithImage:(NSArray *)image fname:(NSArray *)fname lname:(NSArray *)lname ident:(NSArray *)ident time:(NSArray *)time;

@end
