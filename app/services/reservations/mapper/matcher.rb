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
        adults
        children
        infants
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
        description
        last_name
        phone_numbers
        email
      )
      
      #
      # @param [Hash] params
      # @return [Hash] - This new hash is the result of the mapping process
      #
      def initialize(params)
        @reservation_fields = RESERVATION_FIELDS.dup
        @guest_fields = GUEST_FIELDS.dup
        @params = params
        @flat_params = flatten_hash(params)
        @flat_params_keys = @flat_params.keys
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

      # given: 
      # {
      #   "reservation": {
      #     "code": "XXX12345678",
      #     "start_date": "2021-03-12",
      #     "end_date": "2021-03-16",
      #     "expected_payout_amount": "3800.00",
      #     "guest_details": {
      #       "localized_description": "4 guests",
      #       "number_of_adults": 2,
      #       "number_of_children": 2,
      #       "number_of_infants": 0
      #     },
      #     "guest_email": "wayne_woodbridge@bnb.com",
      #     "guest_first_name": "Wayne",
      #     "guest_last_name": "Woodbridge",
      #     "guest_phone_numbers": [
      #       "639123456789",
      #       "639123456789"
      #     ],
      #     "listing_security_price_accurate": "500.00",
      #     "host_currency": "AUD",
      #     "nights": 4,
      #     "number_of_guests": 4,
      #     "status_type": "accepted",
      #     "total_paid_amount_accurate": "4300.00"
      # } }
      # will result to
      # [{:parent_nodes=>["reservation"], :leaf_node=>"code", :value=>"XXX12345678"},
      # {:parent_nodes=>["reservation"], :leaf_node=>"start_date", :value=>"2021-03-12"},
      # {:parent_nodes=>["reservation"], :leaf_node=>"end_date", :value=>"2021-03-16"},
      # {:parent_nodes=>["reservation"], :leaf_node=>"expected_payout_amount", :value=>"3800.00"},
      # {:parent_nodes=>["reservation", "guest_details"], :leaf_node=>"localized_description", :value=>"4 guests"},
      # {:parent_nodes=>["reservation", "guest_details"], :leaf_node=>"number_of_adults", :value=>2},
      # {:parent_nodes=>["reservation", "guest_details"], :leaf_node=>"number_of_children", :value=>2},
      # {:parent_nodes=>["reservation", "guest_details"], :leaf_node=>"number_of_infants", :value=>0},
      # {:parent_nodes=>["reservation", "guest"], :leaf_node=>"email", :value=>"wayne_woodbridge@bnb.com"},
      # {:parent_nodes=>["reservation", "guest"], :leaf_node=>"first_name", :value=>"Wayne"},
      # {:parent_nodes=>["reservation", "guest"], :leaf_node=>"last_name", :value=>"Woodbridge"},
      # {:parent_nodes=>["reservation", "guest"], :leaf_node=>"phone_numbers", :value=>["639123456789", "639123456789"]},
      # {:parent_nodes=>["reservation"], :leaf_node=>"listing_security_price_accurate", :value=>"500.00"},
      # {:parent_nodes=>["reservation"], :leaf_node=>"host_currency", :value=>"AUD"},
      # {:parent_nodes=>["reservation"], :leaf_node=>"nights", :value=>4},
      # {:parent_nodes=>["reservation", "guest"], :leaf_node=>"number_ofs", :value=>4},
      # {:parent_nodes=>["reservation"], :leaf_node=>"status_type", :value=>"accepted"},
      # {:parent_nodes=>["reservation"], :leaf_node=>"total_paid_amount_accurate", :value=>"4300.00"}]
      #
      def match_payload
        # guest could be an array of guest if requirement permits
        new_hash_tree = simplified_hash_tree()
        raise InvalidPayload if new_hash_tree.blank?
        new_hash_tree.each do |node|
          find_and_assign_associated_match(node)
        end
        @result
      rescue InvalidPayload=>e
        puts e.message
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
          parent_association = find_parent_association(node,parent_field)
          next if parent_association.nil?    
          @result[parent_association][node[:leaf_node]] = node[:value] 
          return    
        end
      end

      #
      # This will find first if the key has an exact value of the base field
      #
      # def find_simple_match(node)
      #   # simplest case, the key is already in the reservation_fields
      #   if @reservation_fields.include?(node[:leaf_node])
      #     @result[:reservation][node[:lead_node]] = node[:value]
      #     return true
      #   end

      #   if @guest_fields.include?(node[:leaf_node])
      #     @result[:guest][node][:lead_node] = field[:value]
      #     return true
      #   end
      #   retur nil
      # end

    end
  end
end