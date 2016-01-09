//
//  OrderConfirmedViewController.h
//  AmigoDash
//
//  Created by Pavitar Sidhu on 2015-06-23.
//  Copyright (c) 2015 Appcoda. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface OrderConfirmedViewController : UIViewController

- (IBAction)facebookButtonClicked:(id)sender;
- (IBAction)twitterButtonClicked:(id)sender;
- (IBAction)returnHomeClicked:(id)sender;

@property (weak, nonatomic) IBOutlet UIButton *returnHomeButton;
@property (weak, nonatomic) IBOutlet UIButton *facebookButton;

@end