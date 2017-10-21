//
//  KeywordsTableViewCell.m
//  Magnet
//
//  Created by zhangjing on 2017/10/21.
//  Copyright © 2017年 214644496@qq.com. All rights reserved.
//

#import "KeywordsTableViewCell.h"

@interface KeywordsTableViewCell()
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;
@property (weak, nonatomic) IBOutlet UILabel *sizeLabel;

@end

@implementation KeywordsTableViewCell

- (void)setModel:(ResultDataModel *)model{
    if (model) {
        self.nameLabel.text = model.name;
        self.dateLabel.text = model.count;
        self.sizeLabel.text = model.size;
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
