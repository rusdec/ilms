module HasDifficulty
  extend ActiveSupport::Concern

  included do
    def difficulty_selector(form)
      form.select :difficulty, (1..5).to_a,
                  class: 'form-control small', autocompleate: 'Difficulty'
    end
  end
end
