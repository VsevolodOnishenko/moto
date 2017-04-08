//
//  fabriqStyleView.m
//  Moto-moto
//
//  Created by Vladimir Malakhov on 25.01.17.
//  Copyright © 2017 Vladimir Malakhov. All rights reserved.
//

#import "fabriqStyleView.h"

@implementation fabriqStyleView

+ (UIView *)ApplyStyleView_CornerShadow:(UIView *)view cornerRaduis:(float)c_raduis shadowOffSetX:(float)of_x shadowOffSetY:(float)of_y shadowRaduis:(float)s_radius shadowOpacity:(float)s_opasity maskToBounds:(BOOL)mask {
    
    view.layer.cornerRadius = c_raduis;
    view.layer.shadowOffset = CGSizeMake(of_x, of_y);
    view.layer.shadowRadius = s_radius;
    view.layer.shadowOpacity = s_opasity;
    view.layer.masksToBounds = mask;
    
    return view;
}

@end
