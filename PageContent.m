//
//  PageContent.m
//  Moto-moto
//
//  Created by Vladimir Malakhov on 25.01.17.
//  Copyright © 2017 Vladimir Malakhov. All rights reserved.
//

#import "PageContent.h"

@interface PageContent ()

@end

@implementation PageContent

@synthesize background, Maintitle, nextButton;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.background.image = [UIImage imageNamed:self.imageFile];
    self.background.backgroundColor = [UIColor colorWithRed:0.13 green:0.15 blue:0.19 alpha:1.0];
    self.Maintitle.text = self.titleText;
    
    if ([self.titleText isEqualToString:@"3"]) {
        nextButton.hidden = NO;
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (IBAction)next:(id)sender {
    
    UIViewController *toViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"LoggedIn"];
    SWRevealViewControllerSeguePushController *segue = [[SWRevealViewControllerSeguePushController alloc] initWithIdentifier:@"ident" source:self destination:toViewController];
    [segue perform];
}

@end
