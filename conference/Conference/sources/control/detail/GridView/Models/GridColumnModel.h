/**
 * 我是一个Model，用来接收列的设置参数
 **/
#import <Foundation/Foundation.h>
#import "GridViewHelper.h"

@interface GridColumnModel : NSObject

@property (nonatomic, assign) CGFloat columnWidth;
@property (nonatomic, assign) CGFloat titleFontSize;
@property (nonatomic, assign) CGFloat contentFontSize;
@property (nonatomic, assign) CGFloat footerFontSize;
@property (nonatomic, assign) CGFloat minimumFontSize;
@property (nonatomic, assign) UITextAlignment columnAlignment;
@property (nonatomic, assign) GridColor titleColor;
@property (nonatomic, assign) GridColor titleBgColor;
@property (nonatomic, assign) GridColor titleFrameColor;
@property (nonatomic, assign) GridColor contentColor;
@property (nonatomic, assign) GridColor contentBgColor;
@property (nonatomic, assign) GridColor contentFrameColor;
@property (nonatomic, assign) GridColor footerColor;
@property (nonatomic, assign) GridColor footerBgColor;
@property (nonatomic, assign) GridColor footerFrameColor;
@property (nonatomic, assign) GridPadding padding;
@property (nonatomic, assign, getter = isDecForFontSizeAble) BOOL isDecForFontSizeAble;


@end
