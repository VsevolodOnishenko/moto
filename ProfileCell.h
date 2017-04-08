//
//  ProfileCell.h
//  Moto-moto
//
//  Created by Vladimir Malakhov on 01.11.16.
//  Copyright © 2016 Vladimir Malakhov. All rights reserved.
//

#import <UIKit/UIKit.h>

#import <QuartzCore/QuartzCore.h>

@interface ProfileCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *photo;
@property (weak, nonatomic) IBOutlet UILabel *name;

@end
