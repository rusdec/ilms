class QuestForm
  delegate(
    :id,
    :title,
    :level,
    :author,
    :errors,
    :lesson_id,
    :description,
    :quest_group_id,
    to: :quest
  )

  attr_accessor :quest

  def initialize(args = {})
    self.quest = args[:quest] || Quest.new
  end

  def create(params = nil)
    assign(params) if params
    save if quest.valid?
    quest
  end

  def update(params = nil)
    old_quest_group = quest.quest_group
    assign(params) if params
    if quest.valid?
      save
      old_quest_group.destroy_if_empty
    end
    quest
  end

  def destroy
    quest.destroy
    quest.quest_group.destroy_if_empty
    quest
  end

  private

  def save
    set_quest_group
    quest.save
  end

  def set_quest_group
    self.quest.quest_group ||= create_quest_group
  end

  def destroy_quest_group_if_empty
    quest.quest_group.destroy_if_empty
  end
  def create_quest_group
    QuestGroup.create(lesson_id: lesson_id)
  end

  def assign(params)
    params.permit!

    self.quest.author = params[:user] if params[:user]
    self.quest.lesson_id = params[:lesson_id] if params[:lesson_id]
    self.quest.assign_attributes(params[:quest])
  end
end
