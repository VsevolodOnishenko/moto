//
//  fabriqAnimation.h
//  Moto-moto
//
//  Created by Vladimir Malakhov on 25.01.17.
//  Copyright © 2017 Vladimir Malakhov. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface fabriqAnimation : CATransition

+ (CATransition *)initAnimationType_PushTop:(CATransition *)a;
+ (CATransition *)initAnimationType_PushBottom:(CATransition *)a;
+ (CATransition *)initAnimationType_Fade:(CATransition *)a;
+ (CATransition *)initAnimationType_PushRight:(CATransition *)a;
+ (CATransition *)initAnimationType_PushLeft:(CATransition *)a;

@end
