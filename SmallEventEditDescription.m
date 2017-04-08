//
//  SmallEventEditDescription.m
//  Moto-moto
//
//  Created by Vladimir Malakhov on 13.03.17.
//  Copyright © 2017 Vladimir Malakhov. All rights reserved.
//

#import "SmallEventEditDescription.h"

@interface SmallEventEditDescription () <UITextViewDelegate>

@end

@implementation SmallEventEditDescription

@synthesize SmallEventDescription;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self ApplyTableViewStyle];
}

- (void) viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    UIBarButtonItem *barButton = [[UIBarButtonItem alloc] init];
    barButton.title = @"";
    self.navigationController.navigationBar.topItem.backBarButtonItem = barButton;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void) ApplyTableViewStyle {
    
    SmallEventDescription.backgroundColor = [UIColor colorWithRed:0.11 green:0.12 blue:0.15 alpha:1.0];
    SmallEventDescription.separatorColor = [UIColor colorWithRed:0.17 green:0.19 blue:0.24 alpha:1.0];
    SmallEventDescription.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 285;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    SmallEventDescriptionCell *cell = (SmallEventDescriptionCell *)[SmallEventDescription dequeueReusableCellWithIdentifier:@"SmallEventDescriptionCell"];
    if (cell == nil) {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"SmallEventDescriptionCell" owner:self options:nil];
        cell = [nib objectAtIndex:0];
    }
    cell.backgroundColor = [UIColor clearColor];
    
    if (!([[NSUserDefaults standardUserDefaults] stringForKey:@"TW"] == NULL)) {
        cell.TW.text = [[NSUserDefaults standardUserDefaults] stringForKey:@"TW"];
    }
    
    [cell.TW becomeFirstResponder];
    cell.TW.delegate = self;
    
    return cell;
}

- (void) textViewDidEndEditing:(UITextView *)textView {
    [[NSUserDefaults standardUserDefaults] setObject:textView.text forKey:@"TW"];
}

@end
