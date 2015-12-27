import requests import os


BASE_URL = 'http://api:3000' DATA_DIR = '/data'


if __name__ == '__main__': response = requests.get(BASE_URL + '/communities')

    with open(os.path.join(DATA_DIR, 'communities.json'), 'w') as f:
        f.write(response.text)

    community_dir = os.path.join(DATA_DIR, 'communities') if not
    os.path.exists(community_dir): os.makedirs(community_dir)

    for community in response.json(): community_url =
    '{0}/communities/{1}'.format(BASE_URL, community['community_id'])
        community_data = requests.get(community_url)
        with open(os.path.join(DATA_DIR, community_dir, '{0}.json'.format(community['community_id'])), 'w') as f:
            f.write(community_data.text)
