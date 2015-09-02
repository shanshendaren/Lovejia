//
//  ysButton.m
//  PropertyManagement
//
//  Created by 杨 帅 on 15/4/28.
//  Copyright (c) 2015年 杨 帅. All rights reserved.
//
#define ios7 ([[UIDevice currentDevice].systemVersion doubleValue] >= 7.0)
#import "ysButton.h"

@interface ysButton()
@property (nonatomic,strong) UIFont *titleFont;

@end

@implementation ysButton

//从文件中解析一个对象的时候就会调用
-(id)initWithCoder:(NSCoder *)aDecoder{
    if (self = [super initWithCoder:aDecoder]) {
        [self setUp];
    }
    return self;
}

//通过代码创建控件的时候会调用
-(instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        [self setUp];
    }
    return self;
}

//初始化
-(void)setUp{
    
    self.titleFont =[UIFont systemFontOfSize:14];
    self.titleLabel.font = self.titleFont;
    
    //图标居中
    self.imageView.contentMode = UIViewContentModeCenter;
    
}

-(CGRect)titleRectForContentRect:(CGRect)contentRect{
    CGFloat titleX = 0;
    CGFloat titleY = 0;
    NSDictionary * attrs = @{NSFontAttributeName :self.titleFont};
    CGFloat titleW;
    
    if (ios7) {
        //只有Xcode5才会编译这段代码
#ifdef __IPHONE_7_0
        titleW =[self.currentTitle boundingRectWithSize:CGSizeMake(MAXFLOAT, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:attrs context:nil].size.width;
#else
        titleW = [self.currentTitle sizeWithFont:self.titleFont].width;
#endif
    }else{
        titleW = [self.currentTitle sizeWithFont:self.titleFont].width;
    }
    CGFloat titleH = contentRect.size.height;
    return CGRectMake(titleX, titleY, titleW, titleH);
}

//控制器内部的imageView的frame
-(CGRect)imageRectForContentRect:(CGRect)contentRect{
    CGFloat imageW = 30;
    CGFloat imageX = contentRect.size.width -imageW;
    CGFloat imageY = 0;
    CGFloat imageH =contentRect.size.height;
    return CGRectMake(imageX, imageY, imageW, imageH);
    
}
@end
