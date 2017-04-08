//
//  fabriqStyleView.h
//  Moto-moto
//
//  Created by Vladimir Malakhov on 25.01.17.
//  Copyright © 2017 Vladimir Malakhov. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface fabriqStyleView : UIView

+ (UIView *)ApplyStyleView_CornerShadow:(UIView *)view cornerRaduis:(float)c_raduis shadowOffSetX:(float)of_x shadowOffSetY:(float)of_y shadowRaduis:(float)s_radius shadowOpacity:(float)s_opasity maskToBounds:(BOOL)mask;

@end
