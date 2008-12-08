class ActiveRecord::Base

  named_scope :ids,   :select => 'id'
  named_scope :lock,  :lock => true
  named_scope :ro,    :readonly => true

  ##
  # named_scope_in provides an easy way to define scopes.
  #
  # Example setup:
  #   class Foo < ActiveRecord::Base
  #     belongs_to :bar
  #     named_scope_in :bar
  #   end
  #
  # Typical use:
  #   foo.bar_in(1,2,3).all => foos where bar_id in [1,2,3]
  #   foo.bar_in(a,b,c).all => foos where bar_id in [a.id,b.id,c.id]
  #
  # Typical use with arrays:
  #   foo.bar_in([1,2,3]).all => foos where bar_id in [1,2,3]
  #   foo.bar_in([a,b,c]).all => foos where bar_id in [a.id,b.id,c.id]
  #
  # To skip the scope, use nil:
  #   foo.bar_in(nil).all => foos
  #
  # To find nils, use an array of nil:
	#   foo.bar_in([nil]) => foos where bar_id==nil
  #
  # To find using a different field name:
  #   class Foo < ActiveRecord::Base
  #     belongs_to :bar, :through => :baz
  #     named_scope_in :bar, :baz_id
  #   end
  ##

	def self.named_scope_in(name, field = "#{name}_id", options = {})
		named_scope "#{name}_in", lambda { |*x|
			if !x.nil?
			  new_cond = "#{field} in (?)"
				if options[:conditions]
					cond = options[:conditions].to_a
					cond[0] = "((#{cond[0]}) AND (#{new_cond}))"
					cond << x
					options[:conditions] = cond
				else
					options[:conditions] = [new_cond, x]
				end
			end
			options
    }
	end

end