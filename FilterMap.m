//
//  FilterMap.m
//  Moto-moto
//
//  Created by Vladimir Malakhov on 06.03.17.
//  Copyright © 2017 Vladimir Malakhov. All rights reserved.
//

#import "FilterMap.h"

@interface FilterMap () {
    
    bool selected;
    FilterCategory *category;
}

@end

@implementation FilterMap

@synthesize FilterMapCollectionView;

static NSString * const reuseIdentifier = @"Cell";

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initData];
    [self ApplyCollectionViewStyle];
    
    if ([[NSUserDefaults standardUserDefaults] boolForKey:@"select.0"])  {
        
        [self.collectionView selectItemAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] animated:YES scrollPosition:UICollectionViewScrollPositionNone];
        [self collectionView:self.collectionView didSelectItemAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
        
    }
    
    if ([[NSUserDefaults standardUserDefaults] boolForKey:@"select.1"]) {
        
        [self.collectionView selectItemAtIndexPath:[NSIndexPath indexPathForRow:1 inSection:0] animated:YES scrollPosition:UICollectionViewScrollPositionNone];
        [self collectionView:self.collectionView didSelectItemAtIndexPath:[NSIndexPath indexPathForRow:1 inSection:0]];
        
    }
    
    if ([[NSUserDefaults standardUserDefaults] boolForKey:@"select.2"]) {
        
        [self.collectionView selectItemAtIndexPath:[NSIndexPath indexPathForRow:2 inSection:0] animated:YES scrollPosition:UICollectionViewScrollPositionNone];
        [self collectionView:self.collectionView didSelectItemAtIndexPath:[NSIndexPath indexPathForRow:2 inSection:0]];
        
    }
    
    if ([[NSUserDefaults standardUserDefaults] boolForKey:@"select.3"]) {
        
        [self.collectionView selectItemAtIndexPath:[NSIndexPath indexPathForRow:6 inSection:0] animated:YES scrollPosition:UICollectionViewScrollPositionNone];
        [self collectionView:self.collectionView didSelectItemAtIndexPath:[NSIndexPath indexPathForRow:6 inSection:0]];
        
    }
    
    if ([[NSUserDefaults standardUserDefaults] boolForKey:@"select.4"]) {
        
        [self.collectionView selectItemAtIndexPath:[NSIndexPath indexPathForRow:7 inSection:0] animated:YES scrollPosition:UICollectionViewScrollPositionNone];
        [self collectionView:self.collectionView didSelectItemAtIndexPath:[NSIndexPath indexPathForRow:7 inSection:0]];
        
    }
    
    if ([[NSUserDefaults standardUserDefaults] boolForKey:@"select.5"]) {
        
        [self.collectionView selectItemAtIndexPath:[NSIndexPath indexPathForRow:8 inSection:0] animated:YES scrollPosition:UICollectionViewScrollPositionNone];
        [self collectionView:self.collectionView didSelectItemAtIndexPath:[NSIndexPath indexPathForRow:8 inSection:0]];
        
    }
    
    if ([[NSUserDefaults standardUserDefaults] boolForKey:@"select.6"]) {
        
        [self.collectionView selectItemAtIndexPath:[NSIndexPath indexPathForRow:12 inSection:0] animated:YES scrollPosition:UICollectionViewScrollPositionNone];
        [self collectionView:self.collectionView didSelectItemAtIndexPath:[NSIndexPath indexPathForRow:12 inSection:0]];
        
    }
    
    if ([[NSUserDefaults standardUserDefaults] boolForKey:@"select.7"]) {
    
        [self.collectionView selectItemAtIndexPath:[NSIndexPath indexPathForRow:13 inSection:0] animated:YES scrollPosition:UICollectionViewScrollPositionNone];
        [self collectionView:self.collectionView didSelectItemAtIndexPath:[NSIndexPath indexPathForRow:13 inSection:0]];
        
    }
    
    if ([[NSUserDefaults standardUserDefaults] boolForKey:@"select.8"]) {
        
        [self.collectionView selectItemAtIndexPath:[NSIndexPath indexPathForRow:14 inSection:0] animated:YES scrollPosition:UICollectionViewScrollPositionNone];
        [self collectionView:self.collectionView didSelectItemAtIndexPath:[NSIndexPath indexPathForRow:14 inSection:0]];
        
    }
    
    if ([[NSUserDefaults standardUserDefaults] boolForKey:@"select.9"]) {
        
        [self.collectionView selectItemAtIndexPath:[NSIndexPath indexPathForRow:18 inSection:0] animated:YES scrollPosition:UICollectionViewScrollPositionNone];
        [self collectionView:self.collectionView didSelectItemAtIndexPath:[NSIndexPath indexPathForRow:18 inSection:0]];
        
    }
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    self.navigationItem.title = @"Настройка карты";
    self.navigationController.navigationBar.topItem.title = @"";
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    selected = true;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void) ApplyCollectionViewStyle {
    
    [self.collectionView setAllowsMultipleSelection:YES];
    [self.collectionView registerNib:[UINib nibWithNibName:@"FilterTitleCell" bundle:nil] forCellWithReuseIdentifier:@"cell"];
    
    FilterMapCollectionView.backgroundColor = [UIColor colorWithRed:0.11 green:0.12 blue:0.15 alpha:1.0];
}

