//
//  FilterCategory.h
//  Moto-moto
//
//  Created by Vladimir Malakhov on 06.03.17.
//  Copyright © 2017 Vladimir Malakhov. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FilterCategory : NSObject

@property (nonatomic, strong) NSArray *title;
@property (nonatomic, strong) NSArray *image;

- (instancetype) initFilterCategoryWithTitle:(NSArray *)title image:(NSArray *)image;

@end
