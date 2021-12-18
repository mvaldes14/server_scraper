require 'httparty'
require 'nokogiri'
require 'sqlite3'
require 'telebot'
require 'logger'

# Init DB
db = SQLite3::Database.open 'tracker.db'
db.execute 'CREATE TABLE IF NOT EXISTS products(product TEXT, added TEXT)'
db.results_as_hash = true

# Define Log
log = Logger.new('scraper.log')
log.level = Logger::INFO

# Telegram settings
token = ENV['TELEGRAM_TOKEN']
chat_id = ENV['TELEGRAM_CHAT']
if token.nil?
  log.fatal 'Token not loaded, aborting'
  abort
end
client = Telebot::Client.new(token)

# Check if client started correctly
if client.get_me.nil?
  log.error 'Bot not initialized'
end

# Scrape results from site
log.info "Starting script at: #{Time.now}"
url = 'https://www.freegeektwincities.org/computers'
request = HTTParty.get(url)
html = Nokogiri::HTML(request)
products = html.css('.ProductList-title')
log.info "Found #{products.length} products in site"

# Validate and Save
products.children.each do |p|
  check_if_db = db.query 'SELECT * FROM products WHERE product = ?', p.inner_text
  log.info "Checking if #{p.inner_text} exists in the database"
  if check_if_db.count.zero?
    # Save to DB, notify and log
    log.info "Server added to DB: #{p.inner_text}"
    client.send_message(chat_id: chat_id, text: "NEW SERVER POSTED:#{p.inner_text}")
    db.execute 'INSERT INTO products(product, added) VALUES (?,?)', p.inner_text, Time.now.to_s
  else
    log.info 'Server already in the db, skipping'
  end
end
