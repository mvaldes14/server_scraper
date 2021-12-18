# Scraper to see if new servers are posted
1. Creates its own sqlite db to keep track of things
2. Notifies if new entries are added via telegram
3. Stores internal log
4. Secrets are stored in ENV variables

**Dummy project so I could practice some Ruby**

# Requirements
- gem "pry"
- gem "nokogiri"
- gem 'httparty', '~> 0.20.0'
- gem "sqlite3", "~> 1.4"
- gem "telebot", "~> 0.1.2"