- (void) initData {
    
    category = [[FilterCategory alloc] initFilterCategoryWithTitle:@[@"", @"", @"", @"Паркинг", @"Заправка", @"Сервис", @"", @"", @"", @"Магазин", @"Ресторан", @"Кафе", @"", @"", @"", @"Бар", @"Мото школа", @"Люди", @"", @"", @"", @"События"]
                                                             image:@[@"map_parking.pdf", @"map_gaz.pdf", @"map_service.pdf", @"", @"", @"", @"map_shop.pdf", @"map_rest.pdf", @"map_cafe.pdf", @"", @"", @"", @"map_bar.pdf", @"map_school.pdf", @"map_people.pdf", @"", @"", @"", @"map_event.pdf"]
                ];
    
    [FilterMapCollectionView reloadData];
}

#pragma mark <UICollectionViewDataSource>

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return 20;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    if ((indexPath.row == 0) || (indexPath.row == 1) || (indexPath.row == 2) || (indexPath.row == 6) || (indexPath.row == 7) || (indexPath.row == 8) || (indexPath.row == 12) || (indexPath.row == 13) || (indexPath.row == 14) || (indexPath.row == 18)) {
        
        FilterMapCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifier forIndexPath:indexPath];
        
        if ([[NSUserDefaults standardUserDefaults] boolForKey:@"select.0"])  {
            if (indexPath.row == 0) {
                cell.backgroundColor = [UIColor colorWithRed:0.17 green:0.19 blue:0.24 alpha:1.0];
            }
        } else {
            if (indexPath.row == 0) {
                cell.backgroundColor = [UIColor colorWithRed:0.12 green:0.58 blue:0.93 alpha:1.0];
            }
        }
        
        if ([[NSUserDefaults standardUserDefaults] boolForKey:@"select.1"])  {
            if (indexPath.row == 1) {
                cell.backgroundColor = [UIColor colorWithRed:0.17 green:0.19 blue:0.24 alpha:1.0];
            }
        } else {
            if (indexPath.row == 1) {
                cell.backgroundColor = [UIColor colorWithRed:0.12 green:0.58 blue:0.93 alpha:1.0];
            }
        }
        
        if ([[NSUserDefaults standardUserDefaults] boolForKey:@"select.2"])  {
            if (indexPath.row == 2) {
                cell.backgroundColor = [UIColor colorWithRed:0.17 green:0.19 blue:0.24 alpha:1.0];
            }
        } else {
            if (indexPath.row == 2) {
                cell.backgroundColor = [UIColor colorWithRed:0.12 green:0.58 blue:0.93 alpha:1.0];
            }
        }
        
        if ([[NSUserDefaults standardUserDefaults] boolForKey:@"select.3"])  {
            if (indexPath.row == 6) {
                cell.backgroundColor = [UIColor colorWithRed:0.17 green:0.19 blue:0.24 alpha:1.0];
            }
        } else {
            if (indexPath.row == 6) {
                cell.backgroundColor = [UIColor colorWithRed:0.12 green:0.58 blue:0.93 alpha:1.0];
            }
        }
        
        if ([[NSUserDefaults standardUserDefaults] boolForKey:@"select.4"])  {
            if (indexPath.row == 7) {
                cell.backgroundColor = [UIColor colorWithRed:0.17 green:0.19 blue:0.24 alpha:1.0];
            }
        } else {
            if (indexPath.row == 7) {
                cell.backgroundColor = [UIColor colorWithRed:0.12 green:0.58 blue:0.93 alpha:1.0];
            }
        }
        
        if ([[NSUserDefaults standardUserDefaults] boolForKey:@"select.5"])  {
            if (indexPath.row == 8) {
                cell.backgroundColor = [UIColor colorWithRed:0.17 green:0.19 blue:0.24 alpha:1.0];
            }
        } else {
            if (indexPath.row == 8) {
                cell.backgroundColor = [UIColor colorWithRed:0.12 green:0.58 blue:0.93 alpha:1.0];
            }
        }
        
        if ([[NSUserDefaults standardUserDefaults] boolForKey:@"select.6"])  {
            if (indexPath.row == 12) {
                cell.backgroundColor = [UIColor colorWithRed:0.17 green:0.19 blue:0.24 alpha:1.0];
            }
        } else {
            if (indexPath.row == 12) {
                cell.backgroundColor = [UIColor colorWithRed:0.12 green:0.58 blue:0.93 alpha:1.0];
            }
        }
        
        if ([[NSUserDefaults standardUserDefaults] boolForKey:@"select.7"])  {
            if (indexPath.row == 13) {
                cell.backgroundColor = [UIColor colorWithRed:0.17 green:0.19 blue:0.24 alpha:1.0];
            }
        } else {
            if (indexPath.row == 13) {
                cell.backgroundColor = [UIColor colorWithRed:0.12 green:0.58 blue:0.93 alpha:1.0];
            }
        }
        
        if ([[NSUserDefaults standardUserDefaults] boolForKey:@"select.8"])  {
            if (indexPath.row == 14) {
                cell.backgroundColor = [UIColor colorWithRed:0.17 green:0.19 blue:0.24 alpha:1.0];
            }
        } else {
            if (indexPath.row == 14) {
                cell.backgroundColor = [UIColor colorWithRed:0.12 green:0.58 blue:0.93 alpha:1.0];
            }
        }
        
        if ([[NSUserDefaults standardUserDefaults] boolForKey:@"select.9"])  {
            if (indexPath.row == 18) {
                cell.backgroundColor = [UIColor colorWithRed:0.17 green:0.19 blue:0.24 alpha:1.0];
            }
        } else {
            if (indexPath.row == 18) {
                cell.backgroundColor = [UIColor colorWithRed:0.12 green:0.58 blue:0.93 alpha:1.0];
            }
        }
  
        cell.layer.cornerRadius = CGRectGetWidth([cell bounds]) / 2;
        cell.clipsToBounds = YES;
        
        cell.image.image = [UIImage imageNamed:[category.image objectAtIndex:indexPath.row]];
        
        return cell;
        
    } else {
        
        FilterTitleCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPath];
        cell.title.text = [category.title objectAtIndex:indexPath.row];
        NSLog(@"%@", cell.title.text);
        return cell;
    }
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    CGRect screenRect = [[UIScreen mainScreen] bounds];
    CGFloat screenWidth = screenRect.size.width;
    float cellWidth = screenWidth / 3.5;
    
    CGSize size;
    if ((indexPath.row == 3) || (indexPath.row == 4) || (indexPath.row == 5) || (indexPath.row == 9) || (indexPath.row == 10) || (indexPath.row == 11) || (indexPath.row == 15) || (indexPath.row == 16) || (indexPath.row == 17) || (indexPath.row == 21)) {
        size = CGSizeMake(cellWidth, cellWidth / 2.5);
    } else {
        size = CGSizeMake(cellWidth, cellWidth);
    }
    
    return size;
}

