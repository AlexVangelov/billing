module ActiveRecord
  module Associations
    class CollectionProxy < Relation
      def wild(*args)
        @association.build(klass.wild_args(*args))
      end
    end
  end
end