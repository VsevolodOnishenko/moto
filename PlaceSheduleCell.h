//
//  PlaceSheduleCell.h
//  Moto-moto
//
//  Created by Vladimir Malakhov on 27.03.17.
//  Copyright © 2017 Vladimir Malakhov. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PlaceSheduleCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *todaysTime;

@property (weak, nonatomic) IBOutlet UILabel *time_0;
@property (weak, nonatomic) IBOutlet UILabel *time_1;
@property (weak, nonatomic) IBOutlet UILabel *time_2;
@property (weak, nonatomic) IBOutlet UILabel *time_3;
@property (weak, nonatomic) IBOutlet UILabel *time_4;
@property (weak, nonatomic) IBOutlet UILabel *time_5;
@property (weak, nonatomic) IBOutlet UILabel *time_6;

@property (weak, nonatomic) IBOutlet UIImageView *icon;

@end