#pragma mark <UICollectionViewDelegate>

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
    if ((indexPath.row == 0) || (indexPath.row == 1) || (indexPath.row == 2) || (indexPath.row == 6) || (indexPath.row == 7) || (indexPath.row == 8) || (indexPath.row == 12) || (indexPath.row == 13) || (indexPath.row == 14) || (indexPath.row == 18)) {
        
        switch (indexPath.row) {
                
            case 0:
                
                [[NSUserDefaults standardUserDefaults] setBool:true forKey:@"select.0"];
                [[NSNotificationCenter defaultCenter] postNotificationName:@"categoryParkingOff" object:nil];
                break;
                
            case 1:
                [[NSUserDefaults standardUserDefaults] setBool:true forKey:@"select.1"];
                [[NSNotificationCenter defaultCenter] postNotificationName:@"categoryGazOff" object:nil];
                break;
                
            case 2:
                [[NSUserDefaults standardUserDefaults] setBool:true forKey:@"select.2"];
                [[NSNotificationCenter defaultCenter] postNotificationName:@"categoryServiceOff" object:nil];
                break;
                
            case 6:
                [[NSUserDefaults standardUserDefaults] setBool:true forKey:@"select.3"];
                [[NSNotificationCenter defaultCenter] postNotificationName:@"categoryShopOff" object:nil];
                break;
                
            case 7:
                [[NSUserDefaults standardUserDefaults] setBool:true forKey:@"select.4"];
                [[NSNotificationCenter defaultCenter] postNotificationName:@"categoryRestorauntOff" object:nil];
                break;
                
            case 8:
                [[NSUserDefaults standardUserDefaults] setBool:true forKey:@"select.5"];
                [[NSNotificationCenter defaultCenter] postNotificationName:@"categoryCafeOff" object:nil];
                break;
                
            case 12:
                [[NSUserDefaults standardUserDefaults] setBool:true forKey:@"select.6"];
                [[NSNotificationCenter defaultCenter] postNotificationName:@"categoryBarOff" object:nil];
                break;
                
            case 13:
                [[NSUserDefaults standardUserDefaults] setBool:true forKey:@"select.7"];
                [[NSNotificationCenter defaultCenter] postNotificationName:@"categorySchoolOff" object:nil];
                break;
                
            case 14:
                [[NSUserDefaults standardUserDefaults] setBool:true forKey:@"select.8"];
                [[NSNotificationCenter defaultCenter] postNotificationName:@"categoryPeopleOff" object:nil];
                break;
                
            case 18:
                [[NSUserDefaults standardUserDefaults] setBool:true forKey:@"select.9"];
                [[NSNotificationCenter defaultCenter] postNotificationName:@"categoryEventOff" object:nil];
                break;
                
            default:
                break;
        }
        
        UICollectionViewCell *datasetCell = [collectionView cellForItemAtIndexPath:indexPath];
        datasetCell.backgroundColor = [UIColor colorWithRed:0.17 green:0.19 blue:0.24 alpha:1.0];
    }
}

