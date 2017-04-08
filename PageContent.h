//
//  PageContent.h
//  Moto-moto
//
//  Created by Vladimir Malakhov on 25.01.17.
//  Copyright © 2017 Vladimir Malakhov. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "SWRevealViewController.h"

@interface PageContent : UIViewController

@property (weak, nonatomic) IBOutlet UIImageView *background;
@property (weak, nonatomic) IBOutlet UILabel *Maintitle;

@property NSUInteger pageIndex;
@property NSString *titleText;
@property NSString *imageFile;

- (IBAction)next:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *nextButton;

@end
