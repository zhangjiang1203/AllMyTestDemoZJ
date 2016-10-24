//
//  ZJCustomPaoPaoView.m
//  AllMyTestDemoZJ
//
//  Created by zhangjiang on 15/11/10.
//  Copyright © 2015年 zhangjiang. All rights reserved.
//

#import "ZJCustomPaoPaoView.h"


#define KLabelFont [UIFont systemFontOfSize:12]
#define KLabelColor KRGBA(76, 76, 105, 1)
@interface ZJCustomPaoPaoView ()
@property (nonatomic,strong)UIImageView *backImageView1;//大圈

@property (nonatomic,strong)UIImageView *backImageView2;//箭头

@property (nonatomic,strong)UILabel *addressLabel;

@property (nonatomic,strong)UILabel *timeLabel;

@property (nonatomic,strong)UILabel *userNameLabel;

@property (nonatomic,strong)UIButton *leadBtn;

@end


@implementation ZJCustomPaoPaoView

-(instancetype)initWithFrame:(CGRect)frame onClick:(OnClickHandle)clickBlock{
    self = [super initWithFrame:frame];
    if (self) {
        self.clickhandle = clickBlock;
        self.layer.shadowColor = [UIColor blackColor].CGColor;
        self.layer.shadowOffset = CGSizeMake(1, 1);
        self.layer.shadowOpacity = 0.7;
        [self initMyPaoPaoViewUIWithFrame:frame];
        
    }
    return self;
}

#pragma mark -自定义视图中的控件
-(void)initMyPaoPaoViewUIWithFrame:(CGRect)frame{
    CGFloat ViewW = frame.size.width;
    CGFloat LabelW = ViewW - 70;
    self.backImageView1 = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, ViewW, frame.size.height -8)];
    self.backImageView1.image = [UIImage imageNamed:@"popupBackImage_01"];
    [self addSubview:self.backImageView1];
    
    self.backImageView2 = [[UIImageView alloc]init];
    self.backImageView2.center = CGPointMake(ViewW*0.5, frame.size.height -4);
    self.backImageView2.bounds = CGRectMake(0, 0, 13, 8);
    self.backImageView2.image = [UIImage imageNamed:@"popupBackImage_02"];
    [self addSubview:self.backImageView2];
    
    //姓名
    self.userNameLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, 5, LabelW, 18)];
    self.userNameLabel.textColor = KLabelColor;
    self.userNameLabel.font = KLabelFont;
    self.userNameLabel.backgroundColor = [UIColor clearColor];
    [self addSubview:self.userNameLabel];
    //时间
    self.timeLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, 23, LabelW, 16)];
//    self.timeLabel.adjustsFontSizeToFitWidth = YES;
//    self.timeLabel.minimumScaleFactor = 1.0;
    self.timeLabel.textColor = KLabelColor;
    self.timeLabel.font = KLabelFont;
    self.timeLabel.backgroundColor = [UIColor clearColor];
    [self addSubview:self.timeLabel];
    //地点
    self.addressLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, 40, LabelW, 16)];
    self.addressLabel.textColor = KLabelColor;
    self.addressLabel.font = KLabelFont;
    self.addressLabel.backgroundColor = [UIColor clearColor];
    [self addSubview:self.addressLabel];
    //按钮单击事件
    self.leadBtn = [[UIButton alloc]initWithFrame:CGRectMake(LabelW, 0, 60, frame.size.height -8)];
    [self.leadBtn addTarget:self action:@selector(mapNavigation:) forControlEvents:UIControlEventTouchUpInside];
    [self.leadBtn setBackgroundImage:[UIImage imageNamed:@"leadposition"] forState:UIControlStateNormal];
    [self addSubview:self.leadBtn];
    
}


-(void)setCustomAnno:(MyAnnotation *)customAnno{
    _customAnno = customAnno;
    self.userNameLabel.text = @"zhangjiang";
    self.timeLabel.text = _customAnno.lastTime;
    self.addressLabel.text = _customAnno.title;
}

#pragma mark -导航按钮的触发事件
-(void)mapNavigation:(UIButton*)sender{
    //TODO:开始设置代理或者是block回执
    NSLog(@"函数回调开始");
    self.clickhandle();
}

@end
