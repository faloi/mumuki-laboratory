class Exercise < ActiveRecord::Base
  LANGUAGES = [:haskell, :prolog]

  enum language: LANGUAGES
  belongs_to :author, class_name: 'User'

  has_many :submissions

  validates_presence_of :title, :description, :language, :test,
                        :submissions_count, :author
  after_initialize :defaults, if: :new_record?

  def plugin
    Kernel.const_get("#{language.to_s.titleize}Plugin".to_sym).new
  end

  def authored_by?(user)
    #FIXME remove nil check
    author != nil && user == author
  end

  def description_html
    markdown = Redcarpet::Markdown.new(Redcarpet::Render::HTML, autolink: true)
    markdown.render(description).html_safe
  end

  private

  def defaults
    self.submissions_count = 0
  end
end
