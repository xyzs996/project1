//
//  MyMasterSubTitleCell.m
//  Conference
//
//  Created by wu xiaofang on 13-6-15.
//  Copyright (c) 2013年 wu xiaofang. All rights reserved.
//

#import "MyMasterSubTitleCell.h"
@interface MyMasterSubTitleCell()
@property (nonatomic,retain)UILabel* titleLabel;
@property (nonatomic,retain)UIView* bgView;
@end
@implementation MyMasterSubTitleCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        self.bgView = [[[UIView alloc] init] autorelease];
        self.bgView.backgroundColor = [UIColor grayColor];
       
        [self addSubview:self.bgView];
        
        
        self.titleLabel = [[[UILabel alloc] initWithFrame:CGRectMake(10, 0, self.bounds.size.width - 50, self.bounds.size.height)] autorelease];
        self.titleLabel.textAlignment = NSTextAlignmentLeft;
        self.titleLabel.textColor = [UIColor whiteColor];
        self.titleLabel.backgroundColor = [UIColor clearColor];
        self.titleLabel.font = [UIFont boldSystemFontOfSize:20.0f];
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
    self.bgView.frame = self.bounds;
    self.titleLabel.frame = CGRectMake(50, 0, self.bounds.size.width - 50, self.bounds.size.height);
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
