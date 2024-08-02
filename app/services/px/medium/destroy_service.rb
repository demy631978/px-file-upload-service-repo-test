# frozen_string_literal: true

class Px::Medium::DestroyService < BaseService
  uuid :user_id
  array :medium_ids do
    uuid
  end

  set_callback :validate, :after, -> { validate_medium_ids }

  def execute
    Medium.where(id: medium_ids, user_id: user_id).each do |medium|
      MediumAttachment.delete(medium.id)
      medium.destroy
    end
  end

  private

  def validate_medium_ids
    medium_ids.each { |id| errors.add(:"#{id}", "can\'t find medium") unless Medium.exists?(id: id, user_id: user_id) }
  end
end