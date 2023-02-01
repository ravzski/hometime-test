module Reservations
  module Mapper
    module Flatenner

      #
      # This is use to make working with nested hash easier
      #
      def simplified_hash_tree
        new_hash_tree = []
        @flat_params_keys.each do |key|
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