//
//  ViewControllerTransition.m
//  Moto-moto
//
//  Created by Vladimir Malakhov on 26.01.17.
//  Copyright © 2017 Vladimir Malakhov. All rights reserved.
//

#import "ViewControllerTransition.h"

@implementation ViewControllerTransition

+ (CATransition *) initTranstion:(CATransition *)t {
    
    t.type = kCATransitionPush;
    t.subtype = kCATransitionFade;
    t.duration = 0.1;
    
    return t;
}

@end
