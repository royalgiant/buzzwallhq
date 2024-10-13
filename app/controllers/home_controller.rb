class HomeController < ApplicationController
  def index
    @faqs = [
      {
        question: 'Do you have a free trial?',
        answer:
          'Yes, we have a free forever plan that allows you to try out the basic features.',
      },
      {
        question: 'Do you offer refunds?',
        answer: "Absolutely! We offer a 30 days full refund, from the time you get access, if you're not satisfied with the product. No questions asked!",
      },
      {
        question: 'Are there really no subscriptions?',
        answer:
          'Not for early-adopters. NEVER! For your belief in me, you will be grandfathered into our launch prices forever.',
      },
      {
        question: 'When will I start seeing reviews appear?',
        answer:
          'Once you add your keywords, BuzzwallHQ will start scanning to get the most recent reviews for those keywords. Typically you sill start seeing leads flow in within the first 48 hours.',
      },
      {
        question: "What's a 'Wall'?",
        answer:
          'A wall is where you showcase all your approved reviews. Each wall has an embed link that you can use to showcase your reviews on your website.',
      },
      {
        question:
          'Can you explain the "X approved reviews"?',
        answer:
          'We find your reviews for the given keywords. The ones you approve will be shown on your wall. Free plans will only show 9 approved reviews at a time per wall; subscribers can show unlimited approved reviews on a wall.',
      },
      {
        question: 'What are keywords tracked?',
        answer:
        'The # of keywords you can input into BuzzwallHQ to constantly track for new reviews. Each keyword will generate a list of reviews that you can approve or reject.',
      },
      {
        question: "What's the difference between Basic and Advanced Reviews Tracking",
        answer: "BuzzwallHQ's AI recommendation on who you should reach out to for sponsorship/collaborations + future tracking features are included in advanced. Basic will only ever track review performance.",
      },
      {
        question:
          'What is the 30% lifetime discount?',
        answer:
          "We're offering our first 50 customers a 30% lifetime discount off our launch price as a thank you for the early support! You will be grandfathered into these prices forever.",
      },
      {
        question:
          'Why don\'t I have access immediately?',
        answer:
          "In full transparency, we're in closed-beta. The product is still validating while we build out the features. We want to ensure we can provide the best experience for our early adopters and get feedback to improve our offerings. This is the best price you'll ever get for BuzzwallHQ. Lifetime deal will never be offered again.",
      },
  ]
  end
end
