//
//  SettingProfileCell.h
//  Moto-moto
//
//  Created by Vladimir Malakhov on 28.02.17.
//  Copyright © 2017 Vladimir Malakhov. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SettingProfileCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UITextField *fname;
@property (weak, nonatomic) IBOutlet UITextField *lname;
@property (weak, nonatomic) IBOutlet UIImageView *image;

@end
