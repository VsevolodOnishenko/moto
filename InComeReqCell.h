//
//  InComeReqCell.h
//  Moto-moto
//
//  Created by Vladimir Malakhov on 04.04.17.
//  Copyright © 2017 Vladimir Malakhov. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface InComeReqCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *image;
@property (weak, nonatomic) IBOutlet UILabel *name;
@property (weak, nonatomic) IBOutlet UILabel *time;

@property (weak, nonatomic) IBOutlet UIButton *addRequest;
@property (weak, nonatomic) IBOutlet UIButton *cancelRequest;

@end
