//
//  RestaurantNameViewCell.h
//  AmigoDash
//
//  Created by Pavitar Sidhu on 2015-06-10.
//  Copyright (c) 2015 Appcoda. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RestaurantNameViewCell : UITableViewCell


@property (weak, nonatomic) IBOutlet UIImageView *restaurantLogo;
@property (weak, nonatomic) IBOutlet UILabel *restaurantName;
@property (weak, nonatomic) IBOutlet UILabel *openOrClosed;

@property (weak, nonatomic) NSString *imageAddress;
@property (strong,nonatomic) UITapGestureRecognizer *restaurantClicked;


@end
