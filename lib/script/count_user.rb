class UserCounter
    def self.count
        User.all.each do |user|
            puts "name: #{user.name}, email: #{user.email}"
        end
    end
end

UserCounter.count