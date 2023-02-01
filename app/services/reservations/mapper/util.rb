module Reservations
  module Mapper
    module Util
      

      # sets the threshold for lev distance on strings
      # lev distance <= 2 is considered a match
      # the lower the threshold, the more strict the match
      # the higher the threshold, the more lenient the match
      # eg. first_name could be firstname or firstnme
      LEV_DISTANCE_THRESHOLD = 2

      # since we are only mapping reservation and guest
      # if in the future, another model is to be mapped,
      # this array needs to be updated
      PARENT_FIELDS = %w(
        guest
        reservation
      )

      # list of fields that are not to be mapped
      # these fields are mapped because if a heustic is used to find the closest match
      # it might cause some issues
      SPECIAL_MAPPED_FIELDS = {
        listing_security_price_accurate: 'security_price',
        expected_payout_amount: 'payout_price',
        total_paid_amount_accurate: 'total_price',
        total_price: 'total_price',
        status_type: 'status',
        phone: 'phone_numbers'
      }.with_indifferent_access

      # list of fields that are to be mapped
      # eg. number_of_infants to be mapped to infants
      PREFIX_MAPPED_FIELDS = %w(
        number_of
        host
      )

      private

      #
      # populate the result hash with the mapped values
      # possible to add singalurize and pluralize here
      #
      def parent_child_key_permutation(parent_field_key)
        [
          parent_field_key,
          "#{parent_field_key}_details",
          "details_#{parent_field_key}"
        ]
      end

      #
      # @param [Hash] node - of type new_hash_tree_field
      # @param [Symbol] parent_field_key - this is either reservation or guest
      # @return [Hash] - This new hash is the result of the mapping process
      # The result is either a reservation or guest or nil
      #
      def find_parent_association(node,parent_field_key)
        matching_parent_node = []
        parent_child_key_permutation(parent_field_key).map do |key|
          node[:parent_nodes].each do |parent_node|
            matching_parent_node << parent_field_key if is_node_associated?(parent_node,key)
          end
        end
        # this could change if we add more parent fields
        # eg. if we add host, then we would need to add a new condition
        # the priority here is guest > reservation
        # if parent_node has guest, then it is a guest
        return nil if matching_parent_node.blank?
        matching_parent_node.include?('guest') ? 'guest' : 'reservation'
      end

      #
      # check if the parent node is associated with the key
      # this is done by checking if the parent node is the same as the key
      # or if the parent node is within the threshold of the key
      #
      def is_node_associated?(parent_node,key)
        parent_node.include?(key.to_s) ||
        parent_node == key.to_s ||
        @dl.distance(parent_node.to_s, key.to_s) <= LEV_DISTANCE_THRESHOLD
      end

      #
      # @param [Hash] node - of type new_hash_tree_field
      # @param [key] parent_field_key - is the basic field of reservation/guest (eg. start_date)
      # @return [Hash] - This new hash is the result of the mapping process
      #
      def new_hash_tree_field(key, leaf_node, parent_nodes=nil)
        {
          parent_nodes: clean_parent_nodes(parent_nodes,leaf_node),
          leaf_node: clean_leaf_node(leaf_node),
          value: @flat_params[key],
        }
      end

      #
      # @param [Array] parent_nodes - array of parent nodes
      # @param [String] leaf_node - the leaf node
      # @return [Array] - This new array is the result of the mapping process
      # This is use to clean the parent nodes
      # eg. if the leaf node is guest_first_name, then we add guest to the parent nodes
      #
      def clean_parent_nodes(parent_nodes,leaf_node)
        parent_nodes = ['reservation'] if parent_nodes.blank?
        leaf_node.split('_').each do |exploded_leaf_node|
          PARENT_FIELDS.each do |parent_field|
            # if the leaf node has a parent field, then add it to the parent nodes
            # eg. guest_first_name => parent_nodes = ['guest']
            if exploded_leaf_node.include?(parent_field)
              parent_nodes << parent_field 
            end
          end
        end

        # removes details_ or _details
        parent_nodes.each_with_index do |node,index|
          parent_nodes[index] = node.gsub('details_','').gsub('_details','')
        end
        parent_nodes.uniq
      end

      #
      # removes guest_ and _guest from the leaf node
      # removes reservation_ and _reservation from the leaf node
      # pluralize and singularize could be added later on
      #
      def clean_leaf_node(leaf_node)
        PARENT_FIELDS.each do |parent_field|
          leaf_node.gsub!("#{parent_field}_", "")
          leaf_node.gsub!("_#{parent_field}", "")
        end

        # if leafnode is special, then return the special field
        special_field = SPECIAL_MAPPED_FIELDS[leaf_node]
        return special_field if special_field.present?

        # if leafnode has a special prefix, then remove the prefix
        PREFIX_MAPPED_FIELDS.each do |prefix|
          leaf_node.gsub!("#{prefix}_", "") if leaf_node.include?(prefix)
        end
        leaf_node
      end

    end
  end
end