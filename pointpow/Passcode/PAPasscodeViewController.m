//
//  PAPasscodeViewController.m
//  PAPasscode
//
//  Created by Denis Hennessy on 15/10/2012.
//  Copyright (c) 2012 Peer Assembly. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>
#import "PAPasscodeViewController.h"

static NSString *BulletCharacter = @"\u25CB";
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

    logoAppImageView = [[UIImageView alloc] initWithImage:([UIImage imageNamed:@"ic-logo"] )];
    logoAppImageView.translatesAutoresizingMaskIntoConstraints = NO;
    logoAppImageView.contentMode = UIViewContentModeScaleAspectFit;
    [contentView addSubview:logoAppImageView];
    
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
            _digitLabels[i].textColor = [UIColor colorWithRed:0.88 green:0 blue:0.03 alpha:1.0];
            [_inputPanel addSubview:_digitLabels[i]];
            _digitLabels[i].text = BulletCharacter;
        }
        passcodeTextField.hidden = YES;
        passcodeTextField.keyboardType = UIKeyboardTypeNumberPad;
    } else {
        _inputPanel.backgroundColor = [UIColor whiteColor];
    }
    
    promptLabel = [[UILabel alloc] init];
    promptLabel.translatesAutoresizingMaskIntoConstraints = NO;
    promptLabel.font = [UIFont fontWithName:@"ThaiSansNeue-Bold" size:18];
    promptLabel.textColor = [UIColor colorWithRed:40/255 green:40/255 blue:40/255 alpha:1];
    promptLabel.textAlignment = NSTextAlignmentCenter;
    promptLabel.numberOfLines = 0;
    //[promptLabel sizeToFit];
    [contentView addSubview:promptLabel];
    
    messageLabel = [[UILabel alloc] init];
    messageLabel.translatesAutoresizingMaskIntoConstraints = NO;
    messageLabel.font = [UIFont fontWithName:@"ThaiSansNeue-Regular" size:18];
    messageLabel.textAlignment = NSTextAlignmentCenter;
    messageLabel.numberOfLines = 0;
    messageLabel.text = _message;
    messageLabel.textColor = [UIColor colorWithRed:0.75 green:0.16 blue:0.16 alpha:1];
    [contentView addSubview:messageLabel];
    
    forgotLabel = [[UILabel alloc] init];
    forgotLabel.translatesAutoresizingMaskIntoConstraints = NO;
    forgotLabel.font = [UIFont fontWithName:@"ThaiSansNeue-Bold" size:18];
    forgotLabel.textAlignment = NSTextAlignmentCenter;
    forgotLabel.numberOfLines = 0;
    forgotLabel.textColor = [UIColor colorWithRed:20/255.0 green:92/255.0 blue:253/255.0 alpha:1];
    
    NSMutableAttributedString *attributeString = [[NSMutableAttributedString alloc]
                                                  initWithString: NSLocalizedString(@"title-forgot-passcode", nil)];
    [attributeString addAttribute:NSUnderlineStyleAttributeName
                            value:[NSNumber numberWithInt:1]
                            range:(NSRange){0,[attributeString length]}];
    
    forgotLabel.attributedText = attributeString;
    
    UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(forgotTapped)];
    tapGestureRecognizer.numberOfTapsRequired = 1;
    forgotLabel.userInteractionEnabled = YES;
    [forgotLabel addGestureRecognizer:tapGestureRecognizer];
    
    
    [contentView addSubview:forgotLabel];

    failedAttemptsLabel = [[UILabel alloc] init];
    failedAttemptsLabel.translatesAutoresizingMaskIntoConstraints = NO;
    failedAttemptsLabel.textColor = [UIColor colorWithRed:0.75 green:0.16 blue:0.16 alpha:1];
    failedAttemptsLabel.font = [UIFont fontWithName:@"ThaiSansNeue-Regular" size:18];
    failedAttemptsLabel.textAlignment = NSTextAlignmentCenter;
    failedAttemptsLabel.numberOfLines = 0;
    failedAttemptsLabel.text = @" ";
    [contentView addSubview:failedAttemptsLabel];
    
    
    emailTextField = [[UITextField alloc] init];
    emailTextField.translatesAutoresizingMaskIntoConstraints = NO;
    emailTextField.delegate = self;
    emailTextField.keyboardType = UIKeyboardTypeEmailAddress;
    emailTextField.autocorrectionType = UITextAutocorrectionTypeNo;
    emailTextField.returnKeyType = UIReturnKeyDone;
    emailTextField.font = [UIFont fontWithName:@"ThaiSansNeue-Bold" size:20];
    [contentView addSubview:emailTextField];
    emailTextField.hidden = YES;
    
    underLineTextFieldView = [[UIView alloc] init];
    underLineTextFieldView.translatesAutoresizingMaskIntoConstraints = NO;
    underLineTextFieldView.backgroundColor = [UIColor lightGrayColor];
    [contentView addSubview: underLineTextFieldView];
    underLineTextFieldView.hidden = YES;
    
    sendEmailButton = [UIButton buttonWithType:UIButtonTypeCustom];
    sendEmailButton.translatesAutoresizingMaskIntoConstraints = NO;
    [sendEmailButton setTitle:NSLocalizedString(@"title-forgot-passcode-send-email", nil) forState:UIControlStateNormal];
    sendEmailButton.titleLabel.font = [UIFont fontWithName:@"ThaiSansNeue-Bold" size:20];
    sendEmailButton.titleLabel.textColor = [UIColor whiteColor];
    sendEmailButton.backgroundColor = [UIColor colorWithRed:255/255.0 green:9/255.0 blue:46/255.0 alpha:1.0];
    
    sendEmailButton.layer.cornerRadius = 15;
    sendEmailButton.clipsToBounds = YES;
    [sendEmailButton addTarget:self action:@selector(buttonClicked:) forControlEvents:UIControlEventTouchUpInside];
    
    
    [contentView addSubview: sendEmailButton];
    sendEmailButton.hidden = YES;
    
    switch (_action) {
        case PasscodeActionSet:
            forgotLabel.hidden = YES;
            break;
            
        case PasscodeActionEnter:
            forgotLabel.hidden = NO;
            break;
            
        case PasscodeActionChange:
            forgotLabel.hidden = YES;
            break;
    }
    
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
                            @"failedAttemptsLabel": failedAttemptsLabel,
                            @"forgotLabel": forgotLabel,
                            @"messageLabel": messageLabel,
                            @"passcodeTextField": passcodeTextField,
                            @"promptLabel": promptLabel,
                            @"logoAppImageView":logoAppImageView,
                            @"emailTextField": emailTextField,
                            @"underLineTextFieldView":underLineTextFieldView,
                            @"sendEmailButton":sendEmailButton
                    
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
        [constraints addObject:[NSLayoutConstraint constraintWithItem:promptLabel attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:contentView attribute:NSLayoutAttributeCenterY multiplier:1 constant:0]];
        [constraints addObject:[NSLayoutConstraint constraintWithItem:promptLabel attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:contentView attribute:NSLayoutAttributeWidth multiplier:0.8 constant:0]];
    }else{
        [constraints addObject:[NSLayoutConstraint constraintWithItem:promptLabel attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:contentView attribute:NSLayoutAttributeTop multiplier:1 constant:20]];
        [constraints addObject:[NSLayoutConstraint constraintWithItem:promptLabel attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:contentView attribute:NSLayoutAttributeWidth multiplier:0.8 constant:0]];
    }
    
    [constraints addObject:[NSLayoutConstraint constraintWithItem:logoAppImageView
                                                        attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:contentView attribute:NSLayoutAttributeCenterX multiplier:1 constant:0]];
    
    [constraints addObject:[NSLayoutConstraint constraintWithItem:logoAppImageView
                                                        attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:promptLabel attribute:NSLayoutAttributeTop multiplier:1.1 constant:0]];
    
    [constraints addObject:[NSLayoutConstraint constraintWithItem:logoAppImageView
                                                        attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:contentView attribute:NSLayoutAttributeWidth multiplier:0.5 constant:0]];

    
    [constraints addObject:[NSLayoutConstraint constraintWithItem:_inputPanel attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:contentView attribute:NSLayoutAttributeCenterX multiplier:1 constant:0]];
    
    NSDictionary *digits = @{@"d0": _digitLabels[0], @"d1": _digitLabels[1], @"d2": _digitLabels[2], @"d3": _digitLabels[3],@"d4": _digitLabels[4],@"d5": _digitLabels[5]};
    [constraints addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[d0]-(w)-[d1]-(w)-[d2]-(w)-[d3]-(w)-[d4]-(w)-[d5]|" options:0 metrics:@{@"w": @(16)} views:digits]];
    [constraints addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[d0]|" options:0 metrics:nil views:digits]];
    [constraints addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[d1]|" options:0 metrics:nil views:digits]];
    [constraints addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[d2]|" options:0 metrics:nil views:digits]];
    [constraints addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[d3]|" options:0 metrics:nil views:digits]];
    [constraints addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[d4]|" options:0 metrics:nil views:digits]];
    [constraints addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[d5]|" options:0 metrics:nil views:digits]];
        
    
    
     [constraints addObject:[NSLayoutConstraint constraintWithItem:underLineTextFieldView attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:emailTextField attribute:NSLayoutAttributeBottom multiplier:1 constant:0]];
    
     [constraints addObject:[NSLayoutConstraint constraintWithItem:underLineTextFieldView attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1 constant:1]];
    
     [constraints addObject:[NSLayoutConstraint constraintWithItem:underLineTextFieldView attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:emailTextField attribute:NSLayoutAttributeLeft multiplier:1 constant:0]];
    
    [constraints addObject:[NSLayoutConstraint constraintWithItem:underLineTextFieldView attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:emailTextField attribute:NSLayoutAttributeRight multiplier:1 constant:0]];
    
    
    
    [constraints addObject:[NSLayoutConstraint constraintWithItem:emailTextField attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:_inputPanel attribute:NSLayoutAttributeCenterY multiplier:1 constant:0]];
    
    
    [constraints addObject:[NSLayoutConstraint constraintWithItem:emailTextField attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:contentView attribute:NSLayoutAttributeWidth multiplier:0.8 constant:0]];
    
    
    [constraints addObject:[NSLayoutConstraint constraintWithItem:emailTextField attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1 constant:30]];
    
    
    [constraints addObject:[NSLayoutConstraint constraintWithItem:emailTextField attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:contentView attribute:NSLayoutAttributeCenterX multiplier:1 constant:0]];

    
    [constraints addObject:[NSLayoutConstraint constraintWithItem:sendEmailButton attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:emailTextField attribute:NSLayoutAttributeBottom multiplier:1 constant:20]];
    
    [constraints addObject:[NSLayoutConstraint constraintWithItem:sendEmailButton attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1 constant:30]];
    
    [constraints addObject:[NSLayoutConstraint constraintWithItem:sendEmailButton attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:emailTextField attribute:NSLayoutAttributeLeft multiplier:1 constant:0]];
    
    [constraints addObject:[NSLayoutConstraint constraintWithItem:sendEmailButton attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:emailTextField attribute:NSLayoutAttributeRight multiplier:1 constant:0]];
    
    
    [constraints addObject:[NSLayoutConstraint constraintWithItem:failedAttemptsLabel attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:contentView attribute:NSLayoutAttributeCenterX multiplier:1 constant:0]];
    
    [constraints addObject:[NSLayoutConstraint constraintWithItem:failedAttemptsLabel attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:_inputPanel attribute:NSLayoutAttributeBottom multiplier:1 constant:0]];
    
    
    [constraints addObject:[NSLayoutConstraint constraintWithItem:forgotLabel attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:contentView attribute:NSLayoutAttributeCenterX multiplier:1 constant:0]];
    
    [constraints addObject:[NSLayoutConstraint constraintWithItem:forgotLabel attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:failedAttemptsLabel attribute:NSLayoutAttributeBottom multiplier:1 constant:0]];
    
    
    
    [constraints addObject:[NSLayoutConstraint constraintWithItem:promptLabel attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:contentView attribute:NSLayoutAttributeWidth multiplier:0.8 constant:0]];
    
     
    [constraints addObject:[NSLayoutConstraint constraintWithItem:messageLabel attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:contentView attribute:NSLayoutAttributeCenterX multiplier:1 constant:0]];
    
    [constraints addObject:[NSLayoutConstraint constraintWithItem:promptLabel attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:contentView attribute:NSLayoutAttributeCenterX multiplier:1 constant:0]];
   
    
    [constraints addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[promptLabel]-[inputPanel]-[messageLabel]" options:0 metrics:@{@"h": @(FailedBackgroundHeight)} views:views]];

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
    
    _keyboardHeightConstraint.constant = -(keyboardFrame.size.height + 30.0);
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
        _digitLabels[i].text = BulletCharacter;
        
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
            /*
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
             */
            break;
    }
}
-(void) buttonClicked:(UIButton*)sender{
    NSLog(@"email = %@", emailTextField.text);

    [_delegate PAPasscodeViewControllerDidResetEmail:self didResetEmailPinCode:emailTextField.text];
}
-(void)forgotTapped {
    
    if (_forgotPin) {
//        [self showScreenForPhase:0 animated:YES];
//         _forgotPin = false;
//        emailTextField.hidden = YES;
//        underLineTextFieldView.hidden = YES;
//        sendEmailButton.hidden = YES;
//        _inputPanel.hidden = NO;
//        forgotLabel.hidden = NO;
//        failedAttemptsLabel.hidden = NO;
//        [passcodeTextField becomeFirstResponder];
//        [emailTextField resignFirstResponder];
//
//
//        NSMutableAttributedString *attributeString = [[NSMutableAttributedString alloc]
//                                                      initWithString: NSLocalizedString(@"title-forgot-passcode", nil)];
//        [attributeString addAttribute:NSUnderlineStyleAttributeName
//                                value:[NSNumber numberWithInt:1]
//                                range:(NSRange){0,[attributeString length]}];
//
//        forgotLabel.attributedText = attributeString;
//        promptLabel.text = _enterPrompt;
//
    }else{
        [self showScreenForPhase:1 animated:YES];
         _forgotPin = true;
        emailTextField.hidden = NO;
        underLineTextFieldView.hidden = NO;
        sendEmailButton.hidden = NO;
        forgotLabel.hidden = YES;
        _inputPanel.hidden = YES;
        failedAttemptsLabel.hidden = YES;
        [emailTextField becomeFirstResponder];
        [passcodeTextField resignFirstResponder];
        
        
        NSMutableAttributedString *attributeString = [[NSMutableAttributedString alloc]
                                                      initWithString: NSLocalizedString(@"title-forgot-passcode-email-back", nil)];
        [attributeString addAttribute:NSUnderlineStyleAttributeName
                                value:[NSNumber numberWithInt:1]
                                range:(NSRange){0,[attributeString length]}];
        
        forgotLabel.attributedText = attributeString;
        promptLabel.text = NSLocalizedString(@"title-forgot-passcode-email", nil);

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
    //failedAttemptsLabel.hidden = YES;
    failedAttemptsLabel.text = @" ";
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
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    if (textField == emailTextField){
        printf("done");
    }
    return YES;
}
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    if (textField == emailTextField){
        return YES;
    }
    NSUInteger newLength = [textField.text length] + [string length] - range.length;
    return (newLength > 6) ? NO : YES;
}
    
- (void)showPassCodeSuccess {
    for (int i=0;i<6;i++) {
        _digitLabels[i].text = DashCharacter;
    }
}
- (void)setTitlePasscode:(NSString*) messageTitle{
    _enterPrompt = messageTitle;
    promptLabel.text = messageTitle;
    
}
- (void)showFailedMessage:(NSString*) messageError {
    messageLabel.hidden = YES;
    
    
    failedAttemptsLabel.text = messageError;
    [failedAttemptsLabel sizeToFit];
    
    for (int i=0;i<6;i++) {
        _digitLabels[i].text = BulletCharacter;
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
            
            _digitLabels[i].text = (i >= [text length]) ? BulletCharacter : DashCharacter;
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
