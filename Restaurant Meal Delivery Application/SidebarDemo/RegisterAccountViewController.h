//
//  RegisterAccountViewController.h
//  AmigoDash
//
//  Created by Pavitar Sidhu on 2015-07-24.
//  Copyright (c) 2015 Appcoda. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RegisterAccountViewController : UIViewController


@property (weak, nonatomic) IBOutlet UITextField *userNameField;
@property (weak, nonatomic) IBOutlet UITextField *firstNameField;
@property (weak, nonatomic) IBOutlet UITextField *lastNameField;
@property (weak, nonatomic) IBOutlet UITextField *passwordField;

@property (weak, nonatomic) IBOutlet UIButton *registerButton;


- (IBAction)registerButtonPressed:(id)sender;
-(void)setNavigationBarBackgroundColorus;
@end
