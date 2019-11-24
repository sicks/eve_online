# frozen_string_literal: true

module EveOnline
  module ESI
    class UniverseConstellations < Base
      API_PATH = "/v1/universe/constellations/"

      def constellation_ids
        response
      end

      def scope
      end

      def path
        API_PATH
      end
    end
  end
end
