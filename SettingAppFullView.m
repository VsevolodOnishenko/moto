//
//  SettingAppFullView.m
//  Moto-moto
//
//  Created by Vladimir Malakhov on 27.02.17.
//  Copyright © 2017 Vladimir Malakhov. All rights reserved.
//

#import "SettingAppFullView.h"

@interface SettingAppFullView ()

@end

@implementation SettingAppFullView

@synthesize SettingAppFullTableView;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self ApplyTableStyle];
}

- (void) viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.navigationItem.title = @"Настройки";
    self.navigationController.navigationBar.topItem.title = @"";
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void) ApplyTableStyle {
    
    SettingAppFullTableView.backgroundColor = [UIColor colorWithRed:0.13 green:0.15 blue:0.19 alpha:1.0];
    SettingAppFullTableView.separatorColor = [UIColor colorWithRed:0.13 green:0.15 blue:0.19 alpha:1.0];
    SettingAppFullTableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 50;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell = (UITableViewCell *) [SettingAppFullTableView dequeueReusableCellWithIdentifier:@"cell"];
    cell.backgroundColor = [UIColor clearColor];
    cell.textLabel.text = @"дополнительная информация";
    cell.textLabel.textColor = [UIColor whiteColor];
    cell.textLabel.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:16];
    cell.indentationLevel = 3;
    
    return cell;
}



@end
