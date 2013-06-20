#import "GridRowView.h"

@interface GridRowView()
@property (nonatomic, retain) UIButton *participateBtn;
@property (nonatomic, retain) UIButton *rejectBtn;
@end

@implementation GridRowView

@synthesize cellModelsMArr = _cellModelsMArr;
@synthesize delegate = _delegate;
@synthesize deleteBtnState = _deleteBtnState;

- (void)dealloc
{
    self.cellModelsMArr = nil;
    [_participateBtn release];
    _rejectBtn  = nil;
    
    [_rejectBtn release];
    _rejectBtn = nil;
    
    [super dealloc];
}

- (id)init
{
    self = [super init];
    if (self)
    {
        _deleteBtnState = GridRowViewDeleteBtnStateDefault;
        _cellModelsMArr = [[NSMutableArray alloc] init];
        [self setBackgroundColor:[UIColor whiteColor]];
        [self _addGestureRecognizer];
        
        self.flag = NO;
        
        _participateBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 0, 0)];
        _participateBtn.backgroundColor = [UIColor redColor];
        [self addSubview:_participateBtn];
        
//        _rejectBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 0, 0)];
//        _rejectBtn.backgroundColor = [UIColor blueColor];
//        [self addSubview:_rejectBtn];
    }
    return self;
}

/**
 * 添加两个手势，一、点击。二、长按
 **/
- (void)_addGestureRecognizer {
    UILongPressGestureRecognizer *longPressGesture = [[UILongPressGestureRecognizer alloc]initWithTarget:self action:@selector(longPressGesture:)];
    [longPressGesture setEnabled:YES];
    [self addGestureRecognizer:longPressGesture];
    [longPressGesture release];
    
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapGesture:)];
    [tapGesture setEnabled:YES];
    [self addGestureRecognizer:tapGesture];
    [tapGesture release];
}

/**
 * 点击事件的处理方法
 **/
- (void)tapGesture:(UITapGestureRecognizer *)recognizer {
    for (GridCellModel *cellModel in self.cellModelsMArr) {
        if (CGRectContainsPoint(cellModel.cellFrame, [recognizer locationInView:self])) {
            if (cellModel.isOutWidth) {
                
            }
            if ([_delegate respondsToSelector:@selector(gridRowView:didSelectAtPosition:)]) {
                [_delegate gridRowView:self didSelectAtPosition:cellModel.position];
            }
            break;
        }
    }
}

/**
 * 长按事件的处理方法
 **/
- (void)longPressGesture:(UILongPressGestureRecognizer *)recognizer {
    if (recognizer.state == UIGestureRecognizerStateBegan) {
        for (GridCellModel *cellModel in self.cellModelsMArr) {
            if (CGRectContainsPoint(cellModel.cellFrame, [recognizer locationInView:self])) {
                if ([_delegate respondsToSelector:@selector(gridRowView:didSelectWithLongPressAtPosition:)]) {
                    [_delegate gridRowView:self didSelectWithLongPressAtPosition:cellModel.position];
                }
                break;
            }
        }
    }
}

/**
 * 亲写drawRect:方法，将每一列的cell画到我身上
 **/
