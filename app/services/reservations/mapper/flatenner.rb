module Reservations
  module Mapper
    module Flatenner

      #
      # This is use to make working with nested hash easier

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
      def create_simplified_hash_tree
        new_hash_tree = []
        @flat_params.keys.each do |key|
          exploded_key = key.to_s.split('.')
          leaf_nodes = exploded_key.last
          if exploded_key.length == 1
            new_hash_tree << new_hash_tree_field(key,leaf_nodes)
          else
            parent_nodes = exploded_key[0..exploded_key.length-2]
            new_hash_tree << new_hash_tree_field(key,leaf_nodes, parent_nodes)
          end
        end
        new_hash_tree
      end


      #
      # This is use to make working with nested hash easier
      # Flatten a hash
      # @param [Hash] hash
      # @return [Hash]
      #
      def flatten_hash(hash)
        hash.each_with_object({}) do |(k, v), h|
          if v.is_a? Hash
            flatten_hash(v).map do |h_k, h_v|
              h["#{k}.#{h_k}".to_sym] = h_v
            end
          else 
            h[k] = v
          end
         end
      end


    end
  end
end