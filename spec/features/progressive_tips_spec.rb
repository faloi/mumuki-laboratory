require 'spec_helper'

feature 'Progressive Tips', organization_workspace: :test do
  let(:user) { create(:user) }

  let(:haskell) { create(:haskell) }

  let!(:problem) { build(:problem,
                          name: 'Succ1', description: 'Description of Succ1',
                          layout: :input_right, assistance_rules: [{when: :submission_failed, then: ['try this', 'try that']}] ) }
  let(:assignment) { problem.assignment_for(user) }

  let!(:chapter) {
    create(:chapter, name: 'Functional Programming', lessons: [
      create(:lesson, name: 'getting-started', description: 'An awesome guide', language: haskell, exercises: [problem])
    ]) }

  before { reindex_current_organization! }

  context 'visit failed exercise' do
    before { set_current_user! user }
    before { assignment.update! status: :failed }

    scenario '2 failed submissions' do
      assignment.update! attempts_count: 2
      visit "/exercises/#{problem.transparent_id}"

      expect(page).to have_text('Try this')
      expect(page).to_not have_text('Try that')
    end

    scenario '5 failed submissions' do
      assignment.update! attempts_count: 5
      visit "/exercises/#{problem.id}"

      expect(page).to_not have_text('Try this')
      expect(page).to have_text('Try that')
    end

    scenario '10 failed submissions' do
      assignment.update! attempts_count: 10
      visit "/exercises/#{problem.id}"

      expect(page).to_not have_text('Try this')
      expect(page).to have_text('Try that')
    end
  end
end
