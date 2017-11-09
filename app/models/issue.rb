class Issue < ApplicationRecord
  include RankedModel

  ranks :priority_order, with_same: :project_id

  belongs_to :project
  belongs_to :author, class_name: 'User', foreign_key: :user_id
  has_one :bookmarked, dependent: :destroy, class_name: 'BookmarkedIssue'

  class << self

    def for_project(project_id)
      where(project_id: project_id)
        .order(:priority_order, :created_at)
    end
  end

  def change_priority_to(new_position)
    update(priority_order_position: new_position)
  end

  def bookmark
    create_bookmarked!
  end

  def bookmarked?
    bookmarked.present?
  end

  def unbookmark
    bookmarked.destroy!
  end
end
