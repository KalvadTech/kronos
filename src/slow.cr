require "sqlite3"
require "uuid"

DB.open "sqlite3://./data.db" do |db|
  users = ["Pierre", "Loic", "Galina", "Ivan", "Florent"]
  i = 0
  while i < 1_000_000
    puts i
    uuid =  UUID.random.to_s
    puts uuid
    db.exec "insert into logs values (?, ?, ?, ?)", uuid, users.sample, Random::Secure.urlsafe_base64(128, padding: true), Time.utc().to_unix
    i += 1
  end
end
