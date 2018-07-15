class QuestForm
  include ActiveModel::Serialization

  delegate :id, :title, :level, :description,
           :lesson_id, :quest_group_id, to: :quest

  delegate :created_at, :updated_at, :quest_group,
           :persisted?, :errors, :lesson, to: :quest

  attr_accessor :quest

  def initialize(object = nil)
    raise 'QuestForm parameter object is nil' if object.nil?
    self.quest = object
  end

  def create(params = nil)
    assign(params) if params
    if quest.valid?
      save
      true
    else
      false
    end
  end

  def update(params = nil)
    old_quest_group = quest.quest_group
    assign(params) if params
    if quest.valid?
      save
      old_quest_group.destroy_if_empty
      true
    else
      false
    end
  end

  def destroy
    quest.destroy
    quest.quest_group.destroy_if_empty
  end

  def quest_groups
    quests = {}
    lesson.quests.each do |quest|
      quests[quest.quest_group_id] ||= []
      quests[quest.quest_group_id] << quest
    end
    quests = quests.collect do |group_id, quests|
      is_current_quest_group = false
      if quests.include?(quest)
        quests = quests.reject { |q| q == quest }
        is_current_quest_group = true
      end

      OpenStruct.new(
        id: group_id,
        quests: quests,
        current_quest_group: is_current_quest_group
      )
    end

    # add empty "group" for form
    if quest.has_alternatives? || quest.new_record?
      quests << OpenStruct.new(id: nil, quests: [])
    end

    quests
  end

  private

  def save
    self.quest.quest_group ||= lesson.quest_groups.create
    quest.save
    quest.reload
  end

  def assign(params)
    params.permit!
    self.quest.assign_attributes(params[:quest])
  end
end
