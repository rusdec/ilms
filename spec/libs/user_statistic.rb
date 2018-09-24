require_relative 'libs_helper'

RSpec.describe UserStatistic do
  let(:user) { create(:user) }
  let!(:statistic) { UserStatistic.new(user) }

  it '.knowledges_directions' do
    user_knowledges = create_list(:user_knowledge, 2, user: user)
    user_knowledge = create(:user_knowledge,
      user: user,
      knowledge: create(:knowledge, direction: user_knowledges[0].knowledge.direction)
    )

    expect(statistic.knowledges_directions).to eq([
      { direction: KnowledgeDirection.first.name,
        sum_of_levels: user_knowledges[0].level + user_knowledge.level,
        user_knowledges: [
          { level: user_knowledges[0].level, knowledge: user_knowledges[0].knowledge },
          { level: user_knowledge.level, knowledge: user_knowledge.knowledge },
        ]
      },
      { direction: KnowledgeDirection.last.name,
        sum_of_levels: user_knowledges[1].level,
        user_knowledges: [
          { level: user_knowledges[1].level, knowledge: user_knowledges[1].knowledge }
        ]
      }
    ])
  end

  it '.badges_progress' do
    create_list(:course, 2).collect do |course|
      badge = create(:badge, course: course, badgable: course)
      create(:course_passage, passable: course, user: user).passed!
      user.reward!(badge)
    end

    expect(statistic.badges_progress).to eq(
      badges: { collected: 2, total: 2 }
    )
  end

  it '.courses_progress' do
    create_list(:course_passage, 2, user: user, status: :passed)
    create(:course_passage, user: user, status: :in_progress)

    expect(statistic.courses_progress).to eq(courses: { passed: 2, in_progress: 1 })
  end

  it '.lessons_progress' do
    create_list(:lesson_passage, 2, user: user).each(&:passed!)
    create(:lesson_passage, user: user)

    expect(statistic.lessons_progress).to eq(
      lessons: { passed: 2, in_progress: 1, unavailable: 0 }
    )
  end

  it '.quests_progress' do
    create_list(:quest_passage, 2, user: user).each(&:passed!)
    create(:quest_passage, user: user)
    puts QuestPassage.all.pluck(:status).inspect

    expect(statistic.quests_progress).to eq(
      quests: { passed: 2, in_progress: 0 }
    )
  end

  it '.top_three_knowledges' do
    knowledges = create_list(:knowledge, 4)
    1.upto(3) do |x| 
      create(:user_knowledge, user: user, level: 10 * x, knowledge: knowledges[x])
    end

    expected_result = {
      knowledges: [
        { level: 30, knowledge: knowledges[3] },
        { level: 20, knowledge: knowledges[2] },
        { level: 10, knowledge: knowledges[1] }
      ]
    }

    expect(statistic.top_three_knowledges).to eq(expected_result)
  end
end
