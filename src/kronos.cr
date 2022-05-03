require "sqlite3"
require "uuid"

if File.file?("./data.db") == false
  puts "DB does not exists, creating..."
  DB.open "sqlite3://./data.db" do |db|
    db.exec "CREATE TABLE logs (id VARCHAR(37), user VARCHAR(255), log TEXT, timestamp INTEGER);"
    db.exec "CREATE UNIQUE INDEX logs_id on logs(id);"
    db.exec "CREATE INDEX logs_user on logs(user);"
    db.exec "CREATE INDEX logs_timestamp on logs(timestamp);"
  end
  puts "DB is created, relaunch to start injecting data"
  exit(0)
end
DB.open "sqlite3://./data.db" do |db|
  db.exec "BEGIN TRANSACTION;"
  users = ["Pierre", "Loic", "Galina", "Ivan", "Florent"]
  i = 0
  while i < 5_000_000
    puts i
    db.exec "insert into logs values (?, ?, ?, ?)", UUID.random.to_s, users.sample, Random::Secure.urlsafe_base64(128, padding: true), Time.utc().to_unix
    i += 1
  end
  db.exec "COMMIT;"
end
