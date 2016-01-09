//
//  CategoriesViewController.h
//  AmigoDash
//
//  Created by Pavitar Sidhu on 2015-06-27.
//  Copyright (c) 2015 Appcoda. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "orderCart.h"

@interface CategoriesViewController : UIViewController<UITableViewDataSource,UITableViewDelegate,NSURLSessionDelegate,NSURLSessionDataDelegate>

@property (strong,nonatomic) orderCart *cart;
@property(strong,nonatomic) NSArray *categories;
@property(strong,nonatomic) NSString *restaurantName;
@property(strong,nonatomic) NSString *selectedCategory;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property bool flag;

@property (weak, nonatomic) IBOutlet UIButton *continueButton;


- (IBAction)continueButtonPressed:(id)sender;
-(void)fetchMenuCategories;
- (NSString *)URLEncodeStringFromString:(NSString *)string;

@end
