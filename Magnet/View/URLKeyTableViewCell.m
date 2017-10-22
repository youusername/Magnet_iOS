//
//  URLKeyTableViewCell.m
//  Magnet
//
//  Created by zhangjing on 2017/10/22.
//  Copyright © 2017年 214644496@qq.com. All rights reserved.
//

#import "URLKeyTableViewCell.h"
@interface URLKeyTableViewCell ()

@property (weak, nonatomic) IBOutlet UILabel *stringLabel;


@end
@implementation URLKeyTableViewCell


- (void)setModel:(URLKeyModel *)model{
    if (model) {
        _model = model;
        self.stringLabel.text = model.string;
    }
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
