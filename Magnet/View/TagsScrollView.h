//
//  TagsScrollView.h
//  gifDemo
//
//  Created by zhangjing on 2017/1/14.
//  Copyright © 2017年 214644496@qq.com. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol TagsScrollViewDelegate;

@interface TagsScrollView : UIScrollView

- (instancetype)initWithFrame:(CGRect)frame;
- (void)loadTagScrollViewButton:(NSArray*)tagArray;


@property (nonatomic,assign)NSInteger selectIndex;
//@property (nonatomic,assign)CGFloat tagWidth;//均分出的每个tag宽度
@property (nonatomic,weak) id<TagsScrollViewDelegate> TagsDelegate;
@property (nonatomic,strong)NSMutableArray* tagArray;

//- (void)setProgress:(CGFloat)progress;

@end



@protocol TagsScrollViewDelegate <NSObject>
@optional
-(void)TagsScrollView:(TagsScrollView*)TagsScrollView didSelectTag:(NSInteger)index TagTitle:(NSString*)title;

@end
