import {fromJS} from 'immutable';

export default fromJS([
  {
    id: 'AdvertisersAndCampaigns',
    name: 'Advertisers and Campaigns',
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
    id: 'Empty',
    name: 'Empty template',
    template: []
  }
]);