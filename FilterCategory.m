//
//  FilterCategory.m
//  Moto-moto
//
//  Created by Vladimir Malakhov on 06.03.17.
//  Copyright © 2017 Vladimir Malakhov. All rights reserved.
//

#import "FilterCategory.h"

@implementation FilterCategory

- (instancetype) initFilterCategoryWithTitle:(NSArray *)title image:(NSArray *)image {
    
    self = [super init];
    
    if (self) {
        self.title = title;
        self.image = image;
    }
    
    return self;
}

@end