- (void)drawRect:(CGRect)rect
{
    [super drawRect:rect];
    CGContextRef context = UIGraphicsGetCurrentContext();
    for (GridCellModel *cellModel in self.cellModelsMArr)
    {
        NSString *text = cellModel.text;
        CGRect cellFrame = cellModel.cellFrame;
        CGContextSetRGBFillColor(context, cellModel.bgColor.red, cellModel.bgColor.green, cellModel.bgColor.blue, cellModel.bgColor.alpha);
        CGContextFillRect(context, cellFrame);
        UIColor *color = [UIColor colorWithRed:cellModel.frameColor.red green:cellModel.frameColor.red blue:cellModel.frameColor.red alpha:cellModel.frameColor.red];
        CGContextSetStrokeColorWithColor(context, color.CGColor);
        CGContextSetLineWidth(context, 1.0);
        if (cellModel.position.section == GridSectionHeader || cellModel.position.section == GridSectionFooter) {
            CGContextMoveToPoint(context, cellFrame.origin.x + cellFrame.size.width, cellFrame.origin.y);
            CGContextAddLineToPoint(context, cellFrame.origin.x + cellFrame.size.width, cellFrame.origin.y + cellFrame.size.height);
        } else if (cellModel.position.section == GridSectionContent) {
            CGContextMoveToPoint(context, cellFrame.origin.x, cellFrame.origin.y + cellFrame.size.height);
            CGContextAddLineToPoint(context, cellFrame.origin.x + cellFrame.size.width, cellFrame.origin.y + cellFrame.size.height);
        }
        CGContextStrokePath(context);
        GridPadding padding = cellModel.padding;
        CGFloat textFontSize = cellModel.textFontSize;
        CGFloat x = cellFrame.origin.x + padding.left;
        CGFloat y = padding.top;
        CGFloat width = cellFrame.size.width - padding.left - padding.right;
        float textRealWidth = [text sizeWithFont:[UIFont systemFontOfSize:textFontSize]].width;
        if (cellModel.isDecForFontSizeAble) {
            while (textRealWidth > width) {
                textRealWidth = [text sizeWithFont:[UIFont systemFontOfSize:--textFontSize]].width;
                if (textFontSize < cellModel.minimumFontSize) {
                    break;
                }
            }
        }
        if (textRealWidth > width) {
            cellModel.isOutWidth = YES;
        }
        CGFloat height = cellFrame.size.height - padding.top - padding.bottom;
        CGRect textFrame = CGRectMake(x, y, width, height);
        UITextAlignment textAlignment = cellModel.textAlignment;
        CGContextSetRGBFillColor(context, cellModel.textColor.red, cellModel.textColor.green, cellModel.textColor.blue, cellModel.textColor.alpha);
        [text drawInRect:textFrame withFont:[UIFont systemFontOfSize:textFontSize] lineBreakMode:UILineBreakModeTailTruncation alignment:textAlignment];
    }
//    if (self.flag)
//    {
//        _participateBtn.alpha = 1;
////        _rejectBtn.alpha = 1;
//    }
//    else
//    {
//        _participateBtn.alpha = 0;
////        _rejectBtn.alpha = 0;
//    }
    _participateBtn.frame = CGRectMake(0, 0, 30, 50);
//    _rejectBtn.frame = CGRectMake(_participateBtn.frame.origin.x+_participateBtn.frame.size.width, _participateBtn.frame.origin.y , _participateBtn.frame.size.width, _participateBtn.frame.size.height);
}

/**
 * 删除按钮点击事件响应
 **/
- (void)deleteBtnClick:(UIButton *)sender
{
    _deleteBtnState = 1 - _deleteBtnState;
    sender.layer.transform = CATransform3DMakeRotation(M_PI / (_deleteBtnState + 1), .0, .0, 1.0);
    if ([_delegate respondsToSelector:@selector(gridRowView:deleteWithRow:)])
    {
        GridCellModel *model = [self.cellModelsMArr lastObject];
        [_delegate gridRowView:self deleteWithRow:model.position.rc.row];
    }
}

/**
 * 绘制删除按钮
 **/
- (void)drawDeleteBtnWithHeight:(CGFloat)p_height andWithSection:(GridSection)p_section
{
    UIButton *deleteBtn = [[self subviews] lastObject];
    if (deleteBtn) {
        [deleteBtn removeFromSuperview];
    }
    if (p_section == GridSectionContent) {
        deleteBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [deleteBtn setFrame:CGRectMake(.0, .0, 26.0, 26.0)];
        [deleteBtn setCenter:CGPointMake(WidthForDelete / 2, p_height / 2)];
        UIImage *btnImg = [UIImage imageNamed:@"grid_delete.png"];
        [deleteBtn setImage:btnImg forState:UIControlStateNormal];
        [deleteBtn addTarget:self action:@selector(deleteBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:deleteBtn];
    }
}

@end
