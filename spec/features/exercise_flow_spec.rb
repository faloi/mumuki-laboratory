require 'spec_helper'

feature 'Exercise Flow', organization_workspace: :test do
  let(:user) { create(:user) }

  let(:haskell) { create(:haskell) }
  let(:gobstones) { create(:gobstones) }

  let!(:problem_1) { build(:problem, name: 'Succ1', description: 'Description of Succ1', layout: :input_right, hint: 'lala') }
  let!(:problem_2) { build(:problem, name: 'Succ2', description: 'Description of Succ2', layout: :input_right, editor: :hidden, language: gobstones) }
  let!(:problem_3) { build(:problem, name: 'Succ3', description: 'Description of Succ3', layout: :input_right, editor: :upload, hint: 'lele') }
  let!(:problem_4) { build(:problem, name: 'Succ4', description: 'Description of Succ4', layout: :input_bottom, extra: 'x = 2') }
  let!(:problem_5) { build(:problem, name: 'Succ5', description: 'Description of Succ5', layout: :input_right, editor: :upload, hint: 'lele', language: gobstones) }
  let!(:problem_6) { build(:problem, name: 'Succ6', description: 'Description of Succ6', layout: :input_right, editor: :hidden, language: haskell) }
  let!(:problem_7) { build(:problem, name: 'Succ7', description: 'Description of Succ7', choices: [{value: 'some choice', checked: true}]) }
  let!(:problem_8) { build(:problem, name: 'Succ For Kids', description: 'Description of Succ For Kids', layout: :input_kids, hint: 'lala') }

  let!(:playground_1) { build(:playground, name: 'Succ5', description: 'Description of Succ4', layout: :input_right) }
  let!(:playground_2) { build(:playground, name: 'Succ6', description: 'Description of Succ4', layout: :input_right, extra: 'x = 4') }
  let!(:reading) { build(:reading, name: 'Reading about Succ', description: 'Lets understand succ history') }
  let!(:exercise_not_in_path) { create :exercise }


  let!(:chapter) {
    create(:chapter, name: 'Functional Programming', lessons: [
      create(:lesson, name: 'getting-started', description: 'An awesome guide', language: haskell, exercises: [
        problem_1, problem_2, problem_3, problem_4, reading, problem_5, problem_6, problem_7, problem_8, playground_1, playground_2
      ])
    ]) }

  before { reindex_current_organization! }

  context 'inexistent exercise' do
    scenario 'visit exercise by slug, not in path' do
      visit "/exercises/#{exercise_not_in_path.slug}"
      expect(page).to have_text('You may have mistyped the address or the page may have moved')
    end

    scenario 'visit exercise by slug, unknown exercise' do
      visit '/exercises/an_exercise_slug'
      expect(page).to have_text('You may have mistyped the address or the page may have moved')
    end

    scenario 'visit exercise by id, not in path' do
      visit "/exercises/#{exercise_not_in_path.id}"
      expect(page).to have_text('You may have mistyped the address or the page may have moved')
    end

    scenario 'visit exercise by id, unknown exercise' do
      visit '/exercises/900000'
      expect(page).to have_text('You may have mistyped the address or the page may have moved')
    end
  end

  context 'not logged user' do
    scenario 'visit exercise by slug' do
      visit "/exercises/#{problem_1.slug}"

      expect(page).to have_text('Succ1')
      expect(page).to_not have_text('Console')
      expect(page).to_not have_text('Solution')
      expect(page).to have_text('need a hint?')
      expect(page).to have_text('Description of Succ1')
    end

    scenario 'visit exercise by slug, kids layout' do
      visit "/exercises/#{problem_8.slug}"

      expect(page).to have_text('Succ1')
      expect(page).to_not have_text('Console')
      expect(page).to_not have_text('Solution')
      expect(page).to have_text('need a hint?')
      expect(page).to have_text('Description of Succ1')
    end

    scenario 'visit exercise by id, upload layout' do
      visit "/exercises/#{problem_3.id}"

      expect(page).to have_text('Succ3')
      expect(page).to_not have_text('Console')
      expect(page).to_not have_text('Solution')
      expect(page).to have_text('need a hint?')
      expect(page).to_not have_selector('.upload')
    end

    scenario 'should not see the edit exercise link' do
      visit "/exercises/#{problem_2.id}"
      expect(page).not_to have_xpath("//a[@alt='Edit']")
    end
  end


  context 'logged user' do
    before { set_current_user! user }
    let(:writer) { create(:user, permissions: {student: 'private/*', writer: 'private/*'}) }

    scenario 'visit exercise by slug' do
      visit "/exercises/#{problem_1.slug}"

      expect(page).to have_text('Succ1')
      expect(page).to have_text('Console')
      expect(page).to have_text('need a hint?')
      expect(page).to have_text('Description of Succ1')
    end

    describe 'embedded mode' do
      scenario 'visit exercise by id, standalone mode' do
        visit "/exercises/#{problem_1.id}"
        expect(page).to have_text('Functional Programming 1')
        expect(page).to have_text('Profile')
      end
      scenario 'visit exercise by id, embedded mode in non embeddable organization' do
        visit "/exercises/#{problem_1.id}?embed=true"
        expect(page).to have_text('Functional Programming 1')
        expect(page).to have_text('Profile')
      end
      scenario 'visit exercise by id, embedded mode in embeddable organization' do
        Organization.current.tap { |it| it.embeddable = true }.save!

        visit "/exercises/#{problem_1.id}?embed=true"
        expect(page).to_not have_text('Functional Programming 1')
        expect(page).to_not have_text('Profile')
      end
    end


    scenario 'visit exercise by id, editor right layout' do
      visit "/exercises/#{problem_1.id}"

      expect(page).to have_text('Succ1')
      expect(page).to have_text('Console')
      expect(page).to have_text('Solution')
      expect(page).to have_text('need a hint?')
      expect(page).to_not have_selector('.upload')
    end

    scenario 'visit exercise by id, hidden layout, no hint, not queriable language' do
      visit "/exercises/#{problem_2.id}"

      expect(page).to have_text('Succ2')
      expect(page).to have_text('Continue')
      expect(page).to_not have_text('Submit')

      expect(page).to_not have_text('Console')
      expect(page).to_not have_text('Solution')
      expect(page).to_not have_text('need a hint?')
      expect(page).to_not have_selector('.upload')
    end

    scenario 'visit exercise by id, hidden layout, no hint, queriable language' do
      visit "/exercises/#{problem_6.id}"

      expect(page).to have_text('Succ6')
      expect(page).to_not have_text('Console')
      expect(page).to_not have_text('Solution')
      expect(page).to_not have_text('need a hint?')
      expect(page).to_not have_selector('.upload')
    end


    scenario 'visit exercise by id, upload layout' do
      visit "/exercises/#{problem_3.id}"

      expect(page).to have_text('Succ3')
      expect(page).to have_text('Console')
      expect(page).to have_text('Solution')
      expect(page).to have_text('need a hint?')
      expect(page).to have_selector('.upload')
    end

    scenario 'visit exercise by id, upload layout, not queriable language' do
      visit "/exercises/#{problem_5.id}"

      expect(page).to have_text('Succ5')
      expect(page).to_not have_text('Console')
      expect(page).to have_text('need a hint?')
      expect(page).to have_selector('.upload')
      expect(problem_5.language.extension).to eq('gbs')
      expect(page.find("//div[@class = 'form-group']/input")['accept']).to eq(".gbs")
    end

    scenario 'visit exercise by id, input_bottom layout, extra, no hint' do
      visit "/exercises/#{problem_4.id}"

      expect(page).to have_text('Succ4')
      expect(page).to have_text('x = 2')
      expect(page).to have_text('Console')
      expect(page).to have_text('Solution')
      expect(page).to_not have_text('need a hint?')
      expect(page).to_not have_selector('.upload')
    end

    scenario 'visit playground by id, no extra, no hint' do
      visit "/exercises/#{playground_1.id}"

      expect(page).to have_text('Succ5')
      expect(page).to_not have_text('Console')
      expect(page).to_not have_text('Solution')
      expect(page).to_not have_text('need a hint?')
      expect(page).to_not have_selector('.upload')
    end

    scenario 'visit playground by id, with extra, no hint' do
      visit "/exercises/#{playground_2.id}"

      expect(page).to have_text('Succ6')
      expect(page).to_not have_text('Console')
      expect(page).to_not have_text('Solution')
      expect(page).to_not have_text('need a hint?')
      expect(page).to have_text('x = 4')
      expect(page).to_not have_selector('.upload')
    end

    scenario 'visit inner reading by id' do
      visit "/exercises/#{reading.id}"

      expect(page).to have_text('Reading about Succ')
      expect(page).to have_text('Lets understand succ history')

      expect(page).to_not have_text('Console')
      expect(page).to_not have_text('Solution')
      expect(page).to_not have_text('need a hint?')
      expect(page).to_not have_selector('.upload')
    end

    scenario 'visit solved choices exercise' do
      problem_7.submit_solution!(user, content: '').passed!
      visit "/exercises/#{problem_7.id}"

      expect(page).to have_text 'The answer is correct!'
    end

    scenario 'visit failed choices exercise' do
      problem_7.submit_solution!(user, content: '').failed!
      visit "/exercises/#{problem_7.id}"

      expect(page).to have_text 'The answer is wrong'
    end

    scenario 'with no permissions should not see the edit exercise link' do
      visit "/exercises/#{problem_2.id}"
      expect(page).not_to have_xpath("//a[@alt='Edit']")
    end

    scenario 'writer should see the edit exercise link' do
      set_current_user! writer

      visit "/exercises/#{problem_2.id}"
      expect(page).to have_xpath("//a[@alt='Edit']")
    end
  end
end
