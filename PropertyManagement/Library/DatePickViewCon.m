//
//  DatePickViewCon.m
//  CNHbccGGS
//
//  Created by Liu Lexi on 14-3-30.
//  Copyright (c) 2014年 Lexi & Bella. All rights reserved.
//

#import "DatePickViewCon.h"
#import "DateUtil.h"

static DatePickViewCon *_ShareDatePickViewCon = nil;

@interface DatePickViewCon ()
{
    UIDatePicker *datePicker;
}

@end

@implementation DatePickViewCon

@synthesize curDate, type, delegate;

+ (id)ShareDatePickViewCon
{
    if (_ShareDatePickViewCon == nil) {
        _ShareDatePickViewCon = [[DatePickViewCon alloc] initWithNibName:nil bundle:nil];
    }
    return _ShareDatePickViewCon;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.type = DatePickTypeNone;
        self.curDate = [NSDate date];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor clearColor];
    
    datePicker = [[UIDatePicker alloc] init];
    CGRect frame = datePicker.frame;
    datePicker.frame = CGRectMake((self.view.bounds.size.width - frame.size.width) / 2, self.view.bounds.size.height - frame.size.height, frame.size.width, frame.size.height);
//    datePicker.datePickerMode = UIDatePickerModeDate;
    datePicker.datePickerMode = UIDatePickerModeDateAndTime;

    datePicker.locale = [[[NSLocale alloc] initWithLocaleIdentifier:@"zh-Hans"] autorelease];
    datePicker.minimumDate = [DateUtil datePickFormatString:@"1901-01-01"];
    datePicker.maximumDate = [DateUtil datePickFormatString:@"2048-12-31"];
    [datePicker setDate:self.curDate];
    [self.view addSubview:datePicker];
    
    UIView *viewBG = [[UIView alloc] initWithFrame:datePicker.frame];
    viewBG.backgroundColor = [UIColor whiteColor];
    [self.view insertSubview:viewBG belowSubview:datePicker];
    [viewBG release]; viewBG = nil;
    
    UIToolbar *menuBar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, self.view.bounds.size.height - datePicker.frame.size.height, 320, 44)];
    UIBarButtonItem *cancelBut = [[UIBarButtonItem alloc] initWithTitle:[NSString stringWithFormat:@"取消"] style:UIBarButtonItemStyleBordered target:self action:@selector(cancelAction:)];
    UIBarButtonItem *spaceBut = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    UIBarButtonItem *sureBut = [[UIBarButtonItem alloc] initWithTitle:[NSString stringWithFormat:@"确定"] style:UIBarButtonItemStyleBordered target:self action:@selector(sureAction:)];
    menuBar.items = [NSArray arrayWithObjects:cancelBut, spaceBut, sureBut, nil];
    [self.view addSubview:menuBar];
    [cancelBut release]; cancelBut = nil;
    [spaceBut release]; spaceBut = nil;
    [sureBut release]; sureBut = nil;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)setShowDate:(NSDate *)showDate
{
    self.curDate = showDate;
    if (datePicker != nil) {
        [datePicker setDate:self.curDate];
    }
}

- (IBAction)cancelAction:(id)sender
{
    [self dismiss];
}

- (IBAction)sureAction:(id)sender
{
    self.curDate = datePicker.date;
    [self dismiss];
    if (self.delegate && [self.delegate respondsToSelector:@selector(datePickDidSelected:)]) {
        [self.delegate datePickDidSelected:self];
    }
}

- (void)show
{
    self.view.frame = CGRectMake(0, self.view.frame.size.height, self.view.frame.size.width, self.view.frame.size.height);
    [[[UIApplication sharedApplication] keyWindow] addSubview:self.view];
    [UIView animateWithDuration:0.3 animations:^(void) {
        self.view.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
    } completion:^(BOOL finished) {
        
    }];
}

- (void)dismiss
{
    [UIView animateWithDuration:0.3 animations:^(void) {
        self.view.frame = CGRectMake(0, self.view.frame.size.height, self.view.frame.size.width, self.view.frame.size.height);
    } completion:^(BOOL finished) {
        [self.view removeFromSuperview];
    }];
}

- (void)dealloc
{
    [curDate release]; curDate = nil;
    [datePicker release]; datePicker = nil;
    [super dealloc];
}

@end
