class Poster < ApplicationRecord
    def self.sorted_by_created_at(sort_order)
        order(created_at: sort_order.to_sym)
      end
    
      def self.filtered_by_name(name)
        where("name ILIKE ?", "%#{name}%")
      end
    
      def self.filtered_by_min_price(min_price)
        where("price >= ?", min_price)
      end
    
      def self.filtered_by_max_price(max_price)
        where("price <= ?", max_price)
      end
end