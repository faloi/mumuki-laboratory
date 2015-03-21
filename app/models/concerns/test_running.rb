module TestRunning
  def schedule_test_run!
    TestRunnerJob.run_async(id)
  end

  def run_tests!
    run_update! do
      language.run_tests!(exercise.test, exercise.extra_code, content)
    end
  end
end
