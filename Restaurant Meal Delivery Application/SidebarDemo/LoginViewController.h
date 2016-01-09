//
//  LoginViewController.h
//  AmigoDash
//
//  Created by Pavitar Sidhu on 2015-07-24.
//  Copyright (c) 2015 Appcoda. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LoginViewController : UIViewController

@property (weak, nonatomic) IBOutlet UITextField *usernameTextField;
@property (weak, nonatomic) IBOutlet UITextField *passwordTextField;
@property (weak, nonatomic) IBOutlet UIButton *loginField;
@property (weak, nonatomic) IBOutlet UIButton *registerField;

- (IBAction)loginPressed:(id)sender;
- (IBAction)registerPressed:(id)sender;

-(void)setNavigationBarBackgroundColorus;
@end
