enum PageName {
  home('/home'),
  about('/about'),
  upcoming('/upcoming'),
  leaderboards('/leaderboards'),
  products('/products'),
  contact('/contact'),
  privacyPolicies('/privacyPolicies'),
  termsAndConditions('/termsAndConditions'),
  mail('/mail');

  final String route;
  const PageName(this.route);
}

enum SocialMediaTypes { twitter, linkedIn, instagram, facebook, youtube }

int subscriptionValue = 1000;
