FactoryBot.define do
  sequence :uuid do |_n|
    SecureRandom.uuid
  end
end
