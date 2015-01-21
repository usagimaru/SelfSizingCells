//
//  TableViewCell.m
//  SelfSizingCells
//
//  Created by M.Satori on 15.01.11.
//  Copyright (c) 2015年 M.Satori. All rights reserved.
//

#import "TableViewCell.h"

@interface TableViewCell ()

@property (weak, nonatomic) IBOutlet UIView *squareView;
@property (weak, nonatomic, readwrite) IBOutlet UILabel *label;

@end

@implementation TableViewCell

- (void)awakeFromNib
{
	// Initialization code
	
	self.squareView.layer.cornerRadius = 5;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (UIEdgeInsets)layoutMargins
{
	return UIEdgeInsetsMake(0, 8, 0, 0);
}

@end
