#ifndef DceMobile_GridViewHelper_h
#define DceMobile_GridViewHelper_h

typedef enum {
    GridSectionHeader,
    GridSectionContent,
    GridSectionFooter
}GridSection;

typedef struct {
    NSInteger row;
    NSInteger column;
}GridRowAndColumn;

CG_INLINE GridRowAndColumn GridRowAndColumnMake(NSInteger row, NSInteger column);

CG_INLINE GridRowAndColumn GridRowAndColumnMake(NSInteger row, NSInteger column) {
    GridRowAndColumn rc;
    rc.row = row;
    rc.column = column;
    return rc;
}

typedef struct {
    GridSection section;
    GridRowAndColumn rc;
}GridPosition;

CG_INLINE GridPosition GridPositionMake(GridSection section, GridRowAndColumn rc);

CG_INLINE GridPosition GridPositionMakeFromRowAndColumn(GridSection section, NSInteger row, NSInteger column);

CG_INLINE GridPosition GridPositionMake(GridSection section, GridRowAndColumn rc) {
    GridPosition position;
    position.section = section;
    position.rc = rc;
    return position;
}

CG_INLINE GridPosition GridPositionMakeFromRowAndColumn(GridSection section, NSInteger row, NSInteger column) {
    GridPosition position;
    position.section = section;
    position.rc.row = row;
    position.rc.column = column;
    return position;
}

typedef struct {
    CGFloat left;
    CGFloat right;
    CGFloat top;
    CGFloat bottom;
}GridPadding;

CG_INLINE GridPadding GridPaddingMake(CGFloat left, CGFloat right, CGFloat top, CGFloat bottom);

CG_INLINE GridPadding GridPaddingMakeFromString(NSString *text);

CG_INLINE GridPadding GridPaddingMake(CGFloat left, CGFloat right, CGFloat top, CGFloat bottom) {
    GridPadding padding;
    padding.left = left;
    padding.right = right;
    padding.top = top;
    padding.bottom = bottom;
    return padding;
}

CG_INLINE GridPadding GridPaddingMakeFromString(NSString *text) {
    return GridPaddingMake([[[text componentsSeparatedByString:@","] objectAtIndex:0] floatValue],
                       [[[text componentsSeparatedByString:@","] objectAtIndex:1] floatValue],
                       [[[text componentsSeparatedByString:@","] objectAtIndex:2] floatValue],
                       [[[text componentsSeparatedByString:@","] objectAtIndex:3] floatValue]);
}

typedef struct {
    CGFloat red;
    CGFloat green;
    CGFloat blue;
    CGFloat alpha;
}GridColor;

CG_INLINE GridColor GridColorMake(CGFloat red, CGFloat green, CGFloat blue, CGFloat alpha);

CG_INLINE GridColor GridColorMakeFromString(NSString *text);

CG_INLINE GridColor GridColorMake(CGFloat red, CGFloat green, CGFloat blue, CGFloat alpha) {
    GridColor color;
    color.red = red / 255.0;
    color.green = green / 255.0;
    color.blue = blue / 255.0;
    color.alpha = alpha;
    return color;
}

CG_INLINE GridColor GridColorMakeFromString(NSString *text) {
    return GridColorMake([[[text componentsSeparatedByString:@","] objectAtIndex:0] floatValue],
                     [[[text componentsSeparatedByString:@","] objectAtIndex:1] floatValue],
                     [[[text componentsSeparatedByString:@","] objectAtIndex:2] floatValue],
                     1.0);
}

#endif
