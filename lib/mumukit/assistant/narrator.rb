class Mumukit::Assistant::Narrator
  def initialize(seed)
    @seed = seed
  end

  def retry_phrase
    t :retry
  end

  def explanation_introduction_phrase
    t :introduction
  end

  def compose_explanation(tips)
    "#{explanation_introduction_phrase}\n\n#{explanation_paragraphs(tips).join("\n\n")}\n\n#{retry_phrase}\n"
  end

  def explanation_paragraphs(tips)
    tips.take(3).zip([:opening, :middle, :ending]).map do |tip, selector|
      send "explanation_#{selector}_paragraph", tip
    end
  end

  def explanation_opening_paragraph(tip)
    "#{tip.capitalize}."
  end

  def explanation_middle_paragraph(tip)
    t :middle, tip: tip
  end

  def explanation_ending_paragraph(tip)
    t :ending, tip: tip
  end

  def self.sample
    new seed(*5.times.map { sample_index })
  end

  def self.seed(r, i, o, m, e)
    { retry: r, introduction: i, opening: o, middle: m, ending: e }
  end

  private

  def t(key, args={})
    I18n.t "narrator.#{key}_#{@seed[key]}", args
  end

  def self.sample_index
    (0..2).to_a.sample
  end
end
