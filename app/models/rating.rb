class Rating < ActiveRecord::Base
  SECONDS_IN_DAY = 60 * 60 * 24
  RATING_MAX_WEIGHT = 1000

  belongs_to :user
  belongs_to :product

  validates_numericality_of :rating, :only_integer => true
  validates_inclusion_of :rating, :in => 1..5

  after_save do |rating|
    count = 0
    sum_rating = 0.0
    rating.product.ratings.each do |r|
      count += 1

      delta_date = Time.now - r.updated_at
      weight = delta_date.to_i / SECONDS_IN_DAY
      weight = weight > RATING_MAX_WEIGHT ? 0 : (RATING_MAX_WEIGHT - weight).to_f / RATING_MAX_WEIGHT

      sum_rating += r.rating * weight
    end

    total_rating = sum_rating / count

    product = rating.product
    product.rating = total_rating
    product.save!
  end

end
