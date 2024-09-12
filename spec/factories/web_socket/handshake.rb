FactoryBot.define do
  factory :web_socket_handshake, class: "EventMachine::WebSocket::Handshake" do
    initialize_with { instance_double(EventMachine::WebSocket::Handshake, **attributes) }
    path { "/rm/123" }
  end
end
