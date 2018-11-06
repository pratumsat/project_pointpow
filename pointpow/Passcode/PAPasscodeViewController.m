//
//  PAPasscodeViewController.m
//  PAPasscode
//
//  Created by Denis Hennessy on 15/10/2012.
//  Copyright (c) 2012 Peer Assembly. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>
#import "PAPasscodeViewController.h"

static NSString *BulletCharacter = @"\u25CF";
static NSString *DashCharacter = @"\u25CF"; //@"\u25CB";
static NSInteger FailedBackgroundHeight = 20;
static NSTimeInterval AnimationDuration = 0.3;

@interface PAPasscodeViewController() 
- (void)cancel:(id)sender;
- (void)handleFailedAttempt;
- (void)handleCompleteField;
- (void)passcodeChanged:(id)sender;
- (void)resetFailedAttempts;
- (void)showFailedAttempts;
- (void)showScreenForPhase:(NSInteger)phase animated:(BOOL)animated;

@end

@implementation PAPasscodeViewController

- (id)initForAction:(PasscodeAction)action {
    self = [super init];
    if (self) {
        _action = action;
        switch (action) {
            case PasscodeActionSet:
                self.title = NSLocalizedString(@"title-set-passcode", nil);
                _enterPrompt = NSLocalizedString(@"prompt-enter-a-passcode", nil);
                _confirmPrompt = NSLocalizedString(@"re-enter-your-passcode", nil);
                break;
                
            case PasscodeActionEnter:
                self.title = NSLocalizedString(@"title-enter-passcode", nil);
                _enterPrompt = NSLocalizedString(@"prompt-enter-passcode", nil);
                break;
                
            case PasscodeActionChange:
                self.title = NSLocalizedString(@"Change Passcode", nil);
                _changePrompt = NSLocalizedString(@"Enter your old passcode", nil);
                _enterPrompt = NSLocalizedString(@"Enter your new passcode", nil);
                _confirmPrompt = NSLocalizedString(@"Re-enter your new passcode", nil);
                break;
        }
        self.modalPresentationStyle = UIModalPresentationFormSheet;
        _simple = YES;
    }
    return self;
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)loadView {
    UIView *view = [[UIView alloc] init];
    view.backgroundColor = [UIColor whiteColor]; //[UIColor colorWithWhite:0.9 alpha:1.0];
    
    // contentView is set to the visible area (below nav bar, above keyboard)
    contentView = [[UIView alloc] init];
    contentView.translatesAutoresizingMaskIntoConstraints = NO;
    contentView.backgroundColor = [UIColor clearColor];
    [view addSubview:contentView];

    _inputPanel = [[UIView alloc] init];
    _inputPanel.translatesAutoresizingMaskIntoConstraints = NO;
    [contentView addSubview:_inputPanel];

    passcodeTextField = [[UITextField alloc] init];
    passcodeTextField.translatesAutoresizingMaskIntoConstraints = NO;
    passcodeTextField.secureTextEntry = YES;
    [passcodeTextField addTarget:self action:@selector(passcodeChanged:) forControlEvents:UIControlEventEditingChanged];
    passcodeTextField.delegate = self;
    
    [_inputPanel addSubview:passcodeTextField];
    if (_simple) {
        UIFont *font = [UIFont fontWithName:@"Courier" size:32];
        for (int i=0;i<6;i++) {
            _digitLabels[i] = [[UILabel alloc] init];
            _digitLabels[i].translatesAutoresizingMaskIntoConstraints = NO;
            _digitLabels[i].font = font;
            _digitLabels[i].textColor = [UIColor colorWithRed:0.9 green:0.9 blue:0.95 alpha:1.0];
            [_inputPanel addSubview:_digitLabels[i]];
            _digitLabels[i].text = DashCharacter;
        }
        passcodeTextField.hidden = YES;
        passcodeTextField.keyboardType = UIKeyboardTypeNumberPad;
    } else {
        _inputPanel.backgroundColor = [UIColor whiteColor];
    }
    
    promptLabel = [[UILabel alloc] init];
    promptLabel.translatesAutoresizingMaskIntoConstraints = NO;
    promptLabel.font = [UIFont fontWithName:@"ThaiSansNeue-Regular" size:20];
    promptLabel.textAlignment = NSTextAlignmentCenter;
    promptLabel.numberOfLines = 0;
    //[promptLabel sizeToFit];
    [contentView addSubview:promptLabel];
    
    messageLabel = [[UILabel alloc] init];
    messageLabel.translatesAutoresizingMaskIntoConstraints = NO;
    messageLabel.font = [UIFont fontWithName:@"ThaiSansNeue-Regular" size:20];
    messageLabel.textAlignment = NSTextAlignmentCenter;
    messageLabel.numberOfLines = 0;
    messageLabel.text = _message;
    messageLabel.textColor = [UIColor colorWithRed:0.75 green:0.16 blue:0.16 alpha:1];
    [contentView addSubview:messageLabel];
    
    _failedAttemptsView = [[UIView alloc] init];
    _failedAttemptsView.translatesAutoresizingMaskIntoConstraints = NO;
    _failedAttemptsView.backgroundColor = [UIColor clearColor];
    _failedAttemptsView.hidden = YES;
    [contentView addSubview:_failedAttemptsView];
    
    self.view = view;
    [self.view setNeedsUpdateConstraints];
}

