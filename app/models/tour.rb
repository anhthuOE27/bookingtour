class Tour < ApplicationRecord
  scope :sort_by_created_at, ->{order created_at: :desc}
  scope :find_by_category_id,
    ->(category_id){
      where "category_id = ?", "#{category_id}" if category_id.present?
    }
  scope :find_max_price,
    # ->(price1, price2){where "price BETWEEN ? AND ?", "#{price1}", "#{price2}"}
    ->(price){
      if price.present?
        where "price <= ?", "#{price}"
      else
        where "price"
      end
    }
  scope :find_min_price,
    ->(price){
      if price.present?
        where "price >= ?", "#{price}"
      else
        where "price"
      end
    }
  belongs_to :category
  has_many :booking_tours, dependent: :destroy
  has_many :reviews, dependent: :destroy
  mount_uploader :image, ThumbUploader
  has_many :comments, as: :commentable, dependent: :destroy
  has_many :imagerelations, as: :imagetable, dependent: :destroy
  validates :startdate, presence: true
  validates :finishdate, presence: true
  validates :name, presence: true
  validates :image, presence: true
  validate :check_in_out_date, on: :create

  private

  def check_in_out_date
    errors.add :base,
      "Start Day must less than End Day" if self.startdate > self.finishdate
  end
end
