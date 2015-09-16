module.exports =
  languageOptions: [
      label: 'English',
      value: 'en'
  ,
      label: 'Czech',
      value: 'cs'
  ]

  analysisTypes:

    entities:
      name: 'Extract Entities',
      description: 'Search your texts for names of people, locations, products, dates, account numbers, etc. \
We can adjust the detectors to your needs (e.g. taking into account your products) or even identify a new type of entity \
whether it should be financial products or offending expressions.'

    hashtags:
      name: 'Hashtagging',
      description: 'Engage Your Customers with 5 Labels, make them curious to want more of your content. \
      The objective of a hashtag is to describe the content of a text whether an email, commercial contract, or a yellow press article. \
      A hashtag can be cancel subscription, safe car, or terrible cook.\
      Again, we can adjust hashtags to your domain, to your needs.'

    topic:
      name: 'Identify topic',
      description: 'Detect a broad topic of any text (News, Sport, Technology, Art, …). \
      We can train a custom model assigning exactly the categories you need (support, billing, cancelations, …).'

    language:
      name: 'Identify language',
      description: 'Detect the language of a text. \
      Currently distinguishes English and Czech, tens of languages coming soon.'

    lemmatize:
      name: 'Lemmatize',
      description: 'Turn all the words into their dictionary forms. \
      For example, for I saw him going home the result is I see he go home. \
      This makes your text easier to process, whether you want to find keywords, \
      apply prediction or clustering algorithms.'

    correction:
      name: 'Add diacritics',
      description: 'For Czech texts without diacritics, ads all the wedges and accents. \
      For example, for Muj ctyrnohy pritel > Můj čtyřnohý přítel.'

    sentiment:
      name: 'Detect Sentiment',
      description: 'Detect the emotions contained in the text. \
      Was the author happy (I loved it.), neutral (We left on Tuesday.), \or unhappy (The lunch was not good at all.) with their experience? You can detect sentiment of reviews, feedback or customer service inquiries. \
      The model can be tuned to a particular domain if needed.'
