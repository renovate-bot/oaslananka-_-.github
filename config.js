module.exports = {
  platform: 'github',
  endpoint: 'https://api.github.com/',
  autodiscover: true,
  autodiscoverFilter: [
    'oaslananka/*',
    'oaslananka-dev/*',
    'oaslananka-mobil-dev/*',
    'sismosmart-dev/*',
  ],
  onboarding: true,
  requireConfig: 'optional',
  onboardingConfig: {
    extends: ['github>oaslananka/.github:renovate-config'],
  },
  extends: ['github>oaslananka/.github:renovate-config'],
  branchPrefix: 'self-hosted-renovate/',
  platformCommit: 'enabled',
  repositoryCache: 'enabled',
  gitAuthor: 'Renovate Bot <bot@renovateapp.com>',
  suppressNotifications: ['prIgnoreNotification'],
};
