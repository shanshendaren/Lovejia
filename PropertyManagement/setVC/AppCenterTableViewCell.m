//
//  AppCenterTableViewCell.m
//  SmartPhonebookDemo
//
//  Created by admin on 14-7-2.
//  Copyright (c) 2014年 admin. All rights reserved.
//

#import "AppCenterTableViewCell.h"


@implementation AppCenterTableViewCell
@synthesize titleLabel;
@synthesize newsIV,sepLineView,sepLineView1;


- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(40, 2, 200, 30)];
        titleLabel.textColor = [UIColor grayColor];
        [self.contentView addSubview:titleLabel];
        
        newsIV = [[UIImageView alloc]initWithFrame:CGRectMake(5, 5, 20, 20)];
        [self.contentView  addSubview:newsIV];
//        sepLineView = [[UIView alloc] initWithFrame:CGRectMake(0, self.bounds.size.height-1, self.bounds.size.width, 1)];
//        sepLineView.backgroundColor = [UIColor grayColor];
        [self.contentView addSubview:sepLineView];
    }
    return self;
}

//- (void)resetLayoutSubviews
//{
//    [sepLineView removeFromSuperview];
//    sepLineView = [[UIView alloc] initWithFrame:CGRectZero];
//    sepLineView.backgroundColor = [UIColor grayColor];
//    [self.contentView addSubview:sepLineView];
//}
//
//- (void)layoutSubviews
//{
//    [self resetLayoutSubviews];
//    self.contentView.frame = self.bounds;
//    sepLineView.frame = CGRectMake(0, self.bounds.size.height, self.bounds.size.width, 0.5);
//}





- (void)awakeFromNib
{
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
