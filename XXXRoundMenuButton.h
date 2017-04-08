//
//  XXXRoundMenuButton.h
//  ilist
//
//  Created by 张超 on 16/1/2.
//  Copyright © 2016年 gerinn. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MotoMap.h"

typedef NS_OPTIONS(NSInteger, XXXIconType) {
    
    XXXIconTypePlus = 0, // plus icon
    XXXIconTypeUserDraw,  // draw icon by youself
    XXXIconTypeCustomImage,
};

@protocol isButtonClickedDelegate;

@interface XXXRoundMenuButton : UIControl

@property (nonatomic, assign) CGSize centerButtonSize;

@property (nonatomic, weak) id <isButtonClickedDelegate> delegate;

@property (nonatomic, assign) XXXIconType centerIconType;

/**
 *  default is nil, only used when centerIconType is XXXIconTypeCustomImage
 */
@property (nonatomic, strong) UIImage* centerIcon;


/**
 *  animate style, if you want icon jump out one by one , set it YES, default is NO;
 */
@property (nonatomic, assign) BOOL jumpOutButtonOnebyOne;

/**
 *  main color
 */
@property (nonatomic, strong) UIColor* mainColor;

/**
 *  config function
 *
 *  @param icons        array of UIImages
 *  @param degree       start degree
 *  @param layoutDegree angle span
 */
- (void)loadButtonWithIcons:(NSArray<UIImage*>*)icons startDegree:(double)degree layoutDegree:(double)layoutDegree;

/**
 *  click block
 */
@property (nonatomic, strong) void (^buttonClickBlock) (NSInteger idx);
@property (nonatomic, strong) void (^buttonClickCentralButton) (NSUInteger idx);

/**
 *  draw center icon block
 */
@property (nonatomic, strong) void (^drawCenterButtonIconBlock)(CGRect rect , UIControlState state);


@property (nonatomic, assign) BOOL isOpened;

@end

@protocol isButtonClickedDelegate <NSObject>

- (void) ButtonClicked;
- (void) ButtonUnClicked;

@end
