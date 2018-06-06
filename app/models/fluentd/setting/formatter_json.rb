class Fluentd
  module Setting
    class FormatterJson
      include Fluentd::Setting::Plugin

      register_plugin("formatter", "json")

      def self.initial_params
        {}
      end
    end
  end
end
