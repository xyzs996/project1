#import "GridColumnModel.h"

@implementation GridColumnModel

@synthesize columnWidth;
@synthesize titleFontSize;
@synthesize contentFontSize;
@synthesize footerFontSize;
@synthesize minimumFontSize;
@synthesize columnAlignment;
@synthesize titleColor;
@synthesize titleBgColor;
@synthesize titleFrameColor;
@synthesize contentColor;
@synthesize contentBgColor;
@synthesize contentFrameColor;
@synthesize footerColor;
@synthesize footerBgColor;
@synthesize footerFrameColor;
@synthesize padding;
@synthesize isDecForFontSizeAble;

- (void)dealloc {
    [super dealloc];
}

- (id)init {
    self = [super init];
    if (self) {
        columnWidth = 80.0;
        titleFontSize = 15.0;
        contentFontSize = 15.0;
        footerFontSize = 15.0;
        minimumFontSize = 12.0;
        columnAlignment = UITextAlignmentCenter;
        titleColor = GridColorMake(255.0, .0, .0, 1.0);
        titleBgColor = GridColorMake(255.0, 255.0, 255.0, 1.0);
        titleFrameColor = GridColorMake(255.0, 255.0, 255.0, 1.0);
        contentColor = GridColorMake(142.0, 142.0, 142.0, 1.0);
        contentBgColor = GridColorMake(238.0, 238.0, 238.0, 1.0);
        contentFrameColor = GridColorMake(180.0, 180.0, 180.0, 1.0);
        footerColor = GridColorMake(.0, .0, .0, 1.0);
        footerBgColor = GridColorMake(50.0, 50.0, 50.0, 1.0);
        footerFrameColor = GridColorMake(255.0, 255.0, 255.0, 1.0);
        padding = GridPaddingMake(8.0, 8.0, 8.0, 8.0);
        isDecForFontSizeAble = YES;
    }
    return self;
}

@end
