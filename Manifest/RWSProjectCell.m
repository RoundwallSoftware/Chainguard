//
//  RWSListCell.m
//  Manifest
//
//  Created by Samuel Goodwin on 27-01-14.
//
//

#import "RWSProjectCell.h"

@interface RWSProjectCell()
@property (nonatomic, weak) IBOutlet UILabel *titleLabel;
@property (nonatomic, weak) IBOutlet UILabel *subtitleLabel;
@property (nonatomic, weak) IBOutlet UIImageView *squareImageView;
@end

@implementation RWSProjectCell

- (void)setList:(id<RWSProject>)project
{
    self.titleLabel.text = [project title];

    NSString *priceString = [project formattedTotalRemainingPrice];
    self.subtitleLabel.text = priceString;

    UIImage *image = [project imageFromParts];
    self.squareImageView.image = image;

    if(image){
        self.accessoryType = UITableViewCellAccessoryNone;
    } else {
        self.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
}

@end
