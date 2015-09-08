import {fromJS} from 'immutable';

export default fromJS([
  {
    id: 'AdvertisersAndCampaigns',
    name: 'Basic - Fetch Advertisers and Campaigns',
    template: [
      {
        'endpoint': 'Advertiser/Advertisers',
        'params': [],
        'dataType': 'advertisers',
        'dataField': 'Advertisers',
        'children': [
          {
            'endpoint': 'Campaign/Campaigns?AdvertiserId={advertiserId}',
            'params': {
              'DateFrom': {
                'function': 'date',
                'args': [
                  'Y-m-d',
                  {
                    'time': 'previousStart'
                  }
                ]
              },
              'DateTo': {
                'function': 'date',
                'args': [
                  'Y-m-d',
                  {
                    'function': 'strtotime',
                    'args': [
                      '-1 day'
                    ]
                  }
                ]
              }
            },
            'dataType': 'campaigns',
            'dataField': 'Campaigns',
            'placeholders': {
              'advertiserId': 'Id'
            }
          }
        ]
      }
    ]
  },
  {
    id: 'All',
    name: 'Full - Fetch Advertisers, Campaigns, Campaign Stats and Users',
    template: [
      {
        'endpoint': 'Advertiser/Advertisers',
        'params': [],
        'dataType': 'advertisers',
        'dataField': 'Advertisers',
        'children': [
          {
            'endpoint': 'Campaign/Campaigns?AdvertiserId={advertiserId}',
            'params': {
              'DateFrom': {
                'function': 'date',
                'args': [
                  'Y-m-d',
                  {
                    'time': 'previousStart'
                  }
                ]
              },
              'DateTo': {
                'function': 'date',
                'args': [
                  'Y-m-d',
                  {
                    'function': 'strtotime',
                    'args': [
                      '-1 day'
                    ]
                  }
                ]
              }
            },
            'dataType': 'campaigns',
            'dataField': 'Campaigns',
            'placeholders': {
              'advertiserId': 'Id'
            },
            'children': [
              {
                'endpoint': 'CampaignStats/AdStats?campaignId={campaignId}',
                'params': {
                  'StartDate': {
                    'function': 'date',
                    'args': [
                      'Y-m-d',
                      {
                        'time': 'previousStart'
                      }
                    ]
                  },
                  'EndDate': {
                    'function': 'date',
                    'args': [
                      'Y-m-d',
                      {
                        'function': 'strtotime',
                        'args': [
                          '-1 day'
                        ]
                      }
                    ]
                  }
                },
                'dataType': 'adstats',
                'dataField': 'Campaign.Ads',
                'placeholders': {
                  'campaignId': 'Id'
                }
              }
            ]
          }
        ]
      },
      {
        'endpoint': 'User/Users',
        'dataType': 'users',
        'dataField': 'Users'
      }
    ]
  },
  {
    id: 'Empty',
    name: 'Empty - You\'ll configure what you want to fetch',
    template: []
  }
]);