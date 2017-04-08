//
//  LentaCell.h
//  Moto-moto
//
//  Created by Vladimir Malakhov on 02.11.16.
//  Copyright © 2016 Vladimir Malakhov. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LentaCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *image;
@property (weak, nonatomic) IBOutlet UILabel *title;
@property (weak, nonatomic) IBOutlet UILabel *time_title;
@property (weak, nonatomic) IBOutlet UILabel *subtitle;

@end
