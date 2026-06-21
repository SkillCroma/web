enum pageName {
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
  const pageName(this.name);
}

enum socialMediaTypes { twitter, linkedIn, instagram, facebook, youtube }

var subscriptionValue = 1000;
