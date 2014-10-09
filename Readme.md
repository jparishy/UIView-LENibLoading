# UIView+LENibLoading
## Category for loading view from a nib

### API

The API is simple and includes 2 methods. The first simply calls the second using the class name and the mainBundle.

```
@interface UIView (LENibLoading)

- (void)le_loadFromNib;
- (void)le_loadFromNibWithNibName:(NSString *)nibName bundle:(NSBundle *)bundle;

@end
```

### How to use

You can use the category directly:
```
// If the view is created in code
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        self.translatesAutoresizingMaskIntoConstraints = NO;
        [self le_loadFromNib];
    }
    
    return self;
}

// If the view is instantiated from another nib.
- (void)awakeFromNib
{
    [super awakeFromNib];
    
    self.translatesAutoresizingMaskIntoConstraints = NO;
    [self initializeSubviews];
}
```

Additionally an interface you can subclass is provided which does this for you:
```
@interface MyCustomNibView : LENibLoadedView

@end

```
