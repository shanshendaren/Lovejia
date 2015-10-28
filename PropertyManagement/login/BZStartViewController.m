//
//  BZStartViewController.m
//  BlueFence
//
//  Created by iosMac on 14-8-28.
//  Copyright (c) 2014年 iosMac. All rights reserved.
//

#import "BZStartViewController.h"
#import "BZAppDelegate.h"
@interface BZStartViewController ()

@end

@implementation BZStartViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self showView];
}

-(void)showView
{
    
//    EAIntroPage *page1 = [EAIntroPage page];
//    page1.bgImage = [UIImage imageNamed:@"manage_1.png"];
//    page1.titleImage = [UIImage imageNamed:@""];
//    
    EAIntroPage *page1 = [EAIntroPage page];
    page1.bgImage = [UIImage imageNamed:@"guide_01.jpg"];
    page1.titleImage = [UIImage imageNamed:@""];
    
    EAIntroPage *page2 = [EAIntroPage page];
    page2.bgImage = [UIImage imageNamed:@"guide_02.jpg"];
    page2.titleImage = [UIImage imageNamed:@""];
    
    EAIntroPage *page3 = [EAIntroPage page];
    page3.bgImage = [UIImage imageNamed:@"guide_03.jpg"];
    page3.titleImage = [UIImage imageNamed:@""];
    
    EAIntroView *intro = [[EAIntroView alloc] initWithFrame:self.view.bounds andPages:@[page1,page2,page3]];
    
    [intro setDelegate:self];
    [intro showInView:self.view animateDuration:0.0 button:self.buttonTitle];

}

- (void)introDidFinish {
    if([self.buttonTitle isEqualToString:@"返回"]){
        [self dismissViewControllerAnimated:YES completion:^{
        }];
        
    }else{
        BZAppDelegate *appDelegate = (BZAppDelegate *)[UIApplication sharedApplication].delegate;
        [appDelegate bootLoginViewController];
        NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
        [userDefault setObject:@"1" forKey:@"isLooked"];
        [userDefault synchronize];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
