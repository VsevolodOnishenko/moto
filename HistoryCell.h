//
//  HistoryCell.h
//  Moto-moto
//
//  Created by Vladimir Malakhov on 13.01.17.
//  Copyright © 2017 Vladimir Malakhov. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HistoryCell : UITableViewCell

@property (nonatomic, weak) IBOutlet UIImageView *image;
@property (nonatomic, weak) IBOutlet UILabel *title;
@property (nonatomic, weak) IBOutlet UILabel *lenght;
@property (nonatomic, weak) IBOutlet UILabel *time_duration;

@end
