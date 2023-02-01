module Reservations
  module Mapper
    class Matcher
      include Util
      include Flatenner
      include Exceptions

      # fields that are required for reservation
      # these are the only fields to be mapped
      RESERVATION_FIELDS = %w(
        code
        start_date
        end_date
        nights
        guests
        security_price
        total_price
        payout_price
        currency
        status
      )

      # fields that are required for guests
      # these are the only fields to be mapped
      GUEST_FIELDS = %w(
        first_name
        localized_description
        last_name
        phone_numbers
        email
        adults
        children
        infants
      )
      
      CROSSOVER_FIELDS = %w(
        adults
        children
        infants
      )

      attr_reader :result

      #
      # @param [Hash] params
      # @return [Hash] - This new hash is the result of the mapping process
      #
      def initialize(params)
        @flat_params = flatten_hash(params)
        @simplified_tree = create_simplified_hash_tree()
        @dl = DamerauLevenshtein
        @result = {
          reservation: {},
          guest: {}
        }.with_indifferent_access
      end

      #
      # @return [Hash] - This new hash is the result of the mapping process
      # What this does it:
      # - find all the leaf nodes of the hash (because these are the values)
      # - and store all parent keys of the leaf nodes into parent_nodes key
      # - then iterate through the parent_nodes key
      # - and for each parent node, find the corresponding key in the params
      # - and then map the value to the corresponding key in the new hash

      def match_payload
        # guest could be an array of guest if requirement permits
        raise InvalidPayload if @simplified_tree.blank?

        @simplified_tree.each do |node|
          find_and_assign_associated_match(node)
        end
        map_crossover_fields()
        @result
      rescue InvalidPayload=>e
        e.message
      end

      #
      # @return [Array] - This new array is the result of the mapping process
      # - map out CROSSOVER_FIELDS from guest to reservations
      # - because these fields are common to both reservation and guest
      # - and we want to keep the reservation fields in the reservation table
      #
      def map_crossover_fields
        @result['guest'].keys.each do |t|
          if CROSSOVER_FIELDS.include?(t)
            @result['reservation'][t] = @result['guest'][t] 
            @result['guest'].delete(t)
          end
        end
      end

      #
      # @param [Hash] node - the node to be searched
      # This method will find the parent association of the node
      # given the node: 
      # {:parent_nodes=>["reservation", "guest"], :leaf_node=>"email", :value=>"test@test.com"
      # it will assign the value to the @result[:guest][:email] = "test@test.com
      #
      def find_and_assign_associated_match(node)
        return unless (RESERVATION_FIELDS+GUEST_FIELDS).include?(node[:leaf_node])

        PARENT_FIELDS.each do |parent_field|
          # skips fields that not in the constants
          next unless self.class.const_get("#{parent_field.upcase}_FIELDS").include?(node[:leaf_node])
          
          next unless node[:parent_nodes].include?(parent_field)
          parent_association = find_parent_association(node,parent_field)
          next if parent_association.nil?    
          @result[parent_association][node[:leaf_node]] = node[:value] 
          return    
        end        
      end

    end
  end
end