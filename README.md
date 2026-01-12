# S2 Ruby

[![Tests](https://github.com/stekker/s2-ruby/actions/workflows/ci.yml/badge.svg)](https://github.com/stekker/s2-ruby/actions/workflows/ci.yml)
[![License](https://img.shields.io/badge/License-Apache%202.0-blue.svg)](LICENSE.txt)
[![Ruby](https://img.shields.io/badge/Ruby-3.3+-red.svg)](s2-ruby.gemspec)

Ruby implementation of the [S2 standard](https://s2standard.org/) (EN 50491-12-2) for smart grid energy flexibility.

## About S2

S2 is the European standard for communication between Customer Energy Managers (CEM) and Resource Managers (RM). It enables demand-response and flexible power control for devices like EV chargers, heat pumps, and home batteries. Essential for balancing the grid as we electrify our homes and integrate more renewable energy.

This library implements the S2 protocol for the **Resource Manager** role, allowing devices to communicate their energy flexibility to energy management systems.

## Features

- WebSocket-based communication with automatic reconnection
- Full message validation using JSON schemas from the S2 specification
- Support for Fill Rate Based Control (FRBC) - ideal for battery and EV charging
- Extensible message handler pattern for custom business logic
- Built on async Ruby for efficient concurrent connections

## Protocol version

This library implements **S2 version 0.0.2-beta**.

## Installation

Add to your Gemfile:

```ruby
gem "s2-ruby"
```

Or install directly:

```bash
gem install s2-ruby
```

## Usage

### Basic setup

```ruby
require "s2"

# Configure logging (optional)
S2.logger = Logger.new($stdout)

# Set supported protocol versions (optional, defaults to ["0.0.2-beta"])
S2.supported_protocol_versions = ["0.0.2-beta"]
```

### Creating a custom message handler

```ruby
class MyMessageHandler < S2::MessageHandler
  on S2::Messages::HandshakeResponse do |message|
    # Handle handshake response
  end

  on S2::Messages::SelectControlType do |message|
    # Handle control type selection
  end
end

S2.message_handler_class = MyMessageHandler
```

### Connecting to an S2 endpoint

```ruby
Async do |task|
  connection = S2::Connection.new(
    resource_id: "my-resource-id",
    task: task,
    ws_url: "wss://example.com/s2"
  )

  connection.connect
end
```

### Working with messages

```ruby
# Parse incoming message
message = S2::MessageFactory.create_message(json_string)

# Create outgoing message
handshake = S2::Messages::Handshake.new(
  message_id: SecureRandom.uuid,
  message_type: S2::Messages::HandshakeMessageType::Handshake,
  role: S2::Messages::EnergyManagementRole::Rm,
  supported_protocol_versions: ["0.0.2-beta"]
)

json = handshake.to_json
```

## Supported message types

- Handshake / HandshakeResponse
- ResourceManagerDetails
- SelectControlType
- PowerForecast / PowerMeasurement
- ReceptionStatus
- InstructionStatusUpdate
- RevokeObject
- SessionRequest
- FRBC (Fill Rate Based Control) messages:
  - SystemDescription, StorageStatus, ActuatorStatus
  - Instruction, UsageForecast, FillLevelTargetProfile
  - LeakageBehaviour, TimerStatus

## Architecture

```
┌─────────────────────┐       WebSocket       ┌─────────────────┐
│   Your Application  │◄─────────────────────►│   CEM Server    │
│  (Resource Manager) │ ← Your custom logic   │                 │
└──────────┬──────────┘                       └─────────────────┘
           │
           ▼
┌─────────────────────┐
│ S2::Connection      │ ← Manages WebSocket lifecycle
│ S2::Session         │ ← Handles protocol state
│ S2::MessageHandler  │
└─────────────────────┘
```

## Development

```bash
bundle install
bundle exec rspec
bundle exec rubocop
```

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/stekker/s2-ruby.

## About Stekker

[Stekker](https://stekker.com) is a smart charging service provider offering AI-powered, grid-aware EV charging solutions. We help partners optimize charging schedules based on solar energy, grid capacity, and dynamic energy prices, enabling growth within grid limits. This library is part of our commitment to open standards like S2, OCPP, and OpenADR.

## License

This gem is available as open source under the [Apache License 2.0](LICENSE.txt).

## Links

- [S2 Standard](https://s2standard.org/)
- [S2 Documentation](https://docs.s2standard.org/)
- [EN 50491-12-2](https://standards.iteh.ai/catalog/standards/clc/6c89cfc7-4f3c-429e-9c75-62307b1572ab/en-50491-12-2-2022)
