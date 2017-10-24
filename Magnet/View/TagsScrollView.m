//
//  TagsScrollView.m
//  gifDemo
//
//  Created by zhangjing on 2017/1/14.
//  Copyright © 2017年 214644496@qq.com. All rights reserved.
//

#import "TagsScrollView.h"
#import "YYKit.h"
#define kTagSelectColor     [UIColor colorWithWhite:85.0f / 255.0f alpha:1.0f]
#define kTagUnselectColor   [UIColor colorWithWhite:189.0f / 255.0f alpha:1.0f]
#define kBtnMarginTop  15*kScreenHeight/1334
#define kBtnMarginBottom  15*kScreenHeight/1334

#define kTagButtonTagStart   784
@interface TagsScrollView (){
    NSMutableArray*buttons;
}
@property (nonatomic,strong) UIButton *selectTagButton;
@property (strong,nonatomic) UIProgressView *progressView;
@end

@implementation TagsScrollView

-(instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        self.showsHorizontalScrollIndicator = NO;
        self.showsVerticalScrollIndicator = NO;
        self.selectIndex = 0;
        buttons = [NSMutableArray array];
        self.layer.masksToBounds = NO;
        [self.layer setShadowColor:[UIColor blackColor].CGColor];
        [self.layer setShadowOffset:CGSizeMake(0,0)];
        [self.layer setShadowOpacity:0.1f];
        self.progressView = [[UIProgressView alloc]initWithFrame:CGRectZero];
        self.progressView.progress = 1.0f;
        self.progressView.progressTintColor = [UIColor grayColor];
        self.progressView.trackTintColor = [UIColor redColor];
        
    }
    return self;
}
- (void)setProgress:(CGFloat)progress{
    dispatch_async(dispatch_get_main_queue(), ^{
        
        self.progressView.progress = progress;
    });
        
    
}
- (void)loadTagScrollViewButton:(NSMutableArray*)tagArray{
    self.tagArray = tagArray;
    if (self.selectIndex>=[tagArray count])
        self.selectIndex =0;
    float x = kScreenWidth * 0.044;//tag左侧留白
    float y = (self.frame.size.height - 30)/2;
    for (int i = 0 ; i<tagArray.count; i++) {

        UIFont *font = [UIFont systemFontOfSize:14];
        CGSize newSize = [tagArray[i] boundingRectWithSize:CGSizeMake(kScreenWidth, 100) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:font} context:nil].size;
        
        UIButton*button = [UIButton buttonWithType:UIButtonTypeCustom];
        [button setFrame:CGRectMake(x, y,newSize.width+5, 30)];
        [button setTitle:tagArray[i] forState:UIControlStateNormal];
        [button setTitleColor:kTagUnselectColor forState:UIControlStateNormal];
        if (i == 0) {
            [button setTitleColor:kTagSelectColor forState:UIControlStateNormal];
            self.progressView.frame = CGRectMake(x, self.frame.size.height-2, newSize.width, 2);
        }
        button.titleLabel.textAlignment=NSTextAlignmentCenter;
		[button.titleLabel setFont:font];
        [button setTag:i + kTagButtonTagStart];
        [button addTarget:self action:@selector(selectButton:) forControlEvents:UIControlEventTouchUpInside];
//        button.layer.masksToBounds  = YES;
//        button.layer.cornerRadius   = 15;
//        button.layer.borderColor = [UIColor clearColor].CGColor;
//        button.layer.borderWidth = 1.0;
        [self addSubview:button];
        [buttons addObject:button];
        if(i==tagArray.count-1){
            x = x+button.size.width+kScreenWidth * 0.044;//tag右侧留白
        }else{
            x = x+button.size.width+16.5;
        }
    }
    if (x<self.size.width) {
        x=self.size.width;
    }
    [self addSubview:self.progressView];
    self.contentSize = CGSizeMake(x, self.frame.size.height);
}

- (void)selectButton:(UIButton*)button {
    if (button==nil) {
        return;
    }
    
    [UIView animateWithDuration:0.2 animations:^{
        CGRect frame = button.frame;
        frame.origin.y = self.frame.size.height-2;
        frame.size.height = 2;
        self.progressView.frame = frame;
    }];
    
    [buttons enumerateObjectsUsingBlock:^(UIButton*  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if (obj == button) {
//            obj.layer.borderColor = [UIColor orangeColor].CGColor;
//            [obj setBackgroundColor:[UIColor purpleColor]];
            [obj setTitleColor:kTagSelectColor forState:UIControlStateNormal];
        }else{
//            obj.layer.borderColor = [UIColor clearColor].CGColor;
//            [obj setBackgroundColor:[UIColor whiteColor]];
            [obj setTitleColor:kTagUnselectColor forState:UIControlStateNormal];
        }
    }];

    self.selectTagButton = button;

    
    _selectIndex = button.tag - kTagButtonTagStart;
    
    if ([self.TagsDelegate respondsToSelector:@selector(TagsScrollView:didSelectTag:TagTitle:)]) {
        [self.TagsDelegate TagsScrollView:self didSelectTag:_selectIndex TagTitle:self.selectTagButton.titleLabel.text];
    }
}

-(void)setSelectIndex:(NSInteger)selectIndex{
    NSInteger index;
    if (selectIndex>100) {
        index = 0;
    }else{
        index = selectIndex;
    }
    
    _selectIndex = index;
    UIButton* button = [self viewWithTag:index+kTagButtonTagStart];
    [self selectButton:button];
}

@end
