//
//  OrderConfirmedViewController.m
//  AmigoDash
//
//  Created by Pavitar Sidhu on 2015-06-23.
//  Copyright (c) 2015 Appcoda. All rights reserved.
//

#import "OrderConfirmedViewController.h"

@interface OrderConfirmedViewController ()

@end

@implementation OrderConfirmedViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    //Give return home button border
    _returnHomeButton.layer.borderWidth = .5f;
    _returnHomeButton.layer.borderColor = [[UIColor colorWithRed:0.0 green:122.0/255.0 blue:1.0 alpha:1.0]CGColor];
    
    //Give facebook button border
    _facebookButton.layer.borderWidth = .5f;
    _facebookButton.layer.borderColor = [[UIColor colorWithRed:0.0 green:122.0/255.0 blue:1.0 alpha:1.0]CGColor];
    
    UIColor *backgroundColor = [UIColor colorWithRed:80/255.0f green:216/255.0f blue:187/255.0f alpha:1.0f];
    self.view.backgroundColor = backgroundColor;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)facebookButtonClicked:(id)sender {
    NSString* launchUrl = @"http://facebook.com/spottedvictoria";
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString: launchUrl]];
}

- (IBAction)twitterButtonClicked:(id)sender {
}
- (IBAction)returnHomeClicked:(id)sender {
    [self performSegueWithIdentifier:@"returnHome" sender:self];
}
@end
