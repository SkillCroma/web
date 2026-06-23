enum PageName {
  home('/home'),
  about('/about'),
  news('/news'),
  upcoming('/upcoming'),
  leaderboards('/leaderboards'),
  programmes('/programmes'),
  products('/products'),
  contact('/contact'),
  privacyPolicies('/privacyPolicies'),
  termsAndConditions('/termsAndConditions'),
  mail('/mail');

  final String name;
  const PageName(this.name);
}

enum SocialMediaTypes { twitter, linkedIn, instagram, facebook, youtube }

int subscriptionValue = 1000;
