/**
 * 我是一个UIView，每一行数据都会有两个我，左边（锁定列）一个，右边（可滑动）一个。
 * 在我之上会有N个cell，也就是每一列。为了提高性能，每个cell的实现利用了
 * drawInRect: withFont: lineBreakMode: alignment:方法写字。
 * 我对内容过长超出列宽的情况会根据情况做出处理。其一、在允许的范围内缩小字体，尽量显示所有内容。
 * 其二、如果不允许我缩小字体，或者已经超出其一的范围，那么我会用...来显示。
 **/
#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
#import "GridCellModel.h"

#define WidthForDelete 40.0

typedef enum {
    GridRowViewDeleteBtnStateDefault,
    GridRowViewDeleteBtnStateDelete
}GridRowViewDeleteBtnState;

@class GridRowView;

@protocol GridRowViewDelegate <NSObject>

/**
 * 点击事件代理
 **/
- (void)gridRowView:(GridRowView *)p_view didSelectAtPosition:(GridPosition)p_p;

/**
 * 长按点击事件代理
 **/
- (void)gridRowView:(GridRowView *)p_view didSelectWithLongPressAtPosition:(GridPosition)p_p;

/**
 * 删除事件代理
 **/
- (void)gridRowView:(GridRowView *)p_view deleteWithRow:(NSInteger)p_row;

@end

@interface GridRowView : UIView

@property (nonatomic, retain) NSMutableArray *cellModelsMArr;
@property (nonatomic, assign) id<GridRowViewDelegate> delegate;
@property (nonatomic, assign) GridRowViewDeleteBtnState deleteBtnState;
@property BOOL flag;

/**
 * 绘制删除按钮
 **/
- (void)drawDeleteBtnWithHeight:(CGFloat)p_height andWithSection:(GridSection)p_section;

@end
