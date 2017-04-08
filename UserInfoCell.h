//
//  UserInfoCell.h
//  Moto-moto
//
//  Created by Vladimir Malakhov on 03.04.17.
//  Copyright © 2017 Vladimir Malakhov. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UserInfoCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *photo;
@property (weak, nonatomic) IBOutlet UILabel *name;
@property (weak, nonatomic) IBOutlet UILabel *title;

@property (weak, nonatomic) IBOutlet UIButton *sendMessage;
@property (weak, nonatomic) IBOutlet UIButton *friendRequest;

@end
