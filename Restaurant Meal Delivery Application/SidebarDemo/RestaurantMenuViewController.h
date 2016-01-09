//
//  RestaurantMenuViewController.h
//  AmigoDash
//
//  Created by Pavitar Sidhu on 2015-06-13.
//  Copyright (c) 2015 Appcoda. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "orderCart.h"
#import "MenuViewCell.h"

@interface RestaurantMenuViewController : UIViewController<UITableViewDataSource,UITableViewDelegate,NSURLSessionDataDelegate,NSURLSessionDelegate,MenuViewCellProtocol>

@property (weak, nonatomic) IBOutlet UITableView *menuTable;
@property (strong,nonatomic) NSString *restaurantName;
@property (strong,nonatomic) NSString *category;
@property (strong,nonatomic) orderCart *cart;
@property bool flag;

@property (weak, nonatomic) IBOutlet UIButton *continueButton;


/*The idea behind this is to store all the dictionary's keys 
and then use it to get prices from dictionary */
@property (strong,nonatomic) NSArray *foodItemNames;

- (IBAction)checkoutPressed:(id)sender;
-(void)fetchRestaurantMenu;
- (NSString *)URLEncodeStringFromString:(NSString *)string;

@end
