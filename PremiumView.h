//
//  PremiumView.h
//  Moto-moto
//
//  Created by Vladimir Malakhov on 23.11.16.
//  Copyright © 2016 Vladimir Malakhov. All rights reserved.
//

#import <UIKit/UIKit.h>

#import <StoreKit/StoreKit.h>

#import "RKDropdownAlert.h"

@interface PremiumView : UIViewController <SKProductsRequestDelegate>

- (IBAction)noBuy:(id)sender;
- (IBAction)yesBuy:(id)sender;
- (IBAction)restoreBuy:(id)sender;


@end
