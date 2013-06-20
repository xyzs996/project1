/**
 * 我是一个Model，用来接收各个cell的设置参数
 **/
#import <Foundation/Foundation.h>
#import "GridViewHelper.h"

@interface GridCellModel : NSObject

@property (nonatomic, copy) NSString *text;
@property (nonatomic, assign) CGFloat textFontSize;
@property (nonatomic, assign) CGFloat minimumFontSize;
@property (nonatomic, assign) CGRect cellFrame;
@property (nonatomic, assign) GridPosition position;
@property (nonatomic, assign) UITextAlignment textAlignment;
@property (nonatomic, assign) GridColor textColor;
@property (nonatomic, assign) GridColor bgColor;
@property (nonatomic, assign) GridColor frameColor;
@property (nonatomic, assign) GridPadding padding;
@property (nonatomic, assign, getter = isDecForFontSizeAble) BOOL isDecForFontSizeAble;
@property (nonatomic, assign, getter = isOutWidth) BOOL isOutWidth;

@end
