//
//  SettingApp.m
//  Moto-moto
//
//  Created by Vladimir Malakhov on 27.02.17.
//  Copyright © 2017 Vladimir Malakhov. All rights reserved.
//

#import "SettingApp.h"

@interface SettingApp () {
    
    NSArray *appSetting;
    NSArray *supSetting;
}

@end

@implementation SettingApp

@synthesize SettingAppTableView;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initRevealMenu];
    [self initData];
    [self ApplyTableStyle];
}

- (void) viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.navigationItem.title = @"Настройки";
}

- (void) initRevealMenu {
    
    SWRevealViewController *revealViewController = self.revealViewController;
    if ( revealViewController ) {
        [self.view addGestureRecognizer:self.revealViewController.panGestureRecognizer];
    }
    _sideBarButton.target = self.revealViewController;
    _sideBarButton.action = @selector(revealToggle:);
}

- (void) ApplyTableStyle {
    
    SettingAppTableView.backgroundColor = [UIColor colorWithRed:0.13 green:0.15 blue:0.19 alpha:1.0];
    SettingAppTableView.separatorColor = [UIColor colorWithRed:0.13 green:0.15 blue:0.19 alpha:1.0];
    SettingAppTableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
}

- (void) initData {
    
    appSetting = @[@"Отправлять push уведомления", @"Показывать меня на карте", @"Знакомтсво"];
    supSetting = @[@"Поддержка", @"О сервисе МОТО-МОТО", @"Конфиденциальность", @"Premium-аккаунт", @"Дополнительно"];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 50;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    if (section == 0) {
        return appSetting.count;
    } else {
        return supSetting.count;
    }
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    
    if (section == 0) {
        return @"НАСТРОЙКА АККАУНТА";
    } else {
        return @"ПОДДЕРЖКА";
    }
}

- (void)tableView:(UITableView *)tableView willDisplayHeaderView:(UIView *)view forSection:(NSInteger)section
{
    if([view isKindOfClass:[UITableViewHeaderFooterView class]]) {
        
        UITableViewHeaderFooterView *tableViewHeaderFooterView = (UITableViewHeaderFooterView *) view;
        tableViewHeaderFooterView.textLabel.textAlignment = NSTextAlignmentCenter;
        tableViewHeaderFooterView.textLabel.textColor = [UIColor colorWithRed:0.47 green:0.47 blue:0.49 alpha:1.0];
        tableViewHeaderFooterView.textLabel.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:15];
    }
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    switch (indexPath.section) {
        case 0: {
            
            SettingAppAppCell *cell = (SettingAppAppCell *)[SettingAppTableView dequeueReusableCellWithIdentifier:@"SettingAppAppCell"];
            if (cell == nil) {
                NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"SettingAppAppCell" owner:self options:nil];
                cell = [nib objectAtIndex:0];
            }
            cell.backgroundColor = [UIColor colorWithRed:0.11 green:0.12 blue:0.15 alpha:1.0];
            cell.title.text = [appSetting objectAtIndex:indexPath.row];
            if ([cell.title.text isEqualToString:@"Знакомтсво"]) {
                cell.title.textColor = [UIColor colorWithRed:0.32 green:0.32 blue:0.32 alpha:1.0];
                [cell.sw setOn:false];
                [cell.sw setUserInteractionEnabled:false];
            }
            return cell;
        }
            break;
            
        case 1: {
            
            SettingAppSupCell *cell = (SettingAppSupCell *)[SettingAppTableView dequeueReusableCellWithIdentifier:@"SettingAppSupCell"];
            if (cell == nil) {
                NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"SettingAppSupCell" owner:self options:nil];
                cell = [nib objectAtIndex:0];
            }
            cell.backgroundColor = [UIColor colorWithRed:0.11 green:0.12 blue:0.15 alpha:1.0];
            cell.title.text = [supSetting objectAtIndex:indexPath.row];
            cell.icon.image = [UIImage imageNamed:@"icon_arrow.png"];
            return cell;
        }
            break;
            
        default:
            return nil;
            break;
    }
}

- (void) tableView: (UITableView *) tableView didSelectRowAtIndexPath: (NSIndexPath *) indexPath {
    
    if (indexPath.section == 0) {
        
        NSLog(@"%ld", (long)indexPath.row);
        
    } else {
        
        CATransition *transition = [CATransition animation];
        transition.duration = 0.1;
        transition.type = kCATransitionFade;
        
        self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
        [self.navigationController.view.layer addAnimation:transition forKey:kCATransition];
        
        if (indexPath.row == 3) {
            
            UIViewController *Place = [self.storyboard instantiateViewControllerWithIdentifier:@"Premium"];
            [self.navigationController pushViewController:Place animated:YES];

        } else {
            
            UIViewController *Place = [self.storyboard instantiateViewControllerWithIdentifier:@"SettingAppFullView"];
            [self.navigationController pushViewController:Place animated:YES];
        }
    }
}

@end
