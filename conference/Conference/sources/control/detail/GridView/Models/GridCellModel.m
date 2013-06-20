#import "GridCellModel.h"

@implementation GridCellModel

@synthesize text;
@synthesize textFontSize;
@synthesize minimumFontSize;
@synthesize cellFrame;
@synthesize position;
@synthesize textAlignment;
@synthesize textColor;
@synthesize bgColor;
@synthesize frameColor;
@synthesize padding;
@synthesize isDecForFontSizeAble;
@synthesize isOutWidth;


- (void)dealloc {
    self.text = nil;
    [super dealloc];
}

- (id)init {
    self = [super init];
    if (self) {
        isOutWidth = NO;
    }
    return self;
}

@end
