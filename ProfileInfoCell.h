//
//  ProfileInfoCell.h
//  Moto-moto
//
//  Created by Vladimir Malakhov on 22.02.17.
//  Copyright © 2017 Vladimir Malakhov. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ProfileInfoCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *image;
@property (weak, nonatomic) IBOutlet UITextField *name;
@property (weak, nonatomic) IBOutlet UILabel *address;

@end
