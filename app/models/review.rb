class Review < ApplicationRecord
  has_many :reactions, dependent: :destroy
  belongs_to :tour
  has_many :comments, dependent: :destroy
  has_many :comments, as: :commentable, dependent: :destroy
  has_many :imagerelations, as: :imagetable, dependent: :destroy
  delegate :name, to: :tour, prefix: :tour
  belongs_to :user
  scope :sort_by_created_at, ->{order created_at: :desc}
  scope :includes_user_and_tour, ->{includes :user, :tour}
  validates :content, length: {maximum: Settings.review.length},
    presence: true
end
