module S2
  module Messages
    module MessageType
      ResourceManagerDetails = "ResourceManagerDetails"
    end

    # POWER_ENVELOPE_BASED_CONTROL: Identifier for the Power Envelope Based Control type
    # POWER_PROFILE_BASED_CONTROL: Identifier for the Power Profile Based Control type
    # OPERATION_MODE_BASED_CONTROL: Identifier for the Operation Mode Based Control type
    # FILL_RATE_BASED_CONTROL: Identifier for the Demand Driven Based Control type
    # DEMAND_DRIVEN_BASED_CONTROL: Identifier for the Fill Rate Based Control type
    # NOT_CONTROLABLE: Identifier that is to be used if no control is possible. Resources of
    # this type can still provide measurements and forecast
    # NO_SELECTION: Identifier that is to be used if no control type is or has been selected.
    module ControlType
      DemandDrivenBasedControl  = "DEMAND_DRIVEN_BASED_CONTROL"
      FillRateBasedControl      = "FILL_RATE_BASED_CONTROL"
      NoSelection               = "NO_SELECTION"
      NotControlable            = "NOT_CONTROLABLE"
      OperationModeBasedControl = "OPERATION_MODE_BASED_CONTROL"
      PowerEnvelopeBasedControl = "POWER_ENVELOPE_BASED_CONTROL"
      PowerProfileBasedControl  = "POWER_PROFILE_BASED_CONTROL"
    end

    # Currency to be used for all information regarding costs. Mandatory if cost information is
    # published.
    #
    # Currency used when this resource gives cost information
    module Currency
      Aed = "AED"
      Ang = "ANG"
      Aud = "AUD"
      Che = "CHE"
      Chf = "CHF"
      Chw = "CHW"
      Eur = "EUR"
      Gbp = "GBP"
      Lbp = "LBP"
      Lkr = "LKR"
      Lrd = "LRD"
      Lsl = "LSL"
      Lyd = "LYD"
      Mad = "MAD"
      Mdl = "MDL"
      Mga = "MGA"
      Mkd = "MKD"
      Mmk = "MMK"
      Mnt = "MNT"
      Mop = "MOP"
      Mro = "MRO"
      Mur = "MUR"
      Mvr = "MVR"
      Mwk = "MWK"
      Mxn = "MXN"
      Mxv = "MXV"
      Myr = "MYR"
      Mzn = "MZN"
      NIO = "NIO"
      Nad = "NAD"
      Ngn = "NGN"
      Nok = "NOK"
      Npr = "NPR"
      Nzd = "NZD"
      OMR = "OMR"
      PHP = "PHP"
      Pab = "PAB"
      Pen = "PEN"
      Pgk = "PGK"
      Pkr = "PKR"
      Pln = "PLN"
      Pyg = "PYG"
      Qar = "QAR"
      Ron = "RON"
      Rsd = "RSD"
      Rub = "RUB"
      Rwf = "RWF"
      SSP = "SSP"
      Sar = "SAR"
      Sbd = "SBD"
      Scr = "SCR"
      Sdg = "SDG"
      Sek = "SEK"
      Sgd = "SGD"
      Shp = "SHP"
      Sll = "SLL"
      Sos = "SOS"
      Srd = "SRD"
      Std = "STD"
      Syp = "SYP"
      Szl = "SZL"
      Thb = "THB"
      Tjs = "TJS"
      Tmt = "TMT"
      Tnd = "TND"
      Top = "TOP"
      Try = "TRY"
      Ttd = "TTD"
      Twd = "TWD"
      Tzs = "TZS"
      Uah = "UAH"
      Ugx = "UGX"
      Usd = "USD"
      Usn = "USN"
      Uyi = "UYI"
      Uyu = "UYU"
      Uzs = "UZS"
      Vef = "VEF"
      Vnd = "VND"
      Vuv = "VUV"
      Wst = "WST"
      XAG = "XAG"
      Xau = "XAU"
      Xba = "XBA"
      Xbb = "XBB"
      Xbc = "XBC"
      Xbd = "XBD"
      Xcd = "XCD"
      Xof = "XOF"
      Xpd = "XPD"
      Xpf = "XPF"
      Xpt = "XPT"
      Xsu = "XSU"
      Xts = "XTS"
      Xua = "XUA"
      Xxx = "XXX"
      Yer = "YER"
      Zar = "ZAR"
      Zmw = "ZMW"
      Zwl = "ZWL"
    end


    # ELECTRIC.POWER.L1: Electric power described in Watt on phase 1. If a device utilizes only
    # one phase it should always use L1.
    # ELECTRIC.POWER.L2: Electric power described in Watt on phase 2. Only applicable for 3
    # phase devices.
    # ELECTRIC.POWER.L3: Electric power described in Watt on phase 3. Only applicable for 3
    # phase devices.
    # ELECTRIC.POWER.3_PHASE_SYMMETRIC: Electric power described in Watt on when power is
    # equally shared among the three phases. Only applicable for 3 phase devices.
    # NATURAL_GAS.FLOW_RATE: Gas flow rate described in liters per second
    # HYDROGEN.FLOW_RATE: Gas flow rate described in grams per second
    # HEAT.TEMPERATURE: Heat described in degrees Celsius
    # HEAT.FLOW_RATE: Flow rate of heat carrying gas or liquid in liters per second
    # HEAT.THERMAL_POWER: Thermal power in Watt
    # OIL.FLOW_RATE: Oil flow rate described in liters per hour
    module CommodityQuantity
      ElectricPower3_PhaseSymmetric = "ELECTRIC.POWER.3_PHASE_SYMMETRIC"
      ElectricPowerL1               = "ELECTRIC.POWER.L1"
      ElectricPowerL2               = "ELECTRIC.POWER.L2"
      ElectricPowerL3               = "ELECTRIC.POWER.L3"
      HeatFlowRate                  = "HEAT.FLOW_RATE"
      HeatTemperature               = "HEAT.TEMPERATURE"
      HeatThermalPower              = "HEAT.THERMAL_POWER"
      HydrogenFlowRate              = "HYDROGEN.FLOW_RATE"
      NaturalGasFlowRate            = "NATURAL_GAS.FLOW_RATE"
      OilFlowRate                   = "OIL.FLOW_RATE"
    end

    # Commodity the role refers to.
    #
    # GAS: Identifier for Commodity GAS
    # HEAT: Identifier for Commodity HEAT
    # ELECTRICITY: Identifier for Commodity ELECTRICITY
    # OIL: Identifier for Commodity OIL
    module Commodity
      Electricity = "ELECTRICITY"
      Gas         = "GAS"
      Heat        = "HEAT"
      Oil         = "OIL"
    end

    # Role type of the Resource Manager for the given commodity
    #
    # ENERGY_PRODUCER: Identifier for RoleType Producer
    # ENERGY_CONSUMER: Identifier for RoleType Consumer
    # ENERGY_STORAGE: Identifier for RoleType Storage
    module RoleType
      EnergyConsumer = "ENERGY_CONSUMER"
      EnergyProducer = "ENERGY_PRODUCER"
      EnergyStorage  = "ENERGY_STORAGE"
    end

    class Role < Dry::Struct

      # Commodity the role refers to.
      attribute :commodity, Types::Commodity

      # Role type of the Resource Manager for the given commodity
      attribute :role, Types::RoleType

      def self.from_dynamic!(d)
        d = Types::Hash[d]
        new(
          commodity: d.fetch("commodity"),
          role:      d.fetch("role"),
        )
      end

      def self.from_json!(json)
        from_dynamic!(JSON.parse(json))
      end

      def to_dynamic
        {
          "commodity" => commodity,
          "role"      => role,
        }
      end

      def to_json(options = nil)
        JSON.generate(to_dynamic, options)
      end
    end

    class ResourceManagerDetails < Dry::Struct

      # The control types supported by this Resource Manager.
      attribute :available_control_types, Types.Array(Types::ControlType)

      # Currency to be used for all information regarding costs. Mandatory if cost information is
      # published.
      attribute :currency, Types::Currency.optional

      # Version identifier of the firmware used in the device (provided by the manufacturer)
      attribute :firmware_version, Types::String.optional

      # The average time the combination of Resource Manager and HBES/BACS/SASS or (Smart) device
      # needs to process and execute an instruction
      attribute :instruction_processing_delay, Types::Integer

      # Name of Manufacturer
      attribute :manufacturer, Types::String.optional

      # ID of this message
      attribute :message_id, Types::String

      attribute :message_type, Types::MessageType

      # Name of the model of the device (provided by the manufacturer)
      attribute :model, Types::String.optional

      # Human readable name given by user
      attribute :resource_manager_details_name, Types::String.optional

      # Indicates whether the ResourceManager is able to provide PowerForecasts
      attribute :provides_forecast, Types::Bool

      # Array of all CommodityQuantities that this Resource Manager can provide measurements for.
      attribute :provides_power_measurement_types, Types.Array(Types::CommodityQuantity)

      # Identifier of the Resource Manager. Must be unique within the scope of the CEM.
      attribute :resource_id, Types::String

      # Each Resource Manager provides one or more energy Roles
      attribute :roles, Types.Array(Role)

      # Serial number of the device (provided by the manufacturer)
      attribute :serial_number, Types::String.optional

      def self.from_dynamic!(d)
        d = Types::Hash[d]
        new(
          available_control_types:          d.fetch("available_control_types"),
          currency:                         d["currency"],
          firmware_version:                 d["firmware_version"],
          instruction_processing_delay:     d.fetch("instruction_processing_delay"),
          manufacturer:                     d["manufacturer"],
          message_id:                       d.fetch("message_id"),
          message_type:                     d.fetch("message_type"),
          model:                            d["model"],
          resource_manager_details_name:    d["name"],
          provides_forecast:                d.fetch("provides_forecast"),
          provides_power_measurement_types: d.fetch("provides_power_measurement_types"),
          resource_id:                      d.fetch("resource_id"),
          roles:                            d.fetch("roles").map { |x| Role.from_dynamic!(x) },
          serial_number:                    d["serial_number"],
        )
      end

      def self.from_json!(json)
        from_dynamic!(JSON.parse(json))
      end

      def to_dynamic
        {
          "available_control_types"          => available_control_types,
          "currency"                         => currency,
          "firmware_version"                 => firmware_version,
          "instruction_processing_delay"     => instruction_processing_delay,
          "manufacturer"                     => manufacturer,
          "message_id"                       => message_id,
          "message_type"                     => message_type,
          "model"                            => model,
          "name"                             => resource_manager_details_name,
          "provides_forecast"                => provides_forecast,
          "provides_power_measurement_types" => provides_power_measurement_types,
          "resource_id"                      => resource_id,
          "roles"                            => roles.map { |x| x.to_dynamic },
          "serial_number"                    => serial_number,
        }
      end

      def to_json(options = nil)
        JSON.generate(to_dynamic, options)
      end
    end
  end
end