- (void)updateViewConstraints {
    [super updateViewConstraints];
    
    if (_installedConstraints) {
        [self.view removeConstraints:_installedConstraints];
    }
    NSMutableArray *constraints = [[NSMutableArray alloc] init];
    NSDictionary *views = @{
                            @"contentView": contentView,
                            @"inputPanel": _inputPanel,
                            @"failedAttemptsView": _failedAttemptsView,
                            @"messageLabel": messageLabel,
                            @"passcodeTextField": passcodeTextField,
                            @"promptLabel": promptLabel,
                            };
    [constraints addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[contentView]|" options:0 metrics:nil views:views]];
    
    
        
    [constraints addObject:[NSLayoutConstraint constraintWithItem:contentView
                                                        attribute:NSLayoutAttributeTop
                                                        relatedBy:NSLayoutRelationEqual
                                                           toItem:self.topLayoutGuide
                                                        attribute:NSLayoutAttributeBottom
                                                       multiplier:1 constant:0]];
    
    _keyboardHeightConstraint = [NSLayoutConstraint constraintWithItem:contentView
                                                             attribute:NSLayoutAttributeBottom
                                                             relatedBy:NSLayoutRelationEqual
                                                                toItem:self.bottomLayoutGuide
                                                             attribute:NSLayoutAttributeBottom
                                                            multiplier:1 constant:0];
    [constraints addObject:_keyboardHeightConstraint];
    
    if (_centerPosition){
        [constraints addObject:[NSLayoutConstraint constraintWithItem:promptLabel attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:contentView attribute:NSLayoutAttributeCenterY multiplier:1 constant:0]];
    }else{
        [constraints addObject:[NSLayoutConstraint constraintWithItem:promptLabel attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:contentView attribute:NSLayoutAttributeTop multiplier:1 constant:20]];
        [constraints addObject:[NSLayoutConstraint constraintWithItem:promptLabel attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:contentView attribute:NSLayoutAttributeWidth multiplier:0.8 constant:0]];
        
    }
    [constraints addObject:[NSLayoutConstraint constraintWithItem:_inputPanel attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:contentView attribute:NSLayoutAttributeCenterX multiplier:1 constant:0]];
    
    NSDictionary *digits = @{@"d0": _digitLabels[0], @"d1": _digitLabels[1], @"d2": _digitLabels[2], @"d3": _digitLabels[3],@"d4": _digitLabels[4],@"d5": _digitLabels[5]};
    [constraints addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[d0]-(w)-[d1]-(w)-[d2]-(w)-[d3]-(w)-[d4]-(w)-[d5]|" options:0 metrics:@{@"w": @(16)} views:digits]];
    [constraints addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[d0]|" options:0 metrics:nil views:digits]];
    [constraints addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[d1]|" options:0 metrics:nil views:digits]];
    [constraints addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[d2]|" options:0 metrics:nil views:digits]];
    [constraints addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[d3]|" options:0 metrics:nil views:digits]];
    [constraints addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[d4]|" options:0 metrics:nil views:digits]];
    [constraints addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[d5]|" options:0 metrics:nil views:digits]];
        
    

//    [constraints addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-[failedAttemptsLabel]-|" options:0 metrics:nil views:views]];
//    [constraints addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[failedAttemptsLabel]|" options:0 metrics:nil views:views]];

    
//    [constraints addObject:[NSLayoutConstraint constraintWithItem:_failedAttemptsView attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:contentView attribute:NSLayoutAttributeWidth multiplier:1 constant:0]];
//    
    
    
    
    [constraints addObject:[NSLayoutConstraint constraintWithItem:promptLabel attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:contentView attribute:NSLayoutAttributeWidth multiplier:0.8 constant:0]];
    
     
    [constraints addObject:[NSLayoutConstraint constraintWithItem:messageLabel attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:contentView attribute:NSLayoutAttributeCenterX multiplier:1 constant:0]];
    
    [constraints addObject:[NSLayoutConstraint constraintWithItem:promptLabel attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:contentView attribute:NSLayoutAttributeCenterX multiplier:1 constant:0]];
   
    
    [constraints addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[promptLabel]-[inputPanel]-[messageLabel]-[failedAttemptsView]" options:0 metrics:@{@"h": @(FailedBackgroundHeight)} views:views]];

    _installedConstraints = constraints;
    [self.view addConstraints:_installedConstraints];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    if ([_delegate respondsToSelector:@selector(PAPasscodeViewControllerDidCancel:)]) {
//        if (_simple) {
//            self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(cancel:)];
//        } else {
            self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(cancel:)];
//        }
    }
    
    if (_failedAttempts > 0) {
        [self showFailedAttempts];
    }
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillChangeFrameNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];

}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    
}
- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [NSTimer scheduledTimerWithTimeInterval:0.1
                                     target:self
                                   selector:@selector(becomePasscode:)
                                   userInfo:nil
                                    repeats:NO];
    
}

- (void)becomePasscode:(NSNotification *)notification{
    [self showScreenForPhase:0 animated:NO];
    [passcodeTextField becomeFirstResponder];
    [self.view layoutIfNeeded];
}

- (UIInterfaceOrientationMask)supportedInterfaceOrientations {
    return UIInterfaceOrientationMaskPortrait|UIInterfaceOrientationMaskPortraitUpsideDown;
}

- (void)cancel:(id)sender {
    [_delegate PAPasscodeViewControllerDidCancel:self];
}

#pragma mark - implementation helpers

- (void)keyboardWillShow:(NSNotification *)notification {
    NSDictionary *info = [notification userInfo];
    NSValue *kbFrame = [info objectForKey:UIKeyboardFrameEndUserInfoKey];
    NSTimeInterval animationDuration = [[info objectForKey:UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    CGRect keyboardFrame = [kbFrame CGRectValue];
    
    _keyboardHeightConstraint.constant = -keyboardFrame.size.height;
    [UIView animateWithDuration:animationDuration animations:^{
        [self.view layoutIfNeeded];
    }];
}

- (void)keyboardWillHide:(NSNotification *)notification {
    NSDictionary *info = [notification userInfo];
    NSTimeInterval animationDuration = [[info objectForKey:UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    
    _keyboardHeightConstraint.constant = 0;
    [UIView animateWithDuration:animationDuration animations:^{
        [self.view layoutIfNeeded];
    }];
}
- (void)emptyPin{
    for (int i=0;i<6;i++) {
        _digitLabels[i].text = DashCharacter;
        _digitLabels[i].textColor =  [UIColor colorWithRed:0.9 green:0.9 blue:0.95 alpha:1.0];
    }
    passcodeTextField.text = @"";
}

- (void)handleCompleteField {
    NSString *text = passcodeTextField.text;
    switch (_action) {
        case PasscodeActionSet:
            if (phase == 0) {
                _passcode = text;
                messageLabel.text = @"";
                [self emptyPin];
                [self showScreenForPhase:1 animated:YES];
            } else {
                if ([text isEqualToString:_passcode]) {
                    if ([_delegate respondsToSelector:@selector(PAPasscodeViewControllerDidSetPasscode:didSetPassCode:)]) {
                        [_delegate PAPasscodeViewControllerDidSetPasscode:self didSetPassCode:text];
                    }
                } else {
                    [self emptyPin];
                    [self showScreenForPhase:0 animated:YES];
                    messageLabel.text = NSLocalizedString(@"passcodes-did-not-match", nil);
                }
            }
            break;
            
        case PasscodeActionEnter:
        
            if ([text isEqualToString:_passcode]) {
                [self resetFailedAttempts];
                //if ([_delegate respondsToSelector:@selector(PAPasscodeViewControllerDidEnterPasscode:)]) {
                //    [_delegate PAPasscodeViewControllerDidEnterPasscode:self];
                //}
            } else {
                if (_alternativePasscode && [text isEqualToString:_alternativePasscode]) {
                    [self resetFailedAttempts];
                    //if ([_delegate respondsToSelector:@selector(PAPasscodeViewControllerDidEnterAlternativePasscode:)]) {
                        //[_delegate PAPasscodeViewControllerDidEnterAlternativePasscode:self];
                    //}
                } else {
                    //[self handleFailedAttempt];
                    [self showScreenForPhase:0 animated:NO];
                }
            }
        if ([_delegate respondsToSelector:@selector(PAPasscodeViewControllerDidEnterPasscodeResult:didEnterPassCode:)]) {
                [_delegate PAPasscodeViewControllerDidEnterPasscodeResult:self didEnterPassCode:text];
            }
            break;
            
        case PasscodeActionChange:
            if (phase == 0) {
                if ([text isEqualToString:_passcode]) {
                    [self resetFailedAttempts];
                    [self showScreenForPhase:1 animated:YES];
                } else {
                    //[self handleFailedAttempt];
                    [self showScreenForPhase:0 animated:NO];
                }
            } else if (phase == 1) {
                _passcode = text;
                messageLabel.text = nil;
                [self showScreenForPhase:2 animated:YES];
            } else {
                if ([text isEqualToString:_passcode]) {
                    if ([_delegate respondsToSelector:@selector(PAPasscodeViewControllerDidChangePasscode:)]) {
                        [_delegate PAPasscodeViewControllerDidChangePasscode:self];
                    }
                } else {
                    [self showScreenForPhase:1 animated:YES];
                    messageLabel.text = NSLocalizedString(@"passcodes-did-not-match", nil);
                }
            }
            break;
    }
}

- (void)handleFailedAttempt {
    _failedAttempts++;
    [self showFailedAttempts];
    if ([_delegate respondsToSelector:@selector(PAPasscodeViewController:didFailToEnterPasscode:)]) {
        [_delegate PAPasscodeViewController:self didFailToEnterPasscode:_failedAttempts];
    }
}

- (void)resetFailedAttempts {
    messageLabel.hidden = NO;
    _failedAttempts = 0;
}

- (void)showFailedAttempts {
//    messageLabel.hidden = YES;
//    failedAttemptsLabel = NO;
//    if (_failedAttempts == 1) {
//        failedAttemptsLabel.text = NSLocalizedString(@"1 Failed Passcode Attempt", nil);
//    } else {
//        failedAttemptsLabel.text = [NSString stringWithFormat:NSLocalizedString(@"%d Failed Passcode Attempts", nil), _failedAttempts];
//    }
}
    
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    NSUInteger newLength = [textField.text length] + [string length] - range.length;
    return (newLength > 6) ? NO : YES;
}
    
- (void)showPassCodeSuccess {
    for (int i=0;i<6;i++) {
        _digitLabels[i].text = DashCharacter;
        _digitLabels[i].textColor = [UIColor colorWithRed:0.88 green:0 blue:0.03 alpha:1.0];

    }
}
- (void)setTitlePasscode:(NSString*) messageTitle{
    _enterPrompt = messageTitle;
    promptLabel.text = messageTitle;
    
}
- (void)showFailedMessage:(NSString*) messageError {
    messageLabel.hidden = YES;
    
    
    for (int i=0;i<6;i++) {
        _digitLabels[i].text = DashCharacter;
        _digitLabels[i].textColor =  [UIColor colorWithRed:0.9 green:0.9 blue:0.95 alpha:1.0];
    }
   passcodeTextField.text = @"";
   
    CABasicAnimation *shake = [CABasicAnimation animationWithKeyPath:@"position"];
    [shake setDuration:0.1];
    [shake setRepeatCount:2];
    [shake setAutoreverses:YES];
    [shake setFromValue:[NSValue valueWithCGPoint:
                         CGPointMake(_inputPanel.center.x - 5,_inputPanel.center.y)]];
    [shake setToValue:[NSValue valueWithCGPoint:
                       CGPointMake(_inputPanel.center.x + 5, _inputPanel.center.y)]];
    [_inputPanel.layer addAnimation:shake forKey:@"position"];
}

- (void)passcodeChanged:(id)sender {
    NSString *text = passcodeTextField.text;
    if (_simple) {
        if ([text length] > 6) {
            text = [text substringToIndex:6];
        }
        for (int i=0;i<6;i++) {
            
            _digitLabels[i].textColor = (i >= [text length]) ?  [UIColor colorWithRed:0.9 green:0.9 blue:0.95 alpha:1.0] :[UIColor colorWithRed:0.88 green:0 blue:0.03 alpha:1.0];
        }
        if ([text length] == 6) {
            [self handleCompleteField];
        }
    } else {
        self.navigationItem.rightBarButtonItem.enabled = [text length] > 0;
    }
}

- (void)showScreenForPhase:(NSInteger)newPhase animated:(BOOL)animated {
    CGFloat dir = (newPhase > phase) ? 1 : -1;
    if (animated) {
        UIGraphicsBeginImageContext(self.view.bounds.size);
        [contentView.layer renderInContext:UIGraphicsGetCurrentContext()];
        UIImage *snapshot = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        snapshotImageView = [[UIImageView alloc] initWithImage:snapshot];
        snapshotImageView.frame = CGRectOffset(snapshotImageView.frame, -contentView.frame.size.width*dir, 0);
        [contentView addSubview:snapshotImageView];
    }
    phase = newPhase;
    //passcodeTextField.text = @"";
    if (!_simple) {
        BOOL finalScreen = _action == PasscodeActionSet && phase == 1;
        finalScreen |= _action == PasscodeActionEnter && phase == 0;
        finalScreen |= _action == PasscodeActionChange && phase == 2;
        if (finalScreen) {
            
            self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(handleCompleteField)];
        } else {
            self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"Next", nil) style:UIBarButtonItemStylePlain target:self action:@selector(handleCompleteField)];
        }
        self.navigationItem.rightBarButtonItem.enabled = NO;
    }
    
    switch (_action) {
        case PasscodeActionSet:
            if (phase == 0) {
                promptLabel.text = _enterPrompt;
            } else {
                promptLabel.text = _confirmPrompt;
            }
            break;
            
        case PasscodeActionEnter:
            if (_centerPosition){
                promptLabel.text = _enterPrompt;
            }
            break;
            
        case PasscodeActionChange:
            if (phase == 0) {
                promptLabel.text = _changePrompt;
            } else if (phase == 1) {
                promptLabel.text = _enterPrompt;
            } else {
                promptLabel.text = _confirmPrompt;
            }
            break;
    }
    //[promptLabel sizeToFit];
    
    /*for (int i=0;i<6;i++) {
        _digitLabels[i].text = DashCharacter;
        _digitLabels[i].textColor =  [UIColor colorWithRed:0.9 green:0.9 blue:0.95 alpha:1.0];
    }*/
    if (animated) {
        contentView.frame = CGRectOffset(contentView.frame, contentView.frame.size.width*dir, 0);
        [UIView animateWithDuration:AnimationDuration animations:^() {
            contentView.frame = CGRectOffset(contentView.frame, -contentView.frame.size.width*dir, 0);
        } completion:^(BOOL finished) {
            [snapshotImageView removeFromSuperview];
            snapshotImageView = nil;
        }];
    }
}

@end
