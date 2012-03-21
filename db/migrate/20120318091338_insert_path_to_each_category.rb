class InsertPathToEachCategory < ActiveRecord::Migration
  def up
    higher_categories = Category.where(:category_id => nil)
    higher_categories.each do |elem|
      elem.path = "#{elem.id.to_s}."
      elem.save!(:validate => false)
      insert_path(elem)
    end
  end

  def down
    categories = Category.all
    categories.each { |c|
      c.path = ""
      c.save!(:validate => false)
    }
  end

  private
    def insert_path(category)
      if category.categories.blank?
        return
      end
      category.categories.each { |e|
        e.path = e.category.path + "#{e.id}."
        e.save!(:validate => false)
        insert_path(e)
      }
    end
end
