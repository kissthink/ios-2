#import <Google/Analytics.h>
#import "ReportProblemViewController.h"
#import "ReportDetailViewController.h"

@interface ReportProblemViewController ()

@property (nonatomic) NSArray *problems;

@end

@implementation ReportProblemViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.problems = @[@{ @"descricao": NSLocalizedString(@"REPORT_LINE_NOT_FOUND", nil), @"tipo": @"prefeitura" },
                      @{ @"descricao": NSLocalizedString(@"REPORT_WRONG_LOCATION", nil), @"tipo": @"prefeitura" },
                      @{ @"descricao": NSLocalizedString(@"REPORT_WRONG_ITINERARY", nil), @"tipo": @"prefeitura" },
                      @{ @"descricao": NSLocalizedString(@"REPORT_APP_ISSUES", nil), @"tipo": @"app" },
                      @{ @"descricao": NSLocalizedString(@"REPORT_OTHER", nil), @"tipo": @"outro" }];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    id<GAITracker> tracker = [[GAI sharedInstance] defaultTracker];
    [tracker set:kGAIScreenName value:@"Reportar problema"];
    [tracker send:[[GAIDictionaryBuilder createScreenView] build]];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"ShowReportDetail"]) {
        ReportDetailViewController *detailViewController = segue.destinationViewController;
        
        NSIndexPath *problemIndexPath = [self.tableView indexPathForSelectedRow];
        detailViewController.problem = self.problems[problemIndexPath.row];
        
        [self.tableView deselectRowAtIndexPath:problemIndexPath animated:YES];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


#pragma mark - IBActions

- (IBAction)didTapCloseButton:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}


#pragma mark - UITableViewDataSource methods

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.problems.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *simpleTableIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:simpleTableIdentifier];
    }
    
    cell.textLabel.text = self.problems[indexPath.row][@"descricao"];
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    
    return cell;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return NO;
}


#pragma mark UITableViewDelegate methods

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 80;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    NSMutableParagraphStyle *style =  [[NSParagraphStyle defaultParagraphStyle] mutableCopy];
    style.firstLineHeadIndent = 15.0;
    style.headIndent = 15.0;
    style.tailIndent = -15.0;
    style.lineSpacing = 1.5;
    
    NSAttributedString *attrText = [[NSAttributedString alloc] initWithString:NSLocalizedString(@"REPORT_TYPE_HEADER_TITLE", @"Header of the table view of the 'Report issue' screen")
                                                                   attributes:@{ NSParagraphStyleAttributeName: style}];

    UILabel *lblSectionName = [[UILabel alloc] init];
    lblSectionName.attributedText = attrText;
    lblSectionName.numberOfLines = 0;
    lblSectionName.lineBreakMode = NSLineBreakByWordWrapping;
    lblSectionName.textColor = [UIColor colorWithWhite:0.36 alpha:1.0];
    lblSectionName.backgroundColor = self.tableView.backgroundColor;

    return lblSectionName;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [self performSegueWithIdentifier:@"ShowReportDetail" sender:self];
}

@end