- (void)collectionView:(UICollectionView *)collectionView didDeselectItemAtIndexPath:(NSIndexPath *)indexPath {
    
    if ((indexPath.row == 0) || (indexPath.row == 1) || (indexPath.row == 2) || (indexPath.row == 6) || (indexPath.row == 7) || (indexPath.row == 8) || (indexPath.row == 12) || (indexPath.row == 13) || (indexPath.row == 14) || (indexPath.row == 18)) {
        
        switch (indexPath.row) {
                
            case 0:
                
                [[NSUserDefaults standardUserDefaults] setBool:false forKey:@"select.0"];
                [[NSNotificationCenter defaultCenter] postNotificationName:@"categoryParkingOn" object:nil];
                break;
                
            case 1:
                [[NSUserDefaults standardUserDefaults] setBool:false forKey:@"select.1"];
                [[NSNotificationCenter defaultCenter] postNotificationName:@"categoryGazOn" object:nil];
                break;
                
            case 2:
                [[NSUserDefaults standardUserDefaults] setBool:false forKey:@"select.2"];
                [[NSNotificationCenter defaultCenter] postNotificationName:@"categoryServiceOn" object:nil];
                break;
                
            case 6:
                [[NSUserDefaults standardUserDefaults] setBool:false forKey:@"select.3"];
                [[NSNotificationCenter defaultCenter] postNotificationName:@"categoryShopOn" object:nil];
                break;
                
            case 7:
                [[NSUserDefaults standardUserDefaults] setBool:false forKey:@"select.4"];
                [[NSNotificationCenter defaultCenter] postNotificationName:@"categoryRestorauntOn" object:nil];
                break;
                
            case 8:
                [[NSUserDefaults standardUserDefaults] setBool:false forKey:@"select.5"];
                [[NSNotificationCenter defaultCenter] postNotificationName:@"categoryCafeOn" object:nil];
                break;
                
            case 12:
                [[NSUserDefaults standardUserDefaults] setBool:false forKey:@"select.6"];
                [[NSNotificationCenter defaultCenter] postNotificationName:@"categoryBarOn" object:nil];
                break;
                
            case 13:
                [[NSUserDefaults standardUserDefaults] setBool:false forKey:@"select.7"];
                [[NSNotificationCenter defaultCenter] postNotificationName:@"categorySchoolOn" object:nil];
                break;
                
            case 14:
                [[NSUserDefaults standardUserDefaults] setBool:false forKey:@"select.8"];
                [[NSNotificationCenter defaultCenter] postNotificationName:@"categoryPeopleOn" object:nil];
                break;
                
            case 18:
                [[NSUserDefaults standardUserDefaults] setBool:false forKey:@"select.9"];
                [[NSNotificationCenter defaultCenter] postNotificationName:@"categoryEventOn" object:nil];
                break;
                
            default:
                break;
        }
        
        UICollectionViewCell *datasetCell = [collectionView cellForItemAtIndexPath:indexPath];
        datasetCell.backgroundColor = [UIColor colorWithRed:0.12 green:0.58 blue:0.93 alpha:1.0];
    }
}

- (BOOL)collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}

@end
