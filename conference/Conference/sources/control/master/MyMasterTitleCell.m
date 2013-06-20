//
//  MyMasterTitleCell.m
//  Conference
//
//  Created by wu xiaofang on 13-6-15.
//  Copyright (c) 2013年 wu xiaofang. All rights reserved.
//

#import "MyMasterTitleCell.h"
@interface MyMasterTitleCell()
@property (nonatomic,retain)UILabel* titleLabel;
@end
@implementation MyMasterTitleCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        
        UIView* bgView = [[UIView alloc] initWithFrame:self.bounds];
        bgView.backgroundColor = [UIColor colorWithRed:100/255.0 green:100/255.0 blue:100/255.0 alpha:1.0f];
        bgView.autoresizingMask = UIViewAutoresizingFlexibleHeight|UIViewAutoresizingFlexibleWidth;
        [self addSubview:bgView];
        [bgView release];
        
        self.titleLabel = [[[UILabel alloc] initWithFrame:CGRectMake(10, 0, self.bounds.size.width - 10, self.bounds.size.height)] autorelease];
        self.titleLabel.textAlignment = NSTextAlignmentLeft;
        self.titleLabel.textColor = [UIColor whiteColor];
        self.titleLabel.font = [UIFont boldSystemFontOfSize:26.0f];
        self.titleLabel.backgroundColor = [UIColor clearColor];
        [self addSubview:self.titleLabel];
    }
    return self;
}

- (void)dealloc
{
    self.titleLabel = nil;
    [super dealloc];
}
- (void)layoutSubviews
{
    [super layoutSubviews];
  
    self.titleLabel.frame = CGRectMake(10, 0, self.bounds.size.width - 10, self.bounds.size.height);
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)loadCellData:(NSString*)title
{
    self.titleLabel.text = title;
}

@end
