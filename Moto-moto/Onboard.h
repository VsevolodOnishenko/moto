//
//  Onboard.h
//  Moto-moto
//
//  Created by Vladimir Malakhov on 25.01.17.
//  Copyright © 2017 Vladimir Malakhov. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "PageContent.h"

@interface Onboard : UIViewController

@property (strong, nonatomic) UIPageViewController *pageViewController;
@property (strong, nonatomic) NSArray *pageTitles;
@property (strong, nonatomic) NSArray *pageImages;

@end
