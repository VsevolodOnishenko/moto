//
//  fabriqAnimation.m
//  Moto-moto
//
//  Created by Vladimir Malakhov on 25.01.17.
//  Copyright © 2017 Vladimir Malakhov. All rights reserved.
//

#import "fabriqAnimation.h"

@implementation fabriqAnimation

+ (CATransition *)initAnimationType_PushTop:(CATransition *)a {
    
    a.type = kCATransitionPush;
    a.subtype = kCATransitionFromTop;
    a.duration = 0.6;
    
    return a;
}

+ (CATransition *)initAnimationType_PushBottom:(CATransition *)a {
    
    a.type = kCATransitionPush;
    a.subtype = kCATransitionFromBottom;
    a.duration = 0.3;
    
    return a;
}

+ (CATransition *)initAnimationType_Fade:(CATransition *)a {
    
    a.type = kCATransitionFade;
    a.duration = 0.3;
    
    return a;
}

+ (CATransition *)initAnimationType_PushRight:(CATransition *)a {
    
    a.type = kCATransitionPush;
    a.subtype = kCATransitionFromLeft;
    a.duration = 0.3;
    
    return a;
}

+ (CATransition *)initAnimationType_PushLeft:(CATransition *)a {
    
    a.type = kCATransitionPush;
    a.subtype = kCATransitionFromLeft;
    a.duration = 0.3;
    
    return a;
}

@end
